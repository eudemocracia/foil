class ListMailer < ActionMailer::Base
  default from: "coco@eudemocracia.org.ar"
  
  def list_mail message
    space_address = message.space.mail_address
    space_address_with_name = "#{message.space.name} <#{space_address}>"

    subject = message.space.path + " | " + message.thread.full_title.join( " > " )
    
    # Para que los mensajes sean hilados correctamente en los clientes de correo.
    subject.prepend( "Re: " ) if message.thread.messages.size > 1
    
    @content = message.content
    @headerr = message.header 
    headers(
      "List-ID" => space_address_with_name,
      #list_help: "",
      #list_suscribe: "",
      "List-Unsuscribe" => "<mailto:#{space_address}?subject=Desuscribir>",
      #list_post: "",
      #list_owner: "",
      "List-Archive" => "<#{message.space.web_address}>"
    )

    mail(
      # Ver lo de los rebotes.
      smtp_envelope_from: space_address_with_name,
      # Las direcciones de los destinatarios.
      smtp_envelope_to: message.space.mailing_list(message),
      # La dirección de la lista.
      reply_to: space_address_with_name,
      # La dirección para los rebotes. TODO: VERPear.
      # return_path: "verp-" + message.space.mail_address,
      # Sender no es necesario.
      # sender: space_address_with_name,
      # La dirección del remitente.
      from: "#{message.sender.name} <#{message.sender.mail}>",
      # La dirección de la lista.
      to: space_address_with_name,
      subject: subject
    )
  end
end
