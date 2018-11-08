package MT::Test::DDL;

# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

use strict;
use warnings;
use Data::Dumper;
use English qw( -no_watch_vars );

$OUTPUT_AUTOFLUSH = 1;

use Test::More;
use lib 't/lib';
use MT::Test;
use Test::Class;

package Ddltest;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            id           => 'integer not null auto_increment',
            string_25    => 'string(25)',
            string_25_nn => 'string(25) not null',
            string_255   => 'string(255)',
            string_1024  => 'string(1024)',
            int_bool     => 'boolean',
            int_bool_nn  => 'boolean not null',
            int_small    => 'smallint',
            int_small_nn => 'smallint not null',
            int_med      => 'integer',
            int_med_nn   => 'integer not null',
            int_big      => 'bigint',
            int_big_nn   => 'bigint not null',
            float        => 'float',
            float_nn     => 'float not null',
            text         => 'text',
            text_nn      => 'text not null',
            blob         => 'blob',
            blob_nn      => 'blob not null',
            datetime     => 'datetime',
            datetime_nn  => 'datetime not null',
        },
        indexes => {
            string_25_nn => 1,
            int_small_nn => 1,
            string_dt    => { columns => [qw( string_25 datetime_nn )], },
        },
        audit       => 1,
        datasource  => 'ddltest',
        primary_key => 'id',
        cacheable   => 0,
    }
);

package Ddltest::Multikey;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            fkey  => 'integer not null',
            type  => 'string(255) not null',
            value => 'string(1024)',
        },
        datasource  => 'multikey',
        primary_key => [qw( fkey type )],
        cacheable   => 0,
    }
);

package Ddltest::InvalidType;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            id  => 'integer not null auto_increment',
            boo => 'asfdasf',
        },
        datasource  => 'ddltest_invalidtype',
        primary_key => 'id',
        cacheable   => 0,
    }
);

package Ddltest::ShortIndex;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            id  => 'integer not null auto_increment',
            foo => 'string(25)',
            bar => 'string(25)',
        },
        indexes => {
            foo         => 1,
            short       => { columns => ['foo(10)'], },
            short_short => { columns => [qw( foo(10) bar(10) )], },
            short_multi => { columns => [qw( foo bar(10) )], },
        },
        datasource  => 'ddltest_shortindex',
        primary_key => 'id',
        cacheable   => 0,
    }
);

package Ddltest::Fixable;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            id  => 'integer not null auto_increment',
            foo => 'string(10)',
            bar => 'string(10)',
            baz => 'string(10)',
        },
        datasource  => 'ddltest_fixable',
        primary_key => 'id',
        cacheable   => 0,
    }
);

package Test::DDL;
use base qw( Test::Class MT::Test );
use Test::More;

sub startup : Test(startup) {
    my $self = shift;

    my $driver    = MT::Object->dbi_driver;
    my $dbh       = $driver->rw_handle;
    my $ddl_class = $driver->dbd->ddl_class;

    # The table may exist from a previous test, so delete it if it does.
    eval {
        if ( $driver->table_exists('Ddltest') ) {
            my $sql = $driver->dbd->ddl_class->drop_table_sql('Ddltest');
            $driver->rw_handle->do($sql);
        }
    };
}

sub _00_table_does_not_exist : Tests(3) {
    my $self = shift;

    my $driver    = MT::Object->dbi_driver;
    my $dbh       = $driver->rw_handle;
    my $ddl_class = $driver->dbd->ddl_class;

    ok( !$driver->table_exists('Ddltest'),
        'Ddltest table does not yet exist'
    );
    ok( !defined $ddl_class->column_defs('Ddltest'),
        'Ddltest table has no column defs'
    );

    # postgres might return an empty set of indexes, but I guess that's okay.
    my $index_defs = $ddl_class->index_defs('Ddltest');
    ok( !defined $index_defs || !%$index_defs,
        'Ddltest table has no index defs'
    );
}

