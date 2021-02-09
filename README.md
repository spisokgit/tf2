## tf2의 Dockerfile
docker image tensorflow/tensorflow:latest-gpy-jupyter 개선
* 1. jupyter 자동완성기능이 되지 않아 jedi 설치
* 2. opencv-python 설치하기 위한 build
* 3. requirements.txt 설치
### 실행명령어
* git clone https://github.com/spisokgit/tf2.git
* docker build --rm -t image_name .
### 빌드 완성 docker image link 및 pull 
* https://hub.docker.com/repository/docker/spisok/tf2
* docker pull spisok/tf2:gpu-jupyter-cv


