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
            version_limit => 9.0000,
            priority      => 5,
            code          => \&_v9_boolean_meta,
        },
        v9_list_field_indexes => {
            version_limit => 9.0000,
            priority      => 5,
            code          => \&_v9_list_field_indexes,
        },
        v9_link_default_target => {
            version_limit => 9.0001,
            priority      => 5,
            updater       => {
                type  => 'blog',
                terms => { class => '*' },
                label => "Initializing default link target settings...",
                code  => sub {
                    no warnings 'once';
                    my $blog = shift;
                    $blog->link_default_target($MT::Blog::DEFAULT_LINK_DEFAULT_TARGET);
                },
            },
        },
        v9_api_password => {
            version_limit => 9.0002,
            priority      => 5,
            updater       => {
                type  => 'author',
                label => "Migrating web services passwords...",
                code  => \&v9_api_password,
            },
        },
    };
}

sub v9_api_password {
    my $user         = shift;
    my $old_password = $user->api_password;
    if ($old_password || (defined($old_password) && $old_password eq '0')) {
        require MT::Author;

        # apply it to only passwords that is shorter than old schema max length
        return 1 if length($old_password) > 60;

        $user->api_password($old_password);
    }
    return 1;
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
            $row->vinteger($value || 0);
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

    my %ct_cache;
    my %ct_fields_cache;

    my @cds = $cd_class->load(
        $terms,
        {
            sort   => [{ column => 'content_type_id' }, { column => 'id' }],
            offset => $offset,
            limit  => $MIGRATE_LIST_FIELD_INDEX_BATCH_SIZE,
        });
    for my $cd (@cds) {
        $offset++;

        my $ct = $ct_cache{ $cd->content_type_id } ||= $cd->content_type
            or return $self->error($self->translate_escape('Invalid content type'));

        my $ct_fields = $ct_fields_cache{ $cd->content_type_id };
        unless ($ct_fields) {
            my $cf_ids   = $cf_ids_for_ct_id->{ $cd->content_type_id } || [];
            my %selected = map { $_ => 1 } @{$cf_ids};
            $ct_fields = $ct_fields_cache{ $cd->content_type_id } = [grep { $selected{ $_->{id} } && $_->{type} eq 'list' } @{ $ct->fields }];
        }

        local $@;
        eval { _update_list_cf_idxs($cd, $ct, $ct_fields) };
        if (my $error = $@) {
            return $self->error($self->translate_escape('Error migrating list field indexes of content data # [_1]: [_2]...', $cd->id, $error));
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

sub _update_list_cf_idxs {
    my $cd = shift;
    my ($ct, $ct_fields) = @_;

    my $data            = $cd->data;
    my $idx_type        = 'list';
    my $cf_idx_data_col = 'value_text';

    foreach my $f (@{$ct_fields}) {
        my $value = $data->{ $f->{id} };
        $value = [$value] unless ref $value eq 'ARRAY';
        $value = [grep { defined $_ && $_ ne '' } @$value];

        $cd->_update_cf_idx($ct, $f, $value, $cf_idx_data_col, $idx_type);
    }

    return;
}

1;
