#!/bin/bash

GREEN="\e[32m"
END="\e[0m"

function ota-mgnt() {
    echo -e "${GREEN}Enter OTA URL:${END}"
    read url
    echo -e "${GREEN}Fetching OTA...${END}"
    wget -q --show-progress $url -O ota.zip
    echo -e "${GREEN}Finished downloading OTA.${END}\n"
}
ota-mgnt

function get-payload-dumper() {
    local url_stem="https://github.com/ssut/payload-dumper-go/releases/download"
    local latest_tag=$(curl -s https://api.github.com/repos/ssut/payload-dumper-go/releases/latest | jq -r '.tag_name')
    echo -e "${GREEN}Fetching payload-dumper-go...${END}"
    wget -q --show-progress ${url_stem}/${latest_tag}/payload-dumper-go_${latest_tag}_linux_amd64.tar.gz -O payload-dumper.tar.gz
    echo -e "${GREEN}Done.${END}"
    echo -e "${GREEN}Extracting payload-dumper-go...${END}"
    tar -zxf payload-dumper.tar.gz payload-dumper-go
    echo -e "${GREEN}Making payload-dumper-go executable...${END}"
    chmod +x payload-dumper-go
    echo -e "${GREEN}Done.${END}\n"
}
get-payload-dumper

function extract-payload() {
    echo -e "${GREEN}Extracting payload...${END}"
    ./payload-dumper-go -o images -p abl,aop,bluetooth,cpucp,devcfg,dsp,featenabler,hyp,keymaster,modem,multiimgoem,qupfw,qweslicstore,shrm,tz,uefisecapp,xbl,xbl_config ota.zip
    echo -e "${GREEN}Done.${END}\n"
}
extract-payload

function clean-up() {
    echo -e "${GREEN}Cleaning up...${END}"
    rm -rf payload-dumper-go payload-dumper.tar.gz ota.zip payload.bin
    echo -e "${GREEN}Done.${END}"
}
clean-up
