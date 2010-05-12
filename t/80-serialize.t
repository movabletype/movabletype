#!/usr/bin/perl

use strict;
use warnings;

use lib qw( t/lib lib extlib ../lib ../extlib );

use MT;
use MT::Test;
use Test::More;
use Data::Dumper;

require MT::Serialize;

if ($MT::Serialize::VERSION <= 2) {
  plan skip_all => "This test is for MT::Serialize v3 and higher; the current version is $MT::Serialize::VERSION";
}
else {
  plan tests => 100;
}

is($MT::Serialize::VERSION, 5, 'Default version is v5');

my %sers = map { $_ => MT::Serialize->new($_) } qw(MTJ JSON MT MT2 MTS Storable);

my $a = [1];
my $c = 3;
my $data1 = [1, {a => 'value-a', b => $a, c => ['array', $a, $c, 2], d => 1}, undef];
my $data2 = [1, {a => 'value-a', b => $a, c => ['array', $a, \$c, 2], d => 1}, undef];
$data2->[1]->{z} = $data2;

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent = 0;

# to use with JSON
my $dj = q![1,{'a'=>'value-a','b'=>[1],'c'=>['array',[1],3,2],'d'=>1},undef]!;

# to use for non-recursive structure
my $dn = q![1,{'a'=>'value-a','b'=>[1],'c'=>['array',$VAR1->[1]{'b'},3,2],'d'=>1},undef]!;

# to use for recursive structure
my $dd = sub {
    $_[0] eq q![1,{'a'=>'value-a','b'=>[1],'c'=>['array',$VAR1->[1]{'b'},\'3',2],'d'=>1,'z'=>$VAR1},undef]!
    || $_[0] eq q![1,{'a'=>'value-a','b'=>[1],'c'=>['array',$VAR1->[1]{'b'},\3,2],'d'=>1,'z'=>$VAR1},undef]!};

# serialize and deserialize, check the results
# compare structures with Data::Dumper
for my $label (keys %sers) {
  my $ser = $sers{$label};

  print "# Checking serialization for $label\n";
  my $json = ($label eq 'JSON' || $label eq 'MTJ');

  my $frozen = $ser->serialize( $json ? \$data1 : \$data2 );
  my $thawed = ${$ser->unserialize( $frozen )};

  is(ref $thawed, 'ARRAY', 'Returns correct type ARRAYREF');
  is(scalar @$thawed, 3, 'Returns array with 3 elements');
  is($thawed->[0], 1, 'Returns correct value in the array');
  ok(!defined $thawed->[-1], 'Last element is undef');
  is(ref $thawed->[1], 'HASH', 'Returns correct type HASHREF');
  is($thawed->[1]{a}, 'value-a', 'Returns correct value for HASH{a}'); 
  is(ref $thawed->[1]{b}, 'ARRAY', 'Returns correct value for HASH{b} 1/3'); 
  is($thawed->[1]{b}[0], 1, 'Returns correct value for HASH{b} 2/3'); 
  is(@{$thawed->[1]{b}}, 1, 'Returns correct value for HASH{b} 3/3'); 
  is(ref $thawed->[1]{c}, 'ARRAY', 'Returns correct value for HASH{c} 1/3'); 
  is(@{$thawed->[1]{c}}, 4, 'Returns correct value for HASH{c} 2/3'); 
  is($thawed->[1]{d}, 1, 'Returns correct value for HASH{d}'); 
  SKIP: {
    skip "JSON format doesn't support scalar and circular references" => 3 if $label eq 'MTJ' || $label eq 'JSON';
    is(${$thawed->[1]{c}[2]}, 3, 'Returns correct value for HASH{c} 3/3'); 
    is($thawed->[1]{z}, $thawed, 'Returns correct value for HASH{z} (circular ref)'); 
    is($thawed->[1]{b}, $thawed->[1]{c}[1], 'Returns correct value for HASH{b} == HASH{c}[1] (double ref)');
  }

  # fix stringified numbers for MT2
  if ($label eq 'MT2' || $label eq 'MT') {
    $_ += 0 for $thawed->[0], $thawed->[1]{b}[0], $thawed->[1]{c}[3], $thawed->[1]{d};
  }

  my $expected_dump_map = {
    MTJ => $dj,
    JSON => $dj,
    MT  => $dd,
    MT2  => $dd,
    MTS => $dd,
    Storable => $dd,
  };

  (my $dump = Dumper($thawed)) =~ s/^\$VAR1\s*=\s*|\s|;$//g; # remove spaces, $VAR and ; if any
  my $expect = $expected_dump_map->{$label};
  if ( ref $expect ) {
    ok( $expect->($dump), 'Returns the structure that matches Data::Dumper\'s' );
  }
  else {
    is($dump, $expect, 'Returns the structure that matches Data::Dumper\'s');
  }
}

for my $label (qw(MT2 MTJ MTS)) {
  # serialize with MT2/3, deserialize with MT
  next if !exists $sers{$label} || !exists $sers{MT};
  my $frozen = $sers{$label}->serialize( \$data1 );
  my $thawed = ${$sers{MT}->unserialize( $frozen )};

  # fix stringified numbers for MT2
  if ($label eq 'MT2' || $label eq 'MT') {
    $_ += 0 for $thawed->[0], $thawed->[1]{b}[0], $thawed->[1]{c}[2], $thawed->[1]{c}[3], $thawed->[1]{d};
  }

  (my $dump = Dumper($thawed)) =~ s/^\$VAR1\s*=\s*|\s|;$//g; # remove spaces, $VAR and ; if any
  is($dump, ($label eq 'MTJ' ? $dj : $dn), "Serialize with $label, deserialize with MT, which provides backward compatibility");
}

