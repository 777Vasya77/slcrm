require 'watir'
require 'webdrivers'
require 'dotenv'
require 'pry'

# Choose the right fitness club
Dotenv.load('m.env')

# Insert customers id here 
clients_id = []

browser = Watir::Browser.new
browser.goto "https://crm.sportlifedigital.com/login"

puts 'Open Chrome'

browser.text_field(id: 'username').set(ENV['LOGIN'])
browser.text_field(id: 'password').set(ENV['PASSWORD'])
browser.span(id: 'submit').click

puts "Log in to CRM #{ENV['LOCATION']}"

# Go to /customers
browser.link(visible_text: "Клиенты").click

puts 'Go to customers page'

clients_id.each do |id|

    browser.text_field(id: 'inputId').set(id)
    browser.td(text: id.to_s).wait_until_present

    sleep 2
    browser.link(title: "Редактировать").click

    browser.div(class: 'alert-danger').wait_until_present
    browser.div(id: "modal-edit").select_list(name: "rowstatus").select("3")
    browser.button(class: "form-submit").click

    puts "Done - #{id}"
end
