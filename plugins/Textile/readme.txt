Textile Text Formatter
A plugin for Movable Type

Release 2.05
April 22, 2008


Brad Choate
http://www.bradchoate.com/
Copyright (c) 2003-2008, Brad Choate


===========================================================================

INSTALLATION

To install, you will need to add the following files to your Movable
Type installation. The directory locations and file names are:

  * (mt home)/plugins/textile.pl
  * (mt home)/extlib/Text/Textile.pm

Refer to the Movable Type documentation for more information regarding
plugins.

You may also consider installing two additional plugins that MT-Textile
is compatible with:

  * SmartyPants: http://www.daringfireball.net/projects/smartypants/
    Version 1.1 or later. This plugin will cause MT-Textile to apply
    "smart" quotes (typographic quotes or 'curly' quotes) to your
    text.

  * CodeBeautifier: http://voisen.org/projects/
    Version 0.4 or later. This plugin will allow language specific
    <code> and/or <blockcode> tags. Use the "language" attribute for
    these tags to invoke one of the following formatters: "perl" for
    Perl, "php" for PHP, "java" for Java, "as" or "actionscript" for
    ActionScript, "scheme" for Scheme.
