class IncomingMail
  include Mongoid::Document
  field :reverse_path, type: Array, default: Array.new
  field :forward_path, type: Array, default: Array.new
  field :data, default: String.new
end
