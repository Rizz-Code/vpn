#!/bin/bash
# source /etc/adminbot/var.txt
TIMES="10"
CHATID="1855655763"
CHATIDGC=-1001855655763
KEY="6527620513:AAHKGPCdezTkQYyxOf0ZkktEJC6kbe-f178"
URL="https://api.telegram.org/bot$KEY/sendMessage"
domain=$(cat /etc/xray/domain)
MYIP=$(wget -qO- icanhazip.com)
timenow=$(date +%T)
tim2sec() {
    mult=1
    arg="$1"
    res=0
    while [ ${#arg} -gt 0 ]; do
        prev="${arg%:*}"
        if [ "$prev" = "$arg" ]; then
            curr="${arg#0}"  # avoid interpreting as octal
            prev=""
        else
            curr="${arg##*:}"
            curr="${curr#0}"  # avoid interpreting as octal
        fi
        curr="${curr%%.*}"  # remove any fractional parts
        res=$((res+curr*mult))
        mult=$((mult*60))
        arg="$prev"
    done
    echo "$res"
}
function vmess(){
echo -n > /tmp/iplim
data=($(cat /etc/vmess/.vmess.db | grep '^###' | cut -d ' ' -f 2 | sort | uniq))
for db in ${data[@]}; do
    logFile=$(cat /var/log/xray/access.log | grep -w "email: ${db}" | tail -n 150)
    while read a; do
        if [[ -n ${a} ]]; then
            set -- ${a}
            my="${7}"
            res="${2}"
            makansate="${3}"
            ult=$(echo "${makansate}" | sed 's/tcp://g' | sed '/^$/d' | cut -d. -f1,2,3)
            now=$(tim2sec ${timenow})
            sateeeee=$(tim2sec ${res})
            nowt=$(((${now} - ${sateeeee})))
            if [[ ${nowt} -lt 40 ]]; then
                cat /tmp/iplim | grep -w "${my}" | grep -w "${ult}" >/dev/null
                if [[ $? -eq 1 ]]; then
                    echo "${my} ${res} ${ult}" >>/tmp/iplim
                    split=$(cat /tmp/iplim)
                fi
            fi
        fi
    done <<<"${logFile}"
done
if [[ ${split} != "" ]]; then
    for user in ${data[@]}; do
        result=$(cat /tmp/iplim | grep -w "${user}" | wc -l )
        if [ -e /etc/vmess/limit-ip/${user} ]; then
        cem=$(cat /etc/vmess/limit-ip/${user} )
        if [[ ${result} -gt ${cem} ]]; then
         uuid=$(grep -wE "^### $user" "/etc/vmess/.vmess.db" | cut -d ' ' -f 4 | sort | uniq)
         exp=$(grep -wE "^### $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
         #locked akun 15 menit
         echo "resvm ${user} ${exp} ${uuid}" | at now +15 minutes &> /dev/null
	     sed -i "/^### $user $exp/,/^},{/d" /etc/xray/config.json
	     systemctl restart xray &> /dev/null
         cum=$(cat /tmp/iplim | grep -w "${user}" | cut -d ' ' -f 2,3)
         
         TEXT="
<code>—————————————————————————</code>
<code>         VMESS            </code>
<code>—————————————————————————</code>
<code>❌ Multi Login Detected ❌</code>
<code>—————————————————————————</code>
<code>IP     : ${MYIP}
DOMAIN : ${domain}
</code>
<code>—————————————————————————</code>
<code>Username : ${user}</code>
${cum}

<code>Account Locked 15 minutes</code>
"

        curl -s --max-time $TIMES -d "chat_id=$CHATIDGC&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL
        curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL

        fi
    fi
  done
fi
echo "" >/dev/null
}
function vless(){
echo -n > /tmp/iplimless
data=($(cat /etc/vless/.vless.db | grep '^#&' | cut -d ' ' -f 2 | sort | uniq))
for db in ${data[@]}; do
    logFile=$(cat /var/log/xray/access.log | grep -w "email: ${db}" | tail -n 150)
    while read a; do
        if [[ -n ${a} ]]; then
            set -- ${a}
            my="${7}"
            res="${2}"
            makansate="${3}"
            ult=$(echo "${makansate}" | sed 's/tcp://g' | sed '/^$/d' | cut -d. -f1,2,3)
            now=$(tim2sec ${timenow})
            sateeeee=$(tim2sec ${res})
            nowt=$(((${now} - ${sateeeee})))
            if [[ ${nowt} -lt 40 ]]; then
                cat /tmp/iplimless | grep -w "${my}" | grep -w "${ult}" >/dev/null
                if [[ $? -eq 1 ]]; then
                    echo "${my} ${res} ${ult}" >>/tmp/iplimless
                    split=$(cat /tmp/iplimless)
                fi
            fi
        fi
    done <<<"${logFile}"
done
if [[ ${split} != "" ]]; then
    for user in ${data[@]}; do
        result=$(cat /tmp/iplimless | grep -w "${user}" | wc -l )
        if [ -e /etc/vless/limit-ip/${user} ]; then
        cem=$(cat /etc/vless/limit-ip/${user} )
        if [[ ${result} -gt ${cem} ]]; then
         uuid=$(grep -wE "^#& $user" "/etc/vless/.vless.db" | cut -d ' ' -f 4 | sort | uniq)
         exp=$(grep -wE "^#& $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
         #locked akun 15 menit
         echo "resvless ${user} ${exp} ${uuid}" | at now +15 minutes &> /dev/null
	     sed -i "/^#& $user $exp/,/^},{/d" /etc/xray/config.json
	     systemctl restart xray &> /dev/null
         cum=$(cat /tmp/iplimless | grep -w "${user}" | cut -d ' ' -f 2,3)
         
         TEXT="
<code>—————————————————————————</code>
<code>         Vless            </code>
<code>—————————————————————————</code>
<code>❌ Multi Login Detected ❌</code>
<code>—————————————————————————</code>
<code>IP     : ${MYIP}
DOMAIN : ${domain}
</code>
<code>—————————————————————————</code>
<code>Username : ${user}</code>
${cum}

<code>Account Locked 15 minutes</code>
"

        curl -s --max-time $TIMES -d "chat_id=$CHATIDGC&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL
        curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL

        fi
    fi
  done
fi
echo "" >/dev/null
}
function trojan(){
echo -n > /tmp/iplimtr
data=($(cat /etc/trojan/.trojan.db | grep '^#!' | cut -d ' ' -f 2 | sort | uniq))
for db in ${data[@]}; do
    logFile=$(cat /var/log/xray/access.log | grep -w "email: ${db}" | tail -n 150)
    while read a; do
        if [[ -n ${a} ]]; then
            set -- ${a}
            my="${7}"
            res="${2}"
            makansate="${3}"
            ult=$(echo "${makansate}" | sed 's/tcp://g' | sed '/^$/d' | cut -d. -f1,2,3)
            now=$(tim2sec ${timenow})
            sateeeee=$(tim2sec ${res})
            nowt=$(((${now} - ${sateeeee})))
            if [[ ${nowt} -lt 40 ]]; then
                cat /tmp/iplimtr | grep -w "${my}" | grep -w "${ult}" >/dev/null
                if [[ $? -eq 1 ]]; then
                    echo "${my} ${res} ${ult}" >>/tmp/iplimtr
                    split=$(cat /tmp/iplimtr)
                fi
            fi
        fi
    done <<<"${logFile}"
done
if [[ ${split} != "" ]]; then
    for user in ${data[@]}; do
        result=$(cat /tmp/iplimtr | grep -w "${user}" | wc -l )
        if [ -e /etc/trojan/limit-ip/${user} ]; then
        cem=$(cat /etc/trojan/limit-ip/${user} )
        if [[ ${result} -gt ${cem} ]]; then
         uuid=$(grep -wE "^#! $user" "/etc/trojan/.trojan.db" | cut -d ' ' -f 4 | sort | uniq)
         exp=$(grep -wE "^#! $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
         #locked akun 15 menit
         echo "restr ${user} ${exp} ${uuid}" | at now +15 minutes &> /dev/null
	     sed -i "/^#! $user $exp/,/^},{/d" /etc/xray/config.json
	     systemctl restart xray &> /dev/null
         cum=$(cat /tmp/iplimtr | grep -w "${user}" | cut -d ' ' -f 2,3)
         
         TEXT="
<code>—————————————————————————</code>
<code>         TROJAN           </code>
<code>—————————————————————————</code>
<code>❌ Multi Login Detected ❌</code>
<code>—————————————————————————</code>
<code>IP     : ${MYIP}
DOMAIN : ${domain}
</code>
<code>—————————————————————————</code>
<code>Username : ${user}</code>
${cum}

<code>Account Locked 15 minutes</code>
"

        curl -s --max-time $TIMES -d "chat_id=$CHATIDGC&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL
        curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL

        fi
    fi
  done
fi
echo "" >/dev/null
}
if [[ ${1} == "vmess" ]]; then
vmess
fi
if [[ ${1} == "vless" ]]; then
vless
fi
if [[ ${1} == "trojan" ]]; then
trojan
fi