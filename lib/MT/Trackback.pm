# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Trackback;
use strict;

use MT::Object;
@MT::Trackback::ISA = qw( MT::Object );
__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'blog_id' => 'integer not null',
        'title' => 'string(255)',
        'description' => 'text',
        'rss_file' => 'string(255)',
        'url' => 'string(255)',
        'entry_id' => 'integer not null',
        'category_id' => 'integer not null',
        'is_disabled' => 'boolean',
        'passphrase' => 'string(30)',
    },
    indexes => {
        blog_id => 1,
        entry_id => 1,
        category_id => 1,
        created_on => 1,
    },
    defaults => {
        'entry_id' => 0,
        'category_id' => 0,
        'is_disabled' => 0,
    },
    child_classes => ['MT::TBPing'],
    audit => 1,
    datasource => 'trackback',
    primary_key => 'id',
});

sub class_label {
    MT->translate("TrackBack");
}

sub class_label_plural {
    MT->translate("TrackBacks");
}

sub remove {
    my $tb = shift;
    $tb->remove_children({ key => 'tb_id' }) or return;
    $tb->SUPER::remove(@_);
}

sub entry {
    my $tb = shift;
    return undef unless $tb->entry_id;
    require MT::Entry;
    MT::Entry->load($tb->entry_id);
}

sub category {
    my $tb = shift;
    return undef unless $tb->category_id;
    require MT::Category;
    MT::Category->load($tb->category_id);
}

1;
__END__

=head1 NAME

MT::Trackback

=head1 METHODS

=head2 $tb->remove()

Call L<MT::Object/remove> for the trackback.

=head2 $tb->entry()

Call L<MT::Entry/load> for the trackback I<entry_id>.

=head2 $tb->category()

Call L<MT::Category/load> for the trackback I<category_id>.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
