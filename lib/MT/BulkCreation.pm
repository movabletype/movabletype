# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::BulkCreation;
use strict;
use warnings;
use Carp;

use MT::Util qw(is_valid_email);
use I18N::LangTags qw(is_language_tag);

use MT::Author qw( AUTHOR ACTIVE );

use MT::ErrorHandler;
@MT::BulkCreation::ISA = qw( MT::ErrorHandler );

my %commands = (
    register => 12,
    update => 6,
    delete => 2,
);

sub do_bulk_create {
    my $obj = shift;
    my %param = @_;

    my $line_number = $param{LineNumber};
    my $line = $param{Line};
    my $cb = $param{Callback} || sub { };
    my $app = $param{App};
    
    my ($command, $error) = $obj->_parse_line($line);
    if ($error) {
        require MT::Log;
        $app->log({
            message => MT->translate("Format error at line [_1]: [_2]", $line_number, $error),
            level => MT::Log::ERROR(),
            class => 'system',
            category => 'create_author_bulk'
        });
        $cb->(MT->translate("Format error at line [_1]: [_2]", $line_number, $error));
        return 0;
    }

    my $result = $obj->$command($app, @$line);
    $cb->($result);
    $result;
}


sub _parse_line {
    my $obj = shift;
    my ($lineref) = @_;
    
    $lineref->[0] = lc $lineref->[0];

    if (!exists($commands{$lineref->[0]})) {
        return (undef, MT->translate('Invalid command: [_1]', $lineref->[0]));
    }
    my $num_items = scalar @$lineref;
    if ($commands{$lineref->[0]} != $num_items) {
        return ($lineref->[0], MT->translate("Invalid number of columns for [_1]", $lineref->[0]));
    }
    my $method = '_parse_line_' . $lineref->[0];
    return $obj->$method($lineref);
}

sub _parse_line_common {
    my $obj = shift;
    my ($command, $username, $displayname,
        $email,   $language) = @_;
    
    #username
    if ((length($username) < 1) || (length($username) > 50) || (index($username, '\n') > -1)) {
        return ($command, MT->translate("Invalid user name: [_1]", $username));
    }
    if ($username =~ m/^\s*$/) {
        return ($command, MT->translate("Invalid user name: [_1]", $username));
    }
    
    #displayname
    if (length($displayname) != 0) {
        if ((length($displayname) < 1) || (length($displayname) > 50) || (index($displayname, '\n') > -1)) {
            return ($command, MT->translate("Invalid display name: [_1]", $displayname));
        }
    }
    #email
    if (length($email) > 0) {
        if (!is_valid_email($email)) {
            return ($command, MT->translate("Invalid email address: [_1]", $email));
        }
    }
    
    #language
    if (length($language) > 0) {
        if (!is_language_tag($language)) {
            return ($command, MT->translate("Invalid language: [_1]", $language));
        }
    }
    
    return ($command, undef);
}

