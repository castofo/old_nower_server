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
      promo = Promo.new
      promo.errors.add(:id, "was not found")
      render json: {
        success: false,
        errors: promo.errors
      },
      status: :not_found
    end
  end

  def create
    promo = Promo.new create_params
    branches_json = create_params_branches[:branches]
    if !branches_json
      promo.errors.add(:branches, "were not selected")
      status = :bad_request
    end
    arr = []
    if promo.errors.empty?
      create_params_branches[:branches].each do | branch |
        arr.push(branch["id"])
      end
    end
    branches = Branch.where(id: arr)
    if branches.count != arr.count
      promo.errors.add(:branches, "some provided branches are invalid")
      status = :unprocessable_entity
    end
    if promo.errors.empty?
      promo.branches = branches
      if promo.save
        render json: {
          success: true,
          promo: promo,
          branches: promo.branches
        },
        except: [:created_at, :updated_at],
        status: :created
        return # Keep this to avoid double render
      end
    end
    render json: {
      success: false,
      errors: promo.errors
    },
    status: status ? status : :unprocessable_entity
  end

  def fetch_promos
    promos_json = fetch_promos_params[:promos]
    promo = Promo.new
    if !promos_json
      promo.errors.add(:ids, "were not provided")
      status = :bad_request
    end
    if promo.errors.empty?
      promo_ids = Set.new
      fetch_promos_params[:promos].each do | promo |
        promo_ids.add promo["id"]
      end
      promos = Promo.where id: promo_ids.to_a
      if promos.count == 0
        promo.errors.add(:ids, "were not found")
        status = :unprocessable_entity
      end
      if promo.errors.empty?
        render json: {
          promos: promos
        },
        except: [:created_at, :updated_at],
        methods: [:available_redemptions, :has_expired]
        return # Keep this to avoid double render
      end
    end
    render json: {
      success: false,
      errors: promo.errors
    },
    status: status ? status : :unprocessable_entity
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
