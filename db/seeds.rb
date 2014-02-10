require 'faker'

# Creating the admin user, me :)
f = User.new(username: "bobryan", email: "bobryan@gmail.com", password: 'seriously', password_confirmation: 'seriously', role: 'admin')
f.skip_confirmation!
f.save

# Creating my posts and comments
rand(25..50).times do
	p = f.posts.create(title: Faker::Lorem.words(rand(5..10)).join(" "), body: Faker::Lorem.words(rand(20..40)).join(" "), urllink: Faker::Internet.domain_name)
	f.comments.create(body: Faker::Lorem.words(rand(15..30)).join(" "), post: p)
end

rand(25..50).times do
  p = User.new(username: Faker::Internet.user_name, email: Faker::Internet.email, password: 'foobarfoobar', password_confirmation: 'foobarfoobar', role: 'member')
  p.skip_confirmation!
  p.save
  rand(10..30).times do
    x = p.posts.create(title: Faker::Lorem.words(rand(5..10)).join(" "), body: Faker::Lorem.words(rand(20..40)).join(" "), urllink: Faker::Internet.domain_name)
    x.update_attribute(:created_at, Time.now - rand(600..31536000))
  end
end

post_count = Post.count

User.all.each do |user|
  rand(75..150).times do
    p = Post.find(rand(1..post_count))
    c = user.comments.create(body: Faker::Lorem.paragraphs(rand(1..2)).join("\n"), post: p)
    c.update_attribute(:created_at, Time.now - rand(600..31536000))
  end
end

puts "Seed finished"

puts"#{User.count} users created"
puts"#{Post.count} posts created"
puts"#{Comment.count} comments created"
