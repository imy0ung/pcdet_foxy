# === Ubuntu 20.04 + ROS2 Foxy + GPU(CUDA 11.8) ===
FROM nvidia/cuda:11.8.0-devel-ubuntu20.04
ENV DEBIAN_FRONTEND=noninteractive TZ=Asia/Seoul LANG=C.UTF-8
# 0) 기본 도구 + GUI용 mesa-utils
RUN apt-get update && apt-get install -y --no-install-recommends \
    locales tzdata curl wget gnupg2 ca-certificates lsb-release git \
    build-essential cmake python3 python3-pip python3-venv \
    python3-colcon-common-extensions \
    mesa-utils software-properties-common \
 && rm -rf /var/lib/apt/lists/*
# 1) ROS2 저장소/키 + Foxy 설치
RUN add-apt-repository universe && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
      -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    sh -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
      http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" \
      > /etc/apt/sources.list.d/ros2.list' && \
    apt-get update && apt-get install -y --no-install-recommends \
      ros-foxy-desktop python3-rosdep python3-vcstool \
 && rosdep init || true
# 2) requirements.txt 설치 (경로 지정 가능: --build-arg REQ_PATH=...)
ARG REQ_PATH=requirements.txt
COPY ${REQ_PATH} /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt && rm -f /tmp/requirements.txt
# 3) pcdet_ws/src 기본 생성
RUN mkdir -p /opt/pcdet_ws/src
WORKDIR /opt/pcdet_ws
# 4) 편의: 자동 source (WS가 빌드되어 있으면 자동 로드)
RUN echo "source /opt/ros/foxy/setup.bash" >> /root/.bashrc && \
    echo "[ -f /opt/pcdet_ws/install/setup.bash ] && source /opt/pcdet_ws/install/setup.bash" >> /root/.bashrc
# 5) GPU/GUI 환경 변수
ENV NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics \
    QT_X11_NO_MITSHM=1
SHELL ["/bin/bash", "-lc"]
CMD ["/bin/bash"]
