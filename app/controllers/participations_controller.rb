class ParticipationsController < ApplicationController
  def index
    begin
      @participation = Participation.new
      self.user_id = @participation.deployed!(request.host)
    rescue ActiveResource::UnauthorizedAccess
      flash.now[:notice] = "Argh. The server password has changed. Please tell Dr Nic. Do not submit your form."
      render :action => "index"
    rescue Errno::ECONNREFUSED, Errno::EAFNOSUPPORT
      flash.now[:notice] = "Cannot connect to central server #{ParticipationResource.site}. Please tell Dr Nic. Do not submit your form."
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
      rescue ActiveResource::UnauthorizedAccess
        flash.now[:notice] = "Argh. The server password has changed. Please tell Dr Nic. Do not submit your form."
        render :action => "index"
      rescue Errno::ECONNREFUSED, Errno::EAFNOSUPPORT
        flash.now[:notice] = "Cannot connect to central server #{ParticipationResource.site}. Please tell Dr Nic. Do not submit your form."
        render :action => "index"
      rescue Exception => e
        flash.now[:notice] = "#{e.message} (#{e.class})"
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
