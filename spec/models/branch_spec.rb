require "rails_helper"

describe Branch do
  describe "validations" do

    context "when name is blank" do
      branch = Branch.new
      it "should not be a valid branch" do
        expect(branch).not_to be_valid
      end

      it "should add the correct error message" do
        branch.valid?
        expect(branch.errors.messages[:name]).to include("can't be blank")
      end
    end

    context "when address is blank" do
      branch = Branch.new
      it "should not be a valid branch" do
        expect(branch).not_to be_valid
      end

      it "should add the correct error message" do
        branch.valid?
        expect(branch.errors.messages[:address]).to include("can't be blank")
      end
    end

    context "when latitude is blank" do
      branch = Branch.new
      it "should not be a valid branch" do
        expect(branch).not_to be_valid
      end

      it "should add the correct error message" do
        branch.valid?
        expect(branch.errors.messages[:latitude]).to include("can't be blank")
      end
    end

    context "when latitude is invalid" do
      branch = Branch.new
      it "should not be a valid if it is greater than 90" do
        branch.latitude = 90.0001
        expect(branch).not_to be_valid
      end

      it "should add the correct error message when is greater than 90" do
        branch.latitude = 90.1
        branch.valid?
        message = "must be less than or equal to 90"
        expect(branch.errors.messages[:latitude]).to include(message)
      end

      it "should not be a valid if it is less than -90" do
        branch.latitude = -9999.3141
        expect(branch).not_to be_valid
      end

      it "should add the correct error message when is less than -90" do
        branch.latitude = -90.1
        branch.valid?
        message = "must be greater than or equal to -90"
        expect(branch.errors.messages[:latitude]).to include(message)
      end
    end

    context "when longitude is invalid" do
      branch = Branch.new
      it "should not be a valid if it is greater than 180" do
        branch.longitude = 180.0001
        expect(branch).not_to be_valid
      end

      it "should add the correct error message when is greater than 180" do
        branch.latitude = 180.1
        branch.valid?
        message = "must be less than or equal to 180"
        expect(branch.errors.messages[:longitude]).to include(message)
      end

      it "should not be a valid if it is less than -180" do
        branch.latitude = -1251.61213
        expect(branch).not_to be_valid
      end

      it "should add the correct error message when is less than -180" do
        branch.longitude = -180.1
        branch.valid?
        message = "must be greater than or equal to -180"
        expect(branch.errors.messages[:longitude]).to include(message)
      end
    end

    context "when longitude is blank" do
      branch = Branch.new
      it "should not be a valid branch" do
        expect(branch).not_to be_valid
      end

      it "should add the correct error message" do
        branch.valid?
        expect(branch.errors.messages[:longitude]).to include("can't be blank")
      end
    end

    context "when phone is blank" do
      branch = Branch.new
      it "should not be a valid branch" do
        expect(branch).not_to be_valid
      end

      it "should add the correct error message" do
        branch.valid?
        expect(branch.errors.messages[:phone]).to include("can't be blank")
      end
    end

    context "when store_id" do
      branch = Branch.new
      it "should not be a valid branch" do
        expect(branch).not_to be_valid
      end

      it "should add the correct error message" do
        branch.valid?
        expect(branch.errors.messages[:store_id]).to include("can't be blank")
      end
    end
  end
end
