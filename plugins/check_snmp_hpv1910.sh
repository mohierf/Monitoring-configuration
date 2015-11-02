#!/bin/sh

# 2013-02-27
# Mads N. Vestergaard <mnv@timmy.dk>

BASEOID=.1.3.6.1.4
H3COID=$BASEOID.1.25506.2

# CPU OID
curCPU=$H3COID.6.1.1.1.1.6.8
thresholdCPU=$H3COID.6.1.1.1.1.7.8

# Temperature OID
tempOID=$H3COID.6.1.1.1.1.12.8
tempWarn=$H3COID.6.1.1.1.1.13.8
tempFatal=$H3COID.6.1.1.1.1.17.8

# Config OID
cfgModifiedOID=$H3COID.4.1.1.1.0
cfgSavedOID=$H3COID.4.1.1.2.0

# Overall status OID
statusOID=$H3COID.6.1.1.1.1.19

usage()
{
	echo "Usage: $0 -H host [-U username -P password]|[-C community] -T status|config|cpu|temperature"
	echo "		If username and password is supplied, SNMPv3 is used";
	echo "		If community supplied, SNMPv1 is used";
	exit 0
}

get_integer()
{
        echo "$INT"|/bin/grep "^$2.*$1 = "|/usr/bin/head -1|/bin/sed -e 's,^.*: ,,'|/usr/bin/tr -d '"'
}

get_timeticks()
{
        echo "$TIME"|/bin/grep "^$2.*$1 = "| /bin/sed -e 's,^.*: (,,'| /bin/sed -e 's,).*,,'|/usr/bin/tr -d '"'
}

if test "$1" = -h; then
	usage
fi

while getopts "H:U:P:C:T:" o; do
	case "$o" in
	H )
		HOST="$OPTARG"
		;;
	P )
		PASSWORD="$OPTARG"
		;;
	U )
		USERNAME="$OPTARG"
		;;
	T )
		TEST="$OPTARG"
		;;
	C )
		COMMUNITY="$OPTARG"
		;;
	* )
		usage
		;;
	esac
done

if [ -n "$USERNAME" -a -n "$PASSWORD" ]; then
	SNMP="/usr/bin/snmpwalk -t 15 -r 4 -v 3 -l authNoPriv -u $USERNAME -A $PASSWORD -On $HOST"
elif [ -n "$COMMUNITY" ]; then
	SNMP="/usr/bin/snmpwalk -t 15 -r 4 -v 1 -c $COMMUNITY -On $HOST"
else
	usage
fi	


RESULT=
STATUS=0	# OK

case "$TEST" in
cpu )
	INT=`$SNMP $curCPU`
	cpu=`get_integer`
	INT=`$SNMP $thresholdCPU`
	cpuThres=`get_integer`
	cpuWarn=`expr $cpuThres \* 85 / 100`
	if test "$cpu" -ge "$cpuThres"; then
		RESULT="Maximum CPU $cpu%"
		STATUS=2
	elif test "$cpu" -ge "$cpuWarn"; then
		RESULT="CPU close to maximum $cpu%"
		STATUS=1
	else
		RESULT="CPU $cpu%"
	fi
	;;
config )
	modified=`$SNMP $cfgModifiedOID`
	saved=`$SNMP $cfgSavedOID`
	# Figure out which temperature indexes we have
	if test -z "$modified" -o -z "$saved"; then
		RESULT="No config"
		STATUS=3
	fi
	TIME=$modified
	modifiedTicks=`get_timeticks`
	TIME=$saved
	savedTicks=`get_timeticks`
	if test "$modifiedTicks" -ge "$savedTicks" ; then
		RESULT="Configuration chagend"
		STATUS=2
	else
		RESULT="Config saved"
	fi
	;;
temperature )
	TEMPERATURE=`$SNMP $tempOID`
	TEMPWARN=`$SNMP $tempWarn`
	TEMPFATAL=`$SNMP $tempFatal`
	# Figure out which temperature indexes we have
	if [ -z "$TEMPERATURE" ]; then
		RESULT="No temperatures"
		STATUS=3
	fi
	INT=$TEMPERATURE
	tempTemp=`get_integer`
	INT=$TEMPWARN
	tempWarn=`get_integer`
	INT=$TEMPFATAL
	tempFatal=`get_integer`
	if test "$tempTemp" -ge "$tempFatal"; then
		RESULT="Fatal temperature $tempTemp"
		STATUS=2
	elif test "$tempTemp" -ge "$tempWarn"; then
		RESULT="Warning temperature $tempTemp"
		STATUS=1
	else
		RESULT="Temperature $tempTemp"
	fi
	PERFDATA="${PERFDATA}Temperature=$tempTemp;;;; "
	;;
