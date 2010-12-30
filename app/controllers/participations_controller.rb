class ParticipationsController < ApplicationController
  def index
    Participation.new.deployed!(user_id, ENV)
  end

  def create
    participation = Participation.new(params[:participation])
    if participation.valid?
      participation.announce!(user_id, ENV)
      redirect_to :action => "done"
    else
      flash[:notice] = "Please fill in all fields"
      render :action => "index"
    end
  end
  
  def done
  end

  protected
  def user_id
    session[:user_id] ||= Time.now.to_s
  end
end
