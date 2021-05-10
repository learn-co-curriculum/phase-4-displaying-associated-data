class CreateDogHouses < ActiveRecord::Migration[6.1]
  def change
    create_table :dog_houses do |t|
      t.string :image
      t.string :name
      t.string :city
      t.integer :price
      t.boolean :favorite
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6

      t.timestamps
    end
  end
end
