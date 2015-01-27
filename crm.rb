require 'sinatra'
require './contact'
get '/' do
  @crm_name = "My CRM"
  erb :index
end


get "/contacts" do
  @contacts = []
  @contacts << Contact.new("Yehuda", "Katz", "yehuda@example.com", "Developer")
  @contacts << Contact.new("Mark", "Zuckerberg", "mark@facebook.com", "CEO")
  @contacts << Contact.new("Sergey", "Brin", "sergey@google.com", "Co-Founder")

  erb :contacts
end