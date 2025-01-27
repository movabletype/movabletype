# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Upgrade::v8;

use strict;
use warnings;

our $MIGRATE_META_BATCH_SIZE = 100;

sub upgrade_functions {
    return {
        v8_image_size => {
            version_limit => 8.0001,
            priority      => 5,
            code          => \&_v8_image_size,
        },
    };
}

sub _v8_image_size {
    my $self              = shift;
    my %param             = @_;
    my $asset_image_class = MT->model('asset.image');
    my $meta_class        = $asset_image_class->meta_pkg;

    my $count  = $param{count}  || $asset_image_class->count;
    my $offset = $param{offset} || 0;

    my $msg = $self->translate_escape('Migrating image width/height meta data...');
    if ($offset) {
        $self->progress(
            sprintf("$msg (%d%%)", ($offset / $count * 100)),
            $param{step});
    } else {
        $self->progress($msg, $param{step});
    }

    my @image_assets = $asset_image_class->load(
        undef,
        {
            sort   => 'id',
            offset => $offset,
            limit  => $MIGRATE_META_BATCH_SIZE,
        },
    );
    my @ids       = map { $_->id } @image_assets;
    my @meta_rows = $meta_class->search({
            asset_id => \@ids,
            type     => [qw(image_width image_height)],
        }, {
            fetchonly => [qw(asset_id type vinteger)],
        },
    );
    my %meta_map;
    for my $row (@meta_rows) {
        $meta_map{ $row->asset_id }{ $row->type } = $row->vinteger;
    }

    $asset_image_class->begin_work;
    eval {
        for my $image (@image_assets) {
            my $meta = $meta_map{ $image->id } or next;
            $image->width($meta->{image_width});
            $image->height($meta->{image_height});
            $image->save;
        }
        if (@ids) {
            $meta_class->driver->direct_remove(
                $meta_class, {
                    asset_id => { op => 'in', value => \@ids },
                    type     => { op => 'in', value => [qw(image_width image_height)] },
                },
            );
        }
    };
    if (my $e = $@) {
        $asset_image_class->rollback;
        return $self->error($self->translate_escape("An error occurred: [_1]", $e));
    } else {
        $asset_image_class->commit;
    }

    $offset += @image_assets;
    if ($offset < $count) {
        return { count => $count, offset => $offset };
    }

    $self->progress("$msg (100%)", $param{step});
    return 1;
}

1;
