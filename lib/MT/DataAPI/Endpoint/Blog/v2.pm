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
sub insert_new_blog {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_);
    return unless $site && $site->id;
    if ( $site->is_blog ) {
        return $app->error(
            $app->translate(
                'Cannot create a blog under blog (ID:[_1]).',
                $site->id
            ),
            400
        );
    }

    my $orig_blog = $app->model('blog')->new;
    $orig_blog->set_values(
        {   language      => MT->config->DefaultLanugage || '',
            date_language => MT->config->DefaultLanguage || '',
            nofollow_urls => 1,
            follow_auth_links        => 1,
            page_layout              => 'layout-wtt',
            commenter_authenticators => _generate_commenter_authenticators(),
        }
    );

    my $new_blog = $app->resource_object( 'blog', $orig_blog ) or return;

    _remove_whitespace_of_name($new_blog);
    _remove_dot_of_file_extension($new_blog);

    # Generate site_url and set.
    my $blog_json = $app->param('blog');
    my $blog_hash = $app->current_format->{unserialize}->($blog_json);

    my $subdomain = $blog_hash->{subdomain};
    my $path      = $blog_hash->{url};

    if (   !( defined $subdomain && $subdomain ne '' )
        && !( defined $path && $path ne '' ) )
    {
        return $app->error(
            $app->translate(
                'Either parameter of "url" or "subdomain" is required.'),
            400
        );
    }

    if ($subdomain) {
        $subdomain .= '.' if $subdomain && $subdomain !~ /\.$/;
        $subdomain =~ s/\.{2,}/\./g;
        $new_blog->site_url("$subdomain/::/$path");
    }

    save_object(
        $app, 'blog',
        $new_blog,
        $orig_blog,
        sub {
            $new_blog->touch;
            $_[0]->();
        }
    ) or return;

    $new_blog;
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

    _remove_whitespace_of_name($new_website);
    _remove_dot_of_file_extension($new_website);

    save_object(
        $app,
        'website',
        $new_website,
        $orig_website,
        sub {
            $new_website->touch;
            $_[0]->();
        }
    ) or return;

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

# Remove whitespace characters of the head and the end.
sub _remove_whitespace_of_name {
    my ($site) = @_;
    if ( defined $site->name ) {
        my $name = $site->name;
        $name =~ s/(^\s+|\s+$)//g;
        $site->name($name);
    }

}

# Remove the dot of a character string head.
sub _remove_dot_of_file_extension {
    my ($site) = @_;
    if ( my $file_extension = $site->file_extension ) {
        $file_extension =~ s/^\.*// if ( $file_extension || '' ) ne '';
        $site->file_extension($file_extension);
    }
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::Blog::v2 - Movable Type class for endpoint definitions about the MT::Blog.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
