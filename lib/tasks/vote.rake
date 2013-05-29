namespace :db do
  desc "Fill some Votes."
  task :vote => :environment do

    4.times do |x|
      40.times do |n|
        u = Vote.new
        u.user_id = n + 1
        u.idea_id = x + 1
        u.save
      end
    end
    4.times do |x|
      20.times do |n|
        u = Vote.new
        u.user_id = n + 1
        u.idea_id = x + 5
        u.save
      end
    end
  end
end