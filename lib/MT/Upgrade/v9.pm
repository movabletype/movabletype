# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Upgrade::v9;

use strict;
use warnings;

sub upgrade_functions {
    return {
        v9_boolean_meta => {
            version_limit => 8.9993,
            priority      => 5,
            code          => \&_v9_boolean_meta,
        },
    };
}

sub _v9_boolean_meta {
    my $self       = shift;
    my %param      = @_;
    my $site_class = MT->model('blog');
    my $meta_class = $site_class->meta_pkg;

    $self->progress($self->translate_escape('Migrating site boolean meta data...'));

    my %boolean_meta_columns = (
        publish_empty_archive     => 'vinteger',
        upload_destination        => 'vclob',
        allow_to_change_at_upload => 'vinteger',
        normalize_orientation     => 'vinteger',
        auto_rename_non_ascii     => 'vinteger',
        blog_content_accessible   => 'vinteger',
        default_mt_sites_action   => 'vinteger',
    );

    require MT::Meta::Proxy;
    my $iter = $meta_class->search({ type => [keys %boolean_meta_columns] });
    while (my $row = $iter->next) {
        my $type  = $row->type;
        my $value = $row->vblob;
        MT::Meta::Proxy->do_unserialization(\$value);
        next unless defined $value;

        if ($boolean_meta_columns{$type} eq 'vinteger') {
            $row->vinteger($value);
        } elsif ($boolean_meta_columns{$type} eq 'vclob') {
            $row->vclob($value);
        }
        $row->vblob(undef);
        $row->save;
    }
    return 1;
}

1;
