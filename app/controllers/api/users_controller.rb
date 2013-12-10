class API::UsersController < ApplicationController
  def index

  end

  #Gets the username name password from the HTTP request, authenticates, and returns a remember token if successful
  def login
    #localhost:3000/api/login -u 'admin:password'
    authenticate_or_request_with_http_basic do |username, password|
      if username.include? '%40'
        email = username.gsub('%40','@');
        @user = User.find_by_email(email.downcase)
      else
        @user = User.find_by_username(username.downcase)
      end

      if @user && @user.authenticate(password)
        remember_token = RememberToken.create(token: User.encrypt(User.new_remember_token), user_id: @user.id, accessed_at: Time.now)
        respond_to do |format|
          format.json { render :json => remember_token }
        end
      end
    end
  end
end