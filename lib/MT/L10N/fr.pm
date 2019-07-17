# Movable Type (r) (C) 2001-2019 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id:$

package MT::L10N::fr;
use strict;
use warnings;
use utf8;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

## The following is the translation table.

%Lexicon = (

## php/lib/archive_lib.php
	'INDIVIDUAL_ADV' => 'Individuelles',
	'PAGE_ADV' => 'Page',
	'YEARLY_ADV' => 'Annuelles',
	'MONTHLY_ADV' => 'Mensuelles',
	'DAILY_ADV' => 'Journalières',
	'WEEKLY_ADV' => 'Hebdomadaires',
	'AUTHOR_ADV' => 'Auteur',
	'(Display Name not set)' => '(Nom pas spécifié)',
	'AUTHOR-YEARLY_ADV' => 'Par auteurs et années',
	'AUTHOR-MONTHLY_ADV' => 'Par auteurs et mois',
	'AUTHOR-DAILY_ADV' => 'Par auteurs et jours',
	'AUTHOR-WEEKLY_ADV' => 'Par auteurs et semaines',
	'CATEGORY_ADV' => 'Catégorie',
	'CATEGORY-YEARLY_ADV' => 'Par catégories et années',
	'CATEGORY-MONTHLY_ADV' => 'Par catégories et mois',
	'CATEGORY-DAILY_ADV' => 'Par catégories et jours',
	'CATEGORY-WEEKLY_ADV' => 'Par catégories et semaines',
	'Category' => 'Catégorie',
	'CONTENTTYPE_ADV' => 'ContentType',
	'CONTENTTYPE-DAILY_ADV' => 'ContentType journalières',
	'CONTENTTYPE-WEEKLY_ADV' => 'ContentType hebdomadaires',
	'CONTENTTYPE-MONTHLY_ADV' => 'ContentType mensuelles',
	'CONTENTTYPE-YEARLY_ADV' => 'ContentType annuelles',
	'CONTENTTYPE-AUTHOR_ADV' => 'ContentType Auteur',
	'CONTENTTYPE-AUTHOR-YEARLY_ADV' => 'ContentType Auteur annuelles',
	'CONTENTTYPE-AUTHOR-MONTHLY_ADV' => 'ContentType Auteur mensuelles',
	'CONTENTTYPE-AUTHOR-DAILY_ADV' => 'ContentType Auteur journalières',
	'CONTENTTYPE-AUTHOR-WEEKLY_ADV' => 'ContentType Auteur hebdomadaires',
	'CONTENTTYPE-CATEGORY_ADV' => 'ContentType Catégorie',
	'CONTENTTYPE-CATEGORY-YEARLY_ADV' => 'ContentType Catégorie annuelles',
	'CONTENTTYPE-CATEGORY-MONTHLY_ADV' => 'ContentType Catégorie mensuelles',
	'CONTENTTYPE-CATEGORY-DAILY_ADV' => 'ContentType Catégorie journalières',
	'CONTENTTYPE-CATEGORY-WEEKLY_ADV' => 'ContentType Catégorie hebdomadaires',

## php/lib/block.mtarchives.php
	'ArchiveType not found - [_1]' => 'ArchiveType introuvable - [_1]', # Translate - New

## php/lib/block.mtassets.php
	'sort_by="score" must be used together with a namespace.' => 'sort_by="score" doit être utilisé avec un espace de noms.',

## php/lib/block.mtauthorhascontent.php
	'No author available' => 'Aucun auteur disponible',

## php/lib/block.mtauthorhasentry.php

## php/lib/block.mtauthorhaspage.php

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without establishing a date context.' => 'Vous avez utilisé une balise [_1] sans établir un contexte de date.',

## php/lib/block.mtcategorysets.php
	'No Category Set could be found.' => 'Impossible de trouver un groupe de catégories.',
	'No Content Type could be found.' => 'Impossible de trouver un type de contenu.',

## php/lib/block.mtcontentauthoruserpicasset.php
	'You used an \'[_1]\' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an \'MTContents\' container tag?' => 'Vous avez utilisé une balise \'[_1]\' en dehors d\'un contexte de contenu. Peut-être l\'avez-vous placée par erreur en dehors d\'un bloc \'MTContents\' ?',

## php/lib/block.mtcontentfield.php
	'No Content Field could be found.' => 'Impossible de trouver un champ de contenu.',
	'No Content Field Type could be found.' => 'Pas trouvé de type de champ de contenu.',

## php/lib/block.mtcontentfields.php

## php/lib/block.mtcontents.php

## php/lib/block.mtentries.php

## php/lib/block.mthasplugin.php
	'name is required.' => 'le nom est requis.',

## php/lib/block.mtif.php
	'You used an [_1] tag without a valid name attribute.' => 'Vous avez utilisé une balise [_1] sans attribut de nom valide.',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] est illégal.',

## php/lib/block.mtsethashvar.php

## php/lib/block.mtsetvarblock.php
	'You used a [_1] tag without a valid name attribute.' => 'Vous avez utilisé une balise [_1] sans un attribut de nom valide',
	'\'[_1]\' is not a hash.' => '\'[_1]\' n\'est pas un hash',
	'Invalid index.' => 'Index invalide',
	'\'[_1]\' is not an array.' => '\'[_1]\' n\'est pas un tableau',
	'\'[_1]\' is not a valid function.' => '\'[_1]\' n\'est pas une fonction valide',

## php/lib/block.mttags.php
	'content_type modifier cannot be used with type "[_1]".' => 'Le modificateur content_type ne peut pas être utilisé avec le type "[_1]".',

## php/lib/captcha_lib.php
	'Captcha' => 'CAPTCHA',
	'Type the characters shown in the picture above.' => 'Tapez les caractères affichés dans l\'image ci-dessus.',

## php/lib/content_field_type_lib.php
	'No Label (ID:[_1])' => 'Pas d\'étiquette (ID:[_1])',
	'No category_set setting in content field type.' => 'Pas de paramètre category_set dans le type de champ de contenu.',

## php/lib/function.mtassettype.php
	'image' => 'image',
	'Image' => 'Image',
	'file' => 'fichier',
	'File' => 'Fichier',
	'audio' => 'audio',
	'Audio' => 'Audio',
	'video' => 'vidéo',
	'Video' => 'Vidéo',

## php/lib/function.mtauthordisplayname.php

## php/lib/function.mtcontentauthordisplayname.php

## php/lib/function.mtcontentauthoremail.php

## php/lib/function.mtcontentauthorid.php

## php/lib/function.mtcontentauthorlink.php

## php/lib/function.mtcontentauthorurl.php

## php/lib/function.mtcontentauthorusername.php

## php/lib/function.mtcontentauthoruserpic.php

## php/lib/function.mtcontentauthoruserpicurl.php

## php/lib/function.mtcontentcreateddate.php

## php/lib/function.mtcontentdate.php

## php/lib/function.mtcontentfieldlabel.php

## php/lib/function.mtcontentfieldtype.php

## php/lib/function.mtcontentfieldvalue.php

## php/lib/function.mtcontentid.php

## php/lib/function.mtcontentmodifieddate.php

## php/lib/function.mtcontentpermalink.php

## php/lib/function.mtcontentscount.php

## php/lib/function.mtcontentsitedescription.php

## php/lib/function.mtcontentsiteid.php

## php/lib/function.mtcontentsitename.php

## php/lib/function.mtcontentsiteurl.php

## php/lib/function.mtcontentstatus.php

## php/lib/function.mtcontenttypedescription.php

## php/lib/function.mtcontenttypeid.php

## php/lib/function.mtcontenttypename.php

## php/lib/function.mtcontenttypeuniqueid.php

## php/lib/function.mtcontentuniqueid.php

## php/lib/function.mtcontentunpublisheddate.php

## php/lib/function.mtentryclasslabel.php
	'Entry' => 'Note',

## php/lib/function.mtinclude.php
	'\'parent\' modifier cannot be used with \'[_1]\'' => 'Le modifieur \'parent\' ne peut pas être utilisé avec \'[_1]\'',

## php/lib/function.mtpasswordvalidation.php
	'Password should be longer than [_1] characters' => 'Le mot de passe doit faire plus de [_1] caractères',
	q{Password should not include your Username} => q{Le mot de passe ne doit pas être composé de votre nom d'utilisateur},
	'Password should include letters and numbers' => 'Le mot de passe doit être composé de lettres et de chiffres',
	'Password should include lowercase and uppercase letters' => 'Le mot de passe doit être composé de lettres en minuscule et majuscule',
	'Password should contain symbols such as #!$%' => 'Le mot de passe doit contenir des caractères spéciaux comme #!$%',
	'You used an [_1] tag without a valid [_2] attribute.' => 'Vous avez utilisé une balise [_1] sans un attribut [_2] valide.',

## php/lib/function.mtpasswordvalidationrule.php
	'minimum length of [_1]' => 'longueur minimum de [_1]',
	', uppercase and lowercase letters' => ', lettres en minuscule et majuscule',
	', letters and numbers' => ', lettres et chiffres',
	', symbols (such as #!$%)' => ', caractères spéciaux (comme #!$%)',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtsetvar.php

## php/lib/function.mtsitecontentcount.php

## php/lib/function.mttagsearchlink.php
	'Invalid [_1] parameter.' => 'Paramètre [_1] invalide',

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '\'[_1]\' n\'est pas une fonction valide pour un hash',
	'\'[_1]\' is not a valid function for an array.' => '\'[_1]\' n\'est pas une fonction valide pour un tableau',

## php/lib/mtdb.base.php
	'When the exclude_blogs and include_blogs attributes are used together, the same blog IDs should not be listed as parameters to both of them.' => 'Quand les attributs exclude_blogs et include_blogs sont utilisés ensemble, les mêmes identifiants de blog ne peuvent être fournis en paramètre de ces deux attributs.',

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'userpic-[_1]-%wx%h%x',

## php/mt.php
	'Page not found - [_1]' => 'Page non trouvée - [_1]',

## mt-check.cgi
	'Movable Type System Check' => 'Vérification du système Movable Type',
	q{You attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.} => q{Vous avez tenté d'accéder à une fonctionnalité à laquelle vous n'avez pas droit. Si vous pensez que cette erreur n'est pas normale contactez votre administrateur système.},
	'The MT-Check report is disabled when Movable Type has a valid configuration file (mt-config.cgi)' => 'Le rapport MT-Check est désactivé lorsque Movable Type a un fichier de configuration (mt-config.cgi) valide',
	q{The mt-check.cgi script provides you with information about your system's configuration and determines whether you have all of the components you need to run Movable Type.} => q{Le script mt-check.cgi vous fournit des informations sur la configuration de votre système et détermine si vous avez tous les composants nécessaires pour exécuter Movable Type.},
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). Please upgrade to at least Perl [_2].' => 'La version de Perl installée sur votre serveur ([_1]) est inférieure au minimum requis ([_2]). Veuillez mettre à jour vers, au moins, Perl [_2].',
	'System Information' => 'Informations système',
	'Movable Type version:' => 'Version de Movable Type :',
	'Current working directory:' => 'Répertoire de travail courant :',
	q{MT home directory:} => q{Répertoire d'accueil MT :},
	q{Operating system:} => q{Système d'exploitation :},
	'Perl version:' => 'Version de Perl :',
	q{Perl include path:} => q{Chemin d'inclusion Perl :},
	'Web server:' => 'Serveur web :',
	'(Probably) running under cgiwrap or suexec' => 'Exécuté (probablement) sous cgiwrap ou suexec',
	'[_1] [_2] Modules' => '[_1] modules [_2]',
	q{The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that they provide.} => q{Les modules suivants sont <strong>optionnels</strong>. Si votre serveur ne dispose pas de ces modules, vous n'avez besoin de les installer que si vous avez besoin de leurs fonctionnalités.},
	q{The following modules are required by databases that can be used with Movable Type. Your server must have DBI and at least one of these related modules installed for the application to work properly.} => q{Les modules suivants sont requis par les bases de données utilisables par Movable Type. DBI et au moins l'un des modules idoines doivent être installés sur votre serveur pour que l'application fonctionne.},
	q{Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.} => q{Soit votre serveur n'a pas [_1] d'installé, soit la version installée est trop vieille, ou [_1] nécessite un autre module qui n'est pas installé},
	q{Your server does not have [_1] installed, or [_1] requires another module that is not installed.} => q{Votre serveur n'a pas [_1] d'installé ou [_1] nécessite un autre module qui n'est pas installé.},
	q{Please consult the installation instructions for help in installing [_1].} => q{Veuillez consulter les instructions d'installation pour obtenir de l'aide pour installer [_1].},
	'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the most current release available.' => 'La version installée de DBD::mysql est connue pour être incompatible avec Movable Type. Veuillez installer la dernière version disponible.',
	'The [_1] is installed properly, but requires an updated DBI module. Please see the note above regarding the DBI module requirements.' => '[_1] est installé correctement mais nécessite une version plus récente de DBI. Veuillez vous reporter à la note précédente concernant les pré-requis du module DBI.',
	'Your server has [_1] installed (version [_2]).' => 'Votre serveur possède [_1] (version [_2]).',
	'Movable Type System Check Successful' => 'Vérification du système Movable Type terminée avec succès.',
	q{You're ready to go!} => q{Vous êtes prêt à continuer !},
	q{Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.} => q{Votre serveur dispose de tous les modules requis, vous n'avez pas besoin d'installer autre chose. Continuez avec les instructions d'installation.},
	'CGI is required for all Movable Type application functionality.' => 'CGI est nécessaire pour toutes les fonctionnalités de l\'application Movable Type.',
	'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Size est nécessaire pour l\'envoi de fichiers (afin de déterminer la taille des images envoyées dans différents formats).',
	'File::Spec is required to work with file system path information on all supported operating systems.' => 'File::Spec est nécessaire pour gérer les chemins de fichiers sur les systèmes d\'exploitation supportés.',
	'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie est nécessaire pour l\'authentification via un cookie.',
	'LWP::UserAgent is required for creating Movable Type configuration files using the installation wizard.' => 'LWP::UserAgent est requis pour que l\'assistant de configuration puisse créer les fichiers de configuration de Movable Type.',
	'Scalar::Util is required for initializing Movable Type application.' => 'Scalar::Util est requis pour initialiser l\'application Movable Type.',
	'HTML::Entities is required by CGI.pm' => 'HTML::Entities est nécessaire pour CGI.pm',
	'DBI is required to work with most supported databases.' => 'DBI est nécessaire pour fonctionner avec la plupart des bases de données supportées.',
	'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBI et DBD::mysql sont nécessaires si vous voulez utiliser une base de données MySQL.',
	'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBI et DBD::Pg sont nécessaires si vous voulez utiliser une base de données PostgreSQL.',
	'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBI et DBD::SQLite sont nécessaires si vous voulez utiliser une base de données SQLite.',
	'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBI et DBD::SQLite2 sont nécessaires si vous voulez utiliser une base de données SQLite 2.x.',
	'Digest::SHA is required in order to provide enhanced protection of user passwords.' => 'Digest::SHA est requis pour améliorer la protection des mots de passe des utilisateurs.',
	'This module and its dependencies are required in order to operate Movable Type under psgi.' => 'Ce module et ses dépendances sont nécessaires pour faire fonctionner Movable Type en mode PSGI.',
	'This module and its dependencies are required to run Movable Type under psgi.' => 'Ce module et ses dépendances sont nécessaires pour faire fonctionner Movable Type en mode PSGI.',
	'HTML::Parser is optional; It is needed if you want to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'HTML::Parser est optionnel. Il est nécessaire si vous souhaitez utiliser le système de TrackBack, le ping weblogs.com ou le ping des mises à jour récentes MT.',
	'SOAP::Lite is optional; It is needed if you want to use the MT XML-RPC server implementation.' => 'SOAP::Lite est optionnel. Il est nécessaire si vous souhaitez utiliser l\'implementation serveur MT XML-RPC.',
	'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Temp est optionnel. Il est nécessaire si vous souhaitez être capable de ré-écrire certains fichiers lors d\'envois.',
	'List::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'List::Util est optionnel. Il est nécessaire si vous souhaitez utiliser les possibilités de publications en mode file d\'attente.',
	'[_1] is optional; It is one of the image processors that you can use to create thumbnails of uploaded images.' => '[_1] est optionnel, c\'est l\'une des librairies graphiques permettant de créer des vignettes des images téléchargées.',
	'IPC::Run is optional; It is needed if you would like to use NetPBM as the image processor for Movable Type.' => 'IPC::Run est optionnel, c\'est l\'une des librairies graphiques permettant de créer des vignettes des images téléchargées.',
	'Storable is optional; It is required by certain Movable Type plugins available from third-party developers.' => 'Storable est optionnel, ce module est requis par certains plugins de développeurs tiers.',
	'Crypt::DSA is optional; If it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSA est optionnel. S\'il est installé, les créations de comptes d\'auteurs de commemtaires seront plus rapides.',
	'This module and its dependencies are required to permit commenters to authenticate via OpenID providers such as AOL and Yahoo! that require SSL support. Also this module is required for Google Analytics site statistics.' => 'Ce module et ses dépendances sont requis pour autoriser les commentateurs à s\'authentifier via un fournisseur OpenID tel que AOL et Yahoo! qui exigent SSL. Ce module est également requis pour Google Analytics.',
	'Cache::File is required if you would like to be able to allow commenters to authenticate via OpenID using Yahoo! Japan.' => 'Cache::File est requis si vous souhaitez autoriser les commentateurs à s\'authentifier via OpenID depuis Yahoo! Japon.',
	'MIME::Base64 is required in order to enable comment registration and in order to send mail via an SMTP Server.' => 'MIME::Base64 est nécessaire pour autoriser l\'enregistrement des commentaires et envoyer des e-mails via un serveur SMTP.',
	'XML::Atom is required in order to use the Atom API.' => 'XML::Atom est nécessaire afin d\'utiliser l\'API Atom.',
	'Cache::Memcached and a memcached server are required to use in-memory object caching on the servers where Movable Type is deployed.' => 'Cache::Memcached et un serveur memcached sont nécessaires pour utiliser le cache mémoire des objets sur les serveurs où Movable Type est déployé.',
	'Archive::Tar is required in order to manipulate files during backup and restore operations.' => 'Archive::Tar est nécessaire pour manipuler les fichiers lors des opérations de sauvegarde et de restauration.',
	'IO::Compress::Gzip is required in order to compress files during backup operations.' => 'IO::Compress::Gzip est nécessaire pour comprimer les fichiers lors des opérations de sauvegarde.',
	'IO::Uncompress::Gunzip is required in order to decompress files during restore operation.' => 'IO::Uncompress::Gunzip est nécessaire pour décomprimer les fichiers lors des opérations de restauration.',
	'Archive::Zip is required in order to manipulate files during backup and restore operations.' => 'Archive::Zip est nécessaire pour manipuler les fichiers lors des opérations de sauvegarde et de restauration.',
	'XML::SAX and its dependencies are required to restore a backup created in a backup/restore operation.' => 'XML::SAX et ses dépendances sont nécessaires pour restaurer un fichier créé lors d\'une opération de sauvegarde.',
	'Digest::SHA1 and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.' => 'Digest::SHA1 et ses dépendances sont requises afin de permettre aux auteurs de commentaire d\'être identifiés en utilisant les fournisseurs OpenID, comme LiveJournal.',
	'Net::SMTP is required in order to send mail via an SMTP Server.' => 'Net::SMTP est nécessaire pour envoyer des e-mails via un serveur SMTP.',
	'This module and its dependencies are required in order to support CRAM-MD5, DIGEST-MD5 or LOGIN SASL mechanisms.' => 'Ce module et ses dépendances sont requis pour utiliser les mécanismes CRAM-MD5, DIGEST-MD5 ou LOGIN SASL.',
	'IO::Socket::SSL is required in all of the SSL/TLS connection, such as Google Analytics site statistics or SMTP Auth over SSL/TLS.' => 'IO::Socket::SSL est requis pour les connexions SSL/TLS, telles que les statistiques Google Analytics ou l\'authentification SMTP via SSL/TLS.',
	'Net::SSLeay is required to use SMTP Auth over an SSL connection, or to use it with a STARTTLS command.' => 'Net::SSLeay est requis pour l\'authentification SMTP via une connexion SSL ou par la commande STARTTLS.',
	'This module is used in a test attribute for the MTIf conditional tag.' => 'Ce module est utilisé dans attribut de test pour la balise conditionnelle MTIf.',
	'This module is used by the Markdown text filter.' => 'Ce module est utilisé par le filtre de texte Markdown',
	'This module is required by mt-search.cgi, if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'Ce module est requis par mt-search.cgi si vous faites fonctionner Movable Type avec une version de Perl antérieure à 5.8.',
	'This module required for action streams.' => 'Ce module est nécessaire pour les action streams.',
	'[_1] is optional; It is one of the modules required to restore a backup created in a backup/restore operation' => '[_1] est optionnel. C\'est l\'un des modules requis pour restaurer une sauvegarde créée par une opération de sauvegarde.',
	'This module is required for Google Analytics site statistics and for verification of SSL certificates.' => 'Ce module est requis pour les statistiques Google Analytics ainsi que pour la vérification des certificats SSL.',
	'This module is required for executing run-periodic-tasks.' => 'Ce module est  requis pour exécuter run-periodic-tasks.',
	'[_1] is optional; It is a better, fast and lightweight alternative to YAML::Tiny for YAML file handling.' => '[_1] est optionnel. C\'est une meilleure alternative, plus rapide et plus légère, à YAML::Tiny pour le traitement des fichiers YAML.',
	'The [_1] database driver is required to use [_2].' => 'Le driver de base de données [_1] est requis pour utiliser [_2].',
	'DBI is required to store data in database.' => 'DBI est nécessaire pour enregistrer les données en base de données.',
	'Checking for' => 'Vérification des',
	'Installed' => 'Installé',
	'Data Storage' => 'Stockage des données',
	'Required' => 'Requis',
	'Optional' => 'Optionnel',
	'Details' => 'Détails',
	'unknown' => 'inconnu',

## default_templates/about_this_page.mtml
	'About this Entry' => 'À propos de cette note',
	'About this Archive' => 'À propos de cette archive',
	'About Archives' => 'À propos des archives',
	'This page contains links to all of the archived content.' => 'Cette page contient des liens vers tous les contenus archivés.',
	'This page contains a single entry by [_1] published on <em>[_2]</em>.' => 'Cette page contient une unique note de [_1] publiée le <em>[_2]</em>.',
	'<a href="[_1]">[_2]</a> was the previous entry in this blog.' => '<a href="[_1]">[_2]</a> est la note précédente de ce blog.',
	'<a href="[_1]">[_2]</a> is the next entry in this blog.' => '<a href="[_1]">[_2]</a> est la note suivante de ce blog.',
	'This page is an archive of entries in the <strong>[_1]</strong> category from <strong>[_2]</strong>.' => 'Cette page est une archive des notes dans la catégorie <strong>[_1]</strong> de <strong>[_2]</strong>.',
	q{<a href="[_1]">[_2]</a> is the previous archive.} => q{<a href="[_1]">[_2]</a> est l'archive précédente.},
	q{<a href="[_1]">[_2]</a> is the next archive.} => q{<a href="[_1]">[_2]</a> est l'archive suivante.},
	'This page is an archive of recent entries in the <strong>[_1]</strong> category.' => 'Cette page est une archive des notes récentes dans la catégorie <strong>[_1]</strong>.',
	'<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> est la catégorie précédente.',
	'<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> est la catégorie suivante.',
	'This page is an archive of recent entries written by <strong>[_1]</strong> in <strong>[_2]</strong>.' => 'Cette page est une archive des notes récentes écrites par <strong>[_1]</strong> dans <strong>[_2]</strong>.',
	'This page is an archive of recent entries written by <strong>[_1]</strong>.' => 'Cette page est une archive des notes récentes écrites par <strong>[_1]</strong>.',
	'This page is an archive of entries from <strong>[_2]</strong> listed from newest to oldest.' => 'Cette page est une archive des notes de <strong>[_2]</strong> listées de la plus récente à la plus ancienne.',
	q{Find recent content on the <a href="[_1]">main index</a>.} => q{Retrouvez le contenu récent sur <a href="[_1]">l'index principal</a>.},
	q{Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.} => q{Retrouvez le contenu récent sur <a href="[_1]">l'index principal</a> ou allez dans les <a href="[_2]">archives</a> pour retrouver tout le contenu.},

## default_templates/archive_index.mtml
	'HTML Head' => 'Entête HTML',
	'Archives' => 'Archives',
	q{Banner Header} => q{Bloc de l'entête},
	'Monthly Archives' => 'Archives mensuelles',
	'Categories' => 'Catégories',
	'Author Archives' => 'Archives par auteurs',
	'Category Monthly Archives' => 'Archives par catégories et mois',
	'Author Monthly Archives' => 'Archives par auteurs et mois',
	'Sidebar' => 'Colonne latérale',
	'Banner Footer' => 'Bloc du pied de page',

## default_templates/archive_widgets_group.mtml
	q{This is a custom set of widgets that serve different content depending on the type of archive in which it is included. More info: [_1]} => q{Ceci est un ensemble de widgets servant différents contenus en fonction de l'archive qui les contient. Pour plus d'information : [_1]},
	'Current Category Monthly Archives' => 'Archives mensuelles de la catégorie courante',
	'Category Archives' => 'Archives par catégories',

## default_templates/author_archive_list.mtml
	'Authors' => 'Auteurs',
	'[_1] ([_2])' => '[_1] ([_2])',

## default_templates/banner_footer.mtml
	'_POWERED_BY' => 'Motorisé par <a href="https://www.movabletype.org/"><$MTProductName$></a>',
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Ce blog est publié sous licence <a href="[_1]">Creative Commons</a>.',

## default_templates/calendar.mtml
	'Monthly calendar with links to daily posts' => 'Calendrier mensuel avec des liens vers les notes du jour',
	'Sunday' => 'Dimanche',
	'Sun' => 'Dim',
	'Monday' => 'Lundi',
	'Mon' => 'Lun',
	'Tuesday' => 'Mar',
	'Tue' => 'Mar',
	'Wednesday' => 'Mercredi',
	'Wed' => 'Mer',
	'Thursday' => 'Jeudi',
	'Thu' => 'Jeu',
	'Friday' => 'Vendredi',
	'Fri' => 'Ven',
	'Saturday' => 'Samedi',
	'Sat' => 'Sam',

## default_templates/category_archive_list.mtml

## default_templates/category_entry_listing.mtml
	'[_1] Archives' => 'Archives [_1]',
	'Recently in <em>[_1]</em> Category' => 'Récemment dans la catégorie <em>[_1]</em>',
	'Entry Summary' => 'Résumé de la note',
	'Main Index' => 'Index principal',

## default_templates/creative_commons.mtml

## default_templates/current_author_monthly_archive_list.mtml
	'[_1]: Monthly Archives' => '[_1] : Archives mensuelles',

## default_templates/current_category_monthly_archive_list.mtml
	'[_1]' => '[_1]',

## default_templates/date_based_author_archives.mtml
	'Author Yearly Archives' => 'Archives annuelles par auteurs',
	'Author Weekly Archives' => 'Archives hebdomadaires par auteurs',
	'Author Daily Archives' => 'Archives quotidiennes par auteurs',

## default_templates/date_based_category_archives.mtml
	'Category Yearly Archives' => 'Archives annuelles par catégories',
	'Category Weekly Archives' => 'Archives hebdomadaires par catégories',
	'Category Daily Archives' => 'Archives quotidiennes par catégories',

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'Page non trouvée',

## default_templates/entry.mtml
	'By [_1] on [_2]' => 'Par [_1] le [_2]',
	'1 Comment' => 'Un commentaire',
	'# Comments' => '# commentaires',
	'No Comments' => 'Aucun commentaire',
	'1 TrackBack' => 'Un TrackBack',
	'# TrackBacks' => '# TrackBacks',
	'No TrackBacks' => 'Aucun TrackBack',
	'Tags' => 'Tags',
	'Trackbacks' => 'TrackBacks',
	'Comments' => 'Commentaires',

## default_templates/entry_summary.mtml
	'Continue reading <a href="[_1]" rel="bookmark">[_2]</a>.' => 'Lire la suite de <a href="[_1]" rel="bookmark">[_2]</a>.',

## default_templates/footer-email.mtml
	'Powered by Movable Type [_1]' => 'Motorisé par Movable Type [_1]',

## default_templates/javascript.mtml
	'moments ago' => 'il y a quelques instants',
	'[quant,_1,hour,hours] ago' => 'il y a [quant,_1,heure,heures]',
	'[quant,_1,minute,minutes] ago' => 'il y a [quant,_1,minute,minutes]',
	'[quant,_1,day,days] ago' => 'il y a [quant,_1,jour,jours]',
	'Edit' => 'Éditer',
	'Your session has expired. Please sign in again to comment.' => 'Votre session a expiré. Veuillez vous identifier à nouveau pour commenter.',
	'Signing in...' => 'Identification...',
	q{You do not have permission to comment on this blog. ([_1]sign out[_2])} => q{Vous n'avez pas la permission de commenter sur ce blog. ([_1]Déconnexion[_2])},
	'Thanks for signing in, __NAME__. ([_1]sign out[_2])' => 'Merci de vous être identifié(e) en tant que __NAME__. ([_1]Fermer la session[_2])',
	'[_1]Sign in[_2] to comment.' => '[_1]Identifiez-vous[_2] pour commenter.',
	'[_1]Sign in[_2] to comment, or comment anonymously.' => '[_1]Identifiez-vous[_2] pour commenter, ou laissez un commentaire anonyme.',
	'Replying to <a href="[_1]" onclick="[_2]">comment from [_3]</a>' => 'En réponse au <a href="[_1]" onclick="[_2]">commentaire de [_3]</a>',
	q{The sign-in attempt was not successful; Please try again.} => q{La tentative d'enregistrement a échoué. Veuillez réessayer.},

## default_templates/lockout-ip.mtml
	q{This email is to notify you that an IP address has been locked out.} => q{Cet e-mail est pour vous notifier qu'une adresse IP a été verrouillée.},
	'IP Address: [_1]' => 'Adresse IP : [_1]',
	'Recovery: [_1]' => 'Déverrouiller : [_1]',
	'Mail Footer' => 'Pied des e-mails',

## default_templates/lockout-user.mtml
	q{This email is to notify you that a Movable Type user account has been locked out.} => q{Cet e-mail est pour vous notifier qu'un compte Movable Type a été verrouillé.},
	'Username: [_1]' => 'Identifiant : [_1]',
	'Display Name: [_1]' => 'Nom affiché : [_1]',
	'Email: [_1]' => 'E-mail : [_1]',
	'If you want to permit this user to participate again, click the link below.' => 'Si voulez permettre à cet utilisateur de participer à nouveau, cliquez sur le lien ci-dessous.',

## default_templates/main_index.mtml

## default_templates/main_index_widgets_group.mtml
	q{This is a custom set of widgets that only appear on the homepage (or "main_index"). More info: [_1]} => q{Ceci est un groupe de widgets personnalisés qui n'apparaissent que sur la page d'accueil (ou "main_index").},
	'Recent Comments' => 'Commentaires récents',
	'Recent Entries' => 'Notes récentes',
	'Recent Assets' => 'Éléments récents',
	'Tag Cloud' => 'Nuage de tags',

## default_templates/monthly_archive_dropdown.mtml
	'Select a Month...' => 'Sélectionnez un mois...',

## default_templates/monthly_archive_list.mtml
	'[_1] <a href="[_2]">Archives</a>' => '<a href="[_2]">Archives</a> [_1]',

## default_templates/monthly_entry_listing.mtml

## default_templates/notify-entry.mtml
	q{A new [lc,_3] entitled '[_1]' has been published to [_2].} => q{Une nouvelle [lc,_3] intitulée '[_1]' a été publiée sur [_2].},
	'View entry:' => 'Voir la note :',
	'View page:' => 'Voir la page :',
	'[_1] Title: [_2]' => 'Titre du [_1] : [_2]',
	'Publish Date: [_1]' => 'Date de publication : [_1]',
	q{Message from Sender:} => q{Message de l'expéditeur :},
	q{You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:} => q{Vous recevez cet e-mail car vous avez demandé à recevoir les notifications de nouveau contenu sur [_1], ou l'auteur de la note a pensé que vous seriez intéressé. Si vous ne souhaitez plus recevoir ces e-mails, merci de contacter la personne suivante :},

## default_templates/openid.mtml
	'[_1] accepted here' => '[_1] est accepté',
	'http://www.sixapart.com/labs/openid/' => 'http://www.sixapart.com/labs/openid/',
	q{Learn more about OpenID} => q{Apprenez-en plus à propos d'OpenID},

## default_templates/page.mtml

## default_templates/pages_list.mtml
	'Pages' => 'Pages',

## default_templates/powered_by.mtml
	'_MTCOM_URL' => 'https://www.movabletype.com/',

## default_templates/recent_assets.mtml

## default_templates/recent_entries.mtml

## default_templates/recover-password.mtml
	'A request was made to change your Movable Type password. To complete this process click on the link below to select a new password.' => 'Une demande de réinitialisation de votre mot de passe Movable Type a été faite. Pour compléter cette demande, cliquez sur le lien ci-dessous pour choisir un nouveau mot de passe.',
	q{If you did not request this change, you can safely ignore this email.} => q{Si vous n'avez pas demandé ce changement, vous pouvez simplement ignorer cet e-mail.},

## default_templates/search.mtml
	'Search' => 'Rechercher',

## default_templates/search_results.mtml
	'Search Results' => 'Résultats de recherche',
	'Results matching &ldquo;[_1]&rdquo;' => 'Résultats pour &laquo; [_1] &raquo;',
	'Results tagged &ldquo;[_1]&rdquo;' => 'Résultats tagués &laquo; [_1] &raquo;',
	'Previous' => 'Précédent',
	'Next' => 'Suivant',
	'No results found for &ldquo;[_1]&rdquo;.' => 'Aucun résultat pour &laquo; [_1] &raquo;.',
	'Instructions' => 'Instructions',
	'By default, this search engine looks for all of the specified words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Par défaut, ce moteur va rechercher tous les mots dans le désordre. Pour chercher une expression exacte, placez-la entre apostrophes :',
	'movable type' => 'movable type',
	'The search engine also supports the AND, OR, and NOT boolean operators:' => 'Le moteur de recherche comprend aussi les opérateurs booléens AND, OR et NOT :',
	'personal OR publishing' => 'personnelle OR publication',
	'publishing NOT personal' => 'publication NOT personnelle',

## default_templates/sidebar.mtml
	'2-column layout - Sidebar' => 'Mise en page à 2 colonnes - Barre latérale',
	'3-column layout - Primary Sidebar' => 'Mise en page à 3 colonnes - Première barre latérale',
	'3-column layout - Secondary Sidebar' => 'Mise en page à 3 colonnes - Seconde barre latérale',

## default_templates/signin.mtml
	'Sign In' => 'Connexion',
	'You are signed in as ' => 'Vous êtes identifié en tant que ',
	'sign out' => 'déconnexion',
	q{You do not have permission to sign in to this blog.} => q{Vous n'avez pas l'autorisation de vous identifier sur ce blog.},

## default_templates/syndication.mtml
	q{Subscribe to feed} => q{S'abonner au flux},
	q{Subscribe to this blog's feed} => q{S'abonner au flux de ce blog},
	q{Subscribe to a feed of all future entries tagged &ldquo;[_1]&ldquo;} => q{S'abonner au flux de toutes les futures notes taguées &laquo; [_1] &raquo;},
	q{Subscribe to a feed of all future entries matching &ldquo;[_1]&ldquo;} => q{S'abonner au flux de toutes les futurs notes contenant &ldquo; [_1] &ldquo;},
	'Feed of results tagged &ldquo;[_1]&ldquo;' => 'Flux des résultats tagués &ldquo; [_1] &ldquo;',
	'Feed of results matching &ldquo;[_1]&ldquo;' => 'Flux des résultats pour &ldquo; [_1] &ldquo;',

## default_templates/tag_cloud.mtml

## default_templates/technorati_search.mtml
	'Technorati' => 'Technorati',
	q{<a href='http://www.technorati.com/'>Technorati</a> search} => q{Recherche <a href='http://www.technorati.com/'>Technorati</a> },
	'this blog' => 'ce blog',
	'all blogs' => 'tous les blogs',
	'Blogs that link here' => 'Blogs pointant ici',

## lib/MT/AccessToken.pm
	'AccessToken' => 'Clé d\'accès',

## lib/MT/App/ActivityFeeds.pm
	'Error loading [_1]: [_2]' => 'Erreur lors du chargement [_1] : [_2]',
	'An error occurred while generating the activity feed: [_1].' => 'Une erreur est survenue lors de la génération du flux d\'activité : [_1].',
	'No permissions.' => 'Pas d\'autorisations.',
	'[_1] Entries' => '[_1] notes',
	'All Entries' => 'Toutes les notes',
	'[_1] Activity' => '[_1] activité',
	'All Activity' => 'Toute l\'activité',
	'Invalid request.' => 'Demande invalide.',
	'Movable Type System Activity' => 'Activité du système Movable Type',
	'Movable Type Debug Activity' => 'Activité de débogage Movable Type',
	'[_1] Pages' => '[_1] pages',
	'All Pages' => 'Toutes les pages',
	'[_1] "[_2]" Content Data' => 'Données [_1] "[_2]"',
	'All "[_1]" Content Data' => 'Toutes les données "[_1]"',

## lib/MT/App/CMS/Common.pm
	'Some websites were not deleted. You need to delete blogs under the website first.' => 'Quelques sites n\'ont pas été supprimés. Vous devez supprimer les blogs de ces sites avant de supprimer ces sites.',

## lib/MT/App/CMS.pm
	'[_1]\'s Group' => 'Le Groupe de [_1]',
	'Invalid request' => 'Demande incorrecte',
	'Add a user to this [_1]' => 'Ajouter un utilisateur à ce [_1]',
	'Are you sure you want to reset the activity log?' => 'Voulez-vous vraiment réinitialiser le journal d\'activité ?',
	'_WARNING_PASSWORD_RESET_MULTI' => 'Vous êtes sur le point d\'envoyer des e-mails pour permettre aux utilisateurs sélectionnés de réinitialiser leur mot de passe. Voulez-vous continuer ?',
	'_WARNING_DELETE_USER_EUM' => 'Supprimer un utilisateur est une action définitive qui va rendre des notes orphelines. Si vous voulez retirer un utilisateur ou supprimer ses accès nous vous recommandons de désactiver son compte. Voulez-vous vraiment supprimer cet utilisateur ? Attention, il pourra se créer un nouvel accès s\'il existe encore dans le répertoire externe.',
	'_WARNING_DELETE_USER' => 'Supprimer un utilisateur est une action définitive qui va rendre des notes orphelines. Si vous souhaitez supprimer un utilisateur ou lui retirer ses accès nous vous recommandons de désactiver son compte. Voulez-vous vraiment supprimer cet utilisateur ?',
	'_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' => 'Cette action rétablira les gabarits par défaut pour le(s) blog(s) sélectionné(s). Voulez-vous vraiment rafraîchir les gabarits de ce(s) blog(s) ?',
	'Are you sure you want to delete the selected group(s)?' => 'Etes-vous sûr de vouloir effacer les groupes sélectionnés ?',
	'Are you sure you want to remove the selected member(s) from the group?' => 'Voulez-vous vraiment retirer les groupes sélectionnés ?',
	'https://www.movabletype.org/documentation/' => 'https://www.movabletype.org/documentation/',
	'Groups ([_1])' => 'Groupes ([_1])',
	'Failed login attempt by user who does not have sign in permission. \'[_1]\' (ID:[_2])' => 'Tentative de connexion par un utilisateur non autorisé. \'[_1]\' (ID:[_2])',
	'Invalid login.' => 'La connexion a échoué.',
	'Cannot load blog (ID:[_1])' => 'Impossible de charger le blog (ID:[_1])',
	'No such blog [_1]' => 'Aucun blog ne porte le nom [_1]',
	'Invalid parameter' => 'Paramètre invalide',
	'Edit Template' => 'Modifier un gabarit',
	'Back' => 'Retour',
	'Unknown object type [_1]' => 'Objet de type [_1] inconnu',
	'entry' => 'note',
	'content data' => 'donnée de contenu',
	'None' => 'Aucun',
	'Error during publishing: [_1]' => 'Erreur pendant la publication : [_1]',
	'Movable Type News' => 'Actualités Movable Type',
	'Notification Dashboard' => 'Tableau des notifications',
	'Site Stats' => 'Statistiques du site',
	'Updates' => 'Mise à jour',
	'Activity Log' => 'Journal d\'activité',
	'Site List' => 'Liste des sites',
	'Site List for Mobile' => 'Liste des sites pour mobiles', # Translate - New
	'Refresh Templates' => 'Réactualiser les gabarits',
	'Use Publishing Profile' => 'Utiliser un profil de publication',
	'Create Role' => 'Créer un rôle',
	'Grant Permission' => 'Ajouter une autorisation',
	'Clear Activity Log' => 'Effacer le journal d\'activité',
	'Download Log (CSV)' => 'Télécharger le journal (CSV)',
	'Add IP Address' => 'Ajouter une adresse IP',
	'Add Contact' => 'Ajouter un contact',
	'Download Address Book (CSV)' => 'Télécharger le carnet d\'adresses (CSV)',
	'Add user to group' => 'Ajouter l\'utilisateur au groupe',
	'Unpublish Entries' => 'Annuler la publication',
	'Add Tags...' => 'Ajouter des tags...',
	'Tags to add to selected entries' => 'Tags à ajouter aux notes sélectionnées',
	'Remove Tags...' => 'Enlever des tags...',
	'Tags to remove from selected entries' => 'Tags à enlever des notes sélectionnées',
	'Batch Edit Entries' => 'Modifier des notes par lot',
	'Publish' => 'Publier',
	'Delete' => 'Supprimer',
	'Unpublish Pages' => 'Dépublier les pages',
	'Tags to add to selected pages' => 'Tags à ajouter aux pages sélectionnées',
	'Tags to remove from selected pages' => 'Tags à supprimer des pages sélectionnées',
	'Batch Edit Pages' => 'Modifier les pages par lot',
	'Tags to add to selected assets' => 'Tags à ajouter aux éléments sélectionnés',
	'Tags to remove from selected assets' => 'Tags à supprimer les éléments sélectionnés',
	'Recover Password(s)' => 'Récupérer le mot de passe',
	'Enable' => 'Activer',
	'Disable' => 'Désactiver',
	'Unlock' => 'Déverrouiller',
	'Remove' => 'Retirer',
	'Refresh Template(s)' => 'Actualiser le(s) gabarit(s)',
	'Move child site(s) ' => 'Déplacer le(s) site(s) enfant(s)',
	'Clone Child Site' => 'Cloner le site enfant',
	'Publish Template(s)' => 'Publier le(s) gabarit(s)',
	'Clone Template(s)' => 'Cloner le(s) gabarit(s)',
	'Revoke Permission' => 'Révoquer l\'autorisation',
	'Rebuild' => 'Republier',
	'View Site' => 'Voir le site',
	'Profile' => 'Profil',
	'Documentation' => 'Documentation',
	'Sign out' => 'Déconnexion',
	'Sites' => 'Sites',
	'Content Data' => 'Donnée de contenu',
	'Entries' => 'Notes',
	'Category Sets' => 'Groupes de catégories',
	'Assets' => 'Éléments',
	'Content Types' => 'Types de contenu',
	'Groups' => 'Groupes',
	'Feedbacks' => 'Commentaires',
	'Roles' => 'Rôles',
	'Design' => 'Design',
	'Filters' => 'Filtres',
	'Settings' => 'Paramètres',
	'Tools' => 'Outils',
	'Manage' => 'Gérer',
	'New' => 'Créer',
	'Manage Members' => 'Gérer les membres',
	'Associations' => 'Associations',
	'Import' => 'Importer',
	'Export' => 'Exporter',
	'Folders' => 'Répertoires',
	'Upload' => 'Envoyer',
	'Themes' => 'Thèmes',
	'General' => 'Général',
	'Compose' => 'Rédiger',
	'Feedback' => 'Feedback',
	'Web Services' => 'Services web',
	'Plugins' => 'Plugins',
	'Rebuild Trigger' => 'Déclencheur de publication',
	'IP Banning' => 'Blockage IP',
	'User' => 'Utilisateur',
	'Search & Replace' => 'Rechercher et Remplacer',
	'Import Sites' => 'Importer les sites',
	'Export Sites' => 'Exporter les sites',
	'Export Site' => 'Exporter le site',
	'Export Theme' => 'Exporter le thème',
	'Address Book' => 'Carnet d\'adresses',
	'Asset' => 'Élément',
	'Website' => 'Site web',
	'Blog' => 'Blog',
	'Permissions' => 'Autorisations',

## lib/MT/App.pm
	'Problem with this request: corrupt character data for character set [_1]' => 'Requête erronée : jeu de caractères corrompu [_1]',
	'Cannot load blog #[_1]' => 'Impossible de charge le blog  #[_1]',
	'Internal Error: Login user is not initialized.' => 'Erreur interne : identifiant utilisateur non initialisé.',
	'The login could not be confirmed because of a database error ([_1])' => 'Login invérifiable suite à une erreur de base de données ([_1])',
	'Sorry, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Désolé, mais vous n\'avez pas l\'autorisation d\'accéder aux sites et blogs de cette installation. Si vous pensez qu\'il s\'agit d\'une erreur, veuillez contacter votre administrateur Movable Type.',
	'Cannot load blog #[_1].' => 'Impossible de charger le blog #[_1].',
	'Failed login attempt by unknown user \'[_1]\'' => 'Tentative de connexion par un utilisateur inconnu \'[_1]\'',
	'Failed login attempt by disabled user \'[_1]\'' => 'Tentative de connexion par un utilisateur désactivé \'[_1]\'',
	'This account has been disabled. Please see your Movable Type system administrator for access.' => 'Ce compte a été désactivé. Veuillez contacter votre administrateur Movable Type pour obtenir un accès.',
	'Failed login attempt by pending user \'[_1]\'' => 'Tentative d\'identification échoué par l\'utilisateur en attente \'[_1]\'',
	'This account has been deleted. Please see your Movable Type system administrator for access.' => 'Ce compte a été supprimé. Veuillez contacter votre administrateur Movable Type pour obtenir un accès.',
	'User cannot be created: [_1].' => 'L\'utilisateur n\'a pu être créé : [_1].',
	'User \'[_1]\' has been created.' => 'L\'utilisateur \'[_1]\' a été créé.',
	'Our apologies, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'Désolé mais vous n\'avez pas la permission d\'accéder aux blogs ou aux sites web de cette installation. Si vous pensez qu\'il s\'agit d\'une erreur, veuillez contacter votre administrateur système Movable Type.',
	'User \'[_1]\' (ID:[_2]) logged in successfully' => 'L\'utilisateur \'[_1]\' (ID:[_2]) s\'est identifié correctement',
	'Invalid login attempt from user \'[_1]\'' => 'Tentative d\'authentification invalide de l\'utilisateur \'[_1]\'',
	'User \'[_1]\' (ID:[_2]) logged out' => 'L\'utilisateur \'[_1]\' (ID:[_2]) s\'est déconnecté',
	'User requires password.' => 'L\'utilisateur doit avoir un mot de passe.',
	'Passwords do not match.' => 'Les mots de passe ne correspondent pas.',
	'URL is invalid.' => 'L\'URL est invalide.',
	'User requires display name.' => 'L\'utilisateur doit avoir un nom public.',
	'[_1] contains an invalid character: [_2]' => '[_1] contient un caractère invalide : [_2]',
	'Display Name' => 'Nom affiché',
	'Email Address is invalid.' => 'L\'adresse e-mail est invalide.',
	'Email Address' => 'Adresse e-mail',
	'Email Address is required for password reset.' => 'L\'adresse e-mail est requise pour la réinitialisation du mot de passe',
	'User requires username.' => 'L\'utilisateur doit avoir un nom d\'utilisateur.',
	'Username' => 'Nom d\'utilisateur',
	'A user with the same name already exists.' => 'Un utilisateur possédant ce nom existe déjà.',
	'Text entered was wrong.  Try again.' => 'Le texte entré est invalide. Réessayez.',
	'An error occurred while trying to process signup: [_1]' => 'Une erreur est survenue lors de l\'enregistrement : [_1]',
	'New Comment Added to \'[_1]\'' => 'Nouveau commentaire ajouté à \'[_1]\'',
	'System Email Address is not configured.' => 'Adresse e-mail du système non configurée.',
	'Unknown error occurred.' => 'Erreur inconnue.',
	'Close' => 'Fermer',
	'Failed to open monitoring file that specified by IISFastCGIMonitoringFilePath directive \'[_1]\': [_2]' => 'Impossible d\'ouvrir le fichier spécifié par la directive IISFastCGIMonitoringFilePath \'[_1]\' : [_2]',
	'Failed to open pid file [_1]: [_2]' => 'Impossible d\'ouvrir le fichier pid [_1] : [_2]',
	'Failed to send reboot signal: [_1]' => 'Impossible d\'envoyer un signal de redémarrage : [_1]',
	'The file you uploaded is too large.' => 'Le fichier téléchargé est trop lourd.',
	'Unknown action [_1]' => 'Action inconnue [_1]',
	'Warnings and Log Messages' => 'Mises en garde et entrées du journal d\'activité',
	'Removed [_1].' => '[_1] supprimés.',
	'Cannot load entry #[_1].' => 'Impossible de charger l\'entrée #[_1].',
	'You did not have permission for this action.' => 'Vous n\'avez pas la permission pour cette action.',
	'Password should not include your Username' => 'Le mot de passe ne doit pas être composé de votre nom d\'utilisateur',

## lib/MT/App/Search/ContentData.pm
	'Invalid archive type' => 'Type d\'archive non valide',
	'Invalid value: [_1]' => 'Valeur invalide : [_1]',
	'Invalid query: [_1]' => 'Requête non valide : [_1]',
	'Invalid SearchContentTypes "[_1]": [_2]' => 'SearchContentTypes invalide "[_1]": [_2]',
	'Invalid SearchContentTypes: [_1]' => 'SearchContentTypes invalide [_1]',

## lib/MT/App/Search.pm
	'Invalid type: [_1]' => 'Type invalide : [_1]',
	'Failed to cache search results.  [_1] is not available: [_2]' => 'Impossible de cacher les résultats de recherche. [_1] est indisponible : [_2]',
	'Invalid format: [_1]' => 'Format invalide : [_1]',
	'Unsupported type: [_1]' => 'Type non supporté : [_1]',
	'No column was specified to search for [_1].' => 'Aucune colonne spécifiée à la recherche de [_1].',
	'Search: query for \'[_1]\'' => 'Recherche : requête pour \'[_1]\'',
	'No alternate template is specified for template \'[_1]\'' => 'Aucun gabarit alternatif n\'est spécifié pour le gabarit \'[_1]\'',
	'Opening local file \'[_1]\' failed: [_2]' => 'L\'ouverture du fichier local \'[_1]\' a échoué : [_2]',
	'No such template' => 'Aucun gabarit trouvé',
	'template_id cannot refer to a global template' => 'template_id ne peut pas représenter un gabarit global',
	'Output file cannot be of the type asp or php' => 'Le fichier de sortie ne peut pas être de type asp ou php',
	'You must pass a valid archive_type with the template_id' => 'Vous devez indiquer un archive_type valide avec le template_id',
	'Template must be archive listing for non-Index archive types' => 'Le gabarit doit être de type liste pour toute archive qui n\'est pas un index.',
	'Filename extension cannot be asp or php for these archives' => 'L\'extension de fichier ne peut pas être asp ou php pour ces archives',
	'Template must be a main_index for Index archive type' => 'Le gabarit doit être un main_index pour une archive d\'index',
	'The search you conducted has timed out.  Please simplify your query and try again.' => 'La recherche que vous avez effectuée a expiré. Merci de simplifier votre requête et réessayer.',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearch fonctionne avec MT::App::Search.',

## lib/MT/App/Upgrader.pm
	'Could not authenticate using the credentials provided: [_1].' => 'Ne peut pas s\'identifier en utilisant les identifiants communiqués : [_1].',
	'Both passwords must match.' => 'Les deux mots de passe doivent être identiques.',
	'You must supply a password.' => 'Vous devez indiquer un mot de passe.',
	'Invalid email address \'[_1]\'' => 'Adresse e-mail invalide \'[_1]\'',
	'The \'Website Root\' provided below is not allowed' => 'La \'Racine du site web\' fournie ci-dessous est interdite',
	'The \'Website Root\' provided below is not writable by the web server.  Change the ownership or permissions on this directory, then click \'Finish Install\' again.' => 'La \'Racine du site web\' fournie ci-dessous n\'est pas accessible en écriture pour le serveur web. Changez la propriété ou les permissions sur le serveur puis recliquez sur \'Terminer l\'installation\'.',
	'Invalid session.' => 'Session invalide.',
	'Invalid parameter.' => 'Paramètre invalide.',
	'No permissions. Please contact your Movable Type administrator for assistance with upgrading Movable Type.' => 'Sans permission. Veuillez contacter votre administrateur Movable Type pour la mise à jour de Movable Type.',
	'Movable Type has been upgraded to version [_1].' => 'Movable Type a été mis à jour en version [_1].',

## lib/MT/App/Wizard.pm
	'The [_1] driver is required to use [_2].' => 'Le pilote [_1] est requis pour utiliser [_2].',
	'An error occurred while trying to connect to the database.  Check the settings and try again.' => 'Une erreur est survenue lors de la connexion à la base de données. Vérifiez les paramètres et réessayez.',
	'Please select a database from the list of available databases and try again.' => 'Veuillez choisir une base de données parmi celles disponibles dans la liste, et réessayez.',
	'SMTP Server' => 'Serveur SMTP',
	'Sendmail' => 'Sendmail',
	'Test email from Movable Type Configuration Wizard' => 'Test e-mail à partir de l\'assistant de configuration de Movable Type',
	'This is the test email sent by your new installation of Movable Type.' => 'Ceci est un e-mail de test envoyé par votre nouvelle installation Movable Type.',
	'Net::SMTP is required in order to send mail using an SMTP server.' => 'Net::SMTP est nécessaire pour envoyer des e-mails via un serveur SMTP.',
	'This module is needed if you want to use the MT XML-RPC server implementation.' => 'Ce module est nécessaire si vous souhaitez utiliser l\'implémentation serveur MT XML-RPC.',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Ce module est nécessaire si vous voulez pouvoir écraser les fichiers existants lorsque vous envoyez un nouveau fichier.',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Ce module est nécessaire si vous souhaitez pouvoir créer des vignettes pour les images envoyées.',
	'This module is needed if you would like to be able to use NetPBM as the image driver for MT.' => 'Ce module est nécessaire si vous souhaitez pouvoir utiliser NetPBM comme pilote d\'image pour MT.',
	'This module is required by certain MT plugins available from third parties.' => 'Ce module est nécessaire pour certains plugins MT disponibles auprès de partenaires.',
	'This module accelerates comment registration sign-ins.' => 'Ce module accélère les enregistrements des auteurs de commentaire.',
	'Cache::File is required if you would like to be able to allow commenters to be authenticated by Yahoo! Japan via OpenID.' => 'Cache::File est nécessaire si vous voulez permettre aux commentateurs de s\'authentifier depuis Yahoo! Japan via OpenID.',
	'This module is needed to enable comment registration. Also required in order to send mail via an SMTP Server.' => 'Ce module est nécessaire pour l\'enregistrement des commentaires, ainsi que pour l\'envoi de courriel via un serveur SMTP.',
	'This module enables the use of the Atom API.' => 'Ce module active l\'utilisation de l\'API Atom.',
	'This module is required in order to use memcached as caching mechanism by Movable Type.' => 'Ce module est requis pour utiliser memcached comme système de cache par Movable Type.',
	'This module is required in order to archive files in backup/restore operation.' => 'Ce module est nécessaire pour archiver les fichiers lors des opérations de sauvegarde/restauration.',
	'This module is required in order to compress files in backup/restore operation.' => 'Ce module est nécessaire pour compresser les fichiers lors des opérations de sauvegarde/restauration.',
	'This module is required in order to decompress files in backup/restore operation.' => 'Ce module est nécessaire pour décompresser les fichiers lors d\'une opération de sauvegarde/restauration.',
	'This module and its dependencies are required in order to restore from a backup.' => 'Ce module et ses dépendances sont nécessaires pour restaurer les fichiers à partir d\'une sauvegarde.',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.' => 'Ce module et ses dépendances sont requises afin de permettre aux auteurs de commentaire d\'être identifiés en utilisant les fournisseurs OpenID, comme LiveJournal.',
	'This module is required by mt-search.cgi if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'Ce module est nécessaire pour mt-search.cgi si vous utilisez Movable Type sur une version de Perl supérieure à 5.8.',
	'XML::SAX::ExpatXS is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::SAX::ExpatXS est optionnel. C\'est l\'un des modules nécessaires pour restaurer les fichiers à partir d\'une sauvegarde.',
	'XML::SAX::Expat is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::SAX::Expat est optionnel. C\'est l\'un des modules nécessaires pour restaurer les fichiers à partir d\'une sauvegarde.',
	'XML::LibXML::SAX is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'XML::LibXML::SAX est optionnel. C\'est l\'un des modules nécessaires pour restaurer les fichiers à partir d\'une sauvegarde.',
	'YAML::Syck is optional; It is a better, fast and lightweight alternative to YAML::Tiny for YAML file handling.' => 'YAML::Syck est optionnel. C\'est une meilleure alternative, plus rapide et plus légère, à YAML::Tiny pour le traitement des fichiers YAML.',
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Ce module est nécessaire pour les envois de fichiers (pour déterminer la taille des images dans différents formats).',
	'This module is required for cookie authentication.' => 'Ce module est nécessaire pour l\'authentification par cookies.',

## lib/MT/ArchiveType/AuthorDaily.pm
	'author/author-basename/yyyy/mm/dd/index.html' => 'auteur/nomdebase-auteur/aaaa/mm/jj/index.html',
	'author/author_basename/yyyy/mm/dd/index.html' => 'auteur/nomdebase_auteur/aaaa/mm/jj/index.html',

## lib/MT/ArchiveType/AuthorMonthly.pm
	'author/author-basename/yyyy/mm/index.html' => 'auteur/nomdebase-auteur/aaaa/mm/index.html',
	'author/author_basename/yyyy/mm/index.html' => 'auteur/nomdebase_auteur/aaaa/mm/index.html',

## lib/MT/ArchiveType/Author.pm
	'author/author-basename/index.html' => 'auteur/nomdebase-auteur/index.html',
	'author/author_basename/index.html' => 'auteur/nomdebase_auteur/index.html',

## lib/MT/ArchiveType/AuthorWeekly.pm
	'author/author-basename/yyyy/mm/day-week/index.html' => 'auteur/nomdebase-auteur/aaaa/mm/jour-semaine/index.html',
	'author/author_basename/yyyy/mm/day-week/index.html' => 'auteur/nomdebase_auteur/aaaa/mm/jour-semaine/index.html',

## lib/MT/ArchiveType/AuthorYearly.pm
	'author/author-basename/yyyy/index.html' => 'auteur/nomdebase-auteur/aaaa/index.html',
	'author/author_basename/yyyy/index.html' => 'auteur/nomdebase_auteur/aaaa/index.html',

## lib/MT/ArchiveType/CategoryDaily.pm
	'category/sub-category/yyyy/mm/dd/index.html' => 'categorie/sous-categorie/aaaa/mm/jj/index.html',
	'category/sub_category/yyyy/mm/dd/index.html' => 'categorie/sous_categorie/aaa/mm/jj/index.html',

## lib/MT/ArchiveType/CategoryMonthly.pm
	'category/sub-category/yyyy/mm/index.html' => 'categorie/sous-categorie/aaaa/mm/index.html',
	'category/sub_category/yyyy/mm/index.html' => 'categorie/sous_categorie/aaaa/mm/index.html',

## lib/MT/ArchiveType/Category.pm
	'category/sub-category/index.html' => 'categorie/sous-categorie/index.html',
	'category/sub_category/index.html' => 'categorie/sous_categorie/index.html',

## lib/MT/ArchiveType/CategoryWeekly.pm
	'category/sub-category/yyyy/mm/day-week/index.html' => 'categorie/sous-categorie/aaaa/mm/jour-semaine/index.html',
	'category/sub_category/yyyy/mm/day-week/index.html' => 'categorie/sous_categorie/aaaa/mm/jour-semaine/index.html',

## lib/MT/ArchiveType/CategoryYearly.pm
	'category/sub-category/yyyy/index.html' => 'categorie/sous-categorie/aaaa/index.html',
	'category/sub_category/yyyy/index.html' => 'categorie/sous_categorie/aaaa/index.html',

## lib/MT/ArchiveType/ContentTypeAuthorDaily.pm

## lib/MT/ArchiveType/ContentTypeAuthorMonthly.pm

## lib/MT/ArchiveType/ContentTypeAuthor.pm

## lib/MT/ArchiveType/ContentTypeAuthorWeekly.pm

## lib/MT/ArchiveType/ContentTypeAuthorYearly.pm

## lib/MT/ArchiveType/ContentTypeCategoryDaily.pm

## lib/MT/ArchiveType/ContentTypeCategoryMonthly.pm

## lib/MT/ArchiveType/ContentTypeCategory.pm

## lib/MT/ArchiveType/ContentTypeCategoryWeekly.pm

## lib/MT/ArchiveType/ContentTypeCategoryYearly.pm

## lib/MT/ArchiveType/ContentTypeDaily.pm
	'yyyy/mm/dd/index.html' => 'aaaa/mm/jj/index.html',

## lib/MT/ArchiveType/ContentTypeMonthly.pm
	'yyyy/mm/index.html' => 'aaaa/mm/index.html',

## lib/MT/ArchiveType/ContentType.pm
	'yyyy/mm/content-basename.html' => 'aaaa/mm/content-basename.html',
	'yyyy/mm/content_basename.html' => 'aaaa/mm/content_basename.html',
	'yyyy/mm/content-basename/index.html' => 'aaaa/mm/content-basename/index.html',
	'yyyy/mm/content_basename/index.html' => 'aaaa/mm/content_basename/index.html',
	'yyyy/mm/dd/content-basename.html' => 'aaaa/mm/jj/content-basename.html',
	'yyyy/mm/dd/content_basename.html' => 'aaaa/mm/jj/content_basename.html',
	'yyyy/mm/dd/content-basename/index.html' => 'aaaa/mm/jj/content-basename/index.html',
	'yyyy/mm/dd/content_basename/index.html' => 'aaaa/mm/jj/content_basename/index.html',
	'author/author-basename/content-basename/index.html' => 'author/author-basename/content-basename/index.html',
	'author/author_basename/content_basename/index.html' => 'author/author_basename/content_basename/index.html',
	'author/author-basename/content-basename.html' => 'author/author-basename/content-basename.html',
	'author/author_basename/content_basename.html' => 'author/author_basename/content_basename.html',
	'category/sub-category/content-basename.html' => 'categorie/sous-categorie/content-basename.html',
	'category/sub-category/content-basename/index.html' => 'categorie/sous-categorie/content-basename/index.html',
	'category/sub_category/content_basename.html' => 'categorie/sous_categorie/content_basename.html',
	'category/sub_category/content_basename/index.html' => 'categorie/sous_categorie/content_basename/index.html',

## lib/MT/ArchiveType/ContentTypeWeekly.pm
	'yyyy/mm/day-week/index.html' => 'aaaa/mm/jour-semaine/index.html',

## lib/MT/ArchiveType/ContentTypeYearly.pm
	'yyyy/index.html' => 'aaaa/index.html',

## lib/MT/ArchiveType/Daily.pm

## lib/MT/ArchiveType/Individual.pm
	'yyyy/mm/entry-basename.html' => 'aaaa/mm/nomdebase-note.html',
	'yyyy/mm/entry_basename.html' => 'aaaa/mm/nomdebase_note.html',
	'yyyy/mm/entry-basename/index.html' => 'aaaa/mm/nomdebase-note/index.html',
	'yyyy/mm/entry_basename/index.html' => 'aaaa/mm/nomdebase_note/index.html',
	'yyyy/mm/dd/entry-basename.html' => 'aaaa/mm/jj/nomdebase-note.html',
	'yyyy/mm/dd/entry_basename.html' => 'aaaa/mm/jj/nomdebase_note.html',
	'yyyy/mm/dd/entry-basename/index.html' => 'aaaa/mm/jj/nomdebase-note/index.html',
	'yyyy/mm/dd/entry_basename/index.html' => 'aaaa/mm/jj/nomdebase_note/index.html',
	'category/sub-category/entry-basename.html' => 'categorie/sous-categorie/nomdebase-note.html',
	'category/sub-category/entry-basename/index.html' => 'categorie/sous-categorie/nomdebase-note/index.html',
	'category/sub_category/entry_basename.html' => 'categorie/sous_categorie/nomdebase_note.html',
	'category/sub_category/entry_basename/index.html' => 'categorie/sous_categorie/nomdebase_note/index.html',

## lib/MT/ArchiveType/Monthly.pm

## lib/MT/ArchiveType/Page.pm
	'folder-path/page-basename.html' => 'chemin-repertoire/nomdebase-page.html',
	'folder-path/page-basename/index.html' => 'chemin-repertoire/nomdebase-page/index.html',
	'folder_path/page_basename.html' => 'chemin_repertoire/nomdebase_page.html',
	'folder_path/page_basename/index.html' => 'chemin_repertoire/nomdebase_page/index.html',

## lib/MT/ArchiveType/Weekly.pm

## lib/MT/ArchiveType/Yearly.pm

## lib/MT/Asset/Audio.pm

## lib/MT/Asset/Image.pm
	'Images' => 'Images',
	'Actual Dimensions' => 'Dimensions réelles',
	'[_1] x [_2] pixels' => '[_1] x [_2] pixels',
	'Error cropping image: [_1]' => 'Erreur de rognage de l\'image : [_1]',
	'Error scaling image: [_1]' => 'Erreur lors du redimensionnement de l\'image : [_1]',
	'Error converting image: [_1]' => 'Erreur pendant la conversion de l\'image : [_1]',
	'Error creating thumbnail file: [_1]' => 'Erreur lors de la création de la vignette : [_1]',
	'%f-thumb-%wx%h-%i%x' => '%f-thumb-%wx%h-%i%x',
	'Cannot load image #[_1]' => 'Impossible de charger l\'image #[_1]',
	'View image' => 'Voir l\'image',
	'Thumbnail image for [_1]' => 'Vignette de [_1]',
	'Saving [_1] failed: [_2]' => 'L\'enregistrement de [_1] a échoué : [_2]',
	'Invalid basename \'[_1]\'' => 'Nom de base invalide \'[_1]\'',
	'Error writing to \'[_1]\': [_2]' => 'Erreur d\'écriture sur \'[_1]\' : [_2]',
	'Popup page for [_1]' => 'Fenêtre surgissante pour [_1]',
	'Scaling image failed: Invalid parameter.' => 'L\'image n\'a pu être redimensionnée : paramètre invalide.',
	'Cropping image failed: Invalid parameter.' => 'L\'image n\'a pu être retaillée : paramètre invalide.',
	'Rotating image failed: Invalid parameter.' => 'L\'image n\'a pu être pivotée : paramètre invalide.',
	'Writing metadata failed: [_1]' => 'L\'écriture des métadonnées a échoué : [_1]',
	'Error writing metadata to \'[_1]\': [_2]' => 'Erreur d\'écriture des métadonnées vers \'[_1]\' : [_2]',
	'Extracting image metadata failed: [_1]' => 'L\'extraction des métadonnées image a échoué : [_1]',
	'Writing image metadata failed: [_1]' => 'L\'écriture des métadonnées image a échoué : [_1]',

## lib/MT/Asset.pm
	'Deleted' => 'Supprimé',
	'Enabled' => 'Activé',
	'Disabled' => 'Désactivé',
	'missing' => 'manquant',
	'extant' => 'existant',
	'Assets with Missing File' => 'Éléments sans fichier',
	'Assets with Extant File' => 'Éléments avec fichier existant',
	'Assets in [_1] field of [_2] \'[_4]\' (ID:[_3])' => 'Éléments du champ [_1] de [_2] \'[_4]\' (ID:[_3])',
	'No Label' => 'Pas d\'étiquette',
	'Content Field ( id: [_1] ) does not exists.' => 'Le champ de contenu (id : [_1]) n\'existe pas.',
	'Content Data ( id: [_1] ) does not exists.' => 'La donnée de contenu (id : [_1]) n\'existe pas.',
	'Content type of Content Data ( id: [_1] ) does not exists.' => 'Le type de contenu pour la donnée de contenu (id : [_1]) n\'existe pas.',
	'Could not remove asset file [_1] from the filesystem: [_2]' => 'Impossible de supprimer le fichier [_1] du système : [_2]',
	'Description' => 'Description',
	'Name' => 'Nom',
	'URL' => 'URL',
	'Location' => 'Adresse',
	'Could not create asset cache path: [_1]' => 'Impossible de créer le chemin du cache des éléments : [_1]',
	'string(255)' => 'chaîne(255)',
	'Label' => 'Étiquette',
	'Type' => 'Type',
	'Filename' => 'Nom de fichier',
	'File Extension' => 'Extension de fichier',
	'Pixel Width' => 'Largeur en pixel',
	'Pixel Height' => 'Hauteur en pixel',
	'Except Userpic' => 'Exclure les photos des utilisateurs',
	'Author Status' => 'Status de l\'auteur',
	'Missing File' => 'Fichier manquant',
	'Content Field' => 'Champ de contenu',
	'Assets of this website' => 'Éléments de ce site',

## lib/MT/Asset/Video.pm
	'Videos' => 'Vidéos',

## lib/MT/Association.pm
	'Association' => 'Association',
	'Permissions of group: [_1]' => 'Permissions du groupe [_1]',
	'Group' => 'Groupe',
	'Permissions with role: [_1]' => 'Autorisations avec rôle : [_1]',
	'User is [_1]' => 'L\'utilisateur est [_1]',
	'Permissions for [_1]' => 'Autorisations pour [_1]',
	'association' => 'association',
	'associations' => 'associations',
	'User/Group' => 'Utilisateur/Groupe',
	'User/Group Name' => 'Nom d\'utilisateur/groupe',
	'Role' => 'Rôle',
	'Role Name' => 'Nom du rôle',
	'Role Detail' => 'Détails du rôle',
	'Site Name' => 'Nom du site',
	'Permissions for Users' => 'Permissions pour les utilisateurs',
	'Permissions for Groups' => 'Permissions pour les groupes',

## lib/MT/AtomServer.pm
	'[_1]: Entries' => '[_1] : Notes',
	'Invalid blog ID \'[_1]\'' => 'ID du blog invalide \'[_1]\'',
	'PreSave failed [_1]' => 'Échec lors du pré-enregistrement [_1]',
	'Removing stats cache failed.' => 'La suppression du cache des statistiques a échoué',
	'User \'[_1]\' (user #[_2]) added [lc,_4] #[_3]' => 'L\'utilisateur \'[_1]\' (utilisateur #[_2]) a ajouté [lc,_4] #[_3]',
	'User \'[_1]\' (user #[_2]) edited [lc,_4] #[_3]' => 'L\'utilisateur \'[_1]\' (L\'utilisateur #[_2]) a édité [lc,_4] #[_3]',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from atom api' => 'Note \'[_1]\' ([lc,_5] #[_2]) supprimée par \'[_3]\' (utilisateur #[_4]) depuis l\'API Atom.',
	'\'[_1]\' is not allowed to upload by system settings.: [_2]' => '\'[_1]\' n\'est pas autorisé à télécharger par les paramètres système : [_2]',
	'Invalid image file format.' => 'Le format du fichier image est invalide.',
	'Cannot make path \'[_1]\': [_2]' => 'Impossible de créer le chemin \'[_1]\' : [_2]',
	'Perl module Image::Size is required to determine the width and height of uploaded images.' => 'Le module Perl Image::Size est requis pour déterminer la hauteur et la largeur des images téléchargées.',

## lib/MT/Auth/MT.pm
	'Failed to verify the current password.' => 'La vérification du mot de passe a échoué.',
	'Password contains invalid character.' => 'Le mot de passe contient des caractères invalides.',
	'Missing required module' => 'Un module requis est manquant',

## lib/MT/Author.pm
	'Users' => 'Utilisateurs',
	'Active' => 'Actif',
	'Pending' => 'En attente',
	'Not Locked Out' => 'Pas verrouillé',
	'Locked Out' => 'Verrouillé',
	'MT Users' => 'Utilisateurs MT',
	'Commenters' => 'Commentateurs',
	'Registered User' => 'Utilisateur enregistré',
	'The approval could not be committed: [_1]' => 'L\'approbation ne peut être réalisée : [_1]',
	'Userpic' => 'Image de l\'utilisateur',
	'User Info' => 'Infos de l\'utilisateur',
	'__ENTRY_COUNT' => 'Nombre de notes',
	'Content Data Count' => 'Nombre de données de contenu',
	'Created by' => 'Créé par',
	'Status' => 'Statut',
	'Website URL' => 'URL du site',
	'Privilege' => 'Privilège',
	'Lockout' => 'Verrouillé',
	'Enabled Users' => 'Utilisateurs actifs',
	'Disabled Users' => 'Utilisateurs désactivés',
	'Pending Users' => 'Utilisateurs en attente',
	'Locked out Users' => 'Utilisateurs déverrouillés',
	'MT Native Users' => 'Utilisateurs natifs MT',

## lib/MT/Auth.pm
	'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Mauvaise configuration du module d\'authentification \'[_1]\' : [_2]',
	'Bad AuthenticationModule config' => 'Mauvaise configuration du module d\'authentification',

## lib/MT/BackupRestore/BackupFileHandler.pm
	'The uploaded file was not a valid Movable Type exported manifest file.' => 'Le fichier chargé n\'est pas un export Movable Type valide.',
	'The uploaded exported manifest file was created with Movable Type, but the schema version ([_1]) differs from the one used by this system ([_2]).  You should not import this exported file to this version of Movable Type.' => 'Le fichier chargé est un export créé par Movable Type, mais la version de son schéma ([_1]) diffère de celle du présent système ([_2]). Vous ne devriez pas importer ce fichier dans cette version de Movable Type.',
	'[_1] is not a subject to be imported by Movable Type.' => '[_1] n\'est pas un sujet importable dans Movable Type.',
	'[_1] records imported.' => '[_1] enregistrements importés.',
	'Importing [_1] records:' => 'Import de [_1] enregistrements :',
	'A user with the same name as the current user ([_1]) was found in the exported file.  Skipping this user record.' => 'Un utilisateur avec le même nom que l\'utilisateur courant ([_1]) a été trouvé dans le fichier exporté. Son enregistrement a été omis.',
	'A user with the same name \'[_1]\' was found in the exported file (ID:[_2]).  Import replaced this user with the data from the exported file.' => 'Un utilisateur avec le même nom \'[_1]\' a été trouvé dans le fichier exporté (ID:[_2]). L\'import l\'a remplacé avec les données du fichier exporté.',
	'Invalid serializer version was specified.' => 'La version fournie du sérialiseur est invalide.',
	'Tag \'[_1]\' exists in the system.' => 'Le tag \'[_1]\' existe dans le système.',
	'[_1] records imported...' => '[_1] enregistrements importés…',
	'The role \'[_1]\' has been renamed to \'[_2]\' because a role with the same name already exists.' => 'Le rôle \'[_1]\' a été renommé \'[_2]\' car un autre rôle portant le même nom existe déjà.',
	'The system level settings for plugin \'[_1]\' already exist.  Skipping this record.' => '
	Le paramètre au niveau du système pour le plugin \'[_1]\' existe déjà. Enregistrement ignoré.',

## lib/MT/BackupRestore/BackupFileScanner.pm
	'Cannot import requested file because doing so requires the Digest::SHA Perl module. Please contact your Movable Type system administrator.' => 'L\'importation de ce fichier est impossible car il requiert le module Perl Digest::SHA. Veuillez contacter votre administrateur système Movable Type.',
	'Cannot import requested file because a site was not found in either the existing Movable Type system or the exported data. A site must be created first.' => 'L\'importation de ce fichier est impossible car il n\'existe pas de site ni dans le système Movable Type ni dans les données exportées. Un site doit d\'abord être créé.',

## lib/MT/BackupRestore/ManifestFileHandler.pm

## lib/MT/BackupRestore.pm
	"\nCannot write file. Disk full." => "
Impossible d\'enregistrer le fichier. Le disque est plein.",
	'Exporting [_1] records:' => 'Export de [_1] enregistrements :',
	'[_1] records exported...' => '[_1] enregistrements exportés…',
	'[_1] records exported.' => '[_1] enregistrements exportés.',
	'There were no [_1] records to be exported.' => 'Aucun enregistrement [_1] à exporter.',
	'Cannot open directory \'[_1]\': [_2]' => 'Impossible d\'ouvrir le répertoire \'[_1]\' : [_2]',
	'No manifest file could be found in your import directory [_1].' => 'Aucun fichier manifeste n\'a été trouvé dans votre répertoire d\'import [_1].',
	'Cannot open [_1].' => 'Impossible d\'ouvrir [_1].',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'Le fichier manifest [_1] n\'est pas un fichier manifeste de sauvegarde Movable Type.',
	'Manifest file: [_1]' => 'Fichier manifeste : [_1]',
	'Path was not found for the file, [_1].' => 'Chemin introuvable pour le fichier, [_1].',
	'[_1] is not writable.' => '[_1] non éditable.',
	'Error making path \'[_1]\': [_2]' => 'Erreur dans le chemin \'[_1]\' : [_2]',
	'Copying [_1] to [_2]...' => 'Copie de [_1] vers [_2]...',
	'Failed: ' => 'Échec : ',
	'Done.' => 'Terminé.',
	'Importing asset associations ... ( [_1] )' => 'Import des associations d\'éléments ( [_1] )…',
	'Importing asset associations in entry ... ( [_1] )' => 'Import des associations d\'éléments de note ( [_1] )…',
	'Importing asset associations in page ... ( [_1] )' => 'Import des associations d\'éléments de page ( [_1] )…',
	'Importing content data ... ( [_1] )' => 'Import des données de contenu ( [_1] )…',
	'Rebuilding permissions ... ( [_1] )' => 'Reconstruction des permissions ( [_1] )…',
	'Importing url of the assets ( [_1] )...' => 'Import des URLs des éléments ( [_1] )…',
	'Importing url of the assets in entry ( [_1] )...' => 'Import des URLs des éléments de note ( [_1] )…',
	'Importing url of the assets in page ( [_1] )...' => 'Import des URLs des éléments de page ( [_1] )…',
	'ID for the file was not set.' => 'L\'ID pour le fichier n\'a pas été spécifié.',
	'The file ([_1]) was not imported.' => 'Le fichier ([_1]) n\'a pas été importé.',
	'Changing path for the file \'[_1]\' (ID:[_2])...' => 'Changement du chemin du fichier \'[_1]\' (ID:[_2])...',
	'failed' => 'échec',
	'ok' => 'OK',

## lib/MT/BasicAuthor.pm
	'authors' => 'auteurs',

## lib/MT/Blog.pm
	'Child Site' => 'Site enfant',
	'Child Sites' => 'Sites enfants',
	'*Site/Child Site deleted*' => '*Site / Site enfant supprimé*',
	'First Blog' => 'Premier blog',
	'No default templates were found.' => 'Aucun gabarit par défaut trouvé.',
	'archive_type is needed in Archive Mapping \'[_1]\'' => 'archive_type est requis dans la correspondance d\'archive \'[_1]\'',
	'Invalid archive_type \'[_1]\' in Archive Mapping \'[_2]\'' => 'archive_type \'[_1]\' invalide dans la correspondance d\'archive \'[_2]\'',
	'Invalid datetime_field \'[_1]\' in Archive Mapping \'[_2]\'' => 'datetime_field \'[_1]\' invalide dans la correspondance d\'archive \'[_2]\'',
	'Invalid category_field \'[_1]\' in Archive Mapping \'[_2]\'' => 'category_field \'[_1]\' invalide dans la correspondance d\'archive \'[_2]\'',
	'category_field is required in Archive Mapping \'[_1]\'' => 'category_field est requis dans la correspondance d\'archive \'[_1]\'',
	'Clone of [_1]' => 'Clone de [_1]',
	'Cloned child site... new id is [_1].' => 'Site enfant cloné… Son nouvel identifiant est [_1].',
	'Cloning permissions for blog:' => 'Clonage des autorisations du blog :',
	'[_1] records processed...' => '[_1] enregistrements effectués...',
	'[_1] records processed.' => '[_1] enregistrements effectués.',
	'Cloning associations for blog:' => 'Clonage des associations du blog :',
	'Cloning entries and pages for blog...' => 'Clonage des notes et pages du blog en cours...',
	'Cloning categories for blog...' => 'Clonage des catégories du blog...',
	'Cloning entry placements for blog...' => 'Clonage des placements de notes du blog...',
	'Cloning entry tags for blog...' => 'Clonage des tags de notes du blog...',
	'Cloning templates for blog...' => 'Clonage des gabarits du blog...',
	'Cloning template maps for blog...' => 'Clonage des tables de correspondances des gabarits du blog...',
	'Failed to load theme [_1]: [_2]' => 'Échec lors du chargement du thème [_1] : [_2]',
	'Failed to apply theme [_1]: [_2]' => 'Échec de l\'application du thème [_1] : [_2]',
	'__PAGE_COUNT' => 'Nombre de pages',
	'__ASSET_COUNT' => 'Nombre d\'éléments',
	'Content Type' => 'Type de contenu',
	'Content Type Count' => 'Nombre de types de contenu',
	'Parent Site' => 'Site parent',
	'Theme' => 'Thème',

## lib/MT/Bootstrap.pm
	'Got an error: [_1]' => 'Une erreur s\'est produite : [_1]',

## lib/MT/Builder.pm
	'<[_1]> at line [_2] is unrecognized.' => '<[_1]> à la ligne [_2] n\'est pas reconnu.',
	'<[_1]> with no </[_1]> on line #' => '<[_1]> sans </[_1]> à la ligne #',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]> sans </[_1]> à la ligne [_2].',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]> sans </[_1]> à la ligne [_2]',
	'Error in <mt[_1]> tag: [_2]' => 'Erreur dans la balise <mt[_1]> : [_2]',
	'Unknown tag found: [_1]' => 'Une balise inconnue a été trouvée : [_1]',

## lib/MT/Category.pm
	'[quant,_1,entry,entries,No entries]' => '[quant,_1,note,notes,Pas de note]',
	'[quant,_1,page,pages,No pages]' => '[quant,_1,page,pages,Pas de page]',
	'Categories must exist within the same blog' => 'Les catégories doivent exister au sein du même blog',
	'Category loop detected' => 'Boucle de catégorie détectée',
	'string(100) not null' => 'chaîne(100) non nulle',
	'Basename' => 'Nom de base',
	'Parent' => 'Parent',

## lib/MT/CategorySet.pm
	'Category Set' => 'Groupe de catégories',
	'name "[_1]" is already used.' => 'Le nom "[_1]" est déjà utilisé.',
	'Category Count' => 'Nombre de catégories',
	'Category Label' => 'Label de catégorie',
	'Content Type Name' => 'Nom du type de contenu',

## lib/MT/CMS/AddressBook.pm
	'No entry ID was provided' => 'L\'ID de la note est manquant',
	'No such entry \'[_1]\'' => 'Aucune note du type \'[_1]\'',
	'No valid recipients were found for the entry notification.' => 'Aucun destinataire valide trouvé pour la notification de la note.',
	'[_1] Update: [_2]' => '[_1] Mise à jour : [_2]',
	'Error sending mail ([_1]): Try another MailTransfer setting?' => 'Erreur lors de l\'envoi de l\'e-mail ([_1]). Essayez de modifier le paramètre MailTransfer.',
	'Please select a blog.' => 'Merci de sélectionner un blog.',
	'The text you entered is not a valid email address.' => 'Le texte entré n\'est pas une adresse e-mail valide.',
	'The text you entered is not a valid URL.' => 'Le texte entré n\'est pas une adresse URL valide.',
	'The e-mail address you entered is already on the Notification List for this blog.' => 'L\'adresse e-mail saisie est déjà sur la liste de notification de ce blog.',
	'Subscriber \'[_1]\' (ID:[_2]) deleted from address book by \'[_3]\'' => 'Abonné \'[_1]\' (ID:[_2]) supprimé du carnet d\'adresses par \'[_3]\'',

## lib/MT/CMS/Asset.pm
	'(user deleted)' => '(utilisateur effacé)',
	'Files' => 'Fichiers',
	'Extension changed from [_1] to [_2]' => 'Extensions changées de [_1] vers [_2]',
	'Failed to create thumbnail file because [_1] could not handle this image type.' => 'Impossible de créer la vignette car [_1] ne gère pas ce type de fichier.',
	'Upload Asset' => 'Télécharger un élément',
	'Invalid Request.' => 'Requête invalide.',
	'Permission denied.' => 'Permission refusée.',
	'File with name \'[_1]\' already exists. Upload has been cancelled.' => 'Un fichier nommé \'[_1]\' existe déjà. Le téléchargement a été annulé.',
	'Cannot load file #[_1].' => 'Impossible de charger le fichier #[_1].',
	'No permissions' => 'Aucun droit',
	'File \'[_1]\' uploaded by \'[_2]\'' => 'Fichier \'[_1]\' envoyé par \'[_2]\'',
	'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Fichier \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
	'Untitled' => 'Sans nom',
	'Site' => 'Site',
	'basename of user' => 'nom de base de l\'utilisateur',
	'<[_1] Root>' => '<Racine du [_1]>',
	'<[_1] Root>/[_2]' => '<Racine du [_1]>/[_2]',
	'Archive' => 'Archive',
	'Custom...' => 'Personnalisé...',
	'Please select a file to upload.' => 'Merci de sélectionner un fichier à télécharger.',
	'Invalid filename \'[_1]\'' => 'Nom de fichier invalide \'[_1]\'',
	'Please select an audio file to upload.' => 'Merci de sélectionner un fichier audio à télécharger.',
	'Please select an image to upload.' => 'Merci de sélectionner une image à télécharger.',
	'Please select a video to upload.' => 'Merci de sélectionner une vidéo à télécharger.',
	'Movable Type was unable to write to the "Upload Destination". Please make sure that the webserver can write to this folder.' => 'Movable Type n\'a pas pu écrire dans la destination de téléchargement. Assurez-vous que Movable Type peut écrire dans ce répertoire.',
	'Invalid extra path \'[_1]\'' => 'Chemin supplémentaire invalide \'[_1]\'',
	'Invalid temp file name \'[_1]\'' => 'Nom de fichier temporaire invalide \'[_1]\'',
	'Error opening \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture de \'[_1]\' : [_2]',
	'Error deleting \'[_1]\': [_2]' => 'Erreur lors de la suppression de \'[_1]\' : [_2]',
	'File with name \'[_1]\' already exists. (Install the File::Temp Perl module if you would like to be able to overwrite existing uploaded files.)' => 'Un fichier nommé \'[_1]\' existe déjà. (Installez le module Perl File::Temp si vous souhaitez pouvoir écraser des fichiers existants.)',
	'Error creating a temporary file; The webserver should be able to write to this folder.  Please check the TempDir setting in your configuration file, it is currently \'[_1]\'. ' => 'Impossible de créer un fichier temporaire. Le serveur devrait pouvoir écrire dans ce répertoire. Veuillez vérifier la directive TempDir dans votre fichier de configuration, sa valeur actuelle est \'[_1]\'.',
	'unassigned' => 'non assigné',
	'File with name \'[_1]\' already exists; Tried to write to a tempfile, but the webserver could not open it: [_2]' => 'Un fichier nommé \'[_1]\' existe déjà. Une tentative de création d\'un fichier temporaire a échoué, le serveur web n\'a pas pu l\'ouvrir : [_2]',
	'Could not create upload path \'[_1]\': [_2]' => 'Impossible de créer le répertoire d\'upload \'[_1]\' : [_2]',
	'Error writing upload to \'[_1]\': [_2]' => 'Erreur d\'écriture lors de l\'envoi de \'[_1]\' : [_2]',
	'Uploaded file is not an image.' => 'Le fichier téléchargé n\'est pas une image.',
	'Cannot overwrite an existing file with a file of a different type. Original: [_1] Uploaded: [_2]' => 'Impossible de remplacer un fichier avec un autre de type différent. Original : [_1] / Téléchargé : [_2]',
	'File with name \'[_1]\' already exists.' => 'Un fichier nommé \'[_1]\' existe déjà.',
	'Cannot load asset #[_1].' => 'Impossible de charger l\'élément #[_1].',
	'Save failed: [_1]' => 'Échec de la sauvegarde : [_1]',
	'Saving object failed: [_1]' => 'Échec de la sauvegarde de l\'objet : [_1]',
	'Transforming image failed: [_1]' => 'La transformation de l\'image a échoué : [_1]',
	'Cannot load asset #[_1]' => 'Impossible de charger l\'élément #[_1]',

## lib/MT/CMS/Blog.pm
	q{Cloning child site '[_1]'...} => q{Clonage du site enfant '[_1]'...},
	'Error' => 'Erreur',
	'Finished!' => 'Terminé !',
	'General Settings' => 'Paramètres généraux',
	'Compose Settings' => 'Paramètres d\'édition',
	'These setting(s) are overridden by a value in the Movable Type configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.' => 'Ce ou ces paramètres sont invalidés par une valeur dans le fichier de configuration de MT : [_1]. Supprimez la valeur du fichier de configuration afin de la contrôler depuis cette page.',
	'Feedback Settings' => 'Paramètres des feedbacks',
	'Plugin Settings' => 'Paramètres des plugins',
	'Registration Settings' => 'Paramètres des enregistrements',
	'Create Child Site' => 'Créer un site enfant',
	'Cannot load template #[_1].' => 'Impossible de charger le gabarit #[_1].',
	'Cannot load content data #[_1].' => 'Impossible de charger la donnée de contenu #[_1].',
	'index template \'[_1]\'' => 'gabarit d\'index \'[_1]\'',
	'[_1] \'[_2]\'' => '[_1] \'[_2]\'',
	'[_1] (ID:[_2])' => '[_1] (ID:[_2])',
	'(no name)' => '(sans nom)',
	'Publish Site' => 'Publier le site',
	'Select Child Site' => 'Sélectionner un site enfant',
	'Selected Child Site' => 'Site enfant sélectionné',
	'Enter a site name to filter the choices below.' => 'Entrez un nom de site pour filtrer les choix ci-dessous.',
	'The \'[_1]\' provided below is not writable by the web server. Change the directory ownership or permissions and try again.' => 'Le \'[_1]\' fourni ci-dessous n\'est pas accessible en écriture pour le serveur web. Modifiez les droits du répertoire et réessayez.',
	'Blog Root' => 'Racine du blog',
	'Website Root' => 'Racine du site web',
	'Saving permissions failed: [_1]' => 'La sauvegarde des autorisations a échoué : [_1]',
	'[_1] changed from [_2] to [_3]' => '[_1] a changé de \'[_2]\' à \'[_3]\'',
	'Saved [_1] Changes' => 'Changements de [_1] enregistrés',
	'[_1] \'[_2]\' (ID:[_3]) created by \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) a été créé par \'[_4]\'',
	'You did not specify a blog name.' => 'Vous n\'avez pas spécifié de nom pour le blog.',
	'Site URL must be an absolute URL.' => 'L\'URL du site doit être une URL absolue.',
	'Archive URL must be an absolute URL.' => 'Les URLs d\'archive doivent être des URLs absolues.',
	'You did not specify an Archive Root.' => 'Vous n\'avez pas spécifié une racine d\'archive.',
	'The number of revisions to store must be a positive integer.' => 'Le nombre de révisions à stocker doit être un entier positif.',
	'Please choose a preferred archive type.' => 'Veuillez choisir le type d\'archive préférée.',
	'Blog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Blog \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
	'Saving blog failed: [_1]' => 'Échec de la sauvegarde du blog : [_1]',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Erreur : Movable Type ne peut pas écrire dans le répertoire de cache de gabarits. Merci de vérifier les autorisations du répertoire <code>[_1]</code> situé dans le répertoire du blog.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Erreur : Movable Type n\'a pas pu créer un répertoire pour cacher vos gabarits dynamiques. Vous devez créer un répertoire nommé <code>[_1]</code> dans le répertoire de votre blog.',
	'No blog was selected to clone.' => 'Aucun blog à cloner n\'a été sélectionné.',
	'This action can only be run on a single blog at a time.' => 'Cette action ne peut être exécutée que sur un seul blog à la fois.',
	'Invalid blog_id' => 'Identifiant du blog invalide',
	'This action cannot clone website.' => 'Cette action ne peut pas cloner un site web.',
	'Entries must be cloned if comments and trackbacks are cloned' => 'Les notes doivent être clonées si les commentaires et les TrackBacks le sont',
	'Entries must be cloned if comments are cloned' => 'Les notes doivent être clonées si les commentaires le sont',
	'Entries must be cloned if trackbacks are cloned' => 'Les notes doivent être clonées si les TrackBacks le sont',
	'\'[_1]\' (ID:[_2]) has been copied as \'[_3]\' (ID:[_4]) by \'[_5]\' (ID:[_6]).' => '\'[_1]\' (ID:[_2]) a été copié comme \'[_3]\' (ID:[_4]) par \'[_5]\' (ID:[_6]).',

## lib/MT/CMS/Category.pm
	'The [_1] must be given a name!' => 'Le [_1] doit avoir un nom !',
	'Invalid category_set_id: [_1]' => 'category_set_id invalide : [_1]',
	'Failed to update [_1]: Some of [_2] were changed after you opened this page.' => 'Impossible de mettre à jour [_1] : certains [_2] ont été modifiés après que vous avez ouvert cette page.',
	'Tried to update [_1]([_2]), but the object was not found.' => 'Tentative de mise à jour [_1] ([_2]), mais l\'objet est introuvable.',
	'[_1] order has been edited by \'[_2]\'.' => 'L\'ordre de [_1] a été édité par \'[_2]\'.',
	'Your changes have been made (added [_1], edited [_2] and deleted [_3]). <a href="#" onclick="[_4]" class="mt-rebuild">Publish your site</a> to see these changes take effect.' => 'Vos changements ont été effectués ([_1] ajoutés, [_2] édités et [_3] supprimés). <a href="#" onclick="[_4]" class="mt-rebuild">Publiez votre site</a> pour voir les changements.',
	'The category name \'[_1]\' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Le nom de la catégorie \'[_1]\' entre en conflit avec celui d\'une autre. Les catégories principales et celles secondaires du même parent doivent avoir un nom distinct.',
	'The category basename \'[_1]\' conflicts with the basename of another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => 'Le nom de base de la catégorie \'[_1]\' entre en conflit avec celui d\'une autre. Les catégories principales et celles secondaires du même parent doivent avoir un nom de base distinct.',
	'The name \'[_1]\' is too long!' => 'Le nom \'[_1]\' est trop long.',
	'Category \'[_1]\' created by \'[_2]\'.' => 'Catégorie \'[_1]\' créée par \'[_2]\'.',
	'Category \'[_1]\' (ID:[_2]) edited by \'[_3]\'' => 'Catégorie \'[_1]\' (ID:[_2]) éditée par \'[_3]\'',
	'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Catégorie \'[_1]\' (ID:[_2]) supprimée par \'[_3]\'',
	'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Le nom de catégorie \'[_1]\' est en conflit avec une autre catégorie. Les catégories racines et les sous-catégories qui ont le même parent doivent avoir un nom distinct.',
	'Edit [_1]' => 'Éditer [_1]',
	'Create [_1]' => 'Créer [_1]',
	'Manage [_1]' => 'Gérer les [_1]',
	'Create Category Set' => 'Créer un groupe de catégories',

## lib/MT/CMS/CategorySet.pm

## lib/MT/CMS/Common.pm
	'Invalid type [_1]' => 'Type invalide [_1]',
	'The Template Name and Output File fields are required.' => 'Le nom du gabarit et celui du fichier de sortie sont requis.',
	'Invalid ID [_1]' => 'ID invalide [_1]',
	'The blog root directory must be within [_1].' => 'Le répertoire racine du blog doit être dans [_1].',
	'The website root directory must be within [_1].' => 'Le répertoire racine du site doit être dans [_1].',
	'\'[_1]\' edited the template \'[_2]\' in the blog \'[_3]\'' => '\'[_1]\' a édité le gabarit \'[_2]\' du blog \'[_3]\'',
	'\'[_1]\' edited the global template \'[_2]\'' => '\'[_1]\' a édité le gabarit global \'[_2]\'',
	'Load failed: [_1]' => 'Échec du chargement : [_1]',
	'(no reason given)' => '(sans raison donnée)',
	'Web Services Settings' => 'Paramètres des services web',
	'Error occurred during permission check: [_1]' => 'Erreur lors de la vérification des permissions : [_1]',
	'Invalid filter: [_1]' => 'Filtre invalide : [_1]',
	'New Filter' => 'Nouveau filtre',
	'__SELECT_FILTER_VERB' => 'est',
	'All [_1]' => 'Totalité des [_1]',
	'[_1] Feed' => 'Flux [_1]',
	'Unknown list type' => 'Type de liste inconnu',
	'Invalid filter terms: [_1]' => 'Filtre invalide : [_1]',
	'An error occurred while counting objects: [_1]' => 'Une erreur est survenue au décompte des objets : [_1]',
	'An error occurred while loading objects: [_1]' => 'Une erreur est survenue au chargement des objets : [_1]',
	'Removing tag failed: [_1]' => 'La suppression du tag a échoué : [_1]',
	'Removing [_1] failed: [_2]' => 'La suppression de [_1] a échoué : [_2]',
	'System templates cannot be deleted.' => 'Les gabarits système ne peuvent pas être supprimés.',
	'The selected [_1] has been deleted from the database.' => 'Le [_1] sélectionné a été supprimé de la base de données.',
	'Permission denied: [_1]' => 'Autorisation refusée : [_1]',
	'Saving snapshot failed: [_1]' => 'L\'enregistrement de l\'instantané a échoué : [_1]',

## lib/MT/CMS/ContentData.pm
	'Cannot load content field (UniqueID:[_1]).' => 'Impossible de charger le champ de contenu (UniqueID:[_1]).',
	'The value of [_1] is automatically used as a data label.' => 'La valeur de [_1] est automatiquement utilisée comme étiquette de données.',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'Votre blog n\'a pas été configuré avec un chemin de site et une URL. Vous ne pourrez pas publier de notes tant qu\'ils ne seront pas définis.',
	'Invalid date \'[_1]\'; \'Published on\' dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Date invalide \'[_1]\'. Une date de publication doit être au format AAAA-MM-JJ HH:MM:SS.',
	'Invalid date \'[_1]\'; \'Unpublished on\' dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Date invalide \'[_1]\'. La date de dépublication doit avoir pour format YYYY-MM-DD HH:MM:SS.',
	'Invalid date \'[_1]\'; \'Unpublished on\' dates should be dates in the future.' => 'Date invalide \'[_1]\'. La date de dépublication doit être dans le futur.',
	'Invalid date \'[_1]\'; \'Unpublished on\' dates should be later than the corresponding \'Published on\' date.' => 'Date invalide \'[_1]\'. La date de dépublication doit être postérieure à celle de publication.',
	'Cannot load content_type #[_1]' => 'Impossible de charger le content_type #[_1]',
	'New [_1] \'[_4]\' (ID:[_2]) added by user \'[_3]\'' => 'Nouveau [_1] \'[_4]\' (ID:[_2]) ajouté par l\'utilisateur \'[_3]\'',
	'[_1] \'[_5]\' (ID:[_2]) edited and its status changed from [_3] to [_4] by user \'[_5]\'' => '[_1] \'[_5]\' (ID:[_2]) édité et son status changé de [_3] à [_4] par l\'utilisateur \'[_5]\'',
	'[_1] \'[_4]\' (ID:[_2]) edited by user \'[_3]\'' => '[_1] \'[_4]\' (ID:[_2]) édité par l\'utilisateur \'[_3]\'',
	'[_1] \'[_4]\' (ID:[_2]) deleted by \'[_3]\'' => '[_1] \'[_4]\' (ID:[_2]) supprimé par \'[_3]\'',
	'Create new [_1]' => 'Créer un nouveau  [_1]',
	'Cannot load template.' => 'Impossible de charger le gabarit',
	'Publish error: [_1]' => 'Erreur de publication : [_1]',
	'Unable to create preview files in this location: [_1]' => 'Impossible de créer les fichiers de prévisualisation à cet emplacement : [_1]',
	'(untitled)' => '(sans titre)',
	'New [_1]' => 'Nouvelle [_1]',
	'Need a status to update content data' => 'Status requis pour éditer une donnée de contenu',
	'Need content data to update status' => 'Donnée de contenu requise pour changer le status',
	'One of the content data ([_1]) did not exist' => 'Une des données de contenu ([_1]) n\'existait pas',
	'[_1] (ID:[_2]) status changed from [_3] to [_4]' => '[_1] (ID:[_2]) status changé de [_3] à [_4]',
	'(No Label)' => '(Sans étiquette)',
	'Unpublish Contents' => 'Dépublier les contenus',

## lib/MT/CMS/ContentType.pm
	'Create Content Type' => 'Créer un type de contenu',
	'Cannot load content type #[_1]' => 'Impossible de charger le type de contenu #[_1]',
	'The content type name is required.' => 'Le nom du type de contenu est requis.',
	'The content type name must be shorter than 255 characters.' => 'Le nom du type de contenu doit faire moins de 255 caractères.',
	'Name \'[_1]\' is already used.' => 'Le nom \'[_1]\' est déjà utilisé.',
	'Cannot load content field data (ID: [_1])' => 'Impossible de charger les données du champ de contenu (ID: [_1])',
	'Saving content field failed: [_1]' => 'Impossible de sauvegarder le champ de contenu : [_1]',
	'Saving content type failed: [_1]' => 'Impossible de sauvegarder le type de contenu : [_1]',
	'A label for content field of \'[_1]\' is required.' => 'Une étiquette pour le champ de contenu de \'[_1]\' est requise.',
	'A label for content field of \'[_1]\' should be shorter than 255 characters.' => 'L\'étiquette du champ de contenu de \'[_1]\' doit faire moins de 255 caractères.',
	'A description for content field of \'[_1]\' should be shorter than 255 characters.' => 'La description du champ de contenu de \'[_1]\' doit faire moins de 255 caractères.',
	'*User deleted*' => '*Utilisateur supprimé*',
	'Content Type Boilerplates' => 'Modèles de type de contenu',
	'Manage Content Type Boilerplates' => 'Gérer les modèles de type de contenu',
	'Content Type \'[_1]\' (ID:[_2]) added by user \'[_3]\'' => 'Type de contenu \'[_1]\' (ID:[_2]) ajouté par l\'utilisateur \'[_3]\'',
	'A content field \'[_1]\' ([_2]) was added' => 'Un champ de contenu \'[_1]\' ([_2]) a été ajouté',
	'A content field options of \'[_1]\' ([_2]) was changed' => 'Une option de champ de contenu de \'[_1]\' ([_2]) a été modifiée',
	'Some content fields were deleted: ([_1])' => 'Certains champs de contenu ont été supprimés : ([_1])',
	'Content Type \'[_1]\' (ID:[_2]) edited by user \'[_3]\'' => 'Type de contenu \'[_1]\' (ID:[_2]) modifié par l\'utilisateur \'[_3]\'',
	'Content Type \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Type de contenu \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
	'Create new content type' => 'Créer un nouveau type de contenu',

## lib/MT/CMS/Dashboard.pm
	'Error: This child site does not have a parent site.' => 'Erreur : ce site enfant n\'a pas de site parent.',
	'Not configured' => 'Non configuré',
	'Please contact your Movable Type system administrator.' => 'Veuillez contacter votre administrateur système Movable Type',
	'The support directory is not writable.' => 'Le répertoire support n\'est pas ouvert en écriture.',
	'Movable Type was unable to write to its \'support\' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.' => 'Movable Type n\'a pas pu écrire dans son répertoire \'support\'. Merci de créer un répertoire à cet endroit : [_1], et de lui ajouter des droits qui permettent au serveur web d\'écrire dedans.',
	'ImageDriver is not configured.' => 'ImageDriver n\'est pas configuré.',
	'An image processing toolkit, often specified by the ImageDriver configuration directive, is not present on your server or is configured incorrectly. A toolkit must be installed to ensure proper operation of the userpics feature. Please install Image::Magick, NetPBM, GD, or Imager, then set the ImageDriver configuration directive accordingly.' => 'Un outil de traitement d\'image, souvent spécifié par la directive de configuration ImageDriver, n\'est pas présent sur votre serveur ou n\'est pas configuré correctement. Un outil doit être installé pour permettre l\'utilisation correcte de la fonctionnalité des images d\'utilsateurs. Veuillez installer Image::Magick, NetPBM, GD ou Imager, puis spécifiez la directive de configuration ImageDriver.',
	'The System Email Address is used in the \'From:\' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events. Please confirm your <a href="[_1]">settings.</a>' => 'L\'adresse e-mail du système est utilisée comme entête de l\'expéditeur de chaque e-mail envoyé par Movable Type (récupération de mot de passe, enregistrement de commentateur, notification de commentaire ou de TrackBack, blocage d\'un utilisateur ou d\'une adresse IP, et d\'autres événements mineurs). Veuillez confirmer vos <a href="[_1]">paramètres</a>.',
	'Cannot verify SSL certificate.' => 'Impossible de vérifier le certificat SSL.',
	'Please install Mozilla::CA module. Writing "SSLVerifyNone 1" in mt-config.cgi can hide this warning, but this is not recommended.' => 'Veuillez installer le module Mozilla::CA. Ajouter "SSLVerifyNone 1" dans mt-config.cgi masque cet avertissement, mais ce n\'est pas recommandé.',
	'Can verify SSL certificate, but verification is disabled.' => 'Le certificat SSL pourrait être vérifié mais la vérification est désactivée.',
	'You should remove "SSLVerifyNone 1" in mt-config.cgi.' => 'Vous devriez supprimer "SSLVerifyNone 1" dans mt-config.cgi.',
	'System' => 'Système',
	'Unknown Content Type' => 'Type de contenu inconnu.',
	'Page Views' => 'Page vues',

## lib/MT/CMS/Debug.pm

## lib/MT/CMS/Entry.pm
	'New Entry' => 'Nouvelle note',
	'New Page' => 'Nouvelle page',
	'No such [_1].' => 'Pas de [_1].',
	'This basename has already been used. You should use an unique basename.' => 'Ce nom de base a déjà été utilisé. Vous devez utiliser un nom de base distinct.',
	'Saving placement failed: [_1]' => 'Échec de la sauvegarde du placement : [_1]',
	'Invalid date \'[_1]\'; [_2] dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Date invalide \'[_1]\'. Les dates [_2] doivent être au format AAAA-MM-JJ HH:MM:SS.',
	'Invalid date \'[_1]\'; \'Published on\' dates should be earlier than the corresponding \'Unpublished on\' date \'[_2]\'.' => 'Date invalide \'[_1]\'. La date \'Publiée le\' doit être antérieure à la date \'Dépubliée le\' \'[_2]\' correspondante.',
	'authored on' => 'créée le',
	'modified on' => 'modifiée le',
	'Saving entry \'[_1]\' failed: [_2]' => 'La sauvegarde de la note \'[_1]\' a échoué : [_2]',
	'Removing placement failed: [_1]' => 'Échec de la suppression de l\'emplacement : [_1]',
	'[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_1] \'[_2]\' (ID:[_3]) édité et son statut est passé de [_4] à [_5] par utilisateur \'[_6]\'',
	'[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) édité par utilisateur \'[_4]\'',
	'(user deleted - ID:[_1])' => '(utilisateur supprimé - ID : [_1])',
	'<a href="[_1]">QuickPost to [_2]</a> - Drag this bookmarklet to your browser\'s toolbar, then click it when you are visiting a site that you want to blog about.' => '<a href="[_1]">Publication rapide vers [_2]</a> — Glisser ce bookmarklet dans la barre de signets de votre navigateur et cliquez-le quand vous visitez un site que vous voulez mentionner sur votre blog.',
	'[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) ajouté par utilisateur \'[_4]\'',
	'[_1] \'[_2]\' (ID:[_3]) deleted by \'[_4]\'' => '[_1] \'[_2]\' (ID:[_3]) supprimée par \'[_4]\'',
	'Need a status to update entries' => 'Un statut est nécessaire pour mettre à jour les notes',
	'Need entries to update status' => 'Des notes sont nécessaires pour mettre à jour le statut',
	'One of the entries ([_1]) did not exist' => 'Une des notes ([_1]) n\'existe pas.',
	'[_1] \'[_2]\' (ID:[_3]) status changed from [_4] to [_5]' => '[_1] \'[_2]\' (ID:[_3]) statut changé de [_4] à [_5]',
	'/' => '/',

## lib/MT/CMS/Export.pm
	'Export Site Entries' => 'Exporter les notes du site',
	'Please select a site.' => 'Veuillez sélectionner un site.',
	'Loading site \'[_1]\' failed: [_2]' => 'Le chargement du site \'[_1]\' a échoué : [_2]',
	'You do not have export permissions' => 'Vous n\'avez pas les droits d\'exportation',

## lib/MT/CMS/Filter.pm
	'Failed to save filter: Label is required.' => 'Échec de la sauvegarde du filtre : le label est requis.',
	'Failed to save filter:  Label "[_1]" is duplicated.' => 'Échec de la sauvegarde du filtre : le label "[_1]" est dupliqué.',
	'No such filter' => 'Pas de tel filtre',
	'Permission denied' => 'Permission refusée',
	'Failed to save filter: [_1]' => 'Échec de la sauvegarde du filtre : [_1]',
	'Failed to delete filter(s): [_1]' => 'Échec de la suppression des filtres : [_1]',
	'Removed [_1] filters successfully.' => 'Retrait de [_1] filtres avec succès.',
	'[_1] ( created by [_2] )' => '[_1] ( créé par [_2] )',
	'(Legacy) ' => '(obsolète) ',

## lib/MT/CMS/Folder.pm
	'The folder \'[_1]\' conflicts with another folder. Folders with the same parent must have unique basenames.' => 'Le répertoire \'[_1]\' est en conflit avec un autre répertoire. Les répertoires qui ont le même répertoire parent doivent avoir un nom de base distinct.',
	'Folder \'[_1]\' created by \'[_2]\'' => 'Répertoire \'[_1]\' créé par \'[_2]\'',
	'Folder \'[_1]\' (ID:[_2]) edited by \'[_3]\'' => 'Répertoire \'[_1]\' (ID:[_2]) édité par \'[_3]\'',
	'Folder \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Répertoire \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',

## lib/MT/CMS/Group.pm
	'Each group must have a name.' => 'Chaque groupe doit avoir un nom.',
	'Select Users' => 'Utilisateurs sélectionnés',
	'Users Selected' => 'Utilisateurs sélectionnés',
	'Search Users' => 'Rechercher des utilisateurs',
	'Select Groups' => 'Sélectionner les groupes',
	'Group Name' => 'Nom du groupe',
	'Groups Selected' => 'Groupes sélectionnés',
	'Search Groups' => 'Rechercher des groupes',
	'Add Users to Groups' => 'Ajouter des utilisateurs aux groupes',
	'User \'[_1]\' (ID:[_2]) removed from group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) supprimé du groupe \'[_3]\' (ID:[_4]) par \'[_5]\'',
	'Group load failed: [_1]' => 'Chargement du groupe échoué : [_1]',
	'User load failed: [_1]' => 'Chargement de l\'utilisateur échoué : [_1]',
	'User \'[_1]\' (ID:[_2]) was added to group \'[_3]\' (ID:[_4]) by \'[_5]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) a été ajouté au groupe \'[_3]\' (ID:[_4]) par \'[_5]\'',
	'Create Group' => 'Créer un groupe',
	'Author load failed: [_1]' => 'Chargement de l\'auteur échoué : [_1]',

## lib/MT/CMS/Import.pm
	'Cannot load site #[_1].' => 'Impossible de charger le site #[_1].',
	'Import Site Entries' => 'Importer les notes du site',
	'You do not have import permission' => 'Vous n\'avez pas le droit d\'importer',
	'You do not have permission to create users' => 'Vous n\'avez pas l\'autorisation de créer des utilisateurs',
	'You need to provide a password if you are going to create new users for each user listed in your site.' => 'Vous devez fournir un mot de passe pour tous les nouveaux comptes utilisateurs à créer présents sur votre site.',
	'Importer type [_1] was not found.' => 'Type d\'importateur [_1] non trouvé.',

## lib/MT/CMS/Log.pm
	'All Feedback' => 'Tous les retours lecteurs',
	'Publishing' => 'Publication',
	'System Activity Feed' => 'Flux d\'activité du système',
	'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'Journal d\'activité pour le blog \'[_1]\' (ID:[_2]) réinitialisé par \'[_3]\'',
	'Activity log reset by \'[_1]\'' => 'Journal d\'activité réinitialisé par \'[_1]\'',

## lib/MT/CMS/Plugin.pm
	'Error saving plugin settings: [_1]' => 'Erreur à la sauvegarde des paramètres du plugin : [_1]',
	'Plugin Set: [_1]' => 'Éventail de plugins : [_1]',
	'Individual Plugins' => 'Plugins individuels',
	'Plugin' => 'plugin',

## lib/MT/CMS/RebuildTrigger.pm
	'Select Site' => 'Sélectionnez un site',
	'Select Content Type' => 'Sélectionner un type de contenu',
	'Create Rebuild Trigger' => 'Créer un événement de republication ',
	'Search Sites and Child Sites' => 'Chercher dans les sites et leurs enfants',
	'Search Content Type' => 'Cherche un type de contenu',
	'(All child sites in this site)' => '(Tous les sites enfants de ce site)',
	'Select to apply this trigger to all child sites in this site.' => 'Cochez pour appliquer ce déclencheur à tous les sites enfants de ce site.',
	'(All sites and child sites in this system)' => '(Tous les sites enfants de ce système)',
	'Select to apply this trigger to all sites and child sites in this system.' => 'Cochez pour appliquer ce déclencheur à tous les sites et sites enfants de ce système.',
	'Entry or Page' => 'Note ou page',
	'Comment' => 'Commentaire',
	'Trackback' => 'TrackBack',
	'saves an entry/page' => 'une note/page est sauvegardée',
	'Entry/Page' => 'Note/Page',
	'Save' => 'Enregistrer',
	'publishes an entry/page' => 'une note/page est publiée',
	'unpublishes an entry/page' => 'une note/page est dépubliée',
	'Unpublish' => 'Dé-publier',
	'saves a content' => 'Sauve le contenu',
	'publishes a content' => 'Publie le contenu',
	'unpublishes a content' => 'Dé-publie le contenu',
	'publishes a comment' => 'un commentaire est publié',
	'publishes a TrackBack' => 'un Trackback est publié',
	'TrackBack' => 'TrackBack',
	'rebuild indexes.' => 'reconstruire les index.',
	'rebuild indexes and send pings.' => 'reconstruire les index et envoyer les pings.',

## lib/MT/CMS/Search.pm
	q{No [_1] were found that match the given criteria.} => q{Aucun [_1] correspondant aux critères fournis n'a été trouvé.},
	'Data Label' => 'Étiquette de donnée',
	'Title' => 'Titre',
	'Entry Body' => 'Corps de la note',
	'Extended Entry' => 'Suite de la note',
	'Keywords' => 'Mots-clés',
	'Excerpt' => 'Extrait',
	'Page Body' => 'Corps de la page',
	'Extended Page' => 'Page étendue',
	'Template Name' => 'Nom du gabarit',
	'Text' => 'Texte',
	'Linked Filename' => 'Lien du fichier lié',
	'Output Filename' => 'Nom du fichier de sortie',
	'IP Address' => 'Adresse IP',
	'Log Message' => 'Message du journal',
	'Site URL' => 'URL du site',
	'Site Root' => 'Racine du site',
	'Invalid date(s) specified for date range.' => 'Date(s) incorrecte(s) pour la sélection de calendrier.',
	'Error in search expression: [_1]' => 'Erreur dans l\'expression de recherche : [_1]',
	'replace_handler of [_1] field is invalid' => 'replace_handler du champ [_1] est invalide',
	'"[_1]" field is required.' => 'Le champ "[_1]" est requis.',
	'ss_validator of [_1] field is invalid' => 'ss_validator du champ [_1] est invalide',
	'"[_1]" is invalid for "[_2]" field of "[_3]" (ID:[_4]): [_5]' => '"[_1]" est invalide pour le champ "[_2]" de "[_3]" (ID:[_4]): [_5]',
	'Searched for: \'[_1]\' Replaced with: \'[_2]\'' => 'Recherché : \'[_1]\' Remplacé par : \'[_2]\'',
	'[_1] \'[_2]\' (ID:[_3]) updated by user \'[_4]\' using Search & Replace.' => '[_1] \'[_2]\' (ID:[_3]) mis à jour par l\'utilisateur \'[_4]\' via Chercher/Remplacer.',
	'Templates' => 'Gabarits',

## lib/MT/CMS/Tag.pm
	'A new name for the tag must be specified.' => 'Un nouveau nom doit être spécifié pour ce tag.',
	'No such tag' => 'Pas de tag de ce type',
	'The tag was successfully renamed' => 'Le tag a bien été renommé.',
	'Error saving entry: [_1]' => 'Erreur d\'enregistrement de la note : [_1]',
	'Successfully added [_1] tags for [_2] entries.' => '[_1] tags ont bien été ajoutés à [_2] notes.',
	'Error saving file: [_1]' => 'Erreur en sauvegardant le fichier : [_1]',
	'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Tag \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',

## lib/MT/CMS/Template.pm
	'index' => 'index',
	'archive' => 'archive',
	'module' => 'module',
	'widget' => 'widget',
	'email' => 'Adresse e-mail',
	'backup' => 'sauvegarder',
	'system' => 'système',
	'One or more errors were found in this template.' => 'Une ou plusieurs erreurs ont été trouvées dans ce gabarit.',
	'Unknown blog' => 'Blog inconnu',
	'One or more errors were found in the included template module ([_1]).' => 'Une ou plusieurs erreurs ont été trouvées dans le module de gabarit inclus ([_1]).',
	'Global Template' => 'Gabarit global',
	'Invalid Blog' => 'Blog incorrect',
	'Global' => 'global',
	'You must specify a template type when creating a template' => 'Vous devez spécifier un type de gabarit lors de sa création',
	'contnt type' => 'Type de contenu',
	'Content Type Archive' => 'Archive de type de contenu',
	'Create Widget' => 'Créer un widget',
	'Create Template' => 'Créer un gabarit',
	'No Name' => 'Pas de nom',
	'Index Templates' => 'Gabarits d\'index',
	'Archive Templates' => 'Gabarits d\'archives',
	'Content Type Templates' => 'Gabarits de type de contenu',
	'Template Modules' => 'Modules de gabarits',
	'System Templates' => 'Gabarits système',
	'Email Templates' => 'Gabarits e-mail',
	'Template Backups' => 'Sauvegardes de gabarit',
	'Widget Template' => 'Gabarit de widget',
	'Widget Templates' => 'Gabarits de widget',
	'Cannot locate host template to preview module/widget.' => 'Impossible de localiser le gabarit du serveur pour prévisualiser le module/widget.',
	'Cannot preview without a template map!' => 'Prévisualisation impossible sans une carte de gabarit !',
	'Preview' => 'Aperçu',
	'Unable to create preview file in this location: [_1]' => 'Impossible de créer le fichier de pré-visualisation à cet endroit : [_1]',
	'Lorem ipsum' => 'Lorem ipsum',
	'LOREM_IPSUM_TEXT' => 'LOREM_IPSUM_TEXT',
	'LORE_IPSUM_TEXT_MORE' => 'LORE_IPSUM_TEXT_MORE',
	'sample, entry, preview' => 'extrait, note, prévisualisation',
	'Published Date' => 'Date de publication',
	'Cannot load templatemap' => 'Impossible de charger la table de correspondance des gabarits',
	'Saving map failed: [_1]' => 'Échec lors du rattachement : [_1]',
	'You should not be able to enter zero (0) as the time.' => 'Vous ne pouvez pas entrer zéro (0) comme heure.',
	'You must select at least one event checkbox.' => 'Vous devez cocher au moins une case événement.',
	'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Gabarit \'[_1]\' (ID:[_2]) créé par \'[_3]\'',
	'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Gabarit \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
	'Orphaned' => 'Orphelin',
	'Global Templates' => 'Gabarits globaux',
	' (Backup from [_1])' => ' (Sauvegarde depuis [_1])',
	'Error creating new template: ' => 'Erreur pendant la création du nouveau gabarit : ',
	'Setting up mappings failed: [_1]' => 'La mise en oeuvre des mappings a échoué : [_1]',
	'Template Refresh' => 'Réactualiser les gabarits',
	'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Saut du gabarit \'[_1]\' car c\'est un gabarit personnalisé.',
	'Refreshing template <strong>[_3]</strong> after making <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>.' => 'Réactualiser les gabarits <strong>[_3]</strong> depuis <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">la sauvegarde</a>',
	'Skipping template \'[_1]\' since it has not been changed.' => 'Saut du gabarit \'[_1]\' car il n\'a pas été modifié.',
	'Copy of [_1]' => 'Copie de [_1]',
	'Cannot publish a global template.' => 'Ne peut pas publier un gabarit global.',
	'Create Widget Set' => 'Créer un groupe de widgets',
	'template' => 'gabarit',

## lib/MT/CMS/Theme.pm
	'Theme not found' => 'Thème introuvable',
	'Failed to uninstall theme' => 'Impossible de désinstaller le thème',
	'Failed to uninstall theme: [_1]' => 'Impossible de désinstaller le thème : [_1]',
	'Theme from [_1]' => 'Thème de [_1]',
	'Install into themes directory' => 'Installer dans le répertoire des thèmes',
	'Download [_1] archive' => 'Télécharger l\'archive [_1]',
	'Export Themes' => 'Exporter les thèmes',
	'Failed to load theme export template for [_1]: [_2]' => 'Le chargement des gabarits d\'exportation de thème a échoué pour [_1] : [_2]',
	'Failed to save theme export info: [_1]' => 'La sauvegarde des informations d\'exportation de thème a échoué : [_1]',
	'Themes directory [_1] is not writable.' => 'Le répertoire des thèmes [_1] n\'est pas modifiable.',
	'All themes directories are not writable.' => 'Les répertoires des thèmes ne sont pas modifiables.',
	'Error occurred during exporting [_1]: [_2]' => 'Erreur lors de l\'exportation de [_1] : [_2]',
	'Error occurred during finalizing [_1]: [_2]' => 'Erreur lors de la finalisation de [_1] : [_2]',
	'Error occurred while publishing theme: [_1]' => 'Erreur pendant la publication du thème : [_1]',
	'Themes Directory [_1] is not writable.' => 'Le répertoire des thèmes [_1] n\'est pas modifiable.',

## lib/MT/CMS/Tools.pm
	'Password Recovery' => 'Récupération de mot de passe',
	'Email address is required for password reset.' => 'L\'adresse e-mail est requise pour la réinitialisation du mot de passe.',
	'Invalid email address' => 'Adresse e-mail invalide.',
	'Error sending e-mail ([_1]); Please fix the problem, then try again to recover your password.' => 'Impossible d\'envoyer l\'e-mail ([_1]). Veuillez corriger le problème puis réessayez de récupérer votre mot de passe.',
	'Password reset token not found' => 'Jeton de réinitialisation du mot de passe introuvable',
	'Email address not found' => 'Adresse e-mail introuvable',
	'User not found' => 'Utilisateur introuvable',
	'Your request to change your password has expired.' => 'Votre demande de réinitialisation de mot de passe a expiré.',
	'Invalid password reset request' => 'Requête de réinitialisation de mot de passe invalide',
	'Please confirm your new password' => 'Merci de confirmer votre nouveau mot de passe',
	'Passwords do not match' => 'Les mots de passe ne correspondent pas',
	'That action ([_1]) is apparently not implemented!' => 'Cette action ([_1]) n\'est visiblement pas implémentée !',
	'Error occurred while attempting to [_1]: [_2]' => 'Une erreur s\'est produite en essayant de [_1] : [_2]',
	'Please enter a valid email address.' => 'Veuillez entrer une adresse e-mail valide.',
	'You do not have a system email address configured.  Please set this first, save it, then try the test email again.' => 'L\'adresse e-mail système n\'est pas configurée. Veuillez la configurer puis réessayez d\'envoyer l\'e-mail de test.',
	'Test email from Movable Type' => 'Tester l\'e-mail depuis Movable Type',
	'This is the test email sent by Movable Type.' => 'Ceci est un e-mail de test envoyé par Movable Type.',
	'Test e-mail was successfully sent to [_1]' => 'L\'e-mail de test a été envoyé avec succès à [_1]',
	'E-mail was not properly sent. [_1]' => 'L\'e-mail de test n\'a pas pu être envoyé. [_1]',
	'Email address is [_1]' => 'L\'e-mail est [_1]',
	'Debug mode is [_1]' => 'Le mode de débogage est [_1]',
	'Performance logging is on' => 'La journalisation des performances est activée',
	'Performance logging is off' => 'La journalisation des performances est désactivée',
	'Performance log path is [_1]' => 'Le chemin d\'accès à la journalisation des perfomances est [_1]',
	'Performance log threshold is [_1]' => 'La limite de la journalisation des performances est [_1]',
	'Invalid SitePath.  The SitePath should be valid and absolute, not relative' => 'SitePath invalide. Ce chemin doit être valide et absolu, pas relatif.',
	'Prohibit comments is on' => 'Interdire les commentaires est actif',
	'Prohibit comments is off' => 'Interdire les commentaires est inactif',
	'Prohibit trackbacks is on' => 'Interdire les trackbacks est actif',
	'Prohibit trackbacks is off' => 'Interdire les trackbacks est inactif',
	'Prohibit notification pings is on' => 'Interdire les notifications est actif',
	'Prohibit notification pings is off' => 'Interdire les notifications est inactif',
	'Outbound trackback limit is [_1]' => 'La limite de trackbacks sortants est [_1]',
	'Any site' => 'Tout site',
	'Only to blogs within this system' => 'Seulement vers les blogs de ce système',
	'[_1] is [_2]' => '[_1] est [_2]',
	'none' => 'aucun fournisseur',
	'Changing image quality is [_1]' => 'Le changement de qualité d\'image est [_1]',
	'Image quality(JPEG) is [_1]' => 'La qualité d\'image JPEG est [_1]',
	'Image quality(PNG) is [_1]' => 'La qualité d\'image PNG est [_1]',
	'System Settings Changes Took Place' => 'Les changements des paramètres système ont pris place',
	'Invalid password recovery attempt; Cannot recover the password in this configuration' => 'Tentative de récupération de mot de passe invalide. Impossible de recouvrer le mot de passe avec cette configuration.',
	'Invalid author_id' => 'auteur_id incorrect',
	'Temporary directory needs to be writable for export to work correctly.  Please check TempDir configuration directive.' => 'Le répertoire temporaire doit être accessible en écriture pour l\'export. Veuillez vérifier la directive de configuration TempDir.',
	'Temporary directory needs to be writable for import to work correctly.  Please check TempDir configuration directive.' => 'Le répertoire temporaire doit être accessible en écriture pour l\'import. Veuillez vérifier la directive de configuration TempDir.',
	'[_1] is not a number.' => '[_1] n\'est pas un nombre.',
	'Copying file [_1] to [_2] failed: [_3]' => 'La copie du fichier [_1] vers [_2] a échoué : [_3]',
	'Specified file was not found.' => 'Le fichier spécifié est introuvable.',
	'[_1] successfully downloaded export file ([_2])' => '[_1] le fichier d\'export a été correctement chargé ([_2])',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1] : ',
	'Some of the actual files for assets could not be imported.' => 'Certains des fichiers correspondants aux éléments n\'ont pu être importés.',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Merci d\'utiliser xml, tar.gz, zip, ou manifest comme extension de fichier.',
	'Some objects were not imported because their parent objects were not imported.' => 'Certains objets n\'ont pas été importés car leurs objets parents ne l\'ont pas été.',
	'Detailed information is in the activity log.' => 'Des informations détaillées se trouvent dans le journal d\'activité.',
	'[_1] has canceled the multiple files import operation prematurely.' => '[_1] a annulé prématurément l\'importation de multiples fichiers.',
	'Changing Site Path for the site \'[_1]\' (ID:[_2])...' => 'Changement du chemin pour le site \'[_1]\' (ID:[_2])…',
	'Removing Site Path for the site \'[_1]\' (ID:[_2])...' => 'Supression du chemin pour le site \'[_1]\' (ID:[_2])…',
	'Changing Archive Path for the site \'[_1]\' (ID:[_2])...' => 'Changement du chemin pour l\'archive du site \'[_1]\' (ID:[_2])…',
	'Removing Archive Path for the site \'[_1]\' (ID:[_2])...' => 'Supression du chemin pour l\'archive du site \'[_1]\' (ID:[_2])…',
	'Changing file path for FileInfo record (ID:[_1])...' => 'Modification du chemin de fichier de l\'enregistrement FileInfo (ID:[_1])...',
	'Changing URL for FileInfo record (ID:[_1])...' => 'Modification d\'URL de l\'enregistrement FileInfo (ID:[_1])...',
	'Changing file path for the asset \'[_1]\' (ID:[_2])...' => 'Changement de chemin de fichier pour l\'élément \'[_1]\' (ID:[_2])...',
	'Manifest file [_1] was not a valid Movable Type exported manifest file.' => 'Le fichier de manfiste [_1] n\'est pas un manifeste valide pour un export Movable Type.',
	'Could not remove exported file [_1] from the filesystem: [_2]' => 'Impossible de supprimer le fichier exporté [_1] du système de fichiers : [_2]',
	'Some of the exported files could not be removed.' => 'Certains fichiers exportés n\'ont pu être supprimés.',
	'Please upload [_1] in this page.' => 'Merci de télécharger [_1] dans cette page.',
	'File was not uploaded.' => 'Le fichier n\'a pas été envoyé.',
	'Importing a file failed: ' => 'L\'importation d\'un fichier a échoué : ',
	'Some of the files were not imported correctly.' => 'Certains fichiers n\'ont pas être importés correctement.',
	'Successfully imported objects to Movable Type system by user \'[_1]\'' => 'Succès de l\'importation des objets dans le système Movable Type par l\'utilisateur \'[_1]\'',
	'Invalid password recovery attempt; cannot recover password in this configuration' => 'Tentative de récupération de mot de passe invalide. Impossible de récupérer le mot de passe dans cette configuration',
	'Cannot recover password in this configuration' => 'Impossible de récupérer le mot de passe dans cette configuration',
	'User \'[_1]\' (user #[_2]) does not have email address' => 'L\'utilisateur \'[_1]\' (utilisateur #[_2]) n\'a pas d\'adresse e-mail',
	'A password reset link has been sent to [_3] for user  \'[_1]\' (user #[_2]).' => 'Un lien de réinitialisation du mot de passe a été envoyé à [_3] concernant l\'utilisateur \'[_1]\' (utilisateur #[_2]).',
	'Some objects were not imported because their parent objects were not imported.  Detailed information is in the activity log.' => 'Certains objets n\'ont pas été importés car leurs objets parents ne l\'ont pas été. Plus de détails dans le log d\'activité.',
	'[_1] is not a directory.' => '[_1] n\'est pas un répertoire.',
	'Error occurred during import process.' => 'Une erreur est survenue durant l\'import.',
	'Some of files could not be imported.' => 'Certains fichiers n\'ont pas pu être importés.',
	'Uploaded file was not a valid Movable Type exported manifest file.' => 'Le fichier chargé n\'est pas un export valide de manifeste Movable Type.',
	'Manifest file \'[_1]\' is too large. Please use import directory for importing.' => 'Le fichier manifeste \'[_1]\' est trop large. Veuillez utiliser le répertoire d\'importation pour l\'import.',
	'Site(s) (ID:[_1]) was/were successfully exported by user \'[_2]\'' => 'Le(s) site(s) (ID:[_1]) a/ont été exporté(s) avec succès par l\'utilisateur \'[_2]\'',
	'Movable Type system was successfully exported by user \'[_1]\'' => 'Le système Movable Type a été exporté avec succès par l\'utilisateur \'[_1]\'',
	'Some [_1] were not imported because their parent objects were not imported.' => 'Certains [_1] n\'ont pas été importés car leurs objets parents ne l\'ont pas été.',
	'Recipients for lockout notification' => 'Destinataires des notifications de verrouillage',
	'User lockout limit' => 'Limite de verrouillage pour les utilisateurs',
	'User lockout interval' => 'Intervalle de verrouillage pour les utilisateurs',
	'IP address lockout limit' => 'Limite de verrouillage pour les adresses IP',
	'IP address lockout interval' => 'Intervalle de verrouillage pour les adresses IP',
	'Lockout IP address whitelist' => 'Liste blanche de verrouillage pour les adresses IP',

## lib/MT/CMS/User.pm
	'For improved security, please change your password' => 'Pour plus de sécurité, veuillez changer votre mot de passe',
	'Create User' => 'Créer un utilisateur',
	'Cannot load role #[_1].' => 'Impossible de charger le rôle #[_1].',
	'Role name cannot be blank.' => 'Le rôle ne peut pas être laissé vierge.',
	'Another role already exists by that name.' => 'Un autre rôle existe déjà avec ce nom.',
	'You cannot define a role without permissions.' => 'Vous ne pouvez pas définir un rôle sans autorisations.',
	'Invalid type' => 'Type incorrect',
	'User \'[_1]\' (ID:[_2]) could not be re-enabled by \'[_3]\'' => 'L\'utilisateur \'[_1]\' (ID:[_2]) n\'a pas pu être réactivé par \'[_3]\'',
	'User Settings' => 'Paramètres utilisateur',
	'Invalid ID given for personal blog theme.' => 'L\'ID communiqué est invalide pour un thème de blog personnel.',
	'Invalid ID given for personal blog clone location ID.' => 'L\'ID communiqué est invalide pour un ID de localisation de blog clone personnel.',
	'Minimum password length must be an integer and greater than zero.' => 'La longueur minimale du mot de passe doit être un entier supérieur à zéro.',
	'Select a entry author' => 'Sélectionner l\'auteur de la note',
	'Select a page author' => 'Sélectionner l\'auteur de la page',
	'Selected author' => 'Auteur sélectionné',
	'Type a username to filter the choices below.' => 'Tapez un nom d\'utilisateur pour affiner les choix ci-dessous.',
	'Select a System Administrator' => 'Sélectionner un administrateur système',
	'Selected System Administrator' => 'Administrateur système sélectionné',
	'System Administrator' => 'Administrateur système',
	'(newly created user)' => '(utilisateur nouvellement créé)',
	'Sites Selected' => 'Sites sélectionnés',
	'Select Roles' => 'Sélectionnez des rôles',
	'Roles Selected' => 'Rôles sélectionnés',
	'Grant Permissions' => 'Ajouter des autorisations',
	'Select Groups And Users' => 'Sélectionnez des groupes et des utilisateurs',
	'Groups/Users Selected' => 'Groupes/Utilisateurs sélectionnés',
	'You cannot delete your own association.' => 'Vous ne pouvez pas supprimer votre propre association.',
	'[_1]\'s Associations' => 'Associations de [_1]',
	'You have no permission to delete the user [_1].' => 'Vous n\'avez pas l\'autorisation d\'effacer l\'utilisateur [_1].',
	'User requires username' => 'Un nom d\'utilisateur est nécessaire pour l\'utilisateur',
	'User requires display name' => 'Un nom d\'affichage est nécessaire pour l\'utilisateur',
	'User requires password' => 'L\'utilisateur a besoin d\'un mot de passe',
	'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) créé par \'[_3]\'',
	'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Utilisateur \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
	'represents a user who will be created afterwards' => 'représente un utilisateur qui sera créé plus tard',

## lib/MT/CMS/Website.pm
	'Create Site' => 'Créer un site',
	'Website \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Site web \'[_1]\' (ID:[_2]) supprimé par \'[_3]\'',
	'Selected Site' => 'Site sélectionné',
	'Type a website name to filter the choices below.' => 'Entrez un nom de site web pour filtrer les choix ci-dessous.',
	'This action cannot move a top-level site.' => 'Cette action ne permet pas de déplacer un site de premier niveau',
	'Type a site name to filter the choices below.' => 'Entrez un nom de site pour filtrer les choix suivants.',
	'Cannot load website #[_1].' => 'Impossible de charger le site web #[_1].',
	'Blog \'[_1]\' (ID:[_2]) moved from \'[_3]\' to \'[_4]\' by \'[_5]\'' => 'Blog \'[_1]\' (ID:[_2]) déplacé de \'[_3]\' à \'[_4]\' par \'[_5]\'',

## lib/MT/Comment.pm
	'Loading entry \'[_1]\' failed: [_2]' => 'La chargement de la note \'[_1]\' a échoué : [_2]',
	'Loading blog \'[_1]\' failed: [_2]' => 'Le chargement du blog \'[_1]\' a échoué : [_2]',

## lib/MT/Compat/v3.pm
	'uses: [_1], should use: [_2]' => 'utilise : [_1], devrait utiliser : [_2]',
	'uses [_1]' => 'utilise [_1]',
	'No executable code' => 'Pas de code exécutable',
	'Publish-option name must not contain special characters' => 'La personnalisation du nom de publication ne doit pas contenir de caractères spéciaux',

## lib/MT/Component.pm
	'Loading template \'[_1]\' failed: [_2]' => 'Échec lors du chargement du gabarit \'[_1]\' : [_2]',

## lib/MT/ConfigMgr.pm
	'Alias for [_1] is looping in the configuration.' => 'L\'alias pour [_1] fait une boucle dans la configuration.',
	'Error opening file \'[_1]\': [_2]' => 'Erreur lors de l\'ouverture du fichier \'[_1]\' : [_2]',
	'Config directive [_1] without value at [_2] line [_3]' => 'Directive de Config  [_1] sans valeur sur [_2] ligne [_3]',
	'No such config variable \'[_1]\'' => 'Pas de telle variable de configuration \'[_1]\'',

## lib/MT/Config.pm
	'Configuration' => 'Configuration',

## lib/MT/ContentData.pm
	'Invalid content type' => 'Type de contenu invalide',
	'Saving content field index failed: [_1]' => 'La sauvegarde de l\'index de champ de contenu a échoué : [_1]',
	'Removing content field indexes failed: [_1]' => 'La suppression des index de champ de contenu a échoué : [_1]',
	'Saving object asset failed: [_1]' => 'La sauvegarde de l\'élément d\'objet a échoué : [_1]',
	'Removing object assets failed: [_1]' => 'La suppression des éléments d\'objet a échoué : [_1]',
	'Saving object tag failed: [_1]' => 'La sauvegarde de tag d\'objet a échoué : [_1]',
	'Removing object tags failed: [_1]' => 'La suppression des tags d\'objet a échoué : [_1]',
	'Saving object category failed: [_1]' => 'La sauvegarde de catégorie d\'objet a échoué : [_1]',
	'Removing object categories failed: [_1]' => 'La suppression de catégorie d\'objet a échoué : [_1]',
	'record does not exist.' => 'l\'enregistrement n\'existe pas.',
	'Cannot load content field #[_1]' => 'Impossible de charger le champ de contenu #[_1]',
	'Publish Date' => 'Date de publication',
	'Unpublish Date' => 'Date de dépublication',
	'[_1] ( id:[_2] ) does not exists.' => '[_1] (ID:[_2]) n\'existe pas.',
	'Contents by [_1]' => 'Contenus par [_1]',
	'Tags fields' => 'Champs de tags',
	'(No label)' => '(Aucun label)',
	'Identifier' => 'Identifiant',
	'Link' => 'Lien',

## lib/MT/ContentFieldIndex.pm
	'Content Field Index' => 'Index de champ de contenu',
	'Content Field Indexes' => 'Index de champ de contenu',

## lib/MT/ContentField.pm
	'Content Fields' => 'Champs de contenu',
	'Edit [_1] field' => 'Éditer le champ [_1]',

## lib/MT/ContentFieldType/Asset.pm
	'Show all [_1] assets' => 'Montrer tous les éléments [_1]',
	'You must select or upload correct assets for field \'[_1]\' that has asset type \'[_2]\'.' => 'Vous devez sélectionner ou télécharger les bons éléments pour le champ \'[_1]\' qui a le type d\'élément \'[_2]\'.',
	'A minimum selection number for \'[_1]\' ([_2]) must be a positive integer greater than or equal to 0.' => 'La sélection minimale pour \'[_1]\' ([_2]) doit être un entier supérieur ou égal à 0.',
	'A maximum selection number for \'[_1]\' ([_2]) must be a positive integer greater than or equal to 1.' => 'La sélection maximale pour \'[_1]\' ([_2]) doit être un entier supérieur ou égal à 1.',
	'A maximum selection number for \'[_1]\' ([_2]) must be a positive integer greater than or equal to the minimum selection number.' => 'La sélection maximale pour \'[_1]\' ([_2]) doit être un entier supérieur ou égal à la sélection minimale.',

## lib/MT/ContentFieldType/Categories.pm
	'Invalid Category IDs: [_1] in "[_2]" field.' => 'Identifiants de catégorie invalides : [_1] dans le champ "[_2]".',
	'You must select a source category set.' => 'Vous devez sélectionner un groupe de catégories source.',
	'The source category set is not found in this site.' => 'Le groupe de catégories est introuvable dans ce site.',
	'There is no category set that can be selected. Please create a category set if you use the Categories field type.' => 'Aucun groupe de catégories sélectionnable. Veuillez créer un groupe de catégories pour utiliser le type de champ catégorie.',

## lib/MT/ContentFieldType/Checkboxes.pm
	'You must enter at least one label-value pair.' => 'Vous devez entrer au moins une paire label/valeur.',
	'A label for each value is required.' => 'Chaque valeur requiert un label.',
	'A value for each label is required.' => 'Chaque label requiert une valeur.',

## lib/MT/ContentFieldType/Common.pm
	'is selected' => 'est sélectionné',
	q{is not selected} => q{n'est pas sélectionné},
	'In [_1] column, [_2] [_3]' => 'Dans la colonne [_1], [_2] [_3]',
	'Invalid [_1] in "[_2]" field.' => '[_1] invalide dans le champ "[_2]".',
	'[_1] less than or equal to [_2] must be selected in "[_3]" field.' => '[_1] inférieur ou égal à [_2] doit être sélectionné dans le champ "[_3]".',
	'[_1] greater than or equal to [_2] must be selected in "[_3]" field.' => '_1] supérieur ou égal à [_2] doit être sélectionné dans le champ "[_3]".',
	'Only 1 [_1] can be selected in "[_2]" field.' => 'Un seul [_1] peut être sélectionné dans le champ "[_2]".',
	'Invalid values in "[_1]" field: [_2]' => 'Valeurs invalides dans le champ "[_1]" : [_2]',
	'"[_1]" field value must be less than or equal to [_2].' => 'La valeur du champ "[_1]" doit être inférieure ou égale à [_2].',
	'"[_1]" field value must be greater than or equal to [_2]' => 'La valeur du champ "[_1]" doit être supérieure ou égale à [_2].',

## lib/MT/ContentFieldType/ContentType.pm
	'No Label (ID:[_1]' => 'Aucun label (ID:[_1]',
	'Invalid Content Data Ids: [_1] in "[_2]" field.' => 'Identifiants de données de contenu invalides : [_1] dans le champ "[_2]".',
	'You must select a source content type.' => 'Vous devez sélectionner une source de type de contenu.',
	'The source Content Type is not found in this site.' => 'La source de type de contenu est introuvable dans ce site.',
	'There is no content type that can be selected. Please create new content type if you use Content Type field type.' => 'Aucun type de contenu sélectionnable. Veuillez créer un type de contenu afin d\'utiliser le type de champ de type de contenu.',

## lib/MT/ContentFieldType/Date.pm
	'Invalid date \'[_1]\'; An initial date value must be in the format YYYY-MM-DD.' => 'Date invalide \'[_1]\'. Une valeur initiale de date doit avoir le format AAAA-MM-JJ.',

## lib/MT/ContentFieldType/DateTime.pm
	'Invalid date \'[_1]\'; An initial date/time value must be in the format YYYY-MM-DD HH:MM:SS.' => 'Date invalide \'[_1]\'. Une valeur initiale de date/horaire doit avoir le format AAAA-MM-JJ HH:MM:SS.',

## lib/MT/ContentFieldType/MultiLineText.pm

## lib/MT/ContentFieldType/Number.pm
	'"[_1]" field value must be a number.' => 'La valeur du champ "[_1]" doit être un nombre.',
	'"[_1]" field value has invalid precision.' => 'La valeur du champ "[_1]" a une précision invalide.',
	'Number of decimal places must be a positive integer.' => 'Le nombre de décimales doit être un entier positif.',
	'Number of decimal places must be a positive integer and between 0 and [_1].' => 'Le nombre de décimales doit être un entier positif entre 0 et [_1].',
	'A minimum value must be an integer, or must be set with decimal places to use decimal value.' => 'Une valeur minimale doit être un entier, ou un nombre à virgule pour utiliser une valeur décimale.',
	'A minimum value must be an integer and between [_1] and [_2]' => 'Une valeur minimale doit être un entier entre [_1] et [_2]',
	'A maximum value must be an integer, or must be set with decimal places to use decimal value.' => 'Une valeur maximale doit être un entier, ou un nombre à virgule pour utiliser une valeur décimale.',
	'A maximum value must be an integer and between [_1] and [_2]' => 'Une valeur maximale doit être un entier entre [_1] et [_2]',
	'An initial value must be an integer, or must be set with decimal places to use decimal value.' => 'Une valeur initiale doit être un entier, ou un nombre à virgule pour utiliser une valeur décimale.',
	'An initial value must be an integer and between [_1] and [_2]' => 'Une valeur initiale doit être un entier entre [_1] et [_2]',

## lib/MT/ContentFieldType.pm
	'Single Line Text' => 'Texte sur une ligne',
	'Multi Line Text' => 'Texte multi-lignes',
	'Number' => 'Nombre',
	'Date and Time' => 'Date et heure',
	'Date' => 'Date',
	'Time' => 'Heure',
	'Select Box' => 'Boite de sélection',
	'Radio Button' => 'Bouton radio',
	'Checkboxes' => 'Cases à cocher',
	'Audio Asset' => 'Élément audio',
	'Video Asset' => 'Élément vidéo',
	'Image Asset' => 'Élément image',
	'Embedded Text' => 'Text embarqué',
	'__LIST_FIELD_LABEL' => 'Liste', # Translate - New
	'Table' => 'Tableau',

## lib/MT/ContentFieldType/RadioButton.pm
	'A label of values is required.' => 'Un label de valeurs est requis.',
	'A value of values is required.' => 'Une valeur de valeurs est requise.',

## lib/MT/ContentFieldType/SelectBox.pm

## lib/MT/ContentFieldType/SingleLineText.pm
	'"[_1]" field is too long.' => 'Le champ "[_1]" est trop long.',
	'"[_1]" field is too short.' => 'Le champ "[_1]" est trop court.',
	'A minimum length number for \'[_1]\' ([_2]) must be a positive integer between 0 and [_3].' => 'La longueur minimale pour \'[_1]\' ([_2]) doit être un entoer positif entre 0 et [_3].',
	'A maximum length number for \'[_1]\' ([_2]) must be a positive integer between 1 and [_3].' => 'La longueur maximale pour \'[_1]\' ([_2]) doit être un entoer positif entre 1 et [_3].',
	'An initial value for \'[_1]\' ([_2]) must be shorter than [_3] characters' => 'La valeur initiale pour \'[_1]\' ([_2]) doit être plus courte que [_3] caractères',

## lib/MT/ContentFieldType/Table.pm
	'Initial number of rows for \'[_1]\' ([_2]) must be a positive integer.' => 'Le nombre initial de rangées pour \'[_1]\' ([_2]) doit être un entier positif.',
	'Initial number of columns for \'[_1]\' ([_2]) must be a positive integer.' => 'Le nombre initial de colonnes pour \'[_1]\' ([_2]) doit être un entier positif.',

## lib/MT/ContentFieldType/Tags.pm
	'Cannot create tags [_1] in "[_2]" field.' => 'Impossible de créer les tags [_1] dans le champ "[_2]".',
	'Cannot create tag "[_1]": [_2]' => 'Impossible de créer le tag [_1] : [_2]',
	'An initial value for \'[_1]\' ([_2]) must be an shorter than 255 characters' => 'La valeur initiale pour \'[_1]\' ([_2]) doit être inférieure à 255 caractères',

## lib/MT/ContentFieldType/Time.pm
	'<mt:var name="[_1]"> [_2] [_3] [_4]' => '<mt:var name="[_1]"> [_2] [_3] [_4]',
	'Invalid time \'[_1]\'; An initial time value be in the format HH:MM:SS.' => 'Horaire invalide \'[_1]\'. La valeur initiale doit être au format HH:MM:SS.',

## lib/MT/ContentFieldType/URL.pm
	'Invalid URL in "[_1]" field.' => 'URL incalide dans le champ "[_1]".',
	'An initial value for \'[_1]\' ([_2]) must be shorter than 2000 characters' => 'La valeur initiale pour \'[_1]\' ([_2]) doit être inférieure à 2000 caractères',

## lib/MT/ContentPublisher.pm
	'Loading of blog \'[_1]\' failed: [_2]' => 'Le chargement du blog \'[_1]\' a échoué : [_2]',
	'Archive type \'[_1]\' is not a chosen archive type' => 'Le Type d\'archive\'[_1]\' n\'est pas un type d\'archive sélectionné',
	'Load of blog \'[_1]\' failed: [_2]' => 'Le chargement du blog \'[_1]\' a échoué : [_2]',
	'Parameter \'[_1]\' is required' => 'Le paramètre \'[_1]\' est requis',
	'Parameter \'[_1]\' is invalid' => 'Le paramètre \'[_1]\' est invalide',
	'Load of blog \'[_1]\' failed' => 'Le chargement du blog \'[_1]\' a échoué',
	'[_1] archive type requires [_2] parameter' => 'Le type d\'archive [_1] requiert un paramètre [_2]',
	'An error occurred publishing [_1] \'[_2]\': [_3]' => 'Une erreur s\'est produite lors de la publication [_1] \'[_2]\' : [_3]',
	'An error occurred publishing date-based archive \'[_1]\': [_2]' => 'Une erreur s\'est produite en publiant l\'archive par dates \'[_1]\': [_2]',
	'Writing to \'[_1]\' failed: [_2]' => 'L\'écriture sur \'[_1]\' a échoué : [_2]',
	'Renaming tempfile \'[_1]\' failed: [_2]' => 'Le renommage de tempfile \'[_1]\' a échoué : [_2]',
	'You did not set your blog publishing path' => 'Vous n\'avez pas spécifié le chemin de publication de votre blog',
	'Cannot load catetory. (ID: [_1]' => 'Impossible de charger la catégorie. (ID : [_1]',
	'Scheduled publishing.' => 'Publication programmée.',
	'An error occurred while publishing scheduled contents: [_1]' => 'Erreur lors de la publication programmée de contenus : [_1]',
	'An error occurred while unpublishing past contents: [_1]' => 'Erreur lors de la dépublication de contenus passés : [_1]',

## lib/MT/ContentType.pm
	'Manage Content Data' => 'Gérer les données de contenu',
	'Create Content Data' => 'Créer une donnée de contenu',
	'Publish Content Data' => 'Publier des données de contenu',
	'Edit All Content Data' => 'Éditer les données de contenu',
	'"[_1]" (Site: "[_2]" ID: [_3])' => '"[_1]" (Site : "[_2]" ID : [_3])',
	'Content Data # [_1] not found.' => 'Donnée de contenu # [_1] introuvable.',
	'Tags with [_1]' => 'Tags avec [_1]',
	'string(40)' => 'string(40)',

## lib/MT/ContentType/UniqueID.pm
	'Cannot generate unique unique_id' => 'Impossible de générer un identifiant unique_id unique',

## lib/MT/Core.pm
	'This is often \'localhost\'.' => 'C\'est généralement \'localhost\'.',
	'The physical file path for your SQLite database. ' => 'Le chemin du fichier physique de votre base de données SQLite. ',
	'[_1] in [_2]: [_3]' => '[_1] dans [_2] : [_3]',
	'option is required' => 'L\'option est requise',
	'Days must be a number.' => 'Les jours doivent être un nombre.',
	'Invalid date.' => 'Date invalide.',
	'[_1] [_2] between [_3] and [_4]' => '[_1] [_2] entre [_3] et [_4]',
	'[_1] [_2] since [_3]' => '[_1] [_2] depuis [_3]',
	'[_1] [_2] or before [_3]' => '[_1] [_2] ou avant [_3]',
	'[_1] [_2] these [_3] days' => '[_1] [_2] ces [_3] jours',
	'[_1] [_2] future' => '[_1] [_2] futur',
	'[_1] [_2] past' => '[_1] [_2] passé',
	'[_1] [_3] [_2]' => '[_1] [_3] [_2]',
	'No Title' => 'sans titre',
	'(system)' => '(système)',
	'*Website/Blog deleted*' => '*Site/blog supprimé*',
	'My [_1]' => 'Mes [_1]',
	'[_1] of this Site' => '[_1] de ce site',
	'IP Banlist is disabled by system configuration.' => 'La configuration système a désactivé le banissement par adresse IP.',
	'Address Book is disabled by system configuration.' => 'La configuration système a désactivé le carnet d\'adresse.',
	'Error creating performance logs directory, [_1]. Please either change the permissions to make it writable or specify an alternate using the PerformanceLoggingPath configuration directive. [_2]' => 'Impossible de créer le répertoire des logs de performance, [_1]. Veuillez changer ses permissions pour qu\'il soit modifiale ou spécifiez-en un autre via la directive de configuration PerformanceLoggingPath. [_2]',
	'Error creating performance logs: PerformanceLoggingPath setting must be a directory path, not a file. [_1]' => 'Impossible de créer les logs de performance : PerformanceLoggingPath doit être le chemin d\'un répertoire, pas d\'un fichier. [_1]',
	'Error creating performance logs: PerformanceLoggingPath directory exists but is not writeable. [_1]' => 'Impossible de créer les logs de performance : le répertoire PerformanceLoggingPath existe mais n\'est pas modifiable.',
	'MySQL Database (Recommended)' => 'Base de données MySQL (recommandée)',
	'PostgreSQL Database' => 'Base de données PostgreSQL',
	'SQLite Database' => 'Base de données SQLite',
	'SQLite Database (v2)' => 'Base de données SQLite (v2)',
	'Database Server' => 'Serveur de base de données',
	'Database Name' => 'Nom de la base de données',
	'Password' => 'Mot de passe',
	'Database Path' => 'Chemin de la base de données',
	'Database Port' => 'Port de la base de données',
	'Database Socket' => 'Socket de la base de données',
	'ID' => 'ID',
	'No label' => 'Pas d\'étiquette',
	'Date Created' => 'Date de création',
	'Date Modified' => 'Date de modification',
	'Author Name' => 'Nom de l\'auteur',
	'Tag' => 'Tag',
	'Legacy Quick Filter' => 'Filtre rapide d\'obsolescence',
	'My Items' => 'Mes items',
	'Log' => 'Journal',
	'Activity Feed' => 'Flux d\'activité',
	'Folder' => 'Répertoire',
	'Member' => 'membre',
	'Members' => 'Membres',
	'Permission' => 'Autorisation',
	'IP address' => 'Adresse IP',
	'IP addresses' => 'Adresses IP',
	'IP Banning Settings' => 'Paramètres des IP bannies',
	'Contact' => 'Contact',
	'Manage Address Book' => 'Gérer l\'annuaire',
	'Filter' => 'Filtre',
	'Manage Content Type' => 'Gérer le type de contenu',
	'Manage Group Members' => 'Gérer les membres du groupe',
	'Group Members' => ' Membres du groupe',
	'Group Member' => 'Membre du groupe',
	'Convert Line Breaks' => 'Conversion retours ligne',
	'Rich Text' => 'Texte enrichi',
	'Movable Type Default' => 'Valeur par défaut Movable Type',
	'Classic Blog' => 'Blog classique',
	'Publishes content.' => 'Publication de contenu.',
	'Synchronizes content to other server(s).' => 'Synchronise le contenu vers d\'autres serveurs.',
	'Refreshes object summaries.' => 'Réactualise les résumés des objets.',
	'Adds Summarize workers to queue.' => 'Ajoute les robots de résumés à la queue.',
	'zip' => 'zip',
	'tar.gz' => 'tar.gz',
	'Entries List' => 'Liste des notes',
	'Blog URL' => 'URL du blog',
	'Blog ID' => 'ID du blog',
	'Blog Name' => 'Nom du blog',
	'Entry Excerpt' => 'Extrait de la note',
	'Entry Link' => 'Lien de la note',
	'Entry Extended Text' => 'Texte étendu de la note',
	'Entry Title' => 'Titre de la note',
	'If Block' => 'Bloc If',
	'If/Else Block' => 'Bloc If/Else',
	'Include Template Module' => 'Inclure un module de gabarit',
	'Include Template File' => 'Inclure un fichier de gabarit',
	'Get Variable' => 'Récupérer la variable',
	'Set Variable' => 'Spécifier la variable',
	'Set Variable Block' => 'Spécifier le bloc de variable',
	'Widget Set' => 'Groupe de widgets',
	'Publish Scheduled Entries' => 'Publier les notes planifiées',
	'Unpublish Past Entries' => 'Dépublier les notes précédentes',
	'Publish Scheduled Contents' => 'Publier les contenus programmés',
	'Unpublish Past Contents' => 'Dépublier les contenus passés',
	'Add Summary Watcher to queue' => 'Ajoute un surveillant de résumés à la queue',
	'Junk Folder Expiration' => 'Expiration du répertoire de spam',
	'Remove Temporary Files' => 'Supprimer les fichiers temporaires',
	'Purge Stale Session Records' => 'Purger les enregistrements des sessions périmées',
	'Purge Stale DataAPI Session Records' => 'Purger les enregistrements des sessions DataAPI périmées',
	'Remove expired lockout data' => 'Supprimer les données des verrouillages expirés',
	'Purge Unused FileInfo Records' => 'Vider les enregistrements d’informations de fichier inutilisés',
	'Remove Compiled Template Files' => 'Supprimer les fichiers de gabarits compilés',
	'Manage Sites' => 'Gérer les sites',
	'Manage Website' => 'Gérer un site web',
	'Manage Blog' => 'Gérer un blog',
	'Manage Website with Blogs' => 'Gérer un site web avec des blogs',
	'Create Sites' => 'Créer des sites',
	'Post Comments' => 'Commentaires de la note',
	'Create Entries' => 'Création d\'une note',
	'Edit All Entries' => 'Éditer toutes les entrées',
	'Manage Assets' => 'Gérer les élements',
	'Manage Categories' => 'Gérer les catégories',
	'Change Settings' => 'Changer les paramètres',
	'Manage Tags' => 'Gérer les tags',
	'Manage Templates' => 'Gérer les gabarits',
	'Manage Feedback' => 'Gérer les retours',
	'Manage Content Types' => 'Gérer les types de contenu',
	'Manage Pages' => 'Gérer les pages',
	'Manage Users' => 'Gérer les utilisateurs',
	'Manage Themes' => 'Gérer les thèmes',
	'Publish Entries' => 'Publier les notes',
	'Send Notifications' => 'Envoyer des notifications',
	'Set Publishing Paths' => 'Régler les chemins de publication',
	'View Activity Log' => 'Afficher le journal d\'activité',
	'Manage Category Set' => 'Gérer les groupes de catégories',
	'Upload File' => 'Télécharger un fichier',
	'Create Child Sites' => 'Créer des sites enfants',
	'Manage Plugins' => 'Gérer les plugins',
	'View System Activity Log' => 'Afficher le journal d\'activité du système',
	'Sign In(CMS)' => 'Se connecter (CMS)',
	'Sign In(Data API)' => 'Se connecter (Data API)',
	'Create Websites' => 'Créer des sites web',
	'Manage Users & Groups' => 'Gérer les utilisateurs et groupes',

## lib/MT/DataAPI/Callback/Blog.pm
	'A parameter "[_1]" is required.' => 'Un paramètre "[_1]" est requis.',
	'The website root directory must be an absolute path: [_1]' => 'Le répertoire racine du site doit être un chemin absolu : [_1]',
	'Invalid theme_id: [_1]' => 'theme_id invalide : [_1]',
	'Cannot apply website theme to blog: [_1]' => 'Impossible d\'appliquer le thème du site au blog : [_1]',

## lib/MT/DataAPI/Callback/Category.pm
	'The label \'[_1]\' is too long.' => 'Le label \'[_1]\' est trop long.',
	'Parent [_1] (ID:[_2]) not found.' => '[_1] parent (ID:[_2]) introuvable.',

## lib/MT/DataAPI/Callback/CategorySet.pm
	'Name "[_1]" is used in the same site.' => 'Le nom "[_1]" est utilisé dans le même site.',

## lib/MT/DataAPI/Callback/ContentData.pm
	'There is an invalid field data: [_1]' => 'Donnée de champ invalide : [_1]',

## lib/MT/DataAPI/Callback/ContentField.pm
	'A parameter "[_1]" is invalid: [_2]' => 'Un paramètre "[_1]" est invalide : [_2]',
	'Invalid option key(s): [_1]' => 'Clé(s) d\'option invalide(s) : [_1]',
	'options_validation_handler of "[_1]" type is invalid' => 'options_validation_handler du type "[_1]" est invalide',
	'Invalid option(s): [_1]' => 'Option(s) invalide(s) : [_1]',

## lib/MT/DataAPI/Callback/ContentType.pm

## lib/MT/DataAPI/Callback/Entry.pm

## lib/MT/DataAPI/Callback/Group.pm
	'A parameter "[_1]" is invalid.' => 'Un paramètre "[_1]" est invalide.',

## lib/MT/DataAPI/Callback/Log.pm
	'author_id (ID:[_1]) is invalid.' => 'author_id (ID:[_1]) est invalide.',
	'Log (ID:[_1]) deleted by \'[_2]\'' => 'Log (ID:[_1]) supprimé par \'[_2]\'',

## lib/MT/DataAPI/Callback/Role.pm

## lib/MT/DataAPI/Callback/Tag.pm
	'Invalid tag name: [_1]' => 'Nom de tag invalide : [_1]',

## lib/MT/DataAPI/Callback/TemplateMap.pm
	'Invalid archive type: [_1]' => 'Type d\'archive invalide : [_1]',

## lib/MT/DataAPI/Callback/Template.pm

## lib/MT/DataAPI/Callback/User.pm
	'Invalid language: [_1]' => 'Paramètre "language" invalide : [_1]',
	'Invalid dateFormat: [_1]' => 'Paramètre "dateFormat" invalide : [_1]',
	'Invalid textFormat: [_1]' => 'Paramètre "textFormat" invalide : [_1]',

## lib/MT/DataAPI/Callback/Widget.pm

## lib/MT/DataAPI/Callback/WidgetSet.pm

## lib/MT/DataAPI/Endpoint/Auth.pm
	'Failed login attempt by user who does not have sign in permission via data api. \'[_1]\' (ID:[_2])' => 'Tentative de connexion invalide par un utilisateur n\'ayant pas d\'autorisation via l\'API Data. \'[_1]\' (ID:[_2])',
	'User \'[_1]\' (ID:[_2]) logged in successfully via data api.' => 'L\'utilisateur \'[_1]\' (ID:[_2]) s\'est connecté avec succès via l\'API Data.',

## lib/MT/DataAPI/Endpoint/Common.pm
	'Invalid dateFrom parameter: [_1]' => 'Le paramètre dateFrom est invalide : [_1]',
	'Invalid dateTo parameter: [_1]' => 'Le paramètre dateTo est invalide : [_1]',

## lib/MT/DataAPI/Endpoint/Entry.pm

## lib/MT/DataAPI/Endpoint/v2/Asset.pm
	'The asset does not support generating a thumbnail file.' => 'Cet élément ne permet pas de générer une vignette.',
	'Invalid width: [_1]' => 'Largeur invalide : [_1]',
	'Invalid height: [_1]' => 'Hauteur invalide : [_1]',
	'Invalid scale: [_1]' => 'Échelle invalide : [_1]',

## lib/MT/DataAPI/Endpoint/v2/BackupRestore.pm
	'An error occurred during the backup process: [_1]' => 'Une erreur est survenue pendant la sauvegarde : [_1]',
	'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.' => 'Le répertoire temporaire doit être autorisé en écriture pour que la sauvegarde puisse fonctionner. Merci de vérifier la directive de configuration TempDir.',
	'Invalid backup_what: [_1]' => 'backup_what invalide : [_1]',
	'Invalid backup_archive_format: [_1]' => 'backup_archive_format invalide : [_1]',
	'Invalid limit_size: [_1]' => 'limit_size invalide : [_1]',
	'An error occurred during the restore process: [_1] Please check activity log for more details.' => 'Une erreur s\'est produite pendant la procédure de restauration : [_1] Veuillez consulter le journal d\'activité pour plus de détails.',
	'Make sure that you remove the files that you restored from the \'import\' folder, so that if/when you run the restore process again, those files will not be re-restored.' => 'Assurez-vous d\'avoir supprimé les fichiers que vous avez restaurés dans le répertoire \'import\', ainsi, si vous restaurez à nouveau d\'autres fichiers plus tard, les fichiers actuels ne seront pas restaurés une seconde fois.',

## lib/MT/DataAPI/Endpoint/v2/Blog.pm
	'Cannot create a blog under blog (ID:[_1]).' => 'Impossible de créer un blog sous le blog (ID:[_1]).',
	'Either parameter of "url" or "subdomain" is required.' => 'L\'un des paramètres "url" ou "subdomain" est requis.',
	'Site not found' => 'Site introuvable',
	'Website "[_1]" (ID:[_2]) was not deleted. You need to delete the blogs under the website first.' => 'Le site web "[_1]" (ID:[_2]) n\'a pas été supprimé. Vous devez d\'abord supprimer tous les blogs qu\'il contient.',

## lib/MT/DataAPI/Endpoint/v2/Category.pm
	'[_1] not found' => '[_1] est introuvable',
	'Loading object failed: [_1]' => 'Impossible de charger l\'objet : [_1]',

## lib/MT/DataAPI/Endpoint/v2/Entry.pm
	'You need to provide a parameter "password" if you are going to create new users for each user listed in your blog.' => 'Vous devez fournir un paramètre "password" si vous voulez créer de nouveaux utilisateurs pour chaque utilisateur présent dans votre blog.',
	'Invalid import_type: [_1]' => 'Paramètre "import_type" invalide : [_1]',
	'Invalid encoding: [_1]' => 'Paramètre "encoding" invalide [_1]',
	'Invalid convert_breaks: [_1]' => 'Paramètre "convert_breaks" invalide [_1]',
	'Invalid default_cat_id: [_1]' => 'Paramètre "default_cat_id" invalide [_1]',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Une erreur s\'est produite pendant le processus: [_1]. Merci de vérifier le fichier d\'import.',
	'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => 'Assurez vous d\'avoir bien enlevé les fichiers importés du répertoire \'import\', pour éviter une ré-importation des mêmes fichiers à l\'avenir.',
	'A resource "[_1]" is required.' => 'Une ressource "[_1]" est requise.',
	'Could not found archive template for [_1].' => 'Impossible de trouver un gabarit d\'archive pour [_1].',
	'Preview data not found.' => 'Données de prévisualisation introuvables.',

## lib/MT/DataAPI/Endpoint/v2/Folder.pm

## lib/MT/DataAPI/Endpoint/v2/Group.pm
	'Creating group failed: ExternalGroupManagement is enabled.' => 'La création du groupe a échoué : ExternalGroupManagement est activé.',
	'Cannot add member to inactive group.' => 'Impossible d\'ajouter un membre à un groupe inactif.',
	'Adding member to group failed: [_1]' => 'L\'ajout du membre au groupe a échoué : [_1]',
	'Removing member from group failed: [_1]' => 'Le membre n\'a pas pu être retiré du groupe : [_1]',
	'Group not found' => 'Groupe introuvable',
	'Member not found' => 'Membre introuvable',
	'A resource "member" is required.' => 'Une ressource "membre" est requise.',

## lib/MT/DataAPI/Endpoint/v2/Log.pm
	'Log message' => 'Message du journal',

## lib/MT/DataAPI/Endpoint/v2/Page.pm
	'\'folder\' parameter is invalid.' => 'Le paramètre \'folder\' est invalide.',

## lib/MT/DataAPI/Endpoint/v2/Permission.pm
	'Granting permission failed: [_1]' => 'L\'autorisation n\'a pas pu être attribuée : [_1]',
	'Role not found' => 'Rôle introuvable',
	'Revoking permission failed: [_1]' => 'L\'autorisation n\'a pas pu être révoquée : [_1]',
	'Association not found' => 'Association introuvable',

## lib/MT/DataAPI/Endpoint/v2/Plugin.pm
	'Plugin not found' => 'Plugin introuvable',

## lib/MT/DataAPI/Endpoint/v2/Role.pm

## lib/MT/DataAPI/Endpoint/v2/Search.pm

## lib/MT/DataAPI/Endpoint/v2/Tag.pm
	'Cannot delete private tag associated with objects in system scope.' => 'Impossible de supprimer un tag privé associé à des objets au niveau système.',
	'Cannot delete private tag in system scope.' => 'Impossible de supprimer un tag privé au niveau système.',
	'Tag not found' => 'Tag introuvable',

## lib/MT/DataAPI/Endpoint/v2/TemplateMap.pm
	'Template "[_1]" is not an archive template.' => 'Le gabarit "[_1]" n\'est pas un gabarit d\'archive.',

## lib/MT/DataAPI/Endpoint/v2/Template.pm
	'Template not found' => 'Gabarit introuvable',
	'Cannot delete [_1] template.' => 'Impossible de supprimer le gabarit [_1].',
	'Cannot publish [_1] template.' => 'Impossible de publier le gabarit [_1].',
	'A parameter "refresh_type" is invalid: [_1]' => 'Un paramètre "refresh_type" est invalide : [_1]',
	'Cannot clone [_1] template.' => 'Impossible de dupliquer un gabarit [_1]',
	'A resource "template" is required.' => 'Une ressource "template" est requise.',

## lib/MT/DataAPI/Endpoint/v2/Theme.pm
	'Cannot apply website theme to blog.' => 'Impossible d\'appliquer le thème du site au blog.',
	'Changing site theme failed: [_1]' => 'Impossible de changer le thème du site : [_1]',
	'Applying theme failed: [_1]' => 'Impossible d\'appliquer le thème du site : [_1]',
	'Cannot uninstall this theme.' => 'Impossible de désinstaller ce thème.',
	'Cannot uninstall theme because the theme is in use.' => 'Impossible de désinstaller ce thème car il est utilisé.',
	'theme_id may only contain letters, numbers, and the dash or underscore character. The theme_id must begin with a letter.' => 'theme_id ne peut contenir que des lettres, des chiffres et les caractères - et _.',
	'theme_version may only contain letters, numbers, and the dash or underscore character.' => 'theme_version ne peut contenir que des lettres, des chiffres et les caractères - et _.',
	'Cannot install new theme with existing (and protected) theme\'s basename: [_1]' => 'Impossible d\'installer un nouveau thème ayant le nom de base, protégé, d\'un thème existant : [_1]',
	'Export theme folder already exists \'[_1]\'. You can overwrite an existing theme with \'overwrite_yes=1\' parameter, or change the Basename.' => 'Le dossier d\'export du thème existe déjà \'[_1]\'. Vous pouvez l\'écraser en ajoutant le paramètre \'overwrite_yes=1\', ou changer le nom de base.',
	'Unknown archiver type: [_1]' => 'Type d\'archive inconnu : [_1]',

## lib/MT/DataAPI/Endpoint/v2/User.pm
	'The email address provided is not unique. Please enter your username by "name" parameter.' => 'L\'adresse e-mail fournie n\'est pas unique. Entrez votre nom d\'utilisateur via le paramètre "name".',
	'An email with a link to reset your password has been sent to your email address ([_1]).' => 'Un e-mail contenant un lien pour réinitialiser votre mot de passe a été envoyé à votre adresse e-mail ([_1]).',

## lib/MT/DataAPI/Endpoint/v2/Widget.pm
	'Widget not found' => 'Widget introuvable',
	'Removing Widget failed: [_1]' => 'Le widget n\'a pas pu être supprimé : [_1]',
	'Widgetset not found' => 'Ensemble de widgets introuvable',

## lib/MT/DataAPI/Endpoint/v2/WidgetSet.pm
	'A resource "widgetset" is required.' => 'Une ressource "widgetset" est requise.',
	'Removing Widgetset failed: [_1]' => 'L\'ensemble de widgets n\'a pas pu être supprimé : [_1]',

## lib/MT/DataAPI/Endpoint/v3/Asset.pm

## lib/MT/DataAPI/Endpoint/v4/Category.pm

## lib/MT/DataAPI/Endpoint/v4/CategorySet.pm

## lib/MT/DataAPI/Endpoint/v4/ContentData.pm

## lib/MT/DataAPI/Endpoint/v4/ContentField.pm
	'A parameter "content_fields" is required.' => 'Un paramètre "content_fields" est requis.',
	'A parameter "content_fields" is invalid.' => 'Un paramètre "content_fields" est invalide.',

## lib/MT/DataAPI/Endpoint/v4/ContentType.pm

## lib/MT/DataAPI/Endpoint/v4/Search.pm

## lib/MT/DataAPI/Resource.pm
	'Cannot parse "[_1]" as an ISO 8601 datetime' => 'Impossible d\'interprêter "[_1]" comme une date ISO 8601',

## lib/MT/DataAPI/Resource/v4/ContentData.pm

## lib/MT/DefaultTemplates.pm
	'Comment Form' => 'Formulaire de commentaire',
	'Navigation' => 'Navigation',
	'Blog Index' => 'Index du Blog',
	'Search Results for Content Data' => 'Résultats de recherche de données de contenu',
	'Archive Index' => 'Index d\'archive',
	'Stylesheet' => 'Feuille de style',
	'JavaScript' => 'JavaScript',
	'Feed - Recent Entries' => 'Flux - Notes récentes',
	'RSD' => 'RSD',
	'Monthly Entry Listing' => 'Liste des notes mensuelles',
	'Category Entry Listing' => 'Liste des notes catégorisées',
	'Dynamic Error' => 'Erreur dynamique',
	'Displays errors for dynamically-published templates.' => 'Affiche les erreurs pour les gabarits publiés dynamiquement.',
	'Popup Image' => 'Image dans une fenêtre surgissante',
	'Displays image when user clicks a popup-linked image.' => 'Affiche l\'image quand l\'utilisateur clique sur une image pop-up.',
	'Displays results of a search.' => 'Affiche les résultats d\'une recherche.',
	'Banner Header' => 'Bloc de l\'entête',
	'About This Page' => 'À propos de cette page',
	'Archive Widgets Group' => 'Archive du groupe des widgets',
	'Current Author Monthly Archives' => 'Archives mensuelles de l\'auteur courant',
	'Calendar' => 'Calendrier',
	'Creative Commons' => 'Creative Commons',
	'Home Page Widgets Group' => 'Page d\'accueil du groupe des widgets',
	'Monthly Archives Dropdown' => 'Liste déroulante des archives mensuelles',
	'Page Listing' => 'Liste des pages',
	'Powered By' => 'Motorisé par',
	'Syndication' => 'Syndication',
	'Technorati Search' => 'Recherche Technorati',
	'Date-Based Author Archives' => 'Archives des auteurs par dates',
	'Date-Based Category Archives' => 'Archives des catégories par dates',
	'OpenID Accepted' => 'OpenID accepté',
	'Entry Notify' => 'Notification de note',
	'User Lockout' => 'Verrouillage de l\'utilisateur',
	'IP Address Lockout' => 'Verrouillage de l\'adresse IP',

## lib/MT/Entry.pm
	'View [_1]' => 'Voir [_1]',
	'Entries from category: [_1]' => 'Notes de la catégorie : [_1]',
	'NONE' => 'Aucun fournisseur',
	'Draft' => 'Brouillon',
	'Published' => 'Publiée',
	'Reviewing' => 'En cours de relecture',
	'Scheduled' => 'Planifiée',
	'Junk' => 'Indésirable',
	'Unpublished (End)' => 'Dépubliées (Fin)',
	'Entries by [_1]' => 'Notes de [_1]',
	'Invalid arguments. They all need to be saved MT::Category objects.' => 'Arguments invalides. Tous doivent être des objects MT::Category sauvegardés.',
	'Invalid arguments. They all need to be saved MT::Asset objects.' => 'Arguments invalides. Tous doivent être des objects MT::Asset sauvegardés.',
	'Review' => 'Vérification',
	'Future' => 'Futur',
	'Spam' => 'Spam',
	'Accept Comments' => 'Accepter les commentaires',
	'Body' => 'Corps',
	'Extended' => 'Étendu',
	'Format' => 'Format',
	'Accept Trackbacks' => 'Accepter les TrackBacks',
	'Primary Category' => 'Catégorie primaire',
	'-' => '-',
	'Author ID' => 'ID de l\'auteur',
	'My Entries' => 'Mes notes',
	'Entries in This Website' => 'Notes de ce site web',
	'Published Entries' => 'Notes publiées',
	'Draft Entries' => 'Brouillons de notes',
	'Unpublished Entries' => 'Notes non publiées',
	'Scheduled Entries' => 'Notes en publication planifiée',

## lib/MT/FileMgr/DAV.pm
	'DAV connection failed: [_1]' => 'La connexion DAV a échoué : [_1]',
	'DAV open failed: [_1]' => 'L\'ouverture DAV a échoué : [_1]',
	'DAV get failed: [_1]' => 'La récupération DAV a échoué : [_1]',
	'DAV put failed: [_1]' => 'L\'envoi DAV a échoué : [_1]',
	'Deleting \'[_1]\' failed: [_2]' => 'La suppression de \'[_1]\' a échoué : [_2]',
	'Creating path \'[_1]\' failed: [_2]' => 'Création du chemin \'[_1]\' a échoué : [_2]',
	'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Le renommage de \'[_1]\' en \'[_2]\' a échoué : [_3]',

## lib/MT/FileMgr/FTP.pm

## lib/MT/FileMgr/Local.pm

## lib/MT/FileMgr/SFTP.pm
	'SFTP connection failed: [_1]' => 'La connexion SFTP a échoué : [_1]',
	'SFTP get failed: [_1]' => 'La récupération SFTP a échoué : [_1]',
	'SFTP put failed: [_1]' => 'L\'envoi SFTP a échoué : [_1]',

## lib/MT/Filter.pm
	'Invalid filter type [_1]:[_2]' => 'Type de filtre invalide [_1] : [_2]',
	'Invalid sort key [_1]:[_2]' => 'Clé de tri invalide [_1] : [_2]',
	'"editable_terms" and "editable_filters" cannot be specified at the same time.' => '"editable_terms" et "editable_filters" ne peuvent pas être spécifiés en même temps.',
	'System Object' => 'Objet système',

## lib/MT/Folder.pm

## lib/MT/Group.pm
	'Backing up [_1] records:' => 'Sauvegarde des enregistrements [_1] :',
	'[_1] records backed up.' => '[_1] enregistrements sauvegardés.',
	'Groups associated with author: [_1]' => 'Groupes associés avec l\'auteur : [_1]',
	'Inactive' => 'Inactif',
	'Members of group: [_1]' => 'Membres du groupe : [_1]',
	'__GROUP_MEMBER_COUNT' => 'Nombre de membres du groupe',
	'My Groups' => 'Mes groupes',
	'__COMMENT_COUNT' => 'Nombre de commentaires',
	'Email' => 'Adresse e-mail',
	'Active Groups' => 'Groupes actifs',
	'Disabled Groups' => 'Groupes inactifs',

## lib/MT/Image/GD.pm
	'Cannot load GD: [_1]' => 'Impossible de charger GD : [_1]',
	'Unsupported image file type: [_1]' => 'Type de fichier image non supporté : [_1]',
	'Reading file \'[_1]\' failed: [_2]' => 'La lecture du fichier \'[_1]\' a échoué : [_2]',
	'Reading image failed: [_1]' => 'Échec de la lecture de l\'image : [_1]',
	'Rotate (degrees: [_1]) is not supported' => 'La rotation ([_1] degrés) est non supportée',

## lib/MT/Image/ImageMagick.pm
	'Cannot load Image::Magick: [_1]' => 'Impossible de charger Image::Magick : [_1]',
	'Scaling to [_1]x[_2] failed: [_3]' => 'La mise à l\'échelle vers [_1]x[_2] a échoué : [_3]',
	'Cropping a [_1]x[_2] square at [_3],[_4] failed: [_5]' => 'Le retaillage d\'un carré de [_1]x[_2] à [_3],[_4] a échoué : [_5]',
	'Flip horizontal failed: [_1]' => 'La symétrie horizontale a échoué : [_1]',
	'Flip vertical failed: [_1]' => 'La symétrie verticale a échoué : [_1]',
	'Rotate (degrees: [_1]) failed: [_2]' => 'La rotation ([_1] degrés) a échoué : [_2]',
	'Converting image to [_1] failed: [_2]' => 'La conversion de l\'image vers [_1] a échoué : [_2]',
	'Outputting image failed: [_1]' => 'La génération de l\'image a échoué : [_1]',

## lib/MT/Image/Imager.pm
	'Cannot load Imager: [_1]' => 'Impossible de charger Imager : [_1]',

## lib/MT/Image/NetPBM.pm
	'Cannot load IPC::Run: [_1]' => 'Impossible de charger IPC::Run : [_1]',
	'Reading alpha channel of image failed: [_1]' => 'La lecture du canal alpha de l\'image a échoué : [_1]',
	'Cropping to [_1]x[_2] failed: [_3]' => 'Le retaillage vers [_1]x[_2] a échoué : [_3]',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'Votre chemin d\'accès vers les outils NetPBM est invalide sur votre machine.',

## lib/MT/Image.pm
	'Invalid Image Driver [_1]' => 'Pilote d\'image invalide [_1]',
	'Saving [_1] failed: Invalid image file format.' => 'Échec de la sauvegarde [_1] : format d\'image invalide.',
	'File size exceeds maximum allowed: [_1] > [_2]' => 'La taille du fichier dépasse le maximum autorisé : [_1] > [_2]',

## lib/MT/ImportExport.pm
	'No Blog' => 'Pas de blog',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'Vous devez fournir un mot de passe si vous allez créer de nouveaux utilisateurs pour chaque utilisateur listé dans votre blog.',
	'Need either ImportAs or ParentAuthor' => 'Soit ImportAs soit ParentAuthor est nécessaire',
	'Creating new user (\'[_1]\')...' => 'Création d\'un nouvel utilisateur (\'[_1]\')...',
	'Saving user failed: [_1]' => 'Échec de la sauvegarde de l\'utilisateur : [_1]',
	'Creating new category (\'[_1]\')...' => 'Création d\'une nouvelle catégorie (\'[_1]\')...',
	'Saving category failed: [_1]' => 'Échec de la sauvegarde de la catégorie : [_1]',
	'Invalid status value \'[_1]\'' => 'Valeur du statut invalide \'[_1]\'',
	'Invalid allow pings value \'[_1]\'' => 'Valeur du ping invalide \'[_1]\'',
	'Cannot find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.' => 'Impossible de trouver une note avec la date \'[_1]\'... abandon de ces commentaires, et passage à la note suivante.',
	'Importing into existing entry [_1] (\'[_2]\')' => 'Importation dans la note existante [_1] (\'[_2]\')',
	'Saving entry (\'[_1]\')...' => 'Enregistrement de la note (\'[_1]\')...',
	'ok (ID [_1])' => 'ok (ID [_1])',
	'Saving entry failed: [_1]' => 'Échec de la sauvegarde de la note : [_1]',
	'Export failed on entry \'[_1]\': [_2]' => 'Échec de l\'exportation sur la note \'[_1]\': [_2]',
	'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Format de date invalide \'[_1]\'. Il doit être \'MM/JJ/AAAA HH:MM:SS AM|PM\' (AM|PM est optionnel)',

## lib/MT/Import.pm
	'Cannot rewind' => 'Impossible de revenir en arrière',
	'Cannot open \'[_1]\': [_2]' => 'Impossible d\'ouvrir \'[_1]\' : [_2]',
	'No readable files could be found in your import directory [_1].' => 'Aucun fichier lisible n\'a été trouvé dans le répertoire d\'importation [_1].',
	'Importing entries from file \'[_1]\'' => 'Importation des notes du fichier \'[_1]\'',
	'File not found: [_1]' => 'Fichier introuvable : [_1]',
	'Could not resolve import format [_1]' => 'Impossible de déterminer le format du fichier d\'importation [_1]',
	'Movable Type' => 'Movable Type',
	'Another system (Movable Type format)' => 'Autre système (format Movable Type)',

## lib/MT/IPBanList.pm
	'IP Ban' => 'Interdiction IP',
	'IP Bans' => 'Interdictions IP',

## lib/MT/JunkFilter.pm
	'Action: Junked (score below threshold)' => 'Action : indésirable (score ci-dessous)',
	'Action: Published (default action)' => 'Action : publié (action par défaut)',
	'Junk Filter [_1] died with: [_2]' => 'Filtre indésirable [_1] mort avec : [_2]',
	'Unnamed Junk Filter' => 'Filtre indésirable sans nom',
	'Composite score: [_1]' => 'Score composite : [_1]',

## lib/MT/ListProperty.pm
	'Cannot initialize list property [_1].[_2].' => 'Impossible d\'initialiser la propriété de liste [_1].[_2].',
	'Failed to initialize auto list property [_1].[_2]: Cannot find definition of column [_3].' => 'Impossible d\'initialiser la propriété de liste automatique [_1].[_2] : la définition de la colonne [_3] est introuvable.',
	'Failed to initialize auto list property [_1].[_2]: unsupported column type.' => 'Impossible d\'initialiser la propriété de liste automatique [_1].[_2] : type de colonne non supporté.',
	'[_1] (id:[_2])' => '[_1] (ID:[_2])', # Translate - Case

## lib/MT/Lockout.pm
	'Cannot find author for id \'[_1]\'' => 'Impossible de trouver un auteur pour l\'id \'[_1]\'',
	'User was locked out. IP address: [_1], Username: [_2]' => 'Cet utilisateur a été verrouillé. Adresse IP : [_1], Nom d\'utilisateur : [_2]',
	'User Was Locked Out' => 'Cet utilisateur a été verrouillé',
	'Error sending mail: [_1]' => 'Erreur de l\'envoi de l\'e-mail : [_1]',
	'IP address was locked out. IP address: [_1], Username: [_2]' => 'Cette adresse IP a été verrouillée. Adresse IP : [_1], Nom d\'utilisateur : [_2]',
	'IP Address Was Locked Out' => 'Cette adresse IP a été verrouillée',
	'User has been unlocked. Username: [_1]' => 'Cet utilisateur a été déverrouillé. Nom d\'utilisateur : [_1]',

## lib/MT/Log.pm
	'Log messages' => 'Messages du journal',
	'Security' => 'Sécurité',
	'Warning' => 'Attention',
	'Information' => 'Information',
	'Debug' => 'Debug',
	'Security or error' => 'Sécurité ou erreur',
	'Security/error/warning' => 'Sécurité/erreur/mise en garde',
	'Not debug' => 'Non debug',
	'Debug/error' => 'Debug/erreur',
	'Showing only ID: [_1]' => 'Afficher seulement l\'ID : [_1]',
	'Page # [_1] not found.' => 'Page #[_1] introuvable.',
	'Entry # [_1] not found.' => 'Note #[_1] introuvable.',
	'Comment # [_1] not found.' => 'Commentaire #[_1] introuvable.',
	'TrackBacks' => 'TrackBacks',
	'TrackBack # [_1] not found.' => 'TrackBack #[_1] introuvable.',
	'blog' => 'blog',
	'website' => 'site web',
	'search' => 'rechercher',
	'author' => 'par auteurs',
	'ping' => 'ping',
	'theme' => 'thème',
	'folder' => 'répertoire',
	'plugin' => 'plugin',
	'page' => 'Page',
	'Message' => 'Message',
	'By' => 'Par',
	'Class' => 'Classe',
	'Level' => 'Niveau',
	'Metadata' => 'Métadonnées',
	'Logs on This Website' => 'Journaux sur ce site',
	'Show only errors' => 'Montrer uniquement les erreurs',

## lib/MT/Mail.pm
	'Unknown MailTransfer method \'[_1]\'' => 'Méthode de transfert d\'e-mail inconnue \'[_1]\'',
	'Username and password is required for SMTP authentication.' => 'Le nom utilisateur et le mot de passe sont requis pour l\'authentification SMTP.',
	'Error connecting to SMTP server [_1]:[_2]' => 'Erreur de connexion au serveur SMTP [_1] : [_2]',
	'Authentication failure: [_1]' => 'Échec de l\'authentification : [_1]',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'Vous n\'avez pas un chemin valide vers sendmail sur votre machine. Peut-être devriez-vous essayer en utilisant SMTP ?',
	'Exec of sendmail failed: [_1]' => 'Échec de l\'exécution de sendmail : [_1]',
	'Following required module(s) were not found: ([_1])' => 'Module(s) requis introuvable(s) : ([_1])',

## lib/MT/Notification.pm
	'Contacts' => 'Contacts',
	'Click to edit contact' => 'Cliquer pour modifier le contact',
	'Save Changes' => 'Enregistrer les modifications',
	'Cancel' => 'Annuler',

## lib/MT/ObjectAsset.pm
	'Asset Placement' => 'Gestion des éléments',

## lib/MT/ObjectCategory.pm
	'Category Placement' => 'Gestion des catégories',
	'Category Placements' => 'Gestion des catégories',

## lib/MT/ObjectDriver/Driver/DBD/SQLite.pm

## lib/MT/ObjectScore.pm
	'Object Score' => 'Score Objet',
	'Object Scores' => 'Scores Objet',

## lib/MT/ObjectTag.pm
	'Tag Placement' => 'Gestion des tags',
	'Tag Placements' => 'Gestion des tags',

## lib/MT/Page.pm
	'Pages in folder: [_1]' => 'Pages dans le dossier : [_1]',
	'Loading blog failed: [_1]' => 'Impossible de charger le blog : [_1]',
	'(root)' => '(racine)',
	'My Pages' => 'Mes pages',
	'Pages in This Website' => 'Pages dans ce site',
	'Published Pages' => 'Pages publiées',
	'Draft Pages' => 'Brouillons de pages',
	'Unpublished Pages' => 'Pages non publiées',
	'Scheduled Pages' => 'Pages planifiées pour publication',

## lib/MT/Permission.pm

## lib/MT/Placement.pm

## lib/MT/PluginData.pm
	'Plugin Data' => 'Données plugin',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1] : [_2][_3] de la règle [_4][_5]',
	'[_1]: [_2][_3] from test [_4]' => '[_1] : [_2][_3] du test [_4]',

## lib/MT/Plugin.pm
	'My Text Format' => 'Format de mon texte.',

## lib/MT.pm
	'Powered by [_1]' => 'Motorisé par [_1]',
	'Version [_1]' => 'Version [_1]',
	'https://www.movabletype.com/' => 'https://www.movabletype.com/',
	'Hello, world' => 'Bonjour tout le monde',
	'Hello, [_1]' => 'Bonjour, [_1]',
	'Message: [_1]' => 'Message : [_1]',
	'If it is present, the third argument to add_callback must be an object of type MT::Component or MT::Plugin' => 'S\'il est présent, le troisième argument de add_callback doit être un objet de type MT::Component ou MT::Plugin',
	'Fourth argument to add_callback must be a CODE reference.' => 'Le quatrième argument de add_callback doit être une référence CODE.',
	'Two plugins are in conflict' => 'Deux plugins sont en conflit',
	'Invalid priority level [_1] at add_callback' => 'Niveau de priorité invalide [_1] dans add_callback',
	'Internal callback' => 'Callback interne',
	'Unnamed plugin' => 'Plugin sans nom',
	'[_1] died with: [_2]' => '[_1] mort avec : [_2]',
	'Bad LocalLib config ([_1]): [_2]' => 'Mauvaise configuration LocalLib ([_1]) : [_2]',
	'Bad ObjectDriver config' => 'Mauvaise configuration ObjectDriver',
	'Bad CGIPath config' => 'Mauvaise configuration CGIPath',
	'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Fichier de configuration manquant. Auriez-vous oublié de déplacer mt-config.cgi-original vers mt-config.cgi ?',
	'Plugin error: [_1] [_2]' => 'Erreur de plugin : [_1] [_2]',
	'Loading template \'[_1]\' failed.' => 'Le chargement du template \'[_1]\' a échoué.',
	'Error while creating email: [_1]' => 'Erreur à la création de l\'e-mail : [_1]',
	'An error occurred: [_1]' => 'Une erreur est survenue : [_1]',
	'OpenID' => 'OpenID',
	'LiveJournal' => 'LiveJournal',
	'Vox' => 'Vox',
	'Google' => 'Google',
	'Yahoo!' => 'Yahoo!',
	'AIM' => 'AIM',
	'WordPress.com' => 'WordPress.com',
	'TypePad' => 'TypePad',
	'Yahoo! JAPAN' => 'Yahoo! Japon',
	'livedoor' => 'livedoor',
	'Hatena' => 'Hatena',
	'Movable Type default' => 'Valeur par défaut Movable Type',

## lib/MT/RebuildTrigger.pm
	'Restoring rebuild trigger for blog #[_1]...' => 'Restauration du déclencheur de republication pour le blog #[_1]...',
	'Restoring Rebuild Trigger for Content Type #[_1]...' => 'Restauration du déclencheur de republication pour le type de contenu #[_1]...',

## lib/MT/Revisable/Local.pm

## lib/MT/Revisable.pm
	'Bad RevisioningDriver config \'[_1]\': [_2]' => 'Mauvaise configuration du pilote de révision \'[_1]\' : [_2]',
	'Revision not found: [_1]' => 'Révision introuvable : [_1]',
	'There are not the same types of objects, expecting two [_1]' => 'Ce ne sont pas les mêmes types d\'objets, deux [_1] sont attendus',
	'Did not get two [_1]' => 'N\'a pas obtenu deux [_1]',
	'Unknown method [_1]' => 'Méthode [_1] inconnue',
	'Revision Number' => 'Numéro de révision',

## lib/MT/Role.pm
	'__ROLE_ACTIVE' => 'En usage',
	'__ROLE_INACTIVE' => 'Pas en usage',
	'Site Administrator' => 'Administrateur du site',
	'Can administer the site.' => 'Peut administrer le site',
	'Editor' => 'Éditeur',
	'Can upload files, edit all entries(categories), pages(folders), tags and publish the site.' => 'Peut télécharger des fichiers, éditer toutes les notes (catégories), pages (répertoires), tags et publier le site.',
	'Can create entries, edit their own entries, upload files and publish.' => 'Peut créer des notes, éditer ses propres notes, télécharger des fichiers et publier.',
	'Designer' => 'Designer',
	'Can edit, manage, and publish blog templates and themes.' => 'Peut éditer, gérer et publier les gabarits du blog et les thèmes.',
	'Webmaster' => 'Webmaster',
	'Can manage pages, upload files and publish site/child site templates.' => 'Peut gérer les pages, charger des fichiers et publier les gabarits du site / site enfant.',
	'Contributor' => 'Contributeur',
	'Can create entries, edit their own entries, and comment.' => 'Peut créer des notes, éditer ses propres notes et commenter.',
	'Content Designer' => 'Designer de contenu',
	'Can manage content types, content data and category sets.' => 'Peut gérer des types de contenu, des données de contenu et des groupes de catégories.',
	'__ROLE_STATUS' => 'Statut',

## lib/MT/Scorable.pm
	'Object must be saved first.' => 'L\'objet doit être d\'abord sauvegardé.',
	'Already scored for this object.' => 'Cet objet a déjà été noté.',
	'Could not set score to the object \'[_1]\'(ID: [_2])' => 'Impossible de stocker le score de l\'objet \'[_1]\' (ID:[_2])',

## lib/MT/Session.pm
	'Session' => 'Session',

## lib/MT/Tag.pm
	'Private' => 'Privé',
	'Not Private' => 'Public',
	'Tag must have a valid name' => 'Le tag doit avoir un nom valide',
	'This tag is referenced by others.' => 'Ce tag est référencé par d\'autres.',
	'Tags with Entries' => 'Tags avec notes',
	'Tags with Pages' => 'Tags avec pages',
	'Tags with Assets' => 'Tags avec éléments',

## lib/MT/TaskMgr.pm
	'Unable to secure a lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'Impossible d\'obtenir un verrou pour l\'exécution des tâches système. Vérifiez que le répertoire défini par TempDir ([_1]) est modifiable.',
	'Error during task \'[_1]\': [_2]' => 'Erreur pendant la tâche \'[_1]\' : [_2]',
	'Scheduled Tasks Update' => 'Mise à jour des tâches planifiées',
	'The following tasks were run:' => 'Les tâches suivantes ont été exécutées :',

## lib/MT/TBPing.pm

## lib/MT/Template/ContextHandlers.pm
	'All About Me' => 'Tout sur moi',
	'[_1]Publish[_2] your [_3] to see these changes take effect.' => '[_1]Publiez[_2] votre [_3] pour que ces changements soient appliqués.',
	'[_1]Publish[_2] your site to see these changes take effect.' => '[_1]Publiez[_2] votre site pour que ces changements soient appliqués.',
	'Actions' => 'Actions',
	q{The entered message is displayed as a input field hint.} => q{Le message renseigné est affiché comme aide du champ d'entrée.},
	'Is this field required?' => 'Ce champ est-il requis ?',
	q{Display Options} => q{Options d'affichage},
	q{Choose the display options for this content field in the listing screen.} => q{Choisissez les options d'affichage pour ce champ de contenu dans la liste affichée.},
	'Force' => 'Forcer',
	'Default' => 'Défaut',
	'https://www.movabletype.org/documentation/appendices/tags/%t.html' => 'https://www.movabletype.org/documentation/appendices/tags/%t.html',
	'You used an [_1] tag without a date context set up.' => 'Vous utilisez une balise [_1] hors d\'un contexte de date.',
	'Division by zero.' => 'Division par zéro.',
	'[_1] is not a hash.' => '[_1] n\'est pas un hash',
	'blog(s)' => 'blog(s)',
	'website(s)' => 'site(s) web',
	'No [_1] could be found.' => 'Pas trouvé de [_1].',
	'records' => 'enregistrements',
	'id attribute is required' => 'L\'attribut id est requis',
	'No template to include was specified' => 'Aucun gabarit spécifié pour inclusion',
	'Recursion attempt on [_1]: [_2]' => 'Tentative de récursion sur [_1] : [_2]',
	'Cannot find included template [_1] \'[_2]\'' => 'Impossible de trouver le gabarit inclus [_1] \'[_2]\'',
	'Error in [_1] [_2]: [_3]' => 'Erreur dans [_1] [_2] : [_3]',
	'File inclusion is disabled by "AllowFileInclude" config directive.' => 'L\'inclusion de fichier est désactivée par la directive de configuration "AllowFileInclude".',
	'Cannot find blog for id \'[_1]' => 'Impossible de trouver un blog ayant pour ID \'[_1]',
	'Cannot find included file \'[_1]\'' => 'Impossible de trouver le fichier inclus \'[_1]\'',
	'Error opening included file \'[_1]\': [_2]' => 'Erreur à l\'ouverture du fichier inclus \'[_1]\' : [_2]',
	'Recursion attempt on file: [_1]' => 'Tentative de récursion sur le fichier : [_1]',
	'Cannot load user.' => 'Impossible de charger l\'utilisateur.',
	'Cannot find template \'[_1]\'' => 'Impossible de trouver le gabarit \'[_1]\'',
	'Cannot find entry \'[_1]\'' => 'Impossible de trouver la note \'[_1]\'',
	'Unspecified archive template' => 'Gabarit d\'archive non spécifié',
	'Error in file template: [_1]' => 'Erreur dans fichier gabarit : [_1]',
	'Cannot load template' => 'Impossible de charger le gabarit',

## lib/MT/Template/Context.pm
	'The attribute exclude_blogs cannot take \'[_1]\' for a value.' => 'L\'attribut exclude_blogs ne peut pas prendre \'[_1]\' pour valeur.',
	'When the same blog IDs are simultaneously listed in the include_blogs and exclude_blogs attributes, those blogs are excluded.' => 'Lorsque les mêmes IDs de blog sont listés simultanément dans les attributs include_blogs et exclude_blogs, ces blogs sont exclus.',
	'You used an \'[_1]\' tag outside of the context of a author; Perhaps you mistakenly placed it outside of an \'MTAuthors\' container tag?' => 'Vous avez utilisé une balise \'[_1]\' en dehors d\'un contexte auteur. Peut-être l\'avez-vous placée par erreur en dehors d\'un bloc \'MTAuthors\' ?',
	'You used an \'[_1]\' tag outside of the context of an entry; Perhaps you mistakenly placed it outside of an \'MTEntries\' container tag?' => 'Vous avez utilisé une balise \'[_1]\' en dehors d\'un contexte de note. Peut-être l\'avez-vous placée par erreur en dehors d\'un bloc \'MTEntries\' ?',
	'You used an \'[_1]\' tag outside of the context of the website; Perhaps you mistakenly placed it outside of an \'MTWebsites\' container tag?' => 'Vous avez utilisé une balise \'[_1]\' en dehors d\'un contexte de site web. Peut-être l\'avez-vous placée par erreur en dehors d\'un bloc \'MTWebsites\' ?',
	'You used an \'[_1]\' tag inside of the context of a blog which has no parent website; Perhaps your blog record is broken?' => 'Vous avez utilisé une balise \'[_1]\' dans le  contexte d\'un blog sans site web parent. L\'enregistrement de ce blog est peut-être endommagé.',
	'You used an \'[_1]\' tag outside of the context of the blog; Perhaps you mistakenly placed it outside of an \'MTBlogs\' container tag?' => 'Vous avez utilisé une balise \'[_1]\' en dehors d\'un contexte de blog. Peut-être l\'avez-vous placée par erreur en dehors d\'un bloc \'MTBlogs\' ?',
	'You used an \'[_1]\' tag outside of the context of the site;' => 'Vous avez utilisé une balise \'[_1]\' en dehors d\'un contexte de site.', # Translate - New
	'You used an \'[_1]\' tag outside of the context of a comment; Perhaps you mistakenly placed it outside of an \'MTComments\' container tag?' => 'Vous avez utilisé une balise \'[_1]\' en dehors d\'un contexte de commentaire. Peut-être l\'avez-vous placée par erreur en dehors d\'un bloc \'MTComments\' ?',
	'You used an \'[_1]\' tag outside of the context of a ping; Perhaps you mistakenly placed it outside of an \'MTPings\' container tag?' => 'Vous avez utilisé une balise \'[_1]\' en dehors d\'un contexte de ping. Peut-être l\'avez-vous placée par erreur en dehors d\'un bloc \'MTPings\' ?',
	'You used an \'[_1]\' tag outside of the context of an asset; Perhaps you mistakenly placed it outside of an \'MTAssets\' container tag?' => 'Vous avez utilisé une balise \'[_1]\' en dehors d\'un contexte d\'élément. Peut-être l\'avez-vous placée par erreur en dehors d\'un bloc \'MTAssets\' ?',
	'You used an \'[_1]\' tag outside of the context of a page; Perhaps you mistakenly placed it outside of a \'MTPages\' container tag?' => 'Vous avez utilisé une balise \'[_1]\' en dehors d\'un contexte de page. Peut-être l\'avez-vous placée par erreur en dehors d\'un bloc \'MTPages\' ?',

## lib/MT/TemplateMap.pm
	'Archive Mapping' => 'Table de correspondance des archives',
	'Archive Mappings' => 'Tables de correspondance des archives',

## lib/MT/Template.pm
	'Template' => 'gabarit',
	'Template load error: [_1]' => 'Erreur de chargement de gabarit : [_1]',
	'Tried to load the template file from outside of the include path \'[_1]\'' => 'Tentative de chargement du gabarit en dehors du chemin d’inclusion \'[_1]\'',
	'Error reading file \'[_1]\': [_2]' => 'Erreur à la lecture du fichier \'[_1]\' : [_2]',
	'Publish error in template \'[_1]\': [_2]' => 'Erreur de publication dans le gabarit \'[_1]\': [_2]',
	'Content Type is required.' => 'Le type de contenu est requis.',
	'Template name must be unique within this [_1].' => 'Le nom du gabarit doit être unique dans ce [_1].',
	'You cannot use a [_1] extension for a linked file.' => 'Vous ne pouvez pas utiliser l\'extension [_1] pour un fichier joint.',
	'Opening linked file \'[_1]\' failed: [_2]' => 'L\'ouverture du fichier lié \'[_1]\' a échoué : [_2] ',
	'Index' => 'Index',
	'Category Archive' => 'Archive de catégorie',
	'Comment Listing' => 'Liste des commentaires',
	'Ping Listing' => 'Liste des pings',
	'Comment Preview' => 'Prévisualisation du commentaire',
	'Comment Error' => 'Erreur de commentaire',
	'Comment Pending' => 'Commentaire en attente',
	'Uploaded Image' => 'Image téléchargée',
	'Module' => 'Module',
	'Widget' => 'Widget',
	'Output File' => 'Fichier de sortie',
	'Template Text' => 'Texte de gabarit',
	'Rebuild with Indexes' => 'Republier avec les index',
	'Dynamicity' => 'Dynamicité',
	'Build Type' => 'Type de publication',
	'Interval' => 'Interval',

## lib/MT/Template/Tags/Archive.pm
	'Group iterator failed.' => 'Le répéteur de groupe a échoué.',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] est valide uniquement avec des archives quotidiennes, hebdomadaires ou mensuelles.',
	'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Vous avez utilisé une balise [_1] pour créer un lien vers des archives \'[_2]\' , mais ce type d\'archive n\'est pas publié.',
	'You used an [_1] tag outside of the proper context.' => 'Vous avez utilisé une balise [_1] en dehors de son contexte propre.',
	'Could not determine entry' => 'La note n\'a pu être déterminée',
	'Could not determine content' => 'Impossible de déterminer un contenu',

## lib/MT/Template/Tags/Asset.pm
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" doit être utilisé en combinaison avec l\'espace de nom.',
	'No such user \'[_1]\'' => 'L\'utilisateur \'[_1]\' n\'existe pas',
	'You have an error in your \'[_2]\' attribute: [_1]' => 'Vous avez une erreur dans votre attribut \'[_2]\' : [_1]',
	'[_1] must be a number.' => '[_1] doit être un nombre.',

## lib/MT/Template/Tags/Author.pm
	'The \'[_2]\' attribute will only accept an integer: [_1]' => 'L\'attribut \'[_2]\' n\'accepte qu\'un entier : [_1]',
	'You used an [_1] without a author context set up.' => 'Vous avez utilisé un [_1] sans avoir configuré de contexte d\'auteur.',

## lib/MT/Template/Tags/Blog.pm
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Valeur de l\'attribut "mode" inconnue : [_1]. Les valeurs valides sont "loop" et "context".',

## lib/MT/Template/Tags/Calendar.pm
	'Invalid weeks_start_with format: must be Sun|Mon|Tue|Wed|Thu|Fri|Sat' => 'Format weeks_start_with invalide : doit être Sun|Mon|Tue|Wed|Thu|Fri|Sat',
	'Invalid month format: must be YYYYMM' => 'Le format du mois est invalide : il doit être de la forme AAAAMM',
	'No such category \'[_1]\'' => 'La catégorie \'[_1]\' n\'existe pas',

## lib/MT/Template/Tags/Category.pm
	'MT[_1] must be used in a [_2] context' => 'MT[_1] doit être utilisé dans le contexte [_2]',
	'Cannot find package [_1]: [_2]' => 'Impossible de trouver le package [_1] : [_2]',
	'Error sorting [_2]: [_1]' => 'Erreur en classant [_2] : [_1]',
	'Cannot use sort_by and sort_method together in [_1]' => 'Impossible d\'utiliser sort_by et sort_method ensemble dans ce [_1]',
	'[_1] cannot be used without publishing [_2] archive.' => '[_1] ne peut pas être utilisé sans publier l\'archive [_2].',
	'[_1] used outside of [_2]' => '[_1] utilisé en dehors de [_2]',

## lib/MT/Template/Tags/ContentType.pm
	'Invalid tag_handler of [_1].' => 'tag_handler de [_1] invalide.',
	'Invalid field_value_handler of [_1].' => 'field_value_handler de [_1] invalide.',
	'Content Type was not found. Blog ID: [_1]' => 'Type de contenu introuvable. Blog ID : [_1]',

## lib/MT/Template/Tags/Entry.pm
	'You used <$MTEntryFlag$> without a flag.' => 'Vous utilisez <$MTEntryFlag$> sans drapeau.',
	'Could not create atom id for entry [_1]' => 'Impossible de créer un ID Atom pour cette note [_1]',

## lib/MT/Template/Tags/Misc.pm
	'Specified WidgetSet \'[_1]\' not found.' => 'Le groupe de widgets \'[_1]\' est introuvable.',

## lib/MT/Template/Tags/Tag.pm

## lib/MT/Template/Tags/Website.pm

## lib/MT/Theme/Category.pm
	'Failed to save category_order: [_1]' => 'Impossible de sauvegarder category_order : [_1]',
	'Failed to save folder_order: [_1]' => 'Impossible de sauvegarder folder_order : [_1]',
	'[_1] top level and [_2] sub categories.' => 'Niveau parent [_1] et catégories enfants [_2].',
	'[_1] top level and [_2] sub folders.' => 'Niveau parent [_1] et répertoires enfants [_2].',

## lib/MT/Theme/CategorySet.pm
	'[_1] category sets.' => '[_1] groupes de catégories.',

## lib/MT/Theme/ContentData.pm
	'Failed to find content type: [_1]' => 'Impossible de trouver le type de contenu : [_1]',
	'Invalid theme_data_import_handler of [_1].' => 'theme_data_import_handler de [_1] invalide.',
	'[_1] content data.' => '[_1] données de contenu.',

## lib/MT/Theme/ContentType.pm
	'Invalid theme_import_handler of [_1].' => 'theme_import_handler de [_1] invalide.',
	'[_1] content types.' => '[_1] types de contenu.',
	'some content field in this theme has invalid type.' => 'un champ de contenu dans ce thème a un type invalide.',
	'some content type in this theme have been installed already.' => 'un type de contenu dans ce thème est déjà installé.',

## lib/MT/Theme/Element.pm
	'Component \'[_1]\' is not found.' => 'Le composant \'[_1]\' est introuvable.',
	'Internal error: the importer is not found.' => 'Erreur interne : l\'importateur est introuvable.',
	'Compatibility error occurred while applying \'[_1]\': [_2].' => 'Une erreur de compatibilité est survenue en appliquant \'[_1]\' : [_2].',
	'An Error occurred while applying \'[_1]\': [_2].' => 'Une erreur est survenue en appliquant \'[_1]\' : [_2].',
	'Fatal error occurred while applying \'[_1]\': [_2].' => 'Une erreur fatale est survenue en appliquant \'[_1]\' : [_2].',
	'Importer for \'[_1]\' is too old.' => 'L\'importateur pour \'[_1]\' est trop vieux.',
	'Theme element \'[_1]\' is too old for this environment.' => 'L\'élément de thème \'[_1]\' est trop vieux pour cet environnement.',

## lib/MT/Theme/Entry.pm
	'[_1] pages' => 'Pages [_1]',

## lib/MT/Theme.pm
	'Failed to load theme [_1].' => 'Échec lors du chargement du thème [_1].',
	'A fatal error occurred while applying element [_1]: [_2].' => 'Une erreur fatale est survenue lors de l\'application de l\'élément [_1] : [_2].',
	'An error occurred while applying element [_1]: [_2].' => 'Une erreur est survenue lors de l\'application de l\'élément [_1] : [_2].',
	'Failed to copy file [_1]:[_2]' => 'Échec de la copie du fichier [_1] : [_2]',
	'Component \'[_1]\' version [_2] or greater is needed to use this theme, but is not installed.' => 'Le composant \'[_1]\' version [_2] ou supérieur est requis pour utiliser ce thème mais n\'est pas installé.',
	'Component \'[_1]\' version [_2] or greater is needed to use this theme, but the installed version is [_3].' => 'Le composant \'[_1]\' version [_2] ou supérieur est requis pour utiliser ce thème mais la version installée est [_3].',
	'Element \'[_1]\' cannot be applied because [_2]' => 'L\'élément \'[_1] ne peut pas être appliqué à cause de [_2]',
	'There was an error scaling image [_1].' => 'Il y a eu une erreur lors du redimensionnement de l\'image [_1].',
	'There was an error converting image [_1].' => 'Il y a eu une erreur lors de la conversion de l\'image [_1].',
	'There was an error creating thumbnail file [_1].' => 'Il y a eu une erreur lors de la création de la miniature de l\'image [_1].',
	'Default Prefs' => 'Préférences par défaut',
	'Default Pages' => 'Pages par défaut',
	'Template Set' => 'Groupe de gabarits',
	'Default Content Data' => 'Donnée de contenu par défaut',
	'Static Files' => 'Fichiers statiques',

## lib/MT/Theme/Pref.pm
	'this element cannot apply for non blog object.' => 'cet élément ne peut pas s\'appliquer sur un objet autre que blog.',
	'Failed to save blog object: [_1]' => 'Échec de la sauvegarde de l\'objet : [_1]',
	'default settings for [_1]' => 'paramètres par défaut pour [_1]',
	'default settings' => 'paramètres par défaut',

## lib/MT/Theme/TemplateSet.pm
	'A template set containing [quant,_1,template,templates], [quant,_2,widget,widgets], and [quant,_3,widget set,widget sets].' => 'Un ensemble de gabarits contenant [quant,_1,gabarit,gabarits], [quant,_2,widget,widgets], and [quant,_3,ensemble de widgets set,ensembles de widgets].',
	'Widget Sets' => 'Groupes de widgets',
	'Failed to make templates directory: [_1]' => 'Échec de la création des gabarits de répertoires : [_1]',
	'Failed to publish template file: [_1]' => 'Échec de la publication du fichier de gabarit : [_1]',
	'exported_template set' => 'Groupe exported_template',

## lib/MT/TheSchwartz/Error.pm
	'Job Error' => 'Erreur de tâche',

## lib/MT/TheSchwartz/ExitStatus.pm
	'Job Exit Status' => 'Statut de fin de tâche',

## lib/MT/TheSchwartz/FuncMap.pm
	'Job Function' => 'Fonction de tâche',

## lib/MT/TheSchwartz/Job.pm
	'Job' => 'Tâche',

## lib/MT/Trackback.pm

## lib/MT/Upgrade/Core.pm
	'Upgrading asset path information...' => 'Mise à jour du chemin des éléments...',
	'Creating initial user records...' => 'Création des enregistrements utilisateurs initiaux...',
	'Error saving record: [_1].' => 'Erreur d\'enregistrement des informations : [_1].',
	'Error creating role record: [_1].' => 'Erreur lors de la création de l\'enregistrement du rôle : [_1]',
	'Creating new template: \'[_1]\'.' => 'Création d\'un nouveau gabarit : \'[_1]\'.',
	'Mapping templates to blog archive types...' => 'Mapping des gabarits vers les archives des blogs...',
	'Expiring cached MT News widget...' => 'Invalidation du cache du widget MT News...',
	'Error loading class: [_1].' => 'Erreur de chargement de la classe : [_1].',
	'Assigning custom dynamic template settings...' => 'Attribution des paramètres spécifiques de gabarit dynamique...',
	'Assigning user types...' => 'Attribution des types d\'utilisateurs...',
	'Assigning category parent fields...' => 'Attribution des champs parents de la catégorie...',
	'Assigning template build dynamic settings...' => 'Attribution des paramètres de construction dynamique de gabarit...',
	'Assigning visible status for comments...' => 'Attribution du statut visible pour les commentaires...',
	'Assigning visible status for TrackBacks...' => 'Attribution du statut visible des TrackBacks...',

## lib/MT/Upgrade.pm
	'Invalid upgrade function: [_1].' => 'Fonction de mise à jour invalide : [_1].',
	'Error loading class [_1].' => 'Erreur en chargeant la classe [_1].',
	'Upgrading table for [_1] records...' => 'Mise à jour des tables pour les enregistrements [_1]...',
	'Upgrading database from version [_1].' => 'Mise à jour de la base de données depuis la version [_1].',
	'Database has been upgraded to version [_1].' => 'La base de données a été mise à jour en version [_1].',
	'User \'[_1]\' upgraded database to version [_2]' => 'L\'utilisateur \'[_1]\' a mis à jour la base de données en version [_2]',
	'Plugin \'[_1]\' upgraded successfully to version [_2] (schema version [_3]).' => 'Plugin \'[_1]\' mis à jour avec succès en version [_2] (schéma version [_3]).',
	'User \'[_1]\' upgraded plugin \'[_2]\' to version [_3] (schema version [_4]).' => 'L\'utilisateur \'[_1]\' a mis à jour le plugin \'[_2]\' en version [_3] (schéma version [_4]).',
	'Plugin \'[_1]\' installed successfully.' => 'Le plugin \'[_1]\' a été installé correctement.',
	'User \'[_1]\' installed plugin \'[_2]\', version [_3] (schema version [_4]).' => 'L\'utilisateur \'[_1]\' a installé le plugin \'[_2]\', version [_3] (schéma version [_4]).',
	'Error saving [_1] record # [_3]: [_2]...' => 'Erreur en sauvegardant l\'enregistrement [_1] # [_3] : [_2]...',

## lib/MT/Upgrade/v1.pm
	'Creating template maps...' => 'Création des tables de correspondances de gabarits...',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'Lien du gabarit [_1] vers [_2] ([_3]).',
	'Mapping template ID [_1] to [_2].' => 'Lien du gabarit [_1] vers [_2].',
	'Creating entry category placements...' => 'Création des placements des catégories des notes...',

## lib/MT/Upgrade/v2.pm
	'Updating category placements...' => 'Modification des placements de catégories...',
	'Assigning comment/moderation settings...' => 'Mise en place des paramètres commentaires/modération ...',

## lib/MT/Upgrade/v3.pm
	'Custom ([_1])' => '([_1]) personnalisé',
	'This role was generated by Movable Type upon upgrade.' => 'Ce rôle a été généré par Movable Type lors d\'une mise à jour.',
	'Removing Dynamic Site Bootstrapper index template...' => 'Suppression du gabarit index "Dynamic Site Bootstrapper"',
	'Creating configuration record.' => 'Création des infos de configuration.',
	'Setting your permissions to administrator.' => 'Spécification des autorisations d\'administrateur.',
	'Setting blog basename limits...' => 'Spécification des limites des noms de base du blog...',
	'Setting default blog file extension...' => 'Ajout de l\'extension de fichier par défaut du blog...',
	'Updating comment status flags...' => 'Modification des statuts des commentaires...',
	'Updating commenter records...' => 'Modification des données des auteurs de commentaire...',
	'Assigning blog administration permissions...' => 'Ajout des autorisations d\'administration du blog...',
	'Setting blog allow pings status...' => 'Mise en place du statut d\'autorisation des pings...',
	'Updating blog comment email requirements...' => 'Mise à jour des prérequis des e-mails pour les commentaires du blog...',
	'Assigning entry basenames for old entries...' => 'Ajout des racines des notes pour les anciennes notes...',
	'Updating user web services passwords...' => 'Mise à jour des mots de passe des services web d\'utilisateur...',
	'Updating blog old archive link status...' => 'Modification de l\'ancien statut d\'archive du blog...',
	'Updating entry week numbers...' => 'Mise à jour des numéros des semaines de la note...',
	'Updating user permissions for editing tags...' => 'Modification des autorisations des utilisateurs pour modifier les balises...',
	'Setting new entry defaults for blogs...' => 'Réglage des valeurs par défaut des nouvelles notes pour les blogs...',
	'Migrating any "tag" categories to new tags...' => 'Migration des catégories de "tag" vers de nouveaux tags...',
	'Assigning basename for categories...' => 'Attribution de noms de base aux catégories...',
	'Assigning user status...' => 'Attribution du statut utilisateur...',
	'Migrating permissions to roles...' => 'Migration des autorisations vers les rôles...',

## lib/MT/Upgrade/v4.pm
	'Comment Posted' => 'Commentaire envoyé',
	'Confirmation...' => 'Confirmation...',
	'Your comment has been posted!' => 'Votre commentaire a été envoyé !',
	q{Thank you for commenting.} => q{Merci d'avoir commenté.},
	'Your comment has been received and held for review by a blog administrator.' => 'Votre commentaire a été reçu et est en attente de validation par un administrateur du blog.',
	q{Comment Submission Error} => q{Erreur d'envoi du commentaire},
	q{Your comment submission failed for the following reasons:} => q{L'envoi de votre commentaire a échoué pour les raisons suivantes :},
	'[_1]: [_2]' => '[_1] : [_2]',
	q{Return to the <a href="[_1]">original entry</a>.} => q{Retourner à la <a href="[_1]">note d'origine</a>.},
	'Migrating permission records to new structure...' => 'Migration des données d\'autorisation vers la nouvelle structure...',
	'Migrating role records to new structure...' => 'Migration des données de rôle vers la nouvelle structure...',
	'Migrating system level permissions to new structure...' => 'Migration des autorisations pour tout le système vers la nouvelle structure...',
	'Updating system search template records...' => 'Mise à jour des données du gabarit de recherche du système...',
	'Renaming PHP plugin file names...' => 'Renommage des noms de fichier des plugins php...',
	'Error renaming PHP files. Please check the Activity Log.' => 'Erreur pendant le renommage des fichiers PHP. Merci de vérifier le journal d\'activité.',
	'Cannot rename in [_1]: [_2].' => 'Impossible de renommer dans [_1] : [_2].',
	'Migrating Nofollow plugin settings...' => 'Migration des paramètres du plugin Nofollow...',
	'Comment Response' => 'Réponse au commentaire',
	'Removing unnecessary indexes...' => 'Suppression des index non nécessaires...',
	'Moving metadata storage for categories...' => 'Déplacement du stockage des métadonnées pour les catégories en cours...',
	'Upgrading metadata storage for [_1]' => 'Mise à jour du stockage des métadonnées pour [_1]',
	'Assigning entry comment and TrackBack counts...' => 'Attribution des nombres de commentaires et TrackBacks...',
	'Updating password recover email template...' => 'Template de réinitialisation du mot de passe en cours de mise à jour...',
	'Assigning junk status for comments...' => 'Attribution du statut spam pour les commentaires...',
	'Assigning junk status for TrackBacks...' => 'Attribution du statut spam pour les TrackBacks...',
	'Populating authored and published dates for entries...' => 'Mise en place des dates de création et de publication des notes...',
	'Updating widget template records...' => 'Mise à jour des données des gabarits de widget...',
	'Classifying category records...' => 'Classement des données des catégories...',
	'Classifying entry records...' => 'Classement des données des notes...',
	'Merging comment system templates...' => 'Assemblage des gabarits du système de commentaire...',
	'Populating default file template for templatemaps...' => 'Mise en place du fichier gabarit par défaut pour les tables de correspondances de gabarits...',
	'Removing unused template maps...' => 'Suppression des tables de correspondances de gabarits non utilisées...',
	'Assigning user authentication type...' => 'Attribution du type d\'authentification utilisateur...',
	'Adding new feature widget to dashboard...' => 'Ajout du nouveau widget au tableau de bord...',
	'Moving OpenID usernames to external_id fields...' => 'Déplacement des identifiants OpenID vers les champs external_id...',
	'Assigning blog template set...' => 'Attribution du groupe de gabarits de blogs...',
	'Assigning blog page layout...' => 'Attribution de la mise en page du blog...',
	'Assigning author basename...' => 'Attribution du nom de base de l\'auteur...',
	'Assigning embedded flag to asset placements...' => 'Attribution des drapeaux embarqués vers la gestion d\'éléments...',
	'Updating template build types...' => 'Mise à jour des types de construction de gabarits...',
	'Replacing file formats to use CategoryLabel tag...' => 'Remplacement des formats de fichiers pour utiliser la balise CategoryLabel...',

## lib/MT/Upgrade/v5.pm
	'Populating generic website for current blogs...' => 'Génération d\'un site web générique pour les blogs actuels...',
	'Generic Website' => 'Site web générique',
	'Migrating [_1]([_2]).' => 'Migration [_1] ([_2])',
	'Granting new role to system administrator...' => 'Élévation du nouveau rôle vers administrateur système...',
	'Updating existing role name...' => 'Mise à jour du nom de rôle existant...',
	'_WEBMASTER_MT4' => 'Webmaster',
	'Webmaster (MT4)' => 'Webmaster (MT4)',
	'Populating new role for website...' => 'Génération du nouveau rôle pour le site web...',
	'Website Administrator' => 'Administrateur du site web',
	'Can administer the website.' => 'Peut administrer le site web.',
	'Can manage pages, Upload files and publish blog templates.' => 'Peut gérer les pages, télécharger des fichiers et publiuer les gabarits du blog.',
	'Designer (MT4)' => 'Designer (MT4)',
	'Populating new role for theme...' => 'Génération du nouveau rôle pour le thème...',
	'Can edit, manage and publish blog templates and themes.' => 'Peut modifier, gérer et publier les gabarits et thèmes du blog.',
	'Assigning new system privilege for system administrator...' => 'Assignation des nouveaux privilèges système pour l\'administrateur système...',
	'Assigning to  [_1]...' => 'Assignation pour [_1]...',
	'Migrating mtview.php to MT5 style...' => 'Migration de mtview.php vers le style MT5...',
	'Migrating DefaultSiteURL/DefaultSiteRoot to website...' => 'Migration de DefaultSiteURL/DefaultSiteRoot vers site web...',
	'New user\'s website' => 'Site web du nouvel utilisateur',
	'Migrating existing [quant,_1,blog,blogs] into websites and their children...' => 'Migration de [quant,_1,blog,blogs] en sites web et leurs enfants...',
	'Error loading role: [_1].' => 'Erreur lors du chargement d\'un rôle : [_1].',
	'New WebSite [_1]' => 'Nouveau site web [_1]',
	'An error occurred during generating a website upon upgrade: [_1]' => 'Une erreur est survenue lors de la génération d\'un site web pendant la mise à jour : [_1]',
	'Generated a website [_1]' => 'Site web généré [_1]',
	'An error occurred during migrating a blog\'s site_url: [_1]' => 'Une erreur est survenue pendant la migration de l\'URL de site d\'un blog : [_1]',
	'Moved blog [_1] ([_2]) under website [_3]' => 'A déplacé le blog [_1] ([_2]) sous le site web [_3]',
	'Removing Technorati update-ping service from [_1] (ID:[_2]).' => 'Retrait du service de mise à jour ping Technorati de [_1] (ID:[_2]).',
	'Recovering type of author...' => 'Récupération du type d\'auteur...',
	'Classifying blogs...' => 'Classification des blogs...',
	'Rebuilding permissions...' => 'Republication des permissions...',
	'Assigning ID of author for entries...' => 'Assignation de l\'ID d\'auteur pour les notes...',
	'Removing widget from dashboard...' => 'Retrait du widget du tableau de bord...',
	'Ordering Categories and Folders of Blogs...' => 'Tri des catégories et dossiers de blogs...',
	'Ordering Folders of Websites...' => 'Tri des dossiers de sites...',
	'Setting the \'created by\' ID for any user for whom this field is not defined...' => 'Création de l\'ID \'created by\' pour chaque utilisateur pour qui ce champ est indéfini...',
	'Assigning a language to each blog to help choose appropriate display format for dates...' => 'Assignation de la langue pour chaque blog afin de fciliter le choix du format des dates...',
	'Adding notification dashboard widget...' => 'Ajout du widget de notification au tableau de bord...',

## lib/MT/Upgrade/v6.pm
	'Fixing TheSchwartz::Error table...' => 'Réparation de la table TheSchwartz::Error...',
	'Migrating current blog to a website...' => 'Migration du blog courant dans un site web...',
	'Migrating the record for recently accessed blogs...' => 'Migration des enregistrements des blogs récemments vus...',
	'Adding Website Administrator role...' => 'Ajout du rôle Administrateur du blog...',
	'Adding "Site stats" dashboard widget...' => 'Ajout du widget "Statistiques du site" au tableau de bord...',
	'Reordering dashboard widgets...' => 'Réarrangement des widgets du tableau de bord...',
	'Rebuilding permission records...' => 'Reconstruction des autorisations...',

## lib/MT/Upgrade/v7.pm
	'Create new role: [_1]...' => 'Créer un nouveau rôle : [_1]...',
	'change [_1] to [_2]' => 'changer [_1] en [_2]',
	'Assign a Site Administrator Role for Manage Website...' => 'Assigner un rôle d\'Administrateur de site pour gérer un site...',
	'Assign a Site Administrator Role for Manage Website with Blogs...' => 'Assigner un rôle d\'Administrateur de site pour gérer un site avec blogs...',
	'add administer_site permission for Blog Administrator...' => 'ajouter une permission administer_site pour Administrateur de blog...',
	'Changing the Child Site Administrator role to the Site Administrator role.' => 'Changement du rôle Administrateur de site enfant en Administrateur de site.',
	'Child Site Administrator' => 'Administrateur de site enfant',
	'Rebuilding object categories...' => 'Reconstruction des catégories d\'objets...',
	'Error removing records: [_1]' => 'Erreur lors de la suppression des enregistrements : [_1]',
	'Error saving record: [_1]' => 'Erreur lors de la suppression de l\'enregistrement : [_1]',
	'Rebuilding object tags...' => 'Reconstruction des tags d\'objets...',
	'Rebuilding object assets...' => 'Reconstruction des éléments d\'objets...',
	'Rebuilding content field permissions...' => 'Reconstruction des permissions de champs de contenu...',
	'Create a new role for creating a child site...' => 'Création d\'un nouveau rôle pour la création de site enfant...',
	'Migrating create child site permissions...' => 'Migration des autorisations de créer un site enfant...',
	'Migrating MultiBlog settings...' => 'Migration des paramètres MultiBlog...',
	'Migrating fields column of MT::ContentType...' => 'Migration de la colonne fields de MT::ContentType...',
	'Migrating data column of MT::ContentData...' => 'Migration de la colonne data de MT::ContentData...',
	'Rebuilding MT::ContentFieldIndex of number field...' => 'Reconstruction de MT::ContentFieldIndex du champ number',
	'Error removing record (ID:[_1]): [_2].' => 'Erreur lors de la suppression de l\'enregistrement (ID:[_1]) : [_2].',
	'Error saving record (ID:[_1]): [_2].' => 'Erreur lors de la sauvegarde de l\'enregistrement (ID:[_1]) : [_2].',
	'Rebuilding MT::ContentFieldIndex of multi_line_text field...' => 'Reconstruction de MT::ContentFieldIndex du champ multi_line_text...',
	'Rebuilding MT::ContentFieldIndex of tables field...' => 'Reconstruction de MT::ContentFieldIndex du champ tables...',
	'Rebuilding MT::ContentFieldIndex of embedded_text field...' => 'Reconstruction de MT::ContentFieldIndex du champ embedded_text...',
	'Rebuilding MT::ContentFieldIndex of url field...' => 'Reconstruction de MT::ContentFieldIndex du champ url...',
	'Rebuilding MT::ContentFieldIndex of single_line_text field...' => 'Reconstruction de MT::ContentFieldIndex du champ single_line_text...',
	'Rebuilding MT::Permission records (remove edit_categories)...' => 'Reconstruction de MT::Permission records (suppression de edit_categories)...',
	'Cleaning up content field indexes...' => 'Nettoyage des index de champs de contenu...',
	'Cleaning up objectasset records for content data...' => 'Nettoyage des enregistrements objectasset des données de contenu...',
	'Cleaning up objectcategory records for content data...' => 'Nettoyage des enregistrements objectcategory des données de contenu...',
	'Cleaning up objecttag records for content data...' => 'Nettoyage des enregistrements objecttag des données de contenu...',
	'Truncating values of value_varchar column...' => 'Tronquage des valeurs de la colonne value_varchar...',
	'Migrating Max Length option of Single Line Text fields...' => 'Migration de l\'option de longueur maximale pour les champs de texte sur une ligne...',
	'Reset default dashboard widgets...' => 'Réinitialisation des widgets du tableau de bord...',
	'Rebuilding Content Type count of Category Sets...' => 'Reconstruction du compteur de type de contenu pour les ensembles de catégories...', # Translate - New
	'Adding site list dashboard widget for mobile...' => 'Ajout du widget de liste de site pour mobiles...', # Translate - New

## lib/MT/Util/Archive.pm
	'Type must be specified' => 'Le type doit être spécifié',
	'Registry could not be loaded' => 'Le registre n\'a pu être chargé',

## lib/MT/Util/Archive/Tgz.pm
	'Type must be tgz.' => 'Le type doit être tgz.',
	'Could not read from filehandle.' => 'Impossible de lire le fichier.',
	'File [_1] is not a tgz file.' => 'Le fichier [_1] n\'est pas un fichier tgz.',
	'File [_1] exists; could not overwrite.' => 'Le fichier [_1] existe, impossible de l\'écraser.',
	'[_1] in the archive is not a regular file' => '[_1] dans l\'archive n\'est pas un fichier valide', # Translate - New
	'[_1] in the archive is an absolute path' => '[_1] dans l\'archive est un chemin absolu', # Translate - New
	'[_1] in the archive contains ..' => '[_1] dans l\'archive contient ', # Translate - New
	'Cannot extract from the object' => 'Impossible d\'extraire l\'objet',
	'Cannot write to the object' => 'Impossible d\'écrire l\'objet',
	'Both data and file name must be specified.' => 'Les données et le fichier doivent être spécifiés.',

## lib/MT/Util/Archive/Zip.pm
	'Type must be zip' => 'Le type doit être zip',
	'File [_1] is not a zip file.' => 'Le fichier [_1] n\'est pas un fichier zip.',

## lib/MT/Util/Captcha.pm
	'Movable Type default CAPTCHA provider requires Image::Magick.' => 'Le fournisseur de CAPTCHA par défaut de Movable Type nécessite Image::Magick.',
	'You need to configure CaptchaSourceImageBase.' => 'Vous devez configurer CaptchaSourceImagebase.',
	'Type the characters you see in the picture above.' => 'Saisissez les caractères que vous voyez dans l\'image ci-dessus.',
	'Image creation failed.' => 'Création de l\'image échoué.',
	'Image error: [_1]' => 'Erreur image : [_1]',

## lib/MT/Util/Log.pm
	'Unknown Logger Level: [_1]' => 'Niveau de journalisation inconnu : [_1]',
	'Invalid Log module' => 'Module de journalisation invalide',
	'Cannot load Log module: [_1]' => 'Impossible de charger le module de journalisation : [_1]',

## lib/MT/Util.pm
	'moments from now' => 'maintenant',
	'[quant,_1,hour,hours] from now' => 'dans [quant,_1,heure,heures]',
	'[quant,_1,minute,minutes] from now' => 'dans [quant,_1,minute,minutes]',
	'[quant,_1,day,days] from now' => 'dans [quant,_1,jour,jours]',
	'less than 1 minute from now' => 'moins d\'une minute à partir de maintenant',
	'less than 1 minute ago' => 'il y a moins d\'une minute',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => 'dans [quant,_1,heure,heures], [quant,_2,minute,minutes]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => 'il y a [quant,_1,heure,heures], [quant,_2,minute,minutes]',
	'[quant,_1,day,days], [quant,_2,hour,hours] from now' => 'dans [quant,_1,jour,jours], [quant,_2,heure,heures]',
	'[quant,_1,day,days], [quant,_2,hour,hours] ago' => 'il y a [quant,_1,jour,jours], [quant,_2,heure,heures]',
	'[quant,_1,second,seconds] from now' => 'dans [quant,_1,seconde,secondes]',
	'[quant,_1,second,seconds]' => '[quant,_1,seconde,secondes]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => 'dans [quant,_1,minute,minutes], [quant,_2,seconde,secondes]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,minute,minutes], [quant,_2,seconde,secondes]',
	'[quant,_1,minute,minutes]' => '[quant,_1,minute,minutes]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,heure,heures], [quant,_2,minute,minutes]',
	'[quant,_1,hour,hours]' => '[quant,_1,heure,heures]',
	'[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,jour,jours], [quant,_2,heure,heures]',
	'[quant,_1,day,days]' => '[quant,_1,jour,jours]',
	'Invalid domain: \'[_1]\'' => 'Domaine invalide: \'[_1]\'',

## lib/MT/Util/YAML.pm
	'Invalid YAML module' => 'Module YAML invalide',
	'Cannot load YAML module: [_1]' => 'Impossible de charger le module YAML : [_1]',

## lib/MT/Util/YAML/Syck.pm

## lib/MT/Util/YAML/Tiny.pm

## lib/MT/WeblogPublisher.pm
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Le même fichier d\'archive existe déjà. Vous devez changer le nom de base ou le chemin de l\'archive. ([_1])',
	'Blog, BlogID or Template param must be specified.' => 'Les paramètres Blog, BlogID ou Template doivent être spécifiés.',
	'Template \'[_1]\' does not have an Output File.' => 'Le gabarit \'[_1]\' n\'a pas de fichier de sortie.',
	'An error occurred while publishing scheduled entries: [_1]' => 'Une erreur s\'est produite en publiant les notes planifiées : [_1]',
	'An error occurred while unpublishing past entries: [_1]' => 'Une erreur s\'est produite lors de la dépublication de notes passées : [_1]',

## lib/MT/Website.pm
	'First Website' => 'Premier site web',
	'Child Site Count' => 'Nombre de sites enfants',

## lib/MT/Worker/Publish.pm
	'Background Publishing Done' => 'Publication en tâche de fond terminée',
	'Published: [_1]' => 'Publié : [_1]',
	'Error rebuilding file [_1]:[_2]' => 'Erreur lors de la reconstruction du fichier [_1] : [_2]',
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- configuration terminée ([quant,_1,fichier,fichiers] en [_2] secondes)',

## lib/MT/Worker/Sync.pm
	"Error during rsync of files in [_1]:\n" => "Erreur lors de la synchronisation rsync des fichiers dans [_1] :
",
	'Done Synchronizing Files' => 'Synchronisation des fichirs terminée',
	'Done syncing files to [_1] ([_2])' => 'Synchronisation des fichiers de [_1] ([_2]) terminée',

## lib/MT/XMLRPCServer.pm
	'Invalid timestamp format' => 'Format de date invalide',
	'No web services password assigned.  Please see your user profile to set it.' => 'Aucun mot de passe associé aux services web. Merci de vérifier votre profil utilisateur pour le définir.',
	'Requested permalink \'[_1]\' is not available for this page' => 'Le lien permanent requis \'[_1]\' n\'est pas disponible pour cette page',
	'Saving folder failed: [_1]' => 'Échec de la sauvegarde du répertoire : [_1]',
	'No blog_id' => 'Pas de blog_id',
	'Invalid login' => 'Login invalide',
	'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => 'La valeur pour \'mt_[_1]\' doit être 0 ou 1 (était \'[_2]\')',
	'No entry_id' => 'Aucun entry_id',
	'Invalid entry ID \'[_1]\'' => 'ID de note \'[_1]\' invalide',
	'Not allowed to edit entry' => 'Non autorisé à modifier la note',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'La note \'[_1]\' ([lc,_5] #[_2]) a été supprimée par \'[_3]\' (utilisateur #[_4]) depuis XML-RPC',
	'Not allowed to get entry' => 'Non autorisé à afficher la note',
	'Not allowed to set entry categories' => 'Non autorisé à modifier les catégories de la note',
	'Publishing failed: [_1]' => 'La publication a échoué : [_1]',
	'Not allowed to upload files' => 'Non autorisé à télécharger des fichiers',
	'No filename provided' => 'Aucun nom de fichier',
	'Error writing uploaded file: [_1]' => 'Erreur lors de l\'écriture du fichier téléchargé : [_1]',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Le module Perl Image::Size est requis pour déterminer la largeur et la hauteur des images téléchargées.',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Les méthodes de gabarit ne sont pas implémentées en raison d\'une différence entre l\'API Blogger et l\'API Movable Type.',

## mt-static/addons/Cloud.pack/js/cfg_config_directives.js
	'A configuration directive is required.' => 'Une directive de configuration est requise.', # Translate - New
	'[_1] cannot be updated.' => '[_1] ne peut pas être mis à jour.', # Translate - New
	'Although [_1] can be updated by Movable Type, it cannot be updated on this screen.' => 'Bien que [_1] puisse être mis à jour par Movable Type, il ne peut l\'être sur cet écran.', # Translate - New
	'[_1] already exists.' => '[_1] existe déjà.', # Translate - New
	'A configuration value is required.' => 'Une valeur de configuration est requise.', # Translate - New
	'The HASH type configuration directive should be in the format of "key=value"' => 'La directive de configuration du type de HASH doit être au format "clé=valeur"', # Translate - New
	'[_1] for [_2] already exists.' => '[_1] pour [_2] existe déjà.', # Translate - New
	'https://www.movabletype.org/documentation/[_1]' => 'https://www.movabletype.org/documentation/[_1]',
	'Are you sure you want to remove [_1]?' => 'Voulez-vous vraiment supprimer [_1] ?', # Translate - New
	'configuration directive' => 'directive de configuration', # Translate - New

## mt-static/addons/Cloud.pack/js/cms.js
	'Continue' => 'Continuer',
	'You have unsaved changes to this page that will be lost.' => 'Certains de vos changements dans cette page n\'ont pas été enregistrés, ils seront perdus.',

## mt-static/addons/Sync.pack/js/cms.js

## mt-static/chart-api/deps/raphael-min.js
	'+e.x+' => '+e.x+',

## mt-static/chart-api/mtchart.js

## mt-static/chart-api/mtchart.min.js

## mt-static/jquery/jquery.mt.js
	'Invalid value' => 'Valeur incorrecte',
	'You have an error in your input.' => 'Il y a une erreur dans votre entrée.',
	'Options less than or equal to [_1] must be selected' => 'Des options inférieures ou égales à [_1] doivent être sélectionnées',
	'Options greater than or equal to [_1] must be selected' => 'Des options supérieures ou égales à [_1] doivent être sélectionnées',
	'Please select one of these options' => 'Veuillez sélectionner l\'une de ces options',
	'Only 1 option can be selected' => 'Une seule option peut être sélectionnée',
	'Invalid date format' => 'Format de date incorrect',
	'Invalid time format' => 'Format d\'heure incorrect',
	'Invalid URL' => 'URL incorrecte',
	'This field is required' => 'Ce champ est requis',
	'This field must be an integer' => 'Ce champ doit être un entier',
	'This field must be a signed integer' => 'Ce champ doit être un entier signé',
	'This field must be a number' => 'Ce champ doit être un nombre',
	'This field must be a signed number' => 'Ce champ doit être un nombre signé',
	'Please input [_1] characters or more' => 'Veuillez entrer au moins [_1] caractères',

## mt-static/js/assetdetail.js
	'No Preview Available.' => 'Pas de prévisualisation disponible',
	'Dimensions' => 'Dimensions',
	'File Name' => 'Nom de fichier',

## mt-static/js/cms.js

## mt-static/js/contenttype/contenttype.js

## mt-static/js/contenttype/tag/content-fields.tag
	'Data Label Field' => 'Champ de label de donnée',
	'Show input field to enter data label' => 'Afficher le champ pour entrer le label de donnée',
	'Unique ID' => 'Identifiant unique',
	'Allow users to change the display and sort of fields by display option' => 'Autoriser les utilisateurs à modifier l\'affichage et le tri via les options d\'affichage',
	'close' => 'fermer',
	'Drag and drop area' => 'Zone de glisser/déposer',
	'Please add a content field.' => 'Veuillez ajouter un champ de contenu.',

## mt-static/js/contenttype/tag/content-field.tag
	'Move' => 'Déplacer',
	'ContentField' => 'ContentField',

## mt-static/js/dialog.js
	'(None)' => '(Aucun)',

## mt-static/js/image_editor/fabric.js
	' +
                          toFixed(center.x, NUM_FRACTION_DIGITS) +
                           +
                          toFixed(center.y, NUM_FRACTION_DIGITS) +
                        ' => ' +
                          toFixed(center.x, NUM_FRACTION_DIGITS) +
                           +
                          toFixed(center.y, NUM_FRACTION_DIGITS) +
                        ',
	', (-this.width / 2), , (-this.height/2), ' => ', (-this.width / 2), , (-this.height/2), ',
	' + (-this.width/2) +  + (-this.height/2) + ' => ' + (-this.width/2) +  + (-this.height/2) + ',
	', toFixed(offsets.textLeft, 2), , toFixed(offsets.textTop, 2), ' => ', toFixed(offsets.textLeft, 2), , toFixed(offsets.textTop, 2), ',
	',
        -this.width / 2, ,
        -this.height + heightOfLine, ' => ',
        -this.width / 2, ,
        -this.height + heightOfLine, ',

## mt-static/js/image_editor/fabric.min.js
	'+e(n.x,r)++e(n.y,r)+' => '+e(n.x,r)++e(n.y,r)+',
	',i(r.textLeft,2)," ",i(r.textTop,2),' => ',i(r.textLeft,2)," ",i(r.textTop,2),',

## mt-static/js/listing/list_data.js
	'[_1] - Filter [_2]' => '[_1] - Filtre [_2]',

## mt-static/js/listing/listing.js
	'act upon' => 'agir sur',
	'You did not select any [_1] to [_2].' => 'Vous n\'avez pas sélectionné de [_1] à [_2].',
	'You can only act upon a minimum of [_1] [_2].' => 'Vous ne pouvez agir que sur un minimum de [_1] [_2].',
	'You can only act upon a maximum of [_1] [_2].' => 'Vous ne pouvez agir que sur un maximum de [_1] [_2].',
	'Are you sure you want to [_2] this [_1]?' => 'Voulez-vous vraiment [_2] ce(tte) [_1] ?',
	'Are you sure you want to [_3] the [_1] selected [_2]?' => 'Voulez-vous vraiment [_3] les [_1] [_2] sélectionné(e)s ?',
	'Label "[_1]" is already in use.' => 'Le label "[_1]" est déjà en cours d\'utilisation',
	'Are you sure you want to remove filter \'[_1]\'?' => 'Voulez-vous vraiment supprimer le filtre \'[_1]\' ?',

## mt-static/js/listing/tag/display-options-for-mobile.tag
	'Show' => 'Afficher',
	'25 rows' => '25 lignes',
	'50 rows' => '50 lignes',
	'100 rows' => '100 lignes',
	'200 rows' => '200 lignes',

## mt-static/js/listing/tag/display-options.tag
	'Display Options' => 'Options d\'affichage',
	'Reset defaults' => 'Réinitialiser les valeurs par défaut',
	'Column' => 'Colonnes',
	'User Display Option is disabled now.' => 'L\'option d\'affichage utilisateur est maintenant désactivée.',

## mt-static/js/listing/tag/list-actions-for-mobile.tag
	'Select action' => 'Sélectionner une action', # Translate - New
	'Plugin Actions' => 'Actions du plugin',

## mt-static/js/listing/tag/list-actions-for-pc.tag
	'More actions...' => 'Plus d\'actions...',

## mt-static/js/listing/tag/list-actions.tag

## mt-static/js/listing/tag/list-filter.tag
	'Filter:' => 'Filtre :',
	'Reset Filter' => 'Réinitialiser le filtre',
	'Select Filter Item...' => 'Sélectionner un élément de filtre...',
	'Add' => 'Ajouter',
	'Select Filter' => 'Sélectionner un filtre',
	'My Filters' => 'Mes filtres',
	'rename' => 'renommer',
	'Create New' => 'Créer...',
	'Built in Filters' => 'Filtres disponibles',
	'Apply' => 'Appliquer',
	'Save As' => 'Enregistrer sous',
	'Filter Label' => 'Filtrer par label',

## mt-static/js/listing/tag/list-pagination-for-mobile.tag

## mt-static/js/listing/tag/list-pagination-for-pc.tag

## mt-static/js/listing/tag/list-table.tag
	'Loading...' => 'Chargement...',
	'Select All' => 'Tout sélectionner',
	'All' => 'toutes', # Translate - Case
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] de [_3]',
	'Select all [_1] items' => 'Sélectionner tous les [_1] éléments',
	'All [_1] items are selected' => 'Tous les [_1] éléments sont sélectionnés',
	'Select' => 'Sélectionner',

## mt-static/js/mt/util.js
	'You did not select any [_1] [_2].' => 'Vous n\'avez pas sélectionné de [_1] [_2].',
	'delete' => 'supprimer',
	'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => 'Voulez-vous vraiment supprimer ce rôle ? En faisant cela vous allez supprimer les autorisations de tous les utilisateurs et groupes associés à ce rôle.',
	'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => 'Voulez-vous vraiment supprimer les rôles [_1] ? Avec cette action vous allez supprimer les autorisations associées à tous les utilisateurs et groupes liés à ce rôle.',
	'You must select an action.' => 'Vous devez sélectionner une action.',

## mt-static/js/tc/mixer/display.js
	'Title:' => 'Titre :',
	'Description:' => 'Description :',
	'Author:' => 'Auteur :',
	'Tags:' => 'Tags :',
	'URL:' => 'URL :',

## mt-static/js/upload_settings.js
	'You must set a valid path.' => 'Vous devez définir un chemin valide.',
	'You must set a path beginning with %s or %a.' => 'Vous devez définir un chemin  commençant par %s ou %a.',

## mt-static/mt.js
	'remove' => 'retirer',
	'enable' => 'activer',
	'disable' => 'désactiver',
	'publish' => 'publier',
	'unlock' => 'déverrouiller',
	'to mark as spam' => 'pour classer comme spam',
	'to remove spam status' => 'pour retirer le statut de spam',
	'Enter email address:' => 'Saisissez l\'adresse e-mail :',
	'Enter URL:' => 'Saisissez l\'URL :',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\'?' => 'Le tag \'[_2]\' existe déjà. Voulez-vous vraiment fusionner \'[_1]\' avec \'[_2]\' ?',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all weblogs?' => 'Le tag \'[_2]\' existe déjà. Voulez-vous vraiment fusionner \'[_1]\' avec \'[_2]\' sur tous les blogs ?',
	'Same name tag already exists.' => 'Un tag avec le même nom existe déjà.',

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field.js
	'Edit [_1] block' => 'Éditer le bloc [_1]',

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field_manager.js

## mt-static/plugins/BlockEditor/lib/js/fields/embed.js
	'Embed Code' => 'Code embarqué',
	'Please enter the embed code here.' => 'Entrer le code embarqué ici.',

## mt-static/plugins/BlockEditor/lib/js/fields/header.js
	'Heading' => 'Titre',
	'Heading Level' => 'Niveau de titre',
	'Please enter the Header Text here.' => 'Entrer le texte du titre ici.',

## mt-static/plugins/BlockEditor/lib/js/fields/horizon.js
	'Horizontal Rule' => 'Règle horizontale',

## mt-static/plugins/BlockEditor/lib/js/fields/image.js

## mt-static/plugins/BlockEditor/lib/js/fields/text.js
	'__TEXT_BLOCK__' => 'Bloc de texte',

## mt-static/plugins/BlockEditor/lib/js/jquery.blockeditor.js
	'Select a block' => 'Sélectionner un bloc',

## mt-static/plugins/BlockEditor/lib/js/modal_window.js

## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => 'Insérez le texte formaté',

## mt-static/plugins/Loupe/js/vendor.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/autosave/plugin.js
	'You have unsaved changes are you sure you want to navigate away?' => 'Des modifications n\'ont pas été enregistrées. Voulez-vous vraiment quitter cette page ?',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/autosave/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/compat3x/utils/editable_selects.js
	'value' => 'valeur',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/insertdatetime/plugin.js
	'%Y-%m-%d' => '%Y-%m-%d',
	'%H:%M:%S' => '%H:%M:%S',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/insertdatetime/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/langs/plugin.js
	'Fullscreen' => 'Plein écran',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/plugin.js
	'Class Name' => 'Nom de la classe',
	'Bold (Ctrl+B)' => 'Gras (Ctrl+B)',
	'Italic (Ctrl+I)' => 'Italique (Ctrl+I)',
	'Underline (Ctrl+U)' => 'Souligné (Ctrl+U)',
	'Strikethrough' => 'Rayé',
	'Block Quotation' => 'Bloc de citation',
	'Unordered List' => 'Liste non ordonnée',
	'Ordered List' => 'Liste ordonnée',
	'Horizontal Line' => 'Ligne horizontale',
	'Insert/Edit Link' => 'Insérer/éditer un lien',
	'Unlink' => 'Délier',
	'Undo (Ctrl+Z)' => 'Annuler (Ctrl+Z)',
	'Redo (Ctrl+Y)' => 'Refaire (Ctrl+Y)',
	'Select Text Color' => 'Choisir la couleur du texte',
	'Select Background Color' => 'Choisir la couleur du fond',
	'Remove Formatting' => 'Supprimer le formatage',
	'Align Left' => 'Aligner à gauche',
	'Align Center' => 'Aligner au centre',
	'Align Right' => 'Aligner à droite',
	'Indent' => 'Indenter',
	'Outdent' => 'Désindenter',
	'Insert Link' => 'Insérer un lien',
	'Insert HTML' => 'Insérer du HTML',
	'Insert Image Asset' => 'Insérer une image',
	'Insert Asset Link' => 'Insérer un lien de fichier',
	'Toggle Fullscreen Mode' => 'Bascule plein écran',
	'Toggle HTML Edit Mode' => 'Bascule mode code HTML',
	'Strong Emphasis' => 'Forte emphase',
	'Emphasis' => 'Emphase',
	'List Item' => 'Item de liste',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/plugin.js
	'HTML' => 'HTML',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/paste/plugin.min.js
	'Paste is now in plain text mode. Contents will now be pasted as plain text until you toggle this option off.' => 'Coller se passe désormais en mode texte brut. Le contenu sera collé comme texte brut tant que vous ne désactivez pas cette option.',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/save/plugin.js
	'Error: Form submit field collision.' => 'Erreur : collision de champ de soumission de formulaire.',
	'Error: No form element found.' => 'Erreur : aucun élément de formulaire trouvé.',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/save/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/spellchecker/plugin.js
	'Server response wasn\'t proper JSON.' => 'La réponse du serveur n\'est pas du JSON valide.',
	'The spelling service was not found: (' => 'Le service de trduction est introuvable : (',
	')' => ')',
	'No misspellings found.' => 'Aucune faute d\'orthographe trouvée.',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/spellchecker/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/template/plugin.js
	'No templates defined.' => 'Pas de gabarits définis.',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/template/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/textcolor/plugin.js
	'No color' => 'Pas de couleur',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/toc/plugin.js
	'Table of Contents' => 'Table des matières',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/toc/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/tinymce.js
	'Image uploading...' => 'Chargement de l\'image...',

## mt-static/plugins/TinyMCE/tiny_mce/tinymce.min.js
	'Your browser doesn\'t support direct access to the clipboard. Please use the Ctrl+X/C/V keyboard shortcuts instead.' => 'Votre navigateur ne gère pas l\'accès direct au presse-papier. Veuillez utiliser les combinaisons clavier Ctrl+X/C/V à la place.',
	'Rich Text Area. Press ALT-F9 for menu. Press ALT-F10 for toolbar. Press ALT-0 for help' => 'Zone de texte enrichi. Pressez ALT-F9 pour le menu, ALT-F10 pour la barre d\'outils, ALT-0 pour l\'aide.',

## themes/classic_blog/templates/about_this_page.mtml

## themes/classic_blog/templates/archive_index.mtml

## themes/classic_blog/templates/archive_widgets_group.mtml

## themes/classic_blog/templates/author_archive_list.mtml

## themes/classic_blog/templates/banner_footer.mtml

## themes/classic_blog/templates/calendar.mtml

## themes/classic_blog/templates/category_archive_list.mtml

## themes/classic_blog/templates/category_entry_listing.mtml

## themes/classic_blog/templates/comment_detail.mtml
	'[_1] replied to <a href="[_2]">comment from [_3]</a>' => '[_1] en réponse au <a href="[_2]">commentaire de [_3]</a>',

## themes/classic_blog/templates/comment_listing.mtml
	'Comment Detail' => 'Détail du commentaire',

## themes/classic_blog/templates/comment_preview.mtml
	'Previewing your Comment' => 'Aperçu de votre commentaire',
	'Leave a comment' => 'Laisser un commentaire',
	'Replying to comment from [_1]' => 'En réponse au commentaire de [_1]',
	'(You may use HTML tags for style)' => '(vous pouvez utiliser des balises HTML pour le style)',
	'Submit' => 'Envoyer',

## themes/classic_blog/templates/comment_response.mtml
	'Your comment has been submitted!' => 'Votre commentaire a été envoyé !',
	q{Your comment submission failed for the following reasons: [_1]} => q{L'envoi de votre commentaire a échoué pour la raison suivante : [_1]},

## themes/classic_blog/templates/comments.mtml
	'The data is modified by the paginate script' => 'Les données sont modifiées par le script de pagination',
	'Remember personal info?' => 'Mémoriser ces infos personnelles ?',

## themes/classic_blog/templates/creative_commons.mtml

## themes/classic_blog/templates/current_author_monthly_archive_list.mtml

## themes/classic_blog/templates/current_category_monthly_archive_list.mtml

## themes/classic_blog/templates/date_based_author_archives.mtml

## themes/classic_blog/templates/date_based_category_archives.mtml

## themes/classic_blog/templates/dynamic_error.mtml

## themes/classic_blog/templates/entry.mtml

## themes/classic_blog/templates/entry_summary.mtml

## themes/classic_blog/templates/javascript.mtml

## themes/classic_blog/templates/main_index.mtml

## themes/classic_blog/templates/main_index_widgets_group.mtml

## themes/classic_blog/templates/monthly_archive_dropdown.mtml

## themes/classic_blog/templates/monthly_archive_list.mtml

## themes/classic_blog/templates/monthly_entry_listing.mtml

## themes/classic_blog/templates/openid.mtml

## themes/classic_blog/templates/page.mtml

## themes/classic_blog/templates/pages_list.mtml

## themes/classic_blog/templates/powered_by.mtml

## themes/classic_blog/templates/recent_assets.mtml

## themes/classic_blog/templates/recent_comments.mtml
	'<strong>[_1]:</strong> [_2] <a href="[_3]" title="full comment on: [_4]">read more</a>' => '<strong>[_1] :</strong> [_2] <a href="[_3]" title="commentaire complet sur : [_4]">lire la suite</a>',

## themes/classic_blog/templates/recent_entries.mtml

## themes/classic_blog/templates/search.mtml

## themes/classic_blog/templates/search_results.mtml

## themes/classic_blog/templates/sidebar.mtml

## themes/classic_blog/templates/signin.mtml

## themes/classic_blog/templates/syndication.mtml

## themes/classic_blog/templates/tag_cloud.mtml

## themes/classic_blog/templates/technorati_search.mtml

## themes/classic_blog/templates/trackbacks.mtml
	'TrackBack URL: [_1]' => 'URL de TrackBack : [_1]',
	'<a href="[_1]">[_2]</a> from [_3] on <a href="[_4]">[_5]</a>' => '<a href="[_1]">[_2]</a> depuis [_3] sur <a href="[_4]">[_5]</a>',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">Lire la suite</a>',

## themes/classic_blog/theme.yaml
	'A traditional blogging design that comes with plenty of styles and a selection of 2 column / 3 column layouts. Best for use in standard blog publishing applications.' => 'Un design traditionnel de blog livré avec plusieurs styles et une variante de gabarits à 2 et 3 colonnes. Adapté à la publication de blogs standards.',
	'Improved listing of comments.' => 'Liste améliorée des commentaires',
	'Displays preview of comment.' => 'Affiche la prévisualisation du commentaire.',
	'Displays error, pending or confirmation message for comments.' => 'Affiche les erreurs et les messages de modération pour les commentaires.',
	'Displays results of a search for content data.' => 'Affiche les résultats de recherche de données de contenu.',

## themes/classic_website/templates/about_this_page.mtml
	'<a href="[_1]">[_2]</a> was the previous entry in this website.' => '<a href="[_1]">[_2]</a> est la note précédente de ce site web.',
	'<a href="[_1]">[_2]</a> is the next entry in this website.' => '<a href="[_1]">[_2]</a> est la note suivante de ce site web.',

## themes/classic_website/templates/archive_index.mtml

## themes/classic_website/templates/archive_widgets_group.mtml

## themes/classic_website/templates/author_archive_list.mtml

## themes/classic_website/templates/banner_footer.mtml

## themes/classic_website/templates/blogs.mtml
	'Blogs' => 'Blogs',

## themes/classic_website/templates/calendar.mtml

## themes/classic_website/templates/category_archive_list.mtml

## themes/classic_website/templates/category_entry_listing.mtml

## themes/classic_website/templates/comment_detail.mtml

## themes/classic_website/templates/comment_listing.mtml

## themes/classic_website/templates/comment_preview.mtml

## themes/classic_website/templates/comment_response.mtml

## themes/classic_website/templates/comments.mtml

## themes/classic_website/templates/creative_commons.mtml

## themes/classic_website/templates/current_author_monthly_archive_list.mtml

## themes/classic_website/templates/current_category_monthly_archive_list.mtml

## themes/classic_website/templates/date_based_author_archives.mtml

## themes/classic_website/templates/date_based_category_archives.mtml

## themes/classic_website/templates/dynamic_error.mtml

## themes/classic_website/templates/entry.mtml

## themes/classic_website/templates/entry_summary.mtml

## themes/classic_website/templates/javascript.mtml

## themes/classic_website/templates/main_index.mtml

## themes/classic_website/templates/main_index_widgets_group.mtml

## themes/classic_website/templates/monthly_archive_dropdown.mtml

## themes/classic_website/templates/monthly_archive_list.mtml

## themes/classic_website/templates/monthly_entry_listing.mtml

## themes/classic_website/templates/openid.mtml

## themes/classic_website/templates/page.mtml

## themes/classic_website/templates/pages_list.mtml

## themes/classic_website/templates/powered_by.mtml

## themes/classic_website/templates/recent_assets.mtml

## themes/classic_website/templates/recent_comments.mtml

## themes/classic_website/templates/recent_entries.mtml

## themes/classic_website/templates/search.mtml

## themes/classic_website/templates/search_results.mtml

## themes/classic_website/templates/sidebar.mtml

## themes/classic_website/templates/signin.mtml

## themes/classic_website/templates/syndication.mtml
	q{Subscribe to this website's feed} => q{Souscrire au flux du site web},

## themes/classic_website/templates/tag_cloud.mtml

## themes/classic_website/templates/technorati_search.mtml

## themes/classic_website/templates/trackbacks.mtml

## themes/classic_website/theme.yaml
	'Create a blog portal that aggregates contents from several blogs in one website.' => 'Crée un portail de blogs qui agrège les contenus de plusieurs blogs sur un site web.',
	'Classic Website' => 'Site web classique',

## themes/eiger/templates/banner_footer.mtml
	'This blog is licensed under a <a rel="license" href="[_1]">Creative Commons License</a>.' => 'Ce blog est publié sous licence <a href="[_1]">Creative Commons</a>.',

## themes/eiger/templates/category_archive_list.mtml

## themes/eiger/templates/category_entry_listing.mtml
	'Home' => 'Accueil',
	'Pagination' => 'Pagination',
	'Related Contents (Blog)' => 'Contenus en relation (blog)',

## themes/eiger/templates/comment_detail.mtml

## themes/eiger/templates/comment_form.mtml
	'Post a Comment' => 'Publier un commentaire',
	'Reply to comment' => 'Répondre au commentaire',

## themes/eiger/templates/comment_preview.mtml

## themes/eiger/templates/comment_response.mtml
	'Your comment has been received and held for approval by the blog owner.' => 'Votre commentaire a été reçu et est en attente de validation par le propriétaire de ce blog.',

## themes/eiger/templates/comments.mtml

## themes/eiger/templates/dynamic_error.mtml
	'Related Contents (Index)' => 'Contenus en relation (index)',

## themes/eiger/templates/entries_list.mtml
	'Read more' => 'Lire la suite',

## themes/eiger/templates/entry.mtml
	'Posted on' => 'Publiée le',
	'Previous entry' => 'Note précédente',
	'Next entry' => 'Note suivante',
	'Zenback' => 'Zenback',

## themes/eiger/templates/entry_summary.mtml

## themes/eiger/templates/index_page.mtml
	'Main Image' => 'Impage principale',

## themes/eiger/templates/javascript.mtml
	q{The sign-in attempt was not successful; please try again.} => q{La tentative d'enregistrement a échoué. Veuillez réessayer.},

## themes/eiger/templates/javascript_theme.mtml
	'Menu' => 'Menu',

## themes/eiger/templates/main_index.mtml

## themes/eiger/templates/navigation.mtml
	'About' => 'À propos',

## themes/eiger/templates/page.mtml

## themes/eiger/templates/pages_list.mtml

## themes/eiger/templates/pagination.mtml
	'Older entries' => 'Notes plus anciennes',
	'Newer entries' => 'Notes plus récentes',

## themes/eiger/templates/recent_entries.mtml

## themes/eiger/templates/sample_widget_01.mtml
	'Sample Widget' => 'Exemple de widget',
	q{This is sample widget} => q{Ceci est un widget d'exemple},

## themes/eiger/templates/sample_widget_02.mtml
	'Advertisement' => 'Publicité',

## themes/eiger/templates/sample_widget_03.mtml
	'Banner' => 'Bannière',

## themes/eiger/templates/sample_widget_04.mtml
	'Links' => 'Liens',
	'Link Text' => 'Texte du lien',

## themes/eiger/templates/search.mtml

## themes/eiger/templates/search_results.mtml
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'Par défaut, ce moteur va rechercher tous les mots dans le désordre. Pour chercher une expression exacte, placez-la entre apostrophes :',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'Le moteur de recherche supporte aussi les mot-clés AND, OR, NOT pour spécifier des expressions booléennes :',

## themes/eiger/templates/styles.mtml
	'for Comments, Trackbacks' => 'pour commentaires, Trackbacks',
	q{Sample Style} => q{Style d'exemple},

## themes/eiger/templates/syndication.mtml

## themes/eiger/templates/trackbacks.mtml
	'<a href="[_1]">[_2]</a> - [_3]</a>' => '<a href="[_1]">[_2]</a> - [_3]</a>',

## themes/eiger/templates/yearly_archive_dropdown.mtml
	'Select a Year...' => 'Sélectionnez une année...',

## themes/eiger/templates/yearly_archive_list.mtml

## themes/eiger/templates/yearly_entry_listing.mtml

## themes/eiger/templates/zenback.mtml
	'Please paste the Zenback script code here' => 'Copiez le code du script Zenback ici',

## themes/eiger/theme.yaml
	'_THEME_DESCRIPTION' => 'Eiger est un thème web réactif personnalisable, conçu pour des sites et des blogs professionnels. En plus du support multi-clients via Media Query (CSS), des fonctions Movable Type rendent très simple la personnalisation de la navigation et des éléments graphiques comme logos, bannières ou entêtes.',
	'_ABOUT_PAGE_TITLE' => 'À propos',
	q{_ABOUT_PAGE_BODY} => q{<p>Ceci est un exemple de page "à propos" (typiquement, une telle page contient des informations sur l'individu ou l'entreprise).</p><p>Si le tag <code>@ABOUT_PAGE</code> est utilisé sur une page, celle-ci est ajoutée à la navigation dans l'entête et le pied de page.</p>},
	q{_SAMPLE_PAGE_TITLE} => q{Page d'exemple},
	q{_SAMPLE_PAGE_BODY} => q{<p>Ceci est un exemple de page web.</p><p>Si le tag <code>@ADD_TO_SITE_NAV</code> est utilisé sur une page, celle-ci sera ajoutée à la navigation dans l'entête et le pied de page.</p>},
	'Eiger' => 'Eiger',
	'Index Page' => 'Page d\'index',
	'Stylesheet for IE (8 or lower)' => 'Feuille de style pour IE (8 ou inférieur)',
	'JavaScript - Theme' => 'JavaScript - Thème',
	'Yearly Entry Listing' => 'Listing annuel des notes',
	'Displays errors for dynamically published templates.' => 'Affiche les erreurs pour les gabarits publiés dynamiquement.',
	'Yearly Archives Dropdown' => 'Menu déroulant des archives annuelles',
	'Yearly Archives' => 'Archives annuelles',
	'Sample Widget 01' => 'Widget d\'exemple 01',
	'Sample Widget 02' => 'Widget d\'exemple 02',
	'Sample Widget 03' => 'Widget d\'exemple 03',
	'Sample Widget 04' => 'Widget d\'exemple 04',

## themes/mont-blanc/theme.yaml
	'__DESCRIPTION' => 'Rainier est un thème web réactif personnalisable, conçu pour des blogs. En plus du support multi-clients via Media Query (CSS), des fonctions Movable Type rendent très simple la personnalisation de la navigation et des éléments graphiques comme logos, bannières ou entêtes.',
	'Mont-Blanc' => 'Mont-Blanc',
	'Summary' => 'Sommaire',
	'og:image' => 'og:image',

## themes/pico/templates/about_this_page.mtml

## themes/pico/templates/archive_index.mtml
	'Related Content' => 'Contenu lié',

## themes/pico/templates/archive_widgets_group.mtml

## themes/pico/templates/author_archive_list.mtml

## themes/pico/templates/banner_footer.mtml

## themes/pico/templates/calendar.mtml

## themes/pico/templates/category_archive_list.mtml

## themes/pico/templates/category_entry_listing.mtml

## themes/pico/templates/comment_detail.mtml

## themes/pico/templates/comment_listing.mtml

## themes/pico/templates/comment_preview.mtml
	'Preview Comment' => 'Aperçu du commentaire',

## themes/pico/templates/comment_response.mtml

## themes/pico/templates/comments.mtml

## themes/pico/templates/creative_commons.mtml

## themes/pico/templates/current_author_monthly_archive_list.mtml

## themes/pico/templates/current_category_monthly_archive_list.mtml

## themes/pico/templates/date_based_author_archives.mtml

## themes/pico/templates/date_based_category_archives.mtml

## themes/pico/templates/dynamic_error.mtml

## themes/pico/templates/entry.mtml

## themes/pico/templates/entry_summary.mtml

## themes/pico/templates/javascript.mtml

## themes/pico/templates/main_index.mtml

## themes/pico/templates/main_index_widgets_group.mtml

## themes/pico/templates/monthly_archive_dropdown.mtml

## themes/pico/templates/monthly_archive_list.mtml

## themes/pico/templates/monthly_entry_listing.mtml

## themes/pico/templates/navigation.mtml
	q{Subscribe} => q{S'abonner},

## themes/pico/templates/openid.mtml

## themes/pico/templates/page.mtml

## themes/pico/templates/pages_list.mtml

## themes/pico/templates/recent_assets.mtml

## themes/pico/templates/recent_comments.mtml

## themes/pico/templates/recent_entries.mtml

## themes/pico/templates/search.mtml

## themes/pico/templates/search_results.mtml

## themes/pico/templates/signin.mtml

## themes/pico/templates/syndication.mtml

## themes/pico/templates/tag_cloud.mtml

## themes/pico/templates/technorati_search.mtml

## themes/pico/templates/trackbacks.mtml

## themes/pico/theme.yaml
	q{Pico is a microblogging theme, designed for keeping things simple to handle frequent updates. To put the focus on content we've moved the sidebars below the list of posts.} => q{Pico est un thème de microblogging conçu pour gérer simplement des mises à jour fréquentes. Pour mettre en avant votre contenu, nous avons déplacé les colonnes latérales sous la liste de vos notes.},
	'Pico' => 'Pico',
	'Pico Styles' => 'Styles Pico',
	'A collection of styles compatible with Pico themes.' => 'Une collection de styles compatible avec les thèmes Pico.',

## themes/rainier/templates/banner_footer.mtml

## themes/rainier/templates/category_archive_list.mtml

## themes/rainier/templates/category_entry_listing.mtml
	'Related Contents' => 'Contenus liés',

## themes/rainier/templates/comment_detail.mtml

## themes/rainier/templates/comment_form.mtml

## themes/rainier/templates/comment_preview.mtml

## themes/rainier/templates/comment_response.mtml

## themes/rainier/templates/comments.mtml

## themes/rainier/templates/dynamic_error.mtml

## themes/rainier/templates/entry.mtml
	'Posted on [_1]' => 'Publiée le [_1]',
	'by [_1]' => 'par [_1]',
	'in [_1]' => 'dans [_1]',

## themes/rainier/templates/entry_summary.mtml
	'Continue reading' => 'Continuer la lecture',

## themes/rainier/templates/javascript.mtml

## themes/rainier/templates/javascript_theme.mtml

## themes/rainier/templates/main_index.mtml

## themes/rainier/templates/monthly_archive_dropdown.mtml

## themes/rainier/templates/monthly_archive_list.mtml

## themes/rainier/templates/monthly_entry_listing.mtml

## themes/rainier/templates/navigation.mtml

## themes/rainier/templates/page.mtml
	'Last update' => 'Dernière mise à jour',

## themes/rainier/templates/pages_list.mtml

## themes/rainier/templates/pagination.mtml

## themes/rainier/templates/recent_comments.mtml
	'__VIEW_COMMENT' => 'Voir le commentaire',

## themes/rainier/templates/recent_entries.mtml

## themes/rainier/templates/search.mtml

## themes/rainier/templates/search_results.mtml

## themes/rainier/templates/syndication.mtml

## themes/rainier/templates/tag_cloud.mtml

## themes/rainier/templates/trackbacks.mtml

## themes/rainier/templates/zenback.mtml
	'Please paste Zenback script code here.' => 'Copiez le code du script Zenback ici.',

## themes/rainier/theme.yaml
	'About Page' => 'À propos',
	q{Example page} => q{Page d'exemple},
	'Rainier' => 'Rainier',
	'Styles for Rainier' => 'Styles pour Rainier',
	'A collection of styles compatible with Rainier themes.' => 'Une collection de styles compatibles avec les thèmes Rainier.',

## search_templates/comments.tmpl
	'Search for new comments from:' => 'Recherche de nouveaux commentaires depuis :',
	'the beginning' => 'le début',
	'one week ago' => 'il y a une semaine',
	'two weeks ago' => 'il y a deux semaines',
	'one month ago' => 'il y a un mois',
	'two months ago' => 'il y a deux mois',
	'three months ago' => 'il y a trois mois',
	'four months ago' => 'il y a quatre mois',
	'five months ago' => 'il y a cinq mois',
	'six months ago' => 'il y a six mois',
	'one year ago' => 'il y a un an',
	'Find new comments' => 'Voir les nouveaux commentaires',
	'Posted in [_1] on [_2]' => 'Publié dans [_1] le [_2]',
	q{No results found} => q{Aucun résultat n'a été trouvé},
	q{No new comments were found in the specified interval.} => q{Aucun nouveau commentaire n'a été trouvé dans la période spécifiée.},
	q{Select the time interval that you'd like to search in, then click 'Find new comments'} => q{Sélectionner l'intervalle de temps désiré pour la recherche, puis cliquez sur 'Voir les nouveaux commentaires'},

## search_templates/content_data_default.tmpl
	q{SEARCH FEED AUTODISCOVERY LINK IS PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED} => q{Le lien du flux de la recherche automatisée est publié uniquement après l'exécution d'une recherche.},
	'Site Search Results' => 'Résultats de recherche du site',
	'Site search' => 'Recherche du site',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'les recherches simples obtiennent le formulaire de recherche',
	'Search this site' => 'Rechercher sur ce site',
	'SEARCH RESULTS DISPLAY' => 'Affichage des résultats de la recherche',
	'Matching content data from [_1]' => 'Assortiment de données de contenu depuis [_1]',
	'Posted <MTIfNonEmpty tag="ContentAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Publié <MTIfNonEmpty tag="ContentAuthorDisplayName">par [_1] </MTIfNonEmpty>le [_2]',
	'Showing the first [_1] results.' => 'Afficher les premiers [_1] résultats.',
	'NO RESULTS FOUND MESSAGE' => 'Aucun résultat.',
	q{Content Data matching '[_1]'} => q{Donnée de contenu correspondant à '[_1]'},
	q{Content Data tagged with '[_1]'} => q{Donnée de contenu taguée avec '[_1]'},
	q{No pages were found containing '[_1]'.} => q{Aucune page trouvée contenant '[_1]'.},
	'END OF ALPHA SEARCH RESULTS DIV' => 'FIN DE LA DIV ALPHA RÉSULTATS RECHERCHE',
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'DEBUT DE LA COLONNE BETA POUR AFFICHAGE DES INFOS DE RECHERCHE',
	'SET VARIABLES FOR SEARCH vs TAG information' => 'DEFINIT LES VARIABLES DE RECHERCHE vs TAGS',
	q{If you use an RSS reader, you can subscribe to a feed of all future content data tagged '[_1]'.} => q{Si vous utilisez un aggrégateur RSS, vous pouvez souscrire à un flux de toutes les données de contenu taguées avec '[_1]'.},
	q{If you use an RSS reader, you can subscribe to a feed of all future content data matching '[_1]'.} => q{Si vous utilisez un aggrégateur RSS, vous pouvez souscrire à un flux de toutes les données de contenu correspondant à '[_1]'.},
	q{SEARCH/TAG FEED SUBSCRIPTION INFORMATION} => q{INFORMATION D'ABONNEMENT AU FLUX RECHERCHE/TAG},
	'Feed Subscription' => 'Abonnement au flux',
	'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.com/about/feeds',
	q{What is this?} => q{De quoi s'agit-il ?},
	'END OF PAGE BODY' => 'FIN DU CORPS DE LA PAGE',
	'END OF CONTAINER' => 'FIN DU CONTENU',

## search_templates/content_data_results_feed.tmpl
	'Search Results for [_1]' => 'Résultats de la recherche pour [_1]',

## search_templates/default.tmpl
	'Blog Search Results' => 'Résultats de la recherche',
	'Blog search' => 'Recherche de Blog',
	'Match case' => 'Respecter la casse',
	'Regex search' => 'Expression rationnelle',
	'Matching entries from [_1]' => 'Notes correspondant à [_1]',
	q{Entries from [_1] tagged with '[_2]'} => q{Notes de [_1] taguées avec '[_2]'},
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Posté <MTIfNonEmpty tag="EntryAuthorDisplayName">par [_1] </MTIfNonEmpty>le [_2]',
	q{Entries matching '[_1]'} => q{Notes correspondant à '[_1]'},
	q{Entries tagged with '[_1]'} => q{Notes taguées avec '[_1]'},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries tagged '[_1]'.} => q{Si vous utilisez un lecteur de flux RSS, vous pouvez souscrire au flux de toutes notes futures dont le tag sera '[_1]'.},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries matching '[_1]'.} => q{Si vous utilisez un lecteur de flux RSS, vous pouvez souscrire au flux des futures notes contenant le mot '[_1]'.},
	'TAG LISTING FOR TAG SEARCH ONLY' => 'LISTE DES TAGS UNIQUEMENT POUR LA RECHERCHE DE TAG',
	'Other Tags' => 'Autres tags',

## search_templates/results_feed_rss2.tmpl

## search_templates/results_feed.tmpl

## tmpl/cms/asset_replace.tmpl
	'Upload New Asset' => 'Télécharger un nouvel élément',

## tmpl/cms/asset_upload.tmpl

## tmpl/cms/backup.tmpl
	'What to Export' => 'Quoi exporter',
	'Everything' => 'Tout',
	'Reset' => 'Mettre à jour',
	'Choose sites...' => 'Choisir les sites...',
	q{Archive Format} => q{Format d'archive},
	q{Don't compress} => q{Ne pas compresser},
	'Target File Size' => 'Limiter la taille du fichier cible',
	'No size limit' => 'Aucune limite de taille',
	'Export (e)' => 'Export (e)',

## tmpl/cms/cfg_entry.tmpl
	q{Compose Settings} => q{Paramètres d'édition},
	'Your preferences have been saved.' => 'Vos préférences ont été sauvegardées.',
	'Publishing Defaults' => 'Préférences de publication',
	'Listing Default' => 'Préférences de liste',
	'Days' => 'Jours',
	'Posts' => 'Notes',
	'Order' => 'Ordre',
	'Ascending' => 'Croissant',
	'Descending' => 'Décroissant',
	q{Excerpt Length} => q{Longueur de l'extrait},
	'Date Language' => 'Langue de la date',
	'Czech' => 'Tchèque',
	'Danish' => 'Danois',
	'Dutch' => 'Néerlandais',
	'English' => 'Anglais',
	'Estonian' => 'Estonien',
	'French' => 'Français',
	'German' => 'Allemand',
	'Icelandic' => 'Islandais',
	'Italian' => 'Italien',
	'Japanese' => 'Japonais',
	'Norwegian' => 'Norvégien',
	'Polish' => 'Polonais',
	'Portuguese' => 'Portugais',
	'Slovak' => 'Slovaque',
	'Slovenian' => 'Slovène',
	'Spanish' => 'Espagnol',
	'Suomi' => 'Finlandais',
	'Swedish' => 'Suédois',
	'Basename Length' => 'Longueur du nom de base',
	q{Compose Defaults} => q{Préférences d'édition},
	'Unpublished' => 'Non publiée',
	'Text Formatting' => 'Mise en forme du texte',
	q{Specifies the default Text Formatting option when creating a new entry.} => q{Spécifie l'option par défaut de mise en forme du texte des nouvelles notes.},
	'Setting Ignored' => 'Paramètre ignoré',
	'Note: This option is currently ignored since comments are disabled either child site or system-wide.' => 'Note : cette option est ignorée car les commentaires sont désactivés soit au niveau du site enfant, soit au niveau du système.',
	'Note: This option is currently ignored since comments are disabled either site or system-wide.' => 'Note : cette option est ignorée car les commentaires sont désactivés soit au niveau du site, soit au niveau du système.',
	'Accept TrackBacks' => 'Accepter les TrackBacks',
	'Note: This option is currently ignored since TrackBacks are disabled either child site or system-wide.' => 'Note : cette option est ignorée car les TrackBacks sont désactivés soit au niveau du site enfant, soit au niveau du système.',
	'Note: This option is currently ignored since TrackBacks are disabled either site or system-wide.' => 'Note : cette option est ignorée car les TrackBacks sont désactivés soit au niveau du site, soit au niveau du système.',
	'Entry Fields' => 'Champs des notes',
	'Page Fields' => 'Champs des pages',
	q{WYSIWYG Editor Setting} => q{Préférences de l'éditeur riche},
	'Content CSS' => 'CSS pour le contenu',
	q{Content CSS will be applied when WYSIWYG editor does support. You can specify CSS file by URL or {{theme_static}} placeholder. Example: {{theme_static}}path/to/cssfile.css} => q{Des styles CSS pour le contenu seront appliqués si l'éditeur riche le supporte. Vous pouvez spécifier un fichier CSS par URL ou dans l'emplacement {{theme_static}}. Exemple : {{theme_static}}chemin/vers/fichiercss.css},
	'Punctuation Replacement Setting' => 'Paramètre de remplacement de la ponctuation',
	q{Replace UTF-8 characters frequently used by word processors with their more common web equivalents.} => q{Remplacer les caractères UTF-8 utilisés fréquemment par l'éditeur de texte par leur équivalent web le plus commun.},
	'Punctuation Replacement' => 'Remplacement de la ponctuation',
	'No substitution' => 'Ne pas effectuer de remplacements',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'Entités de caractères (&amp#8221;, &amp#8220;, etc.)',
	q{ASCII equivalents (&quot;, ', ..., -, --)} => q{Équivalents ASCII (&quot;, ', ..., -, --)},
	'Replace Fields' => 'Appliquer le remplacement des caractères dans les champs',
	q{Image default insertion options} => q{Options d'insertion d'image par défaut},
	'Use thumbnail' => 'Utiliser une vignette',
	'width:' => 'largeur :',
	'pixels' => 'pixels',
	'Alignment' => 'Alignement',
	'Left' => 'À gauche',
	'Center' => 'Au centre',
	'Right' => 'À droite',
	'Link to popup window' => 'Lien vers fenêtre surgissante',
	q{Link image to full-size version in a popup window.} => q{Créer un lien vers l'image originale dans une fenêtre surgissante},
	'Save changes to these settings (s)' => 'Enregistrer les modifications de ces paramètres (s)',
	'The range for Basename Length is 15 to 250.' => 'La longueur du nom de base va de 15 à 250.',
	'You must set valid default thumbnail width.' => 'Vous devez définir une largeur de vignette par défaut valide.',

## tmpl/cms/cfg_feedback.tmpl
	'Spam Settings' => 'Paramètres du spam',
	'Automatic Deletion' => 'Supression automatique',
	'Automatically delete spam feedback after the time period shown below.' => 'Supprime automatiquement le spam après la période décrite ci-dessous.',
	'Delete Spam After' => 'Effacer le spam après',
	'days' => 'jours',
	'Spam Score Threshold' => 'Niveau de filtrage du spam',
	'This value can be between -10 and +10. The bigger this value is, the more possible spam-detection framework determines comment/trackback as a spam.' => 'Cette valeur peut varier entre -10 et +10. Plus elle est élevée, plus le système de détection de spam va considérer de commentaires/trackback comme spam.',
	q{Apply 'nofollow' to URLs} => q{Appliquer 'nofollow' aux URLs},
	q{If enabled, all URLs in comments and TrackBacks will be assigned a 'nofollow' link relation.} => q{Si activé, toutes les URLs dans les commentaires et TrackBacks se verront attribuer un attribut 'nofollow'.},
	q{'nofollow' exception for trusted commenters} => q{Ne pas utiliser 'nofollow' pour les auteurs de commentaire fiables},
	q{Do not add the 'nofollow' attribute when a comment is submitted by a trusted commenter.} => q{Ne pas ajouter l'attribut 'nofollow' lorsqu'un commentaire est envoyé par un commentateur fiable.},
	'Comment Settings' => 'Paramètres des commentaires',
	'Note: Commenting is currently disabled at the system level.' => 'Note : les commentaires sont actuellement désactivés au niveau système.',
	q{Comment authentication is not available because at least one of the required Perl modules, MIME::Base64 and LWP::UserAgent, are not installed. Install the missing modules and reload this page to configure comment authentication.} => q{L'identification pour les commentaires n'est pas disponible parce qu'au moins un module Perl requis, MIME::Base64 et LWP::UserAgent, n'est pas installé. Installez les modules manquants et rechargez cette page pour configurer l'identification pour les commentaires.},
	'Accept comments according to the policies shown below.' => 'Accepter les commentaires selon les politiques choisies ci-dessous.',
	q{Setup Registration} => q{Configuration de l'enregistrement},
	'Commenting Policy' => 'Règles pour les commentaires',
	'Immediately approve comments from' => 'Approuver immédiatement les commentaires de',
	'No one' => 'Personne',
	'Trusted commenters only' => 'Commentateurs fiables uniquement',
	'Any authenticated commenters' => 'Tout commentateur authentifié',
	'Anyone' => 'Tout le monde',
	'Allow HTML' => 'Autoriser le HTML',
	q{Allow commenters to include a limited set of HTML tags in their comments. Otherwise all HTML will be stripped out.} => q{Permettre aux auteurs de commentaire d'inclure une série limitée de balises HTML dans leurs commentaires. Sinon, tous les tags HTML seront supprimés.},
	'Limit HTML Tags' => 'Limiter les balises HTML',
	'Use defaults' => 'Utiliser les valeurs par défaut',
	'([_1])' => '([_1])',
	'Use my settings' => 'Utiliser mes paramètres',
	'E-mail Notification' => 'Notification par e-mail',
	'On' => 'Activée',
	q{Only when attention is required} => q{Uniquement quand l'attention est requise},
	'Off' => 'Désactivée',
	q{Comment Display Settings} => q{Paramètres d'affichage des commentaires},
	'Comment Order' => 'Ordre des commentaires',
	'Select whether you want comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Sélectionnez si vous souhaitez afficher les commentaires selon un ordre chronologique (nouveaux commentaires en bas) ou anté-chronologique (nouveaux commentaires en haut)',
	'Auto-Link URLs' => 'Liaison automatique des URL',
	'Transform URLs in comment text into HTML links.' => 'Transformer les URLs dans les commentaires en liens',
	'CAPTCHA Provider' => 'Fournisseur de CAPTCHA',
	'No CAPTCHA provider available' => 'Aucun fournisseur de CAPTCHA disponible',
	q{No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed and if the CaptchaSourceImageBase configuration directive points to a valid captcha-source directory within the 'mt-static/images' directory.} => q{Aucun fournisseur de CAPTCHA n'est disponible pour ce système. Veuillez vérifier si Image::Magick est installé et si les directives de configuration CaptchaSourceImageBase pointent une source valide de captcha dans le répertoire 'mt-static/images'.},
	'Use Comment Confirmation Page' => 'Utiliser la page de confirmation de commentaire',
	q{Each commenter's browser will be redirected to a comment confirmation page after their comment is accepted.} => q{Rediriger les auteurs de commentaire vers une page de confirmation lorsque leur commentaire est accepté.},
	'Trackback Settings' => 'Paramètres des TrackBacks',
	'Note: TrackBacks are currently disabled at the system level.' => 'Note : Les Trackbacks sont actuellement désactivés au niveau système.',
	q{Accept TrackBacks from any source.} => q{Accepter les TrackBacks de n'importe quelle source.},
	'TrackBack Policy' => 'Règles pour les TrackBacks',
	'Moderation' => 'Modération',
	'Hold all TrackBacks for approval before they are published.' => 'Attendre la validation des TrackBacks avant de les publier',
	'TrackBack Options' => 'Options de TrackBack',
	'TrackBack Auto-Discovery' => 'Activer la découverte automatique des TrackBacks',
	'Enable External TrackBack Auto-Discovery' => 'Pour les notes extérieures au blog',
	'Setting Notice' => 'Paramètre des informations',
	'Note: This option may be affected since outbound pings are constrained system-wide.' => 'Note : cette option pourrait être affectée puisque les pings sont restreints au niveau du système.',
	'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Note : cette option est actuellement ignorée puisque les pings sortant sont désactivés au niveau du système.',
	'Enable Internal TrackBack Auto-Discovery' => 'Pour les notes intérieures au blog',

## tmpl/cms/cfg_plugin.tmpl
	'Plugin System' => 'Système de plugins',
	q{Enable or disable plugin functionality for the entire Movable Type installation.} => q{Activer ou désactiver la fonction plugin pour l'installation Movable Type toute entière.},
	'Disable plugin functionality' => 'Désactiver la prise en charge des plugins',
	'Disable Plugins' => 'Désactiver les plugins',
	'Enable plugin functionality' => 'Activer la prise en charge des plugins',
	'Enable Plugins' => 'Activer les plugins',
	'_PLUGIN_DIRECTORY_URL' => 'https://plugins.movabletype.org/',
	'Find Plugins' => 'Trouver des plugins',
	'Your plugin settings have been saved.' => 'Les paramètres de votre plugin ont été enregistrés.',
	'Your plugin settings have been reset.' => 'Les paramètres de votre plugin on été réinitialisés.',
	q{Your plugins have been reconfigured. Since you're running mod_perl, you must restart your web server for these changes to take effect.} => q{Vos plugins ont été reconfigurés. Puisque vous utilisez mod_perl, vous devez redémarrer votre serveur web pour que les changements soient pris en compte.},
	'Your plugins have been reconfigured.' => 'Votre plugin a été reconfiguré.',
	q{Your plugins have been reconfigured. Since you're running mod_perl, you will need to restart your web server for these changes to take effect.} => q{Vos plugins ont été reconfigurés. Puisque vous utilisez mod_perl vous devez redémarrer votre serveur web pour la prise en compte de ces changements.},
	'Are you sure you want to reset the settings for this plugin?' => 'Voulez-vous vraiment réinitialiser les paramètres pour ce plugin ?',
	q{Are you sure you want to disable plugins for the entire Movable Type installation?} => q{Voulez-vous vraiment désactiver les plugins pour l'installation Movable Type tout entière ?},
	'Are you sure you want to disable this plugin?' => 'Voulez-vous vraiment désactiver ce plugin ?',
	q{Are you sure you want to enable plugins for the entire Movable Type installation? (This will restore plugin settings that were in place before all plugins were disabled.)} => q{Voulez-vous vraiment activer les plugins pour l'installation Movable Type toute entière ? (Cela restaurera les paramètres déjà en place avant la désactivation de ceux-ci.)},
	'Are you sure you want to enable this plugin?' => 'Voulez-vous vraiment activer ce plugin ?',
	'Failed to load' => 'Erreur de chargement',
	'Failed to Load' => 'Erreur de chargement',
	q{This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be completely functional.} => q{Ce plugin n'a pas été mis à jour afin de supporter Movable Type [_1]. À cause de cela, il pourrait ne pas fonctionner correctement.},
	'Plugin error:' => 'Erreur de plugin :',
	'Info' => 'Info',
	'Resources' => 'Ressources',
	'Run [_1]' => 'Lancer [_1]',
	'Documentation for [_1]' => 'Documentation pour [_1]',
	'More about [_1]' => 'En savoir plus sur [_1]',
	'Plugin Home' => 'Accueil plugin',
	'Author of [_1]' => 'Auteur de [_1]',
	'Tag Attributes:' => 'Attributs de tag :',
	'Text Filters' => 'Filtres de texte',
	'Junk Filters:' => 'Filtres de spam :',
	'Reset to Defaults' => 'Réinitialiser (retour aux paramètres par défaut)',
	q{No plugins with blog-level configuration settings are installed.} => q{Aucun plugin avec une configuration au niveau du blog n'est installé.},
	q{No plugins with configuration settings are installed.} => q{Aucun plugin avec une configuration n'est installé.},

## tmpl/cms/cfg_prefs.tmpl
	q{Error: Movable Type was not able to create a directory for publishing your [_1]. If you create this directory yourself, grant write permission to the web server.} => q{Erreur : Movable Type n'a pas pu créer un répertoire pour la publication de votre [_1]. Si vous avez créé ce répertoire vous-même, ajoutez les autorisations d'écriture sur le serveur.},
	q{Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your site directory.} => q{Erreur : Movable Type n'a pas pu créer un répertoire pour cacher vos gabarits dynamiques. Vous devriez créer un répertoire nommé <code>[_1]</code> sous celui de votre site.},
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your site directory.' => 'Erreur : Movable Type ne peut pas écrire dans le répertoire de cache des gabarits. Vérifez les permissions du répertoire nommé <code>[_1]</code> sous celui du site.',
	'[_1] Settings' => 'Paramètres du [_1]',
	'Time Zone' => 'Fuseau horaire',
	q{Time zone not selected} => q{Vous n'avez pas sélectionné de fuseau horaire},
	'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (Nouvelle-Zélande)',
	'UTC+12 (International Date Line East)' => 'UTC+12 (ligne internationale de changement de date)',
	'UTC+11' => 'UTC+11 (Nouvelle-Calédonie)',
	'UTC+10 (East Australian Time)' => 'UTC+10 (Australie Est)',
	'UTC+9.5 (Central Australian Time)' => 'UTC+9,5 (Australie Centre)',
	'UTC+9 (Japan Time)' => 'UTC+9 (Japon)',
	'UTC+8 (China Coast Time)' => 'UTC+8 (Chine littorale)',
	'UTC+7 (West Australian Time)' => 'UTC+7 (Australie Ouest)',
	'UTC+6.5 (North Sumatra)' => 'UTC+6,5 (Sumatra Nord)',
	'UTC+6 (Russian Federation Zone 5)' => 'UTC+6 (Fédération russe, zone 5)',
	'UTC+5.5 (Indian)' => 'UTC+5.5 (Inde)',
	'UTC+5 (Russian Federation Zone 4)' => 'UTC+5 (Fédération russe, zone 4)',
	'UTC+4 (Russian Federation Zone 3)' => 'UTC+4 (Fédération russe, zone 3)',
	'UTC+3.5 (Iran)' => 'UTC+3,5 (Iran)',
	'UTC+3 (Baghdad Time/Moscow Time)' => 'UTC+3 (Bagdad/Moscou)',
	q{UTC+2 (Eastern Europe Time)} => q{UTC+2 (Europe de l'Est)},
	'UTC+1 (Central European Time)' => 'UTC+1 (Europe centrale)',
	'UTC+0 (Universal Time Coordinated)' => 'UTC+0 (Temps universel coordonné)',
	q{UTC-1 (West Africa Time)} => q{UTC-1 (Afrique de l'Ouest)},
	'UTC-2 (Azores Time)' => 'UTC-2 (Açores)',
	'UTC-3 (Atlantic Time)' => 'UTC-3 (Atlantique)',
	'UTC-3.5 (Newfoundland)' => 'UTC-3,5 (Terre-Neuve)',
	'UTC-4 (Atlantic Time)' => 'UTC-4 (Atlantique)',
	q{UTC-5 (Eastern Time)} => q{UTC-5 (Etats-Unis, heure de l'Est)},
	'UTC-6 (Central Time)' => 'UTC-6 (Etats-Unis, heure centrale)',
	'UTC-7 (Mountain Time)' => 'UTC-7 (Etats-Unis, heure des rocheuses)',
	'UTC-8 (Pacific Time)' => 'UTC-8 (Etats-Unis, heure du Pacifique)',
	'UTC-9 (Alaskan Time)' => 'UTC-9 (Alaska)',
	'UTC-10 (Aleutians-Hawaii Time)' => 'UTC-10 (Hawaii)',
	'UTC-11 (Nome Time)' => 'UTC-11 (Nome)',
	'Language' => 'Langue',
	'If you choose a different language than the default language defined at the system level, you may need to change module names in certain templates to include different global modules.' => 'Si vous choisissez une langue différente de la langue du système, vous pourriez avoir à modifier le nom de module dans certains gabarits pour inclure différents modules globaux.',
	'License' => 'Licence',
	'Your child site is currently licensed under:' => 'Votre site enfant est actuellement sous licence :',
	'Your site is currently licensed under:' => 'Votre site est actuellement sous licence :',
	'Change license' => 'Changer la licence',
	'Remove license' => 'Retirer la licence',
	q{Your child site does not have an explicit Creative Commons license.} => q{Votre site enfant n'a pas de licence Creative Commons explicite.},
	q{Your site does not have an explicit Creative Commons license.} => q{Votre site  n'a pas de licence Creative Commons explicite.},
	'Select a license' => 'Sélectionner une licence',
	'Publishing Paths' => 'Chemins de publication',
	'Use subdomain' => 'Utiliser un sous-domaine',
	q{Warning: Changing the [_1] URL can result in breaking all the links in your [_1].} => q{Attention : Modifier l'URL [_1] peut avoir pour conséquence de casser tous les liens dans votre [_1].},
	q{The URL of your child site. Exclude the filename (i.e. index.html). End with '/'. Example: http://www.example.com/blog/} => q{L'URL de votre site enfant. Exclure le nom de fichier (ex. index.html). Terminer par '/'. Exemple : http://www.example.com/blog/},
	q{The URL of your site. Exclude the filename (i.e. index.html).  End with '/'. Example: http://www.example.com/} => q{L'URL de votre site. Exclure le nom de fichier (ex. index.html). Terminer par '/'. Exemple : http://www.example.com/},
	'Use absolute path' => 'Utiliser le chemin absolu',
	'Warning: Changing the [_1] root requires a complete publish of your [_1].' => 'Attention : modifer la racine du [_1] nécessite une republication complète de votre [_1].',
	q{The path where your index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Le chemin où vos fichiers d'index seront publiés. Ne pas terminer par '/' ou '\'.  Exemple : /home/mt/public_html/blog ou C:\www\public_html\blog},
	q{The path where your index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Le chemin où vos fichiers d'index seront publiés. Un chemin absolu (commençant par '/' pour Linux ou 'C:\' pour Windows) est conseillé. Ne pas commencer par '/' ou '\'. Exemple : /home/mt/public_html ou C:\www\public_html},
	'Advanced Archive Publishing' => 'Publication avancée des archives',
	'Publish archives outside of Site Root' => 'Publier les archives en dehors de la racine du site',
	q{Archive URL} => q{URL d'archive},
	q{Warning: Changing the archive URL can result in breaking all links in your [_1].} => q{Attention : modifier l'URL de l'archive peut casser les liens de votre [_1].},
	q{The URL of the archives section of your child site. Example: http://www.example.com/blog/archives/} => q{L'URL de la section des archives de votre site enfant. Exemple : http://www.example.com/blog/archives/},
	q{The URL of the archives section of your site. Example: http://www.example.com/archives/} => q{L'URL de la section des archives de votre site. Exemple : http://www.example.com/archives/},
	q{Archive Root} => q{Racine de l'archive},
	q{Warning: Changing the archive path can result in breaking all links in your [_1].} => q{Attention : modifier le chemin de l'archive peut casser tous les liens de votre [_1].},
	q{The path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Le chemin où les fichiers d'index de votre section des archives seront publiés. Ne pas terminer par '/' ou '\''. Exemple : /home/mt/public_html/blog ou C:\www\public_html\blog},
	q{The path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Le chemin où les fichiers d'index de votre section des archives seront publiés. Un chemin absolu (commençant par '/' pour Linux ou 'C:\' pour Windows) est conseillé.  Ne pas terminer par '/' ou '\'. Exemple : /home/mt/public_html ou C:\www\public_html},
	'Dynamic Publishing Options' => 'Options de publication dynamique',
	'Enable dynamic cache' => 'Activer le cache dynamique',
	'Enable conditional retrieval' => 'Activer la récupération conditionnelle',
	q{Archive Settings} => q{Paramètres d'archive},
	'Preferred Archive' => 'Archive préférée',
	q{Choose archive type} => q{Choisir le type d'archive},
	q{No archives are active} => q{Aucune archive n'est active},
	q{Used to generate URLs (permalinks) for this child site's archived entries. Choose one of the archive types used in this child site's archive templates.} => q{Sert à générer les URLs (permaliens) pour les notes archivées de ce site enfant. Choisissez un des types d\'archives utilisés par les gabarits d\'archives de ce site enfant.},
	q{Used to generate URLs (permalinks) for this site's archived entries. Choose one of the archive types used in this site's archive templates.} => q{Sert à générer les URLs (permaliens) pour les notes archivées de ce site. Choisissez un des types d\'archives utilisés par les gabarits d\'archives de ce site.},
	'Publish With No Entries' => 'Publier sans notes',
	q{Publish category archive without entries} => q{Publier l'archive de catégorie sans notes},
	'Module Settings' => 'Paramètres du module',
	'Server Side Includes' => 'Inclusions côté serveur (SSI)',
	'None (disabled)' => 'Aucune (désactivées)',
	'PHP Includes' => 'Inclusions PHP',
	'Apache Server-Side Includes' => 'Inclusions Apache Server-Side',
	'Active Server Page Includes' => 'Inclusions Active Server Page',
	'Java Server Page Includes' => 'Inclusions Java Server Page',
	'Module Caching' => 'Cache des modules',
	q{Allow properly configured template modules to be cached to enhance publishing performance.} => q{Permettre aux modules de gabarits optimisés pour le cache d'augmenter les performances de publication.},
	'Revision History' => 'Historique de révisions',
	q{Note: Revision History is currently disabled at the system level.} => q{
	Note : l'historique de révision est actuellement désactivé au niveau système.},
	'Revision history' => 'Historique de révision',
	q{Enable revision history} => q{Activer l'historique de révision},
	'Number of revisions per entry/page' => 'Nombre de révisions par note/page',
	'Number of revisions per content data' => 'Nombre de révisions par donnée de contenu',
	'Number of revisions per template' => 'Nombres de révisions par gabarit',
	'Upload Destination' => 'Destination du fichier',
	'Allow to change at upload' => 'Permettre la modification lors du téléchargement',
	'Rename filename' => 'Renommer le fichier',
	'Rename non-ascii filename automatically' => 'Renommer le nom de fichier (avec caractères non-ASCII) automatiquement',
	'Operation if a file exists' => 'Que faire si un fichier existe',
	'Upload and rename' => 'Charger et renommer',
	'Overwrite existing file' => 'Écraser le fichier existant',
	'Cancel upload' => 'Annuler le chargement',
	q{Normalize orientation} => q{Normaliser l'orientation},
	q{Enable orientation normalization} => q{Activer la normalisation de l'orientation},
	'You must set your Child Site Name.' => 'Vous devez nommer votre site enfant.',
	'You must set your Site Name.' => 'Vous devez nommer votre site.',
	q{You did not select a time zone.} => q{Vous n'avez pas sélectionné de fuseau horaire.},
	'You must set a valid URL.' => 'Vous devez entrer une URL valide.',
	'You must set your Local file Path.' => 'Vous devez entrer un chemin de fichier local.',
	'You must set a valid Local file Path.' => 'Vous devez entrer un chemin de fichier local valide.',
	'Site root must be under [_1]' => 'La racine du site doit être dans [_1]',
	q{You must set a valid Archive URL.} => q{Vous devez renseigner une URL d'archive valide.},
	q{You must set your Local Archive Path.} => q{Vous devez spécifier votre chemin d'archive local.},
	q{You must set a valid Local Archive Path.} => q{Vous devez spécifier un chemin d'archive local valide.},
	q{Please choose a preferred archive type.} => q{Veuillez choisir le type d'archive préférée.},

## tmpl/cms/cfg_rebuild_trigger.tmpl
	'Config Rebuild Trigger' => 'Configurer le déclencheur de republication',
	'Rebuild Trigger settings has been saved.' => 'Les paramètres du déclencheur de republication ont été sauvegardés.',
	'Content Privacy' => 'Protection du contenu',
	'Use system default' => 'Utiliser la règle par défaut du système',
	'Allow' => 'Autoriser',
	'Disallow' => 'Interdire',
	'MTMultiBlog tag default arguments' => 'Arguments par défaut de la balise MTMultiBlog',
	q{Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or 'all' (include_blogs only) are acceptable values.} => q{Autorise l'utilisation de la balise MTMultiBlog sans les attributs include_blogs/exclude_blogs. Les valeurs correctes sont une liste de BlogIDs séparés par des virgules, ou 'all' (seulement pour include_blogs).},
	'Include sites/child sites' => 'Inclure des sites / sites enfants',
	'Exclude sites/child sites' => 'Exclure des sites / sites enfants',
	'Rebuild Triggers' => 'Événements de republication',
	q{You have not defined any rebuild triggers.} => q{Vous n'avez défini aucun événement de republication.},
	'When' => 'Quand',
	'Site/Child Site' => 'Site / site enfant',
	'Data' => 'Donnée',
	'Trigger' => 'Événement',
	'Action' => 'Action',
	q{Default system aggregation policy} => q{Règle d'agrégation du système par défaut},
	q{Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.} => q{L'agrégation inter-blogs sera activée par défaut. Les blogs individuels peuvent être configurés via les paramètres MultiBlog du blog en question, pour restreindre l'accès à leur contenu par les autres blogs.},
	q{Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.} => q{L'agrégation inter-blogs sera désactivée par défaut. Les blogs individuels peuvent être configurés via les paramètres MultiBlog du blog en question, pour autoriser l'accès à leur contenu par les autres blogs.},

## tmpl/cms/cfg_registration.tmpl
	'Your site preferences have been saved.' => 'Vos préférences de site ont été sauvegardées.',
	'User Registration' => 'Enregistrement utilisateur',
	'Registration Not Enabled' => 'Enregistrement non activé',
	q{Note: Registration is currently disabled at the system level.} => q{Remarque : l'enregistrement est actuellement désactivé pour tout le système.},
	q{Allow visitors to register as members of this site using one of the Authentication Methods selected below.} => q{Permettre aux visiteurs de s'enregistrer comme membres de ce site via l'une des méthodes d'authentification sélectionnée ci-dessous.},
	'New Created User' => 'Nouvel utilisateur créé',
	'Select a role that you want assigned to users that are created in the future.' => 'Sélectionnez un role que vous voulez assigner aux utilisateurs créés à partir de maintenant.',
	'(No role selected)' => '(aucun role sélectionné)',
	'Select roles' => 'Sélectionnez des rôles',
	q{Authentication Methods} => q{Méthode d'authentification},
	q{The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.} => q{Le module Perl nécessaire pour l'authentification OpenID (Digest::SHA1) est manquant.},
	q{Please select authentication methods to accept comments.} => q{Veuillez sélectionner les méthodes d'authorisation acceptées pour les commentaires.},
	q{One or more Perl modules may be missing to use this authentication method.} => q{Un ou plusieurs modules Perl manquent peut-être pour utiliser cette méthode d'authentification.},

## tmpl/cms/cfg_system_general.tmpl
	'Your settings have been saved.' => 'Vos paramètres ont été enregistrés.',
	'Imager does not support ImageQualityPng.' => 'Imager ne gère pas ImageQualityPng.',
	'A test mail was sent.' => 'Un e-mail de test a été envoyé.',
	'One or more of your sites or child sites are not following the base site path (value of BaseSitePath) restriction.' => 'Un ou plusieurs de vos sites ou sites enfants ne respectent pas la restriction de chemin de base de site (valeur de BaseSitePath).',
	'System Email Address' => 'Adresse e-mail du système',
	q{This email address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events.} => q{Cette adresse e-mail est utilisée comme celle de l'expéditeur des e-mails envoyés par Movable Type pour la récupération des mots de passe, l'enregistrement des commentateurs, les notifications de commentaires et de TrackBacks, le blocage d'un utilisateur ou d'une adresse IP, et quelques autres événements mineurs.},
	'Send Test Mail' => 'Envoyer un e-mail de test',
	'Debug Mode' => 'Mode debug',
	q{Values other than zero provide additional diagnostic information for troubleshooting problems with your Movable Type installation.  More information is available in the <a href="https://www.movabletype.org/documentation/develooper/plugins/debug-mode.html">Debug Mode documentation</a>.} => q{Une valeur non nulle fourni des informations de diagnostic additionnelles pour identifier des problèmes avec votre installation Movable Type. Plus d'information est disponible dans la <a href="https://www.movabletype.org/documentation/develooper/plugins/debug-mode.html">documentation du mode debug</a>.},
	'Performance Logging' => 'Journalisation des performances',
	'Turn on performance logging, which will report any system event that takes the number of seconds specified by Logging Threshold.' => 'Activer la journalisation des performances, qui va reporter tout événement système prenant le nombre de secondes specifié par le seuil de journalisation.',
	'Turn on performance logging' => 'Activer la journalisation des performances',
	'Log Path' => 'Chemin du journal',
	'The filesystem directory where performance logs are written.  The web server must have write permission in this directory.' => 'Le répertoire où le journal est écrit doit être ouvert en écriture pour le serveur web.',
	'Logging Threshold' => 'Seuil de journalisation',
	'The time limit for unlogged events in seconds. Any event that takes this amount of time or longer will be reported.' => 'La limite des événements non inscrits dans le journal en secondes. Tout événement prenant ce temps ou plus long sera reporté.',
	q{Track revision history} => q{Historique d'enregistrement des révisions},
	'Site Path Limitation' => 'Limitation du chemin du site',
	'Base Site Path' => 'Chemin de base du site',
	q{Allow sites to be placed only under this directory} => q{Autoriser les sites à n'être placés que sous ce répertoire},
	'System-wide Feedback Controls' => 'Contrôles de commentaires et TrackBack du système',
	'Prohibit Comments' => 'Refuser les commentaires',
	'Disable comments for all sites and child sites.' => 'Désactiver les commentaires pour tous les sites et sites enfants.',
	'Prohibit TrackBacks' => 'Refuser les TrackBacks',
	'Disable receipt of TrackBacks for all sites and child sites.' => 'Désactiver la réception des TrackBacks pour tous les sites et sites enfants.',
	'Outbound Notifications' => 'Notifications sortantes',
	'Prohibit Notification Pings' => 'Refuser les pings de notification',
	'Disable notification pings for all sites and child sites.' => 'Désactiver les pings de notification pour tous les sites et sites enfants.',
	'Send Outbound TrackBacks to' => 'Envoyer les TrackBacks sortant vers',
	q{Do not send outbound TrackBacks or use TrackBack auto-discovery if your installation is intended to be private.} => q{Ne pas envoyer de TrackBacks sortant ou utiliser la découverte automatique lorsque l'installation est censée être privée.},
	'(No Outbound TrackBacks)' => '(Pas de TrackBacks sortants)',
	'Only to child sites within this system' => 'Uniquement vers les sites enfants de ce système',
	'Only to sites on the following domains:' => 'Uniquement vers les sites sur ces domaines :',
	'Lockout Settings' => 'Paramètres de verrouillage',
	q{The system administrators whom you wish to notify if a user or an IP address is locked out.  If no administrators are selected, notifications will be sent to the 'System Email' address.} => q{Les administrateur système que vous souhaitez voir notifiés si un utilisateur ou une adresse IP est verrouillée. Si aucun des administrateurs n'est sélectioné, les notifications seront envoyées à l'adresse e-mail système.},
	'Clear' => 'Effacer',
	'(None selected)' => '(Aucune sélection)',
	'User lockout policy' => 'Politique de verrouillage des utilisateurs',
	q{A Movable Type user will be locked out if he or she submits an incorrect password [_1] or more times within [_2] seconds.} => q{Un utilisateur Movable Type sera verrouillé s'il ou elle essaye un mot de passe incorrect [_1] ou plus en moins de [_2] secondes.},
	'IP address lockout policy' => 'Politique de verrouillage des adresses IP',
	q{The list of IP addresses. If a remote IP address is included in this list, the failed login will not recorded. You can specify multiple IP addresses separated by commas or line breaks.} => q{La liste des adresses IP. Si une adresse IP distante est incluse dans cette liste, une tentative d'identification infructueuse ne sera pas enregistrée. Vous pouvez spécifier plusieurs adresses IP séparées par des virgules ou des sauts de ligne},
	q{An IP address will be locked out if [_1] or more incorrect login attempts are made within [_2] seconds from the same IP address.} => q{Une adresse IP sera verrouillée si [_1] tentatives d'identification incorrecte sont effectuées depuis cette même adresse IP en moins de [_2] secondes.},
	q{However, the following IP addresses are 'whitelisted' and will never be locked out:} => q{Cependant, les adresses IP suivantes ne seront jamais verrouillées car elles sont dans la liste blanche :},
	q{Image Quality Settings} => q{Paramètres de qualité d'image},
	q{Changing image quality} => q{Changement de qualité d'image},
	q{Enable image quality changing.} => q{Activer le changement de qualité d'image.},
	q{Image quality(JPEG)} => q{Qualité d'image (JPEG)},
	q{Image quality of uploaded JPEG image and its thumbnail. This value can be set an integer value between 0 and 100. Default value is 75.} => q{Qualité d'image JPEG téléchargée et de sa vignette. Cette valeur entière est comprise entre 0 et 100, 75 étant la valeur par défaut.},
	q{Image quality(PNG)} => q{Qualité d'image (PNG)},
	q{Image quality of uploaded PNG image and its thumbnail. This value can be set an integer value between 0 and 9. Default value is 7.} => q{Qualité d'image PNG téléchargée et de sa vignette. Cette valeur entière est comprise entre 0 et 9, 7 étant la valeur par défaut.},
	'Send Mail To' => 'Envoyer un e-mail à',
	'The email address that should receive a test email from Movable Type.' => 'Cette adresse e-mail devrait recevoir un e-mail de test de Movable Type',
	'Send' => 'Envoyer',
	'You must set a valid absolute Path.' => 'Vous devez définir un chemin absolu valide.',
	'You must set an integer value between 0 and 100.' => 'Entrez un nombre entier entre 0 et 100.',
	'You must set an integer value between 0 and 9.' => 'Entrez un nombre entier entre 0 et 9.',

## tmpl/cms/cfg_system_users.tmpl
	'Allow Registration' => 'Autoriser les enregistrements',
	q{Allow commenters to register on this system.} => q{Autoriser les commentateurs à s'enregistrer sur ce système.},
	q{Notify the following system administrators when a commenter registers:} => q{Notifier les administrateurs ci-dessous lorsqu'un commentateur s'enregistre :},
	'Select system administrators' => 'Sélectionner des administrateurs système',
	q{Note: System Email Address is not set in System > General Settings. Emails will not be sent.} => q{Note : L'adresse e-mail système n'est pas configurée dans Système > Paramètres généraux. Les e-mails ne seront donc pas envoyés.},
	'Password Validation' => 'Validation du mot de passe',
	'Options' => 'Options',
	'Should contain uppercase and lowercase letters.' => 'Doit contenir des lettres en minuscule et majuscule',
	'Should contain letters and numbers.' => 'Doit contenir des lettres et des chiffres',
	'Should contain special characters.' => 'Doit contenir des caractères spéciaux',
	'Minimum Length' => 'Longueur minimale',
	'This field must be a positive integer.' => 'Ce champ doit être un entier positif.',
	'New User Defaults' => 'Paramètres par défaut pour les nouveaux utilisateurs',
	'Default User Language' => 'Langue par défaut',
	'Default Time Zone' => 'Fuseau horaire par défaut',
	'Default Tag Delimiter' => 'Délimiteur de tags par défaut',
	'Comma' => 'Virgule',
	'Space' => 'Espace',

## tmpl/cms/cfg_web_services.tmpl
	q{Data API Settings} => q{Paramètres de l'API Data},
	'Data API' => 'API Data',
	q{Enable Data API in this site.} => q{Activer l'API Data pour ce site.},
	q{Enable Data API in system scope.} => q{Activer l'API Data au niveau système.},
	'External Notifications' => 'Notifications externes',
	'Notify ping services of [_1] updates' => 'Notifier les services de ping des mises à jour de [_1]',
	'Note: This option is currently ignored because outbound notification pings are disabled system-wide.' => 'Note : cette option est actuellement ignorée parce que les notifications sortantes sont désactivés au niveau du système.',
	'Others:' => 'Autres :',
	'(Separate URLs with a carriage return.)' => '(Séparer les URLs avec un retour chariot.)',

## tmpl/cms/content_data/select_edit.tmpl

## tmpl/cms/content_data/select_list.tmpl
	'Select List Content Type' => 'Sélectionner un type de contenu liste',
	'No Content Type.' => 'Pas de type de contenu',

## tmpl/cms/content_field_type_options/asset_audio.tmpl
	'Allow users to select multiple assets?' => 'Autoriser les utilisateurs à sélectionner plusieurs éléments ?',
	'Minimum number of selections' => 'Nombre minimal de sélections',
	'Maximum number of selections' => 'Nombre maximal de sélections',
	'Allow users to upload a new audio asset?' => 'Autoriser les utilisateurs à télécharger un nouvel élément audio ?',

## tmpl/cms/content_field_type_options/asset_image.tmpl
	'Allow users to select multiple image assets?' => 'Autoriser les utilisateurs à sélectionner plusieurs éléments image ?',
	'Allow users to upload a new image asset?' => 'Autoriser les utilisateurs à télécharger un nouvel élément image ?',

## tmpl/cms/content_field_type_options/asset.tmpl
	'Allow users to upload a new asset?' => 'Autoriser les utilisateurs à télécharger un nouvel élément ?',

## tmpl/cms/content_field_type_options/asset_video.tmpl
	'Allow users to select multiple video assets?' => 'Autoriser les utilisateurs à sélectionner plusieurs éléments vidéo ?',
	'Allow users to upload a new video asset?' => 'Autoriser les utilisateurs à télécharger un nouvel élément vidéo ?',

## tmpl/cms/content_field_type_options/categories.tmpl
	'Allow users to select multiple categories?' => 'Autoriser les utilisateurs à sélectionner plusieurs catégories ?',
	'Allow users to create new categories?' => 'Autoriser les utilisateurs à créer de nouvelles catégories ?',
	'Source Category Set' => 'Groupe de catégories source',
	q{There is no content type that can be selected. Please create new content type if you use Content Type field type.} => q{Aucun type de contenu sélectionnable. Veuillez créer un type de contenu afin d'utiliser le type de champ de type de contenu.},

## tmpl/cms/content_field_type_options/checkboxes.tmpl
	'Values' => 'Valeurs',
	'Selected' => 'Sélectionné',
	'Value' => 'Valeur',
	'add' => 'Ajouter',

## tmpl/cms/content_field_type_options/content_type.tmpl
	'Allow users to select multiple values?' => 'Autoriser les utilisateurs à sélectionner plusieurs valeurs ?',
	'Source Content Type' => 'Type de contenu source',
	q{There is no content type that can be selected. Please create a content type if you use the Content Type field type.} => q{Aucun type de contenu n'est sélectionnable. Veuillez créer un type de contenu si vous voulez utiliser le champ de type de contenu.},

## tmpl/cms/content_field_type_options/date_time.tmpl
	'Initial Value (Date)' => 'Valeur initiale (date)',
	'Initial Value (Time)' => 'Valeur initiale (heure)',

## tmpl/cms/content_field_type_options/date.tmpl
	'Initial Value' => 'Valeur initiale',

## tmpl/cms/content_field_type_options/embedded_text.tmpl

## tmpl/cms/content_field_type_options/multi_line_text.tmpl
	q{Input format} => q{Format d'entrée},

## tmpl/cms/content_field_type_options/number.tmpl
	'Min Value' => 'Valeur min',
	'Max Value' => 'Valeur max',
	'Number of decimal places' => 'Nombre de décimales après la virgule',

## tmpl/cms/content_field_type_options/radio_button.tmpl

## tmpl/cms/content_field_type_options/select_box.tmpl

## tmpl/cms/content_field_type_options/single_line_text.tmpl
	'Min Length' => 'Longueur min',
	'Max Length' => 'Longueur max',

## tmpl/cms/content_field_type_options/tables.tmpl
	'Initial Rows' => 'Rangées initiales',
	'Initial Cols' => 'Colonnes initiales',
	'Allow users to increase/decrease rows?' => 'Autoriser les utilisateurs à augmenter/réduire les rangées ?',
	'Allow users to increase/decrease cols?' => 'Autoriser les utilisateurs à augmenter/réduire les colonnes ?',

## tmpl/cms/content_field_type_options/tags.tmpl
	'Allow users to input multiple values?' => 'Autoriser les utilisateurs à entrer de multiples valeurs ?',
	'Allow users to create new tags?' => 'Autoriser les utilisateurs à créer de nouveaus tags ?',

## tmpl/cms/content_field_type_options/time.tmpl

## tmpl/cms/content_field_type_options/url.tmpl

## tmpl/cms/dashboard/dashboard.tmpl
	q{System Overview} => q{Vue d'ensemble},
	'Dashboard' => 'Tableau de bord',
	'Select a Widget...' => 'Sélectionner un widget...',
	'Your Dashboard has been updated.' => 'Votre tableau de bord a été mis à jour.',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Confirm Publishing Configuration' => 'Confirmer la configuration de publication',
	'Site Path' => 'Chemin du site',
	'Please choose parent site.' => 'Choisissez un site parent.',
	q{Enter the new URL of your public child site. End with '/'. Example: http://www.example.com/blog/} => q{Entrez la nouvelle URL de votre site enfant public. Terminez par '/'. Exemple : http://www.example.com/blog/},
	q{Enter the new path where your main index file will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Entrez un nouveau chemin où votre fichier d'index sera localisé. Ne pas commencer par '/' ou '\'.  Exemple : /home/mt/public_html/blog ou C:\www\public_html\blog},
	q{Enter the new path where your main index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Entrez un nouveau chemin où votre fichier d'index sera localisé. Un chemin absolu (commençant par '/' pour Linux ou 'C:\' pour Windows) is conseillé.  Ne pas terminer par '/' ou '\'. Exemple : /home/mt/public_html ou C:\www\public_html},
	'Enter the new URL of the archives section of your child site. Example: http://www.example.com/blog/archives/' => 'Entrez la nouvelle URL des archives de votre site enfant. Exemple : http://www.example.com/blog/archives/',
	q{Enter the new path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Entrer le nouveau chemin où vos fichiers d'index de la section des archives seront publiés. Ne pas terminer par '/' ou '\'. Exemple : /home/mt/public_html/blog ou C:\www\public_html\blog},
	q{Enter the new path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Entrer le nouveau chemin où vos fichiers d'index de la section des archives seront publiés. Un chemin absolu (commençant par '/' pour Linux ou 'C:\' pour Windows) is conseillé.  Ne pas terminer par '/' ou '\'. Exemple : /home/mt/public_html ou C:\www\public_html},
	'Continue (s)' => 'Continuer (s)',
	'Back (b)' => 'Retour (b)',
	'You must set a valid Site URL.' => 'Vous devez spécifier une URL valide.',
	'You must set a valid local site path.' => 'Vous devez spécifier un chemin local de site valide.',
	'You must select a parent site.' => 'Vous devez sélectionner un site parent.',

## tmpl/cms/dialog/asset_edit.tmpl
	'Edit Asset' => 'Éditer les éléments',
	'Your edited image has been saved.' => 'Votre image éditée a été sauvegardée.',
	q{Metadata cannot be updated because Metadata in this image seems to be broken.} => q{Les métadonnées ne peuvent être mises à jour car celles présentes dans l'image semblent erronées.},
	'Error creating thumbnail file.' => 'Erreur à la création du fichier de la vignette.',
	q{File Size} => q{Taille de l'image},
	q{Edit Image} => q{Éditer l'image},
	'Save changes to this asset (s)' => 'Enregistrer les modifications de cet élément (s)',
	'Close (x)' => 'Fermer (x)',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to close this dialog?' => 'Les modifications en cours sur cet élément seront perdues. Voulez-vous vraiment fermer ce formulaire ?',
	'Your changes have been saved.' => 'Les modifications ont été enregistrées.',
	'An error occurred.' => 'Une erreur est survenue.',

## tmpl/cms/dialog/asset_field_insert.tmpl

## tmpl/cms/dialog/asset_insert.tmpl

## tmpl/cms/dialog/asset_modal.tmpl
	'Add Assets' => 'Ajouter un élément',
	'Choose Asset' => 'Choisir un élément',
	'Library' => 'Bibliothèque',
	'Next (s)' => 'Suivant (s)',
	'Insert (s)' => 'Insérer (s)',
	'Insert' => 'Insérer',
	'Cancel (x)' => 'Annuler (x)',

## tmpl/cms/dialog/asset_options.tmpl
	'File Options' => 'Options fichier',
	q{Create entry using this uploaded file} => q{Créer une note à l'aide de ce fichier},
	'Create a new entry using this uploaded file.' => 'Créer une nouvelle note avec ce fichier envoyé.',
	'Finish (s)' => 'Terminer (s)',
	'Finish' => 'Terminer',

## tmpl/cms/dialog/asset_replace.tmpl

## tmpl/cms/dialog/asset_upload.tmpl
	'You need to configure your blog.' => 'Vous devez configurer votre blog.',
	q{Your blog has not been published.} => q{Votre blog n'a pas été publié.},

## tmpl/cms/dialog/clone_blog.tmpl
	'Child Site Details' => 'Détails du site enfant',
	q{This is set to the same URL as the original child site.} => q{Ceci est identique à l'URL du site enfant original.},
	'This will overwrite the original child site.' => 'Ceci va écraser le site enfant original.',
	'Exclusions' => 'Exclusions',
	'Exclude Entries/Pages' => 'Exclure les notes/pages',
	'Exclude Comments' => 'Exclure les commentaires',
	'Exclude Trackbacks' => 'Exclure les TrackBacks',
	'Exclude Categories/Folders' => 'Exclure les catégories/répertoires',
	'Clone' => 'Dupliquer',
	q{Warning: Changing the archive URL can result in breaking all links in your child site.} => q{Attention : modifier l'URL des archives peut casser tous les liens de votre site enfant.},
	'Warning: Changing the archive path can result in breaking all links in your child site.' => 'Attention : modifier le chemin des archives peut casser tous les liens de votre site enfant.',
	'Entries/Pages' => 'Notes/Pages',
	'Categories/Folders' => 'Catégories/Répertoires',
	'Confirm' => 'Confirmer',

## tmpl/cms/dialog/comment_reply.tmpl
	'On [_1], [_2] commented on [_3]' => 'Le [_1], [_2] a commenté sur [_3]',
	'Your reply:' => 'Votre réponse :',
	'Submit reply (s)' => 'Envoyer la réponse (s)',

## tmpl/cms/dialog/content_data_modal.tmpl
	'Add [_1]' => 'Ajouter [_1]',
	'Choose [_1]' => 'Choisir [_1]',
	'Create and Insert' => 'Créer et insérer',

## tmpl/cms/dialog/create_association.tmpl
	q{No roles exist in this installation. [_1]Create a role</a>} => q{Aucun rôle n'existe dans cette installation. [_1]Créer un rôle</a>},
	q{No groups exist in this installation. [_1]Create a group</a>} => q{Aucun groupe n'existe dans cette installation. [_1]Créer un groupe</a>},
	q{No users exist in this installation. [_1]Create a user</a>} => q{Aucun utilisateur n'existe dans cette installation. [_1]Créer un utilisateur</a>},
	q{No blogs exist in this installation. [_1]Create a blog</a>} => q{Aucun blog n'existe dans cette installation. [_1]Créer un blog</a>},
	'all' => 'toutes',

## tmpl/cms/dialog/create_trigger_select_site.tmpl

## tmpl/cms/dialog/create_trigger.tmpl
	'IF <span class="badge source-data-badge">Data</span> in <span class="badge source-site-badge">Site</span> is <span class="badge source-trigger-badge">Triggered</span>, <span class="badge destination-action-badge">Action</span> in <span class="badge destination-site-badge">Site</span>' => 'IF <span class="badge source-data-badge">une donnée</span> dans <span class="badge source-site-badge">le site</span> est <span class="badge source-trigger-badge">déclenchée</span>, <span class="badge destination-action-badge">agir</span> sur <span class="badge destination-site-badge">le site</span>',
	q{Select Trigger Object} => q{Sélectionner l'objet déclencheur},
	q{Object Name} => q{Nom de l'objet},
	q{Select Trigger Event} => q{Sélectionner l'événement déclencheur},
	'Event' => 'Événement',
	q{Select Trigger Action} => q{Sélectionner l'action déclencheuse},
	'OK (s)' => 'OK (s)',
	'OK' => 'OK',

## tmpl/cms/dialog/dialog_select_group_user.tmpl

## tmpl/cms/dialog/edit_image.tmpl
	'Width' => 'Largeur',
	'Height' => 'Hauteur',
	q{Keep aspect ratio} => q{Conserver le ratio d'aspect},
	'Remove All metadata' => 'Supprimer toutes les métadonnées',
	'Remove GPS metadata' => 'Supprimer les métadonnées GPS',
	'Rotate right' => 'Pivoter à droite',
	'Rotate left' => 'Pivoter à gauche',
	'Flip horizontal' => 'Inverser horizontalement',
	'Flip vertical' => 'Inverser verticalement',
	'Crop' => 'Retailler',
	'Undo' => 'Annuler',
	'Redo' => 'Refaire',
	'Save (s)' => 'Enregistrer (s)',
	'You have unsaved changes to this image that will be lost. Are you sure you want to close this dialog?' => 'Les modifications apportées à cette image seront perdues. Voulez-vous vraiment fermer cette fenêtre ?',

## tmpl/cms/dialog/entry_notify.tmpl
	'Send a Notification' => 'Envoyer une notification',
	'You must specify at least one recipient.' => 'Vos devez définir au moins un destinataire.',
	q{Your [_1]'s name, title, and a link to view it will be sent in the notification. Additionally, you can add a message, include an excerpt and/or send the entire body.} => q{Votre nom de [_1], titre et un lien pour le voir seront envoyés dans la notification. De plus, vous pouvez ajouter un message, inclure un extrait et/ou envoyer le contenu en entier.},
	'Recipients' => 'Destinataires',
	'Enter email addresses on separate lines or separated by commas.' => 'Entrez les adresses e-mail, une sur chaque ligne ou séparées par des virgules.',
	q{All addresses from Address Book} => q{Toutes les adresses du carnet d'adresses},
	'Optional Message' => 'Message optionnel',
	'Optional Content' => 'Contenu optionnel',
	'(Body will be sent without any text formatting applied.)' => '(Le contenu sera envoyé sans aucun formattage).',
	'Send notification (s)' => 'Envoyer la notification (s)',

## tmpl/cms/dialog/list_revision.tmpl
	q{Select the revision to populate the values of the Edit screen.} => q{Sélectionner la révision à utiliser pour remplir les champs de l'éditeur.},

## tmpl/cms/dialog/move_blogs.tmpl
	q{Warning: You need to copy uploaded assets to the new path manually. It is also recommended not to delete files in the old path to avoid broken links.} => q{Attention : Vous devez copier les éléments envoyés vers le nouveau chemin manuellement. Il est également recommendé de ne pas supprimer les anciens fichiers afin d'éviter les liens morts.},

## tmpl/cms/dialog/multi_asset_options.tmpl
	q{Insert Options} => q{Options d'insertion},
	'Display [_1]' => 'Afficher [_1]',

## tmpl/cms/dialog/new_password.tmpl
	'Change Password' => 'Changer le mot de passe',
	'Enter the new password.' => 'Saisissez le nouveau mot de passe.',
	'New Password' => 'Nouveau mot de passe',
	'Confirm New Password' => 'Confirmer le nouveau mot de passe',
	'Change' => 'Modifier',

## tmpl/cms/dialog/publishing_profile.tmpl
	'Publishing Profile' => 'Profil de publication',
	'child site' => 'Site enfant',
	'site' => 'Site',
	'Choose the profile that best matches the requirements for this [_1].' => 'Choisir le profil qui correspond le mieux aux besoins de ce [_1].',
	'Static Publishing' => 'Publication statique',
	'Immediately publish all templates statically.' => 'Publier immédiatement tous les gabarits de manière statique.',
	'Background Publishing' => 'Publication en arrière-plan',
	q{All templates published statically via Publish Queue.} => q{Tous les gabarits publiés statiquement via la file d'attente.},
	'High Priority Static Publishing' => 'Publication statique prioritaire',
	q{Immediately publish Main Index template, Entry archives, and Page archives statically. Use Publish Queue to publish all other templates statically.} => q{Publier immédiatement les gabarits d'index et d'archives individuelles de notes et pages en statique. Utiliser une publication en mode file d'attente pour tout le reste.},
	q{Immediately publish Main Index template, Page archives statically. Use Publish Queue to publish all other templates statically.} => q{Publier immédiatement les gabarits d'index et d'archives individuelles en statique. Utiliser une publication en mode file d'attente pour tout le reste.},
	'Dynamic Publishing' => 'Publication dynamique',
	'Publish all templates dynamically.' => 'Publier tous les gabarits en dynamique',
	'Dynamic Archives Only' => 'Archives dynamiques uniquement',
	q{Publish all Archive templates dynamically. Immediately publish all other templates statically.} => q{Publier tous les gabarits d'archives individuelles en dynamique. Publier immédiatement tous les autres gabarits en statique.},
	'This new publishing profile will update your publishing settings.' => 'Ce nouveau profil de publication va mettre à jour vos paramètres de publication.',
	'Are you sure you wish to continue?' => 'Voulez-vous vraiment continuer ?',

## tmpl/cms/dialog/recover.tmpl
	'Reset Password' => 'Réinitialiser le mot de passe',
	q{The email address provided is not unique.  Please enter your username.} => q{L'adresse e-mail fournie n'est pas unique. Merci de saisir votre nom d'utilisateur.},
	'Back (x)' => 'Retour',
	'Sign in to Movable Type (s)' => 'Connectez-vous sur Movable Type (s)',
	'Sign in to Movable Type' => 'Connectez-vous sur Movable Type',
	q{Username} => q{Nom d'utilisateur},
	'Reset (s)' => 'Réinitialiser (s)',

## tmpl/cms/dialog/refresh_templates.tmpl
	'Refresh Global Templates' => 'Mettre à jour les gabarits globaux',
	'Cannot find template set. Please apply [_1]theme[_2] to refresh your templates.' => 'Impossible de trouver le groupe de gabarits. Veuillez appliquer [_1]theme[_2] pour mettre à jour vos gabarits.',
	'Revert modifications of theme templates' => 'Annuler les modifications des gabarits de thème',
	q{Reset to theme defaults} => q{Réinitialiser les thèmes comme à l'origine},
	q{Deletes all existing templates and install the selected theme's default.} => q{Supprimer tous les gabarits existants et installer les gabarits par défaut pour les thèmes sélectionnés.},
	'Refresh global templates' => 'Mettre à jour les gabarits globaux',
	'Reset to factory defaults' => 'Remettre à zéro les modifications',
	'Deletes all existing templates and installs factory default template set.' => 'Supprime tous les gabarits existants et installe les groupes de gabarits par défaut.',
	q{Updates current templates while retaining any user-created templates.} => q{Met à jour les gabarits courants tout en conservant les gabarits créés par l'utilisateur.},
	q{Make backups of existing templates first} => q{Faire d'abord des sauvegardes des gabarits existants},
	'You have requested to <strong>refresh the current template set</strong>. This action will:' => 'Vous avez demandé à <strong>réactualiser le groupe de gabarit actuel</strong>. Cette action va :',
	'You have requested to <strong>refresh the global templates</strong>. This action will:' => 'Vous avez demandé à <strong>rafraîchir les gabarits globaux</strong>. Cette action va :',
	'make backups of your templates that can be accessed through your backup filter' => 'faire des copies de sauvegarde de vos gabarits qui pourront être accessibles via votre filtre de sauvegarde',
	'potentially install new templates' => 'potentiellement installer de nouveaux gabarits',
	'overwrite some existing templates with new template code' => 'remplacer le code de certains gabarits par un nouveau code',
	q{You have requested to <strong>apply a new template set</strong>. This action will:} => q{Vous avez demandé d'<strong>appliquer un nouveau groupe de gabarits</strong>. Cette action va :},
	'You have requested to <strong>reset to the default global templates</strong>. This action will:' => 'Vous avez demandé à <strong>rétablir les gabarits globaux par défaut</strong>. Cette action va :',
	'delete all of the templates in your blog' => 'supprimer tous les gabarits de votre blog',
	'install new templates from the selected template set' => 'installer de nouveaux gabarits depuis le groupe de gabarits sélectionné',
	'delete all of your global templates' => 'supprimer tous vos gabarits globaux',
	'install new templates from the default global templates' => 'installer de nouveaux gabarits issus des gabarits globaux par défaut',

## tmpl/cms/dialog/restore_end.tmpl
	q{An error occurred during the import process: [_1] Please check your import file.} => q{Une erreur est survenue lors de l'import : [_1]. Veuillez vérifier le fichier importé.},
	q{View Activity Log (v)} => q{Voir le journal d'activité (v)},
	q{View Activity Log} => q{Afficher le journal d'activité},
	'All data imported successfully!' => 'Toutes les données ont été importées avec succès !',
	'Close (s)' => 'Fermer (s)',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => 'Cette page va être redirigée vers une nouvelle page dans 3 secondes. [_1]Arrêter la redirection.[_2]',
	'Next Page' => 'Page suivante',

## tmpl/cms/dialog/restore_start.tmpl
	'Importing...' => 'Importation...',

## tmpl/cms/dialog/restore_upload.tmpl
	'Restore: Multiple Files' => 'Restauration : plusieurs fichiers',
	q{Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?} => q{L'annulation de la procédure va créer des objets orphelins.  Voulez-vous vraiment annuler l'opération de restauration ?},
	'Please upload the file [_1]' => 'Veuillez télécharger le fichier [_1]',

## tmpl/cms/dialog/select_association_type.tmpl
	q{Grant site permission to user} => q{Accorder une autorisation sur site à l'utilisateur},
	'Grant site permission to group' => 'Accorder une autorisation sur site au groupe',

## tmpl/cms/dialog/start_create_trigger.tmpl
	q{You must select Object Type.} => q{Vous devez sélectionner un type d'objet.},
	'You must select Content Type.' => 'Vous devez sélectionner un type de contenu.',
	'You must select Event.' => 'Vous devez sélectionner un événement.',
	q{Object Type} => q{Type d'objet},

## tmpl/cms/dialog/theme_element_detail.tmpl

## tmpl/cms/edit_asset.tmpl
	'Stats' => 'Stats',
	'[_1] - Created by [_2]' => '[_1] - a été créé par [_2]',
	'[_1] - Modified by [_2]' => '[_1] - modifié par [_2]',
	'Appears in...' => 'Apparaît dans...',
	q{This asset has been used by other users.} => q{Cet élément a été utilisé par d'autres utilisateurs.},
	'Related Assets' => 'Éléments liés',
	'Prev' => 'Précédent',
	'[_1] is missing' => '[_1] est manquant',
	q{Embed Asset} => q{Adresse pour embarquer l'élément},
	q{You must specify a name for the asset.} => q{Vous devez spécifier un nom pour l'élément.},
	'You have unsaved changes to this asset that will be lost.' => 'Des modifications en cours sur cet élément seront perdues.',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to edit image?' => 'Les modifications en cours sur cet élément seront perdues. Voulez-vous vraiment éditer cette image ?',

## tmpl/cms/edit_author.tmpl
	'Edit Profile' => 'Éditer le profil',
	q{Email Address is required for password reset.} => q{L'adresse e-mail est requise pour la réinitialisation du mot de passe},
	'This profile has been updated.' => 'Ce profil a été mis à jour.',
	q{A new password has been generated and sent to the email address [_1].} => q{Un nouveau mot de passe a été créé et envoyé à l'adresse [_1].},
	'This profile has been unlocked.' => 'Ce profil á été déverrouillé.',
	'This user was classified as pending.' => 'Cet utilisateur a été marqué comme en attente.',
	'This user was classified as disabled.' => 'Cet utilisateur a été marqué comme désactivé.',
	'This user was locked out.' => 'Cet utilisateur a été verrouillé.',
	q{If you want to unlock this user click the 'Unlock' link. <a href="[_1]">Unlock</a>} => q{Si vous souhaitez déverrouiller cet utilisateur, cliquez sur le lien 'Déverrouiller'. <a href="[_1]">Déverrouiller</a>},
	q{User properties} => q{Propriétés de l'utilisateur},
	'Your web services password is currently' => 'Votre mot de passe des services web est actuellement',
	'_WARNING_PASSWORD_RESET_SINGLE' => 'Vous êtes sur le point de réinitialiser le mot de passe pour "[_1]". Un nouveau mot de passe sera généré aléatoirement et envoyé directement à leur adresse e-mail ([_2]). Voulez-vous continuer ?',
	q{Error occurred while removing userpic.} => q{Une erreur est survenue lors du retrait de l'avatar.},
	'_USER_STATUS_CAPTION' => 'Statut',
	'_USER_ENABLED' => 'Utilisateur activé',
	'_USER_PENDING' => 'Utilisateur en attente',
	'_USER_DISABLED' => 'Utilisateur désactivé',
	'External user ID' => 'ID utilisateur externe',
	'The name displayed when content from this user is published.' => 'Le nom affiché lorsque le contenu de cet utilisateur est publié.',
	q{This User's website (e.g. https://www.movabletype.com/).  If the Website URL and Display Name fields are both populated, Movable Type will by default publish entries and comments with bylines linked to this URL.} => q{Le site web de cet utilisateur. Si le site web et le nom affiché sont tous les deux remplis, Movable Type publiera par défaut les notes et commentaires avec un lien vers cette URL.},
	q{Userpic} => q{Image de l'utilisateur},
	q{Select Userpic} => q{Sélectionner l'image de l'utilisateur},
	q{Remove Userpic} => q{Supprimer l'image de l'utilisateur},
	'Current Password' => 'Mot de passe actuel',
	'Initial Password' => 'Mot de passe *',
	'Enter preferred password.' => 'Saisissez le mot de passe préféré.',
	'Confirm Password' => 'Confirmation du mot de passe',
	'Password recovery word/phrase' => 'Indice de récupération du mot de passe',
	'Preferences' => 'Préférences',
	q{Display language for the Movable Type interface.} => q{Langue d'affichage pour l'interface Movable Type.},
	'Text Format' => 'Format du texte',
	q{Default text formatting filter when creating new entries and new pages.} => q{Filtres de mise en forme par défaut lors de la création d'une nouvelle note ou page},
	'(Use Site Default)' => '(Utiliser la préférence du site par défaut)',
	'Date Format' => 'Format de date',
	q{Default date formatting in the Movable Type interface.} => q{Le format de date par défaut dans l'interface Movable Type.},
	'Relative' => 'Relative',
	'Full' => 'Entière',
	'Tag Delimiter' => 'Délimiteur de tags',
	'Preferred method of separating tags.' => 'Méthode préférée pour séparer les tags.',
	'Web Services Password' => 'Mot de passe des services web',
	'Reveal' => 'Révéler',
	'System Permissions' => 'Autorisations système',
	q{Create User (s)} => q{Créer l'utilisateur (s)},
	'Save changes to this author (s)' => 'Enregistrer les modifications de cet auteur (s)',
	'_USAGE_PASSWORD_RESET' => 'Ci-dessous, vous pouvez réinitialiser le mot de passe pour cet utilisateur. Si vous faites cela un mot de passe généré aléatoirement sera créé et envoyé par e-mail à : [_1].',
	'Initiate Password Recovery' => 'Récupérer le mot de passe',
	'You must use half-width character for password.' => 'Vous devez utiliser des caractères de demi-largeur pour le mot de passe.',

## tmpl/cms/edit_blog.tmpl
	'Your child site configuration has been saved.' => 'La configuration de votre site enfant a été sauvegardée.',
	'You must set your Local Site Path.' => 'Vous devez configurer le chemin local de votre site.',
	'Site Theme' => 'Thème du site',
	'Select the theme you wish to use for this child site.' => 'Sélectionnez le thème que vous voulez utiliser pour ce site enfant.',
	'Name your child site. The site name can be changed at any time.' => 'Nommez votre site enfant. Ce nom peut être modifié ultèrieurement.',
	q{Enter the URL of your Child Site. Exclude the filename (i.e. index.html). Example: http://www.example.com/blog/} => q{Entrez l'URL de votre site enfant. Exclure le nom de fichier (ex. index.html). Exemple : http://www.example.com/blog/},
	q{The path where your index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Le chemin où vos fichiers d'index seront situés. Un chemin absolu (commençant par '/' pour Linux ou 'C:\' pour Windows) est conseillé. Ne pas terminer par '/' ou '\'. Exemple : /home/mt/public_html ou C:\www\public_html},
	q{The path where your index files will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Le chemin où vos fichiers d'index seront situés. Ne pas terminer par '/' ou '\'.  Exemple : /home/mt/public_html/blog ou C:\www\public_html\blog},
	'Select your timezone from the pulldown menu.' => 'Veuillez sélectionner votre fuseau horaire dans la liste.',
	'Create Child Site (s)' => 'Créer un site enfant (s)',

## tmpl/cms/edit_category.tmpl
	'Edit Category' => 'Éditer les catégories',
	'Useful links' => 'Liens utiles',
	'Manage entries in this category' => 'Gérer les notes dans cette catégorie',
	'You must specify a label for the category.' => 'Vous devez spécifier un label pour cette catégorie.',
	'You must specify a basename for the category.' => 'Vous devez spécifier un nom de base pour cette catégorie.',
	'Please enter a valid basename.' => 'Veuillez entrer un nom de base valide.',
	'_CATEGORY_BASENAME' => 'Nom de base',
	'This is the basename assigned to your category.' => 'Ceci est le nom de base assigné à votre catégorie.',
	q{Warning: Changing this category's basename may break inbound links.} => q{Attention : changer le nom de base de la catégorie risque de casser des liens entrants.},
	'Inbound TrackBacks' => 'TrackBacks entrants',
	'Allow pings' => 'Autoriser les pings',
	'View TrackBacks' => 'Voir les TrackBacks',
	'TrackBack URL for this category' => 'URL de TrackBack pour cette catégorie',
	'Passphrase Protection' => 'Protection par une phrase',
	'Outbound TrackBacks' => 'TrackBacks sortants',
	'Trackback URLs' => 'URLs de TrackBack',
	'Save changes to this category (s)' => 'Enregistrer les modifications de cette catégorie (s)',

## tmpl/cms/edit_commenter.tmpl
	'Commenter Details' => 'Détails sur le commentateur',
	'The commenter has been trusted.' => 'Le commentateur est fiable.',
	'The commenter has been banned.' => 'Le commentateur a été banni.',
	'Comments from [_1]' => 'Commentaires de [_1]',
	'commenter' => 'le commentateur',
	'commenters' => 'Commentateurs',
	'to act upon' => 'pour agir sur',
	'Trust user (t)' => 'Donner le statut fiable à cet utilisateur (t)',
	'Trust' => 'Fiable',
	'Untrust user (t)' => 'Donner le statut non fiable à cet utilisateur (t)',
	'Untrust' => 'Non fiable',
	'Ban user (b)' => 'Bannir cet utilisateur (t)',
	'Ban' => 'Bannir',
	'Unban user (b)' => 'Annuler le bannissement de cet utilisateur (t)',
	'Unban' => 'Non banni',
	'View all comments with this name' => 'Afficher tous les commentaires associés à ce nom',
	'Identity' => 'Identité',
	'View' => 'Voir',
	'Withheld' => 'Retenu',
	'View all comments with this email address' => 'Afficher tous les commentaires associés à cette adresse e-mail',
	'Trusted' => 'Fiable',
	'Banned' => 'Banni',
	'Authenticated' => 'Authentifié',

## tmpl/cms/edit_comment.tmpl
	'Edit Comment' => 'Éditer le commentaire',
	'The comment has been approved.' => 'Ce commentaire a été approuvé.',
	'This comment was classified as spam.' => 'Ce commentaire a été marqué comme spam',
	'Total Feedback Rating: [_1]' => 'Note globale de feedback : [_1]',
	'Test' => 'Test',
	'Score' => 'Score',
	'Results' => 'Résultats',
	'Save changes to this comment (s)' => 'Enregistrer les modifications de ce commentaire (s)',
	'comment' => 'commentaire',
	'comments' => 'commentaires',
	'Delete this comment (x)' => 'Supprimer ce commentaire (x)',
	'Manage Comments' => 'Gérer les commentaires',
	'_external_link_target' => '_blank',
	'View [_1] comment was left on' => 'Voir la [_1] qui a reçu ce commentaire',
	'Reply to this comment' => 'Répondre à ce commentaire',
	'Approved' => 'Approuvé',
	'Unapproved' => 'Non-approuvé',
	'Reported as Spam' => 'Notifié comme spam',
	'View all comments with this status' => 'Voir tous les commentaires avec ce statut',
	'Commenter' => 'Commentateur',
	'View all comments by this commenter' => 'Afficher tous les commentaires de ce commentateur',
	'Commenter Status' => 'Status du commentateur',
	'View this commenter detail' => 'Voir les détails du commentateur',
	'Untrust Commenter' => 'Considérer le commentateur comme pas sûr',
	'Ban Commenter' => 'Bannir le commentateur',
	'Trust Commenter' => 'Considérer le commentateur comme fiable',
	'Unban Commenter' => 'Lever le bannissement du commentateur',
	'Unavailable for OpenID user' => 'Non disponible pour les utilisateurs OpenID',
	q{No url in profile} => q{Pas d'URL dans le profil},
	'View all comments with this URL' => 'Afficher tous les commentaires associés à cette URL',
	q{[_1] no longer exists} => q{[_1] n'existe plus},
	'View all comments on this [_1]' => 'Voir tous les commentaires sur cette [_1]',
	'View all comments created on this day' => 'Voir tous les commentaires créés ce jour',
	'View all comments from this IP Address' => 'Afficher tous les commentaires associés à cette adresse IP',
	'Comment Text' => 'Texte du commentaire',
	'Responses to this comment' => 'Réponses à ce commentaire',

## tmpl/cms/edit_content_data.tmpl
	'You have successfully recovered your saved content data.' => 'Vous avez recouvré avec succès les données de contenu sauvegardées.',
	'A saved version of this content data was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'Une version de ces données de contenu a été automatiquement sauvegardée [_2]. <a href="[_1]" class="alert-link">Récupérer le contenu automatiquement sauvegardé</a>',
	'An error occurred while trying to recover your saved content data.' => 'Une erreur est survenue en tentant de récupérer vos données de contenu sauvegardées.',
	'This [_1] has been saved.' => 'Ce [_1] a été sauvegardé.',
	'<a href="[_1]" >Create another [_2]?</a>' => '<a href="[_1]" >Créer un autre [_2]?</a>',
	'Revision: <strong>[_1]</strong>' => 'Révision : <strong>[_1]</strong>',
	'View revisions of this [_1]' => 'Voir les révisions de ce [_1]',
	'View revisions' => 'Voir les révisions',
	q{No revision(s) associated with this [_1]} => q{Aucune révision n'est associée à ce [_1]},
	'Publish this [_1]' => 'Publier cette [_1]',
	'Draft this [_1]' => 'Mettre cette [_1] en brouillon',
	'Schedule' => 'Planifier',
	'Update' => 'Mettre à jour',
	'Update this [_1]' => 'Mettre à jour cette [_1]',
	'Unpublish this [_1]' => 'Dépublier cette [_1]',
	'Save this [_1]' => 'Enregistrer cette [_1]',
	'You must configure this blog before you can publish this content data.' => 'Vous devez configurer ce blog avant de pouvoir publier ces données de contenu.',
	'Unpublished (Draft)' => 'Non publiée (Brouillon)',
	'Unpublished (Review)' => 'Non publiée (Vérification)',
	'Unpublished (Spam)' => 'Non publié (spam)',
	'Publish On' => 'Publiée le',
	'Published Time' => 'Heure de publication',
	'Unpublished Date' => 'Date de dépublication',
	'Unpublished Time' => 'Heure de dépublication',
	'Warning: If you set the basename manually, it may conflict with another content data.' => 'Attention : si vous changez le nom de base manuellement, cela peut créer un conflit avec une autre donnée de contenu.',
	q{Warning: Changing this content data's basename may break inbound links.} => q{Attention : changer le nom de base de cette donnée de contenu peut casser les liens entrants.},
	'Change note' => 'Commentaire sur la modification',
	'You must configure this blog before you can publish this entry.' => 'Vous devez configurer ce blog avant de publier cette note.',
	'You must configure this blog before you can publish this page.' => 'Vous devez configurer ce blog avant de publier cette page.',
	'Permalink:' => 'Lien permanent :',
	'Enter a label to identify this data' => 'Entrez un label pour identifier cette donnée',
	'(Min length: [_1] / Max length: [_2])' => '(Longueur min : [_1] / Longueur max : [_2])',
	'(Min length: [_1])' => '(Longueur min : [_1])',
	'(Max length: [_1])' => '(Longueur max : [_1])',
	'(Min: [_1] / Max: [_2] / Number of decimal places: [_3])' => '(Min : [_1] / Max : [_2] / Nombre de décimales : [_3])',
	'(Min: [_1] / Max: [_2])' => '(Min : [_1] / Max : [_2])',
	'(Min: [_1] / Number of decimal places: [_2])' => '(Min : [_1] / Nombre de décimales : [_2])',
	'(Min: [_1])' => '(Min : [_1])',
	'(Max: [_1] / Number of decimal places: [_2])' => '(Max : [_1] / Nombre de décimales : [_2])',
	'(Max: [_1])' => '(Max : [_1])',
	'(Number of decimal places: [_1])' => '(Nombre de décimales : [_1])',
	'(Min select: [_1] / Max select: [_2])' => '(Sélection min : [_1] / Sélection max : [_2])',
	'(Min select: [_1])' => '(Sélection min : [_1])',
	'(Max select: [_1])' => '(Sélection max : [_1])',
	'(Min tags: [_1] / Max tags: [_2])' => '(Tags min : [_1] / Tags max : [_2])',
	'(Min tags: [_1])' => '(Tags min : [_1])',
	'(Max tags: [_2])' => '(Tags max : [_2])',
	'One tag only' => 'Un seul tag',
	'@' => '@',
	'Not specified' => 'Non spécifiée',
	'Auto-saving...' => 'Sauvegarde automatique...',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Dernière sauvegarde automatique à [_1] : [_2] : [_3]',

## tmpl/cms/edit_content_type.tmpl
	'Edit Content Type' => 'Éditer le type de contenu',
	'Contents type settings has been saved.' => 'Les paramètres de type de contenu ont été sauvegardés.',
	q{Some content fields were not deleted. You need to delete archive mapping for the content field first.} => q{Certains champs de contenu n'ont pu être supprimés. Vous devez d'abord supprimer la correspondance d'archive du champ de contenu.},
	'Available Content Fields' => 'Champs de contenu disponibles',
	'Unavailable Content Fields' => 'Champs de contenu indisponibles',
	'Reason' => 'Raison',
	'1 or more label-value pairs are required' => 'Au moins une paire label/valeur est requise',
	'This field must be unique in this content type' => 'Ce champ doit être unique dans ce type de contenu',

## tmpl/cms/edit_entry_batch.tmpl
	'Save these [_1] (s)' => 'Sauvegarder ces [_1] (s)',

## tmpl/cms/edit_entry.tmpl
	'Edit Page' => 'Éditer une page',
	'Create Page' => 'Créer une page',
	'Add new folder parent' => 'Ajouter un nouveau répertoire parent',
	'Preview this page (v)' => 'Prévisualiser cette page (v)',
	'Delete this page (x)' => 'Supprimer cette page (x)',
	'View Page' => 'Afficher une Page',
	'Edit Entry' => 'Éditer une note',
	'Create Entry' => 'Créer une nouvelle note',
	'Category Name' => 'Nom de la catégorie',
	'Add new category parent' => 'Ajouter une nouvelle catégorie parente',
	'Manage Entries' => 'Gérer les notes',
	'Preview this entry (v)' => 'Prévisualiser cette note (v)',
	'Delete this entry (x)' => 'Supprimer cette note (x)',
	'View Entry' => 'Afficher la note',
	'A saved version of this entry was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'Une version de cette note a été automatiquement sauvegardée [_2]. <a href="[_1]" class="alert-link">Récupérer le contenu sauvegardé automatiquement</a>',
	'A saved version of this page was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'Une version de cette page a été automatiquement sauvegardée [_2]. <a href="[_1]" class="alert-link">Récupérer le contenu sauvegardé automatiquement</a>',
	'This entry has been saved.' => 'Cette note a été enregistrée.',
	'This page has been saved.' => 'Cette page a été enregistrée.',
	q{One or more errors occurred when sending update pings or TrackBacks.} => q{Erreur lors de l'envoi des pings ou des TrackBacks.},
	q{_USAGE_VIEW_LOG} => q{L'erreur est enregistrée dans le <a href="[_1]">journal d\'activité</a>.},
	'Your customization preferences have been saved, and are visible in the form below.' => 'Vos préférences ont été enregistrées et sont affichées dans le formulaire ci-dessous.',
	'Your changes to the comment have been saved.' => 'Les modifications apportées aux commentaires ont été enregistrées.',
	'Your notification has been sent.' => 'Votre notification a été envoyée.',
	'You have successfully recovered your saved entry.' => 'Vous avez récupéré le contenu sauvegardé de votre note avec succès.',
	'You have successfully recovered your saved page.' => 'Vous avez récupéré le contenu sauvegardé de votre page avec succès.',
	'An error occurred while trying to recover your saved entry.' => 'Une erreur est survenue lors de la tentative de récupération de la note enregistrée.',
	'An error occurred while trying to recover your saved page.' => 'Une erreur est survenue lors de la tentative de récupération de la page enregistrée.',
	'You have successfully deleted the checked comment(s).' => 'Les commentaires sélectionnés ont été supprimés.',
	'You have successfully deleted the checked TrackBack(s).' => 'Le ou les TrackBacks sélectionnés ont été correctement supprimés.',
	'Restored revision (Date:[_1]).  The current status is: [_2]' => 'Révision (date : [_1]) restaurée. Le statut actuel est : [_2].',
	'Some of tags in the revision could not be loaded because they have been removed.' => 'Certains tags dans cette révision ne peuvent pas être chargés car ils ont été retirés.',
	'Some [_1] in the revision could not be loaded because they have been removed.' => 'Certain(e)s [_1] dans cette révision ne peuvent pas être chargées car elles ont été retirées.',
	'This post was held for review, due to spam filtering.' => 'Cette note a été retenue pour vérification, à cause du filtrage spam.',
	'This post was classified as spam.' => 'Cette note a été marquée comme étant du spam.',
	'Add folder' => 'Ajouter un répertoire',
	'Change Folder' => 'Modifier le dossier',
	q{Warning: If you set the basename manually, it may conflict with another entry.} => q{Attention : éditer le nom de base manuellement peut créer des conflits avec d'autres notes.},
	q{Warning: Changing this entry's basename may break inbound links.} => q{Attention : changer le nom de base de cette note peut casser des liens entrants.},
	'Add category' => 'Ajouter une catégorie',
	'edit' => 'éditer',
	'Accept' => 'Accepter',
	'<a href="[_2]">[_1]</a>' => '<a href="[_2]">[_1]</a>',
	'View Previously Sent TrackBacks' => 'Voir les TrackBacks envoyés précédemment',
	'Outbound TrackBack URLs' => 'URLs des TrackBacks sortants',
	'[_1] Assets' => 'Éléments de la [_1]',
	'Add Entry Asset' => 'Ajouter un élément de note',
	'No assets' => 'Aucun élément',
	q{You have unsaved changes to this entry that will be lost.} => q{Certains de vos changements dans cette note n'ont pas été enregistrés, ils seront perdus.},
	q{You have unsaved changes to this page that will be lost.} => q{Certains de vos changements dans cette page n'ont pas été enregistrés, ils seront perdus.},
	q{Enter email address:} => q{Saisissez l'adresse e-mail :},
	q{Enter the link address:} => q{Saisissez l'adresse du lien :},
	'Enter the text to link to:' => 'Saisissez le texte du lien :',
	'Converting to rich text may result in changes to your current document.' => 'Convertir en texte riche peut entraîner des modifications au document actuel.',
	'Make primary' => 'Rendre principal',
	'Fields' => 'Champs',
	q{Reset display options to blog defaults} => q{Réinitialiser les options d'affichage avec les valeurs par défaut du blog},
	'Draggable' => 'Glissable',
	'Share' => 'Partager',
	'Format:' => 'Format :',
	'Rich Text(HTML mode)' => 'Text enrichi (mode HTML)', # Translate - New
	'(comma-delimited list)' => '(liste délimitée par virgule)',
	'(space-delimited list)' => '(liste délimitée par espace)',
	q{(delimited by '[_1]')} => q{(délimitée par '[_1]')},
	'None selected' => 'Aucune sélectionnée',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Modifier le répertoire',
	'Manage Folders' => 'Gérer les répertoires',
	'Manage pages in this folder' => 'Gérer les pages de ce dossier',
	'You must specify a label for the folder.' => 'Vous devez spécifier un nom pour le répertoire.',
	'Path' => 'Chemin',
	'Save changes to this folder (s)' => 'Enregistrer les modifications de ce répertoire (s)',

## tmpl/cms/edit_group.tmpl
	'Edit Group' => 'Modifier le groupe',
	'This group profile has been updated.' => 'Ce profil de groupe a été mis à jour.',
	'This group was classified as pending.' => 'Ce groupe a été classé comme en attente.',
	'This group was classified as disabled.' => 'Ce groupe a été classé comme désactivé.',
	'Member ([_1])' => 'Membre ([_1])',
	'Members ([_1])' => 'Membres ([_1])',
	'Permission ([_1])' => 'Permission ([_1])',
	'Permissions ([_1])' => 'Permissions ([_1])',
	'LDAP Group ID' => 'Group ID LDAP',
	q{The LDAP directory ID for this group.} => q{L'ID de l'annuaire LDAP pour ce groupe.},
	q{Status of this group in the system. Disabling a group prohibits its members&rsquo; from accessing the system but preserves their content and history.} => q{Le statut de ce groupe dans le système. Désactiver un groupe empêche ses membres d'accéder au système mais conserve leur contenu et leur historique.},
	'The name used for identifying this group.' => 'Le nom utilisé pour identifier ce groupe.',
	q{The display name for this group.} => q{Le nom d'affichage de ce groupe.},
	'The description for this group.' => 'La description de ce groupe.',
	'Created By' => 'Créé par',
	'Created On' => 'Créé le',
	'Save changes to this field (s)' => 'Sauvegarder les changements apportés à ce champ (s)',

## tmpl/cms/edit_ping.tmpl
	'Edit Trackback' => 'Éditer le TrackBack',
	'The TrackBack has been approved.' => 'Le TrackBack a été approuvé.',
	'This trackback was classified as spam.' => 'Ce TrackBack a été marqué comme spam.',
	'Save changes to this TrackBack (s)' => 'Enregistrer les modifications de ce TrackBack (s)',
	'Delete this TrackBack (x)' => 'Supprimer ce TrackBack (x)',
	'Manage TrackBacks' => 'Gérer les TrackBacks',
	'View all TrackBacks with this status' => 'Voir tous les TrackBacks avec ce statut',
	'Source Site' => 'Site source',
	q{Search for other TrackBacks from this site} => q{Rechercher d'autres TrackBacks de ce site},
	'Source Title' => 'Titre de la source',
	q{Search for other TrackBacks with this title} => q{Rechercher d'autres TrackBacks avec ce titre},
	q{Search for other TrackBacks with this status} => q{Rechercher d'autres TrackBacks avec ce statut},
	'Target [_1]' => 'Cible [_1]',
	q{Entry no longer exists} => q{Cette note n'existe plus},
	'No title' => 'Sans titre',
	'View all TrackBacks on this entry' => 'Voir tous les TrackBacks pour cette note',
	'Target Category' => 'Catégorie cible',
	q{Category no longer exists} => q{La catégorie n'existe plus},
	'View all TrackBacks on this category' => 'Afficher tous les TrackBacks de cette catégorie',
	'View all TrackBacks created on this day' => 'Voir tous les TrackBacks créés ce jour',
	'View all TrackBacks from this IP address' => 'Afficher tous les TrackBacks avec cette adresse IP',
	'TrackBack Text' => 'Texte du TrackBack',

## tmpl/cms/edit_role.tmpl
	'Edit Role' => 'Modifier le rôle',
	'Association (1)' => 'Association (1)',
	'Associations ([_1])' => 'Associations ([_1])',
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'Vous avez changé les privilèges pour ce rôle. Cela va modifier ce que les utilisateurs associés à ce rôle ont la possibilité de faire. Si vous préférez, vous pouvez sauvegarder ce rôle avec un nom différent.',
	'Role Details' => 'Détails du rôle',
	'Privileges' => 'Privilèges',
	'Administration' => 'Administration',
	'Authoring and Publishing' => 'Édition et Publication',
	'Designing' => 'Design',
	'Commenting' => 'Commenter',
	'Content Type Privileges' => 'Privilèges de type de contenu',
	'Duplicate Roles' => 'Dupliquer les rôles',
	'Save changes to this role (s)' => 'Enregistrer les modifications de ce rôle (s)',

## tmpl/cms/edit_template.tmpl
	'Edit Widget' => 'Éditer le widget',
	q{Create Index Template} => q{Créer un gabarit d'index},
	q{Create Entry Archive Template} => q{Créer gabarit d'archives individuelles de notes},
	'Create Entry Listing Archive Template' => 'Créer gabarit archive de liste de notes',
	q{Create Page Archive Template} => q{Créer gabarit d'archives de pages},
	q{Create Content Type Archive Template} => q{Créer gabarit d'archives de type de contenu},
	q{Create Content Type Listing Archive Template} => q{Créer gabarit d'archives de liste de type de contenu},
	'Create Template Module' => 'Créer un module de gabarit',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]" class="alert-link">Recover auto-saved content</a>' => 'Une version de ce [_1] a été automatiquement sauvegardée [_3]. <a href="[_2]" class="alert-link">Récupérer le contenu automatiquement sauvegardé</a>',
	'You have successfully recovered your saved [_1].' => 'Vous avez récupéré avec succès votre [_1] sauvegardé.',
	q{An error occurred while trying to recover your saved [_1].} => q{Une erreur s'est produite en essayant de récupérer votre [_1] sauvegardée.},
	'Restored revision (Date:[_1]).' => 'Révision restaurée (date : [_1]).',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => '<a href="[_1]" class="rebuild-link">Publier</a> ce gabarit.',
	'Your [_1] has been published.' => 'Votre [_1] a été publié.',
	'New Template' => 'Nouveau gabarit',
	'View revisions of this template' => 'Voir les révisions de ce gabarit',
	'No revision(s) associated with this template' => 'Aucune révision associée à ce gabarit',
	'Useful Links' => 'Liens utiles',
	'List [_1] templates' => 'Lister les gabarits de type [_1]',
	'List all templates' => 'Lister tous les gabarits',
	'Module Option Settings' => 'Paramètres des options de module',
	'View Published Template' => 'Voir le gabarit publié',
	'Included Templates' => 'Gabarits inclus',
	'create' => 'créer',
	q{Copy Unique ID} => q{Copier l'ID unique},
	'Content field' => 'Champ de contenu',
	'Select Content Field' => 'Sélectionner le champ de contenu',
	'Create a new Content Type?' => 'Créer un nouveau type de contenu ?',
	'Save Changes (s)' => 'Sauvegarder les modifications',
	'Save and Publish this template (r)' => 'Enregistrer et publier ce gabarit (r)',
	'Save &amp; Publish' => 'Enregistrer &amp; publier',
	q{You have unsaved changes to this template that will be lost.} => q{Certains de vos changements à ce gabarit n'ont pas été enregistrés, ils seront perdus.},
	'You must set the Template Name.' => 'Vous devez fournir un nom de gabarit.',
	'You must select the Content Type.' => 'Vous devez sélectionner le type de contenu.',
	'You must set the template Output File.' => 'Vous devez configurer le fichier de sortie du gabarit.',
	'Module Body' => 'Corps du module',
	'Template Body' => 'Corps du gabarit',
	'Code Highlight' => 'Surlignage du code',
	'Template Type' => 'Type de gabarit',
	q{Custom Index Template} => q{Gabarit d'index personnalisé},
	'Link to File' => 'Lien vers le fichier',
	'Learn more about <a href="https://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publishing settings</a>' => 'Apprennez en plus à propos des <a href="https://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">paramètres de publication</a>',
	q{Learn more about <a href="https://www.movabletype.org/documentation/appendices/archive-file-path-specifiers.html" target="_blank">Archive File Path Specifiers</a>} => q{En savoir plus sur <a href="https://www.movabletype.org/documentation/appendices/archive-file-path-specifiers.html" target="_blank">les correspondances de chemin d'archive</a>},
	'Category Field' => 'Champ catégorie',
	'Date & Time Field' => 'Champ date & heure',
	'Create Archive Mapping' => 'Créer une nouvelle table de correspondance des archives',
	'Statically (default)' => 'Statique (défaut)',
	q{Via Publish Queue} => q{Via une publication en mode file d'attente},
	'On a schedule' => 'Planifié',
	': every ' => ' : chaque ',
	'minutes' => 'minutes',
	'hours' => 'heures',
	'Dynamically' => 'Dynamique',
	'Manually' => 'Manuellement',
	'Do Not Publish' => 'Ne pas publier',
	'Server Side Include' => 'Inclusion côté serveur (SSI)',
	'Process as <strong>[_1]</strong> include' => 'Traiter comme inclusion de <strong>[_1]</strong>',
	'Include cache path' => 'Inclure le chemin du cache',
	'Disabled (<a href="[_1]">change publishing settings</a>)' => 'Désactivé (<a href="[_1]">changer les paramètres de publication</a>)',
	'No caching' => 'Pas de cache',
	'Expire after' => 'Expire après',
	'Expire upon creation or modification of:' => 'Expire lors de la création ou modification de :',
	q{Processing request...} => q{Requête en cours d'exécution...},
	q{Error occurred while updating archive maps.} => q{Une erreur s'est produite en mettant à jour les tables de correspondance des archives.},
	'Archive map has been successfully updated.' => 'La table de correspondance des archives a été modifiée avec succès.',
	'Are you sure you want to remove this template map?' => 'Voulez-vous vraiment supprimer cette table de correspondance de gabarit ?',

## tmpl/cms/edit_website.tmpl
	'Your site configuration has been saved.' => 'La configuration de votre site a été sauvegardée.',
	'Select the theme you wish to use for this site.' => 'Sélectionnez le thème à utiliser pour ce site.',
	'Name your site. The site name can be changed at any time.' => 'Nommez votre site. Ce nom peut être modifié à tout moment.',
	q{Enter the URL of your site. Exclude the filename (i.e. index.html). Example: http://www.example.com/} => q{Entrez l'URL de votre site. Exclure le nom de fichier (ex. index.html). Exemple : http://www.example.com/},
	q{Enter the path where your main index file will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/ or C:\www\public_html} => q{Entrez le chemin où vos fichiers d'index seront situés. Un chemin absolu (commençant par '/' pour Linux ou 'C:\' pour Windows) est conseillé, mais vous pouvez également utiliser un chemin relatif au répertoire Movable Type. Exemple : /home/melody/public_html/ ou C:\www\public_html},
	'Create Site (s)' => 'Créer un site (s)',
	'This field is required.' => 'Ce champ est requis.',
	'Please enter a valid URL.' => 'Veuillez entrer une URL valide.',
	'Please enter a valid site path.' => 'Veuillez entrer un chemin de site valide.',
	q{You did not select a timezone.} => q{Vous n'avez pas sélectionné de fuseau horaire.},

## tmpl/cms/edit_widget.tmpl
	'Edit Widget Set' => 'Modifier le groupe de widgets',
	'Widget Set Name' => 'Nom du groupe de widget',
	'Save changes to this widget set (s)' => 'Enregistrer les modifications de ce groupe de widgets',
	q{Drag and drop the widgets that belong in this Widget Set into the 'Installed Widgets' column.} => q{Glissez-déposez les widgets destinés à ce groupe de widgets dans la colonne 'Widgets installés'.},
	'Available Widgets' => 'Widgets disponibles',
	'Installed Widgets' => 'Widgets installés',
	'You must set Widget Set Name.' => 'Vous devez nommer ce groupe de widgets.',

## tmpl/cms/error.tmpl
	q{An error occurred} => q{Une erreur s'est produite},

## tmpl/cms/export_theme.tmpl
	q{Theme package have been saved.} => q{L'archive du thème a été enregistrée.},
	q{Use letters, numbers, dash or underscore only (a-z, A-Z, 0-9, '-' or '_').} => q{Utiliser des lettres, chiffres, tirets ou tirets bas seulement (a-z, A-Z, 0-9, '-' ou '_').},
	'Version' => 'Version',
	'_THEME_AUTHOR' => 'Auteur',
	q{Author link} => q{Site de l'auteur},
	'Destination' => 'Destination',
	'Setting for [_1]' => 'Paramètres pour [_1]',
	'Basename may only contain letters, numbers, and the dash or underscore character. The basename must begin with a letter.' => 'Le nom de base ne peut contenir que des lettres, chiffres, tirets et tirets bas. Il doit commencer par une lettre.',
	q{Cannot install new theme with existing (and protected) theme\'s basename.} => q{Impossible d'installer un nouveau thème avec un nom de base existant (et protégé).},
	'You must set Theme Name.' => 'Vous devez entrer un nom de thème',
	'Theme version may only contain letters, numbers, and the dash or underscore character.' => 'La version du thème ne peut contenir que des lettres, chiffres, tirets et tirets bas.',

## tmpl/cms/export.tmpl
	'Export [_1] Entries' => 'Exporter [_1] notes',
	'[_1] to Export' => '[_1] à exporter',
	q{_USAGE_EXPORT_1} => q{L'exportation vous permet de sauvegarder le contenu de votre blog dans un fichier. Vous pourrez par la suite procéder à l'importation de ce fichier si vous souhaitez restaurer vos notes ou transférer vos notes d'un blog à un autre.},
	'Export [_1]' => 'Exporter le [_1]',

## tmpl/cms/field_html/field_html_asset.tmpl
	'No Assets' => 'aucun élément',
	'No Asset' => 'aucun élément',
	'Assets less than or equal to [_1] must be selected' => 'Vous devez sélectionner au plus [_1] éléments',
	'Assets greater than or equal to [_1] must be selected' => 'Vous devez sélectionner au moins [_1] éléments',
	'Only 1 asset can be selected' => 'Un seul élément peut être sélectionné',

## tmpl/cms/field_html/field_html_categories.tmpl
	q{This field is disabled because valid Category Set is not selected in this field.} => q{Ce champ est désactivé car aucun groupe de catégories valide n'est sélectionné dans ce champ.},
	'Add sub category' => 'Ajouter une sous-catégorie',

## tmpl/cms/field_html/field_html_content_type.tmpl
	'No field data.' => 'Pas de champ de donnée.', # Translate - New
	'No [_1]' => 'Aucun [_1]',
	q{This field is disabled because valid Content Type is not selected in this field.} => q{Ce champ est désactivé car aucun type de contenu valide n'est sélectionné dans ce champ.},
	'[_1] less than or equal to [_2] must be selected' => 'Au plus [_2] [_1] doivent être sélectionnés',
	'[_1] greater than or equal to [_2] must be selected' => 'Au moins [_2] [_1] doivent être sélectionnés',
	'Only 1 [_1] can be selected' => 'Un seul [_1] peut être sélectionné',

## tmpl/cms/field_html/field_html_datetime.tmpl

## tmpl/cms/field_html/field_html_list.tmpl

## tmpl/cms/field_html/field_html_multi_line_text.tmpl

## tmpl/cms/field_html/field_html_select_box.tmpl
	'Not Selected' => 'Non sélectionné',

## tmpl/cms/import_others.tmpl
	'Start title HTML (optional)' => 'HTML de début de titre (optionnel)',
	'End title HTML (optional)' => 'HTML de fin du titre (optionnel)',
	'Default entry status (optional)' => 'Statut des notes par défaut (optionnel)',
	'Select an entry status' => 'Sélectionner un statut de note',

## tmpl/cms/import.tmpl
	'Import [_1] Entries' => 'Importer [_1] notes',
	'You must select a site to import.' => 'Vous devez sélectionner un site à importer.',
	'Enter a default password for new users.' => 'Entrez un mot de passe par défaut pour les nouveaux utilisateurs.',
	q{Transfer site entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.} => q{Transférez des entrées de site entre installations Movable Type ou même d'autres moteurs de blog, ou exportez vos entrées dans une copie de sauvegarde.},
	'Import data into' => 'Importer les données dans',
	'Select site' => 'Choisir un site',
	'Importing from' => 'Importation à partir de',
	'Ownership of imported entries' => 'Propriétaire des notes importées',
	'Import as me' => 'Importer en me considérant comme auteur',
	q{Preserve original user} => q{Préserver l'utilisateur original},
	q{If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.} => q{Si vous choisissez de garder les auteurs originaux des notes importées et qu'ils doivent être créés dans votre installation, vous devez définir un mot de passe par défaut pour ces nouveaux comptes.},
	'Default password for new users:' => 'Mot de passe par défaut pour un nouvel utilisateur :',
	q{You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.} => q{Vous serez désigné comme auteur pour toutes les notes importées. Si vous voulez que l'auteur original en conserve la propriété, vous devez contacter votre administrateur MT pour qu'il fasse l'importation et le cas échéant qu'il crée un nouvel utilisateur.},
	q{Upload import file (optional)} => q{Envoyer le fichier d'import (optionnel)},
	'Apply this formatting if text format is not set on each entry.' => 'Appliquer ce format si le format de texte est indéfini sur chaque note.',
	q{Import File Encoding} => q{Encodage du fichier d'import},
	'<mt:var name="display_name" escape="html">' => '<mt:var name="display_name" escape="html">',
	'Default category for entries (optional)' => 'Catégorie par défaut pour les notes (optionnel)',
	'Select a category' => 'Sélectionnez une catégorie',
	'Import Entries (s)' => 'Importer les notes (s)',
	'Import Entries' => 'Importer des notes',

## tmpl/cms/include/anonymous_comment.tmpl
	'Allow comments from anonymous or unauthenticated users.' => 'Permettre les commentaires anonymes pour les utilisateurs non identifiés.',
	'Require name and E-mail Address for Anonymous Comments' => 'Nécessite une adresse e-mail pour les commentaires anonymes',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Si activé, le visiteur doit donner une adresse e-mail valide pour commenter.',

## tmpl/cms/include/archetype_editor_multi.tmpl
	'Decrease Text Size' => 'Diminuer la taille du texte',
	'Increase Text Size' => 'Augmenter la taille du texte',
	'Bold' => 'Gras',
	'Italic' => 'Italique',
	'Underline' => 'Souligné',
	'Email Link' => 'Lien e-mail',
	'Begin Blockquote' => 'Ajouter un bloc de citation',
	'End Blockquote' => 'Retirer un bloc de citation',
	'Bulleted List' => 'Liste à puces',
	'Numbered List' => 'Liste numérotée',
	q{Left Align Item} => q{Aligner l'élément à gauche},
	q{Center Item} => q{Centrer l'élément},
	q{Right Align Item} => q{Aligner l'élément à droite},
	'Left Align Text' => 'Aligner le texte à gauche',
	'Center Text' => 'Centrer le texte',
	'Right Align Text' => 'Aligner le texte à droite',
	'Insert Image' => 'Insérer une image',
	'Insert File' => 'Insérer un fichier',
	'WYSIWYG Mode' => 'Mode WYSIWYG',
	'HTML Mode' => 'Mode HTML',

## tmpl/cms/include/archetype_editor.tmpl
	'Text Color' => 'Couleur du texte',
	q{Check Spelling} => q{Vérifier l'orthographe},

## tmpl/cms/include/archive_maps.tmpl
	'Collapse' => 'Réduire',

## tmpl/cms/include/asset_replace.tmpl
	q{A file named '[_1]' already exists. Do you want to overwrite this file?} => q{Un fichier nommé '[_1]' existe déjà. Souhaitez-vous le remplacer ?},
	'Yes (s)' => 'Oui (s)',
	'Yes' => 'Oui',
	'No' => 'Non',

## tmpl/cms/include/asset_table.tmpl
	'Delete selected assets (x)' => 'Effacer les contenus sélectionnés (x)',
	'Size' => 'Taille',
	'Asset Missing' => 'Élément manquant',
	'No thumbnail image' => 'Pas de miniature',

## tmpl/cms/include/asset_upload.tmpl
	q{Before you can upload a file, you need to publish your [_1]. [_2]Configure your [_1]'s publishing paths[_3] and republish your [_1].} => q{Avant de pouvoir télécharger un fichier, vous devez publier votre [_1]. [_2]Configurez les chemins de publication[_3] de votre [_1] et republiez-le.},
	'Your system or [_1] administrator needs to publish the [_1] before you can upload files. Please contact your system or [_1] administrator.' => '
	Votre administrateur système ou de [_1] a besoin de publier le [_1] avant que vous puissiez télécharger des fichiers. Veuillez contacter votre administrateur système ou de [_1].',
	q{Cannot write to '[_1]'. Image upload is possible, but thumbnail is not created.} => q{Impossible d'écrire sur '[_1]'. L'envoi d'image est possible mais la vignette ne sera pas créée.},
	q{Asset file('[_1]') has been uploaded.} => q{Le fichier de l'élément ('[_1]') a été envoyé.},
	'Select File to Upload' => 'Sélectionnez le fichier à télécharger',
	q{_USAGE_UPLOAD} => q{Vous pouvez télécharger le fichier ci-dessus dans le chemin local de votre site. Vous pouvez également télécharger le fichier dans un répertoire compris dans les répertoires mentionnés ci-dessus, en spécifiant le chemin dans le champ de droite (<i>images</i>, par exemple). Les répertoires qui n'existent pas encore seront créés.},
	'Choose Folder' => 'Choisir le répertoire',
	'Upload (s)' => 'Envoyer (s)',
	'[_1] contains a character that is invalid when used in a directory name: [_2]' => '[_1] contient un caractère invalide pour un nom de répertoire : [_2]',

## tmpl/cms/include/async_asset_list.tmpl
	q{Asset Type: } => q{Type d'élément : },
	'All Types' => 'Tous les types',
	'label' => 'étiquette',
	'[_1] - [_2] of [_3]' => '[_1] - [_2] sur [_3]',

## tmpl/cms/include/async_asset_upload.tmpl
	'Choose files to upload or drag files.' => 'Choisissez ou glissez les fichiers à télécharger.',
	'Choose file to upload or drag file.' => 'Choisissez ou glissez le fichier à télécharger.',
	'Choose files to upload.' => 'Choisissez des fichiers à télécharger.', # Translate - New
	'Choose file to upload.' => 'Choisissez un fichier à télécharger.', # Translate - New
	'Upload Settings' => 'Paramètres de téléchargement', # Translate - New
	'Upload Options' => 'Options de téléchargement',
	'Operation for a file exists' => 'Que faire si un fichier existe',
	'Drag and drop here' => 'Glissez et déposez ici',
	'Cancelled: [_1]' => 'Annulé : [_1]',
	'The file you tried to upload is too large: [_1]' => 'Le fichier que vous tentez de charger est trop volumineux : [_1]',
	'[_1] is not a valid [_2] file.' => '[_1] n\'est pas un fichier [_2] valide.',

## tmpl/cms/include/author_table.tmpl
	'Enable selected users (e)' => 'Activer les utilisateurs sélectionnés (e)',
	'_USER_ENABLE' => 'Activer',
	'Disable selected users (d)' => 'Désactiver les utilisateurs sélectionnés (d)',
	'_USER_DISABLE' => 'Désactiver',
	'user' => 'utilisateur',
	'users' => 'utilisateurs',
	'_NO_SUPERUSER_DISABLE' => 'Puisque vous êtes administrateur du système Movable Type, vous ne pouvez vous désactiver vous-même.',

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been exported successfully!' => 'Toutes les données ont été sauvegardées avec succès !',
	'_BACKUP_TEMPDIR_WARNING' => 'Les données demandées ont été sauvegardées avec succès dans le répertoire [_1]. Assurez-vous que vous téléchargez  <strong>puis supprimez</ strong> les fichiers mentionnés ci-dessus à partir de [_1] <strong>immédiatement</ strong> car les fichiers de sauvegarde contiennent des informations sensibles.',
	'Export Files' => 'Exporter les fichiers',
	'Download This File' => 'Télécharger ce fichier',
	'Download: [_1]' => 'Télécharger : [_1]',
	q{_BACKUP_DOWNLOAD_MESSAGE} => q{Le téléchargement du fichier de sauvegarde démarre automatiquement en quelques secondes. Si ce n'est pas le cas, <a href="javascript:(void)" onclick="submit_form()">cliquez  ici</ a> pour commencer à télécharger manuellement. Notez que vous pouvez télécharger le fichier de sauvegarde une seule fois par session.},
	q{An error occurred during the export process: [_1]} => q{Une erreur est survenue lors de l'export : [_1]},

## tmpl/cms/include/backup_start.tmpl
	'Exporting Movable Type' => 'Export de Movable Type',

## tmpl/cms/include/basic_filter_forms.tmpl
	'contains' => 'contient',
	'does not contain' => 'ne contient pas',
	'__STRING_FILTER_EQUAL' => 'est',
	'starts with' => 'commence par',
	'ends with' => 'se termine par',
	'[_1] [_2] [_3]' => '[_1] [_2] [_3]',
	'is blank' => 'est vide',
	q{is not blank} => q{n'est pas vide},
	'__INTEGER_FILTER_EQUAL' => 'est',
	'__INTEGER_FILTER_NOT_EQUAL' => 'est',
	'is greater than' => 'est plus grand que',
	'is greater than or equal to' => 'est plus grand ou égal à',
	'is less than' => 'est plus petit que',
	'is less than or equal to' => 'est plus petit ou égal à',
	'is between' => 'est entre',
	'is within the last' => 'est dans les derniers',
	'is before' => 'est avant',
	'is after' => 'est après',
	'is after now' => 'est après maintenant',
	'is before now' => 'est avant maintenant',
	'__FILTER_DATE_ORIGIN' => '[_1]',
	'[_1] and [_2]' => '[_1] et [_2]',
	'_FILTER_DATE_DAYS' => '[_1] jours',
	'__TIME_FILTER_HOURS' => 'est dans les dernières',
	'[_1] hours' => '[_1] heures',

## tmpl/cms/include/blog_table.tmpl
	q{Some templates were not refreshed.} => q{Certains gabarits n'ont pas été mis à jour.},
	q{Some sites were not deleted. You need to delete child sites under the site first.} => q{Certains sites n'ont pas été supprimés. Vous devez d'abord supprimer leurs sites enfants.},
	'Delete selected [_1] (x)' => 'Supprimer le(s) [_1] sélectionné(s) (x)',
	'[_1] Name' => 'Nom [_1]',

## tmpl/cms/include/breadcrumbs.tmpl

## tmpl/cms/include/category_selector.tmpl
	'Add sub folder' => 'Ajouter un sous-dossier',

## tmpl/cms/include/comment_detail.tmpl

## tmpl/cms/include/commenter_table.tmpl
	'Last Commented' => 'Dernier commenté',
	'Edit this commenter' => 'Éditer ce commentateur',
	'View this commenter&rsquo;s profile' => 'Voir le profil de ce commentateur',

## tmpl/cms/include/comment_table.tmpl
	'Publish selected comments (a)' => 'Publier les commentaires sélectionnés (a)',
	'Delete selected comments (x)' => 'Supprimer les commentaires sélectionnés (x)',
	'Edit this comment' => 'Éditer ce commentaire',
	'Reply' => 'Répondre',
	'([quant,_1,reply,replies])' => '([quant,_1,réponse,réponses])',
	'Blocked' => 'Bloqués',
	'Edit this [_1] commenter' => 'Modifier le commentateur de cette [_1]',
	'Search for comments by this commenter' => 'Chercher les commentaires de ce commentateur',
	'Anonymous' => 'Anonyme',
	'View this entry' => 'Voir cette note',
	'View this page' => 'Voir cette page',
	'Search for all comments from this IP address' => 'Rechercher tous les commentaires associés à cette adresse IP',
	'to republish' => 'pour republier',

## tmpl/cms/include/content_data_list.tmpl

## tmpl/cms/include/content_data_table.tmpl
	'Republish selected [_1] (r)' => 'Republier les [_1] sélectionné(e)s (r)',
	'Created' => 'Créé',
	'View Content Data' => 'Voir la donnée de contenu',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001 Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001 Six Apart. Tous droits réservés.',

## tmpl/cms/include/debug_hover.tmpl
	q{Hide Toolbar} => q{Cacher la barre d'outils},
	'Hide &raquo;' => 'Cacher &raquo;',

## tmpl/cms/include/debug_toolbar/cache.tmpl
	'Key' => 'Clé',

## tmpl/cms/include/debug_toolbar/headers.tmpl

## tmpl/cms/include/debug_toolbar/requestvars.tmpl
	'Cookies' => 'Cookies',
	'Variable' => 'Variable',
	'No COOKIE data' => 'Pas de données COOKIE',
	q{Input Parameters} => q{Paramètres d'entrée},
	q{No Input Parameters} => q{Pas de paramètres d'entrée},

## tmpl/cms/include/debug_toolbar/sql.tmpl

## tmpl/cms/include/debug_toolbar/vcs.tmpl

## tmpl/cms/include/display_options.tmpl

## tmpl/cms/include/entry_table.tmpl
	'Last Modified' => 'Dernière modification',
	'View entry' => 'Afficher une note',
	'View page' => 'Afficher une page',
	q{No entries could be found.} => q{Aucune note n'a été trouvée.},
	'<a href="[_1]" class="alert-link">Create an entry</a> now.' => '<a href="[_1]" class="alert-link">Créer une entrée</a> maintenant.',
	q{No pages could be found. <a href="[_1]" class="alert-link">Create a page</a> now.} => q{Aucune page n'a été trouvée. <a href="[_1]" class="alert-link">Créer une page</a> maintenant.},

## tmpl/cms/include/feed_link.tmpl
	q{Activity Feed} => q{Flux d'activité},
	'Set Web Services Password' => 'Définir un mot de passe pour les services web',

## tmpl/cms/include/footer.tmpl
	'DEVELOPER PREVIEW' => 'VERSION DEVELOPPEUR',
	'This is a alpha version of Movable Type and is not recommended for production use.' => 'Ceci est une version alpha de Movable Type non recommandée pour la production.',
	'BETA' => 'beta',
	q{This is a beta version of Movable Type and is not recommended for production use.} => q{Ceci est une version beta de Movable Type et n'est pas recommandée pour une utilisation en production.},
	'https://www.movabletype.org' => 'https://www.movabletype.org/',
	'MovableType.org' => 'MovableType.org',
	'https://plugins.movabletype.org/' => 'https://plugins.movabletype.org/',
	'Support' => 'Support',
	'https://forums.movabletype.org/' => 'https://forums.movabletype.org/',
	'Forums' => 'Forums',
	'Send Us Feedback' => 'Faites-nous part de vos remarques',
	'<a href="[_1]"><mt:var name="mt_product_name"></a> [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> [_2]',
	'with' => 'avec',

## tmpl/cms/include/group_table.tmpl
	'Enable selected group (e)' => 'Activer le groupe sélectionné (e)',
	'Disable selected group (d)' => 'Désactiver le groupe sélectionné (d)',
	'group' => 'groupe',
	'groups' => 'Groupes',
	'Remove selected group (d)' => 'Supprimer le groupe sélectionné (d)',

## tmpl/cms/include/header.tmpl
	'Help' => 'Aide',
	'Search (q)' => 'Recherche (q)',
	'Search [_1]' => 'Rechercher [_1]',
	'Select an action' => 'Sélectionner une action',
	q{This website was created during the upgrade from a previous version of Movable Type. 'Site Root' and 'Site URL' are left blank to retain 'Publishing Paths' compatibility for blogs that were created in a previous version. You can post and publish on existing blogs, but you cannot publish this website itself because of the blank 'Site Root' and 'Site URL'.} => q{
	Ce site a été créé durant une mise à jour d'une version précédente de Movable Type. 'Racine du site' et 'URL du site' sont laissés en blanc afin de garder la compatibilité des 'Chemins de publication' pour les blogs créés dans une version précédente. Vous pouvez poster et publier sur les blogs existants mais vous ne pouvez pas publier ce site en lui-même car 'Racine du site' et 'URL du site' sont laissés en blanc.},
	q{from Revision History} => q{depuis l'historique de révision},

## tmpl/cms/include/import_end.tmpl
	'<a href="#" onclick="[_1]" class="mt-build">Publish your site</a> to see these changes take effect.' => '<a href="#" onclick="[_1]" class="mt-build">Publiez votre site</a> pour appliquer ces modifications en ligne.',
	q{Make sure that you remove the files that you imported from the 'import' folder, so that if/when you run the import process again, those files will not be re-imported.} => q{Assurez vous d'avoir bien enlevé les fichiers importés du répertoire 'import', pour éviter une ré-importation des mêmes fichiers à l'avenir.},
	q{An error occurred during the import process: [_1]. Please check your import file.} => q{Une erreur s'est produite pendant le processus: [_1]. Merci de vérifier le fichier d'import.},

## tmpl/cms/include/import_start.tmpl
	'Importing entries into [_1]' => 'Importation de notes dans le [_1]',
	q{Importing entries as user '[_1]'} => q{Importation des notes en tant qu'utilisateur '[_1]'},
	'Creating new users for each user found in the [_1]' => 'Création de nouveaux utilisateur correspondant à chaque utilisateur trouvé dans le [_1]',

## tmpl/cms/include/insert_options_image.tmpl

## tmpl/cms/include/itemset_action_widget.tmpl
	q{More actions...} => q{Plus d'actions...},
	'Go' => 'OK',

## tmpl/cms/include/listing_panel.tmpl
	'Step [_1] of [_2]' => 'Étape [_1] sur [_2]',
	'Go to [_1]' => 'Aller à [_1]',
	q{Sorry, there were no results for your search. Please try searching again.} => q{Désolé, aucun résultat trouvé pour cette recherche. Merci d'essayer à nouveau.},
	q{Sorry, there is no data for this object set.} => q{Désolé, il n'y a pas de données pour cet ensemble d'objets.},

## tmpl/cms/include/login_mt.tmpl
	'Remember me?' => 'Mémoriser mes informations de connexion ?',

## tmpl/cms/include/log_table.tmpl
	q{No log records could be found.} => q{Aucune donnée du journal n'a été trouvée.},
	'_LOG_TABLE_BY' => 'Utilisateur',
	'IP: [_1]' => 'IP : [_1]',

## tmpl/cms/include/member_table.tmpl
	q{Are you sure you want to remove the selected user from this [_1]?} => q{Voulez-vous vraiment retirer l'utilisateur sélectionné de ce [_1] ?},
	'Are you sure you want to remove the [_1] selected users from this [_2]?' => 'Voulez-vous vraiment retirer les [_1] utilisateurs sélectionnés de ce [_2] ?',
	'Remove selected user(s) (r)' => 'Retirer le ou les utilisateurs sélectionnés (r)',
	'Remove this role' => 'Retirer ce rôle',

## tmpl/cms/include/mobile_global_menu.tmpl
	'Select another site...' => 'Sélectionner un autre site...',
	'Select another child site...' => 'Sélectionner un autre site enfant...',
	'PC View' => 'Vue PC', # Translate - New

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Ajouté(e)',
	'Save changes' => 'Enregistrer les modifications',

## tmpl/cms/include/old_footer.tmpl
	'https://wiki.movabletype.org/' => 'https://wiki.movabletype.org/',
	'Wiki' => 'Wiki',
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]',
	q{_LOCALE_CALENDAR_HEADER_} => q{'D', 'L', 'M', 'M', 'J', 'V', 'S'},
	'Your Dashboard' => 'Votre tableau de bord',

## tmpl/cms/include/pagination.tmpl
	'First' => 'Premier',
	'Last' => 'Dernier',

## tmpl/cms/include/ping_table.tmpl
	'Publish selected [_1] (p)' => 'Publier le(s) [_1] sélectionné(s) (p)',
	'From' => 'De',
	'Target' => 'Cible',
	'Moderated' => 'Modéré',
	'Edit this TrackBack' => 'Modifier ce TrackBack',
	q{Go to the source entry of this TrackBack} => q{Aller à la note à l'origine de ce TrackBack},
	'View the [_1] for this TrackBack' => 'Voir [_1] pour ce TrackBack',

## tmpl/cms/include/primary_navigation.tmpl
	'Open Panel' => 'Ouvrir le panneau',
	'Open Site Menu' => 'Ouvrir le menu du site',
	'Close Site Menu' => 'Fermer le menu du site',

## tmpl/cms/include/revision_table.tmpl
	q{No revisions could be found.} => q{Aucune révision n'a été trouvée.},
	'_REVISION_DATE_' => 'Date',
	'Note' => 'Note',
	'Saved By' => 'Enregistré par',

## tmpl/cms/include/rpt_log_table.tmpl
	'Schwartz Message' => 'Message Schwartz',

## tmpl/cms/include/scope_selector.tmpl
	q{User Dashboard} => q{Tableau de bord de l'utilisateur},
	'Websites' => 'Sites web',
	'Select another website...' => 'Sélectionner un autre site web...',
	'(on [_1])' => '(sur [_1])',
	'Select another blog...' => 'Sélectionner un autre blog...',
	'Create Website' => 'Créer un site web',
	'Create Blog (on [_1])' => 'Créer un blog (sur [_1])',

## tmpl/cms/include/status_widget.tmpl
	'[_1] - Published by [_2]' => '[_1] - a été publié par [_2]',
	'[_1] - Edited by [_2]' => '[_1] - a été édité par [_2]',

## tmpl/cms/include/template_table.tmpl
	q{No content type could be found.} => q{Aucun type de contenu n'a été trouvé.},
	q{Create Archive Template:} => q{Créer un gabarit d'archives},
	'Publish selected templates (a)' => 'Publier les gabarits sélectionnés (a)',
	q{Archive Path} => q{Chemin d'archive},
	'SSI' => 'SSI',
	'Cached' => 'Caché',
	'Manual' => 'Manuellement',
	'Dynamic' => 'Dynamique',
	q{Publish Queue} => q{Publication en mode file d'attente},
	'Static' => 'Statique',
	'Uncached' => 'Non caché',
	'templates' => 'gabarits',
	'to publish' => 'pour publier',

## tmpl/cms/include/theme_exporters/category_set.tmpl

## tmpl/cms/include/theme_exporters/category.tmpl

## tmpl/cms/include/theme_exporters/content_type.tmpl

## tmpl/cms/include/theme_exporters/folder.tmpl
	'Folder Name' => 'Nom du répertoire',
	'<mt:if name="is_blog">Blog URL<mt:else>Site URL</mt:if>' => '<mt:if name="is_blog">URL du blog<mt:else>URL du site</mt:if>',

## tmpl/cms/include/theme_exporters/static_files.tmpl
	'In the specified directories, files of the following types will be included in the theme: [_1]. Other file types will be ignored.' => 'Dans les répertoires spécifiés, les fichiers des types suivant seront inclus dans le thème : [_1]. Les autres seront ignorés.',
	'Specify directories' => 'Spécifier les répertoires',
	'List directories (one per line) in the Site Root directory which contain the static files to be included in the theme. Common directories might be: css, images, js, etc.' => 'Lister les répertoire (un par ligne) dans le répertoire racine du site contenant les fichiers statiques devant être inclus dans le thème. Les répertoires communs sont par exemple : css, images, js, etc.',

## tmpl/cms/include/theme_exporters/templateset.tmpl
	'widget sets' => 'groupe de widgets',
	'modules' => 'modules',
	'<span class="count">[_1]</span> [_2] are included' => '<span class="count">[_1]</span> [_2] sont inclus',

## tmpl/cms/install.tmpl
	'Welcome to Movable Type' => 'Bienvenue dans Movable Type',
	'Create Your Account' => 'Créez votre compte',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'La version Perl installée sur votre serveur ([_1]) est antérieure à la version minimale nécessaire ([_2]).',
	q{While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].} => q{Même si Movable Type semble fonctionner normalement, l'application s'exécute <strong>dans un environnement non testé et non supporté</strong>.  Nous vous recommandons fortement d'installer une version de Perl supérieure ou égale à [_1].},
	q{Do you want to proceed with the installation anyway?} => q{Souhaitez-vous tout de même poursuivre l'installation ?},
	'View MT-Check (x)' => 'Voir MT-Check (x)',
	'Please create an administrator account for your system. When you are done, Movable Type will initialize your database.' => 'Veuillez créer un compte administrateur pour votre système. Lorsque cela sera fait, Movable Type  initialisera votre base de données.',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Pour poursuivre, vous devez vous authentifier correctement auprès de votre serveur LDAP.',
	'System Email' => 'Adresse e-mail système',
	'Use this as system email address' => 'Utiliser ceci comme adresse e-mail du système',
	'Select a password for your account.' => 'Sélectionnez un mot de passe pour votre compte.',
	q{Finish install (s)} => q{Finir l'installation},
	q{Finish install} => q{Finir l'installation},
	'The initial account name is required.' => 'Le nom initial du compte est nécessaire.',
	q{The display name is required.} => q{Le nom d'affichage est requis.},
	q{The e-mail address is required.} => q{L'adresse e-mail est requise.},

## tmpl/cms/layout/common/footer.tmpl

## tmpl/cms/layout/dashboard.tmpl
	'reload' => 'recharger',
	'Reload' => 'Recharger',

## tmpl/cms/list_category.tmpl
	'Top Level' => 'Niveau principal',
	'[_1] label' => 'Label de [_1]',
	'Alert' => 'Alerte',
	'Change and move' => 'Changer et déplacer',
	'Rename' => 'Renommer',
	'Label is required.' => 'Le label est requis',
	'Label is too long.' => 'Le label est trop long.',
	'Duplicated label on this level.' => 'Des labels dupliqués sont sur ce niveau.',
	'Basename is required.' => 'Le nom de base est requis.',
	'Invalid Basename.' => 'Le nom de base est invalide.',
	'Duplicated basename on this level.' => 'Des noms de base dupliqués sont sur ce niveau.',
	'Add child [_1]' => 'Ajouter un enfant [_1]',
	'Remove [_1]' => 'Supprimer [_1]',
	'[_1] \'[_2]\' already exists.' => '[_1] \'[_2]\' existe déjà.',
	'Are you sure you want to remove [_1] [_2]?' => 'Voulez-vous vraiment retirer [_1] [_2] ?',
	'Are you sure you want to remove [_1] [_2] with [_3] sub [_4]?' => 'Voulez-vous vraiment retirer [_1] [_2] avec [_3] sous [_4] ?',

## tmpl/cms/list_common.tmpl
	'Feed' => 'Flux',
	'<mt:var name="js_message">' => '<mt:var name="js_message">',

## tmpl/cms/list_entry.tmpl
	'Entries Feed' => 'Flux des notes',
	'Pages Feed' => 'Flux des pages',
	'The entry has been deleted from the database.' => 'Cette note a été supprimée de la base de données.',
	'The page has been deleted from the database.' => 'Cette page a été supprimée de la base de données.',
	'Quickfilters' => 'Filtres rapides',
	'[_1] (Disabled)' => '[_1] (Désactivé)',
	'Showing only: [_1]' => 'Montrer seulement : [_1]',
	'Remove filter' => 'Supprimer le filtre',
	'change' => 'modifier',
	'[_1] where [_2] is [_3]' => '[_1] où [_2] est [_3]',
	'Show only entries where' => 'Afficher seulement les notes où',
	'Show only pages where' => 'Afficher seulement les pages où',
	'status' => 'le statut',
	'tag (exact match)' => 'le tag (est exactement)',
	'tag (fuzzy match)' => 'le tag (ressemble à)',
	'asset' => 'élément',
	'is' => 'est',
	'published' => 'publié',
	'unpublished' => 'non publié',
	'review' => 'vérification',
	'scheduled' => 'programmé',
	'spam' => 'spam',
	'Select A User:' => 'Sélectionner un utilisateur',
	'User Search...' => 'Recherche utilisateur...',
	'Recent Users...' => 'Utilisateurs récents...',
	'Select...' => 'Sélectionnez...',

## tmpl/cms/listing/asset_list_header.tmpl
	'You have successfully deleted the asset(s).' => 'Vous avez effacé le ou les éléments.',
	q{Cannot write to '[_1]'. Thumbnail of items may not be displayed.} => q{Impossible d'écrire sur '[_1]'. La vignette de ces éléments peut ne pas s'afficher.},

## tmpl/cms/listing/association_list_header.tmpl
	'You have successfully revoked the given permission(s).' => 'Vous avez révoqué avec succès la ou les autorisations sélectionnées.',
	'You have successfully granted the given permission(s).' => 'Vous avez attribué avec succès la ou les autorisations sélectionnées.',

## tmpl/cms/listing/author_list_header.tmpl
	'You have successfully disabled the selected user(s).' => 'Vous avez désactivé avec succès le ou les utilisateurs sélectionnés.',
	'You have successfully enabled the selected user(s).' => 'Vous avez activé avec succès le ou les utilisateurs sélectionnés.',
	'You have successfully unlocked the selected user(s).' => 'Vous avez déverrouiller avec succès le ou les utilisateurs sélectionnés.',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'Vous avez supprimé avec succès le ou les utilisateurs dans le système.',
	q{The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Advanced.} => q{Le ou les utilisateurs effacés existent encore dans le répertoire externe. En conséquence ils pourront encore s'identifier dans Movable Type Advanced},
	q{You have successfully synchronized users' information with the external directory.} => q{Vous avez synchronisé avec succès les informations des utilisateurs avec le répertoire externe.},
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => 'Certains des utilisateurs sélectionnés ([_1]) ne peuvent pas être ré-activés car ils ne sont pas dans le répertoire externe.',
	q{Some ([_1]) of the selected user(s) could not be re-enabled because they had some invalid parameter(s). Please check the <a href='[_2]' class="alert-link">activity log</a> for more details.} => q{Certains ([_1]) du/des utilisateur(s) sélectionné(s) n'ont pu être réactivés à cause de paramètre(s) invalide(s). Veuillez consulter le <a href='[_2]' class="alert-link">journal d'activité</a> pour plus de détails.},
	q{An error occurred during synchronization.  See the <a href='[_1]' class="alert-link">activity log</a> for detailed information.} => q{Une erreur est survenue lors de la synchronization. Veuillez consulter le <a href='[_2]' class="alert-link">journal d'activité</a> pour plus de détails.},

## tmpl/cms/listing/banlist_list_header.tmpl
	q{You have added [_1] to your list of banned IP addresses.} => q{L'adresse [_1] a été ajoutée à la liste des adresses IP bannies.},
	'You have successfully deleted the selected IP addresses from the list.' => 'La ou les adresses IP sélectionnées ont été supprimées de la liste.',
	'' => '', # Translate - New
	'The IP you entered is already banned for this site.' => 'L\'adresse IP entrée est déjà bannie pour ce site.', # Translate - New
	'Invalid IP address.' => 'Adresse IP invalide.',

## tmpl/cms/listing/blog_list_header.tmpl
	'You have successfully deleted the site from the Movable Type system. The files still exist in the site path. Please delete files if not needed.' => 'Vous avez supprimé avec succès le site du système Movable Type. Les fichiers sont toujours présents sur le disque. Supprimez-les si nécessaire.',
	'You have successfully deleted the child site from the site. The files still exist in the site path. Please delete files if not needed.' => 'Vous avez supprimé avec succès le site enfant du système Movable Type. Les fichiers sont toujours présents sur le disque. Supprimez-les si nécessaire.',
	'You have successfully refreshed your templates.' => 'Vous avez réactualisé vos gabarits avec succès.',
	'You have successfully moved selected child sites to another site.' => 'Vous avez déplacé avec succès les sites enfants sélectionnés vers un autre site.',
	q{Warning: You need to copy uploaded assets to new locations manually. You should consider maintaining copies of uploaded assets in their original locations to avoid broken links.} => q{Attention : vous devez copier les éléments envoyés vers le nouvel emplacement manuellement. Vous devriez maintenir des copies des éléments envoyés à leur emplacement original afin d'éviter tout risque de lien mort.},

## tmpl/cms/listing/category_set_list_header.tmpl
	q{Some category sets were not deleted. You need to delete categories fields from the category set first.} => q{Certains groupes de catégories n'ont pas été supprimés. Vous devez d'abord supprimer les champs catégories du groupe de catégories.},

## tmpl/cms/listing/comment_list_header.tmpl
	'The selected comment(s) has been approved.' => 'Le ou les commentaires sélectionnés ont été approuvés.',
	'All comments reported as spam have been removed.' => 'Tous les commentaires notifiés comme spam ont été supprimés.',
	'The selected comment(s) has been unapproved.' => 'Le ou les commentaires sélectionnés ont été approuvés.',
	'The selected comment(s) has been reported as spam.' => 'Le ou les commentaires sélectionnés ont été notifiés comme spam.',
	'The selected comment(s) has been recovered from spam.' => 'Le ou les commentaires sélectionnés ont été récupérés du spam.',
	'The selected comment(s) has been deleted from the database.' => 'Le ou les commentaires sélectionnés ont été supprimés de la base de données.',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be banned or trusted.' => 'Un ou plusieurs commentaires sélectionnés ont été écrits par un commentateur non authentifié. Ces auteurs de commentaire ne peuvent pas être bannis ou validés.',
	q{No comments appear to be spam.} => q{Aucun commentaire n'est marqué comme spam.},

## tmpl/cms/listing/content_data_list_header.tmpl
	'The content data has been deleted from the database.' => 'Les données de contenu ont été supprimées de la base de données.',

## tmpl/cms/listing/content_type_list_header.tmpl
	'The content type has been deleted from the database.' => 'Le type de contenu a été supprimé de la base de données.',
	q{Some content types were not deleted. You need to delete archive templates or content type fields from the content type first.} => q{Certains types de contenu n'ont pas été supprimés. Vous devez d'abord supprimer les gabarits d'archive ou les champs de type de contenu.},

## tmpl/cms/listing/entry_list_header.tmpl

## tmpl/cms/listing/filter_list_header.tmpl

## tmpl/cms/listing/group_list_header.tmpl
	'You successfully disabled the selected group(s).' => 'Vous avez désactivé les groupes sélectionnés avec succès.',
	'You successfully enabled the selected group(s).' => 'Vous avez activé les groupes sélectionnés avec succès.',
	'You successfully deleted the groups from the Movable Type system.' => 'Vous avez supprimé les groupes du système Movable Type.',
	q{You successfully synchronized the groups' information with the external directory.} => q{Vous avez synchronisé les informations des groupes avec l'annuaire externe avec succès.},
	q{An error occurred during synchronization.  See the <a href='[_1]'>activity log</a> for detailed information.} => q{Une erreur s'est produite durant la synchronisation. Consultez le <a href='[_1]'>journal d'activité</a> pour plus d'informations.},

## tmpl/cms/listing/group_member_list_header.tmpl
	'You successfully deleted the users.' => 'Vous avez supprimé avec succès les utilisateurs.',
	'You successfully added new users to this group.' => 'Vous avez ajouté de nouveaux utilisateurs dans ce groupe avec succès.',
	q{You successfully synchronized users' information with the external directory.} => q{Vous avez synchronisé les informations des utilisateurs avec l'annuaire externe avec succès.},
	'Some ([_1]) of the selected users could not be re-enabled because they are no longer found in LDAP.' => 'Quelques ([_1]) des utilisateurs sélectionnés ne peuvent pas être réactivés car ils ne sont plus trouvés dans LDAP',
	'You successfully removed the users from this group.' => 'Vous avez retiré avec succès les utilisateurs de ce groupe.',

## tmpl/cms/listing/log_list_header.tmpl
	'All times are displayed in GMT[_1].' => 'Toutes les heures sont affichées en GMT[_1].',
	'All times are displayed in GMT.' => 'Toutes les heures sont affichées en GMT.',

## tmpl/cms/listing/member_list_header.tmpl

## tmpl/cms/listing/notification_list_header.tmpl
	'You have updated your contact in your address book.' => 'Vous avez mis à jour le contact dans votre carnet d\'adresses.', # Translate - New
	'You have added new contact to your address book.' => 'Vous avez ajouté un contact dans votre carnet d\'adresses.', # Translate - New
	q{You have successfully deleted the selected contacts from your address book.} => q{Vous avez supprimé avec succès les contacts sélectionnés de votre carnet d'adresses.},

## tmpl/cms/listing/ping_list_header.tmpl
	'The selected TrackBack(s) has been approved.' => 'Le ou les TrackBacks sélectionnés ont été approuvés.',
	'All TrackBacks reported as spam have been removed.' => 'Tous les TrackBacks notifiés comme spam ont été supprimés.',
	'The selected TrackBack(s) has been unapproved.' => 'Le ou les TrackBacks sélectionnés ont été désapprouvés.',
	'The selected TrackBack(s) has been reported as spam.' => 'Le ou les TrackBacks sélectionnés ont été notifiés comme spam.',
	'The selected TrackBack(s) has been recovered from spam.' => 'Le ou les TrackBacks sélectionnés ont été récupérés du spam.',
	'The selected TrackBack(s) has been deleted from the database.' => 'Le ou les TrackBacks sélectionnés ont été supprimés de la base de données.',
	'No TrackBacks appeared to be spam.' => 'Aucun TrackBack ne semble être du spam.',

## tmpl/cms/listing/role_list_header.tmpl
	'You have successfully deleted the role(s).' => 'Vous avez supprimé avec succès le(s) rôle(s).',

## tmpl/cms/listing/tag_list_header.tmpl
	'Your tag changes and additions have been made.' => 'Votre changements et additions de tag ont été faits.',
	'You have successfully deleted the selected tags.' => 'Vous avez effacé correctement les tags sélectionnés.',
	'Specify new name of the tag.' => 'Spécifier le nouveau nom du tag',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all blogs?' => 'Le tag \'[_2]\' existe déjà. Voulez-vous vraiment fusionner \'[_1]\' et \'[_2]\' sur tous les blogs ?',

## tmpl/cms/list_template.tmpl
	'Show All Templates' => 'Afficher tous les gabarits',
	q{Index Templates} => q{Gabarits d'index},
	q{Archive Templates} => q{Gabarits d'archives},
	'Content type Templates' => 'Gabarits de type de contenu',
	'Publishing Settings' => 'Paramètres de publication',
	'Helpful Tips' => 'Astuces',
	'To add a widget set to your templates, use the following syntax:' => 'Pour ajouter un groupe de widgets à vos gabarits, utilisez la syntaxe suivante :',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Nom du groupe de widgets&quot;$&gt;</strong>',
	'You have successfully deleted the checked template(s).' => 'Le ou les gabarits sélectionnés ont été supprimés.',
	'Your templates have been published.' => 'Vos gabarits ont bien été publiés.',
	'Selected template(s) has been copied.' => 'Le ou les gabarits sélectionnés ont été copiés.',
	'Select template type' => 'Selecter type de gabarit',
	'Entry Archive' => 'Archives individuelles de notes',
	'Entry Listing Archive' => 'Archives liste de notes',
	'Page Archive' => 'Archives de pages',
	'Content Type Listing Archive' => 'Archive liste des contenus',
	'Template Module' => 'Modules de gabarit',
	'Create new template (c)' => 'Créer nouveau gabarit (c)',
	'Create' => 'Créer',
	'Delete selected Widget Sets (x)' => 'Effacer les groupes de widgets sélectionnés (x)',
	q{No widget sets could be found.} => q{Aucun groupe de widgets n'a été trouvé.},

## tmpl/cms/list_theme.tmpl
	'All Themes' => 'Tous les thèmes',
	'_THEME_DIRECTORY_URL' => 'https://plugins.movabletype.org/',
	'Find Themes' => 'Trouver des thèmes',
	'Theme [_1] has been uninstalled.' => 'Le thème [_1] a été désinstallé.',
	'Theme [_1] has been applied (<a href="[_2]" class="alert-link">[quant,_3,warning,warnings]</a>).' => 'Le thème [_1] a été appliqué (<a href="[_2]" class="alert-link">[quant,_3,alerte,alertes]</a>).',
	'Theme [_1] has been applied.' => 'Le thème [_1] a été appliqué.',
	'Failed' => 'Échec',
	'[quant,_1,warning,warnings]' => '[quant,_1,alerte,alertes]',
	'Reapply' => 'Réappliquer',
	'Uninstall' => 'Désinstaller',
	'Author: ' => 'Auteur :',
	'This theme cannot be applied to the child site due to [_1] errors' => 'Ce thème ne peut pas être appliqué au site enfant à cause de [_1] erreurs',
	'This theme cannot be applied to the site due to [_1] errors' => 'Ce thème ne peut pas être appliqué au site à cause de [_1] erreurs',
	'Errors' => 'Erreurs',
	'Warnings' => 'Alertes',
	'Theme Errors' => 'Erreurs du thème',
	'Theme Warnings' => 'Alertes du thème',
	'Portions of this theme cannot be applied to the child site. [_1] elements will be skipped.' => 'Des portions de ce thème ne peuvent être appliquées au site enfant. [_1] éléments seront ignorés.',
	'Portions of this theme cannot be applied to the site. [_1] elements will be skipped.' => 'Des portions de ce thème ne peuvent être appliquées au site. [_1] éléments seront ignorés.',
	'Theme Information' => 'Informations sur le thème',
	q{No themes are installed.} => q{Aucun thème n'est installé.},
	'Current Theme' => 'Thème actuel',
	'Themes in Use' => 'Thèmes utilisés',
	'Available Themes' => 'Thèmes disponibles',

## tmpl/cms/login.tmpl
	'Sign in' => 'Identification',
	'Your Movable Type session has ended.' => 'Votre session Movable Type est terminée.',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Votre session Movable Type est terminée. Si vous souhaitez vous identifier à nouveau, vous pouvez le faire ci-dessous.',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Votre session Movable Type est terminée. Merci de vous identifier à nouveau pour continuer cette action.',
	'Forgot your password?' => 'Vous avez oublié votre mot de passe ?',
	'Sign In (s)' => 'Connexion (s)',

## tmpl/cms/not_implemented_yet.tmpl
	'Not implemented yet.' => 'Pas encore implémenté.',

## tmpl/cms/pinging.tmpl
	'Pinging sites...' => 'Envoi de ping(s)...',

## tmpl/cms/popup/pinged_urls.tmpl
	'Successful Trackbacks' => 'TrackBacks réussis',
	'Failed Trackbacks' => 'TrackBacks échoués',
	'To retry, include these TrackBacks in the Outbound TrackBack URLs list for your entry.' => 'Pour ré-essayer, incluez ces TrackBacks dans la liste des URLs de TrackBacks sortants pour cette note.',

## tmpl/cms/popup/rebuild_confirm.tmpl
	'Publish [_1]' => 'Publier [_1]',
	'Publish <em>[_1]</em>' => 'Publier <em>[_1]</em>',
	'_REBUILD_PUBLISH' => 'Publier',
	'All Files' => 'Tous les fichiers',
	q{Index Template: [_1]} => q{Gabarit d'index : [_1]},
	'Only Indexes' => 'Uniquement les index',
	'Only [_1] Archives' => 'Uniquement les archives [_1]',
	'Publish (s)' => 'Publier',

## tmpl/cms/popup/rebuilt.tmpl
	'Success' => 'Succès',
	'The files for [_1] have been published.' => 'Les fichiers pour [_1] ont été publiés.',
	'Your [_1] archives have been published.' => 'Vos archives [_1] ont été publiées.',
	'Your [_1] templates have been published.' => 'Vos gabarits [_1] ont été publiés.',
	'Publish time: [_1].' => 'Temps de publication : [_1].',
	'View your site.' => 'Voir votre site.',
	'View this page.' => 'Voir cette page.',
	'Publish Again (s)' => 'Publier à nouveau (s)',
	'Publish Again' => 'Publier à nouveau',

## tmpl/cms/preview_content_data_content.tmpl

## tmpl/cms/preview_content_data_strip.tmpl
	q{Return to the compose screen} => q{Retourner sur l'éditeur},
	q{Return to the compose screen (e)} => q{Retourner sur l'éditeur (e)},
	'Publish this [_1] (s)' => 'Publier ce [_1] (s)',
	'Save this [_1] (s)' => 'Sauvegarder ce [_1] (s)',
	'Re-Edit this [_1]' => 'Ré-éditer ce [_1]',
	'Re-Edit this [_1] (e)' => 'Ré-éditer ce [_1] (e)',
	'You are previewing &ldquo;[_1]&rdquo; content data entitled &ldquo;[_2]&rdquo;' => 'Vous prévisualisez &ldquo;[_1]&rdquo; donnée de contenu intitulée &ldquo;[_2]&rdquo;',

## tmpl/cms/preview_content_data.tmpl
	'Preview [_1] Content' => 'Prévisualiser le contenu [_1]',

## tmpl/cms/preview_entry.tmpl
	'Save this entry' => 'Sauvegarder cette note',
	'Save this entry (s)' => 'Sauvegarder cette note (s)',
	'Re-Edit this entry' => 'Ré-éditer cette note',
	'Re-Edit this entry (e)' => 'Ré-éditer cette note (e)',
	'Save this page' => 'Sauvegarder cette page',
	'Save this page (s)' => 'Sauvegarder cette page (s)',
	'Re-Edit this page' => 'Ré-éditer cette page',
	'Re-Edit this page (e)' => 'Ré-éditer cette page (e)',

## tmpl/cms/preview_strip.tmpl
	'Publish this entry' => 'Publier cette note',
	'Publish this entry (s)' => 'Publier cette note (s)',
	'Publish this page' => 'Publier cette page',
	'Publish this page (s)' => 'Publier cette page (s)',
	'You are previewing the entry entitled &ldquo;[_1]&rdquo;' => 'Vous prévisualisez la note &laquo; [_1] &raquo;',
	'You are previewing the page entitled &ldquo;[_1]&rdquo;' => 'Vous prévisualisez la page &laquo; [_1] &raquo;',

## tmpl/cms/preview_template_strip.tmpl
	'You are previewing the template named &ldquo;[_1]&rdquo;' => 'Vous prévisualisez le module nommé &laquo; [_1] &raquo;',
	'(Publish time: [_1] seconds)' => 'Temps de publication : [_1] secondes',
	'Save this template (s)' => 'Sauvegarder ce gabarit (s)',
	'Save this template' => 'Sauvegarder ce gabarit',
	'Re-Edit this template (e)' => 'Ré-éditer ce gabarit (e)',
	'Re-Edit this template' => 'Ré-éditer ce gabarit',
	q{There are no categories in this blog.  Limited preview of category archive templates is possible with a virtual category displayed.  Normal, non-preview output cannot be generated by this template unless at least one category is created.} => q{Il n'y a pas de catégories dans ce blog. Une prévisualisation limitée du gabarit d'achive d'une catégorie est possible avec une catégorie virtuelle. Une publication normale, hors prévisualisation, ne peut être faite avec ce gabarit que si au moins une catégorie est présente.},

## tmpl/cms/rebuilding.tmpl
	'Publishing...' => 'Publication...',
	'Publishing [_1]...' => 'Publication [_1]...',
	'Publishing <em>[_1]</em>...' => 'Publication <em>[_1]</em>...',
	'Publishing [_1] [_2]...' => 'Publication [_1] [_2]...',
	'Publishing [_1] dynamic links...' => 'Publication des liens dynamiques [_1]...',
	'Publishing [_1] archives...' => 'Publication des archives [_1]...',
	'Publishing [_1] templates...' => 'Publication des gabarits [_1]...',
	'Complete [_1]%' => 'Terminé à [_1]%',

## tmpl/cms/recover_lockout.tmpl
	'Recovered from lockout' => 'Déverrouiller',
	q{User '[_1]' has been unlocked.} => q{L'utilisateur '[_1]' a été déverrouillé.'},

## tmpl/cms/recover_password_result.tmpl
	'Recover Passwords' => 'Retrouver les mots de passe',
	q{No users were selected to process.} => q{Aucun utilisateur sélectionné pour l'opération.},
	'Return' => 'Retour',

## tmpl/cms/refresh_results.tmpl
	'No templates were selected to process.' => 'Aucun gabarit sélectionné pour cette action.',
	'Return to templates' => 'Retourner aux gabarits',

## tmpl/cms/restore_end.tmpl
	q{An error occurred during the import process: [_1] Please check activity log for more details.} => q{Une erreur est survenue lors de l'import : [_1]. Veuillez vérifier le journal d'activité pour plus de détails.},

## tmpl/cms/restore_start.tmpl
	'Importing Movable Type' => 'Import de Movable Type',

## tmpl/cms/restore.tmpl
	q{Import from Exported file} => q{Import d'un fichier exporté},
	'Perl module XML::SAX and/or some of its dependencies are missing.  Movable Type cannot restore the system without these modules.' => 'Le module Perl XML::SAX et/ou ses dépendances sont introuvables. Movable Type ne peut pas restaurer le système sans ces modules.',
	'Exported File' => 'Fichier exporté',
	'Overwrite global templates.' => 'Écraser les gabarits globaux.',
	'Import (i)' => 'Importer (i)',

## tmpl/cms/search_replace.tmpl
	'Search &amp; Replace' => 'Chercher &amp; remplacer',
	'You must select one or more item to replace.' => 'Vous devez sélectionner un ou plusieurs objets à remplacer.',
	'Search Again' => 'Chercher encore',
	'Case Sensitive' => 'Sensible à la casse',
	'Regex Match' => 'Expression rationnelle',
	'Limited Fields' => 'Champs limités',
	'Date/Time Range' => 'Période date/heure',
	'Date Range' => 'Période (date)',
	'Reported as Spam?' => 'Notifié comme spam ?',
	'(search only)' => '(rechercher seulement)',
	'Field' => 'Champ',
	'_DATE_FROM' => 'Depuis le ',
	q{_DATE_TO} => q{jusqu'au },
	'_TIME_FROM' => 'De ',
	q{_TIME_TO} => q{jusqu'à },
	'Submit search (s)' => 'Soumettre la recherche (s)',
	'Search For' => 'Rechercher',
	'Replace With' => 'Remplacer par',
	'Replace Checked' => 'Remplacer dans la sélection',
	'Successfully replaced [quant,_1,record,records].' => 'Remplacements effectués avec succès dans [quant,_1,enregistrement,enregistrements].',
	q{Showing first [_1] results.} => q{Afficher d'abord [_1] résultats.},
	'Show all matches' => 'Afficher tous les résultats',
	'[quant,_1,result,results] found' => '[quant,_1,résultat trouvé,résultats trouvés]',

## tmpl/cms/system_check.tmpl
	'Total Users' => 'Utilisateurs au total',
	'Memcached Status' => 'Status Memcached',
	'configured' => 'configuré',
	'disabled' => 'désactivé',
	'Memcached is [_1].' => 'Memcached est [_1].',
	'available' => 'disponible',
	'unavailable' => 'indisponible',
	'Memcached Server is [_1].' => 'Le serveur Memcached est [_1].',
	'Server Model' => 'Modèle du serveur',
	q{Movable Type could not find the script named 'mt-check.cgi'. To resolve this issue, ensure that the mt-check.cgi script exists and that the CheckScript configuration parameter (if it is necessary) references it properly.} => q{Movable Type ne trouve pas le script nommé 'mt-check.cgi'. Pour résoudre ce problème, vérifiez que le script mt-check.cgi existe et que le paramètre de configuration CheckScript (s'il est nécessaire) le référence correctement.},

## tmpl/cms/theme_export_replace.tmpl
	q{Export theme folder already exists '[_1]'. You can overwrite a existing theme, or cancel to change the Basename?} => q{Le répertoire d'export '[_1]' existe déjà. Vous pouvez le remplacer ou entrer un autre nom de répertoire.},
	'Overwrite' => 'Remplacer',

## tmpl/cms/upgrade_runner.tmpl
	'Initializing database...' => 'Initialisation de la base de données...',
	'Upgrading database...' => 'Mise à jour de la base de données...',
	q{Error during installation:} => q{Erreur lors de l'installation :},
	'Error during upgrade:' => 'Erreur lors de la mise à jour :',
	'Return to Movable Type (s)' => 'Retour vers Movable Type (s)',
	'Return to Movable Type' => 'Retour vers Movable Type',
	'Your database is already current.' => 'Votre base de données est déjà à jour.',
	'Installation complete!' => 'Installation terminée !',
	'Upgrade complete!' => 'Mise à jour terminée !',

## tmpl/cms/upgrade.tmpl
	'Time to Upgrade!' => 'Il est temps de mettre à jour !',
	'Upgrade Check' => 'Vérification des mises à jour',
	'Do you want to proceed with the upgrade anyway?' => 'Voulez-vous quand même procéder à la mise à jour ?',
	q{A new version of Movable Type has been installed.  We'll need to complete a few tasks to update your database.} => q{Une nouvelle version de Movable Type a été installée. Nous avons besoin de faire quelques manipulations complémentaires pour mettre à jour votre base de données.},
	q{The Movable Type Upgrade Guide can be found <a href='[_1]' target='_blank'>here</a>.} => q{Le guide de mise à jour Movable Type peut être trouvé <a href='[_1]' target='_blank'>ici</a>.},
	'In addition, the following Movable Type components require upgrading or installation:' => 'De plus, les composants suivants de Movable Type nécessitent une mise à jour ou une installation :',
	'The following Movable Type components require upgrading or installation:' => 'Les composants suivants de Movable Type nécessitent une mise à jour ou une installation :',
	'Begin Upgrade' => 'Commencer la mise à jour',
	'Congratulations, you have successfully upgraded to Movable Type [_1].' => 'Félicitations, vous avez mis à jour Movable Type à la version [_1].',
	'Your Movable Type installation is already up to date.' => 'Vous disposez de la dernière version de Movable Type.',

## tmpl/cms/view_log.tmpl
	q{Activity Log} => q{Journal d'activité},
	q{The activity log has been reset.} => q{Le journal d'activité a été réinitialisé.},
	q{System Activity Log} => q{Journal d'activité},
	'Filtered' => 'Filtrés',
	q{Filtered Activity Feed} => q{Flux d'activité filtré},
	'Download Filtered Log (CSV)' => 'Télécharger le journal filtré (CSV)',
	q{Clear Activity Log} => q{Effacer le journal d'activité},
	q{Are you sure you want to reset the activity log?} => q{Voulez-vous vraiment réinitialiser le journal d'activité ?},
	'Showing all log records' => 'Affichage de toutes les données du journal',
	'Showing log records where' => 'Affichage des données du journal où',
	'Show log records where' => 'Afficher les données du journal où',
	'level' => 'le statut',
	'classification' => 'classification',

## tmpl/cms/view_rpt_log.tmpl
	'Schwartz Error Log' => 'Journal des erreurs Schwartz',
	'Showing all Schwartz errors' => 'Affichage de toutes les erreurs Schwartz',

## tmpl/cms/widget/activity_log.tmpl

## tmpl/cms/widget/mt_news.tmpl
	'News' => 'Actualité',
	q{No Movable Type news available.} => q{Aucune actualité Movable Type n'est disponible.},

## tmpl/cms/widget/notification_dashboard.tmpl
	'Messages from the system' => 'Messages du système',
	'warning' => 'alerte',

## tmpl/cms/widget/site_list_for_mobile.tmpl

## tmpl/cms/widget/site_list.tmpl
	'Setting' => 'Paramètre',
	'List' => 'Liste',
	'Recent Posts' => 'Notes récentes',

## tmpl/cms/widget/site_stats.tmpl
	'Statistics Settings' => 'Paramètres des statistiques',

## tmpl/cms/widget/system_information.tmpl
	'Active Users' => 'Utilisateurs actifs',

## tmpl/cms/widget/updates.tmpl
	'Update check failed. Please check server network settings.' => 'La vérification des mises à jour a échoué. Veuillez vérifier les paramètres réseau du serveur.',
	'Update check is disabled.' => 'La vérification des mises à jour est désactivée.',
	'Available updates (Ver. [_1]) found. Please see the <a href="[_2]" target="_blank">news</a> for detail.' => 'Mise à jour disponible (version [_1]). Voir <a href="[_2]" target="_blank">les détails</a>.',
	'Movable Type is up to date.' => 'Movable Type est à jour.',

## tmpl/comment/error.tmpl
	'Back (s)' => 'Retour (s)',

## tmpl/comment/login.tmpl
	'Sign in to comment' => 'Identifiez-vous pour commenter',
	q{Sign in using} => q{S'identifier en utilisant},
	'Not a member? <a href="[_1]">Sign Up</a>!' => 'Pas encore membre ? <a href="[_1]">Inscrivez-vous</a> !',

## tmpl/comment/profile.tmpl
	'Your Profile' => 'Votre profil',
	'Select a password for yourself.' => 'Sélectionnez un mot de passe pour vous.',
	q{Return to the <a href="[_1]">original page</a>.} => q{Retourner sur la <a href="[_1]">page d'origine</a>.},

## tmpl/comment/signup_thanks.tmpl
	'Thanks for signing up' => 'Merci de vous être enregistré(e)',
	q{Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].} => q{Avant de pouvoir déposer un commentaire vous devez terminer la prodécure d'enregistrement en confirmant votre compte.  Un e-mail a été envoyé à l'adresse suivante : [_1].},
	q{To complete the registration process you must first confirm your account. An email has been sent to [_1].} => q{Pour terminer la procédure d'enregistrement vous devez confirmer votre compte. Un e-mail a été envoyé à [_1].},
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'Pour confirmer et activer votre compte merci de vérifier votre boîte e-mail et de cliquer sur le lien que nous venons de vous envoyer.',
	q{Return to the original entry.} => q{Retour à la note d'origine.},
	q{Return to the original page.} => q{Retour à la page d'origine.},

## tmpl/comment/signup.tmpl
	'Create an account' => 'Créer un compte',
	'Password Confirm' => 'Mot de passe (confirmation)',
	q{Register} => q{S'enregistrer},

## tmpl/data_api/include/login_mt.tmpl

## tmpl/data_api/login.tmpl

## tmpl/error.tmpl
	'Missing Configuration File' => 'Fichier de configuration manquant',
	'_ERROR_CONFIG_FILE' => 'Votre fichier configuration Movable type est absent ou ne peut pas être lu correctement. Merci de consulter la base de connaissances',
	'Database Connection Error' => 'Erreur de connexion à la base de données',
	q{_ERROR_DATABASE_CONNECTION} => q{Les paramètres de votre base de données sont soit invalides, absents ou ne peuvent pas être lus correctement. Consultez la base de connaissances pour plus d'informations.},
	'CGI Path Configuration Required' => 'Configuration de chemin CGI requise',
	'_ERROR_CGI_PATH' => 'Votre configuration de chemin CGI est invalide ou absente de vos fichiers de configuration Movable Type. Merci de consulter la base de connaissance',

## tmpl/feeds/error.tmpl
	q{Movable Type Activity Log} => q{Journal d'activité de Movable Type},

## tmpl/feeds/feed_comment.tmpl
	'More like this' => 'Plus du même genre',
	'From this [_1]' => 'De ce [_1]',
	'On this entry' => 'Sur cette note',
	'By commenter identity' => 'Par identité du commentateur',
	'By commenter name' => 'Par nom du commentateur',
	'By commenter email' => 'Par e-mail du commentateur',
	'By commenter URL' => 'Par URL du commentateur',
	'On this day' => 'Pendant cette journée',

## tmpl/feeds/feed_content_data.tmpl
	'From this author' => 'De cet auteur',

## tmpl/feeds/feed_entry.tmpl

## tmpl/feeds/feed_page.tmpl

## tmpl/feeds/feed_ping.tmpl
	'Source [_1]' => 'Source [_1]',
	'By source blog' => 'Par le blog source',
	'By source title' => 'Par le titre de la source',
	q{By source URL} => q{Par l'URL de la source},

## tmpl/feeds/login.tmpl
	q{This link is invalid. Please resubscribe to your activity feed.} => q{Ce lien n'est pas valide. Merci de souscrire à nouveau à votre flux d'activité.},

## tmpl/wizard/cfg_dir.tmpl
	'Temporary Directory Configuration' => 'Configuration du répertoire temporaire',
	'You should configure your temporary directory settings.' => 'Vous devriez configurer les paramètres du répertoire temporaire.',
	q{Your TempDir has been successfully configured. Click 'Continue' below to continue configuration.} => q{Votre Tempdir a été correctement configuré. Cliquez sur 'Continuer' ci-dessous pour continuer la configuration.},
	'[_1] could not be found.' => '[_1] introuvable.',
	'TempDir is required.' => 'TempDir est requis.',
	'TempDir' => 'TempDir',

## tmpl/wizard/complete.tmpl
	'Configuration File' => 'Fichier de configuration',
	q{The [_1] configuration file cannot be located.} => q{Le fichier de configuration [_1] n'a pas pu être trouvé},
	q{Please use the configuration text below to create a file named 'mt-config.cgi' in the root directory of [_1] (the same directory in which mt.cgi is found).} => q{Créez un fichier nommé dans le répertoire racine de [_1] (le même qui contient mt.cgi) ayant pour contenu le texte de configuration ci-dessous.},
	q{The wizard was unable to save the [_1] configuration file.} => q{L'assistant n'a pas pu enregistrer le fichier de configuration [_1].},
	q{Confirm that your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click 'Retry'.} => q{Vérifiez que votre répertoire [_1] d'accueil (celui contenant mt.cgi) est ouvert en écriture pour le serveur web et cliquez sur 'Recommencer'.},
	q{Congratulations! You've successfully configured [_1].} => q{Félicitations ! Vous avez configuré [_1] avec succès.},
	q{Show the mt-config.cgi file generated by the wizard} => q{Afficher le fichier mt-config.cgi généré par l'assistant},
	'The mt-config.cgi file has been created manually.' => 'Le fichier mt-config.cgi a été créé manuellement.',
	'Retry' => 'Recommencer',

## tmpl/wizard/configure.tmpl
	'Database Configuration' => 'Configuration de la base de données',
	'Your database configuration is complete.' => 'La configuration de votre base de données est terminée.',
	q{You may proceed to the next step.} => q{Vous pouvez passer à l'étape suivante.},
	'Show Current Settings' => 'Montrer les paramètres actuels',
	'Please enter the parameters necessary for connecting to your database.' => 'Merci de saisir les paramètres nécessaires pour se connecter à votre base de données.',
	'Database Type' => 'Type de base de données',
	'Select One...' => 'Sélectionner...',
	q{Is your preferred database not listed? View the <a href="[_1]" target="_blank">Movable Type System Check</a> see if additional modules are necessary.} => q{Votre base de données préférée n'est pas listée ? Regardez <a href="[_1]" target="_blank">Movable Type System Check</a> pour voir s'il y a des modules additionnels nécessaires pour permettre son utilisation.},
	'Once installed, <a href="javascript:void(0)" onclick="[_1]">click here to refresh this screen</a>.' => 'Une fois installé, <a href="javascript:void(0)" onclick="[_1]">cliquez ici pour réactualiser cette page</a>.',
	'Read more: <a href="[_1]" target="_blank">Setting Up Your Database</a>' => 'Apprenez-en plus : <a href="[_1]" target="_blank">Configurez votre base de données</a>',
	'Show Advanced Configuration Options' => 'Montrer les options avancées de configuration',
	'Test Connection' => 'Test de connexion',
	'You must set your Database Path.' => 'Vous devez définir le chemin de base de données.',
	q{You must set your Username.} => q{Vous devez définir votre nom d'utilisateur.},
	'You must set your Database Server.' => 'Vous devez définir votre serveur de base de données.',

## tmpl/wizard/optional.tmpl
	'Mail Configuration' => 'Configuration e-mail',
	'Your mail configuration is complete.' => 'La configuration e-mail est terminée.',
	q{Check your email to confirm receipt of a test email from Movable Type and then proceed to the next step.} => q{Vérifiez votre adresse e-mail pour confirmer la réception d'un e-mail de test de Movable Type et ensuite passez à l'étape suivante.},
	'Show current mail settings' => 'Montrer les paramètres e-mail actuels',
	q{Periodically Movable Type will send email for password recovery, to inform authors of new comments, and other events. If not using Sendmail (default on unix servers), an SMTP Server must be specified.} => q{Movable Type va envoyer périodiquement des e-mails afin d'informer les utilisateurs des nouveaux commentaires et autres événements. Pour que ces e-mails puissent être envoyés correctement, veuillez spécifier la méthode que Movable Type va utiliser.},
	q{An error occurred while attempting to send mail: } => q{Une erreur s'est produite en essayant d'envoyer un e-mail : },
	'Send mail via:' => 'Envoyer les e-mails via :',
	'Sendmail Path' => 'Chemin sendmail',
	'Outbound Mail Server (SMTP)' => 'Serveur e-mail sortant (SMTP)',
	'Address of your SMTP Server.' => 'Adresse de votre serveur SMTP.',
	'Port number for Outbound Mail Server' => 'Port du serveur e-mail sortant',
	'Port number of your SMTP Server.' => 'Port du serveur SMTP',
	q{Use SMTP Auth} => q{Utiliser l'authentification SMTP},
	q{SMTP Auth Username} => q{Nom d'utilisateur pour l'authentification SMTP},
	q{Username for your SMTP Server.} => q{Nom d'utilisateur pour le serveur SMTP},
	q{SMTP Auth Password} => q{Mot de passe pour l'authentification SMTP},
	'Password for your SMTP Server.' => 'Mot de passe pour le serveur SMTP',
	'SSL Connection' => 'Connexion SSL',
	q{Cannot use [_1].} => q{Impossible d'utiliser [_1].},
	'Do not use SSL' => 'Ne pas utiliser SSL',
	'Use SSL' => 'Utiliser SSL',
	'Use STARTTLS' => 'Utiliser STARTTLS',
	'Send Test Email' => 'Envoyer un e-mail de test',
	q{Mail address to which test email should be sent} => q{L'adresse e-mail à laquelle l'e-mail de test doit être envoyé},
	'Skip' => 'Ignorer',
	'You must set the SMTP server port number.' => 'Vous devez spécifier le port du serveur SMTP',
	'This field must be an integer.' => 'Ce champ doit être un entier',
	q{You must set the system email address.} => q{Vous devez définir l'adresse e-mail du système.},
	'You must set the Sendmail path.' => 'Vous devez sépcifier le chemin Sendmail',
	q{You must set the SMTP server address.} => q{Vous devez spécifier l'adresse du serveur SMTP},
	q{You must set a username for the SMTP server.} => q{Vous devez fournir un nom d'utilisateur pour le serveur SMTP},
	'You must set a password for the SMTP server.' => 'Vous devez fournir un mot de passe pour le serveur SMTP',

## tmpl/wizard/packages.tmpl
	'Requirements Check' => 'Vérification des éléments nécessaires',
	q{The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your data of sites and child sites.  Please install one of the packages listed here in order to proceed.  When you are ready, click the 'Retry' button.} => q{Les modules Perl suivants sont requis pour se connecter à une base de données. Movable Type requiert une base de données pour stocker les données des sites. Veuillez installer l'un des modules listés ici avant de continuer. Pour continuer, cliquez sur le bouton 'Réessayer'.},
	'All required Perl modules were found.' => 'Tous les modules Perl requis ont été trouvés.',
	q{You are ready to proceed with the installation of Movable Type.} => q{Vous êtes prêt à procéder à l'installation de Movable Type.},
	'Some optional Perl modules could not be found. <a href="javascript:void(0)" onclick="[_1]">Display list of optional modules</a>' => 'Certains modules Perl optionnels sont introuvables. <a href="javascript:void(0)" onclick="[_1]">Afficher la liste des modules optionnels</a>',
	'One or more Perl modules required by Movable Type could not be found.' => 'Un ou plusieurs modules Perl nécessaires pour Movable Type sont introuvables.',
	q{The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the 'Retry' button to re-test for these packages.} => q{Les modules Perl suivants sont nécessaires au bon fonctionnement de Movable Type. Dès que vous disposez de ces éléments, cliquez sur le bouton 'Recommencer' pour vérifier ces éléments..},
	q{Some optional Perl modules could not be found. You may continue without installing these optional Perl modules. They may be installed at any time if they are needed. Click 'Retry' to test for the modules again.} => q{Certains modules Perl optionnels sont introuvables. Vous pouvez continuer sans installer ces modules Perl. Ils peuvent être installés n'importe quand si besoin. Cliquez sur 'Recommencer' pour tester à nouveau ces modules.},
	'Missing Database Modules' => 'Modules de base de données manquants',
	'Missing Optional Modules' => 'Modules optionnels manquants',
	'Missing Required Modules' => 'Modules nécessaires manquants',
	'Minimal version requirement: [_1]' => 'Version minimale nécessaire : [_1]',
	'https://www.movabletype.org/documentation/installation/perl-modules.html' => 'https://www.movabletype.org/documentation/installation/perl-modules.html',
	q{Learn more about installing Perl modules.} => q{Plus d'informations sur l'installation de modules Perl.},
	q{Your server has all of the required modules installed; you do not need to perform any additional module installations.} => q{Votre serveur possède tous les modules nécessaires, vous n'avez pas à procéder à des installations complémentaires de modules},

## tmpl/wizard/start.tmpl
	'Configuration File Exists' => 'Le fichier de configuration existe',
	q{Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.} => q{Pour utiliser Movable Type, vous devez activer le JavaScript sur votre navigateur. Merci de l'activer et de rafraîchir cette page pour commencer.},
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Vous allez maintenant, grâce à cet assistant de configuration, configurer les paramètres de base nécessaires au fonctionnement de Movable Type.',
	'Configure Static Web Path' => 'Configurer le chemin web statique',
	q{<strong>Error: '[_1]' could not be found.</strong>  Please move your static files to the directory first or correct the setting if it is incorrect.} => q{<strong>Erreur : '[_1]' ne peut pas être trouvé.</strong>  Veuillez d'abord déplacer vos fichiers statiques dans le répertoire ou en corriger le chemin s'il est incorrect.},
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type est fourni avec un répertoire nommé [_1] contenant un nombre important de fichiers comme des images, fichiers javascript et feuilles de style.',
	q{The [_1] directory is in the main Movable Type directory which this wizard script resides, but due to your web server's configuration, the [_1] directory is not accessible in this location and must be moved to a web-accessible location (e.g., your web document root directory).} => q{Le répertoire [_1] est le répertoire principal de Movable Type contenant les scripts de cet assistant, mais à cause de la configuration de votre serveur web, le répertoire [_1] n'est pas accessible à cette adresse et doit être déplacé vers un serveur web (par exemple, le répertoire racine des documents web).},
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Ce répertoire a été renommé ou déplacé en dehors du répertoire Movable Type.',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => 'Déplacez ou créez un lien symbolique du répertoire [_1] dans un endroit accessible depuis le web et spécifiez le chemin web statique dans le champ ci-dessous.',
	q{This URL path can be in the form of [_1] or simply [_2]} => q{Ce chemin d'URL peut être de la forme [_1] ou simplement [_2]},
	'This path must be in the form of [_1]' => 'Ce chemin doit être de la forme [_1]',
	'Static web path' => 'Chemin web statique',
	'Static file path' => 'Chemin fichier statique',
	'Begin' => 'Commencer',
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => 'Un fichier de configuration (mt-config.cgi) existe déjà, <a href="[_1]">identifiez-vous</a> dans Movable Type.',
	q{To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page} => q{Pour créer un nouveau fichier de configuration avec l'assistant, supprimez le fichier de configuration actuel puis rechargez cette page},

## addons/Cloud.pack/config.yaml
	'https://www.sixapart.com/movabletype/' => 'https://www.movabletype.com/',
	'Cloud Services' => 'Services Cloud', # Translate - New
	'Basic Authentication' => 'Authentification basique', # Translate - New
	'Redirect' => 'Redirection', # Translate - New
	'Auto Update' => 'Mise à jour automatique', # Translate - New
	'FTPS Password' => 'Mot de passe FTPS', # Translate - New
	'SSL Certificates' => 'Certificats SSL', # Translate - New
	'IP Restriction' => 'Restrictions IP', # Translate - New
	'Full Restore' => 'Restauration complète', # Translate - New
	'Config Directives' => 'Directives de configuration', # Translate - New
	'Disk Usage' => 'Utilisation disque', # Translate - New

## addons/Cloud.pack/lib/Cloud/App/CMS.pm
	'Owner' => 'Propriétaire', # Translate - New
	'Creator' => 'Créateur', # Translate - New
	'FTP passowrd for [_1] has successfully been updated.' => 'Le mot de passe de [_1] a été mis à jour.', # Translate - New
	'Unable to reset [_1] FTPS password.' => 'Impossible de réinitialiser le mot de passe FTPS de [_1]', # Translate - New
	'Failed to update [_1]: some of [_2] were changed after you opened this screen.' => 'Impossible de mettre à jour [_1] : certains [_2] ont été modifiés après l\'ouverture de cette fenêtre.', # Translate - New
	'Basic Authentication setting' => 'Paramètres de l\'authentification basique', # Translate - New
	'Cannot access to this uri: [_1]' => 'Cette URI est inaccessible : [_1]', # Translate - New
	'Basic authentication for site has successfully been updated.' => 'L\'authentification basique du site a été mise à jour.', # Translate - New
	'Unable to update Basic Authentication settings.' => 'Impossible de mettre à jour les paramètres de l\'authentification basique.', # Translate - New
	'Administration Screen Setting' => 'Paramètres de l\'écran d\'administration', # Translate - New
	'The URL you specified is not available.' => 'L\'URL spécifiée est indisponible.', # Translate - New
	'Unable to update Admin Screen URL settings.' => 'Impossible de mettre à jour les paramètres de l\'URL de l\'écran d\'administration.', # Translate - New
	'The URL for administration screen has successfully been updated.' => 'L\'URL de l\'écran d\'administration a été mise à jour.', # Translate - New
	'Cannot delete basicauth_admin file.' => 'Impossible de supprimer le fichier basicauth_admin.', # Translate - New
	'Basic authentication for administration screen has successfully been cleared.' => 'L\'authentification basique de l\'écran d\'administration a été effacée.', # Translate - New
	'User ID is required.' => 'L\'ID utilisateur est requise.', # Translate - New
	'Password is required.' => 'Le mot de passe est requis.', # Translate - New
	'Unable to update basic authentication for administration screen.' => 'Impossible de mettre à jour l\'authentification basique de l\'écran d\'administration.', # Translate - New
	'Unable to write temporary file.' => 'Impossible d\'écrire le fichier temporaire.', # Translate - New
	'Basic authentication for administration screen has successfully been updated.' => 'L\'authentification basique de l\'écran d\'administration a été mise à jour.', # Translate - New
	'Cannot delete ip_restriction_[_1] file.' => 'Impossible de supprimer le fichier ip_restriction_[_1]', # Translate - New
	'IP restriction for administration screen has successfully been cleared.' => 'La restriction d\'IP de l\'écran d\'administration a été effacée.', # Translate - New
	'[_1] is not a valid IP address.' => '[_1] n\'est pas une adresse IP valide.', # Translate - New
	'Unable to write allowed IP addresses file.' => 'Impossible d\'écrire le fichier des adresses IP autorisées.', # Translate - New
	'IP restriction white list for administration screen  has successfully been updated.' => 'La liste blanche des adresses IP pour l\'écran d\'administration a été mise à jour.', # Translate - New
	'HTTP Redirect' => 'Redirection HTTP', # Translate - New
	'HTTP Redirect setting' => 'Paramètres de redirection HTTP', # Translate - New
	'HTTP redirect settings has successfully updated.' => 'Les paramètres de redirection HTTP ont été mis à jour.', # Translate - New
	'Unable to update HTTP Redirect settings.' => 'Impossible de mettre à jour les paramètres de redirection HTTP.', # Translate - New
	'Update SSL Certification' => 'Mettre à jour le certificat SSL', # Translate - New
	'__SSL_CERT_UPDATE' => 'mise à jour', # Translate - New
	'__SSL_CERT_INSTALL' => 'installation', # Translate - New
	'Cannot copy default cert file.' => 'Impossible de copier le fichier certificat par défaut.', # Translate - New
	'Unable to create temporary path: [_1]' => 'Impossible de créer le chemin temporaire : [_1]', # Translate - New
	'SSL certification has successfully been updated.' => 'Le certificat SSL a été mis à jour.', # Translate - New
	'Unable to update SSL certification.' => 'Impossible de mettre à jour le certificat SSL.', # Translate - New
	'Manage Configuration Directives' => 'Gérer les directives de configuration', # Translate - New
	'Config Directive' => 'Directive de configuration', # Translate - New
	'Movable Type environment settings has successfully been updated.' => 'Les paramètres d\'environnement de Movable Type ont été mis à jour.', # Translate - New
	'Restoring Backup Data' => 'Restauration des données sauvegardées', # Translate - New
	'backup data' => 'données sauvegardées', # Translate - New
	'Invalid backup file name.' => 'Nom de fichier de sauvegarde invalide.', # Translate - New
	'Cannot copy backup file to workspace.' => 'Impossible de copier le fichier de sauvegarde dans l\'espace de travail.', # Translate - New
	'Could not save the website settings because the number of domains that have been used exceeds the number of domains which can be available.' => 'Impossible de sauvegarder les paramètres du site car le nombre de domaines utilisés excède le nombre de domaines disponibles.', # Translate - New
	'Could not create the website because the number of domains that have been used exceeds the number of domains which can be available.' => 'Impossible de créer le site car le nombre de domaines utilisés excède le nombre de domaines disponibles.', # Translate - New
	'Auto Update Settings' => 'Paramètres de mise à jour automatique', # Translate - New
	'Unable to write AUTOUPDATE file: [_1]' => 'Impossible d\'écrire le fichier AUTOUPDATE : [_1]', # Translate - New
	'Auto update settings has successfully been updated.' => 'Les paramètres de mise à jour automatique ont été mis à jour.', # Translate - New
	'IP Restriction Settings' => 'Paramètres de restriction IP', # Translate - New
	'IP Restriction settings' => 'Paramètres de restriction IP', # Translate - New
	'Domain, Path and IP addresses are required.' => 'Les domaines, chemin et adresses IP sont requis.', # Translate - New
	'\'[_1]\' does not exist.' => '\'[_1]\' n\'existe pas.', # Translate - New
	'\'[_1]\' is invalid path.' => '\'[_1]\' est un chemin invalide.', # Translate - New
	'Unable to create acl path: [_1]' => 'Impossible de créer le chemin ACL : [_1]', # Translate - New
	'Cannot write to acl directory: [_1]' => 'Impossible d\'écrire dans le dossier ACL : [_1]', # Translate - New
	'Cannot write to acl file: [_1]' => 'Impossible d\'écrire dans le fichier ACL : [_1]', # Translate - New
	'IP restriction for site has successfully been updated.' => 'La restriction d\'IP pour le site a été mise à jour.', # Translate - New
	'Cannot apply access restriction settings. Perhaps, the path or IP address you entered is not a valid.' => 'Impossible d\'appliquer les paramètres de restriction. Le chemin ou l\'adresse IP fournis ne sont peut-être pas valides.', # Translate - New
	'Unable to remove acl file.' => 'Impossible de supprimer le fichier ACL.', # Translate - New

## addons/Cloud.pack/lib/Cloud/App.pm
	'Your Movable Type will be automatically updated on [_1].' => 'Votre installation Movable Type sera mise à jour le [_1].', # Translate - New
	'New version of Movable Type has been released on [_1].' => 'Une nouvelle version de Movable Type a été publiée le [_1].', # Translate - New
	'Disk usage rate is [_1]%.' => 'Le disque est utilisé à [_1]%.', # Translate - New
	'<a href="[_1]">Refresh cached disk usage rate data.</a>' => '<a href="[_1]">Rafraîchir les données cachées du taux d\'utilisation du disque.</a>', # Translate - New
	'An error occurred while reading version information.' => 'Une erreur est survenue lors de la lecture des informations de version.', # Translate - New

## addons/Cloud.pack/lib/Cloud/Template.pm
	'Unify the existence of www. <a href="[_1]">Detail</a>' => 'Unifier l\'existence de www. <a href="[_1]">Détails</a>', # Translate - New
	'https://www.movabletype.jp/documentation/cloud/guide/multi-domain.html' => '', # Translate - New
	'\'Website Root\' or \'Archive Root\' has been changed. You must move existing contents.' => 'Le chemin du site ou de ses archives a été modifié. Vous devez déplacer le contenu existant.', # Translate - New

## addons/Cloud.pack/lib/Cloud/Upgrade.pm
	'Disabling any plugins...' => 'Afficher tous les plugins...', # Translate - New

## addons/Cloud.pack/lib/Cloud/Util.pm
	'Cannot read resource file.' => 'Impossible de lire le fichier ressource.', # Translate - New
	'Cannot get the resource data.' => 'Impossible d\'obtenir les données ressource.', # Translate - New
	'Unknown CPU type.' => 'Type de CPU inconnu.', # Translate - New

## addons/Cloud.pack/tmpl/cfg_auto_update.tmpl
	'Auto update setting have been saved.' => 'Les paramètres de mise à jour automatique ont été sauvegardés.', # Translate - New
	'Current installed version of Movable Type is the latest version.' => 'Votre installation de Movable Type est la dernière version disponible.', # Translate - New
	'New version of Movable Type is available.' => 'Une nouvelle version de Movable Type est disponible.', # Translate - New
	'Last Update' => 'dernière mise à jour', # Translate - Case
	'Movable Type [_1] on [_2]' => 'Movable Type [_1] sur [_2]', # Translate - New
	'Available version' => 'Version disponible', # Translate - New
	'Movable Type [_1] (released on [_2])' => 'Movable Type [_1] (publié le [_2])', # Translate - New
	'Your Movable Type will be automatically updated on [_1], regardless of your settings.' => 'Votre installation Movable Type sera mise à jour le [_1], indépendamment de vos réglages.', # Translate - New
	'Auto update' => 'Mise à jour automatique', # Translate - New
	'Enable	automatic update of Movable Type' => 'Activer la mise à jour automatique de Movable Type', # Translate - New

## addons/Cloud.pack/tmpl/cfg_basic_authentication.tmpl
	'Manage Basic Authentication' => 'Gérer l\'authentification basique', # Translate - New
	'/path/to/authentication' => '/chemin/vers/authentification', # Translate - New
	'User ID' => 'ID utilisateur', # Translate - New
	'URI is required.' => 'Une URI est requise', # Translate - New
	'Invalid URI.' => 'URI invalide.', # Translate - New
	'User ID must be with alphabet, number or symbols (excludes back slash) only.' => 'L\'ID utilisateur ne peut contenir que des lettres de l\'alphabet, des nombres ou des symboles (à l\'exclusion de \\).', # Translate - New
	'Password must be with alphabet, number or symbols (excludes back slash) only.' => 'Le mot de passe ne peut contenir que des lettres de l\'alphabet, des nombres ou des symboles (à l\'exclusion de \\).', # Translate - New
	'basic authentication setting' => 'Réglage de l\'authentification basique', # Translate - New
	'basic authentication settings' => 'Réglages de l\'authentification basique', # Translate - New

## addons/Cloud.pack/tmpl/cfg_config_directives.tmpl
	'Configuration directive' => 'Directive de configuration', # Translate - New
	'Configuration value' => 'Valeur de configuration', # Translate - New
	'Reference' => 'Référence', # Translate - New

## addons/Cloud.pack/tmpl/cfg_disk_usage.tmpl
	'User Contents Files' => 'Fichiers contenus utilisateur', # Translate - New
	'Buckup Files' => 'Fichiers de sauvegarde', # Translate - New
	'Free Disk Space' => 'Espace disque libre', # Translate - New
	'User Contents' => 'Contenus utilisateur', # Translate - New
	'Backup' => 'Sauvegarder', # Translate - Case
	'Others' => 'Autres', # Translate - New
	'Free' => 'Libre', # Translate - New

## addons/Cloud.pack/tmpl/cfg_ftps_password.tmpl
	'Reset FTPS Password' => 'Réinitialiser le mot de passe FTPS', # Translate - New
	'Please select the account for which you want to reset the password.' => 'Sélectionnez le compte dont le mot de passe doit être réinitialisé.', # Translate - New
	'Owner Password' => 'Mot de passe du propriétaire', # Translate - New
	'Creator Password' => 'Mot de passe du créateur', # Translate - New
	'Password has been saved.' => 'Le mot de passe a été sauvegardé.', # Translate - New

## addons/Cloud.pack/tmpl/cfg_http_redirect.tmpl
	'Manage HTTP Redirect' => 'Gérer la redirection HTTP', # Translate - New
	'/path/of/redirect' => '/chemin/de/redirection', # Translate - New
	'http://example.com or /path/to/redirect' => 'http://exemple.com ou /chemin/de/redirection', # Translate - New
	'Redirect URL is required.' => 'L\'URL de redirection est requise.', # Translate - New
	'Redirect url is same as URI' => 'L\'URL de redirection est identique à l\'URI', # Translate - New
	'HTTP redirect setting' => 'Réglage de redirection HTTP', # Translate - New
	'HTTP redirect settings' => 'Réglages de redirection HTTP', # Translate - New

## addons/Cloud.pack/tmpl/cfg_ip_restriction.tmpl
	'Administration screen settings have been saved.' => 'Les réglages de l\'écran d\'administration ont été sauvegardés.', # Translate - New
	'Domain name like example.com' => 'Nom de domaine comme exemple.com', # Translate - New
	'Path begin with / like /path' => 'Chemin commençant par / comme /chemin', # Translate - New
	'IP addresses that are allowed to access' => 'Adresses IP autorisées pour l\'accès', # Translate - New
	'Domain is required.' => 'Le domaine est requis.', # Translate - New
	'"[_1]" does not exist.' => '"[_1]" n\'existe pas.', # Translate - New
	'Invalid Path.' => 'Chemin invalide.', # Translate - New
	'This combination of domain and path already exists.' => 'Ce couple domaine / chemin existe déjà.', # Translate - New
	'IP is required.' => 'Une IP est requise.', # Translate - New
	'[_1] is invalid IP Address.' => '[_1] n\'est pas une adresse IP valide.', # Translate - New
	'IP restriction settings' => 'Réglages de restriction par IP', # Translate - New

## addons/Cloud.pack/tmpl/cfg_security.tmpl
	'Administration screen setting have been saved.' => 'Le réglage de l\'écran d\'administration a été sauvegardé.', # Translate - New
	'Administration screen url have been reset to default.' => 'L\'URL de l\'écran d\'administration a été réinitialisé à sa valeur par défaut.', # Translate - New
	'Admin Screen URL' => 'URL de l\'écran d\'administration', # Translate - New
	'Protect administration screen by Basic Authentication' => 'Protéger l\'écran d\'administration par une authentification basique', # Translate - New
	'Access Restriction' => 'Restriction d\'accès', # Translate - New
	'Restricts IP addresses that can access to administration screen.' => 'Restreint l\'accès à l\'écran d\'administration par adresses IP.', # Translate - New
	'Please add the IP address which allows access to the upper list. You can specify multiple IP addresses separated by commas or line breaks. When the current remote IP address  is not contained, it may become impossible to access an administration screen. For details.' => 'Ajoutez les adresses IP autorisées en haut de liste. Vous pouvez ajouter plusieurs adresses en les séparant par des virgules ou des suats de ligne. Si votre propre adresse IP n\'est pas incluse, il peut devenir impossible d\'accéder à l\'écran d\'administration. Détails ', # Translate - New
	'Your IP address is [_1].' => 'Votre adresse IP est [_1].', # Translate - New
	'Restricts IP address that can access to public CGI such as Search and Data API.' => 'Restreint par adresse IP l\'accès aux scripts CGI tels que la recherche ou l\'API Data.', # Translate - New
	'IP address list is required.' => 'Une liste d\'adresses IP est requise.', # Translate - New
	'administration screen' => 'écran d\'administration', # Translate - New
	' and ' => ' et ', # Translate - New
	'public access CGI' => 'Accès CGI public', # Translate - New
	'The remote IP address is not included in the white list ([_1]). Are you sure you want to restrict the current remote IP address?' => 'Votre adresse IP distante n\'est pas incluse dans la liste blanche ([_1]). Voulez-vous vraiment restreindre l\'adresse distante actuelle ?', # Translate - New
	'Are you sure you want to save restrict access settings?' => 'Voulez-vous vraiment sauvegarder ces réglages de restriction d\'accès ?', # Translate - New

## addons/Cloud.pack/tmpl/cfg_ssl_certification.tmpl
	'Install SSL Certification' => 'Installer un certificat SSL', # Translate - New
	'SSL certification have been updated.' => 'Le certificat SSL a été mis à jour.', # Translate - New
	'SSL certification have been reset to default.' => 'Le certificat SSL a été réinitialisé à sa valeur par défaut.', # Translate - New
	'The current server certification is as follows.' => 'La configuration du certificat serveur est la suivante.', # Translate - New
	q{To [_1] the server certificate, please enter the required information in the following fields. To revert back to the initial certificate, please press the 'Remove SSL Certification' button. The passphrase for 'Secret Key' must be released.} => q{Pour [_1] le certificat serveur, veuillez renseigner les champs suivants. Pour revenir au certificat précédent, utilisez le bouton 'Supprimer le certificat SSL'. Le mot de passe de la clé secrète doit être fourni.}, # Translate - New
	'Server Certification' => 'Certificat serveur', # Translate - New
	'Secret Key' => 'Clé secrète', # Translate - New
	'Intermediate Certification' => 'Certificat intermédiaire', # Translate - New
	'Remove SSL Certification' => 'Supprimer le certificat SSL', # Translate - New

## addons/Cloud.pack/tmpl/full_restore.tmpl
	'Restoring Full Backup Data' => 'Restauration complète des données de sauvegarde', # Translate - New
	q{Restored backup data from '[_1]' at [_2]} => q{Données de sauvegarde restaurées de '[_1]' à [_2]}, # Translate - New
	'When restoring back-up data, the contents will revert to the point when the back-up data was created. Please note that any changes made to the data, contents, and received comments and trackback after this restoration point will be discarded. Also, while in the process of restoration, any present data will be backed up automatically. After restoration is complete, it is possible to return to the status of the data before restoration was executed.' => 'En restaurant les données de sauvegarde, le contenu reviendra au point où ces données ont été sauvegardées. Toutes les modifications de données, contenus, commentaires et trackbacks effectuées après cette sauvegarde seront perdues. Notez que pendant le processus de restauration, les données actuelles seront sauvegardées. Une fois la restauration terminée, il sera possible de revenir à l\'état précédant cette restauration.', # Translate - New
	'Restore' => 'Restaurer', # Translate - New
	'Are you sure you want restore from selected backup file?' => 'Voulez-vous vraiment restaurer depuis le fichier de sauvegarde sélectionné ?', # Translate - New

## addons/Commercial.pack/config.yaml
	'https://www.sixapart.com/movabletype/' => 'https://www.movabletype.com/',
	'Professionally designed, well-structured and easily adaptable web site. You can customize default pages, footer and top navigation easily.' => 'Site au design professionnel, bien structuré et facilement adaptable. Vous pouvez personnaliser les pages par défaut, le pied de page et la navigation principale aisément.',
	q{_PWT_ABOUT_BODY} => q{
<p><strong>Remplacez par vos propres informations. </strong></p>
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In nec tellus sed turpis varius sagittis. Nullam pulvinar. Fusce dapibus neque pellentesque nulla. Maecenas condimentum quam. Vestibulum pretium fringilla quam. Nam elementum. Suspendisse odio magna, aliquam vitae, vulputate et, dignissim at, pede. Integer pellentesque orci at nibh. Morbi ante.</p>

<p>Maecenas convallis mattis justo. Ut mauris sapien, consequat a, bibendum vitae, sagittis ac, nisi. Nulla et sapien. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Ut condimentum turpis ut elit. Quisque ultricies sollicitudin justo. Duis vitae magna nec risus pulvinar ultricies.</p>
<!-- supprimez ce lien après l'édition -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl + '?__mode=view&_type=page&id=' + page_id + '&blog_id=' + blog_id; return false">Modifier ce contenu</a>
</p>
	},
	q{_PWT_CONTACT_BODY} => q{
<p><strong>Remplacez par vos propres informations.</strong></p>

<p>Contactez-nous. Envoyez un email à email (at) domainname.com</p>

<!-- remove this link after editing -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl + '?__mode=view&_type=page&id=' + page_id + '&blog_id=' + blog_id; return false">Modifier ce contenu</a>
</p>
	},
	'Welcome to our new website!' => 'Bienvenue sur notre nouveau site !',
	q{_PWT_HOME_BODY} => q{
<p><strong>Remplacez par vos propres informations.</strong></p>
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. In nec tellus sed turpis varius sagittis. Nullam pulvinar. Fusce dapibus neque pellentesque nulla. Maecenas condimentum quam. Aliquam erat volutpat. Ut placerat porta nibh. Donec vitae nulla. Pellentesque nisi leo, pretium a, gravida quis, sollicitudin non, eros. Vestibulum pretium fringilla quam. Nam elementum. Suspendisse odio magna, aliquam vitae, vulputate et, dignissim at, pede. Integer pellentesque orci at nibh. Morbi ante.</p>

<p>Maecenas convallis mattis justo. Ut mauris sapien, consequat a, bibendum vitae, sagittis ac, nisi. Nulla et sapien. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Ut condimentum turpis ut elit. Quisque ultricies sollicitudin justo. Duis vitae magna nec risus pulvinar ultricies. Aliquam sagittis volutpat metus.</p>

<p>Sed enim. Integer hendrerit, arcu ac pretium nonummy, velit turpis faucibus risus, pulvinar egestas enim elit sed ante. Curabitur orci diam, placerat a, faucibus id, condimentum vitae, magna. Etiam enim massa, convallis quis, rutrum vitae, porta quis, turpis.</p>
<!-- supprimez ce lien après l'édition -->
<p class="admin-edit-link">
<a href="#" onclick="location.href=adminurl + '?__mode=view&_type=page&id=' + page_id + '&blog_id=' + blog_id; return false">Modifier ce contenu</a>
</p>
	},
	q{Create a blog as a part of structured website. This works best with Professional Website theme.} => q{Créer un blog en tant que partie d'un site web. Cela fonctionne mieux avec un thème de sites web profeesionnels.},
	'Unknown Type' => 'Type inconnu',
	'Unknown Object' => 'Objet inconnu',
	'Not Required' => 'Non requis',
	'Are you sure you want to delete the selected CustomFields?' => 'Voulez-vous vraiment supprimer les champs personnalisés séléctionnés ?',
	'Photo' => 'Photo',
	'Embed' => 'Embarqué',
	'Custom Fields' => 'Champs personnalisés',
	'Template tag' => 'Tag du gabarit',
	'Updating Universal Template Set to Professional Website set...' => 'Mise à jour du jeu de gabarits universel vers sites web professionnels...',
	'Migrating CustomFields type...' => 'Migration du type de Champ Personnalisé en cours',
	'Converting CustomField type...' => 'Conversion du type CustomField...',
	'Professional Styles' => 'Styles professionnels',
	'A collection of styles compatible with Professional themes.' => 'Une collection de styles compatible avec des thèmes professionnels',
	'Professional Website' => 'Sites web professionnels',
	'Entry Listing' => 'Liste des notes',
	'Header' => 'Entête',
	'Footer' => 'Pied',
	'Entry Detail' => 'Détails de la note',
	'Entry Metadata' => 'Metadonnées de la note',
	'Page Detail' => 'Détails de la page',
	'Footer Links' => 'Liens de Pied de Page',
	'Powered By (Footer)' => 'Powered By (Pied de Page)',
	'Recent Entries Expanded' => 'Entrées étendues récentes',
	'Main Sidebar' => 'Colonne latérale principale',
	'Blog Activity' => 'Activité du blog',
	'Professional Blog' => 'Blog professionel',
	'Blog Archives' => 'Archives du blog',

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Date & Time' => 'Date & heure',
	'Date Only' => 'Date seulement',
	'Time Only' => 'Heure seulement',
	'Please enter all allowable options for this field as a comma delimited list' => 'Merci de saisir toutes les options autorisées pour ce champ dans une liste délimitée par des virgules',
	'Exclude Custom Fields' => 'Exclure les champs personnalisés',
	'[_1] Fields' => 'Champs des [_1]',
	'Create Custom Field' => 'Créer un champ personnalisé',
	'Invalid date \'[_1]\'; dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Date invalide \'[_1]\'. Les dates doivent être dans le format YYYY-MM-DD HH:MM:SS.',
	'Please enter valid URL for the URL field: [_1]' => 'Merci de saisir une URL correcte pour le champ URL : [_1]',
	'Please enter some value for required \'[_1]\' field.' => 'Merci de saisir une valeur pour le champ requis \'[_1]\'.',
	'Please ensure all required fields have been filled in.' => 'Merci de vérifier que tous les champs requis ont été renseignés.',
	'The template tag \'[_1]\' is an invalid tag name.' => 'Le tag de gabarit \'[_1]\' est un nom de tag invalide',
	'The template tag \'[_1]\' is already in use.' => 'Le tag de gabarit \'[_1]\' est déjà utilisé.',
	'blog and the system' => 'blog et le système',
	'website and the system' => 'site web et le système',
	'The basename \'[_1]\' is already in use. It must be unique within this [_2].' => 'Le nom de base \'[_1]\' est déjà utilisé. Il doit être unique dans ce [_2]',
	'You must select other type if object is the comment.' => 'Vous devez sélectionner d\'autre types si l\'objet est dans les commentaires.',
	'type' => 'Type',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'Personnalisez les champs des notes, pages, répertoires, catégories et auteurs pour stocker toutes les informations dont vous avez besoin.',
	' ' => ' ',
	'Single-Line Text' => 'Texte sur une ligne',
	'Multi-Line Text' => 'Texte multi-lignes',
	'Checkbox' => 'Case à cocher',
	'Drop Down Menu' => 'Menu déroulant',
	'Radio Buttons' => 'Boutons radio',
	'Embed Object' => 'Élément externe',
	'Post Type' => 'Type de note',

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Importing custom fields data stored in MT::PluginData...' => 'Import des données des champs personnalisés stockés dans MT::PluginData...',
	'Importing asset associations found in custom fields ( [_1] ) ...' => 'Import des associations d\'éléments trouvées dans les champs personnalisés ( [_1] )...',
	'Importing url of the assets associated in custom fields ( [_1] )...' => 'Import des URL des éléments associés aux champs personnalisés ( [_1] )...',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback/Field.pm
	'The type "[_1]" is invalid.' => 'Le type "[_1]" est invalide.',
	'The systemObject "[_1]" is invalid.' => 'Le paramètre systemObject "[_1]" est invalide.',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback.pm
	'Invalid date \'[_1]\'; dates should be real dates.' => 'Date invalide \'[_1]\'. Les dates doivent être de vraies dates.',
	'Please enter valid option for the [_1] field: [_2]' => 'Veuillez saisir une option valide pour le champ [_1] : [_2]',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Endpoint/v2/Field.pm
	'Invalid includeShared parameter provided: [_1]' => 'Le paramètre includeShared fourni est invalide : [_1]',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'The template tag \'[_1]\' is already in use in the system level' => 'Le tag de gabarit \'[_1]\' est déjà utilisé au niveau du système',
	'The template tag \'[_1]\' is already in use in [_2]' => 'Le tag de gabarit \'[_1]\' est déjà dans [_2]',
	'The template tag \'[_1]\' is already in use in this blog' => 'Le tag de gabarit \'[_1]\' est déjà dans ce blog',
	'The \'[_1]\' of the template tag \'[_2]\' that is already in use in [_3] is [_4].' => 'Le [_1] du tag de gabarit \'[_2]\' qui est déjà utilisé dans [_3] est [_3].',
	'_CF_BASENAME' => 'Nom de base',
	'__CF_REQUIRED_VALUE__' => 'Valeur requise',

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	'Are you sure you have used a \'[_1]\' tag in the correct context? We could not find the [_2]' => 'Etes-vous sûr d\'avoir utilisé un tag \'[_1]\' dans le contexte approprié ? Impossible de trouver le [_2]',
	'You used an \'[_1]\' tag outside of the context of the correct content; ' => 'Vous avez utilisé un tag \'[_1]\' en dehors du contexte de contenu correct ; ',

## addons/Commercial.pack/lib/CustomFields/Theme.pm
	'[_1] custom fields' => 'Champs personnalisés [_1]',
	'a field on this blog' => 'un champ sur ce blog',
	'a field on system wide' => 'un champ sur tout le système',
	'Conflict of [_1] "[_2]" with [_3]' => 'Conflit de [_1] "[_2]" avec [_3]',
	'Template Tag' => 'Tag de gabarit',

## addons/Commercial.pack/lib/CustomFields/Upgrade.pm
	'Moving metadata storage for pages...' => 'Déplacement de l\'emplacement des métadonnées des pages en cours...',
	'Removing CustomFields display-order from plugin data...' => 'Retrait de l\'ordre d\'affichage des champs personnalisés des données du plugin en cours...',
	'Removing unlinked CustomFields...' => 'Retrait des champs personnalisés sans lien en cours...',

## addons/Commercial.pack/lib/CustomFields/Util.pm
	'Cloning fields for blog:' => 'Clonage des champs du blog :',

## addons/Commercial.pack/templates/professional/blog/about_this_page.mtml

## addons/Commercial.pack/templates/professional/blog/archive_index.mtml

## addons/Commercial.pack/templates/professional/blog/archive_widgets_group.mtml

## addons/Commercial.pack/templates/professional/blog/author_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/calendar.mtml

## addons/Commercial.pack/templates/professional/blog/categories.mtml

## addons/Commercial.pack/templates/professional/blog/category_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/comment_detail.mtml

## addons/Commercial.pack/templates/professional/blog/comment_form.mtml

## addons/Commercial.pack/templates/professional/blog/comment_listing.mtml

## addons/Commercial.pack/templates/professional/blog/comment_preview.mtml

## addons/Commercial.pack/templates/professional/blog/comment_response.mtml

## addons/Commercial.pack/templates/professional/blog/comments.mtml

## addons/Commercial.pack/templates/professional/blog/creative_commons.mtml

## addons/Commercial.pack/templates/professional/blog/current_author_monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/current_category_monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/date_based_author_archives.mtml

## addons/Commercial.pack/templates/professional/blog/date_based_category_archives.mtml

## addons/Commercial.pack/templates/professional/blog/dynamic_error.mtml

## addons/Commercial.pack/templates/professional/blog/entry_detail.mtml

## addons/Commercial.pack/templates/professional/blog/entry_listing.mtml
	'Recently by <em>[_1]</em>' => 'Récemment par <em>[_1]</em>',

## addons/Commercial.pack/templates/professional/blog/entry_metadata.mtml

## addons/Commercial.pack/templates/professional/blog/entry.mtml

## addons/Commercial.pack/templates/professional/blog/entry_summary.mtml

## addons/Commercial.pack/templates/professional/blog/footer_links.mtml

## addons/Commercial.pack/templates/professional/blog/footer.mtml

## addons/Commercial.pack/templates/professional/blog/header.mtml

## addons/Commercial.pack/templates/professional/blog/javascript.mtml

## addons/Commercial.pack/templates/professional/blog/main_index.mtml

## addons/Commercial.pack/templates/professional/blog/main_index_widgets_group.mtml

## addons/Commercial.pack/templates/professional/blog/monthly_archive_dropdown.mtml

## addons/Commercial.pack/templates/professional/blog/monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/navigation.mtml

## addons/Commercial.pack/templates/professional/blog/openid.mtml

## addons/Commercial.pack/templates/professional/blog/page.mtml

## addons/Commercial.pack/templates/professional/blog/pages_list.mtml

## addons/Commercial.pack/templates/professional/blog/powered_by_footer.mtml

## addons/Commercial.pack/templates/professional/blog/recent_assets.mtml

## addons/Commercial.pack/templates/professional/blog/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] a commenté sur [_3]</a> : [_4]',

## addons/Commercial.pack/templates/professional/blog/recent_entries.mtml

## addons/Commercial.pack/templates/professional/blog/search.mtml

## addons/Commercial.pack/templates/professional/blog/search_results.mtml

## addons/Commercial.pack/templates/professional/blog/sidebar.mtml

## addons/Commercial.pack/templates/professional/blog/signin.mtml

## addons/Commercial.pack/templates/professional/blog/syndication.mtml

## addons/Commercial.pack/templates/professional/blog/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/blog/tags.mtml

## addons/Commercial.pack/templates/professional/blog/trackbacks.mtml

## addons/Commercial.pack/templates/professional/website/archive_index.mtml

## addons/Commercial.pack/templates/professional/website/blog_index.mtml

## addons/Commercial.pack/templates/professional/website/blogs.mtml
	'Entries ([_1]) Comments ([_2])' => 'Notes ([_1]) Commentaires ([_2])',

## addons/Commercial.pack/templates/professional/website/categories.mtml

## addons/Commercial.pack/templates/professional/website/comment_detail.mtml

## addons/Commercial.pack/templates/professional/website/comment_form.mtml

## addons/Commercial.pack/templates/professional/website/comment_listing.mtml

## addons/Commercial.pack/templates/professional/website/comment_preview.mtml

## addons/Commercial.pack/templates/professional/website/comment_response.mtml

## addons/Commercial.pack/templates/professional/website/comments.mtml

## addons/Commercial.pack/templates/professional/website/dynamic_error.mtml

## addons/Commercial.pack/templates/professional/website/entry_detail.mtml

## addons/Commercial.pack/templates/professional/website/entry_listing.mtml

## addons/Commercial.pack/templates/professional/website/entry_metadata.mtml

## addons/Commercial.pack/templates/professional/website/entry.mtml

## addons/Commercial.pack/templates/professional/website/entry_summary.mtml

## addons/Commercial.pack/templates/professional/website/footer_links.mtml

## addons/Commercial.pack/templates/professional/website/footer.mtml

## addons/Commercial.pack/templates/professional/website/header.mtml

## addons/Commercial.pack/templates/professional/website/javascript.mtml

## addons/Commercial.pack/templates/professional/website/main_index.mtml

## addons/Commercial.pack/templates/professional/website/navigation.mtml

## addons/Commercial.pack/templates/professional/website/openid.mtml

## addons/Commercial.pack/templates/professional/website/page.mtml

## addons/Commercial.pack/templates/professional/website/pages_list.mtml

## addons/Commercial.pack/templates/professional/website/powered_by_footer.mtml

## addons/Commercial.pack/templates/professional/website/recent_entries_expanded.mtml
	'on [_1]' => 'sur [_1]',
	'By [_1] | Comments ([_2])' => 'Par [_1] | Commentaires ([_1])',

## addons/Commercial.pack/templates/professional/website/search.mtml
	'Case sensitive' => 'Sensible à la casse',

## addons/Commercial.pack/templates/professional/website/search_results.mtml

## addons/Commercial.pack/templates/professional/website/sidebar.mtml

## addons/Commercial.pack/templates/professional/website/signin.mtml

## addons/Commercial.pack/templates/professional/website/syndication.mtml

## addons/Commercial.pack/templates/professional/website/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/website/tags.mtml

## addons/Commercial.pack/templates/professional/website/trackbacks.mtml

## addons/Commercial.pack/tmpl/asset-chooser.tmpl
	q{View image} => q{Voir l'image},

## addons/Commercial.pack/tmpl/category_fields.tmpl
	'Show These Fields' => 'Afficher ces champs',

## addons/Commercial.pack/tmpl/edit_field.tmpl
	'Edit Custom Field' => 'Éditer le champ personnalisé',
	'The selected field(s) has been deleted from the database.' => 'Les champs sélectionnés ont été effacés de la base de données.',
	'You must enter information into the required fields highlighted below before the custom field can be created.' => 'Vous devez entrer des informations dans le champ requis indiqué avant que le champ personnalisé soit créé.',
	q{You must save this custom field before setting a default value.} => q{Vous devez sauvegarder ce champ personnalisé avant d'indiquer une valeur par défaut.},
	q{Choose the system object where this custom field should appear.} => q{Sélectionnez l'objet système dans lequel le champ devra apparaître.},
	'Required?' => 'Requis ?',
	q{Must the user enter data into this custom field before the object may be saved?} => q{L'utilisateur doit-il entrer quelque chose dans ce champ avant que l'objet puisse être enregistré ?},
	'The basename must be unique within this [_1].' => 'Le nom de base doit être unique dans ce [_1]',
	q{Warning: Changing this field's basename may require changes to existing templates.} => q{Attention : le changement de ce nom de base peut nécessiter des changements additionnels dans vos gabarits existants.},
	'Example Template Code' => 'Code de gabarit exemple',
	'Show In These [_1]' => 'Afficher dans ces [_1]',
	'Save this field (s)' => 'Enregistrer ce champ (s)',
	'field' => 'champ',
	'fields' => 'Champs',
	'Delete this field (x)' => 'Supprimer ce champ (x)',

## addons/Commercial.pack/tmpl/export_field.tmpl
	'Object' => 'Objet',

## addons/Commercial.pack/tmpl/listing/field_list_header.tmpl

## addons/Commercial.pack/tmpl/reorder_fields.tmpl
	'open' => 'ouvrir',
	'click-down and drag to move this field' => 'gardez le clic maintenu et glissez le curseur pour déplacer ce champ',
	'click to %toggle% this box' => 'cliquez pour %toggle% cette boîte',
	'use the arrow keys to move this box' => 'utilisez les touches flêchées de votre clavier pour déplacer cette boîte',
	', or press the enter key to %toggle% it' => ', ou pressez la touche entrée pour la %toggle%',

## addons/Enterprise.pack/app-cms.yaml
	'Bulk Author Export' => 'Export auteurs en masse',
	'Bulk Author Import' => 'Importer les auteurs en masse',
	'Synchronize Users' => 'Synchroniser les utilisateurs',
	'Synchronize Groups' => 'Synchroniser les groupes',

## addons/Enterprise.pack/app-wizard.yaml
	'This module is required in order to use the LDAP Authentication.' => 'Ce module est nécessaire pour utiliser l\'identification LDAP.',

## addons/Enterprise.pack/config.yaml
	'https://www.sixapart.com/movabletype/' => 'https://www.movabletype.com/',
	'Advanced Pack' => 'Advanced Pack',
	'Oracle Database (Recommended)' => 'Base de données Oracle (Recommendé)',
	'Microsoft SQL Server Database' => 'Base de données Microsoft SQL Server',
	'Microsoft SQL Server Database UTF-8 support (Recommended)' => 'Support UTF-8 Base de données Microsoft SQL Server (recommendé)',
	'Publish Charset' => 'Publier le  Charset',
	'ODBC Driver' => 'Pilote ODBC',
	'External Directory Synchronization' => 'Synchronization répertoire externe',
	'Populating author\'s external ID to have lower case user name...' => 'Peuplement de l\'ID externe d\'auteur pour avoir des identifiants en minuscule...',

## addons/Enterprise.pack/lib/MT/Auth/LDAP.pm
	'Cannot connect to LDAP server.' => 'Impossible de se connecter au serveur LDAP.',
	'User [_1]([_2]) not found.' => 'Utilisateur [_1]([_2]) non trouvé.',
	'User \'[_1]\' cannot be updated.' => 'Utilisateur \'[_1]\' ne peut être mis à jour.',
	'User \'[_1]\' updated with LDAP login ID.' => 'Utilisateur \'[_1]\' mis à jour avec l\'ID de login LDAP.',
	'LDAP user [_1] not found.' => 'Utilisateur LDAP [_1] non trouvé.',
	'User [_1] cannot be updated.' => 'Utilisateur [_1] ne peut être mis à jour.',
	'User cannot be updated: [_1].' => 'Utilisateur ne peut être mis à jour : [_1].',
	'Failed login attempt by user \'[_1]\' who was deleted from LDAP.' => 'Échec lors de la tentative d\'identification de l\'utilisateur \'[_1]\' qui a été supprimé de LDAP',
	'User \'[_1]\' updated with LDAP login name \'[_2]\'.' => 'Utilisateur \'[_1]\' mis à jour avec l\'identifiant LDAP \'[_2]\'.',
	'Failed login attempt by user \'[_1]\'. A user with that username already exists in the system with a different UUID.' => 'Échec lors de la tentative d\'identification de l\'utilisateur \'[_1]\'. Un utilisateur avec ce nom d\'utilisateur existe déjà dans le système avec un UUID différent.',
	'User \'[_1]\' account is disabled.' => 'Le compte de l\'utilisateur \'[_1]\' est désactivé.',
	'LDAP users synchronization interrupted.' => 'Synchronisation des utilisateurs LDAP interrompue.',
	'Loading MT::LDAP::Multi failed: [_1]' => 'Le chargement de MT::LDAP::Multi a échoué : [_1]',
	'External user synchronization failed.' => 'Synchronisation utilisateur externe échouée.',
	'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'Une tentative de désactivation de tous les administrateurs système a été réalisée. La synchronisation des utilisateurs a été interrompue.',
	'Information about the following users was modified:' => 'Une information à propos des utilisateurs suivants a été modifiée :',
	'The following users were disabled:' => 'Les utilisateurs suivants ont été désactivés:',
	'LDAP users synchronized.' => 'Utilisateurs LDAP synchronisés.',
	'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute being set.' => 'La synchronisation des groupes ne peut pas être faite sans la configuration de LDAPGroupIdAttribute et/ou LDAPGroupNameAttribute.',
	'Primary group members cannot be synchronized with Active Directory.' => 'Les membres du groupe principal ne peuvent être synchronisés avec Active Directory.',
	'Cannot synchronize LDAP groups members.' => 'Impossible de synchroniser les membres des groupes LDAP.',
	'User filter was not built: [_1]' => 'Le filtre utilisateur n\'a pas été construit : [_1]',
	'LDAP groups synchronized with existing groups.' => 'Groupes LDAP synchronisés avec les groupes existants.',
	'Information about the following groups was modified:' => 'Une information à propos des groupes suivants a été modifiée :',
	'No LDAP group was found using the filter provided.' => 'Aucun groupe LDAP n\'a été trouvé en utilisant le filtre indiqué.',
	'The filter used to search for groups was: \'[_1]\'. Search base was: \'[_2]\'' => 'Le filtre utilisé pour la recherche dans les groupes était : \'[_1]\'. La base de la recherche était : \'[_2]\'',
	'(none)' => '(Aucun)',
	'The following groups were deleted:' => 'Les groupes suivants ont été effacés :',
	'Failed to create a new group: [_1]' => 'Impossible de créer un nouveau groupe : [_1]',
	'[_1] directive must be set to synchronize members of LDAP groups to Movable Type Advanced.' => 'La directive [_1] doit être configurée pour synchroniser les membres des groupes LDAP avec Movable Type Advanced.',
	'Cannot get group \'[_1]\' (#[_2]) entry and its all member attributes from external directory.' => 'Impossible d\'obtenir le groupe \'[_1]\' (#[_2]) et tous ses attributs membres depuis l\'annuaire externe.',
	'Cannot get member entries of group \'[_1]\' (#[_2]) from external directory.' => 'Impossible d\'obtenir les entrées membres du groupe \'[_1]\' (#[_2]) depuis l\'annuaire externe.',
	'Members removed: ' => 'Membres supprimés :',
	'Members added: ' => 'Membres ajoutés :',
	'Memberships in the group \'[_2]\' (#[_3]) were changed as a result of synchronizing with the external directory.' => 'Les appartenances au groupe \'[_2] (#[_3]) ont été changées par la synchronisation avec l\'annuaire externe.',
	'LDAPUserGroupMemberAttribute must be set to enable synchronizing of members of groups.' => 'LDAPUserGroupMemberAttribute doit être configuré pour permettre la synchronisation des membres des groupes.',

## addons/Enterprise.pack/lib/MT/Enterprise/Author.pm
	'Loading MT::LDAP failed: [_1].' => 'Échec de chargement MT::LDAP[_1]',

## addons/Enterprise.pack/lib/MT/Enterprise/BulkCreation.pm
	'Formatting error at line [_1]: [_2]' => 'Erreur de formattage à la ligne [_1] : [_2]',
	'Invalid command: [_1]' => 'Commande invalide : [_1]',
	'Invalid number of columns for [_1]' => 'Nombre de colonnes invalide pour [_1]',
	'Invalid user name: [_1]' => 'Identifiant invalide : [_1]',
	'Invalid display name: [_1]' => 'Nom d\'affichage invalide : [_1]',
	'Invalid email address: [_1]' => 'Adresse email invalide : [_1]',
	'Invalid password: [_1]' => 'Mot de passe invalide : [_1]',
	'A user with the same name was found.  The registration was not processed: [_1]' => 'Un utilisateur avec le même nom a été trouvé. L\'entregistrement n\'a pas été effectué : [_1]',
	'Permission granted to user \'[_1]\'' => 'Permission accordée à l\'utilisateur \'[_1]\'',
	'User \'[_1]\' already exists. The update was not processed: [_2]' => 'L\'utilisateur \'[_1] existe déjà. La mise à jour n\'a pas continué : [_2]',
	'User \'[_1]\' not found.  The update was not processed.' => 'L\'utilisateur \'[_1] n\'a pas trouvé. La mise à jour n\'a pas continué.',
	'User \'[_1]\' has been updated.' => 'L\'utilisateur \'[_1]\' a été mis à jour.',
	'User \'[_1]\' was found, but the deletion was not processed' => 'L\'utilisateur \'[_1] a été trouvé, mais la suppression n\'a pas été effectuée.',
	'User \'[_1]\' not found.  The deletion was not processed.' => 'L\'utilisateur \'[_1] n\'a pas trouvé. La suppression n\'a pas été effectuée.',
	'User \'[_1]\' has been deleted.' => 'L\'utilisateur \'[_1]\' a été supprimé.',

## addons/Enterprise.pack/lib/MT/Enterprise/CMS.pm
	q{Movable Type Advanced has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.} => q{Movable Type Advanced vient de tenter de désactiver votre compte pendant la synchronisation avec l'annuaire externe. Certains des paramètres du système de gestion externe des utilisateurs doivent être erronés. Merci de corriger avant de poursuivre.},
	'Bulk import cannot be used under external user management.' => 'L\'import en masse ne peut être utilisé avec la gestion externe des utilisateurs.',
	'Users & Groups' => 'Utilisateurs et Groupes',
	'Bulk management' => 'Gestion en masse',
	'No records were found in the file.  Make sure the file uses CRLF as the line-ending characters.' => 'Aucun enregistrement n\'a été trouvé dans le fichier. Veuillez vous assurer que le fichier utilise CRLF comme caractère de fin de ligne.',
	'Registered [quant,_1,user,users], updated [quant,_2,user,users], deleted [quant,_3,user,users].' => 'Création de [quant,_1,utilisateur,utilisateurs], modification de [quant,_2, utilisateur, utilisateurs], suppression de [quant,_3, utilisateur, utilisateurs].',
	'Bulk author export cannot be used under external user management.' => 'L\'exportation par lot ne peut pas être utilisé lors d\'une gestion des utilisateurs externe.',
	'A user cannot change his/her own username in this environment.' => 'Un utilisateur ne peut pas changer son nom d\'utilisateur dans cet environnement',
	'An error occurred when enabling this user.' => 'Une erreur s\'est produite pendant l\'activation de cet utilisateur.',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/Group.pm

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/User.pm

## addons/Enterprise.pack/lib/MT/Enterprise/Upgrade.pm
	'Fixing binary data for Microsoft SQL Server storage...' => 'Correction des données binaires pour le stockage Microsoft SQL Server...',

## addons/Enterprise.pack/lib/MT/Enterprise/Wizard.pm
	'PLAIN' => 'PLAIN',
	'CRAM-MD5' => 'CRAM-MD5',
	'Digest-MD5' => 'Digest-MD5',
	'Login' => 'Identifiant',
	'Found' => 'Trouvé',
	'Not Found' => 'Non trouvé',

## addons/Enterprise.pack/lib/MT/LDAP.pm
	'Invalid LDAPAuthURL scheme: [_1].' => 'LDAPAuthURL invalide : [_1].',
	'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'Soit votre serveur n\'a pas [_1] d\'installé, soit la version installée est trop vieille, ou [_1] nécessite un autre module qui n\'est pas installé',
	'Error connecting to LDAP server [_1]: [_2]' => 'Erreur de connection au serveur LDAP [_1] : [_2]',
	'Entry not found in LDAP: [_1]' => 'Entrée introuvable dans LDAP : [_1]',
	'Binding to LDAP server failed: [_1]' => 'Le rattachement au serveur LDAP a échoué : [_1]',
	'User not found in LDAP: [_1]' => 'L\'utilisateur n\'a pas été trouvé dans LDAP : [_1]',
	'More than one user with the same name found in LDAP: [_1]' => 'Plus d\'un utilisateur avec le même nom a été trouvé dans LDAP : [_1]',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/MSSQLServer.pm
	'PublishCharset [_1] is not supported in this version of the MS SQL Server Driver.' => 'PublishCharset [_1] n\'est pas supporté dans cette version du pilote MS SQL Server.',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/UMSSQLServer.pm
	'This version of UMSSQLServer driver requires DBD::ODBC version 1.14.' => 'Cette version du driver UMSSQLServer nécessite DBD::ODBC version 1.14.',
	'This version of UMSSQLServer driver requires DBD::ODBC compiled with Unicode support.' => 'Cette version du driver UMSSQLServer nécessite DBD::ODBC compilé avec le support de Unicode.',

## addons/Enterprise.pack/tmpl/author_bulk.tmpl
	'Manage Users in bulk' => 'Gérer les utilisateurs en masse',
	'_USAGE_AUTHORS_2' => 'Vous pouvez créer, modifier et effacer des utilisateurs en masse en chargeant un fichier CSV contenant ces commandes et les données associées.',
	'Upload source file' => 'Charger le fichier source',
	'Specify the CSV-formatted source file for upload' => 'Spécifier le fichier source CSV à charger',
	'Source File Encoding' => 'Encodage du fichier source',
	q{Movable Type will automatically try to detect the character encoding of your import file.  However, if you experience difficulties, you can set the character encoding explicitly.} => q{Movable Type va automatiquement essayer de détecter le système d'encodage de votre fichier d'importation. Cependant, si cela ne fonctionne pas, vous pouvez spécifier explicitement le système d'encodage.},
	'Upload (u)' => 'Charger (u)',

## addons/Enterprise.pack/tmpl/cfg_ldap.tmpl
	q{Authentication Configuration} => q{Configuration de l'identification},
	q{You must set your Authentication URL.} => q{Vous devez configurer votre URL d'identification.},
	'You must set your Group search base.' => 'Vous devez configurer votre base de recherche de groupes.',
	'You must set your UserID attribute.' => 'Vous devez configurer votre attribut UserID.',
	'You must set your email attribute.' => 'Vous devez configurer votre attribut email.',
	q{You must set your user fullname attribute.} => q{Vous devez configurer votre attribut nom complet de l'utilisateur.},
	q{You must set your user member attribute.} => q{Vous devez configurer votre attribut de membre de l'utilisateur.},
	'You must set your GroupID attribute.' => 'Vous devez configurer votre attribut GroupID.',
	'You must set your group name attribute.' => 'Vous devez configurer votre attribut nom de groupe.',
	'You must set your group fullname attribute.' => 'Vous devez configurer votre attribut nom complet du groupe.',
	'You must set your group member attribute.' => 'Vous devez configurer votre attribut member du groupe.',
	q{An error occurred while attempting to connect to the LDAP server: } => q{Une erreur s'est produite en essayant de se connecter au serveur LDAP :},
	q{You can configure your LDAP settings from here if you would like to use LDAP-based authentication.} => q{Vous devez configurer vos réglages LDAP ici si vous souhaitez utiliser l'identification LDAP.},
	'Your configuration was successful.' => 'Votre configuration est correcte.',
	q{Click 'Continue' below to configure the External User Management settings.} => q{Cliquez sur 'Continuer' ci-dessous pour configurer les réglages de la gestion externe des utilisateurs.},
	q{Click 'Continue' below to configure your LDAP attribute mappings.} => q{Cliquez sur 'Continuer' ci-dessous pour configurer vos rattachements des attributs LDAP.},
	'Your LDAP configuration is complete.' => 'Votre configuration LDAP est terminée.',
	q{To finish with the configuration wizard, press 'Continue' below.} => q{Pour finir l'assistant de configuration, cliquez sur 'Continuer' ci-dessous.},
	q{Cannot locate Net::LDAP. Net::LDAP module is required to use LDAP authentication.} => q{Net::LDAP impossible à localiser. Le module Net::LDAP est requis pour l'authentification LDAP.},
	'Use LDAP' => 'Utiliser LDAP',
	q{Authentication URL} => q{URL d'identification},
	q{The URL to access for LDAP authentication.} => q{L'URL pour accéder à l'identification LDAP.},
	'Authentication DN' => 'Identificatiin DN',
	q{An optional DN used to bind to the LDAP directory when searching for a user.} => q{Un DN optionnel utilisé pour rattacher à l'annuaire LDAP lors d'une recherche d'utilisateur.},
	q{Authentication password} => q{Mot de passe de l'identification},
	'Used for setting the password of the LDAP DN.' => 'Utilisé pour régler le mot de passe du DN LDAP.',
	'SASL Mechanism' => 'Mécanisme SASL',
	q{The name of the SASL Mechanism used for both binding and authentication.} => q{Le nom du mécanisme SASL est utilisé pour l'association et l'authentification.},
	'Test Username' => 'Identifiant de test',
	'Test Password' => 'Mot de passe de test',
	'Enable External User Management' => 'Activer les gestion externe des utilisateurs',
	'Synchronization Frequency' => 'Fréquence de synchronisation',
	'The frequency of synchronization in minutes. (Default is 60 minutes)' => 'La fréquence de synchronisation en minutes. (60 minutes par défaut).',
	'15 Minutes' => '15 Minutes',
	'30 Minutes' => '30 Minutes',
	'60 Minutes' => '60 Minutes',
	'90 Minutes' => '90 Minutes',
	'Group Search Base Attribute' => 'Attribut de base de recherche du groupe',
	'Group Filter Attribute' => 'Attribut de filtre du groupe',
	'Search Results (max 10 entries)' => 'Résultats de recherche (maxi 10 entrées)',
	'CN' => 'CN',
	q{No groups were found with these settings.} => q{Aucun groupe n'a été trouvé avec ces réglages.},
	q{Attribute mapping} => q{Rattachement d'attribut},
	'LDAP Server' => 'Serveur LDAP',
	'Other' => 'Autre',
	'User ID Attribute' => 'Attribut ID utilisateur',
	'Email Attribute' => 'Attribut email',
	'User Fullname Attribute' => 'Attribut nom complet utilisateur',
	'User Member Attribute' => 'Attribut membre utilisateur',
	'GroupID Attribute' => 'Attribut GroupID',
	'Group Name Attribute' => 'Attribut nom du groupe',
	'Group Fullname Attribute' => 'Attribut nom complet du groupe',
	'Group Member Attribute' => 'Attribut membre du groupe',
	'Search Result (max 10 entries)' => 'Résultat de recherche (maxi 10 entrées)',
	'Group Fullname' => 'Nom complet du groupe',
	'(and [_1] more members)' => '(et [_1] membres en plus)',
	q{No groups could be found.} => q{Aucun groupe n'a été trouvé.},
	'User Fullname' => 'Nom complet utilisateur',
	'(and [_1] more groups)' => '(et [_2] groupes en plus)',
	q{No users could be found.} => q{Aucun utilisateur n'a été trouvé.},
	'Test connection to LDAP' => 'Tester la connection à LDAP',
	'Test search' => 'Tester la recherche',

## addons/Enterprise.pack/tmpl/create_author_bulk_end.tmpl
	'All users were updated successfully.' => 'Tous les utilisateurs ont été mis à jour avec succès',
	'An error occurred during the update process. Please check your CSV file.' => 'Une erreur est apparue lors du processus de mise à jour. Veuillez vérifier votre fichier CSV.',

## addons/Enterprise.pack/tmpl/create_author_bulk_start.tmpl

## addons/Sync.pack/config.yaml
	'https://www.sixapart.com/movabletype/' => 'https://www.movabletype.com/',
	'Migrated sync setting' => 'Paramètres de synchronisation migrés',
	'Content Delivery' => 'Livraison de contenu',
	'Sync Name' => 'Nom de synchronisation',
	'Sync Datetime' => 'Horodatage de synchronisation',
	'Manage Sync Settings' => 'Gérer les paramètres de synchronisation',
	'Sync Setting' => 'Paramètre de synchronisation',
	'Sync Settings' => 'Paramètres de synchronisation',
	'Create new sync setting' => 'Créer un paramètre de synchronisation',
	'Contents Sync' => 'Synchronisation des contenus',
	'Remove sync PID files' => 'Supprimer les fichiers PID de synchronisation',
	'Updating MT::SyncSetting table...' => 'Mise à jour de la table MT::SyncSetting...',
	'Migrating settings of contents sync on website...' => 'Migration des paramètres de synchronisation des contenus sur le site...',
	'Migrating settings of contents sync on blog...' => 'Migration des paramètres de synchronisation des contenus sur le blog...',
	'Re-creating job of contents sync...' => 'Recréation de la tâche de synchronisation de contenu...',

## addons/Sync.pack/lib/MT/FileSynchronizer/FTPBase.pm
	'Cannot access to remote directory \'[_1]\'' => 'Impossible d\'accéder au répertoire distant \'[_1]\'',
	'Deleting file \'[_1]\' failed.' => 'La suppression du fichier \'[_1]\' a échoué.',
	'Deleting path \'[_1]\' failed.' => 'La suppression du chemin \'[_1]\' a échoué.',
	'Directory or file by which end of name is dot(.) or blank exists. Cannot synchronize these files.: "[_1]"' => 'Il existe un dossier ou fichier dont le suffixe est vide ou se termine par \'.\'. Ces fichiers ne peuvent pas être synchronisés : "[_1]"',
	'Unable to write temporary file ([_1]): [_2]' => 'Impossible d\'écrire dans le fichier temporaire ([_1]) : [_2]',
	'Unable to get size of temporary file ([_1]): [_2]' => 'Impossible de déterminer la taille du fichier temporaire ([_1]) : [_2]',
	'FTP reconnection was failed. ([_1])' => 'La connexion FTP a échoué. ([_1])',
	'FTP connection lost.' => 'La connexion FTP a été perdue.',
	'FTP connection timeout.' => 'La connexion FTP a expirée.',
	'Unable to write remote files. Please check activity log for more details.: [_1]' => 'Impossible d\'écrire les fichiers distants. Vérifiez le journal d\'activité pour plus de détails : [_1]',
	'Unable to write remote files ([_1]): [_2]' => 'Impossible d\'écrire les fichiers distants ([_1]) : [_2]',

## addons/Sync.pack/lib/MT/FileSynchronizer.pm
	'Failed to remove sync list. (ID:\'[_1]\')' => 'Impossible de supprimer la liste de synchronisation. (ID:\'[_1]\')',
	'Failed to update sync list. (ID:\'[_1]\')' => 'Impossible de mettre la liste de synchronisation à jour. (ID:\'[_1]\')',
	'Failed to create sync list.' => 'Impossible de créer la liste de synchronisation.',
	'Failed to save sync list. (ID:\'[_1]\')' => 'Impossible de sauvegarder la liste de synchronisation. (ID:\'[_1]\')',
	'Error switching directory.' => 'Erreur au changement de répertoire.',
	'Synchronization([_1]) with an external server([_2]) has been successfully finished.' => 'La synchronisation ([_1]) avec un serveur externe ([_2]) s\'est terminée avec succès.',
	'Failed to Synchronization([_1]) with an external server([_2]).' => 'Impossible de synchroniser ([_1]) avec un serveur externe ([_2]).',

## addons/Sync.pack/lib/MT/FileSynchronizer/Rsync.pm
	'Temp Directory [_1] is not writable.' => 'Le répertoire Temp [_1] n\'est pas ouvert en écriture.',
	'Incomplete file copy to Temp Directory.' => 'Copie de fichier incomplète vers le répertoire temporaire.', # Translate - New
	'Failed to remove "[_1]": [_2]' => 'Impossible de supprimer "[_1]" : [_2]', # Translate - New
	'Error during rsync: Command (exit code [_1]): [_2]' => 'Erreur à la synchronisation : commande (code de retour [_1]) : [_2]',

## addons/Sync.pack/lib/MT/SyncFileList.pm
	'Sync file list' => 'Liste des fichiers à synchroniser',

## addons/Sync.pack/lib/MT/SyncSetting.pm
	'Sync settings' => 'Paramètres de synchronisation',

## addons/Sync.pack/lib/MT/Worker/ContentsSync.pm
	'Sync setting # [_1] not found.' => 'Paramètre de synchronisation # [_1] introuvable.',
	'This sync setting is being processed already.' => 'Ce paramètre de synchronisation est déjà en cours de traitement.',
	'This email is to notify you that synchronization with an external server has been successfully finished.' => 'La synchronisation avec un serveur externe s\'est correctement terminée.',
	'Saving sync settings failed: [_1]' => 'La sauvegarde des paramètres de synchronisation a échoué : [_1]',
	'Failed to remove temporary directory: [_1]' => 'Impossible de supprimer le répertoire temporaire : [_1]',
	'Failed to remove pid file.' => 'Impossible de supprimer le fichier pid.',
	'This email is to notify you that failed to sync with an external server.' => 'La synchronisation avec un serveur externe a échoué.',

## addons/Sync.pack/lib/Sync/App/CMS.pm
	'Copied [_1]' => '[_1] copié',
	'Create Sync Setting' => 'Créer un paramètre de synchronisation',
	'The sync setting with the same name already exists.' => 'Un paramètre de synchronisation avec le même nom existe déjà.',
	'Reached the upper limit of the parallel execution.' => 'La limite maximale d\'exécution en parallèle est atteinte.',
	'Process ID can\'t be acquired.' => 'Impossible de déterminer l\'ID du processus.',
	'Sync setting \'[_1]\' (ID: [_2]) edited by [_3].' => 'Paramètre de synchronisation \'[_1]\' (ID : [_2]) édité par [_3].',
	'Sync setting \'[_1]\' (ID: [_2]) deleted by [_3].' => 'Paramètre de synchronisation \'[_1]\' (ID : [_2]) supprimé par [_3].',
	'An error occurred while attempting to connect to the FTP server \'[_1]\': [_2]' => 'Une erreur est survenue lors de la connexion avec le serveur FTP \'[_1]\' : [_2]',
	'An error occurred while attempting to retrieve the current directory from \'[_1]\'' => 'Une erreur est survenue lors de la tentative de récupération du répertoire courant depuis \'[_1]\'',
	'An error occurred while attempting to retrieve the list of directories from \'[_1]\'' => 'Une erreur est survenue lors de la tentative de récupération de la liste des répertoires depuis \'[_1]\'',

## addons/Sync.pack/lib/Sync/Upgrade.pm
	'Removing all jobs of contents sync...' => 'Suppression des tâches de synchronisation de contenu...',

## addons/Sync.pack/tmpl/cfg_contents_sync.tmpl
	'Contents Sync Settings' => 'Paramètres de synchronisation des contenus',
	'Contents sync settings has been saved.' => 'Les paramètres de synchronisation ont été sauvegardés.',
	'The sync settings has been copied but not saved yet.' => 'Les paramètres de synchronisation ont été copiés mais pas encore sauvegardés.',
	'One or more templates are set to the Dynamic Publishing. Dynamic Publishing may not work properly on the destination server.' => 'Un ou plusieurs gabarits sont en publication dynamique. La publication dynamique peut ne pas fonctionner correctement sur le serveur distant.',
	'Run synchronization now' => 'Lancer la synchronisation maintenant.',
	'Copy this sync setting' => 'Copier ce paramètre de synchronisation',
	'Sync Date' => 'Date de synchronisation',
	'Recipient for Notification' => 'Destinataire des notifications',
	q{Receive only error notification} => q{Ne recevoir que les notifications d'erreur.},
	'htaccess' => 'htaccess',
	'Do not send .htaccess and .htpasswd file' => 'Ne pas envoyer les fichiers .htaccess et .htpasswd',
	'Destinations' => 'Destinations',
	'Add destination' => 'Ajouter une destination',
	'Sync Type' => 'Type de synchronisation',
	'Sync type not selected' => 'Type de synchronisation non sélectionné',
	'FTP' => 'FTP',
	'Rsync' => 'Rsync',
	'FTP Server' => 'Serveur FTP',
	'Port' => 'Port',
	'SSL' => 'SSL',
	'Enable SSL' => 'Activer SSL',
	'Net::FTPSSL is not available.' => 'Net::FTPSSL est introuvable.',
	'Start Directory' => 'Répertoire de départ',
	'Rsync Destination' => 'Répertoire de destination',
	'Are you sure you want to run synchronization?' => 'Voulez-vous vraiment lancer la synchronisation ?',
	'Sync all files' => 'Synchroniser tous les fichiers',
	'Please select a sync type.' => 'Sélectionnez un type de synchronisation.',
	'Sync name is required.' => 'Un nom de synchronisation est requis.',
	'Sync name should be shorter than [_1] characters.' => 'Le nom de synchronisation doit faire moins de [_1] caractères.',
	'The sync date must be in the future.' => 'La date de synchronisation doit être dans le futur.',
	'Invalid time.' => 'Temps invalide.',
	'You must make one or more destination settings.' => 'Vous devez créer au moins une destination.',
	'Are you sure you want to remove this settings?' => 'Voulez-vous vraiment supprimer ces paramètres ?',

## addons/Sync.pack/tmpl/dialog/contents_sync_now.tmpl
	'Sync Now!' => 'Synchroniser maintenant !',
	'Preparing...' => 'Préparation...',
	'Synchronizing...' => 'Synchronisation...',
	'Finish!' => 'Terminé !',
	'The synchronization was interrupted. Unable to resume.' => 'La synchronisation a été interrompue. Impossible de reprendre.',

## plugins/BlockEditor/config.yaml
	'Block Editor.' => 'Éditeur de bloc.',
	'Block Editor' => 'Éditeur de bloc',

## plugins/BlockEditor/lib/BlockEditor/App.pm

## plugins/BlockEditor/lib/BlockEditor/BlockEditorFieldType/Image.pm

## plugins/BlockEditor/tmpl/cms/dialog/asset_modal.tmpl
	'Upload new image' => 'Envoyer une nouvelle image',

## plugins/BlockEditor/tmpl/cms/dialog/include/asset_upload_panel.tmpl

## plugins/BlockEditor/tmpl/cms/dialog/multi_asset_options.tmpl

## plugins/BlockEditor/tmpl/cms/field_html/field_html_multi_line_text.tmpl
	'Sort' => 'Trier', # Translate - New
	'No block in this field.' => 'Pas de bloc dans ce champ', # Translate - New
	q{Changing to plain text is not possible to return to the block edit.} => q{Changer pour du texte brut interdit le retour à l'éditeur de bloc.},
	q{Changing to block editor is not possible to result return to your current document.} => q{Changer pour l'éditeur de bloc ne permet pas de revenir facilement au présent document.},

## plugins/BlockEditor/tmpl/cms/include/async_asset_list.tmpl

## plugins/BlockEditor/tmpl/cms/include/insert_options.tmpl
	'Alt' => 'Alt',
	'Caption' => 'Légende',

## plugins/Comments/config.yaml
	'Provides Comments.' => 'Fournit des commentaires.',
	'Mark as Spam' => 'Considérer comme spam',
	'Remove Spam status' => 'Ne plus considérer comme spam',
	'Unpublish Comment(s)' => 'Annuler la publication de ce (ou ces) commentaire(s)',
	'Trust Commenter(s)' => 'Donner le statut fiable à ce commentateur',
	'Untrust Commenter(s)' => 'Retirer le statut fiable à ce commentateur',
	'Ban Commenter(s)' => 'Bannir ce commentateur',
	'Unban Commenter(s)' => 'Lever le bannissement de ce commentateur',
	'Registration' => 'Enregistrement',
	'Manage Commenters' => 'Gérer les auteurs de commentaire',
	'Comment throttle' => 'Limitation des commentaires',
	'Commenter Confirm' => 'Confirmation du commentateur',
	'Commenter Notify' => 'Notification du commentateur',
	'New Comment' => 'Nouveau commentaire',

## plugins/Comments/default_templates/comment_detail.mtml

## plugins/Comments/default_templates/commenter_confirm.mtml
	'Thank you for registering an account to comment on [_1].' => 'Merci de vous être enregistré pour commenter sur [_1].',
	'For your security and to prevent fraud, we ask you to confirm your account and email address before continuing. Once your account is confirmed, you will immediately be allowed to comment on [_1].' => 'Pour votre sécurité et lutter contre la fraude, nous vous prions de confirmer votre compte et adresse e-mail avant de continuer. Une fois votre compte confirmé, vous pourrez commenter immédiatement sur [_1].',
	q{To confirm your account, please click on the following URL, or cut and paste this URL into a web browser:} => q{Veuillez cliquer sur le lien suivant ou copier/coller l'adresse URL dans un navigateur :},
	q{If you did not make this request, or you don't want to register for an account to comment on [_1], then no further action is required.} => q{Si vous n'êtes pas à l'origine de cette demande, ou si vous ne souhaitez pas vous enregistrer pour commenter sur [_1], alors aucune action n'est nécessaire.},
	'Sincerely,' => 'Cordialement,',

## plugins/Comments/default_templates/commenter_notify.mtml
	q{This email is to notify you that a new user has successfully registered on the blog '[_1]'. Here is some information about this new user.} => q{Un nouvel utilisateur s\'est enregistré sur le blog '[_1]'. Voici quelques informations sur ce nouvel utilisateur.},
	'New User Information:' => 'Informations concernant ce nouvel utilisateur :',
	'Full Name: [_1]' => 'Nom complet : [_1]',
	q{To view or edit this user, please click on or cut and paste the following URL into a web browser:} => q{Pour voir ou modifier cet utilisateur, merci de cliquer ou copier-coller l'adresse suivante dans votre navigateur web :},

## plugins/Comments/default_templates/comment_listing.mtml

## plugins/Comments/default_templates/comment_preview.mtml

## plugins/Comments/default_templates/comment_response.mtml

## plugins/Comments/default_templates/comments.mtml

## plugins/Comments/default_templates/comment_throttle.mtml
	q{If this was an error, you can unblock the IP address and allow the visitor to add it again by logging in to your Movable Type installation, choosing Blog Config - IP Banning, and deleting the IP address [_1] from the list of banned addresses.} => q{En cas d'erreur, vous pouvez débloquer l'adresse IP et permettre au visiteur de la rajouter et se reconnectant à votre installation Movable Type. Choisir Configuration du blog - Blocage IP, et en supprimant l'adresse IP [_1] de la liste des adresses bloquées.},
	'A visitor to your blog [_1] has automatically been banned by adding more than the allowed number of comments in the last [_2] seconds.' => 'Un visiteur de votre blog [_1] a été automatiquement banni après avoir publié une quantité de commentaires supérieure à la limite établie au cours des dernières [_2] secondes.',
	'This was done to prevent a malicious script from overwhelming your weblog with comments. The banned IP address is' => 'Ceci a été fait pour prévenir un assaut de commentaires sur votre blog par un script malicieux.',

## plugins/Comments/default_templates/new-comment.mtml
	q{An unapproved comment has been posted on your site '[_1]', on entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.} => q{Un commentaire en attente de modération a été posté sur votre site '[_1]', sur la note #[_2] ([_3]). Vous devez l'approuver pour qu'il apparaisse sur votre site.},
	q{An unapproved comment has been posted on your site '[_1]', on page #[_2] ([_3]). You need to approve this comment before it will appear on your site.} => q{Un commentaire en attente de modération a été posté sur votre site '[_1]', sur la page #[_2] ([_3]). Vous devez l'approuver pour qu'il apparaisse sur votre site.},
	q{A new comment has been posted on your site '[_1]', on entry #[_2] ([_3]).} => q{Un commentaire en attente de modération a été posté sur votre site '[_1]', sur la note #[_2] ([_3]).},
	q{A new comment has been posted on your site '[_1]', on page #[_2] ([_3]).} => q{Un commentaire en attente de modération a été posté sur votre site '[_1]', sur la page #[_2] ([_3]).},
	'Commenter name: [_1]' => 'Nom du commentateur : [_1]',
	'Commenter email address: [_1]' => 'Adresse e-mail du commentateur :  [_1]',
	'Commenter URL: [_1]' => 'URL du commentateur : [_1]',
	'Commenter IP address: [_1]' => 'Adresse IP du commentateur : [_1]',
	'Approve comment:' => 'Approuver le commentaire :',
	'View comment:' => 'Voir le commentaire :',
	'Edit comment:' => 'Éditer le commentaire :',
	'Report the comment as spam:' => 'Signaler le commentaire comme spam :',

## plugins/Comments/default_templates/recent_comments.mtml

## plugins/Comments/lib/Comments/App/ActivityFeed.pm
	'[_1] Comments' => '[_1] commentaires',
	'All Comments' => 'Tous les commentaires',

## plugins/Comments/lib/Comments/App/CMS.pm
	'Are you sure you want to remove all comments reported as spam?' => 'Voulez-vous vraiment supprimer tous les commentaires reportés comme spam ?',
	'Delete all Spam comments' => 'Supprimer tous les commentaires marqués comme indésirables',

## plugins/Comments/lib/Comments/Blog.pm
	'Cloning comments for blog...' => 'Clonage des commentaires de blog...',

## plugins/Comments/lib/Comments/CMS/Search.pm

## plugins/Comments/lib/Comments/Import.pm
	'Creating new comment (from \'[_1]\')...' => 'Création d\'un nouveau commentaire (de \'[_1]\')...',
	'Saving comment failed: [_1]' => 'Échec de la sauvegarde du commentaire : [_1]',

## plugins/Comments/lib/Comments.pm
	'Search for other comments from anonymous commenters' => 'Chercher d\'autres commentaires anynomes',
	'__ANONYMOUS_COMMENTER' => 'Anonyme',
	'Search for other comments from this deleted commenter' => 'Chercher d\'autres commentaires de ce commentateur supprimé',
	'(Deleted)' => '(supprimé)',
	'Edit this [_1] commenter.' => 'Supprimer ce commentateur [_1]',
	'Comments on [_1]: [_2]' => 'Commentaires sur [_1] : [_2]',
	'Not spam' => 'Non spam',
	'Reported as spam' => 'Notifié comme spam',
	'All comments by [_1] \'[_2]\'' => 'Tous les commentaires par [_1] \'[_2]\'',
	'__COMMENTER_APPROVED' => 'Approuvé',
	'Moderator' => 'Modérateur',
	'Can comment and manage feedback.' => 'Peut commenter et gérer les commentaires.',
	'Can comment.' => 'Peut commenter.',
	'Comments on My Entries/Pages' => 'Commentaires sur mes notes/pages',
	'Entry/Page Status' => 'Status Note/Page',
	'Date Commented' => 'Date du commentaire',
	'Comments in This Website' => 'Commentaires dans ce site web',
	'Non-spam comments' => 'Commentaires marqués comme n\'étant pas du spam',
	'Non-spam comments on this website' => 'Commentaires n\'étant pas du spam sur ce site web',
	'Pending comments' => 'Commentaires en attente',
	'Published comments' => 'Commentaires publiés',
	'Comments on my entries/pages' => 'Commentaires sur mes notes/pages',
	'Comments in the last 7 days' => 'Commentaires des 7 derniers jours',
	'Spam comments' => 'Commentaires marqués comme étant du spam',
	'Enabled Commenters' => 'Auteurs de commentaire actifs',
	'Disabled Commenters' => 'Auteurs de commentaire désactivés',
	'Pending Commenters' => 'Auteurs de commentaire en attente',
	'Externally Authenticated Commenters' => 'Utilisateurs avec authentification externe',
	'Entries with Comments Within the Last 7 Days' => 'Notes avec commentaires ces 7 derniers jours',
	'Pages with comments in the last 7 days' => 'Pages commentées ces 7 derniers jours',

## plugins/Comments/lib/Comments/Upgrade.pm
	'Creating initial comment roles...' => 'Création des rôles initiaux de commentateurs...',

## plugins/Comments/lib/MT/App/Comments.pm
	'Error assigning commenting rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable commenting role was found.' => 'Erreur en assignant les droits de commenter à l\'utilisateur \'[_1] (ID:[_2])\' pour le blog \'[_3] (ID:[_4])\'. Aucun rôle de commentateur adéquat n\'a été trouvé.',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Tentative d\'identification échoué pour le commentateur [_1] sur le blog [_2] (ID:[_3]) qui n\'autorise pas l\'authentification native de Movable Type.',
	'Successfully authenticated, but signing up is not allowed.  Please contact your Movable Type system administrator.' => 'Authentification réussie, mais l\'enregistrement est interdit. Veuillez contacter votre administrateur Movable Type.',
	'You need to sign up first.' => 'Vous devez vous enregistrer d\'abord.',
	'Login failed: permission denied for user \'[_1]\'' => 'Identification échoué : accès interdit pour l\'utilisateur \'[_1]\'',
	'Login failed: password was wrong for user \'[_1]\'' => 'Identification échoué : mot de passe incorrect pour l\'utilisateur \'[_1]\'',
	'Signing up is not allowed.' => 'Enregistrement non autorisée.',
	'Movable Type Account Confirmation' => 'Confirmation de compte Movable Type',
	'Your confirmation has expired. Please register again.' => 'Votre confirmation a expirée. Veuillez vous enregistrer à nouveau.',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">Retourner à la page initiale</a>',
	'Commenter \'[_1]\' (ID:[_2]) has been successfully registered.' => 'Le commentateur \'[_1]\' (ID:[_2]) a été enregistré avec succès.',
	'Thanks for the confirmation.  Please sign in to comment.' => 'Merci pour la confirmation. Merci de vous identifier pour commenter.',
	'[_1] registered to the blog \'[_2]\'' => '[_1] est enregistré sur le blog \'[_2]\'',
	'No id' => 'Pas d\'id',
	'No such comment' => 'Pas de tel commentaire',
	'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'l\'IP [_1] a été bannie car elle a envoyé plus de 8 commentaires en  [_2] seconds.',
	'IP Banned Due to Excessive Comments' => 'IP bannie pour cause de commentaires excessifs',
	'No such entry \'[_1]\'.' => 'Aucune note \'[_1]\'.',
	'_THROTTLED_COMMENT' => 'Afin de réduire les abus, nous avons activé une fonction obligeant les auteurs de commentaire à attendre quelques instants avant de publier un autre commentaire. Veuillez attendre quelques instants avant de publier un autre commentaire. Merci.',
	'Comments are not allowed on this entry.' => 'Les commentaires ne sont pas autorisés sur cette note.',
	'Comment text is required.' => 'Le texte de commentaire est requis.',
	'Registration is required.' => 'L\'inscription est requise.',
	'Name and E-mail address are required.' => 'Le nom et l\'adresse e-mail sont requis.',
	'Invalid URL \'[_1]\'' => 'URL invalide \'[_1]\'',
	'Comment save failed with [_1]' => 'La sauvegarde du commentaire a échoué [_1]',
	'Comment on "[_1]" by [_2].' => 'Commentaire sur « [_1] » par [_2].',
	'Failed comment attempt by pending registrant \'[_1]\'' => 'Tentative de commentaire échoué par utilisateur  \'[_1]\' en cours d\'inscription',
	'The sign-in attempt was not successful; Please try again.' => 'La tentative d\'enregistrement a échoué. Veuillez réessayer.',
	'You are trying to redirect to external resources. If you trust the site, please click the link: [_1]' => 'Vous tentez de rediriger vers une resource extérieure. Si vous faites confiance à ce site, cliquez sur ce lien : [_1]',
	'No entry was specified; perhaps there is a template problem?' => 'Aucune note n\'a été spécifiée, peut-être y a-t-il un problème de gabarit ?',
	'Somehow, the entry you tried to comment on does not exist' => 'Il semble que la note que vous souhaitez commenter n\'existe pas',
	'Invalid entry ID provided' => 'ID de note fourni invalide',
	'All required fields must be populated.' => 'Tous les champs requis doivent être renseignés.',
	'Commenter profile has successfully been updated.' => 'Le profil du commentateur a été modifié avec succès.',
	'Commenter profile could not be updated: [_1]' => 'Le profil du commentateur n\'a pu être modifié : [_1]',

## plugins/Comments/lib/MT/CMS/Comment.pm
	'No such commenter [_1].' => 'Aucun commentateur [_1].',
	'User \'[_1]\' trusted commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\' a considéré comme fiable le commentateur \'[_2]\'.',
	'User \'[_1]\' banned commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\' a banni le commentateur \'[_2]\'.',
	'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\' a retiré le statut Banni à le commentateur \'[_2]\'.',
	'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'L\'utilisateur \'[_1]\' a retiré le statut Fiable à le commentateur \'[_2]\'.',
	'The parent comment id was not specified.' => 'L\'ID du commentaire parent est manquante.',
	'The parent comment was not found.' => 'Le commentaire parent est introuvable.',
	'You cannot reply to unapproved comment.' => 'Vous ne pouvez répondre à un commentaire non approuvé.',
	'You cannot create a comment for an unpublished entry.' => 'Vous ne pouvez pas créer un commentaire sur une note non publiée.',
	'You cannot reply to unpublished comment.' => 'Vous ne pouvez pas répondre à un commentaire non publié.',
	'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Commentaire (ID:[_1]) de \'[_2]\' supprimé par \'[_3]\' de la note \'[_4]\'',
	'You do not have permission to approve this trackback.' => 'Vous n\'avez pas la permission d\'approuver ce TrackBack.',
	'The entry corresponding to this comment is missing.' => 'La note correspondante à ce commentaire est manquante.',
	'You do not have permission to approve this comment.' => 'Vous n\'avez pas la permission d\'approuver ce commentaire.',
	'Orphaned comment' => 'Commentaire orphelin',

## plugins/Comments/lib/MT/DataAPI/Endpoint/Comment.pm

## plugins/Comments/lib/MT/Template/Tags/Commenter.pm
	'This \'[_1]\' tag has been deprecated. Please use \'[_2]\' instead.' => 'La balise \'[_1]\' est obsolète. Veuillez utiliser \'[_2]\' à la place.',

## plugins/Comments/lib/MT/Template/Tags/Comment.pm
	'The MTCommentFields tag is no longer available.  Please include the [_1] template module instead.' => 'La balise MTCommentFields n\'est plus disponible. Veuillez inclure le module de gabarit [_1] à la place.',

## plugins/Comments/php/function.mtcommentauthorlink.php

## plugins/Comments/php/function.mtcommentauthor.php

## plugins/Comments/php/function.mtcommenternamethunk.php
	'The \'[_1]\' tag has been deprecated. Please use the \'[_2]\' tag in its place.' => 'La balise \'[_1]\' est obsolète. Veuillez utiliser la balise \'[_2]\' à la place.',

## plugins/Comments/php/function.mtcommentreplytolink.php

## plugins/Comments/t/211-api-resource-objects.d/asset/from_object.yaml
	'Image photo' => 'Photo image',

## plugins/Comments/t/211-api-resource-objects.d/asset/to_object.yaml

## plugins/Comments/t/211-api-resource-objects.d/category/from_object.yaml

## plugins/Comments/t/211-api-resource-objects.d/category/to_object.yaml
	'Original Test' => 'Test original',

## plugins/Comments/t/211-api-resource-objects.d/entry/from_object.yaml

## plugins/Comments/t/213-api-resource-objects-disabled-fields.d/authenticated/asset/from_object.yaml

## plugins/Comments/t/213-api-resource-objects-disabled-fields.d/authenticated/entry/from_object.yaml

## plugins/Comments/t/213-api-resource-objects-disabled-fields.d/non-authenticated/asset/from_object.yaml

## plugins/Comments/t/213-api-resource-objects-disabled-fields.d/non-authenticated/entry/from_object.yaml

## plugins/FacebookCommenters/config.yaml
	q{Provides commenter registration through Facebook Connect.} => q{Permet l'enregistrement des auteurs de commentaires via Facebook Connect},
	'Facebook' => 'Facebook',

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm
	'Set up Facebook Commenters plugin' => 'Configurer le plugin Facebook Commenters',
	'The login could not be confirmed because of no/invalid blog_id' => 'Login non confirmé pour cause de blog_id inexistant ou invalide',
	'Authentication failure: [_1], reason:[_2]' => 'Échec de l\'authentification : [_1], raison : [_2]',
	'Failed to created commenter.' => 'Impossible de créer le commentateur.',
	'Failed to create a session.' => 'Impossible de créer une session.',
	'Facebook Commenters needs either Crypt::SSLeay or IO::Socket::SSL installed to communicate with Facebook.' => 'Facebook Commenters nécessite l\'installation de Crypt::SSLeay ou de IO::Socket::SSL pour communiquer avec Facebook.',
	'Please enter your Facebook App key and secret.' => 'Veuillez entrer votre clé et code secret d\'application Facebook.',
	'Could not verify this app with Facebook: [_1]' => 'impossible de vérifier cette application avec Facebook : [_1]',

## plugins/FacebookCommenters/tmpl/blog_config_template.tmpl
	q{OAuth Redirect URL of Facebook Login} => q{URL de redirection OAuth pour l'authentification Facebook},
	q{Please set this URL to "Valid OAuth redirect URIs" field of Facebook Login.} => q{Renseignez cette URL avec le champ "Valid OAuth redirect URIs" de l'authentification Facebook.},
	'Facebook App ID' => 'Clé Application Facebook',
	q{The key for the Facebook application associated with your blog.} => q{La clé pour l'application Facebook associée à votre blog.},
	q{Edit Facebook App} => q{Éditer l'application Facebook},
	'Create Facebook App' => 'Créer une application Facebook',
	'Facebook Application Secret' => 'Secret Application Facebook',
	q{The secret for the Facebook application associated with your blog.} => q{Le secret pour l'application Facebook associée à votre blog.},

## plugins/FormattedText/config.yaml
	'Manage boilerplate.' => 'Gérer le texte formaté',
	'Boilerplate' => 'Texte formaté',

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => 'Ajoute le bouton "Insérer du texte formaté" à TinyMCE.',

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => 'Impossible de charger le texte formaté.',

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Boilerplate' => 'Texte formaté',
	'Select a Boilerplate' => 'Sélectionnez un texte formaté',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Boilerplates' => 'Textes formatés',
	'Create Boilerplate' => 'Créer un texte formaté',
	'Are you sure you want to delete the selected boilerplates?' => 'Voulez-vous vraiment supprimer les textes formatés sélectionnés ?',
	'Boilerplate' => 'Texte formaté',
	'My Boilerplate' => 'Mon texte formaté',

## plugins/FormattedText/lib/FormattedText/DataAPI/Callback/FormattedText.pm
	'The boilerplate \'[_1]\' is already in use in this site.' => 'Le texte formaté \'[_1]\' est déjà utilisé sur ce site.',

## plugins/FormattedText/lib/FormattedText/DataAPI/Endpoint/v2/FormattedText.pm

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'The boilerplate \'[_1]\' is already in use in this blog.' => 'Le texte formaté \'[_1]\' est déjà utilisé sur ce blog.',

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Edit Boilerplate' => 'Éditer le texte formaté',
	'This boilerplate has been saved.' => 'Ce texte formaté a été enregistré.',
	'Save changes to this boilerplate (s)' => 'Enregistrer les modifications de ce texte formaté (s)',
	q{The boilerplate '[_1]' is already in use in this blog.} => q{Le texte formaté '[_1]' est déjà utilisé sur ce blog.},

## plugins/FormattedText/tmpl/cms/list_formatted_text.tmpl
	'The boilerplate has been deleted from the database.' => 'Le texte formaté a été supprimé de la base de données.',

## plugins/GoogleAnalytics/config.yaml
	'Site statistics plugin using Google Analytics.' => 'Statistiques du site via Google Analytics.',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/App.pm
	'A Perl module required for using Google Analytics API is missing: [_1].' => 'Un module Perl requis pour utiliser l\'API Google Analytics API est manquant : [_1].',
	'You did not specify a client ID.' => 'Vous n\'avez pas fourni d\'ID client.',
	'You did not specify a code.' => 'Vous n\'avez pas fourni de code.',
	'The name of the profile' => 'Le nom du profil',
	'The web property ID of the profile' => 'L\'ID de propriété web du profil',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/OAuth2.pm
	'An error occurred when getting token: [_1]: [_2]' => 'Une erreur est survenue à la récupération du jeton [_1] : [_2]',
	'An error occurred when refreshing access token: [_1]: [_2]' => 'Une erreur est survenue au rafraîchissement du jeton d\'accès : [_1] : [_2]',
	'An error occurred when getting accounts: [_1]: [_2]' => 'Une erreur est survenue à la récupération des compte : [_1] : [_2]s',
	'An error occurred when getting profiles: [_1]: [_2]' => 'Une erreur est survenue à la récupération des profils : [_1] : [_2]',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/Provider.pm
	'An error occurred when retrieving statistics data: [_1]: [_2]' => 'Une erreur est survenue à la récupération des données statistiques : [_1] : [_2]',

## plugins/GoogleAnalytics/tmpl/api_error.tmpl
	'API error' => 'Erreur API',

## plugins/GoogleAnalytics/tmpl/select_profile.tmpl
	'Select profile' => 'Sélectionner un profil',

## plugins/GoogleAnalytics/tmpl/web_service_config.tmpl
	'Google Analytics' => 'Google Analytics',
	'OAuth2 settings' => 'Paramètres OAuth2',
	'This [_2] is using the settings of [_1].' => 'Ce [_2] utilise les paramètres de [_1].',
	'Other Google account' => 'Autre compte Google',
	q{Create an OAuth2 application's Client ID for web applications with this redirect URI via <a href="https://cloud.google.com/console" target="_blank">Google Cloud Platform</a> before selecting profile.} => q{Créez un ID client d'application OAuth2 pour application web avec cette URI de redirection via <a href="https://cloud.google.com/console" target="_blank">la plateforme Google Cloud/a> avant de sélectionner un profil.},
	q{Redirect URI of the OAuth2 application} => q{URL de redirection de l'application OAuth2},
	q{Client ID of the OAuth2 application} => q{ID Client de l'application OAuth2},
	q{Client secret of the OAuth2 application} => q{Secret Client de l'application OAuth2},
	'Google Analytics profile' => 'Profil Google Analytics',
	'Select Google Analytics profile' => 'Sélectionnez le profil Google Analytics',
	'(No profile selected)' => '(Aucun profil sélectionné)',
	q{Client ID or client secret for Google Analytics was changed, but profile was not updated. Are you sure you want to save these settings?} => q{L'ID ou le secret client de l'application OAuth2 a été modifié mais le profil n'a pas été mis à jour. Êtes-vous sûr de vouloir sauvegarder ces paramètres ?},

## plugins/Loupe/lib/Loupe/App.pm
	q{Loupe settings has been successfully. You can send invitation email to users via <a href="[_1]">Loupe Plugin Settings</a>.} => q{Le paramétrage de Loupe est correct. Vous pouvez envoyer un e-mail d'invitation via les <a href="[_1]">réglages du plugin Loupe</a>.},
	'Error saving Loupe settings: [_1]' => 'Impossible de sauvegarder les réglages de Loupe : [_1]',
	'Send invitation email' => 'Envoyer un e-mail d\'invitation',
	'Could not send a invitation mail because Loupe is not enabled.' => 'Impossible d\'envoyer un e-mail d\'invitation car Loupe n\'est pas activée.',
	'Welcome to Loupe' => 'Bienvenue sur Loupe',

## plugins/Loupe/lib/Loupe/Mail.pm
	'Loupe invitation mail has been sent to [_3] for user \'[_1]\' (user #[_2]).' => 'Un e-mail d\'invitation a été envoyé à [_3] pour l\'utilisateur \'[_1]\' (utilisateur #[_2]).',

## plugins/Loupe/lib/Loupe.pm
	'Loupe\'s HTML file name must not be blank.' => 'Le nom du fichier HTML de Loupe ne peut pas être vide.',
	'The URL should not include any directory name: [_1]' => 'L\'URL ne doit contenir aucun nom de répertoire : [_1]',
	'Could not create Loupe directory: [_1]' => 'Impossible de créer le répertoire de Loupe : [_1]',
	'Loupe HTML file has been created: [_1]' => 'Le fichier HTML de Loupe a été créé : [_1]',
	'Could not create Loupe HTML file: [_1]' => 'Impossible de créer le fichier HTML de Loupe : [_1]',
	'Loupe HTML file has been deleted: [_1]' => 'Le fichier HTML de Loupe a été supprimé : [_1]',
	'Could not delete Loupe HTML file: [_1]' => 'Impossible de supprimer le fichier HTML de Loupe : [_1]',

## plugins/Loupe/lib/Loupe/Upgrade.pm
	'Adding Loupe dashboard widget...' => 'Ajout du widget Loupe au tableau de bord...',

## plugins/Loupe/Loupe.pl
	'Loupe is a mobile-friendly alternative console for Movable Type to let users approve pending entries and comments, upload photos, and view website and blog statistics.' => 'Loupe est une interface Movable Type alternative conçue pour mobile qui permet aux utilisateurs de modérer notes et commentaires, charger des images et voir les statistiques des sites et des blogs.',

## plugins/Loupe/tmpl/dialog/welcome_mail_result.tmpl
	q{Send Loupe welcome email} => q{Envoyer un e-mail d'invitation à Loupe},

## plugins/Loupe/tmpl/system_config.tmpl
	'Enable Loupe' => 'Activer Loupe',
	q{The URL of Loupe's HTML file.} => q{L'URL du fichier HTML de Loupe.},
	q{Send invitation email} => q{Envoyer un e-mail d'invitation},

## plugins/Loupe/tmpl/welcome_mail_html.tmpl
	q{Your MT blog status at a glance} => q{Le status de votre blog MT en un coup d'œil},
	'Dear [_1], ' => 'Cher [_1]',
	q{With Loupe, you can check the status of your blog without having to sign in to your Movable Type account.} => q{Avec Loupe vous pouvez surveiller l'état de votre blog sans avoir à vous connecter à votre compte Movable Type.},
	q{View Access Analysis} => q{Voir les statistiques d'accès},
	'Approve Entries' => 'Approuver des notes',
	'Reply to Comments' => 'Répondre aux commentaires',
	'Loupe is best used with a smartphone (iPhone or Android 4.0 or higher)' => 'Loupe est conçu pour les smartphones (iPhone ou Android 4.0 ou supérieur)',
	'Try Loupe' => 'Essayez Loupe',
	'Perfect for Mini-tasking' => 'Parfait pour les mini-tâches',
	q{_LOUPE_BRIEF} => q{« Laquelle de mes notes est la plus populaire maintenant ? » « Ai-je des notes en attente d'approbation ? » « Je dois vraiment répondre à ce commentaire rapidement… » Toutes ces mini-tâches peuvent être faites directement depuis votre smartphone. Nous avons conçu Loupe pour gérer vos blogs aussi facilement que possible.},
	'Use Loupe to help manage your Movable Type blogs no matter where you are!' => 'Utilisez Loupe pour gérer vos blogs Movable Type où que vous soyez !',
	'Social Media' => 'Média sociaux',
	'https://twitter.com/movabletype' => 'https://twitter.com/movabletype',
	'Contact Us' => 'Nous contacter',
	'http://www.movabletype.org/' => 'http://www.movabletype.org/',
	'http://plugins.movabletype.org' => 'http://plugins.movabletype.org',

## plugins/Loupe/tmpl/welcome_mail_plain.tmpl
	q{Loupe is ready for use!} => q{Loupe est prête à l'emploi !},

## plugins/Loupe/tmpl/widget/welcome_to_loupe.tmpl
	q{Loupe is a mobile-friendly alternative console for Movable Type to let users approve pending entries and comments, upload photos, and view website and blog statistics. <a href="http://www.movabletype.org/documentation/loupe/" target="_blank">See more details.</a>} => q{Loupe est une console alternative de Movable Type conçue pour mobiles, permettant aux utilisateurs d'approuver notes et commentaires, charger des photos, et voir les statistiques des sites et des blogs. <a href="http://www.movabletype.org/documentation/loupe/" target="_blank">En savoir plus</a>.},
	'Loupe can be used without complex configuration, you can get started immediately.' => 'Loupe peut être utilisée sans configuration compliquée, vous pouvez démarrer immédiatement.',
	'Configure Loupe' => 'Configurer Loupe',

## plugins/Markdown/Markdown.pl
	'A plain-text-to-HTML formatting plugin.' => 'Un plugin de formatage de texte brut vers HTML',
	'Markdown' => 'Markdown',
	'Markdown With SmartyPants' => 'Markdown avec SmartyPants',

## plugins/Markdown/SmartyPants.pl
	q{Easily translates plain punctuation characters into 'smart' typographic punctuation.} => q{Permet de convertir facilement des caractères de ponctuation basiques vers une ponctuation plus complexe (comme les guillemets, tirets, etc...)},

## plugins/OpenID/config.yaml
	q{Provides OpenID authentication.} => q{Fournit l'authentification OpenID.},

## plugins/OpenID/lib/MT/Auth/GoogleOpenId.pm
	'A Perl module required for Google ID commenter authentication is missing: [_1].' => 'Le module Perl nécessaire pour l\'authentification de commentateur par Google ID est manquant : [_1].',

## plugins/OpenID/lib/MT/Auth/OpenID.pm
	'Could not save the session' => 'Impossible de sauver la session',
	'Could not load Net::OpenID::Consumer.' => 'Impossible de charger Net::OpenID::Consumer.',
	'The address entered does not appear to be an OpenID endpoint.' => 'L\'adresse entrée ne semble pas être un service OpenID',
	'The text entered does not appear to be a valid web address.' => 'Le texte entré ne semble pas être une adresse web valide.',
	'Unable to connect to [_1]: [_2]' => 'Impossible de se connecter à [_1] : [_2]',
	'Could not verify the OpenID provided: [_1]' => 'La vérification de l\'OpenID entré a échoué : [_1]',
	'The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.' => 'Le module Perl nécessaire pour l\'authentification OpenID (Digest::SHA1) est manquant.',

## plugins/OpenID/tmpl/comment/auth_aim.tmpl
	'Your AIM or AOL Screen Name' => 'Votre pseudonyme AIM ou AOL.',
	'Sign in using your AIM or AOL screen name. Your screen name will be displayed publicly.' => 'Identifiez-vous en utilisant votre pseudonyme AIM ou AOL. Votre pseudonyme sera affiché publiquement.',

## plugins/OpenID/tmpl/comment/auth_googleopenid.tmpl
	'Sign in using your Gmail account' => 'Identifiez-vous en utilisant votre compte Gmail',
	'Sign in to Movable Type with your[_1] Account[_2]' => 'Identifiez-vous dans Movable Type avec votre compte [_1] [_2]',

## plugins/OpenID/tmpl/comment/auth_hatena.tmpl
	'Your Hatena ID' => 'Votre identifiant Hatena',

## plugins/OpenID/tmpl/comment/auth_livedoor.tmpl

## plugins/OpenID/tmpl/comment/auth_livejournal.tmpl
	'Your LiveJournal Username' => 'Votre identifiant LiveJournal',
	'Learn more about LiveJournal.' => 'En savoir plus sur LiveJournal.',

## plugins/OpenID/tmpl/comment/auth_openid.tmpl
	'OpenID URL' => 'URL OpenID',
	q{Sign in with one of your existing third party OpenID accounts.} => q{Identifiez-vous avec l'une de vos identités OpenID tierce partie.},
	'http://www.openid.net/' => 'https://openid.net',
	'Learn more about OpenID.' => 'En savoir plus sur OpenID.',

## plugins/OpenID/tmpl/comment/auth_wordpress.tmpl
	'Your Wordpress.com Username' => 'Votre pseudonyme WordPress.com',
	'Sign in using your WordPress.com username.' => 'Identifiez-vous en utilisant votre pseudonyme WordPress.com',

## plugins/OpenID/tmpl/comment/auth_yahoojapan.tmpl
	'Turn on OpenID for your Yahoo! Japan account now' => 'Activer OpenID pour votre compte Yahoo! Japon maintenant',

## plugins/OpenID/tmpl/comment/auth_yahoo.tmpl
	'Turn on OpenID for your Yahoo! account now' => 'Activer OpenID pour votre compte Yahoo! maintenant',

## plugins/spamlookup/lib/spamlookup.pm
	'Failed to resolve IP address for source URL [_1]' => 'Échec de la vérification de l\'adresse IP pour l\'URL source [_1]',
	'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Modération : l\'IP du domaine ne correspond pas à l\'IP de ping pour l\'URL de la source [_1], IP du domaine : [_2], IP du ping : [_3]',
	'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'L\'IP du domaine ne correspond pas à l\'IP du ping pour l\'URL source [_1], l\'IP du domaine : [_2], IP du ping : [_3]',
	'No links are present in feedback' => 'Aucun lien n\'est présent dans le message',
	'Number of links exceed junk limit ([_1])' => 'Le nombre de liens a dépassé la limite de marquage comme spam ([_1])',
	'Number of links exceed moderation limit ([_1])' => 'Le nombre de liens a dépassé la limite de modération ([_1])',
	'Link was previously published (comment id [_1]).' => 'Le lien a été publié précédemment (ID de commentaire [_1]).',
	'Link was previously published (TrackBack id [_1]).' => 'Le lien a été publié précédemment (ID de trackback [_1]).',
	'E-mail was previously published (comment id [_1]).' => 'L\'e-mail a été publié précédemment (ID de commentaire [_1]).',
	'Word Filter match on \'[_1]\': \'[_2]\'.' => 'Le filtre de mot correspond sur \'[_1]\' : \'[_2]\'.',
	'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'Modération pour filtre de mot sur \'[_1]\' : \'[_2]\'.',
	'domain \'[_1]\' found on service [_2]' => 'domaine \'[_1]\' trouvé sur le service [_2]',
	'[_1] found on service [_2]' => '[_1] trouvé sur le service [_2]',

## plugins/spamlookup/spamlookup.pl
	'SpamLookup module for using blacklist lookup services to filter feedback.' => 'Module SpamLookup pour utiliser les services de vérification de liste noire pour filtrer les commentaires.',
	'SpamLookup IP Lookup' => 'SpamLookup vérification des IP',
	'SpamLookup Domain Lookup' => 'SpamLookup vérification des domaines',
	'SpamLookup TrackBack Origin' => 'SpamLookup origine des TrackBacks',
	'Despam Comments' => 'Commentaires non-spam',
	'Despam TrackBacks' => 'TrackBacks non-spam',
	'Despam' => 'Non-spam',

## plugins/spamlookup/spamlookup_urls.pl
	'SpamLookup module for junking and moderating feedback based on link filters.' => 'Module SpamLookup pour marquer comme spam et modérer les messages basé sur les filtres de liens.',
	'SpamLookup Link Filter' => 'SpamLookup filtre de lien',
	'SpamLookup Link Memory' => 'SpamLookup mémorisation des liens',
	'SpamLookup Email Memory' => 'SpamLookup mémorisation des emails',

## plugins/spamlookup/spamlookup_words.pl
	'SpamLookup module for moderating and junking feedback using keyword filters.' => 'Module SpamLookup pour modérer et marquer comme spam les messages en utilisant des filtres de mots-clés.',
	'SpamLookup Keyword Filter' => 'SpamLookup filtre de mots-clés',

## plugins/spamlookup/tmpl/lookup_config.tmpl
	q{Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the site's Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.} => q{Lookups surveille les adresses IP sources et les liens de tout feedback entrant. Si un commentaire ou un TrackBack provient d'une adresse ou d'un domaine en liste noire, il est retenu pour modération ou déclaré comme spam et placé dans le dossier spam du site. En outre, des vérifications avancées peuvent être faites sur les données TrackBack sources.},
	'IP Address Lookups' => 'Vérifier une adresse IP',
	'Moderate feedback from blacklisted IP addresses' => 'Modérer les commentaires/TrackBacks des adresses IP en liste noire',
	'Junk feedback from blacklisted IP addresses' => 'Marquer comme spam les commentaires/TrackBacks des adresses IP en liste noire',
	'Adjust scoring' => 'Ajuster la notation',
	'Score weight:' => 'Poids de la notation :',
	'block' => 'bloquer',
	q{IP Blacklist Services} => q{Services de liste noire d'IP},
	'Domain Name Lookups' => 'Vérifier un nom de domaine',
	'Moderate feedback containing blacklisted domains' => 'Modérer le contenu des messages contenant des domaines en liste noire',
	'Junk feedback containing blacklisted domains' => 'Marquer comme spam les messages contenant des domaines en liste noire',
	'Domain Blacklist Services' => 'Services de liste noire de domaines',
	'Advanced TrackBack Lookups' => 'Vérifications avancées des TrackBacks',
	'Moderate TrackBacks from suspicious sources' => 'Modérer les TrackBacks de sources suspectes',
	'Junk TrackBacks from suspicious sources' => 'Marquer comme spam les TrackBacks de sources suspectes',
	'Lookup Whitelist' => 'Vérifier la liste blanche',
	'To prevent lookups for specific IP addresses or domains, list each on a line by itself.' => 'Pour ne pas effectuer de vérifications pour des noms de domaines ou addresses IP spécifiques, listez-les ligne par ligne.',

## plugins/spamlookup/tmpl/url_config.tmpl
	q{Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)} => q{Les filtres de liens surveillent le nombre de liens hypertextes dans les messages entrants. Les messages avec beaucoup de liens peuvent être retenus pour modération ou marqués comme spam. Inversement, les messages qui ne contiennent pas de liens ou lient seulement vers des URLs publiées précédemment peuvent être notés positivement. (N'activez cette option que si vous êtes sûr que votre site est déjà dépourvu de spam.)},
	'Link Limits' => 'Limite de liens',
	q{Credit feedback rating when no hyperlinks are present} => q{Créditer la notation du message quand aucun lien hypertexte n'est présent},
	'Moderate when more than' => 'Modérer quand plus de',
	'link(s) are given' => 'liens sont présents',
	'Junk when more than' => 'Marquer comme spam quand plus de',
	'Link Memory' => 'Mémorisation des liens',
	q{Credit feedback rating when &quot;URL&quot; element of feedback has been published before} => q{Créditer la notation du message quand l'élément &quot;URL&quot; du message a été publié précédemment},
	q{Only applied when no other links are present in message of feedback.} => q{Appliquer seulement quand aucun autre lien n'est présent quand le texte du message.},
	'Exclude URLs from comments published within last [_1] days.' => 'Exclure les URLs des commentaires publiés dans les [_1] derniers jours.',
	'Email Memory' => 'Mémorisation des e-mails',
	q{Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address} => q{Créditer la notation du message lorsque des commentaires publiés précédemment contenaient l'adresse &quot;e-mail&quot;},
	'Exclude Email addresses from comments published within last [_1] days.' => 'Exclure les adresses e-mail des commentaires publiés dans les [_1] derniers jours.',

## plugins/spamlookup/tmpl/word_config.tmpl
	'Incoming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Les messages entrant peuvent être analysés pour détecter des mots-clés spécifiques, des noms de domaines et des modèles. Les messages correspondants peuvent être retenus pour modération ou marqués comme spam. De plus, les notes de spam pour ces messages peuvent être personnalisées.',
	'Keywords to Moderate' => 'Mots-clés à modérer',
	'Keywords to Junk' => 'Mots-clés à marquer comme spam',

## plugins/Textile/textile2.pl
	'A humane web text generator.' => 'Générateur de texte convivial',
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.org/documentation/appendices/tags/%t.html',
	'Textile 2' => 'Textile 2',

## plugins/TinyMCE/config.yaml
	'Default WYSIWYG editor.' => 'Éditeur riche par défaut',
	'TinyMCE' => 'TinyMCE',

## plugins/Trackback/config.yaml
	'Provides Trackback.' => 'Fournit des Trackbacks.',
	'Mark as Spam' => 'Considérer comme spam',
	'Remove Spam status' => 'Ne plus considérer comme spam',
	'Unpublish TrackBack(s)' => 'Annuler la publication de ce (ou ces) TrackBacks(s)',
	'weblogs.com' => 'weblogs.com',
	'New Ping' => 'Nouveau ping',

## plugins/Trackback/default_templates/new-ping.mtml
	q{An unapproved TrackBack has been posted on your site '[_1]', on entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Un TrackBack en attente de modération a été posté sur votre site '[_1]', sur la note #[_2] ([_3]). Vous devez l'approuver pour qu'il apparaisse sur votre site.},
	q{An unapproved TrackBack has been posted on your site '[_1]', on page #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Un TrackBack en attente de modération a été posté sur votre site '[_1]', sur la page #[_2] ([_3]). Vous devez l'approuver pour qu'il apparaisse sur votre site.},
	q{An unapproved TrackBack has been posted on your site '[_1]', on category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{Un TrackBack en attente de modération a été posté sur votre site '[_1]', sur la catégorie #[_2] ([_3]). Vous devez l'approuver pour qu'il apparaisse sur votre site.},
	q{A new TrackBack has been posted on your site '[_1]', on entry #[_2] ([_3]).} => q{Un TrackBack en attente de modération a été posté sur votre site '[_1]', sur la note #[_2] ([_3]).},
	q{A new TrackBack has been posted on your site '[_1]', on page #[_2] ([_3]).} => q{Un TrackBack en attente de modération a été posté sur votre site '[_1]', sur la page #[_2] ([_3]).},
	q{A new TrackBack has been posted on your site '[_1]', on category #[_2] ([_3]).} => q{Un TrackBack en attente de modération a été posté sur votre site '[_1]', sur la catégorie #[_2] ([_3]).},
	'Approve TrackBack' => 'Approuver le TrackBack',
	'View TrackBack' => 'Voir le TrackBack',
	'Report TrackBack as spam' => 'Signaler le TrackBack comme spam',
	'Edit TrackBack' => 'Éditer les TrackBacks',

## plugins/Trackback/default_templates/trackbacks.mtml

## plugins/Trackback/lib/MT/App/Trackback.pm
	'You must define a Ping template in order to display pings.' => 'Vous devez définir un gabarit d\'affichage Ping pour les afficher.',
	'Trackback pings must use HTTP POST' => 'Les Pings TrackBack doivent utiliser HTTP POST',
	'TrackBack ID (tb_id) is required.' => 'L\'ID de TrackBack (tb_id) est requis.',
	'Invalid TrackBack ID \'[_1]\'' => 'L\'ID de TrackBack \'[_1]\' est invalide',
	'You are not allowed to send TrackBack pings.' => 'You n\'êtes pas autorisé à envoyer des pings TrackBack.',
	'You are sending TrackBack pings too quickly. Please try again later.' => 'Vous envoyez des pings TrackBack trop rapidement. Veuillez
réessayer plus tard.',
	'You need to provide a Source URL (url).' => 'Vous devez fournir une URL source (url).',
	'Invalid URL \'[_1]\'' => 'URL invalide \'[_1]\'',
	'This TrackBack item is disabled.' => 'Cet élément TrackBack est désactivé.',
	'This TrackBack item is protected by a passphrase.' => 'Cet élément de TrackBack est protégé par un mot de passe.',
	'TrackBack on "[_1]" from "[_2]".' => 'TrackBack sur "[_1]" provenant de "[_2]".',
	'TrackBack on category \'[_1]\' (ID:[_2]).' => 'TrackBack sur la catégorie \'[_1]\' (ID:[_2]).',
	'Cannot create RSS feed \'[_1]\': ' => 'Impossible de créer le flux RSS \'[_1]\' : ',
	'New TrackBack ping to \'[_1]\'' => 'Nouveau TrackBack vers \'[_1]\'',
	'New TrackBack ping to category \'[_1]\'' => 'Nouveau TrackBack vers la catégorie \'[_1]\'',

## plugins/Trackback/lib/MT/CMS/TrackBack.pm
	'(Unlabeled category)' => '(Catégorie sans description)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Ping (ID:[_1]) de \'[_2]\' supprimé par \'[_3]\' de la c
atégorie \'[_4]\'',
	'(Untitled entry)' => '(Note sans titre)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Ping (ID:[_1]) de \'[_2]\' supprimé par \'[_3]\' de la note
 \'[_4]\'',
	'No Excerpt' => 'Pas d\'extrait',
	'Orphaned TrackBack' => 'TrackBack orphelin',
	'category' => 'catégorie',

## plugins/Trackback/lib/MT/Template/Tags/Ping.pm
	'<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> doit être utilisé dans le contexte d\'une catégorie, ou avec l\'attribut \'category\' dans la balise.',

## plugins/Trackback/lib/MT/XMLRPC.pm
	'No WeblogsPingURL defined in the configuration file' => 'Pas de WeblogsPingURL défini dans le fichier de configuration',
	'No MTPingURL defined in the configuration file' => 'Pas de MTPingURL défini dans le fichier de configuration',
	'HTTP error: [_1]' => 'Erreur HTTP : [_1]',
	'Ping error: [_1]' => 'Erreur Ping : [_1]',

## plugins/Trackback/lib/Trackback/App/ActivityFeed.pm
	'[_1] TrackBacks' => '[_1] TrackBacks',
	'All TrackBacks' => 'Tous les TrackBacks',

## plugins/Trackback/lib/Trackback/App/CMS.pm
	'Are you sure you want to remove all trackbacks reported as spam?' => 'Voulez-vous vraiment supprimer tous les TrackBacks reportés comme spam ?',
	'Delete all Spam trackbacks' => 'Supprimer tous les TrackBacks marqués comme indésirables',

## plugins/Trackback/lib/Trackback/Blog.pm
	'Cloning TrackBacks for blog...' => 'Clonage des TrackBacks du blog...',
	'Cloning TrackBack pings for blog...' => 'Clonage des pings de TrackBack du blog...',

## plugins/Trackback/lib/Trackback/CMS/Comment.pm
	'You do not have permission to approve this trackback.' => 'Vous n\'avez pas la permission d\'approuver ce TrackBack.',
	'The entry corresponding to this comment is missing.' => 'La note correspondnate à ce commentaire est manquante.',
	'You do not have permission to approve this comment.' => 'Vous n\'avez pas la permission d\'approuver ce commentaire.',

## plugins/Trackback/lib/Trackback/CMS/Entry.pm
	'Ping \'[_1]\' failed: [_2]' => 'Le ping \'[_1]\' n\'a pas fonctionné : [_2]',

## plugins/Trackback/lib/Trackback/CMS/Search.pm
	'Source URL' => 'URL Source',

## plugins/Trackback/lib/Trackback/Import.pm
	'Creating new ping (\'[_1]\')...' => 'Création d\'un nouveau ping (\'[_1]\')...',
	'Saving ping failed: [_1]' => 'Échec de la sauvegarde du ping : [_1]',

## plugins/Trackback/lib/Trackback.pm
	'<a href="[_1]">Ping from: [_2] - [_3]</a>' => '<a href="[_1]">Ping de : [_2] - [_3]</a>',
	'Not spam' => 'Non spam',
	'Reported as spam' => 'Notifié comme spam',
	'Trackbacks on [_1]: [_2]' => 'TrackBacks sur [_1] : [_2]',
	'__PING_COUNT' => 'Nombre de pings',
	'Trackback Text' => 'Texte du TrackBack',
	'Trackbacks on My Entries/Pages' => 'TrackBacks sur mes notes/pages',
	'Non-spam trackbacks' => 'TrackBacks n\'étant pas du spam',
	'Non-spam trackbacks on this website' => 'TrackBacks n\'étant pas du spam sur ce site web',
	'Pending trackbacks' => 'TrackBacks en attente',
	'Published trackbacks' => 'TrackBacks publiés',
	'Trackbacks on my entries/pages' => 'TrackBacks sur mes notes/pages',
	'Trackbacks in the last 7 days' => 'TrackBacks des 7 derniers jours',
	'Spam trackbacks' => 'TrackBacks indésirables',

## plugins/Trackback/t/211-api-resource-objects.d/asset/from_object.yaml
	'Image photo' => 'Photo image',

## plugins/Trackback/t/211-api-resource-objects.d/asset/to_object.yaml

## plugins/Trackback/t/211-api-resource-objects.d/category/from_object.yaml

## plugins/Trackback/t/211-api-resource-objects.d/category/to_object.yaml
	'Original Test' => 'Test original',

## plugins/Trackback/t/211-api-resource-objects.d/entry/from_object.yaml

## plugins/Trackback/t/213-api-resource-objects-disabled-fields.d/authenticated/asset/from_object.yaml

## plugins/Trackback/t/213-api-resource-objects-disabled-fields.d/authenticated/entry/from_object.yaml

## plugins/Trackback/t/213-api-resource-objects-disabled-fields.d/non-authenticated/asset/from_object.yaml

## plugins/Trackback/t/213-api-resource-objects-disabled-fields.d/non-authenticated/entry/from_object.yaml

## plugins/WidgetManager/WidgetManager.pl
	q{Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.} => q{Widget Manager version 1.1. Cette version est destinée à la mise à jour des données des versions plus anciennes de Widget Manager, livré avec Movable Type. Aucune autre fonction n'est incluse. Vous pouvez supprimer ce plugin après avoir installé/mis à jour Movable Type.},
	'Moving storage of Widget Manager [_2]...' => 'Déplacement de l\'emplacement du gestionnaire de wiget [_2]...',
	'Failed.' => 'Échec.',

## plugins/WXRImporter/config.yaml
	'Import WordPress exported RSS into MT.' => 'Importer depuis un export RSS WordPress vers MT',
	'"WordPress eXtended RSS (WXR)"' => '"WordPress eXtended RSS (WXR)"',
	'"Download WP attachments via HTTP."' => '"Télécharger les pièces jointes WP via HTTP."',

## plugins/WXRImporter/lib/WXRImporter/Import.pm
	'No Site' => 'Aucun site',
	'Archive Root' => 'Racine de l\'archive',

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'Le fichier n\'est pas dans le format WXR.',
	'Creating new tag (\'[_1]\')...' => 'Création d\'un nouveau tag (\'[_1]\')...',
	'Saving tag failed: [_1]' => 'L\'enregistrement du tag a échoué : [_1]',
	'Duplicate asset (\'[_1]\') found.  Skipping.' => 'L\'élément  (\'[_1]\') a été trouvé en double. Ignoré.',
	'Saving asset (\'[_1]\')...' => 'Enregistrement de l\'élément (\'[_1]\')...',
	' and asset will be tagged (\'[_1]\')...' => ' et l\'élément sera taggué (\'[_1]\')...',
	'Duplicate entry (\'[_1]\') found.  Skipping.' => 'La note  (\'[_1]\') a été trouvée en double. Ignorée.',
	'Saving page (\'[_1]\')...' => 'Enregistrement de la page (\'[_1]\')...',
	'Creating new comment (from \'[_1]\')...' => 'Création d\'un nouveau commentaire (de \'[_1]\')...',
	'Saving comment failed: [_1]' => 'Échec de la sauvegarde du commentaire : [_1]',
	'Entry has no MT::Trackback object!' => 'La note n\'a pas d\'objet MT::Trackback !',
	'Creating new ping (\'[_1]\')...' => 'Création d\'un nouveau ping (\'[_1]\')...',
	'Saving ping failed: [_1]' => 'Échec de la sauvegarde du ping : [_1]',
	'Assigning permissions for new user...' => 'Mise en place des autorisations pour le nouvel utilisateur...',
	'Saving permission failed: [_1]' => 'Échec de la sauvegarde des droits des utilisateurs : [_1]',

## plugins/WXRImporter/tmpl/options.tmpl
	q{Before you import WordPress posts to Movable Type, we recommend that you <a href='[_1]'>configure your site's publishing paths</a> first.} => q{Avant d'importer des notes WordPress dans Movable Type, nous vous recommandons de <a href='[_1]'>configurer les chemins de publication du site</a> au préalable.},
	q{Upload path for this WordPress blog} => q{Chemin d'envoi pour ce blog WordPress},
	'Replace with' => 'Remplacer par',
	'Download attachments' => 'Télécharger les fichiers attachés',
	q{Requires the use of a cron job to download attachments from WordPress powered blog in the background.} => q{L'utilisation d'un cron job est requis pour télécharger en arrière plan les fichiers attachés à un blog WordPress.},
	q{Download attachments (images and files) from the imported WordPress powered blog.} => q{Télécharger les fichiers attachés d'un blog WordPress (images et autres documents).},

	'Synchronization([_1]) with an external server([_2]) has been successfully started.' => 'La synchronization ([_1]) avec un serveur externe ([_2]) a démarré avec succès.', # Translate - New
    'This email is to notify you that synchronization with an external server has been successfully started.' => 'Ceci est une notification que la synchronization avec un serveur externe a démarré avec succès.', # Translate - New
    'Immediate sync job is being registered. This job will be executed in next run-periodic-tasks execution.' => 'Une tâche de synchronization immédiate a été programmée. Cette tâche sera exécutée au prochain déclenchement des tâches programmées (run-periodic-tasks).', # Translate - New
    'Immediate sync job has been registered.' => 'Une tâche de synchronization immédiate a été programmée.', # Translate - New
    'Register immediate sync job' => 'Programmer une tâche de synchronization immédiate', # Translate - New
    'Are you sure you want to register immediate sync job?' => 'Voulez-vous programmer cette tâche de synchronization immédiate ?', # Translate - New	

);

## New words: 1164

1;
