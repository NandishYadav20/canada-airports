class CreateAirlines < ActiveRecord::Migration[7.2]
  def change
    create_table :airlines do |t|
      t.string :name
      t.string :iata_code
      t.string :icao_code
      t.string :callsign
      t.string :country
      t.boolean :active

      t.timestamps
    end
  end
end
