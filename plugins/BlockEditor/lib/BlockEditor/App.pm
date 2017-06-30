# Movable Type (r) (C) 2006-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package BlockEditor::App;

use strict;
use warnings;

use BlockEditor;

sub param_edit_content_data {
    my ( $cb, $app, $param, $tmpl ) = @_;

    my $blockeditor_fields       = $app->registry('blockeditor_fields');
    my @blockeditor_fields_array = map {
        my $hash = {};
        $hash->{type}  = $_;
        $hash->{label} = $blockeditor_fields->{$_}{label};
        $hash->{path}  = $blockeditor_fields->{$_}{path};
        $hash;
    } keys %$blockeditor_fields;

    $param->{blockeditor_fields} = \@blockeditor_fields_array;

    my $editor_tmpl = plugin()->load_tmpl('editor.tmpl');
    $param->{blockeditor_tmpl} = $editor_tmpl;
}

1;
