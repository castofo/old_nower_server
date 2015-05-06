class PromosController < ApplicationController

  def index
    render json: {
      promos: Promo.all
    },
    only: [:promos, :id, :title, :expiration_date, :picture],
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
      promo.errors.add(:id, I18n.t('errors.id.is_invalid'))
      render json: {
        success: false,
        errors: promo.errors
      },
      status: :not_found
    end
  end

  def create
    promo = Promo.new create_params
    branches = params.require(:promo).permit(:branches)
    if branches[:branches] && branches[:branches].instance_of?(String)
      branches_json = JSON.parse(branches[:branches])
    else
      branches_json = create_params_branches[:branches]
    end
    if !branches_json
      promo.errors.add(:branches, I18n.t('errors.branch.not_selected'))
      status = :bad_request
    end
    arr = []
    if promo.errors.empty?
      branches_json.each do | branch |
        arr.push(branch["id"])
      end
    end
    branches = Branch.where(id: arr)
    if branches.count != arr.count
      promo.errors.add(:branches, I18n.t('errors.branch.some_are_invalid'))
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

  def update
    promo = Promo.find_by id: update_params[:id]
    if !promo
      promo = Promo.new
      promo.errors.add(:id, I18n.t('errors.id.is_invalid'))
      status = :bad_request
    elsif promo.errors.empty? && promo.update_attributes(update_params)
      render json: {
        success: true,
        promo: promo
      },
      except: [:created_at, :updated_at]
      return # Keep this to avoid double render
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
      promo.errors.add(:promos, I18n.t('errors.promo.not_provided'))
      status = :bad_request
    end
    if promo.errors.empty?
      promo_ids = Set.new
      fetch_promos_params[:promos].each do | promo |
        promo_ids.add promo["id"]
      end
      promos = Promo.where id: promo_ids.to_a
      if promos.count == 0
        promo.errors.add(:promos, I18n.t('errors.promo.some_are_invalid'))
        status = :unprocessable_entity
      end
      if promo.errors.empty?
        render json: {
          promos: promos
        },
        except: [:created_at, :updated_at],
        methods: [:available_redemptions, :has_expired, :store_logo]
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
                                  :expiration_date, :people_limit, :picture)
  end

  def create_params_branches
    params.require(:promo).permit(branches: [:id])
  end

  def update_params
    params.require(:promo).permit(:id, :title, :description, :terms,
                                  :expiration_date, :people_limit, :picture)
  end

  def fetch_promos_params
    params.permit(promos: [:id])
  end
end
