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
        branch.errors.add(:branch, "already exists")
        status = :conflict
      end
      if branch.errors.empty? && !Store.find_by(id: branch.store_id)
        branch.errors.add(:store, "is invalid")
        status = :unprocessable_entity
      end
    end
    if branch.errors.empty? && branch.save
      render json: {
        success: true,
        branch: branch
      },
      except: [:created_at, :updated_at],
      status: :created
      return # Keep this to avoid double render
    end
    render json: {
      success: false,
      errors: branch.errors
    },
    status: status ? status : :unprocessable_entity
  end

  def update
    branch = Branch.find_by id: update_params[:id]
    if !branch
      branch = Branch.new
      branch.errors.add(:id, "is invalid")
      status = :bad_request
    elsif branch.errors.empty? && branch.update_attributes(update_params)
      render json: {
        success: true,
        branch: branch
      },
      except: [:created_at, :updated_at]
      return # Keep this to avoid double render
    end
    render json: {
      success: false,
      errors: branch.errors
    },
    status: status ? status : :unprocessable_entity
  end

  def destroy
    branch = Branch.find_by id: params[:id]
    if !branch
      branch = Branch.new
      branch.errors.add(:id, "is invalid")
      status = :bad_request
    else
      branch.destroy
      render json: {
        success: true,
        message: {
          branch: ["was successfully deleted"]
        }
      }
      return # Keep this to avoid double render
    end
    render json: {
      success: false,
      errors: branch.errors
    },
    status: status ? status : :unprocessable_entity
  end

  def get_by_locations
    branches = Branch.all
    branches = branches.as_json(except: [:created_at, :updated_at])
    branches.each do |branch|
      store = Branch.find(branch["id"]).store
      branch["store_name"] = store.name
      branch["store_logo"] = store.logo.url(:small)
      branch["promos"] = Promo.find_by_sql(
            Promo.promos_available_by_branch_query branch["id"])
                  .as_json(except: [:created_at, :updated_at])
    end
    render json: {
      locations: branches
    },
    include: [:promos]
  end

  def get_by_locations_in_range
    query = Branch.geolocation_query get_by_locations_in_range_params
    branches = Branch.find_by_sql(query)
    branches = branches.as_json(except: [:created_at, :updated_at])
    branches.each do |branch|
      store = Branch.find(branch["id"]).store
      branch["store_name"] = store.name
      branch["store_logo"] = store.logo.url(:small)
      branch["promos"] = Promo.find_by_sql(
            Promo.promos_available_by_branch_query branch["id"])
                    .as_json(except: [:created_at, :updated_at])
    end
    render json: {
      locations: branches
    },
    include: [:promos]
  end

  private
  def create_params
    params.require(:branch).permit(:name, :address, :latitude, :longitude,
                                    :phone, :store_id)
  end

  def update_params
    params.require(:branch).permit(:id, :name, :address, :latitude,
                                    :longitude, :phone)
  end

  def get_by_locations_in_range_params
    params.require(:user_location).permit(:latitude, :longitude)
  end
end
