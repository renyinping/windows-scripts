#!/bin/sh

# ¥Ú”°∫Ï…´◊÷∑˚¥Æ $1=◊÷∑˚¥Æ
print_red()
{
	echo -e "\033[31m$1\033[0m"
}

# ¥Ú”°¬Ã…´◊÷∑˚¥Æ $1=◊÷∑˚¥Æ
print_green()
{
	echo -e "\033[32m$1\033[0m"
}

# ¥Ú”°ª∆…´◊÷∑˚¥Æ $1=◊÷∑˚¥Æ
print_yellow()
{
	echo -e "\033[33m$1\033[0m"
}

# ≤‚ ‘√¸¡Ó «∑Ò”––ß
if ! which openssl > /dev/null
then
	print_red "Can not find the command: openssl"
	exit 1
fi

# ≤È’“√‹¬ÎŒƒº˛
if test ! -f "password.txt"
then
	print_red "File not found: password.txt"
	exit 2
fi

PWD=`cat password.txt`
ENC=$0
ENC=${ENC##*/}
ENC=${ENC%.sh}

# Ω‚√‹
if test -n "$*"
then
	for i in `ls $*`
	do
		openssl enc -${ENC} -d -salt -in "$i" -out "${i%.*}.temp" -pass "pass:${PWD}"
		print_green "File decryption completed: ${i%.*}.temp"
	done
fi

# º”√‹
if test -z "$*"
then
	for i in `ls *.conf`
	do
		openssl enc -${ENC} -e -salt -in "$i" -out "$i.${ENC}" -pass "pass:${PWD}"
		print_green "File encryption completed: $i.${ENC}"
	done
fi
