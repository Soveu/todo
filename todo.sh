#!/bin/bash

file="$HOME/.todolist"
tmp=""

usage(){
	cat <<EOF
Usage: todo [OPTION] ARG

Options:
     help 		this message
     add		add ARG to todolist
     delete		delete ARG from todolist - can be entry number or regex
     list		lists entries from todolist
EOF
}

list(){
	local count=1
	while IFS= read -r line; do
		printf '%d: %s\n' $count "$line" 
		((count++))
	done
}

delNum(){
	local count=0
	while IFS= read -r line; do
		((count++))
		[[ $count -eq $1 ]] && continue
		printf '%s\n' "$line"
	done
}

case $1 in
	'list') 
		list < "$file";;
	'delete') 
		case $2 in
			''|*[!0-9]*) 
				tmp="`grep --invert-match --ignore-case "$2" < "$file"`";;
			*) 
				tmp="`delNum $2 < "$file"`";;
		esac
		echo "$tmp" > "$file";;
	'add')
		echo "$@" | cut -d ' ' -f 2- >> "$file";;
	*)
		usage
esac

