# Movable Type (r) (C) 2006-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::RebuildTrigger;

use strict;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'      => 'integer not null auto_increment',
            'blog_id' => 'integer not null',
            'data'    => 'blob',
        },
        indexes     => { blog_id => 1 },
        datasource  => 'rebuild_trigger',
        primary_key => 'id',
        audit       => 1,
        child_of => [ 'MT::Blog', 'MT::Website' ],
    }
);

sub class_label {
    MT->translate("Rebuild Trigger");
}

#sub preprocess_native_tags {
#    my ( $ctx, $args, $cond ) = @_;
#    my $plugin = MT::Plugin::MultiBlog->instance;
#    my $tag    = lc $ctx->stash('tag');
#
#    # If we're running under MT-Search, set the context based on the search
#    # parameters available.
#    unless ( $args->{blog_id}
#        || $args->{blog_ids}
#        || $args->{site_ids}
#        || $args->{include_blogs}
#        || $args->{exclude_blogs}
#        || $args->{include_websites}
#        || $args->{exclude_websites} )
#    {
#        my $app = MT->instance;
#        if ( $app->isa('MT::App::Search') && !$ctx->stash('inside_blogs') ) {
#            if ( my $excl = $app->{searchparam}{ExcludeBlogs} ) {
#                $args->{exclude_blogs} ||= join ',', @$excl;
#            }
#            elsif ( my $incl = $app->{searchparam}{IncludeBlogs} ) {
#                $args->{include_blogs} = join ',', @$incl;
#            }
#
#            if ( ( $args->{include_blogs} || $args->{exclude_blogs} )
#                && $args->{blog_id} )
#            {
#                delete $args->{blog_id};
#            }
#        }
#    }
#
#    # Load multiblog access control list
#    my $incl
#        = $args->{include_blogs}
#        || $args->{include_websites}
#        || $args->{blog_id}
#        || $args->{blog_ids}
#        || grep( $_ eq $tag, 'blogs', 'websites' );
#    my $excl = $args->{exclude_blogs} || $args->{exclude_websites};
#    for ( $incl, $excl ) {
#        next unless $_;
#        s{\s+}{}g;    # Remove spaces
#    }
#    if ( $incl or $excl ) {
#        my %acl = load_multiblog_acl( $plugin, $ctx );
#        $args->{ $acl{mode} } = $acl{acl};
#    }
#
#    # Explicity set blog_id for MTInclude if not specified
#    # so that it never gets a multiblog context from MTMultiBlog
#    if ( $tag eq 'include' and !exists $args->{blog_id} ) {
#        if ( $ctx->stash('multiblog_context') ) {
#            if ( !$args->{local} && !$args->{global} && !$args->{parent} ) {
#                $args->{blog_id} = $ctx->stash('blog_id');
#            }
#            elsif ( $args->{local} ) {
#                my $local_blog_id = $ctx->stash('local_blog_id');
#                if ( defined $local_blog_id ) {
#                    $args->{blog_id} = $ctx->stash('local_blog_id');
#                }
#            }
#        }
#        else {
#            my $local_blog_id = $ctx->stash('local_blog_id');
#            if ( defined $local_blog_id ) {
#                $args->{blog_id} = $ctx->stash('local_blog_id');
#            }
#        }
#    }
#
#    # If no include_blogs/exclude_blogs specified look for a
#    # previously set MTMultiBlog context
#    elsif ( $ctx->stash('multiblog_context') ) {
#        $args->{include_blogs} = $ctx->stash('multiblog_include_blog_ids')
#            if $ctx->stash('multiblog_include_blog_ids');
#        $args->{exclude_blogs} = $ctx->stash('multiblog_exclude_blog_ids')
#            if $ctx->stash('multiblog_exclude_blog_ids');
#    }
#
#    # Remove local blog ID from MTTags since it is cross-blog
#    # and hence MTMultiBlogIfLocalBlog doesn't make sense there.
#    local $ctx->{__stash}{local_blog_id} = 0 if $tag eq 'tags';
#
#    # Call original tag handler with new args
#    defined( my $result = $ctx->super_handler( $args, $cond ) )
#        or return $ctx->error( $ctx->errstr );
#    return $result;
#}

sub post_contents_bulk_save {
    my $self = shift;
    my ( $eh, $app, $contents ) = @_;
    foreach my $content (@$contents) {
        &post_content_save( $self, $eh, $app, $content->{current} );
    }
}

sub get_config_value {
    my $self = shift;
    my ( $var, $blog_id ) = @_;
    my $config = $self->get_config_hash($blog_id);
    return exists $config->{ $_[0] } ? $config->{ $_[0] } : undef;
}

sub get_config_hash {
    my $self = shift;
    $self->get_config_obj(@_)->data() || {};
}

