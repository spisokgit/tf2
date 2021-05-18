FROM tensorflow/tensorflow:latest-gpu-jupyter

LABEL MAINTAINER="spisok@naver.com"
ENV TZ Asia/Seoul

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
WORKDIR /root
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt \
    && cp /usr/share/fonts/truetype/nanum/*.* /usr/local/lib/python3.6/dist-packages/matplotlib/mpl-data/fonts/ttf
WORKDIR /tf
CMD ["source","/etc/bash.bashrc","&&","jupyter","notebook","--notebook-dir=/tf","--ip","0.0.0.0","--no-browser","--allow-root","--debug"]
