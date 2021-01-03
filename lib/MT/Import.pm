# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Import;

use strict;
use warnings;
use base qw(MT::ErrorHandler Exporter);

our @EXPORT;
our %Importers;

use Symbol;

sub new {
    my $class = shift;
    my $obj = bless {}, $class;
    $obj->init(@_);
    $obj;
}

sub importer_keys {
    init() unless %Importers;
    keys %Importers;
}

sub importer {
    my $mt = shift;
    my ($importer) = @_;
    init() unless %Importers;
    return $Importers{$importer} if defined $importer && $importer ne '';
    return;
}

sub init {
    my $self = shift;
    my $importers = MT->instance->registry("import_formats") || {};
    %Importers = %$importers;
}

sub core_import_formats {
    return {
        'import_mt' => {
            label   => 'Movable Type',
            type    => 'MT::ImportExport',
            handler => 'MT::ImportExport::import_contents',
        },
        'import_mt_format' => {
            label   => 'Another system (Movable Type format)',
            type    => 'MT::ImportExport',
            handler => 'MT::ImportExport::import_contents',
            options => [ 'title_start', 'title_end', 'default_status' ],
            options_template => 'import_others.tmpl',
        }
    };
}

sub _get_stream_iterator {
    my $class = shift;
    my ( $stream, $cb ) = @_;
    my $iter;
    if ( UNIVERSAL::isa( $stream, 'Fh' ) ) {
        seek( $stream, 0, 0 )
            or return $class->error( MT->translate("Cannot rewind") );
        $iter = sub {
            my $str = $stream;
            my $eof = eof($stream);
            return $eof ? undef : $str;
        };
    }
    elsif ( ref($stream) eq 'SCALAR' ) {
        require IO::String;
        $stream = IO::String->new($$stream);
        $iter   = sub {
            my $str = $stream;
            $stream = undef;
            $str;
        };
    }
    elsif ( ref $stream ) {
        seek( $stream, 0, 0 )
            or return $class->error( MT->translate("Cannot rewind") );
        $iter = sub {
            my $str = $stream;
            $stream = undef;
            $str;
        };
    }
    else {
        if ( -f $stream ) {
            my $fh = gensym();
            open $fh, "<", $stream
                or return $class->error(
                MT->translate( "Cannot open '[_1]': [_2]", $stream, $! ) );
            $stream = $fh;
            $iter   = sub {
                my $str = $stream;
                $stream = undef;
                $str;
            };
        }
        elsif ( -d $stream ) {
            my @files_to_import;
            my $dir = $stream;
            $stream = undef;
            opendir DH,
                $dir
                or return $class->error(
                MT->translate(
                    "Cannot open directory '[_1]': [_2]",
                    $dir, "$!"
                )
                );
            for my $f ( readdir DH ) {
                next if $f =~ /^\./;
                my $file = File::Spec->catfile( $dir, $f );
                push @files_to_import, $file if -r $file;
            }
            closedir DH;
            unless (@files_to_import) {
                return $class->error(
                    MT->translate(
                        "No readable files could be found in your import directory [_1].",
                        $dir
                    )
                );
            }
            $iter = sub {
                close $stream if $stream;
                return undef unless @files_to_import;
                my $file = shift @files_to_import;
                my $fh   = gensym();
                $cb->(
                    MT->translate( "Importing entries from file '[_1]'",
                        $file )
                        . "\n"
                );
                open $fh, "<", $file
                    or return $class->error(
                    MT->translate( "Cannot open '[_1]': [_2]", $file, $! ) );
                $stream = $fh;
            };
        }
        else {
            return $class->error(
                MT->translate( "File not found: [_1]", $stream ) );
        }
    }
    $iter;
}

sub import_contents {
    my $self     = shift;
    my %param    = @_;
    my $stream   = delete $param{Stream};
    my $iter     = $self->_get_stream_iterator( $stream, $param{Callback} );
    my $importer = $self->importer( $param{Key} );
    $param{Iter} = $iter;
    my $code = $importer->{code} || $importer->{handler};
    unless ( ref $code eq 'CODE' ) {
        $code = $importer->{code} = MT->handler_to_coderef($code);
    }
    if ($code) {
        if ( not $iter ) {
            $importer->{type}->error( $self->errstr );
            return;
        }
        my $result
            = eval { $importer->{code}->( $importer->{type}, %param ); };
        print "Error: $@" if $@;
        return $result;
    }
    else {
        return $self->error(
            MT->translate(
                "Could not resolve import format [_1]",
                $param{Key}
            )
        );
    }
}