status )
	HEALTH=`$SNMP $statusOID`
	HEALTHS=`echo "$HEALTH"|
	/bin/grep -F "$statusOID."|
	/bin/sed -e 's,^.*: ,,'`
	if test -z "$HEALTHS"; then
		RESULT="No status"
		STATUS=3
	fi
	for i in $HEALTHS; do
	       case "$i" in
        	1 )
			# notSupported(1)
                	tempSTATUS="3"
                	RESULT=$RESULT"notSupported, "
			;;
        	2 )
			# normal(2)
                	;;
        	3 )
			# postFailure(3)
                	tempSTATUS="2"
                	RESULT=$RESULT"postFailure, "
			;;
        	4 )
			# ientityAbsent(4)
                	tempSTATUS="2"
                	RESULT=$RESULT"entityAbsent, "
			;;
        	11 )
			# poeError(11)
                	tempSTATUS="2"
                	RESULT=$RESULT"poeError, "
			;;
        	21 )
			# stackError(21)
                	tempSTATUS="2"
                	RESULT=$RESULT"stackError, "
			;;
        	22 )
			# stackPortBlocked(22))
                	tempSTATUS="2"
                	RESULT=$RESULT"stackPortBlocked, "
			;;
        	23 )
			# stackPortFailed(23)
                	tempSTATUS="2"
                	RESULT=$RESULT"stackPortFailed, "
			;;
        	31 )
			# sfpRecvError(31)
                	tempSTATUS="2"
                	RESULT=$RESULT"sfpRecvError, "
			;;
        	32 )
			# sfpSendError(32)
                	tempSTATUS="2"
                	RESULT=$RESULT"sfpSendError, "
			;;
        	33 )
			# notSupported(33)
                	tempSTATUS="2"
                	RESULT=$RESULT"sfpBothError, "
			;;
        	41 )
			# fanError(41)
                	tempSTATUS="2"
                	RESULT=$RESULT"fanError, "
			;;
        	51 )
			# psuError(51)
                	tempSTATUS="2"
                	RESULT=$RESULT"psuError, "
			;;
        	61 )
			# rpsError(61)
                	tempSTATUS="2"
                	RESULT=$RESULT"rpsError, "
			;;
        	71 )
			# moduleFaulty(71)
                	tempSTATUS="2"
                	RESULT=$RESULT"moduleFaulty, "
			;;
        	81 )
			# sensorError(81)
                	tempSTATUS="2"
                	RESULT=$RESULT"sensorError, "
			;;
        	91 )
			# hardwareFaulty(91)
                	tempSTATUS="2"
                	RESULT=$RESULT"hardwareFaulty, "
			;;
        	esac
		
		if [ "$tempSTATUS" = "3" -a "$STATUS" = "0" ]; then
			STATUS="3"
		elif [ "$tempSTATUS" = "2" -a "$STATUS" = "0" ]; then
			STATUS="2" 
		elif [ "$tempSTATUS" = "2" -a "$STATUS" = "1" ]; then
			STATUS="2" 
		elif [ "$tempSTATUS" = "2" -a "$STATUS" = "3" ]; then
			STATUS="2" 
		elif [ "$tempSTATUS" = "1" -a "$STATUS" = "3" ]; then
			STATUS="1"
		elif [ "$tempSTATUS" = "1" -a "$STATUS" = "0" ]; then
			STATUS="1"
		fi 
	done
	;;
fans )
	FANS=`/usr/bin/snmpwalk -t 15 -r 4 -v 3 -l authNoPriv -u $USERNAME -A $PASSWORD -On $HOST $fanOID`
	fans=`echo "$FANS"|
	/bin/grep -F "$fanIndexOID."|
	/bin/sed -e 's,^.*: ,,'`
	if test -z "$fans"; then
		RESULT="No fans"
		STATUS=3
	fi
	for i in $fans; do
		fanName=`get_fan $i $fanNameOID`
		fanSpeed=`get_fan $i $fanSpeedOID|/usr/bin/tr -d 'h '`
		RESULT="$RESULT$fanName = $fanSpeed
"
		PERFDATA="${PERFDATA}Fan$i=$fanSpeed;;;; "
	done
	;;
* )
	usage
	;;
esac

echo "$RESULT|$PERFDATA"
exit $STATUS