sub _01_create_table : Tests(2) {
    my $self = shift;

    my $driver    = MT::Object->dbi_driver;
    my $dbh       = $driver->rw_handle;
    my $ddl_class = $driver->dbd->ddl_class;

    my $create_sql = $ddl_class->create_table_sql('Ddltest');
    ok( $create_sql, 'Create Table SQL for Ddltest is available' );
    my $res = $dbh->do($create_sql);
    ok( $res, 'Driver could perform Create Table SQL for Ddltest' );
    note( $dbh->errstr || $DBI::errstr ) if !$res;
}

sub _02_create_indexes : Tests(6) {
    my $self = shift;

    my $driver    = MT::Object->dbi_driver;
    my $dbh       = $driver->rw_handle;
    my $ddl_class = $driver->dbd->ddl_class;

    my @index_sql = $ddl_class->index_table_sql('Ddltest');
    ok( @index_sql, 'Index Table SQL for Ddltest is available' );
    is( scalar @index_sql, 3, 'Index Table SQL has three statements' );
    for my $index_sql (@index_sql) {
        my $res = $dbh->do($index_sql);
        ok( $res, 'Driver could perform Index Table SQL for Ddltest' );
        if ( !$res ) {
            note( $dbh->errstr || $DBI::errstr );
            note( 'SQL: ' . $index_sql );
        }
    }
}

sub _03_create_sequence : Tests(2) {
    my $self = shift;

    my $driver    = MT::Object->dbi_driver;
    my $dbh       = $driver->rw_handle;
    my $ddl_class = $driver->dbd->ddl_class;

    $ddl_class->create_sequence('Ddltest');
    pass('Created Ddltest sequence without dying');

    $ddl_class->drop_sequence('Ddltest');
    $ddl_class->create_sequence('Ddltest');
    pass('Recreated Ddltest sequence after drop without dying');
}

sub _def {
    my ( $not_null, $type, %param ) = @_;
    my $def = {
        not_null => $not_null,
        type     => $type,
        %param,
    };
    return $def;
}

sub is_def {
    my ( $got, $expected, $reason ) = @_;

    my $ddl_class = MT::Object->driver->dbd->ddl_class;
    my @fields;
    if ( $ddl_class =~ m/Pg/xms ) {
        @fields = qw( not_null key);
    }
    else {
        @fields = qw( not_null auto key);
    }

    for my $field (@fields) {
        if ( $expected->{$field} xor $got->{$field} ) {
            fail($reason);
            note(
                $expected->{$field}
                ? "Expected $field but didn't get it"
                : "Expected not $field but got it"
            );
            return;
        }
    }

    if ( !defined $got->{type} ) {
        fail($reason);
        note(
            "Expected MT data type ",
            $expected->{type},
            " but got no type at all"
        );
        return;
    }

    my $got_type      = $ddl_class->type2db($got);
    my $expected_type = $ddl_class->type2db($expected);
    if ( !defined $got_type || $expected_type ne $got_type ) {
        fail($reason);
        note( "Expected db data type ",
            $expected_type, " but got ", $got_type );
        return;
    }

    if ( defined $expected->{size} && $expected->{size} != $got->{size} ) {
        fail($reason);
        note( "Expected size ", $expected->{size}, " but got ",
            $got->{size} );
        return;
    }

    pass($reason);
}