sub _parse_line_register {
    my $obj = shift;
    my ($lineref) = @_;
    my @line = @$lineref;
    
    if (length($lineref->[4]) == 0) {
        $lineref->[4] = MT->config->DefaultLanguage || 'en';
    }
    my ($command, $error) = $obj->_parse_line_common(
        $lineref->[0], $lineref->[1], $lineref->[2], 
        $lineref->[3], $lineref->[4]);
    if ($error) {
        return ($command, $error);
    }
    
    #email
    if ((length($lineref->[3]) < 1) || (length($lineref->[3]) > 75) || (index($lineref->[3], '\n') > -1)) {
        return ($command, MT->translate("Invalid email address: [_1]", $lineref->[3]));
    }

    #initial password
    my $authentication_mode = MT->config->AuthenticationModule || 'MT';
    if ($authentication_mode eq 'MT') {
        if ((length($lineref->[5]) < 1) || (length($lineref->[5]) > 60) || (index($lineref->[5], '\n') > -1)) {
            return ($command, MT->translate("Invalid password: [_1]", $lineref->[5]));
        }
        if ($lineref->[5] =~ m/^\s*$/) {
            return ($command, MT->translate("Invalid password: [_1]", $lineref->[5]));
        }
    }

    #password hint
    if ($authentication_mode eq 'MT') {
        if ((length($lineref->[6]) < 1) || (length($lineref->[6]) > 75) || (index($lineref->[6], '\n') > -1)) {
            return ($lineref->[6], MT->translate("Invalid password recovery phrase: [_1]", $lineref->[6]));
        }
        if ($lineref->[6] =~ m/^\s*$/) {
            return ($command, MT->translate("Invalid password recovery phrase: [_1]", $lineref->[6]));
        }
    }

    #weblog name
    $lineref->[7] =~ s/^\s*$//;
    if (length($lineref->[7]) != 0) {
        if ((length($lineref->[7]) < 1) || (length($lineref->[7]) > 255) || (index($lineref->[7], '\n') > -1)) {
            return ($lineref->[0], MT->translate("Invalid weblog name: [_1]", $lineref->[7]));
        }
    }

    #weblog description
    $lineref->[8] =~ s/^\s*$//;
    if (length($lineref->[8]) != 0) {
        if ((length($lineref->[8]) < 1) || (length($lineref->[8]) > 1024)) {
            return ($lineref->[0], MT->translate("Invalid weblog description: [_1]", $lineref->[8]));
        }
    }
    
    #site url and site root
    $lineref->[9] =~ s/^\s*$//;
    $lineref->[10] =~ s/^\s*$//;
    if (length($lineref->[7]) != 0) {
        if (length($lineref->[9]) == 0) {
            return ($lineref->[0], MT->translate("Invalid site url: [_1]", $lineref->[9]));
        }
        if (length($lineref->[10]) == 0) {
            return ($lineref->[0], MT->translate("Invalid site root: [_1]", $lineref->[10]));
        }
    } else {
        $lineref->[9] = '';
        $lineref->[10] = '';
    }
    
    #timezone
    $lineref->[11] =~ s/^\s*$//;
    if (length($lineref->[11]) != 0) {
        if ($lineref->[11] =~ m/^[\+-][0-9]{2}(?:00|30)$/) {
            $lineref->[11] =~ s/^(?:(?:\+|(-))0?([1-9]?[0-9])00)$/$1$2/;
            $lineref->[11] =~ s/^(?:(?:\+|(-))0?([1-9]?[0-9])30)$/$1$2\.5/;
        } else {
            return ($lineref->[0], MT->translate("Invalid timezone: [_1]", $lineref->[11]));
        } 
    } else {
        $lineref->[11] = MT->config->DefaultTimezone || 0;
    }

    return ($lineref->[0], undef);
}

sub _parse_line_update {
    my $obj = shift;
    my ($lineref) = @_;
    my @line = @$lineref;
    
    $lineref->[3] =~ s/^\s*$//;
    $lineref->[4] =~ s/^\s*$//;
    $lineref->[5] =~ s/^\s*$//;

    my ($command, $error) = $obj->_parse_line_common(
        $lineref->[0], $lineref->[1], $lineref->[3],
        $lineref->[4], $lineref->[5]);
    if ($error) {
        return ($command, $error);
    }
    
    #newusername
    $lineref->[2] =~ s/^\s*$//;
    if (length($lineref->[2]) != 0) {
        if ((length($lineref->[2]) < 1) || (length($lineref->[2]) > 50) || (index($lineref->[2], '\n') > -1)) {
            return ($lineref->[0], MT->translate("Invalid new user name: [_1]", $lineref->[2]));
        }
    }
    
    return ($lineref->[0], undef);
}

sub _parse_line_delete {
    my $obj = shift;
    my ($lineref) = @_;
    my @line = @$lineref;

    #keyword
    $lineref->[1] =~ s/^\s*$//;
    if (length($lineref->[1]) != 0) {
        if ((length($lineref->[1]) < 1) || (length($lineref->[1]) > 50) || (index($lineref->[1], '\n') > -1)) {
            return ($lineref->[0], MT->translate("Invalid user name: [_1]", $lineref->[1]));
        }
    }

    return ($lineref->[0], undef);
}

