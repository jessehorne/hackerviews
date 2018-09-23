class Comment < Granite::Base
	adapter mysql
	timestamps
	field text : String
	field user_id : Int64
	field ups : Int32
	field downs : Int32
end
