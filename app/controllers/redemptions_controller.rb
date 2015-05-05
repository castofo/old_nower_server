class RedemptionsController < ApplicationController

  def generate_code
    promo_id = generate_code_params["promo_id"]
    user_id = generate_code_params["user_id"]
    promo = Promo.find_by id: promo_id
    user = User.find_by id: user_id
    redemption = Redemption.new

    # Catching errors
    if !promo
      redemption.errors.add(:promo_id, I18n.t('errors.promo.is_invalid'))
    end
    redemption.errors.add(:user_id, I18n.t('errors.user.is_invalid')) if !user
    if user
      if promo && Redemption.find_by(user: user, promo: promo)
        redemption.errors.add(:promo, I18n.t('errors.promo.already_taken'))
      end
      if user.active_redemptions >= 5
        message = I18n.t('errors.redemption.limit_exceeded')
        redemption.errors.add(:user, message)
      end
    end
    if promo && promo.has_expired
      redemption.errors.add(:promo, I18n.t('errors.promo.already_expired'))
    end
    if promo && promo.available_redemptions == 0
      redemption.errors.add(:promo_stock, I18n.t('errors.promo.no_more_stock'))
    end
    if !redemption.errors.any?
      # No errors, continue to create the redemption
      redemption.user = user
      redemption.promo = promo
      redemption.generate_code
      if redemption.save
        render json: {
          success: true,
          redemption: redemption,
          promo: promo
        },
        methods: [:available_redemptions],
        only: [:success, :redemption, :code, :promo_id, :user_id, :redeemed,
               :promo, :available_redemptions]
        return # KEEP THIS or a double render will occur
      end
    end
    render json: {
      success: false,
      errors: redemption.errors
    },
    status: :unprocessable_entity
  end

  def redeem
    redemption = Redemption.find_by redeem_params
    if !redemption
      redemption = Redemption.new
      redemption.errors.add(:code, I18n.t('errors.redemption.invalid_code'))
    else
      if redemption.redeemed
        redemption.errors.add(:code,
          I18n.t('errors.redemption.already_redeemed'))
      else
        redemption.redeemed = true #-- Commented for test purposes
        if redemption.save
          render json: {
            success: true,
            promo: redemption.promo,
            user: redemption.user
          },
          methods: [:available_redemptions],
          except: [:created_at, :updated_at, :password, :salt]
          return # KEEP THIS or a double render will occur
        end
      end
    end
    render json: {
      success: false,
      errors: redemption.errors
    },
    status: :unprocessable_entity
  end

  private
  def redeem_params
    params.require(:redemption).permit(:code)
  end

  def generate_code_params
    params.permit(:promo_id, :user_id)
  end
end
