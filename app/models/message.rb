class Message
  include Mongoid::Document
  field :header, type: String
  field :content, type: String
  #field :hashtag, type: String
  #field :attag, type: String
  belongs_to :community
  belongs_to :space
  belongs_to :thread, class_name: 'Topic'
  belongs_to :sender, class_name: 'Member'

  after_create :suscribe_sender #, :unless => :sender_suscribed?
  after_create :send_message_to_space_subscriptors

  #def sender_suscribed?
  #  self.sender.suscriptions.find_by_space_id self.space.id
  #end

  protected

  def subscribe_sender
    self.sender.subscriptions.find_or_create_by(space_id: self.space.id)
  end

  def send_message_to_space_subscriptors
    Mailer.list_mail(self).deliver
  end
end
