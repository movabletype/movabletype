# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::Import;

use strict;
use warnings;

use MT::I18N qw( const );

sub start_import {
    my $app     = shift;
    my $blog_id = $app->param('blog_id');

    my $perms = $app->permissions;
    return $app->permission_denied()
        unless $perms && $app->can_do('open_start_import_screen');

    my $blog = $app->model('blog')->load($blog_id);
    return $app->return_to_dashboard( redirect => 1 )
        if !$blog;

    my %param;

    # FIXME: This should build a category hierarchy!
    my $cat_class = $app->model('category');
    my $iter      = $cat_class->load_iter(
        { blog_id => $blog_id, category_set_id => 0 } );
    my @data;
    while ( my $cat = $iter->() ) {
        push @data,
            {
            category_id    => $cat->id,
            category_label => $cat->label
            };
    }
    @data = sort { $a->{category_label} cmp $b->{category_label} } @data;
    $param{category_loop} = \@data;
    $param{nav_import}    = 1;

    #$param{can_edit_authors} = $app->permissions->can_administer_site;
    $param{encoding_names} = const('ENCODING_NAMES');
    require MT::Auth;
    $param{password_needed} = MT::Auth->password_exists;

    my $importer_loop = [];
    require MT::Import;
    my $imp  = MT::Import->new;
    my @keys = $imp->importer_keys;
    my ( $mt, $mt_format );
    for my $key (@keys) {
        my $importer = $imp->importer($key);
        $importer->{key} = $key;
        $mt        = $importer, next if $key eq 'import_mt';
        $mt_format = $importer, next if $key eq 'import_mt_format';
        push @$importer_loop,
            {
            label       => $importer->{label},
            key         => $importer->{key},
            description => $importer->{description},
            importer_options_html =>
                $imp->get_options_html( $importer->{key}, $blog_id ),
            };
    }
    push @$importer_loop,
        {
        label       => $mt_format->{label},
        key         => $mt_format->{key},
        description => $mt_format->{description},
        importer_options_html =>
            $imp->get_options_html( $mt_format->{key}, $blog_id ),
        };
    unshift @$importer_loop,
        {
        label       => $mt->{label},
        key         => $mt->{key},
        description => $mt->{description},
        importer_options_html =>
            $imp->get_options_html( $mt->{key}, $blog_id ),
        };

    $param{importer_loop} = $importer_loop;

    if ($blog_id) {
        $param{blog_id} = $blog_id;
        my $blog = $app->model('blog')->load($blog_id)
            or return $app->error(
            $app->translate( 'Cannot load site #[_1].', $blog_id ) );
        $param{text_filters}
            = $app->load_text_filters( $blog->convert_paras, 'entry' );
    }

    $app->add_breadcrumb( $app->translate('Import Site Entries') );
    $app->load_tmpl( 'import.tmpl', \%param );
}

sub do_import {
    my $app = shift;

    require MT::Blog;
    my $blog_id = $app->param('blog_id')
        or return $app->return_to_dashboard( redirect => 1 );

    my $blog = MT::Blog->load($blog_id)
        or return $app->error(
        $app->translate(
            "Loading site '[_1]' failed: [_2]", $blog_id,
            MT::Blog->errstr
        )
        );

    if ( 'POST' ne $app->request_method ) {
        return $app->redirect(
            $app->uri(
                'mode' => 'start_import',
                args   => { blog_id => $blog_id }
            )
        );
    }

    return $app->permission_denied()
        unless $app->user->permissions($blog_id)->can_do('import_blog');

    my $import_as_me = $app->param('import_as_me');

    ## Determine the user as whom we will import the entries.
    my $author    = $app->user;
    my $author_id = $author->id;

    $app->can_do('import_blog_as_me')
        or return $app->error(
        $app->translate('You do not have import permission') );
    if ( !$import_as_me ) {
        $app->can_do('import_blog_with_authors')
            or return $app->error(
            $app->translate('You do not have permission to create users') );
    }

    my $password       = $app->param('password');
    my $default_cat_id = $app->param('default_cat_id');
    my $convert_breaks = $app->param('convert_breaks');

    if ( !$import_as_me and !$password and MT::Auth->password_exists ) {
        return $app->error(
            $app->translate(
                'You need to provide a password if you are going to create new users for each user listed in your site.'
            )
        );
    }

    $app->validate_magic() or return;

    $app->add_breadcrumb(
        $app->translate('Import Site Entries'),
        $app->uri(
            mode => 'start_import',
            args => { blog_id => $blog_id },
        ),
    );
    $app->add_breadcrumb( $app->translate('Import') );

    my ($fh) = $app->upload_info('file');
    my $encoding = $app->param('encoding');
    my $stream = $fh ? $fh : $app->config('ImportPath');

    $app->{no_print_body} = 1;

    local $| = 1;
    $app->send_http_header('text/html');

    my $param;
    $param
        = { import_as_me => $import_as_me, import_upload => ( $fh ? 1 : 0 ) };

    $app->print_encode(
        $app->build_page( 'include/import_start.tmpl', $param ) );

    require MT::Entry;
    require MT::Placement;
    require MT::Category;
    require MT::Permission;
    require MT::Comment;
    require MT::TBPing;

    my $import_type = $app->param('import_type') || '';
    require MT::Import;
    my $imp      = MT::Import->new;
    my $importer = $imp->importer($import_type);

    return $app->error(
        $app->translate( 'Importer type [_1] was not found.', $import_type ) )
        unless $importer;

    my %options;
    %options = map { $_ => scalar $app->param($_); } @{ $importer->{options} }
        if $importer->{options};
    my $import_result = $imp->import_contents(
        Key      => $import_type,
        Blog     => $blog,
        Stream   => $stream,
        Callback => sub { $app->print_encode(@_) },
        Encoding => $encoding,
        ($import_as_me)
        ? ( ImportAs => $author )
        : ( ParentAuthor => $author ),
        NewAuthorPassword => $password,
        DefaultCategoryID => $default_cat_id,
        ConvertBreaks     => $convert_breaks,
        (%options) ? (%options) : (),
    );

    $param->{import_success} = $import_result;
    $param->{error} = $importer->{type}->errstr unless $import_result;

    if ($import_result) {
        my $rebuild_url = $app->uri(
            mode => 'rebuild_confirm',
            args => { blog_id => $blog_id, }
        );
        $param->{rebuild_open}
            = qq!window.open('$rebuild_url', 'rebuild_blog_$blog_id', 'width=400,height=400,resizable=yes'); return false;!;
    }

    $app->print_encode(
        $app->build_page( "include/import_end.tmpl", $param ) );

    close $fh if $fh;
    1;
}

1;
