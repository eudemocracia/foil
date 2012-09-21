require "yaml"
require "active_record"
require "logger"

load "mailer.rb"

dbconfig = YAML::load_file "database.yml" 
ActiveRecord::Base.configurations = dbconfig
ActiveRecord::Base.establish_connection "development" 
ActiveRecord::Base.logger = Logger.new( "log/debug.log" )

class Incoming_Mail < ActiveRecord::Base
end

class Community < ActiveRecord::Base
  belongs_to :supercommunity, :class_name => "Community", :foreign_key => "supercommunity_id"
  has_many   :subcommunities, :class_name => "Community", :foreign_key => "supercommunity_id"
  has_many   :spaces
  has_many   :messages

  validates  :domain, :presence => true
 
  def self.assimilate community_domain
    community = self
    subcommunity = self

    community_domain.split( "." ).reverse.each do | subdomain |
      subcommunity = community.find_by_domain subdomain

      if subcommunity == nil
        subcommunity = community.create domain: subdomain
      end

      community = subcommunity.subcommunities
    end

    return subcommunity
  end

  def full_domain
    domain = Array.new
    community = self
    
    while community
      domain.prepend community.domain
      community = community.supercommunity
    end

    return domain
  end
end

class Space < ActiveRecord::Base
  belongs_to :community
  belongs_to :superspace, :class_name => "Space", :foreign_key => "superspace_id"
  has_many   :subspaces, :class_name => "Space", :foreign_key => "superspace_id"
  has_many   :threads, :class_name => "Topic"
  has_many   :messages

  has_many   :suscriptions, :dependent => :destroy

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

class Topic < ActiveRecord::Base
  belongs_to :space
  belongs_to :superthread, :class_name => "Topic", :foreign_key => "superthread_id"
  has_many   :subthreads, :class_name => "Topic", :foreign_key => "superthread_id"
  has_many   :messages, :foreign_key => "thread_id"
  
  validates  :title, :presence => true

  def self.assimilate space, thread_title
    thread = space.threads
    subthread = self

    thread_title.split( ">" ).each do | subtitle |
      subtitle.strip!
      subthread = thread.find_by_title subtitle

      if subthread == nil
        subthread = thread.create title: subtitle
      end

      thread = subthread.subthreads
    end

    return subthread
  end

  def full_title
    title = Array.new
    thread = self

    while thread
      title.prepend thread.title
      thread = thread.superthread
    end

    return title
  end
end

class Message < ActiveRecord::Base
  belongs_to :community
  belongs_to :space
  belongs_to :thread, :class_name => "Topic", :foreign_key => "thread_id"
  belongs_to :sender, :class_name => "Member", :foreign_key => "sender_id"

  after_create :suscribe_sender, :unless => :sender_suscribed?
  after_create :send_message_to_space_suscriptors

  def sender_suscribed?
    self.sender.suscriptions.find_by_space_id self.space.id
  end

  protected

  def suscribe_sender
    self.sender.suscriptions.create space_id: self.space.id
  end

  def send_message_to_space_suscriptors
    Mailer.list_mail( self ).deliver
  end
end

class Member < ActiveRecord::Base
  has_many   :messages, :foreign_key => "sender_id"
  has_many   :suscriptions, :foreign_key => "suscriptor_id", :dependent => :destroy

  def self.assimilate sender_name, sender_mail
    sender = Member.find_by_mail sender_mail

    if sender == nil
      sender = Member.create name: sender_name, mail: sender_mail
    end

    return sender
  end
end

class Suscription < ActiveRecord::Base
  belongs_to :space
  belongs_to :suscriptor, :class_name => "Member", :foreign_key => "suscriptor_id"
end
