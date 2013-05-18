class Space
  include Mongoid::Document
  field :name
  field :domain
  field :path
  field :writable_by, type: Symbol, default: :all
  field :readable_by, type: Symbol, default: :members
  field :forward_to

  belongs_to :community
  has_and_belongs_to_many :sent_messages, class_name: 'Message', inverse_of: :senders
  has_and_belongs_to_many :received_messages, class_name: 'Message', inverse_of: :receivers
  has_and_belongs_to_many :members

  validates :domain, presence: true
  validates :path, presence: true
end
