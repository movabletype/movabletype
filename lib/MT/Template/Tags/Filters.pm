# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Template::Tags::Filters;

use strict;
use warnings;

use MT;
use MT::Util qw( start_end_day start_end_week
    start_end_month week2ymd archive_file_for
    format_ts offset_time_list first_n_words dirify get_entry
    encode_html encode_js remove_html wday_from_ts days_in
    spam_protect encode_php encode_url decode_html encode_xml
    decode_xml relative_date asset_cleanup );
use MT::Request;
use Time::Local qw( timegm timelocal );
use MT::Promise qw( delay );
use MT::Category;
use MT::Entry;
use MT::Asset;

###########################################################################

=head2 numify

Adds commas to a number. Converting "12345" into "12,345" for instance.
The argument for the numify attribute is the separator character to use
(ie, "," or "."); "," is the default.

=cut

sub _fltr_numify {
    my ( $str, $arg, $ctx ) = @_;
    $arg = ',' if ( !defined $arg ) || ( $arg eq '1' );
    $str =~ s/(^[-+]?\d+?(?=(?>(?:\d{3})+)(?!\d))|\G\d{3}(?=\d))/$1$arg/g;
    return $str;
}

###########################################################################

=head2 mteval

Processes the input string for any MT template tags and returns the output.

B<Example:>

1. Add the `mteval` attribute to the <mt:PageBody> and <mt:PageMore> tags 
in your Page archive template so these tags...

    <$mt:PageBody$>
    <$mt:PageMore$>

...become:

    <$mt:PageBody mteval="1"$>
    <$mt:PageMore mteval="1"$>

2. Create a page and place the following code within the body of the page. 
Yes, you read that correctly, put MT tags into the body of a new page.

    <p>Latest 3 entries are...</p>
    <ul>
        <mt:Entries lastn="3">
            <li><$mt:EntryTitle$></li>
        </mt:Entries>
    </ul>

3. Publish the page and view the result!

B<Note:> When a new entry is created MT will not know to republish this page, 
so this is kind of a bad example... but it shows how the feature works. It's 
also bad practice because you should separate the code and the content of the 
site otherwise some user will eventually tinker with it and break it... but 
then they'll call you and PayPal you butloads of cash to fix it... so I guess 
it's not that bad.

=cut

sub _fltr_mteval {
    my ( $str, $arg, $ctx ) = @_;

    return $str unless $arg;

    my $builder = $ctx->stash('builder');
    my $tokens = $builder->compile( $ctx, $str );
    return $ctx->error( $builder->errstr ) unless defined $tokens;
    my $out = $builder->build( $ctx, $tokens );
    return $ctx->error( $builder->errstr ) unless defined $out;
    return $out;
}

###########################################################################

=head2 encode_sha1

Outputs a SHA1-hex digest of the content from the tag it is applied to.

B<Example:>

    <$mt:EntryTitle encode_sha1="1"$>

outputs:

    0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33

=cut

sub _fltr_sha1 {
    my ($str) = @_;
    require MT::Util;
    return MT::Util::perl_sha1_digest_hex($str);
}

###########################################################################

=head2 setvar

Takes the content from the tag it is applied to and assigns it
to the given variable name.

Example, assigning a HTML link of the last published entry with a
'@featured' tag to a template variable named 'featured_entry_link':

    <mt:Entries lastn="1" tags="@featured" setvar="featured_entry_link">
        <a href="<$mt:EntryPermalink$>"><$mt:EntryTitle$></a>
    </mt:Entries>

The output from the L<Entries> tag is suppressed, and placed into
the template variable 'featured_entry_link' instead. To retrieve it,
just use the L<Var> tag.

=cut

sub _fltr_setvar {
    my ( $str, $arg, $ctx ) = @_;
    if ( my $hash = $ctx->{__inside_set_hashvar} ) {
        $hash->{$arg} = $str;
    }
    else {
        $ctx->var( $arg, $str );
    }
    return '';
}

###########################################################################

=head2 nofollowfy

Processes the 'a' tags from the tag it is applied to and adds a 'rel'
attribute of 'nofollow' to it (or appends to an existing rel attribute).

B<Example:>

    <$mt:CommentBody nofollowfy="1"$>

=cut

