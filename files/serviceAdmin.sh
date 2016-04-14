#! /bin/bash

usage="$(basename "$0") [-h] [-s] --test help

where:
    -h show this help text.
    -s service name[\"hdfs yarn hbase zookeeper\"].
    -a action[start|stop|restart]"

servicehosts=""
servicenames=""
action=""
command=""

function gethosts(){
    servicehosts=""
    while read line
    do
	servicehosts=$servicehosts$line" "
    done < $1
}

function chkservice(){
    echo "check $1 service"
    ssh -t $1 chkconfig | grep $2 | awk '{print $1}'
    return $?
}

function forhdfs(){
    gethosts hosts.txt
    for host in $servicehosts; do
	chkservice $host hadoop-hdfs
	if [ $? ]; then
	    for x in `ssh -t $host chkconfig | grep hadoop-hdfs | awk '{print $1}'`; do
	        ssh -t $host service $x $action
	    done
	else
	    echo -e $host" has not hadoop-hdfs service"
	fi
    done
}

function foryarn(){
    gethosts hosts.txt
    for host in $servicehosts; do
        chkservice $host hadoop-yarn
        if [ $? ]; then
            for x in `ssh -t $host chkconfig | grep hadoop-yarn | awk '{print $1}'`; do
                ssh -t $host service $x $action
            done
        else
            echo -e $host" has not hadoop-yarn service"
        fi	
    done
    gethosts hosts.txt
    for host in $servicehosts; do
        chkservice $host hadoop-mapreduce-historyserver
        if [ $? ]; then
            ssh -t $host service hadoop-mapreduce-historyserver $action
        else
            echo -e $host" has not hadoop-mapreduce-historyserver service"
        fi
    done
}

function forhbase(){
    gethosts hosts.txt
    for host in $servicehosts; do
        chkservice $host hbase
        if [ $? ]; then
            for x in `ssh -t $host chkconfig | grep hbase | awk '{print $1}'`; do
                ssh -t $host service $x $action
            done
        else
            echo -e $host" has not hbase service"
        fi
    done
}

function forzookeeper(){
    gethosts hosts.txt
    for host in $servicehosts; do
	chkservice $host zookeeper-server
	if [ $? ]; then
            ssh -t $host service zookeeper-server $action
        else
            echo -e $host" has not zookeeper-server service"
        fi
    done
}

#check permission
if [ $(whoami) != 'root' ]; then
    echo -e "Error: $(basename "$0") must be run as the 'root' user." 
    exit 1
fi


#get property
local TMP_OPTIND=$OPTIND
OPTIND=1
while getopts 'hs:a:' OPTION 
do
    case "$OPTION" in
	h)
	    echo "$usage"
	    exit 0
	    ;;
	s)
	    ARG=$OPTARG
	    servicenames=$OPTARG
	    echo -e "your service names="$servicenames
	    ;;
	a)
	    ARG=$OPTARG
	    action=$OPTARG
	    echo -e "your action="$action
	    ;;
    esac
done

for service in $servicenames; do
    if [ $service == 'hdfs' ]; then
	forhdfs $action
    elif [ $service == 'yarn' ]; then
	foryarn $action
    elif [ $service == 'zookeeper' ]; then
	forzookeeper $action
    elif [ $service == 'hbase' ]; then
	forhbase $action
    else
	echo -e "not support "$service
    fi

done
