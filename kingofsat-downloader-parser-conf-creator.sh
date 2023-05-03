#!/usr/bin/env bash

#set -x 

# in my TBS5530 device, DVBT tuner is FE=0 , DVBS tuner is in FE=1
FRONTEND_NUM=1

read -p "Select Satellite: Turksat or Hotbird: t or h : " SAT

case ${SAT} in
        t|T) DISEQC="0"
                SAT="Turksat"
		SATPOS="42E"
		break
                ;;
        h|H) DISEQC="1"
                SAT="Hotbird"
		SATPOS="13E"
                break
                ;;
        *) printf "Enter t or h..\n"
                exit;;
esac

# Lets go to configuration directory and download ini file
CONFDIR="${SAT}-CONF-FILES"
mkdir -p ${CONFDIR}
KingOfSatFile="${SAT}.ini"
pushd ${CONFDIR}
wget "https://en.kingofsat.net/dl.php?pos=${SATPOS}&fkhz=0" -O ${KingOfSatFile}


while IFS= read -r line
do
    # ini file contains a lot of uninteresting lines
    # we filter them and get only the lines we are interested
    if [ $(echo ${line} | grep -o "," | wc -l ) -ne 5 ]
    then
	    printf "not ok\n"
	    continue
    else
    	#printf '%s\n' "$line"
	FREQ=$(echo $line | awk -F "=" '{print $2}' | awk -F',' '{print $1}')
	POL=$(echo $line | awk -F "=" '{print $2}' | awk -F',' '{print $2}')
	SYMRATE=$(echo $line | awk -F "=" '{print $2}' | awk -F',' '{print $3}')
	DVBTYPE=$(echo $line | awk -F "=" '{print $2}' | awk -F',' '{print $5}')

	#KingOfSat ini file shows DVBS and "DVB-S" but DVBS2 as "S2"
	# Therefore we correct this here
	if [ ${DVBTYPE} == "S2" ]
	then
		DVBTYPE="DVB-S2"
	fi
	printf "${FREQ} ${POL} ${SYMRATE} ${DVBTYPE}\n"

	#Lets create conf file now
	OUT_CONF_FILE="${SAT}_${FREQ}_${POL}_${SYMRATE}.conf"

	printf "tuner=${FRONTEND_NUM}\n" | tee ${OUT_CONF_FILE}
	printf "freq=${FREQ}\n" | tee -a ${OUT_CONF_FILE}
	printf "pol=${POL}\n" | tee -a ${OUT_CONF_FILE}
	printf "srate=${SYMRATE}\n" | tee -a ${OUT_CONF_FILE}
	printf "delivery_system=${DVBTYPE}\n" | tee -a ${OUT_CONF_FILE}
	printf "sat_number=$((DISEQC+1))\n" | tee -a ${OUT_CONF_FILE}
	printf "multicast_ipv4=0\n" | tee -a ${OUT_CONF_FILE}
	printf "autoconfiguration=full\n" | tee -a ${OUT_CONF_FILE}
    fi
done <"${KingOfSatFile}"
popd
