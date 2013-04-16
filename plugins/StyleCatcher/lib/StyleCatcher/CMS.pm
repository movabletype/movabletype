# Movable Type (r) Open Source (C) 2005-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package StyleCatcher::CMS;

use strict;
use File::Basename qw( basename );

use MT::Util qw( caturl );
use StyleCatcher::Util;
use StyleCatcher::Library;

our $DEFAULT_STYLE_LIBRARY;

sub style_library {
    return MT->registry("stylecatcher_libraries");
}

sub listify {
    my ($data) = @_;
    my @list;
    foreach my $k ( keys %$data ) {
        my $lib       = StyleCatcher::Library->new($k);
        my $listified = $lib->listify;
        push @list, $listified if defined $listified;
    }
    @list = sort { $a->{order} <=> $b->{order} } @list;
    \@list;
}

sub view {
    my $app     = shift;
    my $blog_id = $app->param('blog_id');
    return $app->return_to_dashboard( permission => 1 )
        unless $app->can_do('edit_templates');
    return $app->return_to_dashboard( redirect => 1 ) unless $blog_id;

    my $blog = MT::Blog->load($blog_id);
    return $app->errtrans("Invalid request") unless $blog;

    my $static_path    = $app->static_file_path;
    my $static_webpath = $app->static_path;
    my $support_path   = $app->support_directory_path;
    my $support_url    = $app->support_directory_url;
    if ( !-d $static_path ) {
        return $app->errtrans(
            "Your mt-static directory could not be found. Please configure 'StaticFilePath' to continue."
        );
    }

    my $themeroot    = File::Spec->catdir( $support_path, 'themes' );
    my $webthemeroot = $support_url . 'themes';
    my $stylelibrary = listify( style_library() );
    if ( my $blog = $app->blog ) {
        my $set = $blog->template_set;
        $set = MT->registry( template_sets => $set )
            if !ref $set;
        my $lib = listify( $set->{stylecatcher_libraries} );
        $stylelibrary = [ @$stylelibrary, @$lib ];
    }
    for my $lib (@$stylelibrary) {
        $lib->{url} =~ s/{{static}}/$static_webpath/i;
        $lib->{url} =~ s/{{support}}/$support_url/i;
        $lib->{url}
            =~ s/{{theme_static}}/MT::Theme::static_file_url_from_id($lib->{key})/ie;
        if ( $lib->{url} =~ m!^/! ) {
            $lib->{url} = $app->base . $lib->{url};
        }
    }
    my $theme_data   = make_themes();
    my $styled_blogs = fetch_blogs();

    my $config = plugin()->get_config_hash();

    my @blog_loop;
    my %current_themes;
    my ( $blog_theme, $blog_layout );
    foreach my $blog (@$styled_blogs) {
        my $curr_theme = $blog->current_style || '';
        next unless $curr_theme;
        my $curr_layout = $blog->page_layout || 'layout-wtt';
        push @blog_loop,
            {
            blog_id   => $blog->id,
            blog_name => $blog->name,
            layout    => $curr_layout,
            theme_id  => $curr_theme,
            view_link => $blog->site_url,
            };
        if ( $blog->id == $blog_id ) {
            $blog_theme  = $curr_theme;
            $blog_layout = $curr_layout;
        }
        if ( $theme_data->{themes} && $curr_theme ) {
            foreach my $theme ( @{ $theme_data->{themes} } ) {
                if ( ( $theme->{prefix} || '' ) . ':'
                    . $theme->{name} eq $curr_theme )
                {
                    push @{ $theme->{blogs} }, $blog->id;
                    next if exists $current_themes{ $theme->{name} };
                    $current_themes{ $theme->{name} } = 1;
                    push @{ $theme->{tags} }, 'collection:current';
                }
            }
        }
    }

    push @{ $theme_data->{categories} }, 'current'
        if %current_themes;

    require MT::Util;
    my $url   = $app->param('url');
    my %param = (
        version => plugin()->version,

        # blog_loop   => \@blog_loop,
        blog_id => $blog_id,
        themes_json =>
            MT::Util::to_json( $theme_data, { pretty => 1, indent => 2 } ),
        auto_fetch => $url ? $url : 0,
        style_library => $stylelibrary,
        current_theme  => $blog_theme  || '',
        current_layout => $blog_layout || 'layout-wtt',
        dynamic_blog =>
            ( ( $blog->custom_dynamic_templates || '' ) eq 'all' ),
        search_label => $app->translate('Templates'),
        object_type  => 'template',
    );

    if ( $blog_id && @$styled_blogs ) {
        my $blog = $styled_blogs->[0];
        $param{blog_name} = $blog->name;
        $param{blog_url}  = $blog->site_url;
    }

    my $path = $app->static_path;
    $path .= '/' unless $path =~ m!/$!;
    $path .= plugin()->envelope . "/";
    $param{plugin_static_uri} = $path;

    $app->build_page( 'view.tmpl', \%param );
}

