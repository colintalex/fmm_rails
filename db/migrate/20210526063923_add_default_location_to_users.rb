class AddDefaultLocationToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :default_location, :string
  end
end
