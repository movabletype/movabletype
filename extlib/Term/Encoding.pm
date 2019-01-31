package Term::Encoding;

use strict;
our $VERSION = '0.02';

use base qw(Exporter);
our @EXPORT_OK = qw(term_encoding);

*term_encoding = \&get_encoding;

sub get_encoding {
    no warnings 'uninitialized';

    my($locale, $encoding);
    local $@;

    eval {
        # try I18N::Langinfo to get encoding from system
        require I18N::Langinfo;
        $encoding = I18N::Langinfo::langinfo(I18N::Langinfo::CODESET());
    };

    if ($^O eq 'MSWin32') {
        # if it's running on win32 ... try Win32::Console
        eval {
            require Win32::Console;
            $encoding = 'cp'.Win32::Console::OutputCP();
        };
    };

    # Still no luck ... use environment variables to get locale and encoding
    if (!$encoding) {
        foreach my $key (qw( LANGUAGE LC_ALL LC_MESSAGES LANG )) {
            $ENV{$key} =~ /^([^.]+)\.([^.:]+)/ or next;
            ($locale, $encoding) = ($1, $2);
            last;
        }
    }

    # deal with EUC asian variants
    if (defined $encoding &&
        lc($encoding) eq 'euc' &&
        defined $locale) {
        if ($locale =~ /^ja_JP|japan(?:ese)?$/i) {
            $encoding = 'euc-jp';
        } elsif ($locale =~ /^ko_KR|korean?$/i) {
            $encoding = 'euc-kr';
        } elsif ($locale =~ /^zh_CN|chin(?:a|ese)?$/i) {
            $encoding = 'euc-cn';
        } elsif ($locale =~ /^zh_TW|taiwan(?:ese)?$/i) {
            $encoding = 'euc-tw';
        }
    }

    return lc($encoding);
}

1;
__END__

=head1 NAME

Term::Encoding - Detect encoding of the current terminal

=head1 SYNOPSIS

  use Term::Encoding qw(term_encoding);
  my $encoding = term_encoding;

  # ditto without exporting function
  use Term::Encoding;
  my $encoding = Term::Encoding::get_encoding();

=head1 DESCRIPTION

Term::Encoding is a simple module to detect an encoding the current
terminal expects, in various ways.

=head1 AUTHORS

Tatsuhiko Miyagawa E<lt>miyagawa@bulknews.netE<gt>

Audrey Tang E<lt>audreyt@audreyt.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Locale::Maketext::Lexicon>

=cut
