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
      except: [:password, :salt, :created_at, :updated_at]
    else
      render json: {
        success: false,
        errors: user.errors
      }
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
          login: ["Wrong email or password"]
        }
      }
    end
  end

  def get_redemptions
    user = User.find_by id: params[:id]
    if user
      render json: {
        redemptions: user.redemptions
      },
      except: [:promo_id, :created_at, :updated_at],
      methods: [:store_name],
      include: {
        promo: {
          only: [:id, :title, :expiration_date],
          methods: [:available_redemptions]
        }
      }
    else
      render json: {
        errors: {
          user: ["Invalid user"]
        }
      }
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
end