# AJAX/JSON modes

# returns a json structure of styles given a particular url
sub js {

    # ydnar's remixer uses javascript files for each collection of styles -
    # we generate these js files from css metadata
    # StyleCatcher will pick up any metadata in the theme css file in the
    # format of 'key: value' in comment-space
    # The remixer only uses name, author, description at the moment.
    my $app = shift;
    return $app->json_error( $app->translate('Permission Denied.') )
        unless $app->can_do('edit_templates');
    return $app->json_error( $app->errstr ) unless $app->validate_magic;

    my $key = $app->param('key');
    if ( $key && $key ne 'null' ) {
        my $lib = StyleCatcher::Library->new($key)
            or return $app->error( plugin()->translate("Invalid request") );
        my $data = $lib->fetch_themes()
            or return $app->json_error( $lib->errstr );
        return $app->json_result($data);
    }
    else {
        my $lib  = StyleCatcher::Library->new();
        my $data = $lib->fetch_themes( $app->param('url') )
            or return $app->json_error( $lib->errstr );
        return $app->json_result($data);
    }
}

# does the work after user selects a particular theme to apply to a blog
sub apply {
    my $app = shift;
    return $app->return_to_dashboard( permission => 1 )
        unless $app->can_do('edit_templates');

    my ( $blog_id, $url, $layout, $name, $template_set )
        = map { $app->param($_) || q{} }
        (qw( blog_id url layout name template_set ));

    $app->validate_magic
        or return $app->json_error( $app->translate("Invalid request") );
    return $app->json_error( $app->translate("Invalid request") )
        unless $blog_id && $url;

    my ( $repo_id, $theme_id ) = $name =~ /^(?:repo-)?([^:]+).*:([^:]+)$/;
    my $library = StyleCatcher::Library->new($repo_id)
        or die "Invalide repository: " . $repo_id;

    my $static_path = $app->static_file_path;
    if ( !-d $static_path ) {
        return $app->json_error(
            $app->translate(
                "Your mt-static directory could not be found. Please configure 'StaticFilePath' to continue."
            )
        );
    }

    $url = $library->download_theme($url)
        or return $app->json_error( $library->errstr );

    my $blog = MT->model('blog')->load($blog_id)
        or return $app->json_error(
        $app->translate( 'No such blog [_1]', $blog_id ) );

    my $base_css_url;
    my $use_theme = 1;
    my $blog_tset = $blog->template_set;
    if ( !ref $blog_tset ) {
        $blog_tset = MT->registry('template_sets')->{$blog_tset};
        $use_theme = 0;
    }
    if ( $blog_tset->{base_css} ) {
        if ($use_theme) {
            my $theme = $blog->theme;
            my ( $id, $base ) = ( $theme->id, $blog_tset->{base_css} );
            $base_css_url = "theme_static/$id/$base";
        }
        else {
            $base_css_url = $blog_tset->{base_css};
        }
    }
    elsif ( defined $blog_tset->{base_css} ) {

        # base_css is '0', so don't print base_css line.
        $base_css_url = '';
    }
    else {

        # base_css is undefined, so use default blog.css.
        $use_theme    = 0;
        $base_css_url = 'themes-base/blog.css';
    }

    my $base_css = q{};
    if ($base_css_url) {
        require URI;
        my $uri = URI->new_abs( $base_css_url,
            $use_theme ? $app->support_directory_url : $app->static_path );
        $base_css = '@import url(' . $uri->as_string() . ');'
            if $uri;
    }

    # Load the default stylesheet for this blog
    my $tmpl = load_style_template($blog_id);

    unless ($tmpl) {

        # Create one since this blog does not have it
        $tmpl = new MT::Template;
        $tmpl->blog_id($blog_id);
        $tmpl->name( plugin()->translate('Stylesheet') );
        $tmpl->type('index');
        $tmpl->identifier('styles');
        $tmpl->outfile("styles.css");
        $tmpl->text(<<'EOT');
@import url(<$MTStaticWebPath$>themes-base/blog.css);
@import url(<$MTStaticWebPath$>themes/minimalist-red/styles.css);
EOT
    }

    # Replacing the theme import or adding a new one at the beginning
    my $template_text = $tmpl->text();
    my $header
        = '/* This is the StyleCatcher theme addition. Do not remove this block. */';
    my $footer = '/* end StyleCatcher imports */';
    my $styles = <<"EOT";
$header
$base_css
\@import url($url);
$footer
EOT
    if ( $template_text =~ s/\Q$header\E.*\Q$footer\E/$styles/s ) {
        $tmpl->text($template_text);
    }
    else {

        # we're dealing with a template that wasn't modified before now
        # we will need to backup the existing one to make sure the new
        # style is applied properly.
        my @ts = MT::Util::offset_time_list( time, $blog_id );
        my $ts = sprintf "%04d-%02d-%02d %02d:%02d:%02d", $ts[5] + 1900,
            $ts[4] + 1, @ts[ 3, 2, 1, 0 ];
        my $backup = $tmpl->clone;
        delete $backup->{column_values}
            {id};    # make sure we don't overwrite original
        delete $backup->{changed_cols}{id};
        $backup->name( $backup->name . ' (Backup from ' . $ts . ')' );
        $backup->outfile('');
        $backup->linked_file( $tmpl->linked_file );
        $backup->rebuild_me(0);
        $backup->build_dynamic(0);
        $backup->identifier(undef);
        $backup->type('backup');
        $backup->save;
        $tmpl->linked_file('');    # make sure this one isn't linked now
        $tmpl->identifier('styles');
        $tmpl->text($styles);
    }

    # Putting the stylesheet back together again
    $tmpl->save or return $app->json_error( $tmpl->errstr );

    # Custom theme and layout
    my $p = plugin();
    $name =~ s/^repo_\d+:/local:/;
    $name =~ s/^repo-\w+:/local:/;
    $name =~ s/\.css$//;
    $blog->current_style($name);
    $blog->page_layout($layout);
    $blog->touch();
    $blog->save();

    # rebuild only the stylesheet! forcibly. with prejudice.
    $app->rebuild_indexes(
        BlogID   => $tmpl->blog_id,
        Template => $tmpl,
        Force    => 1
    );

    return $app->json_result(
        {   message =>
                $app->translate("Successfully applied new theme selection.")
        }
    );
}

