# Search extension for Safari
Safari Extension that allows the user to use Kagi.com search engine, and Brave search in private. 
Implemented purely using native APIs in Swift.
Forked from [Kagi Search](https://github.com/marcocebrian/kagisearchsafari)

# Info and limits - Please read
* To detect private mode, need to request Level = all, this means Safari will warn you about possible tracking
* If you don't need to differentiate private mode search engine, set Level = Some in the info.plist 
* On an empty tab (new tab), private mode detection doesn't work, so it will still search in Kagi. Detection only works on an open website.


# LICENSE
You can distribute, remix, tweak, and build upon this work,
even commercially, as long as credit is given for the original creation.
Attribution 4.0 International (CC BY 4.0)
(https://creativecommons.org/licenses/by/4.0/)

## How to Use
Clone or download, open with Xcode, run. 

