

WGET_TIMEOUT=10

FILECHECK="opcap_sdk.sh.tar.bz2"
DIRECTORY="sdk"

SDKBIN="opcap_sdk.sh"
ROOT_DIRECTORY=`pwd`
BASEROOT_SDK=${ROOT_DIRECTORY}


function  internet_error()
{
    exit 1;
}


ARCHIVEFILE=${FILECHECK}
MD5FILE="${ARCHIVEFILE}.md5"
MD5FILELOCAL="${DIRECTORY}/${MD5FILE}.local"
VERSIONFILE="${FILECHECK}.ver"
VERSIONFILELOCAL="${DIRECTORY}/${VERSIONFILE}.local"
#FTPSERVER="ftp://engicam.smartfile.com/"
FTPSERVER="ftp://localhost/ftp-tmp/"


wget --timeout=${WGET_TIMEOUT}  --ftp-user 'architech' --ftp-password 'architech' ${FTPSERVER}${MD5FILE} 
[ $? -eq 0 ] || { rm -f${MD5FILE}; internet_error; }

if diff ${MD5FILE} ${MD5FILELOCAL} >/dev/null ; then
  echo Same
  rm ${MD5FILE}  
else
  wget --timeout=${WGET_TIMEOUT}  --ftp-user 'architech' --ftp-password 'architech' ${FTPSERVER}${ARCHIVEFILE}
  [ $? -eq 0 ] || { rm -f ${ARCHIVEFILE}; internet_error; }
    
  wget --timeout=${WGET_TIMEOUT}  --ftp-user 'architech' --ftp-password 'architech' ${FTPSERVER}${VERSIONFILE}
  [ $? -eq 0 ] || { rm -f ${VERSIONFILE}; internet_error; }
    
  if [ -d "${DIRECTORY}" ]; then
     POSTFIX=$(cat ${VERSIONFILELOCAL})
     NEWDIR="${DIRECTORY}.$POSTFIX"
     mv ${DIRECTORY} ${NEWDIR}
  fi

  tar -xvf ${ARCHIVEFILE} 
  ./${SDKBIN} -y -d ${DIRECTORY}
  rm -rf ${ARCHIVEFILE}
  rm -rf ${SDKBIN}

  rm -rf ${MD5FILELOCAL}  
  mv ${MD5FILE} ${MD5FILELOCAL}

  rm -rf ${VERSIONFILELOCAL}  
  mv ${VERSIONFILE} ${VERSIONFILELOCAL}

fi


