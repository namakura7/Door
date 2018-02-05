#!/bin/sh

# https://github.com/oblique/create_ap

# apt install hostapd

# インストールしていない場合は、
# sudo make install
# を実行

# input、outputのモジュール名は
# ifconfig
# で確認

cd `dirname $0`
hoge=`pwd`

if [ "`whoami`" = "root" ] ; then
	echo "Not need \"sudo\"."
	exit  0
fi

# wlp4s0		# wlpは無線
# enp0s25		# enpは有線

output=wlp4s0
input=wlx009c0e0064e4 #enp0s25
ssid=sample
passward=sample!!
# パスワードは8文字以上

sudo sh -c "$hoge/create_ap $output $input $ssid $passward > tmp.txt"
