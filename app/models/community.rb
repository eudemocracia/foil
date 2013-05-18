class Community
  include Mongoid::Document
  field :name
  field :domain
  field :type, type: Symbol, default: :foreign

  has_many :spaces

  validates :domain, presence: true
end
