class StoresController < ApplicationController
  #before_filter :authenticate!, only: [:show]

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
    if !category
      store.errors.add(:category, I18n.t('errors.category.is_invalid'))
    end
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

  def update
    store = Store.find_by id: update_params[:id]
    if !store
      store = Store.new
      store.errors.add(:id, I18n.t('errors.id.is_invalid'))
      status = :bad_request
    elsif store.errors.empty? && store.update_attributes(update_params)
      render json: {
        success: true,
        store: store
      },
      except: [:created_at, :updated_at]
      return # Keep this to avoid double render
    end
    render json: {
      success: false,
      errors: store.errors
    },
    status: status ? status : :unprocessable_entity
  end

  def show
    store = Store.find_by id: params[:id]
    if store
      render json: {
        store: store
      },
      except: [:password, :salt, :created_at, :updated_at]
    else
      store = Store.new
      store.errors.add(:id, I18n.t('errors.id.is_invalid'))
      render json: {
        success: false,
        errors: store.errors
      },
      status: :not_found
    end
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
          login: [I18n.t('errors.store.wrong_email_or_password')]
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
          store: [I18n.t('errors.store.is_invalid')]
        }
      },
      status: :unauthorized
    end
  end

  def destroy
    store = Store.find_by id: params[:id]
    if !store
      store = Store.new
      store.errors.add(:id, I18n.t('errors.id.is_invalid'))
      status = :bad_request
    else
      store.destroy
      render json: {
        success: true,
        message: {
          store: [I18n.t('messages.store.deleted')]
        }
      }
      return # Keep this to avoid double render
    end
    render json: {
      success: false,
      errors: store.errors
    },
    status: status ? status : :unprocessable_entity
  end

  private
  def create_params
    params.require(:store).permit(:email, :name, :main_phone, :nit, :password,
                                  :password_confirmation, :category_id, :logo)
  end

  def update_params
    params.require(:store).permit(:id, :email, :name, :main_phone, :password,
                                  :nit, :password_confirmation, :category_id,
                                  :logo)
  end

  def login_params
    params.require(:store).permit(:email, :password).merge(user_type: "store")
  end
end
