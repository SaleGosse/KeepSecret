#!/bin/bash




#export sudoPass=$(zenity --password --title "Taper votre mots de passe sudo")

checkIp()
{
	currentIp=$(curl -# http://checkip.amazonaws.com/)
}

ckeckStatus()
{
	checkIp
	isTor=$(grep $currentIp trueIp.txt)
	
	if [ -z "$isTor" ];
	then
		isTor="Activated"
	fi
}

windowMenuConfid()
{
	sleep 0.8
	# exit profil serie/Film there because it's impossible after that (we can't use exit 0 in sh getoptsTest.sh )
	if [ $result = "-e" ] || [ $result = "--exit" ] ;
	then
		echo "Vous avez quitté le programme profil confidential et vous avez votre vrai Ip "
		bash torManager.sh -s
		exit 1
	elif [ $result = "-M" ] || [ $result = "--monitor" ] ;
	then
		 bash monitoring.sh &
	elif [ $result = "-t" ] || [ $result = "--storage" ]; 
	then
		bash backup.sh &
	else
		bash torManager.sh $result
	fi
}


main()
{

	end=$(date +"%s")
	difftimelps=$(($end-$begin))
	termin=$(($difftimelps / 60))
	if [ $termin -ge 15 ];
	then
		ckeckStatus
		if [ $isTor = "Activated" ];
		then
			bash torManager.sh -r
			echo "break restart "
		fi
	else
		echo "$termin"	
		windowMenuConfid
		#sleep 2
	fi
	# call menu 
	
	if [ $? -eq 1 ] ;
	then
		#reset
		echo " your option : $result"	
		bash torManager.sh "--help"
		if [ $termin -ge 15 ];
		then
			ckeckStatus
			if [ $isTor = "Activated" ];
			then
				bash torManager.sh -r
				echo "break restart "
			fi		
		else
			echo "$termin"
		
			windowMenuConfid
			#sleep 2
		fi
	else
		#call menu 
		if [ $termin -ge 15 ];
		then
			ckeckStatus
			if [ $isTor = "Activated" ];
			then
				bash torManager.sh -r
				echo "break restart "
			fi		
		else
			echo "$termin"
		
			windowMenuConfid
			#sleep 2
		fi
   fi	
}

while [[ true ]]; 
do
	
	end=$(date +"%s")
	difftimelps=$(($end-$begin))
	termin=$(($difftimelps / 60))
	
	if [ $termin -ge 15 ];
	then
		ckeckStatus
		if [ $isTor = "Activated" ];
		then
			bash torManager.sh -r
			echo "break restart"
		fi
	else
		echo "$termin"
		main
		#sleep 2
	fi
	#statements
	
done

exit 1
