# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Faker（https://github.com/stympy/faker）を参照して適当なクラスを使用する。
100.times do |n|
  email = Faker::Internet.email
  password = "password"
  uid = Faker::Address.city
  provider = Faker::Address.street_name
  User.create!(email: email,
               password: password,
               password_confirmation: password,
               name: Faker::Name.name
               )
end

n = 1
while n <= 100
  Topic.create(
    title: "あああ",
    content: "hoge",
    user_id: n
  )
  n = n + 1
end
