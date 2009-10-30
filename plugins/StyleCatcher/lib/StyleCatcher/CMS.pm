# Movable Type (r) Open Source (C) 2005-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package StyleCatcher::CMS;

use strict;
use File::Basename qw( basename dirname );

use MT::Util qw( remove_html decode_html );

our $DEFAULT_STYLE_LIBRARY;

sub style_library {
    return MT->registry("stylecatcher_libraries");
}

sub file_mgr {
    my $app = MT->instance;
    require MT::FileMgr;
    my $filemgr = MT::FileMgr->new('Local')
      or return $app->error( MT::FileMgr->errstr );
    $filemgr;
}

sub listify {
    my ($data) = @_;
    my @list;
    foreach my $k (keys %$data) {
        my %entry = %{ $data->{$k} };
        $entry{key} = $k;
        delete $entry{plugin};
        if ( ref( $entry{label} ) ) {
            $entry{label} = $entry{label}->();
        }
        else {
            $entry{label} = MT->translate( $entry{label} );
        }
        if ( ref( $entry{description_label} ) ) {
            $entry{description_label} = $entry{description_label}->();
        }
        else {
            $entry{description_label}
                = MT->translate( $entry{description_label} );
        }
        push @list, \%entry;
    }
    @list = sort { $a->{order} <=> $b->{order} } @list;
    \@list;
}