sub register {
    my( $obj, $app ) = @_;
    # Set the known, pre-parsed registration line components.
    my %line;
    @line{qw(
        author
        nickname
        email
        language
        password
        hint
        blog
        description
        site_url
        site_path
        timezone
    )} = @_[3..13];

    my $cfg = $app->config;
    my $author = $obj->_load_author_by_name($line{author});
    if ($author) {
        $app->log({
            message => MT->translate("A user with the same name was found.  Register was not processed: [_1]", $line{author}),
            level => MT::Log::ERROR(),
            class => 'system',
            category => 'create_author_bulk'
        });
        return MT->translate("A user with the same name was found.  Register was not processed: [_1]", $line{author});
    } else {
        my $message = qw( );
        require MT::Author;
        $author = MT::Author->new;
        $author->created_by($app->user->id);
        $author->name($line{author});
        $author->nickname($line{nickname});
        $author->email($line{email});
        $author->preferred_language($line{language}) if $line{language};
        if ($line{password}) {
            $author->set_password($line{password});
        } else {
            $author->password('(none)');
        }
        $author->hint($line{hint});
        $author->status(ACTIVE);
        $author->type(AUTHOR);
        $author->save
            or $app->log({
                    message => MT->translate("User cannot be created: [_1].", $line{author}),
                    level => MT::Log::ERROR(),
                    class => 'system',
                    category => 'create_author_bulk'
               }), return MT->translate("User cannot be created: [_1].", $line{author});
        $app->log({
            message => MT->translate("User '[_1]' has been created.", $line{author}),
            level => MT::Log::INFO(),
            class => 'system',
            category => 'create_author_bulk'
        });
        $author->add_default_roles;
        $message .= MT->translate("User '[_1]' has been created.", $line{author});
        if (($line{blog}) && (length($line{blog}) > 0)) {
            require MT::Blog;
            my $blog = MT::Blog->create_default_blog($line{blog});
            $blog->description($line{description});
            $blog->site_url($line{site_url});
            $blog->site_path($line{site_path});
            $blog->server_offset($line{timezone});
            $blog->language($line{language} || $cfg->DefaultLanguage);
            $blog->save 
                or $app->log({
                        message => MT->translate("Blog for user '[_1]' can not be created.", $line{author}),
                        level => MT::Log::ERROR(),
                        class => 'system',
                        category => 'create_author_bulk'
                   }), 
                   return $message . "\n"
                       . MT->translate("Blog for user '[_1]' can not be created.", $line{author});
            $message .= "\n"
                . MT->translate("Blog '[_1]' for user '[_2]' has been created.", $line{blog}, $line{author});
            require MT::Role;
            require MT::Association;
            my $role = MT::Role->load_by_permission('administer_blog');
            if ($role) {
                MT::Association->link($author => $role => $blog);
            } else {
                my $role_message = 
                    MT->translate("Error assigning weblog administration rights to user '[_1] (ID: [_2])' for weblog '[_3] (ID: [_4])'. No suitable weblog administrator role was found.",
                        $author->name, $author->id, $blog->name, $blog->id);
                $app->log({
                    message => $role_message,
                    level => MT::Log::ERROR(),
                    class => 'system',
                    category => 'new'
                }),
                   return $message . "\n" . $role_message;
            }
        } else {
            if (MT->config->NewUserAutoProvisioning) {
                MT->run_callbacks('NewUserProvisioning', $author);
            }
        }
        $message .= "\n"
            . MT->translate("Permission granted to user '[_1]'", $line{author});
        $app->log({
            message => $message,
            level => MT::Log::INFO(),
            class => 'system',
            category => 'create_author_bulk'
        });

        return $message;
    }
}

sub update {
    my $obj = shift;
    my ($app, @line) = @_;

    my $author = $obj->_load_author_by_name($line[1]);
    require MT::Log;
    if ($author) {
        if ($line[2]) {
            my $new_author = $obj->_load_author_by_name($line[2]);
            if ($new_author) {
                $app->log({
                    message => MT->translate("User '[_1]' already exists. Update was not processed: [_2]", $line[2], $line[1]),
                    level => MT::Log::ERROR(),
                    class => 'system',
                    category => 'create_author_bulk'
                });
                return MT->translate("User '[_1]' already exists. Update was not processed: [_2]", $line[2], $line[1]);
            }
            $author->name($line[2]);
        }
        $author->nickname($line[3]) if (($line[3]) && length $line[3] > 0);
        $author->email($line[4]) if (($line[4]) && length $line[4] > 0);
        $author->preferred_language($line[5]) if (($line[5]) && length $line[5] > 0);
        $author->save
            or $app->log({
                    message => MT->translate("User cannot be updated: [_1].", $line[1]),
                    level => MT::Log::ERROR(),
                    class => 'system',
                    category => 'create_author_bulk'
               }), return MT->translate("User cannot be updated: [_1].", $line[1]);
    } else {
        $app->log({
            message => MT->translate("User '[_1]' not found.  Update was not processed.", $line[1]),
            level => MT::Log::ERROR(),
            class => 'system',
            category => 'create_author_bulk'
        });
        return MT->translate("User '[_1]' not found.  Update was not processed.", $line[1]);
    }
    $app->log({
        message => MT->translate("User '[_1]' has been updated.", $line[1]),
        level => MT::Log::INFO(),
        class => 'system',
        category => 'create_author_bulk'
    });
    return MT->translate("User '[_1]' has been updated.", $line[1]);
}

