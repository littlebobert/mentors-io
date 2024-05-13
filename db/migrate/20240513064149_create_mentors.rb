class CreateMentors < ActiveRecord::Migration[7.1]
  def change
    create_table :mentors do |t|
      t.string :specialty
      t.integer :price
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
