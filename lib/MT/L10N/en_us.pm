# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::L10N::en_us;   # American English
use strict;
use MT::L10N;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N );

sub ascii_only { ((ref $_[0]) || $_[0]) eq __PACKAGE__ }

%Lexicon = (
    'AUTO DETECT' => 'Auto-detect',
    '_external_link_target' => '_top',
    '_BLOG_CONFIG_MODE_BASIC' => 'Basic Mode',
    '_BLOG_CONFIG_MODE_DETAIL' => 'Detailed Mode',
    '_SEARCH_SIDEBAR' => 'Search',
    '_SYSTEM_TEMPLATE_COMMENT_PREVIEW' => 'Shown when a commenter previews their comment.',
    '_SYSTEM_TEMPLATE_COMMENT_PENDING' => 'Shown when a comment is moderated or junked.',
    '_SYSTEM_TEMPLATE_COMMENT_ERROR' => 'Shown when a comment submission cannot be validated.',
    '_SYSTEM_TEMPLATE_POPUP_IMAGE' => 'Shown when a visitor clicks a popup-linked image.',
    '_SYSTEM_TEMPLATE_COMMENTS' => 'Shown when comment popups (deprecated) are enabled.',
    '_SYSTEM_TEMPLATE_DYNAMIC_ERROR' => 'Shown when an error is encountered on a dynamic blog page.',
    '_SYSTEM_TEMPLATE_PINGS' => 'Shown when TrackBack popups (deprecated) are enabled.',
    '_SYSTEM_TEMPLATE_SEARCH_TEMPLATE' => 'Shown when a visitor searches the weblog.',

    '_ERROR_CONFIG_FILE' => 'Your Movable Type configuration file is missing or cannot be read properly. Please see the <a href="#">Installation and Configuration</a> section of the Movable Type manual for more information.',
    '_ERROR_DATABASE_CONNECTION' => 'Your database settings are either invalid or not present in your Movable Type configuration file. Please see the <a href="#">Installation and Configuration</a> section of the Movable Type manual for more information.',
    '_ERROR_CGI_PATH' => 'Your CGIPath configuration setting is either invalid or not present in your Movable Type configuration file. Please see the <a href="#">Installation and Configuration</a> section of the Movable Type manual for more information.',
    '_USAGE_REBUILD' => '<a href="#" onclick="doRebuild()">REBUILD</a> to see those changes reflected on your public site.',
    '_USAGE_VIEW_LOG' => 'Check the <a href="[_1]">Activity Log</a> for the error.',

    '_USAGE_FORGOT_PASSWORD_1' => 'You requested recovery of your Movable Type password. Your password has been changed in the system; here is the new password:',
    '_USAGE_FORGOT_PASSWORD_2' => 'You should be able to log in to Movable Type using this new password. Once you have logged in, you should change your password to something more memorable.',

    '_USAGE_BOOKMARKLET_1' => 'Setting up QuickPost to post to Movable Type allows you to perform one-click posting and publishing without ever entering through the main Movable Type interface.',
    '_USAGE_BOOKMARKLET_2' => 'Movable Type\'s QuickPost structure allows you to customize the layout and fields on your QuickPost page. For example, you may wish to add the ability to add excerpts through the QuickPost window. By default, a QuickPost window will always have: a pulldown menu for the weblog to post to; a pulldown menu to select the Post Status (Draft or Publish) of the new entry; a text entry box for the Title of the entry; and a text entry box for the entry body.',
    '_USAGE_BOOKMARKLET_3' => 'To install the Movable Type QuickPost bookmark, drag the following link to your browser\'s menu or Favorites toolbar:',
    '_USAGE_BOOKMARKLET_4' => 'After installing QuickPost, you can post from anywhere on the web. When viewing a page that you want to post about, click the "QuickPost" QuickPost to open a popup window with a special Movable Type editing window. From that window you can select a weblog to post the entry to, then enter you post, and publish.',
    '_USAGE_BOOKMARKLET_5' => 'Alternatively, if you are running Internet Explorer on Windows, you can install a "QuickPost" option into the Windows right-click menu. Click on the link below and accept the browser prompt to "Open" the file. Then quit and restart your browser to add the link to the right-click menu.',
    '_USAGE_ARCHIVE_MAPS' => 'This advanced feature allows you to map any archive template to multiple archive types. For example, you may want to create two different views of your monthly archives: one in which the entries for a particular month are presented as a list, and the other representing the entries in a calendar view of that month.',
    '_USAGE_ARCHIVING_1' => 'Select the frequencies/types of archiving that you would like on your site. For each type of archiving that you choose, you have the option of assigning multiple Archive Templates to be applied to that particular type. For example, you might wish to create two different views of your monthly archives: one a page containing each of the entries for a particular month, and the other a calendar view of that month.', 
    '_USAGE_ARCHIVING_2' => 'When you associate multiple templates with a particular archive type--or even when you associate only one--you can customize the output path for the archive files using Archive File Templates.',
    '_USAGE_ARCHIVING_3' => 'Select the archive type to which you would like to add a new archive template. Then select the template to associate with that archive type.',

    '_USAGE_BANLIST' => 'Below is the list of IP addresses who you have banned from commenting on your site or from sending TrackBack pings to your site. To add a new IP address, enter the address in the form below. To delete a banned IP address, check the delete box in the table below, and press the DELETE button.',

    '_USAGE_PREFS' => 'This screen allows you to set a variety of optional settings concerning your blog, your archives, your comments, and your publicity &amp; notification settings. When you create a new blog, these values will be set to reasonable defaults.',

    '_USAGE_FEEDBACK_PREFS' => 'This screen allows you to configure the ways that readers can contribute feedback to your blog.',

    '_USAGE_PROFILE' => 'Edit your author profile here. If you change your username or your password, your login credentials will be automatically updated. In other words, you will not need to re-login.',
    '_USAGE_PASSWORD_RESET' => 'Below, you can initiate password recovery on behalf of this user. If you choose to do so, a new, randomly-generated password will be created and sent directly to their email address: [_1].',
    '_WARNING_PASSWORD_RESET_SINGLE' => 'You are about to reset the password for "[_1]". A new password will be randomly generated and sent directly to their email address ([_2]).  Do you wish to continue?',
    '_WARNING_PASSWORD_RESET_MULTI' => 'You are about to reset the password for the selected users. New passwords will be randomly generated and sent directly to their email address(es).\n\nDo you wish to continue?',
    '_USAGE_NEW_AUTHOR' => 'From this screen you can create a new author in the system and give them access to particular weblogs.',

    '_USAGE_CATEGORIES' => 'Use categories to group your entries for easier reference, archiving and blog display. You can assign a category to a particular entry when creating or editing entries. To edit an existing category, click the category\'s title. To create a subcategory click the corresponding "Create" button. To move a category, click the corresponding "Move" button.',

    '_USAGE_TAGS' => 'Use tags to group your entries for easier reference and blog display.',

    '_USAGE_COMMENT' => 'Edit the selected comment. Press SAVE when you are finished. You will need to rebuild for these changes to take effect.',

    '_USAGE_PERMISSIONS_1' => 'You are editing the permissions of <b>[_1]</b>. Below you will find a list of blogs to which you have author-editing access; for each blog in the list, assign permissions to <b>[_1]</b> by checking the boxes for the access permissions you wish to grant.',
    '_USAGE_PERMISSIONS_2' => 'To edit permissions for a different user, select a new user from the pull-down menu, then press EDIT.',
    '_USAGE_PERMISSIONS_3' => 'You have two ways to edit authors and grant/revoke access privileges. For quick access, select a user from the menu below and select edit. Alternatively, you may browse the complete list of authors and, from there, select a person to edit or delete.',
    '_USAGE_PERMISSIONS_4' => 'Each blog may have multiple authors. To add an author, enter the user\'s information in the forms below. Next, select the blogs which the author will have some sort of authoring privileges.  Once you press SAVE and the user is in the system, you can edit the author\'s privileges.',

    '_USAGE_PLACEMENTS' => 'Use the editing tools below to manage the secondary categories to which this entry is assigned. The list to the left consists of the categories to which this entry is not yet assigned as either a primary or secondary category; the list to the right consists of the secondary categories to which this entry is assigned.',

    '_USAGE_ENTRYPREFS' => 'Select the set of fields to be displayed on the entry editor.',

    '_USAGE_IMPORT' => 'You can import entries for your weblog from a file in the <code>import</code> directory where Movable Type is installed, or uploaded by following forms. Entries can be imported from other Movable Type installations or other applications.',
    '_USAGE_EXPORT_1' => 'Exporting your entries from Movable Type allows you to keep <b>personal backups</b> of your blog basic entry data, comment and TrackBack data, for safekeeping.',
    '_USAGE_EXPORT_2' => 'To export your entries, click on the link below ("Export Entries From [_1]"). To save the exported data to a file, you can hold down the <code>option</code> key on the Macintosh, or the <code>Shift</code> key on a PC, while clicking on the link. Alternatively, you can select all of the data, then copy it into another document. (<a href="#" onclick="openManual(\'importing\', \'export_ie\');return false;">Exporting from Internet Explorer?</a>)',
    '_USAGE_EXPORT_3' => 'Clicking the link below will export all of your current weblog entries to the Tangent server. This is generally a one-time push of your entries, to be done after you have installed the Tangent add-on for Movable Type, but conceivably it could be executed whenever you wish.',

    '_USAGE_AUTHORS' => 'This is a list of all of the users in the Movable Type system. You can edit an author\'s permissions by clicking on his/her name. You can permanently delete authors by checking the checkbox next to their name, then pressing DELETE. NOTE: if you only want to remove an author from a particular blog, edit the author\'s permissions to remove the author; deleting an author using DELETE will remove the author from the system entirely.',

    '_USAGE_PLUGINS' => 'This is a list of all plugins currently registered with Movable Type.',

    '_USAGE_LIST_POWER' => 'Here is the list of entries for [_1] in batch-editing mode. In the form below, you may change any of the values for any of the entries displayed; after making the desired modifications, press the SAVE button. The standard List &amp; Edit Entries controls (filters, paging) work in batch mode in the manner to which you are accustomed.',

    '_USAGE_ENTRY_LIST_BLOG' => 'Here is the list of entries for [_1] which you can filter, manage and edit.',
    '_USAGE_ENTRY_LIST_OVERVIEW' => 'Here is the list of entries for all weblogs which you can filter, manage and edit.',

    '_USAGE_COMMENTS_LIST_BLOG' => 'Here is the list of comments for [_1] which you can filter, manage and edit.',
    '_USAGE_COMMENTS_LIST_OVERVIEW' => 'Here is the list of comments for all weblogs which you can filter, manage and edit.',
    
    '_USAGE_COMMENTS_LIST_ALL_WEBLOGS' => 'Here is the list of comments for all weblogs which you can filter, manage and edit.',

    '_USAGE_COMMENTERS_LIST' => 'Here is the list of all authenicated commenters to [_1]. Below you may flag any commenter as trusted or banned, or get more information.',

    '_USAGE_PING_LIST_BLOG' => 'Here is the list of TrackBacks for [_1]  which you can filter, manage and edit.',
    '_USAGE_PING_LIST_OVERVIEW' => 'Here is the list of TrackBacks for all weblogs which you can filter, manage and edit.',
    
    '_USAGE_PING_LIST_ALL_WEBLOGS' => 'Here is the list of TrackBack pings for all weblogs  which you can filter, manage and edit.',

    '_USAGE_NOTIFICATIONS' => 'Here is the list of users who wish to be notified when you post to your site. To add a new user, enter their email address in the form below. The URL field is optional. To delete a user, check the delete box in the table below and press the DELETE button.',

    '_USAGE_SEARCH' => 'You can use the Search &amp; Replace tool to find and optionally replace text or data found in many item listings within Movable Type. IMPORTANT: be careful when doing a replace, because there is <b>no undo</b>.',

    '_USAGE_UPLOAD' => 'Set the upload path by selecting an option from the choices below. If you prefer, you can upload the file to a subdirectory of the selected path. The destination directory will be created if it does not exist.',

    '_THROTTLED_COMMENT_EMAIL' => 'A visitor to your weblog [_1] has automatically been banned by posting more than the allowed number of comments in the last [_2] seconds. This has been done to prevent a malicious script from overwhelming your weblog with comments. The banned IP address is

    [_3]

If this was a mistake, you can unblock the IP address and allow the visitor to post again by logging in to your Movable Type installation, going to Weblog Config - IP Banning, and deleting the IP address [_4] from the list of banned addresses.',
     '_THROTTLED_COMMENT' => 'Too many comments have been submitted from you in a short period of time.  Please try again in a short while.',
     '_NOTIFY_REQUIRE_CONFIRMATION' => 'An email has been sent to [_1]. To complete your subscription, 
please follow the link contained in that email. This will verify that
the address you provided is correct and belongs to you.',

    '_INDEX_INTRO' => '<p>If you are installing Movable Type, you may want to review the <a href="http://www.sixapart.com/movabletype/docs/mtinstall.html">installation instructions</a> and view the <a rel="nofollow" href="mt-check.cgi">Movable Type System Check</a> to make sure that your system has what it needs.</p>',

    '_AUTO' => 1,
    'DAILY_ADV' => 'Daily',
    'WEEKLY_ADV' => 'Weekly',
    'MONTHLY_ADV' => 'Monthly',
    'INDIVIDUAL_ADV' => 'Individual',
    'CATEGORY_ADV' => 'Category',
    'Daily' => 'Daily',
    'Weekly' => 'Weekly',
    'Monthly' => 'Monthly',
    'Individual' => 'Individual',
    'Category' => 'Category',
    'Category Archive' => 'Category Archive',   
    'Date-Based Archive' => 'Date-Based Archive',   
    'Individual Entry Archive' => 'Individual Entry Archive',
    'Atom Index' => 'Atom Index',    
    'Dynamic Site Bootstrapper' => 'Dynamic Site Bootstrapper',    
    'Main Index' => 'Main Index',    
    'Master Archive Index' => 'Master Archive Index',    
    'RSD' => 'RSD',    
    'RSS 1.0 Index' => 'RSS 1.0 Index', 
    'RSS 2.0 Index' => 'RSS 2.0 Index', 
    'Stylesheet' => 'Stylesheet',

    'UTC+11' => 'UTC+11 (East Australian Daylight Savings Time)',
    'UTC+10' => 'UTC+10 (East Australian Standard Time)',

    '_POWERED_BY' => 'Powered by<br /><a href="http://www.sixapart.com/movabletype/">Movable Type <$MTVersion$></a>',
    'Blog Administrator' => 'Blog Administrator',
    'Entry Creation' => 'Entry Creation',
    'Edit All Entries' => 'Edit All Entries',
    'Manage Templates' => 'Manage Templates',
    'Configure Weblog' => 'Configure Weblog',
    'Rebuild Files' => 'Rebuild Files',
    'Send Notifications' => 'Send Notifications',
    'Manage Categories' => 'Manage Categories',
    'Add/Manage Categories' => 'Add/Manage Categories',
    'Manage Tags' => 'Manage Tags',
    'Manage Notification List' => 'Manage Notification List',
    'View Activity Log For This Weblog' => 'View Activity Log For This Weblog',
    'Publish Entries' => 'Publish Entries',
    'Unpublish Entries' => 'Unpublish Entries',
    'Unpublish TrackBack(s)' => 'Unpublish TrackBack(s)',
    'Unpublish Comment(s)' => 'Unpublish Comment(s)',
    'Trust Commenter(s)' => 'Trust Commenter(s)',
    'Untrust Commenter(s)' => 'Untrust Commenter(s)',
    'Ban Commenter(s)' => 'Ban Commenter(s)',
    'Unban Commenter(s)' => 'Unban Commenter(s)',
    'Untrust Commenter(s)' => 'Untrust Commenter(s)',
    'Unban Commenter(s)' => 'Unban Commenter(s)',
    'Add Tags...' => 'Add Tags...',
    'Remove Tags...' => 'Remove Tags...',
    'Tags to add to selected entries' => 'Tags to add to selected entries',
    'Tags to remove from selected entries' => 'Tags to remove from selected entries',
    'Manage my Widgets' => 'Manage my Widgets',
    'Select a Design using StyleCatcher' => 'Select a Design using StyleCatcher',
    'This page contains a single entry from the blog posted on <strong>[_1]</strong>.' => 'This page contains a single entry from the blog posted on <strong>[_1]</strong>.',
    'The previous post in this blog was <a href="[_1]">[_2]</a>.' => 'The previous post in this blog was <a href="[_1]">[_2]</a>.',
    'The next post in this blog is <a href="[_1]">[_2]</a>.' => 'The next post in this blog is <a href="[_1]">[_2]</a>.',
    'Many more can be found on the <a href="[_1]">main index page</a> or by looking through <a href="[_2]">the archives</a>.' => 'Many more can be found on the <a href="[_1]">main index page</a> or by looking through <a href="[_2]">the archives</a>.',
    'Install <a href=\'http://greasemonkey.mozdev.org/\'>GreaseMonkey</a>' => 'Install <a href=\'http://greasemonkey.mozdev.org/\'>GreaseMonkey</a>',
    'Create a feed widget' => 'Create a feed widget',
    'Or return to the <a href="[_1]">Main Menu</a> or <a href="[_2]">System Overview</a>.' => 'Or return to the <a href="[_1]">Main Menu</a> or <a href="[_2]">System Overview</a>.',
    'An error occurred processing [_1]. Check <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">here</a> for more detail and please try again.' => 'An error occurred processing [_1]. Check <a href="http://www.feedvalidator.org/check.cgi?url=[_2]">here</a> for more detail and please try again.',
    'Congratulations! A template module Widget named <strong>[_1]</strong> has been created which you can further <a href="[_2]">edit</a> to customize its display.' => 'Congratulations! A template module Widget named <strong>[_1]</strong> has been created which you can further <a href="[_2]">edit</a> to customize its display.',
    'It can be included onto your published blog using <a href="[_1]">WidgetManager</a> or this MTInclude tag' => 'It can be included onto your published blog using <a href="[_1]">WidgetManager</a> or this MTInclude tag',
    'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.' => 'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.',
    'To download more plugins, check out the <a href="http://www.sixapart.com/pronet/plugins/">Six Apart Plugin Directory</a>.' => 'To download more plugins, check out the <a href="http://www.sixapart.com/pronet/plugins/">Six Apart Plugin Directory</a>.',
    'Adds template tags to allow you to search for content from Google. You will need to configure this plugin using a <a href=\'http://www.google.com/apis/\'>license key.</a>' => 'Adds template tags to allow you to search for content from Google. You will need to configure this plugin using a <a href=\'http://www.google.com/apis/\'>license key.</a>',
    'Please enter the parameters necessary for connecting to your database.If your database type is not listed in the dropdown below, you may be missing the Perl module necessary to connect to your database.  If this is the case, please check your installation and click <a href="?__mode=configure">here</a> to re-test your installation.' => 'Please enter the parameters necessary for connecting to your database.If your database type is not listed in the dropdown below, you may be missing the Perl module necessary to connect to your database.  If this is the case, please check your installation and click <a href="?__mode=configure">here</a> to re-test your installation.',
    'The above settings have been written to the file <tt>[_1]</tt>. If any of these settings are incorrect, you may click the \'Back\' button below to reconfigure them.' => 'The above settings have been written to the file <tt>[_1]</tt>. If any of these settings are incorrect, you may click the \'Back\' button below to reconfigure them.',
    'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides.' => 'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides.',
    '<p>You must define a global theme repository where themes can be stored locally.  If a particular blog has not been configured for it\'s own theme paths, it will use these settings directly. If a blog has it\'s own theme paths, then the theme will be copied to that location when applied to that weblog. The paths defined here must physically exist and be writable by the webserver.</p>' => '<p>You must define a global theme repository where themes can be stored locally.  If a particular blog has not been configured for it\'s own theme paths, it will use these settings directly. If a blog has it\'s own theme paths, then the theme will be copied to that location when applied to that weblog. The paths defined here must physically exist and be writable by the webserver.</p>',
    'Drag and drop the widgets you want into the <strong>Installed</strong> column.' => 'Drag and drop the widgets you want into the <strong>Installed</strong> column.',
    'If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the <code>import</code> folder of your Movable Type directory.' => 'If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the <code>import</code> folder of your Movable Type directory.',
    '<em><strong>Please Note:</strong> The Movable Type export format is not comprehensive and is not suitable for creating full-fidelity backups. Please see the Movable Type manual for full details.</em>' => '<em><strong>Please Note:</strong> The Movable Type export format is not comprehensive and is not suitable for creating full-fidelity backups. Please see the Movable Type manual for full details.</em>',
    'Recover Password(s)' => 'Recover Password(s)',
    'Refresh Template(s)' => 'Refresh Template(s)',
    'This page contains all entries posted to [_1] in <strong>[_2]</strong>. They are listed from oldest to newest.' => 'This page contains all entries posted to [_1] in <strong>[_2]</strong>. They are listed from oldest to newest.',
    '<a href="[_1]">[_2]</a> is the next category.' => '<a href="[_1]">[_2]</a> is the next category.',
    '<a href="[_1]">[_2]</a> is the previous category.' => '<a href="[_1]">[_2]</a> is the previous category.',
    'This page contains an archive of all entries posted to [_1] in the <strong>[_2]</strong> category.  They are listed from oldest to newest.' => 'This page contains an archive of all entries posted to [_1] in the <strong>[_2]</strong> category.  They are listed from oldest to newest.',
    '<a href="[_1]">[_2]</a> is the next archive.' => '<a href="[_1]">[_2]</a> is the next archive.',
    '<a href="[_1]">[_2]</a> is the previous archive.' => '<a href="[_1]">[_2]</a> is the previous archive.',
    'Refreshing (with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>) template \'[_3]\'.' => 'Refreshing (with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>) template \'[_3]\'.',
    'Skipping template \'[_1]\' since it appears to be a custom template.' => 'Skipping template \'[_1]\' since it appears to be a custom template.',
    'Refreshing template \'[_1]\'.' => 'Refreshing template \'[_1]\'.',
);

1;
