# ---------------------------------------------------------------------------
# MT-Textile Text Formatter
# A plugin for Movable Type
#
# Release 2.05
#
# Brad Choate
# http://www.bradchoate.com/
# ---------------------------------------------------------------------------
# This software is provided as-is.
# You may use it for commercial or personal use.
# If you distribute it, please keep this notice intact.
#
# Copyright (c) 2003-2008 Brad Choate
# ---------------------------------------------------------------------------
# $Id$
# ---------------------------------------------------------------------------

package MT::Plugin::Textile;

use strict;
use MT;
use base qw( MT::Plugin );

our $VERSION = 2.06;
our ( $_initialized, $Have_SmartyPants );

MT->add_plugin(
    __PACKAGE__->new(
        {   name        => "Textile",
            description => '<MT_TRANS phrase="A humane web text generator.">',
            author_name => "Brad Choate",
            author_link => "http://bradchoate.com/",
            version     => $VERSION,
            registry    => {
                text_filters => {
                    textile_2 => {
                        label => "Textile 2",
                        code  => \&textile_2,
                        docs =>
                            "http://www.movabletype.org/documentation/author/textile-2-syntax.html",
                    },
                },
                tags => {
                    help_url => sub {
                        MT->translate(
                            'http://www.movabletype.org/documentation/appendices/tags/%t.html'
                        );
                    },
                    block    => { Textile => \&Textile, },
                    function => {
                        TextileOptions    => \&TextileOptions,
                        TextileHeadOffset => \&TextileHeadOffset,
                    },
                },
            },
        }
    )
);

sub _init {
    require Text::Textile;
    @MT::Textile::ISA = qw(Text::Textile);
    $Have_SmartyPants = defined &SmartyPants::SmartyPants ? 1 : 0;
    $_initialized     = 1;
}

sub textile_2 {
    my ( $str, $ctx ) = @_;

    _init() unless $_initialized;

    my $textile;
    if ( ( defined $ctx ) && ( ref($ctx) eq 'MT::Template::Context' ) ) {
        $textile = $ctx->stash('TextileObj');
        unless ($textile) {
            $textile = _new_textile($ctx);
            $ctx->stash( 'TextileObj', $textile );
        }
        $textile->head_offset( $ctx->stash('TextileHeadOffsetStart') || 0 );
        if ( my $opts = $ctx->stash('TextileOptions') ) {
            $textile->set( $_, $opts->{$_} ) foreach keys %$opts;

            # now clear the options from the stash so we don't
            # repeat this for each invocation of textile...
            $ctx->stash( 'TextileOptions', undef );
        }

        # reduces circular references
        # $textile->filter_param($ctx);
        require MT::Util;
        MT::Util::weaken( $textile->{filter_param} = $ctx );
    }
    else {

        # no Context object...
        $textile = _new_textile();
    }

    $str = $textile->process($str);

    if ( ( defined $ctx ) && ( ref($ctx) eq 'MT::Template::Context' ) ) {
        my $entry = $ctx->stash('entry');
        if ( $entry && $entry->id ) {
            my $link = $entry->permalink;
            $link =~ s/#.+$//;
            $str =~ s/(<a .*?(?<=[ ])href=")(#fn(?:\d)+".*?>)/$1$link$2/g;
        }
    }

    # invoke MT-CodeBeautifier for any <code> or <blockcode> tags that
    # specify a 'language' attribute:
    my $beautifier = defined &Voisen::CodeBeautifier::beautifier;
    if ($beautifier) {
        $str
            =~ s|<((block)?code)([^>]*?) language="([^"]+?)"([^>]*?)>(.+?)</\1>|_highlight($1, $3, $5, $4, $textile->decode_html($6))|ges
            ;    # "
    }

    $str;
}

sub _new_textile {
    my ($ctx) = @_;

    my $textile = new MT::Textile;

    # this copies the named filters from MT to TextileFormat
    my %list;
    my $filters = MT::all_text_filters();
    foreach my $name ( keys %$filters ) {
        $list{$name} = $filters->{$name}{on_format};
    }
    $textile->filters( \%list );

    my $cfg = MT::ConfigMgr->instance;

    if ( $cfg->NoHTMLEntities ) {
        $textile->char_encoding(0);
    }

    $textile->charset('utf-8');

    $textile;
}

sub Textile {
    my ( $ctx, $args, $cond ) = @_;
    _init() unless $_initialized;
    local $ctx->{__stash}{TextileObj} = _new_textile($ctx);
    local $ctx->{__stash}{TextileOptions} = $args if keys %$args;
    my $str = $ctx->slurp;
    textile_2( $str, $ctx );
}

sub TextileHeadOffset {
    my ( $ctx, $args, $cond ) = @_;
    my $start = $args->{start};
    if ( $start && $start =~ m/^\d+$/ && $start >= 1 && $start <= 6 ) {
        $ctx->stash( 'TextileHeadOffsetStart', $start );
    }
    '';
}

sub TextileOptions {
    my ( $ctx, $args, $cond ) = @_;
    $ctx->stash( 'TextileOptions', $args );
    '';
}

