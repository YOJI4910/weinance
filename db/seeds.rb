# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



User.create!(
  name: "first",
  email: "first@example.com",
  height: 174.0,
  password: 'password',
  password_confirmation: 'password'
)

r = Random.new()

50.times do |n|
  name = Faker::Name.name
  email = "exsample-#{n+1}@example.com"
  height = r.rand(150.0..185.0).round(1)
  password = 'password'
  User.create!(
    name: name,
    email: email,
    height: height,
    password: password,
    password_confirmation: password
  )
end

r2 = Random.new()
users= User.order(:created_at).take(38)

60.times do |n|
  weight = r2.rand(55.0..100.0)
  to = Time.zone.now
  from = to - 60.days

  users.each do |user|
    user.records.create!(
      weight: weight,
      created_at: r2.rand(from..to)
    )
  end
end