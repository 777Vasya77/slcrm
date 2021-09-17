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

not_exist = []
clients_id.each do |id|
    isIdExist = true
    isUserDataCorrect = true

    browser.text_field(id: 'inputId').set(id)
    isIdExist = browser.td(text: id.to_s).wait_until(timeout: 10, &:present?) rescue false

    if !isIdExist
        puts "#{id} - НЕ НАЙДЕН!"
        not_exist.push("#{id} - НЕ НАЙДЕН!")
        next
    end

    sleep 2
    browser.link(title: "Редактировать").click

    browser.div(class: 'alert-danger').wait_until
    browser.div(id: "modal-edit").select_list(name: "rowstatus").select("3")

    isUserDataCorrect = browser.button(class: "form-submit").click rescue false
    if !isUserDataCorrect
        puts "#{id} - НЕ ПОЛНЫЕ АНКЕТНЫЕ ДАННЫЕ!"
        modal = browser.div(id: "modal-edit")
        header = modal.child(class: "modal-header")
        btn = header.child(class: "close")
        btn.click
        next
    end

    puts "#{id} - УДАЛЕН!"
end

puts "<< ОТЧЕТ: не найдено >>"
puts not_exist

browser.close
