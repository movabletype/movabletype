# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Log;

use strict;
use warnings;
use base qw( MT::Object );
use MT::Util qw( ts2epoch epoch2ts offset_time );

# use constant is slow
sub DEBUG ()    {0}
sub INFO ()     {1}
sub NOTICE ()   {2}
sub WARNING ()  {3}
sub ERROR ()    {4}
sub SECURITY () {5}

use Exporter;
*import = \&Exporter::import;
our @EXPORT_OK = qw( DEBUG INFO NOTICE WARNING ERROR SECURITY );
our %EXPORT_TAGS = ( constants => [@EXPORT_OK] );

use MT::Blog;

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'        => 'integer not null auto_increment',
            'message'   => 'text',
            'ip'        => 'string(50)',
            'blog_id'   => 'integer',
            'author_id' => 'integer',
            'level'     => 'integer',
            'category'  => 'string(255)',
            'metadata'  => 'text',
        },
        indexes => {
            created_on => 1,
            blog_id    => 1,
            level      => 1,
        },
        defaults => {
            blog_id   => 0,
            author_id => 0,
            level     => 1,
        },
        child_of     => 'MT::Blog',
        datasource   => 'log',
        audit        => 1,
        primary_key  => 'id',
        class_column => 'class',
        class_type   => 'system',
    }
);

sub class_label {
    return MT->translate('Log message');
}

sub class_label_plural {
    return MT->translate('Log messages');
}

