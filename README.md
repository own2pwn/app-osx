#integration-osx
----------------------------------------
Desktop application &amp; system wide contextual menu integration for PrYv.

**Current version :** iteration 5

##Overview
Use the status menu to access the general features. From here, you can create a note, pryv some files, display information about your account (in the console), delete all the events and access the [PrYv website](http://www.pryv.net). Now, you can also pryv file(s) from the Finder with a right click on the selection or with the keyboard shortcut CMD-SHIFT-M (arbitrary choice to avoid conflicts with other shortcuts) It currently only works offline. The online connection to an account will be implemented really soon.

##Details
The first time you'll launch the application, just enter a random username and token. It has no influence for the moment. Once connected, you can create some personal notes and pryv any files and folder. They follow the *event* structure of the PrYv API, storing a timestamp, tags, folder, etc...

###File
When pryving a file, you can choose multiple files and folders. The hierarchical structure of all the subfiles is stored in the name of those ones in the form : 

*sub/folder/path/to/filename.ext*

###User status
*Purge events* delete all the files from the Caches folder and release the event objects.

This Mac OS X integration for PrYv uses *CoreData* to implement persistence to data. The following informations about the account are conserved from one run to another :

- Username
- Authorization Token
- Set of events

We will use this for the application's offline mode.

##Troubleshooter and reset

You are reading this section if you want to :

- Troubleshoot **The managed object model version used to open the persistent store is incompatible with the one that was used to create the persistent store**
- Troubleshoot **Failed to initialize the store**
- Change the user
- Check what files are cached
- Remove the pryv file(s) service

CoreData is a great, powerful feature but it has some constraints when you have to change the data model. The solution is to *activate model versioning* or to *delete the data folder*. The first one has to be used when the *application is released* and that users are actually using it. The second one has to be used during the *development phase*. If you want to troubleshoot the CoreData errors or connect another user, just delete the **~/Library/Containers/pryv.PrYv** folder.

You can find all the cached files in the **~/Library/Containers/pryv.PrYv/Data/Library/Caches** folder, which is the folder you can use to write in when using application sandboxing.

If you want to disable the service, just uncheck the corresponding box in 

*System Preferences > Keyboard > Keyboard shortcuts > Services > Files and folders > Pryv file(s)*

To remove it completely, right-click on the service name and chose *Reveal in Finder* and delete the corresponding folder.

##Information
You can explore data with the [GitHub explorer](http://pryv.github.com/explorer/).

The developer API reference is accessible at <http://dev.pryv.com>.

API issues should be reported to <https://github.com/pryv/pryv.github.com/issues>.


## License

(Revised BSD license.)

Copyright (c) 2013, PrYv S.A. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of PrYv nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL PRYV BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
