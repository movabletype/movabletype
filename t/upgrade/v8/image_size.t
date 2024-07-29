use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Mock::MonkeyPatch;
use List::Util qw(all);
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Upgrade;

$test_env->prepare_fixture('db');

sub create_image {
    my ($column_values) = @_;
    my $asset = MT::Test::Permission->make_asset(
        class       => 'image',
        blog_id     => 0,
        url         => 'http://narnia.na/nana/images/test.jpg',
        file_path   => File::Spec->catfile($ENV{MT_HOME}, "t", 'images', 'test.jpg'),
        file_name   => 'test.jpg',
        file_ext    => 'jpg',
        mime_type   => 'image/jpeg',
        label       => 'Userpic A',
        description => 'Userpic A',
    );
    $asset->meta('image_width',  640);
    $asset->meta('image_height', 480);
    $asset->save;
    return $asset;
}

use_ok('MT::Upgrade::v8');
ok $MT::Upgrade::v8::MIGRATE_META_BATCH_SIZE, 'should be defined';

subtest 'upgrade' => sub {
    subtest 'should be migrated' => sub {
        my $image = create_image();

        ok !defined($image->column_values->{width});
        ok !defined($image->column_values->{height});

        MT::Test::Upgrade->upgrade(from => 8.0000);

        $image->refresh;
        is $image->column_values->{width},  640;
        is $image->column_values->{height}, 480;
    };

    subtest 'should be remain migrated width and height when reapplied' => sub {
        my $image = create_image();

        MT::Test::Upgrade->upgrade(from => 8.0000);
        MT::Test::Upgrade->upgrade(from => 8.0000);

        $image->refresh;
        is $image->column_values->{width},  640;
        is $image->column_values->{height}, 480;
    };

    subtest 'should not call `MT::Asset::save` if metadata are not exists' => sub {
        my $image = create_image();
        $image->meta_obj->remove;

        my $saved = 0;
        my $guard = Mock::MonkeyPatch->patch(
            'MT::Asset::save' => sub {
                $saved = 1;
                Mock::MonkeyPatch::ORIGINAL(@_);
            },
        );

        MT::Test::Upgrade->upgrade(from => 8.0000);

        is $saved, 0;
    };

    subtest 'should be reported if got error' => sub {
        create_image();

        my $error_msg;
        my $error_guard = Mock::MonkeyPatch->patch(
            'MT::Upgrade::error' => sub {
                my ($class, $msg) = @_;
                $error_msg = $msg;
                Mock::MonkeyPatch::ORIGINAL(@_);
            },
        );
        my $save_guard = Mock::MonkeyPatch->patch(
            'MT::Asset::save' => sub {
                die 'test error';
            },
        );

        MT::Test::Upgrade->upgrade(from => 8.0000);

        like $error_msg, qr/test error/;
    };

    subtest 'should be divided into steps' => sub {
        local $MT::Upgrade::v8::MIGRATE_META_BATCH_SIZE = 2;

        MT->model('asset.image')->remove({blog_id => 0});
        create_image() for 1..9;

        my $commit_count = 0;
        my $commit_guard = Mock::MonkeyPatch->patch(
            'Data::ObjectDriver::BaseObject::commit' => sub {
                $commit_count++;
                Mock::MonkeyPatch::ORIGINAL(@_);
            },
        );

        my @progress_messages;
        my $progress_guard = Mock::MonkeyPatch->patch(
            'MT::Upgrade::progress' => sub {
                my ($class, $msg) = @_;
                push @progress_messages, $msg;
                Mock::MonkeyPatch::ORIGINAL(@_);
            },
        );

        MT::Test::Upgrade->upgrade(from => 8.0000);

        is $commit_count, 5;
        is_deeply [grep { /^Migrating/ } @progress_messages], [
          'Migrating image width/height meta data...',
          'Migrating image width/height meta data... (22%)',
          'Migrating image width/height meta data... (44%)',
          'Migrating image width/height meta data... (66%)',
          'Migrating image width/height meta data... (88%)',
          'Migrating image width/height meta data... (100%)',
        ];

        my @images = MT->model('asset.image')->load;
        ok all { $_->column_values->{width} == 640 && $_->column_values->{height} == 480 } @images;
    };
};

done_testing;
