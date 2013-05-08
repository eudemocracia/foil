class IncomingMail
  include Mongoid::Document
  field :reverse_path, type: String
  field :forward_path, type: String
  field :data, type: String

  after_initialize :init

  def init
    self.data ||= String.new
  end
end
