require './contact'
require './rolodex'
require 'sinatra'
require 'sinatra/reloader'

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

$rolodex = Rolodex.new

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




