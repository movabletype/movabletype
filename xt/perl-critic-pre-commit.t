use strict;
use warnings;
use Test::More;
use Git;
use Perl::Critic;
use Perl::Critic::Policy::Variables::ProhibitUnusedVariables;                 # To notify the module is needed
use Perl::Critic::Policy::ValuesAndExpressions::ProhibitDuplicateHashKeys;    # To notify the module is needed
use File::Spec;

plan skip_all => 'set MT_TEST_PERL_CRITIC_BEFORE_COMMIT to enable this test' unless $ENV{MT_TEST_PERL_CRITIC_BEFORE_COMMIT};

my $repo = Git->repository(Directory => '.');
my $root = $repo->command('rev-parse', '--show-toplevel');
chop($root);

my @files =
    grep { $_ =~ qr{\.(pm|pl|cgi)\z} && $_ !~ qr{^extlib} && $_ !~ qr{^mt-config.cgi\z} }
    map { (split(/\t/, $_, 2))[1]; } $repo->command('diff-index', '--cached', '--name-status', 'HEAD');

exit unless @files;

my $critic = Perl::Critic->new(-profile => '', -exclude => ['TestingAndDebugging::ProhibitNoStrict']);
$critic->add_policy(-policy => 'TestingAndDebugging::ProhibitNoStrict', -params => { allow => 'refs' });
$critic->add_policy(-policy => 'Variables::ProhibitUnusedVariables');
$critic->add_policy(-policy => 'ValuesAndExpressions::ProhibitDuplicateHashKeys');

print "Perl::Critic severe test\n";

my $abort;
for my $f (@files) {
    my $fullpath   = File::Spec->catfile($root, $f);
    my @violations = $critic->critique($fullpath);
    note sprintf('%s: %s', $f, $_->to_string) for @violations;
    ok !@violations, 'no violations for ' . $f;
    $abort ||= scalar @violations;
}

print("git commit aborting\n") if $abort;

done_testing();

=usage

cat << EOF > .git/hooks/pre-commit
#!/bin/sh
MT_TEST_PERL_CRITIC_BEFORE_COMMIT=1 perl xt/perl-critic-pre-commit.t
EOF
