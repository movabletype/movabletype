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

# Blog-level Access override statuses
sub DENIED ()  {1}
sub ALLOWED () {2}

sub class_label {
    MT->translate("Rebuild Trigger");
}

sub post_contents_bulk_save {
    my $self = shift;
    my ( $app, $contents ) = @_;
    foreach my $content (@$contents) {
        &post_content_save( $self, $app, $content->{current} );
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
    my $data = $self->get_config_obj(@_)->data();
    $data ? MT::Util::from_json($data) : {};
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
    $self->apply_default_settings( $data, $blog_id ) unless $data;
    $rebuild_trigger->data( MT::Util::to_json($data) );
    $rebuild_trigger;
}

sub apply_default_settings {
    my ( $self, $data, $blog_id ) = @_;

    if ( $blog_id > 0 ) {
        $data->{default_mt_sites_action} = 1;
    }
    else {
        $data->{default_access_allowed} = 1;
    }
}

sub post_content_save {
    my $self = shift;
    my ( $app, $content ) = @_;
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
    my ( $app, $content ) = @_;
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
    my ( $app, $content ) = @_;
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

sub load_sites_acl {
    my $self = shift;
    my ($ctx) = @_;

    # Set local site
    my $this_blog = $ctx->stash('blog_id') || 0;

    # Get the MultiBlog system config for default access and overrides
    my $default_access_allowed
        = $self->get_config_value( 'default_access_allowed', 0 );
    my $access_overrides
        = $self->get_config_value( 'access_overrides', 0 ) || {};

    # System setting allows access by default
    my ( $mode, @acl );
    if ($default_access_allowed) {
        @acl = grep {
                    $_ != $this_blog
                and exists $access_overrides->{$_}
                and $access_overrides->{$_} == DENIED
        } keys %$access_overrides;
        $mode = 'deny_blogs';
    }
    else {
        @acl = grep { $_ == $this_blog or $access_overrides->{$_} == ALLOWED }
            ( $this_blog, keys %$access_overrides );
        $mode = 'allow_blogs';
    }

    return ( mode => $mode, acl => @acl ? \@acl : undef );
}

sub post_restore {
    my ( $self, $objects, $deferred, $errors, $callback ) = @_;

    foreach my $key ( keys %$objects ) {
        next unless $key =~ /^MT::RebuildTrigger#\d+$/;
        my $rt = $objects->{$key};
        my $data = $rt->data || {};
        $data = MT::Util::from_json($data);
        next unless ref $data eq 'HASH';
        if ( my $rebuild_triggers = $data->{rebuild_triggers} ) {
            my @restored;
            foreach my $trg_str ( split( '\|', $rebuild_triggers ) ) {
                my ( $action, $id, $trigger ) = split( ':', $trg_str );
                if ( $id eq '_all' ) {
                    push @restored, "$action:$id:$trigger";
                }
                elsif ( $id eq '_blogs_in_website' ) {
                    my @keys = keys %{ $data->{blogs_in_website_triggers} };
                    foreach my $act (@keys) {
                        my @old_ids = keys
                            %{ $data->{blogs_in_website_triggers}{$act} };
                        foreach my $old_id (@old_ids) {
                            my $new_obj = $objects->{ 'MT::Blog#' . $old_id };
                            $new_obj = $objects->{ 'MT::Website#' . $old_id }
                                unless $new_obj;
                            if ($new_obj) {
                                $data->{blogs_in_website_triggers}{$act}
                                    { $new_obj->id }
                                    = delete
                                    $data->{blogs_in_website_triggers}{$act}
                                    {$old_id};
                                $callback->(
                                    $self->translate(
                                        'Restoring MultiBlog rebuild trigger for blog #[_1]...',
                                        $old_id
                                    )
                                );
                            }
                        }
                    }
                    push @restored, "$action:$id:$trigger";
                }
                else {
                    my $new_obj = $objects->{ 'MT::Blog#' . $id };
                    $new_obj = $objects->{ 'MT::Website#' . $id }
                        unless $new_obj;
                    if ($new_obj) {
                        push @restored,
                            "$action:" . $new_obj->id . ":$trigger";
                        $callback->(
                            $self->translate(
                                'Restoring MultiBlog rebuild trigger for blog #[_1]...',
                                $id
                            )
                        );
                    }
                }
            }

            if (@restored) {
                $data->{rebuild_triggers} = join( '|', @restored );
                $rt->data( MT::Util::to_json($data) );
                $rt->save;
            }
        }
        elsif ( my $other_triggers = $data->{other_triggers} ) {
            my @keys = keys %{$other_triggers};
            foreach my $act (@keys) {
                my @old_ids = keys %{ $other_triggers->{$act} };
                foreach my $old_id (@old_ids) {
                    my $new_obj = $objects->{ 'MT::Blog#' . $old_id };
                    $new_obj = $objects->{ 'MT::Website#' . $old_id }
                        unless $new_obj;
                    if ($new_obj) {
                        $data->{other_triggers}{$act}{ $new_obj->id }
                            = delete $data->{other_triggers}{$act}{$old_id};
                        $callback->(
                            $self->translate(
                                'Restoring MultiBlog rebuild trigger for blog #[_1]...',
                                $old_id
                            )
                        );
                    }
                }
            }
            $rt->data( MT::Util::to_json($data) );
            $rt->save;
        }
    }
}

# Run-time loading for Rebuild Trigger core methods
sub runner {
    my $self   = shift;
    my $method = shift;
    $self->init_rebuilt_cache( MT->instance );
    no strict 'refs';
    return $_->( $self, @_ ) if $_ = \&{"MT::RebuildTrigger::$method"};
    die "Failed to find MT::RebuildTrigger::$method";
}

1;
