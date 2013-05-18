class Space
  include Mongoid::Document
  field :name
  field :domain # Community domain.
  field :path
  # Permissions can be :all, :first_neighbors, :second_neighbors, :members.
  field :writable_by, type: Symbol, default: :all
  field :readable_by, type: Symbol, default: :members
  field :relay_to # Member email; useful when Space belongs to a foreign Community.

  belongs_to :community
  has_and_belongs_to_many :sent_messages, class_name: 'Message', inverse_of: :senders
  has_and_belongs_to_many :received_messages, class_name: 'Message', inverse_of: :receivers
  has_and_belongs_to_many :members
  embeds_many :connections

  validates :domain, presence: true
  validates :path, presence: true
end
