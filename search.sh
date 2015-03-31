#!/bin/bash

usage() {
  cat <<EOT
  \$ ./`basename $0` SEARCH_VARIABLE
EOT
  exit 1
}
if [ "$#" -eq "0" ]; then
  usage
  exit 1
fi
TARGET=$1

main() {
  TARGET=$1
  if echo ${TARGET:?} | grep "\[" | grep "\]" >/dev/null 2>&1; then
    for FILE in *.env
    do
      . ${FILE:?}
    done
    eval ANS=\$$TARGET
    echo ${TARGET:?}=${ANS:?}
  else
    cat *.env                             |
      sed "s/\${\([^}][^}]*\)}/\$(\1)/g"  |
      cat > Makefile
    cat <<EOT >> Makefile

search:
	@echo ${TARGET:?}=\$(${TARGET:?})

EOT
    make search
  fi
}

main ${TARGET:?}
