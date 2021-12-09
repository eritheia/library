class Request < ApplicationRecord
  belongs_to :book
  belongs_to :user
  enum request_type: [:pending, :accepted, :rejected, :return]
end
