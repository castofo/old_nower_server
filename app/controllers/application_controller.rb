class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  skip_before_filter :verigy_authenticity_token

  def authenticate!
    if !logged_in?
      render json: {
        success: false,
        errors: {
          login: ["You don't have access"]
        }
      },
      status: :unauthorized
    end
  end

  def current_person
    @current_person ||= authenticate_with_http_token do |token, opts|
      return nil if !opts.has_key? "person"
      context = Auth.find_by token: token
      return context.store if context && opts.fetch("person") == "store"
      return context.user if context && opts.fetch("person") == "user"
      return nil
    end
  end

  def logged_in?
    return true if current_person
  end

  helper_method :current_person, :logged_in?
end
