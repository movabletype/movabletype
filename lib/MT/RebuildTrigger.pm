# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::RebuildTrigger;

use strict;
use base qw( MT::Object );

use Exporter 'import';
our @EXPORT_OK = qw(
    TYPE_ENTRY_OR_PAGE TYPE_CONTENT_TYPE TYPE_COMMENT TYPE_PING
    ACTION_RI ACTION_RIP
    EVENT_SAVE EVENT_PUBLISH EVENT_UNPUBLISH
    TARGET_ALL TARGET_BLOGS_IN_WEBSITE TARGET_BLOG
);
our %EXPORT_TAGS = (
    constants => [qw(
        TYPE_ENTRY_OR_PAGE TYPE_CONTENT_TYPE TYPE_COMMENT TYPE_PING
        ACTION_RI ACTION_RIP
        EVENT_SAVE EVENT_PUBLISH EVENT_UNPUBLISH
        TARGET_ALL TARGET_BLOGS_IN_WEBSITE TARGET_BLOG
    )]);

sub TYPE_ENTRY_OR_PAGE() { 1 }
sub TYPE_CONTENT_TYPE()  { 2 }
sub TYPE_COMMENT()       { 3 }
sub TYPE_PING()          { 4 }

sub ACTION_RI()  { 1 }    # rebuild index pages
sub ACTION_RIP() { 2 }    # rebuild index pages and send update ping

sub EVENT_SAVE()      { 1 }
sub EVENT_PUBLISH()   { 2 }
sub EVENT_UNPUBLISH() { 3 }

sub TARGET_ALL()              { 1 }
sub TARGET_BLOGS_IN_WEBSITE() { 2 }
sub TARGET_BLOG()             { 3 }

__PACKAGE__->install_properties({
    column_defs => {
        'id'             => 'integer not null auto_increment',
        'blog_id'        => 'integer not null',
        'object_type'    => 'integer',
        'ct_id'          => 'integer',
        'ct_unique_id'   => 'string(40)',
        'action'         => 'integer',
        'event'          => 'integer',
        'target'         => 'integer',
        'target_blog_id' => 'integer',
    },
    indexes     => { blog_id => 1 },
    datasource  => 'rebuild_trigger',
    primary_key => 'id',
    audit       => 1,
    child_of    => ['MT::Blog', 'MT::Website'],
});

# Blog-level Access override statuses
sub DENIED ()  { 1 }
sub ALLOWED () { 2 }

sub class_label {
    MT->translate("Rebuild Trigger");
}

sub get_config_value {
    my $self = shift;
    my ($var, $blog_id) = @_;
    my $target_blog = MT->model('blog')->load($blog_id);
    my $target_blog_id   = $var == TARGET_BLOG() ? $blog_id : 0;
    my @rebuild_triggers = MT->model('rebuild_trigger')->load({ target => $var, target_blog_id => $target_blog_id });
    my $data        = {};
    for my $rt (@rebuild_triggers) {
        my @blog_ids;
        if ($var == TARGET_ALL()) {
            push @blog_ids, $rt->blog_id;
        } elsif ($var == TARGET_BLOGS_IN_WEBSITE()) {
            push @blog_ids, $rt->blog_id if $target_blog->id == $rt->blog_id;
        } else {
            push @blog_ids, $rt->blog_id;
        }
        if ($rt->ct_id) {
            $data->{ $rt->object_type }{ $rt->event }{$_}{ $rt->action }{$rt->ct_id} = 1 for @blog_ids;
        } else {
            $data->{ $rt->object_type }{ $rt->event }{$_}{ $rt->action } = 0 for @blog_ids;
        }
    }
    return $data;
}

sub post_contents_bulk_save {
    my $self = shift;
    my ($cb, $app, $contents) = @_;
    for my $content (@$contents) {
        post_content_save($self, $cb, $app, $content->{current}, $content->{original});
    }
}

sub post_content_save {
    my $self = shift;
    my ($cb, $app, $content, $original) = @_;
    my $blog_id = $content->blog_id;

    my $code = sub {
        my ($d) = @_;
        require MT::ContentStatus;
        if (($content->status || 0) == MT::ContentStatus::RELEASE() or ($original->status || 0) == MT::ContentStatus::RELEASE()) {
            while (my ($id, $actions) = each(%{ $d->{ TYPE_CONTENT_TYPE() }->{ EVENT_SAVE() } })) {
                next if $id == $blog_id;
                for my $action (keys %$actions) {
                    perform_mb_action($app, $id, $action) if $actions->{$action}->{$content->content_type_id};
                }
            }
        }

        if (($content->status || 0) == MT::ContentStatus::RELEASE()) {
            while (my ($id, $actions) = each(%{ $d->{ TYPE_CONTENT_TYPE() }->{ EVENT_PUBLISH() } })) {
                next if $id == $blog_id;
                for my $action (keys %$actions) {
                    perform_mb_action($app, $id, $action) if $actions->{$action}->{$content->content_type_id};
                }
            }
        }
    };

    _post_content_common($self, $blog_id, $code, $content->blog);
}

