use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
use utf8;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;
use MT::Test::PHP;
use MT::Test::Permission;
use MT::Util qw(ts2epoch epoch2ts);
use MT::Util::Captcha;

$test_env->prepare_fixture('db_data');

my $switch = MT->config->PluginSwitch;
$switch->{Awesome} = 1;
MT->config->PluginSwitch($switch, 1);
MT->config->save_config;

my $server_path = MT->instance->server_path;
$server_path =~ s|\\|/|g if $^O eq 'MSWin32';

my $blog = MT::Blog->load(1);
$blog->captcha_provider('mt_default');
$blog->save;

my $asset = MT::Asset->load(1);
my ($year, $month) = unpack 'A4A2', $asset->created_on;

# entry we want to capture is dated: 19780131074500
my $tsdiff = time - ts2epoch($blog, '19780131074500');
my $daysdiff = int($tsdiff / (60 * 60 * 24));

my $asset3 = MT::Asset->load(3);

my $modified_by = MT::Test::Permission->make_author(
    name             => 'Foo Bar',
    nickname         => 'foobar',
    email            => 'foobar@localhost',
    url              => 'https://foobar.com',
    userpic_asset_id => $asset3->id,
);

# use driver directly not to auto-update modified_at
MT::Entry->driver->rw_handle->do('UPDATE mt_entry SET entry_modified_by = ?', undef, $modified_by->id);
$test_env->clear_mt_cache;

my $php_supports_gd = MT::Test::PHP->supports_gd;
MT::Test::Tag->vars->{no_php_gd} = !$php_supports_gd;

my %vars = (
    CFG_FILE => MT->instance->{cfg_file},
    VERSION_ID => MT->instance->version_id,
    CURRENT_WORKING_DIRECTORY => $server_path,
    DAYS_CONSTANT1 => $daysdiff + 2,
    DAYS_CONSTANT2 => $daysdiff - 1,
    CURRENT_YEAR => $year,
    CURRENT_MONTH => $month,
    STATIC_FILE_PATH => MT->instance->static_file_path . '/',
    THREE_DAYS_AGO => epoch2ts($blog, time() - int(3.5 * 86400)),
    TEST_ROOT => $test_env->root,
    NO_CAPTCHA => MT::Util::Captcha->check_availability // '',
);

sub var {
    for my $line (@_) {
        for my $key ( keys %vars ) {
            my $value = $vars{$key};
            $line =~ s/$key/$value/g;
        }
    }
    @_;
}

filters {
    skip         => [qw( var chomp )],
    template     => [qw( var )],
    expected     => [qw( var )],
    expected_php => [qw( var )],
};

sub fix_path { File::Spec->canonpath(shift) }

my $blog_id = 1;

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

done_testing;

__DATA__

=== test 1
--- template

--- expected


=== test 2
--- template
<MTCGIPath>
--- expected
http://narnia.na/cgi-bin/

=== test 3
--- template
<MTCGIRelativeURL>
--- expected
/cgi-bin/

=== test 4
--- template
<MTStaticWebPath>
--- expected
http://narnia.na/mt-static/

=== test 5
--- template
<MTCommentScript>
--- expected
mt-comments.cgi

=== test 6
--- template
<MTTrackbackScript>
--- expected
mt-tb.cgi

=== test 7
--- template
<MTSearchScript>
--- expected
mt-search.cgi

=== test 9
--- template
<MTEntries lastn='1'><MTEntryDate></MTEntries>
--- expected
January 31, 1978  7:45 AM

=== test 10
--- template
<MTEntries lastn='1'><MTEntryDate utc="1"></MTEntries>
--- expected
January 31, 1978 11:15 AM

=== test 11
--- template
<MTEntries lastn='1'><MTEntryDate format_name=""></MTEntries>
--- expected
January 31, 1978  7:45 AM

=== test 12
--- template
<MTEntries lastn='1'><MTEntryDate format="%Y-%m-%dT%H:%M:%S"></MTEntries>
--- expected
1978-01-31T07:45:00

=== test 13
--- template
<MTEntries lastn='1'><MTEntryDate language="ja"></MTEntries>
--- expected
1978年1月31日 07:45

=== test 14
--- template
<MTPublishCharset lower_case='1'>
--- expected
utf-8

=== test 15
--- template
<MTIfNonEmpty tag="MTDate">nonempty</MTIfNonEmpty>
--- expected
nonempty

=== test 16
--- template

--- expected


=== test 17
--- template
<MTIfNonZero tag="MTBlogEntryCount">nonzero</MTIfNonZero>
--- expected
nonzero

=== test 21
--- template
<MTBlogs><MTBlogID></MTBlogs>
--- expected
1

=== test 22
--- template
<MTBlogs><MTBlogName></MTBlogs>
--- expected
None

=== test 23
--- template
<MTBlogs><MTBlogDescription></MTBlogs>
--- expected
Narnia None Test Blog

=== test 24
--- template
<MTBlogs><MTBlogURL></MTBlogs>
--- expected
http://narnia.na/nana/

=== test 25
--- template
<MTBlogs><MTBlogArchiveURL></MTBlogs>
--- expected
http://narnia.na/nana/archives/

=== test 26
--- template
<MTBlogs><MTBlogRelativeURL></MTBlogs>
--- expected
/nana/

=== test 27
--- template
<MTBlogs><MTBlogSitePath></MTBlogs>
--- expected
TEST_ROOT/site/

=== test 28
--- template
<MTBlogs><MTBlogHost></MTBlogs>
--- expected
narnia.na

=== test 29
--- template
<MTBlogs><MTBlogHost exclude_port="1"></MTBlogs>
--- expected
narnia.na

=== test 30
--- template
<MTBlogs><MTBlogTimezone></MTBlogs>
--- expected
-03:30

=== test 31
--- template
<MTBlogs><MTBlogTimezone no_colon="1"></MTBlogs>
--- expected
-0330

=== test 32
--- template
<MTBlogs><MTBlogEntryCount></MTBlogs>
--- expected
6

=== test 35
--- template
<MTArchiveList archive_type="Monthly"><MTArchiveListHeader>(Header)</MTArchiveListHeader><MTArchiveListFooter>(Footer)</MTArchiveListFooter><MTArchiveTitle>|</MTArchiveList>
--- expected
(Header)January 1978|January 1965|January 1964|January 1963|January 1962|(Footer)January 1961|

=== test 35-2 mt:CalendarDate
--- template
<MTArchiveList archive_type="Monthly"><$mt:CalendarDate format="%Y/%m"$>|</MTArchiveList>
--- expected
1978/01|1965/01|1964/01|1963/01|1962/01|1961/01|

=== test 36
--- template
[<MTEntries lastn="10"> * <MTEntryTitle></MTEntries>]
--- expected
[ * A Rainy Day * Verse 5 * Verse 4 * Verse 3 * Verse 2 * Verse 1]

=== test 37
--- template
<MTInclude module="blog-name">
--- expected
None

=== test 38
--- template
<MTInclude module="blog-name">
--- expected
None

=== test 39
--- template
<MTEntries lastn='1'><MTLink entry_id="1"></MTEntries>
--- expected
http://narnia.na/nana/archives/1978/01/a-rainy-day.html

=== test 40
--- template
<MTLink template="Main Index">
--- expected
http://narnia.na/nana/

=== test 41
--- template
<MTVersion>
--- expected
VERSION_ID

=== test 42
--- template
<MTDefaultLanguage>
--- expected
en_US

=== test 43
--- SKIP
--- template
<MTSignOnURL>
--- expected
https://www.typekey.com/t/typekey/login?

=== test 44
--- SKIP
--- template
<MTErrorMessage>
--- expected


=== test 45
--- template
<MTSetVar name="x" value="x-var"><MTGetVar name="x">
--- expected
x-var

=== test 46
--- template
<MTBlogLanguage>
--- expected
en_us

=== test 51
--- template
<MTEntries category="foo"><MTEntryTitle></MTEntries>
--- expected
Verse 3

=== test 52
--- template
<MTEntries author="Bob D"><MTEntryTitle></MTEntries>
--- expected
Verse 3

=== test 53
--- template
<MTEntries days="DAYS_CONSTANT1"><MTEntryTitle></MTEntries>
--- expected
A Rainy Day

=== test 54
--- template
<MTEntries days="DAYS_CONSTANT2"><MTEntryTitle></MTEntries>
--- expected


=== test 55
--- template
<MTEntries lastn="1"><MTEntryBody></MTEntries>
--- expected
<p>On a drizzly day last weekend,</p>

=== test 56
--- template
<MTEntries lastn="1"><MTEntryMore></MTEntries>
--- expected
<p>I took my grandpa for a walk.</p>

=== test 57
--- template
<MTEntries lastn="1"><MTEntryStatus></MTEntries>
--- expected
Publish

=== test 58
--- template
<MTEntries lastn="1"><MTEntryDate></MTEntries>
--- expected
January 31, 1978  7:45 AM

=== test 59
--- template
<MTEntries lastn="1"><MTEntryFlag flag="allow_pings"></MTEntries>
--- expected
1

=== test 60
--- template
<MTEntries lastn="1"><MTEntryExcerpt></MTEntries>
--- expected
A story of a stroll.

=== test 61
--- template
<MTEntries lastn="1"><MTEntryKeywords></MTEntries>
--- expected
keywords

=== test 62
--- template
<MTEntries lastn="1"><MTEntryAuthor></MTEntries>
--- expected
Chuck D

=== test 63
--- template
<MTEntries lastn="1"><MTEntryAuthorNickname></MTEntries>
--- expected
Chucky Dee

=== test 64
--- template
<MTEntries lastn="1"><MTEntryAuthorEmail></MTEntries>
--- expected
chuckd@example.com

=== test 65
--- template
<MTEntries lastn="1"><MTEntryAuthorURL></MTEntries>
--- expected
http://chuckd.com/

=== test 66
--- template
<MTEntries lastn="1"><MTEntryAuthorLink></MTEntries>
--- expected
<a href="http://chuckd.com/">Chucky Dee</a>

=== test 67
--- template
<MTEntries lastn="1"><MTEntryID></MTEntries>
--- expected
1

=== test 70
--- template
<MTEntries lastn="1"><MTEntryLink archive_type="Individual"></MTEntries>
--- expected
http://narnia.na/nana/archives/1978/01/a-rainy-day.html

=== test 71
--- template
<MTEntries lastn="1"><MTEntryPermalink archive_type="Individual"></MTEntries>
--- expected
http://narnia.na/nana/archives/1978/01/a-rainy-day.html

=== test 72
--- template
<MTEntries id="6"><MTEntryCategory></MTEntries>
--- expected
foo

=== test 73
--- template
<MTEntries id="6"><MTEntryCategories><MTCategoryLabel></MTEntryCategories></MTEntries>
--- expected
foo

=== test 74
--- SKIP
--- template
<MTTypeKeyToken>
--- expected
token

=== test 75
--- SKIP
--- template
<MTEntries lastn="1"><MTRemoteSignInLink></MTEntries>
--- expected
https://www.typekey.com/t/typekey/login?&amp;lang=en_US&amp;t=token&amp;v=1.1&amp;_return=http://narnia.na/cgi-bin/mt-comments.cgi%3f__mode=handle_sign_in%26key=TypeKey%26static=0%26entry_id=1

=== test 76
--- SKIP
--- template
<MTEntries lastn="1"><MTRemoteSignOutLink></MTEntries>
--- expected
http://narnia.na/cgi-bin/mt-comments.cgi?__mode=handle_sign_in&amp;static=0&amp;logout=1&amp;entry_id=1

=== test 77
--- SKIP
--- template
<MTEntries lastn="1"></MTEntries>
--- expected


=== test 80
--- template
<MTEntries lastn="1" offset="1"><MTEntryNext><MTEntryTitle></MTEntryNext></MTEntries>
--- expected
A Rainy Day

=== test 81
--- template
<MTEntries offset="1" lastn="1"><MTEntryPrevious><MTEntryTitle></MTEntryPrevious></MTEntries>
--- expected
Verse 4

=== test 82
--- template
<MTEntries lastn="1"><MTEntryDate format_name="rfc822"></MTEntries>
--- expected
Tue, 31 Jan 1978 07:45:00 -0330

=== test 83
--- template
<MTEntries lastn="1"><MTEntryDate utc="1"></MTEntries>
--- expected
January 31, 1978 11:15 AM

=== test 84
--- template
<MTEntries lastn="1"><MTEntryTitle dirify="1"></MTEntries>
--- expected
a_rainy_day

=== test 85
--- template
<MTEntries lastn="1"><MTEntryTitle trim_to="6"></MTEntries>
--- expected
A Rain

=== test 86
--- template
<MTEntries lastn="1"><MTEntryTitle decode_html="1"></MTEntries>
--- expected
A Rainy Day

=== test 87
--- template
<MTEntries lastn="1"><MTEntryTitle decode_xml="1"></MTEntries>
--- expected
A Rainy Day

=== test 88
--- template
<MTEntries lastn="1"><MTEntryTitle remove_html="1"></MTEntries>
--- expected
A Rainy Day

=== test 89
--- template
<MTEntries lastn="1" sanitize="1"><h1><strong><MTEntryTitle></strong></h1></MTEntries>
--- expected
<strong>A Rainy Day</strong>

=== test 90
--- template
<MTEntries lastn="1" encode_html="1"><strong><MTEntryTitle></strong></MTEntries>
--- expected
&lt;strong&gt;A Rainy Day&lt;/strong&gt;

=== test 91
--- template
<MTEntries lastn="1" encode_xml="1"><strong><MTEntryTitle></strong></MTEntries>
--- expected
<![CDATA[<strong>A Rainy Day</strong>]]>

=== test 92
--- template
<MTEntries lastn="1" encode_js="1">"<MTEntryTitle>"</MTEntries>
--- expected
\"A Rainy Day\"

=== test 93
--- template
<MTEntries lastn="1" encode_php="1">'<MTEntryTitle>'</MTEntries>
--- expected
\'A Rainy Day\'

=== test 94
--- template
<MTEntries lastn="1"><MTEntryTitle encode_url="1"></MTEntries>
--- expected
A%20Rainy%20Day

=== test 95
--- template
<MTEntries lastn="1"><MTEntryTitle upper_case="1"></MTEntries>
--- expected
A RAINY DAY

=== test 96
--- template
<MTEntries lastn="1"><MTEntryTitle lower_case="1"></MTEntries>
--- expected
a rainy day

=== test 97
--- template
<MTEntries lastn="1" strip_linefeeds="1">
<MTEntryTitle>
</MTEntries>
--- expected
A Rainy Day

=== test 98
--- template
[<MTEntries lastn="1"><MTEntryTitle space_pad="30"></MTEntries>]
--- expected
[                   A Rainy Day]

=== test 99
--- template
[<MTEntries lastn="1"><MTEntryTitle space_pad="-30"></MTEntries>]
--- expected
[A Rainy Day                   ]

=== test 100
--- template
<MTEntries lastn="1"><MTEntryTitle zero_pad="30"></MTEntries>
--- expected
0000000000000000000A Rainy Day

=== test 101
--- template
<MTEntries lastn="1"><MTEntryTitle sprintf="%030s"></MTEntries>
--- expected
0000000000000000000A Rainy Day

=== test 102
--- template
<MTCategories><MTCategoryLabel></MTCategories>
--- expected
foosubfoo

=== test 103
--- template
<MTCategories><MTCategoryID></MTCategories>
--- expected
13

=== test 104
--- template
<MTCategories><MTCategoryDescription></MTCategories>
--- expected
barsubcat

=== test 105
--- SKIP
--- template

--- expected


=== test 107
--- template
<MTEntries lastn="1"><MTEntryBasename></MTEntries>
--- expected
a_rainy_day

=== test 108
--- SKIP
--- template
<MTCGIServerPath>
--- expected
CURRENT_WORKING_DIRECTORY

=== test 127
--- template
[<MTCategories><MTCategoryLabel>: <MTCategoryCount>; </MTCategories>]
--- expected
[foo: 1; subfoo: 1; ]

