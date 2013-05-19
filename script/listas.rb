ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'
require File.expand_path(File.dirname(__FILE__) + '/../config/environment')

loop do
  IncomingMail.each do |mail|
    sender_path, sender_domain     = mail.reverse_path.first.split('@')
    receiver_path, receiver_domain = mail.forward_path.first.split('@')
    
    sender   = Space.where(
                 domain: sender_domain,
                 path: sender_path
               ).first_or_create

    receiver = Space.where(
                        domain: sender_domain,
                        path: sender_path
                      ).first_or_create_by(readable_by: :all, relay_to: nil)

    data = Mail.new(mail.data)

    message = Message.new(
                subject: data.subject,
                content: data.body.decoded
              )

    #sender.deliver(message).to(receiver)

    mail.destroy
  end

  sleep 5
end
