require "rails_helper"

describe Redemption do
  describe "validations" do

    context "when code is blank" do
      redemption = Redemption.new
      it "should not be a valid redemption" do
        expect(redemption).not_to be_valid
      end

      it "should add the correct error message" do
        redemption.valid?
        expect(redemption.errors.messages[:code]).to include("can't be blank")
      end
    end

    context "when code already exists" do
      first = Redemption.create code: "ABCDEF", user_id: 1337, promo_id: 1337

      it "should add the correct error message" do
        rede = Redemption.create code: "ABCDEF", user_id: 1338, promo_id: 1338
        expect(rede.errors.messages[:code]).to include("has already been taken")
        rede.destroy
        first.destroy
      end
    end

    context "when promo_id is blank" do
      redemption = Redemption.new
      it "should not be a valid redemption" do
        expect(redemption).not_to be_valid
      end

      it "should add the correct error message" do
        redemption.valid?
        message = "can't be blank"
        expect(redemption.errors.messages[:promo_id]).to include(message)
      end
    end

    context "when user_id is blank" do
      redemption = Redemption.new
      it "should not be a valid redemption" do
        expect(redemption).not_to be_valid
      end

      it "should add the correct error message" do
        redemption.valid?
        message = "can't be blank"
        expect(redemption.errors.messages[:user_id]).to include(message)
      end
    end
  end
end
