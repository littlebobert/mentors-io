class AddBioToMentors < ActiveRecord::Migration[7.1]
  def change
    add_column :mentors, :tagline, :string
    add_column :mentors, :bio, :string
  end
end
