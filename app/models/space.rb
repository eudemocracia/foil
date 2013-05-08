class Space < ActiveRecord::Base
  belongs_to :community
  belongs_to :superspace, :class_name => "Space", :foreign_key => "superspace_id"
  has_many   :subspaces, :class_name => "Space", :foreign_key => "superspace_id"
  has_many   :threads, :class_name => "Topic"
  has_many   :messages

  has_many   :subscriptions, :dependent => :destroy

  validates  :path, :presence => true
 
  def self.assimilate community, space_path
    space = community.spaces
    subspace = self

    space_path.split( "." ).reverse.each do | subpath |
      subspace = space.find_by_path subpath

      if subspace == nil
        subspace = space.create path: subpath
      end

      space = subspace.subspaces
    end

    return subspace
  end

  def full_path
    path = Array.new
    space = self

    while space
      path.prepend space.path
      space = space.superspace
    end

    return path
  end

  def immediate_community
    space = self

    while space
      community = space.community
      space = space.superspace
    end

    return community
  end
  
  def mail_address
    self.full_path.reverse.join( "." ) + "@" + self.immediate_community.full_domain.reverse.join( "." )
  end

  def web_address
    "http://" + self.immediate_community.full_domain.reverse.join( "." ) + "/" + self.full_path.join( "/" )
  end

  def mailing_list( message = nil )
    list = Array.new

    self.suscriptions.find_each do | suscription |
      list << suscription.suscriptor.mail 
    end

    # Mail echo off.
    list.delete_if do | mail |
      mail == message.sender.mail
    end if message
    
    return list
  end
end
