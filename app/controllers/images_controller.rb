class ImagesController < ApplicationController
  before_action :current_user_must_be_image_user, :only => [:edit, :update, :destroy]

  def current_user_must_be_image_user
    image = Image.find(params[:id])

    unless current_user == image.user
      redirect_to :back, :alert => "You are not authorized for that."
    end
  end

  def index
    @q = Image.ransack(params[:q])
    @images = @q.result(:distinct => true).includes(:user, :taggings, :votes, :comments).page(params[:page]).per(10)

    render("images/index.html.erb")
  end

  def show
    @comment = Comment.new
    @vote = Vote.new
    @tagging = Tagging.new
    @image = Image.find(params[:id])

    render("images/show.html.erb")
  end

  def new
    @image = Image.new

    render("images/new.html.erb")
  end

  def create
    @image = Image.new

    @image.user_id = params[:user_id]
    @image.price = params[:price]
    @image.description = params[:description]
    @image.response_time = params[:response_time]
    @image.image_url = params[:image_url]

    save_status = @image.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/images/new", "/create_image"
        redirect_to("/images")
      else
        redirect_back(:fallback_location => "/", :notice => "Image created successfully.")
      end
    else
      render("images/new.html.erb")
    end
  end

  def edit
    @image = Image.find(params[:id])

    render("images/edit.html.erb")
  end

  def update
    @image = Image.find(params[:id])

    @image.user_id = params[:user_id]
    @image.price = params[:price]
    @image.description = params[:description]
    @image.response_time = params[:response_time]
    @image.image_url = params[:image_url]

    save_status = @image.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/images/#{@image.id}/edit", "/update_image"
        redirect_to("/images/#{@image.id}", :notice => "Image updated successfully.")
      else
        redirect_back(:fallback_location => "/", :notice => "Image updated successfully.")
      end
    else
      render("images/edit.html.erb")
    end
  end

  def destroy
    @image = Image.find(params[:id])

    @image.destroy

    if URI(request.referer).path == "/images/#{@image.id}"
      redirect_to("/", :notice => "Image deleted.")
    else
      redirect_back(:fallback_location => "/", :notice => "Image deleted.")
    end
  end
end
