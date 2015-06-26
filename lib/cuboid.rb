class Cuboid
  attr_reader :origin, :dimension
  
  def initialize(x,y,z,l,w,h)
  	#Create a new cuboid with x,y,z as the ORIGIN coordinates and l,w,h as the DIMENSIONS from the origin.
  	#Note that l is dimension along x axis, w along y axis, and h along z axis

    #Exclude cuboids with negative coordinates (assume 0,0,0 is bottom corner of holding bin)
    #Exclude cuboids that are really 2D planes, lines, or points -- with one or more dimensions of 0
  	#Exclude cuboids with non-numeric inputs
    if x<0 || y<0 || z<0 || l<=0 || w<=0 || h<=0 || !(x.is_a? Numeric) || !(y.is_a? Numeric) || !(z.is_a? Numeric) || !(l.is_a? Numeric) || !(w.is_a? Numeric) || !(h.is_a? Numeric) 
	    raise ArgumentError.new("Origin and dimensions must all be positive numbers")
	  else
		  @origin = {:x => x, :y => y, :z => z}
	  	@dimension = {:x => l, :y => w, :z => h}
    end

	  rescue
	  	puts "Please make sure origin and dimensions of the new cuboid are all positive numbers"
  end

  def move_to!(x, y, z)
    if x<0 || y<0 || z<0 || !(x.is_a? Numeric) || !(y.is_a? Numeric) || !(z.is_a? Numeric)
      raise ArgumentError.new("New origin coordinates must all be positive numbers")
    else
    	#Reset the origin hash to the new coordinates x, y and z
    	@origin = {:x => x, :y => y, :z => z}
    end

    rescue
      puts "Please make sure new origin coordinates are positive numbers"
  end
  
  def vertices
  	#Each cuboid has 8 vertices, which are named v0, v1, v2 through v7
  	#v0 is the ORIGIN
  	#v1, v2 and v3 proceed clockwise around the base (bottom) plane of the cuboid (i.e., Y of each vertex = origin Y)
  	#v4 is directly above the origin in the Y axis, and v5, v6 and v7 proceed clockwise around the upper (top) plane of the cuboid

  	v0 = {:x => @origin[:x],
  		    :y => @origin[:y], 
  		    :z => @origin[:z]}

  	v1 = {:x => @origin[:x]+@dimension[:x],
  		    :y => @origin[:y],
  		    :z => @origin[:z]}

  	v2 = {:x => @origin[:x]+@dimension[:x],
  		    :y => @origin[:y],
  		    :z => @origin[:z]+@dimension[:z]}

  	v3 = {:x => @origin[:x],
  	   	  :y => @origin[:y],
 	   	    :z => @origin[:z]+@dimension[:z]}

  	v4 = {:x => @origin[:x],
  		    :y => @origin[:y]+@dimension[:y],
  		    :z => @origin[:z]}

  	v5 = {:x => @origin[:x]+@dimension[:x],
  		    :y => @origin[:y]+@dimension[:y],
  		    :z => @origin[:z]}

  	v6 = {:x => @origin[:x]+@dimension[:x],
  		   :y => @origin[:y]+@dimension[:y],
  		    :z => @origin[:z]+@dimension[:z]}

  	v7 = {:x => @origin[:x],
  		    :y => @origin[:y]+@dimension[:y],
  		    :z => @origin[:z]+@dimension[:z]}

  	@vertices = [v0,v1,v2,v3,v4,v5,v6,v7]
  end

  def intersects?(other)
    #returns true if the two cuboids intersect each other.  False otherwise.

	 	#Make sure that 'other' argument is actually an instance of Cuboid
  	if !other.instance_of? Cuboid 
  	  raise ArgumentError.new("Argument for intersects method is not Cuboid instance")
  	else
	  	this_cuboid = self
	  	other_cuboid = other

	  	#Need to check whether LOWER edge of one cuboid -- in each plane (x,y,z) -- is within the other cuboid
	  	#And need to test each cuboid against the other, as we don't know which one is "higher" or "lower" in space

	  	if inside_3D?(this_cuboid,other_cuboid) || inside_3D?(other_cuboid,this_cuboid)
	  		intersecting = true #if there is intersection either way, then return true
	  	else
	  		intersecting = false #two cuboids are only clear of each other if testing both ways returns false (i.e., no intersection)
	  	end

	  	intersecting
	  end

		rescue
			puts "You cannot compare apples-to-oranges, or cuboids to non-cuboids... There is problem with call to intersects? method"
  end

  def rotate(axis)
    #Using the assumption that each cuboid is "pushed" against 3 solid walls at its origin vertix (v0) and that once it rotates it again gets "pushed" back against the solid walls at the origin.  If real boxes were packed in a larger bin, with gravity and the desire to optimize space, this assumption seems reasonable.
    #Also using the symmetry of a rectangular shape and 90 degree rotations, there are only 3 different options -- rotating around each axis (X, Y or Z) 90 degrees.  A single 90 degree rotation to the "left" or "right" (or "up" or "down") results in the same new cuboid.  Two rotations of 90 degrees leads to a 180 degree reversal and a cuboid with the same location as its original state.
    #Input for this method is an axis around which to rotate 90 degrees, either "x" or "y" or "z"
    #Output is a new set of dimenions for the cuboid.  My assumption is the origin following any rotation remains the same.

    axis = axis.upcase #Handle lower case argument

    if axis === "X"
      #For a 90 degree rotation around X axis, X dimension remains the same. Y and Z dimensions swap.
      swapper = @dimension[:y]
      @dimension[:y] = @dimension[:z]
      @dimension[:z] = swapper
    elsif axis === "Y"
      #For a 90 degree rotation around Y axis, Y dimension remains the same. X and Z dimensions swap.
      swapper = @dimension[:x]
      @dimension[:x] = @dimension[:z]
      @dimension[:z] = swapper
    elsif axis === "Z"
      #For a 90 degree rotation around Z axis, Z dimension remains the same. X and Y dimensions swap.
      swapper = @dimension[:x]
      @dimension[:x] = @dimension[:y]
      @dimension[:y] = swapper
    else
      raise ArgumentError.new("Axis for rotation has to be X Y or Z")
    end

    rescue
      puts "Rotation has to be around the X or Y or Z axis."
  end

