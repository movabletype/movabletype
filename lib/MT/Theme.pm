# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::Theme;
use strict;
use MT;
use base qw( MT::Component );

sub new {
    my $pkg = shift;
    my ($obj) = ref $_[0] ? @_ : {@_};
    return bless $obj, $pkg;
}

{
my %THEME_CACHE;

sub load {
    my $pkg = shift;
    my ($id) = @_;
    MT->run_callbacks('pre_load_theme',$id);

    ## try cache.
    my $theme = $THEME_CACHE{$id};
    return $theme if defined $theme;

    ## look for registry.
    my $registry = MT->registry('themes');
    $theme = $pkg->_load_from_registry($id, $registry->{$id});
    if ( defined $theme ) {
        return $theme->_register;
    }

    ## if not exists in registry, going to look for theme directory.
    $theme = $pkg->_load_from_themes_directory($id);
    return $theme->_register
        if defined $theme;

    ## at last, search for template set.
    $theme = $pkg->_load_pseudo_theme_from_template_set($id);
    return $theme->_register
        if defined $theme;

    return $pkg->error(MT->translate('Failed to load theme [_1].', $id));
}

sub _register {
    my $theme = shift;
    my $id = $theme->{id};
    if ( !$MT::Components{$id} ) {
        $MT::Components{$id} = $theme;
        push @MT::Components, $theme;
        $THEME_CACHE{$theme->{id}} = $theme;
        MT->run_callbacks('post_load_theme', $theme);
        return $theme;
    }
    return;
}
}

{
my $THEMES_INSTALLED;
sub load_all_themes {
    my $pkg = shift;
    my (%opts) = @_;
    if ($opts{force_reload}) {
        $THEMES_INSTALLED = undef;
    }
    return $THEMES_INSTALLED if defined $THEMES_INSTALLED;
    $THEMES_INSTALLED = {};

    ## load themes from registry.
    my $themes_reg = MT->registry('themes');

    ## load theme packages from themes directory.
    my @packages = $pkg->_theme_packages();

    ## load template sets from registry.
    ## 'mt_blog' is there for backward compatibility, but we won't
    ## load him because it's same to classic_blog theme. skip it.
    my @sets = map { "theme_$_" } grep { $_ ne 'mt_blog' } keys %{ MT->registry('template_sets') };

    my %ids = map { $_ => 1 } ( keys %$themes_reg, @packages, @sets );
    for my $id ( keys %ids ) {
        $THEMES_INSTALLED->{$id} = $pkg->load($id);
    }
    return $THEMES_INSTALLED;
}
}

sub _theme_packages {
    my $pkg = shift;
    my $base_dir = MT->config('ThemesDirectory');
    require DirHandle;
    my $d = DirHandle->new( $base_dir );
    die "Can't open theme directory" unless $d;
    my @ids;
    while ( defined( my $id = $d->read ) ) {
        next if $id =~ /^\./;
        die "Bad theme filename $id"
            if $id !~ /^([-\\\/\@\:\w\.\s~]+)$/;
        push @ids, $id;
    }
    return @ids;
}

sub _load_from_registry {
    my $pkg = shift;
    my ($id, $reg) = @_;
    $reg ||= MT->registry('themes', $id);
    return if !defined $reg;
    my $props = {
        id             => "$id",
        type           => 'registry',
        label          => $reg->{label},
        thumbnail_file        => $reg->{thumbnail_file},
        thumbnail_file_medium => $reg->{thumbnail_file_medium},
        thumbnail_file_small  => $reg->{thumbnail_file_small},
        author_name    => $reg->{author_name},
        author_link    => $reg->{author_link},
        version        => $reg->{version},
        class          => $reg->{class},
        elements       => $reg->{elements},
        base_css       => $reg->{base_css},
        required_components => $reg->{required_components},
        optional_components => $reg->{optional_components},
        menu_modification   => $reg->{menus_modification},
    };
    my $theme = $pkg->new( $props );
    $theme->registry({
        id           => "$id",
        label        => $reg->{label},
        description  => $reg->{description},
        l10n_class   => $reg->{l10n_class},
        l10n_lexicon => $reg->{l10n_lexicon},
        label        => $reg->{label},
    });
    $theme->name($reg->{label});
    $theme->path($reg->{plugin}->path) if $reg->{plugin};
    return $theme;
}

