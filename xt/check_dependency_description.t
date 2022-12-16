use strict;
use warnings;
use Test::More;

plan skip_all => 'Skipping since dependencies no longer hardcorded on mt-check.cgi';

my $deps_from_mt_check = parse_mt_check();
my $deps_from_wizard   = parse_mt_app_wizard();

my %seen;
for my $dep (sort keys %$deps_from_mt_check) {
    if (!exists $deps_from_wizard->{$dep}) {
        next if $dep =~ /^DBD::/;
        fail "$dep not found in wizard";
    }
    is $deps_from_mt_check->{$dep}[0], $deps_from_wizard->{$dep}[0], "$dep translation is the same";
    is $deps_from_mt_check->{$dep}[1], $deps_from_wizard->{$dep}[1], "$dep version is the same";
    $seen{$dep} = 1;
}
for my $dep (sort keys %$deps_from_wizard) {
    next if $seen{$dep};
    if (!exists $deps_from_mt_check->{$dep}) {
        fail "$dep not found in mt-check";
        next;
    }
}

done_testing;

sub parse_mt_check {
    my $file = "mt-check.cgi";
    my $found;
    my $code = "sub get_deps_from_mt_check {\n";
    open my $fh, '<', $file or return;
    while(<$fh>) {
        if (/^my \@CORE_REQ =/) {
            $found = 1;
        }
        next unless $found;
        last if /^use Cwd;/;
        $code .= $_;
    }
    $code .= "return (\@CORE_REQ, \@CORE_DATA, \@CORE_OPT);}\n";
    $code .= 'sub translate {shift}';
    eval $code;
    my %deps;
    for my $dep (get_deps_from_mt_check()) {
        my ($name, $ver, $req, $desc) = @$dep;
        $deps{$name} = [$desc, $ver || 0];
    }
    return \%deps;
}

sub parse_mt_app_wizard {
    my $file = "lib/MT/App/Wizard.pm";
    my $found;
    my $code = "sub get_registry_from_wizard {\nreturn +{\n";
    open my $fh, '<', $file or return;
    while(<$fh>) {
        if (/^\s+\$core->\{registry\}\{applications\}\{wizard\} = \{/) {
            $found = 1;
            next;
        }
        next unless $found;
        $code .= $_;
        last if /^\}/;
    }
    eval $code;
    my %deps;
    my $reg = get_registry_from_wizard();
    for my $type (qw/optional_packages required_packages/) {
        for my $dep (keys %{$reg->{$type}}) {
            $deps{$dep} = [$reg->{$type}{$dep}{label}, $reg->{$type}{$dep}{version} || 0];
        }
    }
    return \%deps;
}