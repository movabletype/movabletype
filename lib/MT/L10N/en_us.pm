# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::L10N::en_us;    # American English

use strict;
use warnings;
use utf8;
use MT::L10N;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N );

sub ascii_only { ( ( ref $_[0] ) || $_[0] ) eq __PACKAGE__ }

%Lexicon = (
    '__STRING_FILTER_EQUAL'      => 'is',
    '__INTEGER_FILTER_EQUAL'     => 'is',
    '__INTEGER_FILTER_NOT_EQUAL' => 'is not',
    '__DATE_FILTER_FUTURE'       => 'past',
    '__FILTER_DATE_ORIGIN'       => '[_1]',
    '_FILTER_DATE_DAYS'          => '[_1] days',
    '__SELECT_FILTER_VERB'       => 'is',
    '__TIME_FILTER_HOURS'        => 'is within the last',

    'AUTO DETECT'              => 'Auto-detect',
    '_USER_ENABLE'             => 'Enable',
    '_USER_DISABLE'            => 'Disable',
    '_USER_ENABLED'            => 'Enabled',
    '_USER_DISABLED'           => 'Disabled',
    '_USER_PENDING'            => 'Pending',
    '_USER_STATUS_CAPTION'     => 'Status',
    '_external_link_target'    => '_blank',
    '_BLOG_CONFIG_MODE_BASIC'  => 'Basic Mode',
    '_BLOG_CONFIG_MODE_DETAIL' => 'Detailed Mode',
    '_SEARCH_SIDEBAR'          => 'Search',
    '_REVISION_DATE_'          => 'Date',

    '_ERROR_CONFIG_FILE' =>
        'Your Movable Type configuration file is missing or cannot be read properly. Please see the <a href="javascript:void(0)">Installation and Configuration</a> section of the Movable Type manual for more information.',
    '_ERROR_DATABASE_CONNECTION' =>
        'Your database settings are either invalid or not present in your Movable Type configuration file. Please see the <a href="javascript:void(0)">Installation and Configuration</a> section of the Movable Type manual for more information.',
    '_ERROR_CGI_PATH' =>
        'Your CGIPath configuration setting is either invalid or not present in your Movable Type configuration file. Please see the <a href="javascript:void(0)">Installation and Configuration</a> section of the Movable Type manual for more information.',
    '_USAGE_REBUILD' =>
        '<a href="javascript:void(0)" onclick="doRebuild()">REBUILD</a> to see those changes reflected on your public site.',
    '_USAGE_VIEW_LOG' =>
        'Check the <a href="[_1]">Activity Log</a> for the error.',

    '_USAGE_FORGOT_PASSWORD_1' =>
        'You requested recovery of your Movable Type password. Your password has been changed in the system; here is the new password:',
    '_USAGE_FORGOT_PASSWORD_2' =>
        'You should be able to log in to Movable Type using this new password from the URL below. Once you have logged in, you should change your password to something more memorable.',

    '_BACKUP_TEMPDIR_WARNING' =>
        'Requested data has been exported successfully in the [_1] directory.  Make sure that you download and <strong>then delete</strong> files listed above from [_1] by clicking each link or with the help of an FTP client.',
    '_BACKUP_DOWNLOAD_MESSAGE' =>
        'Downloading of the exported file will start automatically in a few seconds.  If for some reason it does not, click <a href="javascript:(void)" onclick="submit_form()">here</a> to start downloading manually.  Please note that you can download the exported file only once for a session.',
    '_USAGE_BOOKMARKLET_1' =>
        'Setting up QuickPost to post to Movable Type allows you to perform one-click posting and publishing without ever entering through the main Movable Type interface.',
    '_USAGE_BOOKMARKLET_2' =>
        'Movable Type\'s QuickPost structure allows you to customize the layout and fields on your QuickPost page. For example, you may wish to add the ability to add excerpts through the QuickPost window. By default, a QuickPost window will always have: a pulldown menu for the weblog to post to; a pulldown menu to select the Post Status (Draft or Publish) of the new entry; a text entry box for the Title of the entry; and a text entry box for the entry body.',
    '_USAGE_BOOKMARKLET_3' =>
        'To install the Movable Type QuickPost bookmark, drag the following link to your browser\'s menu or Favorites toolbar:',
    '_USAGE_BOOKMARKLET_4' =>
        'After installing QuickPost, you can post from anywhere on the web. When viewing a page that you want to post about, click the "QuickPost" QuickPost to open a popup window with a special Movable Type editing window. From that window you can select a weblog to post the entry to, then enter you post, and publish.',
    '_USAGE_BOOKMARKLET_5' =>
        'Alternatively, if you are running Internet Explorer on Windows, you can install a "QuickPost" option into the Windows right-click menu. Click on the link below and accept the browser prompt to "Open" the file. Then quit and restart your browser to add the link to the right-click menu.',
    '_USAGE_ARCHIVE_MAPS' =>
        'This advanced feature allows you to map any archive template to multiple archive types. For example, you may want to create two different views of your monthly archives: one in which the entries for a particular month are presented as a list, and the other representing the entries in a calendar view of that month.',
    '_USAGE_ARCHIVING_1' =>
        'Select the frequencies/types of archiving that you would like on your site. For each type of archiving that you choose, you have the option of assigning multiple Archive Templates to be applied to that particular type. For example, you might wish to create two different views of your monthly archives: one a page containing each of the entries for a particular month, and the other a calendar view of that month.',
    '_USAGE_ARCHIVING_2' =>
        'When you associate multiple templates with a particular archive type--or even when you associate only one--you can customize the output path for the archive files using Archive File Templates.',
    '_USAGE_ARCHIVING_3' =>
        'Select the archive type to which you would like to add a new archive template. Then select the template to associate with that archive type.',

    '_USAGE_BANLIST' =>
        'Below is the list of IP addresses who you have banned from commenting on your site or from sending TrackBack pings to your site. To add a new IP address, enter the address in the form below. To delete a banned IP address, check the delete box in the table below, and press the DELETE button.',

    '_USAGE_PREFS' =>
        'This screen allows you to set a variety of optional settings concerning your blog, your archives, your comments, and your publicity &amp; notification settings. When you create a new blog, these values will be set to reasonable defaults.',

    '_USAGE_FEEDBACK_PREFS' =>
        'This screen allows you to configure the ways that readers can contribute feedback to your blog.',

    '_USAGE_PROFILE' =>
        'Edit your user profile here. If you change your username or your password, your login credentials will be automatically updated. In other words, you will not need to re-login.',
    '_GENL_USAGE_PROFILE' =>
        'Edit the user\'s profile here. If you change the username or the password, the user\'s login credentials will be automatically updated. In other words, they will not need to re-login.',
    '_USAGE_GROUP_PROFILE' =>
        'This screen allows you to edit the group\'s profile.',
    '_USAGE_PASSWORD_RESET' =>
        'You can initiate password recovery on behalf of this user. If you choose to do so, an email will be sent to directly to <strong>[_1]</strong> with a randomly generated new password.',
    '_WARNING_PASSWORD_RESET_SINGLE' =>
        'You are about to reset the password for "[_1]". A new password will be randomly generated and sent directly to their email address ([_2]).  Do you wish to continue?',
    '_WARNING_PASSWORD_RESET_MULTI' =>
        'You are about to send email(s) to allow the selected user(s) to reset their passwords.  Do you wish to continue?',
    '_USAGE_NEW_AUTHOR' =>
        'From this screen you can create a new user in the system.',
    '_USAGE_NEW_GROUP' =>
        'From this screen you can create a new group in the system.',
    '_USAGE_ROLES' =>
        'From this screen you can view the roles you have for your weblogs, and create roles. You can see the details for the different roles by clicking on their names.',
    '_USAGE_ROLE_PROFILE' =>
        'From this screen you can define a role and its permissions.',
    '_USAGE_ASSOCIATIONS' =>
        'From this screen you can view permissions and create permissions.',

    '_USAGE_CATEGORIES' =>
        'Use categories to group your entries for easier reference, archiving and blog display. You can assign a category to a particular entry when creating or editing entries. To edit an existing category, click the category\'s title. To create a subcategory click the corresponding "Create" button. To move a category, click the corresponding "Move" button.',
    '_USAGE_CATEGORY_PING_URL' =>
        'This is the URL that others will use to send TrackBacks to your weblog. If you wish for anyone to send TrackBacks to your weblog when they have an entry specific to this category, publish this URL publicly. If you choose to only allow a select group of individuals to TrackBack, send this URL to them privately. To include a list of incoming TrackBacks in your Main Index Template, check the documentation for template tags related to TrackBacks.',

    '_USAGE_TAGS' =>
        'Use tags to group your entries for easier reference and blog display.',

    '_USAGE_COMMENT' =>
        'Edit the selected comment. Press SAVE when you are finished. You will need to rebuild for these changes to take effect.',

    '_USAGE_PERMISSIONS_1' =>
        'You are editing the permissions of <b>[_1]</b>. Below you will find a list of blogs to which you have user-editing access; for each blog in the list, assign permissions to <b>[_1]</b> by checking the boxes for the access permissions you wish to grant.',
    '_USAGE_PERMISSIONS_2' =>
        'To edit permissions for a different user, select a new user from the pull-down menu, then press EDIT.',
    '_USAGE_PERMISSIONS_3' =>
        'You have two ways to edit users and grant/revoke access privileges. For quick access, select a user from the menu below and select edit. Alternatively, you may browse the complete list of users and, from there, select a person to edit or delete.',
    '_USAGE_PERMISSIONS_4' =>
        'Each blog may have multiple users. To add a user, enter the user\'s information in the forms below. Next, select the blogs on which the user will have some sort of privileges.  Once you press SAVE and the user is in the system, you can edit the user\'s privileges.',

    '_USAGE_PLACEMENTS' =>
        'Use the editing tools below to manage the secondary categories to which this entry is assigned. The list to the left consists of the categories to which this entry is not yet assigned as either a primary or secondary category; the list to the right consists of the secondary categories to which this entry is assigned.',

    '_USAGE_ENTRYPREFS' =>
        'Select the set of fields to be displayed on the entry editor.',

    '_USAGE_IMPORT' =>
        'You can import entries for your weblog from a file in the <code>import</code> directory where Movable Type is installed, or uploaded by following forms. Entries can be imported from other Movable Type installations or other applications.',
    '_USAGE_EXPORT_1' =>
        'Export the entries, comments and TrackBacks of a [_1]. An export is not considered a <em>complete</em> backup of a [_1].',
    '_USAGE_EXPORT_2' =>
        'To export your entries, click on the link below ("Export Entries From [_1]"). To save the exported data to a file, you can hold down the <code>option</code> key on the Macintosh, or the <code>Shift</code> key on a PC, while clicking on the link. Alternatively, you can select all of the data, then copy it into another document. (<a href="javascript:void(0)" onclick="openManual(\'importing\', \'export_ie\');return false;">Exporting from Internet Explorer?</a>)',
    '_USAGE_EXPORT_3' =>
        'Clicking the link below will export all of your current weblog entries to the Tangent server. This is generally a one-time push of your entries, to be done after you have installed the Tangent add-on for Movable Type, but conceivably it could be executed whenever you wish.',

    '_NO_SUPERUSER_DISABLE' =>
        'Because you are a system administrator on the Movable Type system, you cannot disable yourself.',

    '_USAGE_AUTHORS' =>
        'This is a list of all of the users in the Movable Type system. You can edit a user\'s profile by clicking on his/her name.',
    '_USAGE_AUTHORS_1' =>
        'This is a list of all of the users in the Movable Type system. You can edit a user\'s profile by clicking on his/her name. You can create, edit and delete user records by using CSV-based command file.',
    '_USAGE_AUTHORS_LDAP' =>
        'This is a list of all of the users in the Movable Type system. You can edit a user\'s profile by clicking on his/her name. You can disable users by checking the checkbox next to their name, then pressing DISABLE. By doing this, the user will not be able to login to Movable Type.',
    '_USAGE_AUTHORS_2' =>
        'You can create, edit and delete users in bulk by uploading a CSV-formatted file containing those commands and relevant data.',

    '_USAGE_GROUPS' =>
        'Below is a list of all groups in the Movable Type system. You can enable or disable a group by checking the checkbox next to its name, then pressing either the Enable or Disable button. You can edit a group by clicking on its name.',
    '_USAGE_GROUPS_USER' =>
        'Below is a list of the groups in which the user is a member. You can remove the user from a group by checking the checkbox next to that group and clicking REMOVE.',
    '_USAGE_GROUPS_LDAP' =>
        'Below is a list of all groups in the Movable Type system. You can enable or disable a group by checking the checkbox next to its name, then pressing either the Enable or Disable button.',
    '_USAGE_GROUPS_USER_LDAP' =>
        'Below is a list of the groups in which the user is a member.',

    '_USAGE_PLUGINS' =>
        'This is a list of all plugins currently registered with Movable Type.',

    '_USAGE_LIST_POWER' =>
        'Here is the list of entries for [_1] in batch-editing mode. In the form below, you may change any of the values for any of the entries displayed; after making the desired modifications, press the SAVE button. The standard List &amp; Edit Entries controls (filters, paging) work in batch mode in the manner to which you are accustomed.',

    '_USAGE_ENTRY_LIST_BLOG' =>
        'Here is the list of entries for [_1] which you can filter, manage and edit.',
    '_USAGE_ENTRY_LIST_OVERVIEW' =>
        'Here is the list of entries for all weblogs which you can filter, manage and edit.',

    '_USAGE_COMMENTERS_LIST' =>
        'Here is the list of all authenicated commenters to [_1]. Below you may flag any commenter as trusted or banned, or get more information.',

    '_USAGE_PING_LIST_BLOG' =>
        'Here is the list of TrackBacks for [_1]  which you can filter, manage and edit.',
    '_USAGE_PING_LIST_OVERVIEW' =>
        'Here is the list of TrackBacks for all weblogs which you can filter, manage and edit.',
    '_USAGE_PING_LIST_ALL_WEBLOGS' =>
        'Here is the list of TrackBack pings for all weblogs  which you can filter, manage and edit.',

    '_USAGE_NOTIFICATIONS' =>
        'Here is the list of users who wish to be notified when you publish to your site. To add a new user, enter their email address in the form below. The URL field is optional. To delete a user, check the delete box in the table below and press the DELETE button.',

    '_USAGE_SEARCH' =>
        'You can use the Search &amp; Replace tool to find and optionally replace text or data found in many item listings within Movable Type. IMPORTANT: be careful when doing a replace, because there is <b>no undo</b>.',

    '_USAGE_UPLOAD' =>
        'You can upload the file to a subdirectory in the selected path. The subdirectory will be created if it does not exist.',

    '_THROTTLED_COMMENT' =>
        'Too many comments have been submitted from you in a short period of time.  Please try again in a short while.',

    '_INDEX_INTRO' =>
        '<p>If you are installing Movable Type, you may want to review the <a href="https://www.sixapart.com/movabletype/docs/mtinstall.html">installation instructions</a> and view the <a rel="nofollow" href="mt-check.cgi">Movable Type System Check</a> to make sure that your system has what it needs.</p>',
    '_LOG_TABLE_BY'         => 'By',
    '_REBUILD_PUBLISH'      => 'Publish',
    '_DATE_FROM'            => 'From',
    '_DATE_TO'              => 'To',
    '_TIME_FROM'            => 'From',
    '_TIME_TO'              => 'To',
    '_SHORT_MAY'            => 'May',
    '_MTCOM_URL'            => 'https://www.movabletype.com/',
    '_PLUGIN_DIRECTORY_URL' => 'https://plugins.movabletype.org/',
    '_THEME_DIRECTORY_URL'  => 'https://plugins.movabletype.org/',
    '_CATEGORY_BASENAME'    => 'Basename',

    '_AUTO'                => 1,
    'DAILY_ADV'            => 'Daily',
    'WEEKLY_ADV'           => 'Weekly',
    'MONTHLY_ADV'          => 'Monthly',
    'YEARLY_ADV'           => 'Yearly',
    'INDIVIDUAL_ADV'       => 'Entry',
    'PAGE_ADV'             => 'Page',
    'AUTHOR_ADV'           => 'Author',
    'AUTHOR-YEARLY_ADV'    => 'Author Yearly',
    'AUTHOR-MONTHLY_ADV'   => 'Author Monthly',
    'AUTHOR-WEEKLY_ADV'    => 'Author Weekly',
    'AUTHOR-DAILY_ADV'     => 'Author Daily',
    'CATEGORY_ADV'         => 'Category',
    'CATEGORY-YEARLY_ADV'  => 'Category Yearly',
    'CATEGORY-MONTHLY_ADV' => 'Category Monthly',
    'CATEGORY-WEEKLY_ADV'  => 'Category Weekly',
    'CATEGORY-DAILY_ADV'   => 'Category Daily',

    'CONTENTTYPE_ADV'                  => 'ContentType',
    'CONTENTTYPE-DAILY_ADV'            => 'ContentType Daily',
    'CONTENTTYPE-WEEKLY_ADV'           => 'ContentType Weekly',
    'CONTENTTYPE-MONTHLY_ADV'          => 'ContentType Monthly',
    'CONTENTTYPE-YEARLY_ADV'           => 'ContentType Yearly',
    'CONTENTTYPE-CATEGORY_ADV'         => 'ContentType Category',
    'CONTENTTYPE-CATEGORY-DAILY_ADV'   => 'ContentType Category Daily',
    'CONTENTTYPE-CATEGORY-WEEKLY_ADV'  => 'ContentType Category Weekly',
    'CONTENTTYPE-CATEGORY-MONTHLY_ADV' => 'ContentType Category Monthly',
    'CONTENTTYPE-CATEGORY-YEARLY_ADV'  => 'ContentType Category Yearly',
    'CONTENTTYPE-AUTHOR_ADV'           => 'ContentType Author',
    'CONTENTTYPE-AUTHOR-DAILY_ADV'     => 'ContentType Author Daily',
    'CONTENTTYPE-AUTHOR-WEEKLY_ADV'    => 'ContentType Author Weekly',
    'CONTENTTYPE-AUTHOR-MONTHLY_ADV'   => 'ContentType Author Monthly',
    'CONTENTTYPE-AUTHOR-YEARLY_ADV'    => 'ContentType Author Yearly',

    'UTC+11' => 'UTC+11 (East Australian Daylight Savings Time)',
    'UTC+10' => 'UTC+10 (East Australian Standard Time)',

    '_POWERED_BY' =>
        'Powered by <a href="https://www.movabletype.org/"><$MTProductName$></a>',
    '_DISPLAY_OPTIONS_SHOW' => 'Show',
    '_WARNING_DELETE_USER_EUM' =>
        'Deleting a user is an irrevocable action which creates orphans of the user\'s entries or content data. If you wish to retire a user or remove their access to the system, disabling their account is the recommended course of action. Are you sure you want to delete the selected user(s)? They will be able to re-create themselves if selected user(s) still exist in your external directory.',
    '_WARNING_DELETE_USER' =>
        'Deleting a user is an irrevocable action which creates orphans of the user\'s entries or content data. If you wish to retire a user or remove their access to the system, disabling their account is the recommended course of action. Are you sure you want to delete the selected user(s)?',
    '_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' =>
        'This action will restore the templates in the selected blog(s) to theme default settings. Are you sure you want to refresh templates in the selected blog(s)?',

    '_WEBMASTER_MT4'           => 'Webmaster',
    '_THEME_AUTHOR'            => 'Author',
    '_FILTER_FUTURE'           => 'Future',
    '_LOCALE_CALENDAR_HEADER_' => "'S', 'M', 'T', 'W', 'T', 'F', 'S'",
    '__AUTHOR_STATUS'          => 'Status',
    '__BLOG_COUNT'             => 'Blog Count',
    '__ENTRY_COUNT'            => 'Entry Count',
    '__PAGE_COUNT'             => 'Page Count',
    '__ASSET_COUNT'            => 'Asset Count',
    '__COMMENT_COUNT'          => 'Comment Count',
    '__PING_COUNT'             => 'Trackback Count',
    '__ROLE_STATUS'            => 'Status',
    '__ROLE_ACTIVE'            => 'In Use',
    '__ROLE_INACTIVE'          => 'Not in Use',
    '__COMMENTER_APPROVED'     => 'Approved',
    '__ANONYMOUS_COMMENTER'    => 'Anonymous',
    '__WEBSITE_BLOG_NAME'      => 'Website/Blog Name',
    '__SSL_CERT_UPDATE'        => 'update',
    '__SSL_CERT_INSTALL'       => 'install',
    '_ABOUT_PAGE_BODY' =>
        '<p>This is an example "about" page. (Typically, an "about" page features a summary about an individual or corporation.)</p><p>If the <code>@ABOUT_PAGE</code> tag is used on a web page, the "about" page will be added to the navigation list in both the header and footer.</p>',
    '_SAMPLE_PAGE_BODY' =>
        '<p>This is an example web page.</p><p>If the <code>@ADD_TO_SITE_NAV</code> tag is used on a web page, that page will be added to the navigation list in both the header and footer.</p>',
    '__CF_REQUIRED_VALUE__' => q{Value},

    '_CONTENT_TYPE_BOILERPLATES' => 'Boilerplates',

    '__TEXT_BLOCK__' => 'Text',

    '__GROUP_MEMBER_COUNT' => 'Members',

    '__LIST_FIELD_LABEL' => 'List',

    '__TEXT_LABEL_TEXT' => 'Text',

    '__UNPUBLISHED' => 'Unpublish',
);

1;
__END__

=head1 NAME

MT::L10N::en_us - English localization support for Movable Type

=head1 METHODS

=head2 ascii_only

Judges whether this language consists of only ASCII codes. Returns 1.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut

