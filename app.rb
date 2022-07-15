require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative 'cookbook'
require_relative 'recipe'
# set :bind, "0.0.0.0"

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get "/" do
  cookbook = Cookbook.new(File.join(__dir__, './recipes.csv'))
  @recipes = cookbook.all
  erb :index
end

# HTTP request to display the form.
get "/new" do
  erb :new
end

post "/recipes" do
  cookbook = Cookbook.new(File.join(__dir__, './recipes.csv'))
  recipe = Recipe.new(name: params[:name], description: params[:description], prep_time: params[:prep_time], rating: params[:rating])
  cookbook.add_recipe(recipe)
  redirect "/"
end

get "/recipes/:index" do
  cookbook = Cookbook.new(File.join(__dir__, './recipes.csv'))
  cookbook.remove_recipe(params[:index].to_i)
  redirect "/"
end

get "/about" do
  erb :about
end

# get "/team/:username" do
#   puts params[:username]
#   "The username is #{params[:username]}"
# end