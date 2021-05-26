class CreateFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites do |t|
      t.string :name
      t.integer :fmid
      t.string :address
      t.string :dates
      t.string :times

      t.timestamps
    end
  end
end