sub class_defs : Tests(26) {
    my $defs = Ddltest->column_defs();
    ok( $defs, 'Ddltest class DDL settings are defined' );

    is_def(
        $defs->{id},
        _def( 1, 'integer', auto => 1, key => 1 ),
        'Ddltest id column def is correct'
    );

    is_def(
        $defs->{string_25},
        _def( 0, 'string', size => 25 ),
        'Ddltest string_25 column def is correct'
    );
    is_def(
        $defs->{string_25_nn},
        _def( 1, 'string', size => 25 ),
        'Ddltest string_25_nn column def is correct'
    );
    is_def(
        $defs->{string_255},
        _def( 0, 'string', size => 255 ),
        'Ddltest string_255 column def is correct'
    );
    is_def(
        $defs->{string_1024},
        _def( 0, 'string', size => 1024 ),
        'Ddltest string_1024 column def is correct'
    );

    is_def(
        $defs->{int_bool},
        _def( 0, 'boolean' ),
        'Ddltest int_bool column def is correct'
    );
    is_def(
        $defs->{int_bool_nn},
        _def( 1, 'boolean' ),
        'Ddltest int_bool_nn column def is correct'
    );
    is_def(
        $defs->{int_small},
        _def( 0, 'smallint' ),
        'Ddltest int_small column def is correct'
    );
    is_def(
        $defs->{int_small_nn},
        _def( 1, 'smallint' ),
        'Ddltest int_small_nn column def is correct'
    );
    is_def(
        $defs->{int_med},
        _def( 0, 'integer' ),
        'Ddltest int_med column def is correct'
    );
    is_def(
        $defs->{int_med_nn},
        _def( 1, 'integer' ),
        'Ddltest int_med_nn column def is correct'
    );
    is_def(
        $defs->{int_big},
        _def( 0, 'bigint' ),
        'Ddltest int_big column def is correct'
    );
    is_def(
        $defs->{int_big_nn},
        _def( 1, 'bigint' ),
        'Ddltest int_big_nn column def is correct'
    );
    is_def(
        $defs->{float},
        _def( 0, 'float' ),
        'Ddltest float column def is correct'
    );
    is_def(
        $defs->{float_nn},
        _def( 1, 'float' ),
        'Ddltest float_nn column def is correct'
    );
    is_def(
        $defs->{text},
        _def( 0, 'text' ),
        'Ddltest text column def is correct'
    );
    is_def(
        $defs->{text_nn},
        _def( 1, 'text' ),
        'Ddltest text_nn column def is correct'
    );
    is_def(
        $defs->{blob},
        _def( 0, 'blob' ),
        'Ddltest blob column def is correct'
    );
    is_def(
        $defs->{blob_nn},
        _def( 1, 'blob' ),
        'Ddltest blob_nn column def is correct'
    );
    is_def(
        $defs->{datetime},
        _def( 0, 'datetime' ),
        'Ddltest datetime column def is correct'
    );
    is_def(
        $defs->{datetime_nn},
        _def( 1, 'datetime' ),
        'Ddltest datetime_nn column def is correct'
    );

    # audit fields
    is_def(
        $defs->{created_on},
        _def( 0, 'datetime' ),
        'Ddltest created_on column def is correct'
    );
    is_def(
        $defs->{created_by},
        _def( 0, 'integer' ),
        'Ddltest created_by column def is correct'
    );
    is_def(
        $defs->{modified_on},
        _def( 0, 'datetime' ),
        'Ddltest modified_on column def is correct'
    );
    is_def(
        $defs->{modified_by},
        _def( 0, 'integer' ),
        'Ddltest modified_by column def is correct'
    );
}

