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

    require MT::Meta::Proxy;

    MT::Meta::Proxy->bulk_load_meta_objects(\@image_assets);
    $asset_image_class->begin_work;
    eval {
        my @ids;
        for my $image (@image_assets) {
            next unless defined($image->meta('image_width')) || defined($image->meta('image_height'));

            push @ids, $image->id;
            $image->width($image->meta('image_width'));
            $image->height($image->meta('image_height'));
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
