require 'watir'
require 'selenium-webdriver'
require 'dotenv'

# Choose the right fitness club
Dotenv.load('m.env')
# Dotenv.load('u.env')

# Insert customers id here 
clients_id = []

caps = Selenium::WebDriver::Remote::Capabilities.chrome(:chrome_options => {detach: true})
Selenium::WebDriver::Chrome.driver_path="/Users/ponomarenko/Documents/web/slcrm/chromedriver"
browser = Watir::Browser.new:chrome, desired_capabilities: caps

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
    
    browser.link(title: "Редактировать").click

    browser.select_list(name: 'rowstatus').select!("3")
    browser.button(value: "Сохранить").click

    puts "Done - #{id}"

end