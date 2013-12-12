class API::SchedulesController < ApplicationController
  before_filter :restrict_access

  #In this controller, any action that accesses data validates it based on the user specified by the remember_token supplied in the header.
  #These actions will return error code 404 if the object doesn't exist, and 403 if the object doesn't belong to the user.

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

  #Returns a JSON object containing both the schedule, and courses contained in that schedule
  #Returns an empty array if the requested schedule does not exist or does not belong to the user corresponding to the remember_token supplied in the header
  def show
    #@schedule = Schedule.find(params[:id])
    @user_id = RememberToken.where(token: @remember_token).first.user_id
    @schedule = Schedule.where(user_id: @user_id).first_or_create
    if @schedule
      #@schedule_hash = Hash.new
      #@schedule_hash['schedule'] = @schedule
      #@schedule_hash['sections'] = @schedule.sections

      respond_to do |format|
        format.json {  render :json => @schedule.sections }
      end

    else
      respond_to do |format|
        format.json {  render :json => [] }
      end
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.json {  render :json => [] }
    end
  end

  #Updates the name of a schedule
  #404 if the schedule doesn't exist. 403 if it doesn't belong to the user specified by the remember token.
  def update
    @schedule = Schedule.find(params[:id])
    @schedule_list = Schedule.where(user_id: RememberToken.select(:user_id).where(token: @remember_token))
    if @schedule and @schedule_list and @schedule_list.include? @schedule
      @new_name = params[:name].gsub('+', ' ')
      @schedule.name = @new_name
      @schedule.save
      respond_to do |format|
        format.all{head :ok, :content_type => 'text/html'}
      end
    else
      respond_to do |format|
        format.all{head :forbidden, :content_type => 'text/html'}
      end
    end

  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.all{head :not_found, :content_type => 'text/html'}
    end
  end

  def destroy
    @schedule = Schedule.find(params[:id])
    @schedule_list = Schedule.where(user_id: RememberToken.select(:user_id).where(token: @remember_token))
    if @schedule and @schedule_list and @schedule_list.include? @schedule
      Schedule.destroy(params[:id])

      respond_to do |format|
        format.all{head :ok, :content_type => 'text/html'}
      end
    else
      respond_to do |format|
        format.all{head :forbidden, :content_type => 'text/html'}
      end
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.all{head :not_found, :content_type => 'text/html'}
    end
  end

  def add_section
    @user_id = RememberToken.where(token: @remember_token).first.user_id
    @schedule = Schedule.where(user_id: @user_id).first_or_create
    @section = Section.find(params[:section_id])
    if @schedule and @section and not @schedule.sections.include? @section then @schedule.sections << @section end
    respond_to do |format|
      format.all{head :ok, :content_type => 'text/html'}
    end
  else
    respond_to do |format|
      format.all{head :not_found, :content_type => 'text/html'}
    end
  end

  def delete_section
    @user_id = RememberToken.where(token: @remember_token).first.user_id
    @schedule = Schedule.where(user_id: @user_id).first
    @schedule_list = Schedule.where(user_id: RememberToken.select(:user_id).where(token: @remember_token))
    if @schedule and @schedule_list and @schedule_list.include? @schedule

      @section = Section.find(params[:section_id])
      if @schedule and @section then @schedule.sections.delete(@section) end

      respond_to do |format|
        format.all{head :ok, :content_type => 'text/html'}
      end
    else
      respond_to do |format|
        format.all{head :forbidden, :content_type => 'text/html'}
      end
    end

  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.all{head :not_found, :content_type => 'text/html'}
    end
  end

  def classes
    @classes = Array.new
    @user_id = RememberToken.where(token: @remember_token).first.user_id
    @schedule = Schedule.where(user_id: @user_id).first

    @schedule.sections.each do |s|
      s.classes.each do |k|
        @classes << k
      end
    end

    respond_to do |format|
      format.json {  render :json => @classes }
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