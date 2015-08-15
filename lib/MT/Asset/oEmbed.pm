# Movable Type (r) (C) 2001-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Asset::oEmbed;

use strict;
use base qw( MT::Asset );

use Symbol;
use URI::Escape;
use POSIX qw( floor );

__PACKAGE__->install_properties(
    {   class_type    => 'oembed',
        provider_type => 'oembed',
        column_defs   => {
            'original_file_url'      => 'vclob meta',
            'type'                   => 'vchar meta',
            'version'                => 'vchar meta',
            'title'                  => 'vchar meta',
            'author_name'            => 'vchar meta',
            'author_url'             => 'vclob meta',
            'provider_name'          => 'vchar meta',
            'provider_url'           => 'vclob meta',
            'cache_age'              => 'integer meta',
            'embed_thumbnail_url'    => 'vclob meta',
            'embed_thumbnail_width'  => 'integer meta',
            'embed_thumbnail_height' => 'integer meta',
        },
        child_of => [ 'MT::Blog', 'MT::Website', ],
    }
);

sub can_handle {
    my ( $pkg, $url ) = @_;

    my $url_schemes = $pkg->properties->{url_schemes} || [];
    foreach my $regex (@$url_schemes) {
        return 1 if ( $url =~ /$regex/ );
    }
    return 0;
}

sub get_oembed {
    my $asset = shift;
    my ( $url, $maxwidth, $maxheight ) = @_;

    my $token = $asset->get_token_data();
    return $asset->error( MT->translate("Token data is not registered.") )
        unless $token;

    $url = $url || $asset->url();
    return undef unless $url;

    $asset->url($url) unless $asset->url();

    $url = Encode::encode_utf8($url) unless Encode::is_utf8($url);

    my $endpoint = $asset->properties->{endpoint};
    my $uri      = URI->new($endpoint);
    my $query    = {};
    $query->{url}       = $url;
    $query->{maxwidth}  = $maxwidth if $maxwidth;
    $query->{maxheight} = $maxheight if $maxheight;
    $query->{format}    = 'json';
    $uri->query_form($query);

    my $ua = MT->new_ua();
    $ua->agent( 'MovableType/' . MT->version_id );
    $ua->ssl_opts( verify_hostname => 0 );
    my $res = $ua->get( $uri->as_string );

    if ( $res->is_success ) {
        require JSON;
        my $json = JSON::from_json( $res->content() );

        return $asset->error(
            MT->translate(
                'oEmbed error: "type" parameter is "link". Perhaps it is not "Public".'
            )
        ) if $json->{type} eq 'link';

        for my $k (
            qw( type version author_name author_url provider_name provider_url cache_age )
            )
        {
            my $item = delete $json->{$k};
            $asset->$k($item) if $item;
        }
        for my $k (qw( thumbnail_url thumbnail_width thumbnail_height )) {
            my $item = delete $json->{$k};
            if ($item) {
                my $method = "embed_$k";
                $asset->$method($item) if $item;
            }
        }
        my $title = delete $json->{title};
        $asset->label($title);
        $asset->original_file_url( $asset->get_original_file_url($json) );
        if ( $asset->errstr ) {
            return $asset->error(
                MT->translate( "Get file url error: [_1]", $asset->errstr ) );
        }

        my $file_size = $asset->get_file_size;
        return $asset->error( MT->translate("file_size could not be got.") )
            unless $file_size;
        $asset->file_size($file_size);

        foreach my $k ( keys(%$json) ) {
            $asset->$k( $json->{$k} ) if $json->{$k};
        }
    }
    else {
        return $asset->error(
            MT->translate( "Error embed: [_1]", $res->content ) );
    }
    return $asset;
}

sub url_schemes { [] }

sub thumbnail_path {
    my $asset = shift;
    my (%param) = @_;

    $asset->embed_thumbnail_url();
}

sub thumbnail_file {
    my $asset = shift;
    my (%param) = @_;
    my $fmgr;
    my $blog = $param{Blog} || $asset->blog;

    require MT::FileMgr;
    $fmgr ||= $blog ? $blog->file_mgr : MT::FileMgr->new('Local');
    return undef unless $fmgr;

    my $file_path = $asset->original_file_url || $asset->embed_thumbnail_url;
    return undef unless $file_path;

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
    if ( $fmgr->exists($thumbnail) ) {
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

    # download original image
    my $orig_img = $asset->_download_image_data();
    return undef unless $orig_img && $fmgr->file_size($orig_img);

    my $data;
    if (   ( $n_w == $i_w )
        && ( $n_h == $i_h )
        && !$param{Square}
        && !$param{Type} )
    {
        $data = $fmgr->get_data( $orig_img, 'upload' );
    }
    else {

        # create a thumbnail for this file
        require MT::Image;
        my $img = new MT::Image( Filename => $orig_img )
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
    $fmgr->delete($orig_img);
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
        $n_w = floor( ( $i_w * $h / $i_h ) + 0.5 );
    }
    elsif ( $scale eq 'w' ) {

        # scale by width
        $n_w = $w;
        $n_h = floor( ( $i_h * $w / $i_w ) + 0.5 );
    }
    $n_h = 1 unless $n_h;
    $n_w = 1 unless $n_w;

    return ( $n_h, $n_w, $scale );
}

sub thumbnail_filename {
    my $asset = shift;
    my (%param) = @_;
    my ( $file, $ext ) = $asset->thumbnail_basename;

    require MT::Util;
    my $format = $param{Format} || MT->translate('%f-thumb-%wx%h-%i%x');
    my $width  = $param{Width}  || 'auto';
    my $height = $param{Height} || 'auto';
    $file =~ s/\.\w+$//;
    my $base = File::Basename::basename($file);
    my $id   = $asset->id;
    $ext = '.' . $ext;
    $format =~ s/%w/$width/g;
    $format =~ s/%h/$height/g;
    $format =~ s/%f/$base/g;
    $format =~ s/%i/$id/g;
    $format =~ s/%x/$ext/g;
    return $format;
}

sub _download_image_data {
    my $asset = shift;
    my $url
        = $asset->type eq 'photo'
        ? $asset->original_file_url
        : $asset->embed_thumbnail_url;

    return unless $url;

    my $ua = MT->new_ua(
        {   agent    => 'MovableType/' . MT->version_id,
            max_size => 10_000_000,
        }
    );
    $ua->ssl_opts( verify_hostname => 0 );

    my $req = HTTP::Request->new( 'GET', $url );
    my $res = $ua->request($req);

    if ( $res->is_success ) {
        require File::Temp;
        my $tmp_dir = MT->config('TempDir');
        my ( $tmp_fh, $tmp_file ) = File::Temp::tempfile( DIR => $tmp_dir );

        binmode $tmp_fh;
        print $tmp_fh $res->content;
        close $tmp_fh;

        return $tmp_file;
    }
    else {
        return $asset->error(
            MT->translate( "Error download: [_1]", $res->content ) );
    }
}

sub as_html {
    my $asset = shift;
    my ($param) = @_;

    $asset->html;
}

sub get_original_file_url {
    my $asset = shift;
    my ($json) = @_;
    return $json->{url} || $asset->embed_thumbnail_url;
}

sub get_file_size {
    0;
}

sub get_token_data {
    undef;
}

sub thumbnail_basename {
    my $asset = shift;

    require Digest::MD5;
    my $file = Digest::MD5::md5_hex( $asset->url );

    my $ext
        = $asset->embed_thumbnail_url =~ /.*\/.*\.(\w+)$/
        ? $1
        : '';

    return ( $file, $ext );
}

1;
