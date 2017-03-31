FROM ubuntu:16.04

RUN	apt-get update

RUN	apt-get install -y curl && \
	apt-get install -y git && \
	apt-get install -y less && \
	apt-get install -y vim && \
	apt-get install -y vim-common && \
	apt-get install -y tar && \
	apt-get install -y zip && \
	apt-get install -y unzip

RUN	apt-get update

RUN	apt-get install -y build-essential && \
 	apt-get install -y apt-utils && \
	apt-get install -y automake && \
	apt-get install -y cmake && \
	apt-get install -y libprotobuf-dev && \
	apt-get install -y gcc && \
	apt-get install -y gcc-4.9 && \
	apt-get install -y gcc-4.8 && \
	apt-get install -y g++ && \
	apt-get install -y g++-4.9 && \
	apt-get install -y g++-4.8 && \
	apt-get install -y gcc-multilib && \
	apt-get install -y libgomp1 && \
	apt-get install -y pkg-config && \
	apt-get install -y sphinx-common && \
	apt-get install -y gfortran 
	
RUN	apt-get install -y yasm  && \
	apt-get install -y libxext-dev  && \
	apt-get install -y libfreetype6-dev  && \
	apt-get install -y libsdl2-dev  && \
	apt-get install -y libtheora-dev  && \
	apt-get install -y libtool  && \
	apt-get install -y libva-dev  && \
	apt-get install -y libvdpau-dev  && \
	apt-get install -y libvorbis-dev  && \
	apt-get install -y libxcb1-dev  && \
	apt-get install -y libxcb-shm0-dev  && \
	apt-get install -y libxcb-xfixes0-dev  && \
	apt-get install -y zlib1g-dev 

RUN 	apt-get install -y libgtk-3-dev && \
	apt-get install -y libavcodec-dev && \
	apt-get install -y libavformat-dev && \
	apt-get install -y libavutil-dev

RUN	apt-get install -y libswscale-dev && \
	apt-get install -y libtbb2 && \
	apt-get install -y libtbb-dev && \
	apt-get install -y libjpeg-dev && \
	apt-get install -y libpng-dev && \
	apt-get install -y libtiff-dev && \
	apt-get install -y libjasper-dev 

RUN	apt-get install -y libavcodec-dev && \	
	apt-get install -y libavformat-dev
	
RUN	apt-get install -y wget

RUN	apt-get install -y libblas-dev && \
	apt-get install -y liblapack-dev && \
	apt-get install -y libdc1394-22-dev && \
   	apt-get install -y libxine2-dev && \
	apt-get install -y libgstreamer0.10-dev && \
	apt-get install -y libgstreamer-plugins-base0.10-dev && \
	apt-get install -y libmp3lame-dev && \
	apt-get install -y libtheora-dev && \
	apt-get install -y libvorbis-dev && \
	apt-get install -y libxvidcore-dev && \
	apt-get install -y x264 && \
	apt-get install -y ffmpeg

RUN	apt-get install -y libreadline-dev && \
	apt-get install -y readline-common 
	
RUN	apt-get install -y libv4l-dev && \
	apt-get install -y libv4lconvert0 && \
	apt-get install -y libv4l-0 && \
	apt-get install -y v4l-utils && \
	apt-get install -y v4l-conf && \
        apt-get install -y w3cam && \
	apt-get install -y libpng12-dev && \
	apt-get install -y libjpeg-dev && \
        apt-get install -y libfreeimage-dev  && \
	apt-get install -y libfreetype6-dev 

RUN	git clone https://github.com/opencv/opencv.git --branch 3.1.0    && \
	git clone https://github.com/opencv/opencv_contrib.git --branch 3.1.0 && \
	cd opencv && \
	mkdir build && \
	cd build && \
	cmake -DCMAKE_C_COMPILER=/usr/bin/gcc-4.8 -DCMAKE_CXX_COMPILER=/usr/bin/g++-4.8  -DBUILD_EXAMPLES=on -DCMAKE_INSTALL_PREFIX=/usr/local  DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules  ..  && \
	make && \
	make install && \
	cd .. && \
	cd .. 

