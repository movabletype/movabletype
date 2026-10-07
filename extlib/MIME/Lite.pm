package MIME::Lite 3.038;
# ABSTRACT: low-calorie MIME generator
use v5.12.0;
use warnings;

use File::Basename;

#pod =begin :prelude
#pod
#pod =head1 WAIT!
#pod
#pod MIME::Lite is not recommended by its current maintainer.  There are a number of
#pod alternatives, like Email::MIME or MIME::Entity and Email::Sender, which you
#pod should probably use instead.  MIME::Lite continues to accrue weird bug reports,
#pod and it is not receiving a large amount of refactoring due to the availability
#pod of better alternatives.  Please consider using something else.
#pod
#pod =end :prelude
#pod
#pod =head1 SYNOPSIS
#pod
#pod Create and send using the default send method for your OS a single-part message:
#pod
#pod     use MIME::Lite;
#pod     ### Create a new single-part message, to send a GIF file:
#pod     $msg = MIME::Lite->new(
#pod         From     => 'me@myhost.com',
#pod         To       => 'you@yourhost.com',
#pod         Cc       => 'some@other.com, some@more.com',
#pod         Subject  => 'Helloooooo, nurse!',
#pod         Type     => 'image/gif',
#pod         Encoding => 'base64',
#pod         Path     => 'hellonurse.gif'
#pod     );
#pod     $msg->send; # send via default
#pod
#pod Create a multipart message (i.e., one with attachments) and send it via SMTP
#pod
#pod     ### Create a new multipart message:
#pod     $msg = MIME::Lite->new(
#pod         From    => 'me@myhost.com',
#pod         To      => 'you@yourhost.com',
#pod         Cc      => 'some@other.com, some@more.com',
#pod         Subject => 'A message with 2 parts...',
#pod         Type    => 'multipart/mixed'
#pod     );
#pod
#pod     ### Add parts (each "attach" has same arguments as "new"):
#pod     $msg->attach(
#pod         Type     => 'TEXT',
#pod         Data     => "Here's the GIF file you wanted"
#pod     );
#pod     $msg->attach(
#pod         Type     => 'image/gif',
#pod         Path     => 'aaa000123.gif',
#pod         Filename => 'logo.gif',
#pod         Disposition => 'attachment'
#pod     );
#pod     ### use Net::SMTP to do the sending
#pod     $msg->send('smtp','some.host', Debug=>1 );
#pod
#pod Output a message:
#pod
#pod     ### Format as a string:
#pod     $str = $msg->as_string;
#pod
#pod     ### Print to a filehandle (say, a "sendmail" stream):
#pod     $msg->print(\*SENDMAIL);
#pod
#pod Send a message:
#pod
#pod     ### Send in the "best" way (the default is to use "sendmail"):
#pod     $msg->send;
#pod     ### Send a specific way:
#pod     $msg->send('type',@args);
#pod
#pod Specify default send method:
#pod
#pod     MIME::Lite->send('smtp','some.host',Debug=>0);
#pod
#pod with authentication
#pod
#pod     MIME::Lite->send('smtp','some.host', AuthUser=>$user, AuthPass=>$pass);
#pod
#pod using SSL
#pod
#pod     MIME::Lite->send('smtp','some.host', SSL => 1, Port => 465 );
#pod
#pod =head1 DESCRIPTION
#pod
#pod In the never-ending quest for great taste with fewer calories,
#pod we proudly present: I<MIME::Lite>.
#pod
#pod MIME::Lite is intended as a simple, standalone module for generating
#pod (not parsing!) MIME messages... specifically, it allows you to
#pod output a simple, decent single- or multi-part message with text or binary
#pod attachments.  It does not require that you have the Mail:: or MIME::
#pod modules installed, but will work with them if they are.
#pod
#pod You can specify each message part as either the literal data itself (in
#pod a scalar or array), or as a string which can be given to open() to get
#pod a readable filehandle (e.g., "<filename" or "somecommand|").
#pod
#pod You don't need to worry about encoding your message data:
#pod this module will do that for you.  It handles the 5 standard MIME encodings.
#pod
#pod =head1 EXAMPLES
#pod
#pod =head2 Create a simple message containing just text
#pod
#pod     $msg = MIME::Lite->new(
#pod         From     =>'me@myhost.com',
#pod         To       =>'you@yourhost.com',
#pod         Cc       =>'some@other.com, some@more.com',
#pod         Subject  =>'Helloooooo, nurse!',
#pod         Data     =>"How's it goin', eh?"
#pod     );
#pod
#pod =head2 Create a simple message containing just an image
#pod
#pod     $msg = MIME::Lite->new(
#pod         From     =>'me@myhost.com',
#pod         To       =>'you@yourhost.com',
#pod         Cc       =>'some@other.com, some@more.com',
#pod         Subject  =>'Helloooooo, nurse!',
#pod         Type     =>'image/gif',
#pod         Encoding =>'base64',
#pod         Path     =>'hellonurse.gif'
#pod     );
#pod
#pod
#pod =head2 Create a multipart message
#pod
#pod     ### Create the multipart "container":
#pod     $msg = MIME::Lite->new(
#pod         From    =>'me@myhost.com',
#pod         To      =>'you@yourhost.com',
#pod         Cc      =>'some@other.com, some@more.com',
#pod         Subject =>'A message with 2 parts...',
#pod         Type    =>'multipart/mixed'
#pod     );
#pod
#pod     ### Add the text message part:
#pod     ### (Note that "attach" has same arguments as "new"):
#pod     $msg->attach(
#pod         Type     =>'TEXT',
#pod         Data     =>"Here's the GIF file you wanted"
#pod     );
#pod
#pod     ### Add the image part:
#pod     $msg->attach(
#pod         Type        =>'image/gif',
#pod         Path        =>'aaa000123.gif',
#pod         Filename    =>'logo.gif',
#pod         Disposition => 'attachment'
#pod     );
#pod
#pod
#pod =head2 Attach a GIF to a text message
#pod
#pod This will create a multipart message exactly as above, but using the
#pod "attach to singlepart" hack:
#pod
#pod     ### Start with a simple text message:
#pod     $msg = MIME::Lite->new(
#pod         From    =>'me@myhost.com',
#pod         To      =>'you@yourhost.com',
#pod         Cc      =>'some@other.com, some@more.com',
#pod         Subject =>'A message with 2 parts...',
#pod         Type    =>'TEXT',
#pod         Data    =>"Here's the GIF file you wanted"
#pod     );
#pod
#pod     ### Attach a part... the make the message a multipart automatically:
#pod     $msg->attach(
#pod         Type     =>'image/gif',
#pod         Path     =>'aaa000123.gif',
#pod         Filename =>'logo.gif'
#pod     );
#pod
#pod
#pod =head2 Attach a pre-prepared part to a message
#pod
#pod     ### Create a standalone part:
#pod     $part = MIME::Lite->new(
#pod         Top      => 0,
#pod         Type     =>'text/html',
#pod         Data     =>'<H1>Hello</H1>',
#pod     );
#pod     $part->attr('content-type.charset' => 'UTF-8');
#pod     $part->add('X-Comment' => 'A message for you');
#pod
#pod     ### Attach it to any message:
#pod     $msg->attach($part);
#pod
#pod
#pod =head2 Print a message to a filehandle
#pod
#pod     ### Write it to a filehandle:
#pod     $msg->print(\*STDOUT);
#pod
#pod     ### Write just the header:
#pod     $msg->print_header(\*STDOUT);
#pod
#pod     ### Write just the encoded body:
#pod     $msg->print_body(\*STDOUT);
#pod
#pod
#pod =head2 Print a message into a string
#pod
#pod     ### Get entire message as a string:
#pod     $str = $msg->as_string;
#pod
#pod     ### Get just the header:
#pod     $str = $msg->header_as_string;
#pod
#pod     ### Get just the encoded body:
#pod     $str = $msg->body_as_string;
#pod
#pod
#pod =head2 Send a message
#pod
#pod     ### Send in the "best" way (the default is to use "sendmail"):
#pod     $msg->send;
#pod
#pod
#pod =head2 Send an HTML document... with images included!
#pod
#pod     $msg = MIME::Lite->new(
#pod          To      =>'you@yourhost.com',
#pod          Subject =>'HTML with in-line images!',
#pod          Type    =>'multipart/related'
#pod     );
#pod     $msg->attach(
#pod         Type => 'text/html',
#pod         Data => qq{
#pod             <body>
#pod                 Here's <i>my</i> image:
#pod                 <img src="cid:myimage.gif">
#pod             </body>
#pod         },
#pod     );
#pod     $msg->attach(
#pod         Type => 'image/gif',
#pod         Id   => 'myimage.gif',
#pod         Path => '/path/to/somefile.gif',
#pod     );
#pod     $msg->send();
#pod
#pod
#pod =head2 Change how messages are sent
#pod
#pod     ### Do something like this in your 'main':
#pod     if ($I_DONT_HAVE_SENDMAIL) {
#pod        MIME::Lite->send('smtp', $host, Timeout=>60,
#pod            AuthUser=>$user, AuthPass=>$pass);
#pod     }
#pod
#pod     ### Now this will do the right thing:
#pod     $msg->send;         ### will now use Net::SMTP as shown above
#pod
#pod =head1 PUBLIC INTERFACE
#pod
#pod =head2 Global configuration
#pod
#pod To alter the way the entire module behaves, you have the following
#pod methods/options:
#pod
#pod =over 4
#pod
#pod
#pod =item MIME::Lite->field_order()
#pod
#pod When used as a L<classmethod|/field_order>, this changes the default
#pod order in which headers are output for I<all> messages.
#pod However, please consider using the instance method variant instead,
#pod so you won't stomp on other message senders in the same application.
#pod
#pod
#pod =item MIME::Lite->quiet()
#pod
#pod This L<classmethod|/quiet> can be used to suppress/unsuppress
#pod all warnings coming from this module.
#pod
#pod
#pod =item MIME::Lite->send()
#pod
#pod When used as a L<classmethod|/send>, this can be used to specify
#pod a different default mechanism for sending message.
#pod The initial default is:
#pod
#pod     MIME::Lite->send("sendmail", "/usr/lib/sendmail -t -oi -oem");
#pod
#pod However, you should consider the similar but smarter and taint-safe variant:
#pod
#pod     MIME::Lite->send("sendmail");
#pod
#pod Or, for non-Unix users:
#pod
#pod     MIME::Lite->send("smtp");
#pod
#pod
#pod =item $MIME::Lite::AUTO_CC
#pod
#pod If true, automatically send to the Cc/Bcc addresses for send_by_smtp().
#pod Default is B<true>.
#pod
#pod
#pod =item $MIME::Lite::AUTO_CONTENT_TYPE
#pod
#pod If true, try to automatically choose the content type from the file name
#pod in C<new()>/C<build()>.  In other words, setting this true changes the
#pod default C<Type> from C<"TEXT"> to C<"AUTO">.
#pod
#pod Default is B<false>, since we must maintain backwards-compatibility
#pod with prior behavior.  B<Please> consider keeping it false,
#pod and just using Type 'AUTO' when you build() or attach().
#pod
#pod
#pod =item $MIME::Lite::AUTO_ENCODE
#pod
#pod If true, automatically choose the encoding from the content type.
#pod Default is B<true>.
#pod
#pod
#pod =item $MIME::Lite::AUTO_VERIFY
#pod
#pod If true, check paths to attachments right before printing, raising an exception
#pod if any path is unreadable.
#pod Default is B<true>.
#pod
#pod
#pod =item $MIME::Lite::PARANOID
#pod
#pod If true, we won't attempt to use MIME::Base64, MIME::QuotedPrint,
#pod or MIME::Types, even if they're available.
#pod Default is B<false>.  Please consider keeping it false,
#pod and trusting these other packages to do the right thing.
#pod
#pod
#pod =back
#pod
#pod =cut

use Carp ();
use FileHandle;

# GLOBALS, EXTERNAL/CONFIGURATION...

### Automatically interpret CC/BCC for SMTP:
our $AUTO_CC = 1;

### Automatically choose content type from file name:
our $AUTO_CONTENT_TYPE = 0;

### Automatically choose encoding from content type:
our $AUTO_ENCODE = 1;

### Check paths right before printing:
our $AUTO_VERIFY = 1;

### Set this true if you don't want to use MIME::Base64/QuotedPrint/Types:
our $PARANOID = 0;

### Don't warn me about dangerous activities:
our $QUIET = undef;

### Unsupported (for tester use): don't qualify boundary with time/pid:
our $VANILLA = 0;

our $DEBUG = 0;

#==============================
#==============================
#
# GLOBALS, INTERNAL...

my $Sender = "";
my $SENDMAIL = "";

if ( $^O =~ /win32|cygwin/i ) {
    $Sender = "smtp";
} else {
    ### Find sendmail:
    $Sender   = "sendmail";
    $SENDMAIL = "/usr/lib/sendmail";
    ( -x $SENDMAIL ) or ( $SENDMAIL = "/usr/sbin/sendmail" );
    ( -x $SENDMAIL ) or ( $SENDMAIL = "sendmail" );
    unless (-x $SENDMAIL) {
        require File::Spec;
        for my $dir (File::Spec->path) {
            if ( -x "$dir/sendmail" ) {
                $SENDMAIL = "$dir/sendmail";
                last;
            }
        }
    }
    unless (-x $SENDMAIL) {
        undef $SENDMAIL;
    }
}

### Our sending facilities:
my %SenderArgs = (
  sendmail  => [],
  smtp      => [],
  sub       => [],
);

### Boundary counter:
my $BCount = 0;

### Known Mail/MIME fields... these, plus some general forms like
### "x-*", are recognized by build():
my %KnownField = map { $_ => 1 }
  qw(
  bcc         cc          comments      date          encrypted
  from        keywords    message-id    mime-version  organization
  received    references  reply-to      return-path   sender
  subject     to          in-reply-to

  approved
);

### What external packages do we use for encoding?
my @Uses = (
  "F" . File::Basename->VERSION,
);

### Header order:
my @FieldOrder;

### See if we have/want MIME::Types
my $HaveMimeTypes = 0;
if ( !$PARANOID and eval "require MIME::Types; MIME::Types->VERSION(1.28);" ) {
    $HaveMimeTypes = 1;
    push @Uses, "T$MIME::Types::VERSION";
}

#==============================
#==============================
#
# PRIVATE UTILITY FUNCTIONS...

#------------------------------
#
# fold STRING
#
# Make STRING safe as a field value.  Remove leading/trailing whitespace,
# and make sure newlines are represented as newline+space

sub fold {
    my $str = shift;
    $str =~ s/^\s*|\s*$//g;    ### trim
    $str =~ s/\n/\n /g;
    $str;
}

#------------------------------
#
# gen_boundary
#
# Generate a new boundary to use.
# The unsupported $VANILLA is for test purposes only.

sub gen_boundary {
    return ( "_----------=_" . ( $VANILLA ? '' : int(time) . $$ ) . $BCount++ );
}

#------------------------------
#
# is_mime_field FIELDNAME
#
# Is this a field I manage?

sub is_mime_field {
    $_[0] =~ /^(mime\-|content\-)/i;
}

#------------------------------
#
# extract_full_addrs STRING
# extract_only_addrs STRING
#
# Split STRING into an array of email addresses: somewhat of a KLUDGE.
#
# Unless paranoid, we try to load the real code before supplying our own.
BEGIN {
    my $ATOM      = '[^ \000-\037()<>@,;:\134"\056\133\135]+';
    my $QSTR      = '".*?"';
    my $WORD      = '(?:' . $QSTR . '|' . $ATOM . ')';
    my $DOMAIN    = '(?:' . $ATOM . '(?:' . '\\.' . $ATOM . ')*' . ')';
    my $LOCALPART = '(?:' . $WORD . '(?:' . '\\.' . $WORD . ')*' . ')';
    my $ADDR      = '(?:' . $LOCALPART . '@' . $DOMAIN . ')';
    my $PHRASE    = '(?:' . $WORD . ')+';
    my $SEP       = "(?:^\\s*|\\s*,\\s*)"; ### before elems in a list

    sub my_extract_full_addrs {
        my $str = shift;
        return unless $str;
        my @addrs;
        $str =~ s/\s/ /g; ### collapse whitespace

        pos($str) = 0;
        while ( $str !~ m{\G\s*\Z}gco ) {
            ### print STDERR "TACKLING: ".substr($str, pos($str))."\n";
            if ( $str =~ m{\G$SEP($PHRASE)\s*<\s*($ADDR)\s*>}gco ) {
                push @addrs, "$1 <$2>";
            } elsif ( $str =~ m{\G$SEP($ADDR)}gco or $str =~ m{\G$SEP($ATOM)}gco ) {
                push @addrs, $1;
            } else {
                my $problem = substr( $str, pos($str) );
                die "can't extract address at <$problem> in <$str>\n";
            }
        }
        return wantarray ? @addrs : $addrs[0];
    }

    sub my_extract_only_addrs {
        my @ret = map { /<([^>]+)>/ ? $1 : $_ } my_extract_full_addrs(@_);
        return wantarray ? @ret : $ret[0];
    }
}
#------------------------------


if ( !$PARANOID and eval "require Mail::Address" ) {
    push @Uses, "A$Mail::Address::VERSION";
    eval q{
                sub extract_full_addrs {
                    my @ret=map { $_->format } Mail::Address->parse($_[0]);
                    return wantarray ? @ret : $ret[0]
                }
                sub extract_only_addrs {
                    my @ret=map { $_->address } Mail::Address->parse($_[0]);
                    return wantarray ? @ret : $ret[0]
                }
    };    ### q
} else {
    eval q{
        *extract_full_addrs=*my_extract_full_addrs;
        *extract_only_addrs=*my_extract_only_addrs;
    };    ### q
}    ### if

#==============================
#==============================
#
# PRIVATE ENCODING FUNCTIONS...

#------------------------------
#
# encode_base64 STRING
#
# Encode the given string using BASE64.
# Unless paranoid, we try to load the real code before supplying our own.

