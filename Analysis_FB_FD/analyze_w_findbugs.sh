#!/bin/bash

process_file(){
   # categories
   security=0
   dodgyCode=0
   badPractice=0
   correctness=0
   performance=0
   experimental=0
   internationalization=0
   multiThreadedCorrectness=0
   maliciousCodeVulnerability=0

   counter=0

   while read line
   do
      temp=${line%,*}
      temp=${temp##*:}
      category=${line##*,}
      counter=`grep -c "$temp" "warnings.txt"`
      
      if echo "$category" | grep -q "Bad practice"; 
      then
         ((badPractice=badPractice+counter))
      elif echo "$category" | grep -q "Correctness"; 
      then
         ((correctness=correctness+counter))
      elif echo "$category" | grep -q "Performance";
      then
         ((performance=performance+counter))
      elif echo "$category" | grep -q "Experimental";
      then
         ((experimental=experimental+counter))
      elif echo "$category" | grep -q "Malicious code vulnerability";   
      then
         ((maliciousCodeVulnerability=maliciousCodeVulnerability+counter))
      elif echo "$category" | grep -q "Multithreaded correctness";
      then
         ((multiThreadedCorrectness=multiThreadedCorrectness+counter))
      elif echo "$category" | grep -q "Security"; 
      then
         ((security=security+counter))
      elif echo $category | grep -q "Dodgy code"; 
      then
         ((dodgyCode=dodgyCode+counter))
      fi

      counter=0
   done < "findbugs_warnings.csv"

   sqlite3 darwin-userratings.sqlite "INSERT INTO APPWARNINGSFINDBUGS(apk_id, bad_practice, correctness, experimental, performance, multithreaded_correctness, malicious_code_vulnerability, security, dodgy_code) VALUES ('$1', $badPractice, $correctness, $experimental, $performance, $multiThreadedCorrectness, $maliciousCodeVulnerability, $security, $dodgyCode);"
}

process_file $1