ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'
require File.expand_path(File.dirname(__FILE__) + '/../config/environment')

loop do
  IncomingMail.find_each do |mail|

    sender_mail  = mail.reverse_path
    space_path, community_domain = mail.forward_path.split('@')
    mail_data    = Mail.new mail.data
    sender_name  = mail_data.from
    thread_title = mail_data.subject ? mail_data.subject.split( '|' ).last : nil
    sender_name  = sender_name? sender_name.display_names.first : nil
    
    # TODO: Regex para las direcciones y todo lo demás. | y > en el asunto por ejemplo.

    #community_domain << '.root'
    #space_path << '.comunidad' unless space_path[-9..-1] == 'comunidad'
    thread_title = thread_title.slice(4..-1) if thread_title[0..3] == 'Re: '
    #thread_title.prepend( "Principal > " )

### Assimilation ###

    community = Community.assimilate community_domain
    space = Space.assimilate community, space_path
    thread = Topic.assimilate space, thread_title
    sender = Member.assimilate sender_name, sender_mail

    thread.messages.create  #header: mail_data.html_part.decoded, #tiró error con decoded
                            #header: mail_data.header.raw_source,                        
                            content: mail_data.text_part.decoded,#.force_encoding(Encoding::UTF_8),
                            community_id: community.id,
                            space_id: space.id,
                            sender_id: sender.id

    mail.destroy
  end

  sleep 5
end
