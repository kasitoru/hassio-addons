#!/usr/bin/env bashio
set -e

MEGAD_SCRIPT_URL=http://ab-log.ru/files/File/megad-cfg/megad-cfg-2561.zip
echo "Download latest update script from $MEGAD_SCRIPT_URL"
if ! curl -L -f -s -o megad.zip "$MEGAD_SCRIPT_URL"; then
    echo "Download failed, using local megad-cfg-2561.zip"
    if [ -f megad-cfg-2561.zip ]; then
        echo "Renaming local megad-cfg-2561.zip to megad.zip"
        mv megad-cfg-2561.zip megad.zip
    else
        echo "Local file megad-cfg-2561.zip not found!"
        exit 1
    fi
fi
unzip megad.zip
rm megad.zip

localip=$(bashio::config 'localip' $(ip route get 1 | awk '{print $NF;exit}'))
for host in $(bashio::config "hosts|keys"); do
    ip=$(bashio::config "hosts[${host}].ip")
    password=$(bashio::config "hosts[${host}].password")
    options=$(bashio::config "hosts[${host}].options" "-w --ee --read-conf /backup/megad-$ip.cfg --write-conf /backup/megad-$ip.cfg")
    cmd="php megad-cfg-2561.php --ip $ip -p $password --local-ip $localip $options"
    echo "$cmd"
    $cmd
done

echo "Done."
