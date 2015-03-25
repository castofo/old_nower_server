class PromosController < ApplicationController

  def index
    render json: {
      promos: Promo.all
    },
    only: [:promos, :id, :title, :expiration_date],
    methods: [:available_redemptions],
    include: {
        branches: {
          only: [:id, :latitude, :longitude, :store_id]
        }
    }
  end

  def show
    promo = Promo.find_by id: params[:id]
    if promo
      render json: {
        promo: promo
      },
      except: [:created_at, :updated_at],
      methods: [:available_redemptions]
    else
      render json: {
        success: false,
        errors: ["Unable to find the promo"]
      },
      status: 404
    end
  end

  def create
    promo = Promo.new create_params
    arr = []
    create_params_branches[:branches].each do | branch |
      arr.push(branch["id"])
    end
    branches = Branch.where(id: arr)
    if branches.count != arr.count
      render json: {
        success: false,
        errors: ["Some provided branches are invalid"]
      }
    else
      promo.branches = branches
      if promo.save
        render json: {
          success: true,
          promo: promo,
          branches: promo.branches
        },
        except: [:created_at, :updated_at]
      else
        render json: {
          success: false,
          errors: promo.errors
        }
      end
    end
  end

  private
  def create_params
    params.require(:promo).permit(:title, :description, :terms,
                                  :expiration_date, :people_limit)
  end

  def create_params_branches
    params.require(:promo).permit(branches: [:id])
  end
end
