# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package FormattedText::App;

use strict;
use warnings;

use FormattedText;
use FormattedText::FormattedText;

sub is_enabled {
    my ($app) = @_;
    my $key = 'formatted_text_is_enabled';

    my $status = $app->request($key);

    return $status if defined $status;

    my $current_editor
        = lc( $app->config('WYSIWYGEditor') || $app->config('Editor') );
    my $settings = $app->registry( 'editors', $current_editor );
    $status = $settings->{template}
        && $settings->{formatted_text}{enabled} ? 1 : 0;

    $app->request( $key, $status );

    $status;
}

sub _is_enabled { is_enabled( MT->instance ) }

sub _load_formatted_text_to_param {
    my ( $key, $cb, $app, $param, $tmpl ) = @_;

    my $perms = $app->permissions;
    my $user  = $app->user;

    my @formatted_texts
        = $app->model('formatted_text')->load( { blog_id => $app->blog->id },
        { sort => 'id', direction => 'descend' } );
    $param->{$key} = [ grep { can_view_formatted_text( $perms, $_, $user ) }
            @formatted_texts ];
}

sub param_edit_entry {
    my ( $cb, $app, $param, $tmpl ) = @_;

    return if $param->{object_type} ne 'entry';

    _load_formatted_text_to_param( 'formatted_texts', @_ );
}

sub param_edit_formatted_text {
    my ( $cb, $app, $param, $tmpl ) = @_;

    _load_formatted_text_to_param( 'blog_formatted_texts', @_ );
}

sub can_edit_formatted_text {
    my ( $perms, $formatted_text, $author ) = @_;

    return 0 unless $author->isa('MT::Author');
    return 1 if $author->is_superuser();
    return 0 unless $perms;

    # For new object
    if ( !$formatted_text ) {
        return $perms->can_do('create_formatted_text');
    }

    return 1 if $perms->can_do('edit_all_formatted_texts');
    return 0 if !$perms->can_do('edit_own_formatted_texts');

    # This $author can only edit own boilerplate.
    if ( !ref $formatted_text ) {
        $formatted_text = MT->model('formatted_text')->load($formatted_text)
            or return 0;
    }
    return $formatted_text->created_by == $author->id;
}

sub can_view_formatted_text {
    my ( $perms, $formatted_text, $author ) = @_;

    return 0 unless $author->isa('MT::Author');
    return 1 if $author->is_superuser();
    return 0 unless $perms;

    $perms->can_do('view_all_formatted_texts');
}

sub cms_object_scope_filter {
    my ( $cb, $app, $id ) = @_;
    $app->blog;
}

sub save_permission_filter {
    my ( $cb, $app, $id ) = @_;
    my $user = $app->user;
    my $obj = $id ? $app->model('formatted_text')->load($id) : undef;
    my $perms
        = $obj ? $user->permissions( $obj->blog_id ) : $app->permissions;
    can_edit_formatted_text( $perms, $obj, $user );
}

sub view_permission_filter {
    my ( $cb, $app, $id ) = @_;
    my $user = $app->user;
    my $obj = $id ? $app->model('formatted_text')->load($id) : undef;
    my $perms
        = $obj ? $user->permissions( $obj->blog_id ) : $app->permissions;
    can_edit_formatted_text( $perms, $obj, $user );
}

sub delete_permission_filter {
    my ( $cb, $app, $obj ) = @_;
    my $user  = $app->user;
    my $perms = $user->permissions( $obj->blog_id );
    can_edit_formatted_text( $perms, $obj, $user );
}

sub set_params_for_formatted_text {
    my ( $cb, $app, $param ) = @_;
    $param->{search_type}  = 'entry';
    $param->{search_label} = $app->translate('Entry');
}

