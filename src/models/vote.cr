class Vote < Granite::Base
	adapter mysql
	timestamps
	field vote_type : String
	field username : String
	field post_id : Int64
end
