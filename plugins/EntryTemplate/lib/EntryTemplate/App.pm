package EntryTemplate::App;

use strict;
use warnings;

use EntryTemplate;
use EntryTemplate::EntryTemplate;

sub is_enabled {
    my ($app) = @_;
    my $key = 'entry_template_is_enabled';

    my $status = $app->request($key);

    return $status if defined $status;

    my $current_editor
        = lc( $app->config('WYSIWYGEditor') || $app->config('Editor') );
    my $settings = $app->registry( 'editors', $current_editor );
    $status = $settings->{entry_template}{enabled} ? 1 : 0;

    $app->request( $key, $status );

    $status;
}

sub param_edit_entry {
    my ( $cb, $app, $param, $tmpl ) = @_;

    my $perms = $app->permissions;
    my $user  = $app->user;

    my @entry_templates
        = $app->model('entry_template')->load( { blog_id => $app->blog->id },
        { sort => 'id', direction => 'descend' } );
    $param->{entry_templates}
        = [ grep { can_view_entry_template( $perms, $_, $user ) }
            @entry_templates ];
}

sub can_edit_entry_template {
    my ( $perms, $entry_template, $author ) = @_;

    return 0
        if ( !$perms )
        || ( !$author->isa('MT::Author') );
    return 1 if $author->is_superuser();

    # For new object
    if ( !$entry_template ) {
        return $perms->can_do('create_entry_template');
    }

    return 1 if $perms->can_do('edit_all_entry_templates');
    return 0 if !$perms->can_do('edit_own_entry_templates');

    # This $author can only edit own entry template.
    if ( !ref $entry_template ) {
        $entry_template = MT->model('entry_template')->load($entry_template)
            or return 0;
    }
    return $entry_template->created_by == $author->id;
}

sub can_view_entry_template {
    my ( $perms, $entry_template, $author ) = @_;

    return 0
        if ( !$perms )
        || ( !$author->isa('MT::Author') );

    $author->is_superuser() || $perms->can_do('view_all_entry_templates');
}

sub save_permission_filter {
    my ( $cb, $app, $entry_template ) = @_;
    my $perms = $app->permissions;
    can_edit_entry_template( $perms, $entry_template, $app->user );
}

sub view_permission_filter {
    my ( $cb, $app, $entry_template ) = @_;
    my $perms = $app->permissions;
    can_edit_entry_template( $perms, $entry_template, $app->user );
}

sub delete_permission_filter {
    my ( $cb, $app, $entry_template ) = @_;
    my $perms = $app->permissions;
    can_edit_entry_template( $perms, $entry_template, $app->user );
}

sub set_params_for_entry_template {
    my ( $cb, $app, $param ) = @_;
    $param->{search_type}  = 'entry';
    $param->{search_label} = $app->translate('Entry');
}

sub cms_edit_entry_template {
    my ( $cb, $app, $id, $obj, $param ) = @_;
    $app->setup_editor_param($param);
    $param->{output} = File::Spec->catfile( plugin()->{full_path},
        'tmpl', 'cms', 'edit_entry_template.tmpl' );
    set_params_for_entry_template( $cb, $app, $param );
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
        if ( $p->can_do('access_to_entry_template_list') ) {
            push @filters, '-or', { blog_id => $p->blog_id, };
            push @editable_filters, '-or',
                {
                blog_id => $p->blog_id,
                (   $p->can_do('edit_all_entry_templates')
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
    set_params_for_entry_template( $cb, $app, $param );
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
        if ( !can_edit_entry_template( $perms{$blog_id}, $obj, $user ) ) {
            $row->[0] = 0;
        }
    }
}

sub listing_screens {
    return {
        object_label       => 'EntryTemplate',
        primary            => 'label',
        default_sort_key   => 'created_on',
        default_sort_order => 'descend',
        permission         => {
            permit_action => 'access_to_entry_template_list',
            inherit       => 0,
        },
        template => File::Spec->catfile(
            plugin()->{full_path}, 'tmpl',
            'cms',                 'list_entry_template.tmpl'
        ),
    };
}

sub system_filters {
    return {
        my_entry_template => {
            label => 'My Entry Template',
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
                    'Are you sure you want to delete the selected EntryTemplates?'
                );
            },
            mode       => 'delete',
            button     => 1,
            js_message => 'delete',
        },
    };
}

1;
