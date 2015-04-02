require 'faker'

# Create Users
5.times do
  user = User.new(
    name: Faker::Name.name,
    username: Faker::Internet.user_name,
    email: Faker::Internet.email,
    password: Faker::Lorem.characters(10)
    )
  user.skip_confirmation!
  user.save!
end
users = User.all

# Create Wikis
@words = ["coding", "ruby", "bloc", "internet", "SDN", "applications", "devops", "tdd", "openstack"]
15.times do
  wiki = Wiki.create!(
    title: Faker::Lorem.sentence,
    body: 
      "###" + Faker::Lorem.sentence + 
      " - [RedCarpet at Github](https://github.com/vmg/redcarpet)!" +
      "
      This wiki is good for:
          * understanding wikis
          * faking wikis
          * editing wikis
      " + Faker::Lorem.paragraph(25),
    user: users.sample,
    )
  wiki.all_tags = (@words.sample(1 + rand(@words.count)))*","
end
wikis = Wiki.all

# Create Collaborations
wikis.each do |wiki| 
  Collaboration.create(user_id: wiki.user_id, wiki_id: wiki.id)
end
  
# Create an admin user
admin = User.new(
  name: 'Admin User',
  email: 'admin@example.com',
  password: 'helloworld',
  role: 'admin'
)
admin.skip_confirmation!
admin.save!

# Create an standard user
standard = User.new(
  name: 'Standard User',
  email: 'standard@example.com',
  password: 'helloworld',
  role: 'standard'
)
standard.skip_confirmation!
standard.save!

# Create a premium user
premium = User.new(
  name: 'Premium User',
  email: 'premium@example.com',
  password: 'helloworld',
  role: 'premium',
  upgrade_date: (Time.now - 100.days)
)
premium.skip_confirmation!
premium.save!

puts "Seed finished"
puts "#{User.count} users created."
puts "#{Wiki.count} wikis created."