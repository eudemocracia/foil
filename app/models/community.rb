class Community
  include Mongoid::Document
  field :name
  field :domain
  # Region can be :local, :neighboring or :foreign.
  field :region, type: Symbol, default: :foreign

  has_many :spaces

  validates :domain, presence: true
end
