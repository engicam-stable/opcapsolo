
# Yocto installation

YOCTO_DIRECTORY="yocto"

WGET_TIMEOUT=10

FILECHECK="qtcreator.tar.bz2"
DIRECTORY="qtcreator"

ROOT_DIRECTORY=`pwd`
BASEROOT_SDK=${ROOT_DIRECTORY}


function  internet_error()
{
    exit 1;
}

function  eula_LGPL2()
{
    zenity --text-info \
           --title="License" \
           --filename=splashscreen/LGPL2.1.txt \
           --checkbox="I read and accept the terms."

    case $? in
        0)
            echo "Start installation!"
            return 0
	    ;;
        1)
            echo "Stop installation!"
            return 1
	    ;;
        -1)
            echo "An unexpected error has occurred."
            return -1
	    ;;
    esac 
}

function  eula_LGPL3()
{
    zenity --text-info \
           --title="License" \
           --filename=splashscreen/LGPL3.txt\
           --checkbox="I read and accept the terms."

    case $? in
        0)
            echo "Start installation!"
            return 0
	    ;;
        1)
            echo "Stop installation!"
            return 1
	    ;;
        -1)
            echo "An unexpected error has occurred."
            return -1
	    ;;
    esac 
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

  eula_LGPL2
  if [ $? -ne 0 ] ;then
       echo "esco"
       exit 1
  fi

  eula_LGPL3
  if [ $? -ne 0 ] ;then
       echo "esco"
       exit 1
  fi

  tar -xvf ${ARCHIVEFILE} 
  rm -rf ${ARCHIVEFILE}

  rm -rf ${MD5FILELOCAL}  
  mv ${MD5FILE} ${MD5FILELOCAL}

  rm -rf ${VERSIONFILELOCAL}  
  mv ${VERSIONFILE} ${VERSIONFILELOCAL}

  cd  ${DIRECTORY}
  ./install_settings.sh
  cd ..
fi

exit 0


