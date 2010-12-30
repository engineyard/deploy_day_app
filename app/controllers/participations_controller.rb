class ParticipationsController < ApplicationController
  def index
    participation = Participation.new.deployed!(request.host)
    self.user_id = participation.id
  end

  def create
    unless user_id
      redirect_to :action => "index"
    else
      participation = Participation.new(params[:participation])
      if participation.valid?
        participation.announce!(user_id)
        redirect_to :action => "done"
      else
        flash[:notice] = "Please fill in all fields"
        render :action => "index"
      end
    end
  end
  
  def done
  end

  protected
  def user_id
    session[:user_id]
  end
  def user_id= id
    session[:user_id] = id
  end
end
