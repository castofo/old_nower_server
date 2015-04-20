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
        expect(user.errors.messages[:email]).to include("can't be blank")
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
        expect(user.errors.messages[:email]).to include("is invalid")
      end
    end

    context "when user email already exists" do
      User.create name: "Santiago", email: "savanegasg@gmail.com",
                         birthday: Date.today, gender: "m", password: "123",
                         password_confirmation: "123"
      it "should add the correct error message" do
        usr = User.create name: "Santiago", email: "savanegasg@gmail.com",
                           birthday: Date.today, gender: "m", password: "123",
                           password_confirmation: "123"
        expect(usr.errors.messages[:email]).to include("has already been taken")
      end
    end

    context "when name is blank" do
      user = User.new
      it "should not be a valid user" do
        expect(user).not_to be_valid
      end

      it "should add the correct error message" do
        user.valid?
        expect(user.errors.messages[:name]).to include("can't be blank")
      end
    end
  end
end
