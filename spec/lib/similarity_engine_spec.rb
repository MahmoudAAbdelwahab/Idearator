require 'spec_helper'

describe SimilarityEngine do
  describe 'similarity index' do
    def calc(i1, i2)
      v = SimilarityEngine.idea_similarity_coeff(i1, i2)
      puts "Similarity: #{v}"
      v
    end

    before :all do
      @tag_ids = Tag.limit(5).pluck(:id)
      if @tag_ids.empty?
        5.times { @tag_ids << FactoryGirl.create(:tag).id }
      end
      @i1 = Idea.new(tag_ids: @tag_ids)
      @i2 = Idea.new(tag_ids: @tag_ids)

      @str1 = 'a cool car meh test'
      @str2 = 'a hot car test meh'

      @str3 = 'a cool alcamino car meh test'
      @str4 = 'an alcamino car test meh'
    end

    context 'of two ideas with the same set of tags' do
      it 'should be 10 if nothing else is similar' do
        calc(@i1, @i2).should == 10
      end

      # keyword size assumed to be default at 5
      it 'should be more than 10 if title is similar with no keywords' do
        @i1.title = @str1
        @i2.title = @str2
        calc(@i1, @i2).should > 10
      end

      it 'should be more than 10 if description is similar' do
        @i1.title = @i2.title = ''
        @i1.description = @str1
        @i2.description = @str2
        calc(@i1, @i2).should > 10
      end

      it 'should be more than 10 if problem solved is similar' do
        @i1.description = @i2.description = ''
        @i1.problem_solved = @str1
        @i2.problem_solved = @str2
        calc(@i1, @i2).should > 10
      end

      it 'should be at least 15 if title is similar with one matching keyword' do
        @i1.title = @str3
        @i2.title = @str4
        calc(@i1, @i2).should >= 15
      end

      it 'should be at least 20 if title is the same' do
        @i1.title = @str1
        @i2.title = @i1.title
        calc(@i1, @i2).should >= 20
      end
    end

    it 'should be calculated automatically on idea creation' do
      SimilarityEngine.build_after_idea_save = true
      i1 = Idea.create(title: @str1, description: @str3, problem_solved: @str1,
                  tag_ids: @tag_ids)
      i2 = Idea.create(title: @str2, description: @str4, problem_solved: @str1,
                  tag_ids: @tag_ids)

      s1 = Similarity.where(idea_id: i1, similar_idea_id: i2).first.similarity
      s2 = Similarity.where(idea_id: i2, similar_idea_id: i1).first.similarity

      s1.should eq(s2)
      s1.should > 10
    end

    it 'should be recalculated if manual rebuilding is initiated' do
      SimilarityEngine.build_after_idea_save = false
      i1 = Idea.create(title: @str2, description: @str4, problem_solved: @str2,
                  tag_ids: @tag_ids[0, 2])
      i2 = Idea.create(title: @str1, description: @str3, problem_solved: @str2,
                  tag_ids: @tag_ids[0, 2])
      s1 = Similarity.where(idea_id: i1).first.should be(nil)

      SimilarityEngine.rebuild_all_similarities
      s1 = Similarity.where(idea_id: i1).first.should_not be(nil)
    end
  end
end
