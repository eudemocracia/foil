class Community
  include Mongoid::Document
  field :name
  field :domain
  field :type

  has_many :spaces

  validates :domain, presence: true
end
