class CreateRoutes < ActiveRecord::Migration[7.2]
  def change
    create_table :routes do |t|
      t.references :airline, null: false, foreign_key: true
      t.references :origin_airport, null: false, foreign_key: { to_table: :airports }
      t.references :destination_airport, null: false, foreign_key: { to_table: :airports }
      t.integer :stops
      t.string :equipment

      t.timestamps
    end
  end
end
