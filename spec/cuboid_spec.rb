require 'cuboid'

describe Cuboid do
	
	describe "#initialize" do
		before do
			@cuboid_small = Cuboid.new(0,0,0,2,3,4)
			@cuboid_negative = Cuboid.new(4,-2,1,-1,2,3)
			@cuboid_string = Cuboid.new(1,1,1,9,"4",9)
		end 

		it "creates a new cuboid instance" do 
			expect(@cuboid_small).to be_instance_of(Cuboid)
		end

		it "assigns dimension when arguments are valid" do
			expect(@cuboid_small.dimension).to eq({:x => 2, :y => 3, :z => 4})
		end

		it "does not assign dimension when an argument is negative" do 
			#Ruby still creates the object when the initialize method is called, however
			expect(@cuboid_negative.dimension).to eq(nil)
		end

		it "does not assign origin when an argument is negative" do 
			#Ruby still creates the object when the initialize method is called, however
			expect(@cuboid_negative.origin).to eq(nil)
		end

		it "does not assign origin when an argument is non-numeric" do
			#Ruby still creates the object when the initialize method is called, however
			expect(@cuboid_string.origin).to eq(nil)
		end
	end

	describe "#vertices" do
		before do
			@my_cuboid = Cuboid.new(1,1,1,2,4,5)
		end

		it "gives a list of 8 coordinates" do
			expect(@my_cuboid.vertices.length).to eq(8)
		end

		it "calculates the coordinates correctly" do
			#This is spot-check of the vertex that is farthest from the origin, so all axes used
			expect(@my_cuboid.vertices[6]).to eq({:x => 3, :y => 5, :z => 6})
		end
	end

	describe "#intersects?" do
		before do
			@huge_cube = Cuboid.new(0,0,0,100,100,100) #This should intersect both others
			@base_cube = Cuboid.new(1,1,1,4,4,4) #This should not intersect high rectangle
			@high_rectangle = Cuboid.new(1,7,1,6,2,3) #This should only intersect with huge_cube but clear base_cube
		end

		it "returns false when two cuboids do not intersect" do
			expect(@base_cube.intersects?(@high_rectangle)).to eq(false)
		end

		it "returns true when two cuboids do intersect" do
			expect(@base_cube.intersects?(@huge_cube)).to eq(true)
		end

		it "catches error when attempted comparison is between cuboid and non-cuboid" do
			expect{@high_rectangle.intersects?(178)}.not_to raise_error
		end
	end

	describe "#move_to!" do
		before(:each) do
			@low_cube = Cuboid.new(1,1,1,3,3,3)
		end

		it "changes origin when cuboid is moved" do
			expect{@low_cube.move_to!(7,7,7)}.to change{@low_cube.origin}.from({:x => 1, :y => 1, :z => 1}).to({:x => 7, :y => 7, :z => 7})
		end

		it "does not move origin when given negative coordinates" do
			expect{@low_cube.move_to!(-7,7,7)}.not_to change{@low_cube.origin}
		end

		it "does not move origin when given non-numeric coordinates" do
			expect{@low_cube.move_to!(7,"8",9)}.not_to change{@low_cube.origin}
		end
	end

	describe "#rotate" do
		before(:each) do
			@tall_cuboid = Cuboid.new(0,0,0,1,2,8)
		end

		it "does not cause an error if rotation axis is invalid -- not X Y or Z" do
			expect{@tall_cuboid.rotate(45)}.not_to raise_error
		end

		it "does not rotate cuboid if rotation axis is invalid -- not X Y or Z" do
			expect{@tall_cuboid.rotate(45)}.not_to change{@tall_cuboid.dimension}
		end

		it "changes dimensions when rotation axis is valid" do
			expect{@tall_cuboid.rotate("y")}.to change{@tall_cuboid.dimension}
		end

		it "does not move origin of cuboid when cuboid rotated" do
			expect{@tall_cuboid.rotate("X")}.not_to change{@tall_cuboid.origin}
		end
	end

end #End of describe Cuboid