if ( !$PARANOID and eval "require MIME::Base64" ) {
    MIME::Base64->import(qw(encode_base64));
    push @Uses, "B$MIME::Base64::VERSION";
} else {
    eval q{
        sub encode_base64 {
            my $res = "";
            my $eol = "\n";

            pos($_[0]) = 0;        ### thanks, Andreas!
            while ($_[0] =~ /(.{1,45})/gs) {
            $res .= substr(pack('u', $1), 1);
            chop($res);
            }
            $res =~ tr|` -_|AA-Za-z0-9+/|;

            ### Fix padding at the end:
            my $padding = (3 - length($_[0]) % 3) % 3;
            $res =~ s/.{$padding}$/'=' x $padding/e if $padding;

            ### Break encoded string into lines of no more than 76 characters each:
            $res =~ s/(.{1,76})/$1$eol/g if (length $eol);
            return $res;
        } ### sub
  }    ### q
}    ### if

#------------------------------
#
# encode_qp STRING
#
# Encode the given string, LINE BY LINE, using QUOTED-PRINTABLE.
# Stolen from MIME::QuotedPrint by Gisle Aas, with a slight bug fix: we
# break lines earlier.  Notice that this seems not to work unless
# encoding line by line.
#
# Unless paranoid, we try to load the real code before supplying our own.

if ( !$PARANOID and eval "require MIME::QuotedPrint" ) {
    import MIME::QuotedPrint qw(encode_qp);
    push @Uses, "Q$MIME::QuotedPrint::VERSION";
} else {
    eval q{
        sub encode_qp {
            my $res = shift;
            local($_);
            $res =~ s/([^ \t\n!-<>-~])/sprintf("=%02X", ord($1))/eg;  ### rule #2,#3
            $res =~ s/([ \t]+)$/
              join('', map { sprintf("=%02X", ord($_)) }
                       split('', $1)
              )/egm;                        ### rule #3 (encode whitespace at eol)

            ### rule #5 (lines shorter than 76 chars, but can't break =XX escapes:
            my $brokenlines = "";
            $brokenlines .= "$1=\n" while $res =~ s/^(.{70}([^=]{2})?)//; ### 70 was 74
            $brokenlines =~ s/=\n$// unless length $res;
            "$brokenlines$res";
        } ### sub
  }    ### q
}    ### if


#------------------------------
#
# encode_8bit STRING
#
# Encode the given string using 8BIT.
# This breaks long lines into shorter ones.

sub encode_8bit {
    my $str = shift;
    $str =~ s/^(.{990})/$1\n/mg;
    $str;
}

#------------------------------
#
# encode_7bit STRING
#
# Encode the given string using 7BIT.
# This NO LONGER protects people through encoding.

sub encode_7bit {
    my $str = shift;
    $str =~ s/[\x80-\xFF]//g;
    $str =~ s/^(.{990})/$1\n/mg;
    $str;
}

#==============================
#==============================

#pod =head2 Construction
#pod
#pod =over 4
#pod
#pod =cut


#------------------------------

#pod =item new [PARAMHASH]
#pod
#pod I<Class method, constructor.>
#pod Create a new message object.
#pod
#pod If any arguments are given, they are passed into C<build()>; otherwise,
#pod just the empty object is created.
#pod
#pod =cut


sub new {
    my $class = shift;

    ### Create basic object:
    my $self = { Attrs    => {},    ### MIME attributes
                 SubAttrs => {},    ### MIME sub-attributes
                 Header   => [],    ### explicit message headers
                 Parts    => [],    ### array of parts
    };
    bless $self, $class;

    ### Build, if needed:
    return ( @_ ? $self->build(@_) : $self );
}


#------------------------------

#pod =item attach PART
#pod
#pod =item attach PARAMHASH...
#pod
#pod I<Instance method.>
#pod Add a new part to this message, and return the new part.
#pod
#pod If you supply a single PART argument, it will be regarded
#pod as a MIME::Lite object to be attached.  Otherwise, this
#pod method assumes that you are giving in the pairs of a PARAMHASH
#pod which will be sent into C<new()> to create the new part.
#pod
#pod One of the possibly-quite-useful hacks thrown into this is the
#pod "attach-to-singlepart" hack: if you attempt to attach a part (let's
#pod call it "part 1") to a message that doesn't have a content-type
#pod of "multipart" or "message", the following happens:
#pod
#pod =over 4
#pod
#pod =item *
#pod
#pod A new part (call it "part 0") is made.
#pod
#pod =item *
#pod
#pod The MIME attributes and data (but I<not> the other headers)
#pod are cut from the "self" message, and pasted into "part 0".
#pod
#pod =item *
#pod
#pod The "self" is turned into a "multipart/mixed" message.
#pod
#pod =item *
#pod
#pod The new "part 0" is added to the "self", and I<then> "part 1" is added.
#pod
#pod =back
#pod
#pod One of the nice side-effects is that you can create a text message
#pod and then add zero or more attachments to it, much in the same way
#pod that a user agent like Netscape allows you to do.
#pod
#pod =cut


sub attach {
    my $self = shift;
    my $attrs = $self->{Attrs};
    my $sub_attrs = $self->{SubAttrs};

    ### Create new part, if necessary:
    my $part1 = ( ( @_ == 1 ) ? shift: ref($self)->new( Top => 0, @_ ) );

    ### Do the "attach-to-singlepart" hack:
    if ( $attrs->{'content-type'} !~ m{^(multipart|message)/}i ) {

        ### Create part zero:
        my $part0 = ref($self)->new;

        ### Cut MIME stuff from self, and paste into part zero:
        foreach (qw(SubAttrs Attrs Data Path FH)) {
            $part0->{$_} = $self->{$_};
            delete( $self->{$_} );
        }
        $part0->top_level(0);    ### clear top-level attributes

        ### Make self a top-level multipart:
        $attrs = $self->{Attrs} ||= {};       ### reset (sam: bug?  this doesn't reset anything since Attrs is already a hash-ref)
        $sub_attrs = $self->{SubAttrs} ||= {};    ### reset
        $attrs->{'content-type'}              = 'multipart/mixed';
        $sub_attrs->{'content-type'}{'boundary'}      = gen_boundary();
        $attrs->{'content-transfer-encoding'} = '7bit';
        $self->top_level(1);      ### activate top-level attributes

        ### Add part 0:
        push @{ $self->{Parts} }, $part0;
    }

    ### Add the new part:
    push @{ $self->{Parts} }, $part1;
    $part1;
}

#------------------------------

#pod =item build [PARAMHASH]
#pod
#pod I<Class/instance method, initializer.>
#pod Create (or initialize) a MIME message object.
#pod Normally, you'll use the following keys in PARAMHASH:
#pod
#pod    * Data, FH, or Path      (either one of these, or none if multipart)
#pod    * Type                   (e.g., "image/jpeg")
#pod    * From, To, and Subject  (if this is the "top level" of a message)
#pod
#pod The PARAMHASH can contain the following keys:
#pod
#pod =over 4
#pod
#pod =item (fieldname)
#pod
#pod Any field you want placed in the message header, taken from the
#pod standard list of header fields (you don't need to worry about case):
#pod
#pod     Approved      Encrypted     Received      Sender
#pod     Bcc           From          References    Subject
#pod     Cc            Keywords      Reply-To      To
#pod     Comments      Message-ID    Resent-*      X-*
#pod     Content-*     MIME-Version  Return-Path
#pod     Date                        Organization
#pod
#pod To give experienced users some veto power, these fields will be set
#pod I<after> the ones I set... so be careful: I<don't set any MIME fields>
#pod (like C<Content-type>) unless you know what you're doing!
#pod
#pod To specify a fieldname that's I<not> in the above list, even one that's
#pod identical to an option below, just give it with a trailing C<":">,
#pod like C<"My-field:">.  When in doubt, that I<always> signals a mail
#pod field (and it sort of looks like one too).
#pod
#pod =item Data
#pod
#pod I<Alternative to "Path" or "FH".>
#pod The actual message data.  This may be a scalar or a ref to an array of
#pod strings; if the latter, the message consists of a simple concatenation
#pod of all the strings in the array.
#pod
#pod =item Datestamp
#pod
#pod I<Optional.>
#pod If given true (or omitted), we force the creation of a C<Date:> field
#pod stamped with the current date/time if this is a top-level message.
#pod You may want this if using L<send_by_smtp()|/send_by_smtp>.
#pod If you don't want this to be done, either provide your own Date
#pod or explicitly set this to false.
#pod
#pod =item Disposition
#pod
#pod I<Optional.>
#pod The content disposition, C<"inline"> or C<"attachment">.
#pod The default is C<"inline">.
#pod
#pod =item Encoding
#pod
#pod I<Optional.>
#pod The content transfer encoding that should be used to encode your data:
#pod
#pod    Use encoding:     | If your message contains:
#pod    ------------------------------------------------------------
#pod    7bit              | Only 7-bit text, all lines <1000 characters
#pod    8bit              | 8-bit text, all lines <1000 characters
#pod    quoted-printable  | 8-bit text or long lines (more reliable than "8bit")
#pod    base64            | Largely non-textual data: a GIF, a tar file, etc.
#pod
#pod The default is taken from the Type; generally it is "binary" (no
#pod encoding) for text/*, message/*, and multipart/*, and "base64" for
#pod everything else.  A value of C<"binary"> is generally I<not> suitable
#pod for sending anything but ASCII text files with lines under 1000
#pod characters, so consider using one of the other values instead.
#pod
#pod In the case of "7bit"/"8bit", long lines are automatically chopped to
#pod legal length; in the case of "7bit", all 8-bit characters are
#pod automatically I<removed>.  This may not be what you want, so pick your
#pod encoding well!  For more info, see L<"A MIME PRIMER">.
#pod
#pod =item FH
#pod
#pod I<Alternative to "Data" or "Path".>
#pod Filehandle containing the data, opened for reading.
#pod See "ReadNow" also.
#pod
#pod =item Filename
#pod
#pod I<Optional.>
#pod The name of the attachment.  You can use this to supply a
#pod recommended filename for the end-user who is saving the attachment
#pod to disk.  You only need this if the filename at the end of the
#pod "Path" is inadequate, or if you're using "Data" instead of "Path".
#pod You should I<not> put path information in here (e.g., no "/"
#pod or "\" or ":" characters should be used).
#pod
#pod =item Id
#pod
#pod I<Optional.>
#pod Same as setting "content-id".
#pod
#pod =item Length
#pod
#pod I<Optional.>
#pod Set the content length explicitly.  Normally, this header is automatically
#pod computed, but only under certain circumstances (see L<"Benign limitations">).
#pod
#pod =item Path
#pod
#pod I<Alternative to "Data" or "FH".>
#pod Path to a file containing the data... actually, it can be any open()able
#pod expression.  If it looks like a path, the last element will automatically
#pod be treated as the filename.
#pod See "ReadNow" also.
#pod
#pod =item ReadNow
#pod
#pod I<Optional, for use with "Path".>
#pod If true, will open the path and slurp the contents into core now.
#pod This is useful if the Path points to a command and you don't want
#pod to run the command over and over if outputting the message several
#pod times.  B<Fatal exception> raised if the open fails.
#pod
#pod =item Top
#pod
#pod I<Optional.>
#pod If defined, indicates whether or not this is a "top-level" MIME message.
#pod The parts of a multipart message are I<not> top-level.
#pod Default is true.
#pod
#pod =item Type
#pod
#pod I<Optional.>
#pod The MIME content type, or one of these special values (case-sensitive):
#pod
#pod      "TEXT"   means "text/plain"
#pod      "BINARY" means "application/octet-stream"
#pod      "AUTO"   means attempt to guess from the filename, falling back
#pod               to 'application/octet-stream'.  This is good if you have
#pod               MIME::Types on your system and you have no idea what
#pod               file might be used for the attachment.
#pod
#pod The default is C<"TEXT">, but it will be C<"AUTO"> if you set
#pod $AUTO_CONTENT_TYPE to true (sorry, but you have to enable
#pod it explicitly, since we don't want to break code which depends
#pod on the old behavior).
#pod
#pod =back
#pod
#pod A picture being worth 1000 words (which
#pod is of course 2000 bytes, so it's probably more of an "icon" than a "picture",
#pod but I digress...), here are some examples:
#pod
#pod     $msg = MIME::Lite->build(
#pod         From     => 'yelling@inter.com',
#pod         To       => 'stocking@fish.net',
#pod         Subject  => "Hi there!",
#pod         Type     => 'TEXT',
#pod         Encoding => '7bit',
#pod         Data     => "Just a quick note to say hi!"
#pod     );
#pod
#pod     $msg = MIME::Lite->build(
#pod         From     => 'dorothy@emerald-city.oz',
#pod         To       => 'gesundheit@edu.edu.edu',
#pod         Subject  => "A gif for U"
#pod         Type     => 'image/gif',
#pod         Path     => "/home/httpd/logo.gif"
#pod     );
#pod
#pod     $msg = MIME::Lite->build(
#pod         From     => 'laughing@all.of.us',
#pod         To       => 'scarlett@fiddle.dee.de',
#pod         Subject  => "A gzipp'ed tar file",
#pod         Type     => 'x-gzip',
#pod         Path     => "gzip < /usr/inc/somefile.tar |",
#pod         ReadNow  => 1,
#pod         Filename => "somefile.tgz"
#pod     );
#pod
#pod To show you what's really going on, that last example could also
#pod have been written:
#pod
#pod     $msg = new MIME::Lite;
#pod     $msg->build(
#pod         Type     => 'x-gzip',
#pod         Path     => "gzip < /usr/inc/somefile.tar |",
#pod         ReadNow  => 1,
#pod         Filename => "somefile.tgz"
#pod     );
#pod     $msg->add(From    => "laughing@all.of.us");
#pod     $msg->add(To      => "scarlett@fiddle.dee.de");
#pod     $msg->add(Subject => "A gzipp'ed tar file");
#pod
#pod =cut


sub build {
    my $self   = shift;
    my %params = @_;
    my @params = @_;
    my $key;

    ### Miko's note: reorganized to check for exactly one of Data, Path, or FH
    ( defined( $params{Data} ) + defined( $params{Path} ) + defined( $params{FH} ) <= 1 )
      or Carp::croak "supply exactly zero or one of (Data|Path|FH).\n";

    ### Create new instance, if necessary:
    ref($self) or $self = $self->new;


    ### CONTENT-TYPE....
    ###

    ### Get content-type or content-type-macro:
    my $type = ( $params{Type} || ( $AUTO_CONTENT_TYPE ? 'AUTO' : 'TEXT' ) );

    ### Interpret content-type-macros:
    if    ( $type eq 'TEXT' )   { $type = 'text/plain'; }
    elsif ( $type eq 'HTML' )   { $type = 'text/html'; }
    elsif ( $type eq 'BINARY' ) { $type = 'application/octet-stream' }
    elsif ( $type eq 'AUTO' )   { $type = $self->suggest_type( $params{Path} ); }

    ### We now have a content-type; set it:
    $type = lc($type);
    my $attrs  = $self->{Attrs};
    my $sub_attrs  = $self->{SubAttrs};
    $attrs->{'content-type'} = $type;

    ### Get some basic attributes from the content type:
    my $is_multipart = ( $type =~ m{^(multipart)/}i );

    ### Add in the multipart boundary:
    if ($is_multipart) {
        my $boundary = gen_boundary();
        $sub_attrs->{'content-type'}{'boundary'} = $boundary;
    }


    ### CONTENT-ID...
    ###
    if ( defined $params{Id} ) {
        my $id = $params{Id};
        $id = "<$id>" unless $id =~ /\A\s*<.*>\s*\z/;
        $attrs->{'content-id'} = $id;
    }


    ### DATA OR PATH...
    ###    Note that we must do this *after* we get the content type,
    ###    in case read_now() is invoked, since it needs the binmode().

    ### Get data, as...
    ### ...either literal data:
    if ( defined( $params{Data} ) ) {
        $self->data( $params{Data} );
    }
    ### ...or a path to data:
    elsif ( defined( $params{Path} ) ) {
        $self->path( $params{Path} );    ### also sets filename
        $self->read_now if $params{ReadNow};
    }
    ### ...or a filehandle to data:
    ### Miko's note: this part works much like the path routine just above,
    elsif ( defined( $params{FH} ) ) {
        $self->fh( $params{FH} );
        $self->read_now if $params{ReadNow};    ### implement later
    }


    ### FILENAME... (added by Ian Smith <ian@safeway.dircon.co.uk> on 8/4/97)
    ###    Need this to make sure the filename is added.  The Filename
    ###    attribute is ignored, otherwise.
    if ( defined( $params{Filename} ) ) {
        $self->filename( $params{Filename} );
    }


    ### CONTENT-TRANSFER-ENCODING...
    ###

    ### Get it:
    my $enc =
      ( $params{Encoding} || ( $AUTO_ENCODE and $self->suggest_encoding($type) ) || 'binary' );
    $attrs->{'content-transfer-encoding'} = lc($enc);

    ### Sanity check:
    if ( $type =~ m{^(multipart|message)/} ) {
        ( $enc =~ m{^(7bit|8bit|binary)\Z} )
          or Carp::croak( "illegal MIME: " . "can't have encoding $enc with type $type\n" );
    }

    ### CONTENT-DISPOSITION...
    ###    Default is inline for single, none for multis:
    ###
    my $disp = ( $params{Disposition} or ( $is_multipart ? undef: 'inline' ) );
    $attrs->{'content-disposition'} = $disp;

    ### CONTENT-LENGTH...
    ###
    my $length;
    if ( exists( $params{Length} ) ) {    ### given by caller:
        $attrs->{'content-length'} = $params{Length};
    } else {                              ### compute it ourselves
        $self->get_length;
    }

    ### Init the top-level fields:
    my $is_top = defined( $params{Top} ) ? $params{Top} : 1;
    $self->top_level($is_top);

    ### Datestamp if desired:
    my $ds_wanted = $params{Datestamp};
    my $ds_defaulted = ( $is_top and !exists( $params{Datestamp} ) );
    if ( ( $ds_wanted or $ds_defaulted ) and !exists( $params{Date} ) ) {
        require Email::Date::Format;
        $self->add( "date", Email::Date::Format::email_date() );
    }

    ### Set message headers:
    my @paramz = @params;
    my $field;
    while (@paramz) {
        my ( $tag, $value ) = ( shift(@paramz), shift(@paramz) );
        my $lc_tag = lc($tag);

        ### Get tag, if a tag:
        if ( $lc_tag =~ /^-(.*)/ ) {                   ### old style, backwards-compatibility
            $field = $1;
        } elsif ( $lc_tag =~ /^(.*):$/ ) {             ### new style
            $field = $1;
        } elsif ( $KnownField{$lc_tag} or
                  $lc_tag =~ m{^(content|resent|x)-.} ){
            $field = $lc_tag;
        } else {                                          ### not a field:
            next;
        }

        ### Add it:
        $self->add( $field, $value );
    }

    ### Done!
    $self;
}

#pod =back
#pod
#pod =cut


#==============================
#==============================

#pod =head2 Setting/getting headers and attributes
#pod
#pod =over 4
#pod
#pod =cut


#------------------------------
#
# top_level ONOFF
#
# Set/unset the top-level attributes and headers.
# This affects "MIME-Version", "X-Mailer", and "Date"

sub top_level {
    my ( $self, $onoff ) = @_;
    my $attrs = $self->{Attrs};
    if ($onoff) {
        $attrs->{'mime-version'} = '1.0';
        my $uses = ( @Uses ? ( "(" . join( "; ", @Uses ) . ")" ) : '' );
        $self->replace( 'X-Mailer' => "MIME::Lite $MIME::Lite::VERSION $uses" )
          unless $VANILLA;
    } else {
        delete $attrs->{'mime-version'};
        $self->delete('X-Mailer');
        $self->delete('Date');
    }
}

#------------------------------

#pod =item add TAG,VALUE
#pod
#pod I<Instance method.>
#pod Add field TAG with the given VALUE to the end of the header.
#pod The TAG will be converted to all-lowercase, and the VALUE
#pod will be made "safe" (returns will be given a trailing space).
#pod
#pod B<Beware:> any MIME fields you "add" will override any MIME
#pod attributes I have when it comes time to output those fields.
#pod Normally, you will use this method to add I<non-MIME> fields:
#pod
#pod     $msg->add("Subject" => "Hi there!");
#pod
#pod Giving VALUE as an arrayref will cause all those values to be added.
#pod This is only useful for special multiple-valued fields like "Received":
#pod
#pod     $msg->add("Received" => ["here", "there", "everywhere"]
#pod
#pod Giving VALUE as the empty string adds an invisible placeholder
#pod to the header, which can be used to suppress the output of
#pod the "Content-*" fields or the special  "MIME-Version" field.
#pod When suppressing fields, you should use replace() instead of add():
#pod
#pod     $msg->replace("Content-disposition" => "");
#pod
#pod I<Note:> add() is probably going to be more efficient than C<replace()>,
#pod so you're better off using it for most applications if you are
#pod certain that you don't need to delete() the field first.
#pod
#pod I<Note:> the name comes from Mail::Header.
#pod
#pod =cut


sub add {
    my $self  = shift;
    my $tag   = lc(shift);
    my $value = shift;

    ### If a dangerous option, warn them:
    Carp::carp "Explicitly setting a MIME header field ($tag) is dangerous:\n"
      . "use the attr() method instead.\n"
      if ( is_mime_field($tag) && !$QUIET );

    ### Get array of clean values:
    my @vals = ( ( ref($value) and ( ref($value) eq 'ARRAY' ) )
                 ? @{$value}
                 : ( $value . '' )
    );
    map { s/\n/\n /g } @vals;

    ### Add them:
    foreach (@vals) {
        push @{ $self->{Header} }, [ $tag, $_ ];
    }
}

#------------------------------

#pod =item attr ATTR,[VALUE]
#pod
#pod I<Instance method.>
#pod Set MIME attribute ATTR to the string VALUE.
#pod ATTR is converted to all-lowercase.
#pod This method is normally used to set/get MIME attributes:
#pod
#pod     $msg->attr("content-type"         => "text/html");
#pod     $msg->attr("content-type.charset" => "US-ASCII");
#pod     $msg->attr("content-type.name"    => "homepage.html");
#pod
#pod This would cause the final output to look something like this:
#pod
#pod     Content-type: text/html; charset=US-ASCII; name="homepage.html"
#pod
#pod Note that the special empty sub-field tag indicates the anonymous
#pod first sub-field.
#pod
#pod Giving VALUE as undefined will cause the contents of the named
#pod subfield to be deleted.
#pod
#pod Supplying no VALUE argument just returns the attribute's value:
#pod
#pod     $type = $msg->attr("content-type");        ### returns "text/html"
#pod     $name = $msg->attr("content-type.name");   ### returns "homepage.html"
#pod
#pod =cut


sub attr {
    my ( $self, $attr, $value ) = @_;
    my $attrs = $self->{Attrs};

    $attr = lc($attr);

    ### Break attribute name up:
    my ( $tag, $subtag ) = split /\./, $attr;
    if (defined($subtag)) {
        $attrs = $self->{SubAttrs}{$tag} ||= {};
        $tag   = $subtag;
    }

    ### Set or get?
    if ( @_ > 2 ) {    ### set:
        if ( defined($value) ) {
            $attrs->{$tag} = $value;
        } else {
            delete $attrs->{$tag};
        }
    }

    ### Return current value:
    $attrs->{$tag};
}

sub _safe_attr {
    my ( $self, $attr ) = @_;
    return defined $self->{Attrs}{$attr} ? $self->{Attrs}{$attr} : '';
}

#------------------------------

#pod =item delete TAG
#pod
#pod I<Instance method.>
#pod Delete field TAG with the given VALUE to the end of the header.
#pod The TAG will be converted to all-lowercase.
#pod
#pod     $msg->delete("Subject");
#pod
#pod I<Note:> the name comes from Mail::Header.
#pod
#pod =cut


sub delete {
    my $self = shift;
    my $tag  = lc(shift);

    ### Delete from the header:
    my $hdr = [];
    my $field;
    foreach $field ( @{ $self->{Header} } ) {
        push @$hdr, $field if ( $field->[0] ne $tag );
    }
    $self->{Header} = $hdr;
    $self;
}


#------------------------------

#pod =item field_order FIELD,...FIELD
#pod
#pod I<Class/instance method.>
#pod Change the order in which header fields are output for this object:
#pod
#pod     $msg->field_order('from', 'to', 'content-type', 'subject');
#pod
#pod When used as a class method, changes the default settings for
#pod all objects:
#pod
#pod     MIME::Lite->field_order('from', 'to', 'content-type', 'subject');
#pod
#pod Case does not matter: all field names will be coerced to lowercase.
#pod In either case, supply the empty array to restore the default ordering.
#pod
#pod =cut


sub field_order {
    my $self = shift;
    if ( ref($self) ) {
        $self->{FieldOrder} = [ map { lc($_) } @_ ];
    } else {
        @FieldOrder = map { lc($_) } @_;
    }
}

#------------------------------

#pod =item fields
#pod
#pod I<Instance method.>
#pod Return the full header for the object, as a ref to an array
#pod of C<[TAG, VALUE]> pairs, where each TAG is all-lowercase.
#pod Note that any fields the user has explicitly set will override the
#pod corresponding MIME fields that we would otherwise generate.
#pod So, don't say...
#pod
#pod     $msg->set("Content-type" => "text/html; charset=US-ASCII");
#pod
#pod unless you want the above value to override the "Content-type"
#pod MIME field that we would normally generate.
#pod
#pod I<Note:> I called this "fields" because the header() method of
#pod Mail::Header returns something different, but similar enough to
#pod be confusing.
#pod
#pod You can change the order of the fields: see L</field_order>.
#pod You really shouldn't need to do this, but some people have to
#pod deal with broken mailers.
#pod
#pod =cut


sub fields {
    my $self = shift;
    my @fields;
    my $attrs = $self->{Attrs};
    my $sub_attrs = $self->{SubAttrs};

    ### Get a lookup-hash of all *explicitly-given* fields:
    my %explicit = map { $_->[0] => 1 } @{ $self->{Header} };

    ### Start with any MIME attributes not given explicitly:
    my $tag;
    foreach $tag ( sort keys %{ $self->{Attrs} } ) {

        ### Skip if explicit:
        next if ( $explicit{$tag} );

        # get base attr value or skip if not available
        my $value = $attrs->{$tag};
        defined $value or next;

        ### handle sub-attrs if available
        if (my $subs = $sub_attrs->{$tag}) {
            $value .= '; ' .
              join('; ', map {
                  /\*$/ ? qq[$_=$subs->{$_}] : qq[$_="$subs->{$_}"]
              } sort keys %$subs);
        }

        # handle stripping \r\n now since we're not doing it in attr()
        # anymore
        $value =~ tr/\r\n//;

        ### Add to running fields;
        push @fields, [ $tag, $value ];
    }

    ### Add remaining fields (note that we duplicate the array for safety):
    foreach ( @{ $self->{Header} } ) {
        push @fields, [ @{$_} ];
    }

    ### Final step:
    ### If a suggested ordering was given, we "sort" by that ordering.
    ###    The idea is that we give each field a numeric rank, which is
    ###    (1000 * order(field)) + origposition.
    my @order = @{ $self->{FieldOrder} || [] };    ### object-specific
    @order or @order = @FieldOrder;                ### no? maybe generic
    if (@order) {                                  ### either?

        ### Create hash mapping field names to 1-based rank:
        my %rank = map { $order[$_] => ( 1 + $_ ) } ( 0 .. $#order );

        ### Create parallel array to @fields, called @ranked.
        ### It contains fields tagged with numbers like 2003, where the
        ### 3 is the original 0-based position, and 2000 indicates that
        ### we wanted this type of field to go second.
        my @ranked = map {
            [ ( $_ + 1000 * ( $rank{ lc( $fields[$_][0] ) } || ( 2 + $#order ) ) ), $fields[$_] ]
        } ( 0 .. $#fields );

        # foreach (@ranked) {
        #     print STDERR "RANKED: $_->[0] $_->[1][0] $_->[1][1]\n";
        # }

        ### That was half the Schwartzian transform.  Here's the rest:
        @fields = map { $_->[1] }
          sort { $a->[0] <=> $b->[0] } @ranked;
    }

    ### Done!
    return \@fields;
}


#------------------------------

#pod =item filename [FILENAME]
#pod
#pod I<Instance method.>
#pod Set the filename which this data will be reported as.
#pod This actually sets both "standard" attributes.
#pod
#pod With no argument, returns the filename as dictated by the
#pod content-disposition.
#pod
#pod =cut


sub filename {
    my ( $self, $filename ) = @_;
    my $sub_attrs = $self->{SubAttrs};

    if ( @_ > 1 ) {
        $sub_attrs->{'content-type'}{'name'} = $filename;
        $sub_attrs->{'content-disposition'}{'filename'} = $filename;
    }
    return $sub_attrs->{'content-disposition'}{'filename'};
}

#------------------------------

#pod =item get TAG,[INDEX]
#pod
#pod I<Instance method.>
#pod Get the contents of field TAG, which might have been set
#pod with set() or replace().  Returns the text of the field.
#pod
#pod     $ml->get('Subject', 0);
#pod
#pod If the optional 0-based INDEX is given, then we return the INDEX'th
#pod occurrence of field TAG.  Otherwise, we look at the context:
#pod In a scalar context, only the first (0th) occurrence of the
#pod field is returned; in an array context, I<all> occurrences are returned.
#pod
#pod I<Warning:> this should only be used with non-MIME fields.
#pod Behavior with MIME fields is TBD, and will raise an exception for now.
#pod
#pod =cut


sub get {
    my ( $self, $tag, $index ) = @_;
    $tag = lc($tag);
    Carp::croak "get: can't be used with MIME fields\n" if is_mime_field($tag);

    my @all = map { ( $_->[0] eq $tag ) ? $_->[1] : () } @{ $self->{Header} };
    ( defined($index) ? $all[$index] : ( wantarray ? @all : $all[0] ) );
}

#------------------------------

#pod =item get_length
#pod
#pod I<Instance method.>
#pod Recompute the content length for the message I<if the process is trivial>,
#pod setting the "content-length" attribute as a side-effect:
#pod
#pod     $msg->get_length;
#pod
#pod Returns the length, or undefined if not set.
#pod
#pod I<Note:> the content length can be difficult to compute, since it
#pod involves assembling the entire encoded body and taking the length
#pod of it (which, in the case of multipart messages, means freezing
#pod all the sub-parts, etc.).
#pod
#pod This method only sets the content length to a defined value if the
#pod message is a singlepart with C<"binary"> encoding, I<and> the body is
#pod available either in-core or as a simple file.  Otherwise, the content
#pod length is set to the undefined value.
#pod
#pod Since content-length is not a standard MIME field anyway (that's right, kids:
#pod it's not in the MIME RFCs, it's an HTTP thing), this seems pretty fair.
#pod
#pod =cut


#----
# Miko's note: I wasn't quite sure how to handle this, so I waited to hear
# what you think.  Given that the content-length isn't always required,
# and given the performance cost of calculating it from a file handle,
# I thought it might make more sense to add some sort of computelength
# property. If computelength is false, then the length simply isn't
# computed.  What do you think?
#
# Eryq's reply:  I agree; for now, we can silently leave out the content-type.

sub get_length {
    my $self = shift;
    my $attrs = $self->{Attrs};

    my $is_multipart = ( $attrs->{'content-type'} =~ m{^multipart/}i );
    my $enc = lc( $attrs->{'content-transfer-encoding'} || 'binary' );
    my $length;
    if ( !$is_multipart && ( $enc eq "binary" ) ) {    ### might figure it out cheap:
        if ( defined( $self->{Data} ) ) {              ### it's in core
            $length = length( $self->{Data} );
        } elsif ( defined( $self->{FH} ) ) {           ### it's in a filehandle
            ### no-op: it's expensive, so don't bother
        } elsif ( defined( $self->{Path} ) ) {         ### it's a simple file!
            $length = ( -s $self->{Path} ) if ( -e $self->{Path} );
        }
    }
    $attrs->{'content-length'} = $length;
    return $length;
}

#------------------------------

#pod =item parts
#pod
#pod I<Instance method.>
#pod Return the parts of this entity, and this entity only.
#pod Returns empty array if this entity has no parts.
#pod
#pod This is B<not> recursive!  Parts can have sub-parts; use
#pod parts_DFS() to get everything.
#pod
#pod =cut


sub parts {
    my $self = shift;
    @{ $self->{Parts} || [] };
}

#------------------------------

#pod =item parts_DFS
#pod
#pod I<Instance method.>
#pod Return the list of all MIME::Lite objects included in the entity,
#pod starting with the entity itself, in depth-first-search order.
#pod If this object has no parts, it alone will be returned.
#pod
#pod =cut


sub parts_DFS {
    my $self = shift;
    return ( $self, map { $_->parts_DFS } $self->parts );
}

#------------------------------

#pod =item preamble [TEXT]
#pod
#pod I<Instance method.>
#pod Get/set the preamble string, assuming that this object has subparts.
#pod Set it to undef for the default string.
#pod
#pod =cut


sub preamble {
    my $self = shift;
    $self->{Preamble} = shift if @_;
    $self->{Preamble};
}

#------------------------------

#pod =item replace TAG,VALUE
#pod
#pod I<Instance method.>
#pod Delete all occurrences of fields named TAG, and add a new
#pod field with the given VALUE.  TAG is converted to all-lowercase.
#pod
#pod B<Beware> the special MIME fields (MIME-version, Content-*):
#pod if you "replace" a MIME field, the replacement text will override
#pod the I<actual> MIME attributes when it comes time to output that field.
#pod So normally you use attr() to change MIME fields and add()/replace() to
#pod change I<non-MIME> fields:
#pod
#pod     $msg->replace("Subject" => "Hi there!");
#pod
#pod Giving VALUE as the I<empty string> will effectively I<prevent> that
#pod field from being output.  This is the correct way to suppress
#pod the special MIME fields:
#pod
#pod     $msg->replace("Content-disposition" => "");
#pod
#pod Giving VALUE as I<undefined> will just cause all explicit values
#pod for TAG to be deleted, without having any new values added.
#pod
#pod I<Note:> the name of this method  comes from Mail::Header.
#pod
#pod =cut


sub replace {
    my ( $self, $tag, $value ) = @_;
    $self->delete($tag);
    $self->add( $tag, $value ) if defined($value);
}


#------------------------------

#pod =item scrub
#pod
#pod I<Instance method.>
#pod B<This is Alpha code.  If you use it, please let me know how it goes.>
#pod Recursively goes through the "parts" tree of this message and tries
#pod to find MIME attributes that can be removed.
#pod With an array argument, removes exactly those attributes; e.g.:
#pod
#pod     $msg->scrub(['content-disposition', 'content-length']);
#pod
#pod Is the same as recursively doing:
#pod
#pod     $msg->replace('Content-disposition' => '');
#pod     $msg->replace('Content-length'      => '');
#pod
#pod =cut


sub scrub {
    my ( $self, @a ) = @_;
    my ($expl) = @a;
    local $QUIET = 1;

    ### Scrub me:
    if ( !@a ) {    ### guess

        ### Scrub length always:
        $self->replace( 'content-length', '' );

        ### Scrub disposition if no filename, or if content-type has same info:
        if ( !$self->_safe_attr('content-disposition.filename')
             || $self->_safe_attr('content-type.name') )
        {
            $self->replace( 'content-disposition', '' );
        }

        ### Scrub encoding if effectively unencoded:
        if ( $self->_safe_attr('content-transfer-encoding') =~ /^(7bit|8bit|binary)$/i ) {
            $self->replace( 'content-transfer-encoding', '' );
        }

        ### Scrub charset if US-ASCII:
        if ( $self->_safe_attr('content-type.charset') =~ /^(us-ascii)/i ) {
            $self->attr( 'content-type.charset' => undef );
        }

        ### TBD: this is not really right for message/digest:
        if (     ( keys %{ $self->{Attrs}{'content-type'} } == 1 )
             and ( $self->_safe_attr('content-type') eq 'text/plain' ) )
        {
            $self->replace( 'content-type', '' );
        }
    } elsif ( $expl and ( ref($expl) eq 'ARRAY' ) ) {
        foreach ( @{$expl} ) { $self->replace( $_, '' ); }
    }

    ### Scrub my kids:
    foreach ( @{ $self->{Parts} } ) { $_->scrub(@a); }
}

#pod =back
#pod
#pod =cut


#==============================
#==============================

#pod =head2 Setting/getting message data
#pod
#pod =over 4
#pod
#pod =cut


#------------------------------

#pod =item binmode [OVERRIDE]
#pod
#pod I<Instance method.>
#pod With no argument, returns whether or not it thinks that the data
#pod (as given by the "Path" argument of C<build()>) should be read using
#pod binmode() (for example, when C<read_now()> is invoked).
#pod
#pod The default behavior is that any content type other than
#pod C<text/*> or C<message/*> is binmode'd; this should in general work fine.
#pod
#pod With a defined argument, this method sets an explicit "override"
#pod value.  An undefined argument unsets the override.
#pod The new current value is returned.
#pod
#pod =cut


sub binmode {
    my $self = shift;
    $self->{Binmode} = shift if (@_);    ### argument? set override
    return ( defined( $self->{Binmode} )
             ? $self->{Binmode}
             : ( $self->{Attrs}{"content-type"} !~ m{^(text|message)/}i )
    );
}

#------------------------------

#pod =item data [DATA]
#pod
#pod I<Instance method.>
#pod Get/set the literal DATA of the message.  The DATA may be
#pod either a scalar, or a reference to an array of scalars (which
#pod will simply be joined).
#pod
#pod I<Warning:> setting the data causes the "content-length" attribute
#pod to be recomputed (possibly to nothing).
#pod
#pod =cut


sub data {
    my $self = shift;
    if (@_) {
        $self->{Data} = ( ( ref( $_[0] ) eq 'ARRAY' ) ? join( '', @{ $_[0] } ) : $_[0] );
        $self->get_length;
    }
    $self->{Data};
}

#------------------------------

#pod =item fh [FILEHANDLE]
#pod
#pod I<Instance method.>
#pod Get/set the FILEHANDLE which contains the message data.
#pod
#pod Takes a filehandle as an input and stores it in the object.
#pod This routine is similar to path(); one important difference is that
#pod no attempt is made to set the content length.
#pod
#pod =cut


sub fh {
    my $self = shift;
    $self->{FH} = shift if @_;
    $self->{FH};
}

#------------------------------

#pod =item path [PATH]
#pod
#pod I<Instance method.>
#pod Get/set the PATH to the message data.
#pod
#pod I<Warning:> setting the path recomputes any existing "content-length" field,
#pod and re-sets the "filename" (to the last element of the path if it
#pod looks like a simple path, and to nothing if not).
#pod
#pod =cut


sub path {
    my $self = shift;
    if (@_) {

        ### Set the path, and invalidate the content length:
        $self->{Path} = shift;

        ### Re-set filename, extracting it from path if possible:
        my $filename;
        if ( $self->{Path} and ( $self->{Path} !~ /\|$/ ) ) {    ### non-shell path:
            ( $filename = $self->{Path} ) =~ s/^<//;

            ### Consult File::Basename
            $filename = File::Basename::basename($filename);
        }
        $self->filename($filename);

        ### Reset the length:
        $self->get_length;
    }
    $self->{Path};
}

#------------------------------

#pod =item resetfh [FILEHANDLE]
#pod
#pod I<Instance method.>
#pod Set the current position of the filehandle back to the beginning.
#pod Only applies if you used "FH" in build() or attach() for this message.
#pod
#pod Returns false if unable to reset the filehandle (since not all filehandles
#pod are seekable).
#pod
#pod =cut


#----
# Miko's note: With the Data and Path, the same data could theoretically
# be reused.  However, file handles need to be reset to be reused,
# so I added this routine.
#
# Eryq reply: beware... not all filehandles are seekable (think about STDIN)!

sub resetfh {
    my $self = shift;
    seek( $self->{FH}, 0, 0 );
}

#------------------------------

#pod =item read_now
#pod
#pod I<Instance method.>
#pod Forces data from the path/filehandle (as specified by C<build()>)
#pod to be read into core immediately, just as though you had given it
#pod literally with the C<Data> keyword.
#pod
#pod Note that the in-core data will always be used if available.
#pod
#pod Be aware that everything is slurped into a giant scalar: you may not want
#pod to use this if sending tar files!  The benefit of I<not> reading in the data
#pod is that very large files can be handled by this module if left on disk
#pod until the message is output via C<print()> or C<print_body()>.
#pod
#pod =cut


sub read_now {
    my $self = shift;
    local $/ = undef;

    if ( $self->{FH} ) {    ### data from a filehandle:
        my $chunk;
        my @chunks;
        CORE::binmode( $self->{FH} ) if $self->binmode;
        while ( read( $self->{FH}, $chunk, 1024 ) ) {
            push @chunks, $chunk;
        }
        $self->{Data} = join '', @chunks;
    } elsif ( $self->{Path} ) {    ### data from a path:
        open SLURP, $self->{Path} or Carp::croak "open $self->{Path}: $!\n";
        CORE::binmode(SLURP) if $self->binmode;
        $self->{Data} = <SLURP>;    ### sssssssssssssslurp...
        close SLURP;                ### ...aaaaaaaaahhh!
    }
}

#------------------------------

#pod =item sign PARAMHASH
#pod
#pod I<Instance method.>
#pod Sign the message.  This forces the message to be read into core,
#pod after which the signature is appended to it.
#pod
#pod =over 4
#pod
#pod =item Data
#pod
#pod As in C<build()>: the literal signature data.
#pod Can be either a scalar or a ref to an array of scalars.
#pod
#pod =item Path
#pod
#pod As in C<build()>: the path to the file.
#pod
#pod =back
#pod
#pod If no arguments are given, the default is:
#pod
#pod     Path => "$ENV{HOME}/.signature"
#pod
#pod The content-length is recomputed.
#pod
#pod =cut


sub sign {
    my $self   = shift;
    my %params = @_;

    ### Default:
    @_ or $params{Path} = "$ENV{HOME}/.signature";

    ### Force message in-core:
    defined( $self->{Data} ) or $self->read_now;

    ### Load signature:
    my $sig;
    if ( !defined( $sig = $params{Data} ) ) {    ### not given explicitly:
        local $/ = undef;
        open SIG, $params{Path} or Carp::croak "open sig $params{Path}: $!\n";
        $sig = <SIG>;                            ### sssssssssssssslurp...
        close SIG;                               ### ...aaaaaaaaahhh!
    }
    $sig = join( '', @$sig ) if ( ref($sig) and ( ref($sig) eq 'ARRAY' ) );

    ### Append, following Internet conventions:
    $self->{Data} .= "\n-- \n$sig";

    ### Re-compute length:
    $self->get_length;
    1;
}

#------------------------------
#
# =item suggest_encoding CONTENTTYPE
#
# I<Class/instance method.>
# Based on the CONTENTTYPE, return a good suggested encoding.
# C<text> and C<message> types have their bodies scanned line-by-line
# for 8-bit characters and long lines; lack of either means that the
# message is 7bit-ok.  Other types are chosen independent of their body:
#
#    Major type:       7bit ok?    Suggested encoding:
#    ------------------------------------------------------------
#    text              yes         7bit
#                      no          quoted-printable
#                      unknown     binary
#
#    message           yes         7bit
#                      no          binary
#                      unknown     binary
#
#    multipart         n/a         binary (in case some parts are not ok)
#
#    (other)           n/a         base64
#
#=cut

sub suggest_encoding {
    my ( $self, $ctype ) = @_;
    $ctype = lc($ctype);

    ### Consult MIME::Types, maybe:
    if ($HaveMimeTypes) {

        ### Mappings contain [suffix,mimetype,encoding]
        my @mappings = MIME::Types::by_mediatype($ctype);
        if ( scalar(@mappings) ) {
            ### Just pick the first one:
            my ( $suffix, $mimetype, $encoding ) = @{ $mappings[0] };
            if (    $encoding
                 && $encoding =~ /^(base64|binary|[78]bit|quoted-printable)$/i )
            {
                return lc($encoding);    ### sanity check
            }
        }
    }

    ### If we got here, then MIME::Types was no help.
    ### Extract major type:
    my ($type) = split '/', $ctype;
    if ( ( $type eq 'text' ) || ( $type eq 'message' ) ) {    ### scan message body?
        return 'binary';
    } else {
        return ( $type eq 'multipart' ) ? 'binary' : 'base64';
    }
}

#------------------------------
#
# =item suggest_type PATH
#
# I<Class/instance method.>
# Suggest the content-type for this attached path.
# We always fall back to "application/octet-stream" if no good guess
# can be made, so don't use this if you don't mean it!
#
sub suggest_type {
    my ( $self, $path ) = @_;

    ### If there's no path, bail:
    $path or return 'application/octet-stream';

    ### Consult MIME::Types, maybe:
    if ($HaveMimeTypes) {

        # Mappings contain [mimetype,encoding]:
        my ( $mimetype, $encoding ) = MIME::Types::by_suffix($path);
        return $mimetype if ( $mimetype && $mimetype =~ /^\S+\/\S+$/ );    ### sanity check
    }
    ### If we got here, then MIME::Types was no help.
    ### The correct thing to fall back to is the most-generic content type:
    return 'application/octet-stream';
}

#------------------------------

#pod =item verify_data
#pod
#pod I<Instance method.>
#pod Verify that all "paths" to attached data exist, recursively.
#pod It might be a good idea for you to do this before a print(), to
#pod prevent accidental partial output if a file might be missing.
#pod Raises exception if any path is not readable.
#pod
#pod =cut


sub verify_data {
    my $self = shift;

    ### Verify self:
    my $path = $self->{Path};
    if ( $path and ( $path !~ /\|$/ ) ) {    ### non-shell path:
        $path =~ s/^<//;
        ( -r $path ) or die "$path: not readable\n";
    }

    ### Verify parts:
    foreach my $part ( @{ $self->{Parts} } ) { $part->verify_data }
    1;
}

#pod =back
#pod
#pod =cut


#==============================
#==============================

#pod =head2 Output
#pod
#pod =over 4
#pod
#pod =cut


#------------------------------

#pod =item print [OUTHANDLE]
#pod
#pod I<Instance method.>
#pod Print the message to the given output handle, or to the currently-selected
#pod filehandle if none was given.
#pod
#pod All OUTHANDLE has to be is a filehandle (possibly a glob ref), or
#pod any object that responds to a print() message.
#pod
#pod =cut


sub print {
    my ( $self, $out ) = @_;

    ### Coerce into a printable output handle:
    $out = MIME::Lite::IO_Handle->wrap($out);

    ### Output head, separator, and body:
    $self->verify_data if $AUTO_VERIFY;    ### prevents missing parts!
    $out->print( $self->header_as_string );
    $out->print( "\n" );
    $self->print_body($out);
}

#------------------------------
#
# print_for_smtp
#
# Instance method, private.
# Print, but filter out the topmost "Bcc" field.
# This is because qmail apparently doesn't do this for us!
#
sub print_for_smtp {
    my ( $self, $out ) = @_;

    ### Coerce into a printable output handle:
    $out = MIME::Lite::IO_Handle->wrap($out);

    ### Create a safe head:
    my @fields = grep { $_->[0] ne 'bcc' } @{ $self->fields };
    my $header = $self->fields_as_string( \@fields );

    ### Output head, separator, and body:
    $out->print( $header );
    $out->print( "\n" );
    $self->print_body( $out, '1' );
}

#------------------------------

#pod =item print_body [OUTHANDLE] [IS_SMTP]
#pod
#pod I<Instance method.>
#pod Print the body of a message to the given output handle, or to
#pod the currently-selected filehandle if none was given.
#pod
#pod All OUTHANDLE has to be is a filehandle (possibly a glob ref), or
#pod any object that responds to a print() message.
#pod
#pod B<Fatal exception> raised if unable to open any of the input files,
#pod or if a part contains no data, or if an unsupported encoding is
#pod encountered.
#pod
#pod IS_SMPT is a special option to handle SMTP mails a little more
#pod intelligently than other send mechanisms may require. Specifically this
#pod ensures that the last byte sent is NOT '\n' (octal \012) if the last two
#pod bytes are not '\r\n' (\015\012) as this will cause some SMTP servers to
#pod hang.
#pod
#pod =cut


sub print_body {
    my ( $self, $out, $is_smtp ) = @_;
    my $attrs = $self->{Attrs};
    my $sub_attrs = $self->{SubAttrs};

    ### Coerce into a printable output handle:
    $out = MIME::Lite::IO_Handle->wrap($out);

    ### Output either the body or the parts.
    ###   Notice that we key off of the content-type!  We expect fewer
    ###   accidents that way, since the syntax will always match the MIME type.
    my $type = $attrs->{'content-type'};
    if ( $type =~ m{^multipart/}i ) {
        my $boundary = $sub_attrs->{'content-type'}{'boundary'};

        ### Preamble:
        $out->print( defined( $self->{Preamble} )
                     ? $self->{Preamble}
                     : "This is a multi-part message in MIME format.\n"
        );

        ### Parts:
        my $part;
        foreach $part ( @{ $self->{Parts} } ) {
            $out->print("\n--$boundary\n");
            $part->print($out);
        }

        ### Epilogue:
        $out->print("\n--$boundary--\n\n");
    } elsif ( $type =~ m{^message/} ) {
        my @parts = @{ $self->{Parts} };

        ### It's a toss-up; try both data and parts:
        if ( @parts == 0 ) { $self->print_simple_body( $out, $is_smtp ) }
        elsif ( @parts == 1 ) { $parts[0]->print($out) }
        else { Carp::croak "can't handle message with >1 part\n"; }
    } else {
        $self->print_simple_body( $out, $is_smtp );
    }
    1;
}

#------------------------------
#
# print_simple_body [OUTHANDLE]
#
# I<Instance method, private.>
# Print the body of a simple singlepart message to the given
# output handle, or to the currently-selected filehandle if none
# was given.
#
# Note that if you want to print "the portion after
# the header", you don't want this method: you want
# L<print_body()|/print_body>.
#
# All OUTHANDLE has to be is a filehandle (possibly a glob ref), or
# any object that responds to a print() message.
#
# B<Fatal exception> raised if unable to open any of the input files,
# or if a part contains no data, or if an unsupported encoding is
# encountered.
#
sub print_simple_body {
    my ( $self, $out, $is_smtp ) = @_;
    my $attrs = $self->{Attrs};

    ### Coerce into a printable output handle:
    $out = MIME::Lite::IO_Handle->wrap($out);

    ### Get content-transfer-encoding:
    my $encoding = uc( $attrs->{'content-transfer-encoding'} );
    warn "M::L >>> Encoding using $encoding, is_smtp=" . ( $is_smtp || 0 ) . "\n"
      if $MIME::Lite::DEBUG;

    ### Notice that we don't just attempt to slurp the data in from a file:
    ### by processing files piecemeal, we still enable ourselves to prepare
    ### very large MIME messages...

    ### Is the data in-core?  If so, blit it out...
    if ( defined( $self->{Data} ) ) {
      DATA:
        {
            local $_ = $encoding;

            /^BINARY$/ and do {
                $is_smtp and $self->{Data} =~ s/(?!\r)\n\z/\r/;
                $out->print( $self->{Data} );
                last DATA;
            };
            /^8BIT$/ and do {
                $out->print( encode_8bit( $self->{Data} ) );
                last DATA;
            };
            /^7BIT$/ and do {
                $out->print( encode_7bit( $self->{Data} ) );
                last DATA;
            };
            /^QUOTED-PRINTABLE$/ and do {
                ### UNTAINT since m//mg on tainted data loops forever:
                my ($untainted) = ( $self->{Data} =~ m/\A(.*)\Z/s );

                ### Encode it line by line:
                while ( $untainted =~ m{^(.*[\r\n]*)}smg ) {
                    ### have to do it line by line...
                    my $line = $1; # copy to avoid weird bug; rt 39334
                    $out->print( encode_qp($line) );
                }
                last DATA;
            };
            /^BASE64/ and do {
                $out->print( encode_base64( $self->{Data} ) );
                last DATA;
            };
            Carp::croak "unsupported encoding: `$_'\n";
        }
    }

    ### Else, is the data in a file?  If so, output piecemeal...
    ###    Miko's note: this routine pretty much works the same with a path
    ###    or a filehandle. the only difference in behaviour is that it does
    ###    not attempt to open anything if it already has a filehandle
    elsif ( defined( $self->{Path} ) || defined( $self->{FH} ) ) {
        no strict 'refs';    ### in case FH is not an object
        my $DATA;

        ### Open file if necessary:
        if ( defined( $self->{Path} ) ) {
            $DATA = new FileHandle || Carp::croak "can't get new filehandle\n";
            $DATA->open("$self->{Path}")
              or Carp::croak "open $self->{Path}: $!\n";
        } else {
            $DATA = $self->{FH};
        }
        CORE::binmode($DATA) if $self->binmode;

        ### Encode piece by piece:
      PATH:
        {
            local $_ = $encoding;

            /^BINARY$/ and do {
                my $last = "";
                while ( read( $DATA, $_, 2048 ) ) {
                    $out->print($last) if length $last;
                    $last = $_;
                }
                if ( length $last ) {
                    $is_smtp and $last =~ s/(?!\r)\n\z/\r/;
                    $out->print($last);
                }
                last PATH;
            };
            /^8BIT$/ and do {
                $out->print( encode_8bit($_) ) while (<$DATA>);
                last PATH;
            };
            /^7BIT$/ and do {
                $out->print( encode_7bit($_) ) while (<$DATA>);
                last PATH;
            };
            /^QUOTED-PRINTABLE$/ and do {
                $out->print( encode_qp($_) ) while (<$DATA>);
                last PATH;
            };
            /^BASE64$/ and do {
                $out->print( encode_base64($_) ) while ( read( $DATA, $_, 45 ) );
                last PATH;
            };
            Carp::croak "unsupported encoding: `$_'\n";
        }

        ### Close file:
        close $DATA if defined( $self->{Path} );
    }

    else {
        Carp::croak "no data in this part\n";
    }
    1;
}

