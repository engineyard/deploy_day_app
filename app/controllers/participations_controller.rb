class ParticipationsController < ApplicationController
  def index
    Participation.new.deployed!(user_id, ENV)
  end

  def create
    Participation.new(params[:participation]).announce!(user_id, ENV)
    redirect_to :action => "done"
  end
  
  def done
    
  end

  protected
  def user_id
    session[:user_id] ||= Time.now.to_s
  end
end
