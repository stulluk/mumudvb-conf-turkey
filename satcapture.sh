#!/usr/bin/env sh

ADAPTER_NUM=0
FRONTEND_NUM=1
DEMUX_NUM=0
DVR_NUM=0

FREQMIN=10700
FREQMAX=12750

SYMRATEMIN=1000
SYMRATEMAX=50000

read -p "Select Satellite: Turksat or Hotbird: t or h : " SAT

case ${SAT} in
	t|T) DISEQC="0"
		SAT="Turksat"
		break
		;;
	h|H) DISEQC="1"
		SAT="Hotbird"
		break
		;;
	*) printf "Enter t or h..\n"
		exit;;
esac


read -p "Enter DVB DELIVERY_SYSTEM TYPE: S or S2: " DVBTYPE

case ${DVBTYPE} in
	s|S) DVBTYPE="DVB-S"
		break
		;;
	s2|S2) DVBTYPE="DVB-S2"
		break
		;;
	*) printf "Enter s or s2..\n"
		exit;;
esac

printf "DVBTYPE is ${DVBTYPE}\n"

read -p "Enter Frequency: " FREQ

case ${FREQ} in
    ''|*[!0-9]*) printf "Please enter a number between ${FREQMIN} and ${FREQMAX} !!\n"
	   	exit
	       	;;
    *) ;;
esac

if [ ${FREQ} -lt ${FREQMIN} ] || [ ${FREQ} -gt ${FREQMAX} ]
then
	printf "Wrong Frequency value!!\n"
	exit
fi

printf "FREQUENCY is ${FREQ}\n"

read -p "Enter Polarity: V or H: " POL

case ${POL} in
	v|V) POL="vertical"
		POL_MUMU="v"
		break
		;;
	h|H) POL="horizontal"
		POL_MUMU="h"
		break
		;;
	*) printf "Enter v or h..\n"
		exit;;
esac

printf "POLARITY is ${POL}\n"

read -p "Enter Symbol Rate: " SYMRATE

case ${SYMRATE} in
    ''|*[!0-9]*) printf "Please enter a number between ${SYMRATEMIN} and ${SYMRATEMAX} !!\n"
	   	exit
	       	;;
    *) ;;
esac


if [ ${SYMRATE} -lt ${SYMRATEMIN} ] || [ ${SYMRATE} -gt ${SYMRATEMAX} ]
then
	printf "Wrong Symbol Rate value!!\n"
	exit
fi


printf "SYMRATE is ${SYMRATE}\n"
CURDATE="$(date +'%Y-%m-%d-%H-%M-%S')"
OUT_TS_FILE="${SAT}_${FREQ}_${POL_MUMU}_${SYMRATE}_${CURDATE}.ts"

printf "Output TS file is %s\n" ${OUT_TS_FILEFILE}

# Lets create conf file for mumudvb

OUT_CONF_FILE="${SAT}_${FREQ}_${POL_MUMU}_${SYMRATE}.conf"

printf "tuner=${FRONTEND_NUM}\n" | tee ${OUT_CONF_FILE}
printf "freq=${FREQ}\n" | tee -a ${OUT_CONF_FILE}
printf "pol=${POL_MUMU}\n" | tee -a ${OUT_CONF_FILE}
printf "srate=${SYMRATE}\n" | tee -a ${OUT_CONF_FILE}
printf "delivery_system=${DVBTYPE}\n" | tee -a ${OUT_CONF_FILE}
printf "sat_number=$((DISEQC+1))\n" | tee -a ${OUT_CONF_FILE}
printf "multicast_ipv4=0\n" | tee -a ${OUT_CONF_FILE}
printf "autoconfiguration=full\n" | tee -a ${OUT_CONF_FILE}

mumudvb -dt -c ${OUT_CONF_FILE} --dumpfile ${OUT_TS_FILE}

# tsp --debug  -I dvb \
# 	-d /dev/dvb/adapter${ADAPTER_NUM}:${FRONTEND_NUM}:${DEMUX_NUM}:${DVR_NUM} \
# 	--delivery-system ${DVBTYPE} \
#        	--satellite-number ${DISEQC} \
#        	--lnb Extended \
# 	--frequency "${FREQ}000000" \
# 	--polarity ${POL} \
#        	--symbol-rate "${SYMRATE}000" > ${OUT_TS_FILE}