#------------------------------

#pod =item print_header [OUTHANDLE]
#pod
#pod I<Instance method.>
#pod Print the header of the message to the given output handle,
#pod or to the currently-selected filehandle if none was given.
#pod
#pod All OUTHANDLE has to be is a filehandle (possibly a glob ref), or
#pod any object that responds to a print() message.
#pod
#pod =cut


sub print_header {
    my ( $self, $out ) = @_;

    ### Coerce into a printable output handle:
    $out = MIME::Lite::IO_Handle->wrap($out);

    ### Output the header:
    $out->print( $self->header_as_string );
    1;
}

#------------------------------

#pod =item as_string
#pod
#pod I<Instance method.>
#pod Return the entire message as a string, with a header and an encoded body.
#pod
#pod =cut


sub as_string {
    my $self = shift;
    my $buf  = "";
    my $io   = ( wrap MIME::Lite::IO_Scalar \$buf);
    $self->print($io);
    return $buf;
}
*stringify = \&as_string;    ### backwards compatibility
*stringify = \&as_string;    ### ...twice to avoid warnings :)

#------------------------------

#pod =item body_as_string
#pod
#pod I<Instance method.>
#pod Return the encoded body as a string.
#pod This is the portion after the header and the blank line.
#pod
#pod I<Note:> actually prepares the body by "printing" to a scalar.
#pod Proof that you can hand the C<print*()> methods any blessed object
#pod that responds to a C<print()> message.
#pod
#pod =cut


