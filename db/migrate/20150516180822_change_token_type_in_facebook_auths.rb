class ChangeTokenTypeInFacebookAuths < ActiveRecord::Migration
  def change
    change_column :facebook_auths, :token, :text
  end
end
