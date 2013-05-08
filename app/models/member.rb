class Member
  include Mongoid::Document
  field :name, type: String
  field :mail, type: String
  field :phone, type: String
  has_many :messages
  has_many :subscriptions, dependent: :destroy

  def self.assimilate sender_name, sender_mail
    sender = Member.find_or_create_by(mail: sender_mail)
    sender.update_attributes(name: sender_name)

    return sender
  end
end
