#!/usr/bin/perl

# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: blog-common.pl 3531 2009-03-12 09:11:52Z fumiakiy $

use strict;
use vars qw( $T_CFG );

=pod

    blog-common.pl

      This is the gold standard of test data for all the tests in t/.
      If you need more test data, it's best to put it in here, rather
      than to just create it in your test script, since your data
      could screw up one of the other tests in an unpredictable
      fashion (depending on which test runs first, e.g.).

      When adding to the common loopable objects (entries, comments,
      pings) it's wise to choose positions that don't put those
      objects in the first few objects, because those will break the
      tag loops used in t/35-tags.t. You've been warned.

=cut


require MT;

$T_CFG = $ARGV[0] || $T_CFG;

my $mt = MT->instance(Config => $T_CFG) or die "No MT object " . MT->errstr();

my $driver = MT::Object->driver();
my @tables = keys %{ $mt->registry("object_types") };
@tables = grep { ! m/^plugin$/ } @tables;
my $dbh = $driver->rw_handle;
$dbh->do("drop table mt_$_") foreach @tables;
if (MT->config('ObjectDriver') =~ m/(postgres|pg)/i) {
    $dbh->do("drop sequence mt_$_\_id") foreach @tables;
}
require MT::Upgrade;
MT::Upgrade->do_upgrade(Install => 1, App => __PACKAGE__);

my$blog = MT::Blog->new();
$blog->set_values({ name => 'none',
                        site_url => 'http://narnia.na/nana/',
                        archive_url => 'http://narnia.na/nana/archives/',
                        site_path => 't/site/',
                        archive_path => 't/site/archives/',
                        archive_type=>'Individual,Monthly,Weekly,Daily,Category',
                        archive_type_preferred => 'Individual',
                        description => "Narnia None Test Blog",
                        custom_dynamic_templates => 'custom',
                        convert_paras => 1,
                        allow_reg_comments => 1,
                        allow_unreg_comments => 0,
                        allow_pings => 1,
                        sort_order_posts => 'descend',
                        sort_order_comments => 'ascend',
                        remote_auth_token => 'token',
                        convert_paras_comments => 1,
                        google_api_key => 'r9Vj5K8PsjEu+OMsNZ/EEKjWmbCeQAv1',
                        cc_license => 'by-nc-sa http://creativecommons.org/licenses/by-nc-sa/2.0/ http://creativecommons.org/images/public/somerights20.gif',
                        server_offset => '-3.5',
                        children_modified_on => '20000101000000',
                        language => 'en_us',
                        file_extension => 'html'
                        });
$blog->id(1);
$blog->save() or die "Couldn't save blog 1: ". $blog->errstr;

require MT::Entry;
require MT::Author;
my $chuckd = MT::Author->new();
$chuckd->set_values({ name => 'Chuck D', nickname => 'Chucky Dee', 
                      email => 'chuckd@example.com', url => 'http://chuckd.com/', api_password => 'seecret'});
$chuckd->set_password("bass");
$chuckd->type(MT::Author::AUTHOR());
$chuckd->id(2);
$chuckd->is_superuser(1);
$chuckd->save() or die "Couldn't save author record 2: " . $chuckd->errstr;

my $bobd = MT::Author->new();
$bobd->set_values({ name => 'Bob D', nickname => 'Dylan', 
                    email => 'bobd@example.com'});
$bobd->set_password("flute");
$bobd->type(MT::Author::AUTHOR());
$bobd->id(3);
$bobd->save() or die "Couldn't save author record 3: " . $bobd->errstr;

my $johnd = MT::Author->new();
$johnd->set_values({ name => 'John Doe', email => 'jdoe@doe.com' });
$johnd->type(MT::Author::COMMENTER());
$johnd->password('(none)');
$johnd->id(4);
$johnd->save() or die "Couldn't save author record 4: " . $johnd->errstr;

