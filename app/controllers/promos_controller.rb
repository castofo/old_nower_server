class PromosController < ApplicationController

  def index
    render json: {
      promos: Promo.all
    },
    except: [:created_at, :updated_at],
    methods: [:current_redemptions],
    include: {

        branches: {
          except: [:created_at, :updated_at]
        }
    }
  end
end
