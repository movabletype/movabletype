# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::TBPing;

use strict;
use base qw( MT::Object MT::Scorable );

sub JUNK()      { -1 }
sub NOT_JUNK () {  1 }

__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'blog_id' => 'integer not null',
        'tb_id' => 'integer not null',
        'title' => 'string(255)',
        'excerpt' => 'text',
        'source_url' => 'string(255)',
        'ip' => 'string(50) not null',
        'blog_name' => 'string(255)',
        'visible' => 'boolean',
        'junk_status' => 'smallint not null',
        'last_moved_on' => 'datetime not null',
        'junk_score' => 'float',
        'junk_log' => 'text',
    },
    indexes => {
        created_on => 1,
        tb_visible => {
            columns => [ 'tb_id', 'visible', 'created_on' ],
        },
        ip => 1,
        last_moved_on => 1, # used for junk expiration
        # For URL lookups to aid spam filtering
        blog_url => {
            columns => [ 'blog_id', 'visible', 'source_url' ],
        },
        blog_stat => {
            columns => ['blog_id', 'junk_status', 'created_on'],
        },
        blog_visible => {
            columns => ['blog_id', 'visible', 'created_on', 'id'],
        },
        visible_date => {
            columns => [ 'visible', 'created_on' ],
        },
        junk_date => {
            columns => [ 'junk_status', 'created_on' ],
        },
    },
    defaults => {
        junk_status => NOT_JUNK,
        last_moved_on => '20000101000000',
    },
    audit => 1,
    meta => 1,
    datasource => 'tbping',
    primary_key => 'id',
});

sub class_label {
    return MT->translate('TrackBack');
}

sub class_label_plural {
    return MT->translate('TrackBacks');
}