private

	def inside_3D?(primary,comparison)
	  #Input is 2 cuboid objects
	  #Output is TRUE if any vertex of primary cuboid falls inside the comparison cuboid, and false otherwise

	  #Store vertices for each cuboid. Call method once for each, rather than multiple times
	  primary_vertices = primary.vertices
	  comparison_vertices = comparison.vertices

	  #Get data for X axis
	  primary_x = primary_vertices[0][:x]
	  comparison_lower_x = comparison_vertices[0][:x]
	  comparison_upper_x = comparison_vertices[6][:x] #v6 will always be the farthest from the origin, diagonally across cuboid

	  #Then Y axis
	  primary_y = primary_vertices[0][:y]
	  comparison_lower_y = comparison_vertices[0][:y]
	  comparison_upper_y = comparison_vertices[6][:y]

	  #Then Z axis
	  primary_z = primary_vertices[0][:z]
	  comparison_lower_z = comparison_vertices[0][:z]
	  comparison_upper_z = comparison_vertices[6][:z]

    #Compare primary cuboid lower point against lower-to-upper range of comparison cuboid on all 3 axes
    #If primary vertex is "inside" comparison cuboid on all 3 dimensions, then there is intersection
	  if inside_linear?(primary_x, comparison_lower_x, comparison_upper_x) && inside_linear?(primary_y, comparison_lower_y, comparison_upper_y) && inside_linear?(primary_z, comparison_lower_z, comparison_upper_z)
	  		inside_3D = true
	  	else 
	  		inside_3D = false
	  end

	  inside_3D
	end

	def inside_linear?(point,lower,upper)
	 #Input is 1 point and 2 bounds
	 #Output is TRUE if point is inside the bounds or FALSE if point is outside the bounds
	 #Point touching (equal to) either boundary returns false. If, in reality, two boxes touching creates problems or if some 'buffer space' is needed so that things fit in practice, then shift this to >= and <= 

	 if point > lower && point < upper
	 	inside_linear = true
	 else 
	 	inside_linear = false
	 end

	 inside_linear
	end

end #End of Cuboid class