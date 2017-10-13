#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

eval(
    $ENV{SKIP_REINITIALIZE_DATABASE}
    ? "use MT::Test qw(:app);"
    : "use MT::Test qw(:app :db :data);"
);

use File::Basename;
use MT::WeblogPublisher;

my $mt        = MT->instance;
my $publisher = MT::WeblogPublisher->new( start_time => time() + 10 );
my $map       = $mt->model('templatemap')->new;
$map->file_template('publish_empty_archive_test/%C/index.html');

# Set template_id of template map.
my $category_archive = MT->model('template')->load(
    {   blog_id    => 1,
        type       => 'archive',
        identifier => 'category_entry_listing'
    }
);
$map->template_id( $category_archive->id );

my $blog = $mt->model('blog')->load(1);
my @cats = $mt->model('category')->load( { blog_id => $blog->id } );
my ($cat_with_entry)    = grep { $_->entry_count } @cats;
my ($cat_without_entry) = grep { !$_->entry_count } @cats;

my @suite = (
    {   category              => $cat_with_entry,
        publish_empty_archive => 0,
        published             => 1,
    },
    {   category              => $cat_with_entry,
        publish_empty_archive => 1,
        published             => 1,
    },
    {   category              => $cat_without_entry,
        publish_empty_archive => 0,
        published             => 0,
    },
    {   category              => $cat_without_entry,
        publish_empty_archive => 1,
        published             => 1,
    },
);

for my $at (
    qw(Category Category-Yearly Category-Weekly Category-Monthly Category-Daily)
    )
{
    note( 'ArchiveType: ' . $at );
    for my $d (@suite) {
        my $cat = $d->{category};

        note(
            (   $cat->entry_count
                ? 'Category with entry'
                : 'Category without entry'
            )
            . ': $blog->publish_empty_archive == '
                . $d->{publish_empty_archive}
        );

        $blog->publish_empty_archive( $d->{publish_empty_archive} );
        $blog->save;

        my $archiver          = $publisher->archiver($at);
        my $does_publish_file = $archiver->does_publish_file(
            {   Blog        => $blog,
                ArchiveType => $at,
                Category    => $cat,
            }
        );
        is( $does_publish_file, $d->{published},
            ref($archiver) . '::does_publish_file' );

        next if $at ne 'Category';

        my $file = File::Spec->catfile( $blog->archive_path,
            'publish_empty_archive_test', $cat->basename, 'index.html' );

        unlink $file if -e $file;
        $mt->request->reset;
        $publisher->_rebuild_entry_archive_type(
            Blog        => $blog,
            Category    => $cat,
            ArchiveType => $at,
            TemplateMap => $map,
            Force       => 1,
        );
        is( -e $file ? 1 : 0,
            $d->{published}, 'Rebuild: When a target file does not exists' );

        {
            my $dirname = dirname($file);
            if ( !-d $dirname ) {
                require MT::FileMgr;
                my $fmgr = MT::FileMgr->new('Local');
                $fmgr->mkpath($dirname);
            }

            open my $fh, '>', $file;
            print {$fh} "test";
            close $fh;
        }
        $mt->request->reset;
        $publisher->_rebuild_entry_archive_type(
            Blog        => $blog,
            Category    => $cat,
            ArchiveType => $at,
            TemplateMap => $map,
            Force       => 1,
        );
        is( -e $file ? 1 : 0,
            $d->{published}, 'Rebuild: When a target file already exists' );
    }
}

done_testing();