sub list_props {
    return {
        created_on => {
            auto    => 1,
            label   => 'Date Created',
            order   => 100,
            display => 'force',
            raw     => sub {
                my $prop = shift;
                my ( $obj, $app, $opts ) = @_;
                my $ts   = $obj->created_on;
                my $blog = $opts->{blog};

                ## All Log records are saved with GMT, so do trick here.
                my $epoch = ts2epoch( undef, $ts, 1 )
                    ;    # just get epoch with "no_offset" option
                $epoch = offset_time( $epoch, $blog )
                    ;    # from GMT to Blog( or system ) Timezone
                return epoch2ts( $blog, $epoch, 1 );    # back to timestamp
            },
        },
        message => {
            auto      => 1,
            label     => 'Message',
            order     => 200,
            display   => 'force',
            use_blank => 1,
            html      => sub {
                my $prop = shift;
                my ( $obj, $app ) = @_;
                my $msg = $obj->message;
                my $desc;
                if ( 'MT::Log' eq ref $obj ) {
                    $desc = MT::Util::encode_html( $obj->metadata ) || '';
                }
                else {
                    $desc = $obj->description;
                }
                $desc = $desc->() if ref $desc eq 'CODE';
                $desc = '' unless defined $desc;
                $desc = '' if $msg eq $desc;
                $desc = MT::Util::encode_html($desc);
                $msg  = MT::Util::encode_html($msg);
                my $id = $obj->id;
                return $desc
                    ? qq{
                    <div class="log-message can-select">
                      <a href="#log-detail-$id" class="dropdown-toggle toggle-link icon-left icon-spinner detail-link" data-toggle="collapse" aria-expanded="false" aria-controls="log-detail-$id">
                        $msg
                      </a>
                      <div id="log-detail-$id" class="collapse log-metadata detail">
                        <div class="card card-block bg-light mt-2 p-2">
                          <pre class="pre-scrollable"><code>$desc</code></pre>
                        </div>
                      </div>
                    </div>
                }
                    : qq{
                    <div class="log-message can-select">$msg</div>
                };
            },
        },
        blog_name => {
            base    => '__common.blog_name',
            order   => 300,
            display => 'force',
        },
        by => {
            base        => '__virtual.string',
            label       => 'By',
            view_filter => [],
            order       => 400,
            display     => 'force',
            raw         => sub {
                my $prop = shift;
                my ( $obj, $app ) = shift;
                if ( $obj->author_id ) {
                    if ( my $user
                        = MT->model('author')->load( $obj->author_id ) )
                    {
                        return $user->name;
                    }
                    else {
                        return MT->translate('*User deleted*');
                    }
                }
                return '';
            },
            sort => sub {
                my $prop = shift;
                my ( $terms, $args ) = @_;
                $args->{joins} ||= [];
                push @{ $args->{joins} },
                    MT->model('author')->join_on(
                    undef, undef,
                    {   sort      => 'nickname',
                        condition => { id => \'= log_author_id', },
                        direction => ( $args->{direction} || 'ascend' ),
                        type      => 'left',
                    },
                    );
                $args->{sort} = [];
                return;
            },
        },
        class => {
            label   => 'Class',
            col     => 'class',
            display => 'none',
            base    => '__virtual.single_select',
            sort    => sub {
                my $prop = shift;
                my ( $terms, $args ) = @_;
                $args->{sort} = $prop->col;
                return;
            },
            single_select_options => sub {
                my $prop  = shift;
                my $app   = shift || MT->app;
                my $terms = {};
                if ( my $blog_id = $app->param('blog_id') ) {
                    my $blog = MT->model('blog')->load($blog_id);
                    if ( $blog->is_blog ) {
                        $terms->{blog_id} = $blog->id;
                    }
                    else {
                        my $blogs = $blog->blogs;
                        $terms->{blog_id}
                            = [ map { $_->id } ( $blog, @$blogs ) ];
                    }
                }
                my $iter = MT->model('log')->count_group_by(
                    $terms,
                    {   group    => ['class'],
                        no_class => 1,
                    },
                );
                my @options;
                while ( my ( $count, $class ) = $iter->() ) {
                    my $label = $class;
                    if ( my ($content_type_id)
                        = $class =~ /^content_data_([0-9]+)$/ )
                    {
                        my $content_type = MT->model('content_type')
                            ->load($content_type_id);
                        my $site
                            = $content_type ? $content_type->blog : undef;
                        my $site_name
                            = $site
                            ? defined $site->name
                                ? $site->name
                                : 'blog_id: ' . $site->id
                            : MT->translate('*Site/Child Site deleted*');
                        $label = $content_type->name . " ($site_name)"
                            if $content_type;
                    }
                    push @options,
                        {
                          label => $label
                        ? MT->translate($label)
                        : MT->translate('none'),
                        value => $class ? $class : '',
                        };
                }
                return \@options;
            },
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                delete $db_args->{no_class};
                if ( $args->{value} ) {
                    $prop->super(@_);
                }
                else {
                    $db_terms->{class} = \' is null';
                }
            },
        },

        #category => {
        #    label                 => 'Category',
        #    col                   => 'category',
        #    base                  => '__virtual.single_select',
        #    single_select_options => sub {
        #        my $iter = MT->model('log')->count_group_by(
        #            undef,
        #            {   group    => ['category'],
        #                no_class => 1,
        #            },
        #        );
        #        my @options;
        #        while ( my ( $count, $cat ) = $iter->() ) {
        #            next unless $cat;
        #            my $label = $cat;
        #            $label =~ s/_/ /g;
        #            push @options,
        #                {
        #                label => MT->translate($cat),
        #                value => $cat
        #                };
        #        }
        #        return \@options;
        #    },
        #},
        level => {
            label   => 'Level',
            base    => '__virtual.single_select',
            display => 'none',
            col     => 'level',
            sort    => sub {
                my $prop = shift;
                my ( $terms, $args ) = @_;
                $args->{sort} = $prop->col;
                return;
            },
            terms => sub {
                my $prop = shift;
                my ($args) = @_;
                my $val = $prop->normalized_value(@_);
                my @types = split(',', $val);
                return { level => \@types };
            },
            single_select_options => [
                {   label => MT->translate('Security'),
                    value => SECURITY(),
                    text  => 'security'
                },
                {   label => MT->translate('Error'),
                    value => ERROR(),
                    text  => 'error'
                },
                {   label => MT->translate('Warning'),
                    value => WARNING(),
                    text  => 'warning'
                },
                {   label => MT->translate('Notice'),
                    value => NOTICE(),
                    text  => 'notice'
                },
                {   label => MT->translate('Information'),
                    value => INFO(),
                    text  => 'info'
                },
                {   label => MT->translate('Debug'),
                    value => DEBUG(),
                    text  => 'debug'
                },
                {   label => MT->translate('Security or error'),
                    value => join(',', (SECURITY(), ERROR())),
                    text  => 'sercurity_or_error',
                },
                {   label => MT->translate('Security/error/warning'),
                    value => join(',', (SECURITY(), ERROR(), WARNING())),
                    text  => 'security_or_error_or_warning',
                },
                {   label => MT->translate('Not debug'),
                    value => join(',', (SECURITY(), ERROR(), WARNING(), NOTICE(), INFO())),
                    text  => 'not_debug',
                },
                {   label => MT->translate('Debug/error'),
                    value => join(',', (DEBUG(), ERROR())),
                    text  => 'debug_or_error',
                },
            ],
        },
        metadata => {
            auto      => 1,
            label     => 'Metadata',
            use_blank => 1,
            display   => 'none',
        },
        modified_on => {
            base    => '__virtual.modified_on',
            display => 'none',
        },
        author_name => {
            base    => '__virtual.author_name',
            display => 'none',
        },
        ip => {
            auto      => 1,
            label     => 'IP Address',
            display   => 'default',
            use_blank => 1,
        },
        id => {
            base            => '__virtual.id',
            label_via_param => sub {
                my $prop = shift;
                my ( $app, $val ) = @_;
                return MT->translate( 'Showing only ID: [_1]', $val );
            },
            display         => 'none',
            filter_editable => 0,
        },
        blog_id => {
            auto            => 1,
            col             => 'blog_id',
            display         => 'none',
            filter_editable => 0,
        },
        author_id => {
            auto            => 1,
            col             => 'author_id',
            display         => 'none',
            filter_editable => 0,
        },
        content => {
            base    => '__virtual.content',
            fields  => [qw( message ip )],
            display => 'none',
        },
    };
}

