# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

u = User.create(name: "Tam Nguyen", email: "tam@feels.com", password: "123456", password_confirmation: "123456")
u.update_columns(api_key: "TtDKqIuz50GyNpl7z8tMtQtt")