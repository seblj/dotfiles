#!/bin/bash
languages=`echo "golang lua c typescript python" | tr ' ' '\n'`
core_utils=`echo "xargs find" | tr ' ' '\n'`

selected=`printf "$languages\n$core_utils" | fzf`
read -p "query: " query

if printf $languages | grep -qs $selected; then
    curl cht.sh/$selected/`echo $query | tr ' ' '+'`
else
    curl cht.sh/$selected/`echo $query | tr ' ' '~'`
fi
