class View < Granite::Base
	adapter mysql
	timestamps
	field post_id : Int64
	field username : String
end
