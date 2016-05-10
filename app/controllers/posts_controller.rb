class PostsController < ApplicationController
  before_action :find_post, only: [:show, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @posts = Post.all.order("created_at DESC")
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def create
    req = Cloudinary::Uploader.upload(params[:post]['image'])
     # This can be used to set up image resize on upload to cloudinary.
     #:crop => :fill, :width => 1080, :height => 1080
    @post = current_user.posts.build(post_params)
    @post.update :image => req['url']

    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    if @post.update(post_params)
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  private
  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :description, :image)
  end
end
