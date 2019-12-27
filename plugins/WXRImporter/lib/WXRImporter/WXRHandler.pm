# WXRImporter plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id$

package WXRImporter::WXRHandler;

use strict;
use warnings;
use XML::SAX::Base;
use Time::Local qw( timegm );
use MT;
use MT::Util qw( offset_time_list );

use base qw(XML::SAX::Base);

sub POST_SEPARATOR { '<!--more-->'; }    # WordPress's separator string

sub new {
    my $class   = shift;
    my (%param) = @_;
    my $self    = bless \%param, $class;
    return $self;
}

sub start_document {
    my $self = shift;
    my $data = shift;

    $self->{start}          = 1;
    $self->{basename_limit} = 255;    # max length of the column
    no warnings 'redefine';
    *_decoder = sub { $_[0]; }
        unless $self->{is_pp};

    1;
}

sub _decoder {
    my ($text) = @_;

    # Fix the broken string passed by XML::SAX::PurePerl.
    utf8::downgrade( $text, 1 );
    $text = Encode::decode_utf8($text) if !Encode::is_utf8($text);
    return $text;
}

sub start_element {
    my $self   = shift;
    my $data   = shift;
    my $plugin = MT->component('WXRImporter');

    my $name   = $data->{LocalName};
    my $prefix = $data->{Prefix};
    my $attrs  = $data->{Attributes};
    my $ns     = $data->{NamespaceURI};

    if ( exists $self->{in_wp_comment_content} ) {

  # wordpress's comment content consists of mixed contents (tags and texts)...
        my $element_data = '<' . $data->{Name};
        for my $attr ( keys %$attrs ) {
            $element_data
                .= ' '
                . $attrs->{$attr}->{Name} . '='
                . $attrs->{$attr}->{Value};
        }
        $element_data .= '>';
        $data->{Data} = $element_data;
        $self->characters($data);
        return;
    }

    if ( $self->{start} ) {
        die $plugin->translate("File is not in WXR format.")
            unless ( ( 'rss' eq $name )
            && ( '2.0' eq $attrs->{'{}version'}->{Value} ) )
            ;    ## FIXME: This is checking RSS2.
        $self->{start} = 0;
        $self->{'bucket'} = [];
        return 1;
    }

    my %values
        = map { $attrs->{$_}->{LocalName} => _decoder( $attrs->{$_}->{Value} ) }
        keys(%$attrs);

    $self->{in_wp_comment_content} = 1
        if ( 'wp' eq $prefix ) && ( 'comment_content' eq $name );

    if ( scalar(%values) ) {
        push @{ $self->{'bucket'} },
            { $prefix . '_' . $name => undef, _a => \%values };
    }
    else {
        push @{ $self->{'bucket'} }, $prefix . '_' . $name;
    }
    1;
}

sub characters {
    my $self = shift;
    my $data = shift;

    return
        unless ( $data->{Data} !~ /^\s+$/ )
        || ( exists $self->{in_wp_comment_content} )
        ;    # see if we need to process whitespaces

    my $element = pop @{ $self->{'bucket'} };
    return unless $element;

    my $chars = $data->{Data};
    if ( 'HASH' eq ref($element) ) {
        my @hash_array = grep { $_ ne '_a' } keys %$element;
        return unless $hash_array[0];
        my $val = $element->{ $hash_array[0] };
        $val .= $chars;
        $element->{ $hash_array[0] } = $val;
    }
    elsif ($element) {
        $element = { $element => $chars };
    }
    push @{ $self->{'bucket'} }, $element;
    1;
}

