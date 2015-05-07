class RenameFacebokAuthsToFacebookAuths < ActiveRecord::Migration
  def change
    rename_table :facebok_auths, :facebook_auths
  end
end
