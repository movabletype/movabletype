# $Id$

use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use Test::More tests => 38;
use Cwd;
use MT;
use strict;

my $mt = MT->new;
use MT::Util::Archive;
my $tmp = MT->config->TempDir;
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

    my $arc = MT::Util::Archive->new($type, $file);
    ok($arc, "Empty $type archive created");
    
    is($arc->type, $type, 'Type is ' . $type);
    ok($arc->is($type), 'Type is ' . $type);
    ok(!$arc->is('txt'), 'Type is not txt');
    
    my $path = cwd();
    
    ok($arc->add_file($path, 'mt-config.cgi-original'), 'Add file');
    ok($arc->add_string($str, 'november.txt'), 'Added string');
    
    ok($arc->close, 'Archive created');
    
    my $ext = MT::Util::Archive->new($type, $file);
    ok($ext, 'Archive file read');
    $ext->close;
    
    open my $fh, '<', $file;
    $ext = MT::Util::Archive->new($type, $fh);
    ok($ext, 'Archive file read');
    
    my @files = $ext->files;
    is(@files, 2, 'Number of files is 2');
    is($files[0], 'mt-config.cgi-original', 'The name of the file 0 is correct');
    is($files[1], 'november.txt', 'The name of the file 1 is correct');
    
    ok($ext->extract($tmp), 'Extracted successfully');
    close $fh;
    
    my $file1 = File::Spec->catfile($tmp, $files[0]);
    my $file2 = File::Spec->catfile($tmp, $files[1]);
    
    open my $f1, '<', $file1;
    my $content1 = do { local $/; <$f1> };
    close $f1;
    open my $f2, '<', File::Spec->catfile(cwd(), 'mt-config.cgi-original');
    my $content2 = do { local $/; <$f2> };
    close $f2;
    is($content1, $content2, 'Contents are the same');
    
    open my $f3, '<', $file2;
    my $content3 = do { local $/; <$f3> };
    close $f3;
    is($content3, $str, 'Contents are the same');
    
    unlink $file1;
    unlink $file2;
    unlink $file if $type ne 'tgz';
}

## Tar (not tgz) test...

# Uncompress gunzip and create tar file

open my $file4, '<', $files{'tgz'};
bless $file4, 'IO::File';
require IO::Uncompress::Gunzip;
my $z = new IO::Uncompress::Gunzip $file4;
my $data = do { local $/; <$z> };
close $z;
close $file4;
open my $fileX, '>', $files{'tgz'} . '.tar';
print $fileX $data;
close $fileX;


# Run the tests
my $ext = MT::Util::Archive->new('tgz', $files{'tgz'} . '.tar');
ok($ext, 'Archive file read');

my @files = $ext->files;
is(@files, 2, 'Number of files is 2');
is($files[0], 'mt-config.cgi-original', 'The name of the file 0 is correct');
is($files[1], 'november.txt', 'The name of the file 1 is correct');

ok($ext->extract($tmp), 'Extracted successfully');
$ext->close;

my $file5 = File::Spec->catfile($tmp, $files[0]);
my $file6 = File::Spec->catfile($tmp, $files[1]);

open my $f5, '<', $file5;
my $content5 = do { local $/; <$f5> };
close $f5;
open my $f6, '<', File::Spec->catfile(cwd(), 'mt-config.cgi-original');
my $content6 = do { local $/; <$f6> };
close $f6;
is($content5, $content6, 'Contents are the same');

open my $f7, '<', $file6;
my $content7 = do { local $/; <$f7> };
close $f7;
is($content7, $str, 'Contents are the same');

unlink $file5;
unlink $file6;
unlink $files{'tgz'};
unlink $files{'tgz'} . '.tar';
