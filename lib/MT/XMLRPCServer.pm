# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::XMLRPCServer::Util;
use strict;
use warnings;
use Time::Local qw( timegm );
use MT;
use MT::Util qw( offset_time_list );

sub mt_new {
    my $cfg
        = MT::Util::is_mod_perl1()
        ? Apache->request->dir_config('MTConfig')
        : ( $ENV{MT_CONFIG} || $MT::XMLRPCServer::MT_DIR . '/mt-config.cgi' );
    my $mt = MT->new( Config => $cfg )
        or die MT::XMLRPCServer::_fault( MT->errstr );

    ## Initialize the MT::Request singleton for this particular request.
    $mt->request->reset();

    $mt->config( 'DeleteFilesAfterRebuild', 0, 0 );

    # we need to be UTF-8 here no matter which PublishCharset
    $mt->run_callbacks( 'init_app', $mt, { App => 'xmlrpc' } );
    $mt;
}

sub iso2ts {
    my ( $blog, $iso ) = @_;
    die MT::XMLRPCServer::_fault( MT->translate("Invalid timestamp format") )
        unless $iso
        =~ /^(\d{4})(?:-?(\d{2})(?:-?(\d\d?)(?:T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?(Z|[+-]\d{2}:\d{2})?)?)?)?/;
    my ( $y, $mo, $d, $h, $m, $s, $offset )
        = ( $1, $2 || 1, $3 || 1, $4 || 0, $5 || 0, $6 || 0, $7 );
    if ( $offset && !MT->config->IgnoreISOTimezones ) {
        $mo--;
        $y -= 1900;
        my $time = timegm( $s, $m, $h, $d, $mo, $y );
        ## If it's not already in UTC, first convert to UTC.
        if ( $offset ne 'Z' ) {
            my ( $sign, $h, $m ) = $offset =~ /([+-])(\d{2}):(\d{2})/;
            $offset = $h * 3600 + $m * 60;
            $offset *= -1 if $sign eq '-';
            $time -= $offset;
        }
        ## Now apply the offset for this weblog.
        ( $s, $m, $h, $d, $mo, $y ) = offset_time_list( $time, $blog );
        $mo++;
        $y += 1900;
    }
    sprintf "%04d%02d%02d%02d%02d%02d", $y, $mo, $d, $h, $m, $s;
}

sub ts2iso {
    my ( $blog, $ts ) = @_;
    my ( $yr, $mo, $dy, $hr, $mn, $sc ) = unpack( 'A4A2A2A2A2A2A2', $ts );
    $ts = timegm( $sc, $mn, $hr, $dy, $mo, $yr );
    ( $sc, $mn, $hr, $dy, $mo, $yr ) = offset_time_list( $ts, $blog, '-' );
    $yr += 1900;
    sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $yr, $mo, $dy, $hr, $mn, $sc );
}

package MT::XMLRPCServer;
use strict;

use MT;
use MT::Util
    qw( first_n_words decode_html start_background_task archive_file_for );
use base qw( MT::ErrorHandler );

our $MT_DIR;

my ($HAVE_XML_PARSER);

BEGIN {
    eval { require XML::Parser };
    $HAVE_XML_PARSER = $@ ? 0 : 1;
}

sub _validate_params {
    my ($params) = @_;

    foreach my $p (@$params) {
        die _fault( MT->translate("Invalid parameter") )
            if ( 'ARRAY' eq ref $p )
            or ( 'HASH' eq ref $p );
    }

    return 1;
}

sub _fault {
    my $mt  = MT::XMLRPCServer::Util::mt_new();
    my $enc = $mt->config('PublishCharset');
    SOAP::Fault->faultcode(1)
        ->faultstring( SOAP::Data->type( string => $_[0] || '' ) );
}

## This is sort of a hack. XML::Parser automatically makes everything
## UTF-8, and that is causing severe problems with the serialization
## of database records (what happens is this: we construct a string
## consisting of pack('N', length($string)) . $string. If the $string SV
## is flagged as UTF-8, the packed length is then upgraded to UTF-8,
## which turns characters with values greater than 128 into two bytes,
## like v194.129. And so on. This is obviously now what we want, because
## pack produces a series of bytes, not a string that should be mucked
## about with.)
##
## The following subroutine strips the UTF8 flag from a string, thus
## forcing it into a series of bytes. "pack 'C0'" is a magic way of
## forcing the following string to be packed as bytes, not as UTF8.

sub no_utf8 {
    for (@_) {
        next if ref;
        $_ = pack 'C0A*', $_;
    }
}

## SOAP::Lite 0.7 or above, expects string with UTF8 flag for response data.
sub _encode_text_for_soap {
    if ( $] > 5.007 ) {
        require Encode;
        return Encode::decode( 'utf-8', encode_text(@_) );
    }
    else {
        return encode_text(@_);
    }
}

sub _make_token {
    my @alpha = ( 'a' .. 'z', 'A' .. 'Z', 0 .. 9 );
    my $token = join '', map $alpha[ rand @alpha ], 1 .. 40;
    $token;
}

sub _login {
    my $class = shift;
    my ( $user, $pass, $blog_id ) = @_;

    my $mt  = MT::XMLRPCServer::Util::mt_new();
    my $enc = $mt->config('PublishCharset');
    require MT::Author;
    my $author = MT::Author->load( { name => $user, type => 1 } ) or return;
    die _fault(
        MT->translate(
            "No web services password assigned.  Please see your user profile to set it."
        )
    ) unless $author->api_password;
    die _fault(
        MT->translate("Failed login attempt by disabled user '[_1]'") )
        unless $author->is_active;
    my $auth = $author->api_password eq $pass;
    $auth ||= crypt( $pass, $author->api_password ) eq $author->api_password;
    return unless $auth;
    return $author unless $blog_id;
    require MT::Permission;
    my $perms = MT::Permission->load(
        {   author_id => $author->id,
            blog_id   => $blog_id
        }
    );

    ( $author, $perms );
}

sub _publish {
    my $class = shift;
    my ( $mt, $entry, $no_ping, $old_categories ) = @_;
    require MT::Blog;
    my $blog = MT::Blog->load( $entry->blog_id );
    $mt->rebuild_entry(
        Entry => $entry,
        Blog  => $blog,
        (   $old_categories
            ? ( OldCategories => join(
                    ',', map { ref $_ ? $_->id : $_ } @$old_categories
                )
                )
            : ()
        ),
        BuildDependencies => 1
    ) or return $class->error( "Publish error: " . $mt->errstr );
    if ( $entry->status == MT::Entry::RELEASE() && !$no_ping ) {
        $mt->ping_and_save( Blog => $blog, Entry => $entry )
            or return $class->error( "Ping error: " . $mt->errstr );
    }
    1;
}

sub _apply_basename {
    my $class = shift;
    my ( $entry, $item, $param ) = @_;

    my $basename = $item->{mt_basename} || $item->{wp_slug};
    if ( $param->{page} && $item->{permaLink} ) {
        local $entry->{column_values}->{basename} = '##s##';
        my $real_url = $entry->archive_url();
        my ( $pre, $post ) = split /##s##/, $real_url, 2;

        my $req_url = $item->{permaLink};
        if ( $req_url =~ m{ \A \Q$pre\E (.*) \Q$post\E \z }xms ) {
            my $req_base = $1;
            my @folders = split /\//, $req_base;
            $basename = pop @folders;
            $param->{__permaLink_folders} = \@folders;
        }
        else {
            die _fault(
                MT->translate(
                    "Requested permalink '[_1]' is not available for this page",
                    $req_url
                )
            );
        }
    }

    if ( defined $basename ) {

        # Ensure this basename is unique.
        my $entry_class   = ref $entry;
        my $basename_uses = $entry_class->exist(
            {   blog_id  => $entry->blog_id,
                basename => $basename,
                (   $entry->id
                    ? ( id => { op => '!=', value => $entry->id } )
                    : ()
                ),
            }
        );
        if ($basename_uses) {
            $basename = MT::Util::make_unique_basename($entry);
        }

        $entry->basename($basename);
    }

    1;
}

