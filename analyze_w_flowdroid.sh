#!/bin/bash

process_file(){
	the_file="flowdroid_results/$1.txt"

	counter1=`grep -c "Found a flow to sink" $the_file`
	counter2=`grep -c "Analysis has run for" $the_file`

	if [ $counter2 -eq 0 ]; then
		counter2=-1
	fi 

	sqlite3 darwin-userratings.sqlite "INSERT INTO APPFLOWSFLOWDROID(apk_id, completed, flows) VALUES ('$1', $counter2, $counter1);"

	rm $the_file
}

create_file(){
	cd $1/

	java -Xmx4g -cp soot-trunk.jar:soot-infoflow.jar:soot-infoflow-android.jar:slf4j-api-1.7.5.jar:slf4j-simple-1.7.5.jar:axml-2.0.jar soot.jimple.infoflow.android.TestApps.Test ../$3 "android-platforms/" &> "../flowdroid_results/$2.txt"

	cd ../

	process_file $2
}

create_file $1 $2 $3