#!/bin/bash
  
function send-log(){
# source /etc/adminbot/var.txt
TIMES="10"
CHATID="1855655763"
CHATIDGC=-1001855655763
KEY="6527620513:AAHKGPCdezTkQYyxOf0ZkktEJC6kbe-f178"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<code>────────────────────</code>
<b>⚠️NOTIF QUOTA HABIS⚠️</b>
<code>────────────────────</code>
<code>Username  : </code><code>$user</code>
<code>Usage     : </code><code>$total</code>
<code>────────────────────</code>
"
curl -s --max-time $TIMES -d "chat_id=$CHATIDGC&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL
}

function con() {
    local -i bytes=$1;
    if [[ $bytes -lt 1024 ]]; then
        echo "${bytes}B"
    elif [[ $bytes -lt 1048576 ]]; then
        echo "$(( (bytes + 1023)/1024 ))KB"
    elif [[ $bytes -lt 1073741824 ]]; then
        echo "$(( (bytes + 1048575)/1048576 ))MB"
    else
        echo "$(( (bytes + 1073741823)/1073741824 ))GB"
    fi
}
function cekvmess(){
  data=($(cat /etc/xray/config.json | grep '^###' | cut -d ' ' -f 2 | sort | uniq))
  if [[ ! -e /etc/limit/vmess ]]; then
  mkdir -p /etc/limit/vmess
  fi
  for user in ${data[@]}
  do
  xray api stats --server=127.0.0.1:10000 -name "user>>>${user}>>>traffic>>>downlink" >& /tmp/${user}
  getThis=$(cat /tmp/${user} | awk '{print $1}');
  if [[ ${getThis} != "failed" ]]; then
        downlink=$(xray api stats --server=127.0.0.1:10000 -name "user>>>${user}>>>traffic>>>downlink" | grep -w "value" | awk '{print $2}' | cut -d '"' -f2);
        if [ -e /etc/limit/vmess/${user} ]; then
        plus2=$(cat /etc/limit/vmess/${user});
        if [[ ${#plus2} -gt 0 ]]; then
        plus3=$(( ${downlink} + ${plus2} ));
        echo "${plus3}" > /etc/limit/vmess/"${user}"
        xray api stats --server=127.0.0.1:10000 -name "user>>>${user}>>>traffic>>>downlink" -reset > /dev/null 2>&1
        else
        echo "${downlink}" > /etc/limit/vmess/"${user}"
        xray api stats --server=127.0.0.1:10000 -name "user>>>${user}>>>traffic>>>downlink" -reset > /dev/null 2>&1
        fi
        else
        echo "${downlink}" > /etc/limit/vmess/"${user}"
        xray api stats --server=127.0.0.1:10000 -name "user>>>${user}>>>traffic>>>downlink" -reset > /dev/null 2>&1
        fi
        else
      echo ""
   fi
done
}
function vmess(){
while true; do
sleep 30
cekvmess
data=($(cat /etc/xray/config.json | grep '^###' | cut -d ' ' -f 2 | sort | uniq))
for user in ${data[@]}
  do
    if [ -e /etc/vmess/${user} ]; then
      checkLimit=$(cat /etc/vmess/${user});
      if [[ ${#checkLimit} -gt 1 ]]; then
      if [ -e /etc/limit/vmess/${user} ]; then
      Usage=$(cat /etc/limit/vmess/${user});
      if [[ ${Usage} -gt ${checkLimit} ]]; then
      exp=$(grep -w "^### $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
      sed -i "/^### $user $exp/,/^},{/d" /etc/xray/config.json
      sed -i "/^### $user $exp/d" /etc/vmess/.vmess.db
      systemctl restart xray >> /dev/null 2>&1
      bol=$(cat /etc/limit/vmess/${user});
      total=$(con ${bol})
      send-log
      rm -rf /etc/limit/vmess/${user}
      else
      echo ""
      fi
      else
      echo ""
      fi
      else
      echo ""
      fi
      else
      echo ""
    fi
  done
done
}
function cekvless(){
  data=($(cat /etc/xray/config.json | grep '^#&' | cut -d ' ' -f 2 | sort | uniq))
  if [[ ! -e /etc/limit/vless ]]; then
  mkdir -p /etc/limit/vless
  fi
  for user in ${data[@]}
  do
  xray api stats --server=127.0.0.1:10000 -name "user>>>${user}>>>traffic>>>downlink" >& /tmp/${user}
  getThis=$(cat /tmp/${user} | awk '{print $1}');
  if [[ ${getThis} != "failed" ]]; then
        downlink=$(xray api stats --server=127.0.0.1:10000 -name "user>>>${user}>>>traffic>>>downlink" | grep -w "value" | awk '{print $2}' | cut -d '"' -f2);
        if [ -e /etc/limit/vless/${user} ]; then
        plus2=$(cat /etc/limit/vless/${user});
        if [[ ${#plus2} -gt 0 ]]; then
        plus3=$(( ${downlink} + ${plus2} ));
        echo "${plus3}" > /etc/limit/vless/"${user}"
        xray api stats --server=127.0.0.1:10000 -name "user>>>${user}>>>traffic>>>downlink" -reset > /dev/null 2>&1
        else
        echo "${downlink}" > /etc/limit/vless/"${user}"
        xray api stats --server=127.0.0.1:10000 -name "user>>>${user}>>>traffic>>>downlink" -reset > /dev/null 2>&1
        fi
        else
        echo "${downlink}" > /etc/limit/vless/"${user}"
        xray api stats --server=127.0.0.1:10000 -name "user>>>${user}>>>traffic>>>downlink" -reset > /dev/null 2>&1
        fi
        else
      echo ""
   fi
done
}
function vless(){
while true; do
sleep 30
cekvless
data=($(cat /etc/xray/config.json | grep '^#&' | cut -d ' ' -f 2 | sort | uniq))
for user in ${data[@]}
  do
    if [ -e /etc/vless/${user} ]; then
      checkLimit=$(cat /etc/vless/${user});
      if [[ ${#checkLimit} -gt 1 ]]; then
      if [ -e /etc/limit/vless/${user} ]; then
      Usage=$(cat /etc/limit/vless/${user});
      if [[ ${Usage} -gt ${checkLimit} ]]; then
      exp=$(grep -w "^#& $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
      sed -i "/^#& $user $exp/,/^},{/d" /etc/xray/config.json
      sed -i "/^### $user $exp/d" /etc/vless/.vless.db
      systemctl restart xray >> /dev/null 2>&1
      bol=$(cat /etc/limit/vless/${user});
      total=$(con ${bol})
      send-log
      rm -rf /etc/limit/vless/${user}
      else
      echo ""
      fi
      else
      echo ""
      fi
      else
      echo ""
      fi
      else
      echo ""
    fi
  done
done
}
function cektrojan(){
  data=($(cat /etc/xray/config.json | grep '^#!' | cut -d ' ' -f 2 | sort | uniq))
  if [[ ! -e /etc/limit/trojan ]]; then
  mkdir -p /etc/limit/trojan
  fi
  for user in ${data[@]}
  do
  xray api stats --server=127.0.0.1:10000 -name "user>>>${user}>>>traffic>>>downlink" >& /tmp/${user}
  getThis=$(cat /tmp/${user} | awk '{print $1}');
  if [[ ${getThis} != "failed" ]]; then
        downlink=$(xray api stats --server=127.0.0.1:10000 -name "user>>>${user}>>>traffic>>>downlink" | grep -w "value" | awk '{print $2}' | cut -d '"' -f2);
        if [ -e /etc/limit/trojan/${user} ]; then
        plus2=$(cat /etc/limit/trojan/${user});
        if [[ ${#plus2} -gt 0 ]]; then
        plus3=$(( ${downlink} + ${plus2} ));
        echo "${plus3}" > /etc/limit/trojan/"${user}"
        xray api stats --server=127.0.0.1:10000 -name "user>>>${user}>>>traffic>>>downlink" -reset > /dev/null 2>&1
        else
        echo "${downlink}" > /etc/limit/trojan/"${user}"
        xray api stats --server=127.0.0.1:10000 -name "user>>>${user}>>>traffic>>>downlink" -reset > /dev/null 2>&1
        fi
        else
        echo "${downlink}" > /etc/limit/trojan/"${user}"
        xray api stats --server=127.0.0.1:10000 -name "user>>>${user}>>>traffic>>>downlink" -reset > /dev/null 2>&1
        fi
        else
      echo ""
   fi
done
}
function trojan(){
while true; do
sleep 30
cektrojan
data=($(cat /etc/xray/config.json | grep '^#!' | cut -d ' ' -f 2 | sort | uniq))
for user in ${data[@]}
  do
    if [ -e /etc/trojan/${user} ]; then
      checkLimit=$(cat /etc/trojan/${user});
      if [[ ${#checkLimit} -gt 1 ]]; then
      if [ -e /etc/limit/trojan/${user} ]; then
      Usage=$(cat /etc/limit/trojan/${user});
      if [[ ${Usage} -gt ${checkLimit} ]]; then
      exp=$(grep -w "^#! $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
      sed -i "/^#! $user $exp/,/^},{/d" /etc/xray/config.json
      sed -i "/^### $user $exp/d" /etc/trojan/.trojan.db
      systemctl restart xray >> /dev/null 2>&1
      bol=$(cat /etc/limit/trojan/${user});
      total=$(con ${bol})
      send-log
      rm -rf /etc/limit/trojan/${user}
      else
      echo ""
      fi
      else
      echo ""
      fi
      else
      echo ""
      fi
      else
      echo ""
    fi
  done
done
}
if [[ ${1} == "vmess" ]]; then
vmess
elif [[ ${1} == "vless" ]]; then
vless
elif [[ ${1} == "trojan" ]]; then
trojan
fi