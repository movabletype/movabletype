# Copyright 2005-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.
#
# $Id$

package StyleCatcher::CMS;

use strict;
use File::Basename qw(basename);

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
        $entry{label} = $entry{label}->() if ref($entry{label});
        $entry{description_label} = $entry{description_label}->() if ref($entry{description_label});
        push @list, \%entry;
    }
    @list = sort { $a->{order} <=> $b->{order} } @list;
    \@list;
}

sub view {
    my $app     = shift;
    my $blog_id = $app->param('blog_id');
    return $app->errtrans("Invalid request") unless $blog_id;

    my $blog = MT::Blog->load($blog_id);
    return $app->errtrans("Invalid request") unless $blog;

    my $themeroot =
      File::Spec->catdir( $app->static_file_path, 'support', 'themes' );
    my $webthemeroot = $app->static_path . 'support/themes';
    my $stylelibrary = listify(style_library());
    my $theme_data   = make_themes();
    my $styled_blogs = fetch_blogs();

    my $config = plugin()->get_config_hash();

    my @blog_loop;
    my %current_themes;
    my ($blog_theme, $blog_layout);
    foreach my $blog (@$styled_blogs) {
        my $curr_theme = $config->{"current_theme_" . $blog->id} || '';
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

    require JSON;
    my $url   = $app->param('url');
    my %param = (
        version     => plugin()->version,
        # blog_loop   => \@blog_loop,
        blog_id => $blog_id,
        themes_json => JSON::objToJson(
            $theme_data, { pretty => 1, indent => 2, delimiter => 1 }
        ),
        auto_fetch => $url ? 1 : 0,
        style_library => $stylelibrary,
        current_theme => $blog_theme || '',
        current_layout => $blog_layout || 'layout-wtt',
        dynamic_blog => (($blog->custom_dynamic_templates || '') eq 'all'),
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

    my $data = fetch_themes($app->param('url'))
        or return $app->json_error( $app->errstr );
    return $app->json_result( $data );
}

# does the work after user selects a particular theme to apply to a blog
sub apply {
    my $app = shift;

    my $blog_id = $app->param('blog_id');
    my $url     = $app->param('url');
    my $layout  = $app->param('layout');
    my $name    = $app->param('name');

    # Load the default stylesheet for this blog
    my $tmpl = load_style_template($blog_id);

    $app->validate_magic or return $app->json_error($app->translate("Invalid request"));
    return $app->json_error($app->translate("Invalid request"))
      unless $blog_id && $url && $tmpl;

    my $themeroot =
      File::Spec->catdir( $app->static_file_path, 'support', 'themes' );
    my $webthemeroot = $app->static_path . 'support/themes/';
    my $mtthemeroot  = $app->static_path . 'themes/';

    # Break up the css url in to a couple useful pieces
    my @url = split( /\//, $url );

    # if this isn't a local url, then we have to grab some files from
    # yonder...
    my $filemgr = file_mgr()
      or return $app->json_error( MT::FileMgr->errstr );

    if ( $url !~ m/^(\Q$webthemeroot\E|\Q$mtthemeroot\E)/ ) {
        my $new_url = '';

        for (0..(scalar(@url)-2)) {
            $new_url .= $url[$_] . '/';
        }
        my ( $basename, $extension ) = split( /\./, $url[-1] );
        if ($basename eq 'screen') {
            $basename = $url[-2];
        }

        # Pick up the stylesheet
        my $user_agent  = $app->new_ua;
        my $css_request = HTTP::Request->new( GET => $url );
        my $response    = $user_agent->request($css_request);

        # Pick up the thumbnail and thumbnail-large
        my $thumbnail_request =
          HTTP::Request->new( GET => $new_url . "thumbnail.gif" );
        my $thumbnail_response = $user_agent->request($thumbnail_request);
        my $thumbnail_large_request =
          HTTP::Request->new( GET => $new_url . "thumbnail-large.gif" );
        my $thumbnail_large_response =
          $user_agent->request($thumbnail_large_request);

        # Parse out image filenames in the css and then write out the css file
        # and thumbnails to our theme folder
        my $content = $response->content;
        $content =~ s!/\*.*?\*/!!gs;    # strip all comments first
        my @images = $content =~
          m/\b(?:url\(\s*)([a-zA-Z0-9_.-]+\.(?:gif|jpe?g|png))(?:\s*?\))/gi;
        $filemgr->mkpath( File::Spec->catdir( $themeroot, $basename ) )
          or return $app->json_error(
            $app->translate(
"Could not create [_1] folder - Check that your 'themes' folder is webserver-writable.",
                $basename
            )
          );
        $filemgr->put_data( $response->content,
            File::Spec->catfile( $themeroot, $basename, $basename . '.css' ) );
        if (($thumbnail_response->code >= 200) && ($thumbnail_response->code < 400)) {
        $filemgr->put_data( $thumbnail_response->content,
            File::Spec->catfile( $themeroot, $basename, "thumbnail.gif" ),
            'upload' );
        } else {
            return $app->json_error($app->translate("Error downloading image: [_1]", $new_url . 'thumbnail.gif'))
        }
        if (($thumbnail_large_response->code >= 200) && ($thumbnail_large_response->code < 400)) {
            $filemgr->put_data(
                $thumbnail_large_response->content,
                File::Spec->catfile( $themeroot, $basename, "thumbnail-large.gif" ),
                'upload'
            );
        } else {
            return $app->json_error($app->translate("Error downloading image: [_1]", $new_url . 'thumbnail-large.gif'))
        }

       # Pick up the images we parsed earlier and write them to the theme folder
        for my $image_url (@images) {
            my $image_request =
              HTTP::Request->new( GET => $new_url . $image_url );
            my $image_response = $user_agent->request($image_request);

            my @image_url = split( /\//, $image_url );
            my $image_filename = $image_url[-1];

            if (($response->code >= 200) && ($response->code < 400)) {
                $filemgr->put_data( $image_response->content,
                    File::Spec->catfile( $themeroot, $basename, $image_filename ),
                    'upload' )
                  or return $app->json_error( $filemgr->errstr );
            } else {
                return $app->json_error($app->translate("Error downloading image: [_1]", $new_url . $image_url));
            }
        }
        $url = "$webthemeroot$basename/$basename.css";
    }

    my $base_theme =
      $app->model('template')
      ->load( { identifier => 'base_theme', blog_id => $blog_id } );
    my $url2 = $base_theme ? $base_theme->outfile : 'base_theme.css';

    # Replacing the theme import or adding a new one at the beginning
    my $template_text  = $tmpl->text();
    my $replaced       = 0;
    my $header =
'/* This is the StyleCatcher theme addition. Do not remove this block. */';
    my $footer = '/* end StyleCatcher imports */';
    my $layout_str = '';
    if ($layout && ($layout =~ m/^[-\w]+$/)) {
        $layout_str = qq{/* Selected Layout: <MTSetVar name="page_layout" value="$layout"> */\n};
    }
    my $styles = $header . "\n" . $layout_str . <<"EOT" . $footer;
\@import url($url2);
\@import url($url);
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
        $backup->save;
        $tmpl->linked_file('');    # make sure this one isn't linked now
        $tmpl->identifier('styles');
        $tmpl->text($styles);
    }

    # Putting the stylesheet back together again
    $tmpl->save or return $app->json_error( $tmpl->errstr );

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
        $tmpl->identifier('styles');
        $tmpl->outfile("styles.css");
        $tmpl->text(<<'EOT');
@import url(<$MTLink template="base_theme"$>);
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
        my $theme = fetch_theme( $url, ['collection:auto'] );
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
            push @repo_themes, $css;
        }

        my $themes = [];
        for my $repo_theme (@repo_themes) {
            my $theme = fetch_theme( $repo_theme, [] );
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
        $themes->{$theme} =
          fetch_theme( $theme_dir, ['collection:mt-designs'], $theme_url,
            $theme_dir );
        $themes->{$theme}{name} = $themes->{$theme}{name};
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
        $themes->{$theme} =
          fetch_theme( $theme_dir, ['collection:my-designs'] );
        $themes->{$theme}{prefix} = 'local';
    }

    my $data = {
        categories => [ keys %$categories ],
        themes     => [ values %$themes ]
    };

    $data;
}

sub fetch_theme {
    my $app = MT->app;
    my ( $url, $tags, $baseurl, $basepath ) = @_;

    my $theme;
    my $stylesheet;
    my $new_url;
    my $themeroot;
    if ( $url =~ m/^https?:/i ) {

        # Pick up the css file
        my $user_agent  = $app->new_ua;
        my $css_request = HTTP::Request->new( GET => $url );
        my $response    = $user_agent->request($css_request);
        $stylesheet = $response->content if ($response->code >= 200) && ($response->code < 400);
        return unless $stylesheet;

# Break up the css url in to a couple useful pieces (generalize and break me out)
        $theme = $url;
        $theme =~ s/.*[\\\/]//;
        my @url = split( /\//, $url );
        for ( 0 .. ( scalar(@url) - 2 ) ) {
            $new_url .= $url[$_] . '/';
        }
    }
    else {
        $themeroot = $basepath
          || File::Spec->catdir( $app->static_file_path, 'support', 'themes' );
        my $webthemeroot = $baseurl || $app->static_path . 'support/themes';

        $theme = $url;
        $theme =~ s/.*[\\\/]//;
        my $file = File::Spec->catfile( $url, "$theme.css" );
        $new_url = "$webthemeroot/$theme/";
        if ( -e $file ) {
            $stylesheet = file_mgr()->get_data($file);
            $url        = $new_url . "$theme.css";
        }
        else {
            $file = File::Spec->catfile( $url, "screen.css" );
            if ( -e $file ) {
                $stylesheet = file_mgr()->get_data($file);
                $url        = $new_url . "screen.css";
            }
        }
    }

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

    my $comment;
    my %metadata;

    # Trim me white space, yarr
    for (@comments) {

        # TBD: strip any "risky" content; we don't want any
        # XSS in this content.
        # Strip any null bytes
        tr/\x00//d;
        s/^\s+|\s+$//g;
        my ( $key, $value ) = split( /:/, $_, 2 ) or next;
        next unless defined $value;
        $value =~ s/^\s+//;
        $metadata{ lc $key } = $value;
    }

    my $thumbnail_link;
    $thumbnail_link = $new_url . 'thumbnail.gif';
    my $thumbnail_large_link;
    $thumbnail_large_link = $new_url . 'thumbnail-large.gif';

    require MT::Util;
    my $data = {
        name        => $theme,
        description => $metadata{description} || '',
        title       => $metadata{name} || '(Untitled)',
        url         => $url,
        imageSmall  => $thumbnail_link,
        imageBig    => $thumbnail_large_link,
        author      => $metadata{designer} || $metadata{author} || '',
        author_url  => $metadata{designer_url} || $metadata{author_url} || '',
        author_affiliation => $metadata{author_affiliation} || '',
        layouts            => $metadata{layouts} || '',
        'sort'             => $metadata{name} || '',
        tags               => $tags,
        blogs              => [],
    };
    $data;
}

sub plugin {
    return MT->component('StyleCatcher');
}

1;
