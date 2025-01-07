# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set the maintainer (optional but good practice)
LABEL maintainer="Ethan M (22knc5@queensu.ca)"

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
	astyle \
	build-essential \
	ccache \
	cmake \
	cppcheck \
	file \
	g++ \
	gcc \
	gdb \
	git \
	lcov \
	libssl-dev \
	libxml2-dev \
	libxml2-utils \
	make \
	ninja-build \
	python3 \
	python3-dev \
	python3-pip \
	python3-setuptools \
	python3-wheel \
	rsync \
	shellcheck \
	unzip \
	zip \
    ca-certificates \
    gnupg \
    gosu \
    lsb-release \
    software-properties-common \
    sudo \
    wget \
    nano \
    vim \
        lsb-release \
        build-essential \
        software-properties-common \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# Ros shi
#RUN apt update && apt install -y locales && \
#    locale-gen en_US en_US.UTF-8 && \
#    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
#    export LANG=en_US.UTF-8 && \
#    apt install -y software-properties-common && \
#    add-apt-repository universe && \
#    apt update && apt install -y curl && \
#    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
#    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
#    apt update && apt upgrade -y && \
#    apt install -y ros-humble-desktop ros-dev-tools && \
#    echo "source /opt/ros/humble/setup.bash" >> /etc/bash.bashrc

WORKDIR /home/hawk

# Copy files in the same directory into the container
COPY . .

# Run the setup for PX4
RUN git clone https://github.com/PX4/PX4-Autopilot.git --recursive 

# Install Python dependencies from the requirements file
RUN pip3 install --no-cache-dir -r requirements.txt


# Create a non-root user for security
RUN useradd -m hawk && \
    echo "hawk:tuah" | chpasswd && \
    usermod -aG sudo hawk


RUN chown -R hawk:hawk /home/hawk

RUN chmod +x /home/hawk/PX4-Autopilot/Tools/setup/ubuntu.sh

RUN /home/hawk/PX4-Autopilot/Tools/setup/ubuntu.sh

USER hawk

CMD ["bash"]
