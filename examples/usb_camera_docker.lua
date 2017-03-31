require 'torch'
require 'sys'
require 'camera'
width  = 960
height = 720
fps = 1
dir = "web_camera_images"

sys.execute(string.format('mkdir -p %s',dir))

--/dev/video1
local camera1 = image.Camera{idx=1,width=width,height=height,fps=fps}

local f = 1
local max_f = 2

while f < max_f do
   sys.tic()
   local webcam = camera1:forward()
   
   image.savePNG(string.format("%s/frame_1_%05d.png",dir,f),webcam)
   f = f + 1
   print("FPS: ".. 1/sys.toc()) 
end

