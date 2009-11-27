# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Website;

use strict;
use base qw( MT::Blog );

__PACKAGE__->install_properties({
    class_type => 'website',
    child_classes => ['MT::Page', 'MT::Template', 'MT::Asset',
                      'MT::Folder', 'MT::Notification', 'MT::Log',
                      'MT::ObjectTag', 'MT::Association', 'MT::Comment',
                      'MT::TBPing', 'MT::Trackback', 'MT::TemplateMap',
                      'MT::Touch',],
});

sub class_label {
    return MT->translate("Website");
}

sub class_label_plural {
    MT->translate("Websites");
}

sub create_default_website {
    my $class = shift;
    my ($site_name, $site_theme) = @_;
    $site_name ||= MT->translate("First Website");
    $class = ref $class if ref $class;

    my $website = new $class;
    $website->name($site_name);

    # Enable nofollow options
    $website->nofollow_urls(1);
    $website->follow_auth_links(1);

    # Enable default commenter authentication
    $website->commenter_authenticators(MT->config('DefaultCommenterAuth'));

    # set class type
    $website->class('website');

    $website->page_layout('layout-wtt');
    $website->theme_id($site_theme) if $site_theme;

    $website->save or return $class->error($website->errstr);

    # Apply website theme
    if ( $site_theme ) {
        $website->apply_theme()
            or return $class->error($website->errstr);
    }
    return $website;
}

sub blogs {
    my $class = shift;
    my ($terms, $args) = @_;

    my $blog_class = MT->model('blog');
    if ($terms || $args) {
        $terms ||= {};
        $terms->{class} = 'blog';
        $terms->{parent_id} = $class->id;
        return [ $blog_class->load( $terms, $args ) ];
    } else {
        $class->cache_property('blogs', sub {
            [ $blog_class->load({
                parent_id => $class->id,
                class     => 'blog'
            }) ];
        });
    }
}

sub add_blog {
    my $website = shift;
    my ( $blog ) = @_;
    return unless $blog;

    $blog->parent_id($website->id);
    $blog->save;

    # Apply permission to website administrator if (s)he has manage_member_blogs permission.
    my $author_class = MT->model('author');
    my @website_admins = $author_class->load(
        { type => MT::Author::AUTHOR(), },
        {   join => MT::Permission->join_on(
                'author_id',
                {   permissions => "\%'manage_member_blogs'\%",
                    blog_id     => $website->id,
                },
                { 'like' => { 'permissions' => 1 } }
            )
        }
    );
    if ( @website_admins ) {
        require MT::Association;
        require MT::Role;
        my $user = MT->instance->user;
        if ( $user ) {
            my @roles = MT::Role->load_by_permission("administer_blog");
            my $role;
            foreach my $r ( @roles ) {
                next if $r->permissions =~ m/\'administer_website\'/;
                $role = $r;
                last;
            }
            foreach my $adm (@website_admins) {
                MT::Association->link( $adm => $role => $blog );
            }
        }
    }
}

1;
__END__

=head1 NAME

MT::Website - Movable Type webpage record

=head1 SYNOPSIS

    use MT::Website;
    my $website = MT::Website->load($website_id);
    $website->name('Some new name');
    $website->save
        or die $website->errstr;

=head1 DESCRIPTION

The C<MT::Website> class is a subclass of L<MT::Blog>.

=head2 MT::Website->class_label

Returns the localized descriptive name for this class.

=head2 MT::Website->class_label_plural

Returns the localized, plural descriptive name for this class.

=head1 METHOD

=head2 blogs

Returns all blogs that belongs to the website.

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