require MT::Permission;
my $perm = MT::Permission->new();
$perm->author_id($chuckd->id);
$perm->blog_id(1);
$perm->can_post(1);
$perm->can_edit_all_posts(1);
$perm->save() or die "Couldn't save permission record 1: ".$perm->errstr;

$perm = MT::Permission->new();
$perm->author_id($bobd->id);
$perm->blog_id(1);
$perm->can_post(1);
$perm->can_edit_templates(1);
$perm->save() or die "Couldn't save permission record 2: ".$perm->errstr;

# set permission record for johnd commenter on blog 1
$johnd->approve(1);

my $entry = MT::Entry->load(1);
if (!$entry) {
    $entry = MT::Entry->new();
    $entry->set_values({ blog_id => 1,
                         title => 'A Rainy Day',
                         text => 'On a drizzly day last weekend,',
                         text_more => 'I took my grandpa for a walk.',
                         excerpt => 'A story of a stroll.',
                         keywords => 'keywords',
                         created_on => '19780131074500',
                         modified_on => '19780131074600',
                         author_id => $chuckd->id,
                         pinged_urls => 'http://technorati.com/',
                         allow_comments => 1,
                         allow_pings => 1,
                         status => MT::Entry::RELEASE()});
    $entry->id(1);
    $entry->tags('rain', 'grandpa', 'strolling');
    $entry->save() or die "Couldn't save entry record 1: ".$entry->errstr;
}

$entry = MT::Entry->load(2);
if (!$entry) {
    $entry = MT::Entry->new();
    $entry->set_values({ blog_id => 1,
                         title => 'A preponderance of evidence',
                         text => 'It is sufficient to say...',
                         text_more => 'I suck at making up test data.',
                         created_on => '19790131074500',
                         modified_on => '19790131074600',
                         author_id => $bobd->id,
                         allow_comments => 1,
                         status => MT::Entry::FUTURE()});
    $entry->id(2);
    $entry->save() or die "Couldn't save entry record 2: ".$entry->errstr;
}

$entry = MT::Entry->load(3);
if (!$entry) {
    $entry = MT::Entry->new();
    $entry->set_values({ blog_id => 1,
                         title => 'Spurious anemones',
                         text => '...are better than the non-spurious',
                         text_more => 'variety.',
                         created_on => '19770131074500',
                         modified_on => '19770131074600',
                         author_id => $chuckd->id,
                         allow_comments => 1,
                         allow_pings => 0,
                         status => MT::Entry::HOLD()});
    $entry->id(3);
    $entry->tags('anemones');
    $entry->save() or die "Couldn't save entry record 3: ".$entry->errstr;
}

require MT::Trackback;
my $tb = MT::Trackback->load(1);
if (!$tb) {
    $tb = new MT::Trackback;
    $tb->entry_id(1);
    $tb->blog_id(1);
    $tb->title("Entry TrackBack Title");
    $tb->description("Entry TrackBack Description");
    $tb->category_id(0);
    $tb->id(1);
    $tb->save or die "Couldn't save Trackback record 1: " . $tb->errstr;;
}

require MT::TBPing;
my $ping = MT::TBPing->load(1);
if (!$ping) {
    $ping = new MT::TBPing;
    $ping->tb_id(1);
    $ping->blog_id(1);
    $ping->ip('127.0.0.1');
    $ping->title('Foo');
    $ping->excerpt('Bar');
    $ping->source_url('http://example.com/');
    $ping->blog_name("Example Blog");
    $ping->created_on('20050405000000');
    $ping->id(1);
    $ping->visible(1);
    $ping->save or die "Couldn't save TBPing record 1: " . $ping->errstr;
}