sub table_defs : Tests(26) {
    my $defs = MT::Object->driver->dbd->ddl_class->column_defs('Ddltest');
    ok( $defs, 'Ddltest table DDL settings are defined' );

    is_def(
        $defs->{id},
        _def( 1, 'integer', auto => 1, key => 1 ),
        'Ddltest id column def is correct'
    );

    is_def(
        $defs->{string_25},
        _def( 0, 'string', size => 25 ),
        'Ddltest string_25 column def is correct'
    );
    is_def(
        $defs->{string_25_nn},
        _def( 1, 'string', size => 25 ),
        'Ddltest string_25_nn column def is correct'
    );
    is_def(
        $defs->{string_255},
        _def( 0, 'string', size => 255 ),
        'Ddltest string_255 column def is correct'
    );
    is_def(
        $defs->{string_1024},
        _def( 0, 'string', size => 1024 ),
        'Ddltest string_1024 column def is correct'
    );

    is_def(
        $defs->{int_bool},
        _def( 0, 'boolean' ),
        'Ddltest int_bool column def is correct'
    );
    is_def(
        $defs->{int_bool_nn},
        _def( 1, 'boolean' ),
        'Ddltest int_bool_nn column def is correct'
    );
    is_def(
        $defs->{int_small},
        _def( 0, 'smallint' ),
        'Ddltest int_small column def is correct'
    );
    is_def(
        $defs->{int_small_nn},
        _def( 1, 'smallint' ),
        'Ddltest int_small_nn column def is correct'
    );
    is_def(
        $defs->{int_med},
        _def( 0, 'integer' ),
        'Ddltest int_med column def is correct'
    );
    is_def(
        $defs->{int_med_nn},
        _def( 1, 'integer' ),
        'Ddltest int_med_nn column def is correct'
    );
    is_def(
        $defs->{int_big},
        _def( 0, 'bigint' ),
        'Ddltest int_big column def is correct'
    );
    is_def(
        $defs->{int_big_nn},
        _def( 1, 'bigint' ),
        'Ddltest int_big_nn column def is correct'
    );
    is_def(
        $defs->{float},
        _def( 0, 'float' ),
        'Ddltest float column def is correct'
    );
    is_def(
        $defs->{float_nn},
        _def( 1, 'float' ),
        'Ddltest float_nn column def is correct'
    );
    is_def(
        $defs->{text},
        _def( 0, 'text' ),
        'Ddltest text column def is correct'
    );
    is_def(
        $defs->{text_nn},
        _def( 1, 'text' ),
        'Ddltest text_nn column def is correct'
    );
    is_def(
        $defs->{blob},
        _def( 0, 'blob' ),
        'Ddltest blob column def is correct'
    );
    is_def(
        $defs->{blob_nn},
        _def( 1, 'blob' ),
        'Ddltest blob_nn column def is correct'
    );
    is_def(
        $defs->{datetime},
        _def( 0, 'datetime' ),
        'Ddltest datetime column def is correct'
    );
    is_def(
        $defs->{datetime_nn},
        _def( 1, 'datetime' ),
        'Ddltest datetime_nn column def is correct'
    );

    # audit fields
    is_def(
        $defs->{created_on},
        _def( 0, 'datetime' ),
        'Ddltest created_on column def is correct'
    );
    is_def(
        $defs->{created_by},
        _def( 0, 'integer' ),
        'Ddltest created_by column def is correct'
    );
    is_def(
        $defs->{modified_on},
        _def( 0, 'datetime' ),
        'Ddltest modified_on column def is correct'
    );
    is_def(
        $defs->{modified_by},
        _def( 0, 'integer' ),
        'Ddltest modified_by column def is correct'
    );
}

sub index_defs : Tests(5) {
    my $index_defs
        = MT::Object->driver->dbd->ddl_class->index_defs('Ddltest');
    ok( $index_defs, 'Ddltest table has index defs' );

    is( keys %$index_defs,           3, 'Ddltest table has three indexes' );
    is( $index_defs->{string_25_nn}, 1, 'Ddltest table has name index' );
    is( $index_defs->{int_small_nn}, 1, 'Ddltest table has status index' );
    is_deeply(
        $index_defs->{string_dt},
        { columns => [qw( string_25 datetime_nn )] },
        'Ddltest table has multi-column string_dt index'
    );
}

