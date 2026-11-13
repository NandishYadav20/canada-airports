class CreateReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :reviews do |t|
      t.references :reviewer, null: false, foreign_key: true
      t.references :airport, null: false, foreign_key: true
      t.integer :rating
      t.string :title
      t.text :comment
      t.date :visited_on

      t.timestamps
    end
  end
end
