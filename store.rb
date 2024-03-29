
require 'pry'
gem 'sinatra', '1.3.0'
require 'sinatra'
require 'sinatra/reloader'
# require 'better_errors'
require 'sqlite3'
require 'json'
require 'open-uri'
require 'uri'


before do
  @db = SQLite3::Database.new "store.sqlite3"
  @db.results_as_hash = true
end



get '/users' do
  db = SQLite3::Database.new "store.sqlite3" #create a handle to the database
  db.results_as_hash = true
  @rs = db.prepare('SELECT * FROM users;').execute #recordset 
  @users = '/users'
  @products = '/products'
  @home = '/'
  @new_product = '/products/new'
  erb :show_users #render show users  
end

get '/users.json' do
  @rs = @db.execute('SELECT id, name FROM users;')
  @rs.to_json
end


get '/' do
  @users = '/users'
  @products = '/products'
  @home = '/'
  @new_product = '/products/new'
  erb :home
end

get '/products' do
  @rs = @db.prepare('SELECT * FROM products;').execute #recordset 
  @users = '/users'
  @products = '/products'
  @home = '/'
  @new_product = '/products/new'
  erb :show_products #render show users
end 



get '/products/twittersearch' do
  @q = params[:namers]
  file = open("http://search.twitter.com/search.json?q=#{URI.escape(@q)}")
  @results = JSON.load(file.read)
  erb :search_results_twitter
end

get '/products/googlesearch' do
  @q = params[:namers]
  file = open("https://www.googleapis.com/shopping/search/v1/public/products?key=AIzaSyCORVLr-yK2IvWRSmvrJ01L-U5kpfFYTBM&country=US&q=#{URI.escape(@q)}&alt=json",:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE)
 
  @results = JSON.load(file.read)
  #@results.inspect
   erb :search_results_google
end




get '/products/new' do
  @users = '/users'
  @products = '/products'
  @home = '/'
  @new_product = '/products/new'
  erb :new_product
end


post '/products/new' do
name = params[:product_name]
price = params[:product_price]
on_sale = params[:on_sale]
 
#make the product in the db
  db = SQLite3::Database.new "store.sqlite3" #create a handle to the database
  sql = "insert into products ('name', 'price', 'on_sale') values('#{name}', '#{price}', '#{on_sale}');"
  
  # @rs = db.prepare("insert into products ('name', 'price') values ('#{name}', #{price});").execute #recordset 


  @rs = db.prepare(sql).execute
  @name = name
  @price = price
  @users = '/users'
  @products = '/products'
  @home = '/'
  @new_product = '/products/new'
  erb :product_created

# erb :product_created
end



# show action
get '/products/:id' do
   id = params[:id]
   sql = "SELECT name, price, id, on_sale FROM products where id = '#{id}';"
   # @rs = @db.prepare("SELECT name, price, id, on_sale FROM products where id = '#{id}';").execute #recordset 
   @rs = @db.execute(sql)
   @row = @rs.first

   # row = @rs.first
   # @name = row['name']
   # @price = row['price']
   # @id = row['id']
   # @on_sale = row['on_sale']
  # @id = row['id']
  @users = '/users'
  @products = '/products'
  @home = '/'
  @new_product = '/products/new'
   erb :idproduct
end

# http://guides.rubyonrails.org/routing.html
# GET /photos/:id/edit  edit  return an HTML form for editing a photo
# PUT /photos/:id update  update a specific photo



# +++++++++++
get '/products/:id/edit' do
  @id = params[:id]
   #sql = "SELECT name, price, id, on_sale FROM products;"
   # @rs = @db.prepare("SELECT name, price, id, on_sale FROM products where id = '#{id}';").execute #recordset 
   #@rs = @db.execute(sql)
   #@row = @rs.first


   # @name = row['name']
   # @price = row['price']

  @users = '/users'
  @products = '/products'
  @home = '/'
  @new_product = '/products/new'
  erb :edit

end

get '/products/:id/delete' do
  unless params[:id]
      redirect "/products"
  end
  @id = params[:id]

  @users = '/users'
  @products = '/products'
  @home = '/'
  @new_product = '/products/new'
  erb :delete
end

post '/products/:id/delete' do
  @id = params[:id]
  sql = "delete from products where id = #{@id};"
  @rs = @db.execute(sql)

  redirect "/products"
  # erb :show_products
end





post '/products/:id' do
  id = params[:id]
  name = params[:product_name]
  price = params[:product_price]
  on_sale = params[:on_sale]
  sql = "update products set name = '#{name}', price = '#{price}', on_sale = '#{on_sale}' where id = #{id};" 
  @rs = @db.execute(sql)
  @row = @rs.first
    @name = name
    @price = price
    @users = '/users'
    @products = '/products'
    @home = '/'
    @new_product = '/products/new'
    erb :product_modified
# erb :product_created
end










# "update products set name = #{name}, price = #{price} where id = #{id}
 
 
 
 