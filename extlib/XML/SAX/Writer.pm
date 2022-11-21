package XML::SAX::Writer;
$XML::SAX::Writer::VERSION = '0.57';
use strict;
use warnings;
use vars qw(%DEFAULT_ESCAPE %ATTRIBUTE_ESCAPE %COMMENT_ESCAPE);

# ABSTRACT: SAX2 XML Writer

use Encode                  qw();
use XML::SAX::Exception     qw();
use XML::SAX::Writer::XML   qw();
use XML::Filter::BufferText qw();
@XML::SAX::Writer::Exception::ISA = qw(XML::SAX::Exception);


%DEFAULT_ESCAPE = (
                    '&'     => '&amp;',
                    '<'     => '&lt;',
                    '>'     => '&gt;',
                    '"'     => '&quot;',
                    "'"     => '&apos;',
                  );

%ATTRIBUTE_ESCAPE = (
                    %DEFAULT_ESCAPE,
                    "\t"    => '&#x9;',
                    "\n"    => '&#xA;',
                    "\r"    => '&#xD;',
                  );

%COMMENT_ESCAPE = (
                    '--'    => '&#45;&#45;',
                  );


#-------------------------------------------------------------------#
# new
#-------------------------------------------------------------------#
sub new {
    my $class = ref($_[0]) ? ref(shift) : shift;
    my $opt   = (@_ == 1)  ? { %{shift()} } : {@_};

    # default the options
    $opt->{Writer}          ||= 'XML::SAX::Writer::XML';
    $opt->{Escape}          ||= \%DEFAULT_ESCAPE;
    $opt->{AttributeEscape} ||= \%ATTRIBUTE_ESCAPE;
    $opt->{CommentEscape}   ||= \%COMMENT_ESCAPE;
    $opt->{EncodeFrom}        = exists $opt->{EncodeFrom} ? $opt->{EncodeFrom} : 'utf-8';
    $opt->{EncodeTo}          = exists $opt->{EncodeTo}   ? $opt->{EncodeTo}   : 'utf-8';
    $opt->{Format}          ||= {}; # needs options w/ defaults, we'll see later
    $opt->{Output}          ||= *{STDOUT}{IO};
    $opt->{QuoteCharacter}  ||= q['];

    eval "use $opt->{Writer};";

    my $obj = bless $opt, $opt->{Writer};
    $obj->init;

    # we need to buffer the text to escape it right
    my $bf = XML::Filter::BufferText->new( Handler => $obj );

    return $bf;
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# init
#-------------------------------------------------------------------#
sub init {} # noop, for subclasses
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# setConverter
#-------------------------------------------------------------------#
sub setConverter {
    my $self = shift;

    if (lc($self->{EncodeFrom}) ne lc($self->{EncodeTo})) {
        $self->{Encoder} = XML::SAX::Writer::Encode->new($self->{EncodeFrom}, $self->{EncodeTo});
    }
    else {
        $self->{Encoder} = XML::SAX::Writer::NullConverter->new;
    }
    return $self;
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# setConsumer
#-------------------------------------------------------------------#
sub setConsumer {
    my $self = shift;

    # create the Consumer
    my $ref = ref $self->{Output};
    if ($ref eq 'SCALAR') {
        $self->{Consumer} = XML::SAX::Writer::StringConsumer->new($self->{Output});
    }
    elsif ($ref eq 'CODE') {
        $self->{Consumer} = XML::SAX::Writer::CodeConsumer->new($self->{Output});
    }
    elsif ($ref eq 'ARRAY') {
        $self->{Consumer} = XML::SAX::Writer::ArrayConsumer->new($self->{Output});
    }
    elsif (
            $ref eq 'GLOB'                                or
            UNIVERSAL::isa(\$self->{Output}, 'GLOB')      or
            UNIVERSAL::isa($self->{Output}, 'IO::Handle')) {
        $self->{Consumer} = XML::SAX::Writer::HandleConsumer->new($self->{Output});
    }
    elsif (not $ref) {
        $self->{Consumer} = XML::SAX::Writer::FileConsumer->new($self->{Output});
    }
    elsif (UNIVERSAL::can($self->{Output}, 'output')) {
        $self->{Consumer} = $self->{Output};
    }
    else {
        XML::SAX::Writer::Exception->throw( Message => 'Unknown option for Output' );
    }
    return $self;
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# setEscaperRegex
#-------------------------------------------------------------------#
sub setEscaperRegex {
    my $self = shift;

    $self->{EscaperRegex} = eval 'qr/'                                                .
                            join( '|', map { $_ = "\Q$_\E" } keys %{$self->{Escape}}) .
                            '/;'                                                  ;
    return $self;
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# setAttributeEscaperRegex
#-------------------------------------------------------------------#
sub setAttributeEscaperRegex {
    my $self = shift;

        $self->{AttributeEscaperRegex} = 
            eval 'qr/'                                                         .
            join( '|', map { $_ = "\Q$_\E" } keys %{$self->{AttributeEscape}}) .
            '/;'                                                               ;
    return $self;
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# setCommentEscaperRegex
#-------------------------------------------------------------------#
sub setCommentEscaperRegex {
    my $self = shift;

    $self->{CommentEscaperRegex} =
                        eval 'qr/'                                                .
                        join( '|', map { $_ = "\Q$_\E" } keys %{$self->{CommentEscape}}) .
                        '/;'                                                  ;
    return $self;
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# escape
#-------------------------------------------------------------------#
sub escape {
    my $self = shift;
    my $str  = shift;

    $str =~ s/($self->{EscaperRegex})/$self->{Escape}->{$1}/ge;
    return $str;
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# escapeAttribute
#-------------------------------------------------------------------#
sub escapeAttribute {
    my $self = shift;
    my $str  = shift;

    $str =~ s/($self->{AttributeEscaperRegex})/$self->{AttributeEscape}->{$1}/ge;
    return $str;
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# escapeComment
#-------------------------------------------------------------------#
sub escapeComment {
    my $self = shift;
    my $str  = shift;

    $str =~ s/($self->{CommentEscaperRegex})/$self->{CommentEscape}->{$1}/ge;
    return $str;
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# convert and checking the return value
#-------------------------------------------------------------------#
sub safeConvert {
    my $self = shift;
    my $str = shift;

    my $out = $self->{Encoder}->convert($str);

    if (!defined $out && defined $str) {
        warn "Conversion error returned by Encoder [$self->{Encoder}], string: '$str'";
        $out = '_LOST_DATA_';
    }
    return $out;
}
#-------------------------------------------------------------------#


#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#
#`,`, The Empty Consumer ,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,#
#```````````````````````````````````````````````````````````````````#

# this package is only there to provide a smooth upgrade path in case
# new methods are added to the interface

package XML::SAX::Writer::ConsumerInterface;
$XML::SAX::Writer::ConsumerInterface::VERSION = '0.57';
sub new {
    my $class = shift;
    my $ref = shift;
    ## $self is a reference to the reference that we will send output
    ## to.  This allows us to bless $self without blessing $$self.
    return bless \$ref, ref $class || $class;
}

sub output {}
sub finalize {}


#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#
#`,`, The String Consumer `,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,#
#```````````````````````````````````````````````````````````````````#

package XML::SAX::Writer::StringConsumer;
$XML::SAX::Writer::StringConsumer::VERSION = '0.57';
@XML::SAX::Writer::StringConsumer::ISA = qw(XML::SAX::Writer::ConsumerInterface);

#-------------------------------------------------------------------#
# new
#-------------------------------------------------------------------#
sub new {
    my $self = shift->SUPER::new( @_ );
    ${${$self}} = '';
    return $self;
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# output
#-------------------------------------------------------------------#
sub output { ${${$_[0]}} .= $_[1] }
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# finalize
#-------------------------------------------------------------------#
sub finalize { ${$_[0]} }
#-------------------------------------------------------------------#

#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#
#`,`, The Code Consumer `,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,#
#```````````````````````````````````````````````````````````````````#

package XML::SAX::Writer::CodeConsumer;
$XML::SAX::Writer::CodeConsumer::VERSION = '0.57';
@XML::SAX::Writer::CodeConsumer::ISA = qw(XML::SAX::Writer::ConsumerInterface );

#-------------------------------------------------------------------#
# new
#-------------------------------------------------------------------#
sub new {
    my $self = shift->SUPER::new( @_ );
    $$self->( 'start_document', '' );
    return $self;
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# output
#-------------------------------------------------------------------#
sub output { ${$_[0]}->('data', pop) } ## Avoid an extra copy
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# finalize
#-------------------------------------------------------------------#
sub finalize { ${$_[0]}->('end_document', '') }
#-------------------------------------------------------------------#


#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#
#`,`, The Array Consumer ,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,#
#```````````````````````````````````````````````````````````````````#

package XML::SAX::Writer::ArrayConsumer;
$XML::SAX::Writer::ArrayConsumer::VERSION = '0.57';
@XML::SAX::Writer::ArrayConsumer::ISA = qw(XML::SAX::Writer::ConsumerInterface);

#-------------------------------------------------------------------#
# new
#-------------------------------------------------------------------#
sub new {
    my $self = shift->SUPER::new( @_ );
    @$$self = ();
    return $self;
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# output
#-------------------------------------------------------------------#
sub output { push @${$_[0]}, pop }
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# finalize
#-------------------------------------------------------------------#
sub finalize { return ${$_[0]} }
#-------------------------------------------------------------------#


#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#
#`,`, The Handle Consumer `,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,#
#```````````````````````````````````````````````````````````````````#

package XML::SAX::Writer::HandleConsumer;
$XML::SAX::Writer::HandleConsumer::VERSION = '0.57';
@XML::SAX::Writer::HandleConsumer::ISA = qw(XML::SAX::Writer::ConsumerInterface);

#-------------------------------------------------------------------#
# output
#-------------------------------------------------------------------#
sub output {
    my $fh = ${$_[0]};
    print $fh pop or XML::SAX::Exception->throw(
        Message => "Could not write to handle: $fh ($!)"
    );
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# finalize
#-------------------------------------------------------------------#
sub finalize { return 0 }
#-------------------------------------------------------------------#


#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#
#`,`, The File Consumer `,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,#
#```````````````````````````````````````````````````````````````````#

package XML::SAX::Writer::FileConsumer;
$XML::SAX::Writer::FileConsumer::VERSION = '0.57';
@XML::SAX::Writer::FileConsumer::ISA = qw(XML::SAX::Writer::HandleConsumer);

#-------------------------------------------------------------------#
# new
#-------------------------------------------------------------------#
sub new {
    my ( $proto, $file, $opt ) = @_;
    my $enc_to = (defined $opt and ref $opt eq 'HASH'
                  and defined $opt->{EncodeTo}) ? $opt->{EncodeTo}
                                                : 'utf-8';

    XML::SAX::Writer::Exception->throw(
        Message => "No filename provided to " . ref( $proto || $proto )
    ) unless defined $file;

    local *XFH;

    open XFH, ">:encoding($enc_to)", $file
      or XML::SAX::Writer::Exception->throw(
        Message => "Error opening file $file: $!"
      );

    return $proto->SUPER::new( *{XFH}{IO}, @_ );
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# finalize
#-------------------------------------------------------------------#
sub finalize {
    close ${$_[0]};
    return 0;
}
#-------------------------------------------------------------------#


#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#
#`,`, Noop Converter ,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,#
#```````````````````````````````````````````````````````````````````#

package XML::SAX::Writer::NullConverter;
$XML::SAX::Writer::NullConverter::VERSION = '0.57';
sub new     { return bless [], __PACKAGE__ }
sub convert { $_[1] }


#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#
#`,`, Encode Converter ,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,#
#```````````````````````````````````````````````````````````````````#

package XML::SAX::Writer::Encode;
$XML::SAX::Writer::Encode::VERSION = '0.57';
sub new {
    my ($class, $from, $to) = @_;
    my $self = {
        from_enc => $from,
        to_enc   => $to,
    };
    return bless $self, $class;
}
sub convert {
    my ($self, $data) = @_;
    eval {
        $data = Encode::decode($self->{from_enc}, $data) if $self->{from_enc};
        $data = Encode::encode($self->{to_enc}, $data, Encode::FB_CROAK) if $self->{to_enc};
    };
    if ($@) {
        warn $@;
        return;
    }
    return $data;
};


1;

=pod

=encoding UTF-8

=head1 NAME

XML::SAX::Writer - SAX2 XML Writer

=head1 VERSION

version 0.57

=head1 SYNOPSIS

  use XML::SAX::Writer;
  use XML::SAX::SomeDriver;

  my $w = XML::SAX::Writer->new;
  my $d = XML::SAX::SomeDriver->new(Handler => $w);

  $d->parse('some options...');

=head1 DESCRIPTION

=head2 Why yet another XML Writer ?

A new XML Writer was needed to match the SAX2 effort because quite
naturally no existing writer understood SAX2. My first intention had
been to start patching XML::Handler::YAWriter as it had previously
been my favourite writer in the SAX1 world.

However the more I patched it the more I realised that what I thought
was going to be a simple patch (mostly adding a few event handlers and
changing the attribute syntax) was turning out to be a rewrite due to
various ideas I'd been collecting along the way. Besides, I couldn't
find a way to elegantly make it work with SAX2 without breaking the
SAX1 compatibility which people are probably still using. There are of
course ways to do that, but most require user interaction which is
something I wanted to avoid.

So in the end there was a new writer. I think it's in fact better this
way as it helps keep SAX1 and SAX2 separated.

=head1 METHODS

=over 4

=item * new(%hash)

This is the constructor for this object. It takes a number of
parameters, all of which are optional.

=item * Output

This parameter can be one of several things. If it is a simple
scalar, it is interpreted as a filename which will be opened for
writing. If it is a scalar reference, output will be appended to this
scalar. If it is an array reference, output will be pushed onto this
array as it is generated. If it is a filehandle, then output will be
sent to this filehandle.

Finally, it is possible to pass an object for this parameter, in which
case it is assumed to be an object that implements the consumer
interface L<described later in the documentation|/THE CONSUMER
INTERFACE>.

If this parameter is not provided, then output is sent to STDOUT.

Note that there is no means to set an encoding layer on filehandles
created by this module; if this is necessary, the calling code should
first open a filehandle with the appropriate encoding set, and pass
that filehandle to this module.

=item * Escape

This should be a hash reference where the keys are characters
sequences that should be escaped and the values are the escaped form
of the sequence. By default, this module will escape the ampersand
(&), less than (<), greater than (>), double quote ("), and apostrophe
('). Note that some browsers don't support the &apos; escape used for
apostrophes so that you should be careful when outputting XHTML.

If you only want to add entries to the Escape hash, you can first
copy the contents of %XML::SAX::Writer::DEFAULT_ESCAPE.

=item * CommentEscape

Comment content often needs to be escaped differently from other
content. This option works exactly as the previous one except that
by default it only escapes the double dash (--) and that the contents
can be copied from %XML::SAX::Writer::COMMENT_ESCAPE.

=item * EncodeFrom

The character set encoding in which incoming data will be provided.
This defaults to UTF-8, which works for US-ASCII as well.

Set this to C<undef> if you do not wish to decode your data.

=item * EncodeTo

The character set encoding in which output should be encoded. Again,
this defaults to UTF-8.

Set this to C<undef> if you do not with to encode your data.

=item * QuoteCharacter

Set the character used to quote attributes. This defaults to single quotes (') 
for backwards compatibility.

=back

=head1 THE CONSUMER INTERFACE

XML::SAX::Writer can receive pluggable consumer objects that will be
in charge of writing out what is formatted by this module. Setting a
Consumer is done by setting the Output option to the object of your
choice instead of to an array, scalar, or file handle as is more
commonly done (internally those in fact map to Consumer classes and
and simply available as options for your convenience).

If you don't understand this, don't worry. You don't need it most of
the time.

That object can be from any class, but must have two methods in its
API. It is also strongly recommended that it inherits from
XML::SAX::Writer::ConsumerInterface so that it will not break if that
interface evolves over time. There are examples at the end of
XML::SAX::Writer's code.

The two methods that it needs to implement are:

=over 4

=item * output STRING

(Required)

This is called whenever the Writer wants to output a string formatted
in XML. Encoding conversion, character escaping, and formatting have
already taken place. It's up to the consumer to do whatever it wants
with the string.

=item * finalize()

(Optional)

This is called once the document has been output in its entirety,
during the end_document event. end_document will in fact return
whatever finalize() returns, and that in turn should be returned
by parse() for whatever parser was invoked. It might be useful if
you need to provide feedback of some sort.

=back

Here's an example of a custom consumer.  Note the extra C<$> signs in
front of $self; the base class is optimized for the overwhelmingly
common case where only one data member is required and $self is a
reference to that data member.

    package MyConsumer;

    @ISA = qw( XML::SAX::Writer::ConsumerInterface );

    use strict;

    sub new {
        my $self = shift->SUPER::new( my $output );

        $$self = '';      # Note the extra '$'

        return $self;
    }

    sub output {
        my $self = shift;
        $$self .= uc shift;
    }

    sub get_output {
        my $self = shift;
        return $$self;
    }

And here is one way to use it:

    my $c = MyConsumer->new;
    my $w = XML::SAX::Writer->new( Output => $c );

    ## ... send events to $w ...

    print $c->get_output;

If you need to store more that one data member, pass in an array or hash
reference:

        my $self = shift->SUPER::new( {} );

and access it like:

    sub output {
        my $self = shift;
        $$self->{Output} .= uc shift;
    }

=head1 THE ENCODER INTERFACE

Encoders can be plugged in to allow one to use one's favourite encoder
object. Presently there are two encoders: Encode and NullEncoder. They
need to implement two methods, and may inherit from
XML::SAX::Writer::NullConverter if they wish to

=over 4

=item new FROM_ENCODING, TO_ENCODING

Creates a new Encoder. The arguments are the chosen encodings.

=item convert STRING

Converts that string and returns it.

=back

Note that the return value of the convert method is B<not> checked. Output may
be truncated if a character couldn't be converted correctly. To avoid problems
the encoder should take care encoding errors itself, for example by raising an
exception.

=head1 CUSTOM OUTPUT

This module is generally used to write XML -- which it does most of the
time -- but just like the rest of SAX it can be used as a generic
framework to output data, the opposite of a non-XML SAX parser.

Of course there's only so much that one can abstract, so depending on
your format this may or may not be useful. If it is, you'll need to
know the following API (and probably to have a look inside
C<XML::SAX::Writer::XML>, the default Writer).

=over

=item init

Called before the writing starts, it's a chance for the subclass to do
some initialisation if it needs it.

=item setConverter

This is used to set the proper converter for character encodings. The
default implementation should suffice but you can override it. It must
set C<< $self->{Encoder} >> to an Encoder object. Subclasses *should* call
it.

=item setConsumer

Same as above, except that it is for the Consumer object, and that it
must set C<< $self->{Consumer} >>.

=item setEscaperRegex

Will initialise the escaping regex C<< $self->{EscaperRegex} >> based on
what is needed.

=item escape STRING

Takes a string and escapes it properly.

=item setCommentEscaperRegex and escapeComment STRING

These work exactly the same as the two above, except that they are meant
to operate on comment contents, which often have different escaping rules
than those that apply to regular content.

=back

=head1 TODO

    - proper UTF-16 handling

    - the formatting options need to be developed.

    - test, test, test (and then some tests)

    - doc, doc, doc (actually this part is in better shape)

    - remove the xml_decl and replace it with intelligent logic, as
    discussed on perl-xml

    - make a the Consumer selecting code available in the API, to avoid
    duplicating

    - add an Apache output Consumer, triggered by passing $r as Output

=head1 CREDITS

Michael Koehne (XML::Handler::YAWriter) for much inspiration and Barrie
Slaymaker for the Consumer pattern idea, the coderef output option and
miscellaneous bugfixes and performance tweaks. Of course the usual
suspects (Kip Hampton and Matt Sergeant) helped in the usual ways.

=head1 SEE ALSO

XML::SAX::*

=head1 AUTHORS

=over 4

=item *

Robin Berjon <robin@knowscape.com>

=item *

Chris Prather <chris@prather.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Robin Berjon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

__END__
#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#
#`,`, Documentation `,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,#
#```````````````````````````````````````````````````````````````````#


