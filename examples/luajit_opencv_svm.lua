
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
print ("... labels = ", labelsMat)

-- Set up SVM's parameters
local svm = cv.ml.SVM()

--CvSVM::C_SVC, CvSVM::NU_SVC, CvSVM::ONE_CLASS, CvSVM::EPS_SVR, CvSVM::NU_SVR  
svm:setType  		{cv.ml.SVM_C_SVC}

--CvSVM::LINEAR, CvSVM::POLY, CvSVM::RBF, CvSVM::SIGMOID
svm:setKernel		{cv.ml.SVM_LINEAR}

--degree – Parameter degree of a kernel function (POLY).
--svm:setDegree 		{2}

--term_crit – Termination criteria of the iterative SVM training procedure which solves a partial case of constrained quadratic optimization problem. You can specify tolerance and/or the maximum number of iterations.
--TermCriteria (int type, int maxCount, double epsilon)
svm:setTermCriteria {cv.TermCriteria{cv.TermCriteria_MAX_ITER, 100, 1e-6}}

--- Train the SVM ---
svm:train{trainingDataMat, cv.ml.ROW_SAMPLE, labelsMat}

--- test image ---

local testDataMat = torch.FloatTensor(1, 90*120):zero()

local test_dir = "./images/testimage"
local files = io.popen('find "'..test_dir..'" -type f') 

local index = 1
for file in files:lines() do
	                        
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

--local sv = svm:getSupportVectors()