sub body_as_string {
    my $self = shift;
    my $buf  = "";
    my $io   = ( wrap MIME::Lite::IO_Scalar \$buf);
    $self->print_body($io);
    return $buf;
}
*stringify_body = \&body_as_string;    ### backwards compatibility
*stringify_body = \&body_as_string;    ### ...twice to avoid warnings :)

#------------------------------
#
# fields_as_string FIELDS
#
# PRIVATE!  Return a stringified version of the given header
# fields, where FIELDS is an arrayref like that returned by fields().
#
sub fields_as_string {
    my ( $self, $fields ) = @_;
    my $out = "";
    foreach (@$fields) {
        my ( $tag, $value ) = @$_;
        next if ( $value eq '' );         ### skip empties
        $tag =~ s/\b([a-z])/uc($1)/ge;    ### make pretty
        $tag =~ s/^mime-/MIME-/i;         ### even prettier
        if (length($value) > 72 && $value !~ /\n/) {
            $value = fold_header($value);
        }
        $out .= "$tag: $value\n";
    }
    return $out;
}

sub fold_header {
    local $_ = shift;
    my $Eol = shift || "\n";

    # Undo any existing folding
    s/\r?\n(\s)/$1/gms;

    # Pulled partly from Mail::Message::Field
    my $Folded = '';
    while (1) {
        if (length($_) < 72) {
            $Folded .= $_;
            last;
        }
        # Prefer breaking at ; or ,
        s/^(.{18,72}[;,])([ \t])// ||
        # Otherwise any space is fine
        s/^(.{18,72})([ \t])// ||
        # Hmmm, longer than 72 chars, find up to next whitespace
        s/^(.{72,}?)([ \t])// ||
        # Ok, better just get everything
        s/^(.*)()//;
        $Folded .= $1 . $Eol . $2;
    }

    # Strip the trailing eol
    $Folded =~ s/${Eol}$//;

    return $Folded;
}

#------------------------------

#pod =item header_as_string
#pod
#pod I<Instance method.>
#pod Return the header as a string.
#pod
#pod =cut


sub header_as_string {
    my $self = shift;
    $self->fields_as_string( $self->fields );
}
*stringify_header = \&header_as_string;    ### backwards compatibility
*stringify_header = \&header_as_string;    ### ...twice to avoid warnings :)

#pod =back
#pod
#pod =cut


#==============================
#==============================

#pod =head2 Sending
#pod
#pod =over 4
#pod
#pod =cut


#------------------------------

#pod =item send
#pod
#pod =item send HOW, HOWARGS...
#pod
#pod I<Class/instance method.>
#pod This is the principal method for sending mail, and for configuring
#pod how mail will be sent.
#pod
#pod I<As a class method> with a HOW argument and optional HOWARGS, it sets
#pod the default sending mechanism that the no-argument instance method
#pod will use.  The HOW is a facility name (B<see below>),
#pod and the HOWARGS is interpreted by the facility.
#pod The class method returns the previous HOW and HOWARGS as an array.
#pod
#pod     MIME::Lite->send('sendmail', "d:\\programs\\sendmail.exe");
#pod     ...
#pod     $msg = MIME::Lite->new(...);
#pod     $msg->send;
#pod
#pod I<As an instance method with arguments>
#pod (a HOW argument and optional HOWARGS), sends the message in the
#pod requested manner; e.g.:
#pod
#pod     $msg->send('sendmail', "d:\\programs\\sendmail.exe");
#pod
#pod I<As an instance method with no arguments,> sends the
#pod message by the default mechanism set up by the class method.
#pod Returns whatever the mail-handling routine returns: this
#pod should be true on success, false/exception on error:
#pod
#pod     $msg = MIME::Lite->new(From=>...);
#pod     $msg->send || die "you DON'T have mail!";
#pod
#pod On Unix systems (or rather non-Win32 systems), the default
#pod setting is equivalent to:
#pod
#pod     MIME::Lite->send("sendmail", "/usr/lib/sendmail -t -oi -oem");
#pod
#pod On Win32 systems the default setting is equivalent to:
#pod
#pod     MIME::Lite->send("smtp");
#pod
#pod The assumption is that on Win32 your site/lib/Net/libnet.cfg
#pod file will be preconfigured to use the appropriate SMTP
#pod server. See below for configuring for authentication.
#pod
#pod There are three facilities:
#pod
#pod =over 4
#pod
#pod =item "sendmail", ARGS...
#pod
#pod Send a message by piping it into the "sendmail" command.
#pod Uses the L<send_by_sendmail()|/send_by_sendmail> method, giving it the ARGS.
#pod This usage implements (and deprecates) the C<sendmail()> method.
#pod
#pod =item "smtp", [HOSTNAME, [NAMEDPARMS] ]
#pod
#pod Send a message by SMTP, using optional HOSTNAME as SMTP-sending host.
#pod L<Net::SMTP> will be required.  Uses the L<send_by_smtp()|/send_by_smtp>
#pod method. Any additional arguments passed in will also be passed through to
#pod send_by_smtp.  This is useful for things like mail servers requiring
#pod authentication where you can say something like the following
#pod
#pod   MIME::Lite->send('smtp', $host, AuthUser=>$user, AuthPass=>$pass);
#pod
#pod which will configure things so future uses of
#pod
#pod   $msg->send();
#pod
#pod do the right thing.
#pod
#pod =item "sub", \&SUBREF, ARGS...
#pod
#pod Sends a message MSG by invoking the subroutine SUBREF of your choosing,
#pod with MSG as the first argument, and ARGS following.
#pod
#pod =back
#pod
#pod I<For example:> let's say you're on an OS which lacks the usual Unix
#pod "sendmail" facility, but you've installed something a lot like it, and
#pod you need to configure your Perl script to use this "sendmail.exe" program.
#pod Do this following in your script's setup:
#pod
#pod     MIME::Lite->send('sendmail', "d:\\programs\\sendmail.exe");
#pod
#pod Then, whenever you need to send a message $msg, just say:
#pod
#pod     $msg->send;
#pod
#pod That's it.  Now, if you ever move your script to a Unix box, all you
#pod need to do is change that line in the setup and you're done.
#pod All of your $msg-E<gt>send invocations will work as expected.
#pod
#pod After sending, the method last_send_successful() can be used to determine
#pod if the send was successful or not.
#pod
#pod =cut


sub send {
    my $self = shift;
    my $meth = shift;

    if ( ref($self) ) {    ### instance method:
        my ( $method, @args );
        if (@_) {          ### args; use them just this once
            $method = 'send_by_' . $meth;
            @args   = @_;
        } else {           ### no args; use defaults
            $method = "send_by_$Sender";
            @args   = @{ $SenderArgs{$Sender} || [] };
        }
        $self->verify_data if $AUTO_VERIFY;    ### prevents missing parts!
        Carp::croak "Unknown send method '$meth'" unless $self->can($method);
        return $self->$method(@args);
    } else {                                   ### class method:
        if (@_) {
            my @old = ( $Sender, @{ $SenderArgs{$Sender} } );
            $Sender              = $meth;
            $SenderArgs{$Sender} = [@_];       ### remaining args
            return @old;
        } else {
            Carp::croak "class method send must have HOW... arguments\n";
        }
    }
}


#------------------------------

#pod =item send_by_sendmail SENDMAILCMD
#pod
#pod =item send_by_sendmail PARAM=>VALUE, ARRAY, HASH...
#pod
#pod I<Instance method.>
#pod Send message via an external "sendmail" program
#pod (this will probably only work out-of-the-box on Unix systems).
#pod
#pod Returns true on success, false or exception on error.
#pod
#pod You can specify the program and all its arguments by giving a single
#pod string, SENDMAILCMD.  Nothing fancy is done; the message is simply
#pod piped in.
#pod
#pod However, if your needs are a little more advanced, you can specify
#pod zero or more of the following PARAM/VALUE pairs (or a reference to hash
#pod or array of such arguments as well as any combination thereof); a
#pod Unix-style, taint-safe "sendmail" command will be constructed for you:
#pod
#pod =over 4
#pod
#pod =item Sendmail
#pod
#pod Full path to the program to use.
#pod Default is "/usr/lib/sendmail".
#pod
#pod =item BaseArgs
#pod
#pod Ref to the basic array of arguments we start with.
#pod Default is C<["-t", "-oi", "-oem"]>.
#pod
#pod =item SetSender
#pod
#pod Unless this is I<explicitly> given as false, we attempt to automatically
#pod set the C<-f> argument to the first address that can be extracted from
#pod the "From:" field of the message (if there is one).
#pod
#pod I<What is the -f, and why do we use it?>
#pod Suppose we did I<not> use C<-f>, and you gave an explicit "From:"
#pod field in your message: in this case, the sendmail "envelope" would
#pod indicate the I<real> user your process was running under, as a way
#pod of preventing mail forgery.  Using the C<-f> switch causes the sender
#pod to be set in the envelope as well.
#pod
#pod I<So when would I NOT want to use it?>
#pod If sendmail doesn't regard you as a "trusted" user, it will permit
#pod the C<-f> but also add an "X-Authentication-Warning" header to the message
#pod to indicate a forged envelope.  To avoid this, you can either
#pod (1) have SetSender be false, or
#pod (2) make yourself a trusted user by adding a C<T> configuration
#pod     command to your I<sendmail.cf> file
#pod     (e.g.: C<Teryq> if the script is running as user "eryq").
#pod
#pod =item FromSender
#pod
#pod If defined, this is identical to setting SetSender to true,
#pod except that instead of looking at the "From:" field we use
#pod the address given by this option.
#pod Thus:
#pod
#pod     FromSender => 'me@myhost.com'
#pod
#pod =back
#pod
#pod After sending, the method last_send_successful() can be used to determine
#pod if the send was successful or not.
#pod
#pod =cut

sub _unfold_stupid_params {
  my $self = shift;

  my %p;
  STUPID_PARAM: for (my $i = 0; $i < @_; $i++) { ## no critic Loop
    my $item = $_[$i];
    if (not ref $item) {
      $p{ $item } = $_[ ++$i ];
    } elsif (UNIVERSAL::isa($item, 'HASH')) {
      $p{ $_ } = $item->{ $_ } for keys %$item;
    } elsif (UNIVERSAL::isa($item, 'ARRAY')) {
      for (my $j = 0; $j < @$item; $j += 2) {
        $p{ $item->[ $j ] } = $item->[ $j + 1 ];
      }
    }
  }

  return %p;
}

