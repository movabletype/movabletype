package MT::CMS::Import;

use strict;

use MT::I18N qw( const );

sub start_import {
    my $app     = shift;
    my $blog_id = $app->param('blog_id');

    my $perms = $app->permissions;
    return $app->return_to_dashboard( permission => 1 )
      if $perms
      && ( !( $perms->can_edit_config || $perms->can_administer_blog ) );
    my %param;

    # FIXME: This should build a category hierarchy!
    my $cat_class = $app->model('category');
    my $iter = $cat_class->load_iter( { blog_id => $blog_id } );
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

    #$param{can_edit_authors} = $app->permissions->can_administer_blog;
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
        label                 => $mt->{label},
        key                   => $mt->{key},
        description           => $mt->{description},
        importer_options_html => $imp->get_options_html( $mt->{key}, $blog_id ),
      };

    $param{importer_loop} = $importer_loop;

    if ($blog_id) {
        $param{blog_id} = $blog_id;
        my $blog = $app->model('blog')->load($blog_id)
            or return $app->error($app->translate('Can\'t load blog #[_1].', $blog_id));
        $param{text_filters} = $app->load_text_filters( $blog->convert_paras );
    }

    $app->add_breadcrumb( $app->translate('Import/Export') );
    $app->load_tmpl( 'import.tmpl', \%param );
}

sub do_import {
    my $app = shift;

    my $q = $app->param;
    require MT::Blog;
    my $blog_id = $q->param('blog_id')
      or return $app->error( $app->translate("Please select a blog.") );
    my $blog = MT::Blog->load($blog_id)
      or return $app->error(
        $app->translate(
            "Load of blog '[_1]' failed: [_2]",
            $blog_id, MT::Blog->errstr
        )
      );

    if ( 'POST' ne $app->request_method ) {
        return $app->redirect(
            $app->uri(
                'mode' => 'start_import',
                args => { blog_id => $blog_id }
            )
        );
    }
    
    my $import_as_me = $q->param('import_as_me');

    ## Determine the user as whom we will import the entries.
    my $author    = $app->user;
    my $author_id = $author->id;
    if ( !$author->is_superuser ) {
        my $perms = $author->permissions($blog_id);
        return $app->error(
            $app->translate("You do not have import permissions") )
          unless $perms
          && ( $perms->can_edit_config || $perms->can_administer_blog );
        if ( !$import_as_me ) {
            return $app->error(
                $app->translate("You do not have permission to create users") )
              unless $perms->can_administer_blog;
        }
    }

    my ($pass);
    if ( !$import_as_me ) {
        $pass = $q->param('password')
          or return $app->error(
            $app->translate(
                    "You need to provide a password if you are going to "
                  . "create new users for each user listed in your blog."
            )
          ) if ( MT::Auth->password_exists );
    }

    $app->validate_magic() or return;

    my ($fh) = $app->upload_info('file');
    my $encoding = $q->param('encoding');
    my $stream = $fh ? $fh : $app->config('ImportPath');

    $app->{no_print_body} = 1;

    local $| = 1;
    $app->send_http_header('text/html');

    my $param;
    $param = { import_as_me => $import_as_me, import_upload => ($fh ? 1 : 0) };

    $app->print( $app->build_page( 'include/import_start.tmpl', $param ) );

    require MT::Entry;
    require MT::Placement;
    require MT::Category;
    require MT::Permission;
    require MT::Comment;
    require MT::TBPing;

    my $import_type = $q->param('import_type');
    require MT::Import;
    my $imp      = MT::Import->new;
    my $importer = $imp->importer($import_type);

    return $app->error(
        $app->translate( 'Importer type [_1] was not found.', $import_type ) )
      unless $importer;

    my %options = map { $_ => $q->param($_); } @{ $importer->{options} }
      if $importer->{options};
    my $import_result = $imp->import_contents(
        Key      => $import_type,
        Blog     => $blog,
        Stream   => $stream,
        Callback => sub { $app->print(@_) },
        Encoding => $encoding,
        ($import_as_me)
        ? ( ImportAs => $author )
        : ( ParentAuthor => $author ),
        NewAuthorPassword => ( $q->param('password')       || undef ),
        DefaultCategoryID => ( $q->param('default_cat_id') || undef ),
        ConvertBreaks     => ( $q->param('convert_breaks') || undef ),
        (%options) ? (%options) : (),
    );

    $param->{import_success} = $import_result;
    $param->{error} = $importer->{type}->errstr unless $import_result;

    $app->print( $app->build_page( "include/import_end.tmpl", $param ) );

    close $fh if $fh;
    1;
}

1;
