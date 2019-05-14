class CommentsController < ApplicationController

  before_action :find_post, only: [:create, :destroy]

  # def list_comments -> list -> index
  def index
    @comments = Comment.all
  end

  def create
    @comment = @post.build_comment(params[:comment])

    if comment.save
      # redirect for success
      redirect_to posts_path(@post.id)
    else
      # render form again with errors for failure
      render 'posts/show'
    end
  end

  def destroy
    @post.delete_comment(params[:id])

    redirect_to post_path(@post.id)
  end

  private

  def find_post
    @post = Post.find(params['post_id'])
  end
end
