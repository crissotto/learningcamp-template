class AddUserIdToPreferences < ActiveRecord::Migration[7.1]
  def change
    add_column :preferences, :user_id, :integer
  end
end
