package TinyMCE6::TinyMCEConfig;

use strict;
use warnings;

our @EXPORT = qw(config_data);
use base qw(Exporter);

sub config_data {
  return  {
    external_plugins => '',
    newline_behavior => {
      block => 'block',
      linebreak => 'linebreak',
      invert => 'invert',
    },
    toolbar_buttons => qw(aligncenter alignjustify alignleft alignnone alignright blockquote backcolor blocks bold copy cut fontfamily fontsize forecolor h1 h2 h3 h4 h5 h6 hr indent italic language lineheight newdocument outdent paste pastetext print redo remove removeformat selectall strikethrough styles subscript superscript underline undo visualaid code advtablerownumbering anchor casechange charmap checklist emoticons export formatpainter insertdatetime link unlink bullist numlist media pageembed visualblocks visualchars wordcount)
  }
}

1;