sub end_element {
    my $self = shift;
    my $data = shift;

    my $name   = $data->{LocalName};
    my $prefix = $data->{Prefix};

    if (   ( exists $self->{in_wp_comment_content} )
        && ( 'wp:comment_content' ne $data->{Name} ) )
    {

  # wordpress's comment content consists of mixed contents (tags and texts)...
        my $element_data = '</' . $data->{Name} . '>';
        $data->{Data} = $element_data;
        $self->characters($data);
        return;
    }
    my $element = pop @{ $self->{'bucket'} };
    if ( 'HASH' eq ref($element) ) {
        $element->{ $prefix . '_' . $name }
            = _decoder( $element->{ $prefix . '_' . $name } )
            if exists $element->{ $prefix . '_' . $name };
    }
    push @{ $self->{'bucket'} }, $element;
    my $name_element = $prefix . '_' . $name;

    if ( '_item' eq $name_element ) {
        $self->_create_item($data);
    }
    elsif ( 'wp_postmeta' eq $name_element ) {
        $self->_setup_metadata($data);
    }
    elsif ( 'wp_category' eq $name_element ) {
        $self->_create_category($data);
    }
    elsif ( 'wp_tag' eq $name_element ) {
        $self->_create_tag($data);
    }
    elsif ( 'wp_comment' eq $name_element ) {
        $self->_create_feedback($data);
    }
    elsif ( '_channel' eq $name_element ) {
        $self->_update_blog($data);
    }
    elsif ( 'wp_comment_content' eq $name_element ) {
        delete $self->{in_wp_comment_content};
    }

    1;
}

sub _setup_metadata {
    my $self = shift;
    my $data = shift;

    my $cb   = $self->{callback};
    my $blog = $self->{blog};

    my $meta = {};
    my $current_key;
    my $current_value;
    while ( my $hash = pop @{ $self->{'bucket'} } ) {
        last if 'wp_postmeta' eq $hash;
        next if 'HASH' ne ref $hash;
        my @hash_array = %$hash;
        my $key        = $hash_array[0];
        my $value      = $hash_array[1];
        if ( 'wp_meta_key' eq $key ) {
            $current_key = $value;
        }
        elsif ( 'wp_meta_value' eq $key ) {
            $current_value = $value;
        }
        if ( $current_key && $current_value ) {
            $meta->{$current_key} = $current_value;
            $current_key = $current_value = undef;
        }
    }
    push @{ $self->{'bucket'} }, { 'wp_postmeta' => $meta };
}

sub _update_blog {
    my $self = shift;
    my $data = shift;

    my $cb   = $self->{callback};
    my $blog = $self->{blog};

    while ( my $hash = pop @{ $self->{'bucket'} } ) {
        last if '_channel' eq $hash;
        next if 'HASH' ne ref $hash;
        my @hash_array = %$hash;
        my $key        = $hash_array[0];
        my $value      = $hash_array[1];
        if ( '_description' eq $key ) {
            $blog->description($value) unless $blog->description;

            # Should we do these?
            #        } elsif ('_link' eq $key) {
            #            $blog->site_url($value) unless $blog->site_url;
            #        } elsif ('_title' eq $key) {
            #            $blog->name($value) if 'First Weblog' eq $blog->name;
            #        } elsif ('_language' eq $key) {
            #            $blog->language($value);
        }
    }
    $blog->save;
}

