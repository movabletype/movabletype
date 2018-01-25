#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use File::Spec;
use Data::Dumper;

my $components = {
    'core' => {
        paths => [
            qw(
                MT/Template/ContextHandlers.pm
                MT/Template/Context/Search.pm
                MT/Template/Tags/Archive.pm
                MT/Template/Tags/Asset.pm
                MT/Template/Tags/Author.pm
                MT/Template/Tags/Blog.pm
                MT/Template/Tags/Calendar.pm
                MT/Template/Tags/Category.pm
                MT/Template/Tags/CategorySet.pm
                MT/Template/Tags/ContentType.pm
                MT/Template/Tags/Entry.pm
                MT/Template/Tags/Filters.pm
                MT/Template/Tags/Folder.pm
                MT/Template/Tags/Misc.pm
                MT/Template/Tags/Page.pm
                MT/Template/Tags/Pager.pm
                MT/Template/Tags/Score.pm
                MT/Template/Tags/Search.pm
                MT/Template/Tags/Site.pm
                MT/Template/Tags/Tag.pm
                MT/Template/Tags/Userpic.pm
                MT/Template/Tags/Website.pm
                MT/Summary/Author.pm
                )
        ],
    },

    # 'commercial' =>
    #     { paths => [ 'CustomFields/Template/ContextHandlers.pm', ], },
    'community'    => { paths => [ 'MT/Community/Tags.pm', ], },
    'multiblog'    => { paths => [ 'MultiBlog/Tags.pm', ], },
    'FeedsAppLite' => { paths => [ 'MT/Feeds/Tags.pm', ], },
};

my @removed_from_core = qw(
    BlogCommentCount BlogPingCount
    CategoryCommentCount CategoryTrackbackCount CategoryTrackbackLink
    CommentAuthor CommentAuthorIdentity CommentAuthorLink
    CommentBlogID CommentBody CommentDate CommentEmail
    CommentEntryID CommentFields CommentID CommentIP
    CommentLink CommentName CommentOrderNumber CommentParentID
    CommentPreviewAuthor CommentPreviewAuthorLink
    CommentPreviewBody CommentPreviewDate CommentPreviewEmail
    CommentPreviewIP CommentPreviewIsStatic CommentPreviewState
    CommentPreviewURL CommentRank CommentRepliesRecurse
    CommentReplyToLink CommentScore CommentScoreAvg
    CommentScoreCount CommentScoreHigh CommentScoreLow
    CommentSiteID CommentURL CommenterAuthIconURL
    CommenterAuthType CommenterEmail CommenterID
    CommenterName CommenterNameThunk CommenterURL
    CommenterUsername CommenterUserpic CommenterUserpicURL
    EntryCommentCount EntryTrackbackCount EntryTrackbackData
    EntryTrackbackID EntryTrackbackLink
    PingBlogName PingDate PingExcerpt PingID PingIP
    PingRank PingScore PingScoreAvg PingScoreCount
    PingScoreHigh PingScoreLow PingSiteName PingTitle
    PingURL PingsSentURL RemoteSignInLink RemoteSignOutLink
    SignInLink SignOnURL SignOutLink SiteCommentCount SitePingCount
    TypeKeyToken UserSessionCookieDomain UserSessionCookieName
    UserSessionCookiePath UserSessionCookieTimeout
    UserSessionState WebsiteCommentCount WebsitePingCount

    BlogIfCommentsOpen CategoryIfAllowPings
    CommentEntry CommentIfModerated CommentParent
    CommentReplies CommenterIfTrusted CommenterUserpicAsset
    Comments CommentsFooter CommentsHeader
    EntryIfAllowComments EntryIfAllowPings EntryIfCommentsOpen
    IfAllowCommentHTML IfCommentParent IfCommentReplies
    IfCommenterIsAuthor IfCommenterIsEntryAuthor
    IfCommenterRegistrationAllowed IfCommenterTrusted
    IfCommentsAccepted IfCommentsActive IfCommentsAllowed
    IfCommentsModerated IfExternalUserManagement
    IfNeedEmail IfPingsAccepted IfPingsActive IfPingsAllowed
    IfPingsModerated IfRegistrationAllowed IfRegistrationNotRequired
    IfRegistrationRequired IfRequireCommentEmails IfTypeKeyToken
    PingEntry Pings PingsFooter PingsHeader PingsSent
    SiteIfCommentsOpen WebsiteIfCommentsOpen
);