sub multikey_defs : Tests(8) {
    my $self = shift;

    my $class_defs = Ddltest::Multikey->column_defs();
    ok( $class_defs, 'Multikey class DDL settings are defined' );

    # TODO: multikeys aren't reported as keys.
    is_def(
        $class_defs->{fkey},
        _def( 1, 'integer', auto => 0, key => 0 ),
        'Multikey id column def is correct'
    );
    is_def(
        $class_defs->{type},
        _def( 1, 'string', size => 255, key => 0 ),
        'Multikey type column def is correct'
    );
    is_def(
        $class_defs->{value},
        _def( 0, 'string', size => 1024, key => 0 ),
        'Multikey value column def is correct'
    );

    $self->reset_table_for('Ddltest::Multikey');
    my $table_defs = MT::Object->driver->dbd->ddl_class->column_defs(
        'Ddltest::Multikey');
    ok( $table_defs, 'Multikey table DDL settings are defined' );

    is_def(
        $table_defs->{fkey},
        _def( 1, 'integer', auto => 0, key => 1 ),
        'Multikey id column def is correct'
    );
    is_def(
        $table_defs->{type},
        _def( 1, 'string', size => 255, key => 1 ),
        'Multikey type column def is correct'
    );
    is_def(
        $table_defs->{value},
        _def( 0, 'string', size => 1024 ),
        'Multikey value column def is correct'
    );
}

