desc "Send a request every 2 seconds"
task :run => [:environment] do |t|
  while true
    phone_number = Faker::PhoneNumber.phone_number
    message = Faker::Shakespeare.as_you_like_it_quote

    HTTParty.post("#{ENV['ROOT_URL']}/handle", body: {
      to_number: phone_number,
      message: message
    })

    puts "Received message from #{phone_number}: #{message}"
    sleep 10
  end
end
