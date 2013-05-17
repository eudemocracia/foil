class Message
  include Mongoid::Document
  field :content

  belongs_to :sender, class_name: 'Space', inverse_of: :sent_messages
  belongs_to :receiver, class_name: 'Space', inverse_of: :received_messages

  #after_create :send_message_to_space_subscriptors
end