sub cms_edit_formatted_text {
    my ( $cb, $app, $id, $obj, $param ) = @_;
    $app->setup_editor_param($param);
    $param->{output} = File::Spec->catfile( plugin()->{full_path},
        'tmpl', 'cms', 'edit_formatted_text.tmpl' );
    set_params_for_formatted_text( $cb, $app, $param );

    $app->add_breadcrumb(
        $app->translate('Boilerplates'),
        $app->uri(
            mode => 'list',
            args => {
                _type   => 'formatted_text',
                blog_id => $app->blog->id,
            },
        ),
    );
    if ($id) {
        $app->add_breadcrumb( $obj->label );
    }
    else {
        $app->add_breadcrumb( $app->translate('Create Boilerplate') );
    }
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    my $blog_id = $app->blog ? $app->blog->id : undef;
    my $terms = $load_options->{terms} ||= {};
    $terms->{blog_id} = $blog_id if $blog_id;

    my $user = $app->user;
    return if $user->is_superuser;

    require MT::Permission;
    my $iter = MT::Permission->load_iter(
        {   author_id => $user->id,
            (   $blog_id
                ? ( blog_id => $blog_id )
                : ( blog_id => { 'not' => 0 } )
            ),
        }
    );

    my @editable_filters = my @filters = ( { blog_id => undef, } );
    while ( my $p = $iter->() ) {
        if ( $p->can_do('access_to_formatted_text_list') ) {
            push @filters, '-or', { blog_id => $p->blog_id, };
            push @editable_filters, '-or',
                {
                blog_id => $p->blog_id,
                (   $p->can_do('edit_all_formatted_texts')
                    ? ()
                    : ( created_by => $user->id )
                ),
                };
        }
    }

    $load_options->{terms} = [ %$terms ? ( $terms, '-and' ) : (), \@filters ];
    $load_options->{editable_terms}
        = [ %$terms ? ( $terms, '-and' ) : (), \@editable_filters ];
}

sub list_template_param {
    my ( $cb, $app, $param, $tmpl ) = @_;
    for ('saved_deleted') {
        $param->{$_} = 1 if $app->param($_);
    }
    set_params_for_formatted_text( $cb, $app, $param );
}

sub filtered_list_param {
    my ( $cb, $app, $param, $objs ) = @_;
    my $user        = $app->user;
    my $i           = 0;
    my $local_scope = $app->param('blog_id');
    my %perms;

    for my $obj (@$objs) {
        my $row     = $param->{objects}->[ $i++ ];
        my $blog_id = $obj->blog_id;
        if ( !$blog_id && $local_scope ) {
            $row->[0] = 0;
        }
        next if $user->is_superuser;
        if ( !exists $perms{$blog_id} ) {
            $perms{$blog_id} = MT::Permission->load(
                { blog_id => $obj->blog_id, author_id => $user->id } );
        }
        if ( !can_edit_formatted_text( $perms{$blog_id}, $obj, $user ) ) {
            $row->[0] = 0;
        }
    }
}

sub listing_screens {
    return {
        object_label       => 'Boilerplate',
        primary            => 'label',
        default_sort_key   => 'created_on',
        default_sort_order => 'descend',
        permission         => {
            permit_action => 'access_to_formatted_text_list',
            inherit       => 0,
        },
        condition => \&_is_enabled,
        template => File::Spec->catfile(
            plugin()->{full_path}, 'tmpl',
            'cms',                 'list_formatted_text.tmpl'
        ),
    };
}

sub system_filters {
    return {
        my_formatted_text => {
            label => 'My Boilerplate',
            items => sub {
                [ { type => 'current_user' } ],;
            },
            order => 100,
        },
    };
}

sub list_actions {
    return {
        delete => {
            label                   => 'Delete',
            order                   => 100,
            continue_prompt_handler => sub {
                translate(
                    'Are you sure you want to delete the selected boilerplates?'
                );
            },
            mode       => 'delete',
            button     => 1,
            js_message => 'delete',
        },
    };
}

sub content_actions {
    return {
        create_new => {
            mode      => 'view',
            args      => { _type => 'formatted_text', },
            class     => 'icon-create',
            icon      => 'ic_add',
            label     => 'Create New',
            order     => 100,
            condition => sub { MT->instance->blog },
        },
    };
}

sub enable_object_methods {
    return +{
        formatted_text => {
            delete => \&_is_enabled,
            edit   => \&_is_enabled,
            save   => \&_is_enabled,
        },
    };
}

1;
