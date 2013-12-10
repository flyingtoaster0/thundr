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

  #Gets new user info from HTTP headers. If success, creates a new user and returns a remember_token.
  def register
    email = request.headers['email'].to_s
    username = request.headers['username'].to_s
    password = request.headers['password'].to_s
    password_confirmation = request.headers['passconf'].to_s

    @user = User.new(email: email, username: username, password: password, password_confirmation: password_confirmation)
    if @user.save
      remember_token = RememberToken.create(token: User.encrypt(User.new_remember_token), user_id: @user.id, accessed_at: Time.now)
      respond_to do |format|
        format.json { render :json => remember_token }
      end
    else
      respond_to do |format|
        format.all{head :bad_request, :content_type => 'text/html'}
      end
    end
  end

end