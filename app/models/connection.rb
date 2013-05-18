class Connection
  include Mongoid::Document
  field :type, type: Symbol
  embedded_in :space

  belongs_to :with, class_name: 'Space', inverse_of: nil

  validates :type, presence: true
end