sub _save_placements {
    my $class = shift;
    my ( $entry, $item, $param ) = @_;

    my @categories;
    my $changed = 0;

    if ( $param->{page} ) {
        if ( my $folders = $param->{__permaLink_folders} ) {
            my $parent_id = 0;
            my $folder;
            require MT::Folder;
            for my $basename (@$folders) {
                $folder = MT::Folder->load(
                    {   blog_id         => $entry->blog_id,
                        parent          => $parent_id,
                        basename        => $basename,
                        category_set_id => 0,
                    }
                );

                if ( !$folder ) {

                    # Autovivify the folder tree.
                    $folder = MT::Folder->new;
                    $folder->blog_id( $entry->blog_id );
                    $folder->parent($parent_id);
                    $folder->basename($basename);
                    $folder->label($basename);
                    $changed = 1;
                    $folder->save
                        or die _fault(
                        MT->translate(
                            "Saving folder failed: [_1]",
                            $folder->errstr
                        )
                        );
                }

                $parent_id = $folder->id;
            }
            @categories = ($folder) if $folder;
        }
    }
    elsif ( my $cats = $item->{categories} ) {
        if (@$cats) {
            my $cat_class = MT->model('category');

            # The spec says to ignore invalid category names.
            @categories = grep {defined} $cat_class->search(
                {   blog_id         => $entry->blog_id,
                    label           => $cats,
                    category_set_id => 0,
                }
            );
        }
    }

    require MT::Placement;
    my $is_primary_placement = 1;
CATEGORY: for my $category (@categories) {
        my $place;
        if ($is_primary_placement) {
            $place = MT::Placement->load(
                { entry_id => $entry->id, is_primary => 1, } );
        }
        if ( !$place ) {
            $place = MT::Placement->new;
            $place->blog_id( $entry->blog_id );
            $place->entry_id( $entry->id );
            $place->is_primary( $is_primary_placement ? 1 : 0 );
        }
        $place->category_id( $category->id );
        $place->save
            or die _fault(
            MT->translate( "Saving placement failed: [_1]", $place->errstr )
            );

        if ($is_primary_placement) {

            # Delete all the secondary placements, so each of the remaining
            # iterations of the loop make a brand new placement.
            my @old_places = MT::Placement->load(
                { entry_id => $entry->id, is_primary => 0, } );
            for my $place (@old_places) {
                $place->remove;
            }
        }

        $is_primary_placement = 0;
    }

    $changed;
}

sub _new_entry {
    my $class = shift;
    my %param = @_;
    my ( $blog_id, $user, $pass, $item, $publish )
        = @param{qw( blog_id user pass item publish )};

    _validate_params( [ $blog_id, $user, $pass, $publish ] ) or return;
    my $values;
    foreach my $k ( keys %$item ) {
        if ( 'categories' eq $k || 'mt_tb_ping_urls' eq $k ) {

            # XMLRPC supports categories array and mt_tb_ping_urls array
            _validate_params( \@{ $item->{$k} } ) or return;
        }
        else {
            push @$values, $item->{$k};
        }
    }
    _validate_params( \@$values ) or return;

    my $obj_type = $param{page} ? 'page' : 'entry';
    die _fault( MT->translate("No blog_id") ) unless $blog_id;
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    for my $f (
        qw( title description mt_text_more
        mt_excerpt mt_keywords mt_tags mt_basename wp_slug )
        )
    {
        next unless defined $item->{$f};
        my $enc = $mt->{cfg}->PublishCharset;
        unless ($HAVE_XML_PARSER) {
            $item->{$f} = decode_html( $item->{$f} );
        }
    }
    require MT::Blog;
    my $blog
        = MT::Blog->load( { id => $blog_id, class => [ 'blog', 'website' ] } )
        or die _fault( MT->translate( "Invalid blog ID '[_1]'", $blog_id ) );
    my ( $author, $perms ) = $class->_login( $user, $pass, $blog_id );
    die _fault( MT->translate("Invalid login") ) unless $author;
    die _fault( MT->translate("Permission denied.") )
        if !$author->is_superuser
        && ( !$perms
        || !$perms->can_do('create_new_entry_via_xmlrpc_server') );
    my $entry      = MT->model($obj_type)->new;
    my $orig_entry = $entry->clone;
    $entry->blog_id($blog_id);
    $entry->author_id( $author->id );

    ## In 2.1 we changed the behavior of the $publish flag. Previously,
    ## it was used to determine the post status. That was a bad idea.
    ## So now entries added through XML-RPC are always set to publish,
    ## *unless* the user has set "NoPublishMeansDraft 1" in mt.cfg, which
    ## enables the old behavior.
    if ( $mt->{cfg}->NoPublishMeansDraft ) {
        $entry->status(
            $publish && ( $author->is_superuser
                || $perms->can_do('publish_new_post_via_xmlrpc_server') )
            ? MT::Entry::RELEASE()
            : MT::Entry::HOLD()
        );
    }
    else {
        $entry->status(
            (          $author->is_superuser
                    || $perms->can_do('publish_new_post_via_xmlrpc_server')
            ) ? MT::Entry::RELEASE() : MT::Entry::HOLD()
        );
    }
    $entry->allow_comments( $blog->allow_comments_default );
    $entry->allow_pings( $blog->allow_pings_default );
    $entry->convert_breaks(
        defined $item->{mt_convert_breaks}
        ? $item->{mt_convert_breaks}
        : $blog->convert_paras
    );
    $entry->allow_comments( $item->{mt_allow_comments} )
        if exists $item->{mt_allow_comments};
    $entry->title( $item->{title} ) if exists $item->{title};

    $class->_apply_basename( $entry, $item, \%param );

    $entry->text( $item->{description} );
    for my $field (qw( allow_pings )) {
        my $val = $item->{"mt_$field"};
        next unless defined $val;
        die _fault(
            MT->translate(
                "Value for 'mt_[_1]' must be either 0 or 1 (was '[_2]')",
                $field, $val
            )
        ) unless $val == 0 || $val == 1;
        $entry->$field($val);
    }
    $entry->excerpt( $item->{mt_excerpt} )     if $item->{mt_excerpt};
    $entry->text_more( $item->{mt_text_more} ) if $item->{mt_text_more};
    $entry->keywords( $item->{mt_keywords} )   if $item->{mt_keywords};
    $entry->created_by( $author->id );

    if ( my $tags = $item->{mt_tags} ) {
        require MT::Tag;
        my $tag_delim = chr( $author->entry_prefs->{tag_delim} );
        my @tags = MT::Tag->split( $tag_delim, $tags );
        $entry->set_tags(@tags);
    }
    if ( my $urls = $item->{mt_tb_ping_urls} ) {
        $entry->to_ping_urls( join "\n", @$urls );
    }
    if ( my $iso = $item->{dateCreated} ) {
        $entry->authored_on( MT::XMLRPCServer::Util::iso2ts( $blog, $iso ) )
            || die MT::XMLRPCServer::_fault(
            MT->translate("Invalid timestamp format") );
        require MT::DateTime;
        $entry->status( MT::Entry::FUTURE() )
            if ( $entry->status == MT::Entry::RELEASE() )
            && (
            MT::DateTime->compare(
                blog => $blog,
                a    => $entry->authored_on,
                b    => { value => time(), type => 'epoch' }
            ) > 0
            );
    }
    $entry->discover_tb_from_entry() if MT->has_plugin('Trackback');

    MT->run_callbacks( "api_pre_save.$obj_type", $mt, $entry, $orig_entry )
        || die MT::XMLRPCServer::_fault(
        MT->translate( "PreSave failed [_1]", MT->errstr ) );

    $entry->save;

    # Clear cache for site stats dashboard widget.
    require MT::Util;
    MT::Util::clear_site_stats_widget_cache( $entry->blog_id )
        or die MT::XMLRPCServer::_fault(
        MT->translate('Removing stats cache failed.') );

    my $changed = $class->_save_placements( $entry, $item, \%param );

    my @types = ($obj_type);
    if ($changed) {
        push @types, 'folder';    # folders are the only type that can be
                                  # created in _save_placements
    }
    $blog->touch(@types);
    $blog->save;

    MT->run_callbacks( "api_post_save.$obj_type", $mt, $entry, $orig_entry );

    require MT::Log;
    $mt->log(
        {   message => $mt->translate(
                "User '[_1]' (user #[_2]) added [lc,_4] #[_3]",
                $author->name, $author->id,
                $entry->id,    $entry->class_label
            ),
            level    => MT::Log::INFO(),
            class    => $obj_type,
            category => 'new',
            metadata => $entry->id
        }
    );

    if ($publish) {
        $class->_publish( $mt, $entry ) or die _fault( $class->errstr );
    }

    delete $ENV{SERVER_SOFTWARE};
    SOAP::Data->type( string => $entry->id );
}

