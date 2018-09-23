class Post < Granite::Base
	adapter mysql
	timestamps
	field title : String
	field url : String
	field username : String
	field text : String
	field ups : Int32
	field downs : Int32
	field views : Int32
	field clicks : Int32
end
