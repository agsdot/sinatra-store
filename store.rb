# gem install --version 1.3.0 sinatra
require 'pry'
gem 'sinatra', '1.3.0'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
 
 
get '/users' do
  db = SQLite3::Database.new "store.sqlite3" #create a handle to the database
  db.results_as_hash = true
  @rs = db.prepare('SELECT * FROM users;').execute #recordset 
  @home = '/'
  erb :show_users #render show users
end


get '/products' do
  db = SQLite3::Database.new "store.sqlite3" #create a handle to the database
  db.results_as_hash = true
  @rs = db.prepare('SELECT * FROM products;').execute #recordset 
  @home = '/'
  erb :show_products #render show users
end 


 
get '/' do
  @users = '/users'
  @products = '/products'
  erb :home
end


 
 
 
 