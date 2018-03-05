# WXRImporter plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id$

package WXRImporter::Import;
use strict;
use warnings;

use base qw(MT::ErrorHandler);

use MT::I18N qw( guess_encoding );

sub import_contents {
    my $class = shift;
    my %param = @_;
    my $iter  = $param{Iter};
    my $blog  = $param{Blog}
        or return $class->error( MT->translate("No Site") );
    my $cb = $param{Callback} || sub { };
    my $encoding = $param{Encoding};

    my ( $root_path, $root_url, $relative_path );
    if ( my $p = delete $param{'mt_site_path'} ) {
        $root_path = $root_url = '%r';
    }
    else {
        $root_path = $root_url = '%a';
    }

    if ( $root_path && $root_url ) {
        $relative_path = delete $param{'mt_extra_path'};
        my $path = $root_path;
        if ($relative_path) {
            if ( $relative_path =~ m!\.\.|\0|\|! ) {
                return $class->error(
                    MT->translate(
                        "Invalid extra path '[_1]'",
                        $relative_path
                    )
                );
            }
            $path = File::Spec->catdir( $path, $relative_path );
        }

        ## $path should be local path to file now (we don't create/upload files nor mkpath)

        my $url = $path;
        $url =~ s!\\!/!g;

        $param{'mt_path'} = $path;
        $param{'mt_url'}  = $url;
    }

    if ( exists $param{ImportAs} ) {
    }
    elsif ( exists $param{ParentAuthor} ) {
        require MT::Auth;
        return $class->error(
            MT->translate(
                      "You need to provide a password if you are going to "
                    . "create new users for each user listed in your site."
            )
            )
            if MT::Auth->password_exists
            && !( exists $param{NewAuthorPassword} );
    }
    else {
        return $class->error(
            MT->translate("Need either ImportAs or ParentAuthor") );
    }
    $cb->("\n");
    my $import_result = eval {
        while ( my $stream = $iter->() ) {
            my $result = eval { $class->start_import( $stream, %param ); };
            $cb->($@) unless $result;
        }
        $class->errstr ? undef : 1;
    };
    $import_result;
}

sub start_import {
    my $self = shift;
    my ( $stream, %param ) = @_;

    #if (ref($stream) eq 'Fh') {
    #    $stream = WXRImporter::Stream->new($stream);
    #}

    my $xml = do {
        local $/ = undef;
        my $str = <$stream>;
        if ( my $encoding = $param{Encoding} ) {
            my $guess_encoding
                = $encoding eq 'guess' ? guess_encoding($str) : $encoding;
            $str = Encode::decode( $guess_encoding, $str );
        }
        $str;
        }
        || '';
    $xml
        =~ s{<wp:comment_content>(?:<!\[CDATA\[)?(.*?)(?:\]\]>)?</wp:comment_content>} 
             {<wp:comment_content><![CDATA[$1]]></wp:comment_content>}sg;
    use HTML::Entities::Numbered;
    $xml = HTML::Entities::Numbered::name2hex_xml($xml);

    require WXRImporter::WXRHandler;
    my $handler = WXRImporter::WXRHandler->new(
        callback       => $param{Callback},
        blog           => $param{Blog},
        def_cat_id     => $param{DefaultCategoryID},
        convert_breaks => $param{ConvertBreaks},
        ( exists $param{ImportAs} )
        ? ( author => $param{ImportAs} )
        : ( parent => $param{ParentAuthor} ),
        pass        => $param{NewAuthorPassword},
        wp_path     => $param{wp_path},
        mt_path     => $param{mt_path},
        mt_url      => $param{mt_url},
        wp_download => $param{wp_download},
    );

    require MT::Util;
    my $parser = MT::Util::sax_parser();
    $param{Callback}->( ref($parser) . "\n" )
        if MT::ConfigMgr->instance->DebugMode;
    $handler->{is_pp} = ref($parser) eq 'XML::SAX::PurePerl' ? 1 : 0;
    $parser->{Handler} = $handler;
    my $e;
    eval { $parser->parse_string($xml); };

    #eval { $parser->parse_file($stream); };
    $e = $@ if $@;
    if ($e) {
        $param{Callback}->($e);
        return $self->error($e);
    }
    1;
}

sub get_param {
    my ($blog_id) = shift;
    my $blog = MT::Blog->load($blog_id)
        or return;

    my $param = { blog_id => $blog_id };
    my $label_path;
    if ( $blog->column('archive_path') ) {
        $param->{enable_archive_paths} = 1;
        $label_path = MT->translate('Archive Root');
    }
    else {
        $label_path = MT->translate('Site Root');
    }
    $param->{missing_paths}
        = (    ( defined $blog->site_path || defined $blog->archive_path )
            && ( -d $blog->site_path || -d $blog->archive_path ) ) ? 0 : 1;
    $param;
}

## This package will be removed once WordPress fixes issues
## which it generates non-well formed XML (therefore it's
## not even XML at all).  See:
## http://trac.wordpress.org/ticket/4242
## http://trac.wordpress.org/ticket/4452
#package WXRImporter::Stream;
#
#use Symbol;
#
#use vars qw( $fh );
#sub new {
#    my $class = shift;
#    my $this = bless Symbol::gensym(), $class;
#    tie *$this, $this;
#    $fh = $_[0];
#    return $this;
#}
#
#sub read {
#    my $this = shift;
#    my $res = read($fh, $_[0], $_[1], $_[2] || 0);
#    my $string = $_[0];
#    $string = _encode_wp_comment($string);
#    $_[0] = $string;
#    $res;
#}
#
#sub binmode {
#    my $this = shift;
#    binmode $fh;
#}
#
#sub eof {
#    my $this = shift;
#    eof $fh;
#}
#
#sub close {
#    my $this = shift;
#    close $fh;
#}
#
#*READ   = \&read;
#*BINMODE = \&binmode;
#*EOF    = \&eof;
#*CLOSE  = \&close;
#
#sub TIEHANDLE {
#    return $_[0] if ref($_[0]);
#    my $class = shift;
#    my $this = bless Symbol::gensym(), $class;
#    $fh = $_[0];
#    return $this;
#}
#
#sub _encode_wp_comment {
#    my ($str) = @_;
#
#    use HTML::Entities::Numbered;
#    $str = name2hex_xml($str);
#    return $str;
#}

1;

__END__
