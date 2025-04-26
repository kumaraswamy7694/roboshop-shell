#!/bin/bash
DATE=$(date +%F)
LOGSDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"  # Red
G="\e[32m"  # Green
N="\e[0m"   # Reset
Y="\e[33m"  # Yellow

if [$USERID -ne 0];
then 
    echo -e "$R errror :: please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0];
    then 
        echo -e "$2 ...$R FAILURE $N"
        exit 1
    else 
        echo -e " $2 .. $G success $N"
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE  
VALIDATE $? "coppied mongo.repo into yum .repos.d"
yum install mongodb-org -y &>> $LOGFILE
VALIDATE $? "installing mongodb"
systemctl enable mongod &>> $LOGFILE
VALIDATE $? "enabling mongodb"
systemctl start mongod &>> $LOGFILE
VALIDATE $? "starting mongodb"
sed -i  's/127.0.0.1/0.0.0.0/' etc/mongod.conf &>> $LOGFILE
VALIDATE $? "changing bind ip address"
systemctl restart mongod 
VALIDATE $? "restarting mongodb"

