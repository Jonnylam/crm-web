require_relative 'contact'
require_relative 'rolodex'
require 'sinatra'
require 'sinatra/reloader'

  $rolodex = Rolodex.new
  @@rolodex = Rolodex.new

  @@rolodex.add_contact(Contact.new("Johnny", "Bravo", "johnny@bitmakerlabs.com", "Rockstar"))


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

  get '/contacts' do
    @contacts = $rolodex.contacts
    @title = "View All Contacts"
    erb :contacts
  end

  get '/contacts/new' do
    @title = "Add a contact"
    erb :new
  end

  post '/contacts' do
    contact = Contact.new(params[:first_name], params[:last_name], params[:email], params[:note])
    $rolodex.add_contact(contact)
    redirect to('/contacts')
  end


  # get '/contacts/find' do
  #   @title = "Find a contact"
  #   erb :findcontact
  # end

  # post '/contacts/show_contact' do
  #   @@rolodex.find(params[:id].to_i)
  #   redirect to ('/contacts/:id')
  # end


get "/contacts/:id" do
  @contact = @@rolodex.find(params[:id].to_i)
  if @contact
    erb :show_contact
  else
    raise Sinatra::NotFound
  end
end

get "/contacts/:id/edit" do
  @contact = @@rolodex.find(params[:id].to_i)
  if @contact
    erb :edit_contact
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

