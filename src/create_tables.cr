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

require "granite/adapter/mysql"

# Require models
require "./models/user"
require "./models/post"
require "./models/comment"

User.migrator.create
Post.migrator.create
Comment.migrator.create

puts "Created all tables!"
