class API::SchedulesController < ApplicationController
  before_filter :restrict_access

  #Returns all the schedules belonging to a particular user
  def index
    @schedules = Schedule.where(user_id: RememberToken.select(:user_id).where(token: @remember_token)).all
    respond_to do |format|
      format.json { render :json => @schedules }
    end
  end

  def create
    @name = params[:name].gsub('+', ' ')
    @user_id = RememberToken.where(token: @remember_token).first.user_id
    Schedule.create(name: @name, user_id: @user_id)

    respond_to do |format|
      format.all{head :ok, :content_type => 'text/html'}
    end
  end

  def destroy
    Schedule.destroy(params[:id])

    respond_to do |format|
      format.all{head :ok, :content_type => 'text/html'}
    end
  end

  def add_section
    @schedule = Schedule.find(params[:id])
    @section = Section.find(params[:section_id])
    if @schedule and @section then @schedule.sections << @section end
    respond_to do |format|
      format.all{head :ok, :content_type => 'text/html'}
    end
  end

  def delete_section
    @schedule = Schedule.find(params[:id])
    @section = Section.find(params[:section_id])
    if @schedule and @section then @schedule.sections.delete(@section) end

    respond_to do |format|
      format.all{head :ok, :content_type => 'text/html'}
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