sub _load_from_themes_directory {
    my $pkg = shift;
    my ($theme_id) = @_;
    my $base_dir = MT->config('ThemesDirectory');

    require File::Spec;
    my $dir = File::Spec->catdir( $base_dir, $theme_id );
    my $path = File::Spec->catfile( $dir, 'theme.yaml' );

    return unless -f $path;
    require MT::Util::YAML;
    my $y = eval { MT::Util::YAML::LoadFile($path) }
        or die "Error reading $path: " . (MT::Util::YAML->errstr||$@||$!);

    ## TBD: search all code or excutable values and destroy them here.
    # die "Invalid theme package"
    #     unless _validate_theme_registry($y);

    my $props = {
        id             => $theme_id,
        type           => 'package',
        thumbnail_file        => $y->{thumbnail_file},
        thumbnail_file_medium => $y->{thumbnail_file_medium},
        thumbnail_file_small  => $y->{thumbnail_file_small},
        author_name    => $y->{author_name},
        author_link    => $y->{author_link},
        version        => $y->{version},
        class          => $y->{class},
        elements       => $y->{elements},
        base_css       => $y->{base_css},
        protected      => $y->{protected},
        required_components => $y->{required_components},
        optional_components => $y->{optional_components},
        menus_modification  => $y->{menus_modification},
    };

    my $class = $pkg->new( $props );
    $class->path($dir);
    my %trans;
    if ( $y->{l10n_class} || $y->{l10n_lexicon} ) {
        %trans = (
            l10n_class   => $y->{l10n_class},
            l10n_lexicon => $y->{l10n_lexicon},
            label        => sub { $class->translate( $y->{label} ) },
        );
    }
    $class->registry({
        id          => $theme_id,
        label          => $y->{label},
        name           => $y->{name},
        description  => $y->{description},
        %trans,
    });
    return $class;
}

sub _load_pseudo_theme_from_template_set {
    my $pkg = shift;
    my ($id) = @_;
    $id =~ s/^theme_//;
    my $sets = MT->registry("template_sets")
        or return;
    my $set = $sets->{$id}
        or return;
    my $plugin = $set->{plugin} || undef;
    my $label = $set->{label}
                   || ( $plugin && $plugin->registry('name') )
                   || $id;
    my $props = {
        id          => "theme_$id",
        type        => 'template_set',
        author_name => $plugin ? $plugin->registry('author_name') : '',
        author_link => $plugin ? $plugin->registry('author_link') : '',
        version     => $plugin ? $plugin->registry('version') : '',
        __plugin    => $plugin,
        class       => 'blog',
        path        => $plugin ? $plugin->path : '',
        base_css    => $set->{base_css},
        elements => {
            template_set => {
                component => 'core',
                importer  => 'template_set',
                name      => 'template set',
                data      => $id,
            },
        },
    };
    my $reg = {
        id          => "theme_$id",
        version     => $plugin ? $plugin->registry('version')     : '',
        l10n_class  => $plugin ? $plugin->registry('l10n_class') : 'MT::L10N',
        label       => sub { MT->translate( '[_1]', $label ) },
        description => $set->{description},
        class       => 'blog',
    };
    my $class = $pkg->new( $props );
    $class->registry( $reg );
    return $class;
}

