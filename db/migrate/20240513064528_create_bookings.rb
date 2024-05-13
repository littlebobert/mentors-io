class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.datetime :start_time
      t.references :user, null: false, foreign_key: true
      t.references :mentor, null: false, foreign_key: true
      t.string :status, default: "pending"

      t.timestamps
    end
  end
end
