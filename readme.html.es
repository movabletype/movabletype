<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta http-equiv="content-language" content="en" />
	<title>Movable Type 4.1 Read Me</title>
	<style type="text/css">
        body { font-family: Arial, Helvetica, sans-serif; }
        #container { margin: 0 auto 0 auto; width: 750px; }
	</style>
</head>
<body>
  <div id="container">
    <img src="mt-static/readme/mt4-logo.png" width="750" height="250" />

    <h1>Bienvenido a Movable Type</h1>
    <p>Gracias por elegir Movable Type, la solución ideal para todos sus blogs. Este fichero le informa cómo ponerse en marcha; haga clic en las secciones destacadas para más información sobre esos temas.</p>

    <h2>Antes de empezar</h2>
    <p>Movable Type necesita las siguientes aplicaciones:</p>
    <ul>
      <li><p>Perl 5.6.1 o posterior;</p></li>
      <li><p>Un servidor web como Apache o Windows IIS;</p></li>
      <li><p>Acceso a una base de datos como MySQL, SQLite o Postgres;</p></li>
      <li><p>Los siguientes módulos de Perl:</p>
        <ul>
          <li><a href="http://search.cpan.org/dist/DBI">DBI</a></li>
          <li><a href="http://search.cpan.org/dist/Image-Size">Image::Size</a></li>
          <li><a href="http://search.cpan.org/search?query=cgi-cookie&mode=module">CGI::Cookie</a></li>
        </ul>
        <p><em>Consulte la siguiente documentación para más información sobre cómo <a href="http://www.cpan.org/misc/cpan-faq.html#How_installed_modules">determinar si un módulo de Perl ya está instalado</a> y, si no lo está, <a href="http://www.cpan.org/misc/cpan-faq.html#How_install_Perl_modules">cómo instalarlo</a>.</em></p>
    </ul>

    <h2>Actualización de Movable Type</h2>
    <p>Si está actualizando Movable Type 4 desde una versión anterior, le recomendamos que primero haga una copia de seguridad de su antigua instalación. Luego, transfiera los ficheros de Movable Type 4 donde estén los ficheros antiguos. Acceda a Movable Type como normalmente lo hace y podrá iniciar el proceso de actualización.</p>

    <h2>Instalación de Movable Type</h2>
    <p>Antes de instalar Movable Type:</p>
    <ol>
      <li>Transfiere todos los ficheros de Movable Type a una carpeta accesible a través de su navegador. (Generalmente, esta carpeta se llama 'mt' y está situada en el directorio raíz de su web).</li>
      <li>Asegúrese de que cada fichero .cgi (p.e. mt.cgi, mt-search.cgi, etc) que se encuentra en el directorio de Movable Type tiene los <a href="http://www.elated.com/articles/understanding-permissions/">permisos de ejecución</a> habilitados.</li>
      <li>Asegúrese de que la carpeta 'mt' que contiene los ficheros transferidos de Movable Type tiene permisos de <a href="http://httpd.apache.org/docs/2.0/howto/cgi.html#nonscriptalias">ejecución de scripts CGI</a>.</li>
      <li>Abra dicha carpeta en su navegador (p.e. <tt>http://www.misitioweb.com/mt/</tt>).
      <li>Verá una pantalla de bienvenida a Movable Type, que le guiará por el proceso de instalación. Si la pantalla de bienvenida no aparece, consulte nuestra Guía de Resolución de Problemas.</li>
    </ol>

    <h2>Resolución de Problemas de Movable Type</h2>
    <h3>Configuración de la ruta al web estático</h3>
    <p>En algunos servidores web (y en algunas configuraciones), los ficheros estáticos como los de javascript, hojas de estilo e imágenes, no están permitidos dentro de un directorio cgi-bin. Si instaló Movable Type en un directorio cgi-bin, deberá situar los ficheros estáticos en otro lugar accesible por el web. Consulte nuestra documentación sobre cómo configurar el <a href="http://www.sixapart.com/movabletype/kb/installation/images_styles_a.html">directorio mt-static</a>.</p>

    <h3>Errores internos del servidor</h3>
    <p>Si obtiene un mensaje de error interno del servidor ("Internal Server Error"), quizás el servidor web necesite cambios en la configuración. Por favor, consulte nuestra <a href="http://www.movabletype.org/documentation/install/">guía de instalación</a> para ayudarle a resolver este asunto, o consulte nuestra <a href="http://www.sixapart.com/movabletype/kb/">base de conocimiento</a>.</p>

    <h3>Buscando más ayuda</h3>
    <p>¿Necesita información o soporte adicional? Consulte nuestra <a href="http://www.movabletype.org/documentation/installation/">Guía Detallada de Instalación</a>.</p>
  </div>
</body>
</html>
