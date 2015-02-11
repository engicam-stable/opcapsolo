#!/bin/bash

function testMD5
{
    file1=`md5sum $1`
    file2=`cut -d ' ' -f1 $1.md5`

    echo "Checking file: $1"
    echo "Using MD5 file: $1.md5"
    echo "file 1"
    echo $file1  
    echo "file 2"
    echo $file2

    file1_1=${file1% *}
  

    if [ $file1_1 != $file2 ]
    then
      echo "md5 sums mismatch"
      return 1
    else
      echo "checksums OK"
      return 0
    fi
}


testMD5 $1

