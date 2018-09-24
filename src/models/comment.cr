class Comment < Granite::Base
	adapter mysql
	timestamps
	field text : String
	field username : String
	field post_id : Int64
	field ups : Int32
	field downs : Int32
end
