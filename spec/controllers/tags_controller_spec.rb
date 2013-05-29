# spec/controllers/tags_controller_spec.rb
require 'spec_helper'

#Author: Mohammad Abdulkhaliq
describe TagsController do
  include Devise::TestHelpers
  before :each do
    @a1 = Admin.new
    @a1.email = 'admin@gmail.com'
    @a1.username = 'admin'
    @a1.password = '123123123'
    @a1.confirm!
    @a1.save
    sign_in @a1
  end

  describe "GET #index" do
    it "populates an array of tags" do
      tag = []
      tag << Tag.new(:name => '1').save
      tag << Tag.new(:name => '2').save
      tag << Tag.new(:name => '3').save
      tag << Tag.new(:name => '4').save
      tag << Tag.new(:name => '5').save
      tag = Tag.all
      get :index
      assigns(:tags).should eq(tag)
    end
    it "renders the template view" do
      get :index
      response.should be_successful
      response.should render_template("index")
    end
  end

  describe "GET #new" do
    it "assigns a new Tag to @tag" do
      get :new
      assigns(:tag).should_not eq(nil)
    end
    it "renders the :new template" do
      get :new
      response.should be_successful
      response.should render_template("new")
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new tag in the database" do
        expect{
          post :create, tag: {:name => 'Software'}
        }.to change(Tag,:count).by(1)
      end
    end
    context "with invalid attributes" do
      it "does not save the new contact in the database" do
        t = Tag.new(:name => 'Software').save
        expect{
          post :create, tag: {:name => 'Software'}
        }.to_not change(Tag,:count)
      end
    end
  end

  describe "PUT #addsym" do
    context "Synonym does not exist as a tag" do
      it "creates a new tag" do
        t = Tag.new(:name => 'Soft')
        t.save
        expect { put :addsym, id: t.id, tag: {:name => 'Eng'} } .to change(Tag, :count).by(1)
      end
      it "updates the tag tags list on both sides" do
        t = Tag.new(:name => 'Soft')
        t.save
        put :addsym, id: t.id, tag: {:name => 'Eng'}
        t.tags.count.should eq(1)
        t.tags[0].tags.count.should eq(1)
      end
    end

    context "Synonym exists as a tag" do
      it "updates the tag tags list on both sides" do
        t = Tag.new(:name => 'Soft')
        t.save
        t2 = Tag.new(:name => 'Eng')
        t2.save
        put :addsym, id: t.id, tag: {:name => 'Eng'}
        t.reload
        t2.reload
        t.tags.count.should eq(1)
        t2.tags.count.should eq(1)
      end
    end

    context "Synonym already exists in tag's sym list" do


      it "does not do anything" do
        t = Tag.new(:name => 'Soft')
        t.save
        t2 = Tag.new(:name => 'Eng')
        t2.save
        t.tags << t2
        t2.tags << t
        put :addsym, id: t.id, tag: {:name => 'Eng'}
        t.tags.count.should_not eq(2)
        t2.tags.count.should_not eq(2)
      end
    end
  end

  describe "PUT #delsym" do

    it "destroys @tag.tags using params[:id2]" do
      t = Tag.new(:name => 'Soft')
      t.save
      t2 = Tag.new(:name => 'Eng')
      t2.save
      t.tags << t2
      t2.tags << t
      expect { put :delsym, id: t.id, sym: t2.id} .to change(t.tags, :count).by(-1)
    end
  end

  describe "GET #show" do

    it "gets the tag and it's associated syms" do
      t = Tag.new
      t.name = 'Software'
      t.save
      t.tags << Tag.new(:name => '1')
      t.tags << Tag.new(:name => '2')
      t.tags << Tag.new(:name => '3')
      t.tags << Tag.new(:name => '4')
      t.tags << Tag.new(:name => '5')
      get :show, :id => t.id
      assigns(:tag).should eq(t)
      assigns(:tags).should eq(t.tags)
    end
  end
end
