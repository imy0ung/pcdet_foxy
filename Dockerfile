FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Seoul \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# 기본 도구
RUN apt-get update && apt-get install -y --no-install-recommends \
    locales tzdata ca-certificates gnupg2 curl wget \
    lsb-release software-properties-common \
    build-essential git \
    python3 python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/*

# 로케일/타임존
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

# ROS2 Foxy 저장소/키 등록
RUN add-apt-repository universe && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
      -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    sh -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
    http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/ros2.list'

# ROS2 Foxy 설치 (desktop: rviz2 포함)
RUN apt-get update && apt-get install -y --no-install-recommends \
      ros-foxy-desktop \
      python3-rosdep python3-argcomplete \
      python3-colcon-common-extensions \
    && rm -rf /var/lib/apt/lists/*

# rosdep 초기화 (컨테이너 환경에 따라 init는 이미 되어있을 수 있어 || true)
RUN rosdep init || true && rosdep update || true

# 편의: 셸 진입 시 자동 source
RUN bash -lc 'echo "source /opt/ros/foxy/setup.bash" >> /root/.bashrc'

# 워크스페이스 기본 디렉터리
WORKDIR /ros2_ws/src

CMD ["/bin/bash"]

