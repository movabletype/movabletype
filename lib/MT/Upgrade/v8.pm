# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Upgrade::v8;

use strict;
use warnings;

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
    my $self        = shift;
    my $asset_class = MT->model('asset');
    my $meta_class  = $asset_class->meta_pkg;

    $self->progress($self->translate_escape('Migrating image width/height meta data...'));

    my $iter = $asset_class->load_iter({ class => 'image' });

    require MT::Meta::Proxy;
    my $updater = sub {
        my $assets = shift;
        MT::Meta::Proxy->bulk_load_meta_objects($assets);
        $asset_class->begin_work;
        eval {
            my @ids;
            for my $asset (@$assets) {
                push @ids, $asset->id;
                $asset->width($asset->meta('image_width'));
                $asset->height($asset->meta('image_height'));
                $asset->save;
            }
            $meta_class->driver->direct_remove(
                $meta_class, {
                    asset_id => { op => 'in', value => \@ids },
                    type     => { op => 'in', value => [qw(image_width image_height)] },
                },
            );
        };
        if ($@) {
            $asset_class->rollback;
        } else {
            $asset_class->commit;
        }
    };
    my @assets;
    while (my $asset = $iter->next) {
        push @assets, $asset;
        if (@assets >= 100) {
            $updater->(\@assets);
            @assets = ();
        }
    }
    $updater->(\@assets) if @assets;
}

1;
