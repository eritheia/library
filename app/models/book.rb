class Book < ApplicationRecord
	belongs_to :user
	belongs_to :category
	has_many :requests, dependent: :destroy
	has_many :reviews, dependent: :destroy
end
