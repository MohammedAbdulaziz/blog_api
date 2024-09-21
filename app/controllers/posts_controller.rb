class PostsController < ApplicationController
  include Authentication
  before_action :authorized
  before_action :set_post, only: %i[show update destroy]
  before_action -> { authorize_owner(@post) }, only: %i[update destroy]

  def index
    posts = Post.all
    render json: posts
  end

  def show
    render json: @post.as_json(include: { comments: { include: :user }, tags: { only: [:id, :name] } })
  end

  def create
    post, errors = PostCreationService.new(@current_user, post_params).call
    if post
      render json: post, status: :created
    else
      render json: { errors: errors }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    head :no_content
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, tag_ids: [])
  end
end
