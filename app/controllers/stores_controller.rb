class StoresController < ApplicationController
  before_filter :authenticate!, only: [:show]

  def index
    render json: {
      promos: Store.all
    },
    except: [:password, :salt, :created_at, :updated_at]
  end

  def create
    @store = Store.new create_params
    if @store.save
      render json: {
        success: true,
        store: @store
      },
      except: [:password, :salt, :created_at, :updated_at]
    else
      render json: {
        success: false,
        errors: @store.errors
      }
    end
  end

  def show
    render json: {
      store: current_person
    },
    except: [:salt, :created_at, :updated_at, :password]
  end

  private
  def create_params
    params.require(:store).permit(:email, :name, :category, :main_phone,
                                  :password, :password_confirmation)
  end
end
