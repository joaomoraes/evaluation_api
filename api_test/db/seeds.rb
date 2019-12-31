# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Create Users..."
role_arr = ['admin', 'user']
users = [].tap do |col|
  4.times do |i|
    role = i == 0 ? role_arr[0] : role_arr.sample
    user_attrs = {
      first_name:'John'+i.to_s ,
      last_name: 'Doe'
    }

    user_attrs[:email] = "#{user_attrs[:first_name]}_#{user_attrs[:last_name]}@email.com"
    user = User.find_or_create_by(user_attrs)
    user.update_attribute(:role, role)
    col << user
  end
end

puts "Create Reports..."
users.each do |user|
  next if user.reports.any?
  rand(2..5).times do
    report_attrs = {
      user: user,
      generated_at: rand(3.months.ago..1.second.ago)
    }
    Report.find_or_create_by(report_attrs)
  end
end