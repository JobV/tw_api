# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


5.times do |i|
  user = User.new
  user.first_name = "Joe #{i}"
  user.last_name = "Doe #{i}"
  user.email = "joe#{i}doe@mail.com"
  user.phone_nr = "#{i}#{i}#{i}"
  user.save
end