sub newPost {
    my $class = shift;
    my ( $appkey, $blog_id, $user, $pass, $item, $publish );
    if ( $class eq 'blogger' ) {
        ( $appkey, $blog_id, $user, $pass, my ($content), $publish ) = @_;
        $item->{description} = $content;
    }
    else {
        ( $blog_id, $user, $pass, $item, $publish ) = @_;
    }

    _validate_params( [ $blog_id, $user, $pass, $publish ] ) or return;
    my $values;
    foreach my $k ( keys %$item ) {
        if ( 'categories' eq $k || 'mt_tb_ping_urls' eq $k ) {

            # XMLRPC supports categories array and mt_tb_ping_urls array
            _validate_params( \@{ $item->{$k} } ) or return;
        }
        else {
            push @$values, $item->{$k};
        }
    }
    _validate_params( \@$values ) or return;

    $class->_new_entry(
        blog_id => $blog_id,
        user    => $user,
        pass    => $pass,
        item    => $item,
        publish => $publish
    );
}

sub newPage {
    my $class = shift;
    my ( $blog_id, $user, $pass, $item, $publish ) = @_;

    _validate_params( [ $blog_id, $user, $pass, $publish ] ) or return;
    my $values;
    foreach my $k ( keys %$item ) {
        if ( 'mt_tb_ping_urls' eq $k ) {

            # XMLRPC supports mt_tb_ping_urls array
            _validate_params( \@{ $item->{$k} } ) or return;
        }
        else {
            push @$values, $item->{$k};
        }
    }
    _validate_params( \@$values ) or return;

    $class->_new_entry(
        blog_id => $blog_id,
        user    => $user,
        pass    => $pass,
        item    => $item,
        publish => $publish,
        page    => 1
    );
}

sub _edit_entry {
    my $class = shift;
    my %param = @_;
    my ( $blog_id, $entry_id, $user, $pass, $item, $publish )
        = @param{qw( blog_id entry_id user pass item publish )};

    _validate_params( [ $blog_id, $entry_id, $user, $pass, $publish ] )
        or return;
    my $values;
    foreach my $k ( keys %$item ) {
        if ( 'categories' eq $k || 'mt_tb_ping_urls' eq $k ) {

            # XMLRPC supports categories array and mt_tb_ping_urls array
            _validate_params( \@{ $item->{$k} } ) or return;
        }
        else {
            push @$values, $item->{$k};
        }
    }
    _validate_params( \@$values ) or return;

    my $obj_type = $param{page} ? 'page' : 'entry';
    die _fault( MT->translate("No entry_id") ) unless $entry_id;
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    for my $f (
        qw( title description mt_text_more
        mt_excerpt mt_keywords mt_tags mt_basename wp_slug )
        )
    {
        next unless defined $item->{$f};
        my $enc = $mt->config('PublishCharset');
        unless ($HAVE_XML_PARSER) {
            $item->{$f} = decode_html( $item->{$f} );
        }
    }
    my $entry = MT->model($obj_type)->load($entry_id)
        or
        die _fault( MT->translate( "Invalid entry ID '[_1]'", $entry_id ) );
    if ( $blog_id && $blog_id != $entry->blog_id ) {
        die _fault( MT->translate( "Invalid entry ID '[_1]'", $entry_id ) );
    }
    require MT::Blog;
    $blog_id ||= $entry->blog_id;
    my $blog = MT::Blog->load($blog_id)
        or die _fault( MT->translate( "Invalid blog ID '[_1]'", $blog_id ) );

    my ( $author, $perms ) = $class->_login( $user, $pass, $entry->blog_id );
    die _fault( MT->translate("Invalid login") ) unless $author;
    die _fault( MT->translate("Not allowed to edit entry") )
        if !$author->is_superuser
        && ( !$perms || !$perms->can_edit_entry( $entry, $author ) );
    my $orig_entry = $entry->clone;
    $entry->status( MT::Entry::RELEASE() )
        if $publish
        && ( $author->is_superuser
        || $perms->can_do('publish_entry_via_xmlrpc_server') );
    $entry->title( $item->{title} ) if $item->{title};

    $class->_apply_basename( $entry, $item, \%param );

    $entry->text( $item->{description} );
    $entry->convert_breaks( $item->{mt_convert_breaks} )
        if exists $item->{mt_convert_breaks};
    $entry->allow_comments( $item->{mt_allow_comments} )
        if exists $item->{mt_allow_comments};
    for my $field (qw( allow_pings )) {
        my $val = $item->{"mt_$field"};
        next unless defined $val;
        die _fault(
            MT->translate(
                "Value for 'mt_[_1]' must be either 0 or 1 (was '[_2]')",
                $field, $val
            )
        ) unless $val == 0 || $val == 1;
        $entry->$field($val);
    }
    $entry->excerpt( $item->{mt_excerpt} ) if defined $item->{mt_excerpt};
    $entry->text_more( $item->{mt_text_more} )
        if defined $item->{mt_text_more};
    $entry->keywords( $item->{mt_keywords} ) if defined $item->{mt_keywords};
    $entry->modified_by( $author->id );
    if ( my $tags = $item->{mt_tags} ) {
        require MT::Tag;
        my $tag_delim = chr( $author->entry_prefs->{tag_delim} );
        my @tags = MT::Tag->split( $tag_delim, $tags );
        $entry->set_tags(@tags);
    }
    if ( my $urls = $item->{mt_tb_ping_urls} ) {
        $entry->to_ping_urls( join "\n", @$urls );
    }
    if ( my $iso = $item->{dateCreated} ) {
        $entry->authored_on(
            MT::XMLRPCServer::Util::iso2ts( $entry->blog_id, $iso ) )
            || die MT::XMLRPCServer::_fault(
            MT->translate("Invalid timestamp format") );
        require MT::DateTime;
        $entry->status( MT::Entry::FUTURE() )
            if MT::DateTime->compare(
            blog => $blog,
            a    => $entry->authored_on,
            b    => { value => time(), type => 'epoch' }
            ) > 0;
    }
    $entry->discover_tb_from_entry() if MT->has_plugin('Trackback');

    MT->run_callbacks( "api_pre_save.$obj_type", $mt, $entry, $orig_entry )
        || die MT::XMLRPCServer::_fault(
        MT->translate( "PreSave failed [_1]", MT->errstr ) );

    $entry->save;

    # Clear cache for site stats dashboard widget.
    if ((      $orig_entry->status == MT::Entry::RELEASE()
            || $entry->status == MT::Entry::RELEASE()
        )
        && $orig_entry->status != $entry->status
        )
    {
        require MT::Util;
        MT::Util::clear_site_stats_widget_cache( $entry->blog_id )
            or die MT::XMLRPCServer::_fault(
            MT->translate('Removing stats cache failed.') );
    }

    my $old_categories = $entry->categories;
    $entry->clear_cache('categories');
    my $changed = $class->_save_placements( $entry, $item, \%param );
    my @types = ($obj_type);
    if ($changed) {
        push @types, 'folder';    # folders are the only type that can be
                                  # created in _save_placements
    }
    $blog->touch(@types);

    MT->run_callbacks( "api_post_save.$obj_type", $mt, $entry, $orig_entry );

    require MT::Log;
    $mt->log(
        {   message => $mt->translate(
                "User '[_1]' (user #[_2]) edited [lc,_4] #[_3]",
                $author->name, $author->id,
                $entry->id,    $entry->class_label
            ),
            level    => MT::Log::NOTICE(),
            class    => $obj_type,
            category => 'edit',
            metadata => $entry->id
        }
    );

    if ($publish) {
        $class->_publish( $mt, $entry, undef, $old_categories )
            or die _fault( $class->errstr );
    }

    SOAP::Data->type( boolean => 1 );
}

