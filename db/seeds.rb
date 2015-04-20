require 'faker'

# Create Users
5.times do
  user = User.new(
    username: Faker::Internet.user_name,
    email: Faker::Internet.email,
    password: Faker::Lorem.characters(10),
    name: Faker::Name.name
    )
  user.skip_confirmation!
  user.save!
end
users = User.all

# Create Wikis
@words = ["coding", "ruby", "bloc", "internet", "SDN", "applications", "devops", "tdd", "openstack"]
15.times do
  wiki = Wiki.new(
    title: Faker::Lorem.sentence,
    body: 
      "###" + Faker::Lorem.sentence + 
      "
      This wiki is good for:
          * understanding wikis
          * faking wikis
          * editing wikis
      " + Faker::Lorem.paragraph(25),
    user: users.sample
    )
  wiki.all_tags = (@words.sample(1 + rand(@words.count)))*","
  wiki.save!
end
wikis = Wiki.all

# Create Collaborations
wikis.each do |wiki| 
  Collaboration.create(user_id: wiki.user_id, wiki_id: wiki.id)
end
  
# Create an admin user
admin = User.new(
  username: 'admin',
  email: 'admin@example.com',
  password: 'helloworld',
  role: 'admin',
  name: 'Admin User'
)
admin.skip_confirmation!
admin.save!

# Create an standard user
standard = User.new(
  username: 'standard',
  email: 'standard@example.com',
  password: 'helloworld',
  role: 'standard',
  name: 'Standard User'
)
standard.skip_confirmation!
standard.save!

# Create a premium user
premium = User.new(
  username: 'premium',
  email: 'premium@example.com',
  password: 'helloworld',
  role: 'premium',
  name: 'Premium User',
  upgrade_date: (Time.now - 100.days)
)
premium.skip_confirmation!
premium.save!

puts "Seed finished"
puts "#{User.count} users created."
puts "#{Wiki.count} wikis created."