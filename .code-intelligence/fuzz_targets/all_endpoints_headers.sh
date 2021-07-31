WGUSER=cifuzz
WGPASS=nnMjJa72lx
WGCOOK="/tmp/webgoatcookies$WGUSER"
curl -s -X 'POST' 'http://172.17.0.3:8080/WebGoat/register.mvc' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:90.0) Gecko/20100101 Firefox/90.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Origin: http://172.17.0.3:8080' -H 'Connection: keep-alive' -H 'Referer: http://172.17.0.3:8080/WebGoat/register.mvc' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-GPC: 1' --data-raw "username=$USER&password=$WGPASS&matchingPassword=$WGPASS&agree=agree" -c $WGCOOK >/dev/null
curl -s 'http://172.17.0.3:8080/WebGoat/login' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:90.0) Gecko/20100101 Firefox/90.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Origin: http://172.17.0.3:8080' -H 'Connection: keep-alive' -H 'Referer: http://172.17.0.3:8080/WebGoat/login?error' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-GPC: 1' --data-raw "username=$USER&password=$WGPASS&matchingPassword=$WGPASS&agree=agree" -c $WGCOOK >/dev/null
echo -n Cookie: JSESSIONID= && cat $WGCOOK|grep JSESSIONID|cut -f 7
rm $WGCOOK