sub editPost {
    my $class = shift;
    my ( $entry_id, $user, $pass, $item, $publish );
    if ( $class eq 'blogger' ) {
        ( my ($appkey), $entry_id, $user, $pass, my ($content), $publish )
            = @_;
        $item->{description} = $content;
    }
    else {
        ( $entry_id, $user, $pass, $item, $publish ) = @_;
    }

    _validate_params( [ $entry_id, $user, $pass, $publish ] ) or return;
    my $values;
    foreach my $k ( keys %$item ) {
        if ( 'categories' eq $k || 'mt_tb_ping_urls' eq $k ) {

            # XMLRPC supports categories array and mt_tb_ping_urls array
            _validate_params( \@{ $item->{$k} } ) or return;
        }
        else {
            push @$values, $item->{$k};
        }
    }
    _validate_params( \@$values ) or return;

    $class->_edit_entry(
        entry_id => $entry_id,
        user     => $user,
        pass     => $pass,
        item     => $item,
        publish  => $publish
    );
}

sub editPage {
    my $class = shift;
    my ( $blog_id, $entry_id, $user, $pass, $item, $publish ) = @_;

    _validate_params( [ $blog_id, $entry_id, $user, $pass, $publish ] )
        or return;
    my $values;
    foreach my $k ( keys %$item ) {
        if ( 'mt_tb_ping_urls' eq $k ) {

            # XMLRPC supports mt_tb_ping_urls array
            _validate_params( \@{ $item->{$k} } ) or return;
        }
        else {
            push @$values, $item->{$k};
        }
    }
    _validate_params( \@$values ) or return;

    $class->_edit_entry(
        blog_id  => $blog_id,
        entry_id => $entry_id,
        user     => $user,
        pass     => $pass,
        item     => $item,
        publish  => $publish,
        page     => 1
    );
}

sub getUsersBlogs {
    my $class;
    if ( UNIVERSAL::isa( $_[0] => __PACKAGE__ ) ) {
        $class = shift;
    }
    else {
        $class = __PACKAGE__;
    }
    my ( $appkey, $user, $pass ) = @_;

    _validate_params( [ $user, $pass ] ) or return;

    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my ($author) = $class->_login( $user, $pass );
    die _fault( MT->translate("Invalid login") ) unless $author;

    require MT::Permission;
    require MT::Blog;

    my $iter;
    if ( $author->is_superuser ) {
        $iter = MT::Blog->load_iter( { class => '*' } );
    }
    else {
        $iter = MT::Blog->load_iter(
            { class => '*' },
            {   join => MT::Permission->join_on(
                    'blog_id', { author_id => $author->id, }, {}
                )
            }
        );
    }

    my @res;
    while ( my $blog = $iter->() ) {
        if ( !$author->is_superuser ) {
            my $perm = $author->permissions( $blog->id );
            next
                unless $perm
                && $perm->can_do('get_blog_info_via_xmlrpc_server');
        }
        push @res,
            {
            url => SOAP::Data->type( string => $blog->site_url || '' ),
            blogid   => SOAP::Data->type( string => $blog->id ),
            blogName => SOAP::Data->type( string => $blog->name || '' )
            };
    }
    \@res;
}

sub getUserInfo {
    my $class;
    if ( UNIVERSAL::isa( $_[0] => __PACKAGE__ ) ) {
        $class = shift;
    }
    else {
        $class = __PACKAGE__;
    }
    my ( $appkey, $user, $pass ) = @_;

    _validate_params( [ $user, $pass ] ) or return;

    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my ($author) = $class->_login( $user, $pass );
    die _fault( MT->translate("Invalid login") ) unless $author;
    my ( $fname, $lname ) = split /\s+/, $author->name;
    $lname ||= '';
    {   userid    => SOAP::Data->type( string => $author->id ),
        firstname => SOAP::Data->type( string => $fname || '' ),
        lastname  => SOAP::Data->type( string => $lname || '' ),
        nickname  => SOAP::Data->type( string => $author->nickname || '' ),
        email     => SOAP::Data->type( string => $author->email || '' ),
        url       => SOAP::Data->type( string => $author->url || '' )
    };
}

sub _get_entries {
    my $class = shift;
    my %param = @_;
    my ( $blog_id, $user, $pass, $num, $titles_only )
        = @param{qw( blog_id user pass num titles_only )};

    _validate_params( [ $blog_id, $user, $pass, $num, $titles_only ] )
        or return;

    my $obj_type = $param{page} ? 'page' : 'entry';
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my ( $author, $perms ) = $class->_login( $user, $pass, $blog_id );
    die _fault( MT->translate("Invalid login") ) unless $author;
    die _fault( MT->translate("Permission denied.") )
        if !$author->is_superuser
        && ( !$perms
        || !$perms->can_do('get_entries_via_xmlrpc_server') );
    my $iter = MT->model($obj_type)->load_iter(
        { blog_id => $blog_id },
        {   'sort'    => 'authored_on',
            direction => 'descend',
            limit     => $num
        }
    );
    my @res;

    while ( my $entry = $iter->() ) {
        my $co = sprintf "%04d%02d%02dT%02d:%02d:%02d",
            unpack 'A4A2A2A2A2A2', $entry->authored_on;
        my $row = {
            dateCreated => SOAP::Data->type( dateTime => $co ),
            userid      => SOAP::Data->type( string   => $entry->author_id )
        };
        $row->{ $param{page} ? 'page_id' : 'postid' }
            = SOAP::Data->type( string => $entry->id );
        if ( $class eq 'blogger' ) {
            $row->{content}
                = SOAP::Data->type( string => $entry->text || '' );
        }
        else {
            $row->{title} = SOAP::Data->type( string => $entry->title || '' );
            unless ($titles_only) {
                require MT::Tag;
                my $tag_delim = chr( $author->entry_prefs->{tag_delim} );
                my $tags = MT::Tag->join( $tag_delim, $entry->tags );
                $row->{description}
                    = SOAP::Data->type( string => $entry->text );
                my $link = $entry->permalink;
                $row->{link}      = SOAP::Data->type( string => $link || '' );
                $row->{permaLink} = SOAP::Data->type( string => $link || '' ),
                    $row->{mt_basename}
                    = SOAP::Data->type( string => $entry->basename || '' );
                $row->{mt_allow_comments}
                    = SOAP::Data->type( int => $entry->allow_comments + 0 );
                $row->{mt_allow_pings}
                    = SOAP::Data->type( int => $entry->allow_pings + 0 );
                $row->{mt_convert_breaks}
                    = SOAP::Data->type( string => $entry->convert_breaks
                        || '' );
                $row->{mt_text_more}
                    = SOAP::Data->type( string => $entry->text_more || '' );
                $row->{mt_excerpt}
                    = SOAP::Data->type( string => $entry->excerpt || '' );
                $row->{mt_keywords}
                    = SOAP::Data->type( string => $entry->keywords || '' );
                $row->{mt_tags} = SOAP::Data->type( string => $tags || '' );
            }
        }
        push @res, $row;
    }
    \@res;
}

