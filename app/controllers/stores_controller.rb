class StoresController < ApplicationController

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

  private
  def create_params
    params.require(:store).permit(:email, :name, :category, :main_phone,
                                  :password, :password_confirmation)
  end
end
