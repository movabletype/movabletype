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
my $entry_archive = MT->model('template')->load(
    {   blog_id    => 1,
        type       => 'archive',
        identifier => 'monthly_entry_listing'
    }
);
$map->template_id( $entry_archive->id );

my $author_with_entry;
my $author_without_entry;

my $blog = $mt->model('blog')->load(1);
my $author_iter
    = MT::Author->load_iter( { type => MT::Author::AUTHOR() } );
my @suite = ();
while ( my $author = $author_iter->() ) {
    my $class   = MT->model('entry');
    my @entries = $class->load(
        {   blog_id   => $blog->id,
            author_id => $author->id,
            status    => MT::Entry::RELEASE(),
        },
        { sort_by => 'authored_on' }
    );
    my $entry     = @entries ? $entries[0] : undef;
    my $count     = @entries;
    my $timestamp = @entries ? $entries[0]->authored_on : undef;
    my $published = $count ? 1 : 0;
    my $suite     = {
        author    => $author,
        entry     => $entry,
        count     => $count,
        timestamp => $timestamp,
        published => $published,
    };
    push @suite, $suite;
}

for my $at (
    qw(Author Author-Yearly Author-Weekly Author-Monthly Author-Daily))
{
    note( 'ArchiveType: ' . $at );
    for my $d (@suite) {
        my $author    = $d->{author};
        my $published = $d->{published};

        note(
            (   $d->{count}
                ? 'Author with entry'
                : 'Author without entry'
            )
            . ': $author->name == '
                . $author->name
        );

        my $archiver = $publisher->archiver($at);
        my $params   = {
            Blog        => $blog,
            ArchiveType => $at,
            Entry       => $d->{entry},
            Category    => undef,
            Author      => $author,
        };

        # does_publish_file
        my $does_publish_file = $archiver->does_publish_file($params);
        is( $does_publish_file, $d->{count},
            ref($archiver) . '::does_publish_file' );

        # archive_entries_count
        my $archive_entries_count
            = MT::ArchiveType::archive_entries_count( $archiver, $params );
        is( $archive_entries_count, $d->{count},
            ref($archiver) . '::archive_entries_count' );

        next if $at ne 'Author';

        # publish file
        my $file = File::Spec->catfile( 'publish_archive_test',
            $author->basename, 'index.html' );
        my $published_file
            = File::Spec->catfile( $blog->archive_path, $file );

        unlink $published_file if -e $published_file;
        $mt->request->reset;
        $publisher->_rebuild_entry_archive_type(
            Blog        => $blog,
            Entry       => $d->{entry},
            Author      => $author,
            ArchiveType => $at,
            TemplateMap => $map,
            Start       => $d->{timestamp},
            File        => $file,
            Force       => 1,
        );
        is( -e $published_file ? 1 : 0,
            $d->{published},
            'Rebuild: When a target file does not exists: $at == ' . $at );
    }
}

done_testing();