sub _highlight {
    my ( $tag, $attr1, $attr2, $lang, $code ) = @_;
    my $tagopen = '<' . $tag;
    $tagopen .= $attr1 if defined $attr1;
    $tagopen .= $attr2 if defined $attr2;
    $tagopen .= '>';
    if ( $lang =~ m/perl/i ) {
        $code = Voisen::CodeBeautifier::highlight_perl($code);
    }
    elsif ( $lang =~ m/php/i ) {
        $code = Voisen::CodeBeautifier::highlight_php3($code);
    }
    elsif ( $lang =~ m/java/i ) {
        $code = Voisen::CodeBeautifier::highlight_java($code);
    }
    elsif ( ( $lang =~ m/actionscript/i ) || ( $lang =~ m/as/i ) ) {
        $code = Voisen::CodeBeautifier::highlight_as($code);
    }
    elsif ( $lang =~ m/scheme/i ) {
        $code = Voisen::CodeBeautifier::highlight_scheme($code);
    }
    $code =~ s!^<pre>!!;
    $code =~ s!</pre>$!!;
    return $tagopen . $code . '</' . $tag . '>';
}

# This is a Text::Textile subclass that provides enhanced
# functionality for Movable Type integration

package MT::Textile;

sub image_size {
    my $self  = shift;
    my ($src) = @_;
    my $ctx   = $self->filter_param;
    if ( $src !~ m|^http:| && $ctx ) {
        my $blog = $ctx->stash('blog');
        if ($blog) {
            require File::Spec;

            # local image -- calc size
            my $file;
            if ( ( $src =~ m!^/! ) && ( exists $ENV{DOCUMENT_ROOT} ) ) {
                $file = File::Spec->catfile( $ENV{DOCUMENT_ROOT}, $src );
            }
            else {
                $file = File::Spec->catfile( $blog->site_path, $src );
            }
            if ( -f $file ) {
                eval { require MT::Image; };
                if ( !$@ ) {
                    my $img = MT::Image->new( Filename => $file );
                    if ($img) {
                        return $img->get_dimensions;
                    }
                }
            }
        }
    }
    undef;
}

sub format_link {
    my $self   = shift;
    my (%args) = @_;
    my $title  = exists $args{title} ? $args{title} : '';
    my $url    = exists $args{url} ? $args{url} : '';
    my $ctx    = $self->filter_param;
    if ( $url =~ m/^\d+$/ && $ctx ) {
        my $blog = $ctx->stash('blog');
        if ($blog) {
            require MT::Entry;
            my $entry
                = MT::Entry->load( { blog_id => $blog->id, id => $url } );
            if ($entry) {
                local $ctx->{__stash}{entry} = $entry;
                my $relurl    = MT::Template::Context::_hdlr_blog_url($ctx);
                my $regrelurl = quotemeta($relurl);
                $args{url}
                    = MT::Template::Context::_hdlr_entry_permalink($ctx);
                $args{url} =~ s/^.*?($regrelurl)/$1/;
                if ( ( !exists $args{title} ) && ( $entry->title ) ) {
                    require MT::Util;
                    my $title
                        = MT::Util::remove_html( $entry->title ); # strip HTML
                    $title
                        =~ s/"/&quot;/g;   # convert double quotes to entities
                    $args{title} = $title;
                }
            }
        }
    }

    $self->SUPER::format_link(%args);
}

sub process_quotes {
    my $self = shift;
    my ($str) = @_;
    return $str unless $self->{do_quotes};
    if ($plugins::textile2::Have_SmartyPants) {
        $str = SmartyPants::SmartyPants( $str, $self->{smarty_mode} );
    }
    $str;
}

sub format_url {
    my $self   = shift;
    my (%args) = @_;
    my $url    = exists $args{url} ? $args{url} : '';
    my $ctx    = $self->filter_param;
    if ( $url =~ m/^\d+$/ && $ctx ) {

        # looks like an entry id, so let's link it
        my $blog = $ctx->stash('blog');
        if ($blog) {
            require MT::Entry;
            my $entry
                = MT::Entry->load( { 'blog_id' => $blog->id, 'id' => $url } );
            if ($entry) {
                local $ctx->{__stash}{entry} = $entry;
                my $relurl
                    = MT::Template::Context::_hdlr_blog_relative_url($ctx);
                my $regrelurl = quotemeta($relurl);
                $args{url}
                    = MT::Template::Context::_hdlr_entry_permalink($ctx);
                $args{url} =~ s/^.+?($regrelurl)/$1/;
            }
        }
    }
    elsif ( $url =~ m/^imdb(?::(.+))?$/ ) {
        my $term = $1;
        $term ||= MT::Util::remove_html( $args{linktext} || '' );
        $args{url} = 'http://www.imdb.com/Find?for=' . $term;
    }
    elsif ( $url =~ m/^google(?::(.+))?$/ ) {
        my $term = $1;
        $term ||= MT::Util::remove_html( $args{linktext} || '' );
        $args{url} = 'http://www.google.com/search?q=' . $term;
    }
    elsif ( $url =~ m/^dict(?::(.+))?$/ ) {
        my $term = $1;
        $term ||= MT::Util::remove_html( $args{linktext} || '' );
        $args{url} = 'http://www.dictionary.com/search?q=' . $term;
    }
    elsif ( $url =~ m/^amazon(?::(.+))?$/ ) {
        my $term = $1;
        $term ||= MT::Util::remove_html( $args{linktext} || '' );
        $args{url}
            = 'http://www.amazon.com/exec/obidos/external-search?index=blended&keyword='
            . $term;
    }
    $self->SUPER::format_url(%args);
}

