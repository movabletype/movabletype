#	Русский локализационный файл для Movable Type 5.1
#	
#	Автор перевода: Андрей Серебряков <http://saahov.ru/>
#	 
#	Отдельная благодарность Алексею Демидову <http://alexd.vinf.ru>
#	за автоматизацию процесса перевода
#	и доработку функции, отвечающей за множественное число.
#	 
#	Дата публикации файла: 16 мая 2011 года.
#
#	Перевод распространяется по лицензии GNU General Public License v2
#	http://www.gnu.org/licenses/old-licenses/gpl-2.0.html

package MT::L10N::ru;
use strict;
use utf8;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

sub quant {
    my($handle, $num, @forms) = @_;

    return $num if @forms == 0; # what should this mean?

    # Note that the formatting of $num is preserved.
    return( $handle->numf($num) . ' ' . $handle->numerate($num, @forms) );
    # Most human languages put the number phrase before the qualified phrase.
}

sub numerate {
    # return this lexical item in a form appropriate to this number
    my($handle, $num, @forms) = @_;
    my $s = ($num == 1);

    return '' unless @forms;

    return $forms[0] if $num =~ /^([0-9]*?[02-9])?1$/; 
    return $forms[0] if ( @forms == 1);

    return $forms[1] if $num =~ /^([0-9]*?[02-9])?[234]$/; 
    return $forms[1] if ( @forms == 2);
    return $forms[2];
}
        
## The following is the translation table.

%Lexicon = (

## php/lib/archive_lib.php
	'Individual' => 'Индивидуальный',
	'Page' => 'Страница',
	'Yearly' => 'Годовой',
	'Monthly' => 'Месячный',
	'Daily' => 'Дневной',
	'Weekly' => 'Недельный',
	'Author' => 'Автор',
	'(Display Name not set)' => '(Отображаемое имя не указано)',
	'Author Yearly' => 'Автор за год',
	'Author Monthly' => 'Автор за месяц',
	'Author Daily' => 'Автор за день',
	'Author Weekly' => 'Автор за неделю',
	'Category Yearly' => 'Категория за год',
	'Category Monthly' => 'Категория за месяц',
	'Category Daily' => 'Категория за день',
	'Category Weekly' => 'Категория за неделю',

## php/lib/block.mtassets.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" должен использоваться в сочетании с namespace.',

## php/lib/block.mtauthorhasentry.php
	'No author available' => 'Нет такого автора',

## php/lib/block.mtif.php
	'You used a [_1] tag without a valid name attribute.' => 'Вы использовали тег [_1] без допустимого имени атрибута.',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] — это недопустимо.',

## php/lib/block.mtsetvarblock.php
	'\'[_1]\' is not a hash.' => '«[_1]» — это не хэш.',
	'Invalid index.' => 'Неправильный индекс.',
	'\'[_1]\' is not an array.' => '«[_1]» — это не массив.',
	'\'[_1]\' is not a valid function.' => '«[_1]» — это неправильная функция.',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha', # Translate - Not translated
	'Type the characters you see in the picture above.' => 'Введите изображённые на картинке символы.',

## php/lib/function.mtassettype.php
	'image' => 'изображение',
	'Image' => 'Изображение',
	'file' => 'файл',
	'File' => 'Файл',
	'audio' => 'аудио',
	'Audio' => 'Аудио',
	'video' => 'видео',
	'Video' => 'Видео',

## php/lib/function.mtcommentauthorlink.php
	'Anonymous' => 'Аноним',

## php/lib/function.mtcommentreplytolink.php
	'Reply' => 'Ответить',

## php/lib/function.mtentryclasslabel.php
	'page' => 'страница',
	'entry' => 'запись',
	'Entry' => 'Запись',

## php/lib/function.mtinclude.php
	'\'parent\' modifier cannot be used with \'[_1]\'' => 'Модификатор \'parent\' не может быть использован совместно с \'[_1]\'',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]', # Translate - Not translated

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can not be used.' => 'Авторизация через TypePad не включена в этом блоге. Использовать MTRemoteSignInLink не получится.',

## php/lib/function.mttagsearchlink.php
	'Invalid [_1] parameter.' => 'Неправильный [_1] параметр',

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '«[_1]» — это неправильная функция для хэша.',
	'\'[_1]\' is not a valid function for an array.' => '«[_1]» — это неправильная функция для массива.',

## php/lib/function.mtwidgetmanager.php
	'Error compiling widgetset [_1]' => 'Ошибка при компиляции связки виджетов [_1]',

## php/lib/mtdb.base.php
	'The attribute exclude_blogs denies all include_blogs.' => 'Атрибут exclude_blogs запрещает все include_blogs.',

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'userpic-[_1]-%wx%h%x', # Translate - Not translated

## php/mt.php
	'Page not found - [_1]' => 'Страница не найдена',

## mt-check.cgi
	'Movable Type System Check' => 'Системная проверка Movable Type',
	'You attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'Вы пытаетесь использовать функцию, доступ к которой ограничен. Если вы уверены, что такого быть не должно, обратитесь к администратору.',
	'The MT-Check report is disabled when Movable Type has a valid configuration file (mt-config.cgi)' => 'Функция MT-Check отключена, так как имеется валидный конфигурационный файл (mt-config.cgi)',
	q{The mt-check.cgi script provides you with information about your system's configuration and determines whether you have all of the components you need to run Movable Type.} => q{Скрипт mt-check.cgi предоставляет информацию о системной конфигурации и определяет, все ли необходимые компоненты присутствуют для запуска Movable Type.},
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). Please upgrade to at least Perl [_2].' => 'Установленная версия Perl ([_1]) ниже, чем минимально поддерживаемая ([_2]). Необходимо обновить хотя бы до Perl [_2].',
	'System Information' => 'Информация о системе',
	'Movable Type version:' => 'Версия Movable Type:',
	'Current working directory:' => 'Текущая рабочая директория:',
	'MT home directory:' => 'Домашняя директория MT:',
	'Operating system:' => 'Операционная система:',
	'Perl version:' => 'Версия Perl:',
	'Perl include path:' => 'Путь включения Perl:',
	'Web server:' => 'Веб-сервер:',
	'(Probably) running under cgiwrap or suexec' => '(Возможно) Запущено под cgiwrap или suexec',
	'[_1] [_2] Modules' => '[_1] модулей: [_2]',
	'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides.' => 'Следующие модули необязательны. Если они отсутствуют на сервере, вам понадобится установить их только в случае, когда потребуется функциональность, обеспечиваемая модулем.',
	'Some of the following modules are required by databases supported by Movable Type. Your server must have DBI and at least one of these related modules installed for proper operation of Movable Type.' => 'Некоторые из следующих модулей обязательны для поддержки баз данных в Movable Type. На сервере должен быть установлен DBI, а также хотя бы один из подмодулей для работы c необходимой базой данных.',
	'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'Либо на вашем сервере не установлен [_1], либо установленная версия слишком старая, или требуется другой модуль, который не установлен.',
	'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => 'На вашем сервере не установлен [_1], либо связанные модули не установлены.',
	'Please consult the installation instructions for help in installing [_1].' => 'Пожалуйста, ознакомьтесь с инструкцией по установке для получения помощи по установке [_1].',
	'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN.' => 'Версия DBD::mysql, установленная у вас, не совместима с Movable Type. Пожалуйста, установите свежую версию, доступную через CPAN.',
	'The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements.' => '$mod установлен правильно, но требуется обновление модуля DBI. См. выше примечания по требованиям к модулю DBI.',
	'Your server has [_1] installed (version [_2]).' => 'На сервере установлен [_1] (версия [_2])',
	'Movable Type System Check Successful' => 'Проверка системы выполнена',
	q{You're ready to go!} => q{Вы можете начать!},
	'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'На вашем сервере установлены все необходимые модули, так что в установке дополнительных модулей нет необходимости. Следуйте инструкциям по установке.',
	'CGI is required for all Movable Type application functionality.' => 'Для работы Movable Type необходим CGI.',
	'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Модуль Image::Size необходим для загрузки файлов (для определения размера загруженных изображений).',
	'File::Spec is required for path manipulation across operating systems.' => 'File::Spec обязателен для работы с файлами.',
	'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookie обязателен для авторизации с использованием cookie.',
	'DBI is required to store data in database.' => 'Для хранения данных в базе данных обязателен DBI.',
	'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'Модули DBI и DBD::mysql обязательны, если вы хотите использовать базу данных MySQL.',
	'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'Модули DBI и DBD::Pg обязательны, если вы хотите использовать базу данных PostgreSQL.',
	'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'Модули DBI и DBD::SQLite обязательны, если вы хотите использовать базу данных SQLite.',
	'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'Модули DBI и DBD::SQLite2 обязательны, если вы хотите использовать базу данных SQLite 2.x.',
	'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in the configuration file.' => 'Модуль HTML::Entities необходим для кодирования некоторых символов. Эта функция может быть отключена, если добавить в конфигурационный файл директиву NoHTMLEntities.',
	'LWP::UserAgent is optional; It is needed if you want to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'Модуль LWP::UserAgent не обязателен. Он необходим, если вы хотите использовать систему трекбэков для пинга различных сервисов (например, Яндекс.Блоги или weblogs.com).',
	'HTML::Parser is optional; It is needed if you want to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'Модуль HTML::Parser не обязателен. Он необходим, если вы хотите использовать систему трекбэков для пинга различных сервисов (например, Яндекс.Блоги или weblogs.com).',
	'SOAP::Lite is optional; It is needed if you want to use the MT XML-RPC server implementation.' => 'Модуль SOAP::Lite не обязателен. Но он необходим, если вы хотите работать с MT посредством XML-RPC (блогинг-клиенты; различные программы, позволяющие работать с MT не из браузера).',
	'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'Модуль File::Temp необязателен, но необходим для перезаписи существующих файлов при загрузке.',
	'Scalar::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'Scalar::Util необязателен; он необходим, если вы хотите использовать функцию очереди публикации.',
	'List::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'List:Util не обязателен, но он необходим, если вы хотите использовать очередь публикации.',
	'Image::Magick is optional; It is needed if you would like to be able to create thumbnails of uploaded images.' => 'Модуль Image::Magick необязателен, но необходим, если вы хотите иметь возможность делать миниатюры загружаемых изображений.',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'Модуль необходим, если вы хотите иметь возможность делать миниатюры загружаемых изображений.',
	'This module is needed if you would like to be able to use NetPBM as the image driver for MT.' => 'Модуль необходим, если вы хотите использовать в качестве обработчика картинок драйвер NetPBM.',
	'Storable is optional; It is required by certain MT plugins available from third parties.' => 'Модуль Storable не обязателен, однако требуется для некоторых сторонних плагинов MT.',
	'Crypt::DSA is optional; If it is installed, comment registration sign-ins will be accelerated.' => 'Модуль Crypt::DSA не обязателен, но если он присутствует, то авторизация комментаторов происходит быстрее.',
	'This module and its dependencies are required to permit commenters to authenticate via OpenID providers such as AOL and Yahoo! that require SSL support.' => 'Этот модуль и его зависимости необходимы для авторизации комментаторов через OpenID-провайдеров, которые требуют поддержки SSL. Например, это может быть Google или Yahoo.',
	'Cache::File is required if you would like to be able to allow commenters to be authenticated by Yahoo! Japan as OpenID.' => 'Необходим Cache::File, если вы хотите использовать возможность авторизации комментаторов через Yahoo! Japan.',
	'MIME::Base64 is required in order to enable comment registration.' => 'Модуль MIME::Base64 необходим для регистрации комментаторов.',
	'XML::Atom is required in order to use the Atom API.' => 'Модуль XML::Atom необходим для использования Atom API.',
	'Cache::Memcached and memcached server/daemon is required in order to use memcached as caching mechanism used by Movable Type.' => 'Модуль Cache::Memcached и memcached server/daemon необходим для использования memcached в Movable Type.',
	'Archive::Tar is required in order to archive files in backup/restore operation.' => 'Модуль Archive::Tar необходим для архивации файлов при создании бэкапа и его восстановления.',
	'IO::Compress::Gzip is required in order to compress files in backup/restore operation.' => 'Модуль IO::Compress::Gzip необходим для архивации файлов при создании бэкапа и его восстановления.',
	'IO::Uncompress::Gunzip is required in order to decompress files in backup/restore operation.' => 'Модуль IO::Uncompress::Gunzip необходим для архивации файлов при создании бэкапа и его восстановления.',
	'Archive::Zip is required in order to archive files in backup/restore operation.' => 'Модуль Archive::Zip необходим для архивации файлов при создании бэкапа и его восстановления.',
	'XML::SAX and its dependencies are required in order to restore a backup created in a backup/restore operation.' => 'Модуль XML::SAX необходим для восстановления бекапов, созданных через Movable Type.',
	'Digest::SHA1 and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.' => 'Модуль Digest::SHA1 необходим для авторизации комментаторов посредством OpenID, включая LiveJournal.',
	'Mail::Sendmail is required in order to send mail via an SMTP Server.' => 'Mail::Sendmail необходим для отправки почты через SMTP сервер.',
	'This module is used in a test attribute for the MTIf conditional tag.' => 'Модуль используется для тестирования атрибутов тега MTIf.',
	'This module is used by the Markdown text filter.' => 'Модуль используется в текстовом фильтре Markdown.',
	'This module is required by mt-search.cgi if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'Модуль необходим для скрипта mt-search.cgi, если установленная версия Perl ниже 5.8.',
	'This module required for action streams.' => 'Модуль необходим для Action Streams',
	'The [_1] database driver is required to use [_2].' => 'Для использования [_2] необходим драйвер базы данных [_1].',
	'Checking for' => 'Проверка',
	'Installed' => 'Установлен',
	'Data Storage' => 'Хранение данных',
	'Required' => 'Обязательно',
	'Optional' => 'По желанию',
	'Details' => 'Детали',

## default_templates/about_this_page.mtml
	'About this Entry' => 'Об этой записи',
	'About this Archive' => 'Об архиве',
	'About Archives' => 'Об архивах',
	'This page contains links to all the archived content.' => 'Эта страница содержит ссылки на все архивы.',
	'This page contains a single entry by [_1] published on <em>[_2]</em>.' => 'Сообщение опубликовано <em>[_2]</em>. Автор — [_1].',
	'<a href="[_1]">[_2]</a> was the previous entry in this blog.' => 'Предыдущая запись — <a href="[_1]">[_2]</a>',
	'<a href="[_1]">[_2]</a> is the next entry in this blog.' => 'Следующая запись — <a href="[_1]">[_2]</a>',
	'This page is an archive of entries in the <strong>[_1]</strong> category from <strong>[_2]</strong>.' => 'Эта страница содержит записи из категории <strong>[_1]</strong> за <strong>[_2]</strong>.',
	'<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> — предыдущий архив.',
	'<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> — следующий архив.',
	'This page is an archive of recent entries in the <strong>[_1]</strong> category.' => 'Эта страница содержит последние записи категории <strong>[_1]</strong>.',
	'<a href="[_1]">[_2]</a> is the previous category.' => 'Предыдущая категория — <a href="[_1]">[_2]</a>.',
	'<a href="[_1]">[_2]</a> is the next category.' => 'Следующая категория — <a href="[_1]">[_2]</a>.',
	'This page is an archive of recent entries written by <strong>[_1]</strong> in <strong>[_2]</strong>.' => 'Эта страница содержит последние записи, созданные автором <strong>[_1]</strong> (<strong>[_2]</strong>).',
	'This page is an archive of recent entries written by <strong>[_1]</strong>.' => 'Эта страница содержит последние записи, созданные автором <strong>[_1]</strong>.',
	'This page is an archive of entries from <strong>[_2]</strong> listed from newest to oldest.' => 'Страница содержит архив записей за <strong>[_2]</strong>, расположенных по убыванию.',
	'Find recent content on the <a href="[_1]">main index</a>.' => 'Смотрите новые записи <a href="[_1]">главной странице</a>.',
	'Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.' => 'Смотрите новые записи на <a href="[_1]">главной странице</a> или загляните в <a href="[_2]">архив</a>, где есть ссылки на все сообщения.',

## default_templates/archive_index.mtml
	'HTML Head' => 'HTML Head', # Translate - Not translated
	'Archives' => 'Архивы',
	'Banner Header' => 'Шапка сайта',
	'Monthly Archives' => 'Архивы по месяцам',
	'Categories' => 'Категории',
	'Author Archives' => 'Архивы авторов',
	'Category Monthly Archives' => 'Архивы категорий по месяцам',
	'Author Monthly Archives' => 'Архивы авторов по месяцам',
	'Sidebar' => 'Боковое меню',
	'Banner Footer' => 'Подвал',

## default_templates/archive_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to serve different content based upon what type of archive it is included. More info: [_1]' => 'Это произвольный набор виджетов, что обуславливает его включении на основе того, в какой архив он включён. Дополнительная информация: [_1]',
	'Current Category Monthly Archives' => 'Текущий архив категории по месяцам',
	'Category Archives' => 'Архивы категорий',

## default_templates/author_archive_list.mtml
	'Authors' => 'Авторы',
	'[_1] ([_2])' => '[_1] ([_2])', # Translate - Not translated

## default_templates/banner_footer.mtml
	'_POWERED_BY' => 'Работает на<br /><a href="http://www.movabletype.org/"><$MTProductName$></a>',
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'Содержимое блога распространяется в соответствии с лицензией <a href="[_1]">Creative Commons</a>.',

## default_templates/calendar.mtml
	'Monthly calendar with links to daily posts' => 'Календарь на месяц со ссылками на отдельные сообщения',
	'Sunday' => 'Воскресенье',
	'Sun' => 'Вс',
	'Monday' => 'Понедельник',
	'Mon' => 'Пн',
	'Tuesday' => 'Вторник',
	'Tue' => 'Вт',
	'Wednesday' => 'Среда',
	'Wed' => 'Ср',
	'Thursday' => 'Четверг',
	'Thu' => 'Чт',
	'Friday' => 'Пятница',
	'Fri' => 'Пт',
	'Saturday' => 'Суббота',
	'Sat' => 'Сб',

## default_templates/category_entry_listing.mtml
	'[_1] Archives' => 'Архив [_1]',
	'Recently in <em>[_1]</em> Category' => 'Последнее в категории <em>[_1]</em>',
	'Entry Summary' => 'Общий вид записи',
	'Main Index' => 'Главная страница',

## default_templates/comment_detail.mtml
	'[_1] replied to <a href="[_2]">comment from [_3]</a>' => '[_1] ответил на <a href="[_2]">комментарий от [_3]</a>',

## default_templates/commenter_confirm.mtml
	'Thank you registering for an account to comment on [_1].' => 'Спасибо за регистрацию аккаунта для комментирования «[_1]».',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to comment on [_1].' => 'Для подтверждения email адреса, вам необходимо активировать ваш аккаунт. После этого вы сможете незамедлительно комментировать «[_1]».',
	'To confirm your account, please click on or cut and paste the following URL into a web browser:' => 'Перейдите по следующей ссылке или вставьте её в адресную строку браузера:',
	q{If you did not make this request, or you don't want to register for an account to comment on [_1], then no further action is required.} => q{Если же регистрацию за вас выполнил кто-то другой, наглым образом воспользовавшись вашим адресом, и вы не хотите оставлять комментарии на сайте «[_1]», просто проигнорируйте это письмо.},
	'Thank you very much for your understanding.' => 'Если вы всё же перейдёте по ссылке, значит робот, отправивший это письмо, старался не зря.',
	'Sincerely,' => 'С уважением,',
	'Mail Footer' => 'Подвал сообщения',

## default_templates/commenter_notify.mtml
	q{This email is to notify you that a new user has successfully registered on the blog '[_1]'. Listed below you will find some useful information about this new user.} => q{На вашем сайте «[_1]» зарегистрировался новый пользователь. Ниже представлена некоторая информация о нём:},
	'New User Information:' => 'Информация о новом пользователе:',
	'Username: [_1]' => 'Логин: [_1]',
	'Full Name: [_1]' => 'Полное имя: [_1]',
	'Email: [_1]' => 'Email: [_1]', # Translate - Not translated
	'To view or edit this user, please click on or cut and paste the following URL into a web browser:' => 'Для просмотра или редактирования пользователя, перейдите по следующей ссылке:',

## default_templates/comment_listing.mtml
	'Comment Detail' => 'Детали комментария',

## default_templates/comment_preview.mtml
	'Previewing your Comment' => 'Просмотр комментария',
	'Leave a comment' => 'Комментировать',
	'Name' => 'Имя',
	'Email Address' => 'Email', # Translate - No russian chars
	'URL' => 'Сайт',
	'Replying to comment from [_1]' => 'Ответ на комментарий от [_1]',
	'Comments' => 'Комментарии',
	'(You may use HTML tags for style)' => '(Можно использовать некоторые HTML теги для форматирования)',
	'Preview' => 'Просмотр',
	'Submit' => 'Отправить',
	'Cancel' => 'Отмена',

## default_templates/comment_response.mtml
	'Confirmation...' => 'Подтверждение…',
	'Your comment has been submitted!' => 'Ваш комментарий добавлен!',
	'Thank you for commenting.' => 'Спасибо за комментарий.',
	'Your comment has been received and held for approval by the blog owner.' => 'Ваш комментарий добавлен, но прежде, чем он будет опубликован, он должен быть проверен владельцем блога.',
	'Comment Submission Error' => 'Ошибка при добавлении комментария',
	'Your comment submission failed for the following reasons: [_1]' => 'Ваш комментарий не добавлен по следующим причинам: [_1]',
	'Return to the <a href="[_1]">original entry</a>.' => 'Вернуться к <a href="[_1]">записи</a>.',

## default_templates/comments.mtml
	'1 Comment' => '1 комментарий',
	'# Comments' => 'Комментариев: #',
	'No Comments' => 'Нет комментариев',
	'Previous' => 'Предыдущий',
	'Next' => 'Следующий',
	'The data is modified by the paginate script' => 'Данные изменены скриптом пейджинации',
	'Remember personal info?' => 'Запомнить меня?',

## default_templates/comment_throttle.mtml
	'If this was a mistake, you can unblock the IP address and allow the visitor to add it again by logging in to your Movable Type installation, going to Blog Config - IP Banning, and deleting the IP address [_1] from the list of banned addresses.' => 'Если произошла ошибка, вы можете разблокировать IP адрес. Для этого зайдите в Movable Type, перейдите к настройке блога — Блокировка IP, а затем удалите адрес [_1] из списка заблокированных.',
	'A visitor to your blog [_1] has automatically been banned by adding more than the allowed number of comments in the last [_2] seconds.' => 'Посетитель вашего блога «[_1]» был автоматически заблокирован, так как пытался добавить больше позволенного количества комментариев за [quant,_2,секунду,секунды,секунд].',
	'This has been done to prevent a malicious script from overwhelming your weblog with comments. The banned IP address is' => 'Это сделано для того, чтобы предотвратить засорение блога комментариями, добавляемыми автоматически с помощью специальных программ (спам-ботов).',

## default_templates/current_author_monthly_archive_list.mtml
	'[_1]: Monthly Archives' => '[_1]: архив за месяц',

## default_templates/current_category_monthly_archive_list.mtml
	'[_1]' => '[_1]', # Translate - Not translated

## default_templates/date_based_author_archives.mtml
	'Author Yearly Archives' => 'Ежегодные архивы авторов',
	'Author Weekly Archives' => 'Еженедельные архивы авторов',
	'Author Daily Archives' => 'Ежедневные архивы авторов',

## default_templates/date_based_category_archives.mtml
	'Category Yearly Archives' => 'Архивы категорий по месяцам',
	'Category Weekly Archives' => 'Архивы категорий по неделям',
	'Category Daily Archives' => 'Архивы категорий по дням',

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'Страница не найдена',

## default_templates/entry.mtml
	'By [_1] on [_2]' => 'Автор: [_1] — [_2]',
	'1 TrackBack' => '1 трекбэк',
	'# TrackBacks' => 'Трекбэков: #',
	'No TrackBacks' => 'Нет трекбэков',
	'Tags' => 'Теги',
	'Trackbacks' => 'Трекбэки',

## default_templates/entry_summary.mtml
	'Continue reading <a href="[_1]" rel="bookmark">[_2]</a>.' => 'Читать дальше «<a href="[_1]" rel="bookmark">[_2] &rarr;</a>»',

## default_templates/footer-email.mtml
	'Powered by Movable Type [_1]' => 'Работает на Movable Type [_1]',

## default_templates/javascript.mtml
	'moments ago' => 'только что',
	'[quant,_1,hour,hours] ago' => '[quant,_1,час,часа,часов] назад',
	'[quant,_1,minute,minutes] ago' => '[quant,_1,минуту,минуты,минут] назад',
	'[quant,_1,day,days] ago' => '[quant,_1,день,дня,дней] назад',
	'Edit' => 'Редактировать',
	'Your session has expired. Please sign in again to comment.' => 'Ваша сессия истекла. Пожалуйста, авторизуйтесь ещё раз.',
	'Signing in...' => 'Авторизация…',
	'You do not have permission to comment on this blog. ([_1]sign out[_2])' => 'У вас нет прав для комментирования в этом блоге. ([_1]выйти[_2])',
	'Thanks for signing in, __NAME__. ([_1]sign out[_2])' => 'Привет! Сегодня вы — __NAME__.',
	'[_1]Sign in[_2] to comment.' => 'Необходимо [_1]авторизоваться[_2] для комментирования.',
	'[_1]Sign in[_2] to comment, or comment anonymously.' => '[_1]Авторизуйтесь[_2], чтобы прокомментировать эту запись, либо комментируйте анонимно.',
	'Replying to <a href="[_1]" onclick="[_2]">comment from [_3]</a>' => 'Ответ на комментарий от <a href="[_1]" onclick="[_2]">[_3]</a>',

## default_templates/main_index_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to only appear on the homepage (or "main_index"). More info: [_1]' => 'Это произвольный набор виджетов, что обуславливает его включение только на домашней странице (или «main_index»). Дополнительная информация: [_1]',
	'Recent Comments' => 'Последние комментарии',
	'Recent Entries' => 'Последние записи',
	'Recent Assets' => 'Последнее медиа',
	'Tag Cloud' => 'Облако тегов',

## default_templates/monthly_archive_dropdown.mtml
	'Select a Month...' => 'Выберите месяц…',

## default_templates/monthly_archive_list.mtml
	'[_1] <a href="[_2]">Archives</a>' => '<a href="[_2]">Архивы</a> [_1]',

## default_templates/new-comment.mtml
	q{An unapproved comment has been posted on your blog '[_1]', for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.} => q{В вашем блоге «[_1]» появился новый комментарий к записи #[_2] ([_3]). Вам необходимо проверить этот комментарий, прежде чем он будет опубликован.},
	q{An unapproved comment has been posted on your blog '[_1]', for page #[_2] ([_3]). You need to approve this comment before it will appear on your site.} => q{В вашем блоге «[_1]» появился новый комментарий к странице #[_2] ([_3]). Вам необходимо проверить этот комментарий, прежде чем он будет опубликован.},
	q{An unapproved comment has been posted on your website '[_1]', for page #[_2] ([_3]). You need to approve this comment before it will appear on your site.} => q{На вашем сайте «[_1]» появился новый комментарий к странице #[_2] ([_3]). Вам необходимо проверить этот комментарий, прежде чем он будет опубликован.},
	q{A new comment has been posted on your blog '[_1]', on entry #[_2] ([_3]).} => q{Новый комментарий в блоге «[_1]», оставленный к записи #[_2] ([_3]).},
	q{A new comment has been posted on your blog '[_1]', on page #[_2] ([_3]).} => q{Новый комментарий в блоге «[_1]», оставленный к странице #[_2] ([_3]).},
	q{A new comment has been posted on your website '[_1]', on page #[_2] ([_3]).} => q{Новый комментарий на сайте «[_1]», оставленный к странице #[_2] ([_3]).},
	'Commenter name: [_1]' => 'Имя комментатора: [_1]',
	'Commenter email address: [_1]' => 'Email: [_1]', # Translate - No russian chars
	'Commenter URL: [_1]' => 'URL: [_1]', # Translate - No russian chars
	'Commenter IP address: [_1]' => 'IP адрес: [_1]',
	'Approve comment:' => 'Одобрить комментарий:',
	'View comment:' => 'Посмотреть комментарий:',
	'Edit comment:' => 'Редактировать комментарий:',
	'Report comment as spam:' => 'Пометить комментарий как спам:',

## default_templates/new-ping.mtml
	q{An unapproved TrackBack has been posted on your blog '[_1]', for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{В вашем блоге «[_1]» появился новый трекбэк, отправленный к записи #[_2] ([_3]). Вам необходимо проверить его, прежде чем он будет опубликован.},
	q{An unapproved TrackBack has been posted on your blog '[_1]', for page #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{В вашем блоге «[_1]» появился новый трекбэк, отправленный к странице #[_2] ([_3]). Вам необходимо проверить его, прежде чем он будет опубликован.},
	q{An unapproved TrackBack has been posted on your blog '[_1]', for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{В вашем блоге «[_1]» появился новый трекбэк, отправленный к категории #[_2] ([_3]). Вам необходимо проверить его, прежде чем он будет опубликован.},
	q{An unapproved TrackBack has been posted on your website '[_1]', for page #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{На вашем сайте «[_1]» появился новый трекбэк, отправленный к странице #[_2] ([_3]). Вам необходимо проверить его, прежде чем он будет опубликован.},
	q{A new TrackBack has been posted on your blog '[_1]', on entry #[_2] ([_3]).} => q{В блоге «[_1]» появился новый трекбэк, отправленный к записи #[_2] ([_3]).},
	q{A new TrackBack has been posted on your blog '[_1]', on page #[_2] ([_3]).} => q{В блоге «[_1]» появился новый трекбэк, отправленный к странице #[_2] ([_3]).},
	q{A new TrackBack has been posted on your blog '[_1]', on category #[_2] ([_3]).} => q{В блоге «[_1]» появился новый трекбэк, отправленный к категории #[_2] ([_3]).},
	q{A new TrackBack has been posted on your website '[_1]', on page #[_2] ([_3]).} => q{На сайте «[_1]» появился новый трекбэк, отправленный к странице #[_2] ([_3]).},
	'Excerpt' => 'Выдержка',
	'Title' => 'Заголовок',
	'Blog' => 'Блог',
	'IP address' => 'IP адрес',
	'Approve TrackBack' => 'Одобрить трекбэк',
	'View TrackBack' => 'Посмотреть трекбэк',
	'Report TrackBack as spam' => 'Пометить трекбэк как спам',
	'Edit TrackBack' => 'Редактировать трекбэк',

## default_templates/notify-entry.mtml
	q{A new [lc,_3] entitled '[_1]' has been published to [_2].} => q{В блоге «[_2]» опубликована новая [lc,_3] «[_1]».},
	'View entry:' => 'Посмотреть запись:',
	'View page:' => 'Посмотреть страницу:',
	'[_1] Title: [_2]' => 'Заголовок: [_2]',
	'Publish Date: [_1]' => 'Дата публикации: [_1]',
	'Message from Sender:' => 'Сообщение от отправителя:',
	'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'Вы получили это письмо, так как подписались на получение уведомлений о новом контенте на сайте «[_1]», или автор посчитал, что вам будет это интересно. Если вы не желаете получать подобные уведомления, пожалуйста, свяжитесь с отправителем:',

## default_templates/openid.mtml
	'[_1] accepted here' => '[_1] принимается здесь',
	'http://www.sixapart.com/labs/openid/' => 'http://www.sixapart.com/labs/openid/', # Translate - Not translated
	'Learn more about OpenID' => 'Узнать больше об OpenID',

## default_templates/pages_list.mtml
	'Pages' => 'Страницы',

## default_templates/powered_by.mtml
	'_MTCOM_URL' => 'http://www.movabletype.com/', # Translate - No russian chars

## default_templates/recent_comments.mtml
	'<strong>[_1]:</strong> [_2] <a href="[_3]" title="full comment on: [_4]">read more</a>' => '<strong>[_1]:</strong> [_2] <a href="[_3]" title="полный комментарий: [_4]">читать дальше</a>',

## default_templates/recover-password.mtml
	'A request has been made to change your password in Movable Type. To complete this process click on the link below to select a new password.' => 'Сделан запрос на изменение пароля в Movable Type. Для завершения процесса, перейдите по ссылке, расположенной ниже:',
	'If you did not request this change, you can safely ignore this email.' => 'Если вы не запрашивали изменение пароля, проигнорируйте это письмо.',

## default_templates/search.mtml
	'Search' => 'Найти',
	'Case sensitive' => 'Учитывать регистр',
	'Regex search' => 'С регулярными выражениями',

## default_templates/search_results.mtml
	'Search Results' => 'Результат поиска',
	'Results matching &ldquo;[_1]&rdquo;' => 'Записи, в которых присутствует «[_1]»',
	'Results tagged &ldquo;[_1]&rdquo;' => 'Записи, связанные с тегом «[_1]»',
	'No results found for &ldquo;[_1]&rdquo;.' => 'По вашему запросу «[_1]» ничего не найдено.',
	'Instructions' => 'Инструкции',
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'По умолчанию поисковый механизм ищет все слова, расположенные в любом порядке. Чтобы искать точную фразу, заключите её в кавычки: ',
	'movable type' => 'movable type', # Translate - Not translated
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'Также обратите внимание, что поисковый механизм поддерживает операторы AND, OR и NOT:',
	'personal OR publishing' => 'собака OR животное',
	'publishing NOT personal' => 'животное NOT кошка',

## default_templates/sidebar.mtml
	'2-column layout - Sidebar' => '2-колончатый — Боковое меню',
	'3-column layout - Primary Sidebar' => '3-колончатый — Главное боковое меню',
	'3-column layout - Secondary Sidebar' => '3-колончатый — Вторичное боковое меню',

## default_templates/signin.mtml
	'Sign In' => 'Авторизация',
	'You are signed in as ' => 'Вы авторизовались как ',
	'sign out' => 'выйти',
	'You do not have permission to sign in to this blog.' => 'Вы не можете авторизовываться в этом блоге.',

## default_templates/syndication.mtml
	'Subscribe to feed' => 'Подписаться на обновления',
	q{Subscribe to this blog's feed} => q{Подписаться на обновления этого блога},
	'Subscribe to a feed of all future entries tagged &ldquo;[_1]&ldquo;' => 'Подписаться на обновления, связанные с тегом «[_1]»',
	'Subscribe to a feed of all future entries matching &ldquo;[_1]&ldquo;' => 'Подписаться на обновления, содержащие «[_1]»',
	'Feed of results tagged &ldquo;[_1]&ldquo;' => 'Обновления по тегу «[_1]»',
	'Feed of results matching &ldquo;[_1]&ldquo;' => 'Обновления, содержащие «[_1]»',

## default_templates/technorati_search.mtml
	'Technorati' => 'Technorati', # Translate - Not translated
	q{<a href='http://www.technorati.com/'>Technorati</a> search} => q{Поиск <a href='http://www.technorati.com/'>Technorati</a> },
	'this blog' => 'в этом блоге',
	'all blogs' => 'во всех блогах',
	'Blogs that link here' => 'Ссылающиеся блоги',

## default_templates/trackbacks.mtml
	'TrackBack URL: [_1]' => 'URL для трекбэков: [_1]',
	'<a href="[_1]">[_2]</a> from [_3] on <a href="[_4]">[_5]</a>' => '<a href="[_1]">[_2]</a> от «[_3]» — <a href="[_4]">[_5]</a>',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">Читать дальше</a>',

## default_templates/verify-subscribe.mtml
	'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => 'Благодарим за подписку на уведомления о новых записях на ваш адрес [_1]. Для подтверждения подписки перейдите по следующей ссылке:',
	'If the link is not clickable, just copy and paste it into your browser.' => 'Если ссылка не открывается, просто скопируйте её и вставьте в адресную строку браузера.',

## lib/MT/App/ActivityFeeds.pm
	'Error loading [_1]: [_2]' => 'Ошибка при загрузке [_1]: [_2]',
	'An error occurred while generating the activity feed: [_1].' => 'Произошла ошибка при генерации фида с последней активностью: [_1].',
	'Invalid request.' => 'Неверный запрос.',
	'No permissions.' => 'Недостаточно прав.',
	'[_1] TrackBacks' => 'Трекбэки ([_1])',
	'All TrackBacks' => 'Все трекбэки',
	'[_1] Comments' => 'Комментарии ([_1])',
	'All Comments' => 'Все комментарии',
	'[_1] Entries' => 'Записи ([_1])',
	'All Entries' => 'Все записи',
	'[_1] Activity' => 'Активность ([_1])',
	'All Activity' => 'Вся активность',
	'Movable Type System Activity' => 'Активность — системный уровень',
	'Movable Type Debug Activity' => 'Активность — отладочная информация',
	'[_1] Pages' => 'Страницы ([_1])',
	'All Pages' => 'Все страницы',

## lib/MT/App/CMS.pm
	'Invalid request' => 'Неверный запрос',
	'Are you sure you want to remove all trackbacks reported as spam?' => 'Вы увеерны, что хотите удалить все трекбэки, отмеченные как спам?',
	'Are you sure you want to remove all comments reported as spam?' => 'Вы уверены, что хотите удалить все комментарии, помеченные как спам?',
	'Add a user to this [_1]' => 'Добавить пользователя в этот [_1]',
	'Are you sure you want to reset the activity log?' => 'Вы уверены, что хотите очистить журнал активности?',
	'_WARNING_PASSWORD_RESET_MULTI' => 'Вы собираетесь отправить выбранным пользователям, чтобы они смогли сбросить пароль. Продолжить?',
	'_WARNING_DELETE_USER_EUM' => 'Удаление пользователя — окончательное действие, которое приведёт к отсутствию авторов у некорых записей. Вместо этого вы можете просто деактивировать его или лишить всех прав в системе. Вы всё равно хотите удалить пользователя? Обратите внимание, что он сможет получить новый доступ, если был зарегистрирован через внешние ресурсы.',
	'_WARNING_DELETE_USER' => 'Удаление пользователя — окончательное действие, которое приведёт к отсутствию авторов у некорых записей. Вместо это рекомендуется деактивировать пользователя или лишить его всех прав в системе. Вы уверены, что хотите удалить выбранных пользователей?',
	'_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' => 'Это действие заменит шаблоны в выбранных блогах на стандартные. Вы уверены?',
	'Some websites were not deleted. You need to delete blogs under the website first.' => 'Некоторые сайты не были удалены. Необходимо сначала удалить блоги, входящие в эти сайты.',
	'You are not authorized to log in to this blog.' => 'Вам не разрешено авторизовываться в этом блоге.',
	'No such blog [_1]' => 'Нет такого блога [_1]',
	'Invalid parameter' => 'Недопустимый параметр',
	'Edit Template' => 'Редактирование шаблона',
	'Back' => 'Вернуться',
	'Unknown object type [_1]' => 'Неизвестный тип объекта [_1]',
	'None' => 'Ничего',
	'Error during publishing: [_1]' => 'Ошибка во время публикации: [_1]',
	'This is You' => 'Это вы',
	'Movable Type News' => 'Новости Movable Type',
	'Blog Stats' => 'Статистика',
	'Websites' => 'Сайты',
	'Blogs' => 'Блоги',
	'Websites and Blogs' => 'Сайты и блоги',
	'Entries' => 'Записи',
	'Refresh Templates' => 'Обновить шаблоны',
	'Use Publishing Profile' => 'Использовать профиль публикации',
	'Delete all Spam trackbacks' => 'Удалить все спам-трекбеки',
	'Delete all Spam comments' => 'Удалить все спам-комментарии',
	'Create Role' => 'Создать роль',
	'Grant Permission' => 'Назначить права',
	'Clear Activity Log' => 'Очистить журнал активности',
	'Download Log (CSV)' => 'Скачать журнал (CSV)',
	'Add IP Address' => 'Добавить IP адрес',
	'Add Contact' => 'Добавить контакт',
	'Download Address Book (CSV)' => 'Скачать адресную книгу (CSV)',
	'Unpublish Entries' => 'Неопубликованные записи',
	'Add Tags...' => 'Добавить теги…',
	'Tags to add to selected entries' => 'Теги, которые необходимо добавить к выбранным записям',
	'Remove Tags...' => 'Удалить теги…',
	'Tags to remove from selected entries' => 'Теги, которые необходимо удалить у выбранных записей',
	'Batch Edit Entries' => 'Массовое редактирование записей',
	'Publish' => 'Публикация',
	'Delete' => 'Удалить',
	'Unpublish Pages' => 'Отменить публикацию страниц',
	'Tags to add to selected pages' => 'Теги, которые необходимо добавить к выбранным страницам',
	'Tags to remove from selected pages' => 'Теги, которые необходимо удалить у выбранных страниц',
	'Batch Edit Pages' => 'Массовое редактирование страниц',
	'Tags to add to selected assets' => 'Теги, которые необходимо добавить к выбранному медиа',
	'Tags to remove from selected assets' => 'Теги, которые необходимо удалить у выбранного медиа',
	'Mark as Spam' => 'Пометить как спам',
	'Remove Spam status' => 'Удалить статус спама',
	'Unpublish TrackBack(s)' => 'Отменить публикацию трекбэков',
	'Unpublish Comment(s)' => 'Отменить публикацию комментариев',
	'Trust Commenter(s)' => 'Сделать комментатора доверенным',
	'Untrust Commenter(s)' => 'Убрать статус доверенного у комментатора',
	'Ban Commenter(s)' => 'Заблокировать комментаторов',
	'Unban Commenter(s)' => 'Снять блокировку у комментаторов',
	'Recover Password(s)' => 'Восстановить пароли',
	'Enable' => 'включить',
	'Disable' => 'отключить',
	'Remove' => 'Удалить',
	'Refresh Template(s)' => 'Восстановить шаблоны',
	'Move blog(s) ' => 'Переместить блог(и)',
	'Clone Blog' => 'Клонировать блог',
	'Publish Template(s)' => 'Опубликовать шаблоны',
	'Clone Template(s)' => 'Клонировать шаблоны',
	'Revoke Permission' => 'Отменить права',
	'Assets' => 'Медиа',
	'Commenters' => 'Комментаторы',
	'Design' => 'Дизайн',
	'Listing Filters' => 'Фильтры отображения',
	'Settings' => 'Настройка',
	'Tools' => 'Инструменты',
	'Manage' => 'Управление',
	'New' => 'Создать',
	'Folders' => 'Директории',
	'TrackBacks' => 'Трекбэки',
	'Templates' => 'Шаблоны',
	'Widgets' => 'Виджеты',
	'Themes' => 'Темы',
	'General' => 'Общие',
	'Compose' => 'Создать',
	'Feedback' => 'Обратная связь',
	'Registration' => 'Регистрация',
	'Web Services' => 'Веб-сервисы',
	'IP Banning' => 'Бан IP',
	'User' => 'Пользователь',
	'Roles' => 'Роли',
	'Permissions' => 'Права',
	'Search &amp; Replace' => 'Поиск и замена',
	'Plugins' => 'Плагины',
	'Import Entries' => 'Импорт записей',
	'Export Entries' => 'Экспортировать записи',
	'Export Theme' => 'Экспортировать тему',
	'Backup' => 'Бэкап',
	'Restore' => 'Восстановление',
	'Address Book' => 'Адресная книга',
	'Activity Log' => 'Журнал активности',
	'Asset' => 'Медиа',
	'Website' => 'Сайт',
	'Profile' => 'Профиль',

## lib/MT/App/Comments.pm
	'Error assigning commenting rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable commenting role was found.' => 'Ошибка при назначении прав комментирования для пользователя «[_1]» (ID: [_2]), блог «[_3]» (ID: [_4]). Подходящая роль комментатора не нашлась.',
	'Can\'t load blog #[_1].' => 'Не удалось загрузить блог #[_1].',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => 'Неудавшаяся попытка входа комментатора от [_1] в блоге «[_2]» (ID: [_3]), в котором отключена возможность авторизовываться через Movable Type.',
	'Invalid login.' => 'Неверный логин.',
	'Invalid login' => 'Неверный логин',
	'Successfully authenticated but signing up is not allowed.  Please contact system administrator.' => 'Авторизация прошла успешно, но, к сожалению, она запрещена в этом блоге. Пожалуйста, свяжитесь с администратором блога.',
	'You need to sign up first.' => 'Для начала необходимо авторизоваться.',
	'Permission denied.' => 'Доступ запрещён.',
	'Login failed: permission denied for user \'[_1]\'' => 'Авторизация не удалась: для пользователя «[_1]» доступ закрыт',
	'Login failed: password was wrong for user \'[_1]\'' => 'Авторизация не удалась: неправильно указан пароль для пользователя «[_1]»',
	'Failed login attempt by disabled user \'[_1]\'' => 'Авторизация не удалась, потому что пользователь «[_1]» не активен.',
	'Failed login attempt by unknown user \'[_1]\'' => 'Неудачная попытка входа, используя неизвестный логин «[_1]»',
	'Signing up is not allowed.' => 'Авторизация запрещена.',
	'Movable Type Account Confirmation' => 'Активация аккаунта Movable Type',
	'System Email Address is not configured.' => 'Системный email не указан в параметрах.',
	'Commenter \'[_1]\' (ID:[_2]) has been successfully registered.' => 'Комментатор «[_1]» (ID:[_2]) успешно зарегистрировался.',
	'Thanks for the confirmation.  Please sign in to comment.' => 'Активация прошла успешно, спасибо. Пожалуйста, авторизуйтесь для комментирования.',
	'[_1] registered to the blog \'[_2]\'' => 'Пользователь [_1] зарегистрирован в блоге «[_2]»',
	'No id' => 'Не указан ID',
	'No such comment' => 'Нет такого комментария',
	'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IP [_1] заблокирован, потому что превышен предел 8 комментариев за [quant,_2,секунду,секунды,секунд].',
	'IP Banned Due to Excessive Comments' => 'IP заблокирован из-за массовых отправки комментариев',
	'No entry_id' => 'Не указан entry_id',
	'No such entry \'[_1]\'.' => 'Нет такой записи «[_1]».',
	'_THROTTLED_COMMENT' => 'Вы попытались добавить слишком много комментариев за короткий период времени. В народе это называется «флуд». Подождите, пожалуйста, некоторое время.',
	'Comments are not allowed on this entry.' => 'Комментирование этой записи запрещено.',
	'Comment text is required.' => 'Комментарий должен содержать текст.',
	'An error occurred: [_1]' => 'Произошла ошибка: [_1]',
	'Registration is required.' => 'Необходима регистрация.',
	'Name and E-mail address are required.' => 'Имя и электронная почта обязательны.',
	'Invalid email address \'[_1]\'' => 'Неправильный email адрес: [_1]',
	'Invalid URL \'[_1]\'' => 'Неправильный URL: [_1]',
	'Text entered was wrong.  Try again.' => 'Текст введён неправильно. Попробуйте ещё раз.',
	'Comment save failed with [_1]' => 'Не удалось сохранить комментарий с [_1]',
	'Comment on "[_1]" by [_2].' => 'Комментарий к «[_1]» от [_2].',
	'Publish failed: [_1]' => 'Публикация не удалась: [_1]',
	'Can\'t load template' => 'Не удалось загрузить шаблон',
	'Failed comment attempt by pending registrant \'[_1]\'' => 'Неудавшаяся попытка размещения комментария неподтверждённым пользователем  «[_1]»',
	'Registered User' => 'Зарегистрированный пользователь',
	'The sign-in attempt was not successful; please try again.' => 'Авторизация не удалась. Пожалуйста, попробуйте снова.',
	'Can\'t load entry #[_1].' => 'Не удалось загрузить запись #[_1].',
	'No entry was specified; perhaps there is a template problem?' => 'Запись не определена. Возможно, есть проблема с шаблоном?',
	'Somehow, the entry you tried to comment on does not exist' => 'Как-то так произошло, но записи, которую вы пытаетесь комментировать, не существует',
	'Invalid entry ID provided' => 'Представленный ID записи — неверный',
	'All required fields must have valid values.' => 'Все обязательные поля должны быть заполнены правильно.',
	'[_1] contains an invalid character: [_2]' => '[_1] содержит недопустимые символы: [_2]',
	'Display Name' => 'Отображаемое имя',
	'Passwords do not match.' => 'Пароли не идентичны.',
	'Email Address is invalid.' => 'Неправильный email адрес.',
	'URL is invalid.' => 'Неправильный URL.',
	'Commenter profile has successfully been updated.' => 'Профиль комментатора обновлён.',
	'Commenter profile could not be updated: [_1]' => 'Не удалось обновить профиль комментатора: [_1]',

## lib/MT/App/NotifyList.pm
	'Please enter a valid email address.' => 'Пожалуйста, введите правильный email адрес.',
	'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'Пропущен обязательный параметр: blog_id. Пожалуйста, ознакомьтесь с руководством пользователя для настройки уведомлений.',
	'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'Предоставлен неверный параметр для переадресации. Владелец блога должен определить путь, соответствующий домену блога.',
	'The email address \'[_1]\' is already in the notification list for this weblog.' => 'Адрес «[_1]» уже присутствует в списке уведомлений этого блога.',
	'Please verify your email to subscribe' => 'Пожалуйста, подтвердите ваш email для подписки',
	'_NOTIFY_REQUIRE_CONFIRMATION' => 'На адрес [_1] отправлено письмо. Перейдите по ссылке из этого письма, чтобы подтвердить подписку.',
	'The address [_1] was not subscribed.' => 'Адрес [_1] не был подписан.',
	'The address [_1] has been unsubscribed.' => 'Адрес [_1] отписан от уведомлений.',

## lib/MT/App.pm
	'Invalid request: corrupt character data for character set [_1]' => 'Недопустимый запрос: неверный символ для кодировки [_1]',
	'Error loading website #[_1] for user provisioning. Check your NewUserefaultWebsiteId setting.' => 'Ошибка при загрузке сайта #[_1] для указанного пользователя. Проверьте директиву NewUserefaultWebsiteId.',
	'First Weblog' => 'Первый блог',
	'Error loading blog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => 'Ошибка при загрузке блога #[_1]. Проверьте параметр NewUserTemplateBlogId.',
	'Error provisioning blog for new user \'[_1]\' using template blog #[_2].' => 'Ошибка при создании блога для нового пользователя «[_1]», используя шаблоны блога #[_2].',
	'Error provisioning blog for new user \'[_1] (ID: [_2])\'.' => 'Не удалось создать блог для нового пользователя «[_1]» (ID: [_2]).',
	'Blog \'[_1] (ID: [_2])\' for user \'[_3] (ID: [_4])\' has been created.' => 'Блог «[_1]» (ID: [_2]) для пользователя «[_3]» (ID: [_4]) успешно создан.',
	'Error assigning blog administration rights to user \'[_1] (ID: [_2])\' for blog \'[_3] (ID: [_4])\'. No suitable blog administrator role was found.' => 'Ошибка при назначении администраторских прав для пользователя «[_1]» (ID: [_2]), блог «[_3]» (ID: [_4]) — не найдено подходящей роли администратора блога.',
	'Internal Error: Login user is not initialized.' => 'Внутренняя ошибка: логин пользователя не инициализирован.',
	'The login could not be confirmed because of a database error ([_1])' => 'Вход с систему не может быть осуществлён из-за ошибки в базе данных ([_1])',
	'Our apologies, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'К сожалению, у вас нет доступа ни к одному из блогов или сайтов в этой системе. Если вы считаете, что произошла ошибка, пожалуйста, свяжитесь с администратором Movable Type.',
	'This account has been disabled. Please see your system administrator for access.' => 'Эта учётная запись заблокирована. Пожалуйста, свяжитесь с администратором для получения доступа.',
	'Failed login attempt by pending user \'[_1]\'' => 'Ошибка авторизации: попытка входа от ожидающего пользователя «[_1]»',
	'This account has been deleted. Please see your system administrator for access.' => 'Эта учётная запись удалена. Пожалуйста, свяжитесь с администратором для получения доступа.',
	'User cannot be created: [_1].' => 'Пользователь не может быть создан: [_1].',
	'User \'[_1]\' has been created.' => 'Пользователь «[_1]» создан.',
	'User \'[_1]\' (ID:[_2]) logged in successfully' => 'Пользователь «[_1]» (ID:[_2]) авторизовался',
	'Invalid login attempt from user \'[_1]\'' => 'Неудавшаяся попытка авторизации, используя логин «[_1]»',
	'User \'[_1]\' (ID:[_2]) logged out' => 'Пользователь «[_1]» (ID:[_2]) вышел из системы',
	'User requires password.' => 'Необходимо указать пароль.',
	'User requires display name.' => 'Необходимо указать отображаемое имя (оно будет видно для всех).',
	'Email Address is required for password reset.' => 'Необходим адрес электронной почты для сброса пароля.',
	'User requires username.' => 'Необходимо указать логин.',
	'Username' => 'Имя пользователя',
	'A user with the same name already exists.' => 'Пользователь с таким именем уже существует.',
	'Something wrong happened when trying to process signup: [_1]' => 'Что-то пошло не так, пока вы регистрировались: [_1]',
	'New Comment Added to \'[_1]\'' => 'Добавлен новый комментарий к «[_1]»',
	'Close' => 'Закрыть',
	'The file you uploaded is too large.' => 'Загружаемый файл слишком большой.',
	'Unknown action [_1]' => 'Неизвестное действие [_1]',
	'Warnings and Log Messages' => 'Предупреждения и журнал записей',
	'Removed [_1].' => 'Удалено: [_1].',
	'You did not have permission for this action.' => 'У вас нет прав для совешения этого действия.',

## lib/MT/App/Search/Legacy.pm
	'You are currently performing a search. Please wait until your search is completed.' => 'В данный момент осуществляется поиск. Пожалуйста, дождитесь завершения поиска.',
	'Search failed. Invalid pattern given: [_1]' => 'Поиск не удался. Представлены недопустимые данные: [_1]',
	'Search failed: [_1]' => 'Поиск не удался: [_1]',
	'No alternate template is specified for the Template \'[_1]\'' => 'Не указан альтернативный шаблон для шаблона «[_1]»',
	'Opening local file \'[_1]\' failed: [_2]' => 'Не удалось открыть локальный файл «[_1]»: [_2]',
	'Publishing results failed: [_1]' => 'Публикация результатов не удалась: [_1]',
	'Search: query for \'[_1]\'' => 'Поиск: запрос «[_1]»',
	'Search: new comment search' => 'Поиск: новые коментарии',

## lib/MT/App/Search.pm
	'Invalid type: [_1]' => 'Неверный тип: [_1]',
	'Search: failed storing results in cache.  [_1] is not available: [_2]' => 'Поиск: не удалось сохранить результат в кеш. [_1] — не доступна: [_2]',
	'Invalid format: [_1]' => 'Неверный формат: [_1]',
	'Unsupported type: [_1]' => 'Неподдерживаемый тип: [_1]',
	'Invalid query: [_1]' => 'Неверный запрос: [_1]',
	'Invalid archive type' => 'Неверный тип архива',
	'Invalid value: [_1]' => 'Неверное значение: [_1]',
	'No column was specified to search for [_1].' => 'Нет колонки, указанной для поиска по [_1]',
	'No such template' => 'Нет такого шаблона',
	'template_id cannot be a global template' => 'template_id не может быть глобальным шаблоном',
	'Output file cannot be asp or php' => 'Конечный файл не может быть PHP или ASP',
	'You must pass a valid archive_type with the template_id' => 'Необходимо передать действительный archive_type с template_id',
	'Template must have identifier entry_listing for non-Index archive types' => 'У шаблона должен быть идентификатор для неиндексных типов архивов',
	'Blog file extension cannot be asp or php for these archives' => 'Для этих архивов расширение публикуемых файлов блога не может быть php или asp',
	'Template must have identifier main_index for Index archive type' => 'У шаблона должен быть индентификатор main_index для индексного типа архива',
	'The search you conducted has timed out.  Please simplify your query and try again.' => 'Поиск по вашему запросу занимает слишком продолжительное время. Пожалуйста, упростите ваш запрос и повторите попытку.',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearch работает с MT::App::Search.',

## lib/MT/App/Trackback.pm
	'Invalid entry ID \'[_1]\'' => 'Неправильный ID записи - \'[_1]\'',
	'You must define a Ping template in order to display pings.' => 'Для отображения пингов необходимо задать для них шаблон.',
	'Trackback pings must use HTTP POST' => 'При отправке трекбэков нужно использовать HTTP POST',
	'Need a TrackBack ID (tb_id).' => 'Необходим ID трекбэка (tb_id).',
	'Invalid TrackBack ID \'[_1]\'' => 'Неверный ID трекбэка: [_1]',
	'You are not allowed to send TrackBack pings.' => 'У вас нет прав на отправку трекбэков.',
	'You are pinging trackbacks too quickly. Please try again later.' => 'Вы отправляете трекбэки слишком часто. Пожалуйста, попробуйте ещё раз чуть позже.',
	'Need a Source URL (url).' => 'Необходим источник (url).',
	'This TrackBack item is disabled.' => 'Этот элемент трекбэка заблокирован.',
	'This TrackBack item is protected by a passphrase.' => 'Этот элемент трекбэка защищен паролем.',
	'TrackBack on "[_1]" from "[_2]".' => 'Трекбэк к «[_1]» от «[_2]».',
	'TrackBack on category \'[_1]\' (ID:[_2]).' => 'Трекбэк к категории «[_1]» (ID:[_2]).',
	'Can\'t create RSS feed \'[_1]\': ' => 'Не удалось создать RSS канал «[_1]»: ',
	'New TrackBack Ping to \'[_1]\'' => 'Новый трекбэк к «[_1]»',
	'New TrackBack Ping to Category \'[_1]\'' => 'Новый трекбэк к категории «[_1]»',

## lib/MT/App/Upgrader.pm
	'Could not authenticate using the credentials provided: [_1].' => 'Не удалось авторизоваться, используя предоставленные данные: [_1].',
	'Both passwords must match.' => 'Оба пароля должны совпадать.',
	'You must supply a password.' => 'Необходимо указать пароль.',
	'The \'Publishing Path\' provided below is not writable by the web server.  Change the ownership or permissions on this directory, then click \'Finish Install\' again.' => 'Путь публикации, указанный ниже, не доступен для записи. Смените владельца или права доступа у этой директории, а затем нажмите продолжите установку.',
	'Invalid session.' => 'Неверная сессия.',
	'No permissions. Please contact your administrator for upgrading Movable Type.' => 'Недостаточно прав для выполнения этого действия. Пожалуйста, свяжитесь с администратором для обновления Movable Type.',
	'Movable Type has been upgraded to version [_1].' => 'Movable Type обновлён до версии [_1].',

## lib/MT/App/Viewer.pm
	'Loading blog with ID [_1] failed' => 'Не удалось загрузить блог с ID [_1]',
	'Template publishing failed: [_1]' => 'Не удалось опубликовать шаблон: [_1]',
	'Invalid date spec' => 'Неверный формат даты',
	'Can\'t load templatemap' => 'Не удалось загрузить карту шаблонов',
	'Can\'t load template [_1]' => 'Не удалось загрузить шаблон [_1]',
	'Archive publishing failed: [_1]' => 'Не удалось опубликовать архив: [_1]',
	'Entry [_1] is not published' => 'Запись [_1] не опубликована',
	'Invalid category ID \'[_1]\'' => 'Неверный ID категории: [_1]',

## lib/MT/App/Wizard.pm
	'The [_1] driver is required to use [_2].' => 'Для использования [_2] необходим драйвер [_1].',
	'An error occurred while attempting to connect to the database.  Check the settings and try again.' => 'Не удалось соединиться с базой данных. Пожалуйста, проверьте параметры и попробуйте ещё раз.',
	'Please select database from the list of database and try again.' => 'Пожалуйста, выберите базу данных из списка и попробуйте снова.',
	'SMTP Server' => 'SMTP сервер',
	'Sendmail' => 'Sendmail', # Translate - Not translated
	'Test email from Movable Type Configuration Wizard' => 'Тестовое письмо от Movable Type',
	'This is the test email sent by your new installation of Movable Type.' => 'Это тестовое письмо, отправленное во время установки Movable Type.',
	'This module is needed to encode special characters, but this feature can be turned off using the NoHTMLEntities option in mt-config.cgi.' => 'Модуль необходим для кодирования специальных символов. Но вы можете отключить эту возможность, используя опцию NoHTMLEntities в mt-config.cgi.',
	'This module is needed if you want to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'Модуль необходим, если вы хотите использовать систему трекбэков для пинга различных сервисов (например, Яндекс.Блоги или weblogs.com).',
	'This module is needed if you want to use the MT XML-RPC server implementation.' => 'Модуль необходим, если вы хотите работать с MT посредством XML-RPC (блогинг-клиенты; различные программы, позволяющие работать с MT не из браузера).',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'Модуль необходим для перезаписи файлов после загрузки.',
	'This module is required by certain MT plugins available from third parties.' => 'Модуль обязателен для некоторых плагинов MT.',
	'This module accelerates comment registration sign-ins.' => 'Модуль ускоряет регистрацию комментаторов.',
	'This module is needed to enable comment registration.' => 'Модуль необходим для включения возможности регистрации комментаторов.',
	'This module enables the use of the Atom API.' => 'Модуль позволяет использовать Atom API.',
	'This module is required in order to use memcached as caching mechanism used by Movable Type.' => 'Модуль необходим для использования memcached как механизма кеширования в Movable Type.',
	'This module is required in order to archive files in backup/restore operation.' => 'Модуль необходим для добавления в архив файлов во время операции резервного копирования/восстановления.',
	'This module is required in order to compress files in backup/restore operation.' => 'Модуль необходим для сжатия файлов во время операции резервного копирования/восстановления.',
	'This module is required in order to decompress files in backup/restore operation.' => 'Модуль необходим для распаковки файлов во время операции резервного копирования/восстановления.',
	'This module and its dependencies are required in order to restore from a backup.' => 'Этот модуль и зависимости от него необходимы для восстановления из резервной копии.',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.' => 'Модуль и его зависимости необходим для авторизации комментаторов посредством OpenID, включая LiveJournal.',
	'This module is required for sending mail via SMTP Server.' => 'Модуль необходим для отправки почты посредством SMTP сервера.',
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Модуль необходим для загрузки файлов (чтобы определить размер загруженных изображений в различных форматах).',
	'This module is required for cookie authentication.' => 'Модуль необходим для авторизации через куки (cookie).',

## lib/MT/ArchiveType/AuthorDaily.pm
	'AUTHOR-DAILY_ADV' => 'авторов по дням',
	'author/author-basename/yyyy/mm/dd/index.html' => 'author/базовое-имя-автора/гггг/мм/дд/index.html',
	'author/author_basename/yyyy/mm/dd/index.html' => 'author/базовое_имя_автора/гггг/мм/дд/index.html',

## lib/MT/ArchiveType/AuthorMonthly.pm
	'AUTHOR-MONTHLY_ADV' => 'авторов по месяцам',
	'author/author-basename/yyyy/mm/index.html' => 'author/базовое-имя-автора/гггг/мм/index.html',
	'author/author_basename/yyyy/mm/index.html' => 'author/базовое_имя_автора/гггг/мм/index.html',

## lib/MT/ArchiveType/Author.pm
	'AUTHOR_ADV' => 'авторов',
	'author/author-basename/index.html' => 'author/базовое_имя_автора/index.html',
	'author/author_basename/index.html' => 'author/базовое_имя_автора/index.html',

## lib/MT/ArchiveType/AuthorWeekly.pm
	'AUTHOR-WEEKLY_ADV' => 'авторов по неделям',
	'author/author-basename/yyyy/mm/day-week/index.html' => 'author/базовое-имя-автора/гггг/мм/день-недели/index.html',
	'author/author_basename/yyyy/mm/day-week/index.html' => 'author/базовое_имя_автора/гггг/мм/день-недели/index.html',

## lib/MT/ArchiveType/AuthorYearly.pm
	'AUTHOR-YEARLY_ADV' => 'авторов по годам',
	'author/author-basename/yyyy/index.html' => 'author/базовое-имя-автора/гггг/index.html',
	'author/author_basename/yyyy/index.html' => 'author/базовое_имя_автора/гггг/index.html',

## lib/MT/ArchiveType/CategoryDaily.pm
	'CATEGORY-DAILY_ADV' => 'категорий по дням',
	'category/sub-category/yyyy/mm/dd/index.html' => 'категория/под-категория/гггг/мм/дд/index.html',
	'category/sub_category/yyyy/mm/dd/index.html' => 'категория/под_категория/гггг/мм/дд/index.html',

## lib/MT/ArchiveType/CategoryMonthly.pm
	'CATEGORY-MONTHLY_ADV' => 'категорий по месяцам',
	'category/sub-category/yyyy/mm/index.html' => 'категория/под-категория/гггг/мм/index.html',
	'category/sub_category/yyyy/mm/index.html' => 'категория/под_категория/гггг/мм/index.html',

## lib/MT/ArchiveType/Category.pm
	'CATEGORY_ADV' => 'категорий',
	'category/sub-category/index.html' => 'категория/под-категория/index.html',
	'category/sub_category/index.html' => 'категория/под_категория/index.html',

## lib/MT/ArchiveType/CategoryWeekly.pm
	'CATEGORY-WEEKLY_ADV' => 'категорий по неделям',
	'category/sub-category/yyyy/mm/day-week/index.html' => 'категория/под-категория/гггг/мм/день-недели/index.html',
	'category/sub_category/yyyy/mm/day-week/index.html' => 'категория/под_категория/гггг/мм/день-недели/index.html',

## lib/MT/ArchiveType/CategoryYearly.pm
	'CATEGORY-YEARLY_ADV' => 'категорий по годам',
	'category/sub-category/yyyy/index.html' => 'категория/под-категория/гггг/index.html',
	'category/sub_category/yyyy/index.html' => 'категория/под_категория/гггг/index.html',

## lib/MT/ArchiveType/Daily.pm
	'DAILY_ADV' => 'по дням',
	'yyyy/mm/dd/index.html' => 'гггг/мм/дд/index.html',

## lib/MT/ArchiveType/Individual.pm
	'INDIVIDUAL_ADV' => 'записей',
	'yyyy/mm/entry-basename.html' => 'гггг/мм/имя-записи.html',
	'yyyy/mm/entry_basename.html' => 'гггг/мм/имя_записи.html',
	'yyyy/mm/entry-basename/index.html' => 'гггг/мм/имя-записи/index.html',
	'yyyy/mm/entry_basename/index.html' => 'гггг/мм/имя_записи/index.html',
	'yyyy/mm/dd/entry-basename.html' => 'гггг/мм/дд/имя-записи.html',
	'yyyy/mm/dd/entry_basename.html' => 'гггг/мм/дд/nomdebase_note.html',
	'yyyy/mm/dd/entry-basename/index.html' => 'гггг/мм/дд/имя-записи/index.html',
	'yyyy/mm/dd/entry_basename/index.html' => 'гггг/мм/дд/имя_записи/index.html',
	'category/sub-category/entry-basename.html' => 'категория/под-категория/имя-записи.html',
	'category/sub-category/entry-basename/index.html' => 'категория/под-категория/имя-записи/index.html',
	'category/sub_category/entry_basename.html' => 'категория/под_категория/имя_записи.html',
	'category/sub_category/entry_basename/index.html' => 'категория/под_категория/имя_записи/index.html',

## lib/MT/ArchiveType/Monthly.pm
	'MONTHLY_ADV' => 'по месяцам',
	'yyyy/mm/index.html' => 'гггг/мм/index.html',

## lib/MT/ArchiveType/Page.pm
	'PAGE_ADV' => 'страниц',
	'folder-path/page-basename.html' => 'путь-директории/имя-страницы.html',
	'folder-path/page-basename/index.html' => 'путь-директории/имя-страницы/index.html',
	'folder_path/page_basename.html' => 'путь_директории/имя_страницы.html',
	'folder_path/page_basename/index.html' => 'путь_директории/имя_страницы/index.html',

## lib/MT/ArchiveType/Weekly.pm
	'WEEKLY_ADV' => 'по неделям',
	'yyyy/mm/day-week/index.html' => 'гггг/мм/день-недели/index.html',

## lib/MT/ArchiveType/Yearly.pm
	'YEARLY_ADV' => 'по годам',
	'yyyy/index.html' => 'гггг/index.html',

## lib/MT/Asset/Image.pm
	'Images' => 'Изображения',
	'Actual Dimensions' => 'Реальные размеры',
	'[_1] x [_2] pixels' => '[_1] x [_2] пикселей',
	'Error cropping image: [_1]' => 'Ошибка при обрезке изображения: [_1]',
	'Error scaling image: [_1]' => 'Ошибка при изменении изображения: [_1]',
	'Error converting image: [_1]' => 'Ошибка при конвертации изображения: [_1]',
	'Error creating thumbnail file: [_1]' => 'Ошибка при создании миниатюры изображения: [_1]',
	'%f-thumb-%wx%h-%i%x' => '%f-thumb-%wx%h-%i%x', # Translate - Not translated
	'Can\'t load image #[_1]' => 'Не удалось загрузить изображение #[_1]',
	'View image' => 'Просмотр изображения',
	'Permission denied setting image defaults for blog #[_1]' => 'Недостаточно прав для сохранения настроек по умолчанию для изображений в блоге #[_1]',
	'Thumbnail image for [_1]' => 'Миниатюра изображения для [_1]',
	'Invalid basename \'[_1]\'' => 'Неправильное базовое имя «[_1]»',
	'Error writing to \'[_1]\': [_2]' => 'Ошибка при записи в «[_1]»: [_2]',
	'Popup Page for [_1]' => 'Страница всплывающего окна для [_1]',

## lib/MT/Asset.pm
	'Deleted' => 'Удалено',
	'Enabled' => 'Работает',
	'Disabled' => 'Отключено',
	'Could not remove asset file [_1] from filesystem: [_2]' => 'Не удалось удалить медиа-файл [_1] с файловой системы: [_2]',
	'Description' => 'Описание',
	'Location' => 'Размещение',
	'string(255)' => 'string(255)', # Translate - Not translated
	'Label' => 'Имя',
	'Type' => 'Тип',
	'Filename' => 'Имя файла',
	'File Extension' => 'Расширение файлов',
	'Pixel width' => 'Ширина (пикселей)',
	'Pixel height' => 'Высота (пикселей)',
	'Except Userpic' => 'Исключая аватары',
	'Author Status' => 'Статус автора',
	'Assets of this website' => 'Медиа на этом сайте',

## lib/MT/Asset/Video.pm
	'Videos' => 'Видео',

## lib/MT/Association.pm
	'Association' => 'Ассоциация',
	'Associations' => 'Ассоциации',
	'Permissions with role: [_1]' => 'Права с ролью: [_1]',
	'Permissions for [_1]' => 'Права доступа для [_1]',
	'association' => 'ассоциация',
	'associations' => 'ассоциация',
	'User Name' => 'Имя пользователя',
	'Role' => 'Роль',
	'Role Name' => 'Имя роли',
	'Role Detail' => 'Детали роли',
	'Website/Blog Name' => 'Имя сайта/блога',
	'__WEBSITE_BLOG_NAME' => 'Имя сайта/блога',

## lib/MT/AtomServer.pm
	'[_1]: Entries' => '[_1]: записи',
	'Invalid blog ID \'[_1]\'' => 'ID «[_1]» для блога указан неверно',
	'PreSave failed [_1]' => 'Ошибка предварительного сохранения [_1]',
	'User \'[_1]\' (user #[_2]) added [lc,_4] #[_3]' => 'Пользователь «[_1]» (ID #[_2]) добавил [lc,_4] #[_3]',
	'User \'[_1]\' (user #[_2]) edited [lc,_4] #[_3]' => 'Пользователь «[_1]» (ID #[_2]) отредактировал [lc,_4] #[_3]',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from atom api' => 'Запись «[_1]» ([lc,_5] #[_2]) удалена пользователем «[_3]» (#[_4]) через Atom API',
	'The file([_1]) you uploaded is not allowed.' => 'Нельзя загрузить указанный файл: [_1].',
	'Saving [_1] failed: [_2]' => 'Не удалось сохранить [_1]: [_2]',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Для указания ширины и высоты загружаемыех файлов необходим модуль Perl Image::Size.',

## lib/MT/Auth/MT.pm
	'Failed to verify current password.' => 'Неверно указан текущий пароль.',

## lib/MT/Auth/OpenID.pm
	'Couldn\'t save the session' => 'Не удалось сохранить сессию',
	'Could not load Net::OpenID::Consumer.' => 'Не удалось загрузить Net::OpenID::Consumer.',
	'The address entered does not appear to be an OpenID' => 'Указанный адрес не может быть использован в качестве OpenID',
	'The text entered does not appear to be a web address' => 'Введённый текст не является веб-адресом',
	'Unable to connect to [_1]: [_2]' => 'Не удалось соединиться с [_1]: [_2]',
	'Could not verify the OpenID provided: [_1]' => 'Не удалось проверить OpenID: [_1]',

## lib/MT/Author.pm
	'Users' => 'Пользователи',
	'Active' => 'Активный',
	'Pending' => 'Ожидающий',
	'__COMMENTER_APPROVED' => 'Принят',
	'Banned' => 'Заблокирован',
	'MT Users' => 'Пользователи MT',
	'The approval could not be committed: [_1]' => 'Одобрение не может быть совершено: [_1]',
	'Userpic' => 'Аватар',
	'User Info' => 'Информация о пользователе',
	'__ENTRY_COUNT' => 'Количество записей',
	'__COMMENT_COUNT' => 'Количество комментариев',
	'Created by' => 'Создано',
	'Status' => 'Статус',
	'Website URL' => 'Адрес сайта (URL)',
	'Privilege' => 'Привилегии',
	'Enabled Users' => 'Активные пользователи',
	'Disabled Users' => 'Отключенные пользователи',
	'Pending Users' => 'Ожидающие пользователи',
	'Enabled Commenters' => 'Активные комментаторы',
	'Disabled Commenters' => 'Отключенные комментаторы',
	'Pending Commenters' => 'Ожидающие комментаторы',
	'MT Native Users' => 'Зарегистрированные пользователи MT',
	'Externally Authenticated Commenters' => 'Комментаторы с других сервисов',

## lib/MT/Auth.pm
	'Bad AuthenticationModule config \'[_1]\': [_2]' => 'Неудачная конфигурация модуля идентификации «[_1]»: [_2]',
	'Bad AuthenticationModule config' => 'Неверная конфигурация модуля идентификации',

## lib/MT/Auth/TypeKey.pm
	'Sign in requires a secure signature.' => 'Авторизация требует безопасной подписи.',
	'The sign-in validation failed.' => 'Проверка авторизации не удалась.',
	'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'В этом блоге необходимо указать email адрес. Пожалуйста, авторизуйтесь заново, но перед этим укажите в параметрах авторизационного сервиса, чтобы он по запросу передавал ваш email.',
	'Couldn\'t get public key from url provided' => 'Не удалось получить публичный ключ.',
	'No public key could be found to validate registration.' => 'Публичный ключ, необходимый для проверки регистрации, не найден.',
	'TypePad signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'Проверка подписи TypePad возвратила [_1] за [_2] сек. проверив [_3] с [_4]',
	'The TypePad signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'Подпись TypePad устарела ([_1] сек. назад). Убедитесь, что часы вашего сервера установлены правильно.',

## lib/MT/BackupRestore/BackupFileHandler.pm
	'Uploaded file was not a valid Movable Type backup manifest file.' => 'Загруженный файл не соответствует формату Movable Type.',
	'Uploaded file was backed up from Movable Type but the different schema version ([_1]) from the one in this system ([_2]).  It is not safe to restore the file to this version of Movable Type.' => 'Загруженный файл — резервная копия Movable Type, но его версия схемы базы данных ([_1]) отличается от текущей версии ([_2]). Восстановление данных из этого файла может быть небезопасно.',
	'[_1] is not a subject to be restored by Movable Type.' => '[_1] — не является причиной для восстановления Movable Type.',
	'[_1] records restored.' => '[_1] записей восстановлено.',
	'Restoring [_1] records:' => 'Восстановление [_1] записей:',
	'User with the same name as the name of the currently logged in ([_1]) found.  Skipped the record.' => 'Пользователь с тем же самым именем уже авторизован ([_1]). Пропуск отчёта.',
	'User with the same name \'[_1]\' found (ID:[_2]).  Restore replaced this user with the data backed up.' => 'Найден пользователь с тем же самым именем  — «[_1]» (ID:[_2]). При восстановлении была произведена замена этого пользователя полученными данными.',
	'Tag \'[_1]\' exists in the system.' => 'Тег «[_1]» уже есть в системе.',
	'[_1] records restored...' => '[_1] записей восстанавливаются…',
	'The role \'[_1]\' has been renamed to \'[_2]\' because a role with the same name already exists.' => 'Роль «[_1]» была переименована в «[_2]», потому что роль с таким именем уже существует.',
	'The system level settings for plugin \'[_1]\' already exist.  Skipping this record.' => 'Системный параметр для плагина \'[_1]\' уже существует. Пропускаем этот пункт.',

## lib/MT/BackupRestore.pm
	'Backing up [_1] records:' => 'Сохранение записей [_1]:',
	'[_1] records backed up...' => 'Сохрание [_1] записей…',
	'[_1] records backed up.' => '[_1] записей сохранено.',
	'There were no [_1] records to be backed up.' => 'В [_1] нет записей для сохранения.',
	'Can\'t open directory \'[_1]\': [_2]' => 'Не удалось открыть директорию «[_1]» : [_2]',
	'No manifest file could be found in your import directory [_1].' => 'В директории импорта [_1] не найдено необходимого файла.',
	'Can\'t open [_1].' => 'Не удалось открыть [_1].',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => 'Содержимое указанного файла в неправильном для импорта формате.',
	'Manifest file: [_1]' => 'Файл импорта: [_1]',
	'Path was not found for the file ([_1]).' => 'Путь для файла указан неверно ([_1]).',
	'[_1] is not writable.' => '[_1] — не доступно для записи.',
	'Error making path \'[_1]\': [_2]' => 'Ошибка при создании пути «[_1]\» : [_2]',
	'Copying [_1] to [_2]...' => 'Копирование [_1] в [_2]...',
	'Failed: ' => 'Ошибка: ',
	'Done.' => 'Успешно.',
	'Restoring asset associations ... ( [_1] )' => 'Восстановление ассоциаций медиа… ([_1])',
	'Restoring asset associations in entry ... ( [_1] )' => 'Восстановление ассоциаций медиа в записях… ([_1])',
	'Restoring asset associations in page ... ( [_1] )' => 'Восстановление ассоциаций медиа в страницах… ([_1])',
	'Restoring url of the assets ( [_1] )...' => 'Восстановление адресов для медиа… ([_1])',
	'Restoring url of the assets in entry ( [_1] )...' => 'Восстановление адресов для медиа в записях… ([_1])',
	'Restoring url of the assets in page ( [_1] )...' => 'Восстановление адресов для медиа в страницах… ([_1])',
	'ID for the file was not set.' => 'Не был указан ID для файла.',
	'The file ([_1]) was not restored.' => 'Файл ([_1]) не восстановлен.',
	'Changing path for the file \'[_1]\' (ID:[_2])...' => 'Изменение пути для файла «[_1]» (ID:[_2])…',
	'failed' => 'не удалось',
	'ok' => 'ok', # Translate - Not translated

## lib/MT/BasicAuthor.pm
	'authors' => 'авторы',

## lib/MT/Blog.pm
	'First Blog' => 'Первый блог',
	'No default templates were found.' => 'Не найдены стандартные шаблоны.',
	'Clone of [_1]' => 'Клон [_1]',
	'Cloned blog... new id is [_1].' => 'Клонирование блога… новый ID — [_1].',
	'Cloning permissions for blog:' => 'Клонирование прав для блога:',
	'[_1] records processed...' => '[_1] элементов обработано…',
	'[_1] records processed.' => '[_1] элементов обработано.',
	'Cloning associations for blog:' => 'Клонирование ассоциаций блога:',
	'Cloning entries and pages for blog...' => 'Клонирование записей и страниц блога…',
	'Cloning categories for blog...' => 'Клонирование категорий блога…',
	'Cloning entry placements for blog...' => 'Клонирование расположения записей блога…',
	'Cloning comments for blog...' => 'Клонирование комментариев блога…',
	'Cloning entry tags for blog...' => 'Клонирование тегов записей…',
	'Cloning TrackBacks for blog...' => 'Клонирование трекбэков блога…',
	'Cloning TrackBack pings for blog...' => 'Клонирование отправленных трекбэков блога…',
	'Cloning templates for blog...' => 'Клонирование шаблонов блога…',
	'Cloning template maps for blog...' => 'Клонирование карт шаблонов блога…',
	'Failed to load theme [_1]: [_2]' => 'Не удалось загрузить тему [_1]: [_2]',
	'Failed to apply theme [_1]: [_2]' => 'Не удалось применить тему [_1]: [_2]',
	'__PAGE_COUNT' => 'Количество страниц',
	'__ASSET_COUNT' => 'Количество медиа',
	'Members' => 'Пользователи',
	'Theme' => 'Тема',

## lib/MT/Bootstrap.pm
	'Got an error: [_1]' => 'Получена ошибка: [_1]',

## lib/MT/Builder.pm
	'<[_1]> at line [_2] is unrecognized.' => '<[_1]> в строке [_2] не распознано.',
	'<[_1]> with no </[_1]> on line #' => '<[_1]> нет </[_1]> в строке #',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]> нет </[_1]> в строке [_2].',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]> нет </[_1]> в строке [_2]',
	'Error in <mt[_1]> tag: [_2]' => 'Ошибка в теге <mt[_1]>: [_2]',
	'Unknown tag found: [_1]' => 'Найден неизвестный тег: [_1]',

## lib/MT/Category.pm
	'[quant,_1,entry,entries,No entries]' => '[quant,_1,запись,записи,записей,Нет записей]',
	'[quant,_1,page,pages,No pages]' => '[quant,_1,страница,страницы,страниц,Нет страниц]',
	'Category' => 'Категория',
	'Categories must exist within the same blog' => 'Категории должны существовать в пределах одного и того же блога',
	'Category loop detected' => 'Обнаружен цикл категорий',
	'string(100) not null' => 'string(100) not null', # Translate - Not translated
	'Basename' => 'Базовое имя',
	'Parent' => 'Родитель',

## lib/MT/CMS/AddressBook.pm
	'No entry ID provided' => 'Не указан ID записи',
	'No such entry \'[_1]\'' => 'Нет такой записи: «[_1]»',
	'No email address for user \'[_1]\'' => 'У пользователя «[_1]» нет email адреса',
	'No valid recipients found for the entry notification.' => 'Нет доступных получателей для уведомления о записи.',
	'[_1] Update: [_2]' => '[_1] обновлено: [_2]',
	'Error sending mail ([_1]); try another MailTransfer setting?' => 'Не удалось отправить почту ([_1]); попробовать настроить MailTransfer?',
	'Please select a blog.' => 'Пожалуйста, выберите блог.',
	'The value you entered was not a valid email address' => 'Представленная вами информация не является email адресом',
	'The value you entered was not a valid URL' => 'Вы ввели данные, которые не соответствуют URL',
	'The e-mail address you entered is already on the Notification List for this blog.' => 'Email, который вы ввели, уже присутствует в списке подписчиков этого блога.',
	'Subscriber \'[_1]\' (ID:[_2]) deleted from address book by \'[_3]\'' => 'Подписчик «[_1]» (ID:[_2]) удалён из адресной книги пользователем «[_3]»',

## lib/MT/CMS/Asset.pm
	'(user deleted)' => '(пользователь удалён)',
	'Files' => 'Файлы',
	'Extension changed from [_1] to [_2]' => 'Расширение изменено с [_1] на [_2]',
	'Upload File' => 'Загрузка файла',
	'Can\'t load file #[_1].' => 'Не удалось загрузить файл #[_1].',
	'No permissions' => 'Недостаточно прав',
	'File \'[_1]\' uploaded by \'[_2]\'' => 'Файл «[_1]» загружен пользователем «[_2]»',
	'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Файл «[_1]» (ID:[_2]) удалён пользователем «[_3]»',
	'Untitled' => 'Безымянный',
	'Archive Root' => 'Папка архива',
	'Site Root' => 'Папка сайта',
	'Please select a file to upload.' => 'Пожалуйста, выберите файл для загрузки.',
	'Invalid filename \'[_1]\'' => 'Неверное имя файла «[_1]\»',
	'Please select an audio file to upload.' => 'Пожалуйста, выберите аудио файл для загрузки.',
	'Please select an image to upload.' => 'Пожалуйста, выберите изображение для загрузки.',
	'Please select a video to upload.' => 'Пожалуйста, выберите видео для загрузки.',
	'Movable Type was unable to write on the "Upload Destination". Please make sure that the folder is writable from the web server.' => 'Movable Type не может выполнить загрузку в «Место загрузки». Пожалуйста, сделайте эту папку перезаписываемой.',
	'Invalid extra path \'[_1]\'' => 'Неправильный дополнительный путь «[_1]»',
	'Can\'t make path \'[_1]\': [_2]' => 'Не удалось создать путь «[_1]» : [_2]',
	'Invalid temp file name \'[_1]\'' => 'Неправильное имя временного файла «[_1]»',
	'Error opening \'[_1]\': [_2]' => 'Ошибка при открытии «[_1]»: [_2]',
	'Error deleting \'[_1]\': [_2]' => 'Ошибка при удалении «[_1]»: [_2]',
	'File with name \'[_1]\' already exists. (Install File::Temp if you\'d like to be able to overwrite existing uploaded files.)' => 'Файл с именем «[_1]» уже существует. (Установите File::Temp, если вы хотите перезаписывать уже загруженные файлы.)',
	'Error creating temporary file; please check your TempDir setting in your coniguration file (currently \'[_1]\') this location should be writable.' => 'Ошибка при создании временного файла; пожалуйста, проверьте параметр TempDir в вашем конфигурационном файле (сейчас там указано «[_1]»). Эта папка должна быть доступна для записи.',
	'unassigned' => 'не определено',
	'File with name \'[_1]\' already exists; Tried to write to tempfile, but open failed: [_2]' => 'Файл с именем «[_1]» уже существует. Была осуществлена попытка записи временного файла, но не удалось открыть: [_2]',
	'Could not create upload path \'[_1]\': [_2]' => 'Не удалось создать путь загрузки «[_1]»: [_2]',
	'Error writing upload to \'[_1]\': [_2]' => 'Ошибка записи файла при загрузке в «[_1]»: [_2]',
	'Uploaded file is not an image.' => 'Загруженный файл — не изображение.',
	'Can\'t overwrite with the file of different type. Original: [_1] Uploaded: [_2]' => 'Не удалось перезаписать файлом другого типа. Оригинал: [_1] Загруженный: [_2]',
	'<' => '<', # Translate - Not translated
	'/' => '/', # Translate - Not translated

## lib/MT/CMS/BanList.pm
	'You did not enter an IP address to ban.' => 'Вы не ввели IP адрес, который хотите заблокировать.',
	'The IP you entered is already banned for this blog.' => 'Введённый IP уже заблокирован в этом блоге.',

## lib/MT/CMS/Blog.pm
	q{Cloning blog '[_1]'...} => q{Клонирование блога «[_1]»…},
	'Error' => 'Ошибка',
	'Finished!' => 'Завершено!',
	'General Settings' => 'Общая настройка',
	'Plugin Settings' => 'Настройка плагинов',
	'New Blog' => 'Новый блог',
	'Can\'t load template #[_1].' => 'Не удалось загрузить шаблон #[_1]',
	'index template \'[_1]\'' => 'индексный шаблон «[_1]»',
	'[_1] \'[_2]\'' => '[_1] «[_2]»',
	'Publish Site' => 'Опубликовать сайт',
	'Invalid blog' => 'Недопустимый блог',
	'Select Blog' => 'Выберите блог',
	'Selected Blog' => 'Выбранный блог',
	'Type a blog name to filter the choices below.' => 'Напечатайте имя блога, чтобы отфильтровать представленные ниже.',
	'Blog Name' => 'Имя блога',
	'[_1] changed from [_2] to [_3]' => '[_1] изменено с [_2] на [_3]',
	'Saved [_1] Changes' => 'Изменения [_1] сохранены',
	'Saving permissions failed: [_1]' => 'Не удалось сохранить права: [_1]',
	'[_1] \'[_2]\' (ID:[_3]) created by \'[_4]\'' => '[_1] «[_2]» (ID:[_3]), созданный «[_4]»',
	'You did not specify a blog name.' => 'Вы не указали имя блога.',
	'Site URL must be an absolute URL.' => 'Необходимо указать абсолютный URL.',
	'Archive URL must be an absolute URL.' => 'Необходимо указать абсолютный URL архивов.',
	'You did not specify an Archive Root.' => 'Вы не указали путь публикации архивов.',
	'The number of revisions to store must be a positive integer.' => 'Число сохраняемых ревизий должно быть положительным числом.',
	'Blog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Блог «[_1]» (ID:[_2]) удалён пользователем «[_3]»',
	'Saving blog failed: [_1]' => 'Не удалось сохранить блог: [_1]',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'Ошибка: Movable Type не удалось записать файлы в папку с кешом шаблонов. Пожалуйста, проверьте права доступа для вызываемой директории <code>[_1]</code>, расположенной в папке блога.',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'Ошибка: Movable Type не удалось создать директорию для кеширования динамических шаблонов. Вам необходимо создать директорию <code>[_1]</code>, расположенную в папке блога.',
	'No blog was selected to clone.' => 'Не выбран блог для клонирования',
	'This action can only be run on a single blog at a time.' => 'В настоящее время это действие может быть выполнено только в одном блоге.',
	'Invalid blog_id' => 'Неверный ID блога',
	'This action cannot clone website.' => 'Это действие не может клонировать сайт.',
	'Entries must be cloned if comments and trackbacks are cloned' => 'Записи будут склонированы, если будут склонированы комментарии и трекбэки',
	'Entries must be cloned if comments are cloned' => 'Записи будут склонированы, если будут склонированы комментарии',
	'Entries must be cloned if trackbacks are cloned' => 'Записи будут склонированы, если будут склонированы трекбэки',

## lib/MT/CMS/Category.pm
	'The [_1] must be given a name!' => 'У [_1] должно быть указано имя!',
	'Failed to update [_1]: some of [_2] were changed after you opened this screen.' => 'Ошибка обновления [_1]: что-то в [_2] изменилось с момента открытия этой страницы.',
	'Tried to update [_1]([_2]), but the object was not found.' => 'Была произведена попытка обновления [_1]([_2]), но объект не существует.',
	'Your changes have been made (added [_1], edited [_2] and deleted [_3]). <a href="#" onclick="[_4]" class="mt-rebuild">Publish your site</a> to see these changes take effect.' => 'Ваши изменения произведены (добавлены [_1], отредактированы [_2] и удалены [_3]). <a href="#" onclick="[_4]" class="mt-rebuild">Опубликуйте сайт</a>, чтобы увидеть изменения на сайте.',
	'Add a [_1]' => 'Добавить [_1]',
	'No label' => 'Нет имени',
	'Category name cannot be blank.' => 'Имя категории не может быть пустым.',
	'Permission denied: [_1]' => 'В доступе отказано: [_1]',
	'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => 'Имя категории «[_1]» конфликтует с другой категорией. У основных категорий и подкатегорий с одной родительской категорией должны быть уникальные имена.',
	'The category basename \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => 'Базовое имя категории «[_1]» конфликтует с другой категорией. У основных категорий и подкатегорий с одной родительской категорией должны быть уникальные базовые имена.',
	'Category \'[_1]\' created by \'[_2]\'' => 'Категория «[_1]» создана пользователем «[_2]»',
	'The name \'[_1]\' is too long!' => 'Имя «[_1]» слишком длинное.',
	'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Категория «[_1]» (ID:[_2]) удалена пользователем «[_3]»',

## lib/MT/CMS/Comment.pm
	'Edit Comment' => 'Редактирование комментария',
	'(untitled)' => '(безымянный)',
	'No such commenter [_1].' => 'Нет такого комментатора [_1].',
	'User \'[_1]\' trusted commenter \'[_2]\'.' => 'Пользователь «[_1]» предоставил комментатору «[_2]» статус доверенного комментатора.',
	'User \'[_1]\' banned commenter \'[_2]\'.' => 'Пользователь «[_1]» заблокировал комментатора «[_2]».',
	'User \'[_1]\' unbanned commenter \'[_2]\'.' => 'Пользователь «[_1]»  разблокировал комментатора «[_2]».',
	'User \'[_1]\' untrusted commenter \'[_2]\'.' => 'Пользователь «[_1]» снял статус доверенного комментатора у «[_2]».',
	'Parent comment id was not specified.' => 'id родительского комментария не определён.',
	'Parent comment was not found.' => 'Не найден родительский комментарий.',
	'You can\'t reply to unapproved comment.' => 'Вы не можете ответить на неутверждённый комментарий.',
	'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Комментарий (ID:[_1]), оставленный читателем «[_2]» удалён пользователем «[_3]» из записи «[_4]»',
	'You don\'t have permission to approve this trackback.' => 'У вас нет прав для принятия этого трекбэка',
	'Comment on missing entry!' => 'Комментарий для несуществующей записи!',
	'You don\'t have permission to approve this comment.' => 'Вы не имеете достаточно полномочий для одобрения этого комментария.',
	'You can\'t reply to unpublished comment.' => 'Вы не можете ответить на неопубликованный комментарий.',
	'Orphaned comment' => 'Осиротевшие комментарии',

## lib/MT/CMS/Common.pm
	'The Template Name and Output File fields are required.' => 'Необходимо указать имя шаблона и имя публикуемого файла.',
	'Invalid type [_1]' => 'Недопустимый тип [_1]',
	'Invalid ID [_1]' => 'Неверный ID [_1]',
	'Save failed: [_1]' => 'Не удалось сохранить: [_1]',
	'Saving object failed: [_1]' => 'Не удалось сохранить объект: [_1]',
	'\'[_1]\' edited the template \'[_2]\' in the blog \'[_3]\'' => '«[_1]» отредактировал шаблон «[_2]» в блоге «[_3]»',
	'\'[_1]\' edited the global template \'[_2]\'' => '«[_1]» отредактировал глобальный шаблон «[_2]»',
	'Load failed: [_1]' => 'Ошибка загрузки: [_1]',
	'(no reason given)' => '(без указанной причины)',
	'New Filter' => 'Новый фильтр',
	'__SELECT_FILTER_VERB' => '—',
	'All [_1]' => 'Все [_1]',
	'[_1] Feed' => '[_1]', # Translate - No russian chars
	'Unknown list type' => 'Неизвестный тип списка',
	'Invalid filter terms: [_1]' => 'Неверные условия фильтра: [_1]',
	'An error occured while counting objects: [_1]' => 'Произошла ошибка при подсчёте объектов: [_1]',
	'An error occured while loading objects: [_1]' => 'Произошла ошибка при при загрузке объектов: [_1]',
	'Removing tag failed: [_1]' => 'Не удалось удалить тег: [_1]',
	'Loading MT::LDAP failed: [_1].' => 'Загрузка MT::LDAP не удалась: [_1]',
	'Removing [_1] failed: [_2]' => 'Не удалось удалить [_1]: [_2]',
	'System templates can not be deleted.' => 'Системные шаблоны не могут быть удалены.',
	'The selected [_1] has been deleted from the database.' => 'Выбранная [_1] удалена из базы данных.',
	'Can\'t load [_1] #[_1].' => 'Не удалось загрузить [_1] #[_1].',
	'Saving snapshot failed: [_1]' => 'Не удалось сохранить снимок: [_1]',

## lib/MT/CMS/Dashboard.pm
	'Error: This blog doesn\'t have a parent website.' => 'Ошибка: этот блог не имеет родительского сайта',

## lib/MT/CMS/Entry.pm
	'New Entry' => 'Новая запись',
	'New Page' => 'Новая страница',
	'pages' => 'страницы',
	'Tag' => 'Тег',
	'Entry Status' => 'Статус записи',
	'Can\'t load template.' => 'Не удалось загрузить шаблон.',
	'Publish error: [_1]' => 'Ошибка публикации: [_1]',
	'Unable to create preview file in this location: [_1]' => 'Не удалось создать файл для предварительного просмотра в этом месте: [_1]',
	'New [_1]' => 'Новый [_1]',
	'No such [_1].' => 'Нет таких [_1].',
	'Same Basename has already been used. You should use an unique basename.' => 'Это базовое имя уже использовано. Необходимо использовать уникальные базовые имена.',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'У вашего блога не настроены URL и путь публикации. Без этой информации публикация невозможна.',
	'Invalid date \'[_1]\'; published on dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Неправильная дата \'[_1]\'; формат даты должен быть следующий: ГГГГ-ММ-ДД ЧЧ:ММ:СС.',
	'Invalid date \'[_1]\'; published on dates should be real dates.' => 'Неверная дата \'[_1]\'; публикуемая дата должна быть реальной.',
	'[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_1] «[_2]» (ID:[_3]) добавлена пользователем «[_4]»',
	'[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_1] «[_2]» (ID:[_3]), отредактирована пользователем [_6], а также у неё изменён статус с [_4] на [_5].',
	'[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_1] «[_2]» (ID:[_3]) отредактирована пользователем «[_4]»',
	'Saving placement failed: [_1]' => 'Не удалось сохранить размещение: [_1]',
	'Invalid date \'[_1]\'; [_2] dates must be in the format YYYY-MM-DD HH:MM:SS.' => 'Неправильная дата \'[_1]\'; [_2] формат даты должен быть следующий: ГГГГ-ММ-ДД ЧЧ:ММ:СС.',
	'Invalid date \'[_1]\'; [_2] dates should be real dates.' => 'Неправильная дата \'[_1]\'; дата [_2] должна быть реальной.',
	'authored on' => 'создано',
	'modified on' => 'изменено',
	'Saving entry \'[_1]\' failed: [_2]' => 'Не удалось сохранить запись «[_1]»: [_2]',
	'Removing placement failed: [_1]' => 'Не удалось удалить размещение: [_1]',
	'Ping \'[_1]\' failed: [_2]' => 'Отправка пинга «[_1]» не удалась: [_2]',
	'(user deleted - ID:[_1])' => '(пользователь удалён — ID:[_1])',
	'<a href="[_1]">QuickPost to [_2]</a> - Drag this link to your browser\'s toolbar, then click it when you are visiting a site that you want to blog about.' => '<a href="[_1]">Пост в [_2]</a> — перетащите эту ссылку на персональную панель браузера; находясь на любой странице, нажмите на эту ссылку — некоторые поля редактора заполнятся автоматически.',
	'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Запись «[_1]» (ID:[_2]) удалена пользователем «[_3]»',
	'Need a status to update entries' => 'Необходим статус, чтобы обновить записи',
	'Need entries to update status' => 'Необходимы записи, чтобы обновить стутус',
	'One of the entries ([_1]) did not actually exist' => 'Одна из записей ([_1]) не существует',
	'[_1] \'[_2]\' (ID:[_3]) status changed from [_4] to [_5]' => '[_1] «[_2]» (ID:[_3]) изменён статус с [_4] на [_5]',

## lib/MT/CMS/Export.pm
	'Load of blog \'[_1]\' failed: [_2]' => 'Не удалось загрузить блог [_1]»: [_2]',
	'You do not have export permissions' => 'У вас недостаточно прав для экспорта',

## lib/MT/CMS/Filter.pm
	'Failed to save filter: label is required.' => 'Не удалось сохранить фильтр: необходимо имя.',
	'Failed to save filter: label "[_1]" is duplicated.' => 'Не удалось сохранить фильтр: имя "[_1]" уже используется.',
	'No such filter' => 'Нет фильтров',
	'Failed to save filter: [_1]' => 'Не удалось сохранить фильтр: [_1]',
	'Permission denied' => 'Доступ запрещён',
	'Failed to delete filter(s): [_1]' => 'Не удалось удалить фильтр(ы): [_1]',
	'Removed [_1] filters successfully.' => 'Удалено фильтров: [_1].',
	'[_1] ( created by [_2] )' => '[_1] (создано пользователем [_2] )',
	'(Legacy) ' => '(Наследие)', # проверить

## lib/MT/CMS/Folder.pm
	'The folder \'[_1]\' conflicts with another folder. Folders with the same parent must have unique basenames.' => 'Папка «[_1]» конфликтует с другой папкой. У папок с одной и той же родительской папкой должны быть уникальные базовые имена.',
	'Folder \'[_1]\' created by \'[_2]\'' => 'Папка «[_1]» создана пользователем «[_2]»',
	'Folder \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Папка «[_1]» (ID:[_2]) удалена пользователем «[_3]»',

## lib/MT/CMS/Import.pm
	'Import/Export' => 'Импорт/Экспорт',
	'You do not have import permission' => 'У вас нет прав для импорта',
	'You do not have permission to create users' => 'У вас недостаточно прав для создания пользователей',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'Вам необходимо указать пароли для каждого пользователя, если вы собираетесь их создать.',
	'Importer type [_1] was not found.' => 'Импортёр типа [_1] не найден.',

## lib/MT/CMS/Log.pm
	'All Feedback' => 'Все отзывы читателей',
	'Publishing' => 'Публикация',
	'System Activity Feed' => 'Активность в системе',
	'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => 'Журнал активности для блога «[_1]» (ID:[_2]) очищен пользователем «[_3]»',
	'Activity log reset by \'[_1]\'' => 'Журнал активности очищен пользователем «[_1]»',

## lib/MT/CMS/Plugin.pm
	'Plugin Set: [_1]' => 'Комплект плагинов: [_1]',
	'Individual Plugins' => 'Индивидуальные плагины',

## lib/MT/CMS/Search.pm
	'No [_1] were found that match the given criteria.' => 'Нет [_1], удовлетворяющих вашим критериям.',
	'Entry Body' => 'Основной текст записи',
	'Extended Entry' => 'Продолжение',
	'Keywords' => 'Ключевые слова',
	'Comment Text' => 'Текст комментария',
	'IP Address' => 'IP адрес',
	'Source URL' => 'URL источника',
	'Page Body' => 'Содержание страницы',
	'Extended Page' => 'Продолжение',
	'Template Name' => 'Имя шаблона',
	'Text' => 'Текст',
	'Linked Filename' => 'Имя связанного файла',
	'Output Filename' => 'Имя публикуемого файла',
	'Log Message' => 'Журнал сообщений',
	'Site URL' => 'URL сайта',
	'Search & Replace' => 'Поиск и замена',
	'Invalid date(s) specified for date range.' => 'Неправильная дата для промежутка дат.',
	'Error in search expression: [_1]' => 'Ошибка при поиске слова: [_1]',
	'Saving object failed: [_2]' => 'Не удалось сохранить объект: [_2]',

## lib/MT/CMS/Tag.pm
	'New name of the tag must be specified.' => 'Должно быть определено новое имя тега.',
	'No such tag' => 'Нет такого тега',
	'Tag name was successfully renamed' => 'Тег переименован',
	'Error saving entry: [_1]' => 'Ошибка при сохранении записи: [_1]',
	'Added [_1] tags for [_2] entries successfully!' => 'Теги для записей добавлены!',
	'Error saving file: [_1]' => 'Ошибка сохранения файла: [_1]',
	'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Тег «[_1]» (ID:[_2]) удалён пользователм «[_3]»',

## lib/MT/CMS/Template.pm
	'index' => 'индексный',
	'archive' => 'архивный',
	'module' => 'модульный',
	'widget' => 'виджет',
	'email' => 'email', # Translate - Not translated
	'backup' => 'Бэкап',
	'system' => 'система',
	'One or more errors were found in this template.' => 'В шаблоне найдена одна или несколько ошибок.',
	'Unknown blog' => 'Неизвестный блог',
	'One or more errors were found in included template module ([_1]).' => 'Одна или несколько ошибок при включении модуля шаблона ([_1]).',
	'Global Template' => 'Глобальный шаблон',
	'Invalid Blog' => 'Недопустимый блог',
	'Global' => 'Глобальный',
	'Create template requires type' => 'Для создания шаблонов требуется тип',
	'Archive' => 'Архив',
	'Entry or Page' => 'Запись или Страница',
	'New Template' => 'Новый шаблон',
	'Index Templates' => 'Индексные шаблоны',
	'Archive Templates' => 'Шаблоны архивов',
	'Template Modules' => 'Модули шаблонов',
	'System Templates' => 'Системные шаблоны',
	'Email Templates' => 'Почтовые шаблоны',
	'Template Backups' => 'Резервные копии шаблонов',
	'Can\'t locate host template to preview module/widget.' => 'Не удалось найти хост, чтобы посмотреть модуль/виджет.',
	'Cannot preview without a template map!' => 'Предпросмотр невозможен без указания пути архива!',
	'Lorem ipsum' => 'Lorem ipsum', # Translate - Not translated
	'LOREM_IPSUM_TEXT' => 'LOREM_IPSUM_TEXT', # Translate - Not translated
	'LORE_IPSUM_TEXT_MORE' => 'LORE_IPSUM_TEXT_MORE', # Translate - Not translated
	'sample, entry, preview' => 'образец, запись, предпросмотр',
	'Populating blog with default templates failed: [_1]' => 'Не удалось создать блог со стандартными шаблонами: [_1]',
	'Setting up mappings failed: [_1]' => 'Не удалось настроить карту: [_1]',
	'Saving map failed: [_1]' => 'Не удалось сохранить карту: [_1]',
	'You should not be able to enter 0 as the time.' => 'Вы не можете указать 0 в качестве времени.',
	'You must select at least one event checkbox.' => 'Необходимо отметить хотя бы один пункт.',
	'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Шаблон «[_1]» (ID:[_2]) создан пользователем «[_3]»',
	'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Шаблон «[_1]» (ID:[_2]) удалён пользователем «[_3]»',
	'No Name' => 'Без имени',
	'Orphaned' => 'Осиротевшие',
	'Global Templates' => 'Глобальные шаблоны',
	' (Backup from [_1])' => ' (Резервная копия от [_1])',
	'Error creating new template: ' => 'Ошибка при создании нового шаблона: ',
	'Template Referesh' => 'Обновить шаблон',
	'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Пропуск шаблона «[_1]», так как, кажется, это созданный вами шаблон.',
	'Refreshing template <strong>[_3]</strong> with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>' => 'Обновлён шаблон <strong>[_3]</strong>, создана <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">резервная копия</a>.',
	'Skipping template \'[_1]\' since it has not been changed.' => 'Пропуск шаблона «[_1]», так как он не изменялся.',
	'Copy of [_1]' => 'Копирование [_1]',
	'Cannot publish a global template.' => 'Не удалось опубликовать глобальный шаблон.',
	'Widget Template' => 'Шаблон виджета',
	'Widget Templates' => 'Шаблоны виджетов',
	'template' => 'шаблон',
	'Restoring widget set [_1]... ' => 'Восстановление связки виджетов [_1]…',
	'Failed.' => 'Неуспешно.',

## lib/MT/CMS/Theme.pm
	'Theme not found' => 'Тема не найдена',
	'Failed to uninstall theme' => 'Не удалось удалить тему',
	'Failed to uninstall theme: [_1]' => 'Не удалось удалить тему: [_1]',
	'Theme from [_1]' => 'Тема от [_1]',
	'Install into themes directory' => 'Установить в директорию тем',
	'Download [_1] archive' => 'Скачать [_1] архив',
	'Failed to load theme export template for [_1]: [_2]' => 'Не удалось загрузить шаблон экспортируемой темы для [_1]: [_2]',
	'Failed to save theme export info: [_1]' => 'Ошибка при сохранении экспортируемой информации темы: [_1]',
	'Themes Directory [_1] is not writable.' => 'Директория тем [_1] не доступна для записи.',
	'Error occurred during exporting [_1]: [_2]' => 'Ошибка в процессе экспорта [_1]: [_2]',
	'Error occurred during finalizing [_1]: [_2]' => 'Ошибка в процессе финализирования [_1]: [_2]',
	'Error occurred while publishing theme: [_1]' => 'Ошибка при публикации темы: [_1]',

## lib/MT/CMS/Tools.pm
	'Password Recovery' => 'Восстановление пароля',
	'User not found' => 'Пользователя не существует',
	'Error sending mail ([_1]); please fix the problem, then try again to recover your password.' => 'Ошибка при отправке почты ([_1]); пожалуйста, устраните проблему и попробуйте восстановить пароль снова.',
	'Password reset token not found' => 'Ключ сброса пароля не существует',
	'Email address not found' => 'Нет такого адреса',
	'Your request to change your password has expired.' => 'У запроса на изменение пароля истёк срок действия.',
	'Invalid password reset request' => 'Неверный запрос изменения пароля',
	'Please confirm your new password' => 'Подтвердите новый пароль',
	'Passwords do not match' => 'Пароли не совпадают',
	'That action ([_1]) is apparently not implemented!' => 'Это действие ([_1]) не осуществлено!',
	'You don\'t have a system email address configured.  Please set this first, save it, then try the test email again.' => 'Вы не сконфигурировали email-адрес. Пожалуйста, укажите системный email, сохраните изменения и попробуйте отправить тестовое письмо ещё раз.',
	'Please enter a valid email address' => 'Пожалуйста, укажите правильный email',
	'Test email from Movable Type' => 'Тестовое письмо от Movable Type',
	'This is the test email sent by Movable Type.' => 'Это тестовое письмо, отправленное Movable Type.',
	'Mail was not properly sent' => 'Письмо не отправлено',
	'Test e-mail was successfully sent to [_1]' => 'Тестовое письмо успешно отправлено на адрес [_1]',
	'These setting(s) are overridden by a value in the MT configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.' => 'Этот параметр переопределён в конфигурационном файле: [_1]. Удалите это значение из конфигурационного файла, если хотите управлять этим параметром с этой страницы.',
	'Email address is [_1]' => 'Текущий email — [_1]',
	'Debug mode is [_1]' => 'Режим отладки — [_1]',
	'Performance logging is on' => 'Журналирование производительности включено',
	'Performance logging is off' => 'Журналирование производительности отключено',
	'Performance log path is [_1]' => 'Журнал производительности сохраняется в [_1]',
	'Performance log threshold is [_1]' => 'Журналирование ведётся для событий, продолжительностью от [_1] сек.',
	'System Settings Changes Took Place' => 'Изменены системные параметры',
	'Invalid password recovery attempt; can\'t recover password in this configuration' => 'Попытка восстановления пароля не удалась; невозможно восстановить пароль при текущей настройке',
	'Invalid author_id' => 'Неверный author_id',
	'Backup & Restore' => 'Бэкап и восстановление',
	'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.' => 'Для резервного копирования данных (бекапа) необходимо, чтобы временная директория была перезаписываемой. Проверьте параметры TempDir в конфигурационном файле.',
	'Temporary directory needs to be writable for restore to work correctly.  Please check TempDir configuration directive.' => 'Для восстановления данных необходимо, чтобы временная директория была перезаписываемой. Проверьте параметры TempDir в конфигурационном файле.',
	'No website could be found. You must create a website first.' => 'Сайтов не найдено. Сайт необходимо создать в первую очередь.',
	'[_1] is not a number.' => '[_1] — не число.',
	'Copying file [_1] to [_2] failed: [_3]' => 'Не удалось скопировать файл [_1] в [_2]: [_3]',
	'Specified file was not found.' => 'Указанный файл не найден.',
	'[_1] successfully downloaded backup file ([_2])' => '[_1] успешно загрузил файл бекапа ([_2])',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ', # Translate - Not translated
	'Some of the actual files for assets could not be restored.' => 'Некоторые из медиа объектов не были восстановлены.',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => 'Пожалуйста, используйте файлы с расширением xml, tar.gz, zip или manifest.',
	'Unknown file format' => 'Неизвестный формат файла',
	'Some objects were not restored because their parent objects were not restored.' => 'Некоторые объекты не были восстановлены, так как не были восстановлены их родительские объекты.',
	'Detailed information is in the <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>activity log</a>.' => 'Подробная информация содержится в <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>журнале активности</a>.',
	'[_1] has canceled the multiple files restore operation prematurely.' => '[_1] преждевременно отменил операцию мульти-восстановления файлов.',
	'Changing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Изменение пути публикации у блога «[_1]» (ID:[_2])…',
	'Removing Site Path for the blog \'[_1]\' (ID:[_2])...' => 'Удаление пути публикации у блога «[_1]» (ID:[_2])…',
	'Changing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Изменение пути публикации архива у блога «[_1]» (ID:[_2])…',
	'Removing Archive Path for the blog \'[_1]\' (ID:[_2])...' => 'Удаление пути публикации архива у блога «[_1]» (ID:[_2])…',
	'Changing file path for the asset \'[_1]\' (ID:[_2])...' => 'Изменение пути файла для медиа объекта «[_1]» (ID:[_2])…',
	'Please upload [_1] in this page.' => 'Пожалуйста, загрузите [_1] на этой странице.',
	'File was not uploaded.' => 'Файл не загружен.',
	'Restoring a file failed: ' => 'Не удалось восстановить файл: ',
	'Some of the files were not restored correctly.' => 'Некоторые из файлов восстановлены некорректно.',
	'Successfully restored objects to Movable Type system by user \'[_1]\'' => 'Объекты успешно восстановлены в Movable Type пользователем «[_1]»',
	'Can\'t recover password in this configuration' => 'Невозможно восстановить пароль при текущей настройке',
	'Invalid user name \'[_1]\' in password recovery attempt' => 'Имя пользователя «[_1]», указанное при восстановлении пароля, указано неверно',
	'User name or password hint is incorrect.' => 'Имя пользователя или слово/фраза для восстановления пароля указаны неверно.',
	'User has not set pasword hint; cannot recover password' => 'Пользователь не указал слово/фразу для восстановления пароль; пароль не может быть восстановлен',
	'Invalid attempt to recover password (used hint \'[_1]\')' => 'Неудачная попытка восстановления пароля (использована фраза «[_1]»)',
	'User \'[_1]\' (user #[_2]) does not have email address' => 'У пользователя «[_1]» (#[_2]) не указан адрес электронной почты',
	'A password reset link has been sent to [_3] for user  \'[_1]\' (user #[_2]).' => 'Ссылка для сброса пароля пользователя [_1] (#[_2]) была отправлена по адресу [_3].',
	'Some objects were not restored because their parent objects were not restored.  Detailed information is in the <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">activity log</a>.' => 'Некоторые объекты не были восстановлены, так как не были восстановлены их родительские объекты. Подробная информация содержится в <a href=\"javascript:void(0);\" onclick=\"closeDialog(\'[_1]\');\">журнале активности</a>.',
	'[_1] is not a directory.' => '[_1] — не директория.',
	'Error occured during restore process.' => 'В процессе восстановления произошла ошибка.',
	'Some of files could not be restored.' => 'Не удалось восстановить некоторые файлы.',
	'Manifest file \'[_1]\' is too large. Please use import direcotry for restore.' => 'Файл Manifest «[_1]» очень большой. Пожалуйста, используйте директорию для импорта при восстановлении.',
	'Blog(s) (ID:[_1]) was/were successfully backed up by user \'[_2]\'' => 'Бэкап блога(ов) (ID:[_1]) был успешно сделан пользователем «[_2]»',
	'Movable Type system was successfully backed up by user \'[_1]\'' => 'Полный бекап Movable Type был успешно сделан пользователем «[_1]»',
	'Some [_1] were not restored because their parent objects were not restored.' => 'Некоторые объекты (приблизительно [_1]) не были восстановлены, так как не были восстановлены их родительские объекты.',

## lib/MT/CMS/TrackBack.pm
	'(Unlabeled category)' => '(Категория без описания)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => 'Пинг (ID:[_1]) от «[_2]» удалён пользователем «[_3]» из категории «[_4]»',
	'(Untitled entry)' => '(Безымянная запись)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => 'Пинг (ID:[_1]) от «[_2]» удалён пользователем «[_3]» из записи «[_4]»',
	'No Excerpt' => 'Нет выдержки',
	'No Title' => 'Нет заголовка',
	'Orphaned TrackBack' => 'Осиротевшие трекбэки',
	'category' => 'категория',

## lib/MT/CMS/User.pm
	'Create User' => 'Создать пользователя',
	'Can\'t load role #[_1].' => 'Не удалось загрузить роль #[_1].',
	'Role name cannot be blank.' => 'Необходимо указать имя роли.',
	'Another role already exists by that name.' => 'Роль с таким именем уже существует.',
	'You cannot define a role without permissions.' => 'Невозможно сделать роль без прав.',
	'Invalid type' => 'Недопустимый тип',
	'Invalid ID given for personal blog theme.' => 'Указан неверный ID для персональной темы блога.',
	'Invalid ID given for personal blog clone location ID.' => 'Указан неверный ID для персонального размещения клона блога.',
	'If personal blog is set, the personal blog location are required.' => 'Если указан персональный блог, то обязательно нужно указать размещение этого блога.',
	'Select a entry author' => 'Выбрать автора записи',
	'Select a page author' => 'Выберите автора страницы',
	'Selected author' => 'Выбранный автор',
	'Type a username to filter the choices below.' => 'Напечатайте имя, чтобы отфильтровать представленные ниже.',
	'Select a System Administrator' => 'Выберите администратора системы',
	'Selected System Administrator' => 'Выбранный администратор системы',
	'System Administrator' => 'Администратор системы',
	'(newly created user)' => '(недавно созданный пользователь)',
	'Select Website' => 'Выберите сайт',
	'Website Name' => 'Имя сайта',
	'Websites Selected' => 'Выбранные сайты',
	'Select Blogs' => 'Выберите блоги',
	'Blogs Selected' => 'Выбранные блоги',
	'Select Users' => 'Выберите пользователя',
	'Users Selected' => 'Выбранные пользователи',
	'Select Roles' => 'Выберите роль',
	'Roles Selected' => 'Выбранные роли',
	'Grant Permissions' => 'Назначить права',
	'You cannot delete your own association.' => 'Вы не можете удалить собственную ассоциацию.',
	'You cannot delete your own user record.' => 'Вы не можете удалить себя.',
	'You have no permission to delete the user [_1].' => 'У вас недостаточно прав для удаления пользователя [_1].',
	'User requires username' => 'Необходимо указать имя пользователя',
	'User requires display name' => 'Необходимо указать отображаемое имя пользователя',
	'User requires password' => 'Необходимо указать пароль для пользователя',
	'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => 'Пользователь «[_1]» (ID:[_2]) создан пользователем «[_3]»',
	'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Пользователь «[_1]» (ID:[_2]) удалён пользователем \'[_3]\'',
	'represents a user who will be created afterwards' => 'представляет пользователя, который будет впоследствии создан',

## lib/MT/CMS/Website.pm
	'New Website' => 'Новый сайт',
	'Website \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => 'Сайт «[_1]» (ID:[_2]) удалён пользователем [_3]',
	'Selected Website' => 'Выбранный сайт',
	'Type a website name to filter the choices below.' => 'Введите имя сайта, чтобы отфильтровать представленые ниже.',
	'Can\'t load website #[_1].' => 'Не удалось загрузить сайт #[_1].',
	'Blog \'[_1]\' (ID:[_2]) moved from \'[_3]\' to \'[_4]\' by \'[_5]\'' => 'Блог «[_1]» (ID:[_2]) перемещён из «[_3]» в «[_4]» пользователем «[_5]»',

## lib/MT/Comment.pm
	'Comment' => 'Комментарий',
	'Search other comments from this anonymous commenter' => 'Искать другие комментарии от этого анонимного комментатора',
	'__ANONYMOUS_COMMENTER' => 'Аноним',
	'Search other comments from this deleted commenter' => 'Искать другие комментарии от этого удалённого комментатора',
	'(Deleted)' => '(Удалено)',
	'Edit this [_1] commenter.' => 'Редактировать этого [_1] комментатора.',
	'Comments on [_1]: [_2]' => 'Комментарий к [_1]: [_1]',
	'Approved' => 'Принят',
	'Unapproved' => 'Отклонен',
	'Not spam' => 'Не спам',
	'Reported as spam' => 'Спам',
	'All comments by [_1] \'[_2]\'' => 'Все комментарии от [_1] «[_2]»',
	'Commenter' => 'Комментатор',
	'Load of entry \'[_1]\' failed: [_2]' => 'Не удалось загрузить запись «[_1]»: [_2]',
	'Entry/Page' => 'Запись/Страница',
	'Comments on My Entries/Pages' => 'Комментарии к моим записям/страницам',
	'Commenter Status' => 'Статус комментатора',
	'Non-spam comments' => 'Комментарии без спама',
	'Non-spam comments on this website' => 'Не-спам комментарии этого сайта',
	'Pending comments' => 'Ожидающие комментарии',
	'Published comments' => 'Опубликованные комментарии',
	'Comments on my entries/pages' => 'Комментарии к моим записям/страницам',
	'Comments in the last 7 days' => 'Комментарии за последние 7 дней',
	'Spam comments' => 'Комментарии, помеченные как спам',

## lib/MT/Compat/v3.pm
	'uses: [_1], should use: [_2]' => 'использовано: [_1], а должно быть: [_2]',
	'uses [_1]' => 'использовано [_1]',
	'No executable code' => 'Нет кода для выполнения',
	'Publish-option name must not contain special characters' => 'В параметрах имени публикации не должны содержаться специальные символы.',

## lib/MT/Component.pm
	'Loading template \'[_1]\' failed: [_2]' => 'Не удалось загрузить шаблон «[_1]» по следующей причине: [_2]',

## lib/MT/ConfigMgr.pm
	'Alias for [_1] is looping in the configuration.' => 'Псевдоним для [_1] повторяется в конфигурационном файле.',
	'Error opening file \'[_1]\': [_2]' => 'Ошибка при открытии файла «[_1]»: [_2]',
	'Config directive [_1] without value at [_2] line [_3]' => 'Директива в конфигурации [_1] не содержит значения [_2] (строка [_3])',
	'No such config variable \'[_1]\'' => 'В конфигурации не найдено такой переменной «[_1]»',

## lib/MT/Config.pm
	'Configuration' => 'Конфигурация',

## lib/MT/Core.pm
	'This is usually \'localhost\'.' => 'Обычно это «localhost».',
	'The physical file path for your SQLite database. ' => 'Физический путь к файлам вашей SQLite базы данных. ',
	'[_1] in [_2]: [_3]' => '[_1] в [_2]: [_3]',
	'option is required' => 'параметр обязателен',
	'[_1] [_2] between [_3] and [_4]' => '[_1] [_2] между [_3] и [_4]',
	'[_1] [_2] since [_3]' => '[_1] [_2] начиная с [_3]',
	'[_1] [_2] or before [_3]' => '[_1] [_2] или раньше [_3]',
	'[_1] [_2] these [_3] days' => '[_1] [_2] этих [quant,_3,день,дня,дней]', # проверить
	'[_1] [_2] future' => '[_1] [_2] будущее', # проверить
	'[_1] [_2] past' => '[_1] [_2] прошлое', # проверить
	'<mt:var name="[_1]"> [_2] [_3] [_4]' => '<mt:var name="[_1]"> [_2] [_3] [_4]', # Translate - Not translated
	'Invalid parameter.' => 'Неверный параметр.',
	'[_1] [_3] [_2]' => '[_1] [_3] [_2]', # Translate - Not translated
	'No Label' => 'Нет имени',
	'*User deleted*' => '*Пользователь удалён*',
	'(system)' => '(система)',
	'*Website/Blog deleted*' => '*Сайт/блог удалён*',
	'My [_1]' => 'Мои [_1]',
	'[_1] of this Website' => '[_1] этого сайта',
	'IP Banlist is disabled by system configuration.' => 'Бан по IP отключен в системной конфигурации.',
	'Address Book is disabled by system configuration.' => 'Адресная книга отключена в системной конфигурации.',
	'Error creating performance logs directory, [_1]. Please either change the permissions to make it writable or specify an alternate using the PerformanceLoggingPath configuration directive: [_2]' => 'Не удалось создать директорию для журнала производительности ([_1]). Пожалуйста, сделайте директорию перезаписываемой, либо используйте альтернативный путь в конфигурациии PerformanceLoggingPath: [_2]',
	'Error creating performance logs: PerformanceLoggingPath setting must be a directory path, not a file: [_1]' => 'Ошибка при создании журнала производительности: параметр PerformanceLoggingPath должнен указывать на директорию, а не на файл: [_1]',
	'Error creating performance logs: PerformanceLoggingPath directory exists but is not writeable: [_1]' => 'Ошибка при создании журнала производительности: директория PerformanceLoggingPath существует, но она не перезаписываемая: [_1]',
	'MySQL Database (Recommended)' => 'База данных MySQL (рекомендуется)',
	'PostgreSQL Database' => 'База данных PostgreSQL',
	'SQLite Database' => 'База данных SQLite',
	'SQLite Database (v2)' => 'База данных SQLite (v2)',
	'Database Server' => 'Сервер базы данных',
	'Database Name' => 'Имя базы данных',
	'Password' => 'Пароль',
	'Database Path' => 'Путь к базе данных',
	'Database Port' => 'Порт сервера базы данных',
	'Database Socket' => 'Сокет базы данных',
	'ID' => 'ID', # Translate - Not translated
	'Date Created' => 'Дата создания',
	'Date Modified' => 'Дата изменения',
	'Author Name' => 'Имя автора',
	'Legacy Quick Filter' => 'Быстрый фильтр наследования', # проверить
	'My Items' => 'Мои записи',
	'Log' => 'Лог',
	'Activity Feed' => 'Активность',
	'Folder' => 'Директория',
	'Trackback' => 'Трекбэк',
	'Manage Commenters' => 'Управление комментаторами',
	'Member' => 'Пользователи',
	'Permission' => 'Права',
	'IP addresses' => 'IP адреса',
	'IP Banning Settings' => 'Параметры заблокированных IP',
	'Contact' => 'Контакт',
	'Manage Address Book' => 'Управлениe адресной книгой',
	'Filter' => 'Отфильтровать',
	'Convert Line Breaks' => 'Автоматический разрыв строк',
	'Rich Text' => 'Визуальный редактор',
	'Movable Type Default' => 'Movable Type по умолчанию',
	'weblogs.com' => 'weblogs.com', # Translate - Not translated
	'google.com' => 'google.com', # Translate - Not translated
	'Classic Blog' => 'Классический блог',
	'Publishes content.' => 'Публикация контента.',
	'Synchronizes content to other server(s).' => 'Синхронизация контента с другим сервером.',
	'Refreshes object summaries.' => 'Обновление объекта с суммарной информацией.',
	'Adds Summarize workers to queue.' => 'Добавление в очередь процессов по суммированию информации.',
	'zip' => 'zip', # Translate - Not translated
	'tar.gz' => 'tar.gz', # Translate - Not translated
	'Entries List' => 'Список записей',
	'Blog URL' => 'URL блога',
	'Blog ID' => 'ID блога',
	'Entry Excerpt' => 'Выдержка записи',
	'Entry Link' => 'Ссылка записи',
	'Entry Extended Text' => 'Дополнительный текст записи',
	'Entry Title' => 'Заголовок записи',
	'If Block' => 'Блок If',
	'If/Else Block' => 'Блок If/Else',
	'Include Template Module' => 'Подключить модуль',
	'Include Template File' => 'Подключить файл',
	'Get Variable' => 'Получить переменную',
	'Set Variable' => 'Установить переменную',
	'Set Variable Block' => 'Установить блок переменной',
	'Widget Set' => 'Связка виджетов',
	'Publish Scheduled Entries' => 'Публикация запланированных записей',
	'Add Summary Watcher to queue' => 'Добавление в очередь Summary Watcher',
	'Junk Folder Expiration' => 'Срок хранения спама',
	'Remove Temporary Files' => 'Удалить временные файлы',
	'Purge Stale Session Records' => 'Очистить просроченные сессии',
	'Manage Website' => 'Управление сайтом',
	'Manage Blog' => 'Управление блогом',
	'Manage Website with Blogs' => 'Управление сайтом с блогами',
	'Post Comments' => 'Отправить комментарий',
	'Create Entries' => 'Создание записей',
	'Edit All Entries' => 'Редактировать все записи',
	'Manage Assets' => 'Управление медиа объектами',
	'Manage Categories' => 'Управление категориями',
	'Change Settings' => 'Изменить параметры',
	'Manage Tags' => 'Управление тегами',
	'Manage Templates' => 'Управление шаблонами',
	'Manage Feedback' => 'Управление обратной связью',
	'Manage Pages' => 'Управление страницами',
	'Manage Users' => 'Управление пользователями',
	'Manage Themes' => 'Управление темами',
	'Publish Entries' => 'Публикация записей',
	'Save Image Defaults' => 'Сохранить параметры по умолчанию для картинок',
	'Send Notifications' => 'Отправка уведомлений',
	'Set Publishing Paths' => 'Указать путь публикации',
	'View Activity Log' => 'Просмотр журнала действий',
	'Create Blogs' => 'Создать блог',
	'Create Websites' => 'Создать сайты',
	'Manage Plugins' => 'Управление плагинами',
	'View System Activity Log' => 'Просмотр системного журнала действий',

## lib/MT/DefaultTemplates.pm
	'Archive Index' => 'Список архивов',
	'Stylesheet' => 'Таблица стилей',
	'JavaScript' => 'JavaScript', # Translate - Not translated
	'Feed - Recent Entries' => 'Лента последних записей (Atom)',
	'RSD' => 'RSD', # Translate - Not translated
	'Monthly Entry Listing' => 'Ежемесячный список записей',
	'Category Entry Listing' => 'Список записей категории',
	'Comment Listing' => 'Список комментариев',
	'Improved listing of comments.' => 'Улучшенное отображение комментариев',
	'Comment Response' => 'Уведомление о добавленном комментарии',
	'Displays error, pending or confirmation message for comments.' => 'Сообщение об ошибке, помещение на модерацию или подтвеждающее сообщение для комментариев.',
	'Comment Preview' => 'Предпросмотр комментария',
	'Displays preview of comment.' => 'Предпросмотр для комментария.',
	'Dynamic Error' => 'Ошибка на динамических страницах',
	'Displays errors for dynamically published templates.' => 'Отображение ошибок на динамических страницах.',
	'Popup Image' => 'Изображение во всплывающем окне',
	'Displays image when user clicks a popup-linked image.' => 'Отображение изображения, когда посетитель нажмёт на соответствующую ссылку.',
	'Displays results of a search.' => 'Отображение результатов поиска.',
	'About This Page' => 'Об этой странице',
	'Archive Widgets Group' => 'Архивные связки виджетов',
	'Current Author Monthly Archives' => 'Текущий архив автора по месяцам',
	'Calendar' => 'Календарь',
	'Creative Commons' => 'Creative Commons', # Translate - Not translated
	'Home Page Widgets Group' => 'Связка виджетов домашней страницы',
	'Monthly Archives Dropdown' => 'Архивы по месяцам - выпадающий список',
	'Page Listing' => 'Список страниц',
	'Powered By' => 'Работает на',
	'Syndication' => 'Синдикация',
	'Technorati Search' => 'Поиск Technorati',
	'Date-Based Author Archives' => 'Архив авторов по датам',
	'Date-Based Category Archives' => 'Архив категория по датам',
	'OpenID Accepted' => 'OpenID принимается',
	'Comment throttle' => 'Задержка комментария',
	'Commenter Confirm' => 'Подтверждение регистрации комментатора',
	'Commenter Notify' => 'Уведомление о новом комментаторе',
	'New Comment' => 'Новый комментарий',
	'New Ping' => 'Новый пинг',
	'Entry Notify' => 'Уведомление о записи',
	'Subscribe Verify' => 'Подтверждение подписки',

## lib/MT/Entry.pm
	'[_1] ( id:[_2] ) does not exists.' => '[_1] ( id:[_2] ) не существует.',
	'Entries from category: [_1]' => 'Записи из категории: [_1]',
	'NONE' => 'никто',
	'Draft' => 'Черновик',
	'Published' => 'Опубликовано',
	'Reviewing' => 'Рассматривается',
	'Scheduled' => 'Запланировано',
	'Junk' => 'Спам',
	'Entries by [_1]' => 'Записи от [_1]',
	'record does not exist.' => 'объект не существует.',
	'Review' => 'Обзор',
	'Future' => 'Запланировано',
	'Spam' => 'Спам',
	'Accept Comments' => 'Принимать комментарии',
	'Body' => 'Текст',
	'Extended' => 'Продолжение',
	'Format' => 'Формат',
	'Accept Trackbacks' => 'Принимать трекбэки',
	'Publish Date' => 'Дата публикации',
	'Link' => 'Ссылка',
	'Primary Category' => 'Основная категория',
	'-' => '-', # Translate - Not translated
	'__PING_COUNT' => 'Количество трекбэков',
	'Date Commented' => 'Дата комментирования',
	'Author ID' => 'ID автора',
	'My Entries' => 'Мои записи',
	'Published Entries' => 'Опубликованные записи',
	'Unpublished Entries' => 'Неопубликованные записи',
	'Scheduled Entries' => 'Запланированные записи',
	'Entries Commented on in the Last 7 Days' => 'Записи, прокомментированные за последние 7 дней',

## lib/MT/FileMgr/DAV.pm
	'DAV connection failed: [_1]' => 'Не удалось установить DAV соединение: [_1]',
	'DAV open failed: [_1]' => 'Не удалось открыть по DAV: [_1]',
	'DAV get failed: [_1]' => 'Не удалось получить по DAV: [_1]',
	'DAV put failed: [_1]' => 'Не удалось отправить по DAV: [_1]',
	'Deleting \'[_1]\' failed: [_2]' => 'Не удалось удалить «[_1]», потому что: [_2]',
	'Creating path \'[_1]\' failed: [_2]' => 'Не удалось создать путь «[_1]»: [_2]',
	'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => 'Не удалось переименовать «[_1]» в «[_2]», потому что: [_3]',

## lib/MT/FileMgr/SFTP.pm
	'SFTP connection failed: [_1]' => 'Не удалось установить соединение SFTP: [_1]',
	'SFTP get failed: [_1]' => 'Не удалось получить по SFTP: [_1]',
	'SFTP put failed: [_1]' => 'Не удалось отправить по SFTP: [_1]',

## lib/MT/Filter.pm
	'Filters' => 'Фильтры',
	'Invalid filter type [_1]:[_2]' => 'Неверный тип фильтра  [_1]:[_2]',
	'Invalid sort key [_1]:[_2]' => 'Неверный ключ сортировки  [_1]:[_2]',
	'"editable_terms" and "editable_filters" cannot be specified at the same time.' => '«editable_terms» и «editable_filters» не могут быть использованы в одно и тоже время.',
	'System Object' => 'Системные объекты',

## lib/MT/Image/GD.pm
	'Can\'t load GD: [_1]' => 'Не удалось загрузить GD: [_1]',
	'Unsupported image file type: [_1]' => 'Неподдерживаемый тип изображения: [_1]',
	'Reading file \'[_1]\' failed: [_2]' => 'Ошибка при чтении файла «[_1]»: [_2]',
	'Reading image failed: [_1]' => 'Ошибка при чтении изображения: [_1]',

## lib/MT/Image/ImageMagick.pm
	'Can\'t load Image::Magick: [_1]' => 'Не удалось загрузить Image::Magick : [_1]',
	'Scaling to [_1]x[_2] failed: [_3]' => 'Мастштабирование к [_1]x[_2] не удалось: [_3]',
	'Cropping a [_1]x[_1] square at [_2],[_3] failed: [_4]' => 'Обрезка [_2],[_3] до размеров [_1]x[_1] не удалась: [_4]',
	'Converting image to [_1] failed: [_2]' => 'Конвертация изображения в [_1] не удалась: [_2]',

## lib/MT/Image/Imager.pm
	'Can\'t load Imager: [_1]' => 'Не удалось загрузить Imager:  [_1]',

## lib/MT/Image/NetPBM.pm
	'Can\'t load IPC::Run: [_1]' => 'Не удалось загрузить IPC::Run : [_1]',
	'Cropping to [_1]x[_1] failed: [_2]' => 'Обрезка до [_1]x[_1] не удалась: [_2]',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'Путь к местоположению NetPBM на сервере указан неверно.',

## lib/MT/Image.pm
	'Invalid Image Driver [_1]' => 'Неверный драйвер обработки изображений  [_1]',
	'Saving [_1] failed: Invalid image file format.' => 'Не удалось сохранить [_1]: неверный формат изображения.',
	'File size exceeds maximum allowed: [_1] > [_2]' => 'Размер файла превышает максимально допустимый: [_1] > [_2]',

## lib/MT/ImportExport.pm
	'No Blog' => 'Нет блога',
	'Need either ImportAs or ParentAuthor' => 'Необходим или ImportAs или ParentAuthor',
	'Creating new user (\'[_1]\')...' => 'Создание нового пользователя («[_1]»)…',
	'Saving user failed: [_1]' => 'Не удалось сохранить пользователя: [_1]',
	'Creating new category (\'[_1]\')...' => 'Создание новой категории («[_1]»)…',
	'Saving category failed: [_1]' => 'Не удалось сохранить категорию: [_1]',
	'Invalid status value \'[_1]\'' => 'Статус указан неверно «[_1]»',
	'Invalid allow pings value \'[_1]\'' => 'Неверно указаны разрешения для пингов [_1]',
	'Can\'t find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.' => 'Не удалось найти запись с временем «[_1]»… пропускаем комментарии и переходим к следующей записи.',
	'Importing into existing entry [_1] (\'[_2]\')' => 'Импорт в существующую запись [_1] («[_2]»)',
	'Saving entry (\'[_1]\')...' => 'Сохранение записи (\'[_1]\')…',
	'ok (ID [_1])' => 'ok (ID [_1])', # Translate - Not translated
	'Saving entry failed: [_1]' => 'Не удалось сохранить запись: [_1]',
	'Creating new comment (from \'[_1]\')...' => 'Создание нового комментария (от \'[_1]\')…',
	'Saving comment failed: [_1]' => 'Не удалось сохранить комментарий: [_1]',
	'Creating new ping (\'[_1]\')...' => 'Создание нового пинга («[_1]»)…',
	'Saving ping failed: [_1]' => 'Не удалось сохранить пинг: [_1]',
	'Export failed on entry \'[_1]\': [_2]' => 'Экспорт записи «[_1]\» не удался: [_2]',
	'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => 'Неверно указан формат времени «[_1]»; должно быть так: «MM/DD/YYYY HH:MM:SS AM|PM» (AM|PM по желанию)',

## lib/MT/Import.pm
	'Can\'t rewind' => 'Невозможно вернуть',
	'Can\'t open \'[_1]\': [_2]' => 'Не удалось открыть «[_1]» : [_2]',
	'No readable files could be found in your import directory [_1].' => 'В директории [_1] не найдено читаемых файлов для импорта.',
	'Importing entries from file \'[_1]\'' => 'Импорт записей из файла «[_1]»',
	'Couldn\'t resolve import format [_1]' => 'Не удалось определить формат импорта [_1]',
	'Movable Type' => 'Movable Type', # Translate - Not translated
	'Another system (Movable Type format)' => 'Другие системы (формат Movable Type)',

## lib/MT/IPBanList.pm
	'IP Ban' => 'Блокировка IP',
	'IP Bans' => 'Блокировка IP',

## lib/MT/JunkFilter.pm
	'Action: Junked (score below threshold)' => 'Действие: В корзину (счёт ниже допустимого)',
	'Action: Published (default action)' => 'Действие: Опубликовать (действие по умолчанию)',
	'Junk Filter [_1] died with: [_2]' => 'Фильтр корзины [_1] недействителен с: [_2]',
	'Unnamed Junk Filter' => 'Безымянный фильтр корзины',
	'Composite score: [_1]' => 'Суммарный подсчёт: [_1]',

## lib/MT/ListProperty.pm
	'Failed to init auto list property [_1].[_2]: Cannot find definition of column [_3].' => 'Ошибка при инициализации автоматического параметра списка [_1].[_2]: не удалось найти описание столбца [_3].', # проверить
	'Failed to init auto list property [_1].[_2]: unsupported column type.' => 'Ошибка при инициализации автоматического параметра списка [_1].[_2] не поддерживаемый тип колонки.',

## lib/MT/Log.pm
	'Log message' => 'Сообщение журнала',
	'Log messages' => 'Сообщения журнала',
	'none' => 'никто',
	'Security' => 'Безопасность',
	'Warning' => 'Предупреждение',
	'Information' => 'Информация',
	'Debug' => 'Отладка',
	'Security or error' => 'Безопасность или ошибка',
	'Security/error/warning' => 'Безопасность/ошибка/предупреждение',
	'Not debug' => 'Не отладка',
	'Debug/error' => 'Отладка/ошибка',
	'Showing only ID: [_1]' => 'Показаны только ID: [_1]',
	'Page # [_1] not found.' => 'Страница # [_1] не найдена.',
	'Entry # [_1] not found.' => 'Запись # [_1] не найдена.',
	'Comment # [_1] not found.' => 'Комментарий # [_1] не найден.',
	'TrackBack # [_1] not found.' => 'Трекбэк # [_1] не найден.',
	'blog' => 'блог',
	'website' => 'Сайт',
	'search' => 'Найти',
	'author' => 'Автор',
	'ping' => 'пинг',
	'theme' => 'Тема',
	'folder' => 'Директория',
	'plugin' => 'плагин',
	'Message' => 'Сообщение',
	'By' => 'от',
	'Class' => 'класс',
	'Level' => 'статус',
	'Metadata' => 'Метаданные',
	'Logs on This Website' => 'Лог на этом сайте',
	'Show only errors' => 'Показать только ошибки',

## lib/MT/Mail.pm
	'Unknown MailTransfer method \'[_1]\'' => 'Неизвестный метод отправки почты — «[_1]»',
	'Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]' => 'Отправка почты через SMTP требует установленного Mail::Sendmail: [_1]',
	'Error sending mail: [_1]' => 'Ошибка при отправке почты: [_1]',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'Путь к sendmail указан неверно. Может быть, попробовать воспользоваться SMTP?',
	'Exec of sendmail failed: [_1]' => 'При выполнении sendmail произошла ошибка: [_1]',

## lib/MT/Notification.pm
	'Contacts' => 'Контакты',
	'Click to edit contact' => 'Редактировать контакт',
	'Save Changes' => 'Сохранить изменения',
	'Save' => 'Сохранить',

## lib/MT/ObjectAsset.pm
	'Asset Placement' => 'Расположение медиа объектов',

## lib/MT/ObjectScore.pm
	'Object Score' => 'Счёт объекта',
	'Object Scores' => 'Счёт объектов',

## lib/MT/ObjectTag.pm
	'Tag Placement' => 'Управление тегами',
	'Tag Placements' => 'Управление тегами',

## lib/MT/Page.pm
	'Pages in folder: [_1]' => 'Страницы в папке:  [_1]',
	'Load of blog failed: [_1]' => 'Не удалось загрузить блог: [_1]',
	'(root)' => '(корень)',
	'My Pages' => 'Мои страницы',
	'Pages in This Website' => 'Страницы на этом сайте',
	'Published Pages' => 'Опубликованные страницы',
	'Unpublished Pages' => 'Неопубликованные страницы',
	'Scheduled Pages' => 'Запланированные страницы',
	'Pages with comments in the last 7 days' => 'Страницы, прокомментированные за последние 7 дней',

## lib/MT/Placement.pm
	'Category Placement' => 'Управление категориями',

## lib/MT/PluginData.pm
	'Plugin Data' => 'Данные о плагине',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: [_2][_3] согласно правилу [_4][_5]',
	'[_1]: [_2][_3] from test [_4]' => '[_1]: [_2][_3] согласно тесту [_4]',

## lib/MT/Plugin.pm
	'My Text Format' => 'Мой формат текста',

## lib/MT.pm
	'Powered by [_1]' => 'Работает на [_1]',
	'Version [_1]' => 'Версия [_1]',
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.com/movabletype/', # Translate - Not translated
	'Hello, world' => 'Привет мир',
	'Hello, [_1]' => 'Привет! Сегодня вы — [_1].',
	'Message: [_1]' => 'Сообщение: [_1]',
	'If present, 3rd argument to add_callback must be an object of type MT::Component or MT::Plugin' => 'Если есть, 3-й параметр для add_callback должен быть объектом типа MT::Component или MT:Plugin',
	'4th argument to add_callback must be a CODE reference.' => '4-й параметр для add_callback должен быть ссылкой CODE.',
	'Two plugins are in conflict' => 'Конфликт двух плагинов',
	'Invalid priority level [_1] at add_callback' => 'Неверный уровень приоритета [_1] в add_callback',
	'Internal callback' => 'Внутренний обратный вызов', # проверить
	'Unnamed plugin' => 'Безымянный плагин',
	'[_1] died with: [_2]' => '[_1] не работает с: [_2]',
	'Bad LocalLib config ([_1]): ' => 'Неверная конфигурация LocalLib ([_1]): ',
	'Bad ObjectDriver config' => 'Неверная конфигурация ObjectDriver',
	'Bad CGIPath config' => 'Неверная конфигурация CGIPath',
	'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => 'Файл конфигурации не найден. Возможно вы забыли переименовать mt-config.cgi-original в  mt-config.cgi?',
	'Plugin error: [_1] [_2]' => 'Ошибка плагина: [_1] [_2]',
	'Loading template \'[_1]\' failed.' => 'Не удалось загрузить шаблон «[_1]»',
	'Error during building email: [_1]' => 'Ошибка при составлении письма: [_1]',
	'http://www.movabletype.org/documentation/' => 'http://www.movabletype.org/documentation/', # Translate - Not translated
	'OpenID' => 'OpenID', # Translate - Not translated
	'LiveJournal' => 'LiveJournal', # Translate - Not translated
	'Vox' => 'Vox', # Translate - Not translated
	'Google' => 'Google', # Translate - Not translated
	'Yahoo!' => 'Yahoo!', # Translate - Not translated
	'AIM' => 'AIM', # Translate - Not translated
	'WordPress.com' => 'WordPress.com', # Translate - Not translated
	'TypePad' => 'TypePad', # Translate - Not translated
	'Yahoo! JAPAN' => 'Yahoo! JAPAN', # Translate - Not translated
	'livedoor' => 'livedoor', # Translate - Not translated
	'Hatena' => 'Hatena', # Translate - Not translated
	'Movable Type default' => 'Movable Type по умолчанию',

## lib/MT/Revisable.pm
	'Bad RevisioningDriver config \'[_1]\': [_2]' => 'Ошибочная настройка директивы RevisioningDriver «[_1]»: [_2]',
	'Revision not found: [_1]' => 'Нет такой ревизии',
	'There aren\'t the same types of objects, expecting two [_1]' => 'Не подходят типы объектов, необходимо 2 [_1]',
	'Did not get two [_1]' => 'Не предоставлены 2 [_1]',
	'Unknown method [_1]' => 'Неизвестный метод',
	'Revision Number' => 'Номер ревизии',

## lib/MT/Role.pm
	'__ROLE_ACTIVE' => 'Используется',
	'__ROLE_INACTIVE' => 'Не используется',
	'Website Administrator' => 'Администратор сайта',
	'Can administer the website.' => 'Может администрировать сайт',
	'Blog Administrator' => 'Администратор блога',
	'Can administer the blog.' => 'Может управлять блогом.',
	'Editor' => 'Редактор',
	'Can upload files, edit all entries(categories), pages(folders), tags and publish the site.' => 'Может загружать файлы, редактировать все записи и категории, страницы и папки, а также теги, может публиковать весь сайт.',
	'Can create entries, edit their own entries, upload files and publish.' => 'Может создавать записи, редактировать свои записи, загружать файлы и осуществлять публикацию.',
	'Designer' => 'Дизайнер',
	'Can edit, manage, and publish blog templates and themes.' => 'Может редактировать, управлять и публиковать шаблоны блога и темы.',
	'Webmaster' => 'Вебмастер',
	'Can manage pages, upload files and publish blog templates.' => 'Может редактировать страницы, загружать изображения и публиковать шаблоны блога.',
	'Contributor' => 'Участник',
	'Can create entries, edit their own entries, and comment.' => 'Может создавать записи, редактировать свои записи и комментировать.',
	'Moderator' => 'Модератор',
	'Can comment and manage feedback.' => 'Может комментировать и управлять отзывами.',
	'Can comment.' => 'Может комментировать.',
	'__ROLE_STATUS' => 'Статус',

## lib/MT/Scorable.pm
	'Object must be saved first.' => 'Сначала объект должен быть сохранён.',
	'Already scored for this object.' => 'Этот объект уже был отмечен',
	'Could not set score to the object \'[_1]\'(ID: [_2])' => 'Не удалось установить вес для объекта «[_1]» (ID: [_2])',

## lib/MT/Session.pm
	'Session' => 'Сессия',

## lib/MT/Tag.pm
	'Private' => 'Приватный',
	'Not Private' => 'Не приватный',
	'Tag must have a valid name' => 'Тег должен иметь допустимое имя',
	'This tag is referenced by others.' => 'На этот тег ссылаются другие.',
	'Tags with Entries' => 'Теги записей',
	'Tags with Pages' => 'Теги страниц',
	'Tags with Assets' => 'Теги медиа объектов',

## lib/MT/TaskMgr.pm
	'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'Не удаётся выполнить блокировку для выполнения системных задач. Разрешите запись в директории TempDir ([_1]).',
	'Error during task \'[_1]\': [_2]' => 'Ошибка при выполнении задачи «[_1]» : [_2]',
	'Scheduled Tasks Update' => 'Запланированное задание обновлено',
	'The following tasks were run:' => 'Выполнены следующие задания:',

## lib/MT/TBPing.pm
	'TrackBack' => 'Трекбэк',
	'<a href="[_1]">Ping from: [_2] - [_3]</a>' => '<a href="[_1]">Пинг от: [_2] — [_3]</a>',
	'Trackbacks on [_1]: [_2]' => 'Трекбэк на [_1]: [_2]', # проверить
	'Trackback Text' => 'Текст трекбэка',
	'Target' => 'К записи',
	'From' => 'От',
	'Source Site' => 'Сайт источника',
	'Source Title' => 'Заголовок',
	'Trackbacks on My Entries/Pages' => 'Трекбэки к моим записям/страницам',
	'Non-spam trackbacks' => 'Трекбэки без спама',
	'Non-spam trackbacks on this website' => 'Не-спам трекбэки этого сайта',
	'Pending trackbacks' => 'Ожидающие трекбэки',
	'Published trackbacks' => 'Опубликованные трекбэки',
	'Trackbacks on my entries/pages' => 'Трекбэки к моим записям/страницам',
	'Trackbacks in the last 7 days' => 'Трекбэки за последние 7 дней',
	'Spam trackbacks' => 'Спам-трекбэки',

## lib/MT/Template/ContextHandlers.pm
	'All About Me' => 'Всё обо мне',
	'Remove this widget' => 'Удалить этот виджет',
	'[_1]Publish[_2] your site to see these changes take effect.' => '[_1]Опубликуйте[_2] ваш сайт, чтобы увидеть изменения.',
	'Actions' => 'Действия',
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.org/documentation/appendices/tags/%t.html', # Translate - Not translated
	'You used an [_1] tag without a date context set up.' => 'Вы использовали тег [_1] вне контекста (дата).',
	'Division by zero.' => 'Деление на ноль',
	'[_1] is not a hash.' => '[_1] — это не хэш.',
	'No [_1] could be found.' => 'Не удалось найти [_1].',
	'records' => 'записи',
	'No template to include was specified' => 'Не был указан включаемый шаблон',
	'Recursion attempt on [_1]: [_2]' => 'Попытка рекурсии [_1]: [_2]',
	'Can\'t find included template [_1] \'[_2]\'' => 'Не удалось найти включённый шаблон [_1] «[_2]»',
	'Error in [_1] [_2]: [_3]' => 'Ошибка в Error [_1] [_2]: [_3]',
	'Writing to \'[_1]\' failed: [_2]' => 'Запись в «[_1]» не удалась: [_2]',
	'Can\'t find blog for id \'[_1]' => 'Не удалось найти блог с ID\'[_1]',
	'Can\'t find included file \'[_1]\'' => 'Не удалось найти включённый файл «[_1]»',
	'Error opening included file \'[_1]\': [_2]' => 'Ошибка при открытии включённого файла «[_1]» : [_2]',
	'Recursion attempt on file: [_1]' => 'Попытка рекурсии с файлом: [_1]',
	'Can\'t load user.' => 'Не удалось загрузить пользователя.',
	'Can\'t find template \'[_1]\'' => 'Не удалось найти шаблон «[_1]»',
	'Can\'t find entry \'[_1]\'' => 'Не удалось найти запись «[_1]»',
	'Unspecified archive template' => 'Неопределённый шаблон архива',
	'Error in file template: [_1]' => 'Ошибка в файле шаблона: [_1]',

## lib/MT/Template/Context.pm
	'The attribute exclude_blogs cannot take \'[_1]\' for a value.' => 'Атрибут exclude_blogs не может содержать значение «[_1]».',
	'When the same blog IDs are simultaneously listed in the include_blogs and exclude_blogs attributes, those blogs are excluded.' => 'Когда одинаковые ID указаны в атрибутах include_blogs и exclude_blogs, эти блоги будут исключены.',
	'You used an \'[_1]\' tag outside of the context of a author; perhaps you mistakenly placed it outside of an \'MTAuthors\' container?' => 'Вы использовали тег «[_1]» вне контекста авторов; возможно, вы поместили его вне контейнера «MTAuthors» ?',
	'You used an \'[_1]\' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an \'MTEntries\' container?' => 'Вы использовали тег «[_1]» вне контекста записей; возможно, вы поместили его вне контейнера «MTEntries»?',
	'You used an \'[_1]\' tag outside of the context of the website; perhaps you mistakenly placed it outside of an \'MTWebsites\' container?' => 'Вы использовали тег «[_1]» вне контекста сайта; возможно, вы поместили его вне контейнера «MTWebsites»?',
	'You used an \'[_1]\' tag outside of the context of the blog; perhaps you mistakenly placed it outside of an \'MTBlogs\' container?' => 'Вы использовали тег «[_1]» вне контекста блога; возможно, вы поместили его вне контейнера «MTBlogs»?',
	'You used an \'[_1]\' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an \'MTComments\' container?' => 'Вы использовали тег «[_1]» вне контекста комментариев; возможно, вы поместили его вне контейнера «MTComments» ?',
	'You used an \'[_1]\' tag outside of the context of a ping; perhaps you mistakenly placed it outside of an \'MTPings\' container?' => 'Вы использовали тег «[_1]» вне контекста пингов; возможно, вы поместили его вне контейнера «MTPings»?',
	'You used an \'[_1]\' tag outside of the context of an asset; perhaps you mistakenly placed it outside of an \'MTAssets\' container?' => 'Вы использовали тег «[_1]» вне контекста медиа-объектов; возможно, вы поместили его вне контейнера «MTAssets»?',
	'You used an \'[_1]\' tag outside of the context of a page; perhaps you mistakenly placed it outside of a \'MTPages\' container?' => 'Вы использовали тег «[_1]» вне контекста страницы; возможно, вы по ошибке поместили его вне контейнера MTPages?',

## lib/MT/TemplateMap.pm
	'Archive Mapping' => 'Путь публикации архивов',
	'Archive Mappings' => 'Пути публикации архивов',

## lib/MT/Template.pm
	'Template' => 'Шаблон',
	'File not found: [_1]' => 'Файл не найден: [_1]',
	'Error reading file \'[_1]\': [_2]' => 'Ошибка при чтении файла «[_1]»: [_2]',
	'Publish error in template \'[_1]\': [_2]' => 'Ошибка публикации в шаблоне «[_1]»: [_2]',
	'Template name must be unique within this [_1].' => 'Шаблон должен быть уникальным с [_1].', # проверить
	'You cannot use a [_1] extension for a linked file.' => 'Вы не можете использовать расширение [_1] для связанного файла.',
	'Opening linked file \'[_1]\' failed: [_2]' => 'Не удалось открыть связанный файл «[_1]»: [_2]',
	'Index' => 'Индексный',
	'Category Archive' => 'Архив категории',
	'Ping Listing' => 'Список пингов',
	'Comment Error' => 'Ошибка комментирования',
	'Comment Pending' => 'Комментарий на проверке',
	'Uploaded Image' => 'Загруженное изображение',
	'Module' => 'Модуль',
	'Widget' => 'Виджет',
	'Output File' => 'Имя файла',
	'Template Text' => 'Текст шаблона',
	'Rebuild with Indexes' => 'Опубликовать с индексными',
	'Dynamicity' => 'Динамически',
	'Build Type' => 'Тип публикации',
	'Interval' => 'Интервал',

## lib/MT/Template/Tags/Archive.pm
	'Group iterator failed.' => 'Не удалось сгруппировать итератор.',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1] может быть использован только в архивах по дням, неделям или месяцам.',
	'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => 'Вы использовали тег [_1] для связки с архивом «[_2]», который не публикуется.',
	'You used an [_1] tag outside of the proper context.' => 'Вы использовали тег [_1] вне контекста.',
	'Could not determine entry' => 'Невозможно определить запись',

## lib/MT/Template/Tags/Asset.pm
	'No such user \'[_1]\'' => 'Пользователь «[_1]» не существует',
	'You have an error in your \'[_2]\' attribute: [_1]' => 'Обнаружена ошибка атрибута «[_2]»: [_1]',

## lib/MT/Template/Tags/Author.pm
	'The \'[_2]\' attribute will only accept an integer: [_1]' => 'В атрибуте «[_2]» допустимо только целое значение: [_1]',
	'You used an [_1] without a author context set up.' => 'Вы использовали тег [_1] без контекста (автор).',

## lib/MT/Template/Tags/Calendar.pm
	'Invalid month format: must be YYYYMM' => 'Неправильный формат даты: должно быть ГГГГММ',
	'No such category \'[_1]\'' => 'Категория «[_1]» не найдена',

## lib/MT/Template/Tags/Category.pm
	'MT[_1] must be used in a [_2] context' => 'MT[_1] должен использоваться в контексте с [_2]',
	'Cannot find package [_1]: [_2]' => 'Не удалось найти пакет [_1]: [_2]',
	'Error sorting [_2]: [_1]' => 'Ошибка сортировки [_2]: [_1]',
	'Can\'t use sort_by and sort_method together in [_1]' => 'Не удалось использовать методы sort_by и sort_method совместно с [_1]',
	'[_1] cannot be used without publishing Category archive.' => '[_1] не может быть использована без публикации архива категории.',
	'[_1] used outside of [_2]' => '[_1] использован вне [_2]',

## lib/MT/Template/Tags/Comment.pm
	'The MTCommentFields tag is no longer available; please include the [_1] template module instead.' => 'Тег MTCommentFields больше не доступен; пожалуйста, используйте вместо этого модульный шаблон [_1].',
	'Comment Form' => 'Форма для комментариев',
	'To enable comment registration, you need to add a TypePad token in your weblog config or user profile.' => 'Для включения регистрации в комментариях необходимо добавить TypePad-токен для вашего блога или профиля пользователя.',

## lib/MT/Template/Tags/Entry.pm
	'You used <$MTEntryFlag$> without a flag.' => 'Вы использовали <$MTEntryFlag$> без флага.',
	'Could not create atom id for entry [_1]' => 'Не удалось создать Atom для записи [_1]',

## lib/MT/Template/Tags/Misc.pm
	'name is required.' => 'имя обязательно.',
	'Specified WidgetSet \'[_1]\' not found.' => 'Указанная связка виджетов не найдена.',

## lib/MT/Template/Tags/Ping.pm
	'<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$> должен использоваться в контексте категории или с атрибутом \'category\' в теге',

## lib/MT/Theme/Category.pm
	'[_1] top level and [_2] sub categories.' => '[quant,_1,основная,основные,основных] и [quant,_1,подкатегория,подкатегории,подкатегорий].',
	'[_1] top level and [_2] sub folders.' => '[_1] высшего уровня и [quant,_2,подпапка,подпапки,подпапок].',

## lib/MT/Theme/Element.pm
	'Component \'[_1]\' is not found.' => 'Компонент [_1] не найден.',
	'Internal error: the importer is not found.' => 'Внутренняя ошибка: импортёр не найден',
	'Compatibility error occured while applying \'[_1]\': [_2].' => 'Проблема совместимости при применении «[_1]»: [_2].',
	'An Error occured while applying \'[_1]\': [_2].' => 'Ошибка при применении «[_1]»: [_2].',
	'Fatal error occured while applying \'[_1]\': [_2].' => 'Фатальная ошибка при применении «[_1]»: [_2].',
	'Importer for \'[_1]\' is too old.' => 'Импортёр для «[_1]» устаревший.',
	'Theme element \'[_1]\' is too old for this environment.' => 'Элемент темы «[_1]» устаревший.',

## lib/MT/Theme/Entry.pm
	'[_1] pages' => '[quant,_1,страница,страницы,страниц]',

## lib/MT/Theme.pm
	'Failed to load theme [_1].' => 'Не удалось загрузить тему [_1].',
	'A fatal error occurred while applying element [_1]: [_2].' => 'Произошла фатальная ошибка при применении элемента [_1]: [_2].',
	'An error occurred while applying element [_1]: [_2].' => 'Ошибка при применении элемента [_1]: [_2].',
	'Failed to copy file [_1]:[_2]' => 'Не удалось скопировать файл [_1]:[_2]',
	'Component \'[_1]\' version [_2] or greater is needed to use this theme, but is not installed.' => 'Для использования этой темы необходим компонент «[_1]» версии [_2] и выше, но он не установлен.',
	'Component \'[_1]\' version [_2] or greater is needed to use this theme, but the installed version is [_3].' => 'Для использования этой темы необходим компонент «[_1]» версии [_2] и выше; у вас установлена версия [_3].',
	'Element \'[_1]\' cannot be applied because [_2]' => 'Элемент «[_1]» не может быть применён, потому что [_2]',
	'There was an error scaling image [_1].' => 'Произошла ошибка при масштабировании изображения [_1].',
	'There was an error converting image [_1].' => 'Произошла ошибка при конвертации изображения [_1].',
	'There was an error creating thumbnail file [_1].' => 'Произошла ошибка при генерации миниатюры файла [_1].',
	'Default Prefs' => 'Параметры по умолчанию',
	'Template Set' => 'Связка шаблонов',
	'Static Files' => 'Статические файлы',
	'Default Pages' => 'Страницы по умолчанию',

## lib/MT/Theme/Pref.pm
	'this element cannot apply for non blog object.' => 'этот элемент не может быть применён для не блогового объекта.',
	'Failed to save blog object: [_1]' => 'Не удалось сохранить объект блога: [_1]',
	'default settings for [_1]' => 'параметры по умолчанию для [_1]',
	'default settings' => 'параметры по умолчанию',

## lib/MT/Theme/TemplateSet.pm
	'A template set containing [_1] templates, [_2] widgets, and [_3] widget sets.' => 'Связка шаблонов содержит [quant,_1,шаблон,шаблона,шаблонов], [quant,_2,виджет,виджета,виджетов] и [quant,_3,связка виджетов,связки виджетов,связок виджетов]',
	'Widget Sets' => 'Связки виджетов',
	'Failed to make templates directory: [_1]' => 'Не удалось создать директорию шаблонов: [_1]',
	'Failed to publish template file: [_1]' => 'Не удалось опубликовать файл шаблона: [_1]',
	'exported_template set' => 'связка exported_template',

## lib/MT/TheSchwartz/Error.pm
	'Job Error' => 'Ошибка задачи',

## lib/MT/TheSchwartz/ExitStatus.pm
	'Job Exit Status' => 'Статус задачи выхода',

## lib/MT/TheSchwartz/FuncMap.pm
	'Job Function' => 'Функция задачи',

## lib/MT/TheSchwartz/Job.pm
	'Job' => 'Задача',

## lib/MT/Upgrade/Core.pm
	'Upgrading Asset path informations...' => 'Обновление информации о путях медиа-файлов…',
	'Creating initial website and user records...' => 'Создание первоначального сайта и пользовательских данных…',
	'Error saving record: [_1].' => 'Ошибка сохранения записи: [_1].',
	'Error creating role record: [_1].' => 'Ошибка при создании роли: [_1].',
	'First Website' => 'Первый сайт',
	'Creating new template: \'[_1]\'.' => 'Создание нового шаблона: «[_1]».',
	'Mapping templates to blog archive types...' => 'Установка соответствий шаблонов типам архива блога…',
	'Assigning custom dynamic template settings...' => 'Назначение собственных настроек для динамических шаблонов…',
	'Assigning user types...' => 'Назначение пользовательских типов…',
	'Assigning category parent fields...' => 'Назначение родительских полей категорий…',
	'Assigning template build dynamic settings...' => 'Назначение сборки шаблонов для динамической публикации…',
	'Assigning visible status for comments...' => 'Назначение статуса видимости для комментариев…',
	'Assigning visible status for TrackBacks...' => 'Назначение статуса видимости для трекбэков…',

## lib/MT/Upgrade.pm
	'Invalid upgrade function: [_1].' => 'Неверная функция обновления: [_1].',
	'Error loading class [_1].' => 'Ошибка при загрузке класса [_1].',
	'Upgrading table for [_1] records...' => 'Обновление таблицы типа «[_1]»…',
	'Upgrading database from version [_1].' => 'Обновление базы данных из версии [_1].',
	'Database has been upgraded to version [_1].' => 'База данных обновлена до версии [_1].',
	'User \'[_1]\' upgraded database to version [_2]' => 'Пользователь «[_1]» обновил базу данных до версии [_2]',
	'Plugin \'[_1]\' upgraded successfully to version [_2] (schema version [_3]).' => 'Плагин «[_1]» успешно обновлён до версии [_2] (schema version [_3]).',
	'User \'[_1]\' upgraded plugin \'[_2]\' to version [_3] (schema version [_4]).' => 'Пользователь «[_1]» обновил плагин «[_2]» до версии [_3] (schema version [_4]).',
	'Plugin \'[_1]\' installed successfully.' => 'Плагин «[_1]» успешно установлен.',
	'User \'[_1]\' installed plugin \'[_2]\', version [_3] (schema version [_4]).' => 'Пользователь «[_1]» установил плагин «[_2]», версия [_3] (schema version [_4]).',
	'Error loading class: [_1].' => 'Ошибка загрузки класса: [_1].',
	'Assigning entry comment and TrackBack counts...' => 'Назначение комментариев записи и счётчика трекбэков…',
	'Error saving [_1] record # [_3]: [_2]...' => 'Ошибка при сохранении объекта [_1] # [_3]: [_2]…',

## lib/MT/Upgrade/v1.pm
	'Creating template maps...' => 'Создание карт шаблонов…',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'Связывание шаблона ID [_1]с [_2] ([_3]).',
	'Mapping template ID [_1] to [_2].' => 'Связывание шаблона ID [_1] с [_2].',
	'Creating entry category placements...' => 'Создание размещений категории записи…',

## lib/MT/Upgrade/v2.pm
	'Updating category placements...' => 'Обновление размещений категории…',
	'Assigning comment/moderation settings...' => 'Установка настроек комментариев/модерации…',

## lib/MT/Upgrade/v3.pm
	'Custom ([_1])' => '([_1]) Выборочный',
	'This role was generated by Movable Type upon upgrade.' => 'Эта роль будет обновлена Movable Type.',
	'Removing Dynamic Site Bootstrapper index template...' => 'Удаление индексного шаблона Dynamic Site Bootstrapper',
	'Creating configuration record.' => 'Создание элемента конфигурации.',
	'Setting your permissions to administrator.' => 'Установка ваших прав администратора.',
	'Setting blog basename limits...' => 'Установка ограничений базового имени в блоге…',
	'Setting default blog file extension...' => 'Установка расширения файлов, используем при публикации блога…',
	'Updating comment status flags...' => 'Обновление статуса комментария…',
	'Updating commenter records...' => 'Обновление элементов комментатора…',
	'Assigning blog administration permissions...' => 'Добавление администраторских полномочий…',
	'Setting blog allow pings status...' => 'Настройка разрешений пингов в блоге…',
	'Updating blog comment email requirements...' => 'Обновление требований email для комментаторов…',
	'Assigning entry basenames for old entries...' => 'Назначение базового имени для прошлых записей…',
	'Updating user web services passwords...' => 'Обновление паролей для веб-сервисов пользователя…',
	'Updating blog old archive link status...' => 'Обновление статуса ссылок блога на предыдущие архивы…',
	'Updating entry week numbers...' => 'Обновление количества записей за неделю…',
	'Updating user permissions for editing tags...' => 'Обновление полномочий пользователя для редактирования тегов…',
	'Setting new entry defaults for blogs...' => 'Установка настроек по умолчанию для новых записей в блоге…',
	'Migrating any "tag" categories to new tags...' => 'Перемещение любых "tag" категорий в новые теги…',
	'Assigning basename for categories...' => 'Назначение базового имени для категорий…',
	'Assigning user status...' => 'Назначение статуса пользователей…',
	'Migrating permissions to roles...' => 'Миграция от разрешений к ролям…',

## lib/MT/Upgrade/v4.pm
	'Comment Posted' => 'Комментарий отправлен',
	'Your comment has been posted!' => 'Ваш комментарий получен!',
	'Your comment submission failed for the following reasons:' => 'Ваш комментарий не добавлен по следующим причинам:',
	'[_1]: [_2]' => '[_1]: [_2]', # Translate - Not translated
	'Migrating permission records to new structure...' => 'Миграция прав пользователей на новую структуру…',
	'Migrating role records to new structure...' => 'Миграция ролей на новую структуру…',
	'Migrating system level permissions to new structure...' => 'Перемещение прав системного уровня на новую структуру…',
	'Updating system search template records...' => 'Обновление элементов системного шаблона поиска…',
	'Renaming PHP plugin file names...' => 'Изменение имен файлов PHP плагина…',
	'Error renaming PHP files. Please check the Activity Log.' => 'Ошибка при переименовании PHP файлов. Пожалуйста, проверьте журнал активности.',
	'Cannot rename in [_1]: [_2].' => 'Не удалось переименовать [_1]: [_2].',
	'Migrating Nofollow plugin settings...' => 'Миграция настроек плагина Nofollow…',
	'Removing unnecessary indexes...' => 'Удаление ненужных индексов…',
	'Moving metadata storage for categories...' => 'Перемещение хранилища метаданных для категорий…',
	'Upgrading metadata storage for [_1]' => 'Обновление метаданных для категорий…',
	'Updating password recover email template...' => 'Обновление шаблона восстановления пароля…',
	'Assigning junk status for comments...' => 'Назначение статуса спамп для комментариев…',
	'Assigning junk status for TrackBacks...' => 'Назначение статуса спама для трекбэков…',
	'Populating authored and published dates for entries...' => 'Заполнение авторских и опубликованных дат для записей…',
	'Updating widget template records...' => 'Обновление элементов шаблонов виджетов…',
	'Classifying category records...' => 'Классификация элементов категорий…',
	'Classifying entry records...' => 'Классификация элементов записей…',
	'Merging comment system templates...' => 'Объединение системных шаблонов комментариев…',
	'Populating default file template for templatemaps...' => 'Заполнение файла шаблона для карты шаблонов…',
	'Removing unused template maps...' => 'Удаление неиспользуемых карт шаблона…',
	'Assigning user authentication type...' => 'Назначение типов идентификации пользователей',
	'Adding new feature widget to dashboard...' => 'Добавление новых виджетов на обзорную панель…',
	'Moving OpenID usernames to external_id fields...' => 'Перемещение имён пользователей OpenID в поля external_id…',
	'Assigning blog template set...' => 'Назначение связки шаблонов блога…',
	'Assigning blog page layout...' => 'Назначение макета страниц блога…',
	'Assigning author basename...' => 'Назначение базового имени для авторов…',
	'Assigning embedded flag to asset placements...' => 'Установка флага встроенности для медиа…',
	'Updating template build types...' => 'Обновление типов шаблонов…',
	'Replacing file formats to use CategoryLabel tag...' => 'Перезапись формата файлов для использования тега CategoryLabel…',

## lib/MT/Upgrade/v5.pm
	'Populating generic website for current blogs...' => 'Наполнение общего сайта для текущих блогов…',
	'Generic Website' => 'Общий сайт',
	'Migrating [_1]([_2]).' => 'Миграция [_1]([_2]).',
	'Granting new role to system administrator...' => 'Предоставление новой роли для системного администратора…',
	'Updating existing role name...' => 'Обновление текущих имён ролей…',
	'_WEBMASTER_MT4' => 'Веб-мастер',
	'Webmaster (MT4)' => 'Веб-мастер (MT4)',
	'Populating new role for website...' => 'Заполнение новой роли для сайта…',
	'Can manage pages, Upload files and publish blog templates.' => 'Может управлять страницами, загружать файлы и публиковать шаблоны блога.',
	'Designer (MT4)' => 'Дизайнер (MT4)',
	'Populating new role for theme...' => 'Заполнение новой роли для темы…',
	'Can edit, manage and publish blog templates and themes.' => 'Может редактировать, управлять и публиковать шаблоны блога и темы.',
	'Assigning new system privilege for system administrator...' => 'Назначение новой системы привелегий для системного администратора…',
	'Assigning to  [_1]...' => 'Назначено для [_1]…',
	'Migrating mtview.php to MT5 style...' => 'Миграция mtview.php в формат MT5…',
	'Migrating DefaultSiteURL/DefaultSiteRoot to website...' => 'Миграция DefaultSiteURL/DefaultSiteRoot в формат сайтов…',
	'New user\'s website' => 'Новый пользовательский сайт',
	'Migrating existing [quant,_1,blog,blogs] into websites and its children...' => 'Миграция [quant,_1,существующего блога,существующих блогов,существующих блогов] в сайты и их родителей…',
	'Error loading role: [_1].' => 'Не удалось загрузить роль: [_1].',
	'New WebSite [_1]' => 'Новый сайт [_1]',
	'An error occured during generating a website upon upgrade: [_1]' => 'При обновлении, в процессе генерации сайта произошла ошибка: [_1]',
	'Generated a website [_1]' => 'Сгенерирован сайт [_1]',
	'An error occured during migrating a blog\'s site_url: [_1]' => 'Ошибка при миграции site_url блога: [_1]',
	'Moved blog [_1] ([_2]) under website [_3]' => 'Блог [_1] ([_2]) перемещён в сайт [_3]',
	'Removing technorati update-ping service from [_1] (ID:[_2]).' => 'Удаление сервиса уведомлений technorati из [_] (ID: [_2]).',
	'Expiring cached MT News widget...' => 'Время кеширования виджета с новостями MT…',
	'Recovering type of author...' => 'Восстановление типа автора…',
	'Merging dashboard settings...' => 'Слияние параметров обзорной панели…',
	'Classifying blogs...' => 'Классификация блогов…',
	'Rebuilding permissions...' => 'Перестройка разрешений…',
	'Assigning ID of author for entries...' => 'Назначение ID автора для записей…',
	'Removing widget from dashboard...' => 'Удаление виджета с обзорной панели...',
	'Ordering Categories and Folders of Blogs...' => 'Сортировка категорий и папок в блогах...',
	'Ordering Folders of Websites...' => 'Сортировка папок в сайте...',

## lib/MT/Util/Archive.pm
	'Type must be specified' => 'Необходимо указать тип',
	'Registry could not be loaded' => 'Не удалось загрузить регистрацию',

## lib/MT/Util/Archive/Tgz.pm
	'Type must be tgz.' => 'Тип должен быть tgz.',
	'Could not read from filehandle.' => 'Не удалось прочитать из дескриптора файла.',
	'File [_1] is not a tgz file.' => 'Файл [_1] не в формате tgz.',
	'File [_1] exists; could not overwrite.' => 'Файл [_1] уже существует; перезапись не удалась.',
	'Can\'t extract from the object' => 'Не удалось извлечь из объекта',
	'Can\'t write to the object' => 'Не удалось записать в объект',
	'Both data and file name must be specified.' => 'Необходимо указать данные и имя файла.',

## lib/MT/Util/Archive/Zip.pm
	'Type must be zip' => 'Тип должен быть zip.',
	'File [_1] is not a zip file.' => 'Файл [_1] не в формате zip.',

## lib/MT/Util/Captcha.pm
	'Movable Type default CAPTCHA provider requires Image::Magick.' => 'Для работы CAPTCHA необходим модуль Image::Magick.',
	'You need to configure CaptchaSourceImageBase.' => 'Необходимо настроить CaptchaSourceImagebase.',
	'Image creation failed.' => 'Не удалось создать картинку.',
	'Image error: [_1]' => 'Ошибка изображения: [_1]',

## lib/MT/Util.pm
	'moments from now' => 'только что',
	'[quant,_1,hour,hours] from now' => '[quant,_1,час,часа,часов] назад',
	'[quant,_1,minute,minutes] from now' => '[quant,_1,минуту,минуты,минут] назад',
	'[quant,_1,day,days] from now' => '[quant,_1,день,дня,дней] назад',
	'less than 1 minute from now' => 'около минуты назад',
	'less than 1 minute ago' => 'минуту назад',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => 'прошло [quant,_1,час,часа,часов], [quant,_2,минута,минуты,минут]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => '[quant,_1,час,часа,часов], [quant,_2,минута,минуты,минут]',
	'[quant,_1,day,days], [quant,_2,hour,hours] from now' => 'прошло [quant,_1,день,дня,дней], [quant,_2,час,часа,часов]',
	'[quant,_1,day,days], [quant,_2,hour,hours] ago' => '[quant,_1,день,дня,дней], [quant,_2,час,часа,часов] назад',
	'[quant,_1,second,seconds] from now' => '[quant,_1,секунду,секунды,секунд] назад',
	'[quant,_1,second,seconds]' => '[quant,_1,секунда,секунды,секунд]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => '[quant,_1,минуту,минуты,минут] и [quant,_2,секунду,секунды,секунд] назад',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,минута,минуты,минут] и [quant,_2,секунда,секунды,секунд]',
	'[quant,_1,minute,minutes]' => '[quant,_1,минута,минуты,минут]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,час,часа,часов] и [quant,_2,минута,минуты,минут]',
	'[quant,_1,hour,hours]' => '[quant,_1,час,часа,часов]',
	'[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,день,дня,дней] и [quant,_2,час,часа,часов]',
	'[quant,_1,day,days]' => '[quant,_1,день,дня,дней]',
	'Invalid domain: \'[_1]\'' => 'Неправильный домен: «[_1]»',

## lib/MT/WeblogPublisher.pm
	'Archive type \'[_1]\' is not a chosen archive type' => 'Тип архива «[_1]» не доступен для выбранного архива.',
	'Parameter \'[_1]\' is required' => 'Параметр «[_1]» обязателен.',
	'You did not set your blog publishing path' => 'Вы не указали путь публикации для блога',
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => 'Точно такой же файл архива уже существует. Попробуйте изменить базовое имя или путь публикации архива ([_1])',
	'An error occurred publishing [_1] \'[_2]\': [_3]' => 'Произошла ошибка во время публикации [_1] «[_2]»: [_3]',
	'An error occurred publishing date-based archive \'[_1]\': [_2]' => 'Произошла ошибка при публикации архивов по датам «[_1]»: [_2]',
	'Renaming tempfile \'[_1]\' failed: [_2]' => 'Не удалось переименовать временный файл «[_1]»: [_2]',
	'Blog, BlogID or Template param must be specified.' => 'Должны быть указаны параметры Blog, BlogID или Template.',
	'Template \'[_1]\' does not have an Output File.' => 'Для шаблона «[_1]» не найден связанный с ним файл.',
	'An error occurred while publishing scheduled entries: [_1]' => 'Возникли ошибки при публикации запланированных записей: [_1]',

## lib/MT/Website.pm
	'__BLOG_COUNT' => 'Количество блогов',

## lib/MT/Worker/Publish.pm
	'Error rebuilding file [_1]:[_2]' => 'Ошибка при публикации файла [_1]:[_2]',
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- полный набор ([quant,_1,файл,файла,файлов] за [_2] секунд)',

## lib/MT/Worker/Sync.pm
	"Error during rsync of files in [_1]:\n" => "", # Translate - New
	'Synchrnizing Files Done' => 'Синхронизация файлов завершена',
	'Done syncing files to [_1] ([_2])' => 'Синхронизация файлов совершена в [_1] ([_2])',

## lib/MT/XMLRPC.pm
	'No WeblogsPingURL defined in the configuration file' => 'WeblogsPingURL не определён в файле настроек (config.cgi)',
	'No MTPingURL defined in the configuration file' => 'MTPingURL не определён в файле настроек (config.cgi)',
	'HTTP error: [_1]' => 'Ошибка HTTP: [_1]',
	'Ping error: [_1]' => 'Ошибка пинга: [_1]',

## lib/MT/XMLRPCServer.pm
	'Invalid timestamp format' => 'Неверный формат времени',
	'No web services password assigned.  Please see your user profile to set it.' => 'Для веб-сервисов создаётся другой пароль. Перейдите к настройке профиля, чтобы узнать эту информацию.',
	'Requested permalink \'[_1]\' is not available for this page' => 'Запрошенная постоянная ссылка недоступна для этой страницы',
	'Saving folder failed: [_1]' => 'Не удалось сохранить папку: [_1]',
	'No blog_id' => 'Не указан blog_id',
	'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => 'В поле «mt_[_1]» могуть быть только значения 1 или 0 (was \'[_2]\')',
	'Not privileged to edit entry' => 'Недостаточно прав для редактирования этой записи',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => 'Запись «[_1]» ([lc,_5] #[_2]) удалена пользователем «[_3]» (ID #[_4]) через xml-rpc',
	'Not privileged to get entry' => 'Недостаточно прав для получения этой записи',
	'Not privileged to set entry categories' => 'Недостаточно прав для указания категории у записи',
	'Not privileged to upload files' => 'Недостаточно прав для загрузки файлов',
	'No filename provided' => 'Не указано имя файла',
	'Error writing uploaded file: [_1]' => 'Ошибки при записи загружаемого файла: [_1]',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Из-за различий в Blogger API и Movable Type API методы шаблона не реализованы.',

## mt-static/jquery/jquery.mt.js
	'Invalid value' => 'Неверное значение',
	'Invalid date format' => 'Неверный формат даты',
	'Invalid mail address' => 'Неверный адрес электронной почты',
	'Invalid URL' => 'Неверный URL',
	'This field is required' => 'Это поле обязательно',
	'This field must be integer' => 'Это поле должно быть целочисленным',
	'This field must be number' => 'Это поле должно быть числом',

## mt-static/js/assetdetail.js
	'No Preview Available.' => 'Без предпросмотра.',
	'Dimensions' => 'Соотношение размера', # проверить
	'File Name' => 'Имя файла',

## mt-static/js/dialog.js
	'(None)' => '(Нет)',

## mt-static/js/tc/mixer/display.js
	'Title:' => 'Заголовок:',
	'Description:' => 'Описание:',
	'Author:' => 'Автор:',
	'Tags:' => 'Теги:',
	'URL:' => 'URL:', # Translate - Not translated

## mt-static/mt.js
	'delete' => 'удалить',
	'remove' => 'переместить',
	'enable' => 'включить',
	'disable' => 'отключить',
	'publish' => 'Публикация',
	'You did not select any [_1] to [_2].' => 'Вы не выбрали [_1] для [_2].',
	'Are you sure you want to [_2] this [_1]?' => 'Вы уверены, что хотите [_2] этот [_1]?',
	'Are you sure you want to [_3] the [_1] selected [_2]?' => 'Вы уверены, что хотите [_3] [_1] выбранный [_2]?',
	'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => 'Вы уверены, что хотите переместить или убрать эту роль? Таким образом вы снимаете ассоциации, приписанные на данный момент пользователям и группам, связанным с этой ролью.',
	'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => 'Вы уверены, что хотите переместить или убрать эти роли ([_1])? Таким образом вы снимаете ассоциации, приписанные на данный момент пользователям и группам, связанными с этими ролями.',
	'You did not select any [_1] [_2].' => 'Вы не выбрали [_1] [_2].',
	'You can only act upon a minimum of [_1] [_2].' => 'Вы можете действовать только по минимуму [_1] [_2].',
	'You can only act upon a maximum of [_1] [_2].' => 'Вы можете действовать только по максимому [_1] [_2].',
	'You must select an action.' => 'Необходимо выбрать действие.',
	'to mark as spam' => 'пометить как спам',
	'to remove spam status' => 'убрать пометку спам',
	'Enter email address:' => 'Ввведите адрес электронной почты:',
	'Enter URL:' => 'Введите URL:',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\'?' => 'Тег  «[_2]» уже существует. Вы уверены, что хотите объединить «[_1]» с «[_2]»?',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all weblogs?' => 'Тег «[_2]» уже существует. Вы уверены, что хотите объеденить «[_1]» с «[_2]» во всех блогах?',
	'Loading...' => 'Загрузка…',
	'First' => 'Первый',
	'Prev' => 'Предыдущий',
	'[_1] &ndash; [_2] of [_3]' => '[_1] — [_2] из [_3]',
	'[_1] &ndash; [_2]' => '[_1] — [_2]', # Translate - No russian chars
	'Last' => 'Последний',

## themes/classic_blog/theme.yaml
	'Typical and authentic blogging design comes with plenty of styles and the selection of 2 column / 3 column layout. Best for all the bloggers.' => 'Стандартный макет блога, к которому создано множество стилей; можно использовать 2-х или 3-х колончатую структуру макета.',

## themes/classic_website/templates/syndication.mtml
	q{Subscribe to this website's feed} => q{Подписаться на обновления сайта},

## themes/classic_website/theme.yaml
	'Create a blog portal that aggregates contents from blogs under the website.' => 'Создать сайт, содержащий контент из блогов, входящих в него.',
	'Classic Website' => 'Классический сайт',

## themes/pico/templates/archive_index.mtml
	'Navigation' => 'Навигация',
	'Related Content' => 'Похожее',

## themes/pico/templates/comment_preview.mtml
	'Preview Comment' => 'Предпросмотр комментария',

## themes/pico/templates/entry.mtml
	'Home' => 'Главная',

## themes/pico/templates/navigation.mtml
	'Subscribe' => 'Подписка',

## themes/pico/theme.yaml
	q{Pico is the microblogging theme, designed for keeping things simple to handle frequent updates. To put the focus on content we've moved the sidebars below the list of posts.} => q{Pico — это специальная тема для микроблогинга. В этой теме акцент делается на частые обновления. Чтобы в первую очередь показать контент, содержимое сайдбара размещено под постами.},
	'Pico' => 'Pico', # Translate - Not translated
	'Pico Styles' => 'Стили Pico',
	'A collection of styles compatible with Pico themes.' => 'Коллекция совместимых с Pico стилей.',

## search_templates/comments.tmpl
	'Search for new comments from:' => 'Поиск новых комментариев от:',
	'the beginning' => 'начало',
	'one week back' => 'неделю назад',
	'two weeks back' => 'две недели назад',
	'one month back' => 'месяц назад',
	'two months back' => '2 месяца назад',
	'three months back' => '3 месяца назад',
	'four months back' => '4 месяца назад',
	'five months back' => '5 месяцев назад',
	'six months back' => '6 месяцев назад',
	'one year back' => 'год назад',
	'Find new comments' => 'Найти новые комментарии',
	'Posted in [_1] on [_2]' => 'Опубликовано в [_1] — [_2]',
	'No results found' => 'Нет результатов',
	'No new comments were found in the specified interval.' => 'Не найдено новых комментариев за указанный период.',
	q{Select the time interval that you'd like to search in, then click 'Find new comments'} => q{Выберите период времени, в котором будет осуществлён поиск, а затем нажмите «Найти новые комментарии»},

## search_templates/default.tmpl
	'SEARCH FEED AUTODISCOVERY LINK PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => 'ССЫЛКА ПОИСКА  AUTODISCOVERY ОПУБЛИКОВАНА ТОЛЬКО ТОГДА, КОГДА ПОИСК ОСУЩЕСТВЛЕН.',
	'Blog Search Results' => 'Результаты поиска в блоге',
	'Blog search' => 'Поиск по блогу',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => 'ПРЯМЫЕ ПОИСКИ ПОЛУЧАЮТ ФОРМУ ЗАПРОСОВ',
	'Search this site' => 'Поиск по сайту',
	'Match case' => 'С учётом регистра',
	'SEARCH RESULTS DISPLAY' => 'ОТОБРАЖЕНИЕ РЕЗУЛЬТАТОВ ПОИСКА',
	'Matching entries from [_1]' => 'Сопоставление записи из [_1]',
	q{Entries from [_1] tagged with '[_2]'} => q{Записи блога «[_1]», связанные с тегом «[_2]»},
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Автор: <MTIfNonEmpty tag="EntryAuthorDisplayName">[_1]</MTIfNonEmpty> — [_2]',
	'Showing the first [_1] results.' => 'Показ первые [_1] результатов.',
	'NO RESULTS FOUND MESSAGE' => 'СООБЩЕНИЕ ОБ ОТСУТСТВИИ НАЙДЕННЫХ РЕЗУЛЬТАТОВ',
	q{Entries matching '[_1]'} => q{Записи, в которых присутствует «[_1]»},
	q{Entries tagged with '[_1]'} => q{Записи, связанные с тегом «[_1]»},
	q{No pages were found containing '[_1]'.} => q{По запросу «[_1]» ничего не найдено.},
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes' => 'По умолчанию механизм поиска ищет все слова, расположенные в любом порядке. Чтобы искать точную фразу, заключите её в кавычки.',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions' => 'Поисковый механизм также поддерживает логические операторы AND, OR и NOT',
	'END OF ALPHA SEARCH RESULTS DIV' => 'ОКОНЧАНИЕ ПОИСКА  ALPHA РЕЗУЛЬТАТОВ DIV',
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'НАЧАЛО BETA SIDEBAR ДЛЯ ОТОБРАЖЕНИЯ ИНФОРМАЦИИ ПОИСКА ',
	'SET VARIABLES FOR SEARCH vs TAG information' => 'УСТАНОВИТЕ ПЕРЕМЕННЫЕ ВЕЛИЧИНЫ ДЛЯ ПОИСКА vs TAG информация',
	q{If you use an RSS reader, you can subscribe to a feed of all future entries tagged '[_1]'.} => q{Вы можете подписаться на фид, в котором будут присутствовать новые сообщения этого блога, связанные с тегом «[_1]».},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries matching '[_1]'.} => q{Вы можете подписаться на фид, в котором будут присутствовать новые сообщения этого блога, соответствующие запросу «[_1]».},
	'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => 'ПОИСК/ТЕГ — ИНФОРМАЦИЯ О ПОДПИСКЕ',
	'Feed Subscription' => 'Подписка на обновления',
	'http://www.sixapart.com/about/feeds' => 'http://ru.wikipedia.org/wiki/RSS', # Translate - No russian chars
	'What is this?' => 'Что это?',
	'TAG LISTING FOR TAG SEARCH ONLY' => 'СПИСОК ТЕГОВ  ТОЛЬКО ДЛЯ ПОИСКА ТЕГОВ',
	'Other Tags' => 'Другие теги',
	'END OF PAGE BODY' => 'КОНЕЦ ОСНОВНОЙ ЧАСТИ СТРАНИЦЫ',
	'END OF CONTAINER' => 'КОНЕЦ КОНТЕЙНЕРА',

## search_templates/results_feed_rss2.tmpl
	'Search Results for [_1]' => 'Результат поиска по «[_1]»',

## tmpl/cms/asset_replace.tmpl
	'Upload New Asset' => 'Загрузка нового медиа',

## tmpl/cms/asset_upload.tmpl
	'Upload Asset' => 'Загрузить медиа',

## tmpl/cms/backup.tmpl
	'Backup [_1]' => 'Бэкап [_1]',
	'What to Backup' => 'Что включить в бекап',
	'This option will backup Users, Roles, Associations, Blogs, Entries, Categories, Templates and Tags.' => 'Эта опция позволяет выбрать для бекапа пользователей, роли, ассоциации, блоги, записи, категории, шаблоны и теги.',
	'Everything' => 'Всё',
	'Reset' => 'Очистить',
	'Choose websites...' => 'Выберите сайты…',
	'Archive Format' => 'Формат архива',
	'The type of archive format to use.' => 'Тип архива, который будет использован.',
	q{Don't compress} => q{Не сжимать},
	'Target File Size' => 'Ограничивать размер получаемого файла',
	'Approximate file size per backup file.' => 'Приблизительный размер файла бекапа.',
	'No size limit' => 'Без ограничений по размеру',
	'Make Backup (b)' => 'Сделать бекап (b)',
	'Make Backup' => 'Сделать бекап',

## tmpl/cms/cfg_entry.tmpl
	'Compose Settings' => 'Параметры редактирования',
	'Your preferences have been saved.' => 'Параметры сохранены.',
	'Publishing Defaults' => 'Публикация по умолчанию',
	'Listing Default' => 'Отображение по умолчанию',
	'Select the number of days of entries or the exact number of entries you would like displayed on your blog.' => 'Выберите количество дней или точное количество записей, которые вы хотите отобразить в своём блоге.',
	'Days' => 'Дни',
	'Posts' => 'Посты',
	'Order' => 'Сортировка',
	'Select whether you want your entries displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Выберите, как должны отображаться записи: по убыванию (новые вверху; обычный метод) или по возрастанию (старые вверху).',
	'Ascending' => 'По возрастанию',
	'Descending' => 'По убыванию',
	'Excerpt Length' => 'Длина выдержки',
	'Enter the number of words that should appear in an auto-generated excerpt.' => 'Введите количество слов, которые будут использоваться при автоматической генерации выдержки.',
	'Date Language' => 'Язык дат',
	'Select the language in which you would like dates on your blog displayed.' => 'Выберите язык, на котором будут отображаться даты в блоге.',
	'Czech' => 'Чешский',
	'Danish' => 'Датский',
	'Dutch' => 'Голландский',
	'English' => 'Английский',
	'Estonian' => 'Эстонский',
	'French' => 'Французский',
	'German' => 'Немецкий',
	'Icelandic' => 'Исландский',
	'Italian' => 'Итальянский',
	'Japanese' => 'Японский',
	'Norwegian' => 'Норвежский',
	'Polish' => 'Польский',
	'Portuguese' => 'Португальский',
	'Slovak' => 'Словацкий',
	'Slovenian' => 'Словенский',
	'Spanish' => 'Испанский',
	'Suomi' => 'Финский',
	'Swedish' => 'Шведский',
    'Russian' => 'Русский',
	'Basename Length' => 'Длина базового имени (имени файла при публикации записей)',
	'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => 'Определите значение автоматически генерируемого базового имени. Диапозон: от 15 до 250.',
	'Compose Defaults' => 'Создание по умолчанию',
	'Specifies the default Post Status when creating a new entry.' => 'Укажите статус поста по умолчанию при создании новой записи.',
	'Unpublished' => 'Черновик',
	'Text Formatting' => 'Форматирование текста',
	'Specifies the default Text Formatting option when creating a new entry.' => 'Определите, какой вид форматирования текста будет новых записей по умолчанию.',
	'Specifies the default Accept Comments setting when creating a new entry.' => 'Определите значение по умолчанию для комментариев при создании новой записи.',
	'Setting Ignored' => 'Игнорируемые параметры',
	'Note: This option is currently ignored since comments are disabled either blog or system-wide.' => 'Примечание: эта опция в настоящее время игнорируется, так как комментарии отключены в блоге или на системном уровне.',
	'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'Определите значение по умолчанию для трекбэков при создании новой записи.',
	'Accept TrackBacks' => 'Принимать трекбэки',
	'Note: This option is currently ignored since TrackBacks are disabled either blog or system-wide.' => 'Примечание: эта опция в настоящее время игнорируется, так как трекбэки отключены в блоге или на системном уровне.',
	'Entry Fields' => 'Поля записей',
	'_USAGE_ENTRYPREFS' => 'Конфигурация полей определяет поля, которые появятся при добавлении или редактировании записей. Вы можете выбрать базовую или продвинутую конфигурацию, или выполнить персональную настройку.',
	'Page Fields' => 'Поля страниц',
	'Punctuation Replacement Setting' => 'Параметры замены пунктуации',
	'Replace UTF-8 characters frequently used by word processors with their more common web equivalents.' => 'Заменять символы UTF-8, часто использующиеся текстовыми редакторами, их эквивалентом, наиболее подходящим для web.',
	'Punctuation Replacement' => 'Замена пунктуации',
	'No substitution' => 'Не осуществлять замену',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'Специальные символы (&amp#8221;, &amp#8220;, и другие.)',
	q{ASCII equivalents (&quot;, ', ..., -, --)} => q{Эквиваленты ASCII (&quot;, ', ..., -, --)},
	'Replace Fields' => 'Заменять символы в полях',
	'Save changes to these settings (s)' => 'Сохранить изменения этих настроек',

## tmpl/cms/cfg_feedback.tmpl
	'Feedback Settings' => 'Настройка обратной связи',
	'Spam Settings' => 'Настройка спам-защиты',
	'Automatic Deletion' => 'Автоматическое удаление',
	'Automatically delete spam feedback after the time period shown below.' => 'Автоматически удалять спам после указанного ниже времени.',
	'Delete Spam After' => 'Удалять спам после',
	'When an item has been reported as spam for this many days, it is automatically deleted.' => 'Когда объект определен как спам, он будет автоматически удалён после прошествия этого количества.',
	'days' => 'дни',
	'Spam Score Threshold' => 'Границы шкалы спама',
	'Comments and TrackBacks receive a spam score between -10 (complete spam) and +10 (not spam). Feedback with a score which is lower than the threshold shown above will be reported as spam.' => 'Комментарии и трекбэки оцениваются по шкале от -10 (полный спам) до +10 (не спам). Элементы с уровнем меньше порогового определяются как спам.',
	'Less Aggressive' => 'Менее агрессивный',
	'Decrease' => 'Уменьшить',
	'Increase' => 'Увеличить',
	'More Aggressive' => 'Более агрессивный',
	q{Apply 'nofollow' to URLs} => q{Применять «nofollow» и «noindex» к URL},
	q{If enabled, all URLs in comments and TrackBacks will be assigned a 'nofollow' link relation.} => q{Если активно, то ко всем ссылкам в комментариям и трекбекам будет добавляться атрибут «nofollow», а также такая ссылка будет заключена в тег «noindex».},
	q{'nofollow' exception for trusted commenters} => q{Не использовать «nofollow» и «noindex» у доверенных комментаторов},
	q{Do not add the 'nofollow' attribute when a comment is submitted by a trusted commenter.} => q{Не добавлять к ссылкам от доверенных комментаторов «nofollow» и «noindex».},
	'Comment Settings' => 'Настройка комментариев',
	'Note: Commenting is currently disabled at the system level.' => 'Примечание: в настоящее время комментарии отключены на системном уровне.',
	'Comment authentication is not available because at least one of the required Perl modules, MIME::Base64 and LWP::UserAgent, are not installed. Install the missing modules and reload this page to configure comment authentication.' => 'Авторизация комментаторов невозможна, потому что не установлены необходимые Perl-модули: MIME::Base64 и LWP::UserAgent.',
	'Accept comments according to the policies shown below.' => 'Принимать комментарии в соответствии с указанной ниже политикой.',
	'Setup Registration' => 'Настройка регистрации',
	'Commenting Policy' => 'Политика комментирования',
	'Immediately approve comments from' => 'Автоматически одобрять комментарии',
	'Specify what should happen to comments after submission. Unapproved comments are held for moderation.' => 'Укажите, что должно происходить после добавления комментариев. Не одобренные комментарии помещаются на модерацию.',
	'No one' => 'Ни от кого',
	'Trusted commenters only' => 'Только от доверенных комментаторов',
	'Any authenticated commenters' => 'От любого авторизованного комментатора',
	'Anyone' => 'От всех',
	'Allow HTML' => 'Разрешить HTML',
	'Allow commenters to include a limited set of HTML tags in their comments. Otherwise all HTML will be stripped out.' => 'Разрешить комментаторам использовать ограниченный список HTML-тегов в комментариях. Все не разрешённые теги будут вырезаны.',
	'Limit HTML Tags' => 'Лимит HTML тегов',
	'Specify the list of HTML tags to allow when accepting a comment.' => 'Укажите список разрешённых HTML-тегов.',
	'Use defaults' => 'Использовать значения по умолчанию',
	'([_1])' => '([_1])', # Translate - Not translated
	'Use my settings' => 'Использовать собственные параметры',
	'E-mail Notification' => 'Уведомление по email',
	'Specify when Movable Type should notify you of new comments.' => 'Укажите, когда Movable Type будет уведомлять вас о новых комментариях.',
	'On' => 'Активно',
	'Only when attention is required' => 'Только, когда требуется проверка',
	'Off' => 'Отключено',
	'Comment Display Settings' => 'Параметры отображения комментариев',
	'Comment Order' => 'Порядок комментариев',
	'Select whether you want comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'Выберите, как будут отображаться комментарии: по возрастанию (старые вверху) или по убыванию (новые вверху).',
	'Auto-Link URLs' => 'Автоматически создавать ссылку из URL',
	'Transform URLs in comment text into HTML links.' => 'Автоматически делать ссылки из URL в тексте комментариев.',
	'Specifies the Text Formatting option to use for formatting visitor comments.' => 'Укажите тип форматирования текста комментариев.',
	'CAPTCHA Provider' => 'Провайдер CAPTCHA',
	'No CAPTCHA provider available' => 'Нет доступного провайдера CAPTCHA',
	q{No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed and if the CaptchaSourceImageBase configuration directive points to a valid captcha-source directory within the 'mt-static/images' directory.} => q{Нет доступного обработчика CAPTCHA. Проверьте, установлен ли Image::Magick и правильно ли указана конфигурационная директива CaptchaSourceImageBase (директория в папке «mt-static/images»).},
	'Use Comment Confirmation Page' => 'Использовать страницу подтверждения комментариев',
	'Use comment confirmation page' => 'Использовать страницу подтверждения комментариев',
	q{Each commenter's browser will be redirected to a comment confirmation page after their comment is accepted.} => q{Каждый комментатор будет перенаправлен на страницу подтверждения/уведомления о статусе добавленного комментария.},
	'Trackback Settings' => 'Настройка трекбэков',
	'Note: TrackBacks are currently disabled at the system level.' => 'Примечание: в настоящее время трекбэки отключены на системном уровне.',
	'Accept TrackBacks from any source.' => 'Принимать трекбэки от всех сайтов',
	'TrackBack Policy' => 'Правила для трекбэков',
	'Moderation' => 'Модерация',
	'Hold all TrackBacks for approval before they are published.' => 'Не публиковать трекбэки, пока они не будут проверены.',
	'Specify when Movable Type should notify you of new TrackBacks.' => 'Укажите, когда Movable Type будет уведомлять вас о новых трекбэках.',
	'TrackBack Options' => 'Опции трекбэков',
	'TrackBack Auto-Discovery' => 'Автоматическая отправка трекбэков',
	'When auto-discovery is turned on, any external HTML links in new entries will be extracted and the appropriate sites will automatically be sent a TrackBack ping.' => 'Если автоматическая отправка активна, то Movable Type будет пытаться отправить трекбэки на все страницы, ссылки на которые есть в записи.',
	'Enable External TrackBack Auto-Discovery' => 'Для записей в других блогах',
	'Setting Notice' => 'Настройка уведомлений',
	'Note: This option may be affected since outbound pings are constrained system-wide.' => 'Примечание: эта опция может затронуть исходящие пинги во всей системе.',
	'Note: This option is currently ignored since outbound pings are disabled system-wide.' => 'Примечание: эта опция в настоящее время игнорируется, так как она отключена на системном уровне.',
	'Enable Internal TrackBack Auto-Discovery' => 'Для записей в этом блоге',

## tmpl/cms/cfg_plugin.tmpl
	'[_1] Plugin Settings' => 'Параметры плагина [_1]',
	'Plugin System' => 'Системные плагины',
	'Enable or disable plugin functionality for the entire Movable Type installation.' => 'Включение или отключение функциональности плагинов для этой установки Movable Type.',
	'Disable plugin functionality' => 'Отключить дополнительную функциональность за счёт плагинов',
	'Disable Plugins' => 'Отключить плагины',
	'Enable plugin functionality' => 'Активировать дополнительную функциональность за счёт плагинов',
	'Enable Plugins' => 'Активировать плагины',
	'_PLUGIN_DIRECTORY_URL' => 'http://plugins.movabletype.org/', # Translate - No russian chars
	'Find Plugins' => 'Поиск плагинов',
	'Your plugin settings have been saved.' => 'Конфигурация плагинов сохранена.',
	'Your plugin settings have been reset.' => 'Конфигурация плагинов сброшена.',
	q{Your plugins have been reconfigured. Since you're running mod_perl, you must restart your web server for these changes to take effect.} => q{Ваши плагины сконфигурированы. Если MT работает под mod_perl, необходимо перезапустить веб-сервер, чтобы увидеть изменения.},
	'Your plugins have been reconfigured.' => 'Конфигурация плагинов изменена.',
	q{Your plugins have been reconfigured. Since you're running mod_perl, you will need to restart your web server for these changes to take effect.} => q{Конфигурация плагинов изменена. Так как вы используете mod_perl, необходимо перезапустить веб-сервер, чтобы изменения вступили в силу.},
	'Are you sure you want to reset the settings for this plugin?' => 'Вы действительно хотите сбросить параметры этого плагина? (Будут установлены параметры по умолчанию.)',
	'Are you sure you want to disable plugins for the entire Movable Type installation?' => 'Вы уверены, что хотите отключить плагины?',
	'Are you sure you want to disable this plugin?' => 'Вы уверены, что хотите отключить этот плагин?',
	'Are you sure you want to enable plugins for the entire Movable Type installation? (This will restore plugin settings that were in place before all plugins were disabled.)' => 'Вы уверены, что хотите включить плагины? (Это действие вернёт плагины в то состояние, в котором они находились до отключения.)',
	'Are you sure you want to enable this plugin?' => 'Вы уверены, что хотите включить этот плагин?',
	'Settings for [_1]' => 'Настройки для [_1]',
	'Failed to Load' => 'Ошибка при загрузке',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be completely functional.' => 'Этот плагин не был обновлён для поддержки Movable Type [_1], поэтому он может работать некоррктно.',
	'Plugin error:' => 'Ошибка плагина:',
	'Info' => 'Информация',
	'Resources' => 'Ресурсы',
	'Run [_1]' => 'Запустить [_1]',
	'Documentation for [_1]' => 'Документация по [_1]',
	'Documentation' => 'Документация',
	'More about [_1]' => 'Подробная информация об [_1]',
	'Plugin Home' => 'Страница плагина',
	'Author of [_1]' => 'Автор плагина [_1]',
	'Tag Attributes:' => 'Атрибуты тегов:',
	'Text Filters' => 'Фильтры для текста',
	'Junk Filters:' => 'Фильтры для спама:',
	'Reset to Defaults' => 'Сбросить параметры',
	'No plugins with blog-level configuration settings are installed.' => 'Нет плагинов, которыми можно управлять на уровне блога.',
	'No plugins with configuration settings are installed.' => 'Не установлено настраиваемых плагинов.',

## tmpl/cms/cfg_prefs.tmpl
	'Error: Movable Type was not able to create a directory for publishing your [_1]. If you create this directory yourself, grant write permission to the web server.' => 'Ошибка: Movable Type не может создать директорию для публикации вашего [_1]. Если вы создали эту директорию сами, проверьте, доступна ли она для записи.',
	'[_1] Settings' => 'Параметры [_1]',
	'Name your blog. The name can be changed at any time.' => 'Имя вашего блога. Оно может быть изменено в любое время.',
	'Enter a description for your blog.' => 'Опишите ваш блог.',
	'Time Zone' => 'Временная зона',
	'Select your time zone from the pulldown menu.' => 'Выберите временную зону из выпадающего меню.',
	'Time zone not selected' => 'Часовой пояс не выбрана',
	'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (Камчатское летнее время)',
	'UTC+12 (International Date Line East)' => 'UTC+12 (Камчатский край, Чукотский АО)',
	'UTC+11' => 'UTC+11 (Восточная часть Якутии, Курильские острова)',
	'UTC+10 (East Australian Time)' => 'UTC+10 (Приморский край, Хабаровский край)',
	'UTC+9.5 (Central Australian Time)' => 'UTC+9,5 (Центральное австралийское время)',
	'UTC+9 (Japan Time)' => 'UTC+9 (Амурская область, Читинская область)',
	'UTC+8 (China Coast Time)' => 'UTC+8 (Иркутское время)',
	'UTC+7 (West Australian Time)' => 'UTC+7 (Красноярское время)',
	'UTC+6.5 (North Sumatra)' => 'UTC+6,5 (Северная Суматра)',
	'UTC+6 (Russian Federation Zone 5)' => 'UTC+6 (Омское, Екатеринбургское летнее время)',
	'UTC+5.5 (Indian)' => 'UTC+5.5 (Индия)',
	'UTC+5 (Russian Federation Zone 4)' => 'UTC+5 (Башкортостан, Пермский край, Оренбургская область)',
	'UTC+4 (Russian Federation Zone 3)' => 'UTC+4 (Самарское время)',
	'UTC+3.5 (Iran)' => 'UTC+3,5 (Иранское время)',
	'UTC+3 (Baghdad Time/Moscow Time)' => 'UTC+3 (Московское время)',
	'UTC+2 (Eastern Europe Time)' => 'UTC+2 (Восточноевропейское время)',
	'UTC+1 (Central European Time)' => 'UTC+1 (Центральноевропейское время)',
	'UTC+0 (Universal Time Coordinated)' => 'UTC+0 (Среднее время по Гринвичу)',
	'UTC-1 (West Africa Time)' => 'UTC-1 (Португальское время)',
	'UTC-2 (Azores Time)' => 'UTC-2 (Бразильское время — океанические острова)',
	'UTC-3 (Atlantic Time)' => 'UTC-3 (Атлантическое время)',
	'UTC-3.5 (Newfoundland)' => 'UTC-3,5 (Ньюфаундлендское время)',
	'UTC-4 (Atlantic Time)' => 'UTC-4 (Атлантическое стандартное время)',
	'UTC-5 (Eastern Time)' => 'UTC-5 (Североамериканское восточное время)',
	'UTC-6 (Central Time)' => 'UTC-6 (Центральное время США)',
	'UTC-7 (Mountain Time)' => 'UTC-7 (Горное время США и Канады)',
	'UTC-8 (Pacific Time)' => 'UTC-8 (Тихоокеанское время)',
	'UTC-9 (Alaskan Time)' => 'UTC-9 (Аляска)',
	'UTC-10 (Aleutians-Hawaii Time)' => 'UTC-10 (Время гавайских островов)',
	'UTC-11 (Nome Time)' => 'UTC-11 (Время Нома)',
	'License' => 'Лицензия',
	'Your blog is currently licensed under:' => 'Содержимое блога распространяется в соответствии с лицензией:',
	'Change license' => 'Изменить лицензию',
	'Remove license' => 'Удалить лицензию',
	'Your blog does not have an explicit Creative Commons license.' => 'У вашего блога не определена лицензия Creative Commons.',
	'Select a license' => 'Выбрать лицензию',
	'Publishing Paths' => 'Пути для публикации',
	'[_1] URL' => 'URL [_1]', # Translate - No russian chars
	'Use subdomain' => 'Использовать поддомен',
	'Warning: Changing the [_1] URL can result in breaking all the links in your [_1].' => 'Предупреждение: изменение URL может привести к потере входящих ссылок на ваш [_1].',
	q{The URL of your blog. Exclude the filename (i.e. index.html). End with '/'. Example: http://www.example.com/blog/} => q{URL вашего блога, исключая имя индексного файла (например, index.html). Должен заканчивать слэшем («/»). Пример: http://example.com/blog/},
	q{The URL of your website. Exclude the filename (i.e. index.html).  End with '/'. Example: http://www.example.com/} => q{URL вашего сайта, исключая имя индексного файла (например, index.html). Должен заканчивать слэшем («/»). Пример: http://example.com/},
	'[_1] Root' => '[_1] родительская',
	'Use absolute path' => 'Используйте абсолютный путь',
	'Warning: Changing the [_1] root requires a complete publish of your [_1].' => 'Предупреждение: изменение корня [_1] потребует полной публикации вашего [_1].',
	q{The path where your index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Место, где будут публиковаться индексные файлы. Путь не должен заканчиваться на '/' или '\'. Пример: /home/mt/public_html/blog или C:\www\public_html\blog},
	q{The path where your index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Место, где будут публиковаться индексные файлы. Рекомендуется использовать абсолютный путь (в Linux начинается с '/', а в Windows с 'C:\'). Путь не должен заканчиваться на '/' или '\'. Пример: /home/mt/public_html/blog или C:\www\public_html\blog},
	'Advanced Archive Publishing' => 'Дополнительные параметры публикации архивов',
	'Select this option only if you need to publish your archives outside of your Blog Root.' => 'Активируйте эту опцию только в том случае, если вы хотите публиковать архивы в директории, отличающейся от корневой директории блога.',
	'Publish archives outside of Blog Root' => 'Публиковать архивы вне корневой директории блога',
	'Archive URL' => 'URL архива',
	'The URL of the archives section of your blog. Example: http://www.example.com/blog/archives/' => 'URL архивов вашего блога. Пример: http://example.com/blog/archives/',
	'Warning: Changing the archive URL can result in breaking all the links in your blog.' => 'Внимание: если вы измените URL архива, то потеряете входящие ссылки на него.',
	'Warning: Changing the archive path can result in breaking all the links in your blog.' => 'Внимание: если вы измените путь к архивам, то потеряете входящие ссылки на него.',
	q{The path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Место, где будут публиковаться архивы. Путь не должен заканчиваться на '/' или '\'. Пример: /home/mt/public_html/blog или C:\www\public_html\blog},
	q{The path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Место, где будут публиковаться архивы. Рекомендуется использовать абсолютный путь (в Linux начинается с '/', а в Windows с 'C:\'). Путь не должен заканчиваться на '/' или '\'. Пример: /home/mt/public_html/blog или C:\www\public_html\blog},
	'Dynamic Publishing Options' => 'Опции динамической публикации',
	'Enable dynamic cache' => 'Включить кеширование динамических страниц',
	'Enable conditional retrieval' => 'Включить условный поиск',
	'Archive Settings' => 'Параметры архива',
	q{Enter the archive file extension. This can take the form of 'html', 'shtml', 'php', etc. Note: Do not enter the leading period ('.').} => q{Введите расширение файлов архива. Например: html, shtml, php, и.т.д. Внимание: не вводите стартовую точку («.»).},
	'Preferred Archive' => 'Предпочтительный архив',
	q{Used to generate URLs (permalinks) for this blog's archived entries. Choose one of the archive type used in this blog's archive templates.} => q{Используется для генерации URL (постоянных ссылок) для архивов этого блога. Выберите один тип архива, использующегося в архивных шаблонах блога.},
	'No archives are active' => 'Нет активных архивов',
	'Module Settings' => 'Параметры модуля',
	'Server Side Includes' => 'Включение на стороне сервера (SSI)',
	'None (disabled)' => 'Нет (отключено)',
	'PHP Includes' => 'PHP-включение',
	'Apache Server-Side Includes' => 'Apache - включение на стороне сервера',
	'Active Server Page Includes' => 'ASP-включение',
	'Java Server Page Includes' => 'JSP-включение',
	'Module Caching' => 'Модуль кэширования',
	'Allow properly configured template modules to be cached to enhance publishing performance.' => 'Позволяет указывать у модульных шаблонов время кеширования, чтобы повысить производительность публикации.',
	'Revision History' => 'Ревизии',
	'Note: Revision History is currently disabled at the system level.' => 'Примечание: история изменений в настоящее время отключена на системном уровне.',
	'Revision history' => 'История изменений',
	'Enable revision history' => 'Включить историю изменений',
	'Number of revisions per entry/page' => 'Количество изменений для записи/страницы',
	'Number of revisions per page' => 'Количество изменений для страницы',
	'Number of revisions per template' => 'Количество изменений для шаблона',
	'You must set your Blog Name.' => 'Необходимо указать имя блога.',
	'You did not select a time zone.' => 'Вы не выбрали временную зону',
	'You must set a valid URL.' => 'Необходимо указать правильный URL.',
	'You must set your Local file Path.' => 'Необходимо указать локальный путь к файлам.',
	'You must set a valid Local file Path.' => 'Необходимо указать правильный путь к файлам.',
	'You must set a valid Archive URL.' => 'Необходимо указать правильный URL архива.',
	'You must set your Local Archive Path.' => 'Необходимо указать локальный путь архива.',
	'You must set a valid Local Archive Path.' => 'Необходимо указать правильный локальный путь архива.',

## tmpl/cms/cfg_registration.tmpl
	'Registration Settings' => 'Настройка регистрации',
	'Your blog preferences have been saved.' => 'Параметры блога сохранены.',
	'User Registration' => 'Регистрация пользователей',
	'Allow registration for this website.' => 'Разрешить регистрацию на этом сайте.',
	'Registration Not Enabled' => 'Регистрация запрещена',
	'Note: Registration is currently disabled at the system level.' => 'Внимание: регистрация запрещена на системном уровне.',
	'Allow visitors to register as members of this website using one of the Authentication Methods selected below.' => 'Разрешить посетителям регистрироваться как пользователям на этом сайте, используя методы авторизации, указанные ниже.',
	'New Created User' => 'Создать нового пользователя',
	'Select a role that you want assigned to users that are created in the future.' => 'Выберите роль, которая будет автоматически назначаться для пользователей в будущем.',
	'(No role selected)' => '(Роль не выбрана)',
	'Select roles' => 'Выберите роль',
	'Authentication Methods' => 'Методы авторизации',
	'The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.' => 'Для авторизации комментаторов посредством OpenID требуется Perl-модуль Digest::SHA1, но он отсутствует.',
	'Please select authentication methods to accept comments.' => 'Выберите методы авторизации в комментариях.',
	'Require E-mail Address for Comments via TypePad' => 'Требовать email для авторизовавшихся через TypePad',
	'Visitors must allow their TypePad account to share their e-mail address when commenting.' => 'Посетители должны разрешить в своём TypePad-аккаунте предоставление адреса электронной почты при комментировании.',
	'One or more Perl modules may be missing to use this authentication method.' => 'Один или несколько Perl-модулей отсутствуют для этого метода авторизации',
	'Setup TypePad token' => 'Установить токен TypePad',

## tmpl/cms/cfg_system_general.tmpl
	'A test email was sent.' => 'Тестовое письмо отправлено.',
	'Your settings have been saved.' => 'Ваши параметры сохранены.',
	'System Email' => 'Системный email',
	q{This email address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, and a few other minor events.} => q{С этого адреса будут отправляться все уведомления Movable Type (например: восстановление пароля, регистрация комментатора, новый комментарий или трекбэк.},
	'Send Test Email' => 'Отправить тестовое письмо',
	'Debug Mode' => 'Режим отладки',
	'Values other than zero provide additional diagnostic information for troubleshooting problems with your Movable Type installation.  More information is available in the <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">Debug Mode documentation</a>.' => 'Значение, отличное от нуля. Режим отладки позволяет выявить различные проблемы при работе с Movable Type. Подробная информация о <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">режиме отладки</a>.',
	'Performance Logging' => 'Журналирование производительности',
	'Turn on performance logging, which will report any system event that takes the number of seconds specified by Logging Threshold.' => 'Активирует запись журнала производительности, в который будут попадать все события, выполняющиеся более указанного в «Лимит журнала» количества секунд.',
	'Turn on performance logging' => 'Активировать логирование производительности',
	'Log Path' => 'Размещение логов',
	'The filesystem directory where performance logs are written.  The web server must have write permission in this directory.' => 'Директория, где будут размещаться журналы производительности. Директория должна быть доступна для записи.',
	'Logging Threshold' => 'Лимит журнала',
	'The time limit for unlogged events in seconds. Any event that takes this amount of time or longer will be reported.' => 'Ограничение событий по времени в секундах. Любое событие, которые выполняется указанное время или более, будет записано в журнал.',
	'Enable this setting to have Movable Type track revisions made by users to entries, pages and templates.' => 'Активируйте эту настройку, чтобы пользователи могли использовать истории изменений для записей, страниц и шаблонов.',
	'Track revision history' => 'Отслеживать историю изменений',
	'System-wide Feedback Controls' => 'Глобальный контроль за обратной связью',
	'Prohibit Comments' => 'Запретить комментарии',
	'This will override all individual blog settings.' => 'Эта опция переопределит все индивидуальные параметры блогов.',
	'Disable comments for all blogs.' => 'Отключить комментарии во всех блогах.',
	'Prohibit TrackBacks' => 'Запретить трекбэки',
	'Disable receipt of TrackBacks for all blogs.' => 'Запретить приём трекбэков во всех блогах.',
	'Outbound Notifications' => 'Исходящие уведомления',
	'Prohibit Notification Pings' => 'Запретить отправку уведомлений (пингов)',
	'Disable sending notification pings when a new entry is created in any blog on the system.' => 'Запретить отправку уведомлений, когда создаётся новая запись в любом из блогов системы.',
	'Disable notification pings for all blogs.' => 'Отключить уведомления (пинги) во всех блогах.',
	'Send Outbound TrackBacks to' => 'Отправлять трекбэки в',
	'Do not send outbound TrackBacks or use TrackBack auto-discovery if your installation is intended to be private.' => 'Не отправлять трекбэки и не использовать автообнаружение трекбэков, если ваша система используется как приватная.',
	'Any site' => 'Любой сайт',
	'(No Outbound TrackBacks)' => '(Нет исходящих трекбэков)',
	'Only to blogs within this system' => 'Только для блогов в этой системе',
	'Only to websites on the following domains:' => 'Только для сайтов на следующих доменах:',
	'Send Email To' => 'Отправить сообщение на',
	'The email address that should receive a test email from Movable Type.' => 'Адрес электронной почты, на который будет отправлено тестовое письмо от Movable Type.',
	'Send' => 'Отправить',

## tmpl/cms/cfg_system_users.tmpl
	'User Settings' => 'Параметры пользователя',
	'(No website selected)' => '(Не выбран сайт)',
	'Select website' => 'Выбрать сайт',
	'(None selected)' => '(Ничего не выбрано)',
	'Allow Registration' => 'Разрешить регистрацию',
	'Select a system administrator you wish to notify when commenters successfully registered themselves.' => 'Выберите администратора, которого вы хотите уведомить о новых зарегистрированных комментаторах.',
	'Allow commenters to register with blogs on this system.' => 'Разрешить комментаторам регистрироваться в блогах этой системы.',
	'Notify the following system administrators when a commenter registers:' => 'Уведомлять следующих администраторов при регистрации комментатора:',
	'Clear' => 'Очистить',
	'Select system administrators' => 'Выбрать системного администратора',
	'Note: System Email Address is not set in System > General Settings. Emails will not be sent.' => 'Примечание: системный адрес электронной почты не указан в Система > Основные параметры. Письма не будут отправляться.',
	'New User Defaults' => 'Параметры по умолчанию для новых пользователей',
	'Personal Blog' => 'Персональный блог',
	'Have the system automatically create a new personal blog when a user is created. The user will be granted the blog administrator role on this blog.' => 'Movable Type может автоматически создавать новый персональный блог для созданного пользователя. Этот пользователь получит права администратора созданного блога.',
	'Automatically create a new blog for each new user.' => 'Автоматическое создание блога для каждого нового пользователя.',
	'Personal Blog Location' => 'Размещение персонального блога',
	'Select a website you wish to use as the location of new personal blogs.' => 'Выберите сайт, в котором будут размещаться новые персональные блоги.',
	'Change website' => 'Изменить сайт',
	'Personal Blog Theme' => 'Тема персонального блога',
	'Select the theme that should be used for new personal blogs.' => 'Выберите тему, которая будет использована в новых персональных блогах.',
	'(No theme selected)' => '(Тема не выбрана)',
	'Change theme' => 'Изменить тему',
	'Select theme' => 'Выбрать тему',
	'Default User Language' => 'Язык по умолчанию для пользователей',
	'Choose the default language to apply to all new users.' => 'Выберите язык по умолчанию для новых пользователей.',
	'Default Time Zone' => 'Временная зона по умолчанию',
	'Default Tag Delimiter' => 'Разделитель тегов по умолчанию',
	'Define the default delimiter for entering tags.' => 'Укажите разделитель тегов по умолчанию.',
	'Comma' => 'Запятая',
	'Space' => 'Пробел',

## tmpl/cms/cfg_web_services.tmpl
	'Web Services Settings' => 'Настройка веб-сервисов',
	'Web Services from Six Apart' => 'Веб-сервисы от Six Apart',
	'Your TypePad token is used to access services from Six Apart like TypePad Connect and TypePad AntiSpam.' => 'Ваш токен TypePad используется для доступа к сервисам Six Apart (например, TypePad Connect или TypePad AntiSpam).',
	'TypePad is enabled.' => 'TypePad включен',
	'TypePad token:' => 'TypePad-токен:',
	'Clear TypePad Token' => 'Сбросить TypePad-токен',
	'Please click the Save Changes button below to disable authentication.' => 'Пожалуйста, сохраните изменения, чтобы отключить авторизацию.',
	'TypePad is not enabled.' => 'TypePad не активирован',
	'&nbsp;or&nbsp;[_1]obtain a TypePad token[_2] from TypePad.com.' => '&nbsp;или&nbsp;[_1]получить TypePad-токен[_2] от TypePad.com.',
	q{Please click the 'Save Changes' button below to enable TypePad.} => q{Пожалуйста, нажмите «Сохранить изменения», чтобы активировать TypaPad.},
	'External Notifications' => 'Внешние уведомления',
	'Notify ping services of website updates' => 'Уведомления различных сервисов об обновлениях на сайте',
	'When this website is updated, Movable Type will automatically notify the selected sites.' => 'Когда на этом сайте появится новый контент, Movable Type автоматически отправит уведомление на выбранные сервисы.',
	'Note: This option is currently ignored because outbound notification pings are disabled system-wide.' => 'Примечание: в настоящее время эта опция игнорируется, так как отправка пингов отключена на системном уровне.',
	'Others:' => 'Другие:',
	'(Separate URLs with a carriage return.)' => '(Разделяйте URL переводом строки.)',
	'Recently Updated Key' => 'Ключ для последних обновлений',
	'If you received a Recently Updated Key with the purchase of a Movable Type license, enter it here.' => 'Если у вас есть «Recently Updated Key», который вы могли получить при покупке лицензии Movable Type, можете указать его здесь.',

## tmpl/cms/dashboard.tmpl
	'Dashboard' => 'Обзорная панель',
	'System Overview' => 'Обзор',
	'Hi, [_1]' => 'Привет, [_1]',
	'Select a Widget...' => 'Выбрать виджет…',
	'Add' => 'Добавить',
	'Your Dashboard has been updated.' => 'Ваша обзорная панель обновлена.',
	'The support directory is not writable.' => 'Директория support не имеет прав на запись.',
	q{Movable Type was unable to write to its 'support' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.} => q{Movable Type не удалось записать файлы в в папку «support». Пожалуйста, создайте эту папку в этой директории: [_1]. После этого сделайте папку support перезаписываемой.},
	'ImageDriver is not configured.' => 'ImageDriver не настроен.',
	'An image processing toolkit, often specified by the ImageDriver configuration directive, is not present on your server or is configured incorrectly. A toolkit must be installed to ensure proper operation of the userpics feature. Please install Image::Magick, NetPBM, GD, or Imager, then set the ImageDriver configuration directive accordingly.' => 'Инструмент для работы с изображениями, который может быть определён через конфигурационную директиву ImageDriver, отсутствует или неправильно настроен. Для правильной работы с изображениями необходимо установить одно из следующих ПО: Image::Magick, NetPBM, GD, или Imager, а затем указать соответствующую директиву в mt-config.cgi.',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Confirm Publishing Configuration' => 'Подтверждение настроек публикации',
	'Site Path' => 'Путь сайта',
	'Parent Website' => 'Родительский сайт',
	'Please choose parent website.' => 'Пожалуйста, выберите родительский сайт.',
	q{Enter the new URL of your public blog. End with '/'. Example: http://www.example.com/blog/} => q{Введите новый URL блога. Адрес должен заканчиваться на '/'. Пример: http://example.com/blog/},
	'Blog Root' => 'Директория блога',
	q{Enter the new path where your main index file will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Введите новый путь, где будут публиковаться индексные файлы. Путь не должен заканчиваться на '/' или '\'. Пример: /home/mt/public_html/blog или C:\www\public_html\blog},
	q{Enter the new path where your main index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Введите новый путь, где будут публиковаться индексные файлы. Рекомендуется использовать абсолютный путь (в Linux начинается на '/', а в Windows на 'C:\'). Пример: /home/mt/public_html/blog или C:\www\public_html\blog},
	'Enter the new URL of the archives section of your blog. Example: http://www.example.com/blog/archives/' => 'Введите новый URL для архивов вашего блога. Пример: http://example.com/blog/archives/',
	q{Enter the new path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Введите новый путь, где будут публиковаться архивы. Путь не должен заканчиваться на '/' или '\'. Пример: /home/mt/public_html/blog или C:\www\public_html\blog},
	q{Enter the new path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Введите новый путь, где будут публиковаться архивы. Рекомендуется использовать абсолютный путь (в Linux начинается на '/', а в Windows на 'C:\'). Пример: /home/mt/public_html/blog или C:\www\public_html\blog},
	'Continue' => 'Продолжить',
	'Continue (s)' => 'Продолжить (s)',
	'Back (b)' => 'Вернуться (b)',
	'You must set a valid Site URL.' => 'Необходимо ввести корректный URL сайта.',
	'You must set a valid Local Site Path.' => 'Необходимо установить локальный путь на сайте.',
	'You must select a parent website.' => 'Необходимо выбрать родительский сайт.',

## tmpl/cms/dialog/asset_insert.tmpl
	'Close (x)' => 'Закрыть (x)',

## tmpl/cms/dialog/asset_list.tmpl
	'Insert Image' => 'Вставить изображение',
	'Insert Asset' => 'Вставить медиа',
	'Upload New File' => 'Загрузить новый файл',
	'Upload New Image' => 'Загрузить новое изображение',
	'Asset Name' => 'Имя медиа',
	'Size' => 'Размер',
	'Next (s)' => 'Следующий (s)',
	'Insert (s)' => 'Вставить (s)',
	'Insert' => 'Вставить',
	'Cancel (x)' => 'Отмена (x)',
	'No assets could be found.' => 'Медиа объекты не найдены.',

## tmpl/cms/dialog/asset_options_image.tmpl
	'Display image in entry/page' => 'Показать изображение в записи/странице',
	'Use thumbnail' => 'Использовать уменьшенное изображение',
	'width:' => 'ширина:',
	'pixels' => 'px', # Translate - No russian chars
	'Alignment' => 'Выравнивание',
	'Left' => 'По левому краю',
	'Center' => 'По центру',
	'Right' => 'По правому краю',
	'Link image to full-size version in a popup window.' => 'Ссылка на полноразмерное изображение в новом окне',
	'Remember these settings' => 'Запомнить эти параметры',

## tmpl/cms/dialog/asset_options.tmpl
	'File Options' => 'Опции файла',
	'Create entry using this uploaded file' => 'Создать запись с загруженным файлом',
	'Create a new entry using this uploaded file.' => 'Создать новую запись с загруженным файлом.',
	'Finish (s)' => 'Завершить (s)',
	'Finish' => 'Завершить',

## tmpl/cms/dialog/asset_upload.tmpl
	'You need to configure your blog.' => 'Вам необходимо сконфигурировать блог.',
	'Your blog has not been published.' => 'Ваш блог не был опубликован.',

## tmpl/cms/dialog/clone_blog.tmpl
	'Blog Details' => 'Детали блога',
	'This is set to the same URL as the original blog.' => 'Это значение взято из первоначального блога',
	'This will overwrite the original blog.' => 'Это перезапишет оригинальный блог',
	'Exclusions' => 'Исключения',
	'Exclude Entries/Pages' => 'Исключить записи/страницы',
	'Exclude Comments' => 'Исключить комментарии',
	'Exclude Trackbacks' => 'Исключить трекбэки',
	'Exclude Categories/Folders' => 'Исключить категории/папки',
	'Clone' => 'Клонировать',
	'Mark the settings that you want cloning to skip' => 'Выберите элементы, которые вы хотите исключить из клонирования',
	'Entries/Pages' => 'Записи/Страницы',
	'Categories/Folders' => 'Категории/папки',
	'Confirm' => 'Подтвердить',

## tmpl/cms/dialog/comment_reply.tmpl
	'Reply to comment' => 'Ответить на комментарий',
	'On [_1], [_2] commented on [_3]' => '[_1], [_2] комментировал(а) [_3]',
	'Your reply:' => 'Ваш ответ:',
	'Submit reply (s)' => 'Отправить ответ (s)',

## tmpl/cms/dialog/create_association.tmpl
	'No roles exist in this installation. [_1]Create a role</a>' => 'В данной инсталляции нет ролей. [_1]Создать роль</a>',
	'No groups exist in this installation. [_1]Create a group</a>' => 'В данной инсталляции нет групп. [_1]Создать группу</a>',
	'No users exist in this installation. [_1]Create a user</a>' => 'В данной инсталляции нет пользователей [_1]Создать пользователя</a>',
	'No blogs exist in this installation. [_1]Create a blog</a>' => 'В данной инсталляции нет блогов. [_1]Создать блог</a>',

## tmpl/cms/dialog/entry_notify.tmpl
	'Send a Notification' => 'Отправить по почте',
	'You must specify at least one recipient.' => 'Вы должны указать как минимум одного адресата.',
	q{Your [_1]'s name, title, and a link to view it will be sent in the notification. Additionally, you can add a message, include an excerpt and/or send the entire body.} => q{Ваше имя [_1], заголовок и ссылка на просмотр будет добавлена в уведомление. Также вы можете добавить сообщение, включить выдержку и/или отправить тело сообщения.},
	'Recipients' => 'Адресаты',
	'Enter email addresses on separate lines or separated by commas.' => 'Введите адреса электронной почты, разделяя их запятыми, либо по одному на каждой строке.',
	'All addresses from Address Book' => 'Все адреса из адресной книги',
	'Optional Message' => 'Дополнительное сообщение',
	'Optional Content' => 'Дополнительное содержание',
	'(Body will be sent without any text formatting applied.)' => '(Тело сообщения будет отправлено без какого-либо форматирования.)',
	'Send notification (s)' => 'Отправить уведомление (s)',

## tmpl/cms/dialog/list_revision.tmpl
	'Select the revision to populate the values of the Edit screen.' => 'Выберите версию, которая будет использована в редакторе',

## tmpl/cms/dialog/move_blogs.tmpl
	'Warning: You need to copy uploaded assets to the new path manually. It is also recommended not to delete files in the old path to avoid broken links.' => 'Внимание: вам необходимо скопировать загруженное медиа в новое место вручную. Кроме того, рекомендуется не удалять старые файлы, чтобы избежать появления ошибочных ссылок.',

## tmpl/cms/dialog/new_password.tmpl
	'Change Password' => 'Изменить пароль',
	'New Password' => 'Новый пароль',
	'Confirm New Password' => 'Подтверждение нового пароля',
	'Change' => 'изменить',

## tmpl/cms/dialog/publishing_profile.tmpl
	'Publishing Profile' => 'Профиль публикации',
	'Choose the profile that best matches the requirements for this blog.' => 'Выберите профиль, наиболее подходящий вашему блогу.',
	'Static Publishing' => 'Статическая публикация',
	'Immediately publish all templates statically.' => 'Немедленная публикация всех шаблонов на сервере.',
	'Background Publishing' => 'Фоновая публикация',
	'All templates published statically via Publish Que.' => 'Все шаблоны публикуются на сервере с использованием очереди публикации.',
	'High Priority Static Publishing' => 'Высокоприоритетная статическая публикация',
	'Immediately publish Main Index template, Entry archives, and Page archives statically. Use Publish Queue to publish all other templates statically.' => 'На сервере немедленно публикуются главная страница, архивы записей и индивидуальные страницы. Чтобы опубликовать другие шаблоны, необходимо использовать очередь публикации.',
	'Immediately publish Main Index template, Page archives statically. Use Publish Queue to publish all other templates statically.' => 'Немедленно публикуется главная страница и архивы. Чтобы опубликовать другие шаблоны, необходимо использовать очередь публикации.',
	'Dynamic Publishing' => 'Динамическая публикация',
	'Publish all templates dynamically.' => 'Публиковать все шаблоны динамически',
	'Dynamic Archives Only' => 'Только динамические архивы',
	'Publish all Archive templates dynamically. Immediately publish all other templates statically.' => 'Все шаблоны архивов публикуются динамически. Все остальные шаблоны немедленно публикуются на сервере.',
	'This new publishing profile will update your publishing settings.' => 'Этот новый профиль публикации обновит текущие параметры публикации.',
	'Are you sure you wish to continue?' => 'Вы уверены, что хотите продолжить?',

## tmpl/cms/dialog/recover.tmpl
	'Reset Password' => 'Сбросить пароль',
	'The email address provided is not unique.  Please enter your username.' => 'Email-адрес не является уникальным. Пожалуйста, введите своё имя пользователя.',
	'An email with a link to reset your password has been sent to your email address ([_1]).' => 'На адрес [_1] отправлено письмо, содержащее ссылку для сброса пароля.',
	'Back (x)' => 'Назад',
	'Sign in to Movable Type (s)' => 'Авторизация в Movable Type (s)',
	'Sign in to Movable Type' => 'Авторизация в Movable Type',
	'Reset (s)' => 'Сброс (s)',

## tmpl/cms/dialog/refresh_templates.tmpl
	'Refresh Global Templates' => 'Восстановить глобальные шаблоны',
	'Cannot find template set. Please apply [_1]theme[_2] to refresh your templates.' => 'Не удалось найти связку шаблонов. Пожалуйста, примените [_1]тему[_2], чтобы обновить ваши шаблоны.',
	'Revert modifications of theme templates' => 'Откатить изменения в шаблонах темы',
	'Reset to theme defaults' => 'Сбросить тему до значений по умолчанию',
	q{Deletes all existing templates and install the selected theme's default.} => q{Удаление всех существующих шаблонов и установка выбранной темы.},
	'Refresh global templates' => 'Восстановить глобальные шаблоны',
	'Reset to factory defaults' => 'Возврат к установкам по умолчанию',
	'Deletes all existing templates and installs factory default template set.' => 'Удаление всех существующих шаблонов и установка стандартной связки шаблонов.',
	'Updates current templates while retaining any user-created templates.' => 'Обновление текущих шаблонов с сохранением любых шаблонов, созданных пользователем.',
	'Make backups of existing templates first' => 'Сделать резервную копию существующих шаблонов',
	'You have requested to <strong>refresh the current template set</strong>. This action will:' => 'Вы хотите <strong>обновить текущую связку шаблонов</strong>. Это действие выполнит:',
	'You have requested to <strong>refresh the global templates</strong>. This action will:' => 'Вы хотите <strong>обновить глобальные шаблоны</strong>. Это действие выполнит:',
	'make backups of your templates that can be accessed through your backup filter' => 'будет сделана резервная копия шаблонов, которые можно будет посмотреть в специальном разделе',
	'potentially install new templates' => 'возможно, будут установлены новые шаблоны',
	'overwrite some existing templates with new template code' => 'перезаписать некоторые существующие шаблоны новыми',
	'You have requested to <strong>apply a new template set</strong>. This action will:' => 'Вы хотите <strong>применить новую связку шаблонов</strong>. Это действие выполнит:',
	'You have requested to <strong>reset to the default global templates</strong>. This action will:' => 'Вы хотите <strong>вернуться к стандартным глобальным шаблонам</strong>. Это действие выполнит:',
	'delete all of the templates in your blog' => 'удалит все шаблоны вашего блога',
	'install new templates from the selected template set' => 'установит новые шаблоны из выбранной связки шаблонов',
	'delete all of your global templates' => 'удалит все глобальные глобальные шаблоны',
	'install new templates from the default global templates' => 'установит новые, используя стандартные глобальные шаблоны',

## tmpl/cms/dialog/restore_end.tmpl
	'An error occurred during the restore process: [_1] Please check your restore file.' => 'Ошибка в процессе восстановления: [_1] Пожалуйста, проверьте файл.',
	'View Activity Log (v)' => 'Посмотреть журнал активности (v)',
	'All data restored successfully!' => 'Все данные восстановлены успешно!',
	'Close (s)' => 'Закрыть (s)',
	'Next Page' => 'Следующая страница',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => 'Через 3 секунды вы будете перенаправлены на новую страницу. [_1]Остановить переход.[_2]',

## tmpl/cms/dialog/restore_start.tmpl
	'Restoring...' => 'Восстановление…',

## tmpl/cms/dialog/restore_upload.tmpl
	'Restore: Multiple Files' => 'Восстановить : Несколько файлов',
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => 'Отмена процесса приведет к возникновению объектов-сирот. Вы уверены, что хотите остановить процесс восстановления?',
	'Please upload the file [_1]' => 'Пожалуйста, загрузите файл [_1]',

## tmpl/cms/dialog/select_association_type.tmpl
	'Grant website permission to a user' => 'Предоставить пользователю права на сайте',
	'Grant blog permission to a user' => 'Предоставить пользователю права в блоге',
	'Grant website permission to a group' => 'Предоставить права на сайт группе',
	'Grant blog permission to a group' => 'Предоставить права на блог группе',

## tmpl/cms/dialog/select_theme.tmpl
	'Select Personal blog theme' => 'Выберите персональную тему блога',
	'Select' => 'Выбрать',

## tmpl/cms/edit_asset.tmpl
	'Edit Asset' => 'Редактирование медиа',
	'Your changes have been saved.' => 'Изменения сохранены.',
	'Stats' => 'Статистика',
	'[_1] - Created by [_2]' => '[_1] — создано пользователем [_2]',
	'[_1] - Modified by [_2]' => '[_1] — изменено пользователем [_2]',
	'Appears in...' => 'Используется в…',
	'This asset has been used by other users.' => 'Это медиа используется другими пользователями',
	'Related Assets' => 'Похожее медиа',
	'[_1] is missing' => '[_1] не найдено',
	'Embed Asset' => 'Встроить медиа',
	'Save changes to this asset (s)' => 'Сохранить изменения этого медиа (s)',
	'You must specify a name for the asset.' => 'Необходимо указать имя для этого медиа',

## tmpl/cms/edit_author.tmpl
	'Edit Profile' => 'Редактировать профиль',
	'This profile has been updated.' => 'Профиль обновлён.',
	'A new password has been generated and sent to the email address [_1].' => 'Новый пароль был сгенеририрован и отправлен на email [_1].',
	'This user was classified as pending.' => 'Пользователь классифицирован как ожидающий.',
	'This user was classified as disabled.' => 'Пользователь классифицирован как отключенный.',
	'User properties' => 'Свойства пользователя',
	'Your web services password is currently' => 'Текущий пароль для веб-сервисов',
	'_WARNING_PASSWORD_RESET_SINGLE' => 'Вы собираетесь изменить пароль для пользователя «[_1]». Новый пароль будет сгенерирован автоматически и отправлен на адрес пользователя ([_2]). Продолжить?',
	'Error occurred while removing userpic.' => 'Произошло ошибка при удалении аватара.',
	'_USER_STATUS_CAPTION' => 'Статус пользователя',
	'Status of user in the system. Disabling a user prevents that person from using the system but preserves their content and history.' => 'Статус пользователя в системе. Отключение пользователей позволяет заблокировать им доступ в систему, при этом сохраняется их контент и история.',
	'_USER_ENABLED' => 'Пользователь активен',
	'_USER_PENDING' => 'Неподтверждённый пользователь',
	'_USER_DISABLED' => 'Отключенный пользователь',
	'The username used to login.' => 'Имя пользователя используется для входа.',
	'External user ID' => 'Внешний ID пользователя',
	'The name displayed when content from this user is published.' => 'Имя отображается, когда контент этого пользователя публикуется.',
	'The email address associated with this user.' => 'Email, связанный с этим пользователем.',
	q{This User's website (e.g. http://www.movabletype.com/).  If the Website URL and Display Name fields are both populated, Movable Type will by default publish entries and comments with bylines linked to this URL.} => q{Адрес сайта пользователя (например, http://movable-type.ru/). Если URL сайта и отображаемое имя заполнены, то Movable Type будет по умолчанию публиковать имя пользователя со ссылкой с него на указанный сайт.},
	'The image associated with this user.' => 'Картинка, связанная с этим пользователем.',
	'Select Userpic' => 'Выбрать аватар',
	'Remove Userpic' => 'Удалить аватар',
	'Current Password' => 'Текущий пароль',
	'Existing password required to create a new password.' => 'Для изменения пароля необходимо ввести текущий пароль.',
	'Initial Password' => 'Пароль',
	'Enter preferred password.' => 'Введите предпочтительный пароль.',
	'Enter the new password.' => 'Введите новый пароль.',
	'Confirm Password' => 'Подтвердите пароль',
	'Repeat the password for confirmation.' => 'Введите пароль повторно.',
	'Password recovery word/phrase' => 'Слово или фраза для восстановления пароля',
	'This word or phrase is not used in the password recovery.' => 'Это слово или фраза не используется для восстановления пароля.',
	'Preferences' => 'Параметры',
	'Language' => 'Язык',
	'Display language for the Movable Type interface.' => 'Язык интерфейса Movable Type',
	'Text Format' => 'Форматирование текста',
	'Default text formatting filter when creating new entries and new pages.' => 'Форматирование текста по умолчанию для новых записей и страниц.',
	'(Use Website/Blog Default)' => '(Использовать параметры сайта/блога)',
	'Date Format' => 'Формат даты',
	'Default date formatting in the Movable Type interface.' => 'Формат даты в интерфейсе Movable Type.',
	'Relative' => 'Относительный',
	'Full' => 'Полный',
	'Tag Delimiter' => 'Разделитель тегов',
	'Preferred method of separating tags.' => 'Предпочтительный метод для разделения тегов.',
	'Web Services Password' => 'Пароль для веб-сервисов',
	'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'Для использования XML-RPC или Atom клиентов (блогинг-редакторы, к примеру).',
	'Reveal' => 'Показать',
	'System Permissions' => 'Администраторские полномочия',
	'Options' => 'Опции',
	'Create personal blog for user' => 'Создать персональный блог для пользователя',
	'Create User (s)' => 'Создать пользователя (s)',
	'Save changes to this author (s)' => 'Сохранить изменения этого автора (s)',
	'_USAGE_PASSWORD_RESET' => 'Вы можете изменить пароль пользователя. Если вы это сделаете, пароль будет сгенерирован автоматически и отправлен пользователю на email [_1].',
	'Initiate Password Recovery' => 'Начать восстановление пароля',

## tmpl/cms/edit_blog.tmpl
	'Create Blog' => 'Создать блог',
	'Your blog configuration has been saved.' => 'Конфигурация блога сохранена.',
	'Blog Theme' => 'Тема блога',
	'Select the theme you wish to use for this blog.' => 'Выберите тему, которую вы хотите использовать в этом блоге.',
	'Name your blog. The blog name can be changed at any time.' => 'Дайте имя вашему блогу. В дальнейшем оно может быть изменено в любой момент.',
	'Enter the URL of your Blog. Exclude the filename (i.e. index.html). Example: http://www.example.com/blog/' => 'Введите URL блога, исключая имя файлов (например, index.html). Пример: http://example.com/blog/',
	q{The path where your index files will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{Место, где располагаются индексные файлы. Путь не должен заканчиваться на '/' или '\'. Пример: /home/mt/public_html/blog или C:\www\public_html\blog},
	q{The path where your index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{Место, где располагаются индексные файлы. Рекомендуется использовать абсолютный путь (в Linux начинается на '/', а в Windows на 'C:\').  Путь не должен заканчиваться на '/' или '\'. Пример: /home/mt/public_html или C:\www\public_html},
	'Select your timezone from the pulldown menu.' => 'Выберите часовой пояс из выпадающего меню.',
	'If you choose a different language than the default language defined at the system level, you may need to change module names in certain templates to include different global modules.' => 'Если вы выберете язык, отличающийся от системного, то вам, возможно, потребуется переименовать некоторые модульные шаблоны, включая глобальные.',
	'Create Blog (s)' => 'Создать блог (s)',
	'You must set your Local Site Path.' => 'Необходимо ввести локальный путь на сайте.',

## tmpl/cms/edit_category.tmpl
	'Edit Category' => 'Редактировать категорию',
	'Useful links' => 'Полезные ссылки',
	'Manage entries in this category' => 'Управление записями в этой категории',
	'You must specify a label for the category.' => 'Необходимо указать имя категории.',
	'You must specify a basename for the category.' => 'Необходимо указать базовое имя для категории',
	'Please enter a valid basename.' => 'Пожалуйста, укажите правильное базовое имя',
	'_CATEGORY_BASENAME' => 'Базовое имя',
	'This is the basename assigned to your category.' => 'Это — базовое имя категории.',
	q{Warning: Changing this category's basename may break inbound links.} => q{Внимание: если вы измените базовое имя категории, то потеряете входящие ссылки на неё.},
	'Inbound TrackBacks' => 'Входящие трекбэки',
	'If enabled, TrackBacks will be accepted for this category from any source.' => 'Если эта опция активна, трекбэки для этой категории будут приниматься от любого источника.',
	'View TrackBacks' => 'Просмотр трекбэков',
	'TrackBack URL for this category' => 'URL трекбэка для этой категории',
	'_USAGE_CATEGORY_PING_URL' => 'Имеется в виду URL, который читатели используют для отправки трекбэков к записям вашего блога. Если вы желаете позволить всем вашим читателям отправлять трекбэки, опубликуйте этот URL. Если вы хотите, чтобы только избранные читатели могли отправлять трекбэки, сообщите им URL в частном порядке. И, наконец, чтобы включить список поступивших трекбэков на главной странице, ознакомьтесь с документацией по тегам шаблонов, связанных с трекбэками.',
	'Passphrase Protection' => 'Passphrase Protection', # Translate - Not translated
	'Outbound TrackBacks' => 'Исходящие трекбэки',
	'Trackback URLs' => 'URL-ы трекбэков',
	'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you create an entry in this category. (Separate URLs with a carriage return.)' => 'Перечислите адреса сайтов, на которые вы хотите отправить трекбэки, каждый раз, когда вы создаёте запись. (К качестве разделителя используйте перевод строки.)',
	'Save changes to this category (s)' => 'Сохранить изменения категории (s)',

## tmpl/cms/edit_commenter.tmpl
	'Commenter Details' => 'Информация о комментаторе',
	'The commenter has been trusted.' => 'Комментатор сделан доверенным.',
	'The commenter has been banned.' => 'Комментатор заблокирован.',
	'Comments from [_1]' => 'Комментарии от [_1]',
	'commenter' => 'комментатор',
	'commenters' => 'комментаторы',
	'to act upon' => 'действует в соответствии с',
	'Trust user (t)' => 'Сделать доверенным (t)',
	'Trust' => 'Доверенный',
	'Untrust user (t)' => 'Перестать доверять (t)',
	'Untrust' => 'Не доверенный',
	'Ban user (b)' => 'Заблокировать пользователя (b)',
	'Ban' => 'Заблокировать',
	'Unban user (b)' => 'Разблокировать пользователя (b)',
	'Unban' => 'Разблокировать',
	'The Name of the commenter' => 'Имя комментатора',
	'View all comments with this name' => 'Посмотреть все комментарии с этим именем',
	'Identity' => 'Идентификатор',
	'The Identity of the commenter' => 'Идентификатор комментатора',
	'View' => 'Просмотр',
	'The Email Address of the commenter' => 'Адрес электронной почты комментатора',
	'Withheld' => 'Не предоставлено',
	'View all comments with this email address' => 'Показать все комментарии с этим email',
	'The Website URL of the commenter' => 'Сайт комментатора',
	'The trusted status of the commenter' => 'Статус доверенного у комментатора',
	'Trusted' => 'Доверенный',
	'Authenticated' => 'Авторизованные',

## tmpl/cms/edit_comment.tmpl
	'The comment has been approved.' => 'Комментарий принят.',
	'This comment was classified as spam.' => 'Комментарий классифицирован как спам.',
	'Total Feedback Rating: [_1]' => 'Общий рейтинг: [_1]',
	'Test' => 'Тест',
	'Score' => 'Баллы',
	'Results' => 'Результаты',
	'Save changes to this comment (s)' => 'Сохранить изменения комментария (s)',
	'comment' => 'комментарий',
	'comments' => 'комментарии',
	'Delete this comment (x)' => 'Удалить комментарий (x)',
	'Manage Comments' => 'Управление комментариями',
	'_external_link_target' => '_blank', # Translate - No russian chars
	'View [_1] comment was left on' => 'Просмотр [_1] оставленного комментария к',
	'Reply to this comment' => 'Ответить на этот комментарий',
	'Update the status of this comment' => 'Обновить статус этого комментария',
	'Reported as Spam' => 'Спам',
	'View all comments with this status' => 'Все комментарии с данным статусом',
	'The name of the person who posted the comment' => 'Имя автора комментария',
	'View all comments by this commenter' => 'Посмотреть все комментарии этого автора',
	'View this commenter detail' => 'Посмотреть информацию о комментаторе',
	'(Trusted)' => '(Доверенный)',
	'Untrust Commenter' => 'Исключить автора из списка доверенных',
	'Ban Commenter' => 'Заблокировать автора комментария',
	'(Banned)' => '(Заблокирован)',
	'Trust Commenter' => 'Занести в список надежных',
	'Unban Commenter' => 'Разблокировать автора комментария',
	'(Pending)' => '(Ожидает)',
	'Email address of commenter' => 'Email адрес автора комментария',
	'Unavailable for OpenID user' => 'Недоступно для OpenID пользователей',
	'Email' => 'Email', # Translate - Not translated
	'URL of commenter' => 'URL автора комментария',
	'No url in profile' => 'Нет URL в профиле',
	'View all comments with this URL' => 'Показать все комментарии с этого URL',
	'[_1] this comment was made on' => '[_1] этот комментарий оставлен',
	'[_1] no longer exists' => '[_1] не существует',
	'View all comments on this [_1]' => 'Посмотреть все комментарии к [_1]',
	'Date' => 'Дата',
	'Date this comment was made' => 'Дата отправки комментария',
	'View all comments created on this day' => 'Показать все комментарии оставленные в этот день',
	'IP Address of the commenter' => 'IP адрес автора комментария',
	'View all comments from this IP Address' => 'Показать все комментарии с этого IP',
	'Fulltext of the comment entry' => 'Полный текст комментария',
	'Responses to this comment' => 'Ответы на этот комментарий',

## tmpl/cms/edit_entry_batch.tmpl
	'Save these [_1] (s)' => 'Сохранить эти [_1] (s)',
	'Published Date' => 'Дата публикации',
	'Unpublished (Draft)' => 'Черновик',
	'Unpublished (Review)' => 'Черновик (на проверке)',

## tmpl/cms/edit_entry.tmpl
	'Edit Page' => 'Редактирование страницы',
	'Create Page' => 'Создать страницу',
	'Add folder' => 'Добавить папку',
	'Add folder name' => 'Добавить имя папки',
	'Add new folder parent' => 'Добавить новую родительскую папку',
	'Preview this page (v)' => 'Просмотр страницы (v)',
	'Delete this page (x)' => 'Удалить страницу (x)',
	'View Page' => 'Посмотреть страницу',
	'Edit Entry' => 'Редактирование записи',
	'Create Entry' => 'Создание новой записи',
	'Add category' => 'Добавить категорию',
	'Add category name' => 'Добавить имя категории',
	'Add new category parent' => 'Добавить новую родительскую категорию',
	'Manage Entries' => 'Управление записями',
	'Preview this entry (v)' => 'Просмотр записи (v)',
	'Delete this entry (x)' => 'Удалить запись (x)',
	'View Entry' => 'Посмотреть запись →',
	'A saved version of this entry was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Имеется автоматически сохранённая копия этой записи, созданная вами [_2]. <a href="[_1]">Восстановить?</a>',
	'A saved version of this page was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'Имеется автоматически сохранённая копия этой страницы, созданная вами [_2]. <a href="[_1]">Восстановить?</a>',
	'This entry has been saved.' => 'Запись сохранена.',
	'This page has been saved.' => 'Страница сохранена.',
	'One or more errors occurred when sending update pings or TrackBacks.' => 'Ошибки при выполнении пинга или отправке трекбэков.',
	'_USAGE_VIEW_LOG' => 'Сообщение об ошибке сохранено в <a href="[_1]">журнале активности</a>.',
	'Your customization preferences have been saved, and are visible in the form below.' => 'Ваши предпочтения сохранены.',
	'Your changes to the comment have been saved.' => 'Изменения комментария сохранены.',
	'Your notification has been sent.' => 'Ваше уведомление отправлено.',
	'You have successfully recovered your saved entry.' => 'Сохранённая запись успешно восстановлена.',
	'You have successfully recovered your saved page.' => 'Сохранённая страница успешно восстановлена.',
	'An error occurred while trying to recover your saved entry.' => 'Произошла ошибки при попытке восстановления сохранённой записи.',
	'An error occurred while trying to recover your saved page.' => 'Произошла ошибки при попытке восстановления сохранённой страницы.',
	'You have successfully deleted the checked comment(s).' => 'Выбранные комментарии удалены.',
	'You have successfully deleted the checked TrackBack(s).' => 'Выбранные трекбэки удалены.',
	'Restored revision (Date:[_1]).  The current status is: [_2]' => 'Восстановленная версия (дата: [_1]). Текущий статус: [_2]',
	'Some of tags in the revision could not be loaded because they have been removed.' => 'Некоторые теги из этой версии не могут быть загружены, так как они были удалены.',
	'Some [_1] in the revision could not be loaded because they have been removed.' => 'Некоторые [_1] из этой версии не могут быть загружены, так как они были удалены.',
	'This post was held for review, due to spam filtering.' => 'Этот пост был отправлен на модерацию, потому что попал под условия спам-фильтра',
	'This post was classified as spam.' => 'Пост классифицирован как спам',
	'Change Folder' => 'Изменить папку',
	'Unpublished (Spam)' => 'Неопубликованное (спам)',
	'Revision: <strong>[_1]</strong>' => 'Версия: <strong>[_1]</strong>',
	'View revisions of this [_1]' => 'Посмотреть версии этой [_1]',
	'View revisions' => 'Посмотреть версии',
	'No revision(s) associated with this [_1]' => 'Нет версий для этого объекта ([_1])',
	'[_1] - Published by [_2]' => '[_1] — опубликовано, [_2]',
	'[_1] - Edited by [_2]' => '[_1] — отредактировано, [_2]',
	'Publish this [_1]' => 'Опубликовать эту [_1]',
	'Draft this [_1]' => 'Черновик этой [_1]',
	'Schedule' => 'Запланировано',
	'Update' => 'Обновить',
	'Update this [_1]' => 'Обновить эту [_1]',
	'Unpublish this [_1]' => 'Отменить публикацию этой [_1]',
	'Save this [_1]' => 'Сохранить это [_1]',
	'You must configure this blog before you can publish this entry.' => 'Прежде, чем вы сможете публиковать записи, необходимо настроить блог.',
	'You must configure this blog before you can publish this page.' => 'Прежде, чем вы сможете публиковать страницы, необходимо настроить блог.',
	'Publish On' => 'Опубликовано',
	'Warning: If you set the basename manually, it may conflict with another entry.' => 'Внимание: при вводе имени файла вручную может возникнуть конфликт с другой записью.',
	q{Warning: Changing this entry's basename may break inbound links.} => q{Внимание: если вы измените имя файла, то потеряете входящие ссылки.},
	'Change note' => 'Изменить примечание',
	'edit' => 'редактировать',
	'close' => 'закрыть',
	'Accept' => 'Принять',
	'<a href="[_2]">[_1]</a>' => '<a href="[_2]">[_1]</a>', # Translate - Not translated
	'View Previously Sent TrackBacks' => 'Просмотреть ранее отправленные трекбэки',
	'Outbound TrackBack URLs' => 'Куда отправить трекбэки (URL)',
	'[_1] Assets' => '[_1] медиа',
	'Remove this asset.' => 'Удалить это медиа.',
	'No assets' => 'Нет медиа',
	'You have unsaved changes to this entry that will be lost.' => 'У вас есть несохранённые изменения этой записи, которые будут утеряны.',
	'You have unsaved changes to this page that will be lost.' => 'У вас есть несохранённые изменения этой страницы, которые будут утеряны.',
	'Enter the link address:' => 'Введите адрес ссылки:',
	'Enter the text to link to:' => 'Ввведите текст для ссылки:',
	'Are you sure you want to use the Rich Text editor?' => 'Вы уверены, что хотите сменить редактор на визуальный?',
	'Make primary' => 'Сделать основной',
	'Fields' => 'Поля',
	'Reset display options to blog defaults' => 'Сбросить параметры отображения к установкам по умолчанию',
	'Reset defaults' => 'Восстановить как было по умолчанию',
	'Permalink:' => 'Постоянная ссылка:',
	'Share' => 'Отправить',
	'Format:' => 'Формат:',
	'(comma-delimited list)' => '(через запятую)',
	'(space-delimited list)' => '(через пробел)',
	q{(delimited by '[_1]')} => q{(разделитель «[_1]»)},
	'None selected' => 'Ничего не выбрано',
	'Auto-saving...' => 'Автосохранение…',
	'Last auto-save at [_1]:[_2]:[_3]' => 'Автоматически сохранено [_1]:[_2]:[_3]',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'Изменить папку',
	'Manage Folders' => 'Управление папками',
	'Manage pages in this folder' => 'Управление страницами в этой папке',
	'You must specify a label for the folder.' => 'Необходимо указать имя для папки.',
	'Path' => 'Путь',
	'Save changes to this folder (s)' => 'Сохранить изменения папки (s)',

## tmpl/cms/edit_ping.tmpl
	'Edit Trackback' => 'Редактировать трекбэк',
	'The TrackBack has been approved.' => 'Трекбэк одобрен.',
	'This trackback was classified as spam.' => 'Трекбэк классифицирован как спам.',
	'Save changes to this TrackBack (s)' => 'Сохранить изменения трекбэка (s)',
	'Delete this TrackBack (x)' => 'Удалить трекбэк (x)',
	'Manage TrackBacks' => 'Управление трекбэками',
	'View [_1]' => 'Просмотр [_1]',
	'Update the status of this TrackBack' => 'Изменить статус этого трекбэка',
	'View all TrackBacks with this status' => 'Посмотреть все трекбэки с этим статусом',
	'Search for other TrackBacks from this site' => 'Найти другие трекбэки с этого сайта',
	'Search for other TrackBacks with this title' => 'Найти другие трекбэки с таким же заголовком',
	'Search for other TrackBacks with this status' => 'Найти другие трекбэки с таким же статусом',
	'Target [_1]' => 'Target [_1]', # Translate - Not translated
	'Entry no longer exists' => 'Записи больше не существует',
	'No title' => 'Без названия',
	'View all TrackBacks on this entry' => 'Посмотреть все трекбэки к этой записи',
	'Target Category' => 'К категории',
	'Category no longer exists' => 'Категории больше не существует',
	'View all TrackBacks on this category' => 'Посмотреть все трекбэки к этой категории',
	'View all TrackBacks created on this day' => 'Посмотреть все трекбэки, созданные в этот день',
	'View all TrackBacks from this IP address' => 'Посмотреть все трекбэки с этого IP адреса',
	'TrackBack Text' => 'Текст трекбэка',
	'Excerpt of the TrackBack entry' => 'Выдержка из трекбэка записи',

## tmpl/cms/edit_role.tmpl
	'Edit Role' => 'Изменить роль',
	'Association (1)' => 'Связано (1)',
	'Associations ([_1])' => 'Ассоциации ([_1])',
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'Вы изменили параметры роли. Это повлияет на возможности всех пользователей с данной ролью. Чтобы избежать этого, вы можете сохранить роль под новым именем.',
	'Role Details' => 'Настройка роли',
	'System' => 'Система',
	'Privileges' => 'Права',
	'Administration' => 'Администрирование',
	'Authoring and Publishing' => 'Создание и публикация',
	'Designing' => 'Дизайнер',
	'Commenting' => 'Комментирование',
	'Duplicate Roles' => 'Повторяющиеся роли',
	'These roles have the same privileges as this role' => 'Эти роли состоят из того же набора прав, что и данная роль',
	'Save changes to this role (s)' => 'Сохранить изменения этой роли',

## tmpl/cms/edit_template.tmpl
	'Edit Widget' => 'Редактировать виджет',
	'Create Widget' => 'Создать виджет',
	'Create Template' => 'Создание шаблона',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]">Recover auto-saved content</a>' => 'Автоматически сохранился предыдущий контент, созданный вами [_3]. <a href="[_2]">Восстановить?</a>',
	'You have successfully recovered your saved [_1].' => 'Контент ([_1]) восстановлен.',
	'An error occurred while trying to recover your saved [_1].' => 'Ошибка при попытке восстановления [_1].',
	'Restored revision (Date:[_1]).' => 'Восстановленная версия (дата: [_1]).',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => '<a href="[_1]" class="rebuild-link">Опубликовать</a> его?',
	'Your [_1] has been published.' => 'Шаблон «[_1]» опубликован.',
	'View revisions of this template' => 'Версии этого шаблона',
	'No revision(s) associated with this template' => 'Нет версий этого шаблона',
	'Useful Links' => 'Полезные ссылки',
	'List [_1] templates' => 'Список шаблонов ([_1])',
	'Module Option Settings' => 'Опции модуля',
	'List all templates' => 'Список всех шаблонов',
	'View Published Template' => 'Посмотреть опубликованный шаблон',
	'Included Templates' => 'Включаемые шаблоны',
	'create' => 'создать',
	'Template Tag Docs' => 'Документация по тегам',
	'Unrecognized Tags' => 'Неизвестные теги',
	'Save (s)' => 'Сохранить (s)',
	'Save Changes (s)' => 'Сохранить изменения',
	'Save and Publish this template (r)' => 'Сохранить и опубликовать шаблон (r)',
	'Save &amp; Publish' => 'Сохранить и опубликовать',
	'You have unsaved changes to this template that will be lost.' => 'Изменения, внесённые в этот шаблон, будут утеряны.',
	'You must set the Template Name.' => 'Необходимо указать имя шаблона.',
	'You must set the template Output File.' => 'Необходимо указать имя файла шаблона.',
	'Processing request...' => 'Обработка запроса…',
	'Error occurred while updating archive maps.' => 'Ошибка при обновлении карты архива.',
	'Archive map has been successfully updated.' => 'Карта архива успешно обновлена',
	'Are you sure you want to remove this template map?' => 'Вы уверены, что хотите удалить карту шаблона?',
	'Module Body' => 'Содержимое модуля',
	'Template Body' => 'Содержимое шаблона',
	'Template Options' => 'Опции шаблона',
	'Output file: <strong>[_1]</strong>' => 'Публикуемый файл: <strong>[_1]</strong>',
	'Enabled Mappings: [_1]' => 'Типы публикаций: [_1]',
	'Template Type' => 'Тип шаблона',
	'Custom Index Template' => 'Обычный индексный шаблон',
	'Link to File' => 'Связать с файлом',
	'Learn more about <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publishing settings</a>' => 'Узнать больше о <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">профилях публикации</a>',
	'Create Archive Mapping' => 'Создать путь архива',
	'Statically (default)' => 'Статически (по умолчанию)',
	'Via Publish Queue' => 'С использованием очереди публикации',
	'On a schedule' => 'По графику',
	': every ' => ': каждый ',
	'minutes' => 'минуты',
	'hours' => 'часы',
	'Dynamically' => 'Динамически',
	'Manually' => 'Вручную',
	'Do Not Publish' => 'Не публиковать',
	'Server Side Include' => 'Включение на стороне сервера (SSI)',
	'Process as <strong>[_1]</strong> include' => 'Обрабатывать как <strong>[_1]</strong> включение',
	'Include cache path' => 'Включить кэш-путь',
	'Disabled (<a href="[_1]">change publishing settings</a>)' => 'Отключено (<a href="[_1]">изменить параметры публикации</a>)',
	'No caching' => 'Не кэшируется',
	'Expire after' => 'Истекает после',
	'Expire upon creation or modification of:' => 'Истечёт после создания или модификации:',

## tmpl/cms/edit_website.tmpl
	'Create Website' => 'Создать сайт',
	'Website Theme' => 'Тема сайта',
	'Select the theme you wish to use for this website.' => 'Выберите тему, которую вы хотите использовать на этом сайте.',
	'Name your website. The website name can be changed at any time.' => 'Имя вашего сайта (может быть изменено в любой момент).',
	'Enter the URL of your website. Exclude the filename (i.e. index.html). Example: http://www.example.com/' => 'Введите URL вашего сайта, исключая имена файлов (например, index.html). Пример: http://example.com/blog/',
	'Website Root' => 'Расположение сайта',
	q{Enter the path where your main index file will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/ or C:\www\public_html} => q{Место, где располагаются индексные файлы. Рекомендуется использовать абсолютный путь (в Linux начинается с '/', а в Windows с 'C:\'). Путь не должен заканчиваться на '/' или '\'. Пример: /home/mt/public_html или C:\www\public_html},
	'Create Website (s)' => 'Создать сайт (s)',
	'This field is required.' => 'Это поле обязательно.',
	'Please enter a valid URL.' => 'Пожалуйста, укажите правильный URL.',
	'Please enter a valid site path.' => 'Пожалуйста, укажите правильный путь сайта.',
	'You did not select a timezone.' => 'Вы не выбрали часовой пояс.',

## tmpl/cms/edit_widget.tmpl
	'Edit Widget Set' => 'Редактировать связку виджетов',
	'Create Widget Set' => 'Создание связки виджетов',
	'Widget Set Name' => 'Имя связки виджетов',
	'Save changes to this widget set (s)' => 'Сохранить изменения этой связки виджетов (s)',
	q{Drag and drop the widgets that belong in this Widget Set into the 'Installed Widgets' column.} => q{Перетащите виджеты, доступные в этой связке, на колонку «Используемые виджеты».},
	'Available Widgets' => 'Доступные виджеты',
	'Installed Widgets' => 'Используемые виджеты',
	'You must set Widget Set Name.' => 'Необходимо указать имя связки виджетов.',

## tmpl/cms/error.tmpl
	'An error occurred' => 'Произошла ошибка',

## tmpl/cms/export_theme.tmpl
	'Export [_1] Themes' => 'Экспортировать тему [_1]',
	'Theme package have been saved.' => 'Пакет с темой сохранён.',
	'The name of your theme.' => 'Имя вашей темы.',
	q{Use letters, numbers, dash or underscore only (a-z, A-Z, 0-9, '-' or '_').} => q{Используйте латинские буквы, цифры, тире и подчёркивание (a-z, A-Z, 0-9, «-» или «_»).},
	'Version' => 'Версия',
	'A version number for this theme.' => 'Номер версии этой темы.',
	'A description for this theme.' => 'Описание темы.',
	'_THEME_AUTHOR' => 'Автор',
	'The author of this theme.' => 'Автор темы.',
	'Author link' => 'Ссылка на автора',
	q{The author's website.} => q{Сайт автора.},
	'Additional assets to be included in the theme.' => 'Дополнительное медиа, которое будет включено в эту тему.',
	'Destination' => 'Расположение',
	'Select How to get theme.' => 'Выберите способ получения темы.',
	'Setting for [_1]' => 'Параметры для [_1]',
	'Basename may only contain letters, numbers, and the dash or underscore character. The basename must begin with a letter.' => 'Базовое имя может содержать только латинские буквы, цифры, тире или символ подчеркивания. Кроме того, базовое имя должно начинаться с буквы.',
	q{Cannot install new theme with existing (and protected) theme's basename.} => q{Не удаётся установить новую тему с существующим (и защищённым) базовым именем темы.},
	'You must set Theme Name.' => 'Необходимо указать имя темы.',
	'Theme version may only contain letters, numbers, and the dash or underscore character.' => 'Версия темы может содержать только латинские буквы, цифры, тире или символ подчеркивания.',

## tmpl/cms/export.tmpl
	'Export Blog Entries' => 'Экспортировать записи блога',
	'You must select a blog to export.' => 'Необходимо выбрать блог для экспорта.',
	'_USAGE_EXPORT_1' => 'Экспорт позволяет сделать резервную копию контента вашего блога. Впоследствии вы можете импортировать полученный файл, если вы желаете восстановить ваши записи.',
	'Blog to Export' => 'Блог для экспорта',
	'Select a blog for exporting.' => 'Выберите блог для экпорта.',
	'Change blog' => 'Изменить блог',
	'Select blog' => 'Выбрать блог',
	'Export Blog (s)' => 'Экспорт блога(ов)',
	'Export Blog' => 'Экспорт блога',

## tmpl/cms/import_others.tmpl
	'Start title HTML (optional)' => 'Начало заголовка HTML (опционально)',
	'End title HTML (optional)' => 'Окончание заголовка HTML (опционально)',
	'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => 'Если программа, из которой вы получаете информацию не имеет поля заголовка, вы можете использовать эту установку для идентификации заголовка в структуре записи.',
	'Default entry status (optional)' => 'Статус записи по умолчанию (опционально)',
	'If the software you are importing from does not specify an entry status in its export file, you can set this as the status to use when importing entries.' => 'Если среда, из которой вы получаете информацию, не указывает статус записи в экспортируемом файле, вы можете установить его самостоятельно.',
	'Select an entry status' => 'Выберите статус записи',

## tmpl/cms/import.tmpl
	'Import Blog Entries' => 'Импорт записей блога',
	'You must select a blog to import.' => 'Необходимо выбрать блог для импорта.',
	'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Перенос в Movable Type записей из другой инсталляции Movable Type, из другой блог-платформы, или экспорт записей для резервного копирования.',
	'Import data into' => 'Импорт данных в',
	'Select a blog to import.' => 'Выберите блог для импорта.',
	'Importing from' => 'Импорт из',
	'Ownership of imported entries' => 'Владелец импортируемых записей',
	'Import as me' => 'Я',
	'Preserve original user' => 'Сохранить указанного пользователя',
	'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => 'Если вы сохраняете информацию о владельцах записей, и некоторые из этих пользователей должны создаваться в процессе импорта, необходимо указать пароль по умолчанию.',
	'Default password for new users:' => 'Пароль по умолчанию для новых пользователей:',
	'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'Вы станете владельцем всех импортированных записей. Если вы желаете сохранить исходную информацию о пользователях, обратитесь к администратору системы MT для выполнения импорта с созданием новых пользователей.',
	'Upload import file (optional)' => 'Загрузка файла импорта (опционально)',
	q{If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the 'import' folder of your Movable Type directory.} => q{Если импортируемый файл находится на вашем компьютере, вы можете загрузить его здесь. Иначе Movable Type будет искать файл в подкаталоге «import» инсталляционного каталога.},
	'Import File Encoding' => 'Кодиковка файла импорта',
	'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'По умолчанию Movable Type будет пытаться определить кодировку автоматически. Однако вы можете выбрать кодировку вручную.',
	'<mt:var name="display_name" escape="html">' => '<mt:var name="display_name" escape="html">', # Translate - Not translated
	'Default category for entries (optional)' => 'Категория по умолчанию (опционально)',
	'You can specify a default category for imported entries which have none assigned.' => 'Вы можете указать категорию по умолчанию для тех импортируемых записей, которые не имеют категории.',
	'Select a category' => 'Выбрать категорию',
	'Import Entries (s)' => 'Импорт записей',

## tmpl/cms/include/anonymous_comment.tmpl
	'Allow comments from anonymous or unauthenticated users.' => 'Разрешить комментарии от анонимных и неавторизованных пользователей.',
	'Require name and E-mail Address for Anonymous Comments' => 'Требовать имя и электронную почту для анонимных комментариев',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'Если эта опция активна, посетителю нужно будет ввести реальный e-mail, чтобы оставить комментарий.',

## tmpl/cms/include/archetype_editor.tmpl
	'Decrease Text Size' => 'Уменьшить размер шрифта',
	'Increase Text Size' => 'Увеличить размер шрифта',
	'Bold' => 'Жирный',
	'Italic' => 'Курсив',
	'Underline' => 'Подчеркнутый',
	'Strikethrough' => 'Зачеркнутый',
	'Text Color' => 'Цвет текста',
	'Email Link' => 'Ссылка на email',
	'Begin Blockquote' => 'Цитата',
	'End Blockquote' => 'Закончить цитату',
	'Bulleted List' => 'Маркированный список',
	'Numbered List' => 'Нумерованый список',
	'Left Align Item' => 'Выровнять по левому краю',
	'Center Item' => 'Выровнять по центру',
	'Right Align Item' => 'Выровнять по правому краю',
	'Left Align Text' => 'Выровнять по левому краю',
	'Center Text' => 'Выровнять по центру',
	'Right Align Text' => 'Выровнять по правому краю',
	'Insert File' => 'Вставить файл',
	'Check Spelling' => 'Проверка орфографии',
	'WYSIWYG Mode' => 'Визуальный режим',
	'HTML Mode' => 'Режим HTML',

## tmpl/cms/include/archive_maps.tmpl
	'Custom...' => 'Свой путь…',

## tmpl/cms/include/asset_replace.tmpl
	q{A file named '[_1]' already exists. Do you want to overwrite this file?} => q{Файл с именем «[_1]» уже существует. Хотите перезаписать файл?},
	'Yes (s)' => 'Да (s)',
	'Yes' => 'Да',
	'No' => 'Нет',

## tmpl/cms/include/asset_table.tmpl
	'Delete selected assets (x)' => 'Удалить выбранное медиа (x)',
	'Website/Blog' => 'Сайт/Блог',
	'Created By' => 'Создан',
	'Created On' => 'Дата',
	'Asset Missing' => 'Медиа не найдено',
	'No thumbnail image' => 'Нет миниатюры изображения',

## tmpl/cms/include/asset_upload.tmpl
	'Upload Destination' => 'Загрузить в',
	q{Before you can upload a file, you need to publish your [_1]. [_2]Configure your [_1]'s publishing paths[_3] and republish your [_1].} => q{Прежде чем загрузить файл, вам необходимо опубликовать ваш [_1]. [_2]Настройте путь публикации[_3] и опубликуйте [_1].},
	'Your system or [_1] administrator needs to publish the [_1] before you can upload files. Please contact your system or [_1] administrator.' => 'Администратор системы или [_1] администратор должен опубликовать [_1], прежде чем вы сможете загружать файлы.',
	q{Asset file('[_1]') has been uploaded.} => q{Файл «[_1]» загружен.},
	'Select File to Upload' => 'Выберите файл для загрузки',
	'_USAGE_UPLOAD' => 'Вы можете загрузить файл в подкаталог. Если подкаталог не найден, он будет автоматически создан.',
	'Choose Folder' => 'Выбрать папку',
	'Upload (s)' => 'Загрузить (s)',
	'Upload' => 'Загрузить',
	'[_1] contains a character that is invalid when used in a directory name: [_2]' => '[_1] содержит символ, недопустимый в имени директории: [_2]',

## tmpl/cms/include/author_table.tmpl
	'Enable selected users (e)' => 'Активировать выбранных пользователей (e)',
	'_USER_ENABLE' => 'Активировать',
	'Disable selected users (d)' => 'Деактивировать выбранных пользователей (d)',
	'_USER_DISABLE' => 'Деактивировать',
	'user' => 'пользователь',
	'users' => 'пользователи',
	'_NO_SUPERUSER_DISABLE' => 'Вы не можете отключить себя, так как являетесь администратором системы Movable Type.',

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been backed up successfully!' => 'Все данные были успешно сохранены!',
	'_BACKUP_TEMPDIR_WARNING' => 'Указанные данные были успешно сохранены в директории [_1]. Удостоверьтесь, что вы скачали, а затем <strong>удалили</strong> перечисленные выше файлы с [_1] <strong>сразу</strong>, так как файл резервной копиии содержит конфиденциальную информацию.',
	'Backup Files' => 'Файлы бекапа',
	'Download This File' => 'Скачать этот файл',
	'Download: [_1]' => 'Скачать: [_1]',
	'_BACKUP_DOWNLOAD_MESSAGE' => 'Скачивание файла резервной копии начнётся автоматически через несколько секунд. Если этого не произойдёт, вы можете <a href="javascript:(void)" onclick="submit_form()">начать скачивание</a> самостоятельно. Имейте ввиду, что вы можете скачать этот файл только один раз за сессию.',
	'An error occurred during the backup process: [_1]' => 'Во время операции бекапа произошла ошибка: [_1]',

## tmpl/cms/include/backup_start.tmpl
	'Backing up Movable Type' => 'Старт резервного копирования Movable Type',

## tmpl/cms/include/basic_filter_forms.tmpl
	'contains' => 'содержит',
	'does not contain' => 'не содержит',
	'__STRING_FILTER_EQUAL' => '—', # Translate - No russian chars
	'starts with' => 'начинается с',
	'ends with' => 'заканчивается на',
	'[_1] [_2] [_3]' => '[_1] [_2] [_3]', # Translate - Not translated
	'__INTEGER_FILTER_EQUAL' => '—', # Translate - No russian chars
	'__INTEGER_FILTER_NOT_EQUAL' => '—', # Translate - No russian chars
	'is greater than' => 'больше, чем',
	'is greater than or equal to' => 'больше, чем, или равняется',
	'is less than' => 'меньше, чем',
	'is less than or equal to' => 'меньше, чем, или равно',
	'is between' => 'между',
	'is within the last' => 'в течении последних',
	'is before' => 'перед',
	'is after' => 'после',
	'is after now' => 'с текущего момента',
	'is before now' => 'до текущего момента',
	'__FILTER_DATE_ORIGIN' => '[_1]', # Translate - No russian chars
	'[_1] and [_2]' => '[_1] и [_2]',
	'_FILTER_DATE_DAYS' => '[_1] дней',

## tmpl/cms/include/blog_table.tmpl
	'Some templates were not refreshed.' => 'Некоторые шаблоны не были обновлены.',
	'Delete selected [_1] (x)' => 'Удалить выбранные [_1]',
	'[_1] Name' => 'Имя [_1]',

## tmpl/cms/include/category_selector.tmpl
	'Add sub category' => 'Добавить подкатегорию',
	'Add sub folder' => 'Добавить подпапку',

## tmpl/cms/include/commenter_table.tmpl
	'Last Commented' => 'Последний прокомментировавший',
	'Edit this commenter' => 'Редактировать комментатора',
	'View this commenter&rsquo;s profile' => 'Посмотреть профиль комментатора',

## tmpl/cms/include/comment_table.tmpl
	'Publish selected comments (a)' => 'Опубликовать выбранные комментарии (a)',
	'Delete selected comments (x)' => 'Удалить выбранные комментарии (x)',
	'Edit this comment' => 'Редактировать этот комментарий',
	'([quant,_1,reply,replies])' => '([quant,_1,ответ,ответа,ответов])',
	'Blocked' => 'Заблокированные',
	'Edit this [_1] commenter' => 'Редактировать комментатора со статусом «[_1]»',
	'Search for comments by this commenter' => 'Найти комментарии от этого комментатора',
	'View this entry' => 'Посмотреть эту запись',
	'View this page' => 'Посмотреть эту страницу',
	'Search for all comments from this IP address' => 'Найти все комментарии, оставленные с этого IP адреса',
	'to republish' => 'для повторной публикации',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001-[_1] Six Apart. All Rights Reserved.' => '&copy; 2001-[_1] Six Apart. Все права защищены.',

## tmpl/cms/include/debug_hover.tmpl
	'Hide Toolbar' => 'Скрыть панель',
	'Hide &raquo;' => 'Скрыть &raquo;',

## tmpl/cms/include/debug_toolbar/cache.tmpl
	'Key' => 'Ключ',
	'Value' => 'Значение',

## tmpl/cms/include/debug_toolbar/requestvars.tmpl
	'Cookies' => 'Куки',
	'Variable' => 'Переменная',
	'No COOKIE data' => 'Нет данных о Куки',
	'Input Parameters' => 'Входящие параметры',
	'No Input Parameters' => 'Нет входящих параметров',

## tmpl/cms/include/display_options.tmpl
	'Display Options' => 'Опции отображения',
	'_DISPLAY_OPTIONS_SHOW' => 'Показать',
	'[quant,_1,row,rows]' => '[quant,_1,элемент,элемента,элементов]',
	'Compact' => 'Компактный',
	'Expanded' => 'Расширенный',
	'Save display options' => 'Сохранить параметры отображения',

## tmpl/cms/include/entry_table.tmpl
	'Republish selected [_1] (r)' => 'Перепубликовать выбранные [_1] (r)',
	'Last Modified' => 'Последнее изменение',
	'Created' => 'Создано',
	'View entry' => 'Посмотреть запись →',
	'View page' => 'Посмотреть страницу',
	'No entries could be found.' => 'Записи не найдены.',
	'<a href="[_1]">Create an entry</a> now.' => '<a href="[_1]">Создать новую запись</a>?',
	'No pages could be found. <a href="[_1]">Create a page</a> now.' => 'Страниц не найдено. Быть может, <a href="[_1]">создать страницу?</a>',

## tmpl/cms/include/feed_link.tmpl
	'Set Web Services Password' => 'Установить пароль для веб-сервисов',

## tmpl/cms/include/footer.tmpl
	'This is a beta version of Movable Type and is not recommended for production use.' => 'Это бета-версия Movable Type, не рекомендуется использовать как рабочую версию.',
	'http://www.movabletype.org' => 'http://www.movabletype.org', # Translate - Not translated
	'MovableType.org' => 'MovableType.org', # Translate - Not translated
	'http://plugins.movabletype.org/' => 'http://plugins.movabletype.org/', # Translate - Not translated
	'http://wiki.movabletype.org/' => 'http://movable-type.ru/wiki/', # Translate - No russian chars
	'Wiki' => 'Wiki', # Translate - Not translated
	'http://www.movabletype.com/support/' => 'http://www.movabletype.com/support/', # Translate - Not translated
	'Support' => 'Поддержка',
	'http://forums.movabletype.org/' => 'http://movable-type.ru/forums/', # Translate - No russian chars
	'Forums' => 'Форум',
	'http://www.movabletype.org/feedback.html' => 'http://www.movabletype.org/feedback.html', # Translate - Not translated
	'Send Us Feedback' => 'Обратная связь',
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a>, версия [_2]',
	'with' => 'с',
	'_LOCALE_CALENDAR_HEADER_' => "'В', 'П', 'В', 'С', 'Ч', 'П', 'С'",
	'Your Dashboard' => 'Ваша обзорная панель',

## tmpl/cms/include/header.tmpl
	'Signed in as [_1]' => 'Авторизованы как [_1]',
	'Help' => 'Помощь',
	'Sign out' => 'выйти',
	'View Site' => 'Посмотреть сайт',
	'Search (q)' => 'Поиск (q)',
	'Create New' => 'Создать',
	'Select an action' => 'Выберите действие',
	q{This website was created during the upgrade from a previous version of Movable Type. 'Site Root' and 'Site URL' are left blank to retain 'Publishing Paths' compatibility for blogs that were created in a previous version. You can post and publish on existing blogs, but you cannot publish this website itself because of the blank 'Site Root' and 'Site URL'.} => q{Этот сайт создан в процессе обновления с предыдущей версии Movable Type. Поля 'Папка сайта' и 'URL сайта' оставлены пустыми для совместимости с блогами, перенесёнными с прошлой версии. Вы можете публиковать новые посты в существующие блоги, но вы не можете публиковать материалы на сайте, пока не настроите указанные поля.},
	'from Revision History' => 'из предыдущих версий',

## tmpl/cms/include/import_end.tmpl
	'All data imported successfully!' => 'Всё содержимое успешно импортировано!',
	q{Make sure that you remove the files that you imported from the 'import' folder, so that if/when you run the import process again, those files will not be re-imported.} => q{Убедитесь, что вы удалили файлы, импортированные из папки «import». Если вы снова запустите процесс импорта, эти файлы не будут импортированы повторно.},
	'An error occurred during the import process: [_1]. Please check your import file.' => 'Произошла ошибка в процессе импорта: [_1]. Пожалуйста, проверьте файл импорта.',

## tmpl/cms/include/import_start.tmpl
	'Importing...' => 'Импортирование',
	'Importing entries into blog' => 'Импортирование записей в блог',
	q{Importing entries as user '[_1]'} => q{Импортирование записей как пользователем «[_1]»},
	'Creating new users for each user found in the blog' => 'Создание новых пользователей, соответствующих пользователям, найденных в блоге',

## tmpl/cms/include/itemset_action_widget.tmpl
	'More actions...' => 'Дополнительные опции…',
	'Plugin Actions' => 'Опции плагинов',
	'Go' => 'OK', # Translate - No russian chars

## tmpl/cms/include/list_associations/page_title.tmpl
	'Manage Permissions' => 'Управление разрешениями',
	'Users for [_1]' => 'Пользователи для [_1]',

## tmpl/cms/include/listing_panel.tmpl
	'Step [_1] of [_2]' => 'Шаг [_1] из [_2]',
	'Go to [_1]' => 'Перейти к [_1]',
	'Sorry, there were no results for your search. Please try searching again.' => 'К сожалению, по вашему запросу ничего не найдено. Попробуйте уточнить запрос и повторите поиск.',
	'Sorry, there is no data for this object set.' => 'К сожалению, пока ничего нет по этому набору объектов.',
	'OK (s)' => 'OK (s)', # Translate - Not translated
	'OK' => 'OK', # Translate - Not translated

## tmpl/cms/include/login_mt.tmpl
	'Remember me?' => 'Запомнить меня',

## tmpl/cms/include/log_table.tmpl
	'No log records could be found.' => 'Нет записей для журнала активности.',
	'_LOG_TABLE_BY' => 'Пользователь',
	'IP: [_1]' => 'IP: [_1]', # Translate - Not translated

## tmpl/cms/include/member_table.tmpl
	'Are you sure you want to remove the selected user from this [_1]?' => 'Вы действительно хотите удалить выбранного пользоваться из этого [_1]?',
	'Are you sure you want to remove the [_1] selected users from this [_2]?' => 'Вы действительно хотите удалить выбранных пользователей ([_1] шт.) из этого [_2]?',
	'Remove selected user(s) (r)' => 'Удалить выбранных пользователей (r)',
	'Trusted commenter' => 'Доверенный комментатор',
	'Remove this role' => 'Удалить эту роль',

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => 'Добавлено',
	'Save changes' => 'Сохранить изменения',

## tmpl/cms/include/ping_table.tmpl
	'Publish selected [_1] (p)' => 'Опубликовать выбранные [_1] (p)',
	'Edit this TrackBack' => 'Редактировать трекбэк',
	'Go to the source entry of this TrackBack' => 'Перейти к записи, с которой отправлен трекбэк',
	'View the [_1] for this TrackBack' => 'Открыть [_1], к которой оставлен этот трекбэк',

## tmpl/cms/include/revision_table.tmpl
	'No revisions could be found.' => 'Историй версий не найдено.',
	'Note' => 'Примечание',
	'Saved By' => 'Сохранил(а)',

## tmpl/cms/include/rpt_log_table.tmpl
	'Schwartz Message' => 'Сообщение Schwartz',

## tmpl/cms/include/scope_selector.tmpl
	'User Dashboard' => 'Обзорная панель пользователя',
	'Select another website...' => 'Выбрать другой сайт…',
	'(on [_1])' => '(на [_1])',
	'Select another blog...' => 'Выбрать другой блог',
	'Create Blog (on [_1])' => 'Создать блога (на [_1])',

## tmpl/cms/include/template_table.tmpl
	'Create Archive Template:' => 'Создать шаблон архива',
	'Entry Listing' => 'Список записей',
	'Create template module' => 'Создать модульный шаблон',
	'Create index template' => 'Создать индексный шаблон',
	'Publish selected templates (a)' => 'Опубликовать выбранные шаблоны (a)',
	'Archive Path' => 'Путь архива',
	'SSI' => 'SSI', # Translate - Not translated
	'Cached' => 'Кэшированный',
	'Linked Template' => 'Шаблон связан с другим файлом',
	'Manual' => 'Вручную',
	'Dynamic' => 'Динамический',
	'Publish Queue' => 'Очередь публикации',
	'Static' => 'Статика',
	'templates' => 'шаблоны',
	'to publish' => 'публиковать',

## tmpl/cms/include/theme_exporters/category.tmpl
	'Category Name' => 'Имя категории',

## tmpl/cms/include/theme_exporters/folder.tmpl
	'Folder Name' => 'Имя папки',
	'<mt:if name="is_blog">Blog URL<mt:else>Site URL</mt:if>' => '<mt:if name="is_blog">URL блога<mt:else>URL сайта</mt:if>',

## tmpl/cms/include/theme_exporters/static_files.tmpl
	'In the specified directories, files of the following types will be included in the theme: [_1]. Other file types will be ignored.' => 'В указанных каталогах файлы следующих типов будут включены в тему: [_1]. Другие файлы будут игнорироваться.',
	'Specify directories' => 'Укажите директории',
	'List directories (one per line) in the Site Root directory which contain the static files to be included in the theme. Common directories might be: css, images, js, etc.' => 'Список директорий (одна на строке) в директории сайта, содержащих статические файлы, которые будут включены в тему. Например, это могут быть директории, содержащие: CSS, JS, изображения, и др.',

## tmpl/cms/include/theme_exporters/templateset.tmpl
	'widget sets' => 'Связки виджетов',
	'modules' => 'модули',
	'<span class="count">[_1]</span> [_2] are included' => '[_2] (<span class="count">[_1]</span>) включены',

## tmpl/cms/install.tmpl
	'Welcome to Movable Type' => 'Добро пожаловать в Movable Type',
	'Create Your Account' => 'Создание вашего аккаунта',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'Версия Perl, установленная на Вашем сервере ([_1]), ниже минимально поддерживаемой версии ([_2]).',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Несмотря на то, что Movable Type может работать на данной версии Perl, <strong>эта версия не тестируется и не поддерживается</strong>.  Мы настоятельно рекоммендуем установить версию Perl не ниже [_1].',
	'Do you want to proceed with the installation anyway?' => 'Вы уверены, что все равно хотите продолжить инсталляцию?',
	'View MT-Check (x)' => 'Посмотреть MT-Check (x)',
	'Please create an administrator account for your system. When you are done, Movable Type will initialize your database.' => 'Пожалуйста, создайте аккаунт администратора вашей системы. Когда он будет создан, Movable Type сможет заполнить базу данных необходимыми данными.',
	'To proceed, you must authenticate properly with your LDAP server.' => 'Для продолжения вам необходимо авторизоваться при помощи LDAP-сервера.',
	'The name used by this user to login.' => 'Имя для входа в систему (login).',
	'The name used when published.' => 'Имя используемое при публикации.',
	'The user&rsquo;s email address.' => 'Email адрес',
	'The email address used in the From: header of each email sent from the system.' => 'Этот email используется в заголовке From, содержащихся в письмах, отправляемых Movable Type.',
	'Use this as system email address' => 'Использовать как системный email',
	'The user&rsquo;s preferred language.' => 'Язык, предпочитаемый пользователем',
	'Select a password for your account.' => 'Выбрать пароль для учетной записи.',
	'Your LDAP username.' => 'Ваше имя пользователя в LDAP.',
	'Enter your LDAP password.' => 'Введите Ваш LDAP пароль.',
	'The initial account name is required.' => 'Необходимо указать имя учетной записи.',
	'The display name is required.' => 'Необходимо указать отображаемое имя.',
	'The e-mail address is required.' => 'Email адрес обязателен.',

## tmpl/cms/list_category.tmpl
	'Manage [_1]' => 'Управление [_1]',
	'Top Level' => 'Верхний уровень',
	'[_1] label' => 'Имя [_1]',
	'Change and move' => 'Изменить и переместить',
	'Rename' => 'Переименовать',
	'Label is required.' => 'Имя обязательно',
	'Duplicated label on this level.' => 'Дублирующее имя на этом уровне.',
	'Basename is required.' => 'Базовое имя обязательно.',
	'Invalid Basename.' => 'Неверное базовое имя.',
	'Duplicated basename on this level.' => 'Дублирующее базовое имя на этом уровне.',
	'Add child [_1]' => 'Добавить вложенную [_1]',
	'Remove [_1]' => 'Удалить [_1]',
	'[_1] \'[_2]\' already exists.' => '[_1] \'[_2]\' уже существует.',
	'Are you sure you want to remove [_1] [_2]?' => 'Вы уверены, что хотите удалить [_1] [_2]?',
	'Are you sure you want to remove [_1] [_2] with [_3] sub [_4]?' => 'Вы уверены, что хотите удалить [_1] [_2] с [_3] под [_4]?',
	'Alert' => 'Предупреждение',

## tmpl/cms/list_common.tmpl
	'25 rows' => '25 строк',
	'50 rows' => '50 строк',
	'100 rows' => '100 строк',
	'200 rows' => '200 строк',
	'Column' => 'Колонка',
	'<mt:var name="js_message">' => '<mt:var name="js_message">', # Translate - Not translated
	'Filter:' => 'Фильтр:',
	'Select Filter...' => 'Выбрать фильтр...',
	'Remove Filter' => 'Убрать фильтр',
	'Select Filter Item...' => 'Выбрать пункт фильтра...',
	'Apply' => 'Применить',
	'Save As' => 'Сохранить как',
	'Filter Label' => 'Имя фильтра',
	'My Filters' => 'Мои фильтры',
	'Built in Filters' => 'Встроенные фильтры',
	'Remove item' => 'Удалить пункт',
	'Unknown Filter' => 'Неизвестный фильтр',
	'act upon' => 'влияет на',
	'Are you sure you want to remove the filter \'[_1]\'?' => 'Вы уверены, что хотите удалить фильтр \'[_1]\'?',
	'Label "[_1]" is already in use.' => 'Имя «[_1]» уже используется.',
	'Communication Error ([_1])' => 'Ошибка связи ([_1])', # проверить
	'[_1] - [_2] of [_3]' => '[_1] - [_2] из [_3]',
	'Select all [_1] items' => 'Выбрать все [_1]',
	'All [_1] items are selected' => 'Выбраны все [_1]',
	'[_1] Filter Items have errors' => 'Фильтр [_1] содержит ошибки',
	'[_1] - Filter [_2]' => '[_1] - фильтр [_2]',
	'Save Filter' => 'Сохранить фильтр',
	'Save As Filter' => 'Сохранить фильтр как',
	'Select Filter' => 'Выбрать фильтр',

## tmpl/cms/list_entry.tmpl
	'Entries Feed' => 'Записи',
	'Pages Feed' => 'Страницы',
	'The entry has been deleted from the database.' => 'Запись удалена из базы данных.',
	'The page has been deleted from the database.' => 'Страница удалена из базы данных.',
	'Quickfilters' => 'Быстрые фильтры',
	'[_1] (Disabled)' => '[_1] (деактивирован)',
	'Showing only: [_1]' => 'Показаны: [_1]',
	'Remove filter' => 'Убрать фильтр',
	'change' => 'изменить',
	'[_1] where [_2] is [_3]' => '[_1], у которых [_2] — [_3]',
	'Show only entries where' => 'Показать записи, у которых',
	'Show only pages where' => 'Показать страницы, у которых',
	'status' => 'статус',
	'tag (exact match)' => 'тег (точное совпадение)',
	'tag (fuzzy match)' => 'тег (нечёткое совпадение)',
	'asset' => 'Медиа',
	'is' => ' — ', # Translate - No russian chars
	'published' => 'опубликовано',
	'unpublished' => 'не опубликовано',
	'review' => 'Обзор',
	'scheduled' => 'запланировано',
	'spam' => 'Спам',
	'Select A User:' => 'Выберите пользователя',
	'User Search...' => 'Поиск пользователя…',
	'Recent Users...' => 'Новые пользователи…',
	'Select...' => 'Выбрать...',

## tmpl/cms/listing/asset_list_header.tmpl
	'You have successfully deleted the asset(s).' => 'Вы успешно удалили медиа.',

## tmpl/cms/listing/association_list_header.tmpl
	'You have successfully revoked the given permission(s).' => 'Предоставленные права успешно отменены.',
	'You have successfully granted the given permission(s).' => 'Предоставленные права успешно назначены.',

## tmpl/cms/listing/author_list_header.tmpl
	'You have successfully disabled the selected user(s).' => 'Выбранные пользователи успешно деактивированы.',
	'You have successfully enabled the selected user(s).' => 'Выбранные пользователи успешно активированы.',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'Выбранные пользователи были успешно удалены из Movable Type.',
	'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Advanced.' => 'Удалённые пользователи всё ещё находся в стороннем каталоге. Поэтому они по-прежнему смогут авторизовываться в Movable Type.',
	q{You have successfully synchronized users' information with the external directory.} => q{Информация о пользователяъ успешно синхронизирована с внешним каталогом.},
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => 'Несколько ([_1])из выбранных пользователей не могут быть реактивированы, так как они больше не существуют во внешнем каталоге.',
	q{An error occured during synchronization.  See the <a href='[_1]'>activity log</a> for detailed information.} => q{При синхронизации произошла ошибка. Более подробная информация содержится в <a href='[_1]'>журнале активности</a>.},

## tmpl/cms/listing/banlist_list_header.tmpl
	'You have added [_1] to your list of banned IP addresses.' => 'Адрес [_1] добавлен в список заблокированных IP адресов.',
	'You have successfully deleted the selected IP addresses from the list.' => 'Выбранные IP адреса удалены из списка.',
	'Invalid IP address.' => 'Неверный IP адрес.',

## tmpl/cms/listing/blog_list_header.tmpl
	'You have successfully deleted the website from the Movable Type system.' => 'Сайт успешно удалён из Movable Type.',
	'You have successfully deleted the blog from the website.' => 'Блог успешно удалён из сайта.',
	'You have successfully refreshed your templates.' => 'Шаблоны успешно обновлены.',
	'You have successfully moved selected blogs to another website.' => 'Выбранные блоги успешно перемещены в другой сайт.',
	'Warning: You need to copy uploaded assets to new locations manually. You should consider maintaining copies of uploaded assets in their original locations to avoid broken links.' => 'Внимение: вам необходимо скопировать медиа в новое место вручную. Также сохранить медиа в предыдущем месте, чтобы избежать ошибок в ссылках.',

## tmpl/cms/listing/comment_list_header.tmpl
	'The selected comment(s) has been approved.' => 'Выбранные комментарии успешно одобрены.',
	'All comments reported as spam have been removed.' => 'Все комментарии, помеченные как спам, были удалены.',
	'The selected comment(s) has been unapproved.' => 'У выбранных комментариев снято одобрение.',
	'The selected comment(s) has been reported as spam.' => 'Выбранные комментарии помечены как спам.',
	'The selected comment(s) has been recovered from spam.' => 'Выбранные комментарии восстановлены из спама.',
	'The selected comment(s) has been deleted from the database.' => 'Выбранные комментарии были удалены навсегда.',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be banned or trusted.' => 'Один или несколько комментариев, которые вы выбрали, оставлены неавторизованными комментаторами. Поэтому вы не можете их заблокировать или добавить в список доверенных.',
	'No comments appear to be spam.' => 'Нет спам-комментариев.',

## tmpl/cms/listing/log_list_header.tmpl
	'All times are displayed in GMT[_1].' => 'Всё время отображено в GMT[_1].',
	'All times are displayed in GMT.' => 'Всё время отображено в GMT.',

## tmpl/cms/listing/notification_list_header.tmpl
	'You have added [_1] to your address book.' => 'Вы успешно добавили [_1] в адресную книгу.',
	'You have successfully deleted the selected contacts from your address book.' => 'Выбранные контакты удалены из адресной книги.',

## tmpl/cms/listing/ping_list_header.tmpl
	'The selected TrackBack(s) has been approved.' => 'Выбранные трекбэки приняты.',
	'All TrackBacks reported as spam have been removed.' => 'Все трекбэки, отмеченные как спам, были удалены.',
	'The selected TrackBack(s) has been unapproved.' => 'Выбранные трекбэки были отклонены',
	'The selected TrackBack(s) has been reported as spam.' => 'Выбранные трекбэки помечены как спам.',
	'The selected TrackBack(s) has been recovered from spam.' => 'Выбранные трекбэки восстановлены из спама.',
	'The selected TrackBack(s) has been deleted from the database.' => 'Выбранные трекбэки удалены из базы данных.',
	'No TrackBacks appeared to be spam.' => 'Среди трекбэков не обнаружено спама.',

## tmpl/cms/listing/role_list_header.tmpl
	'You have successfully deleted the role(s).' => 'Роли успешно удалены.',

## tmpl/cms/listing/tag_list_header.tmpl
	'Your tag changes and additions have been made.' => 'Ваши изменения и дополнения тега добавлены.',
	'You have successfully deleted the selected tags.' => 'Выбранные теги удалены.',
	'Specify new name of the tag.' => 'Укажите новое имя тега',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all blogs?' => 'Тег «[_2]» уже существует. Вы действительно хотите объединить «[_1]» и «[_2]» во всех блогах?',

## tmpl/cms/list_template.tmpl
	'Manage [_1] Templates' => 'Управление шаблонами ([_1])',
	'Manage Global Templates' => 'Управление глобальными шаблонами',
	'Show All Templates' => 'Показать все шаблоны',
	'Publishing Settings' => 'Настройка публикации',
	'You have successfully deleted the checked template(s).' => 'Выбранные шаблоны удалены.',
	'Your templates have been published.' => 'Ваши шаблоны опубликованы.',
	'Selected template(s) has been copied.' => 'Выбранные шаблоны скопированы',

## tmpl/cms/list_theme.tmpl
	'[_1] Themes' => 'Темы ([_1])',
	'All Themes' => 'Все темы',
	'_THEME_DIRECTORY_URL' => 'http://plugins.movabletype.org/', # Translate - No russian chars
	'Find Themes' => 'Искать темы',
	'Theme [_1] has been uninstalled.' => 'Тема [_1] удалена.',
	'Theme [_1] has been applied (<a href="[_2]">[quant,_3,warning,warnings]</a>).' => 'Тема [_1] применена (<a href="[_2]">[quant,_3,ошибка,ошибки,ошибок]</a>).',
	'Theme [_1] has been applied.' => 'Тема [_1] применена.',
	'Failed' => 'не удалось',
	'[quant,_1,warning,warnings]' => '[quant,_1,ошибка,ошибки,ошибок]',
	'Reapply' => 'Применить повторно',
	'In Use' => 'Используется',
	'Uninstall' => 'Удалить',
	'Author: ' => 'Автор:',
	'This theme cannot be applied to the website due to [_1] errors' => 'Эта тема не может быть применена на сайте из-за [_1] ошибок',
	'Errors' => 'Ошибки',
	'Warnings' => 'Предупрежения',
	'Theme Errors' => 'Ошибки темы',
	'Theme Warnings' => 'Предупреждения темы',
	'Portions of this theme cannot be applied to the website. [_1] elements will be skipped.' => 'Части этой темы не могут быть применены на сайт. [quant,_1,элемент,элемента,элементов] будут пропущены.',
	'Theme Information' => 'Информация о теме',
	'No themes are installed.' => 'Нет установленных тем',
	'Current Theme' => 'Текущая тема',
	'Available Themes' => 'Доступные темы',
	'Themes for Both Blogs and Websites' => 'Темы и для блогов, и для сайтов',
	'Themes for Blogs' => 'Темы для блогов',
	'Themes for Websites' => 'Темы для сайтов',

## tmpl/cms/list_widget.tmpl
	'Manage [_1] Widgets' => 'Управление виджетами ([_1])',
	'Manage Global Widgets' => 'Управление глобальными виджетами',
	'Delete selected Widget Sets (x)' => 'Удалить выбранные связки виджетов (x)',
	'Helpful Tips' => 'Полезные подсказки',
	'To add a widget set to your templates, use the following syntax:' => 'Чтобы добавить связку виджетов в ваши шаблоны, используйте следующий синтаксис:',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;Имя связки виджетов&quot;$&gt;</strong>',
	'Your changes to the widget set have been saved.' => 'Изменения в виджетах сохранены.',
	'You have successfully deleted the selected widget set(s) from your blog.' => 'Выбранные связки виджетов удалены из вашего блога.',
	'No widget sets could be found.' => 'Связки виджетов не найдены.',
	'Create widget template' => 'Создать шаблон виджета',

## tmpl/cms/login.tmpl
	'Sign in' => 'Авторизуйтесь',
	'Your Movable Type session has ended.' => 'Ваша сессия Movable Type завершена.',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Ваша сессия Movable Type завершена. Если Вы хотите снова авторизоваться, используйте форму ниже.',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Ваша сессия Movable Type завершена. Пожалуйста, авторизуйтесь заново для продолжения работы.',
	'Sign In (s)' => 'Войти (s)',
	'Forgot your password?' => 'Забыли пароль?',

## tmpl/cms/pinging.tmpl
	'Pinging sites...' => 'Выполняем пинг сайтов…',

## tmpl/cms/popup/pinged_urls.tmpl
	'Successful Trackbacks' => 'Усмешные трекбэки',
	'Failed Trackbacks' => 'Неуспешные трекбэки',
	'To retry, include these TrackBacks in the Outbound TrackBack URLs list for your entry.' => 'Для повторной отправки включите эти трекбэки в список URL исходящих трекбэков.',

## tmpl/cms/popup/rebuild_confirm.tmpl
	'Publish [_1]' => 'Публикация [_1]',
	'Publish <em>[_1]</em>' => 'Публикация <em>[_1]</em>',
	'_REBUILD_PUBLISH' => 'Публикация',
	'All Files' => 'Все файлы',
	'Index Template: [_1]' => 'Индексный шаблон: [_1]',
	'Only Indexes' => 'Только индексные',
	'Only [_1] Archives' => 'Публиковать только архивы [_1]',
	'Publish (s)' => 'Опубликовать (s)',

## tmpl/cms/popup/rebuilt.tmpl
	'Success' => 'Готово',
	'The files for [_1] have been published.' => 'Файлы «[_1]» опубликованы.',
	'Your [_1] archives have been published.' => 'Архивы опубликованы ([_1])',
	'Your [_1] templates have been published.' => 'Шаблоны опубликованы ([_1]).',
	'Publish time: [_1].' => 'Время публикации: [_1]',
	'View your site.' => 'Посмотреть сайт.',
	'View this page.' => 'Посмотреть эту страницу.',
	'Publish Again (s)' => 'Опубликовать ещё раз (s)',
	'Publish Again' => 'Опубликовать ещё раз',

## tmpl/cms/preview_entry.tmpl
	'Preview [_1] Content' => 'Просмотр [_1]', # проверить
	'Return to the compose screen' => 'Вернуться на страницу редактирования',
	'Return to the compose screen (e)' => 'Вернуться на страницу редактирования (e)',
	'Save this entry' => 'Сохранить запись',
	'Save this entry (s)' => 'Сохранить запись (s)',
	'Re-Edit this entry' => 'Повторное редактирование записи',
	'Re-Edit this entry (e)' => 'Повторное редактирование записи (e)',
	'Save this page' => 'Сохранить страницу',
	'Save this page (s)' => 'Сохранить страницу (s)',
	'Re-Edit this page' => 'Повторное редактирование страницы',
	'Re-Edit this page (e)' => 'Повторное редактирование страницы (e)',

## tmpl/cms/preview_strip.tmpl
	'Publish this entry' => 'Опубликовать запись',
	'Publish this entry (s)' => 'Опубликовать запись (s)',
	'Publish this page' => 'Опубликовать страницу',
	'Publish this page (s)' => 'Опубликовать страницу (s)',
	'You are previewing the entry entitled &ldquo;[_1]&rdquo;' => 'Вы просматриваете запись «[_1]»',
	'You are previewing the page entitled &ldquo;[_1]&rdquo;' => 'Вы просматриваете страницу «[_1]»',

## tmpl/cms/preview_template_strip.tmpl
	'You are previewing the template named &ldquo;[_1]&rdquo;' => 'Вы просматриваете шаблон «[_1]»',
	'(Publish time: [_1] seconds)' => '(Время публикации: [quant,_1,секунда,секунды,секунд])',
	'Save this template (s)' => 'Сохранить шаблон (s)',
	'Save this template' => 'Сохранить шаблон',
	'Re-Edit this template (e)' => 'Повторное редактирование шаблоны (e)',
	'Re-Edit this template' => 'Повторное редактирование шаблона',
	'There are no categories in this blog.  Limited preview of category archive templates is possible with a virtual category displayed.  Normal, non-preview output cannot be generated by this template unless at least one category is created.' => 'В этом блоге нет категорий. Возможен ограниченный предпросмотр с использованием виртуальной категории. Однако публикация этого шаблона невозможна, пока не будет создана хотя бы одна категория.',

## tmpl/cms/rebuilding.tmpl
	'Publishing...' => 'Публикация…',
	'Publishing [_1]...' => 'Публикация [_1]…',
	'Publishing <em>[_1]</em>...' => 'Публикация <em>[_1]</em>...',
	'Publishing [_1] [_2]...' => 'Публикация ([_1] [_2])…',
	'Publishing [_1] dynamic links...' => 'Публикация динамических ссылок [_1]…',
	'Publishing [_1] archives...' => 'Публикация архивов [_1]…',
	'Publishing [_1] templates...' => 'Публикация шаблонов [_1]…',
	'Complete [_1]%' => 'Завершено [_1]%',

## tmpl/cms/recover_password_result.tmpl
	'Recover Passwords' => 'Восстановить пароли',
	'No users were selected to process.' => 'Нет выбранных пользователей для процесса.',
	'Return' => 'Вернуться',

## tmpl/cms/refresh_results.tmpl
	'Template Refresh' => 'Обновить шаблоны',
	'No templates were selected to process.' => 'Не выбран шаблон для осуществления этого действия.',
	'Return to templates' => 'Вернуться к шаблонам',

## tmpl/cms/restore_end.tmpl
	q{Make sure that you remove the files that you restored from the 'import' folder, so that if/when you run the restore process again, those files will not be re-restored.} => q{Не забудьте удалить файлы, которые находятся в папке «import», иначе, если вы повторно запустите процесс восстановления, эти файлы буду повторно импортированы.},
	'An error occurred during the restore process: [_1] Please check activity log for more details.' => 'В процессе восстановления произошла ошибка: [_1] Пожалуйста, проверьте журнал активности для получения подробной информации.',

## tmpl/cms/restore_start.tmpl
	'Restoring Movable Type' => 'Восстановление Movable Type',

## tmpl/cms/restore.tmpl
	'Restore from a Backup' => 'Восстановить из бекапа',
	'Perl module XML::SAX and/or some of its dependencies are missing.  Movable Type cannot restore the system without these modules.' => 'Perl-модуль XML::SAX и/или зависимые от него не найдены. Movable Type не может восстановить систему без этих модулей.',
	'Backup File' => 'Файл бекапа',
	q{If your backup file is located on a remote computer, you can upload it here.  Otherwise, Movable Type will automatically look in the 'import' folder within your Movable Type directory.} => q{Если файл с резервной копией находится на вашем компьютере, вы можете загрузить его здесь. Либо Movable Type будет просматривать каталог «import» в директории MT.},
	'Check this and files backed up from newer versions can be restored to this system.  NOTE: Ignoring Schema Version can damage Movable Type permanently.' => 'Проверить это, и файлы бэкапа новых версий могут быть восстановлены в этой системе. ПРИМЕЧАНИЕ: игнорирование схемы версий базы данных может повредить Movable Type навсегда.',
	'Ignore schema version conflicts' => 'Игнорировать конфликты схем версий базы данных',
	'Allow existing global templates to be overwritten by global templates in the backup file.' => 'Разрешить перезаписать текущие глобальные шаблоны глобальными шаблонами из резервной копии.',
	'Overwrite global templates.' => 'Перезаписать глобальные шаблоны.',
	'Restore (r)' => 'Восстановить (r)',

## tmpl/cms/search_replace.tmpl
	'You must select one or more item to replace.' => 'Для замены необходимо выбрать один или несколько объектов.',
	'Search Again' => 'Повторный поиск',
	'Case Sensitive' => 'Чувствительность к регистру',
	'Regex Match' => 'Регулярные выражения',
	'Limited Fields' => 'Ограничение областями',
	'Date Range' => 'Период',
	'Reported as Spam?' => 'Помеченный как спам?',
	'_DATE_FROM' => 'С',
	'_DATE_TO' => 'до',
	'Submit search (s)' => 'Начать поиск (s)',
	'Search For' => 'Поиск',
	'Replace With' => 'Заменять',
	'Replace Checked' => 'Заменить в выделенных',
	'Successfully replaced [quant,_1,record,records].' => 'Замена успешно осуществлена в [quant,_1,объекте,объектах,объектах].',
	'Showing first [_1] results.' => 'Показано [_1] найденных объектов.',
	'Show all matches' => 'Показать все',
	'[quant,_1,result,results] found' => 'найдено [quant,_1,соответствие,соответствия,соответствий]',

## tmpl/cms/setup_initial_website.tmpl
	'Create Your First Website' => 'Создать ваш первый сайт',
	q{In order to properly publish your website, you must provide Movable Type with your website's URL and the filesystem path where its files should be published.} => q{Для того, чтобы можно было опубликовать ваш сайт, необходимо указать URL вашего сайта и путь на сервере, где будут располагаться опубликованные файлы.},
	'My First Website' => 'Мой первый сайт',
	q{The 'Website Root' is the directory in your web server's filesystem where Movable Type will publish the files for your website. The web server must have write access to this directory.} => q{Корневая директория сайта — это папка на сервере, где будут публиковаться файлы сайта.},
	'Select the theme you wish to use for this new website.' => 'Выберите тему, которую вы хотите использовать на этом сайте.',
	'Finish install (s)' => 'Завершить установку (s)',
	'Finish install' => 'Завершить установку',
	'The website name is required.' => 'Необходимо указать имя сайта',
	'The website URL is required.' => 'Необходимо указать URL сайта',
	'Your website URL is not valid.' => 'URL сайта неправильный.',
	'The publishing path is required.' => 'Необходимо указать путь публикации.',
	'The timezone is required.' => 'Необходимо указать часовой пояс.',

## tmpl/cms/system_check.tmpl
	'Total Users' => 'Всего пользователей',
	'Memcache Status' => 'Стутус Memcache',
	'Memcache is [_1].' => 'Memcache [_1]', # Translate - No russian chars
	'Memcache Server is [_1].' => 'Сервер Memcache [_1]',
	'Server Model' => 'Серверная модель',
	q{Movable Type could not find the script named 'mt-check.cgi'. To resolve this issue, ensure that the mt-check.cgi script exists and that the CheckScript configuration parameter (if it is necessary) references it properly.} => q{Movable Type не удалось найти скрипт с именем «mt-check.cgi». Чтобы решить эту проблему, убедитесь, что скрипт с именем mt-check.cgi существует, а также, что в конфигурации CheckScript указано правильное значение (если эта конфигурация используется).},

## tmpl/cms/theme_export_replace.tmpl
	q{Export theme folder already exists '[_1]'. You can overwrite a existing theme, or cancel to change the Basename?} => q{Экспортируемая папка темы уже существует «[_1]». Вы можете перезаписать существующую тему, либо отменить действия и изменить базовое имя.},
	'Overwrite' => 'Перезаписать',

## tmpl/cms/upgrade_runner.tmpl
	'Initializing database...' => 'Инициализация базы данных…',
	'Upgrading database...' => 'Обновление базы данных…',
	'Error during installation:' => 'Ошибка в процессе установки:',
	'Error during upgrade:' => 'Ошибка в процессе обновления:',
	'Return to Movable Type (s)' => 'Вернуться в Movable Type',
	'Return to Movable Type' => 'Продолжить работу с Movable Type',
	'Your database is already current.' => 'Ваша база данных не нуждается в обновлении.',
	'Installation complete!' => 'Установка завершена!',
	'Upgrade complete!' => 'Обновление завершено!',

## tmpl/cms/upgrade.tmpl
	'Time to Upgrade!' => 'Пришло время обновиться!',
	'Upgrade Check' => 'Проверка обновлений',
	'Do you want to proceed with the upgrade anyway?' => 'Хотите продолжить обновление?',
	q{A new version of Movable Type has been installed.  We'll need to complete a few tasks to update your database.} => q{Новая версия Movable Type установлена. Для завершения операции необходимо выполнить несколько задач по обновлению базы данных.},
	q{The Movable Type Upgrade Guide can be found <a href='[_1]' target='_blank'>here</a>.} => q{<a href='[_1]' target='_blank'>Руководство по обновлению Movable Type</a>.},
	'In addition, the following Movable Type components require upgrading or installation:' => 'Кроме того, необходимо обновить или установить следующие компоненты Movable Type:',
	'The following Movable Type components require upgrading or installation:' => 'Необходимо обновить или установить следующие компоненты Movable Type:',
	'Begin Upgrade' => 'Обновление',
	'Congratulations, you have successfully upgraded to Movable Type [_1].' => 'Поздравляем, вы успешно обновили Movable Type до версии [_1].',
	'Your Movable Type installation is already up to date.' => 'Ваш Movable Type не нуждается в обновлении.',

## tmpl/cms/view_log.tmpl
	'The activity log has been reset.' => 'Журнал активности очищен.',
	'System Activity Log' => 'Журнал активности',
	'Filtered' => 'Отфильтрованное',
	'Filtered Activity Feed' => 'Отфильтрованная активность',
	'Download Filtered Log (CSV)' => 'Скачать отфильтрованный журнал активности (CSV)',
	'Showing all log records' => 'Показаны все записи журнала',
	'Showing log records where' => 'Показаны записи журнала, у которых',
	'Show log records where' => 'Показать записи, у которых',
	'level' => 'статус',
	'classification' => 'классификация',

## tmpl/cms/view_rpt_log.tmpl
	'Schwartz Error Log' => 'Журнал ошибок Schwartz',
	'Showing all Schwartz errors' => 'Показать все ошибки Schwartz',

## tmpl/cms/widget/blog_stats_comment.tmpl
	'Most Recent Comments' => 'Последние комментарии',
	'[_1] [_2], [_3] on [_4]' => '[_1] [_2], [_3] — [_4]', # Translate - No russian chars
	'View all comments' => 'Все комментарии',
	'No comments available.' => 'Пока что нет комментариев.',

## tmpl/cms/widget/blog_stats_entry.tmpl
	'Most Recent Entries' => 'Последние записи',
	'Posted by [_1] [_2] in [_3]' => 'Добавил [_1], категории: [_3], [_2]',
	'Posted by [_1] [_2]' => 'Добавил [_1] [_2]',
	'Tagged: [_1]' => 'Теги: [_1]',
	'View all entries' => 'Посмотреть все записи',
	'No entries have been created in this blog. <a href="[_1]">Create a entry</a>' => 'В этом блоге нет записей. <a href="[_1]">Создать новую?</a>',

## tmpl/cms/widget/blog_stats_recent_entries.tmpl
	'[quant,_1,entry,entries] tagged &ldquo;[_2]&rdquo;' => '[quant,_1,запись,записи,записей], связанных с тегом «[_2]»',
	'No entries available.' => 'Нет доступных записей.',

## tmpl/cms/widget/blog_stats.tmpl
	'Error retrieving recent entries.' => 'Ошибка при получении последних записей.',
	'Loading recent entries...' => 'Загрузка последних записей…',
	'Jan.' => '&#1071;&#1085;&#1074;.', # Translate - No russian chars
	'Feb.' => '&#1060;&#1077;&#1074;.', # Translate - No russian chars
	'March' => 'Март',
	'April' => 'Апрель',
	'May' => 'Май',
	'June' => 'Июнь',
	'July.' => '&#1048;&#1102;&#1083;&#1100;', # Translate - No russian chars
	'Aug.' => '&#1040;&#1074;&#1075.', # Translate - No russian chars
	'Sept.' => '&#1057;&#1077;&#1085;&#1090;.', # Translate - No russian chars
	'Oct.' => '&#1054;&#1082;&#1090;.', # Translate - No russian chars
	'Nov.' => '&#1053;&#1086;&#1103;.', # Translate - No russian chars
	'Dec.' => '&#1044;&#1077;&#1082;.', # Translate - No russian chars
	'[_1] [_2] - [_3] [_4]' => '[_1] [_2] — [_3] [_4]',
	'You have <a href=\'[_3]\'>[quant,_1,comment,comments] from [_2]</a>' => 'У вас <a href=\'[_3]\'>[quant,_1,комментарий,комментария,комментариев] в [_2]</a>',
	'You have <a href=\'[_3]\'>[quant,_1,entry,entries] from [_2]</a>' => 'У вас <a href=\'[_3]\'>[quant,_1,запись,записи,записей] в [_2]</a>',

## tmpl/cms/widget/custom_message.tmpl
	'This is you' => 'Это вы',
	'Welcome to [_1].' => 'Добро пожаловать в [_1].',
	'You can manage your blog by selecting an option from the menu located to the left of this message.' => 'Вы можете управлять вашим блогом, выбирая различный опции из меню, расположенного в левом углу от этого сообщения.',
	'If you need assistance, try:' => 'Если вам необходима помощь, вы можете проконсультироваться у:',
	'Movable Type User Manual' => 'Руководство пользователя Movable Type',
	'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.com/movabletype/support', # Translate - Not translated
	'Movable Type Technical Support' => 'Техническая поддержка Movable Type',
	'Movable Type Community Forums' => 'Форум сообщества Movable Type ',
	'Change this message.' => 'Изменить это сообщение.',
	'Edit this message.' => 'Редактировать это сообщение.',

## tmpl/cms/widget/favorite_blogs.tmpl
	'Your recent websites and blogs' => 'Ваши последние сайты и блоги',
	'[quant,_1,blog,blogs]' => '[quant,_1,блог,блога,блогов]',
	'[quant,_1,page,pages]' => '[quant,_1,страница,страницы,страниц]',
	'[quant,_1,comment,comments]' => '[quant,_1,комментарий,комментария,комментариев]',
	'No website could be found. [_1]' => 'Сайты не найдены. [_1]',
	'Create a new' => 'Создать',
	'[quant,_1,entry,entries]' => '[quant,_1,запись,записи,записей]',
	'No blogs could be found.' => 'Блогов не найдено.',

## tmpl/cms/widget/mt_news.tmpl
	'News' => 'Новости',
	'MT News' => 'Новости MT',
	'Learning MT' => 'Изучая Movable Type',
	'Hacking MT' => 'Hacking MT', # Translate - Not translated
	'Pronet' => 'Pronet', # Translate - Not translated
	'No Movable Type news available.' => 'Нет доступных новостей от Movable Type.',
	'No Learning Movable Type news available.' => 'Нет доступных новостей из блога «Изучая Movable Type».',

## tmpl/cms/widget/mt_shortcuts.tmpl
	'Handy Shortcuts' => 'Быстрый доступ',
	'Import Content' => 'Импорт контента',
	'Blog Preferences' => 'Настройка блога',

## tmpl/cms/widget/new_install.tmpl
	'Thank you for installing Movable Type' => 'Спасибо за установку Movable Type',
	'You are now ready to:' => 'Теперь вы можете:',
	'Create a new page on your website' => 'Создавать новые страницы на сайте',
	'Create a blog on your website' => 'Создавать блоги на сайте',
	'Create a blog (many blogs can exist in one website) to start posting.' => 'Чтобы создавать записи, необходимо создать блог (один сайт может содержать множество блогов).',
	'Movable Type Online Manual' => 'Руководство Movable Type',
	q{Whether you're new to Movable Type or using it for the first time, learn more about what this tool can do for you.} => q{Вы только что установили Movable Type и, возможно, пока не знаете, на что способна эта платформа. Посмотрите, что этот инструмент может сделать для вас.},

## tmpl/cms/widget/new_user.tmpl
	q{Welcome to Movable Type, the world's most powerful blogging, publishing and social media platform:} => q{Добро пожаловать в Movable Type — самую мощную блогинг-платформу в мире, с помощью которой вы можете публиковать материалы и создать собственное социальное медиа.},

## tmpl/cms/widget/new_version.tmpl
	q{What's new in Movable Type [_1]} => q{Что нового в Movable Type [_1]},

## tmpl/cms/widget/recent_blogs.tmpl
	'No blogs could be found. [_1]' => 'Блоги не найдены. [_1]',

## tmpl/cms/widget/this_is_you.tmpl
	'Your <a href="[_1]">last entry</a> was [_2] in <a href="[_3]">[_4]</a>.' => 'Ваша <a href="[_1]">последняя запись</a> создана [_2] в блоге <a href="[_3]">[_4]</a>.',
	'Your last entry was [_1] in <a href="[_2]">[_3]</a>.' => 'Ваша последняя запись создана [_1] в блоге <a href="[_2]">[_3]</a>.',
	'You have <a href="[_1]">[quant,_2,draft,drafts]</a>.' => 'Также у вас есть <a href="[_1]">[quant,_2,черновик,черновика,черновиков]</a>.',
	'You have [quant,_1,draft,drafts].' => 'Также у вас есть [quant,_1,черновик,черновика,черновиков]',
	q{You've written <a href="[_1]">[quant,_2,entry,entries]</a>, <a href="[_3]">[quant,_4,page,pages]</a> with <a href="[_5]">[quant,_6,comment,comments]</a>.} => q{Вы создали <a href="[_1]">[quant,_2,запись,записи,записей]</a>, <a href="[_3]">[quant,_4,страницу,страницы,страниц]</a>, которые <a href="[_5]">прокомментировали  [quant,_6,раз,раза,раз]</a>.},
	q{You've written <a href="[_1]">[quant,_2,entry,entries]</a>, <a href="[_3]">[quant,_4,page,pages]</a> with [quant,_5,comment,comments].} => q{Вы создали <a href="[_1]">[quant,_2,запись,записи,записей]</a>, <a href="[_3]">[quant,_4,страницу,страницы,страниц]</a>, которые прокомментировали [quant,_5,раз,раза,раз].},
	q{You've written <a href="[_1]">[quant,_2,entry,entries]</a>, [quant,_3,page,pages] with <a href="[_4]">[quant,_5,comment,comments]</a>.} => q{Вы создали <a href="[_1]">[quant,_2,запись,записи,записей]</a>, [quant,_3,страницу,страницы,страниц], которые прокомментировали <a href="[_4]">[quant,_5,раз,раза,раз]</a>.},
	q{You've written <a href="[_1]">[quant,_2,entry,entries]</a>, [quant,_3,page,pages] with [quant,_4,comment,comments].} => q{Вы создали <a href="[_1]">[quant,_2,запись,записи,записей]</a>, [quant,_3,страницу,страницы,страниц], которые прокомментировали [quant,_4,раз,раза,раз].},
	q{You've written [quant,_1,entry,entries], <a href="[_2]">[quant,_3,page,pages]</a> with <a href="[_4]">[quant,_5,comment,comments]</a>.} => q{Вы создали [quant,_1,запись,записи,записей], <a href="[_2]">[quant,_3,страницу,страницы,страниц]</a>, которые прокомментировали <a href="[_4]">[quant,_5,раз,раза,раз]</a>.},
	q{You've written [quant,_1,entry,entries], <a href="[_2]">[quant,_3,page,pages]</a> with [quant,_4,comment,comments].} => q{Вы создали [quant,_1,запись,записи,записей], <a href="[_2]">[quant,_3,страницу,страницы,страниц]</a>, которые прокомментировали [quant,_4,раз,раза,раз].},
	q{You've written [quant,_1,entry,entries], [quant,_2,page,pages] with <a href="[_3]">[quant,_4,comment,comments]</a>.} => q{Вы создали [quant,_1,запись,записи,записей], [quant,_2,страницу,страницы,страниц], которые прокомментировали <a href="[_3]">[quant,_4,раз,раза,раз]</a>.},
	q{You've written [quant,_1,entry,entries], [quant,_2,page,pages] with [quant,_3,comment,comments].} => q{Вы создали [quant,_1,запись,записи,записей], [quant,_2,страницу,страницы,страниц], которые прокомментировали [quant,_3,раз,раза,раз].},
	q{You've written <a href="[_1]">[quant,_2,entry,entries]</a>, <a href="[_3]">[quant,_4,page,pages]</a>.} => q{Вы создали <a href="[_1]">[quant,_2,запись,записи,записей]</a>, <a href="[_3]">[quant,_4,страницу,страницы,страниц]</a>.},
	q{You've written <a href="[_1]">[quant,_2,entry,entries]</a>, [quant,_3,page,pages].} => q{Вы создали <a href="[_1]">[quant,_2,запись,записи,записей]</a>, [quant,_3,страницу,страницы,страниц].},
	q{You've written [quant,_1,entry,entries], <a href="[_2]">[quant,_3,page,pages]</a>.} => q{Вы создали [quant,_1,запись,записи,записей], <a href="[_2]">[quant,_3,страницу,страницы,страниц]</a>.},
	q{You've written [quant,_1,entry,entries], [quant,_2,page,pages].} => q{Вы создали [quant,_1,запись,записи,записей], [quant,_2,страницу,страницы,страниц].},
	q{You've written <a href="[_1]">[quant,_2,page,pages]</a> with <a href="[_3]">[quant,_4,comment,comments]</a>.} => q{Вы создали <a href="[_1]">[quant,_2,страницу,страницы,страниц]</a>, которые прокомментировали <a href="[_3]">[quant,_4,раз,раза,раз]</a>.},
	q{You've written <a href="[_1]">[quant,_2,page,pages]</a> with [quant,_3,comment,comments].} => q{Вы создали <a href="[_1]">[quant,_2,страницу,страницы,страниц]</a>, которые прокомментировали [quant,_3,раз,раза,раз].},
	q{You've written [quant,_1,page,pages] with <a href="[_2]">[quant,_3,comment,comments]</a>.} => q{Вы создали [quant,_1,страницу,страницы,страниц], которые прокомментировали <a href="[_2]">[quant,_3,раз,раза,раз]</a>.},
	q{You've written [quant,_1,page,pages] with [quant,_2,comment,comments].} => q{Вы создали [quant,_1,страницу,страницы,страниц], которые прокомментирвоали [quant,_2,раз,раза,раз].},
	'Edit your profile' => 'Редактировать профиль',

## tmpl/comment/auth_aim.tmpl
	'Your AIM or AOL Screen Name' => 'Отображаемое имя в AIM или AOL (Screen Name)',
	'Sign in using your AIM or AOL screen name. Your screen name will be displayed publicly.' => 'Авторизоваться с помощью отображаемого имени AIM или AOL. Отображаемое имя будет доступно публично.',

## tmpl/comment/auth_googleopenid.tmpl
	'Sign in using your Gmail account' => 'Авторизоваться через GMail-аккаунт',
	'Sign in to Movable Type with your[_1] Account[_2]' => 'Авторизоваться в Movable Type, используя ваш [_1] аккаунт [_2]',

## tmpl/comment/auth_hatena.tmpl
	'Your Hatena ID' => 'Ваш ID в Hatena',

## tmpl/comment/auth_livejournal.tmpl
	'Your LiveJournal Username' => 'Ваш логин в LiveJournal',
	'Learn more about LiveJournal.' => 'Узнать больше о LiveJournal.',

## tmpl/comment/auth_openid.tmpl
	'OpenID URL' => 'OpenID URL', # Translate - Not translated
	'Sign in with one of your existing third party OpenID accounts.' => 'Авторизация с помощью OpenID-аккаунта',
	'http://www.openid.net/' => 'http://www.openid.net/', # Translate - Not translated
	'Learn more about OpenID.' => 'Узнать больше об OpenID.',

## tmpl/comment/auth_typepad.tmpl
	'TypePad is a free, open system providing you a central identity for posting comments on weblogs and logging into other websites. You can register for free.' => 'TypePad — это бесплатная, открытая система, предоставляющая возможность централизованной идентификации для комментирования различных сайтов. Регистрация бесплатна.',
	'Sign in or register with TypePad.' => 'Авторизоваться или зарегистрироваться в TypePad.',

## tmpl/comment/auth_vox.tmpl
	'Your Vox Blog URL' => 'Адрес вашего блога на Vox',
	'Learn more about Vox.' => 'Узнать больше о Vox.',

## tmpl/comment/auth_wordpress.tmpl
	'Your Wordpress.com Username' => 'Имя пользователя Wordpress.com',
	'Sign in using your WordPress.com username.' => 'Авторизоваться с помощью логина на Wordpress.com',

## tmpl/comment/auth_yahoojapan.tmpl
	'Turn on OpenID for your Yahoo! Japan account now' => 'ктивировать OpenID для своего Yahoo! Japan',

## tmpl/comment/auth_yahoo.tmpl
	'Turn on OpenID for your Yahoo! account now' => 'Активировать OpenID для своего аккаунта Yahoo!',

## tmpl/comment/error.tmpl
	'Back (s)' => 'Вернуться (s)',

## tmpl/comment/login.tmpl
	'Sign in to comment' => 'Авторизация',
	'Sign in using' => 'Войти используя',
	'Not a member? <a href="[_1]">Sign Up</a>!' => 'Вы можете <a href="[_1]">зарегистрироваться</a> на этом сайте!',

## tmpl/comment/profile.tmpl
	'Your Profile' => 'Ваш профиль',
	'Your login name.' => 'Логин (используется для входа)',
	'The name appears on your comment.' => 'Это имя будет отображаться рядом с вашими комментариями.',
	'Your email address.' => 'Email', # Translate - No russian chars
	'Select a password for yourself.' => 'Введите пароль.',
	'The URL of your website. (Optional)' => 'Адрес вашего сайта (по желанию).',
	'Return to the <a href="[_1]">original page</a>.' => 'Вернуться на  <a href="[_1]">первоначальную страницу</a>.',

## tmpl/comment/register.tmpl
	'Create an account' => 'Регистрация пользователя',
	'Register' => 'Зарегистрироваться',

## tmpl/comment/signup_thanks.tmpl
	'Thanks for signing up' => 'Спасибо за регистрацию',
	'Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].' => 'Перед тем, как вы сможете оставлять комментарии, вы должны завершить процесс регистрации путём активации своего аккаунта. Сообщение было отправлено на [_1].',
	'To complete the registration process you must first confirm your account. An email has been sent to [_1].' => 'Для завершения процесса регистрации необходимо активировать свой аккаунт. Вам было отправлено письмо на адрес [_1].',
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'Для подтверждения и активации вашего аккаунта, пожалуйста, проверьте почту и перейдите по ссылке в письме, которое мы вам отправили.',
	'Return to the original entry.' => 'Вернуться к записи.',
	'Return to the original page.' => 'Вернуться к странице.',

## tmpl/comment/signup.tmpl
	'Password Confirm' => 'Ещё раз',

## tmpl/error.tmpl
	'Missing Configuration File' => 'Файл конфигурации не найден',
	'_ERROR_CONFIG_FILE' => 'Файл конфигурации Movable Type отсутствует или не может быть прочитан. Пожалуйста, ознакомьтесь с базой знаний.',
	'Database Connection Error' => 'Ошибка соединения с базой данных',
	'_ERROR_DATABASE_CONNECTION' => 'Параметры соединения с базой данных неверны, отсутствуют, либо не могут быть правильно прочитаны. Для получения большей информации ознакомьтесь с базой знаний.',
	'CGI Path Configuration Required' => 'Необходима указать путь CGI',
	'_ERROR_CGI_PATH' => 'Путь CGI, указанный в конфигурации, неправильный или вообще отсутствует в файле конфигурации. Пожалуйста, ознакомьтесь с базой знаний.',

## tmpl/feeds/error.tmpl
	'Movable Type Activity Log' => 'Журнал активности Movable Type',

## tmpl/feeds/feed_comment.tmpl
	'Unpublish' => 'Отменить публикацию',
	'More like this' => 'Ещё подобное этому',
	'From this blog' => 'Из этого блога',
	'On this entry' => 'К этой записи',
	'By commenter identity' => 'От комментатора с таким идентификатором',
	'By commenter name' => 'От комментатора с таким именем',
	'By commenter email' => 'От комментатора с таким email',
	'By commenter URL' => 'От комментатора с таким URL',
	'On this day' => 'В течении этого дня',

## tmpl/feeds/feed_entry.tmpl
	'From this author' => 'От этого автора',

## tmpl/feeds/feed_ping.tmpl
	'Source blog' => 'Блог-источник',
	'By source blog' => 'С этого блога',
	'By source title' => 'С таким же названием',
	'By source URL' => 'С таким же URL',

## tmpl/feeds/login.tmpl
	'This link is invalid. Please resubscribe to your activity feed.' => 'Неправильная ссылка. Пожалуйста, переподпишитесь на фид активности.',

## tmpl/wizard/blog.tmpl
	'Setup Your First Blog' => 'Настройка вашего первого блога',
	q{In order to properly publish your blog, you must provide Movable Type with your blog's URL and the path on the filesystem where its files should be published.} => q{Чтобы Movable Type смог обеспечить работу вашего блога, необходимо указать его URL и путь публикации (абсолютный путь на сервере).},
	'My First Blog' => 'Мой первый блог',
	'Publishing Path' => 'Путь публикации',
	q{Your 'Publishing Path' is the path on your web server's file system where Movable Type will publish all the files for your blog. Your web server must have write access to this directory.} => q{Ваш путь публикации — это путь на веб-сервере, где будут располагаться сгенерированные Movable Type файлы. Эта директория должна быть перезаписываема.},

## tmpl/wizard/cfg_dir.tmpl
	'Temporary Directory Configuration' => 'Конфигурация временного каталога',
	'You should configure you temporary directory settings.' => 'Вам необходимо указать временный каталог в параметрах.',
	q{Your TempDir has been successfully configured. Click 'Continue' below to continue configuration.} => q{Временный каталог сконфигурирован. Нажмите «Продолжить» для дальнейшей настройки.},
	'[_1] could not be found.' => '[_1] отсутствует.',
	'TempDir is required.' => 'TempDir обязательна.',
	'TempDir' => 'TempDir', # Translate - Not translated
	'The physical path for temporary directory.' => 'Физический адрес временного каталога.',

## tmpl/wizard/complete.tmpl
	'Configuration File' => 'Файл конфигурации',
	q{The [_1] configuration file can't be located.} => q{Файл конфигурации [_1] не найден},
	q{Please use the configuration text below to create a file named 'mt-config.cgi' in the root directory of [_1] (the same directory in which mt.cgi is found).} => q{Создайте файл «mt-config.cgi», расположенный в корневой директории Movable Type [_1] (в этой директории находится скрипт mt.cgi).},
	'The wizard was unable to save the [_1] configuration file.' => 'Помошнику не удалось создать файл конфигурации [_1].',
	q{Confirm that your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click 'Retry'.} => q{Проверьте, является ли каталог [_1] (там находится mt.cgi) доступным для записи и нажмите «Повторить».},
	q{Congratulations! You've successfully configured [_1].} => q{Поздравляем! Вы успешно настроили [_1].},
	'Your configuration settings have been written to the following file:' => 'Параметры сохранены в следующем файле:',
	'Show the mt-config.cgi file generated by the wizard' => 'Показать файл mt-config.cgi, сгенерированный помошником',
	'The mt-config.cgi file has been created manually.' => 'Файл mt-config.cgi был создан вручную.',
	'Retry' => 'Повторить',

## tmpl/wizard/configure.tmpl
	'Database Configuration' => 'Настройка базы данных',
	'Your database configuration is complete.' => 'Настройка базы данных завершена.',
	'You may proceed to the next step.' => 'Вы можете приступить к следующему шагу.',
	'Show Current Settings' => 'Показать текущие параметры',
	'Please enter the parameters necessary for connecting to your database.' => 'Пожалуйста, укажите необходимые параметры для соединения с базой данных.',
	'Database Type' => 'Тип базы данных',
	'Select One...' => 'Выберите один…',
	'http://www.movabletype.org/documentation/[_1]' => 'http://www.movabletype.org/documentation/[_1]', # Translate - Not translated
	'Is your preferred database not listed? View the <a href="[_1]" target="_blank">Movable Type System Check</a> see if additional modules are necessary.' => 'Вашей базы данных нет в списке? Попробуйте <a href="[_1]" target="_blank">проверку системы от Movable Type</a>, чтобы узнать, необходимы ли дополнительные модули.',
	'Once installed, <a href="javascript:void(0)" onclick="[_1]">click here to refresh this screen</a>.' => 'После установки <a href="javascript:void(0)" onclick="[_1]">нажмите здесь для обновления страницы</a>.',
	'Read more: <a href="[_1]" target="_blank">Setting Up Your Database</a>' => 'Узнать больше: <a href="[_1]" target="_blank">Настройка вашей базы данных</a>',
	'Show Advanced Configuration Options' => 'Показать дополнительные опции',
	'Test Connection' => 'Тестовое соединение',
	'You must set your Database Path.' => 'Необходимо указать расположение базы данных.',
	'You must set your Username.' => 'Необходимо указать ваше имя пользователя.',
	'You must set your Database Server.' => 'Необходимо указать сервер базы данных.',

## tmpl/wizard/optional.tmpl
	'Mail Configuration' => 'Конфигурация почты',
	'Your mail configuration is complete.' => 'Почтовые параметры сконфигурированы.',
	'Check your email to confirm receipt of a test email from Movable Type and then proceed to the next step.' => 'Проверьте свой почтовый ящик, чтобы убедиться в получении тестового письма от Movable Type, а затем перейдите к следующему шагу.',
	'Show current mail settings' => 'Показать текущие параметры почты',
	'Periodically Movable Type will send email for password recovery, to inform authors of new comments, and other events. If not using Sendmail (default on unix servers), an SMTP Server must be specified.' => 'Периодически Movable Type будет отправлять письма: для восстановления пароля, информирования авторов о новых комментариях и других событиях. Если вы не используете Sendmail (по умолчанию на Linux/Unix серверах), необходимо указать параметры SMTP сервера.',
	'An error occurred while attempting to send mail: ' => 'Ошибка при попытке отправке письма: ',
	'Send email via:' => 'Отправлять почту через:',
	'sendmail Path' => 'Местонахождение sendmail',
	'The physical file path for your sendmail binary.' => 'Физический путь к программе sendmail.',
	'Outbound Mail Server (SMTP)' => 'Сервер исходящей почты (SMTP)',
	'Address of your SMTP Server.' => 'Адрес на вашем SMTP.',
	'Mail address to which test email should be sent' => 'Адрес, на который будет отправлено тестовое письмо',
	'From mail address' => 'Адрес, с которого отправить',

## tmpl/wizard/packages.tmpl
	'Requirements Check' => 'Проверка необходимых компонентов',
	q{The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your blog's data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the 'Retry' button.} => q{Следующие модули Perl необходимы для соединения с базой данных. База данных необходима для хранения информации из вашего блога. Прежде чем продолжить, установите, пожалуйста, один из следующих пакетов, указанных ниже.},
	'All required Perl modules were found.' => 'Все обязательные модули Perl найдены.',
	'You are ready to proceed with the installation of Movable Type.' => 'Вы можете приступить к установке Movable Type.',
	'Some optional Perl modules could not be found. <a href="javascript:void(0)" onclick="[_1]">Display list of optional modules</a>' => 'Некоторые опциональные модуль Perl не найдены. <a href="javascript:void(0)" onclick="[_1]">Показать список опциональных модулей</a>',
	'One or more Perl modules required by Movable Type could not be found.' => 'Один или несколько модулей Perl, необходимых для работы Movable Type, не найдены.',
	q{The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the 'Retry' button to re-test for these packages.} => q{Следущие модули Perl необходимы для работы Movable Type. Как только эти модули будут установлены, нажмите кнопку «Повторить», чтобы повторно проверить их.},
	q{Some optional Perl modules could not be found. You may continue without installing these optional Perl modules. They may be installed at any time if they are needed. Click 'Retry' to test for the modules again.} => q{Некоторые опциональные модули Perl не найдены. Вы можете продолжить, не устанавливая их сейчас. Если же вы установили их, нажмите кнопку «Повторить».},
	'Missing Database Modules' => 'Отсутствует модуль базы данных',
	'Missing Optional Modules' => 'Отсутствуют опциональные модули',
	'Missing Required Modules' => 'Отсутствуют обязательные модули',
	'Minimal version requirement: [_1]' => 'Минимальная версия: [_1]',
	'http://www.movabletype.org/documentation/installation/perl-modules.html' => 'http://www.movabletype.org/documentation/installation/perl-modules.html', # Translate - Not translated
	'Learn more about installing Perl modules.' => 'Узнать больше об установке модулей Perl.',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'На вашем сервере установлены все обязательные модули; вы не нуждаетесь в установке опциональных модулей.',

## tmpl/wizard/start.tmpl
	'Configuration File Exists' => 'Найден файл конфигурации',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'Для работы с Movable Type необходимо, чтобы у вас был включен JavaScript. Вкючите его и обновите эту страницу.',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'Этот помошник поможет вам указать базовые параметры, которые необходимы для запуска Movable Type.',
	'Default language.' => 'Язык по умолчанию.',
	'Configure Static Web Path' => 'Параметры адреса статических файлов',
	q{<strong>Error: '[_1]' could not be found.</strong>  Please move your static files to the directory first or correct the setting if it is incorrect.} => q{<strong>Ошибка: «[_1]» не найден.</strong>  Пожалуйста, переместите статические файлы в первичную директорию или скорректируйте параметры.},
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Type связан с каталогом [_1], в котором содержится множество важных файлов — графика, javascript файлы и таблицы стилей.',
	q{The [_1] directory is in the main Movable Type directory which this wizard script resides, but due to your web server's configuration, the [_1] directory is not accessible in this location and must be moved to a web-accessible location (e.g., your web document root directory).} => q{Папка [_1] находится в основной директории Movable Type (здесь содержатся все скрипты, включая скрипт этого помошника). Параметры вашего сервера не позволяют просматривать статические файлы в этой директори, поэтому переместите папку [_1] в общедоступное место (например, вкорневой каталог вашего сайта). },
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'Этот каталог был переименован или перемещён в местоположение, распологающееся вне каталога Movable Type.',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => 'Можно просто переместить папку [_1] в другое место или создать символическую ссылку. После того, как это будет сделано, укажите необходимую информацию в следующие поля.',
	'This URL path can be in the form of [_1] or simply [_2]' => 'Этот URL может быть в форме [_1] или просто [_2]',
	'This path must be in the form of [_1]' => 'Этот путь может быть в форме [_1]',
	'Static web path' => 'Адрес статических файлов',
	'Static file path' => 'Путь на сервере к статическим файлам',
	'Begin' => 'Приступить',
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => 'Файл конфигурации (mt-config.cgi) уже существует, <a href="[_1]">авторизуйтесь</a> в Movable Type.',
	'To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page' => 'Чтобы создать новый файл конфигурации, удалите старый и обновите эту страницу.',

## plugins/Markdown/Markdown.pl
	'A plain-text-to-HTML formatting plugin.' => 'Плагин для форматирования обычного текста в HTML',
	'Markdown' => 'Markdown', # Translate - Not translated
	'Markdown With SmartyPants' => 'Markdown и SmartyPants',

## plugins/Markdown/SmartyPants.pl
	q{Easily translates plain punctuation characters into 'smart' typographic punctuation.} => q{Позволяет преобразовать обычный текст в текст с правильно оформленной пунктуацией (например: кавычки, тире, и т.д.).},

## plugins/MultiBlog/lib/MultiBlog.pm
	'Restoring MultiBlog rebuild trigger for blog #[_1]...' => 'Восстановление значений MultiBlog для блога #[_1]…',

## plugins/MultiBlog/lib/MultiBlog/Tags.pm
	'MTMultiBlog tags cannot be nested.' => 'Теги MTMultiBlog не могут быть вложенными.',
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'Неизвестное значение атрибута "mode": [_1]. Правильные значения: "loop" и "context".',

## plugins/MultiBlog/multiblog.pl
	'MultiBlog allows you to publish content from other blogs and define publishing rules and access controls between them.' => 'MultiBlog позволяет публиковать содержимое из нескольких блогов в одном, определяя правила публикации и контроль доступа между ними.',
	'MultiBlog' => 'MultiBlog', # Translate - Not translated
	'Create Trigger' => 'Создать условие',
	'Search Weblogs' => 'Найти блоги',
	'When this' => 'когда это',
	'(All blogs in this website)' => '(Все блоги на этом сайте)',
	'Select to apply this trigger to all blogs in this website.' => 'Выберите для применения этого правила ко всем блогам этого сайта.',
	'(All websites and blogs in this system)' => '(Все сайты и блоги в этой системе)',
	'Select to apply this trigger to all websites and blogs in this system.' => 'Выберите для применения этого правила ко всем сайтам и блогам в этой системе.',
	'saves an entry/page' => 'сохраняется запись/страница',
	'publishes an entry/page' => 'публикуется запись/страница',
	'publishes a comment' => 'публикуется комментарий',
	'publishes a TrackBack' => 'публикуется трекбэк',
	'rebuild indexes.' => 'публиковать индексные шаблоны.',
	'rebuild indexes and send pings.' => 'публиковать индексные шаблоны и отправлять пинги.',

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'When' => 'Когда',
	'Trigger' => 'Событие',
	'Action' => 'Действие',
	'Weblog' => 'Блог',
	'Content Privacy' => 'Политика приватности',
	'Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.' => 'Укажите, могут ли другие блоги получать контент с этого блога. Эта опция приоритетнее указанных настроек MultiBlog на системном уровне.',
	'Use system default' => 'Использовать параметры по умолчанию',
	'Allow' => 'Разрешить',
	'Disallow' => 'Запретить',
	'MTMultiBlog tag default arguments' => 'Аргументы тега MTMultiBlog по умолчанию',
	q{Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or 'all' (include_blogs only) are acceptable values.} => q{Разрешить использование тега MTMultiBlog без атрибутов include_blogs/exclude_blogs. Правильные значения здесь — ID блогов, разделённые запятыми, или значение «all» (только для include_blogs).},
	'Include blogs' => 'Включить блоги',
	'Exclude blogs' => 'Исключить блоги',
	'Rebuild Triggers' => 'Условия публикации',
	'Create Rebuild Trigger' => 'Создать условие публикации',
	'You have not defined any rebuild triggers.' => 'У вас ещё не создано условия для публикации.',

## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
	'Create MultiBlog Trigger' => 'Создать условие MultiBlog',

## plugins/MultiBlog/tmpl/system_config.tmpl
	'Default system aggregation policy' => 'Системная политика агрегации по умолчанию',
	'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'Кросс-блоговая агрегация по умолчанию активна. В каждом блоге в параметрах MultiBlog можно запретить передачу контента в другие блоги.',
	'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'Кросс-блоговая агрегация по умолчанию выключена. В каждом блоге в параметрах MultiBlog можно разрешить передачу контента в другие блоги.',

## plugins/spamlookup/lib/spamlookup.pm
	'Failed to resolve IP address for source URL [_1]' => 'Не удалось проверить IP адрес для URL [_1]',
	'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'Модерация: IP домена не соответствует IP адресу, с которого отправлен пинг: [_1]; IP домена: [_2]; IP пингующего: [_3]',
	'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'IP домена не соответствует IP адресу, с которого отправлен пинг: [_1]; IP домена: [_2]; IP пингующего: [_3]',
	'No links are present in feedback' => 'Не предоставлено ссылок',
	'Number of links exceed junk limit ([_1])' => 'Количество ссылок превысило допустимый лимит для спама ([_1])',
	'Number of links exceed moderation limit ([_1])' => 'Количество ссылок превысило допустимый лимит для модерации ([_1])',
	'Link was previously published (comment id [_1]).' => 'Ссылка уже была опубликована (id комментария [_1]).',
	'Link was previously published (TrackBack id [_1]).' => 'Ссылка уже была опубликована (id трекбэка [_1]).',
	'E-mail was previously published (comment id [_1]).' => 'Email уже был опубликован (id комментария [_1]).',
	'Word Filter match on \'[_1]\': \'[_2]\'.' => 'Фильтр по словам соответствует «[_1]»: «[_2]».',
	'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'Модерация по фильтру слова «[_1]»: «[_2]».',
	'domain \'[_1]\' found on service [_2]' => 'домен «[_1]» присутствует в сервисе [_2]',
	'[_1] found on service [_2]' => '[_1] присутствует в сервисе [_2]',

## plugins/spamlookup/spamlookup.pl
	'SpamLookup module for using blacklist lookup services to filter feedback.' => 'Плагин SpamLookup используется для фильтрации комментариев с использованием чёрного списка.',
	'SpamLookup IP Lookup' => 'SpamLookup — проверка IP',
	'SpamLookup Domain Lookup' => 'SpamLookup — проверка доменов',
	'SpamLookup TrackBack Origin' => 'SpamLookup — происхождение трекбэков',
	'Despam Comments' => 'Комментарии не спам',
	'Despam TrackBacks' => 'Трекбэки не спам',
	'Despam' => 'Не спам',

## plugins/spamlookup/spamlookup_urls.pl
	'SpamLookup module for junking and moderating feedback based on link filters.' => 'Плагин SpamLookup используется для отправки на модерацию комментариев и трекбэков, отфильтрованных по ссылкам.',
	'SpamLookup Link Filter' => 'Фильтр ссылок SpamLookup',
	'SpamLookup Link Memory' => 'Политика ссылок SpamLookup',
	'SpamLookup Email Memory' => 'Политика email SpamLookup',

## plugins/spamlookup/spamlookup_words.pl
	'SpamLookup module for moderating and junking feedback using keyword filters.' => 'Плагин SpamLookup отправляет на модерацию и помечает как спам комментарии и трекбэки согласно фильтрам по ключевым словам.',
	'SpamLookup Keyword Filter' => 'Фильтр ключевых слов SpamLookup',

## plugins/spamlookup/tmpl/lookup_config.tmpl
	q{Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog's Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.} => q{Плагин Lookups отслеживает IP во всех комментариях и трекбэках. Если комментарий или трекбэк отправлен с IP, находящего в чёрном списке, или содержит доменное имя, также находящееся в чёрном списке, он может быть поставлен на модерирование, либо помечен как спам.},
	'IP Address Lookups' => 'Проверять IP адреса',
	'Moderate feedback from blacklisted IP addresses' => 'Отправлять на модерацию комментарии и трекбэки с IP из чёрного списка',
	'Junk feedback from blacklisted IP addresses' => 'Помечать как спам комментарии и трекбэки с IP из чёрного списка',
	'Adjust scoring' => 'Отрегулируйте значение',
	'Score weight:' => 'Вес значения:',
	'Less' => 'Меньше',
	'More' => 'Больше',
	'block' => 'заблокировать',
	'IP Blacklist Services' => 'Сервис, предоставляющий чёрный список IP',
	'Domain Name Lookups' => 'Проверять доменные имена',
	'Moderate feedback containing blacklisted domains' => 'Отправлять на модерацию сообщения с доменами из чёрного списка',
	'Junk feedback containing blacklisted domains' => 'Помечать как спам сообщения с доменами из чёрного списка',
	'Domain Blacklist Services' => 'Сервис, предоставляющий чёрный список доменов',
	'Advanced TrackBack Lookups' => 'Дополнительная проверка трекбэков',
	'Moderate TrackBacks from suspicious sources' => 'Отправлять на модерацию трекбэки с подозрительных сайтов',
	'Junk TrackBacks from suspicious sources' => 'Помечать как спам трекбэки с подозрительных сайтов',
	'Lookup Whitelist' => 'Проверять белый список',
	'To prevent lookups for specific IP addresses or domains, list each on a line by itself.' => 'Чтобы избежать проверки по конкретным IP-адресам или доменам, укажите их каждый на отдельной строке.',

## plugins/spamlookup/tmpl/url_config.tmpl
	'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'Фильтр ссылок следит за количеством ссылок в комментариях. Комментарии с большим количеством ссылок могут быть отправлены на модерацию или помечены как спам. Или наоборот, комментариям, не содержащим ссылку или содержащим опубликованную ранее ссылку, может быть выставлен положительный рейтинг.',
	'Link Limits' => 'Лимит ссылок',
	'Credit feedback rating when no hyperlinks are present' => 'Повышать рейтинг, если нет ссылки',
	'Moderate when more than' => 'Модерировать, когда больше',
	'link(s) are given' => 'ссылок',
	'Junk when more than' => 'Помечать как спам, когда больше',
	'Link Memory' => 'Политика ссылок',
	'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'Повышать рейтинг, если URL уже был опубликован',
	'Only applied when no other links are present in message of feedback.' => 'Применять только, когда нет других ссылок в комментарии.',
	'Exclude URLs from comments published within last [_1] days.' => 'Исключать URL из комментариев, опубликованных за последние [_1] дн.',
	'Email Memory' => 'Политика email',
	'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'Повышать рейтинг, если в уже опубликованных комментариях был использован тот же email адрес',
	'Exclude Email addresses from comments published within last [_1] days.' => 'Исключать email адреса из комментариев, опубликованных за последние [_1] дн.',

## plugins/spamlookup/tmpl/word_config.tmpl
	'Incoming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => 'Обратная связь может проверяться на наличие определённых ключевых слов, доменных имён и шаблонов. Подпадающие под соответствия будут отправлены на модерацию или отправлены в спам. Также вы можете указать уровень строгости для отправки в спам.',
	'Keywords to Moderate' => 'Ключевые слова для отправки на модерацию',
	'Keywords to Junk' => 'Ключевые слова, чтобы пометить как спам',

## plugins/StyleCatcher/config.yaml
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks.' => 'StyleCatcher позволяет быстро просматривать стили, а затем в несколько кликов применять их в своих блогах.',
	'MT 4 Style Library' => 'Стили MT4',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Коллекция стилей, совместимых с Movable Type 4.',
	'Styles' => 'Стили',

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'Ваша директория mt-static не найдена. Пожалуйста, настройте StaticFilePath в mt-config.cgi для продолжения.',
	'Permission Denied.' => 'Доступ запрещён.',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => 'Не удалось создать каталог [_1] - удостоверьте, что папка «themes», находящаяся в папке со статическими файлами, доступна для записи.',
	'Successfully applied new theme selection.' => 'Новый стиль успешно применён.',
	'Invalid URL: [_1]' => 'Неверный URL: [_1]',
	'(Untitled)' => '(безымянный)',

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a [_1] Style' => 'Выберите стиль ([_1])',
	'3-Columns, Wide, Thin, Thin' => '3-колончатый, широкая, узкая, узкая',
	'3-Columns, Thin, Wide, Thin' => '3-колончатый, узкая, широкая, узкая',
	'3-Columns, Thin, Thin, Wide' => '3-колончатый, узкая, узкая, широкая',
	'2-Columns, Thin, Wide' => '2-колончатый, узкая, широкая',
	'2-Columns, Wide, Thin' => '2-колончатая, широкая, узкая',
	'2-Columns, Wide, Medium' => '2-колончатая, широкая, средняя',
	'2-Columns, Medium, Wide' => '2-колончатый, средняя, широкая',
	'1-Column, Wide, Bottom' => '1-колончатый, широкая, подвал',
	'None available' => 'Ничего не доступно',
	'Applying...' => 'Применение…',
	'Apply Design' => 'Использовать дизайн',
	'Error applying theme: ' => 'Ошибка установке стиля:',
	'The selected theme has been applied, but as you have changed the layout, you will need to republish your blog to apply the new layout.' => 'Выбранный стиль установлен. Теперь вам необходимо полностью опубликовать ваш блог, чтобы изменения вступили в силу. Если шаблоны стилей не публикуются автоматически с публикацией индексных шаблонов, опубликуйте их вручную.',
	'The selected theme has been applied!' => 'Выбранный стиль установлен!',
	'Error loading themes! -- [_1]' => 'Ошибка при загрузке стиля! — [_1]',
	'Stylesheet or Repository URL' => 'URL таблицы стилей или репозитория',
	'Stylesheet or Repository URL:' => 'URL таблицы стилей или репозитория:',
	'Download Styles' => 'Скачать стиль',
	'Current theme for your weblog' => 'Текущий стилья вашего блога',
	'Current Style' => 'Текущий стиль',
	'Locally saved themes' => 'Локально сохранённые стили',
	'Saved Styles' => 'Сохранённые стили',
	'Default Styles' => 'Стиль по умолчанию',
	'Single themes from the web' => 'Отдельные стили из веб',
	'More Styles' => 'Больше стилей',
	'Selected Design' => 'Выбранный дизайн',
	'Layout' => 'Расположение',

## plugins/Textile/textile2.pl
	'A humane web text generator.' => 'Обработчик текста для веб',
	'Textile 2' => 'Textile 2', # Translate - Not translated

## plugins/TypePadAntiSpam/config.yaml
	'TypePad AntiSpam is a free service from Six Apart that helps protect your blog from comment and TrackBack spam. The TypePad AntiSpam plugin will send every comment or TrackBack submitted to your blog to the service for evaluation, and Movable Type will filter items if TypePad AntiSpam determines it is spam. If you discover that TypePad AntiSpam incorrectly classifies an item, simply change its classification by marking it as "Spam" or "Not Spam" from the Manage Comments screen, and TypePad AntiSpam will learn from your actions. Over time the service will improve based on reports from its users, so take care when marking items as "Spam" or "Not Spam."' => 'TypePad AntiSpam — это бесплатный сервис от Six Apart, который помогает защищать блог от спама в комментариях и трекбэках. Плагин TypePad AntiSpam отправляет каждый комментарий или трекбэк на проверку, после которой Movable Type сможет пометить эти элементы как спам, если TypePad AntiSpam решит, что это — спам. Если вы заметите, что TypePad AntiSpam неправильно классифицирует какой-то элемент, просто измените его классификацию, пометив флагом «Спам» или, наоборот, «Не спам» со страницы управления комментариями, и в дальнейшем TypePad AntiSpam будет обучаться от ваших действий. Благодаря подобным действиям, сервис будет постоянно улучшаться и, соответственно, спама будет меньше.',
	'"TypePad AntiSpam"' => '"TypePad AntiSpam"', # Translate - Not translated

## plugins/TypePadAntiSpam/lib/MT/TypePadAntiSpam.pm
	'API key is a required parameter.' => 'Ключи API — обязательный параметр.',

## plugins/TypePadAntiSpam/lib/TypePadAntiSpam.pm
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] for this blog, and [quant,_2,message,messages] system-wide.' => 'На данный момент TypePad AntiSpam заблокировал [quant,_1,сообщение,сообщения,сообщений] в этом блоге и [quant,_1,сообщение,сообщения,сообщений] во всех блогах.',
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] system-wide.' => 'На данный момент TypePad AntiSpam заблокировал [quant,_1,сообщение,сообщения,сообщений].',
	'Failed to verify your TypePad AntiSpam API key: [_1]' => 'Ошибка при проверке вашего API-ключа для TypePad AntiSpam',
	'The TypePad AntiSpam API key provided is invalid.' => 'Указанный API-ключ для TypePad AntiSpam неверный.',

## plugins/TypePadAntiSpam/tmpl/config.tmpl
	'Junk Score Weight' => 'Рейтинг спама',
	'Least Weight' => 'Минимальный уровень',
	'Most Weight' => 'Максимальный уровень',
	'Comments and TrackBacks receive a junk score between -10 (definitely spam) and +10 (definitely not spam). This setting allows you to control the weight of the TypePad AntiSpam rating relative to other filters you may have installed to help you filter comments and TrackBacks.' => 'Комментарии и трекбэки помечаются как спам между -10 (определённо спам) и +10 (определённо не спам). Эти настроки помогут более точно управлять оценкой TypePad AntiSpam.',

## plugins/TypePadAntiSpam/tmpl/stats_widget.tmpl
	'TypePad AntiSpam' => 'TypePad AntiSpam', # Translate - Not translated
	'Spam Blocked' => 'Заблокировано спама',
	'on this blog' => 'в этом блоге',
	'on this system' => 'во всей системе',

## plugins/TypePadAntiSpam/tmpl/system.tmpl
	'API Key' => 'API-ключ',
	q{To enable this plugin, you'll need a free TypePad AntiSpam API key. You can <strong>get your free API key at [_1]antispam.typepad.com[_2]</strong>. Once you have your key, return to this page and enter it in the field below.} => q{Для включения этого плагина вам необходим бесплатный API-ключ для TypePad AntiSpam. Вы можете <strong>получить его на сайте [_1]antispam.typepad.com[_2]</strong>. Когда ключ будет у вас, вернитесь на эту страницу и укажите его в указанное ниже поле.},
	'Service Host' => 'Хост сервиса',
	'The default service host for TypePad AntiSpam is api.antispam.typepad.com. You should only change this if you are using a different service that is compatible with the TypePad AntiSpam API.' => 'По умолчанию, хост сервиса TypePad AntiSpam — api.antispam.typepad.com. Его не стоит изменять, если вы не используете сторонние сервисы, совместимые с TypePad AntiSpam API.',

## plugins/WidgetManager/WidgetManager.pl
	'Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.' => 'Менеджер виджетов, версия 1.1; Эта версия плагина предназначена для обновления данных со старой версии менеджера виджетов. Поскольку менеджер виджетов теперь встроен в Movable Type, вы можете удалить этот плагин после установки/обновления MT.',
	'Moving storage of Widget Manager [_2]...' => 'Перемещение хранилища Менеджера виджетов [_2]…',

## plugins/WXRImporter/config.yaml
	'Import WordPress exported RSS into MT.' => 'Импортировать экспортируемый WordPress RSS в MT',
	'"WordPress eXtended RSS (WXR)"' => '"WordPress eXtended RSS (WXR)"', # Translate - Not translated
	'"Download WP attachments via HTTP."' => 'Скачать медиа WP через браузер.',

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'Файл не в формате WXR.',
	'Creating new tag (\'[_1]\')...' => 'Создание нового тега («[_1]»)…',
	'Saving tag failed: [_1]' => 'Не удалось сохранить тег: [_1]',
	'Duplicate asset (\'[_1]\') found.  Skipping.' => 'Найдено повторяющееся медиа («[_1]»). Пропуск.',
	'Saving asset (\'[_1]\')...' => 'Сохранение медиа («[_1]»)…',
	' and asset will be tagged (\'[_1]\')...' => ' и медиа будет с тегом («[_1]»)…',
	'Duplicate entry (\'[_1]\') found.  Skipping.' => 'Найдена повторяющаяся запись («[_1]»). Пропуск.',
	'Saving page (\'[_1]\')...' => 'Сохранение страницы («[_1]»)…',
	'Entry has no MT::Trackback object!' => 'Запись не содержит MT::Trackback!',
	'Assigning permissions for new user...' => 'Установка прав для пользователя…',
	'Saving permission failed: [_1]' => 'Не удалось сохранить права доступа: [_1]',

## plugins/WXRImporter/tmpl/options.tmpl
	q{Before you import WordPress posts to Movable Type, we recommend that you <a href='[_1]'>configure your blog's publishing paths</a> first.} => q{Прежде чем импортировать контент из Wordpress в Movable Type, рекомендуем <a href='[_1]'>настроить путь публикации блога</a>.},
	'Upload path for this WordPress blog' => 'Путь к загруженным файлам этого WordPress блога',
	'Replace with' => 'Заменять',
	'Download attachments' => 'Скачать файлы',
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'Предполагается использование запланированного задания (CRON) для скачивания файлов в фоновом режиме из блога, работающего на WordPress.',
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'Скачать файлы (картинки и другие файлы) из импортируемого блога WordPress.',


);


1;