# Utility methods

sub fetch_blogs {
    my $app     = MT->app;
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');

    my @blogs;
    if ($blog_id) {
        @blogs = MT::Blog->load($blog_id);
    }
    else {
        if ( $user->is_superuser() ) {
            if ($blog_id) {
                @blogs = MT::Blog->load($blog_id);
            }
        }
        else {
            my $args = { author_id => $user->id };
            $args->{blog_id} = $blog_id if $blog_id;
            require MT::Permission;
            my @perms = MT::Permission->load( { author_id => $user->id } );
            foreach my $perm (@perms) {
                next unless $perm->can_edit_templates;
                push @blogs, MT::Blog->load( $perm->blog_id );
            }
        }
    }
    my @styled_blogs;
    foreach my $blog (@blogs) {
        my $tmpl = load_style_template( $blog->id );
        if ($tmpl) {
            push @styled_blogs, $blog;
        }
    }
    @styled_blogs = sort { $a->name cmp $b->name } @styled_blogs;

    \@styled_blogs;
}

sub load_style_template {
    my ($blog_id) = @_;

    require MT::Template;
    my $tmpl;

    $tmpl = MT::Template->load(
        {   blog_id    => $blog_id,
            identifier => 'styles'
        }
    );

    $tmpl ||= MT::Template->load(
        {   blog_id => $blog_id,
            outfile => "styles.css"
        }
    );

    # MT 3.x era stylesheet file
    $tmpl ||= MT::Template->load(
        {   blog_id => $blog_id,
            outfile => "styles-site.css"
        }
    );

    $tmpl;
}

