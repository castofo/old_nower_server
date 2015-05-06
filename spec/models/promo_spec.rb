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
        expect(promo.errors.messages[:title]).to include(
          I18n.t('activerecord.errors.models.promo.attributes.title.blank'))
      end
    end

    context "when description is blank" do
      promo = Promo.new
      it "should not be a valid promo" do
        expect(promo).not_to be_valid
      end

      it "should add the correct error message" do
        promo.valid?
        expect(promo.errors.messages[:description]).to include(
          I18n.t('activerecord.errors.models.promo.attributes.description'\
                 '.blank'))
      end
    end

    context "when terms is blank" do
      promo = Promo.new
      it "should not be a valid promo" do
        expect(promo).not_to be_valid
      end

      it "should add the correct error message" do
        promo.valid?
        expect(promo.errors.messages[:terms]).to include(
          I18n.t('activerecord.errors.models.promo.attributes.terms.blank'))
      end
    end

    context "when expiration_date is blank" do
      promo = Promo.new
      it "should not be a valid promo" do
        expect(promo).not_to be_valid
      end

      it "should add the correct error message" do
        promo.valid?
        expect(promo.errors.messages[:expiration_date]).to include(
          I18n.t('activerecord.errors.models.promo.attributes.expiration_date'\
                 '.blank'))
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
        expect(promo.errors.messages[:expiration_date]).to include(
          I18n.t('errors.promo.expiration_date.cannot_be_expired'))
      end
    end

    context "when people_limit is blank" do
      promo = Promo.new
      it "should not be a valid promo" do
        expect(promo).not_to be_valid
      end

      it "should add the correct error message" do
        promo.valid?
        expect(promo.errors.messages[:people_limit]).to include(
          I18n.t('activerecord.errors.models.promo.attributes.people_limit'\
                 '.blank'))
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
        expect(promo.errors.messages[:people_limit]).to include(
          I18n.t('errors.promo.people_limit.is_negative'))
      end
    end
  end
end
