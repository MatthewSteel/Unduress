#!/bin/bash

if [ -t 2 ]; then
    bold=$(tput bold)
    normal=$(tput sgr0)
fi

key-gen() {
    printf -- %s\\n%s " " "-" | ../unduress key-gen > key
}
key-encrypt() {
    printf -- %s " " | ../unduress key-encrypt temp key > enc.kcrypt
}
key-decrypt() {
    diff temp <(printf -- %s " " | ../unduress key-decrypt enc.kcrypt key) >/dev/null
}
decrypt-wrong() {
    printf -- %s "wrong password" | ../unduress key-decrypt enc.kcrypt key 2>/dev/null
}
decrypt-duress() {
    printf -- %s "-" | ../unduress key-decrypt enc.kcrypt key 2>/dev/null
}
decrypt-after() {
    printf -- %s " " | ../unduress key-decrypt enc.kcrypt key 2>/dev/null
}
attach() {
    ../unduress key-attach enc.kcrypt key > enc.crypt
    diff temp <(printf -- %s " " | ../unduress decrypt enc.crypt)
}
encrypt() {
    printf -- %s\\n%s " " "-" | ../unduress encrypt temp > temp.c
    printf -- %s " " | ../unduress decrypt temp.c > temp2
    rm temp.c
    
    diff temp2 temp > /dev/null
    ret = $?
    rm temp2
    return ret
}

key-gen
if [ $? ]; then
    echo "1: Key-gen test passed"
else
    echo "${bold}1: Key-gen test failed${normal}"
    exit 1
fi

key-encrypt
if [ $? ]; then
    echo "2: Key-encrypt test passed"
else
    echo "${bold}2: Key-encrypt test failed${normal}"
    exit 1
fi

key-decrypt
if [ $? ]; then
    echo "3: Key-decrypt test passed"
else
    echo "${bold}3: Key-decrypt test failed${normal}"
    exit 1
fi

attach
if [ $? ]; then
    echo "4: Attach+decrypt test passed"
else
    echo "${bold}4: Attach+decrypt test failed${normal}"
    exit 1
fi


decrypt-wrong
if [ $? != 0 ]; then
    echo "5: Wrong-password test passed"
else
    echo "${bold}5: Wrong-passed test failed${normal}"
    exit 1
fi

decrypt-duress
if [ $? != 0 ]; then
    echo "6: Duress-password test passed"
else
    echo "${bold}6: Duress-password test failed${normal}"
    exit 1
fi

decrypt-after
if [ $? != 0 ]; then
    echo "7: Decrypt after duress test passed"
else
    echo "${bold}7: Decrypt after duress test failed${normal}"
    exit 1
fi

rm key enc.kcrypt

encrypt
if [ $? ]; then
    echo "8: Encrypt/decrypt test passed"
else
    echo "${bold}8: Encrypt/decrypt test failed${normal}"
    exit 1
fi

exit 0
