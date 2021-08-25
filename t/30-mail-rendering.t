use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";    # t/lib
use Test::More;
use Test::SharedFork;
use MT::Test::Env;

our $test_env;
BEGIN {
    $test_env          = MT::Test::Env->new;
    $ENV{MT_CONFIG}    = $test_env->config_file;
    $ENV{MT_TEST_MAIL} = 1;
}

use MT::Test;
use MT;
use MT::Mail;
use utf8;
use Encode;
use Email::MIME;
use MIME::EncWords;

MT->instance;

subtest 'to' => sub {
    my @to   = ('test@localhost.localdomain', 'test2@localhost.localdomain');
    my $mail = MT::Mail->_render_mail({
            To => \@to,
        },
        'mail body'
    );
    note $mail;
    my $obj = Email::MIME->new($mail);
    is_deeply $obj->header('To') => join ', ', @to;
};

subtest 'subject' => sub {
    my $subject = 'テスト';
    my $mail    = MT::Mail->_render_mail({
            To      => 'test@localhost.localdomain',
            Subject => $subject,
        },
        'mail body'
    );
    note $mail;
    my $obj = Email::MIME->new($mail);
    is $obj->header('Subject') => $subject;
};

subtest 'encoded subject' => sub {
    my $subject = 'テスト';
    my $mail    = MT::Mail->_render_mail({
            To      => 'test@localhost.localdomain',
            Subject => MIME::EncWords::encode_mimeword(encode_utf8($subject), 'b', 'utf-8'),
        },
        'mail body'
    );
    note $mail;
    my $obj = Email::MIME->new($mail);
    is $obj->header('Subject') => $subject;
};

done_testing();
