class Member
  include Mongoid::Document
  field :name
  field :mail
  field :phone
  has_many :messages
  has_many :subscriptions, dependent: :destroy

end
