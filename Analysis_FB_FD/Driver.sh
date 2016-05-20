#!/bin/bash

# folders to work with
apk_copies_folder="apk_copies"
flow_droid_folder="flowdroid"
jar_files_folder="jar_files"

create_directory(){  
    if [ -d $1 ]; then
        rm -rf $1 # if the directory exists, delete it
    fi

    mkdir $1 # create the directory
}

copy_apk_files(){
    android_apks=($(find apk_files/ -name "*.apk"))

    for apk_file in "${android_apks[@]}"; do
    	# cp -uf $apk_file $apk_copies_folder
        cp -f $apk_file $apk_copies_folder
    done
}

process_apks(){
    counter=1
    android_apks=($(find $apk_copies_folder/ -name "*.apk"))
    
    touch "log.txt"

    for apk_file in "${android_apks[@]}"; do
        processed_apk_file=${apk_file##*/}
        processed_apk_file=${processed_apk_file//.apk}

        bash dex2jar-2.0/d2j-dex2jar.sh -f $apk_file

        # modify the path name
        mod_apk_name="${apk_file/.apk/-dex2jar.jar}"
        mod_apk_name="${mod_apk_name/apk_copies/.}"

        # process with findbugs
        echo "$counter - findbugs: $apk_file" >> "log.txt"
        findbugs-3.0.1/bin/findbugs $mod_apk_name > "warnings.txt"

        # clean up .jar file
        rm $mod_apk_name

        # process results
        bash analyze_w_findbugs.sh $processed_apk_file

        echo "$counter - flowdroid: $apk_file" >> "log.txt"

        # process using flowdroid
        bash analyze_w_flowdroid.sh $flow_droid_folder $processed_apk_file $apk_file

        counter=$((counter+1))
    done
}

clean_up(){
    # clean up all the copies of .apks
    cd $apk_copies_folder/
    rm -r *
    cd ../
}


# SCRIPT ORDER OF EXECUTION
create_directory $apk_copies_folder
copy_apk_files
process_apks
clean_up