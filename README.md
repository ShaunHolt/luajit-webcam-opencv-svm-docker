
Web-cameras and luajit OpenCV SVM are implemented using Docker.


NOTICE1: Don't forget to run "xhost -" after Dokcer is done.

NOTICE2: The web camera code is based on https://github.com/clementfarabet/lua---camera.git

NOTICE3: OpenCV 3.1.0 is used.

NOTICE4: /dev/video1 is used for the web-camera.

NOTICE5: For the docker camera setup, please refer to https://github.com/chipgarner/opencv3-webcam-docker.git.


Please follow the instructions to run the examples.


[1] download (or git clone) this source code folder.

[2] cd downloaded-source-code-folder

[3] sudo make BIND_DIR=.  shell

	wait ... wait ... then a bash shell will be ready (root@7d657058933c:/#).

[4] root@7d657058933c:/# cd /home/camera/lua/

[5] root@f51793bb4ec6:/home/camera/lua# cd torch

[6] root@7d657058933c:/home/camera/lua/torch# ./clean.sh

[7] root@4679750d4acb:/home/camera/lua/torch# bash install-deps

[8] root@7d657058933c:/home/camera/lua/torch# ./install.sh

[9] type in yes [and enter]

[10] root@7d657058933c:/home/camera/lua/torch# source /root/.bashrc

[11] root@7d657058933c:/home/camera/lua/torch# cd ..

[12] root@7d657058933c:/home/camera/lua# luarocks install sys

[13] root@7d657058933c:/home/camera/lua# luarocks install xlua

[14] root@7d657058933c:/home/camera/lua# luarocks install image

[15] root@7d657058933c:/home/camera/lua# cd lua---camera

[16] root@7d657058933c:/home/camera/lua/lua---camera# luarocks make camera-1.1-0.rockspec

[17] root@7d657058933c:/home/camera/lua/lua---camera# cd ..

[18] root@7d657058933c:/home/camera/lua# cd example/

[19] root@b4deac659f02:/home/camera/lua/examples# luajit ./usb_camera_docker.lua

[20] root@f51793bb4ec6:/home/camera/lua# cd torch-opencv

[21] root@f51793bb4ec6:/home/camera/lua/torch-opencv# luarocks make 

[22] root@f51793bb4ec6:/home/camera/lua/torch-opencv# cd ..

[23] root@f51793bb4ec6:/home/camera/lua# cd examples

[23] root@f51793bb4ec6:/home/camera/lua/examples# luajit luajit_opencv_svm.lua


The luajit OpenCV SVM code is as follows.
	
	
	local cv = require 'cv'
	require 'cv.imgproc'
	require 'cv.imgcodecs'
	require 'cv.highgui'

	cv.ml = require 'cv.ml'

	local trainingDataMat = torch.FloatTensor(10, 90*120):zero()
	local labelsMat = torch.IntTensor(10):zero()

	local apples_dir = "./images/apples"
	local files = io.popen('find "'..apples_dir..'" -type f') 

	local index = 1
	for file in files:lines() do
	                        
       		print(file)
		
		local image = cv.imread{file, cv.IMREAD_GRAYSCALE}
		if image:nDimension() == 0 then
    			print('Problem loading image\n')
    			os.exit(0)	
		end
	
		local imageSize = {image:size()[2], image:size()[1]}
		print("		image size ", imageSize[2], imageSize[1])
	
		local scaleX = 0.125
		local scaleY = 0.125
	
		local dst = cv.resize{image, fx=scaleX, fy=scaleY, interpolation=cv.INTER_LINEAR}
	
		local dstSize = {dst:size()[2], dst:size()[1]}
		print("		dst size ", dstSize[2], dstSize[1])
	
		dst:resize( dstSize[2]*dstSize[1])
		print(dst:size())
	
		trainingDataMat[index] = dst:type('torch.FloatTensor')
		labelsMat[index] = 1
		index = index + 1
	
	end


	local oranges_dir = "./images/oranges"
	local files = io.popen('find "'..oranges_dir..'" -type f') 
	for file in files:lines() do
       		print(file)
		local image = cv.imread{file, cv.IMREAD_GRAYSCALE}
		if image:nDimension() == 0 then
    			print('Problem loading image\n')
    			os.exit(0)	
		end
	
		local imageSize = {image:size()[2], image:size()[1]}
		print("		image size ", imageSize[2], imageSize[1])

		local scaleX = 0.125
		local scaleY = 0.125
	
		local dst = cv.resize{image, fx=scaleX, fy=scaleY, interpolation=cv.INTER_LINEAR}
	
		local dstSize = {dst:size()[2], dst:size()[1]}
		print("		dst size ", dstSize[2], dstSize[1])
	
		dst:resize( dstSize[2]*dstSize[1])
		print(dst:size())

		trainingDataMat[index] = dst:type('torch.FloatTensor')
		labelsMat[index] = 2
		index = index + 1
	end

	print ("... trainingDataMat[{1,10}] = ", trainingDataMat[{1,10}])
	print ("... trainingDataMat[{6,10}] = ", trainingDataMat[{6,10}])
	

	local svm = cv.ml.SVM()
	svm:setType  		{cv.ml.SVM_C_SVC}
	svm:setKernel		{cv.ml.SVM_LINEAR}
	svm:setTermCriteria {cv.TermCriteria{cv.TermCriteria_MAX_ITER, 100, 1e-6}}

	--- Train the SVM ---
	svm:train{trainingDataMat, cv.ml.ROW_SAMPLE, labelsMat}

	--- test image ---
	local testDataMat = torch.FloatTensor(1, 90*120):zero()

	local apples_dir = "./images/testimage"
	local files = io.popen('find "'..apples_dir..'" -type f') 

	local index = 1
	file in files:lines() do
	                        
       		print(file)
		-- imgcodecs - imread
		local image = cv.imread{file, cv.IMREAD_GRAYSCALE}
		if image:nDimension() == 0 then
    			print('Problem loading image\n')
    			os.exit(0)	
		end
	
		local imageSize = {image:size()[2], image:size()[1]}
		print("		image size ", imageSize[2], imageSize[1])
	
		local scaleX = 0.125
		local scaleY = 0.125
	
		local dst = cv.resize{image, fx=scaleX, fy=scaleY, interpolation=cv.INTER_LINEAR}
	
		local dstSize = {dst:size()[2], dst:size()[1]}
		print("		dst size ", dstSize[2], dstSize[1])
	
		dst:resize( dstSize[2]*dstSize[1])
		print(dst:size())
	
		testDataMat[index] = dst:type('torch.FloatTensor')
		index = index + 1
	
	end

	local response = svm:predict{testDataMat }
	print ("... response = ", response)

	if response == 1 then
		print("prediction is correct")
	else
		print("prediction is NOT correct")
	end




