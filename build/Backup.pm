# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.movabletype.org.
#
# $Id$

## xxx Todo
## * remove no_utf8 code?
## * tests

package MT::Backup;
use strict;

use MIME::Base64 qw( encode_base64 );
use XML::SAX::ParserFactory;
use Compress::Zlib;
use File::Temp qw( tempfile ) ;

{
    my %enc = ('&' => '&amp;', '<' => '&lt;', "\xd" => '&#xd;');
    sub _encode_data {
        my $str = shift;
        ## If $str contains unclean characters, we need to encode it as
        ## base64. Otherwise, just encode the special characters => entities.
        if ($str =~ /[^\x09\x0a\x0d\x20-\x7f]/) {
            $str = encode_base64($str, '');
            return($str, 'base64');
        } else {
            $str =~ s!([&<\015])!$enc{$1}!g;
            $str =~ s!\]\]>!\]\]&gt;!g;
            $str;
        }
    }
}

my @CLASSES = qw( MT::Author MT::Blog MT::Category MT::Comment MT::Entry
                  MT::IPBanList MT::Log MT::Notification MT::Permission
                  MT::Placement MT::PluginData MT::Template MT::TemplateMap
                  MT::Trackback MT::TBPing );

sub backup {
    my $class = shift;
    my %param = @_;
    my $cb = $param{OutputCallback} || sub { print $_[0] };
    my $cb_end = sub { };

    if ($param{Compress}) {
        require Compress::Zlib;
        my($d, $status) = Compress::Zlib::deflateInit(
                               -Level => Compress::Zlib::Z_BEST_COMPRESSION(),
                               -WindowBits => - Compress::Zlib::MAX_WBITS() );
        ## Create a minimal gzip header.
        $cb->(pack 'C' . Compress::Zlib::MIN_HDR_SIZE(),
              Compress::Zlib::MAGIC1(), Compress::Zlib::MAGIC2(),
              Compress::Zlib::Z_DEFLATED(), 0, 0, 0, 0, 0, 0,
              Compress::Zlib::OSCODE());
        return $class->error("Compression error")
            unless $status == Compress::Zlib::Z_OK();
        my $copy = $cb;
        my($length, $crc) = (0);
        $cb = sub {
            my($str) = @_;
            $length += length($str);
            $crc = Compress::Zlib::crc32($str, $crc);
            my($out, $status) = $d->deflate($_[0]);
            return $class->error("Compression error")
                unless $status == Compress::Zlib::Z_OK();
            $copy->($out);
        };
        $cb_end = sub {
            my($out, $status) = $d->flush;
            return $class->error("Compression error")
                unless $status == Compress::Zlib::Z_OK();
            $copy->($out);
            $copy->(pack 'V V', $crc, $length);
        };
    }

    $cb->("<data>\n");
    for my $class (@CLASSES) {
        eval "use $class";
        return $class->error("Error loading $class: $@") if $@;
        my $iter = $class->load_iter;
        $cb->(sprintf <<HEAD, $class->datasource, $class);
<table>
<datasource>%s</datasource>
<class>%s</class>
<records>
HEAD
        while (my $obj = $iter->()) {
            my $cols = $obj->column_values;
            $cb->("<record>\n");
            for my $col (keys %$cols) {
                my($data, $enc) = _encode_data($cols->{$col});
                $cb->(sprintf <<COL, $col, $enc ? qq( encoding="base64") : '', $data);
<column>
<name>%s</name>
<value%s>%s</value>
</column>
COL
            }
            $cb->("</record>\n");
        }
        $cb->("</records></table>\n");
    }
    $cb->("</data>\n");
    $cb_end->();
    1;
}

