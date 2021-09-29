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
    $test_env->skip_if_plugin_exists('Comments');
    $test_env->skip_if_plugin_exists('Trackback');
}

use MT::Test::Tag;
use MT::Util qw(ts2epoch epoch2ts);

$test_env->prepare_fixture('db');

MT::Test::Tag->run_perl_tests(1);
MT::Test::Tag->run_php_tests(1);

done_testing;

__DATA__

=== comment/trackback functions and non-conditional blocks
--- template
<mt:BlogCommentCount>
<mt:BlogPingCount>
<mt:CategoryCommentCount>
<mt:CategoryTrackbackCount>
<mt:CategoryTrackbackLink>
<mt:CommentAuthor>
<mt:CommentAuthorIdentity>
<mt:CommentAuthorLink>
<mt:CommentBlogID>
<mt:CommentBody>
<mt:CommentDate>
<mt:CommentEmail>
<mt:CommentEntry>1</mt:CommentEntry>
<mt:CommentEntryID>
<mt:CommenterAuthIconURL>
<mt:CommenterAuthType>
<mt:CommenterEmail>
<mt:CommenterID>
<mt:CommenterName>
<mt:CommenterNameThunk>
<mt:CommenterURL>
<mt:CommenterUsername>
<mt:CommenterUserpic>
<mt:CommenterUserpicAsset>1</mt:CommenterUserpicAsset>
<mt:CommenterUserpicURL>
<mt:CommentIP>
<mt:CommentIP>
<mt:CommentLink>
<mt:CommentName>
<mt:CommentOrderNumber>
<mt:CommentParentID>
<mt:CommentRank>
<mt:CommentReplies>1</mt:CommentReplies>
<mt:CommentRepliesRecurse>
<mt:CommentReplyToLink>
<mt:Comments>1</mt:Comments>
<mt:CommentScore>
<mt:CommentScoreAvg>
<mt:CommentScoreCount>
<mt:CommentScoreHigh>
<mt:CommentScoreLow>
<mt:CommentsFooter>1</mt:CommentsFooter>
<mt:CommentsHeader>1</mt:CommentsHeader>
<mt:CommentURL>
<mt:EntryCommentCount>
<mt:EntryTrackbackCount>
<mt:EntryTrackbackData>
<mt:EntryTrackbackID>
<mt:EntryTrackbackLink>
<mt:PingBlogName>
<mt:PingDate>
<mt:PingEntry>1</mt:PingEntry>
<mt:PingRank>
<mt:Pings>1</mt:Pings>
<mt:PingScore>
<mt:PingScoreavg>
<mt:PingScorecount>
<mt:PingScorehigh>
<mt:PingScorelow>
<mt:PingsFooter>1</mt:PingsFooter>
<mt:PingsHeader>1</mt:PingsHeader>
<mt:PingsSent>1</mt:PingsSent>
<mt:PingsSentURL>
<mt:SignInLink>
<mt:SignOutLink>
<mt:WebsiteCommentCount>
<mt:SiteCommentCount>
<mt:WebsitePingCount>
<mt:CommentID>
<mt:CommentSiteID>
<mt:SitePingCount>
--- expected


=== comment/trackback functions and blocks (no php implementation)
--- SKIP_PHP
--- template
<mt:AuthorCommentCount>
<mt:CommentParent>1</mt:CommentParent>
<mt:UserSessionState>
--- expected


=== comment/trackback conditional blocks
--- template
<mt:IfCommenterIsEntryAuthor>yes<MTElse>e001</MTElse></mt:IfCommenterIsEntryAuthor>
<mt:EntryIfAllowPings>yes<MTElse>e002</MTElse></mt:EntryIfAllowPings>
<mt:CategoryIfAllowPings>yes<MTElse>e003</MTElse></mt:CategoryIfAllowPings>
<mt:IfCommenterRegistrationAllowed>yes<MTElse>e004</MTElse></mt:IfCommenterRegistrationAllowed>
<mt:IfCommenterTrusted>yes<MTElse>e005</MTElse></mt:IfCommenterTrusted>
<mt:IfCommenterIsAuthor>yes<MTElse>e006</MTElse></mt:IfCommenterIsAuthor>
<mt:IfCommentsModerated>yes<MTElse>e007</MTElse></mt:IfCommentsModerated>
<mt:BlogIfCommentsOpen>yes<MTElse>e008</MTElse></mt:BlogIfCommentsOpen>
<mt:WebsiteIfCommentsOpen>yes<MTElse>e009</MTElse></mt:WebsiteIfCommentsOpen>
<mt:CommentIfModerated>yes<MTElse>e010</MTElse></mt:CommentIfModerated>
<mt:IfCommentParent>yes<MTElse>e011</MTElse></mt:IfCommentParent>
<mt:IfCommentReplies>yes<MTElse>e012</MTElse></mt:IfCommentReplies>
<mt:IfRegistrationRequired>yes<MTElse>e013</MTElse></mt:IfRegistrationRequired>
<mt:IfRegistrationNotRequired>yes<MTElse>e014</MTElse></mt:IfRegistrationNotRequired>
<mt:IfRegistrationAllowed>yes<MTElse>e015</MTElse></mt:IfRegistrationAllowed>
<mt:IfAllowCommentHTML>yes<MTElse>e016</MTElse></mt:IfAllowCommentHTML>
<mt:IfCommentsAllowed>yes<MTElse>e017</MTElse></mt:IfCommentsAllowed>
<mt:IfCommentsAccepted>yes<MTElse>e018</MTElse></mt:IfCommentsAccepted>
<mt:IfCommentsActive>yes<MTElse>e019</MTElse></mt:IfCommentsActive>
<mt:IfNeedEmail>yes<MTElse>e020</MTElse></mt:IfNeedEmail>
<mt:IfRequireCommentEmails>yes<MTElse>e021</MTElse></mt:IfRequireCommentEmails>
<mt:EntryIfAllowComments>yes<MTElse>e022</MTElse></mt:EntryIfAllowComments>
<mt:EntryIfCommentsOpen>yes<MTElse>e023</MTElse></mt:EntryIfCommentsOpen>
<mt:IfPingsActive>yes<MTElse>e024</MTElse></mt:IfPingsActive>
<mt:IfPingsAccepted>yes<MTElse>e025</MTElse></mt:IfPingsAccepted>
<mt:IfPingsAllowed>yes<MTElse>e026</MTElse></mt:IfPingsAllowed>
<mt:IfPingsModerated>yes<MTElse>e027</MTElse></mt:IfPingsModerated>
--- expected
e001
e002
e003
e004
e005
e006
e007
e008
e009
e010
e011
e012
e013
e014
e015
e016
e017
e018
e019
e020
e021
e022
e023
e024
e025
e026
e027
