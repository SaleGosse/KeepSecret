#!/bin/bash

#Secretum 
#date 1>> ~/Bureau/Script/Debugger/debugger.txt
#echo " " >> ~/Bureau/Script/Debugger/debugger.txts
#echo "################## Debug bashTor.sh #################" >> /home/fabien/Bureau/Script/Debugger/debugger.txt
#exec 5>> ~/Bureau/Script/Debugger/debugger.txt
#BASH_XTRACEFD="5"
#set -x  


help(){
    echo "
        #===========================================================================================#
        # SYNOPSIS                                                                                  #
        #                                                                                           #
        #   bashTor.sh [-option]                                                                    #
        #                                                                                           #
        # DESCRIPTION                                                                               #
        #                                                                                           #
        #   This script allows to manipulate your connection or not all traffic although tor.       #
        #   BashTor lets possibility for user what he want to do with tor, to see status            #
        #   and to show ip.                                                                         #
        #                                                                                           #
        #                                                                                           #
        # OPTIONS                                                                                   #
        #    -S,     --status       put status of your connect or not with Tor                      #
        #    -a,     --activate     start all traffic through Tor                                   #
        #    -s,     --stop         stop processus Tor                                              #
        #    -r,     --restart      restart all traffic through Tor                                 #
        #    -v,     --version      version of script shell                                         #
        #    -e,     --exit         exit script shell                                               #
        #    -t,     --storage       use different task with veracrypt and luks                     #
        #    -M,     --monitor      monitoring                                                      #
        #    -h,     --help         print this help                                                 #
        #                                                                                           #
        # AUTHORS                                                                                   #
        #   - RAKOTONDRAJAO     <rakotondraja@et.esiea.fr>                                          #
        #===========================================================================================#
        "}

RED='\033[0;31m'
LGREEN='\033[1;32m'

startTor()
{
    #valide password sudo option S for check authentificate stdin
    sudo iptables -t nat -F OUTPUT
    sudo iptables -t nat -A OUTPUT -m state --state ESTABLISHED -j RETURN
    sudo iptables -t nat -A OUTPUT -m owner --uid tor -j RETURN
    sudo iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 9061
    sudo iptables -t nat -A OUTPUT -p tcp --dport 53 -j REDIRECT --to-ports 9061
    sudo iptables -t nat -A OUTPUT -d 10.66.0.0/255.255.0.0 -p tcp -j REDIRECT --to-ports 9051
    sudo iptables -t nat -A OUTPUT -d 127.0.0.1/8 -j RETURN
    sudo iptables -t nat -A OUTPUT -d 192.168.0.0/16 -j RETURN
    sudo iptables -t nat -A OUTPUT -d 172.16.0.0/12 -j RETURN
    sudo iptables -t nat -A OUTPUT -d 10.0.0.0/8 -j RETURN
    sudo iptables -t nat -A OUTPUT -p tcp -j REDIRECT --to-ports 9051
    sudo iptables -t filter -F OUTPUT
    sudo iptables -t filter -A OUTPUT -m state --state ESTABLISHED -j ACCEPT
    sudo iptables -t filter -A OUTPUT -m owner --uid tor -j ACCEPT
    sudo iptables -t filter -A OUTPUT -p udp --dport 9061 -j ACCEPT
    sudo iptables -t filter -A OUTPUT -p tcp --dport 9061 -j ACCEPT
    sudo iptables -t filter -A OUTPUT -d 10.66.0.0/255.255.0.0 -p tcp -j ACCEPT
    sudo iptables -t filter -A OUTPUT -d 127.0.0.1/8 -j ACCEPT
    sudo iptables -t filter -A OUTPUT -d 192.168.0.0/16 -j ACCEPT
    sudo iptables -t filter -A OUTPUT -d 172.16.0.0/12 -j ACCEPT
    sudo iptables -t filter -A OUTPUT -d 10.0.0.0/8 -j ACCEPT
    sudo iptables -t filter -A OUTPUT -p tcp -j ACCEPT
    sudo iptables -t filter -A OUTPUT -p udp -j REJECT
    sudo iptables -t filter -A OUTPUT -p icmp -j REJECT

}

stopTor()
{   
	# valide password sudo option S for check authentificate stdin
 	sudo  iptables -t nat -F OUTPUT
  sudo  iptables -t filter -F OUTPUT 
}

checkIp()
{
	currentIp=$(curl -# http://checkip.amazonaws.com/)
}

ckeckStatus()
{
	isTor=$(grep $currentIp trueIp.txt)
	
	if [ -z "$isTor" ];
	then
		isTor="Activated"
	else
		isTor="Disabled"
	fi
}

printIp()
{	
	
	
  if [ $isTor = "Activated" ];
  then
    echo  "     Status  :   $isTor  "
    echo  "     Your Ip :   $currentIp  "
  elif [ $isTor = "Disabled" ];
  then
    echo  "     Status  :   $isTor  "
    echo  "     Your Ip :   $currentIp  "  
  fi

}

restartServiceTor()
{
  sudo systemctl restart tor
}

statusCo()
{
		#check current Ip
  		checkIp
 
  		#define you are on Tor or not
  		ckeckStatus

  		#print result
  		printIp
}

# getopts possibility with concatanation USAGE
OPTDATA="a(-start)"
OPTDATA+="s(-stop)"
OPTDATA+="S(-status)"
OPTDATA+="v(-version)"
OPTDATA+="h(-help)"

version="1.2"

while getopts "$OPTDATA" optchar ;
do
    #define each case and this represent every possibility with proposte in the help
    case $optchar in
    S)	
			
		   statusCo
    ;;
    a)
  		#start tor 
  		startTor
  		
  		#print status connection
  		statusCo
    ;;
    s)
  		#stop
		  stopTor  	
  		
  		#print status connection
  		statusCo
  	;;
  	r)
      
      checkIp
  		#stop
		  stopTor 

  		restartServiceTor
  		
      #start tor 
  		startTor

  		#print status connection
  		statusCo
  	;;
  	v)
		echo -e " ${LGREEN}Version : ${RED}$version "
  	;;
    h)
        help
        exit 0
   
    ;;
     - ) [ $OPTIND -ge 1 ] && optind=$(expr $OPTIND - 1 ) || optind=$OPTIND
	    eval OPTION="\$$optind"
	    OPTARG=$(echo $OPTION | cut -d'=' -f2)
	    OPTION=$(echo $OPTION | cut -d'=' -f1)
	    case $OPTION in
            --status )
						  	       #print status connection
  							       statusCo
  						;;
            --start ) 
                       #start tor 
  						         startTor
                      
                      	#print status connection
							         statusCo
            ;;
            --stop  )         
                       #stop
				               stopTor 
                    	
                    	 #print status connection
						           statusCo
            ;;
           --restart )
                      checkIp

							       #start tor      
                     startTor
                     
                     #restart tor service
                     restartServiceTor

		  		           #stop
				             stopTor

				             #print status connection
					           statusCo
						;;
				--version )
  							echo " Version : $version "
  							exit 0
  				 		;;
                --help )
							help
							exit 0
  				 		;;
    				*)  
       						echo -e " \x1B[01;95m Sorry bashTor.sh does not know this option, you can use -h ou --help for more details.\x1B[0m " 
  	 						exit 1
  	 					;;
       	esac
    ;;
    *)  
        echo -e " \x1B[01;95m Sorry bashTor.sh does not know this option, you can use -h ou --help for more details.\x1B[0m " 
    	exit 1
    ;;
    esac
done

