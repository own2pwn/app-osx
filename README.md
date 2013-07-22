#integration-osx
----------------------------------------
Desktop application &amp; system wide contextual menu integration for PrYv.

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

(Revised BSD license.)

Copyright (c) 2013, PrYv S.A. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of PrYv nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL PRYV BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