my @verses = ('Oh, where have you been, my blue-eyed son?
Oh, where have you been, my darling young one?',
'I saw a newborn baby with wild wolves all around it
I saw a highway of diamonds with nobody on it',
'Heard one hundred drummers whose hands were a-blazin\',
Heard ten thousand whisperin\' and nobody listenin\'',
'I met one man who was wounded in love,
I met another man who was wounded with hatred',
'Where hunger is ugly, where souls are forgotten,
Where black is the color, where none is the number,
And it\'s a hard, it\'s a hard, it\'s a hard, it\'s a hard,
It\'s a hard rain\'s a-gonna fall');

require MT::Category;
my $cat = new MT::Category;
$cat->blog_id(1);
$cat->label('foo');
$cat->description('bar');
$cat->author_id($chuckd->id);
$cat->parent(0);
$cat->save or die "Couldn't save category record 1: ". $cat->errstr;
my $parent_cat = $cat->id;

$cat = new MT::Category;
$cat->blog_id(1);
$cat->label('bar');
$cat->description('foo');
$cat->author_id($chuckd->id);
$cat->parent(0);
$cat->save or die "Couldn't save category record 2: ". $cat->errstr;

$tb = MT::Trackback->load(2);
if (!$tb) {
    $tb = new MT::Trackback;
    $tb->title("Category TrackBack Title");
    $tb->description("Category TrackBack Description");
    $tb->entry_id(0);
    $tb->blog_id(1);
    $tb->category_id(2);
    $tb->id(2);
    $tb->save or die "Couldn't save Trackback record 2: " . $tb->errstr;;
}

$cat = new MT::Category;
$cat->blog_id(1);
$cat->label('subfoo');
$cat->description('subcat');
$cat->author_id($bobd->id);
$cat->parent($parent_cat);
$cat->save or die "Couldn't save category record 3: ". $cat->errstr;

require MT::Placement;
foreach my $i (1..@verses) {
    $entry = MT::Entry->load($i+3);
    if (!$entry) {
        $entry = MT::Entry->new();
        $entry->set_values({ blog_id => 1,
                             title => "Verse $i",
                             text => $verses[$i],
                             author_id => ($i == 3 ? $bobd->id : $chuckd->id),
                             authored_on => sprintf("%04d0131074501", $i + 1960),
                             created_on => sprintf("%04d0131074501", $i + 1960),
                             modified_on => sprintf("%04d0131074601", $i + 1960),
                             allow_comments => ($i <= 2 ? 0 : 1),
                             status => MT::Entry::RELEASE() });
        $entry->id($i+3);
        $entry->tags('verse');
        $entry->save() or die "Couldn't save entry record ".($entry->id).": ". $entry->errstr;
        if ($i == 3) {
            my $place = new MT::Placement;
            $place->entry_id($entry->id);
            $place->blog_id(1);
            $place->category_id(1);
            $place->is_primary(1);
            $place->save or die "Couldn't save placement record: ".$place->errstr;
        }
        if ($i == 4) {
            my $place = new MT::Placement;
            $place->entry_id($entry->id);
            $place->blog_id(1);
            $place->category_id(3);
            $place->is_primary(1);
            $place->save or die "Couldn't save placement record: ".$place->errstr;
        }
    }
}

