# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Asset::Image;

use strict;
use base qw( MT::Asset );
use MT::Blog;
use MT::Website;

__PACKAGE__->install_properties(
    {   class_type  => 'image',
        column_defs => {
            'image_width'  => 'integer meta',
            'image_height' => 'integer meta',
        },
        child_of => [ 'MT::Blog', 'MT::Website', ],
    }
);

# List of supported file extensions (to aid the stock 'can_handle' method.)
sub extensions {
    my $pkg = shift;
    return $pkg->SUPER::extensions(
        [ qr/gif/i, qr/jpe?g/i, qr/png/i, qr/bmp/i, qr/tiff?/i, qr/ico/i ] );
}

sub class_label {
    MT->translate('Image');
}

sub class_label_plural {
    MT->translate('Images');
}

sub metadata {
    my $obj  = shift;
    my $meta = $obj->SUPER::metadata(@_);

    my $width  = $obj->image_width;
    my $height = $obj->image_height;
    $meta->{image_width}  = $width  if defined $width;
    $meta->{image_height} = $height if defined $height;
    $meta->{image_dimensions} = $meta->{ MT->translate("Actual Dimensions") }
        = MT->translate( "[_1] x [_2] pixels", $width, $height )
        if defined $width && defined $height;

    $meta;
}

sub image_height {
    my $asset = shift;
    my $height = $asset->meta( 'image_height', @_ );
    return $height if $height || @_;

    eval { require Image::Size; };
    return undef if $@;
    if ( !-e $asset->file_path || !-r $asset->file_path ) {
        return undef;
    }
    my ( $w, $h, $id ) = Image::Size::imgsize( $asset->file_path );
    $asset->meta( 'image_height', $h );
    if ( $asset->id ) {
        $asset->save;
    }
    return $h;
}

sub image_width {
    my $asset = shift;
    my $width = $asset->meta( 'image_width', @_ );
    return $width if $width || @_;

    eval { require Image::Size; };
    return undef if $@;
    if ( !-e $asset->file_path || !-r $asset->file_path ) {
        return undef;
    }
    my ( $w, $h, $id ) = Image::Size::imgsize( $asset->file_path );
    $asset->meta( 'image_width', $w );
    if ( $asset->id ) {
        $asset->save;
    }
    return $w;
}

sub has_thumbnail {
    my $asset = shift;

    require MT::Image;
    my $image = MT::Image->new(
        ( ref $asset ? ( Filename => $asset->file_path ) : () ) );
    $image ? 1 : 0;
}

sub thumbnail_path {
    my $asset = shift;
    my (%param) = @_;

    $asset->_make_cache_path( $param{Path} );
}

