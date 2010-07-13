# Movable Type (r) Open Source (C) 2006-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

# Original Copyright (c) 2004-2006 David Raynes

package MultiBlog;

use strict;
use warnings;

# Blog-level Access override statuses
sub DENIED  () { 1 }
sub ALLOWED () { 2 }

sub preprocess_native_tags {
    my ( $ctx, $args, $cond ) = @_;
    my $plugin = MT::Plugin::MultiBlog->instance;
    my $tag    = lc $ctx->stash('tag');

    # If we're running under MT-Search, set the context based on the search
    # parameters available.
    unless ( $args->{blog_id}
        || $args->{blog_ids}
        || $args->{include_blogs}
        || $args->{exclude_blogs}
        || $args->{include_websites}
        || $args->{exclude_websites} )
    {
        my $app = MT->instance;
        if ( $app->isa('MT::App::Search') && !$ctx->stash('inside_blogs') ) {
            if ( my $excl = $app->{searchparam}{ExcludeBlogs} ) {
                $args->{exclude_blogs} ||= join ',', @$excl;
            }
            elsif ( my $incl = $app->{searchparam}{IncludeBlogs} ) {
                $args->{include_blogs} = join ',', @$incl;
            }

            if ( ( $args->{include_blogs} || $args->{exclude_blogs} )
                && $args->{blog_id} )
            {
                delete $args->{blog_id};
            }
        }
    }

    # Load multiblog access control list
    my %acl = load_multiblog_acl( $plugin, $ctx );
    $args->{$acl{mode}} = $acl{acl};

    # Explicity set blog_id for MTInclude if not specified
    # so that it never gets a multiblog context from MTMultiBlog
    if ( $tag eq 'include' and !exists $args->{blog_id} ) {
        if ( $ctx->stash('multiblog_context') ) {
            if ( !$args->{local} && !$args->{global} && !$args->{parent} ) {
                $args->{blog_id} = $ctx->stash('blog_id');
            } elsif (  $args->{local} ) {
                my $local_blog_id = $ctx->stash('local_blog_id');
                if ( defined $local_blog_id ) {
                    $args->{blog_id} = $ctx->stash('local_blog_id');
                }
            }
        }
    }

    # If no include_blogs/exclude_blogs specified look for a
    # previously set MTMultiBlog context
    elsif ( $ctx->stash('multiblog_context') ) {
        $args->{include_blogs} = $ctx->stash('multiblog_include_blog_ids')
            if $ctx->stash('multiblog_include_blog_ids');
        $args->{exclude_blogs} = $ctx->stash('multiblog_exclude_blog_ids')
            if $ctx->stash('multiblog_exclude_blog_ids');
    }



    # Remove local blog ID from MTTags since it is cross-blog
    # and hence MTMultiBlogIfLocalBlog doesn't make sense there.
    local $ctx->{__stash}{local_blog_id} = 0 if $tag eq 'tags';

    # Call original tag handler with new args
    defined( my $result = $ctx->super_handler( $args, $cond ) )
        or return $ctx->error( $ctx->errstr );
    return $result;
}


sub post_feedback_save {
    my $plugin = shift;
    my ( $trigger, $eh, $feedback ) = @_;
    if ( $feedback->visible ) {
        my $blog_id = $feedback->blog_id;
        my $app = MT->instance;

        my $code = sub {
            my ( $d ) = @_;

            while ( my ( $id, $a ) = each( %{ $d->{$trigger} } ) ) {
                next if $id == $blog_id;
                perform_mb_action( $app, $id, $_ ) foreach keys %$a;
            }
        };

        foreach my $scope ("blog:$blog_id", "system") {
            my $d = $plugin->get_config_value( $scope eq 'system' ? 'all_triggers' : 'other_triggers', $scope );
            $code->($d);
        }

        my $blog = $feedback->blog;
        if ( $blog->is_blog ) {
            if ( my $website = $blog->website ) {
                my $scope = "blog:".$website->id;
                my $d = $plugin->get_config_value( 'blogs_in_website_triggers', $scope);
                $code->($d);
            }
        }
    }
}

sub post_entry_save {
    my $plugin = shift;
    my ( $eh, $app, $entry ) = @_;
    my $blog_id = $entry->blog_id;
    my @scope = ("blog:$blog_id", "system");

    my $code = sub {
        my ( $d ) = @_;
        while ( my ( $id, $a ) = each( %{ $d->{'entry_save'} } ) ) {
            next if $id == $blog_id;
            perform_mb_action( $app, $id, $_ ) foreach keys %$a;
        }

        require MT::Entry;
        if ( ( $entry->status || 0 ) == MT::Entry::RELEASE() ) {
            while ( my ( $id, $a ) = each( %{ $d->{'entry_pub'} } ) ) {
                next if $id == $blog_id;
                perform_mb_action( $app, $id, $_ ) foreach keys %$a;
            }
        }
    };

    foreach my $scope ( @scope ) {
        my $d = $plugin->get_config_value( $scope eq 'system' ? 'all_triggers' : 'other_triggers', $scope );
        $code->($d);
    }

    my $blog = $entry->blog;
    if ( my $website = $blog->website ) {
        my $scope = "blog:".$website->id;
        my $d = $plugin->get_config_value( 'blogs_in_website_triggers', $scope);
        $code->($d);
    }
}

