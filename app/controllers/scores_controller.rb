class ScoresController < ApplicationController
  before_action :current_user_must_be_score_user, :only => [:edit, :update, :destroy]

  def current_user_must_be_score_user
    score = Score.find(params[:id])

    unless current_user == score.user
      redirect_to :back, :alert => "You are not authorized for that."
    end
  end

  def index
    @scores = Score.all

    render("scores/index.html.erb")
  end

  def show
    @score = Score.find(params[:id])

    render("scores/show.html.erb")
  end

  def new
    @score = Score.new

    render("scores/new.html.erb")
  end

  def create
    @score = Score.new

    @score.user_id = params[:user_id]
    @score.poster_score = params[:poster_score]
    @score.rater_score = params[:rater_score]

    save_status = @score.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/scores/new", "/create_score"
        redirect_to("/scores")
      else
        redirect_back(:fallback_location => "/", :notice => "Score created successfully.")
      end
    else
      render("scores/new.html.erb")
    end
  end

  def edit
    @score = Score.find(params[:id])

    render("scores/edit.html.erb")
  end

  def update
    @score = Score.find(params[:id])

    @score.user_id = params[:user_id]
    @score.poster_score = params[:poster_score]
    @score.rater_score = params[:rater_score]

    save_status = @score.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/scores/#{@score.id}/edit", "/update_score"
        redirect_to("/scores/#{@score.id}", :notice => "Score updated successfully.")
      else
        redirect_back(:fallback_location => "/", :notice => "Score updated successfully.")
      end
    else
      render("scores/edit.html.erb")
    end
  end

  def destroy
    @score = Score.find(params[:id])

    @score.destroy

    if URI(request.referer).path == "/scores/#{@score.id}"
      redirect_to("/", :notice => "Score deleted.")
    else
      redirect_back(:fallback_location => "/", :notice => "Score deleted.")
    end
  end
end
