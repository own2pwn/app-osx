# Pryv integration for Mac OSX

Desktop application &amp; system wide contextual menu integration for Pryv.

**Current version :** iteration 7

##Troubleshooter and reset

You are reading this section if you want to :

- Troubleshoot **The managed object model version used to open the persistent store is incompatible with the one that was used to create the persistent store**
- Troubleshoot **Failed to initialize the store**
- Change the user
- Check what files are cached
- Remove the *pryv file(s)* or *pryv selected text* service

###CoreData errors
CoreData is a great, powerful feature but it has some constraints when you have to change the data model. The solution is to *activate model versioning* or to *delete the data folder*. The first one has to be used in *deployment phase*  and the second one in *development phase*. 

If you want to troubleshoot the CoreData errors delete the **~/Library/Containers/pryv.PrYv** folder.

###Change user

Delete the **~/Library/Containers/pryv.PrYv** folder.

###Access cached files

You can find all the cached files in the **~/Library/Containers/pryv.PrYv/Data/Library/Caches** folder.

###Manage the Services
If you want to disable the Services, just uncheck the corresponding box in 

*System Preferences > Keyboard > Keyboard shortcuts > Services*

To remove it completely, right-click on the service name and chose *Reveal in Finder*. Then delete the corresponding folder.

##Information
You can explore data with the [GitHub explorer](http://pryv.github.io/explorer/).

The developer API reference is accessible at <http://api.pryv.com>.

API issues should be reported to <https://github.com/pryv/pryv.github.io/issues>.


## License

[Revised BSD license](https://github.com/pryv/documents/blob/master/license-bsd-revised.md)