sub elements {
    my $theme = shift;

    ## reload elements from registry,
    ## for translate labels, invoke methods, etc...
    my $elements = $theme->{elements};
    delete $elements->{plugin} if exists $elements->{plugin};

    require MT::Theme::Element;
    map {
        MT::Theme::Element->new(
        theme => $theme,
        id    => $_,
        %{ $elements->{$_ } },
    )} keys %{ $elements };
}

sub apply {
    my $theme = shift;
    my ( $blog, %opts ) = @_;
    if ( !ref $blog ) {
        $blog = MT->model('blog')->load({ id => $blog, class => '*' });
    }
    die('Internal error: blog not found')
        if !defined $blog;
    MT->run_callbacks('pre_apply_theme', $theme, $blog);
    my $importer_filter = $opts{importer_filter};

    ## run all element handlers.
    my @elements = $theme->elements;
    for my $element ( @elements ) {
        next if $element->{class} && ( $element->{class} ne $blog->class_type );
        next if $importer_filter && !$importer_filter->{ $element->{importer} };
        my $result = $element->apply( $blog, $opts{ $element->{importer} } );
        if ( !$result ) {
            if ( $element->{require} ) {
                return $theme->error(
                    MT->translate(
                        'A fatal error occurred while applying element [_1]: [_2].',
                        $element->{label},
                        $element->errstr,
                ));
            }
            else {
                MT->log(
                    MT->translate(
                        'An error occurred while applying element [_1]: [_2].',
                        $element->{label},
                        $element->errstr,
                ));
            }
        }
    }

    ## also do copy static files to mt-static directory.
    my $src_dir   = $theme->{static_path} || 'static';
    my $src_path  = File::Spec->catdir($theme->path, $src_dir);
    my $dest_path = File::Spec->catdir(MT->app->support_directory_path, 'themes', $theme->id );

    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');
    if ( !$fmgr->exists($dest_path) && $fmgr->exists($src_path) ) {
        __PACKAGE__->install_static_files( $src_path, $dest_path );
    }
    MT->run_callbacks('post_apply_theme', $theme, $blog);
    return $blog;
}

sub install_static_files {
    my $pkg = shift;
    my ($src, $dst, %opts) = @_;
    my $default_allowed_extentions = [qw(
        html    css    js
        png     jpeg   jpg   gif
    )];
    my $allowed = 'ARRAY' eq ref $opts{allow} ? $opts{allow} : $default_allowed_extentions;
    my %allowed = map { ( lc $_ ) => 1 } @$allowed;
    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');
    require File::Find;
    my $sub = sub {
        my $name = $File::Find::name;
        return if -d $name;
        my $dir = $File::Find::dir;
        my $filename = $_;
        my ($suffix) = $name =~ m/^.*\.(\w+)$/;
        if ( $allowed{ lc $suffix } ) {
            my $rel = File::Spec->abs2rel( $dir, $src );
            my $to  = File::Spec->catdir( $dst, $rel );
            $fmgr->mkpath( $to );
            my $to_file = File::Spec->catfile( $to, $filename );
            $fmgr->put( $name, $to_file, 'upload')
                or MT->log("Failed to copy file $name:" . $fmgr->errstr);
        }
    };
    File::Find::find( $sub, $src );
}