sub get_config_obj {
    my $self = shift;
    my ($blog_id) = @_;
    $blog_id = 0 unless defined $blog_id;

    my $cfg = MT->request('config_rebuild_trigger');
    unless ($cfg) {
        $cfg = {};
        MT->request( 'config_rebuild_trigger', $cfg );
    }
    return $cfg->{$blog_id} if $cfg->{$blog_id};

    my $rebuild_trigger = MT::RebuildTrigger->load( { blog_id => $blog_id } );
    if ( !$rebuild_trigger ) {
        $rebuild_trigger = MT::RebuildTrigger->new();
        $rebuild_trigger->blog_id($blog_id);
    }
    $cfg->{$blog_id} = $rebuild_trigger;
    my $data
        = $rebuild_trigger->data()
        ? MT::Util::from_json( $rebuild_trigger->data() )
        : {};
    $self->apply_default_settings( $data, $blog_id );
    $rebuild_trigger->data($data);
    $rebuild_trigger;
}

sub apply_default_settings {
    my ( $self, $data, $blog_id ) = @_;

    if ( $blog_id > 0 ) {
        $data->{default_mtmultiblog_action} = 1;
    }
    else {
        $data->{default_access_allowed} = 1;
    }
}

sub post_content_save {
    my $self = shift;
    my ( $eh, $app, $content ) = @_;
    my $blog_id = $content->blog_id || 0;
    my @blog_ids = $blog_id ? (0) : ( $blog_id, 0 );

    my $code = sub {
        my ($d) = @_;
        while ( my ( $id, $a ) = each( %{ $d->{'content_save'} } ) ) {
            next if $id == $blog_id;
            perform_mb_action( $app, $id, $_ ) foreach keys %$a;
        }

        require MT::ContentStatus;
        if ( ( $content->status || 0 ) == MT::ContentStatus::RELEASE() ) {
            while ( my ( $id, $a ) = each( %{ $d->{'content_pub'} } ) ) {
                next if $id == $blog_id;
                perform_mb_action( $app, $id, $_ ) foreach keys %$a;
            }
        }
    };

    $self->post_content_common( \@blog_ids, $code, $content->blog );
}

sub post_content_pub {
    my $self = shift;
    my ( $eh, $app, $content ) = @_;
    my $blog_id = $content->blog_id;
    my @blog_ids = $blog_id ? (0) : ( $blog_id, 0 );

    my $code = sub {
        my ($d) = @_;

        require MT::ContentStatus;
        if ( ( $content->status || 0 ) == MT::ContentStatus::RELEASE() ) {
            while ( my ( $id, $a ) = each( %{ $d->{'content_pub'} } ) ) {
                next if $id == $blog_id;
                perform_mb_action( $app, $id, $_ ) foreach keys %$a;
            }
        }
    };

    _post_content_common( $self, \@blog_ids, $code, $content->blog );
}

sub post_content_unpub {
    my $self = shift;
    my ( $eh, $app, $content ) = @_;
    my $blog_id = $content->blog_id;
    my @blog_ids = $blog_id ? (0) : ( $blog_id, 0 );

    my $code = sub {
        my ($d) = @_;

        require MT::ContentStatus;
        if ( ( $content->status || 0 ) == MT::ContentStatus::UNPUBLISH() ) {
            while ( my ( $id, $a ) = each( %{ $d->{'content_unpub'} } ) ) {
                next if $id == $blog_id;
                perform_mb_action( $app, $id, $_ ) foreach keys %$a;
            }
        }
    };

    _post_content_common( $self, \@blog_ids, $code, $content->blog );
}

sub _post_content_common {
    my ( $self, $blog_ids, $code, $blog ) = @_;

    foreach my $blog_id (@$blog_ids) {
        my $d = $self->get_config_value(
            $blog_id == 0 ? 'all_triggers' : 'other_triggers', $blog_id );
        $code->($d);
    }

    if ( my $website = $blog->website ) {
        my $blog_id = $website->id;
        my $d       = $self->get_config_value( 'blogs_in_website_triggers',
            $blog_id );
        $code->($d);
    }
}

sub init_rebuilt_cache {
    my ( $self, $app ) = @_;
    $app->request( 'rebuild_trigger', {} );
}

sub is_first_rebuild {
    my ( $app, $blog_id, $action ) = @_;
    my $rebuilt = $app->request('rebuild_trigger') || {};
    return if exists $rebuilt->{"$blog_id,$action"};
    $rebuilt->{"$blog_id,$action"} = 1;
    $app->request( 'rebuild_trigger', $rebuilt );
}

sub perform_mb_action {
    my ( $app, $blog_id, $action ) = @_;

    # Don't rebuild the same thing twice in a same runner
    return unless is_first_rebuild( $app, $blog_id, $action );

    # If the action we are performing starts with ri
    # we rebuild indexes for the given blog_id
    if ( $action =~ /^ri/ ) {
        $app->rebuild_indexes( BlogID => $blog_id );
    }
}

#sub filter_blogs_from_args {
#    my ( $self, $ctx, $args ) = @_;
#    my %acl = load_multiblog_acl( $plugin, $ctx );
#    $args->{ $acl{mode} } = $acl{acl};
#}

