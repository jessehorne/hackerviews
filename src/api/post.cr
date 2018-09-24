get "/submit" do |env|
	if env.flash["validation_errors"]?
		validation_errors = JSON.parse(env.flash["validation_errors"]).as_a
	else
		validation_errors = [] of String
	end

	if !env.session.bool?("user_logged_in")
		env.flash["validation_errors"] = ["You must login to access this."].to_json
		env.redirect "/login"
	end

	render "src/views/submit.ecr", "src/views/layout.ecr"
end

post "/post/submit" do |env|
	if env.flash["validation_errors"]?
		validation_errors = JSON.parse(env.flash["validation_errors"]).as_a
	else
		validation_errors = [] of String
	end

	if !env.session.bool?("user_logged_in")
		env.flash["validation_errors"] = ["You must login to access this."].to_json
		env.redirect "/login"
	end

	new_post = Post.new
	new_post.title = env.params.body["title"].as(String)
	new_post.text = env.params.body["text"].as(String)
	new_post.url = "/post/" + Random::Secure.urlsafe_base64(8, padding: true).to_s
	new_post.username = env.session.string("username")
	new_post.ups = 0
	new_post.downs = 0
	new_post.views = 0
	new_post.clicks = 0

	begin
		new_post.save!
	rescue
		env.flash["validation_errors"] = ["The post could not be submitted."].to_json

		env.redirect "/submit"
	else
		env.flash["validation_errors"] = ["You have submitted a post successfully."].to_json

		env.redirect "#{new_post.url}"
	end
end

get "/post/:post_url" do |env|
	the_post = Post.find_by(url: "/post/" + env.params.url["post_url"].as(String))

	if !the_post
		env.redirect "/"
	end

	if the_post

		new_post = {
			"id" => the_post.id,
			"title" => the_post.title,
			"username" => the_post.username,
			"ups" => the_post.ups,
			"downs" => the_post.downs,
			"views" => the_post.views,
			"clicks" => the_post.clicks,
			"text" => the_post.text,
			"url" => the_post.url
		}
		post = new_post

		render "src/views/read.ecr", "src/views/layout.ecr"
	end
end

get "/post/new/:page" do |env|
	page_num = env.params.url["page"].to_i

	limit = 2
	offset = (limit * page_num) - limit

	posts = Post.all("ORDER BY created_at DESC LIMIT #{limit} OFFSET #{offset}").to_json

	posts
end

get "/post/top/:page" do |env|
	page_num = env.params.url["page"].to_i

	limit = 2
	offset = (limit * page_num) - limit

	posts = Post.all("ORDER BY ups DESC LIMIT #{limit} OFFSET #{offset}").to_json

	posts
end

get "/post/show/:page" do |env|
	page_num = env.params.url["page"].to_i

	limit = 2
	offset = (limit * page_num) - limit

	posts = Post.all("WHERE title LIKE '%Show HV:%' ORDER BY created_at DESC LIMIT #{limit} OFFSET #{offset}")

	new_posts = [] of Hash(String, String | Int32 | Int64 | Time | Nil)

	posts.each { |p|
		new_post = {
			"id" => p.id,
			"created_at" => p.created_at,
			"title" => p.title,
			"url" => p.url,
			"username" => p.username,
			"ups" => p.ups,
			"downs" => p.downs,
			"views" => p.views,
			"clicks" => p.clicks
		}

		new_posts << new_post
	}

	new_posts.to_json
end

get "/post/ask/:page" do |env|
	page_num = env.params.url["page"].to_i

	limit = 2
	offset = (limit * page_num) - limit

	posts = Post.all("WHERE title LIKE '%Ask HV:%' ORDER BY created_at DESC LIMIT #{limit} OFFSET #{offset}").to_json

	posts
end

get "/post/jobs/:page" do |env|
	page_num = env.params.url["page"].to_i

	limit = 2
	offset = (limit * page_num) - limit

	posts = Post.all("WHERE title LIKE '%Hire HV:%' ORDER BY created_at DESC LIMIT #{limit} OFFSET #{offset}").to_json

	posts
end