sub send_by_sendmail {
    my $self = shift;
    my $return;
    if ( @_ == 1 and !ref $_[0] ) {
        ### Use the given command...
        my $sendmailcmd = shift @_;
        Carp::croak "No sendmail command available" unless $sendmailcmd;

        ### Do it:
        local *SENDMAIL;
        open SENDMAIL, "|$sendmailcmd" or Carp::croak "open |$sendmailcmd: $!\n";
        $self->print( \*SENDMAIL );
        close SENDMAIL;
        $return = ( ( $? >> 8 ) ? undef: 1 );
    } else {    ### Build the command...
        my %p = $self->_unfold_stupid_params(@_);

        $p{Sendmail} = $SENDMAIL unless defined $p{Sendmail};

        ### Start with the command and basic args:
        my @cmd = ( $p{Sendmail}, @{ $p{BaseArgs} || [ '-t', '-oi', '-oem' ] } );

        # SetSender default is true
        $p{SetSender} = 1 unless defined $p{SetSender};

        ### See if we are forcibly setting the sender:
        $p{SetSender} ||= defined( $p{FromSender} );

        ### Add the -f argument, unless we're explicitly told NOT to:
        if ( $p{SetSender} ) {
            my $from = $p{FromSender} || ( $self->get('From') )[0];
            if ($from) {
                my ($from_addr) = extract_only_addrs($from);
                push @cmd, "-f$from_addr" if $from_addr;
            }
        }

        ### Open the command in a taint-safe fashion:
        my $pid = open SENDMAIL, "|-";
        defined($pid) or die "open of pipe failed: $!\n";
        if ( !$pid ) {    ### child
            exec(@cmd) or die "can't exec $p{Sendmail}: $!\n";
            ### NOTREACHED
        } else {          ### parent
            $self->print( \*SENDMAIL );
            close SENDMAIL || die "error closing $p{Sendmail}: $! (exit $?)\n";
            $return = 1;
        }
    }
    return $self->{last_send_successful} = $return;
}

#------------------------------

#pod =item send_by_smtp HOST, ARGS...
#pod
#pod =item send_by_smtp REF, HOST, ARGS
#pod
#pod I<Instance method.>
#pod Send message via SMTP, using Net::SMTP -- which will be required for this
#pod feature.
#pod
#pod HOST is the name of SMTP server to connect to, or undef to have
#pod L<Net::SMTP|Net::SMTP> use the defaults in Libnet.cfg.
#pod
#pod ARGS are a list of key value pairs which may be selected from the list
#pod below. Many of these are just passed through to specific
#pod L<Net::SMTP|Net::SMTP> commands and you should review that module for
#pod details.
#pod
#pod Please see L<Good-vs-bad email addresses with send_by_smtp()|/Good-vs-bad email addresses with send_by_smtp()>
#pod
#pod =over 4
#pod
#pod =item Hello
#pod
#pod =item LocalAddr
#pod
#pod =item LocalPort
#pod
#pod =item Timeout
#pod
#pod =item Port
#pod
#pod =item ExactAddresses
#pod
#pod =item Debug
#pod
#pod See L<Net::SMTP::new()|Net::SMTP/"mail"> for details.
#pod
#pod =item Size
#pod
#pod =item Return
#pod
#pod =item Bits
#pod
#pod =item Transaction
#pod
#pod =item Envelope
#pod
#pod See L<Net::SMTP::mail()|Net::SMTP/mail> for details.
#pod
#pod =item SkipBad
#pod
#pod If true doesn't throw an error when multiple email addresses are provided
#pod and some are not valid. See L<Net::SMTP::recipient()|Net::SMTP/recipient>
#pod for details.
#pod
#pod =item AuthUser
#pod
#pod Authenticate with L<Net::SMTP::auth()|Net::SMTP/auth> using this username.
#pod
#pod =item AuthPass
#pod
#pod Authenticate with L<Net::SMTP::auth()|Net::SMTP/auth> using this password.
#pod
#pod =item NoAuth
#pod
#pod Normally if AuthUser and AuthPass are defined MIME::Lite will attempt to
#pod use them with the L<Net::SMTP::auth()|Net::SMTP/auth> command to
#pod authenticate the connection, however if this value is true then no
#pod authentication occurs.
#pod
#pod =item To
#pod
#pod Sets the addresses to send to. Can be a string or a reference to an
#pod array of strings. Normally this is extracted from the To: (and Cc: and
#pod Bcc: fields if $AUTO_CC is true).
#pod
#pod This value overrides that.
#pod
#pod =item From
#pod
#pod Sets the email address to send from. Normally this value is extracted
#pod from the Return-Path: or From: field of the mail itself (in that order).
#pod
#pod This value overrides that.
#pod
#pod =back
#pod
#pod I<Returns:>
#pod True on success, croaks with an error message on failure.
#pod
#pod After sending, the method last_send_successful() can be used to determine
#pod if the send was successful or not.
#pod
#pod =cut


# Derived from work by Andrew McRae. Version 0.2  anm  09Sep97
# Copyright 1997 Optimation New Zealand Ltd.
# May be modified/redistributed under the same terms as Perl.

# external opts
my @_mail_opts     = qw( Size Return Bits Transaction Envelope );
my @_recip_opts    = qw( SkipBad Notify );
my @_net_smtp_opts = qw( Hello LocalAddr LocalPort Timeout
                         AuthUser AuthPass SSL
                         Port ExactAddresses Debug );
# internal:  qw( NoAuth AuthUser AuthPass To From Host);

sub __opts {
    my $args=shift;
    return map { exists $args->{$_} ? ( $_ => $args->{$_} ) : () } @_;
}

sub send_by_smtp {
    require Net::SMTP;
    my ($self,$hostname,%args)  = @_;
    # We may need the "From:" and "To:" headers to pass to the
    # SMTP mailer also.
    $self->{last_send_successful}=0;

    my @hdr_to = extract_only_addrs( scalar $self->get('To') );
    if ($AUTO_CC) {
        foreach my $field (qw(Cc Bcc)) {
            push @hdr_to, extract_only_addrs($_) for $self->get($field);
        }
    }
    Carp::croak "send_by_smtp: nobody to send to for host '$hostname'?!\n"
        unless @hdr_to;

    $args{To} ||= \@hdr_to;
    $args{From} ||= extract_only_addrs( scalar $self->get('Return-Path') );
    $args{From} ||= extract_only_addrs( scalar $self->get('From') ) ;

    # Create SMTP client.
    # MIME::Lite::SMTP is just a wrapper giving a print method
    # to the SMTP object.

    my %opts = __opts(\%args, @_net_smtp_opts);
    my $smtp = MIME::Lite::SMTP->new( $hostname, %opts )
      or Carp::croak "SMTP Failed to connect to mail server: $!\n";

    # Possibly authenticate
    if ( defined $args{AuthUser} and defined $args{AuthPass}
         and !$args{NoAuth} )
    {
        if ($smtp->supports('AUTH',500,["Command unknown: 'AUTH'"])) {
            $smtp->auth( $args{AuthUser}, $args{AuthPass} )
                or die "SMTP auth() command failed: $!\n"
                   . $smtp->message . "\n";
        } else {
            die "SMTP auth() command not supported on $hostname\n";
        }
    }

    # Send the mail command
    %opts = __opts( \%args, @_mail_opts);
    $smtp->mail( $args{From}, %opts ? \%opts : () )
      or die "SMTP mail() command failed: $!\n"
             . $smtp->message . "\n";

    # Send the recipients command
    %opts = __opts( \%args, @_recip_opts);
    $smtp->recipient( @{ $args{To} }, %opts ? \%opts : () )
      or die "SMTP recipient() command failed: $!\n"
             . $smtp->message . "\n";

    # Send the data
    $smtp->data()
      or die "SMTP data() command failed: $!\n"
             . $smtp->message . "\n";
    $self->print_for_smtp($smtp);

    # Finish the mail
    $smtp->dataend()
      or Carp::croak "Net::CMD (Net::SMTP) DATAEND command failed.\n"
      . "Last server message was:"
      . $smtp->message
      . "This probably represents a problem with newline encoding ";

    # terminate the session
    $smtp->quit;

    return $self->{last_send_successful} = 1;
}

#pod =item send_by_testfile FILENAME
#pod
#pod I<Instance method.>
#pod Print message to a file (namely FILENAME), which will default to
#pod mailer.testfile
#pod If file exists, message will be appended.
#pod
#pod =cut

sub send_by_testfile {
  my $self = shift;

  ### Use the default filename...
  my $filename = 'mailer.testfile';

  if ( @_ == 1 and !ref $_[0] ) {
    ### Use the given filename if given...
    $filename = shift @_;
    Carp::croak "no filename given to send_by_testfile" unless $filename;
  }

  ### Do it:
  local *FILE;
  open FILE, ">> $filename" or Carp::croak "open $filename: $!\n";
  $self->print( \*FILE );
  close FILE;
  my $return = ( ( $? >> 8 ) ? undef: 1 );

  return $self->{last_send_successful} = $return;
}

#pod =item last_send_successful
#pod
#pod This method will return TRUE if the last send() or send_by_XXX() method call was
#pod successful. It will return defined but false if it was not successful, and undefined
#pod if the object had not been used to send yet.
#pod
#pod =cut


sub last_send_successful {
    my $self = shift;
    return $self->{last_send_successful};
}


### Provided by Andrew McRae. Version 0.2  anm  09Sep97
### Copyright 1997 Optimation New Zealand Ltd.
### May be modified/redistributed under the same terms as Perl.
### Aditional changes by Yves.
### Until 3.01_03 this was send_by_smtp()
sub send_by_smtp_simple {
    my ( $self, @args ) = @_;
    $self->{last_send_successful} = 0;
    ### We need the "From:" and "To:" headers to pass to the SMTP mailer:
    my $hdr = $self->fields();

    my $from_header = $self->get('From');
    my ($from) = extract_only_addrs($from_header);

    warn "M::L>>> $from_header => $from" if $MIME::Lite::DEBUG;


    my $to = $self->get('To');

    ### Sanity check:
    defined($to)
        or Carp::croak "send_by_smtp: missing 'To:' address\n";

    ### Get the destinations as a simple array of addresses:
    my @to_all = extract_only_addrs($to);
    if ($AUTO_CC) {
        foreach my $field (qw(Cc Bcc)) {
            my $value = $self->get($field);
            push @to_all, extract_only_addrs($value)
                if defined($value);
        }
    }

    ### Create SMTP client:
    require Net::SMTP;
    my $smtp = MIME::Lite::SMTP->new(@args)
      or Carp::croak("Failed to connect to mail server: $!\n");
    $smtp->mail($from)
      or Carp::croak( "SMTP MAIL command failed: $!\n" . $smtp->message . "\n" );
    $smtp->to(@to_all)
      or Carp::croak( "SMTP RCPT command failed: $!\n" . $smtp->message . "\n" );
    $smtp->data()
      or Carp::croak( "SMTP DATA command failed: $!\n" . $smtp->message . "\n" );

    ### MIME::Lite can print() to anything with a print() method:
    $self->print_for_smtp($smtp);

    $smtp->dataend()
      or Carp::croak(   "Net::CMD (Net::SMTP) DATAEND command failed.\n"
                      . "Last server message was:"
                      . $smtp->message
                      . "This probably represents a problem with newline encoding " );
    $smtp->quit;
    $self->{last_send_successful} = 1;
    1;
}

#------------------------------
#
# send_by_sub [\&SUBREF, [ARGS...]]
#
# I<Instance method, private.>
# Send the message via an anonymous subroutine.
#
sub send_by_sub {
    my ( $self, $subref, @args ) = @_;
    $self->{last_send_successful} = &$subref( $self, @args );

}

#------------------------------

#pod =item sendmail COMMAND...
#pod
#pod I<Class method, DEPRECATED.>
#pod Declare the sender to be "sendmail", and set up the "sendmail" command.
#pod I<You should use send() instead.>
#pod
#pod =cut


sub sendmail {
    my $self = shift;
    $self->send( 'sendmail', join( ' ', @_ ) );
}

#pod =back
#pod
#pod =cut


#==============================
#==============================

#pod =head2 Miscellaneous
#pod
#pod =over 4
#pod
#pod =cut


#------------------------------

#pod =item quiet ONOFF
#pod
#pod I<Class method.>
#pod Suppress/unsuppress all warnings coming from this module.
#pod
#pod     MIME::Lite->quiet(1);       ### I know what I'm doing
#pod
#pod I recommend that you include that comment as well.  And while
#pod you type it, say it out loud: if it doesn't feel right, then maybe
#pod you should reconsider the whole line.  C<;-)>
#pod
#pod =cut


sub quiet {
    my $class = shift;
    $QUIET = shift if @_;
    $QUIET;
}

#pod =back
#pod
#pod =cut


#============================================================

package MIME::Lite::SMTP 3.038;

#============================================================
# This class just adds a print() method to Net::SMTP.
# Notice that we don't use/require it until it's needed!

use strict;
use vars qw( @ISA );
@ISA = qw(Net::SMTP);

# some of the below is borrowed from Data::Dumper
my %esc = ( "\a" => "\\a",
            "\b" => "\\b",
            "\t" => "\\t",
            "\n" => "\\n",
            "\f" => "\\f",
            "\r" => "\\r",
            "\e" => "\\e",
);

sub _hexify {
    local $_ = shift;
    my @split = m/(.{1,16})/gs;
    foreach my $split (@split) {
        ( my $txt = $split ) =~ s/([\a\b\t\n\f\r\e])/$esc{$1}/sg;
        $split =~ s/(.)/sprintf("%02X ",ord($1))/sge;
        print STDERR "M::L >>> $split : $txt\n";
    }
}

sub print {
    my $smtp = shift;
    $MIME::Lite::DEBUG and _hexify( join( "", @_ ) );
    $smtp->datasend(@_)
      or Carp::croak(   "Net::CMD (Net::SMTP) DATASEND command failed.\n"
                      . "Last server message was:"
                      . $smtp->message
                      . "This probably represents a problem with newline encoding " );
}


#============================================================

package MIME::Lite::IO_Handle 3.038;

#============================================================

### Wrap a non-object filehandle inside a blessed, printable interface:
### Does nothing if the given $fh is already a blessed object.
sub wrap {
    my ( $class, $fh ) = @_;
    no strict 'refs';

    ### Get default, if necessary:
    $fh      or $fh = select;    ### no filehandle means selected one
    ref($fh) or $fh = \*$fh;     ### scalar becomes a globref

    ### Stop right away if already a printable object:
    return $fh if ( ref($fh) and ( ref($fh) ne 'GLOB' ) );

    ### Get and return a printable interface:
    bless \$fh, $class;          ### wrap it in a printable interface
}

### Print:
sub print {
    my $self = shift;
    print {$$self} @_;
}


#============================================================

package MIME::Lite::IO_Scalar 3.038;

#============================================================

### Wrap a scalar inside a blessed, printable interface:
sub wrap {
    my ( $class, $scalarref ) = @_;
    defined($scalarref) or $scalarref = \"";
    bless $scalarref, $class;
}

