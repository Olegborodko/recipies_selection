# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Role.delete_all
Role.create(title: "admin", id: 1)
Role.create(title: "subscriber", id: 2)

User.delete_all
User.create(email: "test@test.ua", description: "some some ..", password: "123", role_id: 1, name: 'david')
User.create(email: "test2@test.ua", description: "some some ..", password: "123", role_id: 2, name: 'sasha')