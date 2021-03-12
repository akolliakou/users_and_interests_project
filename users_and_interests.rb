require 'yaml'

require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'

before do
  @users_and_interests = YAML.load_file('users.yaml')
end

get "/" do
  @title = 'List of users'

  erb :home
end

get "/users" do
  redirect "/"
end

get "/users/:name" do
  @name = params[:name].to_sym
  @email = @users_and_interests[@name][:email]
  @interests = @users_and_interests[@name][:interests]

  erb :user
end

helpers do
  def format_interests(arr)
    arr.join(", ")
  end

  def count_interests(hsh)
    interests = []

    hsh.each_pair do |user, other_hsh|
      interests << other_hsh[:interests]
    end

    interests.flatten.count
  end

  def count_users(hsh)
    hsh.keys.count
  end
end

not_found do
  erb :not_found
end