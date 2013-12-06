module SessionsHelper
  def sign_in(user)
    remember_token_string = User.new_remember_token
    cookies.permanent[:remember_token_string] = remember_token_string

    RememberToken.create(token: User.encrypt(remember_token_string), user_id: user.id, accessed_at: Time.now)

    #user.update_attribute(:remember_token_string, User.encrypt(remember_token_string))
    #self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    access
    remember_token_string = User.encrypt(cookies[:remember_token_string])
    @current_user ||= User.where(id: RememberToken.select(:user_id).where(token: remember_token_string)).first
  end

  def signed_in?
    access
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token_string)
    remember_token_string = User.encrypt(cookies[:remember_token_string])
    RememberToken.where(token: remember_token_string).delete_all
  end


  private
  def access
    remember_token_string = User.encrypt(cookies[:remember_token_string])

    remember_token = RememberToken.select(:user_id).where(token: remember_token_string).first
    unless remember_token.nil?
      remember_token.update_attribute(:accessed_at, Time.now)
    end
  end
end
