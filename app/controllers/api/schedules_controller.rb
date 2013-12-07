class API::SchedulesController < ApplicationController
  before_filter :restrict_access

  #Returns all the schedules belonging to a particular user
  def index
    @schedules = Schedule.where(user_id: RememberToken.select(:user_id).where(token: @remember_token)).all
    respond_to do |format|
      format.json { render :json => @schedules }
    end
  end

  private

  #Authenticates using the remember token supplied in the header of the HTTP request
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      if RememberToken.exists?(token: token) then @remember_token = token end
    end
  end

end