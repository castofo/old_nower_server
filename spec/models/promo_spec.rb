require "rails_helper"

describe Promo do
  describe "validations" do

    context "when title is blank" do
      promo = Promo.new
      it "should not be a valid promo" do
        expect(promo).not_to be_valid
      end

      it "should add the correct error message" do
        promo.valid?
        expect(promo.errors.messages[:title]).to include("can't be blank")
      end
    end

    context "when description is blank" do
      promo = Promo.new
      it "should not be a valid promo" do
        expect(promo).not_to be_valid
      end

      it "should add the correct error message" do
        promo.valid?
        expect(promo.errors.messages[:description]).to include("can't be blank")
      end
    end

    context "when terms is blank" do
      promo = Promo.new
      it "should not be a valid promo" do
        expect(promo).not_to be_valid
      end

      it "should add the correct error message" do
        promo.valid?
        expect(promo.errors.messages[:terms]).to include("can't be blank")
      end
    end

    context "when expiration_date is blank" do
      promo = Promo.new
      it "should not be a valid promo" do
        expect(promo).not_to be_valid
      end

      it "should add the correct error message" do
        promo.valid?
        message = "can't be blank"
        expect(promo.errors.messages[:expiration_date]).to include(message)
      end
    end

    context "when expiration_date is invalid" do
      promo = Promo.new
      promo.expiration_date = 1.year.ago
      it "should not be a valid promo" do
        expect(promo).not_to be_valid
      end

      it "should add the correct error message" do
        promo.valid?
        message = "can not be expired"
        expect(promo.errors.messages[:expiration_date]).to include(message)
      end
    end

    context "when people_limit is blank" do
      promo = Promo.new
      it "should not be a valid promo" do
        expect(promo).not_to be_valid
      end

      it "should add the correct error message" do
        promo.valid?
        message = "can't be blank"
        expect(promo.errors.messages[:people_limit]).to include(message)
      end
    end

    context "when people_limit is negative" do
      promo = Promo.new
      promo.people_limit = -1
      it "should not be a valid promo" do
        expect(promo).not_to be_valid
      end

      it "should add the correct error message" do
        promo.valid?
        message = "can not be negative or zero"
        expect(promo.errors.messages[:people_limit]).to include(message)
      end
    end
  end
end
