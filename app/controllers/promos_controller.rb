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
end
