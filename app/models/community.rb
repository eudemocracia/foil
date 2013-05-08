class Community
  include Mongoid::Document
  field :name, type: String
  field :domain, type: String
  belongs_to :supercommunity, class_name: 'Community'
  has_many   :subcommunities, class_name: 'Community'
  has_many   :spaces
  has_many   :messages

  validates  :domain, presence: true
 
  def self.assimilate community_domain
    community    = self
    subcommunity = self

    community_domain.split('.').reverse.each do |subdomain|
      subcommunity = community.find_or_create_by(domain: subdomain)
      community    = subcommunity.subcommunities
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
