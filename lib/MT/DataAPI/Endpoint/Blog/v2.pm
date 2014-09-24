# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::Blog::v2;

use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list {
    my ( $app, $endpoint ) = @_;

    my %terms = ( class => '*' );
    my $res = filtered_list( $app, $endpoint, 'blog', \%terms ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_by_parent {
    my ( $app, $endpoint ) = @_;

    my ($blog) = context_objects(@_);
    return unless $blog && $blog->id;

    my %terms = ( class => 'blog', parent_id => $blog->id );
    my $res = filtered_list( $app, $endpoint, 'blog', \%terms ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

# Implemented by reference to MT::CMS::Common::save().
sub insert_new_website {
    my ( $app, $endpoint ) = @_;

    my $orig_website = $app->model('website')->new;
    $orig_website->set_values(
        {   language      => MT->config->DefaultLanugage || '',
            date_language => MT->config->DefaultLanguage || '',
            nofollow_urls => 1,
            follow_auth_links        => 1,
            page_layout              => 'layout-wtt',
            commenter_authenticators => _generate_commenter_authenticators(),
        }
    );

    my $new_website = $app->resource_object( 'website', $orig_website )
        or return;

    # Remove whitespace characters of the head and the end.
    if ( defined $new_website->name ) {
        my $name = $new_website->name;
        $name =~ s/(^\s+|\s+$)//g;
        $new_website->name($name);
    }

    # Remove the dot of a character string head.
    if ( my $file_extension = $new_website->file_extension ) {
        $file_extension =~ s/^\.*// if ( $file_extension || '' ) ne '';
        $new_website->file_extension($file_extension);
    }

    save_object( $app, 'website', $new_website )
        or return;

    $new_website;
}

sub _generate_commenter_authenticators {
    my @authenticators = qw( MovableType );
    my @default_auth = split /,/, MT->config('DefaultCommenterAuth');
    foreach my $auth (@default_auth) {
        my $a = MT->commenter_authenticator($auth);
        if ( !defined $a
            || ( exists $a->{condition} && ( !$a->{condition}->() ) ) )
        {
            next;
        }
        push @authenticators, $auth;
    }
    return join( ',', @authenticators );
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::Blog::v2 - Movable Type class for endpoint definitions about the MT::Blog.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
