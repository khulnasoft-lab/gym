#!/bin/bash
function cleanup() {
  xhost -local:root
  containers=$(docker container ls -f "name=demo" -aq)
  docker container stop "$containers"
  exit 1
}

function main() {
  xhost +local:root
  docker run --rm -it --gpus all --net host --privileged --env NVIDIA_DISABLE_REQUIRE=1 --name "demo" --shm-size 64g\
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw -e DISPLAY -e QT_X11_NO_MITSHM=1 \
  \
  -v /home/"${USER}"/ivy_gym:/ivy_gym \
  \
  -v /home/"${USER}"/ivy/ivy:/ivy/ivy \
  -v /home/"${USER}"/ivy_demo_utils/ivy_demo_utils:/demo-utils/ivy_demo_utils \
  -v /home/"${USER}"/ivy_builder/ivy_builder:/builder/ivy_builder \
  \
   ivydl/ivy-gym:latest python3 -m "${@:1}"
}

main "$@" || cleanup "$1"