=== test 128
--- template
[<MTCategories><MTCategoryArchiveLink>; </MTCategories>]
--- expected
[http://narnia.na/nana/archives/foo/; http://narnia.na/nana/archives/foo/subfoo/; ]

=== test 130
--- template
<MTSubCategories show_empty="1" top="1"><MTCategoryLabel></MTSubCategories>
--- expected
barfoo

=== test 131
--- template
<MTSubCategories show_empty="1" top="1"><MTSubCatIsFirst>First: <MTCategoryLabel></MTSubCatIsFirst></MTSubCategories>
--- expected
First: bar

=== test 132
--- template
<MTSubCategories show_empty="1" top="1">[[<MTCategoryLabel><MTSubCatsRecurse>]]</MTSubCategories>
--- expected
[[bar]][[foo[[subfoo]]]]

=== test 133
--- template
<MTSubCategories show_empty="1" top="1"><MTSubCatIsLast>Last: <MTCategoryLabel></MTSubCatIsLast></MTSubCategories>
--- expected
Last: foo

=== test 134
--- template
<MTTopLevelCategories><MTCategoryLabel></MTTopLevelCategories>
--- expected
barfoo

=== test 135
--- template
[<MTSubCategories show_empty="1" top="1"><MTHasParentCategory>Parent of <MTCategoryLabel> is <MTParentCategory><MTCategoryLabel></MTParentCategory></MTHasParentCategory><MTHasNoParentCategory><MTCategoryLabel> has no parent</MTHasNoParentCategory>; <MTSubCatsRecurse></MTSubCategories>]
--- expected
[bar has no parent; foo has no parent; Parent of subfoo is foo; ]

=== test 136
--- template
<MTTopLevelCategories show_empty="1"><MTCategoryLabel><MTHasSubCategories> (has subcategories)</MTHasSubCategories><MTHasNoSubCategories> (has no subcategories)</MTHasNoSubCategories></MTTopLevelCategories>
--- expected
bar (has no subcategories)foo (has subcategories)

=== test 137
--- template
<MTCategories show_empty="1"><MTSubCategoryPath>;</MTCategories>
--- expected
bar;foo;foo/subfoo;

=== test 138
--- template
<MTEntriesWithSubCategories category="foo"><MTEntryTitle>;</MTEntriesWithSubCategories>
--- expected
Verse 4;Verse 3;

=== test 139
--- template
<MTEntriesWithSubCategories category="foo/subfoo"><MTEntryTitle>;</MTEntriesWithSubCategories>
--- expected
Verse 4;

=== test 142
--- template
disabled
--- expected
disabled

=== test 143
--- template
<MTCategories show_empty="1"><MTIfIsAncestor child="subfoo"><MTCategoryLabel> is an ancestor to subfoo</MTIfIsAncestor></MTCategories>
--- expected
foo is an ancestor to subfoosubfoo is an ancestor to subfoo

=== test 144
--- template
<MTCategories show_empty="1"><MTIfIsDescendant parent="foo"><MTCategoryLabel> is a descendant of foo</MTIfIsDescendant></MTCategories>
--- expected
foo is a descendant of foosubfoo is a descendant of foo

=== test 145
--- template
[<MTCategories show_empty="1"><MTCategoryLabel>'s top parent is: <MTTopLevelParent><MTCategoryLabel></MTTopLevelParent>; </MTCategories>]
--- expected
[bar's top parent is: bar; foo's top parent is: foo; subfoo's top parent is: foo; ]

=== test 146
--- template
<MTEntries lastn="1"><MTEntryTitle lower_case="1"></MTEntries>
--- expected
a rainy day

=== test 147
--- template
[<MTArchiveList archive_type="Monthly"><MTArchiveTitle>-<MTArchiveLink>; </MTArchiveList>]
--- expected
[January 1978-http://narnia.na/nana/archives/1978/01/; January 1965-http://narnia.na/nana/archives/1965/01/; January 1964-http://narnia.na/nana/archives/1964/01/; January 1963-http://narnia.na/nana/archives/1963/01/; January 1962-http://narnia.na/nana/archives/1962/01/; January 1961-http://narnia.na/nana/archives/1961/01/; ]

=== test 147-2 nested Monthly ArchiveList
--- template
<MTArchiveList archive_type="Yearly">[<MTArchiveTitle>] <MTArchiveList archive_type="Monthly"><MTArchiveTitle>;</MTArchiveList></MTArchiveList>
--- expected
[1978] January 1978;[1965] January 1965;[1964] January 1964;[1963] January 1963;[1962] January 1962;[1961] January 1961;

=== test 147-3 nested Daily ArchiveList
--- template
<MTArchiveList archive_type="Yearly">[<MTArchiveTitle>] <MTArchiveList archive_type="Daily"><MTArchiveTitle>;</MTArchiveList></MTArchiveList>
--- expected
[1978] January 31, 1978;[1965] January 31, 1965;[1964] January 31, 1964;[1963] January 31, 1963;[1962] January 31, 1962;[1961] January 31, 1961;

=== test 147-4 nested Weekly ArchiveList
--- template
<MTArchiveList archive_type="Yearly">[<MTArchiveTitle>] <MTArchiveList archive_type="Weekly"><MTArchiveTitle>;</MTArchiveList></MTArchiveList>
--- expected
[1978] January 29, 1978 - February  4, 1978;[1965] January 31, 1965 - February  6, 1965;[1964] January 26, 1964 - February  1, 1964;[1963] January 27, 1963 - February  2, 1963;[1962] January 28, 1962 - February  3, 1962;[1961] January 29, 1961 - February  4, 1961;

=== test 147-5 nested Author-Monthly ArchiveList
--- template
<MTArchiveList archive_type="Yearly">[<MTArchiveTitle>] <MTArchiveList archive_type="Author-Monthly"><MTArchiveTitle>;</MTArchiveList></MTArchiveList>
--- expected
[1978] Chucky Dee: January 1978;[1965] Chucky Dee: January 1965;[1964] Chucky Dee: January 1964;[1963] Dylan: January 1963;[1962] Chucky Dee: January 1962;[1961] Chucky Dee: January 1961;

=== test 147-6 nested Author-Daily ArchiveList
--- template
<MTArchiveList archive_type="Yearly">[<MTArchiveTitle>] <MTArchiveList archive_type="Author-Daily"><MTArchiveTitle>;</MTArchiveList></MTArchiveList>
--- expected
[1978] Chucky Dee: January 31, 1978;[1965] Chucky Dee: January 31, 1965;[1964] Chucky Dee: January 31, 1964;[1963] Dylan: January 31, 1963;[1962] Chucky Dee: January 31, 1962;[1961] Chucky Dee: January 31, 1961;

=== test 147-7 nested Author-Weekly ArchiveList
--- template
<MTArchiveList archive_type="Yearly">[<MTArchiveTitle>] <MTArchiveList archive_type="Author-Weekly"><MTArchiveTitle>;</MTArchiveList></MTArchiveList>
--- expected
[1978] Chucky Dee: January 29, 1978 - February  4, 1978;[1965] Chucky Dee: January 31, 1965 - February  6, 1965;[1964] Chucky Dee: January 26, 1964 - February  1, 1964;[1963] Dylan: January 27, 1963 - February  2, 1963;[1962] Chucky Dee: January 28, 1962 - February  3, 1962;[1961] Chucky Dee: January 29, 1961 - February  4, 1961;

=== test 147-8 nested Category-Yearly ArchiveList (TODO check the difference between Perl and php result)
--- template
<MTArchiveList archive_type="Yearly">[<MTArchiveTitle>] <MTArchiveList archive_type="Category-Yearly"><MTArchiveTitle>;</MTArchiveList></MTArchiveList>
--- expected
[1978] foo: 1963;subfoo: 1964;[1965] foo: 1963;subfoo: 1964;[1964] foo: 1963;subfoo: 1964;[1963] foo: 1963;subfoo: 1964;[1962] foo: 1963;subfoo: 1964;[1961] foo: 1963;subfoo: 1964;
--- expected_php
[1978] [1965] [1964] subfoo: 1964;[1963] foo: 1963;[1962] [1961]

=== test 147-9 nested Category-Monthly ArchiveList
--- template
<MTArchiveList archive_type="Yearly">[<MTArchiveTitle>] <MTArchiveList archive_type="Category-Monthly"><MTArchiveTitle>;</MTArchiveList></MTArchiveList>
--- expected
[1978] [1965] [1964] subfoo: January 1964;[1963] foo: January 1963;[1962] [1961]

=== test 147-10 nested Category-Daily ArchiveList
--- template
<MTArchiveList archive_type="Yearly">[<MTArchiveTitle>] <MTArchiveList archive_type="Category-Daily"><MTArchiveTitle>;</MTArchiveList></MTArchiveList>
--- expected
[1978] [1965] [1964] subfoo: January 31, 1964;[1963] foo: January 31, 1963;[1962] [1961]

=== test 147-11 nested Category-Weekly ArchiveList
--- template
<MTArchiveList archive_type="Yearly">[<MTArchiveTitle>] <MTArchiveList archive_type="Category-Weekly"><MTArchiveTitle>;</MTArchiveList></MTArchiveList>
--- expected
[1978] [1965] [1964] subfoo: January 26, 1964 - February  1, 1964;[1963] foo: January 27, 1963 - February  2, 1963;[1962] [1961]

=== test 148
--- template
[Previous: <MTArchiveList archive_type="Monthly"><MTArchivePrevious><MTArchiveTitle>-<MTArchiveLink>;</MTArchivePrevious> </MTArchiveList>]
--- expected
[Previous: January 1965-http://narnia.na/nana/archives/1965/01/; January 1964-http://narnia.na/nana/archives/1964/01/; January 1963-http://narnia.na/nana/archives/1963/01/; January 1962-http://narnia.na/nana/archives/1962/01/; January 1961-http://narnia.na/nana/archives/1961/01/;  ]

=== test 149
--- template
[Next: <MTArchiveList archive_type="Monthly"><MTArchiveNext><MTArchiveTitle>-<MTArchiveLink>;</MTArchiveNext> </MTArchiveList>]
--- expected
[Next:  January 1978-http://narnia.na/nana/archives/1978/01/; January 1965-http://narnia.na/nana/archives/1965/01/; January 1964-http://narnia.na/nana/archives/1964/01/; January 1963-http://narnia.na/nana/archives/1963/01/; January 1962-http://narnia.na/nana/archives/1962/01/; ]

=== test 150
--- template
[<MTArchiveList archive_type="Monthly"><MTArchiveTitle>-<MTArchiveCount>; </MTArchiveList>]
--- expected
[January 1978-1; January 1965-1; January 1964-1; January 1963-1; January 1962-1; January 1961-1; ]

=== test 154
--- template
<MTBlogLanguage locale="1">
--- expected
en_US

=== test 168
--- template
<MTIfRegistrationNotRequired>yes<MTElse>no</MTElse></MTIfRegistrationNotRequired>
--- expected
no

=== test 169
--- SKIP
--- template
<MTIfRegistrationRequired>yes<MTElse>no</MTElse></MTIfRegistrationRequired>
--- expected
yes

=== test 171
--- template
<MTSetVar name="x" value="   abc   "><MTGetVar name="x" trim="1">
--- expected
abc

=== test 172
--- template
[<MTSetVar name="x" value="   abc   "><MTGetVar name="x" ltrim="1">]
--- expected
[abc   ]

=== test 173
--- template
[<MTSetVar name="x" value="   abc"><MTGetVar name="x" rtrim="1">]
--- expected
[   abc]

=== test 174
--- template
<MTSetVar name="x" value="abc"><MTGetVar name="x" filters="__default__">
--- expected
<p>abc</p>

=== test 175
--- template
<MTIfStatic>1</MTIfStatic>
--- expected_php
--- expected
1

=== test 176
--- template
<MTIfDynamic>1</MTIfDynamic>
--- expected
--- expected_php
1

=== test 177
--- template
<MTTags glue=","><MTTagName></MTTags>
--- expected
anemones,grandpa,rain,strolling,verse

=== test 178
--- template
<MTEntries lastn="1"><MTEntryTags glue=","><MTTagName></MTEntryTags></MTEntries>
--- expected
grandpa,rain,strolling

=== test 179
--- template
<MTEntries lastn="1"><MTEntryTags glue=","><MTTagID></MTEntryTags></MTEntries>
--- expected
1,2,3

=== test 180
--- template
<MTEntries lastn="1"><MTEntryIfTagged>has tags</MTEntryIfTagged></MTEntries>
--- expected
has tags

=== test 181
--- template
<MTEntries lastn="1"><MTEntryIfTagged tag="grandpa">tagged</MTEntryIfTagged></MTEntries>
--- expected
tagged

=== test 182
--- template
<MTEntries lastn="1"><MTEntryTags glue=" "><MTTagSearchLink></MTEntryTags></MTEntries>
--- expected
http://narnia.na/cgi-bin/mt-search.cgi?IncludeBlogs=1&amp;tag=grandpa&amp;limit=20 http://narnia.na/cgi-bin/mt-search.cgi?IncludeBlogs=1&amp;tag=rain&amp;limit=20 http://narnia.na/cgi-bin/mt-search.cgi?IncludeBlogs=1&amp;tag=strolling&amp;limit=20

=== test 183
--- template
<MTTags glue=':'><MTTagCount></MTTags>
--- expected
2:1:4:1:5

=== test 183-2
--- template
<MTEntries tag='grandpa' lastn='1'><MTEntryTags glue=','><MTTagCount></MTEntryTags></MTEntries>
--- expected
1,4,1

=== test 184
--- SKIP
--- template
<MTIfTypeKeyToken>tokened</MTIfTypeKeyToken>
--- expected
tokened

=== test 186
--- SKIP
--- template
<MTIfRegistrationAllowed>allowed</MTIfRegistrationAllowed>
--- expected
allowed

=== test 187
--- template
<MTIfArchiveTypeEnabled type="Category">enabled</MTIfArchiveTypeEnabled>
--- expected
enabled

=== test 188
--- template
<MTEntries lastn="1"><MTFileTemplate format="%y/%m/%d/%b"></MTEntries>
--- expected
1978/01/31/a_rainy_day

=== test 189
--- template
<MTAdminCGIPath>
--- expected
http://narnia.na/cgi-bin/

=== test 190
--- template
<MTConfigFile>
--- expected
CFG_FILE

=== test 191
--- template
<MTAdminScript>
--- expected
mt.cgi

=== test 193
--- template
<MTCGIHost>
--- expected
narnia.na

=== test 194
--- template
<MTBlogFileExtension>
--- expected
.html

=== test 195
--- template
<MTEntries lastn="1"><MTEntryAuthorUsername></MTEntries>
--- expected
Chuck D

=== test 196
--- template
<MTEntries lastn="1"><MTEntryAuthorDisplayName></MTEntries>
--- expected
Chucky Dee

=== test 197
--- template
<MTEntries lastn="1"><MTEntryAtomID></MTEntries>
--- expected
tag:narnia.na,1978:/nana//1.1

=== test 198
--- template
<MTEntries lastn="1"><MTEntryTitle trim_to="20"></MTEntries>
--- expected
A Rainy Day

=== test 199
--- template
<MTCategories show_empty="1" glue=","><MTCategoryLabel>-<MTCategoryNext show_empty="1"><MTCategoryLabel></MTCategoryNext></MTCategories>
--- expected
bar-foo,foo-,subfoo-

=== test 200
--- template
<MTCategories show_empty="1" glue=","><MTCategoryLabel>-<MTCategoryPrevious show_empty="1"><MTCategoryLabel></MTCategoryPrevious></MTCategories>
--- expected
bar-,foo-bar,subfoo-

=== test 201
--- template
<MTEntries lastn="1" offset="3"><MTIfCategory name="foo">in category</MTIfCategory></MTEntries>
--- expected
in category

=== test 202
--- template

--- expected


=== test 203
--- template
<MTIndexList><MTIndexName>-<MTIndexLink>-<MTIndexBasename>;</MTIndexList>
--- expected
Archive Index-http://narnia.na/nana/archives.html-index;Feed - Recent Entries-http://narnia.na/nana/atom.xml-index;JavaScript-http://narnia.na/nana/mt.js-index;Main Index-http://narnia.na/nana/-index;RSD-http://narnia.na/nana/rsd.xml-index;Stylesheet-http://narnia.na/nana/styles.css-index;

=== test 204
--- template
<MTIfNeedEmail>email needed</MTIfNeedEmail>
--- expected


=== test 210
--- SKIP
--- template
<MTIfDynamicComments>dynamic comments<MTElse>static comments</MTElse></MTIfDynamicComments>
--- expected
static comments

=== test 214
--- template
<MTEntries lastn='1'><MTEntryIfExtended>entry is extended</MTEntryIfExtended></MTEntries>
--- expected
entry is extended

=== test 215
--- template
[<MTEntries offset="2" lastn="2"> * <MTEntryTitle></MTEntries>]
--- expected
[ * Verse 4 * Verse 3]

=== test 216
--- template
[<MTEntries offset="2"> * <MTEntryTitle></MTEntries>]
--- expected
[ * Verse 4 * Verse 3 * Verse 2 * Verse 1]

=== test 217
--- template
<MTArchiveList archive_type='Category'><MTArchiveCategory></MTArchiveList>
--- expected
foosubfoo

=== test 218
--- template
<MTArchiveList><MTArchiveFile></MTArchiveList>
--- expected
a_rainy_day.htmlverse_5.htmlverse_4.htmlverse_3.htmlverse_2.htmlverse_1.html

=== test 219
--- template
<MTArchives><MTArchiveType></MTArchives>
--- expected
IndividualMonthlyWeeklyDailyCategoryPageAuthor

=== test 220
--- template
<MTArchiveList archive_type='Monthly'><MTArchiveDateEnd></MTArchiveList>
--- expected
January 31, 1978 11:59 PMJanuary 31, 1965 11:59 PMJanuary 31, 1964 11:59 PMJanuary 31, 1963 11:59 PMJanuary 31, 1962 11:59 PMJanuary 31, 1961 11:59 PM

=== test 221
--- template
<MTArchiveList archive_type='Daily'><MTArchiveDateEnd></MTArchiveList>
--- expected
January 31, 1978 11:59 PMJanuary 31, 1965 11:59 PMJanuary 31, 1964 11:59 PMJanuary 31, 1963 11:59 PMJanuary 31, 1962 11:59 PMJanuary 31, 1961 11:59 PM

=== test 222
--- template
<MTArchiveList archive_type='Weekly'><MTArchiveDateEnd></MTArchiveList>
--- expected
February  4, 1978 11:59 PMFebruary  6, 1965 11:59 PMFebruary  1, 1964 11:59 PMFebruary  2, 1963 11:59 PMFebruary  3, 1962 11:59 PMFebruary  4, 1961 11:59 PM

=== test 225
--- template
<MTTags glue=','><MTTagName> <MTTagRank></MTTags>
--- expected
anemones 4,grandpa 6,rain 2,strolling 6,verse 1

=== test 226
--- template
<MTEntries tag='grandpa' lastn='1'><MTEntryTags glue=','><MTTagRank></MTEntryTags></MTEntries>
--- expected
6,2,6

=== test 227
--- template
<MTEntries tag='verse' lastn='1'><MTEntryTags glue=','><MTTagRank></MTEntryTags></MTEntries>
--- expected
2,1

=== test 228
--- template
<MTEntries tags='grandpa' lastn='1'><MTEntryTitle></MTEntries>
--- expected
A Rainy Day

=== test 229
--- template
<MTEntries category='subfoo' lastn='1'><MTEntryTitle></MTEntries>
--- expected
Verse 4

=== test 230
--- SKIP
--- template
<MTEntries tags='verse' category='foo' lastn='1'><MTEntryTitle></MTEntries>
--- expected
Verse 3

=== test 231
--- template
<MTEntries author='Bob D' category='foo'><MTEntryTitle></MTEntries>
--- expected
Verse 3

=== test 232
--- template
<MTEntries author='Chuck D' tags='strolling'><MTEntryTitle></MTEntries>
--- expected
A Rainy Day

=== test 233
--- template
<MTSetVar name='x' value='0'><MTIfNonZero tag='GetVar' name='x'><MTElse>0</MTElse></MTIfNonZero>
--- expected
0

=== test 234
--- template
<MTAsset id='1'><$MTAssetID$></MTAsset>
--- expected
1

=== test 235
--- template
<MTAssets type='image'><$MTAssetID$>;</MTAssets>
--- expected
1;7;6;5;

=== test 236
--- template
<MTAssets type='file'><$MTAssetID$></MTAssets>
--- expected
2

=== test 237
--- template
<MTAssets type='all'><$MTAssetID$></MTAssets>
--- expected


=== test 238
--- template
<MTAssets file_ext='jpg'><$MTAssetID$>;</MTAssets>
--- expected
1;7;6;5;

=== test 239
--- template
<MTAssets file_ext='tmpl'><$MTAssetID$></MTAssets>
--- expected
2

=== test 240
--- template
<MTAssets file_ext='dat'><$MTAssetID$></MTAssets>
--- expected


=== test 241
--- template
<MTAssets lastn='1'><$MTAssetID$></MTAssets>
--- expected
1

=== test 242
--- template
<MTAssets days='1'><$MTAssetID$>;</MTAssets>
--- expected
1;

=== test 243
--- template
<MTAssets author='Chuck D'><$MTAssetID$></MTAssets>
--- expected


=== test 244
--- template
<MTAssets author='Melody'><$MTAssetID$>;</MTAssets>
--- expected
1;7;6;5;2;

=== test 245
--- template
<MTAssets limit='1' offset='1'><$MTAssetID$></MTAssets>
--- expected
7

=== test 246
--- template
<MTAssets limit='1' offset='5'><$MTAssetID$></MTAssets>
--- expected


=== test 247
--- template
<MTAssets tag='alpha'><$MTAssetID$></MTAssets>
--- expected
1765

=== test 248
--- template
<MTAssets sort_by='file_name' sort_order='ascend'><$MTAssetID$>;</MTAssets>
--- expected
1;2;5;6;7;

=== test 249
--- template
<MTAssets sort_order='ascend'><$MTAssetID$>;</MTAssets>
--- expected
2;5;6;7;1;

=== test 250
--- template
<MTAssets lastn='1'><$MTAssetFileName$></MTAssets>
--- expected
test.jpg

=== test 251
--- template
<MTAssets lastn='1'><$MTAssetURL$></MTAssets>
--- expected
http://narnia.na/nana/images/test.jpg

=== test 252
--- template
<MTAssets lastn='1'><$MTAssetType$></MTAssets>
--- expected
image

=== test 253
--- template
<MTAssets lastn='1'><$MTAssetMimeType$></MTAssets>
--- expected
image/jpeg

=== test 254
--- template
<MTAssets lastn='1'><$MTAssetFilePath$></MTAssets>
--- expected fix_path
CURRENT_WORKING_DIRECTORY/t/images/test.jpg

=== test 255
--- template
<MTAssets limit='1' sort_order='ascend'><$MTAssetDateAdded$></MTAssets>
--- expected
January 31, 1978  7:45 AM

=== test 256
--- template
<MTAssets lastn='1'><$MTAssetAddedBy$></MTAssets>
--- expected
Melody

=== test 257
--- template
<MTAssets lastn='1'><$MTAssetProperty property='file_size'$></MTAssets>
--- expected
129.9 KB

=== test 258
--- template
<MTAssets lastn='1'><$MTAssetProperty property='file_size' format='0'$></MTAssets>
--- expected
133050

=== test 259
--- template
<MTAssets lastn='1'><$MTAssetProperty property='file_size' format='1'$></MTAssets>
--- expected
129.9 KB

=== test 260
--- template
<MTAssets lastn='1'><$MTAssetProperty property='file_size' format='k'$></MTAssets>
--- expected
129.9

=== test 261
--- template
<MTAssets lastn='1'><$MTAssetProperty property='file_size' format='m'$></MTAssets>
--- expected
0.1

=== test 262
--- template
<MTAssets lastn='1' type='image'><$MTAssetProperty property='image_width'$></MTAssets>
--- expected
640

=== test 263
--- template
<MTAssets lastn='1' type='image'><$MTAssetProperty property='image_height'$></MTAssets>
--- expected
480

=== test 264
--- template
<MTAssets lastn='1' type='file'><$MTAssetProperty property='image_width'$></MTAssets>
--- expected
0

=== test 265
--- template
<MTAssets lastn='1' type='file'><$MTAssetProperty property='image_height'$></MTAssets>
--- expected
0

=== test 266
--- template
<MTAssets limit='1' sort_order='ascend'><$MTAssetProperty property='image_width'$></MTAssets>
--- expected
0

=== test 267
--- template
<MTAssets limit='1' sort_order='ascend'><$MTAssetProperty property='image_height'$></MTAssets>
--- expected
0

=== test 268
--- template
<MTAssets limit='1' sort_order='ascend'><$MTAssetProperty property='image_width'$></MTAssets>
--- expected
0

=== test 269
--- template
<MTAssets limit='1' sort_order='ascend'><$MTAssetProperty property='image_height'$></MTAssets>
--- expected
0

=== test 270
--- template
<MTAssets lastn='1'><$MTAssetProperty property='label'$></MTAssets>
--- expected
Image photo

=== test 271
--- template
<MTAssets lastn='1'><$MTAssetProperty property='description'$></MTAssets>
--- expected
This is a test photo.

=== test 272
--- template
<MTAssets lastn='1'><$MTAssetFileExt$></MTAssets>
--- expected
jpg

=== test 273
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailURL width='160'$></MTAssets>
--- expected
http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-160xauto-1.jpg

=== test 274
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailURL height='240'$></MTAssets>
--- expected
http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-autox240-1.jpg

=== test 275
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailURL scale='75'$></MTAssets>
--- expected
http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-480x360-1.jpg

=== test 276
--- template
<MTAssets lastn='1'><$MTAssetLink$></MTAssets>
--- expected
<a href="http://narnia.na/nana/images/test.jpg">test.jpg</a>

=== test 277
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailLink$></MTAssets>
--- expected
<a href="http://narnia.na/nana/images/test.jpg"><img src="http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg" width="640" height="480" alt="" /></a>

=== test 278
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailLink width='160'$></MTAssets>
--- expected
<a href="http://narnia.na/nana/images/test.jpg"><img src="http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-160xauto-1.jpg" width="160" height="120" alt="" /></a>

=== test 279
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailLink height='240'$></MTAssets>
--- expected
<a href="http://narnia.na/nana/images/test.jpg"><img src="http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-autox240-1.jpg" width="320" height="240" alt="" /></a>

=== test 280
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailLink scale='100'$></MTAssets>
--- expected
<a href="http://narnia.na/nana/images/test.jpg"><img src="http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg" width="640" height="480" alt="" /></a>

=== test 281
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetLink new_window='1'$></MTAssets>
--- expected
<a href="http://narnia.na/nana/images/test.jpg" target="_blank">test.jpg</a>

=== test 282
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailLink new_window='1'$></MTAssets>
--- expected
<a href="http://narnia.na/nana/images/test.jpg" target="_blank"><img src="http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg" width="640" height="480" alt="" /></a>

=== test 283
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailLink new_window='1' width='160'$></MTAssets>
--- expected
<a href="http://narnia.na/nana/images/test.jpg" target="_blank"><img src="http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-160xauto-1.jpg" width="160" height="120" alt="" /></a>

=== test 284
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailLink new_window='1' scale='100'$></MTAssets>
--- expected
<a href="http://narnia.na/nana/images/test.jpg" target="_blank"><img src="http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg" width="640" height="480" alt="" /></a>

=== test 285
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailLink new_window='1' scale='100'$></MTAssets>
--- expected
<a href="http://narnia.na/nana/images/test.jpg" target="_blank"><img src="http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg" width="640" height="480" alt="" /></a>

=== test 286
--- template
<$MTAssetCount$>
--- expected
5

=== test 287
--- template
[<MTAssets lastn='1'><MTAssetTags><$MTTagName$>; </MTAssetTags></MTAssets>]
--- expected
[alpha; beta; gamma; ]

=== test 288
--- template
<MTAssets><MTAssetsHeader>(Head)</MTAssetsHeader><$MTAssetID$>;<MTAssetsFooter>(Last)</MTAssetsFooter></MTAssets>
--- expected
(Head)1;7;6;5;2;(Last)

=== test 289
--- template
[<MTEntries lastn="10"><MTIfNonZero tag="MTEntryScoreCount" namespace="unit test"><MTEntryID> <MTEntryScore namespace="unit test">; </MTIfNonZero></MTEntries>]
--- expected
[6 2; 5 12; 4 5; ]

=== test 290
--- template
[<MTEntries lastn="10"><MTIfNonZero tag="MTEntryScoreCount" namespace="unit test"><MTEntryID> <MTEntryScoreHigh namespace="unit test">; </MTIfNonZero></MTEntries>]
--- expected
[6 1; 5 5; 4 3; ]

=== test 291
--- template
[<MTEntries lastn="10"><MTIfNonZero tag="MTEntryScoreCount" namespace="unit test"><MTEntryID> <MTEntryScoreLow namespace="unit test">; </MTIfNonZero></MTEntries>]
--- expected
[6 1; 5 3; 4 2; ]

=== test 292
--- template
[<MTEntries lastn="10"><MTIfNonZero tag="MTEntryScoreCount" namespace="unit test"><MTEntryID> <MTEntryScoreAvg namespace="unit test">; </MTIfNonZero></MTEntries>]
--- expected
[6 1.00; 5 4.00; 4 2.50; ]

=== test 293
--- template
[<MTEntries lastn="10"><MTIfNonZero tag="MTEntryScoreCount" namespace="unit test"><MTEntryID> <MTEntryScoreCount namespace="unit test">; </MTIfNonZero></MTEntries>]
--- expected
[6 2; 5 3; 4 2; ]

=== test 294
--- template
[<MTEntries lastn="10"><MTIfNonZero tag="MTEntryScoreCount" namespace="unit test"><MTEntryID> <MTEntryRank namespace="unit test">; </MTIfNonZero></MTEntries>]
--- expected
[6 6; 5 1; 4 4; ]

=== test 295
--- template
[<MTEntries lastn="10"><MTIfNonZero tag="MTEntryScoreCount" namespace="unit test"><MTEntryID> <MTEntryRank max="10" namespace="unit test">; </MTIfNonZero></MTEntries>]
--- expected
[6 10; 5 1; 4 5; ]

=== test 296
--- template
<MTEntries glue="; " sort_by="score" namespace="unit test" min_score="1"><MTEntryID>-<MTEntryScore namespace="unit test"></MTEntries>
--- expected
5-12; 4-5; 6-2

=== test 297
--- template
[<MTAssets lastn="10"><MTIfNonZero tag="MTAssetScoreCount" namespace="unit test"><MTAssetID> <MTAssetScore namespace="unit test">; </MTIfNonZero></MTAssets>]
--- expected
[1 12; 7 7; 6 9; 5 8; 2 5; ]

=== test 298
--- template
[<MTAssets lastn="10"><MTIfNonZero tag="MTAssetScoreCount" namespace="unit test"><MTAssetID> <MTAssetScoreHigh namespace="unit test">; </MTIfNonZero></MTAssets>]
--- expected
[1 5; 7 7; 6 9; 5 8; 2 3; ]

=== test 299
--- template
[<MTAssets lastn="10"><MTIfNonZero tag="MTAssetScoreCount" namespace="unit test"><MTAssetID> <MTAssetScoreLow namespace="unit test">; </MTIfNonZero></MTAssets>]
--- expected
[1 3; 7 7; 6 9; 5 8; 2 2; ]

=== test 300
--- template
[<MTAssets lastn="10"><MTIfNonZero tag="MTAssetScoreCount" namespace="unit test"><MTAssetID> <MTAssetScoreAvg namespace="unit test">; </MTIfNonZero></MTAssets>]
--- expected
[1 4.00; 7 7.00; 6 9.00; 5 8.00; 2 2.50; ]

=== test 301
--- template
[<MTAssets lastn="10"><MTIfNonZero tag="MTAssetScoreCount" namespace="unit test"><MTAssetID> <MTAssetScoreCount namespace="unit test">; </MTIfNonZero></MTAssets>]
--- expected
[1 3; 7 1; 6 1; 5 1; 2 2; ]

=== test 302
--- template
[<MTAssets lastn="10"><MTIfNonZero tag="MTAssetScoreCount" namespace="unit test"><MTAssetID> <MTAssetRank namespace="unit test">; </MTIfNonZero></MTAssets>]
--- expected
[1 1; 7 4; 6 3; 5 3; 2 6; ]

=== test 303
--- template
[<MTAssets lastn="10"><MTIfNonZero tag="MTAssetScoreCount" namespace="unit test"><MTAssetID> <MTAssetRank max="10" namespace="unit test">; </MTIfNonZero></MTAssets>]
--- expected
[1 1; 7 6; 6 4; 5 4; 2 10; ]

=== test 304
--- template
[<MTAssets sort_by="score" namespace="unit test"><MTAssetID>; </MTAssets>]
--- expected
[1; 6; 5; 7; 2; ]

=== test 305
--- template
<MTTags glue=","><MTTagLabel></MTTags>
--- expected
anemones,grandpa,rain,strolling,verse

=== test 306
--- template
<MTEntries lastn="1"><MTEntryTags glue=","><MTTagLabel></MTEntryTags></MTEntries>
--- expected
grandpa,rain,strolling

=== test 307
--- template
<MTTags glue=','><MTTagLabel> <MTTagRank></MTTags>
--- expected
anemones 4,grandpa 6,rain 2,strolling 6,verse 1

=== test 308
--- template
[<MTAssets lastn='1'><MTAssetTags><$MTTagLabel$>; </MTAssetTags></MTAssets>]
--- expected
[alpha; beta; gamma; ]

=== test 312
--- template
<MTPages><MTPageID>;</MTPages>
--- expected
23;22;21;20;

=== test 313
--- template
<MTPages lastn='1'><MTPageID>;</MTPages>
--- expected
23;

=== test 314
--- template
<MTPages lastn='1' offset='1'><MTPageID>;</MTPages>
--- expected
22;

=== test 315
--- template
<MTPages folder='info'><MTPageID>;</MTPages>
--- expected
21;

=== test 316
--- template
<MTPages folder='download' include_subfolders='1'><MTPageID>;</MTPages>
--- expected
23;22;

=== test 317
--- template
<MTPages tag='river'><MTPageID>;</MTPages>
--- expected
20;

=== test 318
--- template
<MTPages id='20'><MTPageID>;</MTPages>
--- expected
20;

=== test 319
--- template
<MTPages sort_by='created_on' sort_order='scend'><MTPageID>;</MTPages>
--- expected
23;22;21;20;

=== test 320
--- template
<MTPages id='21'><MTPageFolder><MTFolderID></MTPageFolder></MTPages>
--- expected
20

=== test 321
--- template
<MTPages id='20'><MTPageTags><MTTagName>;</MTPageTags></MTPages>
--- expected
flow;river;watch;

=== test 322
--- template
<MTPages id='20'><MTPageTitle></MTPages>
--- expected
But in ourselves, that we are underlings.

=== test 323
--- template
<MTPages id='20'><MTPageBody></MTPages>
--- expected
<p>Men at some time are masters of their fates:</p>

=== test 324
--- template
<MTPages id='20'><MTPageDate format_name='rfc822'></MTPages>
--- expected
Tue, 31 Jan 1978 07:45:00 -0330

=== test 325
--- template
<MTPages id='20'><MTPageModifiedDate format_name='rfc822'></MTPages>
--- expected
Tue, 31 Jan 1978 07:46:00 -0330

=== test 326
--- template
<MTPages id='20'><MTPageAuthorDisplayName></MTPages>
--- expected
Chucky Dee

=== test 327
--- template
<MTPages id='20'><MTPageKeywords></MTPages>
--- expected
no folder

=== test 328
--- template
<MTPages id='20'><MTPageBasename></MTPages>
--- expected
but_in_ourselves_that_we_are_underlings

=== test 329
--- template
<MTPages id='20'><MTPagePermalink></MTPages>
--- expected
http://narnia.na/nana/but-in-ourselves-that-we-are-underlings.html

=== test 330
--- template
<MTPages id='20'><MTPageAuthorEmail></MTPages>
--- expected
chuckd@example.com

=== test 331
--- template
<MTPages id='20'><MTPageAuthorLink></MTPages>
--- expected
<a href="http://chuckd.com/">Chucky Dee</a>

=== test 332
--- template
<MTPages id='20'><MTPageAuthorURL></MTPages>
--- expected
http://chuckd.com/

=== test 333
--- template
<MTPages id='20'><MTPageExcerpt></MTPages>
--- expected
excerpt

=== test 334
--- template
<MTBlogPageCount>
--- expected
4

=== test 335
--- template
<MTFolders><MTFolderID>;</MTFolders>
--- expected
21;20;22;

=== test 336
--- template
<MTFolders><MTSubFolders><MTFolderID></MTSubFolders></MTFolders>
--- expected
22

=== test 337
--- template
<MTFolders><MTSubFolders><MTParentFolders><MTFolderID>;</MTParentFolders></MTSubFolders></MTFolders>
--- expected
21;22;

=== test 338
--- template
<MTTopLevelFolders><MTFolderID>;</MTTopLevelFolders>
--- expected
21;20;

=== test 339
--- template
<MTFolders><MTFolderBasename>;</MTFolders>
--- expected
download;info;nightly;

=== test 340
--- template
<MTFolders><MTFolderCount>;</MTFolders>
--- expected
1;1;1;

=== test 341
--- template
<MTFolders><MTFolderDescription>;</MTFolders>
--- expected
download top;information;nightly build;

=== test 342
--- template
<MTFolders><MTFolderLabel>;</MTFolders>
--- expected
download;info;nightly;

=== test 343
--- template
<MTFolders><MTFolderPath>;</MTFolders>
--- expected
download;info;download/nightly;

=== test 346
--- template
<MTArchiveList archive_type='Individual' sort_order='ascend'><$MTArchiveDate format='%Y.%m.%d.%H.%M.%S'$>;</MTArchiveList>
--- expected
1961.01.31.07.45.01;1962.01.31.07.45.01;1963.01.31.07.45.01;1964.01.31.07.45.01;1965.01.31.07.45.01;1978.01.31.07.45.00;

=== test 347
--- template
<MTAuthors lastn="2"><MTAuthorID>;</MTAuthors>
--- expected
2;3;

=== test 348
--- template
<MTAuthors sort_by='name'><MTAuthorName>;</MTAuthors>
--- expected
Bob D;Chuck D;

=== test 349
--- template
<MTAuthors sort_by='nickname'><MTAuthorDisplayName>;</MTAuthors>
--- expected
Chucky Dee;Dylan;

=== test 350
--- template
<MTAuthors sort_by='email'><MTAuthorEmail>;</MTAuthors>
--- expected
bobd@example.com;chuckd@example.com;

=== test 351
--- template
<MTAuthors sort_by='url'><MTAuthorURL>;</MTAuthors>
--- expected
http://chuckd.com/;http://example.com/;

=== test 352
--- template
<MTAuthors username='Chuck D'><MTAuthorName>;<MTAuthorDisplayName>;<MTAuthorEmail>;<MTAuthorURL>;</MTAuthors>
--- expected
Chuck D;Chucky Dee;chuckd@example.com;http://chuckd.com/;

=== test 353
--- SKIP
--- template
<MTArchiveList type='Monthly'><MTPages><MTPageTitle></MTPages></MTArchiveList>
--- expected
But in ourselves, that we are underlings.

=== test 354
--- template
<MTAuthors sort_by='display_name' sort_order='descend'><MTAuthorID>;</MTAuthors>
--- expected
3;2;

=== test 355
--- template
<MTArchives><MTArchiveLabel></MTArchives>
--- expected
EntryMonthlyWeeklyDailyCategoryPageAuthor

=== test 357
--- template
<MTPages id='20'><$MTPageMore$></MTPages>
--- expected
<p>The fault, dear Brutus, is not in our stars,</p>

=== test 358
--- template
<MTAssets lastn='1'><$MTAssetlabel$></MTAssets>
--- expected
Image photo

=== test 359
--- template
<MTEntries id='1'><MTEntryAssets><$MTAssetID$></MTEntryAssets></MTEntries>
--- expected
765

=== test 360
--- template
<MTPages id='20'><MTPageAssets><$MTAssetID$></MTPageAssets></MTPages>
--- expected
765

=== test 361
--- template
<MTAuthors><$MTAuthorAuthType$>:<$MTAuthorAuthIconURL$>;</MTAuthors>
--- expected
MT:http://narnia.na/mt-static/images/logo-mark.svg;MT:http://narnia.na/mt-static/images/logo-mark.svg;

=== test 363
--- template
<MTAuthors need_entry='0' ><MTAuthorName>;</MTAuthors>
--- expected
Chuck D;Bob D;Melody;

=== test 364
--- template
<MTAuthors need_entry='0' status='disabled'><MTAuthorName>;</MTAuthors>
--- expected
Hiro Nakamura;

=== test 365
--- template
<MTAuthors need_entry='0' status='enabled or disabled'><MTAuthorName>;</MTAuthors>
--- expected
Chuck D;Bob D;Hiro Nakamura;Melody;

=== test 366
--- template
<MTAuthors need_entry='0' role='Author'><MTAuthorName>;</MTAuthors>
--- expected
Bob D;

=== test 367
--- template
<MTAuthors need_entry='0' role='Author or Designer'><MTAuthorName>;</MTAuthors>
--- expected
Bob D;

=== test 368
--- template
<MTSetVar name='offices' value='San Francisco' index='0'><MTSetVar name='offices' value='Tokyo' function='unshift'><MTSetVarBlock name='offices' index='2'>Paris</MTSetVarBlock>--<MTGetVar name='offices' function='count'>;<MTGetVar name='offices' index='1'>;<MTGetVar name='offices' function='shift'>;<MTGetVar name='offices' function='count'>;<MTGetVar name='offices' index='1'>
--- expected
--3;San Francisco;Tokyo;2;Paris

=== test 369
--- template
<MTSetVar name='MTVersions' key='4.0' value='Athena'><MTSetVarBlock name='MTVersions' key='4.01'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions' key='4.1'>Boomer<MTSetVar name='4.2' value='Cal'></MTSetVarBlock><MTGetVar name='MTVersions' key='4.0'>;<MTGetVar name='MTVersions' key='4.01'>;<MTGetVar name='MTVersions' key='4.1'>;<MTGetVar name='MTVersions' key='4.2'>;
--- expected
Athena;Enterprise Solution;Boomer;;

=== test 370
--- template
<MTVar name='object1' key='name' value='foo'><MTVar name='object1' key='price' value='1.00'><MTVar name='object2' key='name' value='bar'><MTVar name='object2' key='price' value='1.13'><MTSetVar name='array1' function='push' value='$object1'><MTSetVar name='array1' function='push' value='$object2'><MTLoop name='array1'><MTVar name='name'>(<MTVar name='price'>)<br /></MTLoop>
--- expected
foo(1.00)<br />bar(1.13)<br />

=== test 370-2 respect 0 over default
--- template
<MTVar name='arr' index="0" value='foo'><MTVar name='arr' function='shift'><MTVar name='arr' function='count' default='9'>
--- expected
foo0

=== test 370-3 respect "0" over default
--- template
<MTVar name='arr' index="0" value='0'><MTVar name='arr' function='shift' default='9'>
--- expected
0

=== test 370-4 respect default over ""
--- template
<MTVar name='arr' index="0" value=''><MTVar name='arr' function='shift' default='9'>
--- expected
9

=== test 371
--- template
<MTSetVar name='offices1' value='San Francisco' index='0'><MTSetVar name='offices1' value='Tokyo' function='unshift'><MTSetVarBlock name='offices1' index='2'>Paris</MTSetVarBlock>--<MTGetVar name='offices1' function='count'>;<MTGetVar name='offices1' index='1'>;<MTGetVar name='offices1' function='shift'>;<MTGetVar name='offices1' function='count'>;<MTGetVar name='offices1' index='1'>
--- expected
--3;San Francisco;Tokyo;2;Paris

=== test 372
--- template
<MTSetVar name='offices2' value='San Francisco' index='0'><MTSetVar name='offices2' value='Tokyo' function='unshift'><MTSetVarBlock name='offices2' index='2'>Paris</MTSetVarBlock>--<MTSetVarBlock name='count'><MTGetVar name='offices2' function='count' op='sub' value='1'></MTSetVarBlock><MTFor from='0' to='$count' step='1' glue=','><MTGetVar name='offices2' index='$__index__'></MTFor>
--- expected
--Tokyo,San Francisco,Paris

=== test 373
--- template
<MTSetHashVar name='MTVersions2'><MTSetVar name='4.0' value='Athena'><MTSetVarBlock name='4.01'>Enterprise Solution</MTSetVarBlock><MTSetVar name='4.1' value='Boomer'><MTVar name='4.2' value='Cal'></MTSetHashVar>--<MTLoop name='MTVersions2' sort_by='value'><MTVar name='__key__'> - <MTVar name='__value__'>;</MTLoop>
--- expected
--4.0 - Athena;4.1 - Boomer;4.2 - Cal;4.01 - Enterprise Solution;

=== test 374
--- template
<MTSetHashVar name='MTVersions3'><MTSetVar name='4.0' value='Athena'><MTSetVarBlock name='4.01'>Enterprise Solution</MTSetVarBlock><MTSetVar name='4.1' value='Boomer'></MTSetHashVar><MTVar name='MTVersions3' key='4.2' value='Cal'>--<MTLoop name='MTVersions3' sort_by='key'><MTVar name='__key__'> - <MTVar name='__value__'>;</MTLoop>
--- expected
--4.0 - Athena;4.01 - Enterprise Solution;4.1 - Boomer;4.2 - Cal;

=== test 375
--- template
<MTSetVar name='offices3' value='San Francisco' index='0'><MTSetVar name='offices3' value='Tokyo' function='unshift'><MTSetVarBlock name='offices3' index='2'>Paris</MTSetVarBlock>--<MTLoop name='offices3' glue=','><MTVar name='__value__'></MTLoop>
--- expected
--Tokyo,San Francisco,Paris

=== test 376
--- template
<MTSetVar name='offices4' value='San Francisco' index='0'><MTSetVar name='offices4' value='Tokyo' function='unshift'><MTSetVarBlock name='offices4' index='2'>Paris</MTSetVarBlock>--<MTLoop name='offices4' glue=',' sort_by='value'><MTVar name='__value__'></MTLoop>
--- expected
--Paris,San Francisco,Tokyo

=== test 377
--- template
<MTSetVar name='num' op='add' value='99'><MTGetVar name='num'>;<MTGetVar name='num' value='1' op='+'>;<MTSetVar name='num' value='1'><MTGetVar name='num'>;<MTGetVar name='num' value='20' op='mul'>;<MTSetVar name='num' value='2' op='add'><MTGetVar name='num'>;<MTGetVar name='num' value='20' op='*'>;<MTSetVar name='num' value='3' op='*'><MTGetVar name='num'>;<MTGetVar name='num' value='3' op='/'>;<MTSetVar name='num' op='div' value='2'><MTGetVar name='num'>;<MTGetVar name='num' value='0.5' op='-'>;<MTSetVar name='num' op='mod' value='6'><MTGetVar name='num'>;<MTGetVar name='num' value='3' op='%'>;
--- expected
99;100;1;20;3;60;9;3;4.5;4;4;1;

=== test 378
--- template
<MTSetVar name='num' value='1'><MTGetVar name='num' op='++'>;<MTSetVar name='num' op='inc'><MTGetVar name='num'>;<MTSetVar name='num' op='dec'><MTGetVar name='num'>;<MTGetVar name='num' op='--'>;
--- expected
2;2;1;0;

=== test 379
--- template
<MTSetVar name='offices9[0]' value='San Francisco'><MTSetVar name='unshift(offices9)' value='Tokyo'><MTSetVarBlock name='offices9[2]'>Paris</MTSetVarBlock>--<MTGetVar name='count(offices9)'>;<MTGetVar name='offices9[1]'>;<MTGetVar name='shift(offices9)'>;<MTGetVar name='count(offices9)'>;<MTGetVar name='offices9' index='1'>
--- expected
--3;San Francisco;Tokyo;2;Paris

=== test 380
--- template
<MTSetVar name='MTVersions4{4.0}' value='Athena'><MTSetVarBlock name='MTVersions4{4.01}'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions4{4.1}'>Boomer<MTSetVar name='4.2' value='Cal'></MTSetVarBlock><MTGetVar name='MTVersions4{4.0}'>;<MTGetVar name='MTVersions4{4.01}'>;<MTGetVar name='MTVersions4{4.1}'>;<MTGetVar name='MTVersions4{4.2}'>;
--- expected
Athena;Enterprise Solution;Boomer;;

=== test 381
--- template
<MTVar name='object3{name}' value='foo'><MTVar name='object3{price}' value='1.00'><MTVar name='object4{name}' value='bar'><MTVar name='object4{price}' value='1.13'><MTSetVar name='push(array2)' value='$object3'><MTSetVar name='push(array2)' value='$object4'><MTLoop name='array2'><MTVar name='name'>(<MTVar name='price'>)<br /></MTLoop>
--- expected
foo(1.00)<br />bar(1.13)<br />

=== test 382
--- template
<MTSetVar name='offices5[0]' value='San Francisco'><MTSetVar name='unshift(offices5)' value='Tokyo'><MTSetVarBlock name='offices5[2]'>Paris</MTSetVarBlock>--<MTGetVar name='count(offices5)'>;<MTGetVar name='offices5[1]'>;<MTGetVar name='shift(offices5)'>;<MTGetVar name='count(offices5)'>;<MTGetVar name='offices5[1]'>
--- expected
--3;San Francisco;Tokyo;2;Paris

=== test 383
--- template
<MTSetVar name='offices6[0]' value='San Francisco'><MTSetVar name='unshift(offices6)' value='Tokyo'><MTSetVarBlock name='offices6[2]'>Paris</MTSetVarBlock>--<MTSetVarBlock name='count'><MTGetVar name='count(offices6)' op='--'></MTSetVarBlock><MTFor from='0' to='$count' increment='1' glue=','><MTGetVar name='offices6[$__index__]'></MTFor>
--- expected
--Tokyo,San Francisco,Paris

=== test 384
--- template
<MTSetVar name='MTVersions5{4.0}' value='Athena'><MTSetVarBlock name='MTVersions5{4.01}'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions5{4.1}'>Boomer</MTSetVarBlock><MTSetHashVar name='MTVersions5'><MTSetVar name='4.2' value='Cal'></MTSetHashVar>--<MTLoop name='MTVersions5' sort_by='key reverse'><MTVar name='__key__'> - <MTVar name='__value__'>;</MTLoop>
--- expected
--4.2 - Cal;4.1 - Boomer;4.01 - Enterprise Solution;4.0 - Athena;

=== test 385
--- template
<MTSetVar name='MTVersions6{4.0}' value='Athena'><MTSetVarBlock name='MTVersions6{4.01}'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions6{4.1}'>Boomer<MTSetVar name='4.2' value='Cal'></MTSetVarBlock>--<MTLoop name='MTVersions6' sort_by='key'><MTVar name='__key__'> - <MTVar name='__value__'>;</MTLoop>
--- expected
--4.0 - Athena;4.01 - Enterprise Solution;4.1 - Boomer;

=== test 386
--- template
<MTSetVar name='offices7' value='San Francisco' index='0'><MTSetVar name='unshift(offices7)' value='Tokyo'><MTSetVarBlock name='offices7' index='2'>Paris</MTSetVarBlock>--<MTVar name='offices7[1]'>,<MTVar name='shift(offices7)'>,<MTSetVar name='i' value='1'><MTVar name='offices7[$i]'>
--- expected
--San Francisco,Tokyo,Paris

=== test 387
--- template
<MTSetVar name='offices8' value='San Francisco' index='0'><MTSetVar name='unshift(offices8)' value='Tokyo'><MTSetVarBlock name='offices8' index='2'>Paris</MTSetVarBlock><MTSetVar name='var_offices' value='$offices8'>--<MTVar name='var_offices[1]'>,<MTVar name='shift(var_offices)'>,<MTSetVar name='i' value='1'><MTVar name='var_offices[$i]'>
--- expected
--San Francisco,Tokyo,Paris

=== test 388
--- template
<MTSetVar name='MTVersions7' key='4.0' value='Athena'><MTSetVarBlock name='MTVersions7' key='4.01'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions7' key='4.1'>Boomer<MTSetVar name='4.2' value='Cal'></MTSetVarBlock><MTSetVar name='var_hash' value='$MTVersions7'><MTGetVar name='var_hash{4.0}'>;<MTGetVar name='var_hash{4.01}'>;<MTGetVar name='var_hash{4.1}'>;<MTGetVar name='var_hash{4.2}'>;
--- expected
Athena;Enterprise Solution;Boomer;;

=== test 389
--- template
<MTSetVar name='MTVersions8' key='4.0' value='Athena'><MTSetVarBlock name='MTVersions8' key='4.01'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions8' key='4.1'>Boomer</MTSetVarBlock><MTSetHashVar name='MTVersions8'><MTSetVarBlock name='4.2'>Cal</MTSetVarBlock></MTSetHashVar><MTGetVar name='delete(MTVersions8{4.0})'>;<MTGetVar name='MTVersions8{4.0}'>;<MTSetVar name='delete(MTVersions8{4.01})'>;<MTGetVar name='MTVersions8{4.01}'>;<MTGetVar name='MTVersions8' function='delete' key='4.2'>;<MTGetVar name='MTVersions8' function='delete' key='4.1'>;<MTGetVar name='MTVersions8' key='4.1'>;
--- expected
Athena;;;;Cal;Boomer;;

=== test 390
--- template
<MTSetVar name='offices9' value='San Francisco' index='0'><MTSetVar name='unshift(offices9)' value='Tokyo'><MTSetVarBlock name='offices9' index='2'>Paris</MTSetVarBlock>--<MTIf name='offices9' index='2' eq='Paris'>TRUE<MTElse>FALSE</MTIf>,<MTIf name='offices9[1]' eq='San Francisco'>TRUE<MTElse>FALSE</MTIf>,<MTVar name='idx' value='0'><MTIf name='offices9[$idx]' eq='San Francisco'><MTVar name='offices9[0]'><MTElse name='offices9[2]' eq='San Francisco'>TRUE<MTElse>FALSE</MTIf>,<MTIf name='offices9' index='3' eq='1'><MTIgnore>value is undef so it is always evaluated false.</MTIgnore>TRUE<MTElse>FALSE</MTIf>,
--- expected
--TRUE,TRUE,FALSE,FALSE,

=== test 391
--- template
<MTSetVar name='MTVersions8' key='4.0' value='Athena'><MTSetVarBlock name='MTVersions8' key='4.01'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions8' key='4.1'>Boomer</MTSetVarBlock><MTSetVar name='var_hash' value='$MTVersions8'><MTIf name='var_hash{4.0}' eq='Enterprise Solution'>TRUE<MTElse>FALSE</MTIf>;<MTIf name='var_hash{4.01}' eq='Enterprise Solution'>TRUE<MTElse>FALSE</MTIf>;<MTIf name='var_hash' key='4.2' eq='Boomer'>TRUE<MTElse>FALSE</MTIf>;<MTIf name='MTVersions8{4.1}' ne='Boomer'><MTVar name='MTVersions8{4.1}'><MTElse name='MTVersions8{4.1}' eq='Cal'>TRUE<MTElse>FALSE</MTIf>;
--- expected
FALSE;TRUE;FALSE;FALSE;

=== test 392
--- template
<MTSetVar name='num' value='1'><MTGetVar name='num'>;<MTIf name='num' eq='1'>TRUE<MTElse>FALSE</MTIf>;<MTGetVar name='num' value='20' op='mul'>;<MTIf name='num' value='3' op='*' eq='60'>TRUE<MTElse>FALSE</MTIf>;<MTIf name='num' value='3' op='+' eq='4'>TRUE<MTElse name='num' op='+' value='4' eq='5'>555<MTElse>FALSE</MTIf>;
--- expected
1;TRUE;20;FALSE;TRUE;

=== test 393
--- template
<MTAssets lastn='1'><$MTAssetLabel$></MTAssets>
--- expected
Image photo

=== test 394
--- template
<MTAssets lastn='1'><$MTAssetDescription$></MTAssets>
--- expected
This is a test photo.

=== test 395
--- template
<MTSetVar name='val' value='0'><MTIfNonEmpty name="val">zero</MTIfNonEmpty>
--- expected
zero

=== test 396
--- template
<mt:setvar name='foo' value='hoge'><mt:if name='foo' eq='hoge'>value is hoge.<mt:elseif name='foo' eq='koge'>value is koge.<mt:else eq='joge'>value is joge.<mt:elseif eq='moge'>value is moge.<mt:else>value is <mt:getvar name='foo'>.</mt:if>
--- expected
value is hoge.

=== test 397
--- template
<mt:setvar name='foo' value='koge'><mt:if name='foo' eq='hoge'>value is hoge.<mt:elseif name='foo' eq='koge'>value is koge.<mt:else eq='joge'>value is joge.<mt:elseif eq='moge'>value is moge.<mt:else>value is <mt:getvar name='foo'>.</mt:if>
--- expected
value is koge.

=== test 398
--- template
<mt:setvar name='foo' value='joge'><mt:if name='foo' eq='hoge'>value is hoge.<mt:elseif name='foo' eq='koge'>value is koge.<mt:else eq='joge'>value is joge.<mt:elseif eq='moge'>value is moge.<mt:else>value is <mt:getvar name='foo'>.</mt:if>
--- expected
value is joge.

=== test 399
--- template
<mt:setvar name='foo' value='moge'><mt:if name='foo' eq='hoge'>value is hoge.<mt:elseif name='foo' eq='koge'>value is koge.<mt:else eq='joge'>value is joge.<mt:elseif eq='moge'>value is moge.<mt:else>value is <mt:getvar name='foo'>.</mt:if>
--- expected
value is moge.

=== test 400
--- template
<mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>value is hoge.<mt:elseif name='foo' eq='koge'>value is koge.<mt:else eq='joge'>value is joge.<mt:elseif eq='moge'>value is moge.<mt:else>value is <mt:getvar name='foo'>.</mt:if>
--- expected
value is poge.

=== test 401
--- template
<mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'><mt:else>value is <mt:var name='foo'></mt:if>
--- expected
value is poge

=== test 402
--- template
<mt:setvar name='foo' value='1'><mt:if name='bar'>true<mt:else>false</mt:if>
--- expected
false

=== test 403
--- template
<MTTags glue=',' sort_by='rank'><MTTagLabel> <MTTagRank></MTTags>
--- expected
verse 1,rain 2,anemones 4,grandpa 6,strolling 6

=== test 404
--- template
<MTSubCategories category='foo'><MTCategoryLabel></MTSubCategories>
--- expected
subfoo

=== test 405
--- template
<MTCategories sort_by='label' sort_order='ascend' show_empty='1'><MTCategoryLabel>'<MTSubCategories><MTCategoryLabel></MTSubCategories>'</MTCategories>
--- expected
bar''foo'subfoo'subfoo''

=== test 406
--- template
<MTEntries recently_commented_on='3' glue=','><MTEntryTitle></MTEntries>
--- expected
Verse 2,Verse 3,A Rainy Day

=== test 407
--- template
value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>hoge<mt:elseif name='foo' eq='moge'>moge<mt:else>false</mt:if>
--- expected
value is false

=== test 408
--- template
value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>hoge<mt:else name='foo' eq='moge'>moge<mt:else>false</mt:if>
--- expected
value is false

=== test 409
--- SKIP
--- template
value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>hoge<mt:elseif eq='moge'>moge<mt:else>false</mt:if>
--- expected
value is false

=== test 410
--- SKIP
--- template
value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>hoge<mt:else eq='moge'>moge<mt:else>false</mt:if>
--- expected
value is false

=== test 411
--- SKIP
--- template
value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>hoge<mt:elseif eq='poge'>poge<mt:else>false</mt:if>
--- expected
value is poge

=== test 412
--- SKIP
--- template
value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>hoge<mt:else eq='poge'>poge<mt:else>false</mt:if>
--- expected
value is poge

=== test 413
--- SKIP
--- template
<mt:var name='ar[0]' value='A'><mt:var name='ar[1]' value='B'><mt:var name='ar[2]' value='C'><mt:loop name='ar'><mt:if name='__value__' eq='A'><mt:var name='__counter__'><mt:elseif eq='B'><mt:var name='__counter__'><mt:else><mt:var name='__counter__'></mt:if></mt:loop>
--- expected
123

=== test 414
--- SKIP
--- template
<mt:var name='ar[0]' value='A'><mt:var name='ar[1]' value='B'><mt:var name='ar[2]' value='C'><mt:loop name='ar'><mt:if name='__value__' eq='A'><mt:var name='__counter__'><mt:else eq='B'><mt:var name='__counter__'><mt:else><mt:var name='__counter__'></mt:if></mt:loop>
--- expected
123

=== test 415
--- SKIP
--- template
value is <mt:setvar name='foo' value='fuga'><mt:if name='foo' eq='hoge'>hoge<mt:elseif eq='poge'>poge<mt:elseif eq='fuga'>fuga<mt:else>false</mt:if>
--- expected
value is fuga

=== test 416
--- SKIP
--- template
value is <mt:setvar name='foo' value='fuga'><mt:if name='foo' eq='hoge'>hoge<mt:else eq='poge'>poge<mt:else eq='fuga'>fuga<mt:else>false</mt:if>
--- expected
value is fuga

=== test 417
--- SKIP
--- template
<mt:var name='ar[0]' value='A'><mt:var name='ar[1]' value='B'><mt:var name='ar[2]' value='C'><mt:loop name='ar'><mt:if name='__value__' eq='A'><mt:var name='__counter__'><mt:elseif eq='B'><mt:var name='__counter__'><mt:elseif eq='C'>hoge!<mt:else><mt:var name='__counter__'></mt:if></mt:loop>
--- expected
12hoge!

=== test 418
--- SKIP
--- template
<mt:var name='ar[0]' value='A'><mt:var name='ar[1]' value='B'><mt:var name='ar[2]' value='C'><mt:loop name='ar'><mt:if name='__value__' eq='A'><mt:var name='__counter__'><mt:else eq='B'><mt:var name='__counter__'><mt:else eq='C'>hoge!<mt:else><mt:var name='__counter__'></mt:if></mt:loop>
--- expected
12hoge!

=== test 419
--- template
<mt:setvar name='foo' value='c'><mt:if name='foo' eq='a'>value is a.<mt:elseif eq='b'>value is b.<mt:else eq='c'>value is c.<mt:elseif eq='d'>value is d.<mt:else>value is this: <mt:getvar name='foo'>.</mt:if>
--- expected
value is c.

=== test 420
--- template
<mt:setvar name='foo' value='c'><mt:setvar name='bar' value='xxx'><mt:if name='foo' eq='a'>value is a.<mt:else><mt:if name='bar' eq='aaa'><mt:else eq='c'>value is c<mt:else eq='xxx'>value is xxx.</mt:if></mt:if>
--- expected
value is xxx.

=== test 421
--- template
<mt:setvar name='foo' value='c'><mt:setvar name='bar' value='xxx'><mt:if name='foo' eq='a'>value is a.<mt:elseif name='bar' eq='aaa'><mt:else eq='c'>value is c<mt:else eq='xxx'>value is xxx.</mt:if>
--- expected
value is xxx.

=== test 422
--- template
<mt:var name='foo' value='2'><mt:if name='foo' eq='1'>incorrect<mt:else eq='2'>correct<mt:else eq='3'>incorrect</mt:if>
--- expected
correct

=== test 423
--- template
<mt:var name='foo1' value='foo-1'><mt:var name='foo2' value='foo-2'><mt:if name='foo1' eq='abc'>incorrect-1<mt:else eq='def'>incorrect-2<mt:else eq='foo-1'>CORRECT-1<mt:if name='foo2' eq='ghi'>incorrect-3<mt:else eq='foo-2'>CORRECT-2<mt:else>incorrect-4</mt:if><mt:else eq='foo-2'>incorrect-5<mt:else>incorrect-6</mt:if>
--- expected
CORRECT-1CORRECT-2

=== test 424
--- template
<mt:entries limit='1'><mt:EntryTitle></mt:Entries>
--- expected
A Rainy Day

=== test 425
--- template
<mt:entries category='NOT foo'><mt:EntryTitle>;</mt:Entries>
--- expected
A Rainy Day;Verse 5;Verse 4;Verse 2;Verse 1;

=== test 426
--- template
<mt:entries lastn='1' tags='verse'><mt:EntryTitle></mt:Entries>
--- expected
Verse 5

=== test 427
--- template
<mt:authors username='Chuck D'><MTAuthorName>;<MTAuthorDisplayName>;<MTAuthorEmail>;<MTAuthorURL>;</mt:authors>
--- expected
Chuck D;Chucky Dee;chuckd@example.com;http://chuckd.com/;

=== test 428
--- template
<mt:authors id='2' username='Bob D'><MTAuthorName>;<MTAuthorDisplayName>;<MTAuthorEmail>;<MTAuthorURL>;</mt:authors>
--- expected
Chuck D;Chucky Dee;chuckd@example.com;http://chuckd.com/;

=== test 429
--- template
<mt:authors id='2'><MTAuthorName>;<MTAuthorDisplayName>;<MTAuthorEmail>;<MTAuthorURL>;</mt:authors>
--- expected
Chuck D;Chucky Dee;chuckd@example.com;http://chuckd.com/;

=== test 430
--- template
<mt:Websites><mt:WebsiteName></mt:Websites>
--- expected
Test site

=== test 431
--- template
<mt:Websites><mt:WebsiteDescription></mt:Websites>
--- expected
Narnia None Test Website

=== test 432
--- template
<mt:Websites><mt:WebsiteURL></mt:Websites>
--- expected
http://narnia.na/

=== test 433
--- template
<mt:Websites><mt:WebsitePath></mt:Websites>
--- expected
TEST_ROOT/

=== test 434
--- template
<mt:Websites><mt:WebsiteID></mt:Websites>
--- expected
2

=== test 435
--- template
<mt:Websites><mt:WebsiteTimezone></mt:Websites>
--- expected
-03:30

=== test 436
--- template
<mt:Websites><mt:WebsiteTimezone no_colon='1'></mt:Websites>
--- expected
-0330

=== test 437
--- template
<mt:Websites><mt:WebsiteLanguage></mt:Websites>
--- expected
en_us

=== test 438
--- template
<mt:Websites><mt:WebsiteLanguage locale='1'></mt:Websites>
--- expected
en_US

=== test 439
--- template
<mt:Websites><mt:IfWebsite>1</mt:IfWebsite></mt:Websites>
--- expected
1

=== test 443
--- template
<mt:Websites><mt:WebsiteFileExtension></mt:Websites>
--- expected
.html

=== test 444
--- template
<MTBlogURL id='1'>
--- expected
http://narnia.na/nana/

=== test 445
--- template
<MTBlogRelativeURL id='1'>
--- expected
/nana/

=== test 446
--- template
<MTBlogSitePath id='1'>
--- expected
TEST_ROOT/site/

=== test 447
--- template
<MTBlogArchiveURL id='1'>
--- expected
http://narnia.na/nana/archives/

=== test 448
--- template
<mt:Websites><mt:WebsiteHasBlog>true</mt:WebsiteHasBlog></mt:Websites>
--- expected
true

=== test 449
--- template
<mt:BlogParentWebsite><mt:WebsiteID></mt:BlogParentWebsite>
--- expected
2

=== test 450
--- SKIP
--- template
<MTCalendar><MTCalendarWeekHeader month='197801'><tr></MTCalendarWeekHeader><td><MTCalendarCellNumber>,<MTCalendarIfEntries><MTEntries lastn='1'><a href='<$MTEntryPermalink$>'><$MTCalendarDay$></a></MTEntries></MTCalendarIfEntries><MTCalendarIfNoEntries><$MTCalendarDay$></MTCalendarIfNoEntries><MTCalendarIfBlank>&nbsp;</MTCalendarIfBlank></td><MTCalendarWeekFooter></tr></MTCalendarWeekFooter></MTCalendar>', 'e' : '<tr><td>1,&nbsp;</td><td>2,&nbsp;</td><td>3,&nbsp;</td><td>4,&nbsp;</td><td>5,&nbsp;</td><td>6,1</td><td>7,2</td></tr><tr><td>8,3</td><td>9,4</td><td>10,5</td><td>11,6</td><td>12,7</td><td>13,8</td><td>14,9</td></tr><tr><td>15,10</td><td>16,11</td><td>17,12</td><td>18,13</td><td>19,14</td><td>20,15</td><td>21,16</td></tr><tr><td>22,17</td><td>23,18</td><td>24,19</td><td>25,20</td><td>26,21</td><td>27,22</td><td>28,23</td></tr><tr><td>29,24</td><td>30,25</td><td>31,26</td><td>32,27</td><td>33,28</td><td>34,29</td><td>35,30</td></tr>
--- expected


=== test 451
--- SKIP
--- template
<MTGoogleSearch query='six apart' results='1'><MTGoogleSearchResult property='URL'></MTGoogleSearch>
--- expected
http://www.sixapart.com/

=== test 463
--- template
<MTCategories><MTCategoryBasename></MTCategories>
--- expected
foosubfoo

=== test 467
--- template
<MTSubCategories category='subfoo' include_current='1'><MTParentCategories glue='-' exclude_current='1'><MTCategoryLabel></MTParentCategories></MTSubCategories>
--- expected
foo

=== test 468
--- template
<MTSubCategories category='subfoo' include_current='1'><MTParentCategories glue='-'><MTCategoryLabel></MTParentCategories></MTSubCategories>
--- expected
foo-subfoo

=== test 476
--- template
<MTBlogs><MTBlogCategoryCount></MTBlogs>
--- expected
3


=== test 478
--- template
<MTBlogs><MTBlogTemplatesetID></MTBlogs>
--- expected
classic-blog

=== test 479
--- template
<MTBlogs><MTBlogThemeID></MTBlogs>
--- expected
classic-blog

=== test 480
--- template
<MTAuthors lastn="1"><MTAuthorEntryCount></MTAuthors>
--- expected
5

=== test 481
--- template
<MTAuthors lastn="1"><MTAuthorHasEntry><MTAuthorName setvar="author_name"><MTEntries author="$author_name" lastn="1">has</MTEntries></MTAuthorHasEntry></MTAuthors>
--- expected
has

=== test 482
--- template
<MTAuthors lastn="1"><MTAuthorHasPage><MTAuthorName setvar="author_name"><MTPages author="$author_name" lastn="1">has</MTPages></MTAuthorHasPage></MTAuthors>
--- expected
has

=== test 483
--- template
<MTAuthors lastn="1"><MTAuthorNext><MTAuthorName></MTAuthorNext></MTAuthors>
--- expected


=== test 484
--- template
<MTAuthors lastn="1"><MTAuthorPrevious><MTAuthorName></MTAuthorPrevious></MTAuthors>
--- expected
Bob D

=== test 485
--- template
<MTAuthors lastn="1"><MTAuthorRank></MTAuthors>
--- expected


=== test 486
--- template
<MTAuthors lastn="1"><MTAuthorScore></MTAuthors>
--- expected


=== test 487
--- template
<MTAuthors lastn="1"><MTAuthorScoreAvg></MTAuthors>
--- expected


=== test 488
--- template
<MTAuthors lastn="1"><MTAuthorScoreCount></MTAuthors>
--- expected


=== test 489
--- template
<MTAuthors lastn="1"><MTAuthorScoreHigh></MTAuthors>
--- expected


=== test 490
--- template
<MTAuthors lastn="1"><MTAuthorScoreLow></MTAuthors>
--- expected


=== test 491
--- skip_php
[% no_php_gd %]
--- template
<MTAuthors lastn="1"><MTAuthorUserpic></MTAuthors>
--- expected
<img src="/mt-static/support/assets_c/userpics/userpic-2-100x100.png?3" width="100" height="100" alt="Image photo" />

=== test 492
--- template
<MTAuthors lastn="1"><MTAuthorUserpicAsset><MTAssetFileName></MTAuthorUserpicAsset></MTAuthors>
--- expected
test.jpg

=== test 493
--- skip_php
[% no_php_gd %]
--- template
<MTAuthors lastn="1"><MTAuthorUserpicURL></MTAuthors>
--- expected
/mt-static/support/assets_c/userpics/userpic-2-100x100.png

=== test 494
--- template
<MTAuthors lastn="1"><MTAuthorBasename></MTAuthors>
--- expected
chucky_dee

=== test 495
--- template
<MTAssets assets_per_row="2"><MTAssetIsFirstInRow>First</MTAssetIsFirstInRow><$MTAssetID$><MTAssetIsLastInRow>Last</MTAssetIsLastInRow></MTAssets>
--- expected
First17LastFirst65LastFirst2Last

=== test 496
--- template
<MTAssets lastn='1'><MTAssetIfTagged tag="alpha">Tagged<MTElse>Not Tagged</MTAssetIfTagged></MTAssets>
--- expected
Tagged

=== test 497
--- template
<MTAssets lastn='1'><MTAssetIfTagged tag="empty_tag_name">Tagged<MTElse>Not Tagged</MTAssetIfTagged></MTAssets>
--- expected
Not Tagged

=== test 498
--- template
<MTArchiveList type='Individual'><MTArchiveListHeader><MTArchiveTypeLabel></MTArchiveListHeader></MTArchiveList>
--- expected
Entry

=== test 499
--- SKIP
--- template
<MTUserSessionCookieDomain>
--- expected
.narnia.na

=== test 500
--- SKIP
--- template
<MTUserSessionCookieName>
--- expected
mt_blog_user

=== test 501
--- SKIP
--- template
<MTUserSessionCookiePath>
--- expected
/

=== test 502
--- SKIP
--- template
<MTUserSessionCookieTimeout>
--- expected
14400


=== test 504
--- template
<MTWebsiteHost>
--- expected
narnia.na

=== test 506
--- template
<MTWebsitePageCount>
--- expected
1

=== test 508
--- template
<MTWebsiteRelativeURL>
--- expected
/

=== test 509
--- template
<MTWebsiteThemeID>
--- expected
classic-website

=== test 510
--- SKIP
--- template
<MTNotifyScript>
--- expected
mt-add-notify.cgi

=== test 511
--- template
<MTPages lastn='1'><MTPageIfTagged tag='page3'><MTPageTitle></MTPageIfTagged></MTPages>
--- expected
Page #3

=== test 512
--- template
<MTPages lastn='1' offset='1'><MTPageNext><MTPageTitle></MTPageNext></MTPages>
--- expected
Page #3

=== test 513
--- template
<MTPages lastn='1'><MTPagePrevious><MTPageTitle></MTPagePrevious></MTPages>
--- expected
Page #2

=== test 514
--- template
<MTPages lastn='3'><MTPagesHeader><ul></MTPagesHeader><li><MTPageTitle></li><MTPagesFooter></ul></MTPagesFooter></MTPages>
--- expected
<ul><li>Page #3</li><li>Page #2</li><li>Page #1</li></ul>

=== test 515
--- template
<MTFolders><MTParentFolder><MTFolderLabel></MTParentFolder></MTFolders>
--- expected
download

=== test 516
--- template
<MTFolders><MTHasParentFolder><MTFolderLabel></MTHasParentFolder></MTFolders>
--- expected
nightly

=== test 524
--- template
<MTProductName>
--- expected
Movable Type

=== test 524.1
--- mt_config
{HideVersion => 0}
--- template
<MTProductName version="1">
--- expected regexp
Movable Type [0-9.]+

=== test 524.2
--- mt_config
{HideVersion => 1}
--- template
<MTProductName version="1">
--- expected
Movable Type

=== test 525
--- template
<MTSection>Content</MTSection>
--- expected
Content

=== test 526
--- template
<MTSetVars>
foo=Foo
</MTSetVars><MTGetVar name='foo'>
--- expected
Foo

=== test 527
--- template
<MTSetVarTemplate name='foo_template'><MTSetVar name='foo' value='Bar'></MTSetVarTemplate><MTSetVar name='foo' value='Foo'><MTVar name='foo_template'><MTGetVar name='foo'>
--- expected
Bar

=== test 528
--- template
<MTStaticFilePath>
--- expected
STATIC_FILE_PATH

=== test 529
--- template
<MTSubFolders><MTIF tag='FolderID' eq='21'><MTFolderLabel>;<MTSubfolderRecurse></MTIF></MTSubFolders>
--- expected


=== test 530
--- template
<MTSupportDirectoryURL>
--- expected
/mt-static/support/

=== test 531
--- template
<MTTemplateNOTE note='Comment'>
--- expected


=== test 532
--- template
<MTFolders><MTIF tag='FolderID' eq='22'><MTToplevelFolder><MTFolderLabel></MTToplevelFolder></MTIF></MTFolders>
--- expected
download

=== test 533
--- template
<MTSetVar name='foo' value='Foo'><MTUnless name='foo' eq='Bar'>Content</MTUnless>
--- expected
Content

=== test 534
--- template
<MTSetVar name='foo' value='Foo'><MTUnless name='foo' eq='Foo'>Content</MTUnless>
--- expected


=== test 535
--- template
<MTFolders><MTFolderHeader><ul></MTFolderHeader><li><MTFolderLabel></li><MTFolderFooter></ul></MTFolderFooter></MTFolders>
--- expected
<ul><li>download</li><li>info</li><li>nightly</li></ul>

=== test 536
--- template
<MTFolders show_empty='1' glue=','><MTFolderLabel>-<MTFolderNext show_empty='1'><MTFolderLabel></MTFolderNext></MTFolders>
--- expected
download-info,info-,nightly-

=== test 537
--- template
<MTFolders show_empty='1' glue=','><MTFolderLabel>-<MTFolderPrevious show_empty='1'><MTFolderLabel></MTFolderPrevious></MTFolders>
--- expected
download-,info-download,nightly-

=== test 538
--- template
<MTFolders><MTHasSubFolders><MTSubFolders><MTFolderID></MTSubFolders></MTHasSubFolders></MTFolders>
--- expected
22

=== test 539
--- template
<MTHTTPContentType type='application/xml'>
--- expected


=== test 540
--- template
<MTIfAuthor>HasAuthor:Outside</MTIfAuthor><MTAuthors lastn='1'><MTIfAuthor>HasAuthor:Inside</MTIfAuthor></MTAuthors>
--- expected
HasAuthor:Inside

=== test 541
--- template
<MTIfBlog>HasBlog</MTIfBlog>
--- expected
HasBlog

=== test 544
--- template
<MTIfExternalUserManagement>External</MTIfExternalUserManagement>
--- expected


=== test 545
--- template
<MTPages id='22'><MTIfFolder name='download'>download</MTIfFolder></MTPages>
--- expected
download

=== test 546
--- template
<MTPages id='23'><MTIfFolder name='download'>download</MTIfFolder></MTPages>
--- expected


=== test 547
--- template
<MTIfImageSupport>Supported</MTIfImageSupport>
--- expected
Supported

=== test 550
--- template
<MTDate ts='20101010101010'>
--- expected
October 10, 2010 10:10 AM

=== test 551
--- template
<MTEntriesCount>
--- expected
6

=== test 552
--- template
<MTEntries lastn='3'><MTDateHeader>Header:<MTEntryDate>,</MTDateHeader><MTDateFooter>Footer:<MTEntryDate>,</MTDateFooter></MTEntries>
--- expected
Header:January 31, 1978  7:45 AM,Footer:January 31, 1978  7:45 AM,Header:January 31, 1965  7:45 AM,Footer:January 31, 1965  7:45 AM,Header:January 31, 1964  7:45 AM,Footer:January 31, 1964  7:45 AM,

=== test 553
--- template
<MTEntries lastn='3'><MTEntriesHeader><ul></MTEntriesHeader><li><MTEntryTitle></li><MTEntriesFooter><ul></MTEntriesFooter></MTEntries>
--- expected
<ul><li>A Rainy Day</li><li>Verse 5</li><li>Verse 4</li><ul>

=== test 554
--- template
<MTEntries lastn="1"><MTEntryAdditionalCategories glue=','><MTCategoryLabel></MTEntryAdditionalCategories></MTEntries>
--- expected


=== test 555
--- template
<MTEntries lastn="1"><MTEntryAuthorID></MTEntries>
--- expected
2

=== test 556
--- skip_php
[% no_php_gd %]
--- template
<MTEntries lastn="1"><MTEntryAuthorUserpic></MTEntries>
--- expected
<img src="/mt-static/support/assets_c/userpics/userpic-2-100x100.png?3" width="100" height="100" alt="Image photo" />

=== test 557
--- template
<MTEntries lastn="1"><MTEntryAuthorUserpicAsset><MTAssetFilename></MTEntryAuthorUserpicAsset></MTEntries>
--- expected
test.jpg

=== test 558
--- skip_php
[% no_php_gd %]
--- template
<MTEntries lastn="1"><MTEntryAuthorUserpicURL></MTEntries>
--- expected
/mt-static/support/assets_c/userpics/userpic-2-100x100.png

=== test 559
--- template
<MTEntries lastn="1"><MTEntryBlogDescription></MTEntries>
--- expected
Narnia None Test Blog

=== test 560
--- template
<MTEntries lastn="1"><MTEntryBlogID></MTEntries>
--- expected
1

=== test 561
--- template
<MTEntries lastn="1"><MTEntryBlogName></MTEntries>
--- expected
None

=== test 562
--- template
<MTEntries lastn="1"><MTEntryBlogURL></MTEntries>
--- expected
http://narnia.na/nana/

=== test 563
--- template
<MTEntries lastn="1"><MTEntryClassLabel lower_case='1'></MTEntries>
--- expected
entry

=== test 564
--- template
<MTEntries lastn="1"><MTEntryCreatedDate></MTEntries>
--- expected
January 31, 1978  7:45 AM

=== test 565
--- template
<MTEntries category="foo" lastn="1"><MTEntryIfCategory category='foo'><MTCategoryLabel></MTEntryIfCategory></MTEntries>
--- expected
foo

=== test 566
--- template
<MTEntries lastn="1"><MTEntryModifiedDate></MTEntries>
--- expected
January 31, 1978  7:46 AM

=== test 567
--- template
<MTIncludeBlock module='header-line'>Title</MTIncludeBlock>
--- expected
<h1>Title</h1>

=== test 568
--- template
<MTIncludeBlock module='header-line'>Title</MTIncludeBlock>
--- expected
<h1>Title</h1>

=== test 569
--- template
<MTSetVarBlock name="foo">a
b

c</MTSetVarBlock><MTGetVar name="foo" count_paragraphs="1">
--- expected
3

=== test 570
--- template
<MTSetVarBlock name="foo">-1234567</MTSetVarBlock><MTGetVar name="foo" numify="1">
--- expected
-1,234,567

=== test 571
--- template
<MTSetVarBlock name="foo">Foo</MTSetVarBlock><MTGetVar name="foo" encode_sha1="1">
--- expected
201a6b3053cc1422d2c3670b62616221d2290929

=== test 572
--- template
<MTSetVarBlock name="foo">Foo</MTSetVarBlock><MTGetVar name="foo" spacify=" ">
--- expected
F o o

=== test 573
--- template
<MTSetVarBlock name="foo">Foo</MTSetVarBlock><MTGetVar name="foo" count_characters="1">
--- expected
3

=== test 574
--- template
<MTSetVarBlock name="foo">Foo</MTSetVarBlock><MTGetVar name="foo" cat="Bar">
--- expected
FooBar

=== test 575
--- template
<MTSetVarBlock name="foo">FooBar</MTSetVarBlock><MTGetVar name="foo" regex_replace="/Fo*/i","Bar">
--- expected
BarBar

=== test 576
--- template
<MTSetVarBlock name="foo">Foo Bar Baz</MTSetVarBlock><MTGetVar name="foo" count_words="1">
--- expected
3

=== test 577
--- template
<MTSetVarBlock name="foo">foo</MTSetVarBlock><MTGetVar name="foo" capitalize="1">
--- expected
Foo

=== test 578
--- template
<MTSetVarBlock name="foo">FooBar</MTSetVarBlock><MTGetVar name="foo" replace="Bar","Foo">
--- expected
FooFoo

=== test 578-2
--- ignore_php_warnings
--- template
<MTSetVarBlock name="foo">FooBar</MTSetVarBlock><MTGetVar name="foo" replace="Bar","$undef">
--- expected
Foo

=== test 579
--- template
[
<MTSetVarBlock name="foo">aaa
bbb</MTSetVarBlock><MTGetVar name="foo" indent="2">
]
--- expected
[
  aaa
  bbb
]

=== test 580
--- template
[
<MTSetVarBlock name="foo">aaa
bbb</MTSetVarBlock><MTGetVar name="foo" indent="2">
]
--- expected
[
  aaa
  bbb
]

=== test 581
--- template
<MTSetVar name="foo" value="Foo"><MTSetVar name="bar" value="<MTGetVar name='foo'>"><MTGetVar name="bar" mteval="1">
--- expected
Foo

=== test 582
--- template
<MTSetVarBlock name="foo"><span>Foo</span></MTSetVarBlock><MTGetVar name="foo" strip_tags="1">
--- expected
Foo

=== test 583
--- template
<MTSetVar name="foo" value="Foo"><MTVar name="foo" setvar="bar"><MTVar name="bar">
--- expected
Foo

=== test 584
--- template
<MTSetVarBlock name="foo">1234567890</MTSetVarBlock><MTGetVar name="foo" wrap_text="4">
--- expected
123
456
789
0

=== test 585
--- template
<MTSetVarBlock name="foo">123
456</MTSetVarBlock><MTGetVar name="foo" nl2br="xhtml" strip="">
--- expected
123<br/>456

=== test 586
--- template
<MTSetVarBlock name="foo">  Foo  Bar  </MTSetVarBlock><MTGetVar name="foo" strip="">
--- expected
FooBar

=== test 587
--- template
<MTSetVarBlock name="foo">  Foo  Bar  </MTSetVarBlock><MTGetVar name="foo" strip="&nbsp;">
--- expected
&nbsp;Foo&nbsp;Bar&nbsp;

=== test 588
--- template
<MTSetVarBlock name="foo">1</MTSetVarBlock><MTGetVar name="foo" string_format="%06d">
--- expected
000001

=== test 589
--- template
<MTSetVarBlock name="foo"></MTSetVarBlock><MTGetVar name="foo" _default="Default">
--- expected
Default

=== test 590
--- template
<MTSetVarBlock name="foo">Foo</MTSetVarBlock><MTGetVar name="foo" _default="Default">
--- expected
Foo

=== test 591
--- template
<MTSetVarBlock name="foo"><span>Foo</span></MTSetVarBlock><MTGetVar name="foo" escape="html">
--- expected
&lt;span&gt;Foo&lt;/span&gt;

=== test 592
--- SKIP
--- template
<MTSetVarBlock name="foo"><span>Foo</span></MTSetVarBlock><MTGetVar name="foo" escape="htmlall">
--- expected
&lt;span&gt;Foo&lt;/span&gt;

=== test 593
--- template
<MTSetVarBlock name="foo">http://example.com/?q=@</MTSetVarBlock><MTGetVar name="foo" escape="url">
--- expected
http%3A%2F%2Fexample.com%2F%3Fq%3D%40

=== test 594
--- SKIP
--- template
<MTSetVarBlock name="foo">http://example.com/?q=@</MTSetVarBlock><MTGetVar name="foo" escape="urlpathinfo">
--- expected
http%3A//example.com/%3Fq%3D%40

=== test 595
--- template
<MTSetVarBlock name="foo">http://example.com/?q=@</MTSetVarBlock><MTGetVar name="foo" escape="quotes">
--- expected
http://example.com/?q=@

=== test 596
--- SKIP
--- template
<MTSetVarBlock name="foo">http://example.com/?q=@</MTSetVarBlock><MTGetVar name="foo" escape="hex">
--- expected
%68%74%74%70%3a%2f%2f%65%78%61%6d%70%6c%65%2e%63%6f%6d%2f%3f%71%3d%40

=== test 597
--- SKIP
--- template
<MTSetVarBlock name="foo">http://example.com/?q=@</MTSetVarBlock><MTGetVar name="foo" escape="hexentity">
--- expected
&#x68;&#x74;&#x74;&#x70;&#x3a;&#x2f;&#x2f;&#x65;&#x78;&#x61;&#x6d;&#x70;&#x6c;&#x65;&#x2e;&#x63;&#x6f;&#x6d;&#x2f;&#x3f;&#x71;&#x3d;&#x40;

=== test 598
--- SKIP
--- template
<MTSetVarBlock name="foo">http://example.com/?q=@</MTSetVarBlock><MTGetVar name="foo" escape="decentity">
--- expected
&#104;&#116;&#116;&#112;&#58;&#47;&#47;&#101;&#120;&#97;&#109;&#112;&#108;&#101;&#46;&#99;&#111;&#109;&#47;&#63;&#113;&#61;&#64;

=== test 599
--- SKIP
--- template
<MTSetVarBlock name="foo"><script>alert("test");</script></MTSetVarBlock><MTGetVar name="foo" escape="javascript">
--- expected
\<s\cript\>alert(\"test\");\<\/s\cript\>

=== test 600
--- template
<MTSetVarBlock name="foo">test@example.com</MTSetVarBlock><MTGetVar name="foo" escape="mail">
--- expected
test [AT] example [DOT] com

=== test 601
--- template
<MTSetVarBlock name="foo"><span>Foo</span></MTSetVarBlock><MTGetVar name="foo" escape="nonstd">
--- expected
<span>Foo</span>

=== test 602
--- template
<MTSetVarBlock name="foo"><a href="http://example.com/">Example</a></MTSetVarBlock><MTGetVar name="foo" nofollowfy="1">
--- expected
<a href="http://example.com/" rel="nofollow">Example</a>

=== test 603
--- template
<MTSetVarBlock name="foo"><a href="http://example.com/" rel="next">Example</a></MTSetVarBlock><MTGetVar name="foo" nofollowfy="1">
--- expected
<a href="http://example.com/" rel="nofollow next">Example</a>

=== test 604
--- template
<MTEntries tags='@grandparent' lastn='1'><MTEntryTitle></MTEntries>
--- expected


=== test 605
--- template
<MTEntries lastn="1"><MTEntryTitle trim_to="6+..."></MTEntries>
--- expected
A Rain...

=== test 606
--- template
<MTAuthors id="2"><MTAuthorScore namespace='unit test'></MTAuthors>
--- expected
2

=== test 607
--- template
<MTAuthors id="2"><MTAuthorScoreAvg namespace='unit test'></MTAuthors>
--- expected
2.00

=== test 608
--- template
<MTAuthors id="2"><MTAuthorScoreCount namespace='unit test'></MTAuthors>
--- expected
1

=== test 609
--- template
<mt:Authors need_entry='0' namespace='unit test' sort_by='score' offset='1'><mt:AuthorName>,</mt:Authors>
--- expected
Chuck D,Melody,

=== test 610
--- template
<mt:Authors need_entry='0' namespace='unit test' sort_by='score' offset='2'><mt:AuthorName>,</mt:Authors>
--- expected
Melody,

=== test 611
--- template
<MTEntries id="6"><MTEntryPrimaryCategory><MTCategoryLabel></MTEntryPrimaryCategory></MTEntries>
--- expected
foo

=== test 612
--- template
<MTEntries id="6"><MTEntryCategories type="primary"><MTCategoryLabel></MTEntryCategories></MTEntries>
--- expected
foo

=== test 613
--- template
<MTPasswordValidationRule>
--- expected
minimum length of 8

=== test 614
--- template
<$MTSetVar name="foo614{b}" value="b"$><$MTIf name="foo614{a}"$>true<MTElse>false</MTIf>
--- expected
false

=== test 615
--- template
<mt:Archives type="Page, Individual, Category">[<$mt:ArchiveType$>]</mt:Archives>
--- expected
[Page][Individual][Category]

=== test 616
--- template
<$mt:Date ts="THREE_DAYS_AGO" relative="1"$>
--- expected
3 days ago

=== test 618
--- template
<MTEntries id="6"><$MTIf tag="EntryCategories"$>true<MTElse>false</MTIf></MTEntries>
--- expected
true

=== test 619
--- template
<MTSetVarBlock name="s">&#0; &#2; &#67; &#x2; &#x67; &#x19; &#25</MTSetVarBlock><$MTGetVar name="s" encode_xml="1"$>
--- expected
&amp;#0; &amp;#2; &#67; &amp;#x2; &#x67; &amp;#x19; &amp;#25

=== test 620
--- template
<MTEntries lastn="1"><MTEntryTitle Upper_Case="1"></MTEntries> <MTSetVar name="a1" VALUE="var-a1"><MTVar name="a1">
--- expected
A RAINY DAY var-a1

=== test 621
--- template
<MTSetVar name="foo" value="Foo"><MTSetVar name="bar" value="<MTGetVar name='foo'>"><MTGetVar name="bar" mteval="0">
--- expected
<MTGetVar name='foo'>

=== test 622
--- template
<MTSetVar name="foo" value="Foo"><MTSetVar name="bar" value="<MTGetVar name='foo'>"><MTGetVar name="bar" mteval="">
--- expected
<MTGetVar name='foo'>

=== test 623
--- template
<mt:Unless sanitize='1'><a onclick='alert(1)'>foo</a></mt:Unless>
--- expected
<a>foo</a>

=== test 624
--- template
<mt:Unless sanitize='0'><a onclick='alert(1)'>foo</a></mt:Unless>
--- expected
<a onclick='alert(1)'>foo</a>

=== test 625
--- template
<mt:Unless sanitize=''><a onclick='alert(1)'>foo</a></mt:Unless>
--- expected
<a onclick='alert(1)'>foo</a>

=== test 626
--- template
<mt:Unless numify=''>-1234567</mt:Unless>
--- expected
-1234567

=== test 627
--- template
<mt:Unless numify='0'>-1234567</mt:Unless>
--- expected
-102340567

=== test 628
--- template
<mt:SetVar name='hash' key='foo' value='bar'><mt:If name='hash'>exists</mt:If>
--- expected
exists

=== test 629
--- template
<mt:SetVar name='array' index='0' value='foo'><mt:If name='array'>exists</mt:If>
--- expected
exists

=== test 630
--- template
<mt:SetVar name='array' index='0' value='foo'><mt:GetVar name='shift(array)' setvar='trash'><mt:If name='array'><mt:Else>empty</mt:If>
--- expected
empty

=== test 631
--- template
<mt:SetVar name='hash' key='foo' value='bar'><mt:SetVar name='delete(hash)' key='foo'><mt:If name='hash'><mt:Else>empty</mt:If>
--- expected
empty

=== test 632
--- template
<MTBlogLanguage ietf="1">
--- expected
en-us

=== test 633
--- template
<MTBlogDateLanguage>
--- expected
en_us

=== test 634
--- template
<MTBlogDateLanguage locale='1'>
--- expected
en_US

=== test 635
--- template
<MTBlogDateLanguage ietf='1'>
--- expected
en-us

=== test 636
--- template
<mt:Websites><mt:WebsiteDateLanguage></mt:Websites>
--- expected
en_us

=== test 637
--- template
<mt:Websites><mt:WebsiteDateLanguage locale='1'></mt:Websites>
--- expected
en_US

=== test 638
--- template
<mt:Websites><mt:WebsiteDateLanguage ietf='1'></mt:Websites>
--- expected
en-us

=== test 639
--- template
<MTSetVar name="foo" value="0"><MTSetVar name="bar" value="0"><MTIf name="foo">1<MTElse><MTIf name="bar">2<MTElse>3</MTIf></MTIf>
--- expected
3

=== test 640
--- template
<MTIf name='foo'>1<MTElse><MTIf name='bar'>2<MTElse>3</MTElse></MTIf></MTElse></MTIf>
--- expected
3

=== test 641
--- template
<MTIf name='foo'>1<MTElse><MTIf name='bar'>2<MTElse>3</MTIf></MTElse></MTIf>
--- expected
3

=== test 642
--- template
<MTIf name='foo'>1<MTElse><MTIf name='bar'>2<MTElse>3</MTElse></MTIf></MTIf>
--- expected
3

=== test 643
--- template
<MTEntries category="fooooooooo"><MTEntryTitle></MTEntries>
--- expected


=== test 644
--- template
<MTAssets tag='alphabeta'><$MTAssetID$></MTAssets>
--- expected


=== test 645
--- template
<MTAssets tag='alpha OR beta'><$MTAssetID$></MTAssets>
--- expected
17652

=== test 646
--- template
<MTAssets tag='alpha AND beta'><$MTAssetID$></MTAssets>
--- expected
1765

=== test 647
--- template
<MTAssets tag='NOT gamma'><$MTAssetID$></MTAssets>
--- expected
2

=== test 648
--- template
<MTIgnore><MTEntries></MTIgnore>
--- expected


=== test 649
--- template
<MTIgnore><MTEntries></MTEntries></MTIgnore>
--- expected


=== test 650
--- template
<MTIgnore><MTDate></MTIgnore>
--- expected


=== test 651
--- template
<MTIgnore><MTFoo></MTIgnore>
--- expected


=== test 652
--- template
<MTSupportDirectoryURL with_domain='1'>
--- expected
http://narnia.na/mt-static/support/

=== test 653
--- template
<MTSupportDirectoryURL with_domain='0'>
--- expected
/mt-static/support/

=== test 654
--- template
<MTSupportDirectoryURL with_domain=''>
--- expected
/mt-static/support/

=== test 655
--- template
<MTIfWebsite>if<MTElse>else</MTIfWebsite>
--- expected
else

=== test 656
--- template
<MTWebsiteID>
--- expected
2

=== test 657
--- template
<MTWebsiteName>
--- expected
Test site

=== test 658
--- template
<MTWebsiteDescription>
--- expected
Narnia None Test Website

=== test 659
--- template
<MTWebsiteLanguage>
--- expected
en_us

=== test 660
--- template
<MTWebsiteLanguage locale='1'>
--- expected
en_US

=== test 661
--- template
<MTWebsiteLanguage ietf='1'>
--- expected
en-us

=== test 662
--- template
<MTWebsiteDateLanguage>
--- expected
en_us

=== test 663
--- template
<MTWebsiteDateLanguage locale='1'>
--- expected
en_US

=== test 664
--- template
<MTWebsiteDateLanguage ietf='1'>
--- expected
en-us

=== test 665
--- template
<MTWebsiteURL>
--- expected
http://narnia.na/

=== test 666
--- template
<MTWebsitePath>
--- expected
TEST_ROOT/

=== test 667
--- template
<MTWebsiteTimezone>
--- expected
-03:30

=== test 668
--- template
<MTWebsiteTimezone no_colon='1'>
--- expected
-0330

=== test 672
--- template
<MTWebsiteFileExtension>
--- expected
.html

=== test 677
--- template
<MTWebsitePageCount site_ids='1'>
--- expected
4

=== test 678
--- template
<MTWebsitePageCount site_ids='1' blog_ids='2'>
--- expected
1

=== test 679
--- template
<MTWebsitePageCount site_ids='1' include_blogs='2'>
--- expected
1

=== test 680
--- template
<MTWebsitePageCount site_ids='1' include_websites='2'>
--- expected
4

=== test 685
--- template
<MTWebsiteEntryCount>
--- expected
0

=== test 686
--- template
<MTWebsiteEntryCount site_ids='1'>
--- expected
6

=== test 687
--- template
<MTWebsiteEntryCount site_ids='1' blog_ids='2'>
--- expected
0

=== test 688
--- template
<MTWebsiteEntryCount site_ids='1' include_blogs='2'>
--- expected
0

=== test 689
--- template
<MTWebsiteEntryCount site_ids='1' include_websites='2'>
--- expected
6

=== test 690
--- template
<MTWebsiteEntryCount site_ids='all'>
--- expected
6

=== test 691
--- template
<MTWebsiteEntryCount site_ids='all' exclude_websites='1'>
--- expected
0

=== test 692
--- template
<MTWebsiteEntryCount blog_ids='1' none='none' singular='singular' plural='plural:#'>
--- expected
plural:6

=== test 693
--- template
<MTWebsiteEntryCount blog_ids='2' none='none' singular='singular' plural='plural:#'>
--- expected
none

=== test 694
--- template
<MTAssets sort_order='ascend' sort_by='created_on'><MTAssetID></MTAssets>
--- expected
25671

=== test 695
--- template
<MTAssets sort_order='descend' sort_by='created_on'><MTAssetID></MTAssets>
--- expected
17652

=== test 696
--- template
<MTAssets lastn='2' sort_order='ascend' sort_by='created_on'><MTAssetID></MTAssets>
--- expected
71

=== test 697
--- template
<MTAssets lastn='2' sort_order='descend' sort_by='created_on'><MTAssetID></MTAssets>
--- expected
17

=== test 698
--- template
<MTEntries category='123'><MTEntryTitle></MTEntries>
--- expected


=== test 699
--- template
<MTEntries category='abc123'><MTEntryTitle></MTEntries>
--- expected


=== test 700
--- template
<MTEntries categories='abc123'><MTEntryTitle></MTEntries>
--- expected


=== test 701
--- template
<MTSetVarBlock name='cat'>def456</MTSetVarBlock><MTEntries category='$cat'><MTEntryTitle></MTEntries>
--- expected


=== test 702
--- template
<MTSetVarBlock name='cat'>def456</MTSetVarBlock><MTEntries categories='$cat'><MTEntryTitle></MTEntries>
--- expected


=== test 703
--- template
<MTMultiBlog include_blogs='all' mode='loop'><MTEntries category='1'><MTEntryTitle></MTEntries></MTMultiBlog>
--- expected


=== test 704
--- template
<MTMultiBlog include_blogs='all' mode='loop'><MTEntries categories='1'><MTEntryTitle></MTEntries></MTMultiBlog>
--- expected


=== test 705
--- template
<MTAuthors need_entry='0' status='123'><MTAuthorID>,</MTAuthors>
--- expected


=== test 706
--- SKIP
--- template
<MTAuthors need_entry='0' role='123'><MTAuthorID>,</MTAuthors>
--- expected


=== test 707
--- template
<MTSetVarTemplate name='tmpl'><MTEntriesHeader>!header!</MTEntriesHeader><MTEntryTitle>,<MTEntriesFooter>!footer!</MTEntriesFooter></MTSetVarTemplate><MTEntries><MTVar name='tmpl'></MTEntries>
--- expected
!header!A Rainy Day,Verse 5,Verse 4,Verse 3,Verse 2,Verse 1,!footer!

=== test 708
--- template
<MTSetHashVar name='test'><MTSetVar name='test1' value='1'><MTSetVar name='test2' value='2'><MTSetVar name='test3' value='3'></MTSetHashVar><MTSetVar name='list[0]' value='$test' /><MTGetVar name='list[0]' setvar='rec' /><MTLoop name='rec' sort_by='value' glue=','><MTGetVar name='__key__'>:<MTGetVar name='__value__' /></MTLoop>
--- expected
test1:1,test2:2,test3:3

=== test 709
--- template
<MTEntries limit='1' offset='3'><MTEntryNext by_author='1'><MTEntryID></MTEntryNext></MTEntries>
--- expected


=== test 710
--- template
<MTEntries limit='1' offset='3'><MTEntryPrevious by_author='1'><MTEntryID></MTEntryPrevious></MTEntries>
--- expected


=== test 711
--- template
<MTPages limit='1' offset='1'><MTPageNext by_author='1'><MTPageID></MTPageNext></MTPages>
--- expected


=== test 712
--- template
<MTPages limit='1'><MTPagePrevious by_author='1'><MTPageID></MTPagePrevious></MTPages>
--- expected


=== test 713
--- template
<MTEntries><MTEntryNext by_category='1'><MTEntryID></MTEntryNext></MTEntries>
--- expected


=== test 714
--- template
<MTEntries><MTEntryPrevious by_category='1'><MTEntryID></MTEntryPrevious></MTEntries>
--- expected


=== test 715
--- template
<MTPages><MTPageNext by_category='1'><MTPageID></MTPageNext></MTPages>
--- expected


=== test 716
--- template
<MTPages><MTPagePrevious by_category='1'><MTPageID></MTPagePrevious></MTPages>
--- expected


=== test 717
--- template
<MTPages><MTPageNext by_folder='1'><MTPageID></MTPageNext></MTPages>
--- expected


=== test 718
--- template
<MTPages><MTPagePrevious by_folder='1'><MTPageID></MTPagePrevious></MTPages>
--- expected


=== test 719
--- template
foo<MTFor decode_html='1'>bar</MTFor>baz
--- expected
foobarbaz

=== test 720
--- template
[<MTSubFolders show_empty="1" top="1"><MTHasParentFolder>Parent of <MTFolderLabel> is <MTParentFolder><MTFolderLabel></MTParentFolder></MTHasParentFolder><MTHasNoParentFolder><MTFolderLabel> has no parent</MTHasNoParentFolder>; <MTSubFolderRecurse></MTSubFolders>]
--- expected
[download has no parent; Parent of nightly is download; info has no parent; ]

=== test 721
--- template
<MTTopLevelFolders show_empty="1"><MTFolderLabel><MTHasSubFolders> (has subcategories)</MTHasSubFolders><MTHasNoSubFolders> (has no subcategories)</MTHasNoSubFolders></MTTopLevelFolders>
--- expected
download (has subcategories)info (has no subcategories)

=== test 722
--- template
<MTSetVar name='array'><MTSetVar name='array' function='push' value='foo'><MTUnless name='array'>bar<MTElse>baz</MTUnless>
--- expected
baz

=== test 723
--- template
<MTLoop name='foo'><MTFor regex_replace='/</',''></MTFor></MTLoop>
--- expected


=== test 724
--- template
<MTSetVarBlock name='foo'>bar</MTSetVarBlock><MTGetVar name='foo' regex_replace='/bar/','bar@baz'>
--- expected
bar@baz

=== test 725
--- template
<MTEntries lastn='1'><MTEntryTitle trim_to='0'></MTEntries>
--- expected


=== test 726
--- template
<MTEntries lastn='1'><MTEntryTitle trim_to='foo'></MTEntries>
--- expected


=== test 727
--- template
<MTEntries lastn='1'><MTEntryTitle trim_to='10+...'></MTEntries>
--- expected
A Rainy Da...

=== test 728
--- template
<MTEntries lastn='1'><MTEntryTitle trim_to='11+...'></MTEntries>
--- expected
A Rainy Day

=== test 729
--- template
<MTEntries lastn='1'><MTEntryTitle trim_to='-4'></MTEntries>
--- expected
A Rainy

=== test 730
--- template
<MTEntries lastn='1'><MTEntryTitle trim_to='-4+...'></MTEntries>
--- expected
A Rainy...

=== test 731
--- template
<MTEntries lastn='1'><MTEntryTitle trim_to='-10+...'></MTEntries>
--- expected
A...

=== test 732
--- template
<MTEntries lastn='1'><MTEntryTitle trim_to='-11+...'></MTEntries>
--- expected


=== test 733
--- template
<MTIf tag="BlogID"><MTSetVar name="hoge" value="ccc"><MTIf name="hoge" eq="aaa">aaa<MTElseIf eq="bbb">bbb<MTElseIf eq="ccc">ccc<MTElse>not matched.</MTIf></MTIf>
--- expected
ccc

=== test 734
--- template
<MTSetVarBlock name="foo"><MTBlogID></MTSetVarBlock><MTIf name="foo"><MTSetVar name="bar" value="ccc"><MTIf name="bar" eq="aaa">aaa<MTElseIf eq="bbb">bbb<MTElseIf eq="ccc">ccc<MTElse>not matched.</MTIf></MTIf>
--- expected
ccc

=== test 735
--- template
<div><table><mt:Calendar month="196301" category="foo"><mt:CalendarWeekHeader><tr></mt:CalendarWeekHeader><td><mt:CalendarIfEntries><mt:Entries lastn="1"><a href="<$mt:EntryPermalink$>"><$mt:CalendarDay$></a></mt:Entries></mt:CalendarIfEntries><mt:CalendarIfNoEntries><$mt:CalendarDay$></mt:CalendarIfNoEntries><mt:CalendarIfBlank>&nbsp;</mt:CalendarIfBlank></td><mt:CalendarWeekFooter></tr></mt:CalendarWeekFooter></mt:Calendar></table></div>
--- expected
<div><table><tr><td>&nbsp;</td><td>&nbsp;</td><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td></tr><tr><td>6</td><td>7</td><td>8</td><td>9</td><td>10</td><td>11</td><td>12</td></tr><tr><td>13</td><td>14</td><td>15</td><td>16</td><td>17</td><td>18</td><td>19</td></tr><tr><td>20</td><td>21</td><td>22</td><td>23</td><td>24</td><td>25</td><td>26</td></tr><tr><td>27</td><td>28</td><td>29</td><td>30</td><td><a href="http://narnia.na/nana/archives/1963/01/verse-3.html">31</a></td><td>&nbsp;</td><td>&nbsp;</td></tr></table></div>

=== test 736
--- template
<mt:unless trim_to='7+0'>Movable Type</mt:unless>
--- expected
Movable0

=== test 737
--- template
<mt:DataAPIScript>
--- expected
mt-data-api.cgi

=== test 738
--- template
<mt:DataAPIVersion>
--- expected
7

=== test 739
--- template
<mt:Pages tags="@about" include_blogs="siblings" include_with_website="1"><$mt:PageTitle$></mt:Pages>
--- expected
About

=== test 740
--- template
<MTBlogs><MTBlogThemeID raw='1'></MTBlogs>
--- expected
classic_blog

=== test 741
--- template
<MTWebsiteThemeID raw='1'>
--- expected
classic_website

=== test 742
--- template
<MTSetVarBlock name='foo'>bar</MTSetVarBlock><MTGetVar name='foo' regex_replace='/bar/',"bar'baz">
--- expected
bar'baz

=== test 743
--- template
<MTSetVarBlock name='foo'>bar</MTSetVarBlock><MTGetVar name='foo' regex_replace='/bar/','bar@baz/foo@baz'>
--- expected
bar@baz/foo@baz

=== test 744
--- template
<MTSetVarBlock name='foo'>bar</MTSetVarBlock><MTGetVar name='foo' regex_replace='/bar/','bar@baz\/'>
--- expected
bar@baz\/

=== test 745
--- template
<mt:Ignore><mt:SetVar name='abc' value='123></mt:Ignore><mt:SetVar name='abc' value='123'>
--- expected


=== test 746
--- template
<mt:Ignore><mt:abc</mt:Ignore>
--- expected


=== test 747
--- template
<mt:setvarblock name="str"><&>'"</mt:setvarblock><$mt:var name="str" encode_html="1"$>
--- expected
&lt;&amp;&gt;&#039;&quot;

=== test 748
--- template
<mt:setvarblock name="str"><&>'"</mt:setvarblock><$mt:var name="str" escape="html"$>
--- expected
&lt;&amp;&gt;&#039;&quot;

=== test 749
--- template
<mt:setvarblock name="str">&lt;&amp;&gt;&#039;&quot;</mt:setvarblock><$mt:var name="str" decode_html="1"$>
--- expected
<&>'"

=== test 750
--- template
<mt:setvarblock name="str"><&>'"</mt:setvarblock><$mt:var name="str" encode_xml="1"$>
--- expected
<![CDATA[<&>'"]]>

=== test 751
--- template
<mt:setvarblock name="str"><![CDATA[&lt;&amp;&gt;&#039;&quot;]]></mt:setvarblock><$mt:var name="str" decode_xml="1"$>
--- expected
&lt;&amp;&gt;&#039;&quot;

=== test 752
--- SKIP
--- template
<mt:setvarblock name="str"><&>'"</mt:setvarblock><$mt:var name="str" encode_xml="1"$>
--- expected
&lt;&amp;&gt;&#039;&quot;

=== test 753
--- SKIP
--- template
<mt:setvarblock name="str">&lt;&amp;&gt;&#039;&quot;</mt:setvarblock><$mt:var name="str" decode_xml="1"$>
--- expected
<&>'"

=== test 754
--- template
<mt:setvarblock name="str"><p>abcde<br>abcde<br>abcde<br></p></mt:setvarblock><$mt:var name="str" sanitize="br"$>
--- expected
abcde<br>abcde<br>abcde<br>

=== test 755
--- template
<MTBlogs blog_ids="1"><MTWebsiteHasBlog>true<MTElse>false</MTWebsiteHasBlog></MTBlogs>
--- expected
true

=== test 756
--- template
<MTSubCategories show_empty="1" top="1" sort_method="{ $a->label cmp $b->label }"><MTCategoryLabel></MTSubCategories>
--- expected
barfoo

=== test 756-2
--- template
<MTSubCategories top="1" sort_method="{ $b->label cmp $a->label }"><MTCategoryLabel></MTSubCategories>
--- expected
foobar
--- expected_php
barfoo

=== test 758
--- template
<MTArchiveList archive_type="Individual"><mt:EntryID>:<$mt:CategoryID$>;</MTArchiveList>
--- expected
1:;8:;7:3;6:1;5:;4:;

=== test 759
--- template
<MTArchiveList archive_type="Individual"><mt:EntryID>:<$mt:CategoryDescription$>;</MTArchiveList>
--- expected
1:;8:;7:subcat;6:bar;5:;4:;

=== test 760
--- template
<MTArchiveList archive_type="Individual"><mt:EntryID>:<$mt:CategoryArchiveLink$>;</MTArchiveList>
--- expected
1:;8:;7:http://narnia.na/nana/archives/foo/subfoo/;6:http://narnia.na/nana/archives/foo/;5:;4:;

=== test 761
--- template
<MTArchiveList archive_type="Individual"><mt:EntryID>:<$mt:CategoryCount$>;</MTArchiveList>
--- expected
1:;8:;7:1;6:1;5:;4:;

=== test 762
--- template
<MTArchiveList archive_type="Individual"><mt:EntryID>:<$mt:CategoryBaseName$>;</MTArchiveList>
--- expected
1:;8:;7:subfoo;6:foo;5:;4:;

=== test 763
--- template
<MTArchiveList archive_type="Individual"><mt:EntryID>:<$mt:CategoryLabel$>;</MTArchiveList>
--- expected
1:;8:;7:subfoo;6:foo;5:;4:;

=== test 764
--- template
<MTArchiveList archive_type="Individual"><mt:EntryID>:<MTCategoryPrevious><MTCategoryLabel></MTCategoryPrevious>;</MTArchiveList>
--- expected
1:;8:;7:;6:;5:;4:;

=== test 765
--- template
<MTArchiveList archive_type="Individual"><mt:EntryID>:<MTCategoryNext><MTCategoryLabel></MTCategoryNext>;</MTArchiveList>
--- expected
1:;8:;7:;6:;5:;4:;

=== test 773
--- template
<MTEntries category='(test' glue=','><MTEntryID></MTEntries>
--- expected


=== test 774
--- template
<MTEntries category='&test' glue=','><MTEntryID></MTEntries>
--- expected


=== test 775
--- template
<MTEntries category='test)' glue=','><MTEntryID></MTEntries>
--- expected


=== test 776
--- template
<MTEntries category='test!' glue=','><MTEntryID></MTEntries>
--- expected


=== test 777
--- template
<MTEntries category='||test' glue=','><MTEntryID></MTEntries>
--- expected


=== test 778
--- template
<MTEntries category='#test' glue=','><MTEntryID></MTEntries>
--- expected


=== test 779
--- template
<MTEntries category='&test' glue=','><MTEntryID></MTEntries>
--- expected


=== test 780
--- template
<MTEntries category='testA AND testB' glue=','><MTEntryID></MTEntries>
--- expected


=== test 781
--- template
<MTEntries category='(testA OR testB) AND testC' glue=','><MTEntryID></MTEntries>
--- expected


=== test 782
--- template
<MTEntries category='NOT test' glue=','><MTEntryID></MTEntries>
--- expected
1,8,7,6,5,4

=== test 783
--- template
<MTEntries category="'testA AND testB'" glue=','><MTEntryID></MTEntries>
--- expected


=== test 784
--- template
<MTEntries category='"testA AND testB"' glue=','><MTEntryID></MTEntries>
--- expected


=== test 785
--- template
<MTEntries category='testA (testb)' glue=','><MTEntryID></MTEntries>
--- expected


=== test 786
--- template
<MTEntries category='foo/bar' glue=','><MTEntryID></MTEntries>
--- expected


=== test 787
--- template
<mt:If tag="Entries">true<mt:Else>false</mt:If>
--- expected
true

=== test 788
--- template
<MTEntries tag='(test' glue=','><MTEntryID></MTEntries>
--- expected


=== test 789
--- template
<MTEntries tag='&test' glue=','><MTEntryID></MTEntries>
--- expected


=== test 790
--- template
<MTEntries tag='test)' glue=','><MTEntryID></MTEntries>
--- expected


=== test 791
--- template
<MTEntries tag='test!' glue=','><MTEntryID></MTEntries>
--- expected


=== test 792
--- template
<MTEntries tag='||test' glue=','><MTEntryID></MTEntries>
--- expected


=== test 793
--- template
<MTEntries tag='#test' glue=','><MTEntryID></MTEntries>
--- expected


=== test 794
--- template
<MTEntries tag='&test' glue=','><MTEntryID></MTEntries>
--- expected


=== test 795
--- template
<MTEntries tag='testA AND testB' glue=','><MTEntryID></MTEntries>
--- expected


=== test 796
--- template
<MTEntries tag='(testA OR testB) AND testC' glue=','><MTEntryID></MTEntries>
--- expected


=== test 797
--- template
<MTEntries tag='NOT test' glue=','><MTEntryID></MTEntries>
--- expected
1,8,7,6,5,4

=== test 798
--- template
<MTEntries tag="'testA AND testB'" glue=','><MTEntryID></MTEntries>
--- expected


=== test 799
--- template
<MTEntries tag='"testA AND testB"' glue=','><MTEntryID></MTEntries>
--- expected


=== test 800
--- template
<MTEntries tag='testA (testb)' glue=','><MTEntryID></MTEntries>
--- expected


=== test 801
--- template
<MTEntries tag='foo/bar' glue=','><MTEntryID></MTEntries>
--- expected


=== test 802
--- template
<MTAssets tag='(test'><MTAssetID>,</MTAssets>
--- expected


=== test 803
--- template
<MTAssets tag='&test'><MTAssetID>,</MTAssets>
--- expected


=== test 804
--- template
<MTAssets tag='test)'><MTAssetID>,</MTAssets>
--- expected


=== test 805
--- template
<MTAssets tag='test!'><MTAssetID>,</MTAssets>
--- expected


=== test 806
--- template
<MTAssets tag='||test'><MTAssetID>,</MTAssets>
--- expected


=== test 807
--- template
<MTAssets tag='#test'><MTAssetID>,</MTAssets>
--- expected


=== test 808
--- template
<MTAssets tag='&test'><MTAssetID>,</MTAssets>
--- expected


=== test 809
--- template
<MTAssets tag='testA AND testB'><MTAssetID>,</MTAssets>
--- expected


=== test 810
--- template
<MTAssets tag='(testA OR testB) AND testC'><MTAssetID>,</MTAssets>
--- expected


=== test 811
--- template
<MTAssets tag='NOT test'><MTAssetID>,</MTAssets>
--- expected
1,7,6,5,2,

=== test 812
--- template
<MTAssets tag="'testA AND testB'"><MTAssetID>,</MTAssets>
--- expected


=== test 813
--- template
<MTAssets tag='"testA AND testB"'><MTAssetID>,</MTAssets>
--- expected


=== test 814
--- template
<MTAssets tag='testA (testb)'><MTAssetID>,</MTAssets>
--- expected


=== test 815
--- template
<MTAssets tag='foo/bar'><MTAssetID>,</MTAssets>
--- expected


=== test 816
--- template
<mt:ignore>foo<mt:ignore>bar</mt:ignore></mt:ignore>
--- expected


=== test 817
--- template
 <mt:assets tag="not_exists"><mt:if tag="categorybasename"></mt:if><mt:assetproperty property="file_size" format="0"></mt:assets>
--- expected


=== test 818
--- template
<MTAssets limit='1'><MTAssetBlogID></MTAssets>
--- expected
1

=== test 819
--- template
<MTAuthors lastn="1"><MTAuthorUserpicAsset><MTAssetBlogID></MTAuthorUserpicAsset></MTAuthors>
--- expected
0

=== test 820
--- template
<MTAssets limit='1'><MTAssetBlogID pad='1'></MTAssets>
--- expected
000001

=== test 821
--- template
<MTAuthors lastn="1"><MTAuthorUserpicAsset><MTAssetBlogID pad='1'></MTAuthorUserpicAsset></MTAuthors>
--- expected
000000

=== test 822
--- template
<MTEntries limit='1'><MTArchiveLink archive_type="Author"></MTEntries>
--- expected
http://narnia.na/nana/archives/author/chucky-dee/

=== test 823
--- template
<mt:ArchiveList type='Monthly'><MTIfFolder>foge</MTIfFolder></mt:ArchiveList>
--- expected


=== test 824
--- template
<MTIfFolder>foge</MTIfFolder>
--- expected


=== test 825
--- template
<MTEntries include_blogs='all' lastn='1'><MTEntryClass></MTEntries>
--- expected
entry

=== test 826
--- template
<MTEntries include_blogs='all' class_type='entry' lastn='1'><MTEntryClass></MTEntries>
--- expected
entry

=== test 827
--- template
<MTEntries include_blogs='all' class_type='page' lastn='1'><MTEntryClass></MTEntries>
--- expected
page

=== test 828
--- template
<MTEntries include_blogs='all' class='page' lastn='1'><MTEntryClass></MTEntries>
--- expected
entry

=== test 829
--- template
<MTAssets blog_ids='all' sort_by='id'><MTAssetID></MTAssets>
--- expected
7654321

=== test 830
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailURL width='1280'$></MTAssets>
--- expected
http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg

=== test 831
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailURL width='1280' force='1'$></MTAssets>
--- expected
http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-1280xauto-1.jpg

=== test 832
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailURL height='960'$></MTAssets>
--- expected
http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg

=== test 833
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailURL height='960' force='1'$></MTAssets>
--- expected
http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-autox960-1.jpg

=== test 834
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailLink width='1280'$></MTAssets>
--- expected
<a href="http://narnia.na/nana/images/test.jpg"><img src="http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg" width="640" height="480" alt="" /></a>

=== test 835
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailLink width='1280' force='1'$></MTAssets>
--- expected
<a href="http://narnia.na/nana/images/test.jpg"><img src="http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-1280xauto-1.jpg" width="1280" height="960" alt="" /></a>

=== test 836
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailLink height='960'$></MTAssets>
--- expected
<a href="http://narnia.na/nana/images/test.jpg"><img src="http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg" width="640" height="480" alt="" /></a>

=== test 837
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailLink height='960' force='1'$></MTAssets>
--- expected
<a href="http://narnia.na/nana/images/test.jpg"><img src="http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-autox960-1.jpg" width="1280" height="960" alt="" /></a>

=== test 838
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailURL width='1280' square='1'$></MTAssets>
--- expected
http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-480x480-1.jpg

=== test 839
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailURL height='960' square='1'$></MTAssets>
--- expected
http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-480x480-1.jpg

=== test 840
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailURL width='1280' square='1' force='1'$></MTAssets>
--- expected
http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-1280x1280-1.jpg

=== test 841
--- skip_php
[% no_php_gd %]
--- template
<MTAssets lastn='1'><$MTAssetThumbnailURL height='960' square='1' force='1'$></MTAssets>
--- expected
http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-960x960-1.jpg

=== test 842
--- template
<MTEntries lastn="1"><MTEntryAuthorLink show_hcard="1"></MTEntries>
--- expected
<a class="fn url" href="http://chuckd.com/">Chucky Dee</a>

=== test 843
--- template
<MTEntries lastn="1"><MTEntryAuthorLink type="email" show_hcard="1"></MTEntries>
--- expected
<a class="fn email" href="mailto:chuckd@example.com">Chucky Dee</a>

=== test 844
--- skip_php
[% no_php_gd %]
--- template
<MTAssets include_blogs="1" limit="1"><mt:AssetThumbnailURL></MTAssets>
--- expected
http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg

=== test 845
--- template
<MTCategoryLabel default='category label default'>
--- expected_todo_error
--- expected_php
category label default

=== test 846
--- template
<MTCategoryBaseName default='category basename default'>
--- expected_todo_error
--- expected_php
category basename default

=== test 847
--- template
<MTWebSites include_websites="2"><MTTopLevelCategories><MTCategoryLabel>;<$mt:SubCatsRecurse max_depth="1"$></MTTopLevelCategories></MTWebSites>
--- expected
Japan;Tokyo;US;California;

=== test 848
--- template
<MTWebSites include_websites="2"><MTTopLevelFolders><MTFolderLabel>;<$mt:SubFolderRecurse max_depth="1"$></MTTopLevelFolders></MTWebSites>
--- expected
Product;Consumer;

=== test 849
--- template
<MTPages id="20"><MTPageAssets sort_by="file_name" sort_order="descend" lastn="2"><MTAssetFileName>;</MTPageAssets></MTPages>
--- expected
test3.jpg;test2.jpg;

=== test 850
--- template
<MTPages id="20"><MTPageAssets sort_by="file_name" sort_order="ascend" lastn="2"><MTAssetFileName>;</MTPageAssets></MTPages>
--- expected
test2.jpg;test3.jpg;

=== test 851
--- template
<MTEntries id="1"><MTEntryAssets sort_by="file_name" sort_order="descend" lastn="2"><MTAssetFileName>;</MTEntryAssets></MTEntries>
--- expected
test3.jpg;test2.jpg;

=== test 852
--- template
<MTEntries id="1"><MTEntryAssets sort_by="file_name" sort_order="ascend" lastn="2"><MTAssetFileName>;</MTEntryAssets></MTEntries>
--- expected
test2.jpg;test3.jpg;

=== test 853
--- template
<MTHasPlugin name="Markdown/Markdown.pl">has Markdown.pl</MTHasPlugin>
--- expected
has Markdown.pl

=== test 854
--- template
<MTHasPlugin name="Markdown">has Markdown.pl (alias)</MTHasPlugin>
--- expected
has Markdown.pl (alias)

=== test 856
--- template
<MTHasPlugin name="NotExists">has NotExists<MTElse>doesn't have NotExists</MTHasPlugin>
--- expected
doesn't have NotExists

=== test 858
--- template
<MTWebsitePageCount site_ids='1' include_sites='2'>
--- expected
1

=== test 860
--- template
<MTWebsiteEntryCount site_ids='1' include_sites='2'>
--- expected
0

=== test 861
--- template
<MTMultiBlog include_sites='all' mode='loop'><MTEntries category='1'><MTEntryTitle></MTEntries></MTMultiBlog>
--- expected


=== test 862
--- template
<MTMultiBlog include_sites='all' mode='loop'><MTEntries categories='1'><MTEntryTitle></MTEntries></MTMultiBlog>
--- expected


=== test 863
--- template
<mt:Pages tags="@about" include_sites="siblings" include_with_website="1"><$mt:PageTitle$></mt:Pages>
--- expected
About

=== test 864
--- template
<MTEntries include_sites='all' lastn='1'><MTEntryClass></MTEntries>
--- expected
entry

=== test 865
--- template
<MTEntries include_sites='all' class_type='entry' lastn='1'><MTEntryClass></MTEntries>
--- expected
entry

=== test 866
--- template
<MTEntries include_sites='all' class_type='page' lastn='1'><MTEntryClass></MTEntries>
--- expected
page

=== test 867
--- template
<MTEntries include_sites='all' class='page' lastn='1'><MTEntryClass></MTEntries>
--- expected
entry

=== test 868
--- skip_php
[% no_php_gd %]
--- template
<MTAssets include_sites="1" limit="1"><mt:AssetThumbnailURL></MTAssets>
--- expected
http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg

=== test 871
--- template
<MTWebsiteEntryCount site_ids='all' exclude_sites='1'>
--- expected
0

=== test 872
--- template
<MTWebSites include_sites="2"><MTTopLevelCategories><MTCategoryLabel>;<$mt:SubCatsRecurse max_depth="1"$></MTTopLevelCategories></MTWebSites>
--- expected
Japan;Tokyo;US;California;

=== test 873
--- template
<MTWebSites include_sites="2"><MTTopLevelFolders><MTFolderLabel>;<$mt:SubFolderRecurse max_depth="1"$></MTTopLevelFolders></MTWebSites>
--- expected
Product;Consumer;

=== test 874
--- template
<mt:Pages tags="@about" include_blogs="siblings" include_parent_site="1"><$mt:PageTitle$></mt:Pages>
--- expected
About

=== test 875
--- template
<mt:Pages tags="@about" include_sites="siblings" include_parent_site="1"><$mt:PageTitle$></mt:Pages>
--- expected
About

=== test 876
--- template
<MTSetVarBlock name="foo">Test FooBar String</MTSetVarBlock><MTGetVar name="foo" regex_replace="/(.)(Foo)(.)/g","$1<a href=/\L$2\E>\U$2\E</a>\l$3">
--- expected
Test <a href=/foo>FOO</a>bar String

=== test 877
--- template
<MTSetVarBlock name="foo">Test FooBar String</MTSetVarBlock><MTGetVar name="foo" regex_replace="/(.)(Foo)(.)/g","$1<a href="/\L$2\E">\U$2\E</a>\l$3">
--- expected
Test <a href="/foo">FOO</a>bar String

=== test 878
--- template
<MTSetVarBlock name="foo">Test FooBar String</MTSetVarBlock><MTGetVar name="foo" regex_replace="/(.)(Foo)(.)/g","$1<a href=/\L$2.php>\U$2\E</a>\l$3">
--- expected
Test <a href=/foo.php>FOO</a>bar String

=== test 879
--- template
<MTSetVarBlock name="foo">Test FooBar String</MTSetVarBlock><MTGetVar name="foo" regex_replace="/(.)(Foo)(.)/g","$1<a href="/\L$2.php">\U$2\E</a>\l$3">
--- expected
Test <a href="/foo.php">FOO</a>bar String

=== test 880
--- template
<MTSetVarBlock name="foo">Test FooBar String</MTSetVarBlock><MTGetVar name="foo" regex_replace="/(.)(Foo)(.)/g","$1<a href=/\L$2/$2.php>\U$2:$2\E</a>\l$3\u$3">
--- expected
Test <a href=/foo/foo.php>FOO:FOO</a>bBar String

=== test 881
--- template
<MTSetVarBlock name="foo">Test FooBar String</MTSetVarBlock><MTGetVar name="foo" regex_replace="/(.)(Foo)(.)/g","$1<a href="/\L$2/$2.php">\U$2:$2\E</a>\l$3\u$3">
--- expected
Test <a href="/foo/foo.php">FOO:FOO</a>bBar String

=== test 882
--- template
<mt:Calendar><mt:CalendarIfToday><strong></mt:CalendarIfToday></mt:Calendar>
--- expected
<strong>

=== test 884
--- template
<MTPages no_folder="1"><MTPageID>;</MTPages>
--- expected
20;

=== test 885
--- skip
[% NO_CAPTACH %]
--- template
<mt:CaptchaFields>
--- expected regexp
<input type="hidden" name="token" value="[^"]{40}" />

=== test 886
--- template
<mt:PasswordValidation form="password_reset_form" password="mypassfield" username="myusernamefield">
--- expected regexp=s
function verify_password.+mypassfield.+myusernamefield

=== test 887: test if elsif else1
--- template
<MTVar name='idx' value='2'><MTIf name='idx' eq='2'>2<MTElse name='idx' eq='3'>3<MTElse>4</MTIf>
<MTVar name='idx' value='3'><MTIf name='idx' eq='2'>2<MTElse name='idx' eq='3'>3<MTElse>4</MTIf>
<MTVar name='idx' value='5'><MTIf name='idx' eq='2'>2<MTElse name='idx' eq='3'>3<MTElse>4</MTIf>
--- expected
2
3
4

=== test 888: test  if elsif else2
--- template
<MTVar name='idx' value='2'><MTIf name='idx' eq='2'>2<MTElse>4</MTIf>
<MTVar name='idx' value='5'><MTIf name='idx' eq='2'>2<MTElse>4</MTIf>
--- expected
2
4

=== test 889: test  if elsif else3
--- template
<MTVar name='idx' value='2'><MTIf name='idx' eq='2'>2<MTElse name='idx' eq='3'>3</MTIf>
<MTVar name='idx' value='3'><MTIf name='idx' eq='2'>2<MTElse name='idx' eq='3'>3</MTIf>
<MTVar name='idx' value='5'><MTIf name='idx' eq='2'>2<MTElse name='idx' eq='3'>3</MTIf>
--- expected
2
3

=== test 890
--- template
<MTEntries lastn="1"><MTEntryModifiedAuthorDisplayName></MTEntries>
--- expected
foobar

=== test 891
--- template
<MTEntries lastn="1"><MTEntryModifiedAuthorUsername></MTEntries>
--- expected
Foo Bar

=== test 892
--- template
<MTEntries lastn="1"><MTEntryModifiedAuthorEmail></MTEntries>
--- expected
foobar@localhost

=== test 893
--- template
<MTEntries lastn="1"><MTEntryModifiedAuthorURL></MTEntries>
--- expected
https://foobar.com

=== test 894
--- template
<MTEntries lastn="1"><MTEntryModifiedAuthorLink></MTEntries>
--- expected
<a href="https://foobar.com">foobar</a>

=== test 895
--- template
<MTEntries lastn="1"><MTEntryModifiedAuthorID></MTEntries>
--- expected
6

=== test 896
--- template
<MTPages lastn="1"><MTPageModifiedAuthorDisplayName></MTPages>
--- expected
foobar

=== test 897
--- template
<MTPages lastn="1"><MTPageModifiedAuthorEmail></MTPages>
--- expected
foobar@localhost

=== test 898
--- template
<MTPages lastn="1"><MTPageModifiedAuthorLink></MTPages>
--- expected
<a href="https://foobar.com">foobar</a>

=== test 899
--- template
<MTPages lastn="1"><MTPageModifiedAuthorURL></MTPages>
--- expected
https://foobar.com

=== test 900
--- skip_php
[% no_php_gd %]
--- template
<MTEntries lastn="1"><MTEntryModifiedAuthorUserpic></MTEntries>
--- expected
<img src="/mt-static/support/assets_c/userpics/userpic-6-100x100.png?3" width="100" height="100" alt="Image photo" />

=== test 901
--- template
<MTEntries lastn="1"><MTEntryModifiedAuthorUserpicAsset><MTAssetFilename></MTEntryModifiedAuthorUserpicAsset></MTEntries>
--- expected
test.jpg

=== test 902
--- skip_php
[% no_php_gd %]
--- template
<MTEntries lastn="1"><MTEntryModifiedAuthorUserpicURL></MTEntries>
--- expected
/mt-static/support/assets_c/userpics/userpic-6-100x100.png

=== test 903 cache test combining tests of 199, 200, 536 and 537 (MTC-28841)
--- template
<MTCategories show_empty="1" glue=","><MTCategoryLabel>-<MTCategoryNext show_empty="1"><MTCategoryLabel></MTCategoryNext></MTCategories>
<MTCategories show_empty="1" glue=","><MTCategoryLabel>-<MTCategoryPrevious show_empty="1"><MTCategoryLabel></MTCategoryPrevious></MTCategories>
<MTFolders show_empty='1' glue=','><MTFolderLabel>-<MTFolderNext show_empty='1'><MTFolderLabel></MTFolderNext></MTFolders>
<MTFolders show_empty='1' glue=','><MTFolderLabel>-<MTFolderPrevious show_empty='1'><MTFolderLabel></MTFolderPrevious></MTFolders>
--- expected
bar-foo,foo-,subfoo-
bar-,foo-bar,subfoo-
download-info,info-,nightly-
download-,info-download,nightly-

=== test 904 no localvar bugs in MTAuthorNext (MTC-28842)
--- template
<MTAuthors><MTAuthorNext></MTAuthorNext></MTAuthors>[<MTIfAuthor>HasAuthor:Outside</MTIfAuthor>]
--- expected
[]

=== test 905 no localvar bugs in MTAuthorPrevious (MTC-28842)
--- template
<MTAuthors><MTAuthorPrevious></MTAuthorPrevious></MTAuthors>[<MTIfAuthor>HasAuthor:Outside</MTIfAuthor>]
--- expected
[]

=== test 906 entry unpublished date (MTC-27309)
--- template
<MTEntries lastn="1"><MTEntryUnpublishedDate></MTEntries>
--- expected
January 31, 1978  7:47 AM

=== test 907 page unpublished date (MTC-27309)
--- template
<MTPages id="20"><MTPageUnpublishedDate></MTPages>
--- expected
January 31, 1978  7:47 AM

=== test 908 add id attribute (MTC-29257)
--- template
<MTWebsiteURL id='1'>
--- expected
http://narnia.na/

=== test 909 add id attribute (MTC-29257)
--- template
<MTWebsitePath id='1'>
--- expected
TEST_ROOT/

=== test 910 script (MTC-25985)
--- skip_php
--- template
<MTApp:Script path="foo/bar.js">
--- expected
<script src="/mt-static/foo/bar.js?v=VERSION_ID" charset="utf-8"></script>

=== test 911 script (MTC-25985)
--- skip_php
--- template
<MTApp:Script path="/foo/bar.js">
--- expected
<script src="/mt-static/foo/bar.js?v=VERSION_ID" charset="utf-8"></script>

=== test 912 script (MTC-25985)
--- skip_php
--- template
<MTApp:Script path="/foo/bar_%l.js">
--- expected
<script src="/mt-static/foo/bar_en_us.js?v=VERSION_ID" charset="utf-8"></script>

=== test 913 script (MTC-25985)
--- skip_php
--- template
<MTApp:Script>
--- expected_error
path is required.

=== test 914 script (MTC-25985)
--- skip_php
--- template
<MTApp:Script path="/foo/bar.js" async="1">
--- expected
<script src="/mt-static/foo/bar.js?v=VERSION_ID" async charset="utf-8"></script>

=== test 915 script (MTC-25985)
--- skip_php
--- template
<MTApp:Script path="/foo/bar.js" defer="1">
--- expected
<script src="/mt-static/foo/bar.js?v=VERSION_ID" defer charset="utf-8"></script>

=== test 916 script (MTC-25985)
--- skip_php
--- template
<MTApp:Script path="/foo/bar.js" type="text/javascript">
--- expected
<script src="/mt-static/foo/bar.js?v=VERSION_ID" type="text/javascript" charset="utf-8"></script>

=== test 917 script (MTC-25985)
--- skip_php
--- template
<MTApp:Script path="/foo/bar.js" charset="euc-jp">
--- expected
<script src="/mt-static/foo/bar.js?v=VERSION_ID" charset="euc-jp"></script>

=== test 918 script (MTC-25985)
--- skip_php
--- template
<MTApp:Script path="/foo/bar.js" type="text/javascript" async="1" defer="1">
--- expected
<script src="/mt-static/foo/bar.js?v=VERSION_ID" type="text/javascript" async defer charset="utf-8"></script>

=== test 919 stylesheet (MTC-25985)
--- skip_php
--- template
<MTApp:Stylesheet path="/foo/bar.css">
--- expected
<link rel="stylesheet" href="/mt-static/foo/bar.css?v=VERSION_ID">

=== test 920 stylesheet (MTC-25985)
--- skip_php
--- template
<MTApp:Stylesheet path="foo/bar.css">
--- expected
<link rel="stylesheet" href="/mt-static/foo/bar.css?v=VERSION_ID">

=== test 921 stylesheet (MTC-25985)
--- skip_php
--- template
<MTApp:Stylesheet path="foo/bar_%l.css">
--- expected
<link rel="stylesheet" href="/mt-static/foo/bar_en_us.css?v=VERSION_ID">

=== test 922 stylesheet (MTC-25985)
--- skip_php
--- template
<MTApp:Stylesheet>
--- expected_error
path is required.
