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
        v9_list_field_indexes => {
            version_limit => 8.9994,
            priority      => 5,
            updater       => {
                type      => 'content_data',
                label     => 'Migrating list field index data...',
                condition => sub {
                    my ($cd) = @_;
                    my $removed = _remove_list_field_indexes($cd);
                    return $removed;
                },
                code => sub { },    # do save only when regenerating list field indexes
            },
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

sub _remove_list_field_indexes {
    my ($cd) = @_;

    my @list_fields = MT->model('content_field')->load({
        content_type_id => $cd->content_type_id,
        type            => 'list',
    });
    return unless @list_fields;

    my %list_field_ids = map { $_->id => 1 } @list_fields;
    my $removed        = MT->model('content_field_index')->remove({
        content_data_id  => $cd->id,
        content_field_id => [keys %list_field_ids],
    });
    unless ($removed) {
        return MT::Upgrade->error(MT::Upgrade->translate_escape(
            "Error removing list field index record for content data # [_1]: [_2]...",
            $cd->id,
            MT->model('content_field_index')->errstr,
        ));
    }

    return 1;
}

1;
