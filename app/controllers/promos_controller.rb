class PromosController < ApplicationController

  def index
    render json: {
      promos: Promo.all
    },
    only: [:promos, :id, :title, :expiration_date],
    methods: [:available_redemptions, :has_expired],
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
      methods: [:available_redemptions, :has_expired]
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
    branches_json = create_params_branches[:branches]
    promo.errors.add(:branches, "were not selected") if !branches_json
    arr = []
    if promo.errors.empty?
      create_params_branches[:branches].each do | branch |
        arr.push(branch["id"])
      end
    end
    branches = Branch.where(id: arr)
    if branches.count != arr.count
      promo.errors.add(:branches, "some provided branches are invalid")
    end
    if promo.errors.empty?
      promo.branches = branches
      if promo.save
        render json: {
          success: true,
          promo: promo,
          branches: promo.branches
        },
        except: [:created_at, :updated_at]
        return # Keep this to avoid double render
      end
    end
    render json: {
      success: false,
      errors: promo.errors
    }
  end

  def fetch_promos
    promo_ids = Set.new
    fetch_promos_params[:promos].each do | promo |
      promo_ids.add promo["id"]
    end
    promos = Promo.where id: promo_ids.to_a
    if promos
      render json: {
        promos: promos
      },
      except: [:created_at, :updated_at],
      methods: [:available_redemptions, :has_expired]
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

  def fetch_promos_params
    params.permit(promos: [:id])
  end
end