sub validate_versions {
    my $theme = shift;
    my @elements = $theme->elements;
    my ( @errors, @warnings );
    my $requires = $theme->{required_components};
    for my $component ( keys %$requires ) {
        my $version = $requires->{$component};
        my $c = MT->component($component);
        if ( !$c ) {
            push @errors, sub {
                MT->translate("Component \'[_1]\' version [_2] or greater is needed to use this theme, but is not installed.", $component, $version );
            };
        }
        elsif ( $c->version < $version ) {
            push @errors, sub {
                MT->translate("Component \'[_1]\' version [_2] or greater is needed to use this theme, but the installed version is [_3].", $component, $version, $c->version );
            };
        }
    }
    my $optionals = $theme->{optional_components};
    for my $component ( keys %$optionals ) {
        my $version = $optionals->{$component};
        my $c = MT->component($component);
        if ( !$c ) {
            push @warnings, sub {
                MT->translate("Component \'[_1]\' version [_2] or greater is needed to use this theme, but is not installed.", $component, $version );
            };
        }
        elsif ( $c->version < $version ) {
            push @warnings, sub {
                MT->translate("Component \'[_1]\' version [_2] or greater is needed to use this theme, but the installed version is [_3].", $component, $version, $c->version );
            };
        }
    }
    for my $element ( @elements ) {
        my $result = $element->validate_version;
        if ( !$result ) {
            my $msg = MT->translate(
                'Element \'[_1]\' cannot be applied because [_2]',
                $element->{id},
                $element->errstr,
            );
            $element->{require} ? push @errors, $msg : push @warnings, $msg;
        }
    }
    return ( \@errors, \@warnings );
}

sub alt_tmpl_path {
    my $theme = shift;
    return File::Spec->catdir( $theme->path, 'alt-tmpl' );
}

sub _thumbnail_dir {'theme_thumbnails'}

sub thumbnail {
    my $theme = shift;
    my (%param) = @_;
    if ( !$theme->_mk_thumbnail(%param) ) {
        return ( $theme->default_theme_thumbnail(%param) );
    }
    my $file = $theme->_thumbnail_filename(%param);
    my $url = join '/', MT->support_directory_url, _thumbnail_dir(), $theme->{id}, $file;
    return ( $url, $theme->_thumbnail_size(%param) );
}

sub _thumbnail_size {
    my $theme = shift;
    my (%param) = @_;
    my $size = $param{size};
    my %list = (
        # size  | width | height
        large  => [ 400, 300 ],
        medium => [ 240, 180 ],
        small  => [ 120, 90  ],
    );
    my $wh = $list{$size};
    return $wh ? @$wh : ();
}

sub default_theme_thumbnail {
    my $theme = shift;
    my (%param) = @_;
    my $size = $param{size};
    my %list = (
        large  => 'images/default_theme_thumbnail.png',
        medium => 'images/default_theme_thumbnail_medium.png',
        small  => 'images/default_theme_thumbnail_small.png',
    );
    return ( MT->app->static_path . $list{$size},
             $theme->_thumbnail_size(%param) );
}

sub _thumbnail_filename {
    my $theme = shift;
    my ( %param ) = @_;
    my $filename = $theme->{thumbnail_file}
        or return;
    my $size = $param{size};
    my ($w, $h) = $theme->_thumbnail_size( %param );
    return unless $w;
    $filename =~ s{.*/}{};
    my ( $file, $ext ) = $filename =~ m{^(.*)\.(.*)$};
    my $target_file = sprintf "%s-%s.%s", $file, $size, $ext;
}

