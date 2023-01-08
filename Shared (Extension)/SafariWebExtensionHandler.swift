//
//  SafariWebExtensionHandler.swift
//  Shared (Extension)
//
//  Created by Francesco Pretelli on 10/10/22.
//

import SafariServices
import os.log

let SFExtensionMessageKey = "message"

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when the script calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
          //  NSLog("The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        
    }
    
    override func page(_ page: SFSafariPage, willNavigateTo url: URL?) {
        if let userUrl = url {
            
            //this is to see if it's in private browsing.
            //it only works with level set to ALL in the plist
            page.getPropertiesWithCompletionHandler { [weak self] pageProperties in
                var isPrivateBrowsing = false
                if let properties = pageProperties {
                    isPrivateBrowsing = properties.usesPrivateBrowsing
                }
                
                if let newURL = self?.getNewSearchURLFor(url: userUrl, isPrivate: isPrivateBrowsing) {
                    page.getContainingTab(completionHandler: {(tab) in
                        tab.navigate(to: newURL)
                    })
                }
            }
        }
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
        validationHandler(true, "")
    }
    
    func getNewSearchURLFor(url:URL, isPrivate: Bool)->URL? {
        let sources:[SearchSource] = [SearchSource(host: "www.google.", uniqueText: "ie=", queryParameter: "q"),
                                      SearchSource(host: "www.bing.", uniqueText: "PC=", queryParameter: "q"),
                                      SearchSource(host: "search.yahoo.", uniqueText: "fr=aaplw", queryParameter: "p"),
                                      SearchSource(host: "duckduckgo.", uniqueText: "t=osx", queryParameter: "q"),
                                      SearchSource(host: "www.ecosia.", uniqueText: "tts=st", queryParameter: "q")]
        
        let customSearchEngineQueryLink = "https://kagi.com/search?q="
        let customSearchEngineQueryLinkPrivate = "https://search.brave.com/search?q="
        
        guard let host = url.host,
              let source = sources.first(where: {(source) in host.contains(source.host)}),
              let query = url.query else {return nil}
        
        let uniqueText = source.uniqueText
        let baseQueryUrl = isPrivate ? customSearchEngineQueryLinkPrivate : customSearchEngineQueryLink
        if query.contains(uniqueText){
            let textQuery = url.valueOf(source.queryParameter) ?? ""
            return URL(string: baseQueryUrl+textQuery)
        }
        return nil
        
    }
}

struct SearchSource
{
    var host:String
    var uniqueText:String
    var queryParameter:String
}

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
