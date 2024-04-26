#!/bin/bash

shopt -s dotglob

input_dir=$1
output_dir=$2

if ! [[ $input_dir =~ /$ ]]; then
  input_dir="$input_dir/"
fi
if ! [[ $output_dir =~ /$ ]]; then
  output_dir="$output_dir/"
fi
if ! [[ -e "$input_dir" && -d "$input_dir" ]]; then
  echo "Input directory doesn't exist or is not a directory"
  exit 1
fi
if ! [[ -e "$output_dir" ]]; then
  mkdir "$output_dir"
fi

parse_dir () {
  dir=$1
  for entry in "$dir"*
  do
    if [ -f "$entry" ]; then
      copy_file "$entry"
    fi
    if [ -d "$entry" ]; then
      parse_dir "$entry/"
    fi
  done
}

copy_file () {
  file_path=$1
  [[ $file_path =~ /([^/]+)$ ]] && file_name=${BASH_REMATCH[1]}
  postfix=""
  i=0
  while [ -e "$output_dir$file_name$postfix" ]
  do
    i=$((i + 1))
    if [ $i -gt 1000 ]; then
      echo "Cannot copy file $file_path: Too much files with that name already exist in the output directory"
      return
    fi
    postfix=".$i"
  done
  cp "$file_path" "$output_dir$file_name$postfix"
}

parse_dir "$input_dir"