sub system_filters {
    return {
        current_website => {
            label => 'Logs on This Site',
            items => [ { type => 'current_context' } ],
            order => 100,
            view  => 'website',
        },
        show_only_errors => {
            label => 'Show only errors',
            items => [ { type => 'level', args => { value => ERROR() } }, ],
            order => 200,
        },
    };
}

sub init {
    my $log = shift;
    $log->SUPER::init(@_);
    my @ts = gmtime(time);
    my $ts = sprintf '%04d%02d%02d%02d%02d%02d',
        $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ];
    $log->created_on($ts);
    $log->modified_on($ts);
    $log;
}

sub description {
    my $log = shift;
    my $msg = '';
    if ( $log->message =~ m/\n/ ) {
        $msg = $log->message;
    }
    if ( defined $log->metadata && ( $log->metadata ne '' ) ) {
        $msg .= "\n\n" if $msg ne '';
        $msg .= $log->metadata;
    }
    if ( $msg ne '' ) {
        require MT::Util;
        $msg = MT::Util::encode_html($msg);
    }
    $msg;
}

sub metadata_object {
    my $log   = shift;
    my $class = $log->metadata_class;
    return undef unless $class;
    my $id = int( $log->metadata || 0 );
    return undef unless $id;
    eval "require $class;" or return undef;
    $class->load($id);
}

sub metadata_class {
    my $log = shift;
    my $pkg = ref $log || $log;
    if ( $pkg =~ m/::Log::/ ) {
        $pkg =~ s/::Log::/::/;
        $pkg;
    }
    else {
        undef;
    }
}

