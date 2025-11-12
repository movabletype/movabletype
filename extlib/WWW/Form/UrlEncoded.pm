package WWW::Form::UrlEncoded;

use 5.008001;
use strict;
use warnings;

BEGIN {
    our $VERSION = "0.26";
    our @EXPORT_OK = qw/parse_urlencoded parse_urlencoded_arrayref build_urlencoded build_urlencoded_utf8/;

    my $use_pp = $ENV{WWW_FORM_URLENCODED_PP};

    if (!$use_pp) {
        eval {
            require WWW::Form::UrlEncoded::XS;
            if ( $WWW::Form::UrlEncoded::XS::VERSION < $VERSION ) {
                warn "WWW::Form::UrlEncoded::XS $VERSION is require. fallback to PP version";
                die;
            }
        };
        $use_pp = !!$@;
    }

    if ($use_pp) {
        require WWW::Form::UrlEncoded::PP;
        WWW::Form::UrlEncoded::PP->import(@EXPORT_OK);
    }
    else {
        WWW::Form::UrlEncoded::XS->import(@EXPORT_OK);
    }

    require Exporter;
    *import = \&Exporter::import;
}

1;
__END__

=encoding utf-8

=head1 NAME

WWW::Form::UrlEncoded - parser and builder for application/x-www-form-urlencoded

=head1 SYNOPSIS

    use WWW::Form::UrlEncoded qw/parse_urlencoded build_urlencoded/;
    
    my $query_string = "foo=bar&baz=param";
    my @params = parse_urlencoded($query_string);
    # ('foo','bar','baz','param')
    
    my $query_string = build_urlencoded('foo','bar','baz','param');
    # "foo=bar&baz=param";

=head1 DESCRIPTION

WWW::Form::UrlEncoded provides application/x-www-form-urlencoded parser and builder.
This module aims to have compatibility with other CPAN modules like 
HTTP::Body's urlencoded parser.

This module try to use L<WWW::Form::UrlEncoded::XS> by default and fail to it, 
use WWW::Form::UrlEncoded::PP instead

=head2 Parser rules

WWW::Form::UrlEncoded parsed string in this rule.

=over 4

=item 1. Split application/x-www-form-urlencoded payload by C<&> (U+0026) or C<;> (U+003B)

=item 2. Ready empty array to store C<name> and C<value>

=item 3. For each divided string, apply next steps.

=over 4

=item 1. If first character of string is C<' '> (U+0020 SPACE), remove it.

=item 2. If string has C<=>, let B<name> be substring from start to first C<=>, but excluding first C<=>, and remains to be B<value>. If there is no strings after first C<=>, B<value> to be empty string C<"">. If first C<=> is first character of the string, let B<key> be empty string C<"">. If string does not have any C<=>, all of the string to be B<key> and B<value> to be empty string C<"">.

=item 3. replace all C<+> (U+002B) with C<' '> (U+0020 SPACE).

=item 4. unescape B<name> and B<value>. push them to the array.

=back

=item 4. return the array.

=back

=head2 Test data

  'a=b&c=d'     => ["a","b","c","d"]
  'a=b;c=d'     => ["a","b","c","d"]
  'a=1&b=2;c=3' => ["a","1","b","2","c","3"]
  'a==b&c==d'   => ["a","=b","c","=d"]
  'a=b& c=d'    => ["a","b","c","d"]
  'a=b; c=d'    => ["a","b","c","d"]
  'a=b; c =d'   => ["a","b","c ","d"]
  'a=b;c= d '   => ["a","b","c"," d "]
  'a=b&+c=d'    => ["a","b"," c","d"]
  'a=b&+c+=d'   => ["a","b"," c ","d"]
  'a=b&c=+d+'   => ["a","b","c"," d "]
  'a=b&%20c=d'  => ["a","b"," c","d"]
  'a=b&%20c%20=d' => ["a","b"," c ","d"]
  'a=b&c=%20d%20' => ["a","b","c"," d "]
  'a&c=d'       => ["a","","c","d"]
  'a=b&=d'      => ["a","b","","d"]
  'a=b&='       => ["a","b","",""]
  '&'           => ["","","",""]
  '='           => ["",""]
  ''            => []

=head1 FUNCTION

=over 4

=item @param = parse_urlencoded($str:String)

parse C<$str> and return Array that contains key-value pairs.

=item $param:ArrayRef = parse_urlencoded_arrayref($str:String)

parse C<$str> and return ArrayRef that contains key-value pairs.

=item $string = build_urlencoded(@param)

=item $string = build_urlencoded(@param, $delim)

=item $string = build_urlencoded(\@param)

=item $string = build_urlencoded(\@param, $delim)

=item $string = build_urlencoded(\%param)

=item $string = build_urlencoded(\%param, $delim)

build urlencoded string from B<param>. build_urlencoded accepts arrayref and hashref values.

  build_urlencoded( foo => 1, foo => 2);
  build_urlencoded( foo => [1,2] );
  build_urlencoded( [ foo => 1, foo => 2 ] );
  build_urlencoded( [foo => [1,2]] );
  build_urlencoded( {foo => [1,2]} );

If C<$delim> parameter is passed, this function use it instead of using C<&>.

=item $string = build_urlencoded_utf8(...)

This function is almost same as C<build_urlencoded>. build_urlencoded_utf8 call C<utf8::encode> for all parameters.

=back

=head1 ENVIRONMENT VALUE

=over 4

=item * WWW_FORM_URLENCODED_PP

If true, WWW::Form::UrlEncoded force to load WWW::Form::UrlEncoded::PP.

=back

=head1 SEE ALSO

CPAN already has some application/x-www-form-urlencoded parser modules like these.

=over 4

=item L<URL::Encode>

=item L<URL::Encode::XS>

=item L<Text::QueryString>

=back

They does not fully compatible with WWW::Form::UrlEncoded. Handling of empty key-value
and supporting separator characters are different.

=head1 LICENSE

Copyright (C) Masahiro Nagano.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Masahiro Nagano E<lt>kazeburo@gmail.comE<gt>

=cut

