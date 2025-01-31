package MT::Util::Editor;

use strict;
use warnings;

my ($current_editor, $current_wysiwyg_editor, $current_source_editor);

sub _get_editor {
    my $editor  = shift;
    my $editors = MT->registry('editors');
    exists $editors->{$editor} ? $editor : (sort(keys(%$editors)))[0];
}

sub current_editor {
    $current_editor ||= _get_editor(MT->config('Editor'));
}

sub current_wysiwyg_editor {
    $current_wysiwyg_editor ||= _get_editor(MT->config('WYSIWYGEditor') || MT->config('Editor'));
}

sub current_source_editor {
    $current_source_editor ||= _get_editor(MT->config('SourceEditor') || MT->config('Editor'));
}

1;