sub post_content_pub {
    my $self = shift;
    my ($cb, $app, $content) = @_;
    my $blog_id = $content->blog_id;

    my $code = sub {
        my ($d) = @_;

        require MT::ContentStatus;
        if (($content->status || 0) == MT::ContentStatus::RELEASE()) {
            while (my ($id, $actions) = each(%{ $d->{ TYPE_CONTENT_TYPE() }->{ EVENT_PUBLISH() } })) {
                next if $id == $blog_id;
                for my $action (keys %$actions) {
                    perform_mb_action($app, $id, $action) if $actions->{$action}->{$content->content_type_id};
                }
            }
        }
    };

    _post_content_common($self, $blog_id, $code, $content->blog);
}

sub post_content_unpub {
    my $self = shift;
    my ($cb, $app, $content) = @_;
    my $blog_id = $content->blog_id;

    my $code = sub {
        my ($d) = @_;

        require MT::ContentStatus;
        if (($content->status || 0) == MT::ContentStatus::UNPUBLISH()) {
            while (my ($id, $actions) = each(%{ $d->{ TYPE_CONTENT_TYPE() }->{ EVENT_UNPUBLISH() } })) {
                next if $id == $blog_id;
                for my $action (keys %$actions) {
                    perform_mb_action($app, $id, $action) if $actions->{$action}->{$content->content_type_id};
                }
            }
        }
    };

    _post_content_common($self, $blog_id, $code, $content->blog);
}

sub init_rebuilt_cache {
    my ($self, $app) = @_;
    $app->request('sites_rebuild', {});
}

sub is_first_rebuild {
    my ($app, $blog_id, $action) = @_;
    my $rebuilt = $app->request('sites_rebuild') || {};
    return if exists $rebuilt->{"$blog_id,$action"};
    $rebuilt->{"$blog_id,$action"} = 1;
    $app->request('sites_rebuild', $rebuilt);
}

sub perform_mb_action {
    my ($app, $blog_id, $action) = @_;

    # Don't rebuild the same thing twice in a same runner
    return unless is_first_rebuild($app, $blog_id, $action);

    # If the action we are performing starts with ri
    # we rebuild indexes for the given blog_id
    $app->rebuild_indexes(BlogID => $blog_id) if ($action == ACTION_RI() || $action == ACTION_RIP());
}

sub load_sites_acl {
    my $self = shift;
    my ($ctx) = @_;

    # Set local site
    my $this_blog = $ctx->stash('blog_id') || 0;

    # Get the MultiBlog system config for default access and overrides
    my $default_access_allowed = MT->config('DefaultAccessAllowed');
    my $access_overrides       = MT->config('AccessOverrides') ? MT::Util::from_json(MT->config('AccessOverrides')) : {};

    # System setting allows access by default
    my ($mode, @acl);
    if ($default_access_allowed) {
        @acl  = grep { $_ != $this_blog and exists $access_overrides->{$_} and $access_overrides->{$_} == DENIED } keys %$access_overrides;
        $mode = 'deny_blogs';
    } else {
        @acl  = grep { $_ == $this_blog or $access_overrides->{$_} == ALLOWED } ($this_blog, keys %$access_overrides);
        $mode = 'allow_blogs';
    }

    return (mode => $mode, acl => @acl ? \@acl : undef);
}

sub post_restore {
    my ($self, $objects, $deferred, $errors, $callback) = @_;

    for my $key (keys %$objects) {
        next unless $key =~ /^MT::RebuildTrigger#\d+$/;
        my $rt = $objects->{$key};
        my ($new_blog_id,   $new_target_blog_id,   $new_content_type_id);
        my ($blog_restored, $target_blog_restored, $content_type_restored) = (0, 0, 0);
        if ($rt->target == TARGET_ALL()) {
            $new_blog_id   = 0;
            $blog_restored = 1;
        } else {
            # target_blog_id
            my $target_id      = $rt->target_blog_id;
            my $new_target_obj = $objects->{ 'MT::Blog#' . $target_id };
            $new_target_obj = $objects->{ 'MT::Website#' . $target_id } unless $new_target_obj;
            if ($new_target_obj) {
                $callback->(MT->translate('Restoring rebuild trigger for blog #[_1]...', $target_id));
                $new_target_blog_id   = $new_target_obj->id;
                $target_blog_restored = 1;
            }

            if ($rt->target != TARGET_BLOGS_IN_WEBSITE()) {

                # blog_id
                my $id      = $rt->blog_id;
                my $new_obj = $objects->{ 'MT::Blog#' . $id };
                $new_obj = $objects->{ 'MT::Website#' . $id } unless $new_obj;
                if ($new_obj) {
                    $callback->(MT->translate('Restoring rebuild trigger for blog #[_1]...', $id));
                    $new_blog_id   = $new_obj->id;
                    $blog_restored = 1;
                }
            }
        }

        # content_type_id
        if ($rt->object_type == TYPE_CONTENT_TYPE()) {
            my $content_type_id      = $rt->ct_id;
            my $new_content_type_obj = $objects->{ 'MT::ContentType#' . $content_type_id };
            if ($new_content_type_obj) {
                $callback->(MT->translate('Restoring Rebuild Trigger for Content Type #[_1]...', $content_type_id));
                $new_content_type_id   = $new_content_type_obj->id;
                $content_type_restored = 1;
            }
        }

        if ($blog_restored || $target_blog_restored) {
            $rt->blog_id($new_blog_id)               if $blog_restored;
            $rt->target_blog_id($new_target_blog_id) if $target_blog_restored;
            $rt->ct_id($new_content_type_id)         if $content_type_restored;
            $rt->save;
        }
    }
}