sub list_props {
    return {
        excerpt => {
            label => 'Excerpt',
            auto => 1,
            display => 'force',
            order => 100,
            html  => sub {
                my ( $prop, $obj, $app ) = @_;
                my $text = MT::Util::remove_html($obj->excerpt);
                ## FIXME: Hard coded...
                my $len  = 30;
                if ( $len < length($text) ) {
                    $text = substr($text, 0, $len);
                    $text .= '...';
                }
                elsif ( !$text ) {
                    $text = '...';
                }
                my $id  = $obj->id;
                my $edit_link = $app->uri(
                    mode => 'view',
                    args => {
                        _type   => 'ping',
                        id      => $id,
                        blog_id => $obj->blog_id,
                });
                my $status = $obj->is_junk      ? 'Junk'
                           : $obj->is_published ? 'Published'
                           :                      'Moderated';
                my $lc_status = lc $status;
                my $status_img = MT->static_path . 'images/status_icons/';
                $status_img .= $status eq 'Junk'      ? 'warning.gif'
                             : $status eq 'Published' ? 'success.gif'
                             :                          'draft.gif';

                my $blog_name = $obj->blog_name  || '';
                my $title     = $obj->title      || '';
                my $url       = $obj->source_url || '';
                my $view_img = MT->static_path . 'images/status_icons/view.gif';
                my $ping_from =
                  MT->translate( '<a href="[_1]">Ping from: [_2] - [_3]</a>',
                    $edit_link, $blog_name, $title );

                return qq{
                    <span class="icon status $lc_status">
                        <img als="$status" src="$status_img" />
                    </span>
                    <span class="ping-from">$ping_from</span>
                    <span class="view-link">
                      <a href="$url" target="_blank">
                        <img alt="View" src="$view_img" />
                      </a>
                    </span>
                    <p class="ping-excerpt description">$text</p>
                };
            },
        },
        ip => {
            label => 'IP',
            auto  => 1,
            order => 200,
            condition => sub { MT->config->ShowIPInformation },
        },
        blog_name => {
            base    => '__common.blog_name',
            display => 'default',
            order   => 300,
        },
        target => {
            label       => 'Target',
            display     => 'default',
            order       => 400,
            view_filter => 'none',
            base        => '__virtual.string',
            bulk_html   => sub {
                my ( $prop, $objs, $app ) = @_;
                my %tbs = map { $_->tb_id => 1 } @$objs;
                my @tbs = MT->model('trackback')->load({ id => [ keys %tbs ] });
                my %tb_map  = map { $_->id => $_ } @tbs;
                my %entries = map { $_->entry_id => 1 } grep { $_->entry_id } @tbs;
                my @entries = MT->model('entry')->load({ id => [ keys %entries ]})
                    if scalar keys %entries;
                my %entry_map  = map { $_->id => $_ } @entries;
                my %categories = map { $_->category_id => 1 } grep { $_->category_id } @tbs;
                my @categories = MT->model('category')->load({ id => [ keys %categories ]})
                    if scalar keys %categories;
                my %category_map  = map { $_->id => $_ } @categories;
                my $title_prop = MT::ListProperty->instance( '__virtual.title' );
                my @res;
                for my $obj ( @$objs ) {
                    my $tb = $tb_map{$obj->tb_id};
                    my $obj;
                    if ( $tb->entry_id ) {
                        $obj = $entry_map{$tb->entry_id};
                        $title_prop->{col} = 'title';
                    }
                    elsif ( $tb->category_id ) {
                        $obj = $category_map{$tb->category_id};
                        $title_prop->{col} = 'label';
                    }
                    my $title_html = $title_prop->html($obj,$app);
                    my $type = $obj->class_type;
                    my $img = MT->static_path . 'images/nav_icons/color/' . $type . '.gif';
                    push @res, qq{
                        <span class="icon target-type $type">
                          <img src="$img" />
                        </span>
                        $title_html
                    };
                }
                @res;
            },
        },
        created_on => {
            base    => '__virtual.created_on',
            display => 'default',
            order   => 500,
        },
        modified_on => {
            auto    => 1,
            label   => 'Modeified on',
            display => 'none' },
        from => {
            label => 'From',
            view_filter => [],
            sort  => sub {
                my $prop = shift;
                my ( $terms, $args ) = @_;
                my $dir = $args->{direction} eq 'descend' ? 'DESC' : 'ASC';
                $args->{sort} = [
                    { column => 'blog_name', desc => $dir },
                    { column => 'title', desc => $dir },
                ];
            },
        },
        author_name => {
            condition => sub {0},
        },
        source_blog_name => {
            label => 'Sender blog name',
            col   => 'blog_name',
            display => 'none',
            base  => '__virtual.string',
        },
        source_url => {
            auto    => 1,
            label   => 'Sender URL',
            display => 'none',
        },
        status => {
            base  => 'comment.status',
        },
        title => {
            label => 'Sender title',
            auto  => 1,
            display => 'none',
        },
        entry_id => {
            base => '__virtual.integer',
            label => 'Entry/Page',
            display => 'none',
            filter_editable => 0,
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $entry_id = $args->{value};
                $db_args->{joins} ||= [];
                push @{$db_args->{joins}}, MT->model('trackback')->join_on(
                    undef,
                    {
                        entry_id => $entry_id,
                        id => \'= tbping_tb_id',
                    },
                );
            },
            label_via_param => sub {
                my ( $prop, $app ) = @_;
                my $entry_id = $app->param('filter_val');
                my $entry = MT->model('entry')->load($entry_id);
                my $type = $entry->class eq 'entry' ? 'Entry'
                         : $entry->class eq 'page'  ? 'Page'
                         :                            '';
                return MT->translate(
                    'Trackbacks on [_1]: [_2]',
                    $type,
                    $entry->title,
                );
            },
        },
        category_id => {
            base => '__virtual.integer',
            display => 'none',
            filter_editable => 0,
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $cat_id = $args->{value};
                $db_args->{joins} ||= [];
                push @{$db_args->{joins}}, MT->model('trackback')->join_on(
                    undef,
                    {
                        category_id => $cat_id,
                        id => \'= tbping_tb_id',
                    },
                );
            },
            label_via_param => sub {
                my ( $prop, $app ) = @_;
                my $cat_id = $app->param('filter_val');
                my $cat = MT->model('category')->load($cat_id);
                my $type = $cat->class eq 'category' ? 'Category'
                         : $cat->class eq 'folder'   ? 'Folder'
                         :                             '';
                return MT->translate(
                    'Trackbacks on [_1]: [_2]',
                    $type,
                    $cat->label,
                );
            },
        },
        for_current_user => {
            label => 'For my entries',
            terms => sub {
                my ( $prop, $args, $db_terms, $db_args ) = @_;
                my $user = MT->app->user;
                $db_args->{joins} ||= [];
                push @{ $db_args->{joins} }, MT->model('trackback')->join_on(
                    undef,
                    {
                        id       => \"= tbping_tb_id",
                        entry_id => \"= entry_id",
                    },
                    {
                        join => MT->model('entry')->join_on(undef, {
                            author_id => $user->id,
                        }),
                    },
                );
            },
            filter_tmpl => '',
        },

    };
}

