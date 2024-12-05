use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Fixture::ArchiveType;
use File::Find;
use File::Path;

my $mt = MT->instance;

$test_env->prepare_fixture('archive_type');

my $objs    = MT::Test::Fixture::ArchiveType->load_objs;
my $site    = $objs->{website}{site_for_archive_test};
my $site_id = $site->id;

my @archive_types = MT->publisher->archive_types;

my @tmpls = MT::Template->load({ blog_id => $site_id, type => [qw(individual page archive ct ct_archive)] });
for my $tmpl (@tmpls) {
    my $ct_id = $tmpl->content_type_id;
    my $text  = qq{ArchiveType returns '<MTArchiveType>'\n\n};
    for my $archive_type (@archive_types) {
        if ($ct_id && $archive_type =~ /ContentType/) {
            $text .= qq{<MTIfArchiveType archive_type="$archive_type" content_type="$ct_id">This is truly $archive_type.</MTIfArchiveType>\n};
        } else {
            $text .= qq{<MTIfArchiveType archive_type="$archive_type">This is truly $archive_type.</MTIfArchiveType>\n};
        }
    }
    $tmpl->text($text);
    $tmpl->save;
}

my $site_path = $site->site_path;
rmtree($site_path);
MT::FileInfo->remove;
$test_env->clear_mt_cache;

MT->publisher->rebuild(BlogID => $site_id);

my %seen = map { $_ => 0 } @archive_types;
find({
        wanted => sub {
            my $file = $File::Find::name;
            return if -d $file;
            my $body = do { open my $fh, '<', $file; local $/; <$fh> };
            ok my ($expected) = $body =~ /ArchiveType returns '([^']+)'/, "file $file has something expected";
            if ($expected) {
                like $body => qr/This is truly $expected/, "is truly what is expected";
                $seen{$expected} = 1;
            } else {
                note "$file: $body";
            }
        },
        no_chdir => 1,
    },
    $site_path,
);

my @not_seen = grep { !$seen{$_} } sort keys %seen;
ok !@not_seen, "All the archive types are seen" or note explain \%seen;

done_testing;
