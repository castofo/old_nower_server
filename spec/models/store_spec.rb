require "rails_helper"

describe Store do
  describe "validations" do

    context "when email is blank" do
      store = Store.new
      it "should not be a valid store" do
        expect(store).not_to be_valid
      end
      it "should add the correct error message" do
        store.valid?
        expect(store.errors.messages[:email]).to include(
          I18n.t('activerecord.errors.models.store.attributes.email.blank'))
      end
    end

    context "when email already exists" do
      first = Store.create name: "Test", email: "test1@gmail.com",
                           main_phone: "1234567", password: "123",
                           password_confirmation: "123", category_id: 1

      it "should add the correct error message" do
        store = Store.create email: "test1@gmail.com"
        expect(store.errors.messages[:email]).to include(
          I18n.t('activerecord.errors.models.store.attributes.email.taken'))
        store.destroy
        first.destroy
      end
    end

    context "when email is incorrect" do
      store = Store.new
      store.email = "littlestore.com"
      it "should not be a valid store" do
        expect(store).not_to be_valid
      end
      it "should add the correct error message" do
        store.valid?
        expect(store.errors.messages[:email]).to include(
          I18n.t('activerecord.errors.models.store.attributes.email.invalid'))
      end
    end

    context "when name is blank" do
      store = Store.new
      it "should not be a valid store" do
        expect(store).not_to be_valid
      end

      it "should add the correct error message" do
        store.valid?
        expect(store.errors.messages[:name]).to include(
          I18n.t('activerecord.errors.models.store.attributes.name.blank'))
      end
    end

    context "when main_phone is blank" do
      store = Store.new
      it "should not be a valid store" do
        expect(store).not_to be_valid
      end

      it "should add the correct error message" do
        store.valid?
        expect(store.errors.messages[:main_phone]).to include(
          I18n.t('activerecord.errors.models.store.attributes.main_phone'\
                 '.blank'))
      end
    end

    context "when password is blank" do
      store = Store.new
      it "should not be a valid store" do
        expect(store).not_to be_valid
      end

      it "should add the correct error message" do
        store.valid?
        expect(store.errors.messages[:password]).to include(
          I18n.t('activerecord.errors.models.store.attributes.password.blank'))
      end
    end

    context "when password has not confirmation" do
      store = Store.new
      store.password = "123"
      it "should not be a valid store" do
        expect(store).not_to be_valid
      end

      it "should add the correct error message" do
        store.valid?
        expect(store.errors.messages[:password_confirmation]).to include(
          I18n.t('activerecord.errors.models.store.attributes.'\
                 'password_confirmation.blank'))
      end
    end

    context "when changing password with confirmation unmatching" do
      first = Store.create name: "Test", email: "test2@gmail.com",
                           main_phone: "1234567", password: "123",
                           password_confirmation: "123", category_id: 1

      it "should add the correct error message" do
        store = Store.find_by email: "test2@gmail.com"
        store.password = "12345"
        store.password_confirmation = "12345678910"
        store.save
        expect(store.errors.messages[:password_confirmation]).to include(
          I18n.t('activerecord.errors.models.store.attributes.'\
                 'password_confirmation.confirmation'))
        first.destroy
        store.destroy
      end
    end
  end
end