# Run-time loading for Rebuild Trigger core methods
sub runner {
    my $self   = shift;
    my $method = shift;
    $self->init_rebuilt_cache(MT->instance);
    no strict 'refs';
    return $_->($self, @_) if $_ = \&{"MT::RebuildTrigger::$method"};
    die "Failed to find MT::RebuildTrigger::$method";
}

sub post_feedback_save_comment_pub {
    my $self = shift;
    $self->_post_feedback_save(TYPE_COMMENT(), EVENT_PUBLISH(), @_);
}

sub post_feedback_save_tb_pub {
    my $self = shift;
    $self->_post_feedback_save(TYPE_PING(), EVENT_PUBLISH(), @_);
}

sub _post_feedback_save {
    my $self = shift;
    my ($type, $event, $eh, $feedback) = @_;
    if ($feedback->visible) {
        my $blog_id = $feedback->blog_id;
        my $app     = MT->instance;

        my $code = sub {
            my ($d) = @_;

            while (my ($id, $actions) = each(%{ $d->{$type}->{$event} })) {
                next if $id == $blog_id;
                perform_mb_action($app, $id, $_) for keys %$actions;
            }
        };

        _post_content_common($self, $blog_id, $code, $feedback->blog);
    }
}

sub post_entries_bulk_save {
    my $self = shift;
    my ($cb, $app, $entries) = @_;
    for my $entry (@$entries) {
        &post_entry_save($self, $cb, $app, $entry->{current}, $entry->{original});
    }
}

sub post_entry_save {
    my $self = shift;
    my ($cb, $app, $entry, $original) = @_;
    my $blog_id = $entry->blog_id;

    my $code = sub {
        my ($d) = @_;
        require MT::Entry;
        if (($entry->status || 0) == MT::Entry::RELEASE() or ($original->status || 0) == MT::Entry::RELEASE()) {
            while (my ($id, $actions) = each(%{ $d->{ TYPE_ENTRY_OR_PAGE() }->{ EVENT_SAVE() } })) {
                next if $id == $blog_id;
                perform_mb_action($app, $id, $_) for keys %$actions;
            }
        }

        if (($entry->status || 0) == MT::Entry::RELEASE()) {
            while (my ($id, $actions) = each(%{ $d->{ TYPE_ENTRY_OR_PAGE() }->{ EVENT_PUBLISH() } })) {
                next if $id == $blog_id;
                perform_mb_action($app, $id, $_) for keys %$actions;
            }
        }
    };

    _post_content_common($self, $blog_id, $code, $entry->blog);
}

sub post_entry_pub {
    my $self = shift;
    my ($cb, $app, $entry) = @_;
    my $blog_id = $entry->blog_id;

    my $code = sub {
        my ($d) = @_;

        require MT::Entry;
        if (($entry->status || 0) == MT::Entry::RELEASE()) {
            while (my ($id, $actions) = each(%{ $d->{ TYPE_ENTRY_OR_PAGE() }->{ EVENT_PUBLISH() } })) {
                next if $id == $blog_id;
                perform_mb_action($app, $id, $_) for keys %$actions;
            }
        }
    };

    _post_content_common($self, $blog_id, $code, $entry->blog);
}

sub post_entry_unpub {
    my $self = shift;
    my ($cb, $app, $entry) = @_;
    my $blog_id = $entry->blog_id;

    my $code = sub {
        my ($d) = @_;

        require MT::Entry;
        if (($entry->status || 0) == MT::Entry::UNPUBLISH()) {
            while (my ($id, $actions) = each(%{ $d->{ TYPE_ENTRY_OR_PAGE() }->{ EVENT_UNPUBLISH() } })) {
                next if $id == $blog_id;
                perform_mb_action($app, $id, $_) for keys %$actions;
            }
        }
    };

    _post_content_common($self, $blog_id, $code, $entry->blog);
}

sub _post_content_common {
    my ($self, $blog_id, $code, $blog) = @_;

    $code->($self->get_config_value(TARGET_BLOG(), $blog_id)) if $blog_id;
    $code->($self->get_config_value(TARGET_ALL(),  0));

    if ($blog->is_blog && (my $website = $blog->website)) {
        my $d = $self->get_config_value(TARGET_BLOGS_IN_WEBSITE(), $website->id);
        $code->($d);
    }
}

1;
