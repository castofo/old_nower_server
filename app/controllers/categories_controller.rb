class CategoriesController < ApplicationController

  def index
    categories = Category.all
    render json: {
      categories: categories
    },
    only: [:categories, :id, :name]
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
        error: "category not found"
      }
    end
  end
end
