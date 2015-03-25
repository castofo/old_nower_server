class RedemptionsController < ApplicationController

  def generate_code
    promo_id = generate_code_params["promo_id"]
    user_id = generate_code_params["user_id"]
    promo = Promo.find_by id: promo_id
    user = User.find_by id: user_id
    if !promo
      render json: {
        success: false,
        errors: ["Invalid promo"]
      }
    elsif !user
      render json: {
        success: false,
        errors: ["Invalid user"]
      }
    elsif Redemption.find_by user: user, promo: promo
      render json: {
        success: false,
        errors: ["You already picked this promo"]
      }
    else
      redemption = Redemption.new
      redemption.user = user
      redemption.promo = promo
      begin
        redemption.code = (SecureRandom.hex 3).upcase
      end while Redemption.exists? code: redemption.code
      if redemption.save
        render json: {
          success: true,
          redemption: redemption
        },
        only: [:success, :redemption, :code, :promo_id, :user_id, :redeemed]
      else
        render json: {
          success: false,
          errors: redemption.errors
        }
      end
    end
  end

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

  def generate_code_params
    params.permit(:promo_id, :user_id)
  end
end