1;

__END__

=head1 NAME

Textile - A plugin for Movable Type.

=head1 DESCRIPTION

This plugin integrates the Perl Text::Textile module with Movable
Type.

=head1 INSTALLATION

To install, place the 'textile2.pl' file in your Movable Type
'plugins' directory. Install the 'Textile.pm' file in a 'Text'
subdirectory underneath the Movable Type 'extlib' directory.

Your installation should look like this:

    (mt home)/plugins/textile2.pl
    (mt home)/extlib/Text/Textile.pm

You may also consider installing the Smarty Pants plugin by
John Gruber. MT-Textile uses this plugin to translate normal
quote characters into typographic quotes.

The Code Beautifier plugin by Sean Voisen is also supported
by MT-Textile. If you specify a language modifier for "bc"
blocks or for "@...@" strings, it will invoke the Code Beautifier
to colorize the code.

=head1 TEXT FORMATTERS

=head2 textile_2

The text formatter identified by "textile_2" invokes the Textile
formatter. You can select "Textile 2" from the Movable Type interface
to use this option to format your entries and/or comments.

You may also invoke the formatter on any Movable Type tag, like this:

    <$MTBlogDescription filters="textile_2"$>

For specific documentation on how this text formatter processes
text (a writing guide), please refer to the online documentation
available here:

L<http://www.bradchoate.com/mt/docs/mtmanual_textile2.html>

A copy of that document is available in the distribution of this
plugin. Located in the file "docs/mtmanual_textile2.html".

=head1 TAGS

=head2 E<lt>MTTextileE<gt>

A container tag that also allows you to invoke the Textile formatter.
Anything placed within this tag will be fed into the formatter for
processing. Additionally, all attributes passed to this tag are
processed as options for the Textile engine.

Attributes available:

=over

=item charset

Set this to the character set of the incoming data. This value
will default to the "PublishCharset" value in your mt.cfg file.
If no charset is given anywhere, it will default to ISO-8859-1.

=item char_encoding

Set to 1 to encode special characters to HTML entities. If
you're outputting utf-8 data, this can be set to '0' to
output plaintext instead. In fact, if you set your PublishCharset
for Movable Type to utf-8, it will effectively set this
setting to '0'. Otherwise, the default value is 1.

=item do_quotes

Sets the option for processing quotes into curly quotes. Defaults
to 1. The "Smarty" plugin will be used as a default, if available.

=item trim_spaces

Set to '1' to cause any trailing whitespace on lines to be
trimmed. Default is 0 (disabled).

=item smarty_mode

Controls the Smarty plugin for processing quotes. The value
given is passed through to the Smarty plugin to control how it
behaves. Please refer to the documentation for the Smarty Pants
plugin for the available values for this attribute. You can
simply specify '1' for the default mode of operation.

=item preserve_spaces

Set to '1' to cause multiple, continuous spaces to be preserved
by changing them to the HTML entity &#8195;. If '0', spaces
are left as-is, which means they will appear as a single space
when rendered to HTML. Default is '0'.

=item head_offset

Set to a number from "1" to "5" to control the numbering of the
"h1" to "h6" paragraph block codes. For example, if a head_offset
of "1" is given, any "h1" paragraph blocks will produce "h2" HTML
tags. Or "h3" HTML tags if a head_offset of "2" is specified.

=item flavor

Use the flavor attribute to identify whether the HTML produced
should be HTML, XHTML 1.x or XHTML 2 compliant. Available
values include:

    html
    html/css
    xhtml1
    xhtml2

The default flavor is "xhtml1".
                
=item css

Set to '1' to allow the Textile formatter to use CSS classes
and style attributes to format any output. Specifying '0' will
avoid the use of style and class attributes. This attribute
will default to '1' when a flavor of "html/css" or "xhtml1"
or "xhtml2" is given.

=back

=head2 E<lt>$MTTextileOptions$E<gt>

A standalone tag that can also be used to configure the Textile
text formatter. See the attributes available to the E<lt>MTTextileE<gt>
tag for what is available.

=head2 E<lt>$MTTextileHeadOffset$E<gt>

Another tag that can be used to set the "head_offset" attribute.
This tag is left for backward compability. Please use the
E<lt>MTTextileOptionsE<gt> tag in the future.

=head1 LICENSE

Released under the MIT license. Please see

L<http://www.opensource.org/licenses/mit-license.php>

for details.

=head1 SUPPORT

If you have questions or need assistance with this plugin, please
use the following link:

L<http://www.bradchoate.com/mt-plugins/textile>

=head1 COPYRIGHT

Copyright 2002-2004, Brad Choate

=cut