sub thumbnail_file {
    my $asset = shift;
    my (%param) = @_;
    my $fmgr;
    my $blog = $param{Blog} || $asset->blog;

    require MT::FileMgr;
    $fmgr ||= $blog ? $blog->file_mgr : MT::FileMgr->new('Local');
    return undef unless $fmgr;

    my $file_path = $asset->file_path;
    return undef unless $fmgr->file_size($file_path);

    require MT::Util;
    my $asset_cache_path = $asset->_make_cache_path( $param{Path} );
    my ( $i_h, $i_w ) = ( $asset->image_height, $asset->image_width );
    return undef unless $i_h && $i_w;

    # Pretend the image is already square, for calculation purposes.
    my $auto_size = 1;
    if ( $param{Square} ) {
        require MT::Image;
        my %square
            = MT::Image->inscribe_square( Width => $i_w, Height => $i_h );
        ( $i_h, $i_w ) = @square{qw( Size Size )};
        if ( $param{Width} && !$param{Height} ) {
            $param{Height} = $param{Width};
        }
        elsif ( !$param{Width} && $param{Height} ) {
            $param{Width} = $param{Height};
        }
        $auto_size = 0;
    }
    if ( my $scale = $param{Scale} ) {
        $param{Width}  = int( ( $i_w * $scale ) / 100 );
        $param{Height} = int( ( $i_h * $scale ) / 100 );
        $auto_size     = 0;
    }
    if ( !exists $param{Width} && !exists $param{Height} ) {
        $param{Width}  = $i_w;
        $param{Height} = $i_h;
        $auto_size     = 0;
    }

    # find the longest dimension of the image:
    my ( $n_h, $n_w, $scaled )
        = _get_dimension( $i_h, $i_w, $param{Height}, $param{Width} );
    if ( $auto_size && $scaled eq 'h' ) {
        delete $param{Width} if exists $param{Width};
    }
    elsif ( $auto_size && $scaled eq 'w' ) {
        delete $param{Height} if exists $param{Height};
    }

    my $file = $asset->thumbnail_filename(%param) or return;
    my $thumbnail = File::Spec->catfile( $asset_cache_path, $file );

    # thumbnail file exists and is dated on or later than source image
    if ($fmgr->exists($thumbnail)
        && ( $fmgr->file_mod_time($thumbnail)
            >= $fmgr->file_mod_time($file_path) )
        )
    {
        my $already_exists = 1;
        if ( $asset->image_width != $asset->image_height ) {
            require MT::Image;
            my ( $t_w, $t_h )
                = MT::Image->get_image_info( Filename => $thumbnail );
            if (   ( $param{Square} && $t_h != $t_w )
                || ( !$param{Square} && $t_h == $t_w ) )
            {
                $already_exists = 0;
            }
        }
        return ( $thumbnail, $n_w, $n_h ) if $already_exists;
    }

    # stale or non-existent thumbnail. let's create one!
    return undef unless $fmgr->can_write($asset_cache_path);

    my $data;
    if (   ( $n_w == $i_w )
        && ( $n_h == $i_h )
        && !$param{Square}
        && !$param{Type} )
    {
        $data = $fmgr->get_data( $file_path, 'upload' );
    }
    else {

        # create a thumbnail for this file
        require MT::Image;
        my $img = new MT::Image( Filename => $file_path )
            or return $asset->error( MT::Image->errstr );

        # Really make the image square, so our scale calculation works out.
        if ( $param{Square} ) {
            ($data) = $img->make_square()
                or return $asset->error(
                MT->translate( "Error cropping image: [_1]", $img->errstr ) );
        }

        ($data) = $img->scale( Height => $n_h, Width => $n_w )
            or return $asset->error(
            MT->translate( "Error scaling image: [_1]", $img->errstr ) );

        if ( my $type = $param{Type} ) {
            ($data) = $img->convert( Type => $type )
                or return $asset->error(
                MT->translate( "Error converting image: [_1]", $img->errstr )
                );
        }
    }
    $fmgr->put_data( $data, $thumbnail, 'upload' )
        or return $asset->error(
        MT->translate( "Error creating thumbnail file: [_1]", $fmgr->errstr )
        );
    return ( $thumbnail, $n_w, $n_h );
}

sub _get_dimension {
    my ( $i_h, $i_w, $h, $w ) = @_;

    my ( $n_h, $n_w ) = ( $i_h, $i_w );
    my $scale = '';
    if ( $h && !$w ) {
        $scale = 'h';
    }
    elsif ( $w && !$h ) {
        $scale = 'w';
    }
    else {
        if ( $i_h > $i_w ) {

            # scale, if necessary, by height
            if ( $i_h > $h ) {
                $scale = 'h';
            }
            elsif ( $i_w > $w ) {
                $scale = 'w';
            }
        }
        else {

            # scale, if necessary, by width
            if ( $i_w > $w ) {
                $scale = 'w';
            }
            elsif ( $i_h > $h ) {
                $scale = 'h';
            }
        }
    }
    if ( $scale eq 'h' ) {

        # scale by height
        $n_h = $h;
        $n_w = int( $i_w * $h / $i_h );
    }
    elsif ( $scale eq 'w' ) {

        # scale by width
        $n_w = $w;
        $n_h = int( $i_h * $w / $i_w );
    }
    $n_h = 1 unless $n_h;
    $n_w = 1 unless $n_w;

    return ( $n_h, $n_w, $scale );
}

sub thumbnail_filename {
    my $asset   = shift;
    my (%param) = @_;
    my $file    = $asset->file_name or return;

    require MT::Util;
    my $format = $param{Format} || MT->translate('%f-thumb-%wx%h-%i%x');
    my $width  = $param{Width}  || 'auto';
    my $height = $param{Height} || 'auto';
    $file =~ s/\.\w+$//;
    my $base = File::Basename::basename($file);
    my $id   = $asset->id;
    my $ext  = lc( $param{Type} || '' ) || $asset->file_ext || '';
    $ext = '.' . $ext;
    $format =~ s/%w/$width/g;
    $format =~ s/%h/$height/g;
    $format =~ s/%f/$base/g;
    $format =~ s/%i/$id/g;
    $format =~ s/%x/$ext/g;
    return $format;
}

