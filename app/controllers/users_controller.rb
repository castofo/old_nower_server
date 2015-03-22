class UsersController < ApplicationController

  def index
    render json: {
      success: true,
      users: User.all
    }
  end
end
