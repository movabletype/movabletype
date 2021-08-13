# $Id: 14-archive.t 2562 2008-06-12 05:12:23Z bchoate $

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    eval { require File::Which; 1 } or plan skip_all => 'requires File::Which';
    $test_env = MT::Test::Env->new(
        BinTarPath   => File::Which::which('tar')   || '',
        BinZipPath   => File::Which::which('zip')   || '',
        BinUnzipPath => File::Which::which('unzip') || '',
        TempDir      => 'TEST_ROOT/tmp',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use Cwd;
use MT;
use MT::Test;

my $mt = MT->new;
use MT::Util::Archive;
my $tmp   = $test_env->root;
my %files = (
    'zip' => File::Spec->catfile($tmp, 'test1.zip'),
    'tgz' => File::Spec->catfile($tmp, 'test1.tar.gz'),
);

my $str = <<TXT;
When I look into your eyes, I can see the love restrained.
But darling when I hold you, don't you know I feel the same.
Nothing lasts forever, and we both know hearts can change.
And it's hard to hold a candle, in the cold november rain.
TXT

my $arc = MT::Util::Archive->new('txt', $files{'zip'});
is($arc, undef, 'Type not registered');

for my $type (qw( zip tgz )) {
    my $file = $files{$type};

    for my $use_bin (0, 1) {
        MT->config->UseExternalArchiver($use_bin, 1);

        unlink $file if -e $file;
        my $arc = MT::Util::Archive->new($type, $file);
    SKIP: {
            skip "type $type (bin: $use_bin) test: " . MT::Util::Archive->errstr, 1 unless $arc;
            if ($use_bin && !$arc->find_bin) {
                skip "type $type (bin: $use_bin) test: no external $type";
            }
            subtest "type $type (bin: $use_bin) test" => sub {
                ok($arc, "Empty $type archive created");

                is($arc->type, $type, 'Type is ' . $type);
                ok($arc->is($type),  'Type is ' . $type);
                ok(!$arc->is('txt'), 'Type is not txt');

                my $path = cwd();

                ok(
                    $arc->add_file($path, 'mt-config.cgi-original'),
                    'Add file'
                ) or note $arc->errstr;
                ok($arc->add_string($str, 'november.txt'), 'Added string') or $arc->errstr;

                ok($arc->close, 'Archive created') or note $arc->errstr;
                my $size = -s $file;
                ok -f $file && $size, "$file: $size";

                my $ext = MT::Util::Archive->new($type, $file);
                ok($ext, 'Archive file read') or note MT::Util::Archive->errstr;
                $ext->close;

                open my $fh, '<:raw', $file;
                $ext = MT::Util::Archive->new($type, $fh);
                ok($ext, 'Archive file read') or note MT::Util::Archive->errstr;

                my @files = $ext->files;
                note explain \@files;
                is(@files, 2, 'Number of files is 2');
                is(
                    $files[0], 'mt-config.cgi-original',
                    'The name of the file 0 is correct'
                );
                is(
                    $files[1], 'november.txt',
                    'The name of the file 1 is correct'
                );

                ok($ext->extract($tmp), 'Extracted successfully');
                close $fh;

                my $file1 = File::Spec->catfile($tmp, $files[0]);
                my $file2 = File::Spec->catfile($tmp, $files[1]);

                open my $f1, '<:raw', $file1;
                my $content1 = do { local $/; <$f1> };
                close $f1;
                open my $f2, '<:raw', File::Spec->catfile(cwd(), 'mt-config.cgi-original');
                my $content2 = do { local $/; <$f2> };
                close $f2;
                is($content1, $content2, 'Contents are the same');

                open my $f3, '<:raw', $file2;
                my $content3 = do { local $/; <$f3> };
                close $f3;
                is($content3, $str, 'Contents are the same');

                unlink $file1;
                unlink $file2;

                if ($type eq 'tgz') {
                    ## Tar (not tgz) test...
                    note "testing .tar";

                    # Uncompress gunzip and create tar file

                    open my $file4, '<:raw', $files{'tgz'};
                    bless $file4, 'IO::File';
                    require IO::Uncompress::Gunzip;
                    my $z    = new IO::Uncompress::Gunzip $file4;
                    my $data = do { local $/; <$z> };
                    close $z;
                    close $file4;
                    open my $fileX, '>:raw', $files{'tgz'} . '.tar';
                    print $fileX $data;
                    close $fileX;

                    # Run the tests
                    my $ext = MT::Util::Archive->new('tgz', $files{'tgz'} . '.tar');
                    ok($ext, 'Archive file read');

                    my @files = $ext->files;
                    is(@files, 2, 'Number of files is 2');
                    is(
                        $files[0], 'mt-config.cgi-original',
                        'The name of the file 0 is correct'
                    );
                    is($files[1], 'november.txt', 'The name of the file 1 is correct');

                    ok($ext->extract($tmp), 'Extracted successfully');
                    $ext->close;

                    my $file5 = File::Spec->catfile($tmp, $files[0]);
                    my $file6 = File::Spec->catfile($tmp, $files[1]);

                    open my $f5, '<:raw', $file5;
                    my $content5 = do { local $/; <$f5> };
                    close $f5;
                    open my $f6, '<:raw', File::Spec->catfile(cwd(), 'mt-config.cgi-original');
                    my $content6 = do { local $/; <$f6> };
                    close $f6;
                    is($content5, $content6, 'Contents are the same');

                    open my $f7, '<:raw', $file6;
                    my $content7 = do { local $/; <$f7> };
                    close $f7;
                    is($content7, $str, 'Contents are the same');

                    unlink $file5;
                    unlink $file6;
                    unlink $files{'tgz'};
                    unlink $files{'tgz'} . '.tar';
                }
                unlink $file;
            };
        }
    }
}

my $left;
opendir my $dh, MT->config->TempDir;
while(my $item = readdir $dh) {
    $left++ if $item =~ /^mt_/;
}
ok !$left, "temporary files should be all gone";

done_testing;
