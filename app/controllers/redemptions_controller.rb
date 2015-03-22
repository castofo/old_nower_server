class RedemptionsController < ApplicationController

  def show
    redemption = Redemption.find_by code: params[:code]
    if redemption
      if !redemption.redeemed
        redemption.redeemed = true
        redemption.save
        render json: {
          success: true,
          message: 'Valid code'
        }
      else
        render json: {
          success: false,
          message: 'Code is already in use'
        }
      end
    else
      render json: {
        success: false,
        state: 'Code does not exist'
      }
    end
  end

end
