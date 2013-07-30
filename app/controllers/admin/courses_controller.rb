class Admin::CoursesController < ApplicationController
  include SessionsHelper
  @test = 'tetstst'
  _isAdmin = true
  if _isAdmin #asdf

    redirect_to root_url
  end

  def new
  end

  def create
  end

  def show
  end

  def index
  end


end
