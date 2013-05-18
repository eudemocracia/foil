class IncomingMail
  include Mongoid::Document
  field :reverse_path
  field :forward_path
  field :data

  after_initialize :init

  def init
    self.data ||= String.new
  end
end