sub _get_options_tmpl {
    my $self = shift;
    my ($key) = @_;

    my $importer = $self->importer($key);
    my $tmpl     = $importer->{options_template};
    return q() unless $tmpl;
    return $tmpl->($importer) if ref $tmpl eq 'CODE';
    if ( $tmpl =~ /\s/ ) {
        return $tmpl;
    }
    else {    # no spaces in $tmpl; must be a filename...
        if ( my $c = $importer->{plugin} ) {
            my $ret = $c->load_tmpl($tmpl) or die $c->errstr;
            return $ret;
        }
        else {
            return MT->instance->load_tmpl($tmpl);
        }
    }
}

sub get_options_html {
    my $self = shift;
    my ( $key, $blog_id ) = @_;
    return q() unless $blog_id;
    my $importer = $self->importer($key);

    my $blog_class = MT->model('blog');
    my $blog       = $blog_class->load($blog_id)
        or return q();

    my $snip_tmpl = $self->_get_options_tmpl($key);
    return q() unless $snip_tmpl;

    require MT::Template;
    my $tmpl;
    if ( ref $snip_tmpl ne 'MT::Template' ) {
        $tmpl = MT::Template->new(
            type   => 'scalarref',
            source => ref $snip_tmpl ? $snip_tmpl : \$snip_tmpl,
        );
    }
    else {
        $tmpl = $snip_tmpl;
    }

    if ( my $options_param = $importer->{options_param} ) {
        if ( ref($options_param) ne 'CODE' ) {
            if ( my $c = $importer->{plugin} ) {
                $options_param = MT->handler_to_coderef($options_param);
            }
        }
        my $param;
        $param = $options_param->($blog_id)
            if ref $options_param eq 'CODE';

        $param->{blog_id} = $blog_id;
        $param->{missing_paths}
            = (    ( defined $blog->site_path || defined $blog->archive_path )
                && ( -d $blog->site_path || -d $blog->archive_path ) )
            ? 0
            : 1;

        # XXX always true because of autovivification
        $tmpl->param($param) if $param;
    }
    my $html = $tmpl->output();
    warn $tmpl->errstr if ( $MT::DebugMode && !$html && $tmpl->errstr );
    $html = '' unless defined $html;
    if ( $html =~ m/<(_|MT)_TRANS /i ) {
        if ( my $c = $importer->{plugin} ) {
            $html = $c->translate_templatized($html);
        }
        else {
            $html = MT->translate_templatized($html);
        }
    }
    return $html;
}

1;

__END__

=head1 NAME

MT::Import

=head1 METHODS

=head2 new

Returns a new MT::Import instance.

=head2 init

Loads the import_formats registry to the C<%Importers> package variable. This is
an internal subroutine.

=head2 core_import_formats

Returns the import_formats registry.

=head2 importer($format_name)

Returns the import_formats registry specified by C<$format_name>.

=head2 importer_keys

Returns all key values of the import_formats registry.

=head2 import_contents(%param)

This method is called from CMS when user decided to import files in a selected format.
This method calls selected importer's method to do actual imports.

=head2 get_options_html( $key, $blog_id )

Generates a part of HTML specified by C<$key> and C<$blog_id>, for "Import Website/Blog Entries" screen.

=head2 register_importer($importer)

This method collects importer from a plugin which requests to add itself to
the importer list.  Collected information will be used to show the format
selection in the dropdown on the Import/Export screen, and actual call
to import data from uploaded files.

The information registered as an importer must have the following data
in a single hash:

    my $plugin = new Foo::Bar::Plugin({...});
    $plugin->register_importer({
        name => 'Name of the format which will appear in dropdown',
        key => 'importer_key_which_will_differentiate_it_from_others',
        code => \&Package::method_which_do_import,
        options => [ 'options', 'to', 'receive' ],
        options_template => 'template name' or \&template_code of options,
        options_param => \&Package::method_to_populate_param,
    });

The subroutine referenced by the "code" key takes the following parameters.

    {
        Iter => iterator of streams of files to be imported
        Blog => reference to the blog object which accepts imports
        Callback => subroutine reference used to report progress
        Encoding => specified encoding method for files
        ImportAs or ParentAuthor => reference to author object
        NewAuthorPassword => default password for newly created authors
        DefaultCategoryID => default category id to be used
        key => value, other options 
    }

The subroutine referenced by the "options_param" key takes the following parameters.

    blog_id: blog's id which is importing data.

The subroutine should return a reference to a hash which contains parameters passed to
template upon building html.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