#sub load_multiblog_acl {
#    my $self= shift;
#    my ($ctx) = @_;
#
#    # Set local blog
#    my $this_blog = $ctx->stash('blog_id') || 0;
#
#    # Get the MultiBlog system config for default access and overrides
#    my $default_access_allowed
#        = $self->get_config_value( 'default_access_allowed', 'system' );
#    my $access_overrides
#        = $self->get_config_value( 'access_overrides', 'system' ) || {};
#
#    # System setting allows access by default
#    my ( $mode, @acl );
#    if ($default_access_allowed) {
#        @acl = grep {
#                    $_ != $this_blog
#                and exists $access_overrides->{$_}
#                and $access_overrides->{$_} == DENIED
#        } keys %$access_overrides;
#        $mode = 'deny_blogs';
#    }
#    else {
#        @acl = grep { $_ == $this_blog or $access_overrides->{$_} == ALLOWED }
#            ( $this_blog, keys %$access_overrides );
#        $mode = 'allow_blogs';
#    }
#
#    return ( mode => $mode, acl => @acl ? \@acl : undef );
#}

## 'post_restore' is implemented in the future. ##
#sub post_restore {
#    my ( $self, $cb, $objects, $deferred, $errors, $callback ) = @_;
#
#    foreach my $key ( keys %$objects ) {
#        next unless $key =~ /^MT::PluginData#\d+$/;
#        my $pd   = $objects->{$key};
#        my $data = $pd->data;
#        next unless ref $data eq 'HASH';
#        if ( my $rebuild_triggers = $data->{rebuild_triggers} ) {
#            my @restored;
#            foreach my $trg_str ( split( '\|', $rebuild_triggers ) ) {
#                my ( $action, $id, $trigger ) = split( ':', $trg_str );
#                if ( $id eq '_all' ) {
#                    push @restored, "$action:$id:$trigger";
#                }
#                elsif ( $id eq '_blogs_in_website' ) {
#                    my @keys = keys %{ $data->{blogs_in_website_triggers} };
#                    foreach my $act (@keys) {
#                        my @old_ids = keys
#                            %{ $data->{blogs_in_website_triggers}{$act} };
#                        foreach my $old_id (@old_ids) {
#                            my $new_obj = $objects->{ 'MT::Blog#' . $old_id };
#                            $new_obj = $objects->{ 'MT::Website#' . $old_id }
#                                unless $new_obj;
#                            if ($new_obj) {
#                                $data->{blogs_in_website_triggers}{$act}
#                                    { $new_obj->id }
#                                    = delete
#                                    $data->{blogs_in_website_triggers}{$act}
#                                    {$old_id};
#                                $callback->(
#                                    $self->translate(
#                                        'Restoring MultiBlog rebuild trigger for blog #[_1]...',
#                                        $old_id
#                                    )
#                                );
#                            }
#                        }
#                    }
#                    push @restored, "$action:$id:$trigger";
#                }
#                else {
#                    my $new_obj = $objects->{ 'MT::Blog#' . $id };
#                    $new_obj = $objects->{ 'MT::Website#' . $id }
#                        unless $new_obj;
#                    if ($new_obj) {
#                        push @restored,
#                            "$action:" . $new_obj->id . ":$trigger";
#                        $callback->(
#                            $self->translate(
#                                'Restoring MultiBlog rebuild trigger for blog #[_1]...',
#                                $id
#                            )
#                        );
#                    }
#                }
#            }
#
#            if (@restored) {
#                $data->{rebuild_triggers} = join( '|', @restored );
#                $pd->data($data);
#                $pd->save;
#            }
#        }
#        elsif ( my $other_triggers = $data->{other_triggers} ) {
#            my @keys = keys %{$other_triggers};
#            foreach my $act (@keys) {
#                my @old_ids = keys %{ $other_triggers->{$act} };
#                foreach my $old_id (@old_ids) {
#                    my $new_obj = $objects->{ 'MT::Blog#' . $old_id };
#                    $new_obj = $objects->{ 'MT::Website#' . $old_id }
#                        unless $new_obj;
#                    if ($new_obj) {
#                        $data->{other_triggers}{$act}{ $new_obj->id }
#                            = delete $data->{other_triggers}{$act}{$old_id};
#                        $callback->(
#                            $self->translate(
#                                'Restoring MultiBlog rebuild trigger for blog #[_1]...',
#                                $old_id
#                            )
#                        );
#                    }
#                }
#            }
#            $pd->data($data);
#            $pd->save;
#        }
#    }
#}

# Run-time loading for Rebuild Trigger core methods
sub runner {
    warn 'runner';
    my $self   = shift;
    my $method = shift;
    $self->init_rebuilt_cache( MT->instance );
    no strict 'refs';
    return $_->( $self, @_ ) if $_ = \&{"MT::RebuildTrigger::$method"};
    die "Failed to find MT::RebuildTrigger::$method";
}

1;