sub system_filters {
    return {
        not_spam => {
            label => 'Non spam trackbacks',
            items => [
                { type => 'status', args => { value => 'not_junk' }, },
            ],
        },
        not_spam_in_this_website => {
            label => 'Non spam trackbacks on this website',
            view => 'website',
            items => [
                { type => 'current_context' },
                { type => 'status', args => { value => 'not_junk' }, },
            ],
        },
        pending => {
            label => 'Pending trackbacks',
            items => [
                { type => 'status', args => { value => 'moderated' }, },
            ],
        },
        published => {
            label => 'Published trackbacks',
            items => [
                { type => 'status', args => { value => 'approved' }, },
            ],
        },
        on_my_entry => {
            label => 'Trackbacks on my entries/pages',
            items => sub {
                my $login_user = MT->app->user;
                [ { type => 'for_current_user' } ],
            },
        },
        in_last_7_days => {
            label => 'Trackbacks in the last 7 days',
            items => [
                { type => 'status', args => { value => 'not_junk' }, },
                { type => 'created_on', args => { option => 'days', days => 7 } }
            ],
        },
        spam => {
            label => 'Spam trackbacks',
            items => [
                { type => 'status', args => { value => 'junk' }, },
            ],
        },
        _trackbacks_by_entry => {
            label => sub {
                my $app = MT->app;
                my $id = $app->param('filter_val');
                my $entry = MT->model('entry')->load($id);
                return 'Trackbacks by entry: ' . $entry->title;
            },
            items => sub {
                my $app = MT->app;
                my $id = $app->param('filter_val');
                return [
                    { type => 'entry', args => { option => 'equal', value => $id } }
                ];
            },
        },
    };
}

sub is_junk {
    $_[0]->junk_status == JUNK;
}
sub is_not_junk {
    $_[0]->junk_status != JUNK;
}

sub is_published {
    return $_[0]->visible && !$_[0]->is_junk;
}

sub is_moderated {
    return !$_[0]->visible() && !$_[0]->is_junk();
}

sub blog {
    my ($ping) = @_;
    my $blog = $ping->{__blog};
    unless ($blog) {
        my $blog_id = $ping->blog_id;
        my $blog_class = MT->model('blog');
        $blog = $blog_class->load($blog_id) or
            return $ping->error(MT->translate(
                "Load of blog '[_1]' failed: [_2]", $blog_id, $blog_class->errstr));   
        $ping->{__blog} = $blog;
    }
    return $blog;
}

sub parent {
    my ($ping) = @_;
    if (my $tb = MT->model('trackback')->load($ping->tb_id)) {
        if ($tb->entry_id) {
            return MT->model('entry')->load($tb->entry_id);
        } else {
            return MT->model('category')->load($tb->category_id);
        }
    }
}

sub parent_id {
    my ($ping) = @_;
    if (my $tb = MT->model('trackback')->load($ping->tb_id)) {
        if ($tb->entry_id) {
            return ('MT::Entry', $tb->entry_id);
        } else {
            return ('MT::Category', $tb->category_id);
        }
    }
}

sub next {
    my $ping = shift;
    my($publish_only) = @_;
    $publish_only = $publish_only ? {'visible' => 1} : {};
    $ping->_nextprev('next', $publish_only);
}

sub previous {
    my $ping = shift;
    my($publish_only) = @_;
    $publish_only = $publish_only ? {'visible' => 1} : {};
    $ping->_nextprev('previous', $publish_only);
}

sub _nextprev {
    my $obj = shift;
    my $class = ref($obj);
    my ($direction, $publish_only) = @_;
    return undef unless ($direction eq 'next' || $direction eq 'previous');
    my $next = $direction eq 'next';

    my $label = '__' . $direction;
    return $obj->{$label} if $obj->{$label};

    # Selecting the adjacent object can be tricky since timestamps
    # are not necessarily unique for entries. If we find that the
    # next/previous object has a matching timestamp, keep selecting entries
    # to select all entries with the same timestamp, then compare them using
    # id as a secondary sort column.

    my ($id, $ts) = ($obj->id, $obj->created_on);
    my $iter = $class->load_iter({
        blog_id => $obj->blog_id,
        created_on => ($next ? [ $ts, undef ] : [ undef, $ts ]),
        %{$publish_only}
    }, {
        'sort' => 'created_on',
        'direction' => $next ? 'ascend' : 'descend',
        'range_incl' => { 'created_on' => 1 },
        'limit' => 10,
    });

    # This selection should always succeed, but handle situation if
    # it fails by returning undef.
    return unless $iter;

    # The 'same' array will hold any entries that have matching
    # timestamps; we will then sort those by id to find the correct
    # adjacent object.
    my @same;
    while (my $e = $iter->()) {
        # Don't consider the object that is 'current'
        next if $e->id == $id;
        my $e_ts = $e->created_on;
        if ($e_ts eq $ts) {
            # An object with the same timestamp should only be
            # considered if the id is in the scope we're looking for
            # (greater than for the 'next' object; less than for
            # the 'previous' object).
            push @same, $e
                if $next && $e->id > $id or !$next && $e->id < $id;
        } else {
            # We found an object with a timestamp different than
            # the 'current' object.
            if (!@same) {
                push @same, $e;
                # We should check to see if this new timestamped object also
                # has entries adjacent to _it_ that have the same timestamp.
                while (my $e = $iter->()) {
                    push(@same, $e), next if $e->created_on eq $e_ts;
                    $iter->end, last;
                }
            } else {
                $iter->end;
            }
            return $obj->{$label} = $e unless @same;
            last;
        }
    }
    if (@same) {
        # If we only have 1 element in @same, return that.
        return $obj->{$label} = $same[0] if @same == 1;
        # Sort remaining elements in @same by id.
        @same = sort { $a->id <=> $b->id } @same;
        # Return front of list (smallest id) if selecting 'next'
        # object. Return tail of list (largest id) if selection 'previous'.
        return $obj->{$label} = $same[$next ? 0 : $#same];
    }
    return;
}

sub junk {
    my $ping = shift;
    if (($ping->junk_status || 0) != JUNK) {
        require MT::Util;
        my @ts = MT::Util::offset_time_list(time, $ping->blog_id);
        my $ts = sprintf("%04d%02d%02d%02d%02d%02d",
                         $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0]);
        $ping->last_moved_on($ts);
    }
    $ping->junk_status(JUNK);
    $ping->visible(0);
}

