# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::JunkFilter;

use strict;
use warnings;
use MT;

# constants that force an action or determination. these are all non-numeric
sub ABSTAIN () {'ABSTAIN'}
sub HAM ()     {'HAM'}
sub SPAM ()    {'SPAM'}
sub APPROVE () {'APPROVE'}
sub JUNK ()    {'JUNK'}

use Exporter;
*import = \&Exporter::import;
our ( @EXPORT_OK, %EXPORT_TAGS );
@EXPORT_OK = qw(ABSTAIN HAM SPAM APPROVE JUNK);
%EXPORT_TAGS = ( constants => [qw(ABSTAIN HAM SPAM APPROVE JUNK)] );

sub core_filters {

    # MT Registry style list of core filters
    return {};
}

sub filter {
    my $pkg = shift;
    my ($obj) = @_;
    my $blog;
    $blog = MT::Blog->load( $obj->blog_id ) if $obj->blog_id;
    my $threshold = $blog ? $blog->junk_score_threshold : 0;

    # Have the item scored by plugin tests, save any log messages:
    my ( $score, $log_msgs ) = $pkg->score($obj);
    if ( defined $score ) {
        $obj->junk_log( join( "\n", @$log_msgs ) );
        $obj->junk_score($score);
    }

    # Take action as determined by the score:
    if ( defined $score ) {
        if ( $score < $threshold ) {
            $obj->junk_log( $obj->junk_log
                    . "\n---> "
                    . MT->translate("Action: Junked (score below threshold)")
            );
            $obj->junk;
        }
        else {

            # If the item has been moderated, we're done.
            # (Plugin has the responsibility of logging its moderate action.)
            return if ( $obj->is_moderated );

            $obj->junk_log( $obj->junk_log
                    . "\n---> "
                    . MT->translate("Action: Published (default action)") );
        }
    }
}

{
    my @junk_filters;

    sub all_filters {
        return @junk_filters if @junk_filters;
        if ( my $filters = MT->registry("junk_filters") ) {
            for my $f ( values %$filters ) {
                push @junk_filters, $f;
            }
        }
        return @junk_filters;
    }
}

sub score {
    my $pkg = shift;
    my ($obj) = @_;

    my $total = 0;    # the composite score for non-ABSTAIN'd tests
    my $count = 0;    # the ones that don't abstain
    my @log;

    # Run all the registered filters & average their results.
    foreach my $filter ( $pkg->all_filters ) {
        my $hdlr = $filter->{code} || $filter->{handler};
        next unless defined $hdlr;
        unless ( ref $hdlr eq 'CODE' ) {
            $hdlr = $filter->{code} = MT->handler_to_coderef($hdlr);
            next unless $hdlr;
        }
        my ( $score, $log ) = eval { $hdlr->($obj) };
        if ($@) {
            my $err  = $@;
            my $name = $filter->{name};
            if ( my $plugin = $filter->{plugin} ) {
                $name ||= $plugin->name;
            }
            MT->instance->log(
                {   message => MT->translate(
                        "Junk Filter [_1] died with: [_2]",
                        ( $name || ( MT->translate("Unnamed Junk Filter") ) ),
                        $err
                    ),
                    category => 'junk_filter',
                }
            );
            next;
        }
        if ( $score ne ABSTAIN ) {
            $score = 10  if $score > 10;
            $score = -10 if $score < -10;
            $total += $score;
            $count++;
        }
        if ($log) {
            if ( !( ref $log eq 'ARRAY' && @$log ) ) {
                $log = [$log];
            }
            my $line1 = shift @$log;
            my $name  = $filter->{name};
            if ( my $plugin = $filter->{plugin} ) {
                $name ||= $plugin->name;
            }
            push @log,
                (     ( $name || MT->translate('Unnamed Junk Filter') ) . " ("
                    . $score . "): "
                    . $line1 );
            push @log, "\t" . $_ foreach @$log;
        }
    }

    if ($total) {
        $total = $total / $count if $count > 0;
        $total = sprintf( "%.2f", $total );
        push @log,
            "\n---> " . MT->translate( 'Composite score: [_1]', $total );
    }
    return undef if !$count;
    ( $total, \@log );
}

