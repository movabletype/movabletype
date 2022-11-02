use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Log;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Upgrade;

$test_env->prepare_fixture('db');

my $mt        = MT->instance;
my $cfg       = MT->config;
my $cfg_class = MT->model('config');
my $log_class = MT->model('log');
my $admin     = MT->model('author')->load(1);
my $website   = MT::Test::Permission->make_website( name => 'my website', );
my $args      = { no_class => 1 };

sub create_filter {
    my ($items, $column_values) = @_;
    my $filter = MT->model('filter')->new(
        label     => 'Test',
        object_ds => 'log',
        author_id => $admin->id,
        blog_id   => 0,
        %{$column_values || {}},
    );
    $filter->items($items);
    $filter->save or die;
    $filter;
}

subtest 'Log level WARNING' => sub {
    # WARNING: 2 -> 3
    my $prev_log_level = 2;
    my $terms = {
        message => 'this is a warning message',
    };
    $mt->log({
        message  => $terms->{message},
        level    => $prev_log_level,
        class    => 'system',
    });
    $mt->log({
        message  => $terms->{message},
        level    => $prev_log_level,
        class    => $website->class,
        blog_id  => $website->id,
    });

    MT::Test::Upgrade->upgrade( from => 7.0045 );

    my $count = $log_class->count($terms, $args);
    is $count, 2;
    my $iter = $log_class->load_iter($terms, $args);
    while (my $log = $iter->()) {
        is $log->level, MT::Log::WARNING();
    }
};

subtest 'Log level SECURITY' => sub {
    # SECURITY: 8 -> 5
    my $prev_log_level = 8;
    my $terms = {
        message => 'this is a security message',
    };
    $mt->log({
        message  => $terms->{message},
        level    => $prev_log_level,
        class    => 'system',
    });
    $mt->log({
        message  => $terms->{message},
        level    => $prev_log_level,
        class    => $website->class,
        blog_id  => $website->id,
    });

    MT::Test::Upgrade->upgrade( from => 7.0045 );

    my $count = $log_class->count($terms, $args);
    is $count, 2;
    my $iter = $log_class->load_iter($terms, $args);
    while (my $log = $iter->()) {
        is $log->level, MT::Log::SECURITY();
    }
};

subtest 'Log level DEBUG' => sub {
    # DEBUG: 16 -> 0
    my $prev_log_level = 16;
    my $terms = {
        message => 'this is a debug message',
    };
    $mt->log({
        message  => $terms->{message},
        level    => $prev_log_level,
        class    => 'system',
    });
    $mt->log({
        message  => $terms->{message},
        level    => $prev_log_level,
        class    => $website->class,
        blog_id  => $website->id,
    });

    MT::Test::Upgrade->upgrade( from => 7.0045 );

    my $count = $log_class->count($terms, $args);
    is $count, 2;
    my $iter = $log_class->load_iter($terms, $args);
    while (my $log = $iter->()) {
        is $log->level, MT::Log::DEBUG();
    }
};

subtest 'filter' => sub {
    subtest 'should apply if 6.0025 or earlier' => sub {
        my %filters = map {
            $_ => create_filter([{type => "level", args => {value => $_}}]);
        } (1, 2, 4, 8, 16);

        MT::Test::Upgrade->upgrade( from => 6.0025 );
        $_->refresh for values %filters;

        is_deeply $filters{1}->items,  [{type => "level", args => {value => 1}}], 'preserved';
        is_deeply $filters{2}->items,  [{type => "level", args => {value => 3}}], 'migrated';
        is_deeply $filters{4}->items,  [{type => "level", args => {value => 4}}], 'preserved';
        is_deeply $filters{8}->items,  [{type => "level", args => {value => 5}}], 'migrated';
        is_deeply $filters{16}->items, [{type => "level", args => {value => 0}}], 'migrated';
    };

    subtest 'should apply if 7.x and 7.0049 or earlier' => sub {
        my %filters = map {
            $_ => create_filter([{type => "level", args => {value => $_}}]);
        } (1, 2, 4, 8, 16);

        MT::Test::Upgrade->upgrade( from => 7.0049 );
        $_->refresh for values %filters;

        is_deeply $filters{1}->items,  [{type => "level", args => {value => 1}}], 'preserved';
        is_deeply $filters{2}->items,  [{type => "level", args => {value => 3}}], 'migrated';
        is_deeply $filters{4}->items,  [{type => "level", args => {value => 4}}], 'preserved';
        is_deeply $filters{8}->items,  [{type => "level", args => {value => 5}}], 'migrated';
        is_deeply $filters{16}->items, [{type => "level", args => {value => 0}}], 'migrated';
    };

    subtest 'should not apply if 6.x and 6.0026 or later' => sub {
        my %filters = map {
            $_ => create_filter([{type => "level", args => {value => $_}}]);
        } (0, 1, 2, 3, 4, 5);

        MT::Test::Upgrade->upgrade( from => 6.0026 );
        $_->refresh for values %filters;

        for my $level (0, 1, 2, 3, 4, 5) {
            is_deeply $filters{$level}->items,  [{type => "level", args => {value => $level}}], 'preserved';
        }
    };

    subtest 'should not apply if 7.0050 or later' => sub {
        my %filters = map {
            $_ => create_filter([{type => "level", args => {value => $_}}]);
        } (0, 1, 2, 3, 4, 5);

        MT::Test::Upgrade->upgrade( from => 7.0050 );
        $_->refresh for values %filters;

        for my $level (0, 1, 2, 3, 4, 5) {
            is_deeply $filters{$level}->items,  [{type => "level", args => {value => $level}}], 'preserved';
        }
    };

    subtest 'should not apply if object_ds is not "log"' => sub {
        my %filters = map {
            $_ => create_filter([{type => "level", args => {value => $_}}], {object_ds => 'entry'});
        } (0, 1, 2, 3, 4, 5);

        MT::Test::Upgrade->upgrade( from => 7.0049 );
        $_->refresh for values %filters;

        for my $level (0, 1, 2, 3, 4, 5) {
            is_deeply $filters{$level}->items,  [{type => "level", args => {value => $level}}], 'preserved';
        }
    };
};

subtest 'condition' => sub {
    # WARNING: 2 -> 3

    subtest 'should apply if 6.0025 or earlier' => sub {
        my $log = $log_class->new( message => 'test', level => 2, class => 'system' );
        $log->save;
        MT::Test::Upgrade->upgrade( from => 6.0025 );
        is $log_class->load($log->id)->level, 3;
    };

    subtest 'should apply if 7.x and 7.0049 or earlier' => sub {
        my $log = $log_class->new( message => 'test', level => 2, class => 'system' );
        $log->save;
        MT::Test::Upgrade->upgrade( from => 7.0049 );
        is $log_class->load($log->id)->level, 3;
    };

    subtest 'should not apply if 6.x and 6.0026 or later' => sub {
        my $log = $log_class->new( message => 'test', level => 2, class => 'system' );
        $log->save;
        MT::Test::Upgrade->upgrade( from => 6.0026 );
        is $log_class->load($log->id)->level, 2;
    };

    subtest 'should not apply if 7.0050 or later' => sub {
        my $log = $log_class->new( message => 'test', level => 2, class => 'system' );
        $log->save;
        MT::Test::Upgrade->upgrade( from => 7.0050 );
        is $log_class->load($log->id)->level, 2;
    };
};

done_testing;
