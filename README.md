# Pryv integration for Mac OSX

Desktop application &amp; system wide contextual menu integration for Pryv.

**Current version :** iteration 9


## Setting up the development environment

### Requirements

Xcode 4.6.3 or later on Mac OS X 10.7.4 or later.

### Project setup

1. Open `src/osx-integration.xcodeproj` in Xcode
2. If you get a warning asking to **update Base SDK configuration to Latest Mac OS X** for **project integration-osx** and/or **target integration-osx**, please *uncheck* the tickboxes and click **Done**. It will just set up the Base SDK to be for Mac OS X 10.6, which is one of our requirement for the application.
3. Retrieve the PryvAPIKit submodule by running the following from the repo root:

	```
git submodule init
git submodule update
``` 
4. Then retrieve the `streams` branch in the submodule:

	```
cd src/sdk-objectivec-apple
git checkout streams
git pull origin streams
```	
5. Finally, check that in the project summary, the `osx-integration` target has no missing (written in red) framework in the *Linked Frameworks and Libraries* section. If yes, just remove it and add it again.

### Building and running the application

1. Make sure that the PryvAPIKit submodule is on the `streams` branch.
2. If not, after making the change (see **Project setup**), clean the project (⇧-⌘-K) and relaunch Xcode.
3. In Xcode, the scheme should be set on `osx-integration > My Mac 64-bit`.
4. Build/Run the application in Xcode.


## Troubleshooter and reset

You are reading this section if you want to :

- Troubleshoot **The managed object model version used to open the persistent store is incompatible with the one that was used to create the persistent store.**
- Troubleshoot **Failed to initialize the store.** 
- Check what files are cached
- Remove the *pryv file(s)* or *pryv selected text* service

### CoreData errors

CoreData is a great, powerful feature but it has some constraints when you have to change the data model. The solution is to *activate model versioning* or to *delete the data folder*. The first one has to be used in *deployment phase*  and the second one in *development phase*. 

If you want to troubleshoot the CoreData errors delete the **~/Library/Containers/pryv.PrYv** folder or simply run the `./update_coredata.sh` script.

### Access cached files

You can find all the cached files (streams, events and attachments) in the **~/Library/Containers/com.pryv.Pryv/Data/Library/Caches/PYCachingController** folder.

### Manage the Services

If you want to disable the Services, just uncheck the corresponding box in 

*System Preferences > Keyboard > Keyboard shortcuts > Services*

To remove it completely, right-click on the service name and chose *Reveal in Finder*. Then delete the corresponding folder.

**NOTE :** if you have *compiled the project before iteration 8*, you might need to manually remove - as explained before - the services (you should not have more than one service with the same name in the list).


## Information

You can explore data with the [GitHub explorer](http://pryv.github.io/explorer/).

The developer API reference is accessible at <http://api.pryv.com>.

API issues should be reported to <https://github.com/pryv/pryv.github.io/issues>.


## License

[Revised BSD license](https://github.com/pryv/documents/blob/master/license-bsd-revised.md)
