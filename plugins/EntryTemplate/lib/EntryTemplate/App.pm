package EntryTemplate::App;

use strict;
use warnings;

use EntryTemplate;
use EntryTemplate::EntryTemplate;

sub param_edit_entry {
    my ( $cb, $app, $param, $tmpl ) = @_;

    my $perms = $app->permissions;
    my $user  = $app->user;

    my @entry_templates = $app->model('entry_template')
        ->load( { blog_id => $app->blog->id } );
    $param->{entry_templates}
        = [ grep { can_view_entry_template( $perms, $_, $user ) }
            @entry_templates ];
}

sub can_edit_entry_template {
    my ( $perms, $entry_template, $author ) = @_;
    die unless $author->isa('MT::Author');
    return 1 if $author->is_superuser();
    return 0 unless $perms;
    unless ( ref $entry_template ) {
        $entry_template = EntryTemplate::EntryTemplate->load($entry_template)
            or die;
    }
    die unless $entry_template->isa('EntryTemplate::EntryTemplate');
    my $own_entry_template = $entry_template->created_by == $author->id;

    return $own_entry_template
        ? $perms->can_do('edit_own_published_entry')
        : $perms->can_do('edit_all_published_entry');
}

sub can_view_entry_template {
    my ( $perms, $entry_template, $author ) = @_;
    die unless $author->isa('MT::Author');
    return 1 if $author->is_superuser();
    return $perms->can_create_post;
}

sub save_permission_filter {
    my ( $cb, $app, $entry_template ) = @_;
    my $perms = $app->permissions;
    if ($entry_template) {
        return 0
            unless can_edit_entry_template( $perms, $entry_template,
            $app->user );
    }
    else {
        return 0 unless $perms->can_do('create_new_entry');
    }
}

sub view_permission_filter {
    my ( $cb, $app, $entry_template ) = @_;
    my $perms = $app->permissions;
    if ($entry_template) {
        return 0
            unless can_edit_entry_template( $perms, $entry_template,
            $app->user );
    }
    else {
        return 0 unless $perms->can_do('create_new_entry');
    }
}

sub delete_permission_filter {
    my ( $cb, $app, $entry_template ) = @_;
    my $perms = $app->permissions;
    return 0
        unless can_edit_entry_template( $perms, $entry_template, $app->user );
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

    $load_options->{terms}{blog_id} = $blog_id if $blog_id;

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

    my $filters;
    while ( my $perm = $iter->() ) {
        next if $perm->can_do('edit_all_published_entry');

        push @$filters,
            (
            '-or',
            {   blog_id    => $perm->blog_id,
                created_by => $user->id,
            }
            );
    }

    my $terms = $load_options->{terms} ? { %{ $load_options->{terms} } } : {};
    delete $terms->{blog_id}
        if exists $terms->{blog_id};
    delete $terms->{author_id}
        if exists $terms->{author_id};

    my $new_terms;
    push @$new_terms, ($terms)
        if ( keys %$terms );
    push @$new_terms, ( '-and', $filters );
    $load_options->{editable_terms} = $new_terms;
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

    my @columns = split /,/, $param->{columns};
    my ($label_col) = grep { $columns[$_] eq 'label' } 0 .. $#columns;
    $label_col++;

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
            $row->[$label_col] =~ s{<a[^>]+>(.*?)</a>}{$1};
        }
    }
}

sub view_text {
    my $app  = shift;
    my $user = $app->user;

    my $entry_template
        = MT->model('entry_template')->load( $app->param('id') )
        or
        return $app->error( $app->translate('Cannot load entry template.') );

    return $app->permission_denied()
        if ( !$user->is_superuser )
        && (
        !can_view_entry_template(
            $app->permissions, $entry_template, $app->user
        )
        );

    $app->{no_print_body} = 1;

    local $| = 1;
    $app->send_http_header('text/html');

    $app->print_encode( $entry_template->text );
}

sub listing_screens {
    return {
        object_label       => 'EntryTemplate',
        primary            => 'label',
        default_sort_key   => 'created_on',
        default_sort_order => 'descend',
        permission         => 'access_to_entry_list',
        template           => File::Spec->catfile(
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
