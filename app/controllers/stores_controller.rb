class StoresController < ApplicationController
  before_filter :authenticate!, only: [:show]

  def index
    render json: {
      stores: Store.all
    },
    except: [:password, :salt, :created_at, :updated_at]
  end

  def create
    store = Store.new create_params
    category_ids = []
    create_params_categories[:categories].each do | category |
      category_ids.push(category["id"])
    end
    categories = Category.where(id: category_ids)
    store.categories = categories
    if store.save
      render json: {
        success: true,
        store: store
      },
      include: {
          categories: {
            only: [:id, :name]
          },
      },
      except: [:password, :salt, :created_at, :updated_at]
    else
      render json: {
        success: false,
        errors: store.errors
      }
    end
  end

  def show
    render json: {
      store: current_person
    },
    except: [:salt, :created_at, :updated_at, :password]
  end

  def login
    email = login_params[:email]
    passwd = login_params[:password]
    user_type = login_params[:user_type]
    store = Auth.authenticate email, passwd, user_type
    if store
      render json: {
        success: true,
        store: store
      },
      only: [:success, :store, :token, :store_id]
    else
      render json: {
        success: false,
        errors: ["Login failed"]
      }
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
        errors: ["Invalid store"]
      }
    end
  end

  private
  def create_params
    params.require(:store).permit(:email, :name, :main_phone,
                                  :password, :password_confirmation)
  end

  def login_params
    params.require(:store).permit(:email, :password).merge(user_type: "store")
  end

  def create_params_categories
    params.require(:store).permit(categories: [:id])
  end
end
