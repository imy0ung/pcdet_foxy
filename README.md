# ROS2 Foxy + Ubuntu 20.04 (GPU + RViz2 GUI 지원)

```bash
docker build -t ros2-foxy-focal:gpu .
xhost +local:root
docker run --rm -it \
  --gpus all \
  -e NVIDIA_VISIBLE_DEVICES=all \
  -e DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v "$PWD":/workspace \
  -v "$PWD/pcdet_ws":/pcdet_ws \
  ros2-foxy-focal:gpu
