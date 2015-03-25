class BranchesController < ApplicationController

  def index
    render json: {
      branches: Branch.all
    },
    except: [:created_at, :updated_at]
  end

  def create
    branch = Branch.new create_params
    if branch.name && branch.store_id
      already = Branch.where name: branch.name, store_id: branch.store_id
      if already.count != 0
        render json: {
          success: false,
          errors: ["Branch already exists"],
        }
        return
      end
      if !Store.find_by id: branch.store_id
        render json: {
          success: false,
          errors: ["Invalid store"]
        }
        return
      end
    end
    if branch.save
      render json: {
        success: true,
        branch: branch
      },
      except: [:created_at, :updated_at]
    else
      render json: {
        success: false,
        errors: branch.errors
      }
    end
  end

  def get_by_locations
    render json: {
      locations: Branch.all
    },
    only: [:locations, :id, :latitude, :longitude, :store_id],
    methods: [:store_name],
    include: {
      promos: {
        only: [:promos, :id, :title, :expiration_date],
        methods: [:available_redemptions]
      }
    }
  end

  private
  def create_params
    params.require("branch").permit("name",
                                    "address",
                                    "latitude",
                                    "longitude",
                                    "phone",
                                    "store_id")
  end
end
