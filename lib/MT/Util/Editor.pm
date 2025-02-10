# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.

package MT::Util::Editor;

use strict;
use warnings;

our ($current_editor, $current_wysiwyg_editor, $current_source_editor);

sub _get_editor {
    my ($app, $editor) = @_;
    my $editors = $app->registry('editors');
    exists $editors->{$editor} ? $editor : (sort(keys(%$editors)))[0];
}

sub current_editor {
    $current_editor ||= _get_editor(shift, MT->config('Editor'));
}

sub current_wysiwyg_editor {
    $current_wysiwyg_editor ||= _get_editor(shift, MT->config('WYSIWYGEditor') || MT->config('Editor'));
}

sub current_source_editor {
    $current_source_editor ||= _get_editor(shift, MT->config('SourceEditor') || MT->config('Editor'));
}

1;

__END__

=head1 NAME

MT::Util::Editor - Editor utility functions

=head1 SYNOPSIS

    use MT::Util::Editor;

    my $app = MT->instance;
    my $editor = MT::Util::Editor::current_editor($app);

=head1 FUNCTIONS

=head2 current_editor

Returns the editor selected in the current environment. If the user-specified editor is not available,
fall back to an available editor.

    my $app = MT->instance;
    my $current_editor = MT::Util::Editor::current_editor($app);

=head2 current_wysiwyg_editor

Returns the WYSIWYG editor selected in the current environment. If the user-specified editor is not available,
fall back to an available editor.

    my $app = MT->instance;
    my $current_editor = MT::Util::Editor::current_editor($app);

=head2 current_source_editor

Returns the source editor selected in the current environment. If the user-specified editor is not available,
fall back to an available editor.

    my $app = MT->instance;
    my $current_source_editor = MT::Util::Editor::current_source_editor($app);