sub multikey_unique : Tests(1) {
    my $self = shift;
    $self->reset_table_for('Ddltest::Multikey');

    my $orig = Ddltest::Multikey->new();
    $orig->set_values(
        {   fkey  => 7,
            type  => 'awesome',
            value => 'these truths',
        }
    );
    $orig->save
        or die "Could not save original multikey instance: ", $orig->errstr;

    # Test empirically if the multifield primary key is uniquely constrained
    # by trying to insert another.
    my $driver = MT::Object->dbi_driver;
    my $dbh    = $driver->rw_handle;
    my $dbd    = $driver->dbd;

    my $table_name = Ddltest::Multikey->table_name;
    my $sql = join q{ }, 'INSERT INTO', $table_name, '(',
        join( q{, },
        map { $dbd->db_column_name( $table_name, $_ ) }
            qw( fkey type value ) ),
        ') VALUES (?, ?, ?)';
    my $ret
        = eval { $dbh->do( $sql, {}, 7, 'awesome', 'self-evident' ) ? 1 : 0 };
    my $err
        = $ret         ? q{}
        : defined $ret ? $dbh->errstr
        :                $@;
    ok( !$ret, q{Duplicate multikey instance wouldn't insert} );
    note( 'Saving error: ', $err ) if !$ret;
}

sub invalid_type : Tests(3) {
    my $self = shift;

    my $driver    = MT::Object->dbi_driver;
    my $dbh       = $driver->rw_handle;
    my $ddl_class = $driver->dbd->ddl_class;

    ok( !$driver->table_exists('Ddltest::InvalidType'),
        'Ddltest::InvalidType table does not yet exist'
    );
    ok( !defined $ddl_class->column_defs('Ddltest::InvalidType'),
        'Ddltest::InvalidType table has no column defs'
    );

    ok( !eval { $ddl_class->create_table_sql('Ddltest::InvalidType') },
        'Ddltest::InvalidType cannot make creation sql' );
}

sub short_index : Tests(4) {
    my $self = shift;

    my $ddl_class = MT::Object->driver->dbd->ddl_class;
SKIP: {
        skip( 'Only mysql supports shortened indexes', 4 )
            if $ddl_class !~ m{ mysql \z }xms;

        $self->reset_table_for('Ddltest::ShortIndex');

        my $index_defs = $ddl_class->index_defs('Ddltest::ShortIndex');
        is( $index_defs->{foo}, 1,
            'Class with short indexes can have regular indexes too' );
        is_deeply(
            $index_defs->{short},
            {   columns => ['foo'],
                sizes   => { foo => 10 },
            },
            'Class can have a single column with a shortened index'
        );
        is_deeply(
            $index_defs->{short_short},
            {   columns => [qw( foo bar )],
                sizes   => {
                    foo => 10,
                    bar => 10,
                },
            },
            'Class can have multiple shortened columns in an index'
        );
        is_deeply(
            $index_defs->{short_multi},
            {   columns => [qw( foo bar )],
                sizes   => { bar => 10, },
            },
            'Class can have mixed shortened and regular columns in an index'
        );
    }
}

sub fixable : Tests(12) {
    my $self = shift;

    my $driver    = MT::Object->dbi_driver;
    my $dbh       = $driver->rw_handle;
    my $ddl_class = $driver->dbd->ddl_class;

    $self->reset_table_for('Ddltest::Fixable');
    for my $i ( 1 .. 5 ) {
        my $obj = Ddltest::Fixable->new;
        $obj->foo($i);
        $obj->save
            or die "Could not add test Fixable record: " . $obj->errstr;
    }

    my $defs = $ddl_class->column_defs('Ddltest::Fixable');
    ok( $defs->{baz},
        'Ddltest::Fixable table has baz column after creation' );

    my @sql;
    my $res;

SKIP: {
        skip( "Driver cannot drop columns", 2 )
            unless $ddl_class->can_drop_column;
        @sql = $ddl_class->drop_column_sql( 'Ddltest::Fixable', 'baz' );
        ok( @sql, 'Ddltest::Fixable can have column dropping sql' );
    SQL: for my $sql (@sql) {
            $res = $dbh->do($sql);
            last SQL if !$res;
        }
        ok( $res, 'Ddltest::Fixable could have its column dropped' );
    }

    {
        local Ddltest::Fixable->properties->{column_defs}->{borf}
            = 'string(10)';
        @sql = $ddl_class->add_column_sql( 'Ddltest::Fixable', 'borf' );
        ok( @sql, 'Ddltest::Fixable can have column adding sql' );
    SQL: for my $sql (@sql) {
            $res = $dbh->do($sql);
            note( ( $dbh->errstr || $DBI::errstr ) . "( sql $sql)" ) if !$res;
            last SQL if !$res;
        }
        ok( $res, 'Ddltest::Fixable could have a column added' );
    }

    $defs = $ddl_class->column_defs('Ddltest::Fixable');
SKIP: {
        skip( "Driver cannot drop columns", 1 )
            unless $ddl_class->can_drop_column;
        ok( !$defs->{baz},
            'Ddltest::Fixable did indeed have a column dropped' );
    }
    ok( $defs->{borf}, 'Ddltest::Fixable did indeed have a column added' );

STMT: for my $stmt ( $ddl_class->fix_class('Ddltest::Fixable') ) {
        $res = $dbh->do($stmt);
        if ( !$res ) {
            note( $dbh->errstr || $DBI::errstr );
            last STMT;
        }
    }
    ok( $res,
        q{All Ddltest::Fixable's table-fixing statements were performed} );
    $defs = $ddl_class->column_defs('Ddltest::Fixable');
    ok( $defs->{baz},
        'Ddltest::Fixable regrew its dropped column after a fix_class' );
    ok( !$defs->{borf},
        'Ddltest::Fixable lost its extra column after a fix_class' );

    my @objs = Ddltest::Fixable->load();
    is( scalar @objs, 5, 'There are still 5 Ddltest::Fixable records' );
    is_deeply(
        [ sort map { $_->foo } @objs ],
        [ 1 .. 5 ],
        'Ddltest::Fixable records survived with values intact'
    );
}

sub _00_drop_table_test : Test(shutdown => 3) {
    my $self = shift;

    my $driver    = MT::Object->dbi_driver;
    my $dbh       = $driver->rw_handle;
    my $ddl_class = $driver->dbd->ddl_class;

    my $drop_sql = $ddl_class->drop_table_sql('Ddltest');
    ok( $drop_sql, 'Drop Table SQL for Ddltest is available' );
    my $res = $dbh->do($drop_sql);
    ok( $res, 'Driver could perform Drop Table SQL for Ddltest' );
    note( $dbh->errstr || $DBI::errstr ) if !$res;

    ok( !defined $ddl_class->column_defs('Ddltest'),
        'Ddltest table no longer exists' );
}

1;