### Print:
sub print {
    ${$_[0]} .= join( '', @_[1..$#_] );
    1;
}


#============================================================

package MIME::Lite::IO_ScalarArray 3.038;

#============================================================

### Wrap an array inside a blessed, printable interface:
sub wrap {
    my ( $class, $arrayref ) = @_;
    defined($arrayref) or $arrayref = [];
    bless $arrayref, $class;
}

### Print:
sub print {
    my $self = shift;
    push @$self, @_;
    1;
}

1;

=pod

=encoding UTF-8

=head1 NAME

MIME::Lite - low-calorie MIME generator

=head1 VERSION

version 3.038

=head1 WAIT!

MIME::Lite is not recommended by its current maintainer.  There are a number of
alternatives, like Email::MIME or MIME::Entity and Email::Sender, which you
should probably use instead.  MIME::Lite continues to accrue weird bug reports,
and it is not receiving a large amount of refactoring due to the availability
of better alternatives.  Please consider using something else.

=head1 SYNOPSIS

Create and send using the default send method for your OS a single-part message:

    use MIME::Lite;
    ### Create a new single-part message, to send a GIF file:
    $msg = MIME::Lite->new(
        From     => 'me@myhost.com',
        To       => 'you@yourhost.com',
        Cc       => 'some@other.com, some@more.com',
        Subject  => 'Helloooooo, nurse!',
        Type     => 'image/gif',
        Encoding => 'base64',
        Path     => 'hellonurse.gif'
    );
    $msg->send; # send via default

Create a multipart message (i.e., one with attachments) and send it via SMTP

    ### Create a new multipart message:
    $msg = MIME::Lite->new(
        From    => 'me@myhost.com',
        To      => 'you@yourhost.com',
        Cc      => 'some@other.com, some@more.com',
        Subject => 'A message with 2 parts...',
        Type    => 'multipart/mixed'
    );

    ### Add parts (each "attach" has same arguments as "new"):
    $msg->attach(
        Type     => 'TEXT',
        Data     => "Here's the GIF file you wanted"
    );
    $msg->attach(
        Type     => 'image/gif',
        Path     => 'aaa000123.gif',
        Filename => 'logo.gif',
        Disposition => 'attachment'
    );
    ### use Net::SMTP to do the sending
    $msg->send('smtp','some.host', Debug=>1 );

Output a message:

    ### Format as a string:
    $str = $msg->as_string;

    ### Print to a filehandle (say, a "sendmail" stream):
    $msg->print(\*SENDMAIL);

Send a message:

    ### Send in the "best" way (the default is to use "sendmail"):
    $msg->send;
    ### Send a specific way:
    $msg->send('type',@args);

Specify default send method:

    MIME::Lite->send('smtp','some.host',Debug=>0);

with authentication

    MIME::Lite->send('smtp','some.host', AuthUser=>$user, AuthPass=>$pass);

using SSL

    MIME::Lite->send('smtp','some.host', SSL => 1, Port => 465 );

=head1 DESCRIPTION

In the never-ending quest for great taste with fewer calories,
we proudly present: I<MIME::Lite>.

MIME::Lite is intended as a simple, standalone module for generating
(not parsing!) MIME messages... specifically, it allows you to
output a simple, decent single- or multi-part message with text or binary
attachments.  It does not require that you have the Mail:: or MIME::
modules installed, but will work with them if they are.

You can specify each message part as either the literal data itself (in
a scalar or array), or as a string which can be given to open() to get
a readable filehandle (e.g., "<filename" or "somecommand|").

You don't need to worry about encoding your message data:
this module will do that for you.  It handles the 5 standard MIME encodings.

=head1 PERL VERSION

This library should run on perls released even a long time ago.  It should
work on any version of perl released in the last five years.

Although it may work on older versions of perl, no guarantee is made that the
minimum required version will not be increased.  The version may be increased
for any reason, and there is no promise that patches will be accepted to
lower the minimum required perl.

=head1 EXAMPLES

=head2 Create a simple message containing just text

    $msg = MIME::Lite->new(
        From     =>'me@myhost.com',
        To       =>'you@yourhost.com',
        Cc       =>'some@other.com, some@more.com',
        Subject  =>'Helloooooo, nurse!',
        Data     =>"How's it goin', eh?"
    );

=head2 Create a simple message containing just an image

    $msg = MIME::Lite->new(
        From     =>'me@myhost.com',
        To       =>'you@yourhost.com',
        Cc       =>'some@other.com, some@more.com',
        Subject  =>'Helloooooo, nurse!',
        Type     =>'image/gif',
        Encoding =>'base64',
        Path     =>'hellonurse.gif'
    );

=head2 Create a multipart message

    ### Create the multipart "container":
    $msg = MIME::Lite->new(
        From    =>'me@myhost.com',
        To      =>'you@yourhost.com',
        Cc      =>'some@other.com, some@more.com',
        Subject =>'A message with 2 parts...',
        Type    =>'multipart/mixed'
    );

    ### Add the text message part:
    ### (Note that "attach" has same arguments as "new"):
    $msg->attach(
        Type     =>'TEXT',
        Data     =>"Here's the GIF file you wanted"
    );

    ### Add the image part:
    $msg->attach(
        Type        =>'image/gif',
        Path        =>'aaa000123.gif',
        Filename    =>'logo.gif',
        Disposition => 'attachment'
    );

=head2 Attach a GIF to a text message

This will create a multipart message exactly as above, but using the
"attach to singlepart" hack:

    ### Start with a simple text message:
    $msg = MIME::Lite->new(
        From    =>'me@myhost.com',
        To      =>'you@yourhost.com',
        Cc      =>'some@other.com, some@more.com',
        Subject =>'A message with 2 parts...',
        Type    =>'TEXT',
        Data    =>"Here's the GIF file you wanted"
    );

    ### Attach a part... the make the message a multipart automatically:
    $msg->attach(
        Type     =>'image/gif',
        Path     =>'aaa000123.gif',
        Filename =>'logo.gif'
    );

=head2 Attach a pre-prepared part to a message

    ### Create a standalone part:
    $part = MIME::Lite->new(
        Top      => 0,
        Type     =>'text/html',
        Data     =>'<H1>Hello</H1>',
    );
    $part->attr('content-type.charset' => 'UTF-8');
    $part->add('X-Comment' => 'A message for you');

    ### Attach it to any message:
    $msg->attach($part);

=head2 Print a message to a filehandle

    ### Write it to a filehandle:
    $msg->print(\*STDOUT);

    ### Write just the header:
    $msg->print_header(\*STDOUT);

    ### Write just the encoded body:
    $msg->print_body(\*STDOUT);

=head2 Print a message into a string

    ### Get entire message as a string:
    $str = $msg->as_string;

    ### Get just the header:
    $str = $msg->header_as_string;

    ### Get just the encoded body:
    $str = $msg->body_as_string;

=head2 Send a message

    ### Send in the "best" way (the default is to use "sendmail"):
    $msg->send;

=head2 Send an HTML document... with images included!

    $msg = MIME::Lite->new(
         To      =>'you@yourhost.com',
         Subject =>'HTML with in-line images!',
         Type    =>'multipart/related'
    );
    $msg->attach(
        Type => 'text/html',
        Data => qq{
            <body>
                Here's <i>my</i> image:
                <img src="cid:myimage.gif">
            </body>
        },
    );
    $msg->attach(
        Type => 'image/gif',
        Id   => 'myimage.gif',
        Path => '/path/to/somefile.gif',
    );
    $msg->send();

=head2 Change how messages are sent

    ### Do something like this in your 'main':
    if ($I_DONT_HAVE_SENDMAIL) {
       MIME::Lite->send('smtp', $host, Timeout=>60,
           AuthUser=>$user, AuthPass=>$pass);
    }

    ### Now this will do the right thing:
    $msg->send;         ### will now use Net::SMTP as shown above

=head1 PUBLIC INTERFACE

=head2 Global configuration

To alter the way the entire module behaves, you have the following
methods/options:

=over 4

=item MIME::Lite->field_order()

When used as a L<classmethod|/field_order>, this changes the default
order in which headers are output for I<all> messages.
However, please consider using the instance method variant instead,
so you won't stomp on other message senders in the same application.

=item MIME::Lite->quiet()

This L<classmethod|/quiet> can be used to suppress/unsuppress
all warnings coming from this module.

=item MIME::Lite->send()

When used as a L<classmethod|/send>, this can be used to specify
a different default mechanism for sending message.
The initial default is:

    MIME::Lite->send("sendmail", "/usr/lib/sendmail -t -oi -oem");

However, you should consider the similar but smarter and taint-safe variant:

    MIME::Lite->send("sendmail");

Or, for non-Unix users:

    MIME::Lite->send("smtp");

=item $MIME::Lite::AUTO_CC

If true, automatically send to the Cc/Bcc addresses for send_by_smtp().
Default is B<true>.

=item $MIME::Lite::AUTO_CONTENT_TYPE

If true, try to automatically choose the content type from the file name
in C<new()>/C<build()>.  In other words, setting this true changes the
default C<Type> from C<"TEXT"> to C<"AUTO">.

Default is B<false>, since we must maintain backwards-compatibility
with prior behavior.  B<Please> consider keeping it false,
and just using Type 'AUTO' when you build() or attach().

=item $MIME::Lite::AUTO_ENCODE

If true, automatically choose the encoding from the content type.
Default is B<true>.

=item $MIME::Lite::AUTO_VERIFY

If true, check paths to attachments right before printing, raising an exception
if any path is unreadable.
Default is B<true>.

=item $MIME::Lite::PARANOID

If true, we won't attempt to use MIME::Base64, MIME::QuotedPrint,
or MIME::Types, even if they're available.
Default is B<false>.  Please consider keeping it false,
and trusting these other packages to do the right thing.

=back

=head2 Construction

=over 4

=item new [PARAMHASH]

I<Class method, constructor.>
Create a new message object.

If any arguments are given, they are passed into C<build()>; otherwise,
just the empty object is created.

=item attach PART

=item attach PARAMHASH...

I<Instance method.>
Add a new part to this message, and return the new part.

If you supply a single PART argument, it will be regarded
as a MIME::Lite object to be attached.  Otherwise, this
method assumes that you are giving in the pairs of a PARAMHASH
which will be sent into C<new()> to create the new part.

One of the possibly-quite-useful hacks thrown into this is the
"attach-to-singlepart" hack: if you attempt to attach a part (let's
call it "part 1") to a message that doesn't have a content-type
of "multipart" or "message", the following happens:

=over 4

=item *

A new part (call it "part 0") is made.

=item *

The MIME attributes and data (but I<not> the other headers)
are cut from the "self" message, and pasted into "part 0".

=item *

The "self" is turned into a "multipart/mixed" message.

=item *

The new "part 0" is added to the "self", and I<then> "part 1" is added.

=back

One of the nice side-effects is that you can create a text message
and then add zero or more attachments to it, much in the same way
that a user agent like Netscape allows you to do.

=item build [PARAMHASH]

I<Class/instance method, initializer.>
Create (or initialize) a MIME message object.
Normally, you'll use the following keys in PARAMHASH:

   * Data, FH, or Path      (either one of these, or none if multipart)
   * Type                   (e.g., "image/jpeg")
   * From, To, and Subject  (if this is the "top level" of a message)

The PARAMHASH can contain the following keys:

=over 4

=item (fieldname)

Any field you want placed in the message header, taken from the
standard list of header fields (you don't need to worry about case):

    Approved      Encrypted     Received      Sender
    Bcc           From          References    Subject
    Cc            Keywords      Reply-To      To
    Comments      Message-ID    Resent-*      X-*
    Content-*     MIME-Version  Return-Path
    Date                        Organization

To give experienced users some veto power, these fields will be set
I<after> the ones I set... so be careful: I<don't set any MIME fields>
(like C<Content-type>) unless you know what you're doing!

To specify a fieldname that's I<not> in the above list, even one that's
identical to an option below, just give it with a trailing C<":">,
like C<"My-field:">.  When in doubt, that I<always> signals a mail
field (and it sort of looks like one too).

=item Data

I<Alternative to "Path" or "FH".>
The actual message data.  This may be a scalar or a ref to an array of
strings; if the latter, the message consists of a simple concatenation
of all the strings in the array.

=item Datestamp

I<Optional.>
If given true (or omitted), we force the creation of a C<Date:> field
stamped with the current date/time if this is a top-level message.
You may want this if using L<send_by_smtp()|/send_by_smtp>.
If you don't want this to be done, either provide your own Date
or explicitly set this to false.

=item Disposition

I<Optional.>
The content disposition, C<"inline"> or C<"attachment">.
The default is C<"inline">.

=item Encoding

I<Optional.>
The content transfer encoding that should be used to encode your data:

   Use encoding:     | If your message contains:
   ------------------------------------------------------------
   7bit              | Only 7-bit text, all lines <1000 characters
   8bit              | 8-bit text, all lines <1000 characters
   quoted-printable  | 8-bit text or long lines (more reliable than "8bit")
   base64            | Largely non-textual data: a GIF, a tar file, etc.

The default is taken from the Type; generally it is "binary" (no
encoding) for text/*, message/*, and multipart/*, and "base64" for
everything else.  A value of C<"binary"> is generally I<not> suitable
for sending anything but ASCII text files with lines under 1000
characters, so consider using one of the other values instead.

In the case of "7bit"/"8bit", long lines are automatically chopped to
legal length; in the case of "7bit", all 8-bit characters are
automatically I<removed>.  This may not be what you want, so pick your
encoding well!  For more info, see L<"A MIME PRIMER">.

=item FH

I<Alternative to "Data" or "Path".>
Filehandle containing the data, opened for reading.
See "ReadNow" also.

=item Filename

I<Optional.>
The name of the attachment.  You can use this to supply a
recommended filename for the end-user who is saving the attachment
to disk.  You only need this if the filename at the end of the
"Path" is inadequate, or if you're using "Data" instead of "Path".
You should I<not> put path information in here (e.g., no "/"
or "\" or ":" characters should be used).

=item Id

I<Optional.>
Same as setting "content-id".

=item Length

I<Optional.>
Set the content length explicitly.  Normally, this header is automatically
computed, but only under certain circumstances (see L<"Benign limitations">).

=item Path

I<Alternative to "Data" or "FH".>
Path to a file containing the data... actually, it can be any open()able
expression.  If it looks like a path, the last element will automatically
be treated as the filename.
See "ReadNow" also.

=item ReadNow

I<Optional, for use with "Path".>
If true, will open the path and slurp the contents into core now.
This is useful if the Path points to a command and you don't want
to run the command over and over if outputting the message several
times.  B<Fatal exception> raised if the open fails.

=item Top

I<Optional.>
If defined, indicates whether or not this is a "top-level" MIME message.
The parts of a multipart message are I<not> top-level.
Default is true.

=item Type

I<Optional.>
The MIME content type, or one of these special values (case-sensitive):

     "TEXT"   means "text/plain"
     "BINARY" means "application/octet-stream"
     "AUTO"   means attempt to guess from the filename, falling back
              to 'application/octet-stream'.  This is good if you have
              MIME::Types on your system and you have no idea what
              file might be used for the attachment.

The default is C<"TEXT">, but it will be C<"AUTO"> if you set
$AUTO_CONTENT_TYPE to true (sorry, but you have to enable
it explicitly, since we don't want to break code which depends
on the old behavior).

=back

A picture being worth 1000 words (which
is of course 2000 bytes, so it's probably more of an "icon" than a "picture",
but I digress...), here are some examples:

    $msg = MIME::Lite->build(
        From     => 'yelling@inter.com',
        To       => 'stocking@fish.net',
        Subject  => "Hi there!",
        Type     => 'TEXT',
        Encoding => '7bit',
        Data     => "Just a quick note to say hi!"
    );

    $msg = MIME::Lite->build(
        From     => 'dorothy@emerald-city.oz',
        To       => 'gesundheit@edu.edu.edu',
        Subject  => "A gif for U"
        Type     => 'image/gif',
        Path     => "/home/httpd/logo.gif"
    );

    $msg = MIME::Lite->build(
        From     => 'laughing@all.of.us',
        To       => 'scarlett@fiddle.dee.de',
        Subject  => "A gzipp'ed tar file",
        Type     => 'x-gzip',
        Path     => "gzip < /usr/inc/somefile.tar |",
        ReadNow  => 1,
        Filename => "somefile.tgz"
    );

To show you what's really going on, that last example could also
have been written:

    $msg = new MIME::Lite;
    $msg->build(
        Type     => 'x-gzip',
        Path     => "gzip < /usr/inc/somefile.tar |",
        ReadNow  => 1,
        Filename => "somefile.tgz"
    );
    $msg->add(From    => "laughing@all.of.us");
    $msg->add(To      => "scarlett@fiddle.dee.de");
    $msg->add(Subject => "A gzipp'ed tar file");

=back

=head2 Setting/getting headers and attributes

=over 4

=item add TAG,VALUE

I<Instance method.>
Add field TAG with the given VALUE to the end of the header.
The TAG will be converted to all-lowercase, and the VALUE
will be made "safe" (returns will be given a trailing space).

B<Beware:> any MIME fields you "add" will override any MIME
attributes I have when it comes time to output those fields.
Normally, you will use this method to add I<non-MIME> fields:

    $msg->add("Subject" => "Hi there!");

Giving VALUE as an arrayref will cause all those values to be added.
This is only useful for special multiple-valued fields like "Received":

    $msg->add("Received" => ["here", "there", "everywhere"]

Giving VALUE as the empty string adds an invisible placeholder
to the header, which can be used to suppress the output of
the "Content-*" fields or the special  "MIME-Version" field.
When suppressing fields, you should use replace() instead of add():

    $msg->replace("Content-disposition" => "");

I<Note:> add() is probably going to be more efficient than C<replace()>,
so you're better off using it for most applications if you are
certain that you don't need to delete() the field first.

I<Note:> the name comes from Mail::Header.

=item attr ATTR,[VALUE]

I<Instance method.>
Set MIME attribute ATTR to the string VALUE.
ATTR is converted to all-lowercase.
This method is normally used to set/get MIME attributes:

    $msg->attr("content-type"         => "text/html");
    $msg->attr("content-type.charset" => "US-ASCII");
    $msg->attr("content-type.name"    => "homepage.html");

This would cause the final output to look something like this:

    Content-type: text/html; charset=US-ASCII; name="homepage.html"

Note that the special empty sub-field tag indicates the anonymous
first sub-field.

Giving VALUE as undefined will cause the contents of the named
subfield to be deleted.

Supplying no VALUE argument just returns the attribute's value:

    $type = $msg->attr("content-type");        ### returns "text/html"
    $name = $msg->attr("content-type.name");   ### returns "homepage.html"

=item delete TAG

I<Instance method.>
Delete field TAG with the given VALUE to the end of the header.
The TAG will be converted to all-lowercase.

    $msg->delete("Subject");

I<Note:> the name comes from Mail::Header.

=item field_order FIELD,...FIELD

I<Class/instance method.>
Change the order in which header fields are output for this object:

    $msg->field_order('from', 'to', 'content-type', 'subject');

When used as a class method, changes the default settings for
all objects:

    MIME::Lite->field_order('from', 'to', 'content-type', 'subject');

Case does not matter: all field names will be coerced to lowercase.
In either case, supply the empty array to restore the default ordering.

=item fields

I<Instance method.>
Return the full header for the object, as a ref to an array
of C<[TAG, VALUE]> pairs, where each TAG is all-lowercase.
Note that any fields the user has explicitly set will override the
corresponding MIME fields that we would otherwise generate.
So, don't say...

    $msg->set("Content-type" => "text/html; charset=US-ASCII");

unless you want the above value to override the "Content-type"
MIME field that we would normally generate.

I<Note:> I called this "fields" because the header() method of
Mail::Header returns something different, but similar enough to
be confusing.

You can change the order of the fields: see L</field_order>.
You really shouldn't need to do this, but some people have to
deal with broken mailers.

=item filename [FILENAME]

I<Instance method.>
Set the filename which this data will be reported as.
This actually sets both "standard" attributes.

With no argument, returns the filename as dictated by the
content-disposition.

=item get TAG,[INDEX]

I<Instance method.>
Get the contents of field TAG, which might have been set
with set() or replace().  Returns the text of the field.

    $ml->get('Subject', 0);

If the optional 0-based INDEX is given, then we return the INDEX'th
occurrence of field TAG.  Otherwise, we look at the context:
In a scalar context, only the first (0th) occurrence of the
field is returned; in an array context, I<all> occurrences are returned.

I<Warning:> this should only be used with non-MIME fields.
Behavior with MIME fields is TBD, and will raise an exception for now.

=item get_length

I<Instance method.>
Recompute the content length for the message I<if the process is trivial>,
setting the "content-length" attribute as a side-effect:

    $msg->get_length;

Returns the length, or undefined if not set.

I<Note:> the content length can be difficult to compute, since it
involves assembling the entire encoded body and taking the length
of it (which, in the case of multipart messages, means freezing
all the sub-parts, etc.).

This method only sets the content length to a defined value if the
message is a singlepart with C<"binary"> encoding, I<and> the body is
available either in-core or as a simple file.  Otherwise, the content
length is set to the undefined value.

Since content-length is not a standard MIME field anyway (that's right, kids:
it's not in the MIME RFCs, it's an HTTP thing), this seems pretty fair.

=item parts

I<Instance method.>
Return the parts of this entity, and this entity only.
Returns empty array if this entity has no parts.

This is B<not> recursive!  Parts can have sub-parts; use
parts_DFS() to get everything.

=item parts_DFS

I<Instance method.>
Return the list of all MIME::Lite objects included in the entity,
starting with the entity itself, in depth-first-search order.
If this object has no parts, it alone will be returned.

=item preamble [TEXT]

I<Instance method.>
Get/set the preamble string, assuming that this object has subparts.
Set it to undef for the default string.

=item replace TAG,VALUE

I<Instance method.>
Delete all occurrences of fields named TAG, and add a new
field with the given VALUE.  TAG is converted to all-lowercase.

B<Beware> the special MIME fields (MIME-version, Content-*):
if you "replace" a MIME field, the replacement text will override
the I<actual> MIME attributes when it comes time to output that field.
So normally you use attr() to change MIME fields and add()/replace() to
change I<non-MIME> fields:

    $msg->replace("Subject" => "Hi there!");

Giving VALUE as the I<empty string> will effectively I<prevent> that
field from being output.  This is the correct way to suppress
the special MIME fields:

    $msg->replace("Content-disposition" => "");

Giving VALUE as I<undefined> will just cause all explicit values
for TAG to be deleted, without having any new values added.

I<Note:> the name of this method  comes from Mail::Header.

=item scrub

I<Instance method.>
B<This is Alpha code.  If you use it, please let me know how it goes.>
Recursively goes through the "parts" tree of this message and tries
to find MIME attributes that can be removed.
With an array argument, removes exactly those attributes; e.g.:

    $msg->scrub(['content-disposition', 'content-length']);

Is the same as recursively doing:

    $msg->replace('Content-disposition' => '');
    $msg->replace('Content-length'      => '');

=back

=head2 Setting/getting message data

=over 4

=item binmode [OVERRIDE]

I<Instance method.>
With no argument, returns whether or not it thinks that the data
(as given by the "Path" argument of C<build()>) should be read using
binmode() (for example, when C<read_now()> is invoked).

The default behavior is that any content type other than
C<text/*> or C<message/*> is binmode'd; this should in general work fine.

With a defined argument, this method sets an explicit "override"
value.  An undefined argument unsets the override.
The new current value is returned.

=item data [DATA]

I<Instance method.>
Get/set the literal DATA of the message.  The DATA may be
either a scalar, or a reference to an array of scalars (which
will simply be joined).

I<Warning:> setting the data causes the "content-length" attribute
to be recomputed (possibly to nothing).

=item fh [FILEHANDLE]

I<Instance method.>
Get/set the FILEHANDLE which contains the message data.

Takes a filehandle as an input and stores it in the object.
This routine is similar to path(); one important difference is that
no attempt is made to set the content length.

=item path [PATH]

I<Instance method.>
Get/set the PATH to the message data.

I<Warning:> setting the path recomputes any existing "content-length" field,
and re-sets the "filename" (to the last element of the path if it
looks like a simple path, and to nothing if not).

=item resetfh [FILEHANDLE]

I<Instance method.>
Set the current position of the filehandle back to the beginning.
Only applies if you used "FH" in build() or attach() for this message.

Returns false if unable to reset the filehandle (since not all filehandles
are seekable).

=item read_now

I<Instance method.>
Forces data from the path/filehandle (as specified by C<build()>)
to be read into core immediately, just as though you had given it
literally with the C<Data> keyword.

Note that the in-core data will always be used if available.

Be aware that everything is slurped into a giant scalar: you may not want
to use this if sending tar files!  The benefit of I<not> reading in the data
is that very large files can be handled by this module if left on disk
until the message is output via C<print()> or C<print_body()>.

=item sign PARAMHASH

I<Instance method.>
Sign the message.  This forces the message to be read into core,
after which the signature is appended to it.

=over 4

=item Data

As in C<build()>: the literal signature data.
Can be either a scalar or a ref to an array of scalars.

=item Path

As in C<build()>: the path to the file.

=back

If no arguments are given, the default is:

    Path => "$ENV{HOME}/.signature"

The content-length is recomputed.

=item verify_data

I<Instance method.>
Verify that all "paths" to attached data exist, recursively.
It might be a good idea for you to do this before a print(), to
prevent accidental partial output if a file might be missing.
Raises exception if any path is not readable.

=back

=head2 Output

=over 4

=item print [OUTHANDLE]

I<Instance method.>
Print the message to the given output handle, or to the currently-selected
filehandle if none was given.

All OUTHANDLE has to be is a filehandle (possibly a glob ref), or
any object that responds to a print() message.

=item print_body [OUTHANDLE] [IS_SMTP]

I<Instance method.>
Print the body of a message to the given output handle, or to
the currently-selected filehandle if none was given.

All OUTHANDLE has to be is a filehandle (possibly a glob ref), or
any object that responds to a print() message.

B<Fatal exception> raised if unable to open any of the input files,
or if a part contains no data, or if an unsupported encoding is
encountered.

IS_SMPT is a special option to handle SMTP mails a little more
intelligently than other send mechanisms may require. Specifically this
ensures that the last byte sent is NOT '\n' (octal \012) if the last two
bytes are not '\r\n' (\015\012) as this will cause some SMTP servers to
hang.

=item print_header [OUTHANDLE]

I<Instance method.>
Print the header of the message to the given output handle,
or to the currently-selected filehandle if none was given.

All OUTHANDLE has to be is a filehandle (possibly a glob ref), or
any object that responds to a print() message.

=item as_string

I<Instance method.>
Return the entire message as a string, with a header and an encoded body.

=item body_as_string

I<Instance method.>
Return the encoded body as a string.
This is the portion after the header and the blank line.

I<Note:> actually prepares the body by "printing" to a scalar.
Proof that you can hand the C<print*()> methods any blessed object
that responds to a C<print()> message.

=item header_as_string

I<Instance method.>
Return the header as a string.

=back

=head2 Sending

=over 4

=item send

=item send HOW, HOWARGS...

I<Class/instance method.>
This is the principal method for sending mail, and for configuring
how mail will be sent.

I<As a class method> with a HOW argument and optional HOWARGS, it sets
the default sending mechanism that the no-argument instance method
will use.  The HOW is a facility name (B<see below>),
and the HOWARGS is interpreted by the facility.
The class method returns the previous HOW and HOWARGS as an array.

    MIME::Lite->send('sendmail', "d:\\programs\\sendmail.exe");
    ...
    $msg = MIME::Lite->new(...);
    $msg->send;

I<As an instance method with arguments>
(a HOW argument and optional HOWARGS), sends the message in the
requested manner; e.g.:

    $msg->send('sendmail', "d:\\programs\\sendmail.exe");

I<As an instance method with no arguments,> sends the
message by the default mechanism set up by the class method.
Returns whatever the mail-handling routine returns: this
should be true on success, false/exception on error:

    $msg = MIME::Lite->new(From=>...);
    $msg->send || die "you DON'T have mail!";

On Unix systems (or rather non-Win32 systems), the default
setting is equivalent to:

    MIME::Lite->send("sendmail", "/usr/lib/sendmail -t -oi -oem");

On Win32 systems the default setting is equivalent to:

    MIME::Lite->send("smtp");

The assumption is that on Win32 your site/lib/Net/libnet.cfg
file will be preconfigured to use the appropriate SMTP
server. See below for configuring for authentication.

There are three facilities:

=over 4

=item "sendmail", ARGS...

Send a message by piping it into the "sendmail" command.
Uses the L<send_by_sendmail()|/send_by_sendmail> method, giving it the ARGS.
This usage implements (and deprecates) the C<sendmail()> method.

=item "smtp", [HOSTNAME, [NAMEDPARMS] ]

Send a message by SMTP, using optional HOSTNAME as SMTP-sending host.
L<Net::SMTP> will be required.  Uses the L<send_by_smtp()|/send_by_smtp>
method. Any additional arguments passed in will also be passed through to
send_by_smtp.  This is useful for things like mail servers requiring
authentication where you can say something like the following

  MIME::Lite->send('smtp', $host, AuthUser=>$user, AuthPass=>$pass);

which will configure things so future uses of

  $msg->send();

do the right thing.

=item "sub", \&SUBREF, ARGS...

Sends a message MSG by invoking the subroutine SUBREF of your choosing,
with MSG as the first argument, and ARGS following.

=back

I<For example:> let's say you're on an OS which lacks the usual Unix
"sendmail" facility, but you've installed something a lot like it, and
you need to configure your Perl script to use this "sendmail.exe" program.
Do this following in your script's setup:

    MIME::Lite->send('sendmail', "d:\\programs\\sendmail.exe");

Then, whenever you need to send a message $msg, just say:

    $msg->send;

That's it.  Now, if you ever move your script to a Unix box, all you
need to do is change that line in the setup and you're done.
All of your $msg-E<gt>send invocations will work as expected.

After sending, the method last_send_successful() can be used to determine
if the send was successful or not.

=item send_by_sendmail SENDMAILCMD

=item send_by_sendmail PARAM=>VALUE, ARRAY, HASH...

I<Instance method.>
Send message via an external "sendmail" program
(this will probably only work out-of-the-box on Unix systems).

Returns true on success, false or exception on error.

You can specify the program and all its arguments by giving a single
string, SENDMAILCMD.  Nothing fancy is done; the message is simply
piped in.

However, if your needs are a little more advanced, you can specify
zero or more of the following PARAM/VALUE pairs (or a reference to hash
or array of such arguments as well as any combination thereof); a
Unix-style, taint-safe "sendmail" command will be constructed for you:

=over 4

=item Sendmail

Full path to the program to use.
Default is "/usr/lib/sendmail".

=item BaseArgs

Ref to the basic array of arguments we start with.
Default is C<["-t", "-oi", "-oem"]>.

=item SetSender

Unless this is I<explicitly> given as false, we attempt to automatically
set the C<-f> argument to the first address that can be extracted from
the "From:" field of the message (if there is one).

I<What is the -f, and why do we use it?>
Suppose we did I<not> use C<-f>, and you gave an explicit "From:"
field in your message: in this case, the sendmail "envelope" would
indicate the I<real> user your process was running under, as a way
of preventing mail forgery.  Using the C<-f> switch causes the sender
to be set in the envelope as well.

I<So when would I NOT want to use it?>
If sendmail doesn't regard you as a "trusted" user, it will permit
the C<-f> but also add an "X-Authentication-Warning" header to the message
to indicate a forged envelope.  To avoid this, you can either
(1) have SetSender be false, or
(2) make yourself a trusted user by adding a C<T> configuration
    command to your I<sendmail.cf> file
    (e.g.: C<Teryq> if the script is running as user "eryq").

=item FromSender

If defined, this is identical to setting SetSender to true,
except that instead of looking at the "From:" field we use
the address given by this option.
Thus:

    FromSender => 'me@myhost.com'

=back

After sending, the method last_send_successful() can be used to determine
if the send was successful or not.

=item send_by_smtp HOST, ARGS...

=item send_by_smtp REF, HOST, ARGS

I<Instance method.>
Send message via SMTP, using Net::SMTP -- which will be required for this
feature.

HOST is the name of SMTP server to connect to, or undef to have
L<Net::SMTP|Net::SMTP> use the defaults in Libnet.cfg.

ARGS are a list of key value pairs which may be selected from the list
below. Many of these are just passed through to specific
L<Net::SMTP|Net::SMTP> commands and you should review that module for
details.

Please see L<Good-vs-bad email addresses with send_by_smtp()|/Good-vs-bad email addresses with send_by_smtp()>

=over 4

=item Hello

=item LocalAddr

=item LocalPort

=item Timeout

=item Port

=item ExactAddresses

=item Debug

See L<Net::SMTP::new()|Net::SMTP/"mail"> for details.

=item Size

=item Return

=item Bits

=item Transaction

=item Envelope

See L<Net::SMTP::mail()|Net::SMTP/mail> for details.

=item SkipBad

If true doesn't throw an error when multiple email addresses are provided
and some are not valid. See L<Net::SMTP::recipient()|Net::SMTP/recipient>
for details.

=item AuthUser

Authenticate with L<Net::SMTP::auth()|Net::SMTP/auth> using this username.

=item AuthPass

Authenticate with L<Net::SMTP::auth()|Net::SMTP/auth> using this password.

=item NoAuth

Normally if AuthUser and AuthPass are defined MIME::Lite will attempt to
use them with the L<Net::SMTP::auth()|Net::SMTP/auth> command to
authenticate the connection, however if this value is true then no
authentication occurs.

=item To

Sets the addresses to send to. Can be a string or a reference to an
array of strings. Normally this is extracted from the To: (and Cc: and
Bcc: fields if $AUTO_CC is true).

This value overrides that.

=item From

Sets the email address to send from. Normally this value is extracted
from the Return-Path: or From: field of the mail itself (in that order).

This value overrides that.

=back

I<Returns:>
True on success, croaks with an error message on failure.

After sending, the method last_send_successful() can be used to determine
if the send was successful or not.

=item send_by_testfile FILENAME

I<Instance method.>
Print message to a file (namely FILENAME), which will default to
mailer.testfile
If file exists, message will be appended.

=item last_send_successful

This method will return TRUE if the last send() or send_by_XXX() method call was
successful. It will return defined but false if it was not successful, and undefined
if the object had not been used to send yet.

=item sendmail COMMAND...

I<Class method, DEPRECATED.>
Declare the sender to be "sendmail", and set up the "sendmail" command.
I<You should use send() instead.>

=back

=head2 Miscellaneous

=over 4

=item quiet ONOFF

I<Class method.>
Suppress/unsuppress all warnings coming from this module.

    MIME::Lite->quiet(1);       ### I know what I'm doing

I recommend that you include that comment as well.  And while
you type it, say it out loud: if it doesn't feel right, then maybe
you should reconsider the whole line.  C<;-)>

=back

=head1 NOTES

=head2 How do I prevent "Content" headers from showing up in my mail reader?

Apparently, some people are using mail readers which display the MIME
headers like "Content-disposition", and they want MIME::Lite not
to generate them "because they look ugly".

Sigh.

Y'know, kids, those headers aren't just there for cosmetic purposes.
They help ensure that the message is I<understood> correctly by mail
readers.  But okay, you asked for it, you got it...
here's how you can suppress the standard MIME headers.
Before you send the message, do this:

    $msg->scrub;

You can scrub() any part of a multipart message independently;
just be aware that it works recursively.  Before you scrub,
note the rules that I follow:

=over 4

=item Content-type

You can safely scrub the "content-type" attribute if, and only if,
the part is of type "text/plain" with charset "us-ascii".

=item Content-transfer-encoding

You can safely scrub the "content-transfer-encoding" attribute
if, and only if, the part uses "7bit", "8bit", or "binary" encoding.
You are far better off doing this if your lines are under 1000
characters.  Generally, that means you I<can> scrub it for plain
text, and you can I<not> scrub this for images, etc.

=item Content-disposition

You can safely scrub the "content-disposition" attribute
if you trust the mail reader to do the right thing when it decides
whether to show an attachment inline or as a link.  Be aware
that scrubbing both the content-disposition and the content-type
means that there is no way to "recommend" a filename for the attachment!

B<Note:> there are reports of brain-dead MUAs out there that
do the wrong thing if you I<provide> the content-disposition.
If your attachments keep showing up inline or vice-versa,
try scrubbing this attribute.

=item Content-length

You can always scrub "content-length" safely.

=back

=head2 How do I give my attachment a [different] recommended filename?

By using the Filename option (which is different from Path!):

    $msg->attach(Type => "image/gif",
                 Path => "/here/is/the/real/file.GIF",
                 Filename => "logo.gif");

You should I<not> put path information in the Filename.

=head2 Working with UTF-8 and other character sets

All text that is added to your mail message should be properly encoded.
MIME::Lite doesn't do this for you. For instance, if you want to
send your mail in UTF-8, where C<$to>, C<$subject> and C<$text> have
these values:

=over

=item *

To: "RamE<oacute>n NuE<ntilde>ez E<lt>foo@bar.comE<gt>"

=item *

Subject: "E<iexcl>AquE<iacute> estE<aacute>!"

=item *

Text: "E<iquest>Quieres ganar muchos E<euro>'s?"

=back

    use MIME::Lite;
    use Encode qw(encode encode_utf8 );

    my $to      = "Ram\363n Nu\361ez <foo\@bar.com>";
    my $subject = "\241Aqu\355 est\341!";
    my $text    = "\277Quieres ganar muchos \x{20ac}'s?";

    ### Create a new message encoded in UTF-8:
    my $msg = MIME::Lite->new(
        From    => 'me@myhost.com',
        To      => encode( 'MIME-Header', $to ),
        Subject => encode( 'MIME-Header', $subject ),
        Data    => encode_utf8($text)
    );
    $msg->attr( 'content-type' => 'text/plain; charset=utf-8' );
    $msg->send;

B<Note:>

=over

=item *

The above example assumes that the values you want to encode are in
Perl's "internal" form, i.e. the strings contain decoded UTF-8
characters, not the bytes that represent those characters.

See L<perlunitut>, L<perluniintro>, L<perlunifaq> and L<Encode> for
more.

=item *

If, for the body of the email,  you want to use a character set
other than UTF-8, then you should encode appropriately, and set the
correct C<content-type>, eg:

    ...
    Data => encode('iso-8859-15',$text)
    ...

    $msg->attr( 'content-type' => 'text/plain; charset=iso-8859-15' );

=item *

For the message headers, L<Encode::MIME::Header> only support UTF-8,
but most modern mail clients should be able to handle this.  It is not
a problem to have your headers in a different encoding from the message
body.

=back

=head2 Benign limitations

This is "lite", after all...

=over 4

=item *

There's no parsing.  Get MIME-tools if you need to parse MIME messages.

=item *

MIME::Lite messages are currently I<not> interchangeable with
either Mail::Internet or MIME::Entity objects.  This is a completely
separate module.

=item *

A content-length field is only inserted if the encoding is binary,
the message is a singlepart, and all the document data is available
at C<build()> time by virtue of residing in a simple path, or in-core.
Since content-length is not a standard MIME field anyway (that's right, kids:
it's not in the MIME RFCs, it's an HTTP thing), this seems pretty fair.

=item *

MIME::Lite alone cannot help you lose weight.  You must supplement
your use of MIME::Lite with a healthy diet and exercise.

=back

=head2 Cheap and easy mailing

I thought putting in a default "sendmail" invocation wasn't too bad an
idea, since a lot of Perlers are on UNIX systems. (As of version 3.02 this is
default only on Non-Win32 boxen. On Win32 boxen the default is to use SMTP and the
defaults specified in the site/lib/Net/libnet.cfg)

The out-of-the-box configuration is:

     MIME::Lite->send('sendmail', "/usr/lib/sendmail -t -oi -oem");

By the way, these arguments to sendmail are:

     -t      Scan message for To:, Cc:, Bcc:, etc.

     -oi     Do NOT treat a single "." on a line as a message terminator.
             As in, "-oi vey, it truncated my message... why?!"

     -oem    On error, mail back the message (I assume to the
             appropriate address, given in the header).
             When mail returns, circle is complete.  Jai Guru Deva -oem.

Note that these are the same arguments you get if you configure to use
the smarter, taint-safe mailing:

     MIME::Lite->send('sendmail');

If you get "X-Authentication-Warning" headers from this, you can forgo
diddling with the envelope by instead specifying:

     MIME::Lite->send('sendmail', SetSender=>0);

And, if you're not on a Unix system, or if you'd just rather send mail
some other way, there's always SMTP, which these days probably requires
authentication so you probably need to say

     MIME::Lite->send('smtp', "smtp.myisp.net",
        AuthUser=>"YourName",AuthPass=>"YourPass" );

Or you can set up your own subroutine to call.
In any case, check out the L<send()|/send> method.

=head1 WARNINGS

=head2 Good-vs-bad email addresses with send_by_smtp()

If using L<send_by_smtp()|/send_by_smtp>, be aware that unless you
explicitly provide the email addresses to send to and from you will be
forcing MIME::Lite to extract email addresses out of a possible list
provided in the C<To:>, C<Cc:>, and C<Bcc:> fields.  This is tricky
stuff, and as such only the following sorts of addresses will work
reliably:

    username
    full.name@some.host.com
    "Name, Full" <full.name@some.host.com>

B<Disclaimer:>
MIME::Lite was never intended to be a Mail User Agent, so please
don't expect a full implementation of RFC-822.  Restrict yourself to
the common forms of Internet addresses described herein, and you should
be fine.  If this is not feasible, then consider using MIME::Lite
to I<prepare> your message only, and using Net::SMTP explicitly to
I<send> your message.

B<Note:>
As of MIME::Lite v3.02 the mail name extraction routines have been
beefed up considerably. Furthermore if Mail::Address is provided then
name extraction is done using that. Accordingly the above advice is now
less true than it once was. Funky email names I<should> work properly
now. However the disclaimer remains. Patches welcome. :-)

=head2 Formatting of headers delayed until print()

This class treats a MIME header in the most abstract sense,
as being a collection of high-level attributes.  The actual
RFC-822-style header fields are not constructed until it's time
to actually print the darn thing.

=head2 Encoding of data delayed until print()

When you specify message bodies
(in L<build()|/build> or L<attach()|/attach>) --
whether by B<FH>, B<Data>, or B<Path> -- be warned that we don't
attempt to open files, read filehandles, or encode the data until
L<print()|/print> is invoked.

In the past, this created some confusion for users of sendmail
who gave the wrong path to an attachment body, since enough of
the print() would succeed to get the initial part of the message out.
Nowadays, $AUTO_VERIFY is used to spot-check the Paths given before
the mail facility is employed.  A whisker slower, but tons safer.

Note that if you give a message body via FH, and try to print()
a message twice, the second print() will not do the right thing
unless you  explicitly rewind the filehandle.

You can get past these difficulties by using the B<ReadNow> option,
provided that you have enough memory to handle your messages.

=head2 MIME attributes are separate from header fields!

B<Important:> the MIME attributes are stored and manipulated separately
from the message header fields; when it comes time to print the
header out, I<any explicitly-given header fields override the ones that
would be created from the MIME attributes.>  That means that this:

    ### DANGER ### DANGER ### DANGER ### DANGER ### DANGER ###
    $msg->add("Content-type", "text/html; charset=US-ASCII");

will set the exact C<"Content-type"> field in the header I write,
I<regardless of what the actual MIME attributes are.>

I<This feature is for experienced users only,> as an escape hatch in case
the code that normally formats MIME header fields isn't doing what
you need.  And, like any escape hatch, it's got an alarm on it:
MIME::Lite will warn you if you attempt to C<set()> or C<replace()>
any MIME header field.  Use C<attr()> instead.

=head2 Beware of lines consisting of a single dot

Julian Haight noted that MIME::Lite allows you to compose messages
with lines in the body consisting of a single ".".
This is true: it should be completely harmless so long as "sendmail"
is used with the -oi option (see L<"Cheap and easy mailing">).

However, I don't know if using Net::SMTP to transfer such a message
is equally safe.  Feedback is welcomed.

My perspective: I don't want to magically diddle with a user's
message unless absolutely positively necessary.
Some users may want to send files with "." alone on a line;
my well-meaning tinkering could seriously harm them.

=head2 Infinite loops may mean tainted data!

Stefan Sautter noticed a bug in 2.106 where a m//gc match was
failing due to tainted data, leading to an infinite loop inside
MIME::Lite.

I am attempting to correct for this, but be advised that my fix will
silently untaint the data (given the context in which the problem
occurs, this should be benign: I've labelled the source code with
UNTAINT comments for the curious).

So: don't depend on taint-checking to save you from outputting
tainted data in a message.

=head2 Don't tweak the global configuration

Global configuration variables are bad, and should go away.
Until they do, please follow the hints with each setting
on how I<not> to change it.

=head1 A MIME PRIMER

=head2 Content types

The "Type" parameter of C<build()> is a I<content type>.
This is the actual type of data you are sending.
Generally this is a string of the form C<"majortype/minortype">.

Here are the major MIME types.
A more-comprehensive listing may be found in RFC-2046.

=over 4

=item application

Data which does not fit in any of the other categories, particularly
data to be processed by some type of application program.
C<application/octet-stream>, C<application/gzip>, C<application/postscript>...

=item audio

Audio data.
C<audio/basic>...

=item image

Graphics data.
C<image/gif>, C<image/jpeg>...

=item message

A message, usually another mail or MIME message.
C<message/rfc822>...

=item multipart

A message containing other messages.
C<multipart/mixed>, C<multipart/alternative>...

=item text

Textual data, meant for humans to read.
C<text/plain>, C<text/html>...

=item video

Video or video+audio data.
C<video/mpeg>...

=back

=head2 Content transfer encodings

The "Encoding" parameter of C<build()>.
This is how the message body is packaged up for safe transit.

Here are the 5 major MIME encodings.
A more-comprehensive listing may be found in RFC-2045.

=over 4

=item 7bit

Basically, no I<real> encoding is done.  However, this label guarantees that no
8-bit characters are present, and that lines do not exceed 1000 characters
in length.

=item 8bit

Basically, no I<real> encoding is done.  The message might contain 8-bit
characters, but this encoding guarantees that lines do not exceed 1000
characters in length.

=item binary

No encoding is done at all.  Message might contain 8-bit characters,
and lines might be longer than 1000 characters long.

The most liberal, and the least likely to get through mail gateways.
Use sparingly, or (better yet) not at all.

=item base64

Like "uuencode", but very well-defined.  This is how you should send
essentially binary information (tar files, GIFs, JPEGs, etc.).

=item quoted-printable

Useful for encoding messages which are textual in nature, yet which contain
non-ASCII characters (e.g., Latin-1, Latin-2, or any other 8-bit alphabet).

=back

=head1 HELPER MODULES

MIME::Lite works nicely with other certain other modules if they are present.
Good to have installed are the latest L<MIME::Types|MIME::Types>,
L<Mail::Address|Mail::Address>, L<MIME::Base64|MIME::Base64>,
L<MIME::QuotedPrint|MIME::QuotedPrint>, and L<Net::SMTP>.
L<Email::Date::Format> is strictly required.

If they aren't present then some functionality won't work, and other features
won't be as efficient or up to date as they could be. Nevertheless they are optional
extras.

=head1 BUNDLED GOODIES

MIME::Lite comes with a number of extra files in the distribution bundle.
This includes examples, and utility modules that you can use to get yourself
started with the module.

The ./examples directory contains a number of snippets in prepared
form, generally they are documented, but they should be easy to understand.

The ./contrib directory contains a companion/tool modules that come bundled
with MIME::Lite, they don't get installed by default. Please review the POD
they come with.

=head1 BUGS

The whole reason that version 3.0 was released was to ensure that MIME::Lite is
up to date and patched. If you find an issue please report it.

As far as I know MIME::Lite doesn't currently have any serious bugs, but my
usage is hardly comprehensive.

Having said that there are a number of open issues for me, mostly caused by the
progress in the community as whole since Eryq last released. The tests are
based around an interesting but non standard test framework. I'd like to change
it over to using Test::More.

Should tests fail please review the ./testout directory, and in any bug reports
please include the output of the relevant file. This is the only redeeming
feature of not using Test::More that I can see.

Bug fixes / Patches / Contribution are welcome, however I probably won't apply
them unless they also have an associated test. This means that if I don't have
the time to write the test the patch won't get applied, so please, include tests
for any patches you provide.

=head1 NUTRITIONAL INFORMATION

For some reason, the US FDA says that this is now required by law
on any products that bear the name "Lite"...

Version 3.0 is now new and improved! The distribution is now 30% smaller!

    MIME::Lite                |
    ------------------------------------------------------------
    Serving size:             | 1 module
    Servings per container:   | 1
    Calories:                 | 0
    Fat:                      | 0g
      Saturated Fat:          | 0g

Warning: for consumption by hardware only!  May produce
indigestion in humans if taken internally.

=head1 AUTHORS

=over 4

=item *

Ricardo SIGNES <cpan@semiotic.systems>

=item *

Eryq <eryq@zeegee.com>

=item *

Yves Orton

=back

=head1 CONTRIBUTORS

=for stopwords Claude Damien Krotkine David Steinbrunner Florian Jan Willamowius John Bokma Karen Etheridge Max Maischein Michael Schout Stevens Peder Stray Peter Heirich Ricardo Signes Tom Hukins

=over 4

=item *

Claude <noreply@anthropic.com>

=item *

Damien Krotkine <dkrotkine@booking.com>

=item *

David Steinbrunner <dsteinbrunner@pobox.com>

=item *

Florian <fschlich@zedat.fu-berlin.de>

=item *

Jan Willamowius <jan@willamowius.de>

=item *

John Bokma <contact@johnbokma.com>

=item *

Karen Etheridge <ether@cpan.org>

=item *

Max Maischein <corion@corion.net>

=item *

Michael Schout <mschout@gkg.net>

=item *

Michael Stevens <mstevens@etla.org>

=item *

Peder Stray <peder@inne.proxdynamics.com>

=item *

Peter Heirich <peter@service.heirich.eu>

=item *

Ricardo Signes <rjbs@semiotic.systems>

=item *

Tom Hukins <tom@eborcom.com>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 1997 by Eryq, ZeeGee Software, and Yves Orton.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

__END__


#============================================================


#pod =head1 NOTES
#pod
#pod
#pod =head2 How do I prevent "Content" headers from showing up in my mail reader?
#pod
#pod Apparently, some people are using mail readers which display the MIME
#pod headers like "Content-disposition", and they want MIME::Lite not
#pod to generate them "because they look ugly".
#pod
#pod Sigh.
#pod
#pod Y'know, kids, those headers aren't just there for cosmetic purposes.
#pod They help ensure that the message is I<understood> correctly by mail
#pod readers.  But okay, you asked for it, you got it...
#pod here's how you can suppress the standard MIME headers.
#pod Before you send the message, do this:
#pod
#pod     $msg->scrub;
#pod
#pod You can scrub() any part of a multipart message independently;
#pod just be aware that it works recursively.  Before you scrub,
#pod note the rules that I follow:
#pod
#pod =over 4
#pod
#pod =item Content-type
#pod
#pod You can safely scrub the "content-type" attribute if, and only if,
#pod the part is of type "text/plain" with charset "us-ascii".
#pod
#pod =item Content-transfer-encoding
#pod
#pod You can safely scrub the "content-transfer-encoding" attribute
#pod if, and only if, the part uses "7bit", "8bit", or "binary" encoding.
#pod You are far better off doing this if your lines are under 1000
#pod characters.  Generally, that means you I<can> scrub it for plain
#pod text, and you can I<not> scrub this for images, etc.
#pod
#pod =item Content-disposition
#pod
#pod You can safely scrub the "content-disposition" attribute
#pod if you trust the mail reader to do the right thing when it decides
#pod whether to show an attachment inline or as a link.  Be aware
#pod that scrubbing both the content-disposition and the content-type
#pod means that there is no way to "recommend" a filename for the attachment!
#pod
#pod B<Note:> there are reports of brain-dead MUAs out there that
#pod do the wrong thing if you I<provide> the content-disposition.
#pod If your attachments keep showing up inline or vice-versa,
#pod try scrubbing this attribute.
#pod
#pod =item Content-length
#pod
#pod You can always scrub "content-length" safely.
#pod
#pod =back
#pod
#pod =head2 How do I give my attachment a [different] recommended filename?
#pod
#pod By using the Filename option (which is different from Path!):
#pod
#pod     $msg->attach(Type => "image/gif",
#pod                  Path => "/here/is/the/real/file.GIF",
#pod                  Filename => "logo.gif");
#pod
#pod You should I<not> put path information in the Filename.
#pod
#pod =head2 Working with UTF-8 and other character sets
#pod
#pod All text that is added to your mail message should be properly encoded.
#pod MIME::Lite doesn't do this for you. For instance, if you want to
#pod send your mail in UTF-8, where C<$to>, C<$subject> and C<$text> have
#pod these values:
#pod
#pod =over
#pod
#pod =item *
#pod
#pod To: "RamE<oacute>n NuE<ntilde>ez E<lt>foo@bar.comE<gt>"
#pod
#pod =item *
#pod
#pod Subject: "E<iexcl>AquE<iacute> estE<aacute>!"
#pod
#pod =item *
#pod
#pod Text: "E<iquest>Quieres ganar muchos E<euro>'s?"
#pod
#pod =back
#pod
#pod
#pod     use MIME::Lite;
#pod     use Encode qw(encode encode_utf8 );
#pod
#pod     my $to      = "Ram\363n Nu\361ez <foo\@bar.com>";
#pod     my $subject = "\241Aqu\355 est\341!";
#pod     my $text    = "\277Quieres ganar muchos \x{20ac}'s?";
#pod
#pod     ### Create a new message encoded in UTF-8:
#pod     my $msg = MIME::Lite->new(
#pod         From    => 'me@myhost.com',
#pod         To      => encode( 'MIME-Header', $to ),
#pod         Subject => encode( 'MIME-Header', $subject ),
#pod         Data    => encode_utf8($text)
#pod     );
#pod     $msg->attr( 'content-type' => 'text/plain; charset=utf-8' );
#pod     $msg->send;
#pod
#pod B<Note:>
#pod
#pod =over
#pod
#pod =item *
#pod
#pod The above example assumes that the values you want to encode are in
#pod Perl's "internal" form, i.e. the strings contain decoded UTF-8
#pod characters, not the bytes that represent those characters.
#pod
#pod See L<perlunitut>, L<perluniintro>, L<perlunifaq> and L<Encode> for
#pod more.
#pod
#pod =item *
#pod
#pod If, for the body of the email,  you want to use a character set
#pod other than UTF-8, then you should encode appropriately, and set the
#pod correct C<content-type>, eg:
#pod
#pod     ...
#pod     Data => encode('iso-8859-15',$text)
#pod     ...
#pod
#pod     $msg->attr( 'content-type' => 'text/plain; charset=iso-8859-15' );
#pod
#pod =item *
#pod
#pod For the message headers, L<Encode::MIME::Header> only support UTF-8,
#pod but most modern mail clients should be able to handle this.  It is not
#pod a problem to have your headers in a different encoding from the message
#pod body.
#pod
#pod =back
#pod
#pod =head2 Benign limitations
#pod
#pod This is "lite", after all...
#pod
#pod =over 4
#pod
#pod =item *
#pod
#pod There's no parsing.  Get MIME-tools if you need to parse MIME messages.
#pod
#pod =item *
#pod
#pod MIME::Lite messages are currently I<not> interchangeable with
#pod either Mail::Internet or MIME::Entity objects.  This is a completely
#pod separate module.
#pod
#pod =item *
#pod
#pod A content-length field is only inserted if the encoding is binary,
#pod the message is a singlepart, and all the document data is available
#pod at C<build()> time by virtue of residing in a simple path, or in-core.
#pod Since content-length is not a standard MIME field anyway (that's right, kids:
#pod it's not in the MIME RFCs, it's an HTTP thing), this seems pretty fair.
#pod
#pod =item *
#pod
#pod MIME::Lite alone cannot help you lose weight.  You must supplement
#pod your use of MIME::Lite with a healthy diet and exercise.
#pod
#pod =back
#pod
#pod
#pod =head2 Cheap and easy mailing
#pod
#pod I thought putting in a default "sendmail" invocation wasn't too bad an
#pod idea, since a lot of Perlers are on UNIX systems. (As of version 3.02 this is
#pod default only on Non-Win32 boxen. On Win32 boxen the default is to use SMTP and the
#pod defaults specified in the site/lib/Net/libnet.cfg)
#pod
#pod The out-of-the-box configuration is:
#pod
#pod      MIME::Lite->send('sendmail', "/usr/lib/sendmail -t -oi -oem");
#pod
#pod By the way, these arguments to sendmail are:
#pod
#pod      -t      Scan message for To:, Cc:, Bcc:, etc.
#pod
#pod      -oi     Do NOT treat a single "." on a line as a message terminator.
#pod              As in, "-oi vey, it truncated my message... why?!"
#pod
#pod      -oem    On error, mail back the message (I assume to the
#pod              appropriate address, given in the header).
#pod              When mail returns, circle is complete.  Jai Guru Deva -oem.
#pod
#pod Note that these are the same arguments you get if you configure to use
#pod the smarter, taint-safe mailing:
#pod
#pod      MIME::Lite->send('sendmail');
#pod
#pod If you get "X-Authentication-Warning" headers from this, you can forgo
#pod diddling with the envelope by instead specifying:
#pod
#pod      MIME::Lite->send('sendmail', SetSender=>0);
#pod
#pod And, if you're not on a Unix system, or if you'd just rather send mail
#pod some other way, there's always SMTP, which these days probably requires
#pod authentication so you probably need to say
#pod
#pod      MIME::Lite->send('smtp', "smtp.myisp.net",
#pod         AuthUser=>"YourName",AuthPass=>"YourPass" );
#pod
#pod Or you can set up your own subroutine to call.
#pod In any case, check out the L<send()|/send> method.
#pod
#pod
#pod =head1 WARNINGS
#pod
#pod =head2 Good-vs-bad email addresses with send_by_smtp()
#pod
#pod If using L<send_by_smtp()|/send_by_smtp>, be aware that unless you
#pod explicitly provide the email addresses to send to and from you will be
#pod forcing MIME::Lite to extract email addresses out of a possible list
#pod provided in the C<To:>, C<Cc:>, and C<Bcc:> fields.  This is tricky
#pod stuff, and as such only the following sorts of addresses will work
#pod reliably:
#pod
#pod     username
#pod     full.name@some.host.com
#pod     "Name, Full" <full.name@some.host.com>
#pod
#pod B<Disclaimer:>
#pod MIME::Lite was never intended to be a Mail User Agent, so please
#pod don't expect a full implementation of RFC-822.  Restrict yourself to
#pod the common forms of Internet addresses described herein, and you should
#pod be fine.  If this is not feasible, then consider using MIME::Lite
#pod to I<prepare> your message only, and using Net::SMTP explicitly to
#pod I<send> your message.
#pod
#pod B<Note:>
#pod As of MIME::Lite v3.02 the mail name extraction routines have been
#pod beefed up considerably. Furthermore if Mail::Address is provided then
#pod name extraction is done using that. Accordingly the above advice is now
#pod less true than it once was. Funky email names I<should> work properly
#pod now. However the disclaimer remains. Patches welcome. :-)
#pod
#pod =head2 Formatting of headers delayed until print()
#pod
#pod This class treats a MIME header in the most abstract sense,
#pod as being a collection of high-level attributes.  The actual
#pod RFC-822-style header fields are not constructed until it's time
#pod to actually print the darn thing.
#pod
#pod
#pod =head2 Encoding of data delayed until print()
#pod
#pod When you specify message bodies
#pod (in L<build()|/build> or L<attach()|/attach>) --
#pod whether by B<FH>, B<Data>, or B<Path> -- be warned that we don't
#pod attempt to open files, read filehandles, or encode the data until
#pod L<print()|/print> is invoked.
#pod
#pod In the past, this created some confusion for users of sendmail
#pod who gave the wrong path to an attachment body, since enough of
#pod the print() would succeed to get the initial part of the message out.
#pod Nowadays, $AUTO_VERIFY is used to spot-check the Paths given before
#pod the mail facility is employed.  A whisker slower, but tons safer.
#pod
#pod Note that if you give a message body via FH, and try to print()
#pod a message twice, the second print() will not do the right thing
#pod unless you  explicitly rewind the filehandle.
#pod
#pod You can get past these difficulties by using the B<ReadNow> option,
#pod provided that you have enough memory to handle your messages.
#pod
#pod
#pod =head2 MIME attributes are separate from header fields!
#pod
#pod B<Important:> the MIME attributes are stored and manipulated separately
#pod from the message header fields; when it comes time to print the
#pod header out, I<any explicitly-given header fields override the ones that
#pod would be created from the MIME attributes.>  That means that this:
#pod
#pod     ### DANGER ### DANGER ### DANGER ### DANGER ### DANGER ###
#pod     $msg->add("Content-type", "text/html; charset=US-ASCII");
#pod
#pod will set the exact C<"Content-type"> field in the header I write,
#pod I<regardless of what the actual MIME attributes are.>
#pod
#pod I<This feature is for experienced users only,> as an escape hatch in case
#pod the code that normally formats MIME header fields isn't doing what
#pod you need.  And, like any escape hatch, it's got an alarm on it:
#pod MIME::Lite will warn you if you attempt to C<set()> or C<replace()>
#pod any MIME header field.  Use C<attr()> instead.
#pod
#pod
#pod =head2 Beware of lines consisting of a single dot
#pod
#pod Julian Haight noted that MIME::Lite allows you to compose messages
#pod with lines in the body consisting of a single ".".
#pod This is true: it should be completely harmless so long as "sendmail"
#pod is used with the -oi option (see L<"Cheap and easy mailing">).
#pod
#pod However, I don't know if using Net::SMTP to transfer such a message
#pod is equally safe.  Feedback is welcomed.
#pod
#pod My perspective: I don't want to magically diddle with a user's
#pod message unless absolutely positively necessary.
#pod Some users may want to send files with "." alone on a line;
#pod my well-meaning tinkering could seriously harm them.
#pod
#pod
#pod =head2 Infinite loops may mean tainted data!
#pod
#pod Stefan Sautter noticed a bug in 2.106 where a m//gc match was
#pod failing due to tainted data, leading to an infinite loop inside
#pod MIME::Lite.
#pod
#pod I am attempting to correct for this, but be advised that my fix will
#pod silently untaint the data (given the context in which the problem
#pod occurs, this should be benign: I've labelled the source code with
#pod UNTAINT comments for the curious).
#pod
#pod So: don't depend on taint-checking to save you from outputting
#pod tainted data in a message.
#pod
#pod
#pod =head2 Don't tweak the global configuration
#pod
#pod Global configuration variables are bad, and should go away.
#pod Until they do, please follow the hints with each setting
#pod on how I<not> to change it.
#pod
#pod =head1 A MIME PRIMER
#pod
#pod =head2 Content types
#pod
#pod The "Type" parameter of C<build()> is a I<content type>.
#pod This is the actual type of data you are sending.
#pod Generally this is a string of the form C<"majortype/minortype">.
#pod
#pod Here are the major MIME types.
#pod A more-comprehensive listing may be found in RFC-2046.
#pod
#pod =over 4
#pod
#pod =item application
#pod
#pod Data which does not fit in any of the other categories, particularly
#pod data to be processed by some type of application program.
#pod C<application/octet-stream>, C<application/gzip>, C<application/postscript>...
#pod
#pod =item audio
#pod
#pod Audio data.
#pod C<audio/basic>...
#pod
#pod =item image
#pod
#pod Graphics data.
#pod C<image/gif>, C<image/jpeg>...
#pod
#pod =item message
#pod
#pod A message, usually another mail or MIME message.
#pod C<message/rfc822>...
#pod
#pod =item multipart
#pod
#pod A message containing other messages.
#pod C<multipart/mixed>, C<multipart/alternative>...
#pod
#pod =item text
#pod
#pod Textual data, meant for humans to read.
#pod C<text/plain>, C<text/html>...
#pod
#pod =item video
#pod
#pod Video or video+audio data.
#pod C<video/mpeg>...
#pod
#pod =back
#pod
#pod
#pod =head2 Content transfer encodings
#pod
#pod The "Encoding" parameter of C<build()>.
#pod This is how the message body is packaged up for safe transit.
#pod
#pod Here are the 5 major MIME encodings.
#pod A more-comprehensive listing may be found in RFC-2045.
#pod
#pod =over 4
#pod
#pod =item 7bit
#pod
#pod Basically, no I<real> encoding is done.  However, this label guarantees that no
#pod 8-bit characters are present, and that lines do not exceed 1000 characters
#pod in length.
#pod
#pod =item 8bit
#pod
#pod Basically, no I<real> encoding is done.  The message might contain 8-bit
#pod characters, but this encoding guarantees that lines do not exceed 1000
#pod characters in length.
#pod
#pod =item binary
#pod
#pod No encoding is done at all.  Message might contain 8-bit characters,
#pod and lines might be longer than 1000 characters long.
#pod
#pod The most liberal, and the least likely to get through mail gateways.
#pod Use sparingly, or (better yet) not at all.
#pod
#pod =item base64
#pod
#pod Like "uuencode", but very well-defined.  This is how you should send
#pod essentially binary information (tar files, GIFs, JPEGs, etc.).
#pod
#pod =item quoted-printable
#pod
#pod Useful for encoding messages which are textual in nature, yet which contain
#pod non-ASCII characters (e.g., Latin-1, Latin-2, or any other 8-bit alphabet).
#pod
#pod =back
#pod
#pod =cut

#pod =head1 HELPER MODULES
#pod
#pod MIME::Lite works nicely with other certain other modules if they are present.
#pod Good to have installed are the latest L<MIME::Types|MIME::Types>,
#pod L<Mail::Address|Mail::Address>, L<MIME::Base64|MIME::Base64>,
#pod L<MIME::QuotedPrint|MIME::QuotedPrint>, and L<Net::SMTP>.
#pod L<Email::Date::Format> is strictly required.
#pod
#pod If they aren't present then some functionality won't work, and other features
#pod won't be as efficient or up to date as they could be. Nevertheless they are optional
#pod extras.
#pod
#pod =head1 BUNDLED GOODIES
#pod
#pod MIME::Lite comes with a number of extra files in the distribution bundle.
#pod This includes examples, and utility modules that you can use to get yourself
#pod started with the module.
#pod
#pod The ./examples directory contains a number of snippets in prepared
#pod form, generally they are documented, but they should be easy to understand.
#pod
#pod The ./contrib directory contains a companion/tool modules that come bundled
#pod with MIME::Lite, they don't get installed by default. Please review the POD
#pod they come with.
#pod
#pod =head1 BUGS
#pod
#pod The whole reason that version 3.0 was released was to ensure that MIME::Lite is
#pod up to date and patched. If you find an issue please report it.
#pod
#pod As far as I know MIME::Lite doesn't currently have any serious bugs, but my
#pod usage is hardly comprehensive.
#pod
#pod Having said that there are a number of open issues for me, mostly caused by the
#pod progress in the community as whole since Eryq last released. The tests are
#pod based around an interesting but non standard test framework. I'd like to change
#pod it over to using Test::More.
#pod
#pod Should tests fail please review the ./testout directory, and in any bug reports
#pod please include the output of the relevant file. This is the only redeeming
#pod feature of not using Test::More that I can see.
#pod
#pod Bug fixes / Patches / Contribution are welcome, however I probably won't apply
#pod them unless they also have an associated test. This means that if I don't have
#pod the time to write the test the patch won't get applied, so please, include tests
#pod for any patches you provide.
#pod
#pod =head1 NUTRITIONAL INFORMATION
#pod
#pod For some reason, the US FDA says that this is now required by law
#pod on any products that bear the name "Lite"...
#pod
#pod Version 3.0 is now new and improved! The distribution is now 30% smaller!
#pod
#pod     MIME::Lite                |
#pod     ------------------------------------------------------------
#pod     Serving size:             | 1 module
#pod     Servings per container:   | 1
#pod     Calories:                 | 0
#pod     Fat:                      | 0g
#pod       Saturated Fat:          | 0g
#pod
#pod Warning: for consumption by hardware only!  May produce
#pod indigestion in humans if taken internally.
#pod
#pod =cut