sub delete {
    my $obj = shift;
    my ($app, @line) = @_;

    my $author = $obj->_load_author_by_name($line[1]);
    require MT::Log;
    if ($author) {
        $author->remove
            or $app->log({
                    message => MT->translate("User '[_1]' was found, but delete was not processed", $line[1]),
                    level => MT::Log::ERROR(),
                    class => 'system',
                    category => 'create_author_bulk'
                }), return MT->translate("User '[_1]' was found, but delete was not processed", $line[1]);
    } else {
        $app->log({
            message => MT->translate("User '[_1]' not found.  Delete was not processed.", $line[1]),
            level => MT::Log::ERROR(),
            class => 'system',
            category => 'create_author_bulk'
        });
        return MT->translate("User '[_1]' not found.  Delete was not processed.", $line[1]);
    }
    $app->log({
        message => MT->translate("User '[_1]' has been deleted.", $line[1]),
        level => MT::Log::INFO(),
        class => 'system',
        category => 'create_author_bulk'
    });
    return MT->translate("User '[_1]' has been deleted.", $line[1]);
}

sub _load_author_by_name {
    # That is, load by username, which is unique for the author.
    my $obj = shift;
    my ($name) = @_;

    require MT::Author;
    my $author_iter = MT::Author->load_iter(
        { type => AUTHOR, name => $name },
        { sort => 'name' });
    my $author;
    while (my $au = $author_iter->()) {
        my $row = $au->column_values;
        if ($row->{name} eq $name) {
            $author = MT::Author->load($au->id);
            last;
        }
    }
    return $author;
}

1;
__END__

=head1 NAME

MT::BulkCreation - Utility package for managing the bulk user create,
update, delete facility.

=head1 DESCRIPTION

This module handles the Bulk User management operations of Movable Type.

=head1 METHODS

=head2 $obj->do_bulk_create(%param)

Parameters for this method:

=over 4

=item * App

The parent I<MT::App> application that is driving the process.

=item * Callback

A coderef of a routine that is used to send progress messages back from
this module. The callback routine is simply given a string containing
a message to relay to the end user.

=item * Line

An array reference of data from current line of the import file being
processed.

=item * LineNumber

The current line number of the file being processed.

=back

The 'Line' parameter is a data line in CSV format from the import file being
processed. This module processes three varieties of input data, all beginning
with an identifier that specifies the type of line being processed. That
first element is one of: register, update, delete.

Based on this command column, the appropriate method is called to parse
the rest of the line and apply the updates to the user table.

=head2 $obj->register($app, @line_data)

Processes a bulk user record of the 'register' type. Records processed
with a 'register' command will create new Movable Type user accounts.
The line is expected to be in CSV format and contains the following columns:

=over 4

=item * register

The literal word "register".

=item * username

The username of the user to create.

=item * display name

The name used when publishing the name of the author.

=item * email

The contact email address for this user.

=item * language

The language to assign to the new user account. Valid choices include: en,
ja, de, es, fr, nl (or if you have other MT localization packs installed,
those language codes would be also valid).

=item * password

A password the user will use to login to Movable Type.

=item * hint

A recovery hint the user can use to reset their password. The user
must know this hint in order to reset their password.

=item * blog name

The name to assign to a weblog that will be created and assigned to this
user.

=item * description

The description to assign to their weblog.

=item * site url

The site URL to assign to their weblog.

=item * site path

The site root path to assign to their weblog.

=item * timezone

The timezone to assign to their weblog.

=back

Note that the weblog fields (blog name, description, site url, site path
and timezone) may be blank if you do not wish to create a personal
weblog for the user being created. However, all columns must be in the
input record.

=head2 $obj->update($app, @line_data)

Processes a bulk user record of the 'update' type. Records processed
with a 'update' command will update existing Movable Type user accounts.
The line is expected to be in CSV format and contains the following columns:

=over 4

=item * update

The literal word "update".

=item * username

The username of the user to update. This must match with an existing
user account.

=item * display name

The new display name to assign to this user.

=item * email

The new contact email address to assign to this user.

=item * language

The new language to assign to the this user. Valid choices include: en,
ja, de, es, it, fr, nl.

=item * password

A new password to assign to this user.

=item * hint

A new recovery hint to assign to this user.

=back

=head2 $obj->delete($app, @line_data)

Processes a bulk user record of the 'delete' type. Records processed
with a 'delete' command will delete existing Movable Type user accounts.
The line is expected to be in CSV format and contains the following columns:

=over 4

=item * delete

The literal word "delete".

=item * username

The username of the user to delete. This must match with an existing
user account.

=back

Note: Deleting Movable Type user accounts is not recommended. We would
advise disabling an account in favor of deleting it.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