my %is_removed = map { $_ => 1 } @removed_from_core;

my $mt = MT->instance;

my $tag_count = 0;
foreach my $c ( sort keys %$components ) {
    next unless $mt->component($c);
    my $tags     = $mt->component($c)->registry('tags');
    my $fn_count = scalar keys( %{ $tags->{function} } );
    $fn_count-- if $fn_count;
    my $mod_count = scalar keys( %{ $tags->{modifier} } );
    $mod_count-- if $mod_count;
    my $block_count = scalar keys( %{ $tags->{block} } );
    $block_count-- if $block_count;
    my $count = $fn_count + $mod_count + $block_count;
    $tag_count += $count;
}

foreach my $c ( sort keys %$components ) {
    next unless $mt->component($c);
    note("Checking for tag documentation for component $c");
    my $all_docs  = '';
    my $tags      = $mt->component($c)->registry('tags');
    my $core_tags = $mt->component('core')->registry('tags')
        unless $c eq 'core';

    my $paths = $components->{$c}{paths};
    {
        local $/ = undef;
    FILE: foreach my $file (@$paths) {

            # core tag docs are embedded as POD
            foreach my $inc (@INC) {
                my $file_path = File::Spec->catfile( $inc, $file );
                next unless -e $file_path;

                note("Reading module $file_path");
                open DOC, "< $file_path"
                    or die "Can't read file $file_path: " . $!;
                $all_docs .= <DOC>;
                close DOC;
                next FILE;
            }
            die "Could not locate $file!";
        }
    }

    # Determine if the core tags have adequate documentation or not.
    my $doc_names = {};
    while ( $all_docs =~ m/\n=head2[ ]+([\w:]+)[ ]*\n(.*?)?\n=cut[ ]*\n/gs ) {
        my $tag = $1;
        my $docs = defined $2 ? $2 : '';
        $docs =~ s/\r//g;    # for windows newlines
                             # ignore comment lines
        $docs =~ s/^#.*//gm;

        # ignore empty lines
        $docs =~ s/^\s*$//gm;

        # strip any '=for ...', etc. directive. docs should be above this
        $docs =~ s/(^|\n)=\w+.*//s;

        # strip trailing/leading newlines
        $docs =~ s/^\n+//s;
        $docs =~ s/\n+$//s;

  # if documentation block doesn't have anything left, the tag is undocumented
        next if $docs eq '';
        $doc_names->{$tag} = 1;
    }

    foreach my $tag ( sort keys %{ $tags->{function} } ) {
        next if $tag eq 'plugin';
        next if $is_removed{$tag};
        if ( $core_tags && $core_tags->{function}{$tag} ) {
            ok( 1, "component $c, function tag $tag (extends core tag)" );
        }
        else {
            ok( exists $doc_names->{$tag},
                "component $c, function tag $tag" );
        }
    }

    foreach my $tag ( sort keys %{ $tags->{block} } ) {
        next if $tag eq 'plugin';
        $tag =~ s/\?$//;
        next if $is_removed{$tag};
        if ( $core_tags && $core_tags->{block}{$tag} ) {
            ok( 1, "component $c, block tag $tag (extends core tag)" );
        }
        else {
            ok( exists $doc_names->{$tag}, "component $c, block tag $tag" );
        }
    }

    foreach my $tag ( sort keys %{ $tags->{modifier} } ) {
        next if $tag eq 'plugin';
        next if $is_removed{$tag};
        if ( $core_tags && $core_tags->{modifier}{$tag} ) {
            ok( 1, "component $c, modifier $tag (extends core tag)" );
        }
        else {
            ok( exists $doc_names->{$tag}, "component $c, modifier $tag" );
        }
    }
}

done_testing;
