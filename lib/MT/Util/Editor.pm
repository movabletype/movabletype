# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.

package MT::Util::Editor;

use strict;
use warnings;

my $default_wysiwyg_editor = 'tinymce';
my $default_source_editor  = 'tinymce';

our ($current_wysiwyg_editor, $current_source_editor);

sub _get_editor {
    my ($app, $editor, $default) = @_;
    if (my $editor_regs = MT::Component->registry('editors')) {
        my %editors = map {
            my $reg = $_;
            # exclude extensions
            map {
                $reg->{$_}{label}          # provide editor body
                    || !%{ $reg->{$_} }    # placeholder
                    ? ($_ => 1) : ()
            } keys %$reg;
        } @$editor_regs;
        return
              exists $editors{$editor}  ? $editor
            : exists $editors{$default} ? $default
            : %editors                  ? (sort(keys(%editors)))[0]
            :                             '';                         # no editor found
    } else {
        return undef;
    }
}

sub current_wysiwyg_editor {
    $current_wysiwyg_editor ||= _get_editor(shift, MT->config('WYSIWYGEditor') || MT->config('Editor'), $default_wysiwyg_editor);
}

sub current_source_editor {
    $current_source_editor ||= _get_editor(shift, MT->config('SourceEditor') || MT->config('Editor'), $default_source_editor);
}

1;

__END__

=head1 NAME

MT::Util::Editor - Editor utility functions

=head1 SYNOPSIS

    use MT::Util::Editor;

    my $app = MT->instance;
    my $editor = MT::Util::Editor::current_wysiwyg_editor($app);

=head1 FUNCTIONS


=head2 current_wysiwyg_editor

Returns the WYSIWYG editor selected in the current environment.

    my $app = MT->instance;
    my $current_editor = MT::Util::Editor::current_editor($app);

=head2 current_source_editor

Returns the source editor selected in the current environment.

    my $app = MT->instance;
    my $current_source_editor = MT::Util::Editor::current_source_editor($app);
