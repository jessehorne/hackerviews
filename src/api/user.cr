require "crypto/bcrypt/password"

post "/user/register" do |env|
	if env.session.string?("user_logged_in")
		env.redirect "/"
	end

	username = env.params.body["username"].as(String)
	password = Crypto::Bcrypt::Password.create(env.params.body["password"])
	about = env.params.body["about"]
	role = 1 # See User model for details

	# validation
	validation_errors = [] of String

	existing_user = User.find_by(username: username)

	if existing_user
		validation_errors << "A user already exists with that username."
	end

	if username.size < 8
		validation_errors << "Your username must be at least 8 characters."
	end

	if username.size > 100
		validation_errors << "Your username must be less than 100 characters."
	end

	if env.params.body["password"].size < 10
		validation_errors << "Your password must be at least 10 characters."
	end

	if env.params.body["password"].size > 100
		validation_errors << "Your password must be less than 100 characters."
	end

	# Handle if there are validation errors
	if validation_errors.size > 0
		env.flash["validation_errors"] = validation_errors.to_json

		env.redirect "/register"
	else
		new_user = User.new
		new_user.username = username
		new_user.password = password.to_s
		new_user.about = about
		new_user.role = role

		begin
			new_user.save!
		rescue ex
			env.flash["validation_errors"] = [ex.message].to_json

			env.redirect "/register"
		else
			env.flash["validation_errors"] = ["You have successfully registered."].to_json

			env.redirect "/login"
		end
	end
end

post "/user/login" do |env|
	if env.session.string?("user_logged_in")
		env.redirect "/"
	end

	username = env.params.body["username"].as(String)
	password = env.params.body["password"].as(String)

	# validation
	validation_errors = [] of String

	if username.size < 8
		validation_errors << "Your username must be at least 8 characters."
	end

	if username.size > 100
		validation_errors << "Your username must be less than 100 characters."
	end

	if password.size < 8
		validation_errors << "Your password must be at least 8 characters."
	end

	if password.size > 100
		validation_errors << "Your password must be less than 100 characters."
	end

	if validation_errors.size > 0
		env.flash["validation_errors"] = validation_errors.to_json

		env.redirect "/login"
	else
		the_user = User.find_by(username: username)

		if the_user
			hashed_password = Crypto::Bcrypt::Password.new(the_user.password.to_s)
			if hashed_password == password
				env.session.bool("user_logged_in", true)
				env.session.bigint("user_id", the_user.id || -1.to_i64)
				env.session.string("username", the_user.username.to_s)
				env.session.string("about", the_user.about.to_s)

				if the_user.role == 1
					env.session.string("role", "normal")
				elsif the_user.role == 2
					env.session.string("role", "moderator")
				elsif the_user.role == 3
					env.session.string("role", "administrator")
				else
					env.session.string("role", "undefined")
				end

				env.redirect "/"
			else
				env.flash["validation_errors"] = ["That password was incorrect."].to_json

				env.redirect "/login"
			end
		else
			env.flash["validation_errors"] = ["No user exists with those details."].to_json

			env.redirect "/login"
		end
	end
end

post "/user/update" do |env|
	if !env.session.string?("username")
		env.redirect "/"
	end

	current_username = env.session.string("username")

	the_user = User.find_by(username: current_username)

	if the_user
		the_user.about = env.params.body["about"]
		the_user.save!

		env.session.string("about", env.params.body["about"])

		env.flash["validation_errors"] = ["Success!"].to_json
		env.redirect "/account"
	else
		env.flash["validation_errors"] = ["You're logged in but we cannot find your username."].to_json
		env.redirect "/account"
	end
end

get "/account" do |env|
	if !env.session.bool?("user_logged_in")
		env.redirect "/"
	end

	render "src/views/account.ecr", "src/views/layout.ecr"
end

get "/user/:username" do |env|
	if !env.session.bool?("user_logged_in")
		env.redirect "/"
	end

	the_user = User.find_by(username: env.params.url["username"])

	if the_user
		if the_user.role == 1
			role = "User"
		elsif the_user.role == 2
			role = "Moderator"
		elsif the_user.role == 3
			role = "Administrator"
		end

		user = {
			"username" => the_user.username,
			"role" => role,
			"about" => the_user.about
		}

		render "src/views/user.ecr", "src/views/layout.ecr"
	else
		env.redirect "/"
	end
end