sub _mk_thumbnail {
    my $theme     = shift;
    my (%param)   = @_;
    my $size_key = {
        large  => 'thumbnail_file',
        medium => 'thumbnail_file_medium',
        small  => 'thumbnail_file_small',
    };
    my $size = $param{size} || 'large';
    my $resize;
    my $original_file;
    if ( exists $theme->{ $size_key->{$size} } ) {
        $original_file = $theme->{ $size_key->{$size} };
    }
    else {
        $original_file = $theme->{thumbnail_file};
        $resize = 1 if $size ne 'large';
    }

    my $original_file_path = File::Spec->catfile( $theme->path, $original_file );
    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local')
        or return;
    return unless $fmgr->exists($original_file_path);
    my ($n_w, $n_h) = $theme->_thumbnail_size(%param)
        or return;
    my $target_file = $theme->_thumbnail_filename(%param)
        or return;

    my $thumbnail_dir = File::Spec->catdir(
        MT->app->support_directory_path,
        _thumbnail_dir(),
        $theme->id );
    my $thumbnail_file_path = File::Spec->catfile(
        $thumbnail_dir,
        $target_file );

    $fmgr->exists($thumbnail_file_path)
        and return $thumbnail_file_path;
    # non-existent thumbnail. let's create one!
    $fmgr->exists($thumbnail_dir)
        or $fmgr->mkpath($thumbnail_dir);
    return
        unless $fmgr->can_write($thumbnail_dir);

    my $data;
    if ( $resize ) {
        # create a thumbnail for this file
        require MT::Image;
        my $img = new MT::Image( Filename => $original_file_path )
          or return $theme->error( MT::Image->errstr );
        ($data) = $img->scale( Height => $n_h, Width => $n_w )
          or return $theme->error(
            MT->translate( "There was an error scaling image [_1].", $img->errstr ) );
        if (my $type = $param{Type}) {
            ($data) = $img->convert( Type => $type )
              or return $theme->error(
                MT->translate( "There was an error converting image [_1].", $img->errstr ) );
        }
    }
    else {
        $data = $fmgr->get_data($original_file_path, 'upload');
    }
    $fmgr->put_data( $data, $thumbnail_file_path, 'upload' )
      or return $theme->error(
        MT->translate( "There was an error creating thumbnail file [_1].", $fmgr->errstr ) );
    return $thumbnail_file_path;
}

sub information_strings {
    my $theme = shift;
    my ($blog) = @_;
    my @elements = $theme->elements;
    my @messages;
    for my $element ( @elements ) {
        push @messages, $element->information_string( $blog );
    }
    return @messages;
}

sub core_theme_element_handlers {
    return {
        default_prefs => {
            label => 'Default Prefs',
            importer => {
                import => '$Core::MT::Theme::Pref::import',
                info   => '$Core::MT::Theme::Pref::info',
            },
        },
        default_categories => {
            label => 'Default Categories',
            importer => {
                import => '$Core::MT::Theme::Category::import_categories',
                info   => '$Core::MT::Theme::Category::info_categories',
            },
            exporter => {
                params    => 'default_category_export_ids',
                template  => '$Core::MT::Theme::Category::category_export_template',
                export    => '$Core::MT::Theme::Category::export_category',
                condition => '$Core::MT::Theme::Category::category_condition',
            },
        },
        default_folders => {
            label => 'Default Folders',
            importer => {
                import => '$Core::MT::Theme::Category::import_folders',
                info   => '$Core::MT::Theme::Category::info_folders',
            },
            exporter => {
                params    => 'default_folder_export_ids',
                template  => '$Core::MT::Theme::Category::folder_export_template',
                export    => '$Core::MT::Theme::Category::export_folder',
                condition => '$Core::MT::Theme::Category::folder_condition',
            },
        },
        template_set => {
            label => 'Template Set',
            importer => {
                import => '$Core::MT::Theme::TemplateSet::import',
                info   => '$Core::MT::Theme::TemplateSet::info',
            },
            exporter => {
                params    => 'template_set_export_ids',
                template  => '$Core::MT::Theme::TemplateSet::export_template',
                export    => '$Core::MT::Theme::TemplateSet::export',
                finalize  => '$Core::MT::Theme::TemplateSet::finalize',
                condition => '$Core::MT::Theme::TemplateSet::condition',
            },
        },
        blog_static_files => {
            label => 'Static Files',
            importer => {
                import => '$Core::MT::Theme::StaticFiles::import',
              # info   => '$Core::MT::Theme::StaticFiles::info',
            },
            exporter => {
                params   => 'static_directories',
                template => '$Core::MT::Theme::StaticFiles::export_template',
                export   => '$Core::MT::Theme::StaticFiles::export',
                finalize => '$Core::MT::Theme::StaticFiles::finalize',
            },
        },
        default_pages => {
            label => 'Default Pages',
            importer => {
                import => '$Core::MT::Theme::Entry::import_pages',
                info   => '$Core::MT::Theme::Entry::info_pages',
            },
        },
    };
}

1;
