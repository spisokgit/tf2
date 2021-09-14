FROM tensorflow/tensorflow:latest-gpu-jupyter

LABEL MAINTAINER="spisok@naver.com"
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV TZ Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /root
RUN apt-get update --fix-missing \
    && apt-get install -y fonts-nanum \
    && apt-get install -y cmake git libgl1-mesa-glx libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get update --fix-missing \
    && apt-get install -y python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev \
    && rm -rf /var/lib/apt/lists/*
RUN pip install --upgrade pip
RUN git clone https://github.com/jasperproject/jasper-client.git jasper \ 
    && chmod +x jasper/jasper.py \ 
    && pip install --upgrade setuptools \ 
    && pip install -r jasper/client/requirements.txt
RUN git clone https://github.com/opencv/opencv.git 
WORKDIR /root/opencv    
RUN mkdir build
WORKDIR /root/opencv/build
RUN ["cmake", "-D", "CMAKE_BUILD_TYPE=Release", "-D", "CMAKE_INSTALL_PREFIX=/usr/local", ".."]
RUN make
COPY ./requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt \
    && cp /usr/share/fonts/truetype/nanum/*.* /usr/local/lib/python3.6/dist-packages/matplotlib/mpl-data/fonts/ttf

# setup user and group ids
# ARG USER=sin
# ARG USER_ID=1000
# ARG GROUP_ID=1000
# ENV USER_ID $USER_ID
# ENV GROUP_ID $GROUP_ID

# add non-root user and give permissions to workdir
# RUN groupadd --gid $GROUP_ID $USER && \
#           adduser $USER --ingroup $USER --gecos '' --disabled-password --uid $USER_ID && \
#           mkdir -p /usr/src && \
#           chown -R $USER:$USER /usr/src

# set working directory
# WORKDIR /usr/src

# switch to non-root user
# USER $USER

# root
CMD ["source","/etc/bash.bashrc","&&","jupyter","notebook","--notebook-dir=/usr/src","--ip","0.0.0.0","--no-browser","--allow-root","--debug"]

# user
# CMD ["jupyter","notebook","--notebook-dir=/usr/src","--ip","0.0.0.0","--no-browser","--allow-root","--debug"]
