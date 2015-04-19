class RedemptionsController < ApplicationController

  def generate_code
    promo_id = generate_code_params["promo_id"]
    user_id = generate_code_params["user_id"]
    promo = Promo.find_by id: promo_id
    user = User.find_by id: user_id
    redemption = Redemption.new

    # Catching errors
    redemption.errors.add(:promo, "is invalid") if !promo
    redemption.errors.add(:user, "is ivalid") if !user
    if user && promo && Redemption.find_by(user: user, promo: promo)
      redemption.errors.add(:promo, "was already taken by you")
    end
    if promo && promo.has_expired
      redemption.errors.add(:promo, "has already expired")
    end
    if promo && promo.available_redemptions == 0
      redemption.errors.add(:promo, "has no more stocks")
    end

    if !redemption.errors.any?
      # No errors, continue to create the redemption
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
        return # KEEP THIS or a double render will occur
      end
    end
    render json: {
      success: false,
      errors: redemption.errors
    }
  end

  def redeem
    redemption = Redemption.find_by redeem_params
    if redemption
      if !redemption.redeemed
        redemption.redeemed = true
        if redemption.save
          render json: {
            success: true,
            promo: redemption.promo,
            user: redemption.user
          },
          methods: [:available_redemptions],
          except: [:created_at, :updated_at, :password, :salt]
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