sub getRecentPosts {
    my $class = shift;
    my ( $blog_id, $user, $pass, $num );
    if ( $class eq 'blogger' ) {
        ( my ($appkey), $blog_id, $user, $pass, $num ) = @_;
    }
    else {
        ( $blog_id, $user, $pass, $num ) = @_;
    }

    _validate_params( [ $blog_id, $user, $pass, $num ] ) or return;

    $class->_get_entries(
        blog_id => $blog_id,
        user    => $user,
        pass    => $pass,
        num     => $num
    );
}

sub getRecentPostTitles {
    my $class = shift;
    my ( $blog_id, $user, $pass, $num ) = @_;

    _validate_params( [ $blog_id, $user, $pass, $num ] ) or return;

    $class->_get_entries(
        blog_id     => $blog_id,
        user        => $user,
        pass        => $pass,
        num         => $num,
        titles_only => 1
    );
}

sub getPages {
    my $class = shift;
    my ( $blog_id, $user, $pass ) = @_;

    _validate_params( [ $blog_id, $user, $pass ] ) or return;

    $class->_get_entries(
        blog_id => $blog_id,
        user    => $user,
        pass    => $pass,
        page    => 1
    );
}

sub _delete_entry {
    my $class = shift;
    my %param = @_;
    my ( $blog_id, $entry_id, $user, $pass, $publish )
        = @param{qw( blog_id entry_id user pass publish )};

    _validate_params( [ $blog_id, $entry_id, $user, $pass, $publish ] )
        or return;

    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my $obj_type = $param{page} ? 'page' : 'entry';
    my $entry    = MT->model($obj_type)->load($entry_id)
        or
        die _fault( MT->translate( "Invalid entry ID '[_1]'", $entry_id ) );
    my ( $author, $perms ) = $class->_login( $user, $pass, $entry->blog_id );
    die _fault( MT->translate("Invalid login") ) unless $author;
    die _fault( MT->translate("Permission denied.") )
        if !$author->is_superuser
        && ( !$perms || !$perms->can_edit_entry( $entry, $author ) );

    # Delete archive file
    my $blog = MT::Blog->load( $entry->blog_id );
    my %recipe;
    %recipe = $mt->publisher->rebuild_deleted_entry(
        Entry => $entry,
        Blog  => $blog
    ) if $entry->status eq MT::Entry::RELEASE();

    # Remove object
    $entry->remove;

    # Clear cache for site stats dashboard widget.
    require MT::Util;
    MT::Util::clear_site_stats_widget_cache( $entry->blog_id )
        or die MT::XMLRPCServer::_fault(
        MT->translate('Removing stats cache failed.') );

    # Rebuild archives
    if (%recipe) {
        $mt->rebuild_archives( Blog => $blog, Recipe => \%recipe, )
            or die _fault( $class->errstr );
    }

    # Rebuild index files
    if ( $mt->config('RebuildAtDelete') ) {
        $mt->rebuild_indexes( Blog => $blog ) or die _fault( $class->errstr );
    }

    $mt->log(
        {   message => $mt->translate(
                "Entry '[_1]' ([lc,_5] #[_2]) deleted by '[_3]' (user #[_4]) from xml-rpc",
                $entry->title, $entry->id, $author->name,
                $author->id,   $entry->class_label
            ),
            level    => MT::Log::NOTICE(),
            class    => $entry->class,
            category => 'delete'
        }
    );

    SOAP::Data->type( boolean => 1 );
}

sub deletePost {
    my $class;
    if ( UNIVERSAL::isa( $_[0] => __PACKAGE__ ) ) {
        $class = shift;
    }
    else {
        $class = __PACKAGE__;
    }
    my ( $appkey, $entry_id, $user, $pass, $publish ) = @_;

    _validate_params( [ $entry_id, $user, $pass, $publish ] ) or return;

    $class->_delete_entry(
        entry_id => $entry_id,
        user     => $user,
        pass     => $pass,
        publish  => $publish
    );
}

sub deletePage {
    my $class = shift;
    my ( $blog_id, $user, $pass, $entry_id ) = @_;

    _validate_params( [ $blog_id, $user, $pass, $entry_id ] ) or return;

    $class->_delete_entry(
        blog_id  => $blog_id,
        entry_id => $entry_id,
        user     => $user,
        pass     => $pass,
        publish  => 1,
        page     => 1
    );
}

sub _get_entry {
    my $class = shift;
    my %param = @_;
    my ( $blog_id, $entry_id, $user, $pass )
        = @param{qw( blog_id entry_id user pass )};

    _validate_params( [ $blog_id, $entry_id, $user, $pass ] ) or return;

    my $obj_type = $param{page} ? 'page' : 'entry';
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my $entry = MT->model($obj_type)->load($entry_id)
        or
        die _fault( MT->translate( "Invalid entry ID '[_1]'", $entry_id ) );
    if ( $blog_id && $blog_id != $entry->blog_id ) {
        die _fault( MT->translate( "Invalid entry ID '[_1]'", $entry_id ) );
    }
    my ( $author, $perms ) = $class->_login( $user, $pass, $entry->blog_id );
    die _fault( MT->translate("Invalid login") ) unless $author;
    die _fault( MT->translate("Not allowed to get entry") )
        if !$author->is_superuser
        && ( !$perms || !$perms->can_edit_entry( $entry, $author ) );
    my $co = sprintf "%04d%02d%02dT%02d:%02d:%02d",
        unpack 'A4A2A2A2A2A2', $entry->authored_on;
    my $link = $entry->permalink;
    require MT::Tag;
    my $delim = chr( $author->entry_prefs->{tag_delim} );
    my $tags = MT::Tag->join( $delim, $entry->tags );

    my $cats     = [];
    my $cat_data = $entry->__load_category_data();
    if ( scalar @$cat_data ) {
        my ($first_cat) = grep { $_->[1] } @$cat_data;
        my @cat_ids = grep { !$_->[1] } @$cat_data;
        unshift @cat_ids, $first_cat if $first_cat;
        $cats = MT->model('category')
            ->lookup_multi( [ map { $_->[0] } @cat_ids ] );
    }

    my $basename = SOAP::Data->type( string => $entry->basename || '' );
    {   dateCreated => SOAP::Data->type( dateTime => $co ),
        userid      => SOAP::Data->type( string   => $entry->author_id ),
        ( $param{page} ? 'page_id' : 'postid' ) =>
            SOAP::Data->type( string => $entry->id ),
        description => SOAP::Data->type( string => $entry->text  || '' ),
        title       => SOAP::Data->type( string => $entry->title || '' ),
        mt_basename => $basename,
        wp_slug     => $basename,
        link        => SOAP::Data->type( string => $link         || '' ),
        permaLink   => SOAP::Data->type( string => $link         || '' ),
        categories =>
            [ map { SOAP::Data->type( string => $_->label || '' ) } @$cats ],
        mt_allow_comments =>
            SOAP::Data->type( int => $entry->allow_comments + 0 ),
        mt_allow_pings => SOAP::Data->type( int => $entry->allow_pings + 0 ),
        mt_convert_breaks =>
            SOAP::Data->type( string => $entry->convert_breaks || '' ),
        mt_text_more => SOAP::Data->type( string => $entry->text_more || '' ),
        mt_excerpt   => SOAP::Data->type( string => $entry->excerpt   || '' ),
        mt_keywords  => SOAP::Data->type( string => $entry->keywords  || '' ),
        mt_tags      => SOAP::Data->type( string => $tags             || '' ),
    };
}

