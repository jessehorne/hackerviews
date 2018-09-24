require "dotenv"

# Load .env file
Dotenv.load!

# Setup Granite
name = ENV["DB_NAME"]
host = ENV["DB_HOST"]
port = ENV["DB_PORT"]
user = ENV["DB_USER"]
pass = ENV["DB_PASS"]

db_url = "mysql://#{user}:#{pass}@#{host}:#{port}/#{name}"

Granite::Adapters << Granite::Adapter::Mysql.new({name: "mysql", url: db_url})

# Require things
require "kemal"
require "kemal-session"
require "kemal-flash"
require "granite/adapter/mysql"
require "json"

# Require models
require "./models/user"
require "./models/post"
require "./models/comment"

# Drop tables if they exist and create them
# User.migrator.drop_and_create
# Post.migrator.drop_and_create
# Comment.migrator.drop_and_create

# Session Configuration
Kemal::Session.config do |config|
	config.cookie_name = "kemal_sessid"
	config.secret = ENV["CONFIG_SECRET"]
	config.gc_interval = 60.minutes
	config.engine = Kemal::Session::FileEngine.new({:sessions_dir => ENV["SESSIONS_DIR"]})
end

# Require routes
require "./api/auth.cr"
require "./api/user.cr"
require "./api/post.cr"

# Base route
get "/" do |env|
	render "src/views/home.ecr", "src/views/layout.ecr"
end

# Run webserver
Kemal.run
