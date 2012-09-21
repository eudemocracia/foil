  ** Headers **
Prácticamente están. Falta que el To: header sea la dirección de la lista, pero un bug del ActionMailer hace que sea la misma que la del sobre.

  ** VERP **
Hay una gema.

  ** Threads **
SOLVED Path de los Espacios. Se escribe 2 veces.
* Hay que hacer que los correos sin asunto generen Threads con títulos vacíos.

  ** Members **
* Mail no decodifica el nombre del remitente que aparece en el header. Reportar bug.

  ** Mailer **
SOLVED Apagar el echo.
SOLVED <>: Problema cuando se usa text.erb en vez de html.erb.
SOLVED Se usan algunas funciones que quedarían mejor como métodos de Espacio.
* Multipart.

FEATURES
* Suscribir/avisar a amigos al crear o suscribir.
