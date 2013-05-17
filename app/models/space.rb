class Space
  include Mongoid::Document
  field :name
  field :path

  belongs_to :community
  has_many   :sent_messages, class_name: 'Message', inverse_of: :sender
  has_many   :received_messages, class_name: 'Message', inverse_of: :receiver
  has_and_belongs_to_many :members

  validates  :path, presence: true
end