sub _create_category {
    my $self   = shift;
    my $data   = shift;
    my $plugin = MT->component('WXRImporter');

    my $cb   = $self->{callback};
    my $blog = $self->{blog};

    require MT::Category;    ##FIXME: don't directly reference packages
    my $cat = MT::Category->new;

    while ( my $hash = pop @{ $self->{'bucket'} } ) {
        last if 'wp_category' eq $hash;
        next if 'HASH' ne ref $hash;
        my @hash_array = %$hash;
        my $key        = $hash_array[0];
        my $value      = $hash_array[1];
        $cat->blog_id( $blog->id );
        if ( 'wp_category_nicename' eq $key ) {
            my $dash = MT->instance->config('CategoryNameNodash') ? '' : '-';
            my $base = MT::Util::dirify( MT::Util::decode_url($value) )
                || ( "cat" . $dash . $cat->id );
            $base = substr( $base, 0, $self->{basename_limit} );
            $base =~ s/_+$//;
            $base = 'cat' if $base eq '';
            my $i         = 1;
            my $base_copy = $base;
            while (
                MT::Category->count(
                    {   blog_id  => $blog->id,
                        basename => $base
                    }
                )
                )
            {
                $base = $base_copy . '_' . $i++;
            }
            $cat->basename($base);
        }
        elsif ( 'wp_category_parent' eq $key ) {
            my $parent = MT::Category->load(
                {   label           => $value,
                    blog_id         => $self->{blog}->id,
                    category_set_id => 0,
                }
            );
            $cat->parent( $parent->id ) if defined $parent;
        }
        elsif ( 'wp_posts_private' eq $key ) {

            # skip
        }
        elsif ( 'wp_posts_private' eq $key ) {

            # skip
        }
        elsif ( 'wp_cat_name' eq $key ) {
            my $exist = MT::Category->load(
                {   label           => $value,
                    blog_id         => $self->{blog}->id,
                    category_set_id => 0,
                }
            );
            return if $exist;
            $cat->label($value);
        }
        elsif ( 'wp_category_description' eq $key ) {
            $cat->description($value);
        }
    }
    if ( defined $cat ) {
        if ( exists $self->{author} ) {
            $cat->author_id( $self->{author}->id );
        }
        elsif ( exists $self->{parent} ) {
            $cat->author_id( $self->{parent}->id );
        }
        $cb->(
            $plugin->translate(
                "Creating new category ('[_1]')...",
                $cat->label
            )
        );
        if ( $cat->save ) {
            $cb->( $plugin->translate("ok") . "\n" );
        }
        else {
            $cb->( $plugin->translate("failed") . "\n" );
            return die $plugin->translate( "Saving category failed: [_1]",
                $cat->errstr );
        }
    }
}

sub _create_tag {
    my $self   = shift;
    my $data   = shift;
    my $plugin = MT->component('WXRImporter');

    my $cb   = $self->{callback};
    my $blog = $self->{blog};

    require MT::Tag;
    my $tag = MT::Tag->new;
    my $name;
    while ( my $hash = pop @{ $self->{'bucket'} } ) {
        last if 'wp_tag' eq $hash;
        next if 'HASH' ne ref $hash;
        my @hash_array = %$hash;
        my $key        = $hash_array[0];
        my $value      = $hash_array[1];
        if ( 'wp_tag_slug' eq $key ) {
            $name = MT::Util::decode_url($value);
        }
        if ( 'wp_tag_name' eq $key ) {
            $name = $value;
        }
    }
    if ($name) {
        return if ( MT::Tag->load( { name => $name } ) );
        $tag->name($name);
        $cb->(
            $plugin->translate( "Creating new tag ('[_1]')...", $tag->name )
        );
        if ( $tag->save ) {
            $cb->( $plugin->translate("ok") . "\n" );
        }
        else {
            $cb->( $plugin->translate("failed") . "\n" );
            return
                die $plugin->translate( "Saving tag failed: [_1]",
                $tag->errstr );
        }
    }
}

sub _create_feedback {
    my $self = shift;
    my $data = shift;

    my $cb = $self->{callback};

    my $feedback_data = {};
    my $type          = 'comment';

    while ( my $hash = pop @{ $self->{'bucket'} } ) {
        last if 'wp_comment' eq $hash;
        next if 'HASH' ne ref $hash;
        my @hash_array = %$hash;
        my $key        = $hash_array[0];
        my $value      = $hash_array[1];
        if ( 'wp_comment_type' eq $key ) {
            $type = $value;
        }
        else {
            $feedback_data->{$key} = $value;
        }
    }
    push @{ $self->{'bucket'} }, { $type => $feedback_data };
}

sub _create_item {
    my $self = shift;
    my $data = shift;

    my @hashes;
    my $post_type = 'post';    ## TODO: default?
    while ( my $hash = pop @{ $self->{'bucket'} } ) {
        last if '_item' eq $hash;
        next if 'HASH' ne ref $hash;
        $post_type = $hash->{'wp_post_type'}, next
            if exists $hash->{'wp_post_type'};
        push @hashes, $hash if 'HASH' eq ref($hash);
    }

    my $blog = $self->{blog};
    return unless $blog;

    if ( 'post' eq $post_type ) {
        $self->_create_post( 'entry', \@hashes );
    }
    elsif ( 'page' eq $post_type ) {
        $self->_create_post( 'page', \@hashes );
    }
    elsif ( 'attachment' eq $post_type ) {
        $self->_create_asset( \@hashes );
    }
    1;
}

