# Movable Type (r) (C) 2001-2020 Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::L10N::lang_tag;    ## <--- Replace "lang_tag" with proper tag.
use strict;
use MT::L10N;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

## Translators:
##
## [Enter your email address here.]

sub encoding {"iso-8859-1"}    # Latin-1
## Change this if you need a different encoding.

## The following is the translation table.

%Lexicon = (
    '_USAGE_REBUILD'  => '',
    '_USAGE_VIEW_LOG' => '',

    ## Default Templates
    'Continue reading'                                          => '',
    'Posted by'                                                 => '',
    'at'                                                        => '',
    'Comments'                                                  => '',
    'TrackBack'                                                 => '',
    "Monthly calendar with links to each day's posts"           => "",
    'Sunday'                                                    => '',
    'Sun'                                                       => '',
    'Monday'                                                    => '',
    'Mon'                                                       => '',
    'Tuesday'                                                   => '',
    'Tue'                                                       => '',
    'Wednesday'                                                 => '',
    'Wed'                                                       => '',
    'Thursday'                                                  => '',
    'Thu'                                                       => '',
    'Friday'                                                    => '',
    'Fri'                                                       => '',
    'Saturday'                                                  => '',
    'Sat'                                                       => '',
    'Search'                                                    => '',
    'Search this site:'                                         => '',
    'Archives'                                                  => '',
    'Recent Entries'                                            => '',
    'Links'                                                     => '',
    'Syndicate this site'                                       => '',
    'Powered by'                                                => '',
    'This weblog is licensed under a'                           => '',
    'Comment Preview'                                           => '',
    'Previewing your Comment'                                   => '',
    'Name:'                                                     => '',
    'Email Address:'                                            => '',
    'IP Address:'                                               => '',
    'URL:'                                                      => '',
    'Comments:'                                                 => '',
    'Previous Comments'                                         => '',
    'Comment Submission Error'                                  => '',
    'Your comment submission failed for the following reasons:' => '',
    'Please correct the error in the form below, then press Post to post your comment.'
        => '',
    'Comment on'                                       => '',
    'Post a comment'                                   => '',
    'Remember personal info?'                          => '',
    'Main'                                             => '',
    'Discussion on'                                    => '',
    'Continuing the discussion...'                     => '',
    'TrackBack URL for this entry:'                    => '',
    'Listed below are links to weblogs that reference' => '',
    'from'                                             => '',
    'Excerpt:'                                         => '',
    'Weblog:'                                          => '',
    'Tracked:'                                         => '',

    ## Global: Navigation
    'Main Menu'                   => '',
    '[_1] Editing Menu'           => '',
    'Entries'                     => '',
    'Create Entry'                => '',
    'List &amp; Edit Entries'     => '',
    'Upload File'                 => '',
    'Manage'                      => '',
    'List &amp; Edit Templates'   => '',
    'Edit Categories'             => '',
    'Edit Notification List'      => '',
    'Edit Weblog Configuration'   => '',
    'Utilities'                   => '',
    'Search &amp; Replace'        => '',
    'Import &amp; Export Entries' => '',
    'Rebuild Files'               => '',
    'View Site'                   => '',
    'Go'                          => '',

    ## Global: Generic Fields and Phrases
    'Username'      => '',
    'Password'      => '',
    'Email Address' => '',
    'Entry'         => '',
    'No title'      => '',
    'IP Address'    => '',
    'Author'        => '',
    'URL'           => '',
    'None'          => '',
    'Open'          => '',
    'Closed'        => '',
    'Previous'      => '',
    'Next'          => '',
    'Date Added'    => '',
    'Date'          => '',
    'Yes'           => '',
    'No'            => '',
    'On'            => '',
    'Off'           => '',

    ## Global: Post Status settings
    'Draft'   => '',
    'Publish' => '',

    ## Global: Buttons
    'Cancel'         => '',
    'Post'           => '',
    'Close'          => '',
    'Create'         => '',
    'Add new...'     => '',
    'Save'           => '',
    'Delete'         => '',
    'Add'            => '',
    'Delete Checked' => '',
    'Preview'        => '',
    'Delete Entry'   => '',
    'Send'           => '',
    'Edit'           => '',
    'Rebuild'        => '',

    ## Global: Archive Types
    'Individual' => '',
    'Daily'      => '',
    'Weekly'     => '',
    'Monthly'    => '',
    'Category'   => '',

    ## Global: Entry fields
    'Title'            => '',
    'Post Status'      => '',
    'Primary Category' => '',
    'Allow Comments'   => '',
    'Allow Pings'      => '',
    'URLs to Ping'     => '',
    'Text Formatting'  => '',
    'Entry Body'       => '',
    'Extended Entry'   => '',
    'Excerpt'          => '',
    'Keywords'         => '',
    'Authored On'      => '',
    'TrackBack items'  => '',

    ## Email Messages
    '_USAGE_FORGOT_PASSWORD_1'       => '',    ## Password recovery
    '_USAGE_FORGOT_PASSWORD_2'       => '',
    '[_1] Update: [_2]'              => '',    ## Notification message
    'New Comment Posted to \'[_1]\'' => '',
    'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).'
        => '',
    'New TrackBack Ping to Entry [_1] ([_2])' => '',
    'A new TrackBack ping has been sent to your weblog, on the entry [_1] ([_2]).'
        => '',
    'New TrackBack Ping to Category [_1] ([_2])' => '',
    'A new TrackBack ping has been sent to your weblog, on the category [_1] ([_2]).'
        => '',
    'Title:' => '',

    ## Bookmarklet (bm_entry.tmpl)
    'You must choose a weblog in which to post the new entry.' => '',
    'Enter URL:'                                               => '',
    'Select a weblog for this post:'                           => '',
    'Select a weblog'                                          => '',
    'Ping TrackBack URL:'                                      => '',
    'Select a TrackBack entry to ping:'                        => '',

    ## Bookmarklet posted screen (bm_posted.tmpl)
    'Your new entry has been saved to [_1]' => '',
    ', and it has been posted to your site' => '',
    'View your site'                        => '',
    'Edit this entry'                       => '',

    ## Blog Config: Navigation
    'Configuration' => '',
    'Core Setup'    => '',
    'Preferences'   => '',
    'Archiving'     => '',
    'IP Banning'    => '',

    ## Add a Category screen (category_add.tmpl)
    'Add a Category'                                           => '',
    'Type the name of the new category below, then press ADD.' => '',

    ## Blog Config | IP Banning (cfg_banlist.tmpl)
    'You did not select any IP addresses to delete.'           => '',
    '_USAGE_BANLIST'                                           => '',
    'You have added [_1] to your list of banned IP addresses.' => '',
    'You have successfully deleted the selected IP addresses from the list.'
        => '',
    'IP Ban List'                                                   => '',
    'You have [quant,_1,user] in your list of banned IP addresses.' => '',

    ## Blog Config | Preferences (cfg_prefs.tmpl)
    '_USAGE_PREFS'                              => '',
    'General Settings'                          => '',
    'Publicity / Remote Interfaces / TrackBack' => '',
    'Comment Configuration'                     => '',
    'Your blog preferences have been saved.'    => '',
    'Enter a description for your blog.'        => '',
    'Description:'                              => '',
    'Enter the number of days\' entries you would like displayed on your index.'
        => '',
    'Number of days displayed:' => '',
    'Select the language in which you would like dates on your blog displayed.'
        => '',
    'Language for date display:' => '',
    'Czech'                      => '',
    'Danish'                     => '',
    'Dutch'                      => '',
    'English'                    => '',
    'French'                     => '',
    'German'                     => '',
    'Icelandic'                  => '',
    'Japanese'                   => '',
    'Italian'                    => '',
    'Norwegian'                  => '',
    'Polish'                     => '',
    'Portuguese'                 => '',
    'Slovak'                     => '',
    'Slovenian'                  => '',
    'Spanish'                    => '',
    'Suomi'                      => '',
    'Swedish'                    => '',
    'Select whether you want your posts displayed in ascending (oldest at top) or descending (newest at top) order.'
        => '',
    'Order of entries displayed:' => '',
    'Ascending'                   => '',
    'Descending'                  => '',
    'Specifies the default Text Formatting option when creating a new entry.'
        => '',
    'Default Text Formatting:'                                     => '',
    'Specifies the default Post Status when creating a new entry.' => '',
    'Default Post Status:'                                         => '',
    'Enter the number of words that should appear in an auto-generated excerpt:'
        => '',
    'Number of words in excerpt:' => '',
    'Enter a welcome message to be displayed on the Editing Menu to authors of your blog.'
        => '',
    'Welcome Message:' => '',
    'Specifies the list of HTML tags allowed by default when cleaning an HTML string (a comment, for example).'
        => '',
    'Sanitize Spec:'            => '',
    'Use defaults'              => '',
    'Use my settings:'          => '',
    'Creative Commons License:' => '',
    'Select a Creative Commons license for the posts on your blog (optional).'
        => '',
    'Be sure that you understand these licenses before applying them to your own work.'
        => '',
    'Read more.'                                                      => '',
    'Your weblog is currently licensed under:'                        => '',
    'Your weblog does not have an explicit Creative Commons license.' => '',
    'Change your license'                                             => '',
    'Create a license now'                                            => '',
    'When linking to an archived entry--for a permalink, for example--you must link to a particular archive type, even if you have chosen multiple archive types.'
        => '',
    'Preferred Archive Type:' => '',
    'No Archives'             => '',
    'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: do not enter the leading period (\'.\').'
        => '',
    'File extension for archive files:' => '',
    'When you update your blog, Movable Type will automatically notify the selected sites.'
        => '',
    'Notify the following sites when I update my blog:' => '',
    'Others: (separate URLs with a carriage return)'    => '',
    'If you have received a recently updated key (by virtue of your donation), enter it here.'
        => '',
    'Recently updated key:' => '',
    'If you wish to use any of the Google API functionality, you will need a Google API key. Paste it in here.'
        => '',
    'Google API key:' => '',
    'Specifies whether Allow Pings is checked or unchecked by default when creating a new entry.'
        => '',
    'Allow Pings on by default?' => '',
    'Would you like to be notified via email when someone sends a TrackBack ping to your site?'
        => '',
    'Email new TrackBack pings?' => '',
    'Should visitors to your site be able to post comments anonymously--that is, without submitting a name and email address?'
        => '',
    'Allow anonymous comments?' => '',
    'Select whether you want visitor comments displayed in ascending (oldest at top) or descending (newest at top) order.'
        => '',
    'Order of comments displayed:' => '',
    'Would you liked to be notified via email when someone posts comments to your site?'
        => '',
    'Email new comments?' => '',
    'Specifies the Text Formatting option to use for formatting visitor comments.'
        => '',
    'Text Formatting for comments:' => '',
    'Should visitors be able to include HTML in their comments? If not, all HTML entered will be stripped out.'
        => '',
    'Allow HTML in comments?' => '',
    'If enabled, all web URLs will be transformed into links to that web URL. NOTE: if you have enabled Allow HTML in comments, this option is ignored.'
        => '',
    'Auto-link URLs?' => '',
    'Specifies the default Allow Comments setting when creating a new entry.'
        => '',
    'Allow Comments default' => '',
    'If you turn on auto-discovery, when you write a new post, any links will be extracted and the appropriate sites automatically sent TrackBack pings.'
        => '',
    'Turn on TrackBack auto-discovery?'                               => '',
    'You did not select any archive templates to delete.'             => '',
    '_USAGE_ARCHIVING_1'                                              => '',
    '_USAGE_ARCHIVING_2'                                              => '',
    'Your weblog\'s archive configuration has been saved.'            => '',
    'You have successfully added a new archive-template association.' => '',
    'The selected archive-template associations have been deleted.'   => '',
    'Archive Type'                                                    => '',
    'Template'                                                        => '',
    'Archive File Template'                                           => '',
    'Del'                                                             => '',
    '_USAGE_ARCHIVING_3'                                              => '',

    ## Profile-Editing screen (edit_author.tmpl)
    'Edit Your Profile'              => '',
    '_USAGE_PROFILE'                 => '',
    'Your profile has been updated.' => '',
    'Nickname'                       => '',
    'Website URL (optional)'         => '',
    'Preferred Language'             => '',
    'Change your password'           => '',
    'Password confirm'               => '',
    'For Password Recovery'          => '',
    'Birthplace'                     => '',

    ## Blog Config | Core setup (edit_blog.tmpl)
    'You must set your Local Site Path.'                            => '',
    'You must set your Site URL.'                                   => '',
    'You did not select a time zone.'                               => '',
    'Create weblog'                                                 => '',
    'Your weblog configuration has been saved.'                     => '',
    'Name your weblog. The weblog name can be changed at any time.' => '',
    'Weblog name:'                                                  => '',
    'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.'
        => '',
    'Example:'         => '',
    'Local Site Path:' => '',
    'Enter the URL of your website. Exclude the filename (i.e. index.html).'
        => '',
    'Site URL:' => '',
    'Enter the path where your archive files will be located (this can be the same as your Local Site Path).'
        => '',
    'Local Archive Path:'                                    => '',
    'Enter the URL of the archives section of your website.' => '',
    'Archive URL:'                                           => '',
    'Select your time zone from the pulldown menu.'          => '',
    'Time zone:'                                             => '',
    'Time zone not selected'                                 => '',
    'UTC+12 (International Date Line East)'                  => '',
    'UTC+11'                                                 => '',
    'UTC+10 (East Australian Time)'                          => '',
    'UTC+9.5 (Central Australian Time)'                      => '',
    'UTC+9 (Japan Time)'                                     => '',
    'UTC+8 (China Coast Time)'                               => '',
    'UTC+7 (West Australian Time)'                           => '',
    'UTC+6.5 (North Sumatra)'                                => '',
    'UTC+6 (Russian Federation Zone 5)'                      => '',
    'UTC+5.5 (Indian)'                                       => '',
    'UTC+5 (Russian Federation Zone 4)'                      => '',
    'UTC+4 (Russian Federation Zone 3)'                      => '',
    'UTC+3.5 (Iran)'                                         => '',
    'UTC+3 (Baghdad Time/Moscow Time)'                       => '',
    'UTC+2 (Eastern Europe Time)'                            => '',
    'UTC+1 (Central European Time)'                          => '',
    'UTC+0 (Universal Time Coordinated)'                     => '',
    'UTC-1 (West Africa Time)'                               => '',
    'UTC-2 (Azores Time)'                                    => '',
    'UTC-3 (Atlantic Time)'                                  => '',
    'UTC-3.5 (Newfoundland)'                                 => '',
    'UTC-4 (Atlantic Time)'                                  => '',
    'UTC-5 (Eastern Time)'                                   => '',
    'UTC-6 (Central Time)'                                   => '',
    'UTC-7 (Mountain Time)'                                  => '',
    'UTC-8 (Pacific Time)'                                   => '',
    'UTC-9 (Alaskan Time)'                                   => '',
    'UTC-10 (Aleutians-Hawaii Time)'                         => '',
    'UTC-11 (Nome Time)'                                     => '',

    ## Category-editing screen (edit_categories.tmpl)
    'You did not select any categories to delete.'           => '',
    '_USAGE_CATEGORIES'                                      => '',
    'Your category changes and additions have been made.'    => '',
    'You have successfully deleted the selected categories.' => '',
    'Categories'                                             => '',
    'Created by [_1]'                                        => '',
    '[quant,_1,Entry,Entries]'                               => '',
    '[quant,_1,TrackBack ping]'                              => '',
    'Edit category attributes'                               => '',

    ## Category-attribute screen (edit_category.tmpl)
    'Category: [_1]' => '',
    "Use this page to edit the attributes of the category [_1]. You can set a description for your category to be used in your public pages, as well as configuring the TrackBack options for this category."
        => "",
    'Your category changes have been made.' => '',
    'Category Name:'                        => '',
    'Category Description'                  => '',
    'TrackBack Settings'                    => '',
    'Outgoing Pings'                        => '',
    'TrackBack URLs to ping'                => '',
    'Enter the URL(s) of the websites that you would like to ping each time you post an entry in this category. (Separate URLs with a carriage return.)'
        => '',
    'Incoming Pings'                         => '',
    'Accept incoming TrackBack pings?'       => '',
    'View TrackBack pings for this category' => '',
    'Passphrase Protection (Optional)'       => '',
    'TrackBack URL for this category'        => '',
    'This is the URL that others will use to ping your weblog. If you wish for anyone to ping your weblog when they have a post specific to this category, post this URL publicly. If you choose to only allow a select group of individuals to ping, send this URL to them privately.'
        => '',
    'To include a list of incoming pings in your Main Index Template, look here for sample code:'
        => '',

    ## Comment-editing screen (edit_comment.tmpl)
    'Edit Comment'           => '',
    '_USAGE_COMMENT'         => '',
    'Comment'                => '',
    'Entry no longer exists' => '',

    ## Entry-editing screen (edit_entry.tmpl)
    'You did not select any comments to delete.' => '',
    'Edit Entry'                                 => '',
    'Your entry has been saved. You can now make any changes to the entry itself, edit the authored-on date, edit comments, or send a notification.'
        => '',
    'Your changes have been saved.' => '',
    'Your customization preferences have been saved, and are visible in the form below.'
        => '',
    'Your changes to the comment have been saved.'          => '',
    'Your notification has been sent.'                      => '',
    'Add new category...'                                   => '',
    'Convert Line Breaks'                                   => '',
    'Previous pings sent'                                   => '',
    'You have successfully deleted the checked comment(s).' => '',
    'Customize the display of this page.'                   => '',
    'Advanced Options'                                      => '',
    'Edit Comments'                                         => '',
    'Click on the author\'s name to edit their comment. To delete, check the box to its right and then press the delete button.'
        => '',
    'Manage TrackBack Pings' => '',
    'To delete a ping, check the box to its right and then press the delete button.'
        => '',
    'Send a notification' => '',
    'You can send a notification message to your group of readers. Just enter the email message that you would like to insert below the weblog entry\'s link. You have the option of including the excerpt indicated above or the entry in its entirety.'
        => '',
    'Include excerpt'           => '',
    'Include entire entry body' => '',
    'Note: If you chose to send the weblog entry, all added HTML will be included in the email.'
        => '',

    ## Permission/author-adding screen (edit_permissions.tmpl)
    'Add/Edit Weblog Authors' => '',
    'Edit Permissions'        => '',
    '_USAGE_PERMISSIONS_1'    => '',
    '_USAGE_PERMISSIONS_2'    => '',
    '_USAGE_PERMISSIONS_3'    => '',
    '_USAGE_PERMISSIONS_4'    => '',
    'Your changes to [_1]\'s permissions have been saved. You can select another author to edit or return to the main Author menu.'
        => '',
    '[_1] has been successfully added to [_2].' => '',
    'Select an author to edit:'                 => '',
    'View complete list of authors'             => '',
    'Delete, view, and edit authors via a complete list of authors in the system.'
        => '',
    'General Permissions'                => '',
    'User can create weblogs'            => '',
    'User can view activity log'         => '',
    'Weblog:'                            => '',
    'Post'                               => '',
    'Upload File'                        => '',
    'Edit All Posts'                     => '',
    'Edit Templates'                     => '',
    'Edit Authors & Permissions'         => '',
    'Configure Weblog'                   => '',
    'Rebuild Files'                      => '',
    'Send Notifications'                 => '',
    'Edit Categories'                    => '',
    'Edit Address Book'                  => '',
    'Add user to an additional weblog:'  => '',
    'Select a weblog'                    => '',
    'Add an author'                      => '',
    'This user will be associated with:' => '',

    ## Secondary-category screen (edit_placements.tmpl)
    '_USAGE_PLACEMENTS' => '',
    'The secondary categories for this entry have been updated. You will need to SAVE the entry for these changes to be reflected on your public site.'
        => '',
    'Categories in your blog:' => '',
    'Secondary categories:'    => '',

    ## Template-editing screen (edit_template.tmpl)
    'List Templates'                => '',
    'Create Template'               => '',
    'Edit Template'                 => '',
    'Template Name'                 => '',
    'Comment Listing Template'      => '',
    'Comment Preview Template'      => '',
    'Comment Error Template'        => '',
    'TrackBack Listing Template'    => '',
    'Uploaded Image Popup Template' => '',
    'Output File'                   => '',
    'Rebuild this template automatically when rebuilding index templates' =>
        '',
    'Link this template to a file'           => '',
    'Module Body'                            => '',
    'Template Body'                          => '',
    'Your template changes have been saved.' => '',

    ## Entry-editing preference screen (entry_prefs.tmpl)
    'Your entry screen preferences have been saved.'     => '',
    'Field Configuration'                                => '',
    '_USAGE_ENTRYPREFS'                                  => '',
    '(Help?)'                                            => '',
    'Basic'                                              => '',
    'Advanced'                                           => '',
    'Custom: show the following fields:'                 => '',
    'Button Bar Position'                                => '',
    'Top of the page'                                    => '',
    'Bottom of the page'                                 => '',
    'Editable Authored On Date (Edit Entry screen only)' => '',

    ## Import and export screen (import.tmpl)
    'Import Entries'                               => '',
    '_USAGE_IMPORT'                                => '',
    'Import entries as me'                         => '',
    'Password (required if creating new authors):' => '',
    'Default category for entries (optional):'     => '',
    'Select a category'                            => '',
    'Default post status for entries (optional):'  => '',
    'Select a post status'                         => '',
    'Start title HTML (optional):'                 => '',
    'End title HTML (optional):'                   => '',
    'Export Entries'                               => '',
    '_USAGE_EXPORT_1'                              => '',
    '_USAGE_EXPORT_2'                              => '',
    '_USAGE_EXPORT_3'                              => '',
    'Export Entries From [_1]'                     => '',

    ## Author-listing screen (list_author.tmpl)
    'You did not select any authors to delete.' => '',
    'Add/Edit Weblog Authors'                   => '',
    'List &amp; Delete Authors'                 => '',
    '_USAGE_AUTHORS'                            => '',
    'You have successfully deleted the authors from the Movable Type system.'
        => '',
    'Created By' => '',

    ## Main Menu screen (list_blog.tmpl)
    '[_1]: Welcome to the Main Menu' => '',
    'Select an existing weblog to edit, create weblogs, add/edit authors, and edit your personal information.'
        => '',
    'Your selected weblog has been deleted.'                  => '',
    'Your existing weblogs:'                                  => '',
    'Add entries, manage templates, set configurations, etc.' => '',
    'Entries:'                                                => '',
    'Comments:'                                               => '',
    'Authors:'                                                => '',
    'New Entry'                                               => '',
    'Manage Weblog'                                           => '',
    'Delete Weblog'                                           => '',
    'Create Weblog'                                           => '',
    'Add/Edit Weblog authors'                                 => '',
    'Add authors, set permissions'                            => '',
    'Edit your profile'                                       => '',
    'Change password, contact info, select language'          => '',
    'View Activity Log'                                       => '',
    'System activity, logins'                                 => '',
    'Bookmarklets enable one-click publishing'                => '',

    ## List & Edit Entries screen (list_entry.tmpl)
    'You did not select any entries to delete.'      => '',
    '_USAGE_LIST_POWER'                              => '',
    '_USAGE_LIST'                                    => '',
    'Open power-editing mode'                        => '',
    'Your changes have been saved.'                  => '',
    'Your entry has been deleted from the database.' => '',
    'Filter options'                                 => '',
    'View the entries where the:'                    => '',
    'Select'                                         => '',
    'is'                                             => '',
    'or'                                             => '',
    'Reset Filter'                                   => '',
    'Category'                                       => '',
    'Status'                                         => '',
    'Previous [_1]'                                  => '',
    'Next [_1]'                                      => '',
    '[quant,_1,entry,entries]'                       => '',
    'all entries'                                    => '',

    ## Edit Notifications (list_notification.tmpl)
    'You did not select any notification addresses to delete.' => '',
    'Edit notification list'                                   => '',
    '_USAGE_NOTIFICATIONS'                                     => '',
    'You have added [_1] to your notification list.'           => '',
    'You have successfully deleted the selected notifications from your notification list.'
        => '',
    'URL (Optional)'    => '',
    'Add to List'       => '',
    'Notification list' => '',
    'You have [quant,_1,user,users,no users] in your notification list.' =>
        '',
    'URL'    => '',
    'Delete' => '',

    ## List & Edit Templates (list_template.tmpl)
    'You did not select any templates to delete.'            => '',
    'List Templates'                                         => '',
    '_USAGE_TEMPLATES'                                       => '',
    'You have successfully deleted the checked template(s).' => '',
    'Index templates'                                        => '',
    'Create index template'                                  => '',
    'Rebuild?'                                               => '',
    'Archive-Related Templates'                              => '',
    'Create archive template'                                => '',
    'Miscellaneous Templates'                                => '',
    'Template Modules'                                       => '',
    'Create template module'                                 => '',

    ## Login screen (login.tmpl)
    'Your Movable Type session has ended. If you wish to log in again, you can do so below.'
        => '',
    'Remember me?'          => '',
    'Log In'                => '',
    'Forgot your password?' => '',

    ## Top navigation (logonav.tmpl)
    'Search Weblog' => '',
    'User:'         => '',

    ## Blog Editing Menu (menu.tmpl)
    'Welcome to [_1].' => '',
    'You can post and maintain your weblog by selecting an option from the menu located to the left of this message.'
        => '',
    'If you need assistance, try:'          => '',
    'Movable Type User Manual'              => '',
    'Movable Type Support Forum'            => '',
    'This welcome message is configurable.' => '',
    'Change this message.'                  => '',
    'Five Most Recent Entries'              => '',
    'Five Most Recent Comments'             => '',
    'Five Most Recent Pings'                => '',

    ## Previous pings screen (pinged_urls.tmpl)
    'Here is a list of previous pings that were successfully sent:' => '',

    ## Pinging... screen (pinging.tmpl)
    'Pinging sites...' => '',

    ## Entry preview screen (preview_entry.tmpl)
    'Preview your entry' => '',
    'Re-Edit this entry' => '',
    'Save this entry'    => '',

    ## Rebuild confirmation screen (rebuild_confirm.tmpl)
    'Rebuilding [_1]' => '',
    'Select the type of rebuild you would like to perform (press CANCEL if you do not want to rebuild any files):'
        => '',
    'Rebuild All Files'          => '',
    'Index Template: [_1]'       => '',
    'Rebuild Indexes Only'       => '',
    'Rebuild [_1] Archives Only' => '',

    ## Rebuilding screen (rebuilding.tmpl)
    'Rebuilding [_1]'            => '',
    'Rebuilding [_1] pages [_2]' => '',
    'Rebuilding [_1] pages'      => '',

    ## Rebuilt screen (rebuilt.tmpl)
    'All of your files have been rebuilt.' => '',
    'Your [_1] has been rebuilt.'          => '',
    'Your [_1] pages have been rebuilt.'   => '',
    'View this page'                       => '',
    'Rebuild Again'                        => '',

    ## Password recovery screen (recover.tmpl)
    'Your password has been changed, and the new password has been sent to your email address ([_1]).'
        => '',
    'Enter your Movable Type username:' => '',
    'Enter your birthplace:'            => '',
    'Recover'                           => '',

    ## Search and replace screen (search_replace.tmpl)
    '_USAGE_SEARCH'                                      => '',
    'Search for:'                                        => '',
    'Case Sensitive'                                     => '',
    'Regular Expression Match'                           => '',
    'Search fields:'                                     => '',
    'Extended Entry Body'                                => '',
    'Replace with:'                                      => '',
    'Search'                                             => '',
    'Replace'                                            => '',
    'Search Results'                                     => '',
    'The following entries match the search string [_1]' => '',
    '; that search string has been replaced by [_1]'     => '',

    ## Show upload HTML screen (popup/show_upload_html.tmpl)
    'Copy and paste this HTML into your entry.' => '',
    'Upload Another'                            => '',

    ## Category TrackBack pings (tb_cat_pings.tmpl)
    'You did not select any pings to delete.' => '',
    'Click on the title to view the corresponding entry on the original site. To delete a ping, check the box to the right, then click the Delete Checked button.'
        => '',
    'You have successfully deleted the checked TrackBack pings from this category.'
        => '',

    ## Upload start screen (upload.tmpl)
    'Choose a file' => '',
    'To upload a file to your server, click on the browse button to locate the file on your hard drive.'
        => '',
    'File:'                => '',
    'Choose a destination' => '',
    '_USAGE_UPLOAD'        => '',
    'Upload into:'         => '',
    '(optional)'           => '',
    'Upload'               => '',

    ## Upload complete + thumbnail screen (upload_complete.tmpl)
    'Your file has been uploaded. Size: [quant,_1,byte].' => '',
    'Create a new entry using this uploaded file'         => '',
    'Show me the HTML'                                    => '',
    'Image Thumbnail'                                     => '',
    'Create a thumbnail for this image'                   => '',
    'Width:'                                              => '',
    'Pixels'                                              => '',
    'Percent'                                             => '',
    'Height:'                                             => '',
    'Constrain proportions'                               => '',
    'Would you like this file to be a:'                   => '',
    'Popup Image'                                         => '',
    'Embedded Image'                                      => '',
    'Link'                                                => '',

    ## Upload overwrite confirmation screen (upload_confirm.tmpl)
    'A file named \'[_1]\' already exists. Do you want to overwrite this file?'
        => '',

    ## Activity Log screen (view_log.tmpl)
    'Activity Log' => '',
    'The Movable Type activity log contains a record of notable actions in the system. All times are displayed in GMT.'
        => '',
    'The activity log has been reset.' => '',
    'Log Entry'                        => '',
    'Reset Activity Log'               => '',

    ## Error messages from the Perl API.
    "Can't load error template; got error '[_1]'. Giving up. Original error was [_1]"
        => "",
    'The file you uploaded is too large.'              => '',
    'Unknown action [_1]'                              => '',
    "Loading template '[_1]' failed: [_2]"             => "",
    "Load of blog '[_1]' failed: [_2]"                 => "",
    "Archive type '[_1]' is not a chosen archive type" => "",
    "Parameter '[_1]' is required"                     => "",
    "You selected the archive type '[_1]', but you did not define a template for this archive type."
        => "",
    'Building category archives, but no category provided.' => '',
    'You did not set your Local Archive Path'               => '',
    "Building entry \'[_1]\' failed: [_2]"                  => "",
    "Error making path \'[_1]\': [_2]"                      => "",
    "Writing to \'[_1]\' failed: [_2]"                      => "",
    "Renaming tempfile \'[_1]\' failed: [_2]"               => "",
    'You did not set your Local Site Path'                  => '',

    '[_1] with no [_2]'                      => '',
    "Error opening file '[_1]': [_2]"        => "",
    "[_1]:[_2]: variable '[_3]' not defined" => "",
    "No such config variable '[_1]'"         => "",

    "Opening local file '[_1]' failed: [_2]" => "",
    "Renaming '[_1]' to '[_2]' failed: [_3]" => "",

    "Can't load Image::Magick: [_1]"                                    => "",
    "Can't load IPC::Run: [_1]"                                         => "",
    "'[_1]' is not a valid image."                                      => "",
    "Reading file '[_1]' failed: [_2]"                                  => "",
    "Reading image failed: [_1]"                                        => "",
    "Scaling to [_1]x[_2] failed: [_3]"                                 => "",
    "You do not have a valid path to the NetPBM tools on your machine." => "",

    "Unknown MailTransfer method '[_1]'" => "",
    "Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]"
        => "",
    "Error sending mail: [_1]" => "",
    "You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?"
        => "",
    "Exec of sendmail failed: [_1]" => "",

    "Your DataSource directory ('[_1]') does not exist." => "",
    "Tie '[_1]' failed: [_2]"                            => "",
    "Failed to generate unique ID: [_1]"                 => "",
    "Unlink of '[_1]' failed: [_2]"                      => "",

    "Connection error: [_1]" => "",

    "Parse error in template '[_1]': [_2]"    => "",
    "Build error in template '[_1]': [_2]"    => "",
    "Opening linked file '[_1]' failed: [_2]" => "",

    "Invalid Archive Type setting '[_1]'" => "",

    "No WeblogsPingURL defined in mt.cfg" => "",
    "No MTPingURL defined in mt.cfg"      => "",
    "HTTP error: [_1]"                    => "",
    "Ping error: [_1]"                    => "",

    "Can't find included template module '[_1]'"                   => "",
    "Can't find included file '[_1]'"                              => "",
    "Can't find template '[_1]'"                                   => "",
    "Can't find entry '[_1]'"                                      => "",
    "Error opening included file '[_1]': [_2]"                     => "",
    "You used a [_1] tag without any arguments."                   => "",
    "You can't use both AND and OR in the same expression ([_1])." => "",
    "No such category '[_1]'"                                      => "",
    "No such author '[_1]'"                                        => "",
    "You used an '[_1]' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an 'MTEntries' container?"
        => "",
    'You used <$MTEntryFlag$> without a flag.'            => '',
    "You used an [_1] tag without a date context set up." => "",
    "You used an '[_1]' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an 'MTComments' container?"
        => "",
    "[_1] can be used only with Daily, Weekly, or Monthly archives." => "",
    "The archive type specified in MTArchiveList ('[_1]') is not one of the chosen archive types in your blog configuration."
        => "",
    "You used an [_1] tag outside of the proper context." => "",
    "You used an [_1] tag outside of a Daily, Weekly, or Monthly context." =>
        "",
    "Invalid month format: must be YYYYMM"                         => "",
    "[_1] can be used only if you have enabled Category archives." => "",
    "You used [_1] without a query."                               => "",
    "You need a Google API key to use [_1]"                        => "",
    "You used a non-existent property from the result structure."  => "",

    "No such author with name '[_1]'" => "",
    "Birthplace '[_1]' does not match stored birthplace for this author" =>
        "",
    "Author does not have email address" => "",
    "Error sending mail ([_1]); please fix the problem, then try again to recover your password."
        => "",
    "You are not authored to log in to this blog."        => "",
    "No permissions"                                      => "",
    "Permission denied."                                  => "",
    "Load failed: [_1]"                                   => "",
    "Unknown object type [_1]"                            => "",
    "Loading object driver [_1] failed: [_2]"             => "",
    "Setting up mappings failed: [_1]"                    => "",
    "Populating blog with default templates failed: [_1]" => "",
    "Can't find default template list; where is 'default-templates.pl'?" =>
        "",
    "Invalid filename '[_1]'"       => "",
    "Reading '[_1]' failed: [_2]"   => "",
    "Thumbnail failed: [_1]"        => "",
    "Error writing to '[_1]': [_2]" => "",
    "Invalid basename '[_1]'"       => "",
    "Invalid date '[_1]'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS."
        => "",
    "Saving entry '[_1]' failed: [_2]"                             => "",
    "Removing placement failed: [_1]"                              => "",
    "Saving placement failed: [_1]"                                => "",
    "Your post was saved, but the rebuild or ping failed: [_1]"    => "",
    "Saving category failed: [_1]"                                 => "",
    "Unknown category ID '[_1]'"                                   => "",
    "You do not have permission to configure the blog"             => "",
    "Saving blog failed: [_1]"                                     => "",
    "Saving map failed: [_1]"                                      => "",
    "Parse error: [_1]"                                            => "",
    "Build error: [_1]"                                            => "",
    "No entry ID provided"                                         => "",
    "No such entry '[_1]'"                                         => "",
    "No email address for author '[_1]'"                           => "",
    "Error sending mail ([_1]); try another MailTransfer setting?" => "",
    "You did not choose a file to upload."                         => "",
    "Invalid extra path '[_1]'"                                    => "",
    "Can't make path '[_1]': [_2]"                                 => "",
    "Invalid temp file name '[_1]'"                                => "",
    "Error opening '[_1]': [_2]"                                   => "",
    "Error deleting '[_1]': [_2]"                                  => "",
    "File with name '[_1]' already exists. (Install File::Temp if you'd like to be able to overwrite existing uploaded files.)"
        => "",
    "File with name '[_1]' already exists; Tried to write to tempfile, but open failed: [_2]"
        => "",
    "Error writing upload to '[_1]': [_2]" => "",
    "Invalid temp file name '[_1]'"        => "",
    "Error deleting '[_1]': [_2]"          => "",
    "Perl module Image::Size is required to determine width and height of uploaded images."
        => "",
    "No blog ID"                          => "",
    "You do not have export permissions"  => "",
    "Export failed on entry '[_1]': [_2]" => "",
    "You need to provide a password if you are going to\ncreate authors for each author listed in your blog.\n"
        => "",
    "Can't open directory '[_1]': [_2]"   => "",
    "Can't open file '[_1]': [_2]"        => "",
    "Saving author failed: [_1]"          => "",
    "Saving permissions failed: [_1]"     => "",
    "Invalid status value '[_1]'"         => "",
    "Invalid allow comments value '[_1]'" => "",
    "Invalid convert breaks value '[_1]'" => "",
    "Saving comment failed: [_1]"         => "",
    "Invalid date format '[_1]'; must be 'MM/DD/YYYY HH:MM:SS AM|PM (AM|PM is optional)"
        => "",

    "Invalid entry ID '[_1]'"                                    => "",
    "You must define a Ping template in order to display pings." => "",
    "Need a TrackBack ID (tb_id)."                               => "",
    "Need a Source URL (url)."                                   => "",
    "Invalid TrackBack ID '[_1]'"                                => "",
    "This TrackBack item is disabled."                           => "",
    "This TrackBack item is protected by a passphrase."          => "",
    "You are not allowed to send TrackBack pings."               => "",
    "You are not allowed to post comments."                      => "",
    "Comments are not allowed on this entry."                    => "",
    "Name and email address are required."                       => "",
    "Comment text is required."                                  => "",
    "Invalid email address '[_1]'"                               => "",
    "Invalid URL '[_1]'"                                         => "",
    "Rebuild failed: [_1]"                                       => "",
    "You must define a Comment Listing template in order to display dynamic comments."
        => "",
    "You must define a Comment Error template."   => "",
    "You must define a Comment Preview template." => "",

    'Search failed: [_1]'           => '',
    'Building results failed: [_1]' => '',
    'You are currently performing a search. Please wait until your search is completed.'
        => '',
);

1;
