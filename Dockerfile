FROM osrf/ros:galactic-desktop

RUN echo "hi"

RUN apt-get update \
    && apt-get install -y curl \
    && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - \
    && apt-get update \
    && apt install -y python3-colcon-common-extensions \
    && apt-get install -y ros-${ROS_DISTRO}-navigation2 \
    && apt-get install -y ros-${ROS_DISTRO}-robot-localization \
    && apt-get install -y ros-${ROS_DISTRO}-robot-state-publisher \
    && apt install -y ros-${ROS_DISTRO}-perception-pcl \
  	&& apt install -y ros-${ROS_DISTRO}-pcl-msgs \
  	&& apt install -y ros-${ROS_DISTRO}-vision-opencv \
  	&& apt install -y ros-${ROS_DISTRO}-xacro \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt install -y software-properties-common \
    && add-apt-repository -y ppa:borglab/gtsam-release-4.1 \
    && apt-get update \
    && apt install -y libgtsam-dev libgtsam-unstable-dev \
    && apt install -y libgeographic-dev \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

RUN mkdir -p ~/liorf-ros2/src \
    && cd ~/liorf-ros2/src \
    && git clone --branch liorf-ros2 https://github.com/Fabulani/liorf.git \
    && cd .. \
    && source /opt/ros/${ROS_DISTRO}/setup.bash \
    && colcon build

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /root/.bashrc \
    && echo "source /root/liorf-ros2/install/setup.bash" >> /root/.bashrc

WORKDIR /root/liorf-ros2
