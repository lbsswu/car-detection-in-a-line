require 'sketchup.rb'
UI.menu("PlugIns").add_item("System Experiments") { exp_sys }
$eye = nil
$target = nil
$up = nil

def exp_sys
	$target = Geom::Point3d.new(0,0,0);
    $up = Geom::Vector3d.new(0, 0, 1)

	# Change respect distance  
	vec = Geom::Vector3d.new(-45, 0 , 0) 
	tr = Geom::Transformation.translation( vec ) 
	# assume a single Group is selected 
	entity = Sketchup.active_model.selection[0] 
	# move from current position to one a new position described by the 
	# vector 
	entity.transform!( tr )
	
    shift_dis = 10
	while shift_dis <= 70	# Iterate the shift distance. range: 10~210
		relative_dis = 0
		while relative_dis <= 90	# Iterate the relative distance. range: 0~180
			distance = 700;
			while distance <= 2100	# Iterate distance. range: 700~2100
				pan = 0;
				first = 1;	
				while pan < 360	# Iterate pan angle. range: 0~360
					tilt = 0
					while tilt <= 50	# Iterate tilt angle. range: 0~50
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
						path = "E:\\su_ruby\\exp_sys\\" + shift_dis.to_s + "\\" + relative_dis.to_s + "\\" + distance.to_s + "\\"
						if distance <= 1100 then
							view.write_image path+filename,800,600
						else
							view.write_image path+filename,1200,900
						end
						if first == 1
							tilt = tilt
						else
							tilt = tilt + 10
						end
						first = 0
						view.camera.perspective = true;
					end
					pan = pan + 30
				end
				if distance <= 900 then
					distance = distance + 200
				elsif distance <= 1400 then
					distance = distance + 300
				else
					distance = distance + 400
				end
			end
			relative_dis = relative_dis + 15
			
			# Change respect distance  
			vec = Geom::Vector3d.new(15, 0 , 0) 
			tr = Geom::Transformation.translation( vec ) 
			# assume a single Group is selected 
			entity = Sketchup.active_model.selection[0] 
			# move from current position to one a new position described by the 
			# vector 
			entity.transform!( tr )
			
		end
		shift_dis = shift_dis + 10
		
		# Move back to source position
			vec = Geom::Vector3d.new(-90, 0 , 0) 
			tr = Geom::Transformation.translation( vec ) 
			# assume a single Group is selected 
			entity = Sketchup.active_model.selection[0] 
			# move from current position to one a new position described by the 
			# vector 
			entity.transform!( tr )
			
		# Change shift distance  
			vec = Geom::Vector3d.new(0, 10 , 0) 
			tr = Geom::Transformation.translation( vec ) 
			# assume a single Group is selected 
			entity = Sketchup.active_model.selection[0] 
			# move from current position to one a new position described by the 
			# vector 
			entity.transform!( tr )
			
	end
end

def showImg
    cam = Sketchup.active_model.active_view.camera
	cam.perspective=false;
	cam.focal_length = 70
	cam.set($eye, $target, $up)
end