sub to_hash {
    my $log  = shift;
    my $hash = $log->SUPER::to_hash(@_);
    $hash->{ "log.level_" . $log->level }       = 1 if $log->level;
    $hash->{ "log.class_" . $log->class }       = 1 if $log->class;
    $hash->{ "log.category_" . $log->category } = 1 if $log->category;
    $hash->{'log.description'} = $log->description;
    if ( my $obj = $log->metadata_object ) {
        my $obj_hash = $obj->to_hash;
        $hash->{"log.$_"} = $obj_hash->{$_} foreach keys %$obj_hash;
    }
    if ( $log->author_id ) {
        require MT::Author;
        if ( my $auth = MT::Author->load( $log->author_id ) ) {

            # prefix these hash keys with "log" since this
            # log record may also refer to an entry/comment that
            # has an associated author/commenter record and that
            # would potentially clash with the log author record.
            # ie, author 1 deletes entry written by author 2
            # or author 1 deletes comment posted by commenter author 3
            my $auth_hash = $auth->to_hash;
            $hash->{"log.$_"} = $auth_hash->{$_} foreach keys %$auth_hash;
        }
    }
    return $hash;
}

package MT::Log::Page;

our @ISA = qw( MT::Log );

__PACKAGE__->install_properties( { class_type => 'page', } );

sub class_label { MT->translate("Pages") }

sub description {
    my $log = shift;
    my $msg;
    if ( my $entry = $log->metadata_object ) {
        $msg = $entry->to_hash->{'entry.text_html'};
    }
    else {
        $msg = MT->translate( 'Page # [_1] not found.', $log->metadata );
    }

    $msg;
}

package MT::Log::Entry;

our @ISA = qw( MT::Log );

__PACKAGE__->install_properties( { class_type => 'entry', } );

sub class_label { MT->translate("Entries") }

sub description {
    my $log = shift;
    my $msg;
    if ( my $entry = $log->metadata_object ) {
        $msg = $entry->to_hash->{'entry.text_html'};
    }
    else {
        $msg = MT->translate( 'Entry # [_1] not found.', $log->metadata );
    }

    $msg;
}

package MT::Log::Comment;

our @ISA = qw( MT::Log );

__PACKAGE__->install_properties( { class_type => 'comment', } );

sub class_label { MT->translate("Comments") }

sub description {
    my $log = shift;
    my $cmt = $log->metadata_object;
    my $msg;
    if ($cmt) {
        $msg = $cmt->to_hash->{'comment.text_html'};
    }
    else {
        $msg = MT->translate( "Comment # [_1] not found.", $log->metadata );
    }
    $msg;
}

package MT::Log::TBPing;

our @ISA = qw( MT::Log );

__PACKAGE__->install_properties( { class_type => 'ping', } );

sub class_label { MT->translate("TrackBacks") }

sub description {
    my $log  = shift;
    my $id   = int( $log->metadata || 0 );
    my $ping = $log->metadata_object;
    my $msg;
    if ($ping) {
        $msg = $ping->to_hash->{'tbping.excerpt_html'};
    }
    elsif ($id) {
        $msg = MT->translate( "TrackBack # [_1] not found.", $id );
    }
    $msg;
}

# Hint for translate
# trans('blog');
# trans('website');
# trans('search');
# trans('author');
# trans('ping');
# trans('theme');
# trans('folder');
# trans('plugin');
# trans('page');

1;
__END__

=head1 NAME

MT::Log - Movable Type activity log record

=head1 SYNOPSIS

    use MT::Log;
    my $log = MT::Log->new;
    $log->message('This is a message in the activity log.');
    $log->save
        or die $log->errstr;

Extended log example:

    use MT::Log;
    my $log = MT::Log->new;
    $log->message("This is a debug message");
    $log->level(MT::Log::DEBUG());
    $log->save or die $log->errstr;

You can also log directly with the MT package:

    MT->log({
        message => "A new entry has been posted.",
        metadata => $entry->id,
        class => 'entry'
    });

=head1 DESCRIPTION

