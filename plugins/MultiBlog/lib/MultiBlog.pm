# Copyright 2006-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# Original Copyright (c) 2004-2006 David Raynes
#
# $Id$

package MultiBlog;

use strict;
use warnings;

# Blog-level Access override statuses
use constant DENIED     => 1;
use constant ALLOWED    => 2;

sub preprocess_native_tags {
    my ( $ctx, $args, $cond ) = @_;
    my $plugin = MT::Plugin::MultiBlog->instance;

    my $tag = lc $ctx->stash('tag');

    # If we're running under MT-Search, set the context based on the search
    # parameters available.
    unless ($args->{blog_id} || $args->{include_blogs} || $args->{exclude_blogs}) {
        my $app = MT->instance;
        if ($app->isa('MT::App::Search')) {
            if (my $excl = $app->{searchparam}{ExcludeBlogs}) {
                $args->{exclude_blogs} ||= join ',', keys %$excl;
            } elsif (my $incl = $app->{searchparam}{IncludeBlogs}) {
                $args->{include_blogs} = join ',', keys %$incl;
            } 
            if (($args->{include_blogs} || $args->{exclude_blogs}) && $args->{blog_id}) {
                delete $args->{blog_id};
            }
        }
    }

   # Filter through MultiBlog's access controls.  If no blogs
   # are accessible given the specified attributes, we return
   # NULL or an error if one occured.
    if ( ! filter_blogs_from_args($plugin, $ctx, $args) ) {
        return $ctx->errstr ? $ctx->error($ctx->errstr) : '';
    }
    # Explicity set blog_id for MTInclude if not specified
    # so that it never gets a multiblog context from MTMultiBlog
    elsif ($tag eq 'include' and ! exists $args->{blog_id}) {
        my $local_blog_id = $ctx->stash('local_blog_id');
        if (defined $local_blog_id) {
            $args->{blog_id} = $ctx->stash('local_blog_id');
        }
    }
    # If no include_blogs/exclude_blogs specified look for a 
    # previously set MTMultiBlog context
    elsif ( my $mode = $ctx->stash('multiblog_context') ) {
        $args->{$mode} = $ctx->stash('multiblog_blog_ids');        
    }

    # Save local blog ID for all tags other than
    # MTMultiBlog since that tag handles it itself.
    local $ctx->{__stash}{local_blog_id} = $ctx->stash('blog_id') 
        unless $ctx->stash('multiblog_context');
    # Remove local blog ID from MTTags since it is cross-blog
    # and hence MTMultiBlogIfLocalBlog doesn't make sense there.    
    local $ctx->{__stash}{local_blog_id} = 0 if $tag eq 'tags';

    # Call original tag handler with new args
    defined(my $result = $ctx->super_handler( $args, $cond ))
        or return $ctx->error($ctx->errstr);
    return $result;
}


sub post_feedback_save {
    my $plugin = shift;
    my ( $trigger, $eh, $feedback ) = @_;
    if ( $feedback->visible ) {
        my $blog_id = $feedback->blog_id;
        my $app = MT->instance;
        foreach my $scope ("blog:$blog_id", "system") {
            my $d = $plugin->get_config_value( $scope eq 'system' ? 'all_triggers' : 'other_triggers', $scope );
            while ( my ( $id, $a ) = each( %{ $d->{$trigger} } ) ) {
                next if $id == $blog_id;
                perform_mb_action( $app, $id, $_ ) foreach keys %$a;
            }
        }
    }
}

