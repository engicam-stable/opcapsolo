
WGET_TIMEOUT=10

FILECHECK="doc.tar.bz2"
DIRECTORY="doc"

ROOT_DIRECTORY=`pwd`
BASEROOT_SDK=${ROOT_DIRECTORY}


function testMD5
{
    file1=`md5sum $1`
    file2=`cut -d ' ' -f1 $1.md5`

    echo "Checking file: $1"
    echo "Using MD5 file: $1.md5"

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

function  internet_error()
{
    rm -f ${VERSIONFILE}
    rm -f ${MD5FILE}
    rm -f ${ARCHIVEFILE}
    exit 1;
}

ARCHIVEFILE=${FILECHECK}
MD5FILE="${ARCHIVEFILE}.md5"
MD5FILELOCAL="${DIRECTORY}/${MD5FILE}.local"
VERSIONFILE="${FILECHECK}.ver"
VERSIONFILELOCAL="${DIRECTORY}/${VERSIONFILE}.local"
FTPSERVER="ftp://engicam.smartfile.com/"
#FTPSERVER="ftp://localhost/ftp-tmp/"


wget --timeout=${WGET_TIMEOUT}  --ftp-user 'architech' --ftp-password 'architech' ${FTPSERVER}${MD5FILE} 
if [ $? -ne 0 ]
then
     internet_error
fi

if diff ${MD5FILE} ${MD5FILELOCAL} >/dev/null ; then
  echo Same
  rm ${MD5FILE}  
else
  wget --timeout=${WGET_TIMEOUT}  --ftp-user 'architech' --ftp-password 'architech' ${FTPSERVER}${ARCHIVEFILE}
  if [ $? -ne 0 ]
  then
    internet_error
  fi

  
  testMD5 ${ARCHIVEFILE}
  if [ $? -eq 0 ];  then
     echo "checksum ok"
  else
     rm -rf ${ARCHIVEFILE}
     rm -rf ${MD5FILE}
     exit 1
  fi


  wget --timeout=${WGET_TIMEOUT}  --ftp-user 'architech' --ftp-password 'architech' ${FTPSERVER}${VERSIONFILE}
  if [ $? -ne 0 ]
  then
    internet_error
  fi
    

  if [ -d "${DIRECTORY}" ]; then
     POSTFIX=$(cat ${VERSIONFILELOCAL})
     NEWDIR="${DIRECTORY}.$POSTFIX"
     mv ${DIRECTORY} ${NEWDIR}
  fi

  tar -xvf ${ARCHIVEFILE} 
  rm -rf ${ARCHIVEFILE}

  rm -rf ${MD5FILELOCAL}  
  mv ${MD5FILE} ${MD5FILELOCAL}

  rm -rf ${VERSIONFILELOCAL}  
  mv ${VERSIONFILE} ${VERSIONFILELOCAL}

fi

exit 0

cd ${ROOT_DIRECTORY}

