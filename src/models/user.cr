class User < Granite::Base
	adapter mysql
	timestamps
	field username : String
	field password : String
	field about : String
	field role : Int32 # 0=User, 1=Moderator, 2=Administrator
end
