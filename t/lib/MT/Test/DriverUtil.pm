package MT::Test::DriverUtil;

use strict;
use warnings;
use Exporter qw/import/;
use Time::Piece;
use Test::More;
use Test::Deep qw/eq_deeply/;

our @EXPORT = qw/
    make_objects are_objects is_object
    fix_ts reset_table_for
/;

sub make_objects {
    my @obj_data = @_;

    for my $data (@obj_data) {
        if ( my $wait = delete $data->{__wait} ) {
            sleep($wait);
        }
        my $class = delete $data->{__class};
        my $obj   = $class->new;
        $obj->set_values($data);
        $obj->save() or die "Could not save test Foo: ", $obj->errstr, "\n";
    }
}

sub _is_object {
    my ( $got, $expected, $name ) = @_;

    if ( !defined $got ) {
        fail($name);
        diag('    got undef, not an object');
        return;
    }

    if ( !$got->isa( ref $expected ) ) {
        fail($name);
        diag( '    got a ', ref($got), ' but expected a ', ref $expected );
        return;
    }

    if ( $got == $expected ) {
        fail($name);
        diag(
            '    got the exact same instance as expected, when really expected a different but equivalent object'
        );
        return;
    }

    # Ignore object columns that have undefined values.
    my ( %got_values, %expected_values );
    while ( my ( $field, $value ) = each %{ $expected->{column_values} } ) {
        $expected_values{$field} = $value if defined $value;
    }
    while ( my ( $field, $value ) = each %{ $got->{column_values} } ) {
        if (!exists $expected_values{$field}) {
            note "unexpected $field is ignored" if defined $value;
            next;
        }
        $got_values{$field} = $value if defined $value;
    }

    if ( !eq_deeply( \%got_values, \%expected_values ) ) {

        # 'Test' again so the helpful failure diagnostics are output.
        is_deeply( \%got_values, \%expected_values, $name );
        return;
    }

    return 1;
}

sub is_object {
    my ( $got, $expected, $name ) = @_;
    pass($name) if _is_object(@_);
}

sub are_objects {
    my ( $got, $expected, $name ) = @_;

    my $count = scalar @$expected;
    if ( $count != scalar @$got ) {
        fail($name);
        diag( '    got ', scalar(@$got), ' objects but expected ', $count );
        return;
    }

    for my $i ( 0 .. $count - 1 ) {
        return if !_is_object( $$got[$i], $$expected[$i], "$name (#$i)" );
    }
    pass($name);
}

sub fix_ts {
    my ( $ts, $diff ) = @_;

    # force to parse as GMT
    my $epoch = Time::Piece->strptime( $ts, '%Y%m%d%H%M%S%Z');
    Time::Piece->new( $epoch + $diff )->strftime('%Y%m%d%H%M%S');
}

sub reset_table_for {
    my @classes = @_;
    for my $class (@classes) {
        my $driver    = $class->dbi_driver;
        my $dbh       = $driver->rw_handle;
        my $ddl_class = $driver->dbd->ddl_class;

        $dbh->{pg_server_prepare} = 0
            if $ddl_class =~ m/Pg/;

        $dbh->do( $ddl_class->drop_table_sql($class) )
            or die $dbh->errstr
            if $driver->table_exists($class);
        $dbh->do( $ddl_class->create_table_sql($class) ) or die $dbh->errstr;
        $dbh->do($_)
            or die $dbh->errstr
            for $ddl_class->index_table_sql($class);
        $ddl_class->drop_sequence($class),
            $ddl_class->create_sequence($class);    # may do nothing
    }
}

1;
