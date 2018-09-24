post "/comment/submit" do |env|
	# validation
	validation_errors = [] of String

	if !env.session.bool?("user_logged_in")
		env.flash["validation_errors"] = ["You must login to access this."].to_json
		env.redirect "/login"
	end

	new_comment = Comment.new
	new_comment.username = env.session.string("username")
	new_comment.text = env.params.body["text"].as(String)
	new_comment.post_id = env.params.body["post_id"].to_i64
	new_comment.ups = 0
	new_comment.downs = 0

	if env.params.body["text"].as(String).size < 2
		validation_errors << "Your comment must be more than 2 characters in length."
	end

	the_post = Post.find new_comment.post_id

	if !the_post
		validation_errors << "No post exists with that id."
	end

	if validation_errors.size > 0
		env.flash["validation_errors"] = validation_errors.to_json

		if the_post
			env.redirect "#{the_post.url}"
		end
	end

	begin
		new_comment.save!
	rescue
		env.flash["validation_errors"] = ["The comment could not be submitted."].to_json

		env.redirect "/submit"
	else
		if the_post
			env.redirect "#{the_post.url}"
		end
	end
end

get "/post/comments/:post_id" do |env|
	the_post = Post.find env.params.url["post_id"].to_i64

	if the_post
		comments = Comment.all("WHERE post_id = #{the_post.id}")

		new_comments = [] of Hash(String, String | Int64 | Nil)

		comments.each { |c|
			new_comment = {
				"username" => c.username,
				"text" => c.text,
				"id" => c.id
			}

			new_comments << new_comment
		}

		new_comments.to_json
	else
		env.redirect "/"
	end
end
