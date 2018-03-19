#!/bin/sh

set -ue

rundir=$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)")
canonical="$rundir/$(basename -- "$0")"

if [ -n "${1:-}" ]; then
  cmd=$1
  shift
else
  cmd=build
fi

cd "$rundir"

###

build_docker(){
  docker build -f Dockerfile -t dply/postfix .
}

run_docker(){
  CID=$(docker run -d dply/postfix)
  echo $CID
}


###

run_help(){
  echo "Commands:"
  awk '/  ".*"/{ print "  "substr($1,2,length($1)-3) }' make.sh
}
set +x
case $cmd in
  "build")                  build_docker "$@";;
  "build:docker")           build_docker "$@";;
  "run")                    run_docker "$@";; 
  "run:docker")             run_docker "$@";; 

  '-h'|'--help'|'h'|'help') run_help;;
  *)                        $cmd "$@";;
esac

