## ubuntu host에 3가지 설치 : 1. nvidia driver   2. docker 19.03이상   3. nvidia container toolkit 
* nvidia driver
```
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get install -y ubuntu-drivers-common
sudo ubuntu-drivers autoinstall
sudo reboot
nvidia-smi
```
* docker version 19.03이상 : 공식홈참조 https://docs.docker.com/engine/install/ubuntu/
```
sudo apt-get update && sudo apt-get install docker.io
(curl -sSL https://get.docker.com | sh)
```
* nvidia container toolkit 공식홈참조 https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker
```
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - 
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit 
sudo systemctl restart docker
sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```
## tf2의 Dockerfile를 이용한 build
docker image tensorflow/tensorflow:latest-gpy-jupyter 개선한 내용
* jupyter 자동완성기능이 되지 않아 jedi 설치
* opencv-python 설치하기 위한 build
* requirements.txt 설치
### docker build 
* git clone https://github.com/spisokgit/tf2.git
* docker build --rm -t image_name .
## 빌드 완성 docker image link 및 pull, 실행 example
* https://hub.docker.com/repository/docker/spisok/tf2
* docker pull spisok/tf2:gpu-jupyter-cv2
* host 작업폴더($PWD)로 이동 ( container와 폴더 공유하기 위해 )
* docker run --gpus all -v "$PWD":/tf -p 9999:8888 -p 6006:6006 --name tf2 spisok/tf2:gpu-jupyter-cv2
* host timezone과 같이 맞추어 주고 싶을 경우 아래 (host timezone 설정 : https://www.lesstif.com/lpt/ubuntu-linux-timezone-setting-61899162.html )
* docker run --gpus all -v "$PWD":/tf -v /etc/localtime:/etc/localtime:ro -e TZ=Asia/Seoul -p 9999:8888 -p 6006:6006 --name tf2 spisok/tf2:gpu-jupyter-cv2
## jupyter 또는 container 에서 gpu 확인
* localhost:9999로 접속하여 token 입력 또는 token password로 변경
```
import tensorflow
print(tensorflow.__version__)
from tensorflow.python.client import device_lib
print(device_lib.list_local_devices())
```
## 필요 python package 설치 install 방법
* jupyter 실행후 
* !pip install package
* 
## docker container service 등록 
* cd /etc/systemd/system 또는 /usr/lib/systemd/system
* vi [설정한 서비스].service
```[Unit]
Wants=docker.service
After=docker.service
[Service]
RemainAfterExit=yes
ExecStart=/usr/bin/docker start [실행할 docker container 이름]
ExecStop=/usr/bin/docker stop [실행할 docker container 이름]
[Install]
WantedBy=multi-user.target
```
* systemctl start [설정한 서비스] → 서비스를 시작
* systemctl enable [설정한 서비스] → 부팅시 실행할 수 있도록 해당 서비스 활성화