sub post_entry_save {
    my $plugin = shift;
    my ( $eh, $app, $entry ) = @_;
    my $blog_id = $entry->blog_id;

    foreach my $scope ("blog:$blog_id", "system") {
        my $d = $plugin->get_config_value( $scope eq 'system' ? 'all_triggers' : 'other_triggers', $scope );
        while ( my ( $id, $a ) = each( %{ $d->{'entry_save'} } ) ) {
            next if $id == $blog_id;
            perform_mb_action( $app, $id, $_ ) foreach keys %$a;
        }

        require MT::Entry;
        if ( $entry->status == MT::Entry::RELEASE() ) {
            while ( my ( $id, $a ) = each( %{ $d->{'entry_pub'} } ) ) {
                next if $id == $blog_id;
                perform_mb_action( $app, $id, $_ ) foreach keys %$a;
            }
        }
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

sub filter_blogs_from_args { 
    my ($plugin, $ctx, $args) = @_;

    # SANITY CHECK ON ARGUMENTS
    my $err;
    # Set and clean up working variables
    my $incl = $args->{include_blogs} || $args->{blog_id} || $args->{blog_ids};
    my $excl = $args->{exclude_blogs};
    for ($incl,$excl) {
        next unless $_;
        s{\s+}{}g ; # Remove spaces
    }
    
    # If there are no multiblog arguments to filter, we don't need to be here
    return 1 unless $incl or $excl;

    # Only one multiblog argument can be used
    my $arg_count = scalar grep { $_ and $_ ne '' } $args->{include_blogs}, 
                                                    $args->{blog_id}, 
                                                    $args->{blog_ids}, 
                                                    $args->{exclude_blogs};
    if ($arg_count > 1) {
        $err = $plugin->translate('The include_blogs, exclude_blogs, blog_ids and blog_id attributes cannot be used together.');
    }
    # exclude_blogs="all" is not allowed
    elsif ($excl and $excl =~ /all/i) {
        $err = $plugin->translate('The attribute exclude_blogs cannot take "all" for a value.');
    }
    # blog_id only accepts a single blog ID
    elsif ($args->{blog_id} and $args->{blog_id} !~ /^\d+$/) {
        $err = $plugin->translate('The value of the blog_id attribute must be a single blog ID.');
    }
    # Make sure include_blogs/exclude_blogs is valid
    elsif (($incl || $excl) ne 'all' 
        and ($incl || $excl) !~ /^\d+(,\d+)*$/) {
        $err =  $plugin->translate('The value for the include_blogs/exclude_blogs attributes must be one or more blog IDs, separated by commas.');
    }
    return $ctx->error($err) if $err;

    # Prepare for filter_blogs
    my ($attr, $val, @blogs);
    if ($incl) {
        ($attr, $val) = ('include_blogs', $incl);
    } else {
        ($attr, $val) = ('exclude_blogs', $excl);
    }
    @blogs = split(',', $val);

    # Filter the blogs using the MultiBlog access controls
    ($attr, @blogs) = filter_blogs($plugin, $ctx, $attr, @blogs);
    return unless $attr && @blogs;
    
    # Rewrite the args to the modifed value
    delete $args->{blog_ids} if exists $args->{blog_ids};  # Deprecated
    if ($args->{blog_id}) {
        $args->{'blog_id'} = $blogs[0];
    } else {
        delete $args->{include_blogs};
        delete $args->{exclude_blogs};
        $args->{$attr} = join(',', @blogs);
    }
    1;
}

## Get a mode (include/exclude) and list of blogs
## Process list using system default access setting and
## any blog-level overrides.
## Returns empty list if no blogs can be used
sub filter_blogs {
    my $plugin = shift;
    my ( $ctx, $is_include, @blogs ) = @_;

    # Set flag to indicate whether @blogs are to be included or excluded
    $is_include = $is_include eq 'include_blogs' ? 1 : 0;

    # Set local blog
    my $this_blog = $ctx->stash('blog_id') || 0;

    # Get the MultiBlog system config for default access and overrides
    my $default_access_allowed = 
        $plugin->get_config_value( 'default_access_allowed', 'system' );
    my $access_overrides = 
        $plugin->get_config_value( 'access_overrides', 'system' ) || {};

    # System setting allows access by default
    if ($default_access_allowed) {

        # include_blogs="all"
        if ($is_include and $blogs[0] eq "all") {
            # Check for any deny overrides. 
            # If found, switch to exclude_blogs="..."
            my @deny = grep {     $_ != $this_blog 
                              and exists $access_overrides->{$_} 
                              and $access_overrides->{$_} == DENIED 
                            } keys %$access_overrides;
            return @deny ? ('exclude_blogs', @deny)
                         : ('include_blogs', 'all');
         }
         # include_blogs="1,2,3,4"
         elsif ($is_include and @blogs) {
            # Remove any included blogs that are specifically deny override
            # Return undef is all specified blogs are deny override
            my @allow = grep {    $_ == $this_blog 
                               or ! exists $access_overrides->{$_} 
                               or $access_overrides->{$_} == ALLOWED
                             } @blogs;
            return @allow ? ('include_blogs', @allow) : undef;
         }
         # exclude_blogs="1,2,3,4"
         else {
             # Add any deny overrides blogs to the list and de-dupe
             push(@blogs, grep { $_ != $this_blog
                                 and $access_overrides->{$_} == DENIED 
                               } keys %$access_overrides);
            my %seen;
            @seen{@blogs} = ();
            @blogs = keys %seen;
            return ('exclude_blogs', @blogs);
         }
    }
    # System setting does not allow access by default
    else {
        # include_blogs="all"
        if ($is_include and $blogs[0] eq "all") {
            # Enumerate blogs from allow override
            # Hopefully this is significantly smaller than @all_blogs
            my @allow = grep { $_ == $this_blog 
                               or $access_overrides->{$_} == ALLOWED
                             } ($this_blog, keys %$access_overrides);
            return @allow ? ('include_blogs', @allow) : undef;
        }
        # include_blogs="1,2,3,4"
        elsif ($is_include and @blogs) {
            # Filter @blogs returning only those with allow override
            my @allow = grep {    $_ == $this_blog
                               or ( exists $access_overrides->{$_} 
                                    and $access_overrides->{$_} == ALLOWED)
                             } @blogs;
            return @allow ? ('include_blogs', @allow) : undef;
        }
        # exclude_blogs="1,2,3,4"
        else {
            # Get allow override blogs and then omit 
            # the specified excluded blogs.
            my @allow = grep { $_ == $this_blog
                               or $access_overrides->{$_} == ALLOWED
                             } ($this_blog, keys %$access_overrides);
            my %seen;
            @seen{@blogs} = ();
            @blogs = grep { ! $seen{$_} } @allow;
            return @blogs ? ('include_blogs', @blogs) : undef;
        }
    }
}


1;