sub task_expire_junk {
    my $pkg = shift;
    require MT::Blog;
    my $iter = MT::Blog->load_iter( { class => '*' } );
    my $removed = 0;
    my @blogs;
    my $blog;
    while ( $blog = $iter->() ) {
        push @blogs, $blog if $blog->junk_folder_expiry;
    }
    require MT::Util;
    require MT::Comment;
    require MT::TBPing;
    require MT::Entry;
    foreach $blog (@blogs) {
        my ( $blog_id, $expiry_age )
            = ( $blog->id, 86400 * $blog->junk_folder_expiry );
        my @ts = MT::Util::offset_time_list( time() - $expiry_age, $blog_id );
        my $ts = sprintf(
            "%04d%02d%02d%02d%02d%02d",
            $ts[5] + 1900,
            $ts[4] + 1,
            @ts[ 3, 2, 1, 0 ]
        );
        for my $class (qw(MT::Comment MT::TBPing)) {
            while (
                my @junk = $class->load(
                    {   last_moved_on => [ '19700101000000', $ts ],
                        junk_status   => -1,
                        blog_id       => $blog_id
                    },
                    { range => { last_moved_on => 1 }, limit => 1000 }
                )
                )
            {
                $removed++, $_->remove for @junk;
            }
        }

        while (
            my @junk = MT::Entry->load(
                {   status     => MT::Entry->JUNK(),
                    blog_id    => $blog_id,
                    created_on => [ '19700101000000', $ts ],
                },
                {   range => {
                        created_on => 1,
                        limit      => 1000
                    }
                }
            )
            )
        {
            $removed++, $_->remove for @junk;
        }
    }
    $pkg->_expire_commenter_registration;
    $removed ? 1 : 0;
}

sub _expire_commenter_registration {
    my $pkg = shift;
    require MT::Session;

    # remove commenter registration which has already expired (24 hrs)
    MT::Session->remove(
        { kind => 'CR', start => [ undef, time - 60 * 60 * 24 ] },
        { range => { start => 1 } } );
    1;
}

1;
__END__

=head1 NAME

MT::JunkFilter

=head1 SYNOPSIS

    use MT::JunkFilter;
    MT::JunkFilter->filter($comment);

=head1 Introduction

Movable Type 3.2 introduces a pluggable spam-detection framework
that plugin developers can extend without conflicting with each other. The
framework uses a "scoring" model: each plugin either assesses an incoming
feedback with a numerical score, or it abstains; the scores are combined into
a composite score. The composite score is used to decide what action to take
on the feedback: to publish it or throw it in the junk folder.

The composite score used by Movable Type is the average (arithmetic
mean) of all the attesting plugins' scores (we also allow a plugin to
I<abstain> in which case it is not included in the average). This value
is called the "composite score." If the composite score is above a threshold
(by default, 0) then we count the comment (or trackback) as junk.

Another way to think of it is to imagine that Movable Type weighs each comment
using a balance beam that starts out flat. Each plugin, after looking at the
item, can place a unit weight anywhere it wants on the balance beam (or it
can abstain). If every plugin places its weight on the left side of the
balance beam, it will tip to the left, which causes the item to be junked.
If every plugin places its weight on the right side, the beam will of course
tip that way and the item will be treated as not junk. If some plugins
put their weights on the right and some on the left, the outcome will depend
on how many weights are on each side and where they are placed. The average
is like the center of gravity of all these little weights.

Intuitively, large positive scores will overwhelm small negative scores, or
lots of scores on one side will overwhelm a few on the other side.

=head1 Scoring Guidelines

It is important to design your plugin carefully to be sure that it returns an
appropriate score. Here are some points to remember.

The threshold, by default, is 0, but the user can adjust it. In the balance
beam metaphor, this is like adjusting the "tare" weight or the bias on the
beam. This gives the user some control if they find that too many legitimate
comments are winding up in the junk folder or if too many junk comments are
being published. But this makes no excuse for a poorly-calibrated plugin.

As a corollary to this, remember that you needn't always return a numerical
value at all. There are many situations where your plugin has no information
about whether the item is junk or not--in that case, 0 is not the right value
to return, since 0 is in fact a vote. By default, this may make no
difference, but when the user has raised the threshold, 0 will be
interpreted as a vote for "not junk" or, if the threshold was lowered, 0
would then be interpreted as a vote for "junk."

Think of the balance beam as a perfectly smooth continuum from -10 to +10 --
don't count on any particular value being the cutoff between junk and
not-junk. If your plugin's sensors don't know what to make of a comment, it
should abstain and let other plugins take care of it.

