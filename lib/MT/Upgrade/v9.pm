# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Upgrade::v9;

use strict;
use warnings;

our $MIGRATE_LIST_FIELD_INDEX_BATCH_SIZE = 100;

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
            code          => \&_v9_list_field_indexes,
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

sub _v9_list_field_indexes {
    my $self  = shift;
    my %param = @_;

    my $start = time;

    my $cf_ids_for_ct_id = $param{cf_ids_for_ct_id};
    unless ($cf_ids_for_ct_id) {
        $cf_ids_for_ct_id = {};
        my $iter = MT->model('content_field')->load_iter(
            { type => 'list' },
            {
                join => MT->model('content_type')->join_on(
                    undef,
                    { id => \'= cf_content_type_id' },
                ),
            },
        );
        while (my $cf = $iter->()) {
            $cf_ids_for_ct_id->{ $cf->content_type_id } ||= [];
            push @{ $cf_ids_for_ct_id->{ $cf->content_type_id } }, $cf->id;
        }
    }

    my $cd_class = MT->model('content_data');
    my $msg      = $self->translate_escape('Migrating list field index data...');

    my $terms  = { content_type_id => [keys %{$cf_ids_for_ct_id}] };
    my $offset = $param{offset} || 0;
    my $count  = $param{count}  || $cd_class->count($terms) or return;
    if ($offset) {
        $self->progress(
            sprintf("$msg (%d%%)", ($offset / $count * 100)),
            $param{step});
    } else {
        $self->progress($msg, $param{step});
    }

    my @list = $cd_class->load(
        $terms,
        {
            sort   => [{ column => 'content_type_id' }, { column => 'id' }],
            offset => $offset,
            limit  => $MIGRATE_LIST_FIELD_INDEX_BATCH_SIZE,
        });
    for my $obj (@list) {
        $offset++;

        my $cf_ids = $cf_ids_for_ct_id->{ $obj->content_type_id };
        next unless ref $cf_ids eq 'ARRAY' && @{$cf_ids} > 0;

        local $@;
        eval { _update_list_cf_idxs($obj, $cf_ids) };
        if (my $error = $@) {
            return $self->error($self->translate_escape('Error migrating list field indexes of content data # [_1]: [_2]...', $obj->id, $error));
        }

        last if time > $start + $self->max_time;
    }
    if ($offset < $count) {
        return {
            offset           => $offset,
            count            => $count,
            cf_ids_for_ct_id => $cf_ids_for_ct_id,
        };
    } else {
        $self->progress("$msg (100%)", $param{step});
    }
    return 1;
}

# copied from MT::ContentData::update_cf_idx_multi(), and reduced unnecessary processes
sub _update_list_cf_idxs {
    my $cd = shift;
    my ($cf_ids) = @_;

    my $content_type = $cd->content_type
        or die MT->translate('Invalid content type');

    my %selected  = map  { $_ => 1 } @{$cf_ids};
    my @ct_fields = grep { $selected{ $_->{id} } } @{ $content_type->fields };

    my $content_field_types = MT->registry('content_field_types');
    my $data                = $cd->data;

    my $idx_type        = 'list';
    my $data_type       = 'text';
    my $cf_idx_data_col = 'value_' . $data_type;
    foreach my $f (@ct_fields) {
        next unless ($f->{type}                                   || '') eq $idx_type;
        next unless ($content_field_types->{$idx_type}{data_type} || '') eq $data_type;

        my $value = $data->{ $f->{id} };
        $value = [$value] unless ref $value eq 'ARRAY';
        $value = [grep { defined $_ && $_ ne '' } @$value];

        $cd->_update_cf_idx(
            $content_type, $f, $value, $cf_idx_data_col,
            $idx_type
        );
    }

    return;
}

1;