sub post_entry_pub {
    my $plugin = shift;
    my ( $eh, $app, $entry ) = @_;
    my $blog_id = $entry->blog_id;

    my $code = sub {
        my ( $d ) = @_;

        require MT::Entry;
        if ( ( $entry->status || 0 ) == MT::Entry::RELEASE() ) {
            while ( my ( $id, $a ) = each( %{ $d->{'entry_pub'} } ) ) {
                next if $id == $blog_id;
                perform_mb_action( $app, $id, $_ ) foreach keys %$a;
            }
        }
    };

    foreach my $scope ("blog:$blog_id", "system") {
        my $d = $plugin->get_config_value( $scope eq 'system' ? 'all_triggers' : 'other_triggers', $scope );
        $code->($d);
    }

    my $blog = $entry->blog;
    if ( my $website = $blog->website ) {
        my $scope = "blog:".$website->id;
        my $d = $plugin->get_config_value( 'blogs_in_website_triggers', $scope);
        $code->($d);
    }
}

sub perform_mb_action {
    my ( $app, $blog_id, $action ) = @_;

    # Don't rebuild the same thing twice in a request
    require MT::Request;
    my $r = MT::Request->instance;
    my $rebuilt = $r->stash('multiblog_rebuilt') || {};
    return if exists $rebuilt->{"$blog_id,$action"};
    $rebuilt->{"$blog_id,$action"} = 1;
    $r->stash('multiblog_rebuilt', $rebuilt);

    # If the action we are performing starts with ri
    # we rebuild indexes for the given blog_id
    if ( $action =~ /^ri/ ) {
        $app->rebuild_indexes( BlogID => $blog_id );

        # And if the action contains a p
        # we send out pings for the given blog_id too
        if ( $action =~ /p/ ) {
            $app->ping( BlogID => $blog_id );
        }
    }
}

sub load_multiblog_acl {
    my $plugin = shift;
    my ( $ctx ) = @_;

    # Set local blog
    my $this_blog = $ctx->stash('blog_id') || 0;

    # Get the MultiBlog system config for default access and overrides
    my $default_access_allowed =
        $plugin->get_config_value( 'default_access_allowed', 'system' );
    my $access_overrides =
        $plugin->get_config_value( 'access_overrides', 'system' ) || {};


    # System setting allows access by default
    my ( $mode, @acl );
    if ($default_access_allowed) {
        @acl = grep { $_ != $this_blog and exists $access_overrides->{$_} and $access_overrides->{$_} == DENIED } keys %$access_overrides;
        $mode = 'deny_blogs';
    } else {
        @acl = grep { $_ == $this_blog or $access_overrides->{$_} == ALLOWED } ($this_blog, keys %$access_overrides);
        $mode = 'allow_blogs';
    }

    return ( mode => $mode, acl => @acl ? \@acl : undef );
}

sub post_restore {
    my ( $plugin, $cb, $objects, $deferred, $errors, $callback ) = @_;

    foreach my $key ( keys %$objects ) {
        next unless $key =~ /^MT::PluginData#\d+$/;
        my $pd = $objects->{$key};
        my $data = $pd->data;
        next unless ref $data eq 'HASH';
        if ( my $rebuild_triggers = $data->{rebuild_triggers} ) {
            my @restored;
            foreach my $trg_str ( split ( '\|', $rebuild_triggers ) ) {
                my ( $action, $id, $trigger ) = split ( ':', $trg_str );
                if ( $id eq '_all' ) {
                    push @restored, "$action:$id:$trigger";
               } elsif ( $id eq '_blogs_in_website' ) {
                   my @keys = keys %{ $data->{blogs_in_website_triggers} };
                   foreach my $act ( @keys ) {
                       my @old_ids = keys %{ $data->{blogs_in_website_triggers}{$act} };
                       foreach my $old_id ( @old_ids ) {
                           my $new_obj = $objects->{'MT::Blog#' . $old_id};
                           $new_obj = $objects->{'MT::Website#' . $old_id}
                               unless $new_obj;
                           if ( $new_obj ) {
                               $data->{blogs_in_website_triggers}{$act}{$new_obj->id} =
                                   delete $data->{blogs_in_website_triggers}{$act}{$old_id};
                               $callback->(
                                   $plugin->translate('Restoring MultiBlog rebuild trigger for blog #[_1]...', $old_id));
                           }
                       }
                   }
                   push @restored, "$action:$id:$trigger";
               } else {
                    my $new_obj = $objects->{'MT::Blog#' . $id};
                    $new_obj = $objects->{'MT::Website#' . $id}
                        unless $new_obj;
                    if ( $new_obj ) {
                        push @restored, "$action:" . $new_obj->id . ":$trigger";
                        $callback->(
                            $plugin->translate('Restoring MultiBlog rebuild trigger for blog #[_1]...', $id)
                        );
                    }
                }
            }

            if ( @restored ) {
                $data->{rebuild_triggers} = join ( '|', @restored );
                $pd->data($data);
                $pd->save;
            }
        } elsif ( my $other_triggers = $data->{other_triggers} ) {
            my @keys = keys %{ $other_triggers };
            foreach my $act ( @keys ) {
                my @old_ids = keys %{ $other_triggers->{$act} };
                foreach my $old_id ( @old_ids ) {
                    my $new_obj = $objects->{'MT::Blog#' . $old_id};
                    $new_obj = $objects->{'MT::Website#' . $old_id}
                        unless $new_obj;
                    if ( $new_obj ) {
                        $data->{other_triggers}{$act}{$new_obj->id} =
                            delete $data->{other_triggers}{$act}{$old_id};
                        $callback->(
                            $plugin->translate('Restoring MultiBlog rebuild trigger for blog #[_1]...', $old_id));
                    }
                }
            }
            $pd->data($data);
            $pd->save;
        }
    }
}

1;
