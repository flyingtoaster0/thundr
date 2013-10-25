class AdminController < ApplicationController
  include AdminHelper


  def launch_update

    @testAdmin = Admin.new
    @testAdmin.run_db_import

    #run_db_import
    redirect_to action: 'index', :doUpdate => true
  end

  def get_info
    @percent = Progress.first.percent
    render inline: @percent.to_s
  end

  def show
    @percent = Progress.first.percent
    @description = Progress.first.description
    render inline: @percent.to_s << "$$" << @description
  end

  def confirm
    @prog = Progress.first
    @prog.percent = 0
    @prog.description = ''
    @prog.save
    redirect_to action: 'index'
  end

  def index
    _isAdmin = current_user.nil? ? false : current_user.admin?
    unless _isAdmin

      #redirect_to root_url
    end
  end
end