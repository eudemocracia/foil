require "action_mailer"

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  domain: "eudemocracia.org"
}

ActionMailer::Base.view_paths = File.dirname(__FILE__)

class Mailer < ActionMailer::Base
  def list_mail( message )
    space_address = message.space.mail_address
    space_address_with_name = "#{message.space.name} <#{space_address}>"

    subject = message.space.path + " | " + message.thread.full_title.join( " > " )
    
    # Para que los mensajes sean hilados correctamente en los clientes de correo.
    subject.prepend( "Re: " ) if message.thread.messages.size > 1
    
    @content = message.content
    @headerr = message.header 
    headers(
      "To" => space_address_with_name,
      "Reply-To" => space_address_with_name,
      
      "List-ID" => space_address_with_name,
      #list_help: "",
      #list_suscribe: "",
      "List-Unsuscribe" => "<mailto:#{space_address}?subject=Desuscribir>",
      #list_post: "",
      #list_owner: "",
      "List-Archive" => "<#{message.space.web_address}>",
    )

    mail(
      return_path: "verp-" + message.space.mail_address, # VERPear!
      sender: space_address_with_name,
      from: "#{message.sender.name} <#{message.sender.mail}>",
      # Pasa el mensaje al método mailing list para hacer una recolección más personalizada de los correos de los suscriptores.
      # Si no se proporciona ningún argumento, devuelve la lista completa.
      to: message.space.mailing_list( message ),
      subject: subject,
    )
  end
end
