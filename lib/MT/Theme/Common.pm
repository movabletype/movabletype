package MT::Theme::Common;
use strict;
use warnings;
use base 'Exporter';

use MT;

our @EXPORT_OK = qw( get_author_id );

sub get_author_id {
    my ($blog) = @_;
    my $author_id;

    if ( my $app = MT->instance ) {
        if ( $app->isa('MT::App') ) {
            my $author = $app->user;
            $author_id = $author->id if defined $author;
        }
    }
    unless ( defined $author_id ) {

        # Fallback 1: created_by from this blog.
        $author_id = $blog->created_by if defined $blog->created_by;
    }
    unless ( defined $author_id ) {

        # Fallback 2: One of this blog's administrator
        my $search_string
            = $blog->is_blog
            ? '%\'administer_blog\'%'
            : '%\'administer_website\'%';
        my $perm = MT->model('permission')->load(
            {   blog_id     => $blog->id,
                permissions => { like => $search_string },
            }
        );
        $author_id = $perm->author_id if $perm;
    }
    unless ( defined $author_id ) {

        # Fallback 3: One of system administrator
        my $perm = MT->model('permission')->load(
            {   blog_id     => 0,
                permissions => { like => '%administer%' },
            }
        );
        $author_id = $perm->author_id if $perm;
    }

    $author_id;
}

1;
