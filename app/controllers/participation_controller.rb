class ParticipationController < ApplicationController
  def index
    Participation.deployed!(user_id, ENV)
  end

  def update
    Participation.announce!(user_id, ENV, params[:participation])
    redirect_to :action => "done"
  end
  
  def done
  end

  protected
  def user_id
    session[:user_id] ||= Time.now.to_s
  end
end