=head1 METHODS

=head2 filter($obj)

Score the object, mark as junk or not-junk and log the action.

=head2 score($obj)

Apply the defined filters and return the junk score.

=head2 task_expire_junk()

Perform junk expiration for each blog.

=head1 The API: Sample Code

To get familiar with the API, let's look at some example code.

As we all know, the "e" character is eeevil. So here is a plugin to
detect any E's in an incoming feedback and place a high junk score on
items that have a lot of those monsters.

    package SpamTest;

    use strict;

    use MT::JunkFilter qw(ABSTAIN);
    use base 'MT::Plugin';

    sub name { "Sample Spam Detector"; }
    sub description { "Counts the number of E's, an indicator of junk."; }

    sub score {
        my ($obj) = @_;
        my @es = $obj->all_text =~ m/(e)/gi;
        my $count = scalar @es;
        my $score = (2 ** $count - 1);
        return ABSTAIN if ($score <= 0);

        return (-$score, "Contained $count 'e' characters");
    }

    MT->add_plugin(__PACKAGE__->new);
    MT->register_junk_filter({name => 'E Junk Filter', code => \&score});

    1;

Some of this is boilerplate for defining a basic Movable Type plugin. Let's
cut to the junk.

    MT->register_junk_filter({name => 'E Junk Filter', code => \&score});

This line registers my score routine to be run against incoming comments.
The structure of one of these routines is straightforward:

    sub score {
        my ($obj) = @_;

        # ... return ABSTAIN if I can't find any E's ...
        # ... calculate a score based on "e" count ...

        return (-$score, "Contained $count 'e' characters");
    }

The only argument to this routine is the comment (or TrackBack) to be
filtered.

The return value should be a list ($score, [$log_line1, $log_line2]). The
latter value (the array of log messages) can be omitted. $score should be
either a real number in the range [-10, +10] or the special value ABSTAIN
imported from the MT::JunkFilter package.

Let's break down the example routine a bit further. We use a Perl regular
expression to count the E's and then we apply a mathematical function so that
the score increases dramatically with each additional E. One E is suspicious,
but four or five E's just can't be good.

It is good practice to provide a log message that includes the score you're
returning. The messages will be displayed in the admin interface along with
the comment, so that the weblog owner can track how a score got to be what
it is. Movable Type will add a log line with the final score and the action
taken.

If there are no E's in the comment, the plugin has no rightful judgment about
the feedback. It might be clean, or there might be some other, unrelated signs
that should flag it as junk. That's none of this plugin's business, so it
returns ABSTAIN.

Note that a return value of 0 is truly a judgment on the comment, and not an
abstention. What kind of judgment is it? Well, it's a judgment more spammy
than -1, but less spammy than 1, for example. Since the weblog owner can
adjust the threshold, a 0 result can actually trip the comment into junked,
or rescue a good comment from the junk folder. As a plugin developer, you
don't know how the user is going to adjust his or her threshold, so you have
to see the 0 value as just somewhere in the middle of the spectrum.

By contrast, ABSTAIN indicates that your plugin has no way of judging
whether the item is junk or not. It won't affect the composite score one
way or another. A whitelist plugin (below) never wants to tip a comment
over into the junk folder -- it doesn't know what would make a comment junk,
so it would be reckless to do so. And, except for the small list of
whitelisted names, it doesn't know how to recognize a not-junk comment,
either. So it abstains unless it sees something that is meaningful on the
axis it measures.

    sub score {
        my ($obj) = @_;
        my @whitelist_terms = ('George\s+Lucas', 'Boutros\s+Boutros\s+Ghali',
                               'Neil\s+Armstrong', 'Salif\s+Keita');
        my $whitelist_expr = join "|", @whitelist_terms;
    
        if ($obj->all_text() =~ /$whitelist_expr/i) {
            return (1, "Whitelisted by spam-whitelister.pl");
        } else {
            return ABSTAIN;
        }
    }

You're invited to use the "SpamLookup" junk filters that were supplied
with Movable Type as a basis for developing your own Junk Filter plugins.
The SpamLookup code included with Movable Type is licensed under the
Artistic License and may be modified and/or redistributed under the same
terms as Perl itself.

=head1 LICENSE

The license that applies is the one you agreed to when downloading
Movable Type.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