# entry id 1 - 1 visible comment
# entry id 4 - no comments, commenting is off
require MT::Comment;
unless (MT::Comment->count({entry_id => 1})) {
    my $cmt = new MT::Comment();
    $cmt->set_values({text => 'Postmodern false consciousness has always been firmly rooted in post-Freudian Lacanian neo-Marxist bojangles. Needless to say, this quickly and asymptotically approches a purpletacular jouissance of etic jumpinmypants.',
                      entry_id => 1,
                      author => 'v14GrUH 4 cheep',
                      visible => 1,
                      author => 'Jake',
                      email => 'jake@fatman.com',
                      url => 'http://fatman.com/',
                      blog_id => 1,
                      ip => '127.0.0.1',
                      created_on => '20040914182800'});
    $cmt->id(1);
    $cmt->save() or die "Couldn't save comment record 1: ".$cmt->errstr;
}
# entry id 5 - 1 comment, commenting is off (closed)
unless (MT::Comment->count({entry_id => 5})) {
    my $cmt = new MT::Comment();
    $cmt->set_values({text => 'Comment for entry 5, visible',
                      entry_id => 5,
                      author => 'Comment 2',
                      visible => 1,
                      email => 'johnd@doe.com',
                      url => 'http://john.doe.com/',
                      commenter_id => $johnd->id,
                      blog_id => 1,
                      ip => '127.0.0.1',
                      created_on => '20040912182800'});
    $cmt->id(2);
    $cmt->junk_score(1.5);
    $cmt->save() or die "Couldn't save comment record 2: ".$cmt->errstr;
}
# entry id 6 - 1 comment visible, 1 moderated
unless (MT::Comment->count({entry_id => 6})) {
    my $cmt = new MT::Comment();
    $cmt->set_values({text => 'Comment for entry 6, visible',
                      entry_id => 6,
                      author => 'Comment 3',
                      visible => 1,
                      email => '',
                      url => '',
                      blog_id => 1,
                      ip => '127.0.0.1',
                      created_on => '20040911182800'});
    $cmt->id(3);
    $cmt->save() or die "Couldn't save comment record 3: ".$cmt->errstr;

    $cmt->id(4);
    $cmt->visible(0);
    $cmt->author('Comment 4');
    $cmt->text('Comment for entry 6, moderated');
    $cmt->created_on('20040910182800');
    $cmt->save() or die "Couldn't save comment record 4: ".$cmt->errstr;
}
# entry id 7 - 0 comment visible, 1 moderated
unless (MT::Comment->count({entry_id => 7})) {
    my $cmt = new MT::Comment();
    $cmt->set_values({text => 'Comment for entry 7, moderated',
                      entry_id => 7,
                      author => 'Comment 7',
                      visible => 0,
                      email => '',
                      url => '',
                      blog_id => 1,
                      ip => '127.0.0.1',
                      created_on => '20040909182800'});
    $cmt->id(5);
    $cmt->save() or die "Couldn't save comment record 5: ".$cmt->errstr;
}
# entry id 8 - 1 comment visible, 1 moderated, 1 junk
unless (MT::Comment->count({entry_id => 8})) {
    my $cmt = new MT::Comment();
    $cmt->set_values({text => 'Comment for entry 8, visible',
                      entry_id => 8,
                      author => 'Comment 8',
                      visible => 1,
                      email => '',
                      url => '',
                      blog_id => 1,
                      ip => '127.0.0.1',
                      created_on => '20040814182800'});
    $cmt->id(6);
    $cmt->save() or die "Couldn't save comment record 6: ".$cmt->errstr;

    $cmt->id(7);
    $cmt->visible(0);
    $cmt->text('Comment for entry 8, moderated');
    $cmt->author('JD7');
    $cmt->created_on('20040812182800');
    $cmt->save() or die "Couldn't save comment record 7: ".$cmt->errstr;

    $cmt->id(8);
    $cmt->visible(0);
    $cmt->junk_status(-1);
    $cmt->text('Comment for entry 8, junk');
    $cmt->author('JD8');
    $cmt->created_on('20040810182800');
    $cmt->save() or die "Couldn't save comment record 8: ".$cmt->errstr;
}

require MT::Template;
require MT::TemplateMap;

my $tmpl = new MT::Template;
$tmpl->blog_id(1);
$tmpl->name('blog-name');
$tmpl->text('<MTBlogName>');
$tmpl->type('custom');
$tmpl->save or die "Couldn't save template record 1: ".$tmpl->errstr;

$mt->rebuild(BlogId => 1, EntryCallback => sub { print "- Rebuilding entry " . $_[0]->id . "\n" });

sub progress {
    my ($x, $msg) = @_;
    print "* $msg\n";
}
sub error {
    my ($x, $msg) = @_;
    print "ERROR: $msg\n";
}

1;
