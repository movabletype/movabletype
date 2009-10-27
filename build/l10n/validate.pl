#!/usr/bin/perl
use strict;
use warnings;
use lib qw( lib extlib ../lib ../extlib );
use Getopt::Long;
use MT;
use Encode;

## options
my ( @components, @langs, $themes, $help, $verbose );
GetOptions(
    'components=s' => \@components,
    'langs=s'      => \@langs,
    'themes'       => \$themes,
    'help'         => \$help,
    'verbose'      => \$verbose,
);

if ( $help ) {
    print <<'HELP';
DESCRIPTION:
    check all l10n Lexicons has valid syntax for translation.

SYNOPSIS:
  $ ./build/l10n/validate.pl -c=core,enterprise -l=en_us,ja,de,fr

OPTIONS:
  -c, --components=COMP[,..]  specify commponent to validate.
                              by default, validate all installed components.
  -l, --langs=LANG[,...]      specify languages to validate.
                              by default, validate for en_us, ja, es, fr, de and nl.
  -t, --themes                if set to 1, load all installed theme components.
  -h, --help                  show help(this message).
  -v, --verbose               show error details.
HELP
    exit;
}

my $mt = MT->new;
if ( $themes ) {
    require MT::Theme;
    MT::Theme->load_all_themes;
}

@components = split(/,/, join(',', @components));
@components = map { $_->id } @MT::Components unless scalar @components;

@langs      = split(/,/, join(',', @langs ));
@langs = qw( en_us ja es fr de nl ) unless scalar @langs;

my $total_errors = 0;
my $total_phrases = 0;
COMPONENT:
for my $c_id ( @components ) {
    print "Component: $c_id\n";
    my $c = MT->component($c_id);
    if ( !$c ) {
        print "skipped component $c_id: Can't find component\n";
        next COMPONENT;
    }
 LANG:
    for my $lang_tag ( @langs ) {
        my $handle;
        eval { $handle = $c->_init_l10n_handle($lang_tag) };
        if ( $@ || !$handle ) {
            print "Skipped lang $lang_tag for component $c_id: Can't find language handle\n";
            next LANG;
        }
        my $mod = ref $handle;
        print "   $mod";
        MT->set_language($lang_tag);
        my $lexicon;
        {
            no strict 'refs';
            $lexicon = \%{$mod.'::Lexicon'};
        }
        my $i = 0;
        my $e = 0;
        my $msg = "\n";
        for my $key ( keys %$lexicon ) {
            local $!;
            local $@;
            my $val = $lexicon->{$key};
            $val = Encode::encode_utf8($val) if Encode::is_utf8($val);
            my $res;
            $c->error();
            eval { $res = $c->translate( $key, qw( 111 222 333 444 555 666 777 888 999 )) };
            if ( $@ || $! || !defined $res ) {
                $e++;
                $total_errors++;
                $res ||= '';
                $res = Encode::encode_utf8($res) if Encode::is_utf8($res);
                $msg .= <<"ERROR";
    +------------
    | phrase: $key
    |  trans: $val
ERROR
                $msg .= sprintf "    |   died: %s\n", $@ if $@;
                $msg .= sprintf "    | syserr: %s\n", $! if $!;
                $msg .= sprintf "    |  error: %s\n", $c->errstr if $c->errstr;
            }
            $i++;
            $total_phrases++;
        }
        if ( $e ) {
            print "$msg    +------------\n    " if $verbose;
            print "    Found $e errors in $i phrases...\n";
            print "\n" if $verbose;
        }
        else {
            print "    $i phrases. --- OK\n";
        }
    }
}
print "TOTAL: $total_errors errors in $total_phrases phrases...\n";