sub getPost {
    my $class = shift;
    my ( $entry_id, $user, $pass ) = @_;

    _validate_params( [ $entry_id, $user, $pass ] ) or return;

    $class->_get_entry( entry_id => $entry_id, user => $user, pass => $pass );
}

sub getPage {
    my $class = shift;
    my ( $blog_id, $entry_id, $user, $pass ) = @_;

    _validate_params( [ $blog_id, $entry_id, $user, $pass ] ) or return;

    $class->_get_entry(
        blog_id  => $blog_id,
        entry_id => $entry_id,
        user     => $user,
        pass     => $pass,
        page     => 1
    );
}

sub supportedMethods {
    [   'blogger.newPost', 'blogger.editPost', 'blogger.getRecentPosts',
        'blogger.getUsersBlogs', 'blogger.getUserInfo', 'blogger.deletePost',
        'metaWeblog.getPost',    'metaWeblog.newPost',  'metaWeblog.editPost',
        'metaWeblog.getRecentPosts', 'metaWeblog.newMediaObject',
        'metaWeblog.getCategories',  'metaWeblog.deletePost',
        'metaWeblog.getUsersBlogs', 'wp.newPage', 'wp.getPages', 'wp.getPage',
        'wp.editPage', 'wp.deletePage',

        # not yet supported: metaWeblog.getTemplate, metaWeblog.setTemplate
        'mt.getCategoryList', 'mt.setPostCategories', 'mt.getPostCategories',
        'mt.getTrackbackPings', 'mt.supportedTextFilters',
        'mt.getRecentPostTitles', 'mt.publishPost', 'mt.getTagList'
    ];
}

sub supportedTextFilters {
    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my $filters = $mt->all_text_filters;
    my @res;
    for my $filter ( keys %$filters ) {
        my $label = $filters->{$filter}{label};
        if ( 'CODE' eq ref($label) ) {
            $label = $label->();
        }
        push @res,
            {
            key   => SOAP::Data->type( string => $filter || '' ),
            label => SOAP::Data->type( string => $label  || '' )
            };
    }
    \@res;
}

## getCategoryList, getPostCategories, and setPostCategories were
## originally written by Daniel Drucker with the assistance of
## Six Apart, then later modified by Six Apart.

sub getCategoryList {
    my $class = shift;
    my ( $blog_id, $user, $pass ) = @_;

    _validate_params( [ $blog_id, $user, $pass ] ) or return;

    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my ( $author, $perms ) = $class->_login( $user, $pass, $blog_id );
    die _fault( MT->translate("Invalid login") ) unless $author;
    die _fault( MT->translate("Permission denied.") )
        if !$author->is_superuser
        && ( !$perms
        || !$perms->can_do('get_category_list_via_xmlrpc_server') );
    require MT::Category;
    my $iter = MT::Category->load_iter(
        { blog_id => $blog_id, category_set_id => 0 } );
    my @data;

    while ( my $cat = $iter->() ) {
        push @data,
            {
            categoryName => SOAP::Data->type( string => $cat->label || '' ),
            categoryId => SOAP::Data->type( string => $cat->id )
            };
    }
    \@data;
}

sub getCategories {
    my $class = shift;
    my ( $blog_id, $user, $pass ) = @_;

    _validate_params( [ $blog_id, $user, $pass ] ) or return;

    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my ( $author, $perms ) = $class->_login( $user, $pass, $blog_id );
    die _fault( MT->translate("Invalid login") ) unless $author;
    die _fault( MT->translate("Permission denied.") )
        if !$author->is_superuser
        && ( !$perms
        || !$perms->can_do('get_categories_via_xmlrpc_server') );
    require MT::Category;
    my $iter = MT::Category->load_iter(
        { blog_id => $blog_id, category_set_id => 0 } );
    my @data;
    my $blog = MT::Blog->load($blog_id);
    require File::Spec;

    while ( my $cat = $iter->() ) {
        my $url = File::Spec->catfile( $blog->site_url,
            archive_file_for( undef, $blog, 'Category', $cat ) );
        push @data,
            {
            categoryId => SOAP::Data->type( string => $cat->id ),
            parentId   => (
                $cat->parent_category
                ? SOAP::Data->type( string => $cat->parent_category->id )
                : undef
            ),
            categoryName => SOAP::Data->type( string => $cat->label || '' ),
            title        => SOAP::Data->type( string => $cat->label || '' ),
            description =>
                SOAP::Data->type( string => $cat->description || '' ),
            htmlUrl => SOAP::Data->type( string => $url || '' ),
            };
    }
    \@data;
}

sub getTagList {
    my $class = shift;
    my ( $blog_id, $user, $pass ) = @_;

    _validate_params( [ $blog_id, $user, $pass ] ) or return;

    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my ( $author, $perms ) = $class->_login( $user, $pass, $blog_id );
    die _fault( MT->translate("Invalid login") ) unless $author;
    die _fault( MT->translate("Permission denied.") )
        if !$author->is_superuser
        && ( !$perms
        || !$perms->can_do('get_tag_list_via_xmlrpc_server') );
    require MT::Tag;
    require MT::ObjectTag;
    my $iter = MT::Tag->load_iter(
        undef,
        {   join => [
                'MT::ObjectTag', 'tag_id',
                { blog_id => $blog_id }, { unique => 1 }
            ]
        }
    );
    my @data;

    while ( my $tag = $iter->() ) {
        push @data,
            {
            tagName => SOAP::Data->type( string => $tag->name || '' ),
            tagId => SOAP::Data->type( string => $tag->id )
            };
    }
    \@data;
}

sub getPostCategories {
    my $class = shift;
    my ( $entry_id, $user, $pass ) = @_;

    _validate_params( [ $entry_id, $user, $pass ] ) or return;

    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    require MT::Entry;
    my $entry = MT::Entry->load($entry_id)
        or
        die _fault( MT->translate( "Invalid entry ID '[_1]'", $entry_id ) );
    my ( $author, $perms ) = $class->_login( $user, $pass, $entry->blog_id );
    die _fault( MT->translate("Invalid login") ) unless $author;
    die _fault( MT->translate("Permission denied.") )
        if !$author->is_superuser
        && ( !$perms
        || !$perms->can_do('get_post_categories_via_xmlrpc_server') );
    my @data;
    my $prim = $entry->category;
    my $cats = $entry->categories;

    for my $cat (@$cats) {
        my $is_primary = $prim && $cat->id == $prim->id ? 1 : 0;
        push @data,
            {
            categoryName => SOAP::Data->type( string => $cat->label || '' ),
            categoryId => SOAP::Data->type( string => $cat->id ),
            isPrimary => SOAP::Data->type( boolean => $is_primary ),
            };
    }
    \@data;
}

