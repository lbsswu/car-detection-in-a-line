require 'sketchup.rb'
UI.menu("PlugIns").add_item("Rotate and Capture") { capt }
$eye = nil
$target = nil
$up = nil

def capt
	$target = Geom::Point3d.new(0,0,0);
    $up = Geom::Vector3d.new(0, 0, 1)
    pan = 0;
    tilt = 0;
    distance = 500;
    first = 1;	
    while pan < 360
	  tilt = 0
	  while tilt < 70
	  rTilt= tilt;
	  rPan = pan;
	  $x = $target.x+distance * Math::cos(rTilt*Math::PI / 180.0) * Math::cos(rPan* Math::PI / 180.0)
	  $y = $target.y+distance * Math::cos(rTilt* Math::PI / 180.0) * Math::sin(rPan* Math::PI / 180.0)
	  $z = $target.z+distance * Math::sin(rTilt* Math::PI / 180.0)
	  $eye = Geom::Point3d.new($x, $y, $z)
	  showImg
	  view = Sketchup.active_model.active_view
	  view.show_frame
	  filename = rTilt.to_s + "_" + rPan.to_s + ".bmp"
	  path = "E:\\su_ruby\\matrix\\" + distance.to_s + "\\"
      view.write_image path+filename,1600,1200
	  if first == 1
		tilt = tilt
	  else
		tilt = tilt + 15
	  end
          first = 0
	  view.camera.perspective = true;
	  end
	  pan = pan + 30
	end
end

def showImg
    cam = Sketchup.active_model.active_view.camera
	cam.perspective=false;
	cam.focal_length = 70
	cam.set($eye, $target, $up)
end