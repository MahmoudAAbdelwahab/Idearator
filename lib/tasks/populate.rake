namespace :db do
  desc "Fill Users and Ideas."
  task :populate => :environment do

    # Turn off automatic similarity calculation
    SimilarityEngine.build_after_idea_save = false
    @tags = ["Agriculture", "Software", "Fashion", "Development", "Games" , "BigThings" , "SmallThings" , "CamelCase" , "Food" , "TakeAway"]
    40.times do |n|
      u = User.new
      u.email = Faker::Internet.email
      u.username = Faker::Name.name
      u.password = 123123123
      u.confirm!
      u.save
    end

    10.times do |n|
      c = Committee.new
      c.email = Faker::Internet.email
      c.username = Faker::Name.name
      c.password = 123123123
      c.confirm!
      c.save
    end

    50.times do |n|
      i = Idea.new
      i.user_id = rand(1..50)
      i.title = Faker::Name.name
      i.description = Faker::Lorem.paragraph
      i.problem_solved = Faker::Lorem.paragraph
      i.approved = "true"
      i.committee = Committee.find(rand(41..50))
      i.num_votes = rand(1..500)
      i.save
      v = VoteCount.new
      v.idea = i
      v.prev_day_votes = rand (0..40)
      v.save
    end

    10.times do |n|
      t = Tag.new
      t.name = @tags.at(n).to_s
      t.save
    end

      i = Investor.new
      i.email = Faker::Internet.email
      i.username = Faker::Name.name
      i.password = 123123123
      i.confirm!
      i.save

      i2 = Investor.new
      i2.email = Faker::Internet.email
      i2.username = Faker::Name.name
      i2.password = 123123123
      i2.confirm!
      i2.save

    20.times do |n|
      c = Competition.new
      c.title = Faker::Name.name
      c.description = Faker::Lorem.paragraph
      c.investor = i
      c.start_date = Time.now.to_date + rand(-10..-1).days
      c.end_date = c.start_date + rand(1..30).days
      c.tags << Tag.all[rand(0..9)]
      c.tags << Tag.all[rand(0..9)]
      c.tags << Tag.all[rand(0..9)]
      rand(1..40).times do |p|
        idea = Idea.all[rand(0..49)]
        c.ideas << idea
      end
      c.save
    end

    SimilarityEngine.rebuild_all_similarities

    t = Threshold.new
    t.threshold = 40
    t.save

    50.times do |n|
      it = IdeasTags.new
      it.idea_id = n+1
      it.tag_id = rand(1..12)
      it.save
      it1 = IdeasTags.new
      it1.idea_id = n+1
      it1.tag_id = rand(1..12)
      it1.save
      it2 = IdeasTags.new
      it2.idea_id = n+1
      it2.tag_id = rand(1..12)
      it2.save
    end

    t = Threshold.new
    t.threshold = 40
    t.save

  end
end