sub setPostCategories {
    my $class = shift;
    my ( $entry_id, $user, $pass, $cats ) = @_;

    _validate_params( [ $entry_id, $user, $pass ] ) or return;
    foreach my $c (@$cats) {
        _validate_params( [ values %$c ] ) or return;
    }

    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    require MT::Entry;
    require MT::Placement;
    my $entry = MT::Entry->load($entry_id)
        or
        die _fault( MT->translate( "Invalid entry ID '[_1]'", $entry_id ) );
    my ( $author, $perms ) = $class->_login( $user, $pass, $entry->blog_id );
    die _fault( MT->translate("Invalid login") ) unless $author;
    die _fault( MT->translate("Not allowed to set entry categories") )
        if !$author->is_superuser
        && ( !$perms || !$perms->can_edit_entry( $entry, $author ) );
    my @place = MT::Placement->load( { entry_id => $entry_id } );

    for my $place (@place) {
        $place->remove;
    }
    ## Keep track of which category is named the primary category.
    ## If the first structure in the array does not have an isPrimary
    ## key, we just make it the primary category; if it does, we use
    ## that flag to determine the primary category.
    my $is_primary = 1;
    for my $cat (@$cats) {
        my $place = MT::Placement->new;
        $place->entry_id($entry_id);
        $place->blog_id( $entry->blog_id );
        if ( defined $cat->{isPrimary} && $is_primary ) {
            $place->is_primary( $cat->{isPrimary} );
        }
        else {
            $place->is_primary($is_primary);
        }
        ## If we just set the is_primary flag to 1, we don't want to
        ## make any other categories primary.
        $is_primary = 0 if $place->is_primary;
        $place->category_id( $cat->{categoryId} );
        $place->save
            or die _fault(
            MT->translate( "Saving placement failed: [_1]", $place->errstr )
            );
    }
    $class->_publish( $mt, $entry, undef, [ map { $_->category_id } @place ] )
        or die _fault( $class->errstr );
    SOAP::Data->type( boolean => 1 );
}

sub getTrackbackPings {
    my $class = shift;
    my ($entry_id) = @_;

    _validate_params( [$entry_id] ) or return;

    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    return unless MT->has_plugin('Trackback');

    require Trackback::XMLRPCServer;
    Trackback::XMLRPCServer::_getTrackbackPings($entry_id);
}

sub publishPost {
    my $class = shift;
    my ( $entry_id, $user, $pass ) = @_;

    _validate_params( [ $entry_id, $user, $pass ] ) or return;

    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    require MT::Entry;
    my $entry = MT::Entry->load($entry_id)
        or
        die _fault( MT->translate( "Invalid entry ID '[_1]'", $entry_id ) );
    my ( $author, $perms ) = $class->_login( $user, $pass, $entry->blog_id );
    die _fault( MT->translate("Invalid login") ) unless $author;
    die _fault( MT->translate("Not allowed to edit entry") )
        if !$author->is_superuser
        && ( !$perms || !$perms->can_edit_entry( $entry, $author ) );
    $mt->rebuild_entry( Entry => $entry, BuildDependencies => 1 )
        or
        die _fault( MT->translate( "Publishing failed: [_1]", $mt->errstr ) );
    SOAP::Data->type( boolean => 1 );
}

sub runPeriodicTasks {
    my $class = shift;
    my ( $user, $pass ) = @_;

    _validate_params( [ $user, $pass ] ) or return;

    my $mt = MT::XMLRPCServer::Util::mt_new();
    my $author = $class->_login( $user, $pass );
    die _fault( MT->translate("Invalid login") ) unless $author;

    $mt->run_tasks;

    { responseCode => 'success' };
}

sub publishScheduledFuturePosts {
    my $class = shift;
    my ( $blog_id, $user, $pass ) = @_;

    _validate_params( [ $blog_id, $user, $pass ] ) or return;

    my $mt = MT::XMLRPCServer::Util::mt_new();
    my $author = $class->_login( $user, $pass );
    die _fault( MT->translate("Invalid login") ) unless $author;
    my $blog = MT::Blog->load($blog_id)
        or die _fault( MT->translate( 'Cannot load blog #[_1].', $blog_id ) );

    my $now = time;

    # Convert $now to user's timezone, which is how future post dates
    # are stored.
    $now = MT::Util::offset_time($now);
    $now = strftime( "%Y%m%d%H%M%S", gmtime($now) );

    my $iter = MT::Entry->load_iter(
        {   blog_id => $blog->id,
            class   => '*',
            status  => MT::Entry::FUTURE()
        },
        {   'sort'    => 'authored_on',
            direction => 'descend'
        }
    );
    my @queue;
    while ( my $i = $iter->() ) {
        push @queue, $i->id();
    }

    my $changed       = 0;
    my $total_changed = 0;
    my %types;
    foreach my $entry_id (@queue) {
        my $entry = MT::Entry->load($entry_id);
        if ( $entry && $entry->authored_on <= $now ) {
            $entry->status( MT::Entry::RELEASE() );
            $entry->discover_tb_from_entry() if MT->has_plugin('Trackback');
            $entry->save or die $entry->errstr;

            $types{ $entry->class } = 1;
            start_background_task(
                sub {
                    $mt->rebuild_entry( Entry => $entry, Blog => $blog )
                        or die $mt->errstr;
                }
            );
            $changed++;
            $total_changed++;
        }
    }
    $blog->touch( keys %types ) if $changed;
    $blog->save if $changed && ( keys %types );

    if ($changed) {
        $mt->rebuild_indexes( Blog => $blog ) or die $mt->errstr;
    }
    { responseCode => 'success', publishedCount => $total_changed, };
}

sub getNextScheduled {
    my $class = shift;
    my ( $user, $pass ) = @_;

    _validate_params( [ $user, $pass ] ) or return;

    my $mt = MT::XMLRPCServer::Util::mt_new();
    my $author = $class->_login( $user, $pass );
    die _fault( MT->translate("Invalid login") ) unless $author;

    my $next_scheduled = MT::get_next_sched_post_for_user( $author->id() );

    { nextScheduledTime => $next_scheduled };
}

sub setRemoteAuthToken {
    my $class = shift;
    my ( $user, $pass, $remote_auth_username, $remote_auth_token ) = @_;

    _validate_params(
        [ $user, $pass, $remote_auth_username, $remote_auth_token ] )
        or return;

    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my ($author) = $class->_login( $user, $pass );
    die _fault( MT->translate("Invalid login") ) unless $author;
    $author->remote_auth_username($remote_auth_username);
    $author->remote_auth_token($remote_auth_token);
    $author->save();
    1;
}

