class StoresController < ApplicationController
  before_filter :authenticate!, only: [:show]

  def index
    render json: {
      stores: Store.all
    },
    include: {
      category: {
        only: [:id, :name]
      }
    },
    except: [:password, :salt, :created_at, :updated_at]
  end

  def create
    store = Store.new create_params
    category = Category.find_by id: create_params[:category_id]
    store.errors.add(:category, "is invalid") if !category
    if store.errors.empty? && store.save
      render json: {
        success: true,
        store: store
      },
      include: {
          category: {
            only: [:id, :name]
          },
      },
      except: [:password, :salt, :created_at, :updated_at],
      status: :created
      return # Keep this to avoid double render
    end
    render json: {
      success: false,
      errors: store.errors
    },
    status: :unprocessable_entity
  end

  def show
    render json: {
      store: current_person
    },
    include: {
      category: {
        only: [:id, :name]
      }
    },
    except: [:salt, :created_at, :updated_at, :password]
  end

  def login
    email = login_params[:email]
    passwd = login_params[:password]
    user_type = login_params[:user_type]
    auth = Auth.authenticate email, passwd, user_type
    if auth
      render json: {
        success: true,
        token: auth.token,
        store: Store.find_by(id: auth.store_id)
      },
      except: [:password, :salt, :created_at, :updated_at, :category_id]
    else
      render json: {
        success: false,
        errors: {
          login: ["Wrong email or password"]
        }
      },
      status: :bad_request
    end
  end

  def get_branches
    store = Store.find_by id: params[:id]
    if store
      render json: {
        branches: store.branches
      },
      except: [:created_at, :updated_at]
    else
      render json: {
        errors: {
          store: ["is invalid"]
        }
      },
      status: :unauthorized
    end
  end

  private
  def create_params
    params.require(:store).permit(:email, :name, :main_phone, :password,
                                  :password_confirmation, :category_id)
  end

  def login_params
    params.require(:store).permit(:email, :password).merge(user_type: "store")
  end
end
