use strict;
use warnings;
use 5.010;
use FindBin;
use lib "$FindBin::Bin/../t/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

plan skip_all => "set MT_TEST_MYSQL_DUMP to enable this test" unless $ENV{MT_TEST_MYSQL_DUMP};

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::PHP;
use MT::Test::Tag;
use JSON::PP;

load_dump($test_env, $ENV{MT_TEST_MYSQL_DUMP});
MT::Test::init_upgrade();

my $mt = MT->instance;

if (my $id = $ENV{MT_TEST_MYSQL_DUMP_TEMPLATE_ID}) {
    my $tmpl = $mt->model('template')->load({ id => $id });
    die 'wrong template_id' unless $tmpl;
    my $got = test_text($tmpl->text, $tmpl->blog_id);
    note '--- template start';
    note $tmpl->text;
    note '--- template end';
    note '--- result start';
    note $got;
    note '--- result end';
} else {
    my $iter = $mt->model('template')->load_iter({ type => 'index', build_type => 1 }, { sort => 'id' });
    while (my $tmpl = $iter->()) {
        subtest sprintf('ID:%d %s(%s)', $tmpl->id, $tmpl->name, $tmpl->outfile) => sub {
            my $got = test_text(Encode::encode_utf8($tmpl->text), $tmpl->blog_id);
            record($tmpl->id, $got);
        };
    }
}

done_testing;

sub test_text {
    my ($template, $blog_id) = @_;

    require MT::Util::UniqueID;
    my $log = $ENV{MT_TEST_PHP_ERROR_LOG_FILE_PATH}
        || File::Spec->catfile($ENV{MT_TEST_ROOT}, 'php-' . MT::Util::UniqueID::create_session_id() . '.log');
    my $got;
    if ($^O eq 'MSWin32' or $ENV{MT_TEST_NO_PHP_DAEMON}) {
        my $php_script = MT::Test::Tag::php_test_script(undef, $blog_id, $template, undef, $log, undef);
        $got = Encode::decode_utf8(MT::Test::PHP->run($php_script));
    } else {
        $got = Encode::decode_utf8(MT::Test::Tag::_php_daemon($template, $blog_id, undef, undef, $log));
    }
    is(MT::Test::Tag->_retrieve_php_logs($log), '', 'no php warnings');
    return $got;
}

sub load_dump {
    my ($env, $schema_file) = @_;

    my $schema = $env->slurp($schema_file) or return;

    my $dbh = $env->dbh;
    $dbh->begin_work;
    eval {
        for my $sql (split /;\n/s, $schema) {
            chomp $sql;
            next unless $sql;
            $dbh->do($sql);
        }
    };
    if ($@) {
        warn $@;
        $dbh->rollback;
        return;
    }
    $dbh->commit;

    # There found mysql dump without any pkeys for meta tables in real world use case.
    add_pkey($dbh);

    # for init_db
    require MT::Test;
    MT::Test->_load_classes;

    MT->instance->init_config_from_db;

    return 1;
}

sub add_pkey {
    my $dbh = shift;
    my @tables = qw(asset author awesome blog category cd comment entry profileevent tbping template);
    for my $class (@tables){
        eval {
            $dbh->do("ALTER TABLE mt_${class}_meta ADD PRIMARY KEY (${class}_meta_${class}_id, ${class}_meta_type);");
        };
    }
}

sub record {
    my ($id, $content) = @_;
    open(my $fh, '>', record_dir(). '/'. sprintf('%04d', $id). '.txt');
    print $fh Encode::encode_utf8($content);
    close($fh);
}

sub record_dir {
    state $dir = sprintf("%s/evidence/%s_%s", $FindBin::Bin, time, $FindBin::Script);
    unless (-d $dir) {
        File::Path::make_path($dir);
        open(my $fh, '>', $dir . '/' . 'README.txt');
        print $fh 'php version: ' . MT::Test::PHP->php_version . "\n";

        $test_env->_find_addons_and_plugins();
        print $fh 'plugins: ' . JSON::PP->new->pretty->canonical->utf8->encode($test_env->{addons_and_plugins});

        print $fh 'env: ' . JSON::PP->new->pretty->canonical->utf8->encode({ %ENV{ grep { /^MT_TEST_/ } keys %ENV } });

        close($fh);
    }
    return $dir;
}

__END__

=head1 SYNOPSIS

MT_TEST_IGNORE_PHP_DYNAMIC_PROPERTIES_WARNINGS=1 MT_TEST_MYSQL_DUMP=path/to/dump.sql prove -It/lib -v xt/php-real-usecase.t
MT_TEST_MYSQL_DUMP_TEMPLATE_ID=123 MT_TEST_IGNORE_PHP_DYNAMIC_PROPERTIES_WARNINGS=1 MT_TEST_MYSQL_DUMP=path/to/dump.sql prove -It/lib -v xt/php-real-usecase.t