# sets up the object structure we return through json to populate
# the mixer.
sub make_themes {
    my $app = MT->instance;

    # categories
    #   current    (for active theme)
    #   repo       (for themes found at repo link)
    #   my-designs (for themes that are stored locally)
    #   mt-designs (for themes that are local and installed by default)
    #   auto       (for link to a single css file)

    # structure of "data"
    #   categories => [ one, two, three ]  ie: 'current', 'repo'
    #   themes => [
    #       { theme }
    #   ]
    #   repo => {
    #       display_name => 'display name',
    #       name => 'repo name',
    #       url => 'url of repo',
    #   }

# structure of "theme"
#   theme => {
#       name => 'theme_dir',
#       imageSmall => 'link_to/thumbnail.gif',
#       imageBig => 'link_to/thumbnail-large.gif',
#       title => 'Theme Title',
#       description => 'Theme description.',
#       url_css => 'link_to/theme.css',
#       url_zip => 'link_to/theme.zip',
#       author => 'Author Name',
#       author_url => 'http://author.com/'
#       author_affiliation => 'Author Co.',
#       layouts => "comma,delimited,layout,list"
#       sort => 'theme_sortable_name',
#       tags => ['association:tag']  ie, 'color:blue', 'designer:author', 'collection:repo'
#   }

    my ( $categories, $themes );
    my $sys_root = File::Spec->catdir( $app->static_file_path, 'themes' );

    # Generate our list of themes within the themeroot directory
    my @sys_list = glob( File::Spec->catfile( $sys_root, "*" ) );
    $categories->{'mt-designs'} = 1 if @sys_list;
    for my $theme (@sys_list) {
        my $theme_dir = $theme;
        my $theme_url = $app->static_path . 'themes';
        next unless -d $theme;
        $theme =~ s/.*[\\\/]//;
        $themes->{$theme} = metadata_for_theme(
            path => $theme_dir,
            url  => "$theme_url/$theme/",
            tags => ['collection:mt-designs'],
        );
        $themes->{$theme}{prefix} = 'default';
    }

    my $themeroot
        = File::Spec->catfile( $app->support_directory_path(), 'themes' );

    # Generate our list of themes within the themeroot directory
    my @themeroot_list = glob( File::Spec->catfile( $themeroot, "*" ) );
    $categories->{'my-designs'} = 1 if @themeroot_list;
    for my $theme (@themeroot_list) {
        my $theme_dir = $theme;
        next unless -d $theme;
        $theme =~ s/.*[\\\/]//;
        $themes->{$theme} = metadata_for_theme(
            path => $theme_dir,
            url =>
                caturl( $app->support_directory_url(), 'themes', "$theme/" ),
            tags => ['collection:my-designs'],
        );
        $themes->{$theme}{prefix} = 'local';
    }

    my $data = {
        categories => [ keys %$categories ],
        themes     => [ values %$themes ]
    };

    $data;
}

sub plugin {
    return MT->component('StyleCatcher');
}

1;
