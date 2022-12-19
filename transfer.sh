#!/bin/bash
# 
CURRENT_VERSOIN="1.23.0"


httpSingleUpload() {
  
  echo "Uploading $1"
    response=$(curl -A curl -# --upload-file "$1" "https://transfer.sh/$2") || {
    echo "Failure!"
    return 1
  }
  echo "Transfer File URL: $response"

}


args_upload() {
  for file in "$@"; do
    #dir_name=$(dirname $file)
    file_name=$(basename "$file")
    if [[ ! -e "$file" ]]; then
      echo "$file: No such file"
    else
      httpSingleUpload "$file" "$file_name"
    fi
  done
}
single_download() {
  echo "Downloading $4"
  res=$(curl --create-dirs -# --write-out "%{http_code}\n" https://transfer.sh/"$3"/"$4" -o "$2/$4")
  if [[ "res" -ne 200 ]] ; then
  echo "Download error $res"
  return 1
  else echo "Success!"
  fi

}

if [ $# -eq 0 ]; then
  printf "No arguments specified.\nUsage:\ntransfer file1 file1 ... fileN \ntransfer file_name\n"
  exit 1
fi

case "${1}" in
  "-d")
    single_download "$@"
  ;;
  "-h")
    old_ifs=$IFS
    IFS='' read -r -d '' hlp_msg <<'EOF'
    Description: Bash tool to transfer files from the command line.
    Usage:
      -d  dounload path remote_folder local_file_name
      -h  Show this help 
      -v  Get the tool version
      <file1> <file1> ... <fileN> transfer files <file1> <file1> ... <fileN> to remote sever
    Examples:
    ./transfer.sh <file1> <file1> ... <fileN>
    ./transfer.sh -d ./test Mij6ca test.txt
EOF
  echo "$hlp_msg"
  IFS=$old_ifs
  ;;
  "-v")
    echo "$CURRENT_VERSOIN"
  ;;
  *)args_upload "$@"
  ;;
esac



