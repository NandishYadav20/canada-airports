class CreateProvinces < ActiveRecord::Migration[7.2]
  def change
    create_table :provinces do |t|
      t.string :name
      t.string :code
      t.string :local_code
      t.string :wikipedia_link

      t.timestamps
    end
  end
end