sub _fltr_nofollowfy {
    my ( $str, $arg, $ctx ) = @_;
    return $str unless $arg;
    $str =~ s#<\s*a\s([^>]*\s*href\s*=[^>]*)>#
        my @attr = $1 =~ /[^=\s]*\s*=\s*"[^"]*"|[^=\s]*\s*=\s*'[^']*'|[^=\s]*\s*=[^\s]*/g;
        my @rel = grep { /^rel\s*=/i } @attr;
        my $rel;
        $rel = pop @rel if @rel;
        if ($rel) {
            $rel =~ s/^(rel\s*=\s*['"]?)/$1nofollow /i
                unless $rel =~ m/\bnofollow\b/;
        } else {
            $rel = 'rel="nofollow"';
        }
        @attr = grep { !/^rel\s*=/i } @attr;
        @attr = map { Encode::is_utf8( $_ ) ? $_ : Encode::decode_utf8($_) } @attr;
        '<a ' . (join ' ', @attr) . ' ' . $rel . '>';
    #xieg;
    $str;

}

###########################################################################

=head2 filters

Applies one or more text format filters.

=head4 Values

See the list of acceptable values in the L<AllowedTextFilters|/documentation/appendices/config-directives/allowedtextfilters.html> config directive docs

=head4 Examples

Remove the default text filter specified in the Edit Entry screen (Rich Text, Markdown, etc) by setting convert_breaks="0" and then use the filter attribute to specify the desired filter.

    <$mt:EntryBody convert_breaks="0" filters="__default__"$>

If you want to use Markdown for the body, but Markdown with SmartyPants for the extended entry, do this:

    <$mt:EntryMore convert_breaks="0" filters="markdown_with_smartypants"$>

If you want no formatting on L<EntryBody> or L<EntryMore> (extended) text, just use convert_breaks="0".

=cut

sub _fltr_filters {
    my ( $str, $val, $ctx ) = @_;
    MT->apply_text_filters( $str, [ split /\s*,\s*/, $val ], $ctx );
}

###########################################################################

=head2 trim_to

Trims the input content to the requested length.

B<Example:>

    <$mt:EntryTitle trim_to="4"$>

=cut

sub _fltr_trim_to {
    my ( $str, $val, $ctx ) = @_;

    my ( $len, $tail );
    if ( $val =~ /\+/ ) {
        ( $len, $tail ) = split /\+/, $val, 2;
    }
    else {
        $len = $val;
    }

    if ( $len =~ m/^\d+$/ && $len > 0 ) {

        # $len is positive number.
        if ( $len < length($str) ) {
            $str = substr( $str, 0, $len );
            $str .= $tail if defined $tail;
        }
        return $str;
    }
    elsif ( $len =~ m/^-\d+$/ && $len < 0 ) {

        # $len is negative number.
        $str = substr( $str, 0, $len );
        if ( length($str) && defined($tail) ) {
            $str .= $tail;
        }
        return $str;
    }

    # $len is zero or is not number.
    return '';
}

###########################################################################

=head2 trim

Trims all leading and trailing whitespace from the input.

B<Example:>

    <$mt:EntryTitle trim="1"$>

=cut

sub _fltr_trim {
    my ( $str, $val, $ctx ) = @_;
    $str =~ s/^\s+|\s+$//gs;
    $str;
}

###########################################################################

=head2 ltrim

Trims all leading whitespace from the input.

B<Example:>

    <$mt:EntryTitle ltrim="1"$>

=cut

sub _fltr_ltrim {
    my ( $str, $val, $ctx ) = @_;
    $str =~ s/^\s+//s;
    $str;
}

###########################################################################

=head2 rtrim

Trims all trailing (right-side) whitespace from the input.

B<Example:>

    <$mt:EntryTitle rtrim="1"$>

=cut

sub _fltr_rtrim {
    my ( $str, $val, $ctx ) = @_;
    $str =~ s/\s+$//s;
    $str;
}

###########################################################################

=head2 decode_html

Decodes any HTML entities from the input.

=cut

sub _fltr_decode_html {
    my ( $str, $val, $ctx ) = @_;
    MT::Util::decode_html($str);
}

###########################################################################

=head2 decode_xml

Removes XML encoding from the input. Strips a 'CDATA' wrapper as well.

=cut

sub _fltr_decode_xml {
    my ( $str, $val, $ctx ) = @_;
    decode_xml($str);
}

###########################################################################

=head2 remove_html

Removes any HTML markup from the input.

=cut

sub _fltr_remove_html {
    my ( $str, $val, $ctx ) = @_;
    MT::Util::remove_html($str);
}

###########################################################################

=head2 dirify

Converts the input into a filename-friendly format. This strips accents
from accented characters and changes spaces into underscores (or
dashes, depending on parameter).

The dirify parameter can be either "1", "-" or "_". "1" is equivalent
to "_".

B<Example:>

    <$mt:EntryTitle dirify="-"$>

which would translate an entry titled "Cafe" into "cafe".

=cut

sub _fltr_dirify {
    my ( $str, $val, $ctx ) = @_;
    return $str if ( defined $val ) && ( $val eq '0' );
    MT::Util::dirify( $str, $val );
}

###########################################################################

=head2 sanitize

Filters input of particular HTML tags and other markup that may be unsafe
content. If the sanitize parameter is "1", it will use the MT configured
"GlobalSanitizeSpec" setting to control how it processes the input. But
the parameter may also specify this directly. For example:

    <$mt:CommentBody sanitize="b,strong,em,i,ul,li,ol,p,br/"$>

This would strip any HTML tags from the comment that are not specified
in this list.

=cut

sub _fltr_sanitize {
    my ( $str, $val, $ctx ) = @_;
    my $blog = $ctx->stash('blog');
    require MT::Sanitize;
    if ( $val eq '1' ) {
        $val = ( $blog && $blog->sanitize_spec )
            || $ctx->{config}->GlobalSanitizeSpec;
    }
    MT::Sanitize->sanitize( $str, $val );
}

###########################################################################

=head2 encode_html

Encodes any special characters into HTML entities (ie, '<' becomes '&lt;').

=cut

sub _fltr_encode_html {
    my ( $str, $val, $ctx ) = @_;
    MT::Util::encode_html( $str, 1 );
}

###########################################################################

=head2 encode_xml

Encodes input into an XML-friendly format. May wrap in a CDATA block
if the input contains tags or HTML entities.

=cut

sub _fltr_encode_xml {
    my ( $str, $val, $ctx ) = @_;
    MT::Util::encode_xml($str);
}

###########################################################################

=head2 encode_js

Encodes any special characters so that the string can be used safely as
the value in Javascript.

B<Example:>

    <script type="text/javascript">
    <!-- /* <![CDATA[ */
    var the_title = '<$MTEntryTitle encode_js="1"$>';
    /* ]]> */ -->

=cut

sub _fltr_encode_js {
    my ( $str, $val, $ctx ) = @_;
    MT::Util::encode_js($str);
}

###########################################################################

=head2 encode_json

Encodes any special characters so that the string can be used safely as
the value in JSON.

=cut

sub _fltr_encode_json {
    my ( $str, $val, $ctx ) = @_;
    MT::Util::encode_json($str);
}

###########################################################################

=head2 encode_php

Encodes any special characters so that the string can be used safely as
the value in PHP code.

The value of the attribute can be either C<qq> (double-quote interpolation),
C<here> (heredoc interpolation), or C<q> (single-quote interpolation). C<q>
is the default.

B<Example:>

    <?php
    $the_title = '<$MTEntryTitle encode_php="q"$>';
    $the_author = "<$MTEntryAuthorDisplayName encode_php="qq"$>";
    $the_text = <<<EOT
    <$MTEntryText encode_php="here"$>
    EOT
    ?>

=cut

sub _fltr_encode_php {
    my ( $str, $val, $ctx ) = @_;
    MT::Util::encode_php( $str, $val );
}

###########################################################################

=head2 encode_url

URL encodes any special characters.

=cut

sub _fltr_encode_url {
    my ( $str, $val, $ctx ) = @_;
    MT::Util::encode_url($str);
}

###########################################################################

=head2 upper_case

Uppercases all alphabetic characters.

=cut

sub _fltr_upper_case {
    my ( $str, $val, $ctx ) = @_;
    return uc($str);
}

###########################################################################

=head2 lower_case

Lowercases all alphabetic characters.

=cut

sub _fltr_lower_case {
    my ( $str, $val, $ctx ) = @_;
    return lc($str);
}

###########################################################################

=head2 strip_linefeeds

Removes any linefeed characters from the input.

=cut

sub _fltr_strip_linefeeds {
    my ( $str, $val, $ctx ) = @_;
    $str =~ tr(\r\n)()d;
    $str;
}

###########################################################################

=head2 space_pad

Adds whitespace to the left of the input to the length specified.

B<Example:>

    <$mt:EntryBasename space_pad="10">

For a basename of "example", this would output: "   example".

=cut

sub _fltr_space_pad {
    my ( $str, $val, $ctx ) = @_;
    sprintf "%${val}s", $str;
}

###########################################################################

=head2 zero_pad

Adds '0' to the left of the input to the length specified.

B<Example:>

    <$mt:EntryID zero_pad="10"$>

For an entry id of 1023, this would output: "0000001023".

=cut

sub _fltr_zero_pad {
    my ( $str, $val, $ctx ) = @_;
    sprintf "%0${val}s", $str;
}

###########################################################################

=head2 string_format

An alias for the 'sprintf' modifier.

=cut

###########################################################################

=head2 sprintf

Formats the input text using the Perl 'sprintf' function. The value of
the 'sprintf' attribute is used as the sprintf pattern.

B<Example:>

    <$mt:EntryCommentCount sprintf="<%.6d>"$>

Outputs (for an entry with 1 comment):

    <000001>

Refer to Perl's documentation for sprintf for more examples.

=cut

sub _fltr_sprintf {
    my ( $str, $val, $ctx ) = @_;
    sprintf $val, $str;
}

###########################################################################

=head2 regex_replace

Applies a regular expression operation on the input. This filter accepts
B<two> input values: one is the pattern, the second is the replacement.

B<Example:>

    <$mt:EntryTitle regex_replace="/\s*\[.+?\]\s*$/",""$>

This would strip any bracketed phrase from the end of the entry
title field.

=cut

sub _fltr_regex_replace {
    my ( $str, $val, $ctx ) = @_;

    # This one requires an array
    return $str unless ref($val) eq 'ARRAY';
    my $patt    = $val->[0];
    my $replace = $val->[1];
    if ( $patt =~ m!^(/)(.+)\1([A-Za-z]+)?$! ) {
        $patt = $2;
        my $global;
        if ( my $opt = $3 ) {
            $global = 1 if $opt =~ m/g/;
            $opt =~ s/[ge]+//g;
            $patt = "(?$opt)" . $patt;
        }
        my $re = eval {qr/$patt/};
        if ( defined $re ) {
            $replace =~ s!\\\\(\d+)!\$1!g;  # for php, \\1 is how you write $1
            $replace =~ s{\\(?![\da-zLUE])}{\\\\}g;
            $replace =~ s!/!\\/!g;
            $replace =~ s/(@|\$(?![\d\&]))/\\$1/g;
            eval '$str =~ s/$re/' . $replace . '/' . ( $global ? 'g' : '' );
            if ($@) {
                return $ctx->error("Invalid regular expression: $@");
            }
        }
    }
    return $str;
}

###########################################################################

=head2 capitalize

Uppercases the first letter of each word in the input.

=cut

sub _fltr_capitalize {
    my ( $str, $val, $ctx ) = @_;
    $str =~ s/\b(\w+)\b/\u\L$1/g;
    return $str;
}

###########################################################################

=head2 count_characters

Outputs the number of characters found in the input.

=cut

sub _fltr_count_characters {
    my ( $str, $val, $ctx ) = @_;
    return length($str);
}

###########################################################################

=head2 cat

Append the input value with the value of the 'cat' attribute.

B<Example:>

    <$mt:EntryTitle cat="!!!1!"$>

=cut

sub _fltr_cat {
    my ( $str, $val, $ctx ) = @_;
    return $str . $val;
}

###########################################################################

=head2 count_paragraphs

Outputs the number of paragraphs found in the input.

=cut

sub _fltr_count_paragraphs {
    my ( $str, $val, $ctx ) = @_;
    my @paras = split /[\r\n]+/, $str;
    return scalar @paras;
}

###########################################################################

=head2 count_words

Outputs the number of words found in the input.

=cut

sub _fltr_count_words {
    my ( $str, $val, $ctx ) = @_;
    my @words = split /\s+/, $str;
    @words = grep /[A-Za-z0-9\x80-\xff]/, @words;
    return scalar @words;
}

# sub _fltr_date_format {
#     my ($str, $val, $ctx) = @_;
#
# }

###########################################################################

=head2 escape

Similar to the 'encode_*' modifiers. The input is reformatted so that
certain special characters are translated depending on the value of
the 'escape' attribute. The following modes are recognized:

=over 4

=item * html

Similar to the 'encode_html' modifier. Escapes special characters as
HTML entities.

=item * url

Similar to the 'encode_url' modifier. Escapes special characters using
a URL-encoded format (ie, " " becomes "%20").

=item * javascript or js

Similar to the 'encode_js' modifier. Escapes special characters such
as quotes, newline characters, etc., so that the input can be placed
in a JavaScript string.

=item * mail

A very simple email obfuscation technique.

=back

=cut

sub _fltr_escape {
    my ( $str, $val, $ctx ) = @_;

    # val can be one of: html, htmlall, url, urlpathinfo, quotes,
    # hex, hexentity, decentity, javascript, mail, nonstd
    $val = lc($val);
    if ( $val eq 'html' ) {
        $str = MT::Util::encode_html( $str, 1 );
    }
    elsif ( $val eq 'htmlall' ) {

        # FIXME: implementation
    }
    elsif ( $val eq 'url' ) {
        $str = MT::Util::encode_url($str);
    }
    elsif ( $val eq 'urlpathinfo' ) {

        # FIXME: implementation
    }
    elsif ( $val eq 'quotes' ) {

        # FIXME: implementation
    }
    elsif ( $val eq 'hex' ) {

        # FIXME: implementation
    }
    elsif ( $val eq 'hexentity' ) {

        # FIXME: implementation
    }
    elsif ( $val eq 'decentity' ) {

        # FIXME: implementation
    }
    elsif ( $val eq 'javascript' || $val eq 'js' ) {
        $str = MT::Util::encode_js($str);
    }
    elsif ( $val eq 'mail' ) {
        $str =~ s/\./ [DOT] /g;
        $str =~ s/\@/ [AT] /g;
    }
    elsif ( $val eq 'nonstd' ) {

        # FIXME: implementation
    }
    return $str;
}

###########################################################################

=head2 indent

Adds the specified amount of whitespace to the left of each line of
the input.

B<Example:>

    <$mt:EntryBody indent="4"$>

This adds 4 spaces to the left of each line of the L<EntryBody>
value.

=cut

sub _fltr_indent {
    my ( $str, $val, $ctx ) = @_;
    if ( ( my $len = int($val) ) > 0 ) {
        my $space = ' ' x $len;
        $str =~ s/^/$space/mg;
    }
    return $str;
}

###########################################################################

=head2 nl2br

Converts any newline characters into HTML C<br> tags. If the value of
the 'nl2br' attribute is "xhtml", it will use the "C<<br />>" form
of the C<br> tag.

=cut

sub _fltr_nl2br {
    my ( $str, $val, $ctx ) = @_;
    if ( $val eq 'xhtml' ) {
        $str =~ s/\r?\n/<br \/>/g;
    }
    else {
        $str =~ s/\r?\n/<br>/g;
    }
    return $str;
}

###########################################################################

=head2 replace

Issues a simple text search/replace on the input. This modifier requires
B<two> parameters.

B<Example:>

    <$mt:EntryBody replace="teh","the"$>

=cut

sub _fltr_replace {
    my ( $str, $val, $ctx ) = @_;

    # This one requires an array
    return $str unless ref($val) eq 'ARRAY';
    my $search  = $val->[0];
    my $replace = $val->[1];
    $str =~ s/\Q$search\E/$replace/g;
    return $str;
}

###########################################################################

=head2 spacify

Interleaves the value of the C<spacify> attribute between each character
of the input.

B<Example:>

    <$mt:EntryTitle spacify=" "$>

Changing an entry title of "Hi there!" to "H i   t h e r e !".

=cut

sub _fltr_spacify {
    my ( $str, $val, $ctx ) = @_;
    my @c = split //, $str;
    return join $val, @c;
}

###########################################################################

=head2 strip

Replaces all whitespace with the value of the C<strip> attribute.

B<Example:>

    <$mt:EntryTitle strip="&nbsp;"$>

=cut

sub _fltr_strip {
    my ( $str, $val, $ctx ) = @_;
    $val = ' ' unless defined $val;
    $str =~ s/\s+/$val/g;
    return $str;
}

###########################################################################

=head2 strip_tags

An alias for L<remove_html>. Removes all HTML markup from the input.

=cut

sub _fltr_strip_tags {
    my ( $str, $val, $ctx ) = @_;
    return MT::Util::remove_html($str);
}

###########################################################################

=head2 _default

Outputs the value of the C<_default> attribute if the input string
is empty.

B<Example:>

    <$mt:BlogDescription _default="Not 'just another' Movable Type blog."$>

=cut

sub _fltr_default {
    my ( $str, $val, $ctx ) = @_;
    if ( $str eq '' ) { return $val }
    return $str;
}

# sub _fltr_truncate {
#     my ($str, $val, $ctx) = @_;
# }

# sub _fltr_wordwrap {
#     my ($str, $val, $ctx) = @_;
# }

###########################################################################

=head2 wrap_text

Reformats the input, adding newline characters so the text "wraps"
at the length specified as the value for the C<wrap_text> attribute.
Example (this would format the entry text so it is suitable for
a text e-mail message):

    <$mt:EntryBody remove_html="1" wrap_text="72"$>

=cut

sub _fltr_wrap_text {
    my ( $str, $val, $ctx ) = @_;
    require MT::I18N::default;
    my $ret = MT::I18N::default->wrap_text( $str, $val );
    return $ret;
}

1;
