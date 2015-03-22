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

  private
  def create_params
    params.require(:user).permit(:email, :name, :gender, :birthday,
    :password, :password_confirmation)
  end
end
