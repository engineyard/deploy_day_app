class ParticipationsController < ApplicationController
  def index
    begin
      @participation = Participation.new
      @participation.deployed!(request.host)
      self.user_id = @participation.id
    rescue Errno::ECONNREFUSED
      flash.now[:notice] = "Central server is down. Please tell Dr Nic. Do not submit your form."
    rescue Errno::EAFNOSUPPORT
      flash.now[:notice] = "Cannot connect to central server #{ParticipationResource.site}"
    rescue Exception => e
      flash.now[:notice] = "#{e.message} (#{e.class})"
    end
  end

  def create
    unless user_id
      redirect_to :action => "index"
    else
      begin
        @participation = Participation.new(params[:participation])
        if @participation.valid?
          @participation.announce!(user_id)
          redirect_to :action => "done"
        else
          flash[:notice] = "Please fill in all fields"
          render :action => "index"
        end
      rescue Errno::ECONNREFUSED
        flash.now[:notice] = "Central server is down. Please tell Dr Nic. Do not submit your form."
      rescue Errno::EAFNOSUPPORT
        flash.now[:notice] = "Cannot connect to central server #{ParticipationResource.site}"
      rescue Exception => e
        flash.now[:notice] = "#{e.message} (#{e.class})"
      end
      render :action => "index"
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
