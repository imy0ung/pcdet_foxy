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
```

```bash
# docker 등록
sudo nvidia-ctk runtime configure --runtime=docker 

# 확인
sudo docker run --rm --gpus all nvidia/cuda:11.8.0-base-ubuntu22.04 nvidia-smi
```
