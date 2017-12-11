# Movable Type (r) (C) 2007-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Template::Tags::IntegrateSite;

use strict;
use warnings;

use MT;

=head2 IntegrateSite

This is the block tag for multiple site to be integrated.

=cut

sub _hdlr_integrate_site {
    my ( $ctx, $args, $cond ) = @_;

    return $ctx->error( MT->translate('MTMultiBlog tags cannot be nested.') )
        if $ctx->stash('integrate_site_context');

    # Set default mode for backwards compatibility
    $args->{mode} ||= 'loop';

    if ( $args->{blog_id} ) {
        $args->{blog_ids} = $args->{blog_id};
        delete $args->{blog_id};
    }

    # If MTMultiBlog was called with no arguments, we check the
    # blog-level settings for the default includes/excludes.
    unless ( $args->{blog_ids}
        || $args->{include_blogs}
        || $args->{exclude_blogs}
        || $args->{include_websites}
        || $args->{exclude_websites}
        || $args->{site_ids} )
    {
        require MT::RebuildTrigger;
        my $id = $ctx->stash('blog_id');
        my $is_include
            = MT::RebuildTrigger->get_config_value(
            'default_mt_integrate_site_action', "blog:$id" );
        my $blogs = MT::RebuildTrigger->get_config_value(
            'default_mt_integrate_site_sites', "blog:$id" );

        if ( $blogs && defined($is_include) ) {
            $args->{ $is_include ? 'include_blogs' : 'exclude_blogs' }
                = $blogs;
        }

        # No blog-level config set
        # Set mode to context as this will mimic no MTMultiBlog tag
        else {
            $args->{'mode'} = 'context';    # Override 'loop' mode
        }
    }

    # Filter IntegrateSite args through access controls
    require MT::RebuildTrigger;

    # Load IntegrateSite access control list
    my %acl = MT::RebuildTrigger->load_integrate_site_acl($ctx);
    $args->{ $acl{mode} } = $acl{acl};

    # Run IntegrateSite in specified mode
    my $res;
    if ( $args->{mode} eq 'loop' ) {
        $res = loop(@_);
    }
    elsif ( $args->{mode} eq 'context' ) {
        $res = context(@_);
    }
    else {

        # Throw error if mode is unknown
        $res = $ctx->error(
            MT->translate(
                'Unknown "mode" attribute value: [_1]. '
                    . 'Valid values are "loop" and "context".',
                $args->{mode}
            )
        );
    }

    # Remove integrate_site_context and blog_ids
    $ctx->stash( 'integrate_site_context',          '' );
    $ctx->stash( 'integrate_site_include_blog_ids', '' );
    $ctx->stash( 'integrate_site_exclude_blog_ids', '' );
    return defined($res) ? $res : $ctx->error( $ctx->errstr );
}

## Supporting functions for 'IntegrateSite' tag:

# IntegrateSite's "context" mode:
# The container's contents are evaluated once with a multi-blog context
sub context {
    my ( $ctx, $args, $cond ) = @_;

    my $include_blogs = $args->{include_blogs} || $args->{blog_ids};

    # Assuming multiblog context, set it.
    if ( $include_blogs || $args->{exclude_blogs} ) {
        $ctx->stash( 'multiblog_context', 1 );
        $ctx->stash( 'multiblog_include_blog_ids',
            join( ',', $include_blogs ) )
            if $include_blogs;
        $ctx->stash(
            'multiblog_exclude_blog_ids',
            join( ',', $args->{exclude_blogs} )
        ) if $args->{exclude_blogs};
    }

    # Evaluate container contents and return output
    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');
    my $out     = $builder->build( $ctx, $tokens, $cond );
    return
        defined($out) ? $out : $ctx->error( $ctx->stash('builder')->errstr );

}

# IntegrateSite's "loop" mode:
# The container's contents are evaluated once per specified blog
sub loop {
    my ( $ctx, $args, $cond ) = @_;
    my ( %terms, %args );

    # Set the context for blog loading
    $ctx->set_blog_load_context( $args, \%terms, \%args, 'id' )
        or return $ctx->error( $ctx->errstr );
    $args{'no_class'} = 1
        if ( $args->{include_blogs} && lc $args->{include_blogs} eq 'all' )
        || ( $args->{include_website}
        && lc $args->{include_website} eq 'all' )
        || ( $args->{blog_ids} && lc $args->{blog_ids} eq 'all' )
        || ( $args->{site_ids} && lc $args->{site_ids} eq 'all' );

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    local $ctx->{__stash}{entries} = undef
        if $args->{ignore_archive_context};
    local $ctx->{current_timestamp} = undef
        if $args->{ignore_archive_context};
    local $ctx->{current_timestamp_end} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{category} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{archive_category} = undef
        if $args->{ignore_archive_context};

    require MT::Blog;
    $args{'sort'} = 'name';
    $args{direction} = 'ascend';

    my $iter = MT::Blog->load_iter( \%terms, \%args );
    my $res = '';
    while ( my $blog = $iter->() ) {
        local $ctx->{__stash}{blog}    = $blog;
        local $ctx->{__stash}{blog_id} = $blog->id;
        $ctx->stash( 'multiblog_context',  'include_blogs' );
        $ctx->stash( 'multiblog_blog_ids', $blog->id );
        defined( my $out = $builder->build( $ctx, $tokens, $cond ) )
            or return $ctx->error( $builder->errstr );
        $res .= $out;
    }
    $res;
}

1;
