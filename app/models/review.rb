class Review < ApplicationRecord
  belongs_to :mentor
  belongs_to :user
end
