## ubunt host에 3가지 설치 : 1. nvidia driver   2. docker 19.03이상   3. nvidia container toolkit 
* docker 19.03이상 : 공식홈참조 : https://docs.docker.com/engine/install/ubuntu/
```
  sudo apt-get update && sudo apt-get install docker.io
  (curl -sSL https://get.docker.com | sh)
```
* nvidia driver
```
    sudo add-apt-repository ppa:graphics-drivers/ppa
    sudo apt update
    sudo ubuntu-drivers autoinstall
    sudo reboot
```
* nvidia container toolkit 공식홈참조 https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker
```
  curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - 
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
  curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
  sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit 
```

## tf2의 Dockerfile
docker image tensorflow/tensorflow:latest-gpy-jupyter 개선
* jupyter 자동완성기능이 되지 않아 jedi 설치
* opencv-python 설치하기 위한 build
* requirements.txt 설치
### 실행명령어
* git clone https://github.com/spisokgit/tf2.git
* docker build --rm -t image_name .
### 빌드 완성 docker image link 및 pull, 실행 example
* https://hub.docker.com/repository/docker/spisok/tf2
* docker pull spisok/tf2:gpu-jupyter-cv
* docker run --gpus all -v "$PWD":/tf -p 9999:8888 -p 6006:6006 --name tf2 spisok/tf2:gpu-jupyter-cv bash -c "source /etc/bash.bashrc && jupyter notebook --notebook-dir=/tf --ip 0.0.0.0 --no-browser --allow-root --debug"

### 설치후 확인
```
    import tensorflow
    tensorflow.__version__
    from tensorflow.python.client import device_lib
    device_lib.list_local_devices()
```