sub restore {
    my $class = shift;
    my %param = @_;

    my $h = MT::SAXHandler->new;
    $h->{cb} = $param{DebugCallBack} || sub { };
    my $p = XML::SAX::ParserFactory->parser(Handler => $h);

    my $stream = $param{Stream};
    if (ref($stream) eq 'SCALAR') {
        $$stream = Compress::Zlib::memGunzip($$stream)
            if $param{Compressed};
        $p->parse_string($$stream);
    } else {
        if ($param{Compressed}) {
            my $fh = tempfile(undef, UNLINK => 1);
            binmode $fh;
            ## Works with either a filehandle or a filename.
            my $gz = gzopen($stream, 'rb');
            while ($gz->gzread(my($data))) {
                print $fh $data;
            }
            seek $fh, 0, 0;
            $p->parse_file($fh);
            close $fh;
        } else  {
            $p->parse_file($stream);
        }
    }

    my $cfg = MT::ConfigMgr->instance;
    if ($cfg->ObjectDriver eq 'DBM') {
        require DB_File;
        use File::Spec;
        my $ids = File::Spec->catfile($cfg->DataSource, 'ids.db');
        tie my %db, 'DB_File', $ids
            or die "Can't tie '$ids': $!";
        for my $class (keys %{ $h->{__ids} }) {
            $db{$class} = $h->{__ids}{$class};
        }
        untie %db;
    } elsif ($cfg->ObjectDriver eq 'DBI::postgres') {
        my $dbh = MT::Object->driver->{dbh};
        for my $class (keys %{ $h->{__ids} }) {
            my $seq = 'mt_' . $class->datasource . '_' .
                      $class->properties->{primary_key};
            $dbh->do("select setval('$seq', $h->{__ids}{$class})")
                or die $dbh->errstr;
        }
    }
    1;
}

package MT::SAXHandler;
use strict;
use base qw( XML::SAX::Base );

use MIME::Base64 qw( decode_base64 );

sub no_utf8 {
    for (@_) {
        $_ = pack 'C0A*', $_;
    }
}

sub start_element {
    my $h = shift;
    my($ref) = @_;
    my $key = $ref->{LocalName};
    $h->{__key} = $key;
    if ($key eq 'record') {
        $h->{__columns} = {};
    } elsif ($key eq 'value') {
        $h->{__column_value_encoding} = $ref->{Attributes}{'{}encoding'}{Value};
    }
    1;
}

sub characters {
    my $h = shift;
    my($ref) = @_;
    return unless $h->{__key};
    my $data = $ref->{Data};
    if ($h->{__key} eq 'class') {
        $h->{__class} .= $data;
    } elsif ($h->{__key} eq 'name') {
        $h->{__column_name} .= $data;
    } elsif ($h->{__key} eq 'value') {
        $h->{__column_value} .= $data;
    }
    1;
}

sub end_element {
    my $h = shift;
    my($ref) = @_;
    my $key = $ref->{LocalName};
    $h->{__key} = undef;
    my $cb = $h->{cb};
    if ($key eq 'table') {
        $cb->("done\n");
        $h->{__class} = undef;
    } elsif ($key eq 'class') {
        $cb->("Loading '$h->{__class}': ");
        $h->{i} = 0;
    } elsif ($key eq 'record') {
        ## Gather columns and create object.
        my $class = $h->{__class}
            or die "No class defined for object";
        eval "use $class;";
        die "Loading '$class' failed: $@" if $@;
        my $obj = $class->new;
        $obj->set_values($h->{__columns});
        #use Data::Dumper; print Dumper $obj;
        $obj->save or die "Save failed: ", $obj->errstr;
        $h->{__columns} = undef;

        $h->{__ids}{$class} = $obj->id
            if !$h->{__ids}{$class} || $obj->id > $h->{__ids}{$class};

        if ($h->{i}++ % 20 == 0) {
            $cb->('.');
        }
    } elsif ($key eq 'column') {
        ## Store column data.
        $h->{__columns}{$h->{__column_name}} = $h->{__column_value};
        $h->{__column_name} = undef;
        $h->{__column_value} = undef;
    } elsif ($key eq 'value') {
        my $enc = $h->{__column_value_encoding};
        if ($enc && $enc eq 'base64') {
            $h->{__column_value} = decode_base64($h->{__column_value});
        }
        $h->{__column_value_encoding} = undef;
        no_utf8($h->{__column_value}) if defined $h->{__column_value};
    }
    1;
}

1;
