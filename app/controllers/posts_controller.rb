class PostsController < ApplicationController

  before_action :find_post, only: [:show, :edit, :update, :destroy]

  # list_posts -> list -> index
  def index
    @posts = Post.all
  end

  # show_post -> show
  def show
    @comment = Comment.new
  end

  # new_post -> new
  def new
    @post = Post.new
  end

  # create_post -> create
  def create
    @post = Post.new('author' => params['author'], 'title' => params['title'], 'body' => params['body'])

    if @post.save
      redirect_to posts_path
    else
      render 'new'
    end
  end

  # edit_post -> edit
  def edit
    @post = Post.find(params['id'])
  end

  # update_post -> update
  def update
    if @post.set_attributes('title' => params['title'], 'author' => params['author'], 'body' => params['body'])
      redirect_to posts_path
    else
      render 'edit'
    end
  end

  # delete_post -> delete -> destroy
  def destroy
    @post.destroy
    redirect_to posts_path
  end

  # def greeting
  #   # respond differently to different formats...
  #   respond_to do |format|
  #     # render one response for HTML requests
  #     format.html { render inline: "<p>Hi!</p>" }
  #     # render another for JSON requests
  #     format.json { render json: {greeting: 'Hi!'} }
  #   end
  # end

  private

  def find_post
    @post = Post.find(params[:id])
  end

end
