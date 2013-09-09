#!/bin/sh
 
echo "Updating CoreData model for Pryv.app..."
newBundle=$HOME/Library/Containers/com.pryv.Pryv
oldBundle=$HOME/Library/Containers/pryv.PrYv
if [ -d "$newBundle" ]; then
    rm -R $newBundle
    echo "CoreData model updated."
elif [ -d "oldBundle" ]; then
    rm -R $oldBundle
    echo "CoreData model updated."
else
    echo "CoreData model already up-to-date."
fi
