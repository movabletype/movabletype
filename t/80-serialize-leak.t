#!/usr/bin/perl

use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT;
use MT::Test;
use constant HAS_LEAKTRACE => eval { require Test::LeakTrace };
use Test::More HAS_LEAKTRACE
    ? ( tests => 12 )
    : ( skip_all => 'require Test::LeakTrace' );
use Test::LeakTrace;

require MT::Serialize;
my %sers
    = map { $_ => MT::Serialize->new($_) } qw(MTJ JSON MT MT2 MTS Storable);

my $a     = [1];
my $c     = 3;
my $data1 = [
    1, { a => 'value-a', b => $a, c => [ 'array', $a, $c, 2 ], d => 1 }, undef
];
my $data2 = [
    1, { a => 'value-a', b => $a, c => [ 'array', $a, \$c, 2 ], d => 1 },
    undef
];
$data2->[1]->{z} = $data2;

for my $label ( keys %sers ) {
    my $ser = $sers{$label};
    note "Checking leaks for $label\n";

    # Call it once outside of leak check to make sure we load the serialization backend
    $ser->serialize( \$data1 );

    no_leaks_ok {
        my $frozen = $ser->serialize( \$data1 );
        my $thawed = ${ $ser->unserialize($frozen) };
    }
    "$label: No leaks with no circular data";

    # JSON format would die because they doesn't support circular reference
    if ( $label eq 'MTJ' || $label eq 'JSON' ) {
        eval {
            my $frozen = $ser->serialize( \$data2 );
            my $thawed = ${ $ser->unserialize($frozen) };
        };
        like(
            $@,
            qr/cannot encode reference to scalar/,
            "$label doesn't support circular reference"
        );
    }
    else {
        leaks_cmp_ok {
            my $frozen = $ser->serialize( \$data2 );
            my $thawed = ${ $ser->unserialize($frozen) };
        }
        '<', 20, "$label: leak with circular data";
    }
}
#!/usr/bin/perl

use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT;
use MT::Test;
use constant HAS_LEAKTRACE => eval { require Test::LeakTrace };
use Test::More HAS_LEAKTRACE
    ? ( tests => 12 )
    : ( skip_all => 'require Test::LeakTrace' );
use Test::LeakTrace;

require MT::Serialize;
my %sers
    = map { $_ => MT::Serialize->new($_) } qw(MTJ JSON MT MT2 MTS Storable);

my $a     = [1];
my $c     = 3;
my $data1 = [
    1, { a => 'value-a', b => $a, c => [ 'array', $a, $c, 2 ], d => 1 }, undef
];
my $data2 = [
    1, { a => 'value-a', b => $a, c => [ 'array', $a, \$c, 2 ], d => 1 },
    undef
];
$data2->[1]->{z} = $data2;

for my $label ( keys %sers ) {
    my $ser = $sers{$label};
    note "Checking leaks for $label\n";

    # Call it once outside of leak check to make sure we load the serialization backend
    $ser->serialize( \$data1 );

    no_leaks_ok {
        my $frozen = $ser->serialize( \$data1 );
        my $thawed = ${ $ser->unserialize($frozen) };
    }
    "$label: No leaks with no circular data";

    # JSON format would die because they doesn't support circular reference
    if ( $label eq 'MTJ' || $label eq 'JSON' ) {
        eval {
            my $frozen = $ser->serialize( \$data2 );
            my $thawed = ${ $ser->unserialize($frozen) };
        };
        like(
            $@,
            qr/cannot encode reference to scalar/,
            "$label doesn't support circular reference"
        );
    }
    else {
        leaks_cmp_ok {
            my $frozen = $ser->serialize( \$data2 );
            my $thawed = ${ $ser->unserialize($frozen) };
        }
        '<', 20, "$label: leak with circular data";
    }
}
#!/usr/bin/perl

use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT;
use MT::Test;
use constant HAS_LEAKTRACE => eval { require Test::LeakTrace };
use Test::More HAS_LEAKTRACE
    ? ( tests => 12 )
    : ( skip_all => 'require Test::LeakTrace' );
use Test::LeakTrace;

require MT::Serialize;
my %sers
    = map { $_ => MT::Serialize->new($_) } qw(MTJ JSON MT MT2 MTS Storable);

my $a     = [1];
my $c     = 3;
my $data1 = [
    1, { a => 'value-a', b => $a, c => [ 'array', $a, $c, 2 ], d => 1 }, undef
];
my $data2 = [
    1, { a => 'value-a', b => $a, c => [ 'array', $a, \$c, 2 ], d => 1 },
    undef
];
$data2->[1]->{z} = $data2;

for my $label ( keys %sers ) {
    my $ser = $sers{$label};
    note "Checking leaks for $label\n";

    # Call it once outside of leak check to make sure we load the serialization backend
    $ser->serialize( \$data1 );

    no_leaks_ok {
        my $frozen = $ser->serialize( \$data1 );
        my $thawed = ${ $ser->unserialize($frozen) };
    }
    "$label: No leaks with no circular data";

    # JSON format would die because they doesn't support circular reference
    if ( $label eq 'MTJ' || $label eq 'JSON' ) {
        eval {
            my $frozen = $ser->serialize( \$data2 );
            my $thawed = ${ $ser->unserialize($frozen) };
        };
        like(
            $@,
            qr/cannot encode reference to scalar/,
            "$label doesn't support circular reference"
        );
    }
    else {
        leaks_cmp_ok {
            my $frozen = $ser->serialize( \$data2 );
            my $thawed = ${ $ser->unserialize($frozen) };
        }
        '<', 20, "$label: leak with circular data";
    }
}
#!/usr/bin/perl

use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT;
use MT::Test;
use constant HAS_LEAKTRACE => eval { require Test::LeakTrace };
use Test::More HAS_LEAKTRACE
    ? ( tests => 12 )
    : ( skip_all => 'require Test::LeakTrace' );
use Test::LeakTrace;

require MT::Serialize;
my %sers
    = map { $_ => MT::Serialize->new($_) } qw(MTJ JSON MT MT2 MTS Storable);

my $a     = [1];
my $c     = 3;
my $data1 = [
    1, { a => 'value-a', b => $a, c => [ 'array', $a, $c, 2 ], d => 1 }, undef
];
my $data2 = [
    1, { a => 'value-a', b => $a, c => [ 'array', $a, \$c, 2 ], d => 1 },
    undef
];
$data2->[1]->{z} = $data2;

for my $label ( keys %sers ) {
    my $ser = $sers{$label};
    note "Checking leaks for $label\n";

    # Call it once outside of leak check to make sure we load the serialization backend
    $ser->serialize( \$data1 );

    no_leaks_ok {
        my $frozen = $ser->serialize( \$data1 );
        my $thawed = ${ $ser->unserialize($frozen) };
    }
    "$label: No leaks with no circular data";

    # JSON format would die because they doesn't support circular reference
    if ( $label eq 'MTJ' || $label eq 'JSON' ) {
        eval {
            my $frozen = $ser->serialize( \$data2 );
            my $thawed = ${ $ser->unserialize($frozen) };
        };
        like(
            $@,
            qr/cannot encode reference to scalar/,
            "$label doesn't support circular reference"
        );
    }
    else {
        leaks_cmp_ok {
            my $frozen = $ser->serialize( \$data2 );
            my $thawed = ${ $ser->unserialize($frozen) };
        }
        '<', 20, "$label: leak with circular data";
    }
}