sub _create_asset {
    my $self     = shift;
    my ($hashes) = @_;
    my $plugin   = MT->component('WXRImporter');

    my $blog = $self->{blog};
    my $cb   = $self->{callback};

    my @tags;
    my %meta_hash;
    my $asset_values = { 'blog_id' => $blog->id };
    for my $hash (@$hashes) {
        for my $key ( keys %$hash ) {
            my $value = $hash->{$key};
            if ( '_title' eq $key ) {
                $asset_values->{'label'} = $value;
            }
            elsif ( '_link' eq $key ) {

                # skip
            }
            elsif ( '_pubDate' eq $key ) {

                # skip - we use post_date_gmt;
            }
            elsif ( 'dc_creator' eq $key ) {
                $asset_values->{'created_by'}
                    = $self->_get_author_id( $cb, $value );
            }
            elsif ( '_category' eq $key ) {

                # TODO: is it ok to make it tags?
                push @tags, $value;
            }
            elsif ( '_guid' eq $key ) {
                $asset_values->{'url'} = $value;
            }
            elsif ( '_description' eq $key ) {

                # skip
            }
            elsif ( 'content_encoded' eq $key ) {
                $asset_values->{'description'} = $value;
            }
            elsif ( 'wp_post_id' eq $key ) {

                # skip;
            }
            elsif ( 'wp_post_date' eq $key ) {

                # skip;
            }
            elsif ( 'wp_post_date_gmt' eq $key ) {
                $asset_values->{'created_on'}
                    = $self->_gmt2blogtime( $value, $blog );
            }
            elsif ( 'wp_comment_status' eq $key ) {

                # skip
            }
            elsif ( 'wp_ping_status' eq $key ) {

                # skip
            }
            elsif ( 'wp_post_name' eq $key ) {

                # skip - we don't have an equivalent.
            }
            elsif ( 'wp_status' eq $key ) {

                # skip possible values: inherit,
            }
            elsif ( 'wp_post_parent' eq $key ) {

                # skip - entry association?
            }
            elsif ( 'wp_postmeta' eq $key ) {
                for my $meta_key ( keys %$value ) {
                    if ( '_wp_attached_file' eq $meta_key ) {
                        $asset_values->{'file_path'} = $value->{$meta_key};
                    }
                    elsif ( '_wp_attachment_metadata' eq $meta_key ) {

                        # only parse width and height
                        my $serialized = $value->{$meta_key};
                        if ( $serialized
                            =~ m!s:5:"width";i:(\d+);s:6:"height";i:(\d+);!i )
                        {
                            $asset_values->{'image_width'}  = $1;
                            $asset_values->{'image_height'} = $2;
                        }
                        $meta_hash{$meta_key} = $value->{$meta_key};
                    }
                    else {
                        $meta_hash{$meta_key} = $value->{$meta_key};
                    }
                }
            }
        }
    }

    my $wp_path = $self->{'wp_path'};
    my $mt_path = $self->{'mt_path'};
    if ( not exists $asset_values->{'file_path'} ) {
        $asset_values->{'file_path'} = $asset_values->{'url'};
        $asset_values->{'file_path'} =~ s!^https?://[^/]*/!!;
    }
    my $path = $asset_values->{'file_path'};
    if ( $wp_path && $mt_path ) {
        if ( $path =~ /$wp_path/ ) {
            $path =~ s/^.*$wp_path(.+)$/$mt_path$1/i;
        }
        else {
            $path = File::Spec->catdir( $mt_path, $path );
        }
        $path = File::Spec->canonpath($path);
    }
    $asset_values->{'file_path'} = $path;

    my $mt_url  = $self->{'mt_url'};
    my $url     = $asset_values->{'url'};
    my $old_url = $url;
    if ($mt_url) {
        $url =~ s/^.*$wp_path(.+)$/$mt_url$1/i;
    }
    $asset_values->{'url'} = $url;

    require MT::Asset;

    # Check dupe
    if (MT::Asset->count(
            {   blog_id   => $asset_values->{blog_id},
                label     => $asset_values->{label},
                file_path => $asset_values->{file_path},
            }
        )
        )
    {
        $cb->(
            $plugin->translate(
                "Duplicate asset ('[_1]') found.  Skipping.",
                $asset_values->{label}
            )
        );
        $cb->("\n");
        return 1;
    }
    require File::Basename;
    my $local_basename = File::Basename::basename($path);
    my $ext = ( File::Basename::fileparse( $path, qr/[A-Za-z]+$/ ) )[2];

    $asset_values->{'file_name'} = $local_basename;
    $asset_values->{'file_ext'}  = $ext;

    # Now save the asset.
    my $asset_pkg = MT::Asset->handler_for_file($local_basename);
    my $asset     = $asset_pkg->new();
    my $w         = delete $asset_values->{'image_width'};
    my $h         = delete $asset_values->{'image_height'};
    $asset->set_values($asset_values);
    if ( $h && $w && $asset->can('image_width') ) {
        $asset->image_width($w);
        $asset->image_height($h);
    }
    $cb->( $plugin->translate( "Saving asset ('[_1]')...", $asset->label ) );
    $asset->add_tags(@tags) if 0 < scalar(@tags);
    $cb->(
        $plugin->translate(
            " and asset will be tagged ('[_1]')...",
            join( ',', @tags )
        )
    );
    if ( $asset->save ) {
        $cb->( $plugin->translate( "ok (ID [_1])", $asset->id ) . "\n" );
        if ( exists( $self->{'wp_download'} ) && $self->{'wp_download'} ) {
            _get_item_via_http( $asset->id, $old_url );
        }
    }
    else {
        $cb->( $plugin->translate("failed") . "\n" );
        die $plugin->translate( "Saving entry failed: [_1]", $asset->errstr );
    }
}

