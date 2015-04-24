class CategoriesController < ApplicationController

  def index
    categories = Category.all
    render json: {
      categories: categories
    },
    only: [:categories, :id, :name]
  end

  def create
    category = Category.new create_params
    if category
      render json: {
        success: true,
        store: category
      },
      except: [:created_at, :updated_at],
      status: :created
      return # Keep this to avoid double render
    end
    render json: {
      success: false,
      errors: cateogory.errors
    },
    status: :unprocessable_entity
  end

  def show
    category = Category.find_by id: params[:id]
    if category
      render json: {
        category: category
      },
      only: [:category, :id, :name]
    else
      render json: {
        errors: {
          category: ["not found"]
        }
      },
      status: :not_found
    end
  end

  private
  def create_params
    params.require(:category).permit(:name, :description)
  end
end