sub view {
    my $app     = shift;
    my $blog_id = $app->param('blog_id');
    $app->return_to_dashboard( redirect => 1 ) unless $blog_id;

    my $blog = MT::Blog->load($blog_id);
    return $app->errtrans("Invalid request") unless $blog;

    my $static_path = $app->static_file_path;
    my $static_webpath = $app->static_path;
    my $support_path = $app->support_directory_path;
    my $support_url = $app->support_directory_url;
    if (! -d $static_path ) {
        return $app->errtrans("Your mt-static directory could not be found. Please configure 'StaticFilePath' to continue.");
    }

    my $themeroot =
      File::Spec->catdir( $support_path, 'themes' );
    my $webthemeroot = $support_url . 'themes';
    my $stylelibrary = listify(style_library());
    if ( my $blog = $app->blog ) {
        my $set = $blog->template_set;
        $set = MT->registry(template_sets => $set)
            if !ref $set;
        my $lib = listify($set->{stylecatcher_libraries});
        $stylelibrary = [ @$stylelibrary, @$lib ];
    }
    for my $lib ( @$stylelibrary ) {
        $lib->{url} =~ s/{{static}}/$static_webpath/i;
        $lib->{url} =~ s/{{support}}/$support_url/i;
        if ( $lib->{url} =~ m!^/! ) {
            $lib->{url} = $app->base . $lib->{url};
        }
    }
    my $theme_data   = make_themes();
    my $styled_blogs = fetch_blogs();

    my $config = plugin()->get_config_hash();

    my @blog_loop;
    my %current_themes;
    my ($blog_theme, $blog_layout);
    foreach my $blog (@$styled_blogs) {
        my $curr_theme = $config->{"current_theme_" . $blog->id} || '';
        next unless $curr_theme;
        my $curr_layout = $config->{"current_layout_" . $blog->id} || 'layout-wtt';
        push @blog_loop,
          {
            blog_id   => $blog->id,
            blog_name => $blog->name,
            layout    => $curr_layout,
            theme_id  => $curr_theme,
            view_link => $blog->site_url,
          };
        if ($blog->id == $blog_id) {
            $blog_theme = $curr_theme;
            $blog_layout = $curr_layout;
        }
        if ( $theme_data->{themes} && $curr_theme ) {
            foreach my $theme ( @{ $theme_data->{themes} } ) {
                if ( ($theme->{prefix} || '') . ':' . $theme->{name} eq $curr_theme ) {
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
        version     => plugin()->version,
        # blog_loop   => \@blog_loop,
        blog_id => $blog_id,
        themes_json => MT::Util::to_json(
            $theme_data, { pretty => 1, indent => 2 }
        ),
        auto_fetch => $url ? 1 : 0,
        style_library => $stylelibrary,
        current_theme => $blog_theme || '',
        current_layout => $blog_layout || 'layout-wtt',
        dynamic_blog => (($blog->custom_dynamic_templates || '') eq 'all'),
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
    $path = $app->base . $path if $path =~ m!^/!;
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
    return $app->json_error( $app->errstr ) unless $app->validate_magic;

    my $data = fetch_themes($app->param('url'))
        or return $app->json_error( $app->errstr );
    return $app->json_result( $data );
}

sub files_from_response {
    my ($res, %param) = @_;

    my $extensions = $param{css} ? qr{ (?:gif|jpe?g|png|css) }xms
                   :               qr{ (?:gif|jpe?g|png)     }xms
                   ;

    my $stylesheet = $res->content;
    $stylesheet =~ s!/\*.*?\*/!!gs;    # strip all comments first
    my @images = $stylesheet =~ m{
        \b url\( \s*                          # opening url() reference
        ['"]?
        ( [\w\.\-/]+\.$extensions )  # a filename ending in an image extension
        ['"]?
        \s* \)                                # close of url() reference
    }xmsgi;

    return @images;
}

sub download_theme {
    my $app = shift;
    my ($url) = @_;

    my $static_path = $app->static_file_path;
    my $themeroot   = File::Spec->catdir($static_path, 'support', 'themes');
    my $ua          = $app->new_ua( {max_size => 500_000 } );
    my $filemgr     = file_mgr()
        or return;

    my @url = split( /\//, $url );
    my $stylesheet_filename = pop @url;
    my $theme_url = join(q{/}, @url) . '/';

    my ($basename, $extension) = split /\./, $stylesheet_filename;
    if ($basename eq 'screen' || $basename eq 'style') {
        $basename = $url[-1];
    }

    # Pick up the stylesheet
    my $stylesheet_res = $ua->get($url);

    my @images = files_from_response($stylesheet_res, css => 1);

    my $theme_path = File::Spec->catdir($themeroot, $basename);
    if (!$filemgr->mkpath($theme_path)) {
        my $error = $app->translate("Could not create [_1] folder - Check that your 'themes' folder is webserver-writable.",
            $basename);
        return $app->json_error($error);
    }

    $filemgr->put_data( $stylesheet_res->content,
        File::Spec->catfile($theme_path, $basename . '.css') );

    # Pick up the images we parsed earlier and write them to the theme folder
    my %got_files;
    my @files = ('thumbnail.gif', 'thumbnail-large.gif', @images);
    FILE: while (my $rel_url = shift @files) {
        # Is this safe to get?
        require URI;
        my $full_url = URI->new_abs($rel_url, $theme_url);
        next FILE if !$full_url;
        my $url = $full_url->as_string();
        next FILE if $url !~ m{ \A \Q$theme_url\E }xms;

        next FILE if $got_files{$url};
        $got_files{$url} = 1;
        my $res = $ua->get($url);

        # Skip files that don't download; we were accidentally doing so already.
        next FILE if !$res->is_success();

        my $canon_rel_url = URI->new($rel_url)->rel($theme_url);
        my @image_path = split /\//, $canon_rel_url->as_string();
        my $image_filename = pop @image_path;

        my $image_path = File::Spec->catdir($theme_path, @image_path);
        if (!$filemgr->exists($image_path) && !$filemgr->mkpath($image_path)) {
            my $error = $app->translate("Could not create [_1] folder - Check that your 'themes' folder is webserver-writable.",
                $basename);
            return $app->json_error($error);
        }

        my $image_full_path = File::Spec->catfile($image_path, $image_filename);
        $filemgr->put_data($res->content, $image_full_path, 'upload')
          or return $app->json_error( $filemgr->errstr );

        if ($image_filename =~ m{ \.css \z }xmsi) {
            my @new_files = files_from_response($res, css => 0);
            # Schedule these as full URLs so relative references aren't
            # misabsolved relative to the theme directory.
            @new_files = map {
                my $uri = URI->new_abs($_, $url);
                $uri ? $uri->as_string() : ();
            } @new_files;
            push @files, @new_files;
        }
    }

    return $basename;
}

# does the work after user selects a particular theme to apply to a blog
sub apply {
    my $app = shift;

    my ($blog_id, $url, $layout, $name, $template_set)
        = map { $app->param($_) || q{} } (qw( blog_id url layout name template_set ));

    # Load the default stylesheet for this blog
    my $tmpl = load_style_template($blog_id);

    $app->validate_magic or return $app->json_error($app->translate("Invalid request"));
    return $app->json_error($app->translate("Invalid request"))
      unless $blog_id && $url && $tmpl;

    my $static_path = $app->static_file_path;
    if (! -d $static_path ) {
        return $app->json_error($app->translate("Your mt-static directory could not be found. Please configure 'StaticFilePath' to continue."));
    }

    # if this isn't a local url, then we have to grab some files from
    # yonder...
    my $static_url = $app->static_path;
    if ( $url !~ m{ \A \Q$static_url\E (?:support/)? themes/ }xms ) {
        my $basename = download_theme($app, $url)
            or return;
        $url = "${static_url}support/themes/$basename/$basename.css";
    }

    my $blog = MT->model('blog')->load($blog_id)
      or return $app->json_error( $app->translate('No such blog [_1]', $blog_id) );

    my $base_css_url;
    my $use_theme = 1;
    my $blog_tset = $blog->template_set;
    if ( !ref $blog_tset ) {
        $blog_tset = MT->registry('template_sets')->{$blog_tset};
        $use_theme = 0;
    }
    if ( $blog_tset->{base_css} ) {
        if ( $use_theme ) {
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
        $use_theme = 0;
        $base_css_url = 'themes-base/blog.css';
    }

    my $base_css = q{};
    if ($base_css_url) {
        require URI;
        my $uri = URI->new_abs($base_css_url, $use_theme ? $app->support_directory_url : $app->static_path);
        $base_css = '@import url(' . $uri->as_string() . ');'
            if $uri;
    }

    # Replacing the theme import or adding a new one at the beginning
    my $template_text  = $tmpl->text();
    my $replaced       = 0;
    my $header = '/* This is the StyleCatcher theme addition. Do not remove this block. */';
    my $footer = '/* end StyleCatcher imports */';
    my $styles = <<"EOT";
$header
$base_css
\@import url($url);
$footer
EOT
    if ($template_text =~ s/\Q$header\E.*\Q$footer\E/$styles/s) {
        $tmpl->text( $template_text );
        $replaced = 1;
    }
    unless ($replaced) {

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

    $blog->page_layout($layout);
    $blog->touch();
    $blog->save();

    # rebuild only the stylesheet! forcibly. with prejudice.
    $app->rebuild_indexes(
        BlogID   => $tmpl->blog_id,
        Template => $tmpl,
        Force    => 1
    );

    my $p = plugin();
    $name =~ s/^repo_\d+:/local:/;
    $name =~ s/\.css$//;
    $p->set_config_value('current_theme_' . $blog_id, $name);
    if ($layout) {
        $p->set_config_value('current_layout_' . $blog_id, $layout);
    } else {
        $p->set_config_value('current_layout_' . $blog_id, undef);
    }

    return $app->json_result(
        {
            message =>
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
    } else {
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
        {
            blog_id    => $blog_id,
            identifier => 'styles'
        }
    );

    $tmpl ||= MT::Template->load(
        {
            blog_id => $blog_id,
            outfile => "styles.css"
        }
    );

    # MT 3.x era stylesheet file
    $tmpl ||= MT::Template->load(
        {
            blog_id => $blog_id,
            outfile => "styles-site.css"
        }
    );

    unless ($tmpl) {

        # Create one since we didn't find a candidate
        $tmpl = new MT::Template;
        $tmpl->blog_id($blog_id);
        $tmpl->name(plugin()->translate('Stylesheet'));
        $tmpl->type('index');
        $tmpl->identifier('styles');
        $tmpl->outfile("styles.css");
        $tmpl->text(<<'EOT');
@import url(<$MTStaticWebPath$>themes-base/blog.css);
@import url(<$MTStaticWebPath$>themes/minimalist-red/styles.css);
EOT
        $tmpl->save();
    }

    $tmpl;
}

# pulls a list of themes available from a particular url
sub fetch_themes {
    my $app = MT->app;
    my ($url) = @_;
    return undef unless $url;

    my $blog_id = $app->param('blog_id');
    my $data    = {};

  # If we have a url then we're specifying a specific theme (css) or repo (html)
    # Pick up the file (html with <link>s or a css file with metadata)
    my $user_agent = $app->new_ua;
    my $request    = HTTP::Request->new( GET => $url );
    my $response   = $user_agent->request($request);

    # Make a repo if you've got a ton of links or an automagic entry if
    # you're a css file
    my $type = $response->headers->{'content-type'};
    $type = shift @$type if ref $type eq 'ARRAY';
    if ( $type =~ m!^text/css! ) {
        $data->{auto}{url} = $url;
        my $theme = metadata_for_theme(
            url  => $url,
            tags => ['collection:auto'],
        );
        $data->{themes} = [$theme];
    }
    elsif ( $type =~ m!^text/html! ) {
        my @repo_themes;
        for my $link (
            ref( $response->headers->{'link'} ) eq 'ARRAY'
            ? @{ $response->headers->{'link'} }
            : $response->headers->{'link'}
          )
        {
            my ( $css, @parsed_link ) = split( /;/, $link );
            $css =~ s/[<>]//g;
            my %attr;
            foreach (@parsed_link) {
                my ( $name, $val ) = split /=/, $_, 2;
                $name =~ s/^ //;
                $val  =~ s/^['"]|['"]$//g;
                next if $name eq '/';
                $attr{ lc($name) } = $val;
            }
            next unless lc $attr{rel}  eq 'theme';
            next unless lc $attr{type} eq 'text/x-theme';

            # Fix for relative theme locations
            if ($css !~ m!^https?://!) {
                my $new_css = $url;
                $new_css =~ s!/[a-z0-9_-]+\.[a-z]+?$|/$!/!;
                $new_css .= $css;
                $css = $new_css;
            }
            push @repo_themes, $css;
        }

        my $themes = [];
        for my $repo_theme (@repo_themes) {
            my $theme = metadata_for_theme(
                url => $repo_theme,
            );
            push @$themes, $theme if $theme;
        }
        $data->{themes} = $themes;
        if ( $data->{repo}{display_name} = $response->headers->{'title'} ) {
            $data->{repo}{name} =
              MT::Util::dirify( $data->{repo}{display_name} );
        }
        else {
            $data->{repo}{display_name} = $url;
            $data->{repo}{name}         = MT::Util::dirify($url);
        }
        $data->{repo}{url} = $url;
    }
    else {
        return $app->error( $app->translate('Invalid URL: [_1]', $url) );
    }

    $data;
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

    my $themeroot =
      File::Spec->catdir( $app->static_file_path, 'support', 'themes' );

    # Generate our list of themes within the themeroot directory
    my @themeroot_list = glob( File::Spec->catfile( $themeroot, "*" ) );
    $categories->{'my-designs'} = 1 if @themeroot_list;
    for my $theme (@themeroot_list) {
        my $theme_dir = $theme;
        next unless -d $theme;
        $theme =~ s/.*[\\\/]//;
        $themes->{$theme} = metadata_for_theme(
            path => $theme_dir,
            url  => $app->static_path . "support/themes/$theme/",
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

sub theme_for_url {
    my %param = @_;
    my ($url, $path, $tags, $baseurl, $basepath)
        = @param{qw( url path tags baseurl basepath )};
    my $app = MT->instance;

    my %theme;
    if ($path && -e $path) {
        $theme{stylesheet} = file_mgr()->get_data($path);
        $theme{id} = basename(dirname($path));
    }
    elsif ($url) {
        my $user_agent = $app->new_ua;
        my $response   = $user_agent->get($url);
        return if !$response->is_success();
        $theme{stylesheet} = $response->content;

        my $id = $url;
        $id =~ s{ / (?:screen|style) \.css \z }{}xms;
        $id =~ s/.*[\\\/]//;
        $theme{id} = $id;
    }

    return %theme;
}

sub metadata_for_stylesheet {
    my %param = @_;
    my ($stylesheet) = @param{qw( stylesheet )};

    # Pick up the metadata from the css
    my @css_lines = split( /\r?\n/, $stylesheet || '' );
    my $commented = 0;
    my @comments;
    for my $line (@css_lines) {
        my $pos;
        $pos = index( $line, "/*" );
        unless ( $pos == -1 ) {
            $line = substr( $line, $pos + 2 );
            $commented = 1;
        }
        if ($commented) {
            $pos = index( $line, "*/" );
            unless ( $pos == -1 ) {
                $line = substr( $line, 0, $pos );
                $commented = 0;
            }
            push @comments, $line;
        }
    }

    my %metadata;

    # Trim me white space, yarr
    for my $comment (@comments) {
        # Strip any null bytes
        $comment =~ tr/\x00//d;
        $comment =~ s/^\s+|\s+$//g;

        my ( $key, $value ) = split( /:/, $comment, 2 ) or next;
        next unless defined $value;
        $value =~ s/^\s+//;
        $metadata{ lc $key } = $value;
    }

    my %field_map = (
        title        => [ 'name',         'theme name' ],
        author       => [ 'designer',     'author' ],
        author_url   => [ 'designer_url', 'author_url', 'author uri' ],
        template_set => [ 'template_set', 'template' ],
        description  => [ 'description' ],
    );
    while (my ($best_name, $possible_names) = each %field_map) {
        ($metadata{$best_name}) = grep { defined }
            delete @metadata{ @$possible_names }, q{};
        # TODO: do html mashing later
        $metadata{$best_name} = decode_html(remove_html(Encode::decode_utf8($metadata{$best_name})));
    }

    return %metadata;
}

sub thumbnails_for_theme {
    my %param = @_;
    my ($url, $path, $metadata)
        = @param{qw( url path metadata )};
    my $app = MT->instance;

    my %thumbnails;
    THUMB: for my $thumb (qw( thumbnail thumbnail_large )) {
        $thumbnails{$thumb} = $metadata->{$thumb};
        next THUMB if $thumbnails{$thumb};

        my $thumb_filename = $thumb;
        $thumb_filename =~ tr/_/-/;
        $thumb_filename .= '.gif';

        require URI;
        if ($path) {
            my ($volume, $dir, $theme_filename) = File::Spec->splitpath($path);
            my $thumb_path = File::Spec->catpath($volume, $dir, $thumb_filename);
            if (-e $thumb_path) {
                my $url_uri = URI->new_abs($thumb_filename, $url);
                $thumbnails{$thumb} = $url_uri->as_string();
            }
        }
        elsif ($url) {
            my $url_uri = URI->new_abs($thumb_filename, $url);
            my $thumb_url = $url_uri->as_string();

            my $user_agent = $app->new_ua;
            my $response   = $user_agent->head($thumb_url);
            if ($response->is_success()) {
                $thumbnails{$thumb} = $thumb_url;
            }
        }

        # Use plugin's default thumbnail if necessary.
        $thumbnails{$thumb} ||= $app->static_path . 'plugins/StyleCatcher/'
            . 'images/' . $thumb_filename;
    }

    return %thumbnails;
}

sub metadata_for_theme {
    my $app = MT->app;
    my %param = @_;
    my ($url, $path, $tags, $default_metadata)
        = @param{qw( url path tags metadata )};

    # Update a path, if present, from a theme directory to the real full
    # stylesheet path.
    if ($path && -d $path) {
        $path =~ s{ / \z }{}xms;
        FILESTEM: for my $filestem (basename($path), "screen", "style") {
            my $full_path = File::Spec->catfile($path, "$filestem.css");
            if ($full_path && -f $full_path) {
                $path = $param{path} = $full_path;

                $url =~ s{ / \z }{}xms;
                $url  = $param{url}  = "$url/$filestem.css";

                last FILESTEM;
            }
        }
    }

    my %theme      = theme_for_url(%param);
    my %metadata   = metadata_for_stylesheet(%param, %theme);
    my %thumbnails = thumbnails_for_theme(%param, metadata => \%metadata);

    my $data = {
        name         => $theme{id},
        description  => $metadata{description} || q{},
        title        => $metadata{title} || $app->translate('(Untitled)'),
        url          => $url,
        imageSmall   => $thumbnails{thumbnail},
        imageBig     => $thumbnails{thumbnail_large},
        layouts      => $metadata{layouts} || q{},
        sort         => lc($metadata{title} || $theme{id} || q{}),
        tags         => $tags || [],
        blogs        => [],
        author       => $metadata{author},
        author_url   => $metadata{author_url},
        template_set => $metadata{template_set},
        author_affiliation => $metadata{author_affiliation} || q{},
    };
    $data;
}

sub plugin {
    return MT->component('StyleCatcher');
}

1;
