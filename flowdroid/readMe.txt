To start testing  "app-release.apk”” 
open terminal and go to the folder “nightly builds” then run
java -Xmx4g -cp soot-trunk.jar:soot-infoflow.jar:soot-infoflow-android.jar:slf4j-api-1.7.5.jar:slf4j-simple-1.7.5.jar:axml-2.0.jar soot.jimple.infoflow.android.TestApps.Test "app-release.apk" /Users/hussienalrubaye/Library/Android/sdk/platforms

Note
you have to install Android SDK
http://developer.android.com/sdk/installing/index.html
