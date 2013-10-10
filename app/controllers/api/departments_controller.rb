class API::DepartmentsController < ApplicationController
  def index
    @departments = Department.all
    respond_to do |format|
      format.json { render :json => @departments }
    end
  end
end