class RedemptionsController < ApplicationController

  def redeem
    redemption = Redemption.find_by redeem_params
    if redemption
      if !redemption.redeemed
        redemption.redeemed = true
        if redemption.save
          render json: {
            success: true,
            promo: redemption.promo
          },
          except: [:created_at, :updated_at]
        else
          render json: {
            success: false,
            errors: redemption.errors
          }
        end
      else
        render json: {
          success: false,
          errors: ['The code was already redeemed']
        }
      end
    else
      render json: {
        success: false,
        errors: ['The code is invalid']
      }
    end
  end

  private
  def redeem_params
    params.require(:redemption).permit(:code)
  end
end
