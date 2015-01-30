
require_relative 'rolodex'
require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'
DataMapper.setup(:default, "sqlite3:database.sqlite3")
#database.sqlite3 is the name of your project

class Contact
  include DataMapper::Resource
  property :id, Serial
  property :first_name, String
  property :last_name, String
  property :email, String
  property :note, String


  #includes functionality of Datamapper
  #module DataMapper
  #   module Resource
  #   end
  #end
  # attr_accessor :id, :first_name, :last_name, :email, :note
  
  # def initialize(first_name, last_name, email, note)
  #   @first_name = first_name
  #   @last_name = last_name
  #   @email = email
  #   @note = note
  # end
end

DataMapper.finalize
DataMapper.auto_upgrade!


#End of data mapper setup



# set :server, :webrick

#Put error out in the HTML file if it occurs
disable :raise_errors
disable :show_exceptions

  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end

  error 500 do | exception |
      "Fatal Error Occurred: #{ h exception }<br> <pre>#{h exception.backtrace.join("\n")}</pre>"
  end



  get '/' do
    @crm_name = "My CRM"
    @title = "CRM"
    erb :index

  end

get "/contacts" do
  @contacts = Contact.all
  erb :contacts
end

  get '/contacts/new' do
    @title = "Add a contact"
    erb :new
  end

post "/contacts" do
  contact = Contact.create(
    :first_name => params[:first_name],
    :last_name => params[:last_name],
    :email => params[:email],
    :note => params[:note]
  )
  redirect to('/contacts')
end



  get '/contacts/find' do 
    @title = "Find a contact"
    puts "*****#{params.inspect}*****"
    params[:search]
    @contact = Contact.get(params[:search])
    if @contact
      #Do I need to redirect to the contact/:id page?
      erb :show_contact
    else
      puts "noooo"
    end
    erb :findcontact
  end


# get '/contacts/findtherightcontact' do
#   @contact = $rolodex.find(params[:search].to_i)
#   erb :find
# end


# get '/contacts/search' do
#   erb :findcontact
# end


# post '/contacts/search' do
#   @contact = Contact.get(params[:id].to_i)
#   if @contact
#     erb :show_contact
#   else
#     put "noooo"
#   end
# end


  # post '/contacts/:id' do
  #   @contact = $rolodex.find(params[:search])
  #   if @contact
  #     erb :show_contact
  #   else
  #     raise Sinatra::NotFound
  #   end
  # end

get "/contacts/:id" do
  # @contact = $rolodex.find(params[:id].to_i)
  @contact = Contact.get(params[:id])
  if @contact
    erb :show_contact
  else
    raise Sinatra::NotFound
  end
end

get "/contacts/:id/edit" do
  @contact = Contact.get(params[:id])
  if @contact
    erb :edit_contact
  else
    raise Sinatra::NotFound
  end
end

put "/contacts/:id" do
  @contact = Contact.get(params[:id])
  if @contact
    @contact.first_name = params[:first_name]
    @contact.last_name = params[:last_name]
    @contact.email = params[:email]
    @contact.note = params[:note]
    @contact.save
    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end

delete "/contacts/:id" do
  @contact = Contact.get(params[:id])
  if @contact
    # $rolodex.remove_contact(@contact)
    @contact.destroy
    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end
  # get '/contacts/show_contacts' do
  #   @contacts = $rolodex.find_contact(idnumber)
  #   @title = "Show a contact"
  #   erb :show_contact
  # end

 


# Delete '/' do 
#   puts
#   puts "PARAMS =>{param}"
#   puts
# end

