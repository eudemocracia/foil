class Subscription < ActiveRecord::Base
  belongs_to :space
  belongs_to :suscriptor, :class_name => "Member", :foreign_key => "subscriptor_id"
end
