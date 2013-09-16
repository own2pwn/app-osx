# Pryv integration for Mac OSX

Desktop application &amp; system wide contextual menu integration for Pryv.

**Current version :** iteration 9

##Build and run the application

- Be sure that the PryvAPIKit submodule is on the `origin/streams` branch.
- If not, after making the change, clean the project (⇧-⌘-K) and relaunch Xcode.
- In Xcode, the scheme should be set on `Pryv > My Mac 64-bit` or `osx-integration > My Mac 64-bit`.
- Build/Run the application in Xcode.


##Troubleshooter and reset

You are reading this section if you want to :

- Troubleshoot **The managed object model version used to open the persistent store is incompatible with the one that was used to create the persistent store**
- Troubleshoot **Failed to initialize the store**
- Check what files are cached
- Remove the *pryv file(s)* or *pryv selected text* service

###CoreData errors
CoreData is a great, powerful feature but it has some constraints when you have to change the data model. The solution is to *activate model versioning* or to *delete the data folder*. The first one has to be used in *deployment phase*  and the second one in *development phase*. 

If you want to troubleshoot the CoreData errors delete the **~/Library/Containers/pryv.PrYv** folder or simply run the `./update_coredata.sh` script.

###Access cached files

You can find all the cached files (streams, events and attachments) in the **~/Library/Containers/com.pryv.Pryv/Data/Library/Caches/PYCachingController** folder.

###Manage the Services
If you want to disable the Services, just uncheck the corresponding box in 

*System Preferences > Keyboard > Keyboard shortcuts > Services*

To remove it completely, right-click on the service name and chose *Reveal in Finder*. Then delete the corresponding folder.

**Note if you have compiled the project before iteration 8 :** you might need to manually remove - as explained before - the services (you should not have more than one service with the same name in the list).

##Information
You can explore data with the [GitHub explorer](http://pryv.github.io/explorer/).

The developer API reference is accessible at <http://api.pryv.com>.

API issues should be reported to <https://github.com/pryv/pryv.github.io/issues>.


## License

[Revised BSD license](https://github.com/pryv/documents/blob/master/license-bsd-revised.md)