sub as_html {
    my $asset   = shift;
    my ($param) = @_;
    my $text    = '';

    my $app = MT->instance;
    $param->{enclose} = 0 unless exists $param->{enclose};

    if ( $param->{include} ) {

        my $fname = $asset->file_name;
        require MT::Util;

        my $thumb = undef;
        if ( $param->{thumb} ) {
            $thumb = MT::Asset->load( $param->{thumb_asset_id} )
                || return $asset->error(
                MT->translate(
                    "Cannot load image #[_1]",
                    $param->{thumb_asset_id}
                )
                );
        }

        my $dimensions = sprintf(
            'width="%s" height="%s"',
            (   $thumb
                ? ( $thumb->image_width, $thumb->image_height )
                : ( $asset->image_width, $asset->image_height )
            )
        );
        my $wrap_style = '';
        if ( $param->{wrap_text} && $param->{align} ) {
            $wrap_style = 'class="mt-image-' . $param->{align} . '" ';
            if ( $param->{align} eq 'none' ) {
                $wrap_style .= q{style=""};
            }
            elsif ( $param->{align} eq 'left' ) {
                $wrap_style .= q{style="float: left; margin: 0 20px 20px 0;"};
            }
            elsif ( $param->{align} eq 'right' ) {
                $wrap_style
                    .= q{style="float: right; margin: 0 0 20px 20px;"};
            }
            elsif ( $param->{align} eq 'center' ) {
                $wrap_style
                    .= q{style="text-align: center; display: block; margin: 0 auto 20px;"};
            }
        }

        if ( $param->{popup} && $param->{popup_asset_id} ) {
            my $popup = MT::Asset->load( $param->{popup_asset_id} )
                || return $asset->error(
                MT->translate(
                    "Cannot load image #[_1]",
                    $param->{popup_asset_id}
                )
                );
            my $link
                = $thumb
                ? sprintf(
                '<img src="%s" %s alt="%s" %s />',
                MT::Util::encode_html( $thumb->url ),   $dimensions,
                MT::Util::encode_html( $asset->label ), $wrap_style
                )
                : MT->translate('View image');
            $text = sprintf(
                q|<a href="%s" onclick="window.open('%s','popup','width=%d,height=%d,scrollbars=yes,resizable=no,toolbar=no,directories=no,location=no,menubar=no,status=no,left=0,top=0'); return false">%s</a>|,
                MT::Util::encode_html( $popup->url ),
                MT::Util::encode_html( $popup->url ),
                $asset->image_width,
                $asset->image_height + 1,
                $link,
            );
        }
        else {
            if ( $param->{thumb} ) {
                $text = sprintf(
                    '<a href="%s"><img alt="%s" src="%s" %s %s /></a>',
                    MT::Util::encode_html( $asset->url ),
                    MT::Util::encode_html( $asset->label ),
                    MT::Util::encode_html( $thumb->url ),
                    $dimensions,
                    $wrap_style,
                );
            }
            else {
                $text = sprintf(
                    '<img alt="%s" src="%s" %s %s />',
                    MT::Util::encode_html( $asset->label ),
                    MT::Util::encode_html( $asset->url ),
                    $dimensions, $wrap_style,
                );
            }
        }
    }
    else {
        require MT::Util;
        $text = sprintf(
            '<a href="%s">%s</a>',
            MT::Util::encode_html( $asset->url ),
            MT::Util::encode_html( $asset->display_name )
        );
    }

    return $param->{enclose} ? $asset->enclose($text) : $text;
}

# Return a HTML snippet of form options for inserting this asset
# into a web page. Default behavior is no options.
sub insert_options {
    my $asset = shift;
    my ($param) = @_;

    my $app   = MT->instance;
    my $perms = $app->{perms};
    my $blog  = $asset->blog or return;

    $param->{do_thumb}
        = $asset->has_thumbnail && $asset->can_create_thumbnail ? 1 : 0;

    $param->{can_save_image_defaults}
        = $perms->can_do('save_image_defaults') ? 1 : 0;

    #$param->{constrain} = $blog->image_default_constrain ? 1 : 0;
    $param->{popup}      = $blog->image_default_popup     ? 1 : 0;
    $param->{wrap_text}  = $blog->image_default_wrap_text ? 1 : 0;
    $param->{make_thumb} = $blog->image_default_thumb     ? 1 : 0;
    $param->{ 'align_' . $_ }
        = ( $blog->image_default_align || 'none' ) eq $_ ? 1 : 0
        for qw(none left center right);
    $param->{ 'unit_w' . $_ }
        = ( $blog->image_default_wunits || 'pixels' ) eq $_ ? 1 : 0
        for qw(percent pixels);
    $param->{thumb_width}
        = $blog->image_default_width
        || $asset->image_width
        || 0;

    return $app->build_page( 'dialog/asset_options_image.tmpl', $param );
}

