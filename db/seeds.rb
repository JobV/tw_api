# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


  marcelo = User.new
  marcelo.first_name = "Marcelo"
  marcelo.last_name = "Lebre"
  marcelo.email = "marcelo.lebre@gmail.com"
  marcelo.phone_nr = "+351913226179"
  marcelo.save

  job = User.new
  job.first_name = "Job"
  job.last_name = "van der Voort"
  job.email = "jobvandervoort@gmail.com"
  job.phone_nr = "+31622618548"
  job.save

  marcelo.friends << job
  job.friends << marcelo
