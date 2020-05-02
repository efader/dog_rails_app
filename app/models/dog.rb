class Dog < ApplicationRecord
  has_many_attached :images
  has_one :user
end