sub on_upload {
    my $asset = shift;
    my ($param) = @_;

    $asset->SUPER::on_upload(@_);

    return unless $param->{new_entry};

    my $app = MT->instance;
    require MT::Util;

    my $url    = $asset->url;
    my $width  = $asset->image_width;
    my $height = $asset->image_height;

    my ( $base_url, $fname ) = $url =~ m|(.*)/([^/]*)|;
    $url = $base_url . '/'
        . $fname;    # no need to re-encode filename; url is already encoded
    my $blog = $asset->blog or return;
    my $blog_id = $blog->id;

    my ( $thumb, $thumb_width, $thumb_height );
    $thumb_width = $param->{thumb_width};
    $thumb       = $param->{thumb};
    if ($thumb) {
        if ( $thumb_width && ( $thumb_width !~ m/^\d+$/ ) ) {
            undef $thumb_width;
        }

        # width > 1000 not really a thumbnail, so consider invalid
        if ( $thumb_width > 1000 ) {
            undef $thumb_width;
        }
    }
    if ( $thumb && !$thumb_width ) {
        undef $thumb;
    }
    if ( $param->{image_defaults} ) {
        return $app->error(
            $app->translate(
                'Permission denied setting image defaults for blog #[_1]',
                $blog_id
            )
        ) unless $app->{perms}->can_do('save_image_defaults');

        # Save new defaults if requested.
        $blog->image_default_wrap_text( $param->{wrap_text} ? 1 : 0 );
        $blog->image_default_align( $param->{align} || MT::Blog::ALIGN() );
        if ($thumb) {
            $blog->image_default_thumb(1);
            $blog->image_default_width($thumb_width);
            $blog->image_default_wunits( $param->{thumb_width_type}
                    || MT::Blog::UNITS() );
        }
        else {
            $blog->image_default_thumb(0);
            $blog->image_default_width(0);
            $blog->image_default_wunits( MT::Blog::UNITS() );
        }

        #$blog->image_default_constrain($param->{constrain} ? 1 : 0);
        $blog->image_default_popup( $param->{popup} ? 1 : 0 );
        $blog->save or die $blog->errstr;
    }
    my $fmgr = $blog->file_mgr;
    require MT::Util;

    # Thumbnail creation
    if ( $thumb = $param->{thumb} ) {
        require MT::Image;
        my $image_type = scalar $param->{image_type};
        my ( $w, $h ) = map $param->{$_}, qw( thumb_width thumb_height );
        my ($pseudo_thumbnail_url)
            = $asset->thumbnail_url( Height => $h, Width => $w, Pseudo => 1 );
        my ($thumbnail)
            = File::Basename::basename(
            $asset->thumbnail_file( Height => $h, Width => $w ) );

        my $pseudo_thumbnail_path
            = File::Spec->catfile( $asset->_make_cache_path( undef, 1 ),
            $thumbnail );
        my ( $base, $path, $ext )
            = File::Basename::fileparse( $thumbnail, qr/[A-Za-z0-9]+$/ );
        my $img_pkg = MT::Asset->handler_for_file($thumbnail);
        my $original;
        my $asset_thumb = $img_pkg->load(
            {   file_name => "$base$ext",
                parent    => $asset->id,
            }
        );

        if ( !$asset_thumb ) {
            $asset_thumb = $img_pkg->new();
            $original    = $asset_thumb->clone;
            $asset_thumb->blog_id($blog_id);
            $asset_thumb->url($pseudo_thumbnail_url);
            $asset_thumb->file_path($pseudo_thumbnail_path);
            $asset_thumb->file_name("$base$ext");
            $asset_thumb->file_ext($ext);
            $asset_thumb->image_width($w);
            $asset_thumb->image_height($h);
            $asset_thumb->created_by( $app->user->id );
            $asset_thumb->label(
                $app->translate(
                    "Thumbnail image for [_1]",
                    $asset->label || $asset->file_name
                )
            );
            $asset_thumb->parent( $asset->id );
        }
        else {
            $original = $asset_thumb->clone;
        }

        # force these to calculate now, giving a full URL / file path
        # for callbacks
        $thumbnail = $asset_thumb->file_path;
        my $thumbnail_url   = $asset_thumb->url;
        my $thumb_file_size = $fmgr->file_size($thumbnail);

        $app->run_callbacks( 'cms_pre_save.asset', $app, $asset_thumb,
            $original )
            || return $app->errtrans( "Saving [_1] failed: [_2]",
            'asset', $app->errstr );

        $asset_thumb->save unless $asset_thumb->id;

        $app->run_callbacks( 'cms_post_save.asset', $app, $asset_thumb,
            $original );

        $param->{thumb_asset_id} = $asset_thumb->id;

        $app->run_callbacks(
            'cms_upload_file.' . $asset_thumb->class,
            File  => $thumbnail,
            file  => $thumbnail,
            Url   => $thumbnail_url,
            url   => $thumbnail_url,
            Size  => $thumb_file_size,
            size  => $thumb_file_size,
            Asset => $asset_thumb,
            asset => $asset_thumb,
            Type  => 'thumbnail',
            type  => 'thumbnail',
            Blog  => $blog,
            blog  => $blog
        );

        $app->run_callbacks(
            'cms_upload_image',
            File       => $thumbnail,
            file       => $thumbnail,
            Url        => $thumbnail_url,
            url        => $thumbnail_url,
            Asset      => $asset_thumb,
            asset      => $asset_thumb,
            Width      => $w,
            width      => $w,
            Height     => $h,
            height     => $h,
            ImageType  => $image_type,
            image_type => $image_type,
            Size       => $thumb_file_size,
            size       => $thumb_file_size,
            Type       => 'thumbnail',
            type       => 'thumbnail',
            Blog       => $blog,
            blog       => $blog
        );
    }
    if ( $param->{popup} ) {
        require MT::Template;
        if (my $tmpl = MT::Template->load(
                {   blog_id => $blog_id,
                    type    => 'popup_image'
                }
            )
            )
        {
            ( my $rel_path = $param->{fname} ) =~ s!\.[^.]*$!!;
            if ( $rel_path =~ m!\.\.|\0|\|! ) {
                return $app->error(
                    $app->translate( "Invalid basename '[_1]'", $rel_path ) );
            }
            $rel_path .= '-' . $asset->id;
            my $ext = $blog->file_extension || '';
            $ext = '.' . $ext if $ext ne '';
            require MT::Template::Context;
            my $ctx = MT::Template::Context->new;
            $ctx->stash( 'blog',         $blog );
            $ctx->stash( 'blog_id',      $blog->id );
            $ctx->stash( 'asset',        $asset );
            $ctx->stash( 'image_url',    $url );
            $ctx->stash( 'image_width',  $width );
            $ctx->stash( 'image_height', $height );
            my $popup       = $tmpl->build($ctx) or die $tmpl->errstr;
            my $root_path   = $asset->_make_cache_path;
            my $pseudo_path = $asset->_make_cache_path( undef, 1 );
            my $abs_file_path
                = File::Spec->catfile( $root_path, $rel_path . $ext );

            my ( $i, $rel_path_ext ) = ( 0, $rel_path . $ext );
            my $pseudo_url = File::Spec->catfile( $pseudo_path,
                MT::Util::encode_url($rel_path_ext) );
            $pseudo_path = File::Spec->catfile( $pseudo_path, $rel_path_ext );
            my ( $vol, $dirs, $basename )
                = File::Spec->splitpath($rel_path_ext);

            ## Untaint. We have checked for security holes above, so we
            ## should be safe.
            ($abs_file_path) = $abs_file_path =~ /(.+)/s;
            $fmgr->put_data( $popup, $abs_file_path, 'upload' )
                or return $app->error(
                $app->translate(
                    "Error writing to '[_1]': [_2]", $abs_file_path,
                    $fmgr->errstr
                )
                );

            my $html_pkg = MT::Asset->handler_for_file($abs_file_path);
            my $original;
            my $asset_html = $html_pkg->load(
                {   file_name => "$basename",
                    parent    => $asset->id
                }
            );
            if ( !$asset_html ) {
                $asset_html = new $html_pkg;
                $original   = $asset_html->clone;
                $asset_html->blog_id($blog_id);
                $pseudo_url =~ s!\\!/!g;
                $asset_html->url($pseudo_url);
                $asset_html->label(
                    $app->translate(
                        "Popup page for [_1]",
                        $asset->label || $asset->file_name
                    )
                );
                $asset_html->file_path($pseudo_path);
                $asset_html->file_name($basename);
                $asset_html->file_ext( $blog->file_extension );
                $asset_html->created_by( $app->user->id );
                $asset_html->parent( $asset->id );
            }
            else {
                $original = $asset_html->clone;
            }

            # Select back the real URL for callbacks
            $url = $asset_html->url;

            $app->run_callbacks( 'cms_pre_save.asset', $app, $asset_html,
                $original )
                || return $app->errtrans( "Saving [_1] failed: [_2]",
                'asset', $app->errstr );

            $asset_html->save unless $asset_html->id;

            $param->{popup_asset_id} = $asset_html->id;

            $app->run_callbacks( 'cms_post_save.asset', $app, $asset_html,
                $original );

            $app->run_callbacks(
                'cms_upload_file.' . $asset_html->class,
                File  => $abs_file_path,
                file  => $abs_file_path,
                Url   => $url,
                url   => $url,
                Asset => $asset_html,
                asset => $asset_html,
                Size  => length($popup),
                size  => length($popup),
                Type  => 'popup',
                type  => 'popup',
                Blog  => $blog,
                blog  => $blog
            );
        }
    }
    1;
}

