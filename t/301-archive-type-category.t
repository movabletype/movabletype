#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib qw(lib extlib t/lib);

eval(
    $ENV{SKIP_REINITIALIZE_DATABASE}
    ? "use MT::Test qw(:app);"
    : "use MT::Test qw(:app :db :data);"
);

use Test::More;
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

my $blog     = $mt->model('blog')->load(1);
my $cat_iter = $mt->model('category')->load_iter( { blog_id => $blog->id } );
my @suite    = ();
while ( my $cat = $cat_iter->() ) {
    my $count     = $cat->entry_count;
    my $published = $count ? 1 : 0;
    my $suite     = {
        category              => $cat,
        publish_empty_archive => 0,
        count                 => $count,
        published             => $published,
    };
    push @suite, $suite;
}

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

        my $params = {
            Blog        => $blog,
            ArchiveType => $at,
            Entry       => undef,
            Category    => $cat,
            Author      => undef,
        };

        # does_publish_file
        my $archiver          = $publisher->archiver($at);
        my $does_publish_file = $archiver->does_publish_file($params);
        is( $does_publish_file, $d->{published},
            ref($archiver) . '::does_publish_file' );

        # archive_entries_count
        my $archive_entries_count
            = MT::ArchiveType::archive_entries_count( $archiver, $params );
        is( $archive_entries_count, $d->{count},
            ref($archiver) . '::archive_entries_count' );

        next if $at ne 'Category';

        # publish file
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
