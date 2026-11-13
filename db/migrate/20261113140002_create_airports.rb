class CreateAirports < ActiveRecord::Migration[7.2]
  def change
    create_table :airports do |t|
      t.string :name
      t.string :ident
      t.string :iata_code
      t.string :airport_type
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.integer :elevation_ft
      t.string :municipality
      t.boolean :scheduled_service
      t.string :wikipedia_link
      t.references :province, null: false, foreign_key: true

      t.timestamps
    end
  end
end
