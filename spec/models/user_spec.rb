require "rails_helper"

describe User do
  describe "validations" do

    context "when email is blank" do
      user = User.new
      it "should not be a valid user" do
        expect(user).not_to be_valid
      end
      it "should add the correct error message" do
        user.valid?
        expect(user.errors.messages[:email]).to include(
          I18n.t('activerecord.errors.models.user.attributes.email.blank'))
      end
    end

    context "when email already exists" do
      first = User.create name: "Test", email: "test1@gmail.com",
                          birthday: 20.years.ago, gender: "m", password: "123",
                          password_confirmation: "123"

      it "should add the correct error message" do
        user = User.create email: "test1@gmail.com"
        expect(user.errors.messages[:email]).to include(
          I18n.t('activerecord.errors.models.user.attributes.email.taken'))
        user.destroy
        first.destroy
      end
    end

    context "when email is incorrect" do
      user = User.new
      user.email = "savanegasg@gmail"
      it "should not be a valid user" do
        expect(user).not_to be_valid
      end
      it "should add the correct error message" do
        user.valid?
        expect(user.errors.messages[:email]).to include(
          I18n.t('activerecord.errors.models.user.attributes.email.invalid'))
      end
    end

    context "when name is blank" do
      user = User.new
      it "should not be a valid user" do
        expect(user).not_to be_valid
      end

      it "should add the correct error message" do
        user.valid?
        expect(user.errors.messages[:name]).to include(
          I18n.t('activerecord.errors.models.user.attributes.name.blank'))
      end
    end

    context "when gender is blank" do
      user = User.new
      it "should not be a valid user" do
        expect(user).not_to be_valid
      end

      it "should add the correct error message" do
        user.valid?
        expect(user.errors.messages[:gender]).to include(
          I18n.t('activerecord.errors.models.user.attributes.gender.blank'))
      end
    end

    context "when gender is incorrect" do
      user = User.new
      user.gender = "a"

      it "should add the correct error message" do
        user.valid?
        expect(user.errors.messages[:gender]).to include(
          I18n.t('errors.user.gender.is_invalid'))
      end
    end

    context "when birthday is blank" do
      user = User.new
      it "should not be a valid user" do
        expect(user).not_to be_valid
      end

      it "should add the correct error message" do
        user.valid?
        expect(user.errors.messages[:birthday]).to include(
          I18n.t('activerecord.errors.models.user.attributes.birthday.blank'))
      end
    end

    context "when is too young" do
      user = User.new
      user.birthday = 2.years.ago
      it "should not be a valid user" do
        expect(user).not_to be_valid
      end

      it "should add the correct error message" do
        user.valid?
        expect(user.errors.messages[:birthday]).to include(
          I18n.t('errors.user.birthday.too_young'))
      end
    end

    context "when is too old" do
      user = User.new
      user.birthday = 151.years.ago
      it "should not be a valid user" do
        expect(user).not_to be_valid
      end

      it "should add the correct error message" do
        user.valid?
        expect(user.errors.messages[:birthday]).to include(
          I18n.t('errors.user.birthday.too_old'))
      end
    end

    #context "when password is blank" do
    #  user = User.new
    #  it "should not be a valid user" do
    #    expect(user).not_to be_valid
    #  end
    #
    #  it "should add the correct error message" do
    #    user.valid?
    #    expect(user.errors.messages[:password]).to include(
    #      I18n.t('activerecord.errors.models.user.attributes.password.blank'))
    #  end
    #end

    context "when password has not confirmation" do
      user = User.new
      user.password = "123"
      it "should not be a valid user" do
        expect(user).not_to be_valid
      end

      it "should add the correct error message" do
        user.valid?
        expect(user.errors.messages[:password_confirmation]).to include(
          I18n.t('activerecord.errors.models.user.attributes.'\
                 'password_confirmation.blank'))
      end
    end

    context "when changing password with confirmation unmatching" do
      usr1 = User.create name: "Test", email: "test2@gmail.com",
                         birthday: 20.years.ago, gender: "m", password: "123",
                         password_confirmation: "123"

      it "should add the correct error message" do
        usr2 = User.find_by email: "test2@gmail.com"
        usr2.password = "12345"
        usr2.password_confirmation = "12345678910"
        usr2.save
        expect(usr2.errors.messages[:password_confirmation]).to include(
          I18n.t('activerecord.errors.models.user.attributes.'\
                 'password_confirmation.confirmation'))
        usr1.destroy
        usr2.destroy
      end
    end
  end
end
