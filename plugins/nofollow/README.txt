

    Nofollow

    Release 2.0

    ______________________________________________________________

    DESCRIPTION


    This plugin automatically asserts a "nofollow" link
    relationship for third-party hyperlinks in comments and
    TrackBacks.

    The plugin alters the behavior of the following Movable Type
    tags:


        <$MTCommentAuthorLink$>

        <$MTCommentBody$>

        <MTPings>


    In each case, Nofollow will intercept the content produced
    by these tags and alter any hyperlinks it finds, adding
    a "nofollow" relation ("rel") attribute to them.

    In the event that a hyperlink already has a "rel" attribute,
    the "nofollow" relation is added to the front of the list.

    For example the following submitted in comment or TrackBack:

        <a href="http://sixapart.com">
        <a href="http://movabletype.org" rel="software">

    would become:

        <a href="http://sixapart.com" rel="nofollow">
        <a href="http://movabletype.org" rel="nofollow software">

    You can also use a new global tag attribute provided with
    this plugin.  The attribute is named "nofollowfy".  You
    can apply it to any Movable Type tag to achieve the same
    effect described above. For example, if you had a plugin
    which displayed your site referrer information, you could
    use it as such:

        <MTReferers nofollowfy="1">

    For more information about this plugin, please visit our
    web site:

    http://www.sixapart.com/pronet/weblog/2005/01/introduction_to.html


    ______________________________________________________________

    REQUIREMENTS

    This plugin is supported on Movable Type 3.2 and later.
    If you are using an older version of Movable Type, we
    strongly suggest upgrading to the latest release.


    ______________________________________________________________

    INSTALLATION

    Nofollow is bundled with Movable Type 3.2 and includes the
    following files:

        plugins/nofollow/LICENSE.txt
        plugins/nofollow/README.txt
        plugins/nofollow/nofollow.pl
        php/plugins/init.nofollow.php

    Note that if you are upgrading from a previous release of this
    plugin, you should remove the old version first to avoid having
    two copies installed that may conflict with one another.

    ______________________________________________________________

    UNINSTALLATION

    To remove this plugin, just remove the directories and files above. 
    Then, rebuild your site so that your links published normally.


    ______________________________________________________________

    LICENSE

    This plugin is released under the Artistic License.
    The text of this license can be found in the LICENSE.txt
    file included with this archive. It is also available here:
    http://www.opensource.org/licenses/artistic-license.php


    ______________________________________________________________