sub _create_post {
    my $self = shift;
    my ( $class_type, $hashes ) = @_;
    my $plugin = MT->component('WXRImporter');

    my $blog = $self->{blog};
    my $cb   = $self->{callback};

    my %cat_ids;
    my $primary_cat_id;
    my $feedbacks = {
        'comments'   => [],
        'trackbacks' => [],
    };
    my %meta_hash;
    my @tags;

    my $class = MT->model($class_type);
    require MT::Comment;
    require MT::TBPing;
    require MT::Trackback;

    my $post = $class->new;
    $post->blog_id( $blog->id );
    $post->convert_breaks( $self->{convert_breaks} );
    $post->status( $blog->status_default );
    for my $hash (@$hashes) {
        my @hash_array = grep { $_ ne '_a' } keys %$hash;
        my $key        = $hash_array[0];
        my $value      = $hash->{ $hash_array[0] };
        if ( '_title' eq $key ) {
            $post->title($value);
        }
        elsif ( '_link' eq $key ) {

            # skip;
        }
        elsif ( '_pubDate' eq $key ) {

            # skip - we use post_date_gmt;
        }
        elsif ( 'dc_creator' eq $key ) {
            $post->author_id( $self->_get_author_id( $cb, $value ) );
        }
        elsif ( '_category' eq $key ) {
            if ( $hash->{_a} ) {
                if (   $hash->{_a}->{domain} eq 'tag'
                    || $hash->{_a}->{domain} eq 'post_tag' )
                {
                    $value = MT::Util::decode_url( $hash->{_a}->{nicename} )
                        if !$value;
                    push @tags, $value if $value;
                }
                elsif ( $hash->{_a}->{domain} eq 'category' ) {
                    my $cat_class = MT->model('category');
                    $value = MT::Util::decode_url( $hash->{_a}->{nicename} )
                        if !$value;
                    my $cat = $cat_class->load(
                        {   label           => $value,
                            blog_id         => $self->{blog}->id,
                            category_set_id => 0,
                        }
                    );
                    if ( defined $cat ) {
                        $cat_ids{ $cat->id } = 1;
                        $primary_cat_id = $cat->id unless $primary_cat_id;
                    }
                }
            }
            else {

                # previous category definition
                my $cat_class = MT->model(
                    $class_type eq 'entry' ? 'category' : 'folder' );
                my $cat = $cat_class->load(
                    {   label           => $value,
                        blog_id         => $self->{blog}->id,
                        category_set_id => 0,
                    }
                );
                if ( defined $cat ) {
                    $cat_ids{ $cat->id } = 1;
                    $primary_cat_id = $cat->id unless $primary_cat_id;
                }
            }
        }
        elsif ( '_guid' eq $key ) {

            # skip;
        }
        elsif ( '_description' eq $key ) {

            # skip;
        }
        elsif ( 'content_encoded' eq $key ) {
            my $pos = index $value, POST_SEPARATOR();
            if ( -1 == $pos ) {
                $post->text($value);
            }
            else {
                $post->text( substr $value, 0, $pos );
                $post->text_more( substr $value,
                    $pos + length( POST_SEPARATOR() ) );
            }
        }
        elsif ( 'wp_post_id' eq $key ) {

            # skip;
        }
        elsif ( 'wp_post_date' eq $key ) {

            # skip;
        }
        elsif ( 'wp_post_date_gmt' eq $key ) {
            $post->authored_on( $self->_gmt2blogtime( $value, $blog ) );
        }
        elsif ( 'wp_comment_status' eq $key ) {
            $post->allow_comments( 'open' eq $value ? 1 : 0 );
        }
        elsif ( 'wp_ping_status' eq $key ) {
            $post->allow_pings( 'open' eq $value ? 1 : 0 );
        }
        elsif ( 'wp_post_name' eq $key ) {
            my $base = MT::Util::decode_url($value);
            $base = MT::Util::dirify($base) if $base ne $value;
            $base = substr( $base, 0, $self->{basename_limit} );
            $base =~ s/_+$//;
            $base = 'post' if $base eq '';
            my $i         = 1;
            my $base_copy = $base;
            while (
                $class->count(
                    {   blog_id  => $blog->id,
                        basename => $base
                    }
                )
                )
            {
                $base = $base_copy . '_' . $i++;
            }
            $post->basename($base);
        }
        elsif ( 'wp_status' eq $key ) {
            $post->status( MT::Entry::HOLD() ) unless 'publish' eq $value;
            $post->status( MT::Entry::RELEASE() ) if 'publish' eq $value;
        }
        elsif ( 'wp_post_parent' eq $key ) {

            # skip;
        }
        elsif ( 'wp_postmeta' eq $key ) {
            for my $meta_key ( keys %$value ) {
                $meta_hash{$meta_key} = $value->{$meta_key};
            }

            # TODO: how we should handle metadata is to be decided later
        }
        elsif ( 'comment' eq $key ) {
            my $cmt = MT::Comment->new;
            $cmt->blog_id( $blog->id );
            $cmt->author( $value->{'wp_comment_author'} )
                if exists $value->{'wp_comment_author'};
            $cmt->email( $value->{'wp_comment_author_email'} )
                if exists $value->{'wp_comment_author_email'};
            $cmt->url( $value->{'wp_comment_author_url'} )
                if exists $value->{'wp_comment_author_url'};
            $cmt->ip( $value->{'wp_comment_author_IP'} )
                if exists $value->{'wp_comment_author_IP'};
            my $date = $value->{'wp_comment_date_gmt'};
            $cmt->created_on( $self->_gmt2blogtime( $date, $blog ) );
            $cmt->text( $value->{'wp_comment_content'} )
                if exists $value->{'wp_comment_content'};
            my $status = $value->{'wp_comment_approved'};

            if ( $status eq '1' ) {
                $cmt->approve;
            }
            elsif ( 'spam' eq $status ) {
                $cmt->junk;
            }

            # skip wp:comment_id
            # skip wp:comment_parent
            push @{ $feedbacks->{comments} }, $cmt;
        }
        elsif ( ( 'trackback' eq $key ) || ( 'pingback' eq $key ) ) {

            # TODO: are trackback and pingback the same in its data structure?
            my $ping = MT::TBPing->new;
            $ping->blog_id( $blog->id );
            $ping->blog_name( $value->{'wp_comment_author'} )
                if exists $value->{'wp_comment_author'};
            $ping->source_url( $value->{'wp_comment_author_url'} )
                if exists $value->{'wp_comment_author_url'};
            $ping->ip( $value->{'wp_comment_author_IP'} )
                if exists $value->{'wp_comment_author_IP'};
            my $date = $value->{'wp_comment_date_gmt'};
            $ping->created_on( $self->_gmt2blogtime( $date, $blog ) );

            if ( exists $value->{'wp_comment_content'} ) {
                my $content = $value->{'wp_comment_content'};
                if ( $content =~ m!^<strong>(.+)</strong>\n*(.+)$!m ) {

 # this is exactly how wordpress stores trackbacks in its database as of v2.1.
                    $ping->title($1);
                    $ping->excerpt($2);
                }
            }
            my $status = $value->{'wp_comment_approved'};
            if ( $status eq '1' ) {
                $ping->approve;
            }
            elsif ( 'spam' eq $status ) {
                $ping->junk;
            }
            push @{ $feedbacks->{trackbacks} }, $ping;
        }
    }

    # Check dupe
    if ($class->count(
            {   class       => $class_type,
                blog_id     => $post->blog_id,
                title       => $post->title,
                authored_on => $post->authored_on
            }
        )
        )
    {
        $cb->(
            $plugin->translate(
                "Duplicate entry ('[_1]') found.  Skipping.",
                $post->title
            )
        );
        $cb->("\n");
        return 1;
    }

    # Associate tags to the entry.
    if (@tags) {
        $post->set_tags(@tags);
    }

    # Now save the entry/page.
    if ( 'entry' eq $class_type ) {
        $cb->(
            $plugin->translate( "Saving entry ('[_1]')...", $post->title ) );
    }
    elsif ( 'page' eq $class_type ) {
        $cb->(
            $plugin->translate( "Saving page ('[_1]')...", $post->title ) );
    }
    if ( $post->save ) {
        $cb->( $plugin->translate( "ok (ID [_1])", $post->id ) . "\n" );
    }
    else {
        $cb->( $plugin->translate("failed") . "\n" );
        die $plugin->translate( "Save failed: [_1]", $post->errstr );
    }

    # Associate the entry to categories.
    $primary_cat_id = $self->{def_cat_id} unless $primary_cat_id;
    if ($primary_cat_id) {
        my $place = MT::Placement->new;
        $place->is_primary(1);
        $place->entry_id( $post->id );
        $place->blog_id( $self->{blog}->id );
        $place->category_id($primary_cat_id);
        $place->save
            or die $plugin->translate( "Saving placement failed: [_1]",
            $place->errstr );
        delete $cat_ids{$primary_cat_id};
    }

    for my $cat_id ( keys %cat_ids ) {
        my $place = MT::Placement->new;
        $place->is_primary(0);
        $place->entry_id( $post->id );
        $place->blog_id( $self->{blog}->id );
        $place->category_id($cat_id);
        $place->save
            or die $plugin->translate( "Saving placement failed: [_1]",
            $place->errstr );
    }

    # Associate comments to the entry.
    for my $comment ( @{ $feedbacks->{comments} } ) {
        $comment->entry_id( $post->id );
        $cb->(
            $plugin->translate(
                "Creating new comment (from '[_1]')...",
                $comment->author
            )
        );
        if ( $comment->save ) {
            $cb->(
                $plugin->translate( "ok (ID [_1])", $comment->id ) . "\n" );
        }
        else {
            $cb->( $plugin->translate("failed") . "\n" );
            die $plugin->translate( "Saving comment failed: [_1]",
                $comment->errstr );
        }
    }

    # Associate trackbacks to the entry.
    if ( scalar @{ $feedbacks->{trackbacks} } ) {
        my $tb = $post->trackback;
        unless ($tb) {
            $tb = MT::Trackback->new;
            $tb->blog_id( $post->blog_id );
            $tb->entry_id( $post->id );
            $tb->category_id(0);    ## category_id can't be NULL
        }
        $tb->title( $post->title );
        $tb->description( $post->get_excerpt );
        $tb->url( $post->permalink );
        $tb->is_disabled( $post->allow_pings );
        $tb->save;
        unless ($tb) {
            die $plugin->translate("Entry has no MT::Trackback object!");
        }
        $post->trackback($tb);
        for my $ping ( @{ $feedbacks->{trackbacks} } ) {
            $ping->tb_id( $tb->id );
            $cb->(
                $plugin->translate(
                    "Creating new ping ('[_1]')...",
                    $ping->title
                )
            );
            if ( $ping->save ) {
                $cb->(
                    $plugin->translate( "ok (ID [_1])", $ping->id ) . "\n" );
            }
            else {
                $cb->( $plugin->translate("failed") . "\n" );
                die $plugin->translate( "Saving ping failed: [_1]",
                    $ping->errstr );
            }
        }
    }
    1;
}