An I<MT::Log> object represents a record in the Movable Type activity log.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Log> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

=head1 SUBCLASSING

I<MT::Log> may be subclassed for different types of log records. The MT
Activity Feeds make use of this feature.

    # MyCustomLog.pm

    package MyCustomLog;

    use base 'MT::Log';

    sub description {
        # returns html presentation of log message; used in activity
        # log view and activity feeds...
    }

    1;

If you do define your own subclass, you will want to register it when
your plugin loads. The key/value pairs assigned to the plugin's "log_classes"
element should be unique enough to not conflict with other plugins.

    # Plugin file

    MT->add_plugin({
        name => "My custom plugin",
        log_classes => { customlog => "MyCustomLog" }
    });

    1;

=head1 METHODS

=head2 CLASS->new()

Creates a new log object.

=head2 $log->init()

Initializes the created_on and modified_on properties of the object
to the current time (these are overwritten if an object is being loaded
from the database).

=head2 CLASS->class_label

Returns a localized string identifying the kind of log record the class is
for.

=head2 MT::Log->class_label_plural

Returns the localized, plural descriptive name for this class.

=head2 MT::Log->list_props

Returns the list_properties registry of this class.

=head2 MT::Log->system_filters

Returns the system_filters registry of this class.

=head2 $log->description

Provides an extended view of the log data; this may contain HTML.

=head2 $log->metadata_class()

Returns a Perl package name for the metadata object related to the
log record.

=head2 $log->metadata_object

The base I<MT::Log> metadata_object method will return a MT data object that
is related to this log object in the event that:

=over 4

=item 1. The metadata column is populated with a number.

=item 2. The class column has an identifier that maps to a registered
I<MT::Log> subclass.

=item 3. The class identified for the log record is provided by the C<metadata_class> method.

=back

If these conditions are met, this method will attempt to load a record using
the package name provided by the C<metadata_class> method with the id given in
the metadata column.

=head2 MT::Log->add_class($identifier => $package_name)

Registers a I<MT::Log> subclass with an identifier that is stored in the
'class' column of log records.

=head2 $log->set_values(\%values)

Overrides the I<MT::Object> set_values method and reblesses the object
with the appropriate I<MT::Log> subclass based on the identifier in
the 'class' column.

=head2 $log->to_hash()

Returns a hashref of data that represents the data held by the log
object and any associated metadata_object that it points to.

=head1 DATA ACCESS METHODS

The I<MT::Log> object holds the following pieces of data. These fields can
be accessed and set using the standard data access methods described in the
I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the log record.

=item * message

The log entry.

=item * blog_id

For log messages that occurred within the context of a blog, the
blog's id is stored in this column.

=item * author_id

For log messages that were created from the action of a user, their
author id is recorded in this column.

=item * class

Optional. An identifier that relates to a Perl package name that is a
valid I<MT::Log> descendant class (or relates to I<MT::Log> itself).

=item * category

Optional. A field to further categorize the message being logged. Being
an indexed column, it is possible to filter on this column when selecting
log records.

=item * level

Optional. A number that defines the level or priority of the log message. This
column may be one of the following values (shown below are the package
constants for each level followed by their numeric equivalent).

=over 4

=item * DEBUG / 0

=item * INFO / 1

=item * NOTICE / 2

=item * WARNING / 3

=item * ERROR / 4

=item * SECURITY / 5

=back

The default value for level is 1 (INFO).

=item * metadata

A storage field for additional information about this particular log
message. Different log classes utilize this field in different ways.

=item * ip

The IP address related with the message; this is useful, for example, when
the message pertains to a failed login, to determine the IP address of the
user who attempted to log in.

=item * created_on

The timestamp denoting when the log record was created, in the format
C<YYYYMMDDHHMMSS>. This timestamp is always in GMT.

=item * modified_on

The timestamp denoting when the log record was last modified, in the format
C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted for the
selected timezone.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * created_on

=item * blog_id

=item * level

=item * class

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
