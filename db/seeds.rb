# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

FavoriteRecipe.delete_all
User.delete_all
User.create(email: "test@test.ua", status:"unauthorized", description: "some some ..", password: "Qaz123", name: 'david')
User.create(email: "test1@test.ua", status:"subscriber", description: "some some ..", password: "Qaz123", name: 'david2')
User.create(email: "admin@test.ua", status:"admin", description: "some some ..", password: "admin@test.ua", name: 'admin@test.ua')