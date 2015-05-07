class UsersController < ApplicationController
  before_filter :authenticate!, only: [:show]

  def index
    render json: {
      users: User.all
    },
    except: [:password, :salt, :created_at, :updated_at]
  end

  def create
    user = User.new create_params
    if user.save
      render json: {
        success: true,
        user: user
      },
      except: [:password, :salt, :created_at, :updated_at],
      status: :created
    else
      render json: {
        success: false,
        errors: user.errors
      },
      status: :unprocessable_entity
    end
  end

  def show
    render json: {
      user: current_person
    },
    except: [:salt, :created_at, :updated_at, :password]
  end

  def login
    email = login_params[:email]
    passwd = login_params[:password]
    user_type = login_params[:user_type]
    auth = Auth.authenticate email, passwd, user_type
    if auth
      token = auth.token
      render json: {
        success: true,
        user: auth.user,
        token: token
      },
      except: [:password, :salt, :created_at, :updated_at]
    else
      render json: {
        success: false,
        errors: {
          login: [I18n.translate('errors.user.wrong_email_or_password')]
        }
      },
      status: :bad_request
    end
  end

  def facebook_login
    fb_auth = FacebookAuth.new
    fb_auth.attributes = facebook_login_params.reject do |key, value|
      !fb_auth.attributes.keys.member? key.to_s
    end
    existing_auth = FacebookAuth.find_by facebook_id: fb_auth.facebook_id
    if existing_auth
      # The user was already registered
      # TODO Some authentication process
      existing_auth.token = fb_auth.token
      existing_auth.expires = fb_auth.expires
      existing_auth.save
      fb_auth = existing_auth
      user = fb_auth.user
      status = :ok
    else
      # Create a new user and associate it with the token
      user = User.new
      user.attributes = facebook_login_params.reject do |key, value|
        !user.attributes.keys.member? key.to_s
      end
      # Only the first character of the string
      user.gender = user.gender[0]
      # Suppose the user birthday as maximum years ago
      if facebook_login_params[:age_range][:max]
        user.birthday = facebook_login_params[:age_range][:max].years.ago
      # If maximum doesn't exist, try with minimum
      elsif facebook_login_params[:age_range][:min]
        user.birthday = facebook_login_params[:age_range][:min].years.ago
      end
      if user.save
        status = :created
        fb_auth.user = user
        # TODO Some authentication process
        user.destroy unless fb_auth.save
      end
    end
    if fb_auth.errors.empty? && user.errors.empty?
      render json: {
        success: true,
        user: user
      },
      status: status
    else
      render json: {
        success: false,
        errors: user.errors.any? ? user.errors : fb_auth.errors
      },
      status: :bad_request
    end
  end

  def get_redemptions
    user = User.find_by id: params[:id]
    if user
      render json: {
        redemptions: user.redemptions
      },
      except: [:promo_id, :created_at, :updated_at],
      methods: [:store_name, :store_logo],
      include: {
        promo: {
          only: [:id, :title, :expiration_date, :picture],
          methods: [:available_redemptions]
        }
      }
    else
      render json: {
        errors: {
          user: [I18n.translate('errors.user.is_invalid')]
        }
      },
      status: :unauthorized
    end
  end

  private
  def create_params
    params.require(:user).permit(:email, :name, :gender, :birthday,
    :password, :password_confirmation)
  end

  def login_params
    params.require(:user).permit(:email, :password).merge(user_type: "user")
  end

  def facebook_login_params
    params.require(:user).permit(:email, :name, :gender, :token, :facebook_id,
      :expires, age_range: [:min, :max])
  end
end