sub moderate {
    my $ping = shift;
    $ping->visible(0);
}

sub approve {
    my $ping = shift;
    $ping->visible(1);
    $ping->junk_status(NOT_JUNK);
}

sub all_text {
    my $this = shift;
    my $text = $this->column('blog_name') || '';
    $text .= "\n" . ($this->column('title') || '');
    $text .= "\n" . ($this->column('source_url') || '');
    $text .= "\n" . ($this->column('excerpt') || '');
    $text;
}

sub to_hash {
    my $ping = shift;
    my $hash = $ping->SUPER::to_hash(@_);
    require MT::Sanitize;
    $hash->{'tbping.excerpt_html'} = MT::Sanitize->sanitize($ping->excerpt || '');
    $hash->{'tbping.created_on_iso'} = sub { MT::Util::ts2iso($ping->blog_id, $ping->created_on) };
    $hash->{'tbping.modified_on_iso'} = sub { MT::Util::ts2iso($ping->blog_id, $ping->modified_on) };

    if (my $parent = $ping->parent) {
        my $parent_hash = $parent->to_hash;
        $hash->{"tbping.$_"} = $parent_hash->{$_} foreach keys %$parent_hash;
    }

    $hash;
}

sub visible {
    my $ping = shift;
    return $ping->SUPER::visible unless @_;
        
    ## Note transitions in visibility in the object, so that
    ## other methods can act appropriately.
    my $was_visible = $ping->SUPER::visible || 0;
    my $is_visible = shift || 0;
        
    my $vis_delta = 0;
    if (!$was_visible && $is_visible) {
        $vis_delta = 1;
    } elsif ($was_visible && !$is_visible) {
        $vis_delta = -1;
    }
    $ping->{__changed}{visibility} = $vis_delta;

    $ping->junk_status(NOT_JUNK) if $is_visible;
    return $ping->SUPER::visible($is_visible);
}

1;
__END__

=head1 NAME

MT::TBPing - Movable Type TrackBack Ping record

=head1 SYNOPSIS

    use MT::TBPing;
    my $ping = MT::TBPing->new;
    $ping->blog_id($tb->blog_id);
    $ping->tb_id($tb->id);
    $ping->title('Foo');
    $ping->excerpt('This is from a TrackBack ping.');
    $ping->source_url('http://www.foo.com/bar');
    $ping->save
        or die $ping->errstr;

=head1 DESCRIPTION

An I<MT::TBPing> object represents a TrackBack ping in the Movable Type system.
It contains all of the metadata about the ping (title, excerpt, URL, etc).

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::TBPing> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

=head1 DATA ACCESS METHODS

The I<MT::TBPing> object holds the following pieces of data. These fields can
be accessed and set using the standard data access methods described in the
I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the ping.

=item * blog_id

The numeric ID of the blog in which the ping is found.

=item * tb_id

The numeric ID of the TrackBack record (I<MT::Trackback> object) to which
the ping was sent.

=item * title

The title of the ping item.

=item * ip

The IP address of the server that sent the ping.

=item * excerpt

The excerpt of the ping item.

=item * source_url

The URL of the item pointed to by the ping.

=item * blog_name

The name of the blog on which the original item was posted.

=item * created_on

The timestamp denoting when the ping record was created, in the format
C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted for the
selected timezone.

=item * modified_on

The timestamp denoting when the ping record was last modified, in the
format C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted
for the selected timezone.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * created_on

=item * tb_id

=item * blog_id

=item * ip

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
