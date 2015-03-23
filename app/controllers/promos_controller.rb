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
    if promo.save
      render json: {
        success: true,
        store: promo
      },
      except: [:password, :salt, :created_at, :updated_at]
    else
      render json: {
        success: false,
        errors: promo.errors
      }
    end
  end

  def get_by_locations
    render json: {
      locations: Branch.all
    },
    only: [:locations, :id, :latitude, :longitude, :store_id],
    include: {
      promos: {
        only: [:promos, :id, :title, :expiration_date],
        methods: [:available_redemptions]
      }
    }
  end

  private
  def create_params
    params.require(:promo).permit(:title, :description, :terms,
                                  :expiration_date, :people_limit)
  end
end