sub _get_author_id {
    my $self = shift;
    my ( $cb, $value ) = @_;
    my $plugin = MT->component('WXRImporter');

    my $author = $self->{author};
    unless ($author) {
        require MT::BasicAuthor;
        $author = MT::BasicAuthor->load( { name => $value } );
        unless ( defined $author ) {
            my $parent_author = $self->{parent};
            my $pass          = $self->{pass};
            $author = MT::Author->new;
            $author->created_by( $parent_author->id )
                if defined $parent_author;
            $author->name($value);
            $author->email('');
            $author->type( MT::Author::AUTHOR() );
            if ($pass) {
                $author->set_password($pass);
            }
            else {
                $author->password('(none)');
            }
            $cb->(
                $plugin->translate( "Creating new user ('[_1]')...", $value )
            );
            if ( $author->save ) {
                $cb->( $plugin->translate("ok") . "\n" );
            }
            else {
                $cb->( $plugin->translate("failed") . "\n" );
                die $plugin->translate( "Saving user failed: [_1]",
                    $author->errstr );
            }
            $cb->(
                $plugin->translate("Assigning permissions for new user...") );
            require MT::Role;
            require MT::Association;
            my $role = MT::Role->load_by_permission('post');
            if ($role) {
                my $assoc;
                if ($assoc = MT::Association->link(
                        $author => $role => $self->{blog}
                    )
                    )
                {
                    $cb->( $plugin->translate("ok") . "\n" );
                }
                else {
                    $cb->( $plugin->translate("failed") . "\n" );
                    die $plugin->translate( "Saving permission failed: [_1]",
                        $assoc->errstr );
                }
            }
        }
    }
    defined $author ? $author->id : undef;
}