sub newMediaObject {
    my $class = shift;
    my ( $blog_id, $user, $pass, $file ) = @_;

    _validate_params( [ $blog_id, $user, $pass ] ) or return;
    _validate_params( [ values %$file ] ) or return;

    my $mt = MT::XMLRPCServer::Util::mt_new();   ## Will die if MT->new fails.
    my ( $author, $perms ) = $class->_login( $user, $pass, $blog_id );
    die _fault( MT->translate("Invalid login") ) unless $author;
    die _fault( MT->translate("Not allowed to upload files") )
        if !$author->is_superuser
        && ( !$perms
        || !$perms->can_do('upload_asset_via_xmlrpc_server') );

    require MT::Blog;
    require File::Spec;
    my $blog = MT::Blog->load($blog_id)
        or die _fault( MT->translate( 'Cannot load blog #[_1].', $blog_id ) );

    my $fname = $file->{name}
        or die _fault( MT->translate("No filename provided") );
    if ( $fname =~ m!\.\.|\0|\|! ) {
        die _fault( MT->translate( "Invalid filename '[_1]'", $fname ) );
    }

    my ( $base, $uploaded_path, $ext )
        = File::Basename::fileparse( $fname, '\.[^\.]*' );
    if ( my $deny_exts = MT->config->DeniedAssetFileExtensions ) {
        my @deny_exts = map {
            if   ( $_ =~ m/^\./ ) {qr/$_(?:\..*)?/i}
            else                  {qr/\.$_(?:\..*)?/i}
        } grep { defined $_ && $_ ne '' } split '\s?,\s?', $deny_exts;
        my @ret = File::Basename::fileparse( $fname, @deny_exts );
        die _fault(
            MT->translate(
                '\'[_1]\' is not allowed to upload by system settings.: [_2]',
                $ret[2],
                $fname
            )
        ) if $ret[2];
    }

    if ( my $allow_exts = MT->config('AssetFileExtensions') ) {
        my @allowed = map {
            if   ( $_ =~ m/^\./ ) {qr/$_/i}
            else                  {qr/\.$_/i}
        } split '\s?,\s?', $allow_exts;
        my @ret = File::Basename::fileparse( $fname, @allowed );
        die _fault(
            MT->translate(
                '\'[_1]\' is not allowed to upload by system settings.: [_2]',
                $ext,
                $fname
            )
        ) unless $ret[2];
    }

    my $basename    = $base . $ext;
    my $upload_dest = $blog->site_path;
    my $middle_path;
    my $is_site_root = 1;
    if ( defined $blog->allow_to_change_at_upload
        && !$blog->allow_to_change_at_upload )
    {
        if ( $blog->upload_destination ) {
            my $dest = $blog->upload_destination;
            my $extra_path = $blog->extra_path || '';
            my $root_path;

            if ( $dest =~ m/^%s/i ) {
                $root_path = $blog->site_path;
            }
            else {
                $root_path    = $blog->archive_path;
                $is_site_root = 0;
            }

            $dest = MT::Util::build_upload_destination( $dest, $author );
            $middle_path = MT::Util::caturl( $dest, $extra_path );
            $upload_dest
                = File::Spec->catdir( $root_path, $dest, $extra_path );
        }
        else {
            $middle_path = '';
            $upload_dest = $blog->site_path;
        }
    }
    else {
        $middle_path
            = ( $uploaded_path eq '.' . MT::Util::dir_separator )
            ? ''
            : $uploaded_path;
        $upload_dest = File::Spec->catdir( $blog->site_path, $uploaded_path );
    }

    my $local_file = File::Spec->catfile( $upload_dest, $basename );
    $ext = ( File::Basename::fileparse( $local_file, qr/[A-Za-z0-9]+$/ ) )[2];
    require MT::Asset::Image;
    if ( MT::Asset::Image->can_handle($ext) ) {
        require MT::Image;
        my $fh;
        my $data = $file->{bits};
        open( $fh, "+<", \$data ) or die $!;
        close($fh),
            die _fault(
            MT->translate(
                "Saving [_1] failed: [_2]",
                $file->{name},
                "Invalid image file format."
            )
            ) unless MT::Image::is_valid_image($fh);
        close($fh);
    }

    my $fmgr = $blog->file_mgr;
    my ( $vol, $path, $name ) = File::Spec->splitpath($local_file);
    $path =~ s!/$!!
        unless $path eq '/';    ## OS X doesn't like / at the end in mkdir().
    $path = File::Spec->catpath( $vol, $path )
        if $vol;
    unless ( $fmgr->exists($path) ) {
        $fmgr->mkpath($path)
            or die _fault(
            MT->translate(
                "Error making path '[_1]': [_2]",
                $path, $fmgr->errstr
            )
            );
    }
    defined( my $bytes
            = $fmgr->put_data( $file->{bits}, $local_file, 'upload' ) )
        or die _fault(
        MT->translate( "Error writing uploaded file: [_1]", $fmgr->errstr ) );
    $middle_path =~ s!\\!/!g;
    $middle_path =~ s!^/!!;
    my $url = MT::Util::caturl(
        (     $is_site_root
            ? $blog->site_url
            : $blog->archive_url
        ),
        $middle_path,
        $basename
    );
    my $asset_url = MT::Util::caturl( ( $is_site_root ? '%r' : '%a' ),
        $middle_path, $basename );

    require File::Basename;
    my $local_basename = File::Basename::basename($local_file);
    eval { require Image::Size; };
    die _fault(
        MT->translate(
            "Perl module Image::Size is required to determine width and height of uploaded images."
        )
    ) if $@;
    my ( $w, $h, $id ) = Image::Size::imgsize($local_file);

    require MT::Asset;
    my $asset_pkg = MT::Asset->handler_for_file($local_basename);
    my $is_image  = 0;
    if ( defined($w) && defined($h) ) {
        $is_image = 1 if $asset_pkg->isa('MT::Asset::Image');
    }
    else {

        # rebless to file type
        $asset_pkg = 'MT::Asset';
    }

    my $asset;
    if (!(  $asset = $asset_pkg->load(
                { file_path => $local_file, blog_id => $blog_id }
            )
        )
        )
    {
        $asset = $asset_pkg->new();
        $asset->file_path($local_file);
        $asset->file_name($local_basename);
        $asset->file_ext($ext);
        $asset->blog_id($blog_id);
        $asset->created_by( $author->id );
    }
    else {
        $asset->modified_by( $author->id );
    }
    my $original = $asset->clone;
    $asset->url($asset_url);
    if ($is_image) {
        $asset->image_width($w);
        $asset->image_height($h);
    }
    $asset->mime_type( $file->{type} );
    $asset->save;

    $blog->touch('asset');
    $blog->save;

    MT->run_callbacks(
        'api_upload_file.' . $asset->class,
        File  => $local_file,
        file  => $local_file,
        Url   => $url,
        url   => $url,
        Size  => $bytes,
        size  => $bytes,
        Asset => $asset,
        asset => $asset,
        Type  => $asset->class,
        type  => $asset->class,
        Blog  => $blog,
        blog  => $blog
    );
    if ($is_image) {
        MT->run_callbacks(
            'api_upload_image',
            File       => $local_file,
            file       => $local_file,
            Url        => $url,
            url        => $url,
            Size       => $bytes,
            size       => $bytes,
            Asset      => $asset,
            asset      => $asset,
            Height     => $h,
            height     => $h,
            Width      => $w,
            width      => $w,
            Type       => 'image',
            type       => 'image',
            ImageType  => $id,
            image_type => $id,
            Blog       => $blog,
            blog       => $blog
        );
    }

    { url => SOAP::Data->type( string => $url || '' ) };
}

## getTemplate and setTemplate are not applicable in MT's template
## structure, so they are unimplemented (they return a fault).
## We assign it twice to get rid of "setTemplate used only once" warnings.

sub getTemplate {
    die _fault(
        MT->translate(
            "Template methods are not implemented, due to differences between the Blogger API and the Movable Type API."
        )
    );
}
*setTemplate = *setTemplate = \&getTemplate;

## The above methods will be called as blogger.newPost, blogger.editPost,
## etc., because we are implementing Blogger's API. Thus, the empty
## subclass.
package blogger;
BEGIN { @blogger::ISA = qw( MT::XMLRPCServer ); }

package metaWeblog;
BEGIN { @metaWeblog::ISA = qw( MT::XMLRPCServer ); }

package mt;
BEGIN { @mt::ISA = qw( MT::XMLRPCServer ); }

package wp;
BEGIN { @wp::ISA = qw( MT::XMLRPCServer ); }

1;
__END__

=head1 NAME

MT::XMLRPCServer

=head1 SYNOPSIS

An XMLRPC API interface for communicating with Movable Type.

=head1 CALLBACKS

=over 4

=item api_pre_save.entry
=item api_pre_save.page

    callback($eh, $mt, $entry, $original_entry)

Called before saving a new or existing entry. If saving a new entry, the
$original_entry will have an unassigned 'id'. This callback is executed
as a filter, so your handler must return 1 to allow the entry to be saved.

=item api_post_save.entry
=item api_post_save.page

    callback($eh, $mt, $entry, $original_entry)

Called after saving a new or existing entry. If saving a new entry, the
$original_entry will have an unassigned 'id'.

=item api_upload_file

    callback($eh, %params)

This callback is invoked for each file the user uploads to the weblog.
This callback is similar to the CMSUploadFile callback found in
C<MT::App::CMS>.

=back

=head2 Parameters

=over 4

=item File

The full physical file path of the uploaded file.

=item Url

The full URL to the file that has been uploaded.

=item Type

For this callback, this value is currently always 'file'.

=item Blog

The C<MT::Blog> object associated with the newly uploaded file.

=back

=cut