sub edit_template_param {
    my $asset = shift;
    my ( $cb, $app, $param, $tmpl ) = @_;

    $param->{image_height} = $asset->image_height;
    $param->{image_width}  = $asset->image_width;
}

sub normalize_orientation {
    my $obj = shift;

    require Image::ExifTool;

    my $exif_tool = new Image::ExifTool;
    my $file_path = $obj->file_path;
    my $fmgr = $obj->blog ? $obj->blog->file_mgr : MT::FileMgr->new('Local');
    my $img_data = $fmgr->get_data( $file_path, 'upload' );

    $exif_tool->ExtractInfo( \$img_data );
    my $o = $exif_tool->GetInfo('Orientation')->{'Orientation'};
    if ( $o && ( $o ne 'Horizontal (normal)' && $o !~ /^Unknown/i ) ) {
        $exif_tool->SetNewValue(
            Orientation => $o,
            DelValue    => 1
        );
        $exif_tool->WriteInfo( \$img_data );

        my $img = MT::Image->new( Data => $img_data, Type => $obj->file_ext );

        my ( $blob, $width, $height ) = do {
            if ( $o eq 'Mirror horizontal' ) {
                $img->flipVertical();
            }
            elsif ( $o eq 'Rotate 180' ) {
                $img->rotate( Degrees => 180 );
            }
            elsif ( $o eq 'Mirror vertical' ) {
                $img->flipHorizontal();
            }
            elsif ( $o eq 'Mirror horizontal and rotate 270 CW' ) {
                $img->flipVertical();
                $img->rotate( Degrees => 270 );
            }
            elsif ( $o eq 'Rotate 90 CW' ) {
                $img->rotate( Degrees => 90 );
            }
            elsif ( $o eq 'Mirror horizontal and rotate 90 CW' ) {
                $img->flipVertical();
                $img->rotate( Degrees => 90 );
            }
            elsif ( $o eq 'Rotate 270 CW' ) {
                $img->rotate( Degrees => 270 );
            }
        };
        $fmgr->put_data( $blob, $file_path, 'upload' );
        $obj->image_width($width);
        $obj->image_height($height);
    }

    1;
}

1;

__END__

=head1 NAME

MT::Asset::Image

=head1 SYNOPSIS

    use MT::Asset::Image;

    # Example

=head1 DESCRIPTION

=head1 METHODS

=head2 MT::Asset::Image->class

Returns 'image', the identifier for this particular class of asset.

=head2 MT::Asset::Image->class_label

Returns the localized descriptive name for this type of asset.

=head2 MT::Asset::Image->extensions

Returns an arrayref of file extensions that are supported by this
package.

=head2 $asset->metadata

Returns a hashref of metadata values for this asset.

=head2 $asset->thumbnail_file(%param)

Creates or retrieves the file path to a thumbnail image appropriate for
the asset. If a thumbnail cannot be created, this routine will return
undef.

=head2 $asset->as_html

Return the HTML I<IMG> element with the image asset attributes.

=head2 $asset->normalize_orientation

Normalize orientation if an image has a "Orientation" in Exif information.

=head1 AUTHOR & COPYRIGHT

Please see the L<MT/"AUTHOR & COPYRIGHT"> for author, copyright, and
license information.

=cut
