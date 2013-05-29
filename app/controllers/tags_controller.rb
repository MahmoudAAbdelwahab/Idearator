class TagsController < ApplicationController
  # auto completes tags
  # Params:
  # +q+:: the parameter is  a string passed through auttocomplete field
  # Author: muhammed hassan
  def ajax
    @tags = Tag.find(:all, conditions: ['name LIKE(?)', "%#{ params[:q] }%"]).take(5)
    render :json => @tags, only: [:name, :id]
  end

  before_filter :authenticate_user!

  # This is displays the tag managment page
  # Params: None
  # Author: Mohammad Abdulkhaliq
  def index
    unless user_signed_in? || current_user.type != 'Admin'
      render :text => 'You Need To sign in as An Admin'
      return
    end
    @tags = Tag.find(:all, :order => 'created_at')
    @tag = Tag.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tags }
    end
  end

  # This displays the show page while sending the tags synonyms
  # Params:
  # +id+:: This is an instance of +Tag+ passed through the index view
  # Author: Mohammad Abdulkhaliq
  def show
    unless user_signed_in? || current_user.type != 'Admin'
      render :text => 'You Need To sign in as An Admin'
      return
    end
    @tag = Tag.find(params[:id])
    @tags = @tag.tags.all
    respond_to do |format|
      #format.html # show.html.erb
      #format.json { render json: @tag }
      format.js
    end
  end

  # This displays the new page to create a new tag
  # Params: None
  # Author: Mohammad Abdulkhaliq
  def new
    unless user_signed_in? || current_user.type != 'Admin'
      render :text => 'You Need To sign in as An Admin'
      return
    end
    @tag = Tag.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tag }
    end
  end

  # This displays the new form to enter the tag's new name
  # +id+:: This is an instance of +Tag+ passed through the index view
  # Author: Mohammad Abdulkhaliq
  def edit
    unless user_signed_in? || current_user.type != 'Admin'
      render :text => 'You Need To sign in as An Admin'
      return
    end
    @tag = Tag.find(params[:id])
  end

  # Create A new Tag using the params[:name] sent from the view
  # +name+:: This is an instance of +String+ passed through params[:tag][:name] from the new view
  # Author: Mohammad Abdulkhaliq
  def create
    unless user_signed_in? || current_user.type != 'Admin'
      render :text => 'You Need To sign in as An Admin'
      return
    end
    @tag = Tag.new(params[:tag])
    respond_to do |format|
      if @tag.save
        format.html { redirect_to tags_path, notice: 'Tag was successfully created.' }
        format.json { render json: tags_path, status: :created, location: @tag }
        format.js
      else
        #format.html { render action: "new" }
        #format.json { render json: @tag.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # Updates the selected Tag using the params[:name] sent from the view
  # +name+:: This is an instance of +String+ passed through params[:tag][:name] from the new view
  # Author: Mohammad Abdulkhaliq
  def update
    unless user_signed_in? || current_user.type != 'Admin'
      render :text => 'You Need To sign in as An Admin'
      return
    end
    @tag = Tag.find(params[:id])
    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end


  # Deletes the selected Tag using the params[:id] sent from the index view
  # +id+:: This is an instance of +Tag+ passed through params[:id] from the index view
  # Author: Mohammad Abdulkhaliq
  def destroy
    unless user_signed_in? || current_user.type != 'Admin'
      render :text => 'You Need To sign in as An Admin'
      return
    end
    @tag = Tag.find(params[:id])
    @name = @tag.name
    @tag.destroy
    @tag.tags.destroy_all
    respond_to do |format|
      format.html { redirect_to tags_url }
      format.json { head :no_content }
      format.js
    end
  end

  # Adds a Synonym with the name entered in the form
  # If the entered name does not have an associated tag with the same name
  # a new tag is created with the name and a connection is made
  # Else if the entered name already has a tag but without a connection
  # a connection is made but a new tag is not created
  # Else if the entered name already has a tag and a connection to the
  # parent tag nothing is done and the user is informed so that the
  # synonym already exists
  # +name+:: This is an instance of +String+ passed through params[:tag][:name] from the show view
  # Author: Mohammad Abdulkhaliq
  def addsym
    unless user_signed_in? || current_user.type != 'Admin'
      render :text => 'You Need To sign in as An Admin'
      return
    end
    @tag = Tag.find(params[:id])
    y = params[:tag]['name']
    #query for finding tag with input name returns Tag Array matching 'name'
    tag_query = Tag.where('name = ?', y)
    respond_to do |format|
      if tag_query.empty?
        @sym = Tag.new(:name => y)
        @sym.save
        @sym.tags << @tag
        @tag.tags << @sym
        format.html { redirect_to tags_path, notice: 'Tag was successfully created. and Sym List appended' }
        format.json { render json: @tag, status: :created, location: @sym }
        # format.js
      elsif !@tag.tags.all.include?(tag_query[0]) && @tag != tag_query[0]
        @sym = tag_query[0]
        @sym.tags << @tag
        @tag.tags << @sym
        format.html { redirect_to tags_path, notice: 'Synonym list was successfully updated.' }
        format.json { head :no_content }
        # format.js
      else
        format.html { redirect_to tags_path, notice: 'Synonym already exits !' }
        format.json { head :no_content }
      end
    end
  end

  def delsym
    @tag = Tag.find(params[:id])
    @tag2 = Tag.find(params[:sym])
    @tag.tags.destroy(@tag2)
    @tag2.tags.destroy(@tag)
    respond_to do |format|
      format.html { redirect_to tags_path , notice: 'Synonym list was successfully updated.' }
      format.json { head :no_content }
    end
  end
end