sub _gmt2blogtime {
    my $self = shift;
    my ( $datetime, $blog ) = @_;
    if ( $datetime =~ /^(\d{4})-?(\d{2})-?(\d{2})\s?(\d{2}):(\d{2}):(\d{2})/ )
    {
        my ( $y, $mo, $d, $h, $m, $s )
            = ( $1, $2 || 1, $3 || 1, $4 || 0, $5 || 0, $6 || 0 );
        my $time = eval { timegm( $s, $m, $h, $d, $mo - 1, $y ); }
            or return undef;
        ( $s, $m, $h, $d, $mo, $y ) = offset_time_list( $time, $blog );
        $y += 1900;
        $mo++;
        return sprintf "%04d%02d%02d%02d%02d%02d", $y, $mo, $d, $h, $m, $s;
    }
    return undef;
}

sub _get_item_via_http {
    my ( $asset_id, $url ) = @_;

    require MT::TheSchwartz;
    require TheSchwartz::Job;
    my $job = TheSchwartz::Job->new();
    $job->funcname('WXRImporter::Worker::Downloader');
    $job->uniqkey($asset_id);
    $job->arg( { old_url => $url } );
    $job->coalesce( $$ . ':' . ( time - ( time % 100 ) ) );
    MT::TheSchwartz->insert($job);
}

1;
