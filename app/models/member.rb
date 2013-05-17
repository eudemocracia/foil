class Member
  include Mongoid::Document
  field :name
  field :email
  field :phone

  has_and_belongs_to_many :spaces
end
