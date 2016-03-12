require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db   # в концце программы почемуто не работает
	return SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true #  возвращаем в виде хеша
	return db
end	

configure do # вызывается при инициализации приложения(т.е. тогда когда мы изменили код, а не когда мы нажали обновить)
	#@db = SQLite3::Database.new 'barbershop.db' #создать новое подключение к barbershop.db (если бд есть то она будет открыта, нет то тогда будет создана в текущем каталоге программы)
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS 
	"Users" 
	("id" INTEGER PRIMARY KEY AUTOINCREMENT, 
		"username" TEXT,
		"phone" TEXT,
		"datestamp" TEXT,
		"barber" TEXT,
		"color" TEXT
		)' # ; не обязательно, т.к. execute подразумевает, что будет выполнена 1 команда

end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	# хеш
	hh = { 	:username => 'Введите имя',
			:phone => 'Введите телефон',
			:datetime => 'Введите дату и время' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	db = get_db
	db.execute 'insert into
		Users
		(
			username,
			phone,
			datestamp,
			barber,
			color
		)	
		values (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]    

	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"

end
# Вывод БД
get '/showusers' do
	erb "Hello World"
end	