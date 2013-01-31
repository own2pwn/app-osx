#integration-osx
----------------------------------------
Desktop application &amp; system wide contextual menu integration for PrYv.

**Current version :** iteration 2

##Overview
Use the status menu to access the general features. From here, you can create a note, display information about your account (in the console) and access the [PrYv website](http://www.pryv.net). It currently only works offline. The online connection to an account will be implemented really soon.

##Details
The first time you'll launch the application, just enter a random username and token. It has no influence for the moment. Once connected, you can create some personal notes and display the information about the account. A note is composed by :

- Title : *optional*
- Content : *required*
- Folder : *optional*
- Tags : *optional*

Display in the console the current stored notes along with other information using the *Display current user* in the general menu. 

This Mac OS X integration for PrYv uses *CoreData* to implement persistence to data. The informations about the account are conserved from one run to another :

- Username
- Authorization Token
- Personal Notes

We will use this for the application's offline mode.

##Troubleshooter and reset

You are reading this section if you want to :

- Troubleshoot **The managed object model version used to open the persistent store is incompatible with the one that was used to create the persistent store**
- Troubleshoot **Failed to initialize the store**
- Change the user
- Delete all the notes

CoreData is a great, powerful feature but it has some constraints when you have to change the data model. The solution is to *activate model versioning* or to d*elete the data folder*. The first one has to be used when the *application is released* and that users are actually using it. The second one has to be used during the *development phase*. So, these are the steps you have to follow if you want to troubleshoot the CoreData errors or reset the application :

- Quit the PrYv application
- Go to ~/Library/Containers/
- Delete the pryv.PrYv folder
- Run again the application

##Information
You can explore data with the [GitHub explorer](http://pryv.github.com/explorer/).

The developer API reference is accessible at <http://dev.pryv.com>.

API issues should be reported to <https://github.com/pryv/pryv.github.com/issues>.