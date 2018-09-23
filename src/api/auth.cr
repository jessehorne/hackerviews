get "/register" do |env|
	if env.session.string?("user_logged_in")
		env.redirect "/"
	end

	if env.flash["validation_errors"]?
		validation_errors = JSON.parse(env.flash["validation_errors"]).as_a
	else
		validation_errors = [] of String
	end

	render "src/views/register.ecr", "src/views/layout.ecr"
end

get "/login" do |env|
	if env.session.string?("user_logged_in")
		env.redirect "/"
	end

	if env.flash["validation_errors"]?
		validation_errors = JSON.parse(env.flash["validation_errors"]).as_a
	else
		validation_errors = [] of String
	end

	render "src/views/login.ecr", "src/views/layout.ecr"
end

get "/logout" do |env|
	env.session.destroy
	env.redirect "/"
end
