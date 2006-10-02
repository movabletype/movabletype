package HTML::Template;

$HTML::Template::VERSION = '2.8';

=head1 NAME

HTML::Template - Perl module to use HTML Templates from CGI scripts

=head1 SYNOPSIS

First you make a template - this is just a normal HTML file with a few
extra tags, the simplest being <TMPL_VAR>

For example, test.tmpl:

  <html>
  <head><title>Test Template</title>
  <body>
  My Home Directory is <TMPL_VAR NAME=HOME>
  <p>
  My Path is set to <TMPL_VAR NAME=PATH>
  </body>
  </html>

Now create a small CGI program:

  #!/usr/bin/perl -w
  use HTML::Template;

  # open the html template
  my $template = HTML::Template->new(filename => 'test.tmpl');

  # fill in some parameters
  $template->param(HOME => $ENV{HOME});
  $template->param(PATH => $ENV{PATH});

  # send the obligatory Content-Type and print the template output
  print "Content-Type: text/html\n\n", $template->output;

If all is well in the universe this should show something like this in
your browser when visiting the CGI:

  My Home Directory is /home/some/directory
  My Path is set to /bin;/usr/bin

=head1 DESCRIPTION

This module attempts to make using HTML templates simple and natural.
It extends standard HTML with a few new HTML-esque tags - <TMPL_VAR>,
<TMPL_LOOP>, <TMPL_INCLUDE>, <TMPL_IF>, <TMPL_ELSE> and <TMPL_UNLESS>.
The file written with HTML and these new tags is called a template.
It is usually saved separate from your script - possibly even created
by someone else!  Using this module you fill in the values for the
variables, loops and branches declared in the template.  This allows
you to separate design - the HTML - from the data, which you generate
in the Perl script.

This module is licensed under the GPL.  See the LICENSE section
below for more details.

=head1 TUTORIAL

If you're new to HTML::Template, I suggest you start with the
introductory article available on the HTML::Template website:

   http://html-template.sourceforge.net

=head1 MOTIVATION

It is true that there are a number of packages out there to do HTML
templates.  On the one hand you have things like HTML::Embperl which
allows you freely mix Perl with HTML.  On the other hand lie
home-grown variable substitution solutions.  Hopefully the module can
find a place between the two.

One advantage of this module over a full HTML::Embperl-esque solution
is that it enforces an important divide - design and programming.  By
limiting the programmer to just using simple variables and loops in
the HTML, the template remains accessible to designers and other
non-perl people.  The use of HTML-esque syntax goes further to make
the format understandable to others.  In the future this similarity
could be used to extend existing HTML editors/analyzers to support
HTML::Template.

An advantage of this module over home-grown tag-replacement schemes is
the support for loops.  In my work I am often called on to produce
tables of data in html.  Producing them using simplistic HTML
templates results in CGIs containing lots of HTML since the HTML
itself cannot represent loops.  The introduction of loop statements in
the HTML simplifies this situation considerably.  The designer can
layout a single row and the programmer can fill it in as many times as
necessary - all they must agree on is the parameter names.

For all that, I think the best thing about this module is that it does
just one thing and it does it quickly and carefully.  It doesn't try
to replace Perl and HTML, it just augments them to interact a little
better.  And it's pretty fast.

=head1 THE TAGS

=head2 TMPL_VAR

  <TMPL_VAR NAME="PARAMETER_NAME">

The <TMPL_VAR> tag is very simple.  For each <TMPL_VAR> tag in the
template you call $template->param(PARAMETER_NAME => "VALUE").  When
the template is output the <TMPL_VAR> is replaced with the VALUE text
you specified.  If you don't set a parameter it just gets skipped in
the output.

Optionally you can use the "ESCAPE=HTML" option in the tag to indicate
that you want the value to be HTML-escaped before being returned from
output (the old ESCAPE=1 syntax is still supported).  This means that
the ", <, >, and & characters get translated into &quot;, &lt;, &gt;
and &amp; respectively.  This is useful when you want to use a
TMPL_VAR in a context where those characters would cause trouble.
Example:

   <input name=param type=text value="<TMPL_VAR NAME="PARAM">">

If you called param() with a value like sam"my you'll get in trouble
with HTML's idea of a double-quote.  On the other hand, if you use
ESCAPE=HTML, like this:

   <input name=param type=text value="<TMPL_VAR ESCAPE=HTML NAME="PARAM">">

You'll get what you wanted no matter what value happens to be passed in for
param.  You can also write ESCAPE="HTML", ESCAPE='HTML' and ESCAPE='1'.
Substitute a 0 for the HTML and you turn off escaping, which is the default
anyway.

There is also the "ESCAPE=URL" option which may be used for VARs that
populate a URL.  It will do URL escaping, like replacing ' ' with '+'
and '/' with '%2F'.

There is also the "ESCAPE=JS" option which may be used for VARs that
need to be placed within a Javascript string. All \n, \r, ' and " characters
are escaped.

You can assign a default value to a variable with the DEFAULT
attribute.  For example, this will output "the devil gave me a taco"
if the "who" variable is not set.

  The <TMPL_VAR NAME=WHO DEFAULT=devil> gave me a taco.

=head2 TMPL_LOOP

  <TMPL_LOOP NAME="LOOP_NAME"> ... </TMPL_LOOP>

The <TMPL_LOOP> tag is a bit more complicated than <TMPL_VAR>.  The
<TMPL_LOOP> tag allows you to delimit a section of text and give it a
name.  Inside this named loop you place <TMPL_VAR>s.  Now you pass to
param() a list (an array ref) of parameter assignments (hash refs) for
this loop.  The loop iterates over the list and produces output from
the text block for each pass.  Unset parameters are skipped.  Here's
an example:

 In the template:

   <TMPL_LOOP NAME=EMPLOYEE_INFO>
      Name: <TMPL_VAR NAME=NAME> <br>
      Job:  <TMPL_VAR NAME=JOB>  <p>
   </TMPL_LOOP>


 In the script:

   $template->param(EMPLOYEE_INFO => [ 
                                       { name => 'Sam', job => 'programmer' },
                                       { name => 'Steve', job => 'soda jerk' },
                                     ]
                   );
   print $template->output();

  
 The output in a browser:

   Name: Sam
   Job: programmer

   Name: Steve
   Job: soda jerk

As you can see above the <TMPL_LOOP> takes a list of variable
assignments and then iterates over the loop body producing output.

Often you'll want to generate a <TMPL_LOOP>'s contents
programmatically.  Here's an example of how this can be done (many
other ways are possible!):

   # a couple of arrays of data to put in a loop:
   my @words = qw(I Am Cool);
   my @numbers = qw(1 2 3);

   my @loop_data = ();  # initialize an array to hold your loop

   while (@words and @numbers) {
     my %row_data;  # get a fresh hash for the row data

     # fill in this row
     $row_data{WORD} = shift @words;
     $row_data{NUMBER} = shift @numbers;
 
     # the crucial step - push a reference to this row into the loop!
     push(@loop_data, \%row_data);
   }

   # finally, assign the loop data to the loop param, again with a
   # reference:
   $template->param(THIS_LOOP => \@loop_data);

The above example would work with a template like:

   <TMPL_LOOP NAME="THIS_LOOP">
      Word: <TMPL_VAR NAME="WORD">     <br>
      Number: <TMPL_VAR NAME="NUMBER"> <p>
   </TMPL_LOOP>

It would produce output like:

   Word: I
   Number: 1

   Word: Am
   Number: 2

   Word: Cool
   Number: 3

<TMPL_LOOP>s within <TMPL_LOOP>s are fine and work as you would
expect.  If the syntax for the param() call has you stumped, here's an
example of a param call with one nested loop:

  $template->param(LOOP => [
                            { name => 'Bobby',
                              nicknames => [
                                            { name => 'the big bad wolf' }, 
                                            { name => 'He-Man' },
                                           ],
                            },
                           ],
                  );

Basically, each <TMPL_LOOP> gets an array reference.  Inside the array
are any number of hash references.  These hashes contain the
name=>value pairs for a single pass over the loop template.  

Inside a <TMPL_LOOP>, the only variables that are usable are the ones
from the <TMPL_LOOP>.  The variables in the outer blocks are not
visible within a template loop.  For the computer-science geeks among
you, a <TMPL_LOOP> introduces a new scope much like a perl subroutine
call.  If you want your variables to be global you can use
'global_vars' option to new() described below.

=head2 TMPL_INCLUDE

  <TMPL_INCLUDE NAME="filename.tmpl">

This tag includes a template directly into the current template at the
point where the tag is found.  The included template contents are used
exactly as if its contents were physically included in the master
template.

The file specified can be an absolute path (beginning with a '/' under
Unix, for example).  If it isn't absolute, the path to the enclosing
file is tried first.  After that the path in the environment variable
HTML_TEMPLATE_ROOT is tried, if it exists.  Next, the "path" option is
consulted, first as-is and then with HTML_TEMPLATE_ROOT prepended if
available.  As a final attempt, the filename is passed to open()
directly.  See below for more information on HTML_TEMPLATE_ROOT and
the "path" option to new().

As a protection against infinitly recursive includes, an arbitary
limit of 10 levels deep is imposed.  You can alter this limit with the
"max_includes" option.  See the entry for the "max_includes" option
below for more details.

=head2 TMPL_IF

  <TMPL_IF NAME="PARAMETER_NAME"> ... </TMPL_IF>

The <TMPL_IF> tag allows you to include or not include a block of the
template based on the value of a given parameter name.  If the
parameter is given a value that is true for Perl - like '1' - then the
block is included in the output.  If it is not defined, or given a
false value - like '0' - then it is skipped.  The parameters are
specified the same way as with TMPL_VAR.

Example Template:

   <TMPL_IF NAME="BOOL">
     Some text that only gets displayed if BOOL is true!
   </TMPL_IF>

Now if you call $template->param(BOOL => 1) then the above block will
be included by output. 

<TMPL_IF> </TMPL_IF> blocks can include any valid HTML::Template
construct - VARs and LOOPs and other IF/ELSE blocks.  Note, however,
that intersecting a <TMPL_IF> and a <TMPL_LOOP> is invalid.

   Not going to work:
   <TMPL_IF BOOL>
      <TMPL_LOOP SOME_LOOP>
   </TMPL_IF>
      </TMPL_LOOP>

If the name of a TMPL_LOOP is used in a TMPL_IF, the IF block will
output if the loop has at least one row.  Example:

  <TMPL_IF LOOP_ONE>
    This will output if the loop is not empty.
  </TMPL_IF>

  <TMPL_LOOP LOOP_ONE>
    ....
  </TMPL_LOOP>

WARNING: Much of the benefit of HTML::Template is in decoupling your
Perl and HTML.  If you introduce numerous cases where you have
TMPL_IFs and matching Perl if()s, you will create a maintenance
problem in keeping the two synchronized.  I suggest you adopt the
practice of only using TMPL_IF if you can do so without requiring a
matching if() in your Perl code.

=head2 TMPL_ELSE

  <TMPL_IF NAME="PARAMETER_NAME"> ... <TMPL_ELSE> ... </TMPL_IF>

You can include an alternate block in your TMPL_IF block by using
TMPL_ELSE.  NOTE: You still end the block with </TMPL_IF>, not
</TMPL_ELSE>!
 
   Example:

   <TMPL_IF BOOL>
     Some text that is included only if BOOL is true
   <TMPL_ELSE>
     Some text that is included only if BOOL is false
   </TMPL_IF>

=head2 TMPL_UNLESS

  <TMPL_UNLESS NAME="PARAMETER_NAME"> ... </TMPL_UNLESS>

This tag is the opposite of <TMPL_IF>.  The block is output if the
CONTROL_PARAMETER is set false or not defined.  You can use
<TMPL_ELSE> with <TMPL_UNLESS> just as you can with <TMPL_IF>.

  Example:

  <TMPL_UNLESS BOOL>
    Some text that is output only if BOOL is FALSE.
  <TMPL_ELSE>
    Some text that is output only if BOOL is TRUE.
  </TMPL_UNLESS>

If the name of a TMPL_LOOP is used in a TMPL_UNLESS, the UNLESS block
output if the loop has zero rows.

  <TMPL_UNLESS LOOP_ONE>
    This will output if the loop is empty.
  </TMPL_UNLESS>
  
  <TMPL_LOOP LOOP_ONE>
    ....
  </TMPL_LOOP>

=cut

=head2 NOTES

HTML::Template's tags are meant to mimic normal HTML tags.  However,
they are allowed to "break the rules".  Something like:

   <img src="<TMPL_VAR IMAGE_SRC>">

is not really valid HTML, but it is a perfectly valid use and will
work as planned.

The "NAME=" in the tag is optional, although for extensibility's sake I
recommend using it.  Example - "<TMPL_LOOP LOOP_NAME>" is acceptable.

If you're a fanatic about valid HTML and would like your templates
to conform to valid HTML syntax, you may optionally type template tags
in the form of HTML comments. This may be of use to HTML authors who
would like to validate their templates' HTML syntax prior to
HTML::Template processing, or who use DTD-savvy editing tools.

  <!-- TMPL_VAR NAME=PARAM1 -->

In order to realize a dramatic savings in bandwidth, the standard
(non-comment) tags will be used throughout this documentation.

=head1 METHODS

=head2 new()

Call new() to create a new Template object:

  my $template = HTML::Template->new( filename => 'file.tmpl', 
                                      option => 'value' 
                                    );

You must call new() with at least one name => value pair specifying how
to access the template text.  You can use "filename => 'file.tmpl'" to
specify a filename to be opened as the template.  Alternately you can
use:

  my $t = HTML::Template->new( scalarref => $ref_to_template_text, 
                               option => 'value' 
                             );

and

  my $t = HTML::Template->new( arrayref => $ref_to_array_of_lines , 
                               option => 'value' 
                             );


These initialize the template from in-memory resources.  In almost
every case you'll want to use the filename parameter.  If you're
worried about all the disk access from reading a template file just
use mod_perl and the cache option detailed below.

You can also read the template from an already opened filehandle,
either traditionally as a glob or as a FileHandle:

  my $t = HTML::Template->new( filehandle => *FH, option => 'value');

The four new() calling methods can also be accessed as below, if you
prefer.

  my $t = HTML::Template->new_file('file.tmpl', option => 'value');

  my $t = HTML::Template->new_scalar_ref($ref_to_template_text, 
                                        option => 'value');

  my $t = HTML::Template->new_array_ref($ref_to_array_of_lines, 
                                       option => 'value');

  my $t = HTML::Template->new_filehandle($fh, 
                                       option => 'value');

And as a final option, for those that might prefer it, you can call new as:

  my $t = HTML::Template->new(type => 'filename', 
                              source => 'file.tmpl');

Which works for all three of the source types.

If the environment variable HTML_TEMPLATE_ROOT is set and your
filename doesn't begin with /, then the path will be relative to the
value of $HTML_TEMPLATE_ROOT.  Example - if the environment variable
HTML_TEMPLATE_ROOT is set to "/home/sam" and I call
HTML::Template->new() with filename set to "sam.tmpl", the
HTML::Template will try to open "/home/sam/sam.tmpl" to access the
template file.  You can also affect the search path for files with the
"path" option to new() - see below for more information.

You can modify the Template object's behavior with new().  The options
are available:

=over 4

=item Error Detection Options

=over 4 

=item *

die_on_bad_params - if set to 0 the module will let you call
$template->param(param_name => 'value') even if 'param_name' doesn't
exist in the template body.  Defaults to 1.

=item *

strict - if set to 0 the module will allow things that look like they
might be TMPL_* tags to get by without dieing.  Example:

   <TMPL_HUH NAME=ZUH>

Would normally cause an error, but if you call new with strict => 0,
HTML::Template will ignore it.  Defaults to 1.

=item *

vanguard_compatibility_mode - if set to 1 the module will expect to
see <TMPL_VAR>s that look like %NAME% in addition to the standard
syntax.  Also sets die_on_bad_params => 0.  If you're not at Vanguard
Media trying to use an old format template don't worry about this one.
Defaults to 0.

=back

=item Caching Options

=over 4

=item *

cache - if set to 1 the module will cache in memory the parsed
templates based on the filename parameter and modification date of the
file.  This only applies to templates opened with the filename
parameter specified, not scalarref or arrayref templates.  Caching
also looks at the modification times of any files included using
<TMPL_INCLUDE> tags, but again, only if the template is opened with
filename parameter.  

This is mainly of use in a persistent environment like
Apache/mod_perl.  It has absolutely no benefit in a normal CGI
environment since the script is unloaded from memory after every
request.  For a cache that does work for normal CGIs see the
'shared_cache' option below.

Note that different new() parameter settings do not cause a cache
refresh, only a change in the modification time of the template will
trigger a cache refresh.  For most usages this is fine.  My simplistic
testing shows that using cache yields a 90% performance increase under
mod_perl.  Cache defaults to 0.

=item *

shared_cache - if set to 1 the module will store its cache in shared
memory using the IPC::SharedCache module (available from CPAN).  The
effect of this will be to maintain a single shared copy of each parsed
template for all instances of HTML::Template to use.  This can be a
significant reduction in memory usage in a multiple server
environment.  As an example, on one of our systems we use 4MB of
template cache and maintain 25 httpd processes - shared_cache results
in saving almost 100MB!  Of course, some reduction in speed versus
normal caching is to be expected.  Another difference between normal
caching and shared_cache is that shared_cache will work in a CGI
environment - normal caching is only useful in a persistent
environment like Apache/mod_perl.

By default HTML::Template uses the IPC key 'TMPL' as a shared root
segment (0x4c504d54 in hex), but this can be changed by setting the
'ipc_key' new() parameter to another 4-character or integer key.
Other options can be used to affect the shared memory cache correspond
to IPC::SharedCache options - ipc_mode, ipc_segment_size and
ipc_max_size.  See L<IPC::SharedCache> for a description of how these
work - in most cases you shouldn't need to change them from the
defaults.

For more information about the shared memory cache system used by
HTML::Template see L<IPC::SharedCache>.

=item *

double_cache - if set to 1 the module will use a combination of
shared_cache and normal cache mode for the best possible caching.  Of
course, it also uses the most memory of all the cache modes.  All the
same ipc_* options that work with shared_cache apply to double_cache
as well.  By default double_cache is off.

=item *

blind_cache - if set to 1 the module behaves exactly as with normal
caching but does not check to see if the file has changed on each
request.  This option should be used with caution, but could be of use
on high-load servers.  My tests show blind_cache performing only 1 to
2 percent faster than cache under mod_perl.

NOTE: Combining this option with shared_cache can result in stale
templates stuck permanently in shared memory!

=item *

file_cache - if set to 1 the module will store its cache in a file
using the Storable module.  It uses no additional memory, and my
simplistic testing shows that it yields a 50% performance advantage.
Like shared_cache, it will work in a CGI environment. Default is 0.

If you set this option you must set the "file_cache_dir" option.  See
below for details.

NOTE: Storable using flock() to ensure safe access to cache files.
Using file_cache on a system or filesystem (NFS) without flock()
support is dangerous.


=item *

file_cache_dir - sets the directory where the module will store the
cache files if file_cache is enabled.  Your script will need write
permissions to this directory.  You'll also need to make sure the
sufficient space is available to store the cache files.

=item *

file_cache_dir_mode - sets the file mode for newly created file_cache
directories and subdirectories.  Defaults to 0700 for security but
this may be inconvenient if you do not have access to the account
running the webserver.

=item *

double_file_cache - if set to 1 the module will use a combination of
file_cache and normal cache mode for the best possible caching.  The
file_cache_* options that work with file_cache apply to double_file_cache
as well.  By default double_file_cache is 0.

=back

=item Filesystem Options

=over 4

=item *

path - you can set this variable with a list of paths to search for
files specified with the "filename" option to new() and for files
included with the <TMPL_INCLUDE> tag.  This list is only consulted
when the filename is relative.  The HTML_TEMPLATE_ROOT environment
variable is always tried first if it exists.  Also, if
HTML_TEMPLATE_ROOT is set then an attempt will be made to prepend
HTML_TEMPLATE_ROOT onto paths in the path array.  In the case of a
<TMPL_INCLUDE> file, the path to the including file is also tried
before path is consulted.

Example:

   my $template = HTML::Template->new( filename => 'file.tmpl',
                                       path => [ '/path/to/templates',
                                                 '/alternate/path'
                                               ]
                                      );

NOTE: the paths in the path list must be expressed as UNIX paths,
separated by the forward-slash character ('/').

=item *

search_path_on_include - if set to a true value the module will search
from the top of the array of paths specified by the path option on
every <TMPL_INCLUDE> and use the first matching template found.  The
normal behavior is to look only in the current directory for a
template to include.  Defaults to 0.

=back

=item Debugging Options

=over 4

=item *

debug - if set to 1 the module will write random debugging information
to STDERR.  Defaults to 0.

=item *

stack_debug - if set to 1 the module will use Data::Dumper to print
out the contents of the parse_stack to STDERR.  Defaults to 0.

=item *

cache_debug - if set to 1 the module will send information on cache
loads, hits and misses to STDERR.  Defaults to 0.

=item *

shared_cache_debug - if set to 1 the module will turn on the debug
option in IPC::SharedCache - see L<IPC::SharedCache> for
details. Defaults to 0.

=item *

memory_debug - if set to 1 the module will send information on cache
memory usage to STDERR.  Requires the GTop module.  Defaults to 0.

=back

=item Miscellaneous Options

=over 4

=item *

associate - this option allows you to inherit the parameter values
from other objects.  The only requirement for the other object is that
it have a param() method that works like HTML::Template's param().  A
good candidate would be a CGI.pm query object.  Example:

  my $query = new CGI;
  my $template = HTML::Template->new(filename => 'template.tmpl',
                                     associate => $query);

Now, $template->output() will act as though 

  $template->param('FormField', $cgi->param('FormField'));

had been specified for each key/value pair that would be provided by
the $cgi->param() method.  Parameters you set directly take precedence
over associated parameters.  

You can specify multiple objects to associate by passing an anonymous
array to the associate option.  They are searched for parameters in
the order they appear:

  my $template = HTML::Template->new(filename => 'template.tmpl',
                                     associate => [$query, $other_obj]);

The old associateCGI() call is still supported, but should be
considered obsolete.

NOTE: The parameter names are matched in a case-insensitve manner.  If
you have two parameters in a CGI object like 'NAME' and 'Name' one
will be chosen randomly by associate.  This behavior can be changed by
the following option.

=item *

case_sensitive - setting this option to true causes HTML::Template to
treat template variable names case-sensitively.  The following example
would only set one parameter without the "case_sensitive" option:

  my $template = HTML::Template->new(filename => 'template.tmpl',
                                     case_sensitive => 1);
  $template->param(
    FieldA => 'foo',
    fIELDa => 'bar',
  );

This option defaults to off.

NOTE: with case_sensitive and loop_context_vars the special loop
variables are available in lower-case only.

=item *

loop_context_vars - when this parameter is set to true (it is false by
default) four loop context variables are made available inside a loop:
__first__, __last__, __inner__, __odd__.  They can be used with
<TMPL_IF>, <TMPL_UNLESS> and <TMPL_ELSE> to control how a loop is
output.  

In addition to the above, a __counter__ var is also made available
when loop context variables are turned on.

Example:

   <TMPL_LOOP NAME="FOO">
      <TMPL_IF NAME="__first__">
        This only outputs on the first pass.
      </TMPL_IF>

      <TMPL_IF NAME="__odd__">
        This outputs every other pass, on the odd passes.
      </TMPL_IF>

      <TMPL_UNLESS NAME="__odd__">
        This outputs every other pass, on the even passes.
      </TMPL_UNLESS>

      <TMPL_IF NAME="__inner__">
        This outputs on passes that are neither first nor last.
      </TMPL_IF>

      This is pass number <TMPL_VAR NAME="__counter__">.

      <TMPL_IF NAME="__last__">
        This only outputs on the last pass.
      </TMPL_IF>
   </TMPL_LOOP>

One use of this feature is to provide a "separator" similar in effect
to the perl function join().  Example:

   <TMPL_LOOP FRUIT>
      <TMPL_IF __last__> and </TMPL_IF>
      <TMPL_VAR KIND><TMPL_UNLESS __last__>, <TMPL_ELSE>.</TMPL_UNLESS>
   </TMPL_LOOP>

Would output (in a browser) something like:

  Apples, Oranges, Brains, Toes, and Kiwi.

Given an appropriate param() call, of course.  NOTE: A loop with only
a single pass will get both __first__ and __last__ set to true, but
not __inner__.

=item *

no_includes - set this option to 1 to disallow the <TMPL_INCLUDE> tag
in the template file.  This can be used to make opening untrusted
templates B<slightly> less dangerous.  Defaults to 0.

=item *

max_includes - set this variable to determine the maximum depth that
includes can reach.  Set to 10 by default.  Including files to a depth
greater than this value causes an error message to be displayed.  Set
to 0 to disable this protection.

=item *

global_vars - normally variables declared outside a loop are not
available inside a loop.  This option makes <TMPL_VAR>s like global
variables in Perl - they have unlimited scope.  This option also
affects <TMPL_IF> and <TMPL_UNLESS>.

Example:

  This is a normal variable: <TMPL_VAR NORMAL>.<P>

  <TMPL_LOOP NAME=FROOT_LOOP>
     Here it is inside the loop: <TMPL_VAR NORMAL><P>
  </TMPL_LOOP>

Normally this wouldn't work as expected, since <TMPL_VAR NORMAL>'s
value outside the loop is not available inside the loop.

The global_vars option also allows you to access the values of an
enclosing loop within an inner loop.  For example, in this loop the
inner loop will have access to the value of OUTER_VAR in the correct
iteration:

   <TMPL_LOOP OUTER_LOOP>
      OUTER: <TMPL_VAR OUTER_VAR>
        <TMPL_LOOP INNER_LOOP>
           INNER: <TMPL_VAR INNER_VAR>
           INSIDE OUT: <TMPL_VAR OUTER_VAR>
        </TMPL_LOOP>
   </TMPL_LOOP>

B<NOTE>: C<global_vars> is not C<global_loops> (which does not exist).
That means that loops you declare at one scope are not available
inside other loops even when C<global_vars> is on.

=item *

filter - this option allows you to specify a filter for your template
files.  A filter is a subroutine that will be called after
HTML::Template reads your template file but before it starts parsing
template tags.

In the most simple usage, you simply assign a code reference to the
filter parameter.  This subroutine will recieve a single arguement - a
reference to a string containing the template file text.  Here is an
example that accepts templates with tags that look like "!!!ZAP_VAR
FOO!!!" and transforms them into HTML::Template tags:

   my $filter = sub {
     my $text_ref = shift;
     $$text_ref =~ s/!!!ZAP_(.*?)!!!/<TMPL_$1>/g;
   };

   # open zap.tmpl using the above filter
   my $template = HTML::Template->new(filename => 'zap.tmpl',
                                      filter => $filter);

More complicated usages are possible.  You can request that your
filter receieve the template text as an array of lines rather than as
a single scalar.  To do that you need to specify your filter using a
hash-ref.  In this form you specify the filter using the "sub" key and
the desired argument format using the "format" key.  The available
formats are "scalar" and "array".  Using the "array" format will incur
a performance penalty but may be more convenient in some situations.

   my $template = HTML::Template->new(filename => 'zap.tmpl',
                                      filter => { sub => $filter,
                                                  format => 'array' });

You may also have multiple filters.  This allows simple filters to be
combined for more elaborate functionality.  To do this you specify an
array of filters.  The filters are applied in the order they are
specified.

   my $template = HTML::Template->new(filename => 'zap.tmpl',
                                      filter => [ 
                                           { sub => \&decompress,
                                             format => 'scalar' },
                                           { sub => \&remove_spaces,
                                             format => 'array' }
                                        ]);

The specified filters will be called for any TMPL_INCLUDEed files just
as they are for the main template file.

=item * 

default_escape - Set this parameter to "HTML", "URL" or "JS" and
HTML::Template will apply the specified escaping to all variables
unless they declare a different escape in the template.

=back

=back 4

=cut


use integer; # no floating point math so far!
use strict; # and no funny business, either.

use Carp; # generate better errors with more context
use File::Spec; # generate paths that work on all platforms
## Removing 'use' to allow module to work with basic 5.6.x install
## use Digest::MD5 qw(md5_hex); # generate cache keys

# define accessor constants used to improve readability of array
# accesses into "objects".  I used to use 'use constant' but that
# seems to cause occasional irritating warnings in older Perls.
package HTML::Template::LOOP;
sub TEMPLATE_HASH () { 0 };
sub PARAM_SET     () { 1 };

package HTML::Template::COND;
sub VARIABLE           () { 0 };
sub VARIABLE_TYPE      () { 1 };
sub VARIABLE_TYPE_VAR  () { 0 };
sub VARIABLE_TYPE_LOOP () { 1 };
sub JUMP_IF_TRUE       () { 2 };
sub JUMP_ADDRESS       () { 3 };
sub WHICH              () { 4 };
sub UNCONDITIONAL_JUMP () { 5 };
sub IS_ELSE            () { 6 };
sub WHICH_IF           () { 0 };
sub WHICH_UNLESS       () { 1 };

# back to the main package scope.
package HTML::Template;

# open a new template and return an object handle
sub new {
  my $pkg = shift;
  my $self; { my %hash; $self = bless(\%hash, $pkg); }

  # the options hash
  my $options = {};
  $self->{options} = $options;

  # set default parameters in options hash
  %$options = (
               debug => 0,
               stack_debug => 0,
               timing => 0,
               search_path_on_include => 0,
               cache => 0,               
               blind_cache => 0,
	       file_cache => 0,
	       file_cache_dir => '',
	       file_cache_dir_mode => 0700,
               cache_debug => 0,
               shared_cache_debug => 0,
               memory_debug => 0,
               die_on_bad_params => 1,
               vanguard_compatibility_mode => 0,
               associate => [],
               path => [],
               strict => 1,
               loop_context_vars => 0,
               max_includes => 10,
               shared_cache => 0,
               double_cache => 0,
               double_file_cache => 0,
               ipc_key => 'TMPL',
               ipc_mode => 0666,
               ipc_segment_size => 65536,
               ipc_max_size => 0,
               global_vars => 0,
               no_includes => 0,
               case_sensitive => 0,
               filter => [],
               default_escape => undef,
              );
  
  # load in options supplied to new()
  for (my $x = 0; $x <= $#_; $x += 2) {
    defined($_[($x + 1)]) or croak("HTML::Template->new() called with odd number of option parameters - should be of the form option => value");
    $options->{lc($_[$x])} = $_[($x + 1)]; 
  }

  # blind_cache = 1 implies cache = 1
  $options->{blind_cache} and $options->{cache} = 1;

  # shared_cache = 1 implies cache = 1
  $options->{shared_cache} and $options->{cache} = 1;

  # file_cache = 1 implies cache = 1
  $options->{file_cache} and $options->{cache} = 1;

  # double_cache is a combination of shared_cache and cache.
  $options->{double_cache} and $options->{cache} = 1;
  $options->{double_cache} and $options->{shared_cache} = 1;

  # double_file_cache is a combination of file_cache and cache.
  $options->{double_file_cache} and $options->{cache} = 1;
  $options->{double_file_cache} and $options->{file_cache} = 1;

  # vanguard_compatibility_mode implies die_on_bad_params = 0
  $options->{vanguard_compatibility_mode} and 
    $options->{die_on_bad_params} = 0;

  # handle the "type", "source" parameter format (does anyone use it?)
  if (exists($options->{type})) {
    exists($options->{source}) or croak("HTML::Template->new() called with 'type' parameter set, but no 'source'!");
    ($options->{type} eq 'filename' or $options->{type} eq 'scalarref' or
     $options->{type} eq 'arrayref' or $options->{type} eq 'filehandle') or
       croak("HTML::Template->new() : type parameter must be set to 'filename', 'arrayref', 'scalarref' or 'filehandle'!");

    $options->{$options->{type}} = $options->{source};
    delete $options->{type};
    delete $options->{source};
  }

  # associate should be an array of one element if it's not
  # already an array.
  if (ref($options->{associate}) ne 'ARRAY') {
    $options->{associate} = [ $options->{associate} ];
  }

  # path should be an array if it's not already
  if (ref($options->{path}) ne 'ARRAY') {
    $options->{path} = [ $options->{path} ];
  }

  # filter should be an array if it's not already
  if (ref($options->{filter}) ne 'ARRAY') {
    $options->{filter} = [ $options->{filter} ];
  }
  
  # make sure objects in associate area support param()
  foreach my $object (@{$options->{associate}}) {
    defined($object->can('param')) or
      croak("HTML::Template->new called with associate option, containing object of type " . ref($object) . " which lacks a param() method!");
  } 

  # check for syntax errors:
  my $source_count = 0;
  exists($options->{filename}) and $source_count++;
  exists($options->{filehandle}) and $source_count++;
  exists($options->{arrayref}) and $source_count++;
  exists($options->{scalarref}) and $source_count++;
  if ($source_count != 1) {
    croak("HTML::Template->new called with multiple (or no) template sources specified!  A valid call to new() has exactly one filename => 'file' OR exactly one scalarref => \\\$scalar OR exactly one arrayref => \\\@array OR exactly one filehandle => \*FH");
  }

  # check that filenames aren't empty
  if (exists($options->{filename})) {
      croak("HTML::Template->new called with empty filename parameter!")
        unless defined $options->{filename} and length $options->{filename};
  }

  # do some memory debugging - this is best started as early as possible
  if ($options->{memory_debug}) {
    # memory_debug needs GTop
    eval { require GTop; };
    croak("Could not load GTop.  You must have GTop installed to use HTML::Template in memory_debug mode.  The error was: $@")
      if ($@);
    $self->{gtop} = GTop->new();
    $self->{proc_mem} = $self->{gtop}->proc_mem($$);
    print STDERR "\n### HTML::Template Memory Debug ### START ", $self->{proc_mem}->size(), "\n";
  }

  if ($options->{file_cache}) {
    # make sure we have a file_cache_dir option
    croak("You must specify the file_cache_dir option if you want to use file_cache.") 
      unless defined $options->{file_cache_dir} and 
        length $options->{file_cache_dir};

    # file_cache needs some extra modules loaded
    eval { require Storable; };
    croak("Could not load Storable.  You must have Storable installed to use HTML::Template in file_cache mode.  The error was: $@")
      if ($@);
  }

  if ($options->{shared_cache}) {
    # shared_cache needs some extra modules loaded
    eval { require IPC::SharedCache; };
    croak("Could not load IPC::SharedCache.  You must have IPC::SharedCache installed to use HTML::Template in shared_cache mode.  The error was: $@")
      if ($@);

    # initialize the shared cache
    my %cache;
    tie %cache, 'IPC::SharedCache',
      ipc_key => $options->{ipc_key},
      load_callback => [\&_load_shared_cache, $self],
      validate_callback => [\&_validate_shared_cache, $self],
      debug => $options->{shared_cache_debug},
      ipc_mode => $options->{ipc_mode},
      max_size => $options->{ipc_max_size},
      ipc_segment_size => $options->{ipc_segment_size};
    $self->{cache} = \%cache;
  }

  if ($options->{default_escape}) {
    $options->{default_escape} = uc $options->{default_escape};
    unless ($options->{default_escape} =~ /^(HTML|URL|JS)$/) {
      croak("HTML::Template->new(): Invalid setting for default_escape - '$options->{default_escape}'.  Valid values are HTML, URL or JS.");
    }
  }

  print STDERR "### HTML::Template Memory Debug ### POST CACHE INIT ", $self->{proc_mem}->size(), "\n"
    if $options->{memory_debug};

  # initialize data structures
  $self->_init;
  
  print STDERR "### HTML::Template Memory Debug ### POST _INIT CALL ", $self->{proc_mem}->size(), "\n"
    if $options->{memory_debug};
  
  # drop the shared cache - leaving out this step results in the
  # template object evading garbage collection since the callbacks in
  # the shared cache tie hold references to $self!  This was not easy
  # to find, by the way.
  delete $self->{cache} if $options->{shared_cache};

  return $self;
}

# an internally used new that receives its parse_stack and param_map as input
sub _new_from_loop {
  my $pkg = shift;
  my $self; { my %hash; $self = bless(\%hash, $pkg); }

  # the options hash
  my $options = {};
  $self->{options} = $options;

  # set default parameters in options hash - a subset of the options
  # valid in a normal new().  Since _new_from_loop never calls _init,
  # many options have no relevance.
  %$options = (
               debug => 0,
               stack_debug => 0,
               die_on_bad_params => 1,
               associate => [],
               loop_context_vars => 0,
              );
  
  # load in options supplied to new()
  for (my $x = 0; $x <= $#_; $x += 2) { 
    defined($_[($x + 1)]) or croak("HTML::Template->new() called with odd number of option parameters - should be of the form option => value");
    $options->{lc($_[$x])} = $_[($x + 1)]; 
  }

  $self->{param_map} = $options->{param_map};
  $self->{parse_stack} = $options->{parse_stack};
  delete($options->{param_map});
  delete($options->{parse_stack});

  return $self;
}

# a few shortcuts to new(), of possible use...
sub new_file {
  my $pkg = shift; return $pkg->new('filename', @_);
}
sub new_filehandle {
  my $pkg = shift; return $pkg->new('filehandle', @_);
}
sub new_array_ref {
  my $pkg = shift; return $pkg->new('arrayref', @_);
}
sub new_scalar_ref {
  my $pkg = shift; return $pkg->new('scalarref', @_);
}

# initializes all the object data structures, either from cache or by
# calling the appropriate routines.
sub _init {
  my $self = shift;
  my $options = $self->{options};

  if ($options->{double_cache}) {
    # try the normal cache, return if we have it.
    $self->_fetch_from_cache();
    return if (defined $self->{param_map} and defined $self->{parse_stack});

    # try the shared cache
    $self->_fetch_from_shared_cache();

    # put it in the local cache if we got it.
    $self->_commit_to_cache()
      if (defined $self->{param_map} and defined $self->{parse_stack});
  } elsif ($options->{double_file_cache}) {
    # try the normal cache, return if we have it.
    $self->_fetch_from_cache();
    return if (defined $self->{param_map} and defined $self->{parse_stack});

    # try the file cache
    $self->_fetch_from_file_cache();

    # put it in the local cache if we got it.
    $self->_commit_to_cache()
      if (defined $self->{param_map} and defined $self->{parse_stack});
  } elsif ($options->{shared_cache}) {
    # try the shared cache
    $self->_fetch_from_shared_cache();
  } elsif ($options->{file_cache}) {
    # try the file cache
    $self->_fetch_from_file_cache();
  } elsif ($options->{cache}) {
    # try the normal cache
    $self->_fetch_from_cache();
  }
  
  # if we got a cache hit, return
  return if (defined $self->{param_map} and defined $self->{parse_stack});

  # if we're here, then we didn't get a cached copy, so do a full
  # init.
  $self->_init_template();
  $self->_parse();

  # now that we have a full init, cache the structures if cacheing is
  # on.  shared cache is already cool.
  if($options->{file_cache}){
    $self->_commit_to_file_cache();
  }
  $self->_commit_to_cache() if (($options->{cache}
                                and not $options->{shared_cache}
				and not $options->{file_cache}) or
                                ($options->{double_cache}) or
				($options->{double_file_cache}));
}

# Caching subroutines - they handle getting and validating cache
# records from either the in-memory or shared caches.

# handles the normal in memory cache
use vars qw( %CACHE );
sub _fetch_from_cache {
  my $self = shift;
  my $options = $self->{options};

  # return if there's no file here
  return unless exists($options->{filename});
  my $filepath = $self->_find_file($options->{filename});
  return unless (defined($filepath));
  $options->{filepath} = $filepath;

  # return if there's no cache entry for this key
  my $key = $self->_cache_key();
  return unless exists($CACHE{$key});  
  
  # validate the cache
  my $mtime = $self->_mtime($filepath);  
  if (defined $mtime) {
    # return if the mtime doesn't match the cache
    if (defined($CACHE{$key}{mtime}) and 
        ($mtime != $CACHE{$key}{mtime})) {
      $options->{cache_debug} and 
        print STDERR "CACHE MISS : $filepath : $mtime\n";
      return;
    }

    # if the template has includes, check each included file's mtime
    # and return if different
    if (exists($CACHE{$key}{included_mtimes})) {
      foreach my $filename (keys %{$CACHE{$key}{included_mtimes}}) {
        next unless 
          defined($CACHE{$key}{included_mtimes}{$filename});
        
        my $included_mtime = (stat($filename))[9];
        if ($included_mtime != $CACHE{$key}{included_mtimes}{$filename}) {
          $options->{cache_debug} and 
            print STDERR "### HTML::Template Cache Debug ### CACHE MISS : $filepath : INCLUDE $filename : $included_mtime\n";
          
          return;
        }
      }
    }
  }

  # got a cache hit!
  
  $options->{cache_debug} and print STDERR "### HTML::Template Cache Debug ### CACHE HIT : $filepath => $key\n";
      
  $self->{param_map} = $CACHE{$key}{param_map};
  $self->{parse_stack} = $CACHE{$key}{parse_stack};
  exists($CACHE{$key}{included_mtimes}) and
    $self->{included_mtimes} = $CACHE{$key}{included_mtimes};

  # clear out values from param_map from last run
  $self->_normalize_options();
  $self->clear_params();
}

sub _commit_to_cache {
  my $self     = shift;
  my $options  = $self->{options};
  my $key      = $self->_cache_key();
  my $filepath = $options->{filepath};

  $options->{cache_debug} and print STDERR "### HTML::Template Cache Debug ### CACHE LOAD : $filepath => $key\n";
    
  $options->{blind_cache} or
    $CACHE{$key}{mtime} = $self->_mtime($filepath);
  $CACHE{$key}{param_map} = $self->{param_map};
  $CACHE{$key}{parse_stack} = $self->{parse_stack};
  exists($self->{included_mtimes}) and
    $CACHE{$key}{included_mtimes} = $self->{included_mtimes};
}

# create a cache key from a template object.  The cache key includes
# the full path to the template and options which affect template
# loading.  Has the side-effect of loading $self->{options}{filepath}
sub _cache_key {
    my $self = shift;
    my $options = $self->{options};

    # determine path to file unless already known
    my $filepath = $options->{filepath};
    if (not defined $filepath) {
        $filepath = $self->_find_file($options->{filename});
        confess("HTML::Template->new() : Cannot find file '$options->{filename}'.")
          unless defined($filepath);
        $options->{filepath} = $filepath;   
    }

    # assemble pieces of the key
    my @key = ($filepath);
    push(@key, @{$options->{path}}) if $options->{path};
    push(@key, $options->{search_path_on_include} || 0);
    push(@key, $options->{loop_context_vars} || 0);
    push(@key, $options->{global_vars} || 0);

    # compute the md5 and return it
    require Digest::MD5;
    return Digest::MD5::md5_hex(@key);
}

# generates MD5 from filepath to determine filename for cache file
sub _get_cache_filename {
  my ($self, $filepath) = @_;

  # get a cache key
  $self->{options}{filepath} = $filepath;
  my $hash = $self->_cache_key();
  
  # ... and build a path out of it.  Using the first two charcters
  # gives us 255 buckets.  This means you can have 255,000 templates
  # in the cache before any one directory gets over a few thousand
  # files in it.  That's probably pretty good for this planet.  If not
  # then it should be configurable.
  if (wantarray) {
    return (substr($hash,0,2), substr($hash,2))
  } else {
    return File::Spec->join($self->{options}{file_cache_dir}, 
                            substr($hash,0,2), substr($hash,2));
  }
}

# handles the file cache
sub _fetch_from_file_cache {
  my $self = shift;
  my $options = $self->{options};
  return unless exists($options->{filename});
  
  # return if there's no cache entry for this filename
  my $filepath = $self->_find_file($options->{filename});
  return unless defined $filepath;
  my $cache_filename = $self->_get_cache_filename($filepath);
  return unless -e $cache_filename;
  
  eval {
    $self->{record} = Storable::lock_retrieve($cache_filename);
  };
  croak("HTML::Template::new() - Problem reading cache file $cache_filename (file_cache => 1) : $@")
    if $@;
  croak("HTML::Template::new() - Problem reading cache file $cache_filename (file_cache => 1) : $!") 
    unless defined $self->{record};

  ($self->{mtime}, 
   $self->{included_mtimes}, 
   $self->{param_map}, 
   $self->{parse_stack}) = @{$self->{record}};
  
  $options->{filepath} = $filepath;

  # validate the cache
  my $mtime = $self->_mtime($filepath);
  if (defined $mtime) {
    # return if the mtime doesn't match the cache
    if (defined($self->{mtime}) and 
        ($mtime != $self->{mtime})) {
      $options->{cache_debug} and 
        print STDERR "### HTML::Template Cache Debug ### FILE CACHE MISS : $filepath : $mtime\n";
      ($self->{mtime}, 
       $self->{included_mtimes}, 
       $self->{param_map}, 
       $self->{parse_stack}) = (undef, undef, undef, undef);
      return;
    }

    # if the template has includes, check each included file's mtime
    # and return if different
    if (exists($self->{included_mtimes})) {
      foreach my $filename (keys %{$self->{included_mtimes}}) {
        next unless 
          defined($self->{included_mtimes}{$filename});
        
        my $included_mtime = (stat($filename))[9];
        if ($included_mtime != $self->{included_mtimes}{$filename}) {
          $options->{cache_debug} and 
            print STDERR "### HTML::Template Cache Debug ### FILE CACHE MISS : $filepath : INCLUDE $filename : $included_mtime\n";
          ($self->{mtime}, 
           $self->{included_mtimes}, 
           $self->{param_map}, 
           $self->{parse_stack}) = (undef, undef, undef, undef);
          return;
        }
      }
    }
  }

  # got a cache hit!
  $options->{cache_debug} and print STDERR "### HTML::Template Cache Debug ### FILE CACHE HIT : $filepath\n";

  # clear out values from param_map from last run
  $self->_normalize_options();
  $self->clear_params();
}

sub _commit_to_file_cache {
  my $self = shift;
  my $options = $self->{options};

  my $filepath = $options->{filepath};
  if (not defined $filepath) {
    $filepath = $self->_find_file($options->{filename});
    confess("HTML::Template->new() : Cannot open included file $options->{filename} : file not found.")
      unless defined($filepath);
    $options->{filepath} = $filepath;   
  }

  my ($cache_dir, $cache_file) = $self->_get_cache_filename($filepath);  
  $cache_dir = File::Spec->join($options->{file_cache_dir}, $cache_dir);
  if (not -d $cache_dir) {
    if (not -d $options->{file_cache_dir}) {
      mkdir($options->{file_cache_dir},$options->{file_cache_dir_mode})
	or croak("HTML::Template->new() : can't mkdir $options->{file_cache_dir} (file_cache => 1): $!");
    }
    mkdir($cache_dir,$options->{file_cache_dir_mode})
      or croak("HTML::Template->new() : can't mkdir $cache_dir (file_cache => 1): $!");
  }

  $options->{cache_debug} and print STDERR "### HTML::Template Cache Debug ### FILE CACHE LOAD : $options->{filepath}\n";

  my $result;
  eval {
    $result = Storable::lock_store([ $self->{mtime},
                                     $self->{included_mtimes}, 
                                     $self->{param_map}, 
                                     $self->{parse_stack} ],
                                   scalar File::Spec->join($cache_dir, $cache_file)
                                  );
  };
  croak("HTML::Template::new() - Problem writing cache file $cache_dir/$cache_file (file_cache => 1) : $@")
    if $@;
  croak("HTML::Template::new() - Problem writing cache file $cache_dir/$cache_file (file_cache => 1) : $!")
    unless defined $result;
}

# Shared cache routines.
sub _fetch_from_shared_cache {
  my $self = shift;
  my $options = $self->{options};

  my $filepath = $self->_find_file($options->{filename});
  return unless defined $filepath;

  # fetch from the shared cache.
  $self->{record} = $self->{cache}{$filepath};
  
  ($self->{mtime}, 
   $self->{included_mtimes}, 
   $self->{param_map}, 
   $self->{parse_stack}) = @{$self->{record}}
     if defined($self->{record});
  
  $options->{cache_debug} and defined($self->{record}) and print STDERR "### HTML::Template Cache Debug ### CACHE HIT : $filepath\n";
  # clear out values from param_map from last run
  $self->_normalize_options(), $self->clear_params()
    if (defined($self->{record}));
  delete($self->{record});

  return $self;
}

sub _validate_shared_cache {
  my ($self, $filename, $record) = @_;
  my $options = $self->{options};

  $options->{shared_cache_debug} and print STDERR "### HTML::Template Cache Debug ### SHARED CACHE VALIDATE : $filename\n";

  return 1 if $options->{blind_cache};

  my ($c_mtime, $included_mtimes, $param_map, $parse_stack) = @$record;

  # if the modification time has changed return false
  my $mtime = $self->_mtime($filename);
  if (defined $mtime and defined $c_mtime
      and $mtime != $c_mtime) {
    $options->{cache_debug} and 
      print STDERR "### HTML::Template Cache Debug ### SHARED CACHE MISS : $filename : $mtime\n";
    return 0;
  }

  # if the template has includes, check each included file's mtime
  # and return false if different
  if (defined $mtime and defined $included_mtimes) {
    foreach my $fname (keys %$included_mtimes) {
      next unless defined($included_mtimes->{$fname});
      if ($included_mtimes->{$fname} != (stat($fname))[9]) {
        $options->{cache_debug} and 
          print STDERR "### HTML::Template Cache Debug ### SHARED CACHE MISS : $filename : INCLUDE $fname\n";
        return 0;
      }
    }
  }

  # all done - return true
  return 1;
}

sub _load_shared_cache {
  my ($self, $filename) = @_;
  my $options = $self->{options};
  my $cache = $self->{cache};
  
  $self->_init_template();
  $self->_parse();

  $options->{cache_debug} and print STDERR "### HTML::Template Cache Debug ### SHARED CACHE LOAD : $options->{filepath}\n";
  
  print STDERR "### HTML::Template Memory Debug ### END CACHE LOAD ", $self->{proc_mem}->size(), "\n"
    if $options->{memory_debug};

  return [ $self->{mtime},
           $self->{included_mtimes}, 
           $self->{param_map}, 
           $self->{parse_stack} ]; 
}

# utility function - given a filename performs documented search and
# returns a full path of undef if the file cannot be found.
sub _find_file {
  my ($self, $filename, $extra_path) = @_;
  my $options = $self->{options};
  my $filepath;

  # first check for a full path
  return File::Spec->canonpath($filename)
    if (File::Spec->file_name_is_absolute($filename) and (-e $filename));

  # try the extra_path if one was specified
  if (defined($extra_path)) {
    $extra_path->[$#{$extra_path}] = $filename;
    $filepath = File::Spec->canonpath(File::Spec->catfile(@$extra_path));
    return File::Spec->canonpath($filepath) if -e $filepath;
  }

  # try pre-prending HTML_Template_Root
  if (exists($ENV{HTML_TEMPLATE_ROOT}) and defined($ENV{HTML_TEMPLATE_ROOT})) {
    $filepath =  File::Spec->catfile($ENV{HTML_TEMPLATE_ROOT}, $filename);
    return File::Spec->canonpath($filepath) if -e $filepath;
  }

  # try "path" option list..
  foreach my $path (@{$options->{path}}) {
    $filepath = File::Spec->catfile($path, $filename);
    return File::Spec->canonpath($filepath) if -e $filepath;
  }

  # try even a relative path from the current directory...
  return File::Spec->canonpath($filename) if -e $filename;

  # try "path" option list with HTML_TEMPLATE_ROOT prepended...
  if (exists($ENV{HTML_TEMPLATE_ROOT})) {
    foreach my $path (@{$options->{path}}) {
      $filepath = File::Spec->catfile($ENV{HTML_TEMPLATE_ROOT}, $path, $filename);
      return File::Spec->canonpath($filepath) if -e $filepath;
    }
  }
  
  return undef;
}

# utility function - computes the mtime for $filename
sub _mtime {
  my ($self, $filepath) = @_;
  my $options = $self->{options};
  
  return(undef) if ($options->{blind_cache});

  # make sure it still exists in the filesystem 
  (-r $filepath) or Carp::confess("HTML::Template : template file $filepath does not exist or is unreadable.");
  
  # get the modification time
  return (stat(_))[9];
}

# utility function - enforces new() options across LOOPs that have
# come from a cache.  Otherwise they would have stale options hashes.
sub _normalize_options {
  my $self = shift;
  my $options = $self->{options};

  local $HTML::Template::this_file;
  my @pstacks = ($self->{parse_stack});
  while(@pstacks) {
    my $pstack = pop(@pstacks);
    foreach my $item (@$pstack) {
      next unless (ref($item) eq 'HTML::Template::LOOP');
      foreach my $template (values %{$item->[HTML::Template::LOOP::TEMPLATE_HASH]}) {
        # must be the same list as the call to _new_from_loop...
        $template->{options}{debug} = $options->{debug};
        $template->{options}{stack_debug} = $options->{stack_debug};
        $template->{options}{die_on_bad_params} = $options->{die_on_bad_params};
        $template->{options}{case_sensitive} = $options->{case_sensitive};

        push(@pstacks, $template->{parse_stack});
      }
    }
  }
}      

# initialize the template buffer
sub _init_template {
  my $self = shift;
  my $options = $self->{options};

  print STDERR "### HTML::Template Memory Debug ### START INIT_TEMPLATE ", $self->{proc_mem}->size(), "\n"
    if $options->{memory_debug};

  local $HTML::Template::this_file;
  if (exists($options->{filename})) {    
    my $filepath = $options->{filepath};
    if (not defined $filepath) {
      $filepath = $self->_find_file($options->{filename});
      confess("HTML::Template->new() : Cannot open included file $options->{filename} : file not found.")
        unless defined($filepath);
      # we'll need this for future reference - to call stat() for example.
      $options->{filepath} = $filepath;   
    }

    confess("HTML::Template->new() : Cannot open included file $options->{filename} : $!")
        unless defined(open(TEMPLATE, $filepath));
    $self->{mtime} = $self->_mtime($filepath);

    # read into scalar, note the mtime for the record
    $self->{template} = "";
    while (read(TEMPLATE, $self->{template}, 10240, length($self->{template}))) {}
    close(TEMPLATE);
    $HTML::Template::this_file = $filepath;

  } elsif (exists($options->{scalarref})) {
    # copy in the template text
    $self->{template} = ${$options->{scalarref}};

    delete($options->{scalarref});
  } elsif (exists($options->{arrayref})) {
    # if we have an array ref, join and store the template text
    $self->{template} = join("", @{$options->{arrayref}});

    delete($options->{arrayref});
  } elsif (exists($options->{filehandle})) {
    # just read everything in in one go
    local $/ = undef;
    $self->{template} = readline($options->{filehandle});

    delete($options->{filehandle});
  } else {
    confess("HTML::Template : Need to call new with filename, filehandle, scalarref or arrayref parameter specified.");
  }

  print STDERR "### HTML::Template Memory Debug ### END INIT_TEMPLATE ", $self->{proc_mem}->size(), "\n"
    if $options->{memory_debug};

  # handle filters if necessary
  $self->_call_filters(\$self->{template}) if @{$options->{filter}};

  return $self;
}

# handle calling user defined filters
sub _call_filters {
  my $self = shift;
  my $template_ref = shift;
  my $options = $self->{options};

  my ($format, $sub);
  foreach my $filter (@{$options->{filter}}) {
    croak("HTML::Template->new() : bad value set for filter parameter - must be a code ref or a hash ref.")
      unless ref $filter;

    # translate into CODE->HASH
    $filter = { 'format' => 'scalar', 'sub' => $filter }
      if (ref $filter eq 'CODE');

    if (ref $filter eq 'HASH') {
      $format = $filter->{'format'};
      $sub = $filter->{'sub'};

      # check types and values
      croak("HTML::Template->new() : bad value set for filter parameter - hash must contain \"format\" key and \"sub\" key.")
        unless defined $format and defined $sub;
      croak("HTML::Template->new() : bad value set for filter parameter - \"format\" must be either 'array' or 'scalar'")
        unless $format eq 'array' or $format eq 'scalar';
      croak("HTML::Template->new() : bad value set for filter parameter - \"sub\" must be a code ref")
        unless ref $sub and ref $sub eq 'CODE';

      # catch errors
      eval {
        if ($format eq 'scalar') {
          # call
          $sub->($template_ref, $self);
        } else {
	  # modulate
	  my @array = map { $_."\n" } split("\n", $$template_ref);
          # call
          $sub->(\@array, $self);
	  # demodulate
	  $$template_ref = join("", @array);
        }
      };
      croak("HTML::Template->new() : fatal error occured during filter call: $@") if $@;
    } else {
      croak("HTML::Template->new() : bad value set for filter parameter - must be code ref or hash ref");
    }
  }
  # all done
  return $template_ref;
}

# _parse sifts through a template building up the param_map and
# parse_stack structures.
#
# The end result is a Template object that is fully ready for
# output().
sub _parse {
  my $self = shift;
  my $options = $self->{options};
  
  $options->{debug} and print STDERR "### HTML::Template Debug ### In _parse:\n";
  
  # setup the stacks and maps - they're accessed by typeglobs that
  # reference the top of the stack.  They are masked so that a loop
  # can transparently have its own versions.
  use vars qw(@pstack %pmap @ifstack @ucstack %top_pmap);
  local (*pstack, *ifstack, *pmap, *ucstack, *top_pmap);
  
  # the pstack is the array of scalar refs (plain text from the
  # template file), VARs, LOOPs, IFs and ELSEs that output() works on
  # to produce output.  Looking at output() should make it clear what
  # _parse is trying to accomplish.
  my @pstacks = ([]);
  *pstack = $pstacks[0];
  $self->{parse_stack} = $pstacks[0];
  
  # the pmap binds names to VARs, LOOPs and IFs.  It allows param() to
  # access the right variable.  NOTE: output() does not look at the
  # pmap at all!
  my @pmaps = ({});
  *pmap = $pmaps[0];
  *top_pmap = $pmaps[0];
  $self->{param_map} = $pmaps[0];

  # the ifstack is a temporary stack containing pending ifs and elses
  # waiting for a /if.
  my @ifstacks = ([]);
  *ifstack = $ifstacks[0];

  # the ucstack is a temporary stack containing conditions that need
  # to be bound to param_map entries when their block is finished.
  # This happens when a conditional is encountered before any other
  # reference to its NAME.  Since a conditional can reference VARs and
  # LOOPs it isn't possible to make the link right away.
  my @ucstacks = ([]);
  *ucstack = $ucstacks[0];
  
  # the loopstack is another temp stack for closing loops.  unlike
  # those above it doesn't get scoped inside loops, therefore it
  # doesn't need the typeglob magic.
  my @loopstack = ();

  # the fstack is a stack of filenames and counters that keeps track
  # of which file we're in and where we are in it.  This allows
  # accurate error messages even inside included files!
  # fcounter, fmax and fname are aliases for the current file's info
  use vars qw($fcounter $fname $fmax);
  local (*fcounter, *fname, *fmax);

  my @fstack = ([$options->{filepath} || "/fake/path/for/non/file/template",
                 1, 
                 scalar @{[$self->{template} =~ m/(\n)/g]} + 1
                ]);
  (*fname, *fcounter, *fmax) = \ ( @{$fstack[0]} );

  my $NOOP = HTML::Template::NOOP->new();
  my $ESCAPE = HTML::Template::ESCAPE->new();
  my $JSESCAPE = HTML::Template::JSESCAPE->new();
  my $URLESCAPE = HTML::Template::URLESCAPE->new();

  # all the tags that need NAMEs:
  my %need_names = map { $_ => 1 } 
    qw(TMPL_VAR TMPL_LOOP TMPL_IF TMPL_UNLESS TMPL_INCLUDE);
    
  # variables used below that don't need to be my'd in the loop
  my ($name, $which, $escape, $default);

  # handle the old vanguard format
  $options->{vanguard_compatibility_mode} and 
    $self->{template} =~ s/%([-\w\/\.+]+)%/<TMPL_VAR NAME=$1>/g;

  # now split up template on '<', leaving them in
  my @chunks = split(m/(?=<)/, $self->{template});

  # all done with template
  delete $self->{template};

  # loop through chunks, filling up pstack
  my $last_chunk =  $#chunks;
 CHUNK: for (my $chunk_number = 0;
	    $chunk_number <= $last_chunk;
	    $chunk_number++) {
    next unless defined $chunks[$chunk_number]; 
    my $chunk = $chunks[$chunk_number];
    
    # a general regex to match any and all TMPL_* tags 
    if ($chunk =~ /^<
                    (?:!--\s*)?
                    (
                      \/?[Tt][Mm][Pp][Ll]_
                      (?:
                         (?:[Vv][Aa][Rr])
                         |
                         (?:[Ll][Oo][Oo][Pp])
                         |
                         (?:[Ii][Ff])
                         |
                         (?:[Ee][Ll][Ss][Ee])
                         |
                         (?:[Uu][Nn][Ll][Ee][Ss][Ss])
                         |
                         (?:[Ii][Nn][Cc][Ll][Uu][Dd][Ee])
                      )
                    ) # $1 => $which - start of the tag

                    \s* 

                    # DEFAULT attribute
                    (?:
                      [Dd][Ee][Ff][Aa][Uu][Ll][Tt]
                      \s*=\s*
                      (?:
                        "([^">]*)"  # $2 => double-quoted DEFAULT value "
                        |
                        '([^'>]*)'  # $3 => single-quoted DEFAULT value
                        |
                        ([^\s=>]*)  # $4 => unquoted DEFAULT value
                      )
                    )?

                    \s*

                    # ESCAPE attribute
                    (?:
                      [Ee][Ss][Cc][Aa][Pp][Ee]
                      \s*=\s*
                      (?:
                         (?: 0 | (?:"0") | (?:'0') )
                         |
                         ( 1 | (?:"1") | (?:'1') | 
                           (?:[Hh][Tt][Mm][Ll]) | 
                           (?:"[Hh][Tt][Mm][Ll]") |
                           (?:'[Hh][Tt][Mm][Ll]') |
                           (?:[Uu][Rr][Ll]) | 
                           (?:"[Uu][Rr][Ll]") |
                           (?:'[Uu][Rr][Ll]') |
                           (?:[Jj][Ss]) |
                           (?:"[Jj][Ss]") |
                           (?:'[Jj][Ss]') |
                         )                         # $5 => ESCAPE on
                       )
                    )* # allow multiple ESCAPEs

                    \s*

                    # DEFAULT attribute
                    (?:
                      [Dd][Ee][Ff][Aa][Uu][Ll][Tt]
                      \s*=\s*
                      (?:
                        "([^">]*)"  # $6 => double-quoted DEFAULT value "
                        |
                        '([^'>]*)'  # $7 => single-quoted DEFAULT value
                        |
                        ([^\s=>]*)  # $8 => unquoted DEFAULT value
                      )
                    )?

                    \s*                    

                    # NAME attribute
                    (?:
                      (?:
                        [Nn][Aa][Mm][Ee]
                        \s*=\s*
                      )?
                      (?:
                        "([^">]*)"  # $9 => double-quoted NAME value "
                        |
                        '([^'>]*)'  # $10 => single-quoted NAME value
                        |
                        ([^\s=>]*)  # $11 => unquoted NAME value
                      )
                    )? 
                    
                    \s*

                    # DEFAULT attribute
                    (?:
                      [Dd][Ee][Ff][Aa][Uu][Ll][Tt]
                      \s*=\s*
                      (?:
                        "([^">]*)"  # $12 => double-quoted DEFAULT value "
                        |
                        '([^'>]*)'  # $13 => single-quoted DEFAULT value
                        |
                        ([^\s=>]*)  # $14 => unquoted DEFAULT value
                      )
                    )?

                    \s*

                    # ESCAPE attribute
                    (?:
                      [Ee][Ss][Cc][Aa][Pp][Ee]
                      \s*=\s*
                      (?:
                         (?: 0 | (?:"0") | (?:'0') )
                         |
                         ( 1 | (?:"1") | (?:'1') | 
                           (?:[Hh][Tt][Mm][Ll]) | 
                           (?:"[Hh][Tt][Mm][Ll]") |
                           (?:'[Hh][Tt][Mm][Ll]') |
                           (?:[Uu][Rr][Ll]) | 
                           (?:"[Uu][Rr][Ll]") |
                           (?:'[Uu][Rr][Ll]') |
                           (?:[Jj][Ss]) |
                           (?:"[Jj][Ss]") |
                           (?:'[Jj][Ss]') |
                         )                         # $15 => ESCAPE on
                       )
                    )* # allow multiple ESCAPEs

                    \s*

                    # DEFAULT attribute
                    (?:
                      [Dd][Ee][Ff][Aa][Uu][Ll][Tt]
                      \s*=\s*
                      (?:
                        "([^">]*)"  # $16 => double-quoted DEFAULT value "
                        |
                        '([^'>]*)'  # $17 => single-quoted DEFAULT value
                        |
                        ([^\s=>]*)  # $18 => unquoted DEFAULT value
                      )
                    )?

                    \s*

                    (?:--)?>                    
                    (.*) # $19 => $post - text that comes after the tag
                   $/sx) {

      $which = uc($1); # which tag is it

      $escape = defined $5 ? $5 : defined $15 ? $15
        : (defined $options->{default_escape} && $which eq 'TMPL_VAR') ? $options->{default_escape} : 0; # escape set?
      
      # what name for the tag?  undef for a /tag at most, one of the
      # following three will be defined
      $name = defined $9 ? $9 : defined $10 ? $10 : defined $11 ? $11 : undef;

      # is there a default?
      $default = defined $2  ? $2  : defined $3  ? $3  : defined $4  ? $4 : 
                 defined $6  ? $6  : defined $7  ? $7  : defined $8  ? $8 : 
                 defined $12 ? $12 : defined $13 ? $13 : defined $14 ? $14 : 
                 defined $16 ? $16 : defined $17 ? $17 : defined $18 ? $18 :
                 undef;

      my $post = $19; # what comes after on the line

      # allow mixed case in filenames, otherwise flatten
      $name = lc($name) unless (not defined $name or $which eq 'TMPL_INCLUDE' or $options->{case_sensitive});

      # die if we need a name and didn't get one
      die "HTML::Template->new() : No NAME given to a $which tag at $fname : line $fcounter." 
        if ($need_names{$which} and (not defined $name or not length $name));

      # die if we got an escape but can't use one
      die "HTML::Template->new() : ESCAPE option invalid in a $which tag at $fname : line $fcounter." if ( $escape and ($which ne 'TMPL_VAR'));

      # die if we got a default but can't use one
      die "HTML::Template->new() : DEFAULT option invalid in a $which tag at $fname : line $fcounter." if ( defined $default and ($which ne 'TMPL_VAR'));
        
      # take actions depending on which tag found
      if ($which eq 'TMPL_VAR') {
	$options->{debug} and print STDERR "### HTML::Template Debug ### $fname : line $fcounter : parsed VAR $name\n";
	
	# if we already have this var, then simply link to the existing
	# HTML::Template::VAR, else create a new one.        
	my $var;        
	if (exists $pmap{$name}) {
	  $var = $pmap{$name};
	  (ref($var) eq 'HTML::Template::VAR') or
	    die "HTML::Template->new() : Already used param name $name as a TMPL_LOOP, found in a TMPL_VAR at $fname : line $fcounter.";
	} else {
	  $var = HTML::Template::VAR->new();
	  $pmap{$name} = $var;
	  $top_pmap{$name} = HTML::Template::VAR->new()
	    if $options->{global_vars} and not exists $top_pmap{$name};
	}

        # if a DEFAULT was provided, push a DEFAULT object on the
        # stack before the variable.
	if (defined $default) {
            push(@pstack, HTML::Template::DEFAULT->new($default));
        }
	
	# if ESCAPE was set, push an ESCAPE op on the stack before
	# the variable.  output will handle the actual work.
	if ($escape) {
          if ($escape =~ /^["']?[Uu][Rr][Ll]["']?$/) {
	    push(@pstack, $URLESCAPE);
	  } elsif ($escape =~ /^"?[Jj][Ss]"?$/) {
	    push(@pstack, $JSESCAPE);
	  } else {
	    push(@pstack, $ESCAPE);
	  }
	}

	push(@pstack, $var);
	
      } elsif ($which eq 'TMPL_LOOP') {
	# we've got a loop start
	$options->{debug} and print STDERR "### HTML::Template Debug ### $fname : line $fcounter : LOOP $name start\n";
	
	# if we already have this loop, then simply link to the existing
	# HTML::Template::LOOP, else create a new one.
	my $loop;
	if (exists $pmap{$name}) {
	  $loop = $pmap{$name};
	  (ref($loop) eq 'HTML::Template::LOOP') or
	    die "HTML::Template->new() : Already used param name $name as a TMPL_VAR, TMPL_IF or TMPL_UNLESS, found in a TMP_LOOP at $fname : line $fcounter!";
	  
	} else {
	  # store the results in a LOOP object - actually just a
	  # thin wrapper around another HTML::Template object.
	  $loop = HTML::Template::LOOP->new();
	  $pmap{$name} = $loop;
	}
	
	# get it on the loopstack, pstack of the enclosing block
	push(@pstack, $loop);
	push(@loopstack, [$loop, $#pstack]);
	
	# magic time - push on a fresh pmap and pstack, adjust the typeglobs.
	# this gives the loop a separate namespace (i.e. pmap and pstack).
	push(@pstacks, []);
	*pstack = $pstacks[$#pstacks];
	push(@pmaps, {});
	*pmap = $pmaps[$#pmaps];
	push(@ifstacks, []);
	*ifstack = $ifstacks[$#ifstacks];
	push(@ucstacks, []);
	*ucstack = $ucstacks[$#ucstacks];
	
	# auto-vivify __FIRST__, __LAST__ and __INNER__ if
	# loop_context_vars is set.  Otherwise, with
	# die_on_bad_params set output() will might cause errors
	# when it tries to set them.
	if ($options->{loop_context_vars}) {
	  $pmap{__first__}   = HTML::Template::VAR->new();
	  $pmap{__inner__}   = HTML::Template::VAR->new();
	  $pmap{__last__}    = HTML::Template::VAR->new();
	  $pmap{__odd__}     = HTML::Template::VAR->new();
	  $pmap{__counter__} = HTML::Template::VAR->new();
	}
	
      } elsif ($which eq '/TMPL_LOOP') {
	$options->{debug} and print STDERR "### HTML::Template Debug ### $fname : line $fcounter : LOOP end\n";
	
	my $loopdata = pop(@loopstack);
	die "HTML::Template->new() : found </TMPL_LOOP> with no matching <TMPL_LOOP> at $fname : line $fcounter!" unless defined $loopdata;
	
	my ($loop, $starts_at) = @$loopdata;
	
	# resolve pending conditionals
	foreach my $uc (@ucstack) {
	  my $var = $uc->[HTML::Template::COND::VARIABLE]; 
	  if (exists($pmap{$var})) {
	    $uc->[HTML::Template::COND::VARIABLE] = $pmap{$var};
	  } else {
	    $pmap{$var} = HTML::Template::VAR->new();
	    $top_pmap{$var} = HTML::Template::VAR->new()
	      if $options->{global_vars} and not exists $top_pmap{$var};
	    $uc->[HTML::Template::COND::VARIABLE] = $pmap{$var};
	  }
	  if (ref($pmap{$var}) eq 'HTML::Template::VAR') {
	    $uc->[HTML::Template::COND::VARIABLE_TYPE] = HTML::Template::COND::VARIABLE_TYPE_VAR;
	  } else {
	    $uc->[HTML::Template::COND::VARIABLE_TYPE] = HTML::Template::COND::VARIABLE_TYPE_LOOP;
	  }
	}
	
	# get pmap and pstack for the loop, adjust the typeglobs to
	# the enclosing block.
	my $param_map = pop(@pmaps);
	*pmap = $pmaps[$#pmaps];
	my $parse_stack = pop(@pstacks);
	*pstack = $pstacks[$#pstacks];
	
	scalar(@ifstack) and die "HTML::Template->new() : Dangling <TMPL_IF> or <TMPL_UNLESS> in loop ending at $fname : line $fcounter.";
	pop(@ifstacks);
	*ifstack = $ifstacks[$#ifstacks];
	pop(@ucstacks);
	*ucstack = $ucstacks[$#ucstacks];
	
	# instantiate the sub-Template, feeding it parse_stack and
	# param_map.  This means that only the enclosing template
	# does _parse() - sub-templates get their parse_stack and
	# param_map fed to them already filled in.
	$loop->[HTML::Template::LOOP::TEMPLATE_HASH]{$starts_at}             
	  = ref($self)->_new_from_loop(
					   parse_stack => $parse_stack,
					   param_map => $param_map,
					   debug => $options->{debug}, 
					   die_on_bad_params => $options->{die_on_bad_params}, 
					   loop_context_vars => $options->{loop_context_vars},
                                           case_sensitive => $options->{case_sensitive},
					  );
	
      } elsif ($which eq 'TMPL_IF' or $which eq 'TMPL_UNLESS' ) {
	$options->{debug} and print STDERR "### HTML::Template Debug ### $fname : line $fcounter : $which $name start\n";
	
	# if we already have this var, then simply link to the existing
	# HTML::Template::VAR/LOOP, else defer the mapping
	my $var;        
	if (exists $pmap{$name}) {
	  $var = $pmap{$name};
	} else {
	  $var = $name;
	}
	
	# connect the var to a conditional
	my $cond = HTML::Template::COND->new($var);
	if ($which eq 'TMPL_IF') {
	  $cond->[HTML::Template::COND::WHICH] = HTML::Template::COND::WHICH_IF;
	  $cond->[HTML::Template::COND::JUMP_IF_TRUE] = 0;
	} else {
	  $cond->[HTML::Template::COND::WHICH] = HTML::Template::COND::WHICH_UNLESS;
	  $cond->[HTML::Template::COND::JUMP_IF_TRUE] = 1;
	}
	
	# push unconnected conditionals onto the ucstack for
	# resolution later.  Otherwise, save type information now.
	if ($var eq $name) {
	  push(@ucstack, $cond);
	} else {
	  if (ref($var) eq 'HTML::Template::VAR') {
	    $cond->[HTML::Template::COND::VARIABLE_TYPE] = HTML::Template::COND::VARIABLE_TYPE_VAR;
	  } else {
	    $cond->[HTML::Template::COND::VARIABLE_TYPE] = HTML::Template::COND::VARIABLE_TYPE_LOOP;
	  }
	}
	
	# push what we've got onto the stacks
	push(@pstack, $cond);
	push(@ifstack, $cond);
	
      } elsif ($which eq '/TMPL_IF' or $which eq '/TMPL_UNLESS') {
	$options->{debug} and print STDERR "### HTML::Template Debug ### $fname : line $fcounter : $which end\n";
	
	my $cond = pop(@ifstack);
	die "HTML::Template->new() : found </${which}> with no matching <TMPL_IF> at $fname : line $fcounter." unless defined $cond;
	if ($which eq '/TMPL_IF') {
	  die "HTML::Template->new() : found </TMPL_IF> incorrectly terminating a <TMPL_UNLESS> (use </TMPL_UNLESS>) at $fname : line $fcounter.\n" 
	    if ($cond->[HTML::Template::COND::WHICH] == HTML::Template::COND::WHICH_UNLESS);
	} else {
	  die "HTML::Template->new() : found </TMPL_UNLESS> incorrectly terminating a <TMPL_IF> (use </TMPL_IF>) at $fname : line $fcounter.\n" 
	    if ($cond->[HTML::Template::COND::WHICH] == HTML::Template::COND::WHICH_IF);
	}
	
	# connect the matching to this "address" - place a NOOP to
	# hold the spot.  This allows output() to treat an IF in the
	# assembler-esque "Conditional Jump" mode.
	push(@pstack, $NOOP);
	$cond->[HTML::Template::COND::JUMP_ADDRESS] = $#pstack;
	
      } elsif ($which eq 'TMPL_ELSE') {
	$options->{debug} and print STDERR "### HTML::Template Debug ### $fname : line $fcounter : ELSE\n";
	
	my $cond = pop(@ifstack);
	die "HTML::Template->new() : found <TMPL_ELSE> with no matching <TMPL_IF> or <TMPL_UNLESS> at $fname : line $fcounter." unless defined $cond;
        die "HTML::Template->new() : found second <TMPL_ELSE> tag for  <TMPL_IF> or <TMPL_UNLESS> at $fname : line $fcounter." if $cond->[HTML::Template::COND::IS_ELSE];	
	
	my $else = HTML::Template::COND->new($cond->[HTML::Template::COND::VARIABLE]);
	$else->[HTML::Template::COND::WHICH] = $cond->[HTML::Template::COND::WHICH];
        $else->[HTML::Template::COND::UNCONDITIONAL_JUMP] = 1;
	$else->[HTML::Template::COND::IS_ELSE] = 1;

	# need end-block resolution?
	if (defined($cond->[HTML::Template::COND::VARIABLE_TYPE])) {
	  $else->[HTML::Template::COND::VARIABLE_TYPE] = $cond->[HTML::Template::COND::VARIABLE_TYPE];
	} else {
	  push(@ucstack, $else);
	}
	
	push(@pstack, $else);
	push(@ifstack, $else);
	
	# connect the matching to this "address" - thus the if,
	# failing jumps to the ELSE address.  The else then gets
	# elaborated, and of course succeeds.  On the other hand, if
	# the IF fails and falls though, output will reach the else
	# and jump to the /if address.
	$cond->[HTML::Template::COND::JUMP_ADDRESS] = $#pstack;
		
      } elsif ($which eq 'TMPL_INCLUDE') {
	# handle TMPL_INCLUDEs
	$options->{debug} and print STDERR "### HTML::Template Debug ### $fname : line $fcounter : INCLUDE $name \n";
	
	# no includes here, bub
	$options->{no_includes} and croak("HTML::Template : Illegal attempt to use TMPL_INCLUDE in template file : (no_includes => 1)");
	
	my $filename = $name;
	
	# look for the included file...
	my $filepath;
	if ($options->{search_path_on_include}) {
	  $filepath = $self->_find_file($filename);
	} else {
	  $filepath = $self->_find_file($filename, 
					[File::Spec->splitdir($fstack[-1][0])]
				       );
	}
	die "HTML::Template->new() : Cannot open included file $filename : file not found."
	  unless defined($filepath);
	die "HTML::Template->new() : Cannot open included file $filename : $!"
	  unless defined(open(TEMPLATE, $filepath));              
	
	# read into the array
	my $included_template = "";
        while(read(TEMPLATE, $included_template, 10240, length($included_template))) {}
	close(TEMPLATE);

    local $HTML::Template::this_file = $filepath;
	# call filters if necessary
	$self->_call_filters(\$included_template) if @{$options->{filter}};
	
	if ($included_template) { # not empty
	  # handle the old vanguard format - this needs to happen here
	  # since we're not about to do a next CHUNKS.
	  $options->{vanguard_compatibility_mode} and 
	    $included_template =~ s/%([-\w\/\.+]+)%/<TMPL_VAR NAME=$1>/g;
	  
	  # collect mtimes for included files
	  if ($options->{cache} and !$options->{blind_cache}) {
	    $self->{included_mtimes}{$filepath} = (stat($filepath))[9];
	  }
	  
	  # adjust the fstack to point to the included file info
	  push(@fstack, [$filepath, 1,
			 scalar @{[$included_template =~ m/(\n)/g]} + 1]);
	  (*fname, *fcounter, *fmax) = \ ( @{$fstack[$#fstack]} );
	  
          # make sure we aren't infinitely recursing
          die "HTML::Template->new() : likely recursive includes - parsed $options->{max_includes} files deep and giving up (set max_includes higher to allow deeper recursion)." if ($options->{max_includes} and (scalar(@fstack) > $options->{max_includes}));
          
	  # stick the remains of this chunk onto the bottom of the
	  # included text.
	  $included_template .= $post;
	  $post = undef;
	  
	  # move the new chunks into place.  
	  splice(@chunks, $chunk_number, 1,
		 split(m/(?=<)/, $included_template));

	  # recalculate stopping point
	  $last_chunk = $#chunks;

	  # start in on the first line of the included text - nothing
	  # else to do on this line.
	  $chunk = $chunks[$chunk_number];

	  redo CHUNK;
	}
      } else {
	# zuh!?
	die "HTML::Template->new() : Unknown or unmatched TMPL construct at $fname : line $fcounter.";
      }
      # push the rest after the tag
      if (defined($post)) {
	if (ref($pstack[$#pstack]) eq 'SCALAR') {
	  ${$pstack[$#pstack]} .= $post;
	} else {
	  push(@pstack, \$post);
	}
      }
    } else { # just your ordinary markup
      # make sure we didn't reject something TMPL_* but badly formed
      if ($options->{strict}) {
	die "HTML::Template->new() : Syntax error in <TMPL_*> tag at $fname : $fcounter." if ($chunk =~ /<(?:!--\s*)?\/?[Tt][Mm][Pp][Ll]_/);
      }
      
      # push the rest and get next chunk
      if (defined($chunk)) {
	if (ref($pstack[$#pstack]) eq 'SCALAR') {
	  ${$pstack[$#pstack]} .= $chunk;
	} else {
	  push(@pstack, \$chunk);
	}
      }
    }
    # count newlines in chunk and advance line count
    $fcounter += scalar(@{[$chunk =~ m/(\n)/g]});
    # if we just crossed the end of an included file
    # pop off the record and re-alias to the enclosing file's info
    pop(@fstack), (*fname, *fcounter, *fmax) = \ ( @{$fstack[$#fstack]} )
      if ($fcounter > $fmax);
    
  } # next CHUNK

  # make sure we don't have dangling IF or LOOP blocks
  scalar(@ifstack) and die "HTML::Template->new() : At least one <TMPL_IF> or <TMPL_UNLESS> not terminated at end of file!";
  scalar(@loopstack) and die "HTML::Template->new() : At least one <TMPL_LOOP> not terminated at end of file!";

  # resolve pending conditionals
  foreach my $uc (@ucstack) {
    my $var = $uc->[HTML::Template::COND::VARIABLE]; 
    if (exists($pmap{$var})) {
      $uc->[HTML::Template::COND::VARIABLE] = $pmap{$var};
    } else {
      $pmap{$var} = HTML::Template::VAR->new();
      $top_pmap{$var} = HTML::Template::VAR->new()
        if $options->{global_vars} and not exists $top_pmap{$var};
      $uc->[HTML::Template::COND::VARIABLE] = $pmap{$var};
    }
    if (ref($pmap{$var}) eq 'HTML::Template::VAR') {
      $uc->[HTML::Template::COND::VARIABLE_TYPE] = HTML::Template::COND::VARIABLE_TYPE_VAR;
    } else {
      $uc->[HTML::Template::COND::VARIABLE_TYPE] = HTML::Template::COND::VARIABLE_TYPE_LOOP;
    }
  }

  # want a stack dump?
  if ($options->{stack_debug}) {
    require 'Data/Dumper.pm';
    print STDERR "### HTML::Template _param Stack Dump ###\n\n", Data::Dumper::Dumper($self->{parse_stack}), "\n";
  }

  # get rid of filters - they cause runtime errors if Storable tries
  # to store them.  This can happen under global_vars.
  delete $options->{filter};
}

# a recursive sub that associates each loop with the loops above
# (treating the top-level as a loop)
sub _globalize_vars {
  my $self = shift;
  
  # associate with the loop (and top-level templates) above in the tree.
  push(@{$self->{options}{associate}}, @_);
  
  # recurse down into the template tree, adding ourself to the end of
  # list.
  push(@_, $self);
  map { $_->_globalize_vars(@_) } 
    map {values %{$_->[HTML::Template::LOOP::TEMPLATE_HASH]}}
      grep { ref($_) eq 'HTML::Template::LOOP'} @{$self->{parse_stack}};
}

# method used to recursively un-hook associate
sub _unglobalize_vars {
  my $self = shift;
  
  # disassociate
  $self->{options}{associate} = undef;
  
  # recurse down into the template tree disassociating
  map { $_->_unglobalize_vars() } 
    map {values %{$_->[HTML::Template::LOOP::TEMPLATE_HASH]}}
      grep { ref($_) eq 'HTML::Template::LOOP'} @{$self->{parse_stack}};
}

=head2 param()

param() can be called in a number of ways

1) To return a list of parameters in the template : 

   my @parameter_names = $self->param();
   

2) To return the value set to a param : 

   my $value = $self->param('PARAM');

3) To set the value of a parameter :

      # For simple TMPL_VARs:
      $self->param(PARAM => 'value');

      # with a subroutine reference that gets called to get the value
      # of the scalar.  The sub will recieve the template object as a
      # parameter.
      $self->param(PARAM => sub { return 'value' });   

      # And TMPL_LOOPs:
      $self->param(LOOP_PARAM => 
                   [ 
                    { PARAM => VALUE_FOR_FIRST_PASS, ... }, 
                    { PARAM => VALUE_FOR_SECOND_PASS, ... } 
                    ...
                   ]
                  );

4) To set the value of a a number of parameters :

     # For simple TMPL_VARs:
     $self->param(PARAM => 'value', 
                  PARAM2 => 'value'
                 );

      # And with some TMPL_LOOPs:
      $self->param(PARAM => 'value', 
                   PARAM2 => 'value',
                   LOOP_PARAM => 
                   [ 
                    { PARAM => VALUE_FOR_FIRST_PASS, ... }, 
                    { PARAM => VALUE_FOR_SECOND_PASS, ... } 
                    ...
                   ],
                   ANOTHER_LOOP_PARAM => 
                   [ 
                    { PARAM => VALUE_FOR_FIRST_PASS, ... }, 
                    { PARAM => VALUE_FOR_SECOND_PASS, ... } 
                    ...
                   ]
                  );

5) To set the value of a a number of parameters using a hash-ref :

      $self->param(
                   { 
                      PARAM => 'value', 
                      PARAM2 => 'value',
                      LOOP_PARAM => 
                      [ 
                        { PARAM => VALUE_FOR_FIRST_PASS, ... }, 
                        { PARAM => VALUE_FOR_SECOND_PASS, ... } 
                        ...
                      ],
                      ANOTHER_LOOP_PARAM => 
                      [ 
                        { PARAM => VALUE_FOR_FIRST_PASS, ... }, 
                        { PARAM => VALUE_FOR_SECOND_PASS, ... } 
                        ...
                      ]
                    }
                   );

=cut


sub param {
  my $self = shift;
  my $options = $self->{options};
  my $param_map = $self->{param_map};

  # the no-parameter case - return list of parameters in the template.
  return keys(%$param_map) unless scalar(@_);
  
  my $first = shift;
  my $type = ref $first;

  # the one-parameter case - could be a parameter value request or a
  # hash-ref.
  if (!scalar(@_) and !length($type)) {
    my $param = $options->{case_sensitive} ? $first : lc $first;
    
    # check for parameter existence 
    $options->{die_on_bad_params} and !exists($param_map->{$param}) and
      croak("HTML::Template : Attempt to get nonexistent parameter '$param' - this parameter name doesn't match any declarations in the template file : (die_on_bad_params set => 1)");
    
    return undef unless (exists($param_map->{$param}) and
                         defined($param_map->{$param}));

    return ${$param_map->{$param}} if 
      (ref($param_map->{$param}) eq 'HTML::Template::VAR');
    return $param_map->{$param}[HTML::Template::LOOP::PARAM_SET];
  } 

  if (!scalar(@_)) {
    croak("HTML::Template->param() : Single reference arg to param() must be a hash-ref!  You gave me a $type.")
      unless $type eq 'HASH' or 
        (ref($first) and UNIVERSAL::isa($first, 'HASH'));  
    push(@_, %$first);
  } else {
    unshift(@_, $first);
  }
  
  croak("HTML::Template->param() : You gave me an odd number of parameters to param()!")
    unless ((@_ % 2) == 0);

  # strangely, changing this to a "while(@_) { shift, shift }" type
  # loop causes perl 5.004_04 to die with some nonsense about a
  # read-only value.
  for (my $x = 0; $x <= $#_; $x += 2) {
    my $param = $options->{case_sensitive} ? $_[$x] : lc $_[$x];
    my $value = $_[($x + 1)];
    
    # check that this param exists in the template
    $options->{die_on_bad_params} and !exists($param_map->{$param}) and
      croak("HTML::Template : Attempt to set nonexistent parameter '$param' - this parameter name doesn't match any declarations in the template file : (die_on_bad_params => 1)");
    
    # if we're not going to die from bad param names, we need to ignore
    # them...
    next unless (exists($param_map->{$param}));
    
    # figure out what we've got, taking special care to allow for
    # objects that are compatible underneath.
    my $value_type = ref($value);
    if (defined($value_type) and length($value_type) and ($value_type eq 'ARRAY' or ((ref($value) !~ /^(CODE)|(HASH)|(SCALAR)$/) and $value->isa('ARRAY')))) {
      (ref($param_map->{$param}) eq 'HTML::Template::LOOP') or
        croak("HTML::Template::param() : attempt to set parameter '$param' with an array ref - parameter is not a TMPL_LOOP!");
      $param_map->{$param}[HTML::Template::LOOP::PARAM_SET] = [@{$value}];
    } else {
      (ref($param_map->{$param}) eq 'HTML::Template::VAR') or
        croak("HTML::Template::param() : attempt to set parameter '$param' with a scalar - parameter is not a TMPL_VAR!");
      ${$param_map->{$param}} = $value;
    }
  }
}

=pod

=head2 clear_params()

Sets all the parameters to undef.  Useful internally, if nowhere else!

=cut

sub clear_params {
  my $self = shift;
  my $type;
  foreach my $name (keys %{$self->{param_map}}) {
    $type = ref($self->{param_map}{$name});
    undef(${$self->{param_map}{$name}})
      if ($type eq 'HTML::Template::VAR');
    undef($self->{param_map}{$name}[HTML::Template::LOOP::PARAM_SET])
      if ($type eq 'HTML::Template::LOOP');    
  }
}


# obsolete implementation of associate
sub associateCGI { 
  my $self = shift;
  my $cgi  = shift;
  (ref($cgi) eq 'CGI') or
    croak("Warning! non-CGI object was passed to HTML::Template::associateCGI()!\n");
  push(@{$self->{options}{associate}}, $cgi);
  return 1;
}


=head2 output()

output() returns the final result of the template.  In most situations
you'll want to print this, like:

   print $template->output();

When output is called each occurrence of <TMPL_VAR NAME=name> is
replaced with the value assigned to "name" via param().  If a named
parameter is unset it is simply replaced with ''.  <TMPL_LOOPS> are
evaluated once per parameter set, accumlating output on each pass.

Calling output() is guaranteed not to change the state of the
Template object, in case you were wondering.  This property is mostly
important for the internal implementation of loops.

You may optionally supply a filehandle to print to automatically as
the template is generated.  This may improve performance and lower
memory consumption.  Example:

   $template->output(print_to => *STDOUT);

The return value is undefined when using the "print_to" option.

=cut

use vars qw(%URLESCAPE_MAP);
sub output {
  my $self = shift;
  my $options = $self->{options};
  local $_;

  croak("HTML::Template->output() : You gave me an odd number of parameters to output()!")
    unless ((@_ % 2) == 0);
  my %args = @_;

  print STDERR "### HTML::Template Memory Debug ### START OUTPUT ", $self->{proc_mem}->size(), "\n"
    if $options->{memory_debug};

  $options->{debug} and print STDERR "### HTML::Template Debug ### In output\n";

  # want a stack dump?
  if ($options->{stack_debug}) {
    require 'Data/Dumper.pm';
    print STDERR "### HTML::Template output Stack Dump ###\n\n", Data::Dumper::Dumper($self->{parse_stack}), "\n";
  }

  # globalize vars - this happens here to localize the circular
  # references created by global_vars.
  $self->_globalize_vars() if ($options->{global_vars});

  # support the associate magic, searching for undefined params and
  # attempting to fill them from the associated objects.
  if (scalar(@{$options->{associate}})) {
    # prepare case-mapping hashes to do case-insensitive matching
    # against associated objects.  This allows CGI.pm to be
    # case-sensitive and still work with asssociate.
    my (%case_map, $lparam);
    foreach my $associated_object (@{$options->{associate}}) {
      # what a hack!  This should really be optimized out for case_sensitive.
      if ($options->{case_sensitive}) {
        map {
          $case_map{$associated_object}{$_} = $_
        } $associated_object->param();
      } else {
        map {
          $case_map{$associated_object}{lc($_)} = $_
        } $associated_object->param();
      }
    }

    foreach my $param (keys %{$self->{param_map}}) {
      unless (defined($self->param($param))) {
      OBJ: foreach my $associated_object (reverse @{$options->{associate}}) {
          $self->param($param, scalar $associated_object->param($case_map{$associated_object}{$param})), last OBJ
            if (exists($case_map{$associated_object}{$param}));
        }
      }
    }
  }

  use vars qw($line @parse_stack); local(*line, *parse_stack);

  # walk the parse stack, accumulating output in $result
  *parse_stack = $self->{parse_stack};
  my $result = '';

  tie $result, 'HTML::Template::PRINTSCALAR', $args{print_to}
    if defined $args{print_to} and not tied $args{print_to};
	
  my $type;
  my $parse_stack_length = $#parse_stack;
  for (my $x = 0; $x <= $parse_stack_length; $x++) {
    *line = \$parse_stack[$x];
    $type = ref($line);
    
    if ($type eq 'SCALAR') {
      $result .= $$line;
    } elsif ($type eq 'HTML::Template::VAR' and ref($$line) eq 'CODE') {
      defined($$line) and $result .= $$line->($self);
    } elsif ($type eq 'HTML::Template::VAR') {
      defined($$line) and $result .= $$line;
    } elsif ($type eq 'HTML::Template::LOOP') {
      if (defined($line->[HTML::Template::LOOP::PARAM_SET])) {
        eval { $result .= $line->output($x, $options->{loop_context_vars}); };
        croak("HTML::Template->output() : fatal error in loop output : $@") 
          if $@;
      }
	} elsif ($type eq 'HTML::Template::COND') {
    	
     if ($line->[HTML::Template::COND::UNCONDITIONAL_JUMP]) {
       $x = $line->[HTML::Template::COND::JUMP_ADDRESS]
     } else {
        if ($line->[HTML::Template::COND::JUMP_IF_TRUE]) {
          if ($line->[HTML::Template::COND::VARIABLE_TYPE] == HTML::Template::COND::VARIABLE_TYPE_VAR) {
            if (defined ${$line->[HTML::Template::COND::VARIABLE]}) {
              if (ref(${$line->[HTML::Template::COND::VARIABLE]}) eq 'CODE') {
                $x = $line->[HTML::Template::COND::JUMP_ADDRESS] if ${$line->[HTML::Template::COND::VARIABLE]}->($self);
              } else {
                $x = $line->[HTML::Template::COND::JUMP_ADDRESS] if ${$line->[HTML::Template::COND::VARIABLE]};
              }
            }
          } else {
            $x = $line->[HTML::Template::COND::JUMP_ADDRESS] if
              (defined $line->[HTML::Template::COND::VARIABLE][HTML::Template::LOOP::PARAM_SET] and
               scalar @{$line->[HTML::Template::COND::VARIABLE][HTML::Template::LOOP::PARAM_SET]});
          }
        } else {
          if ($line->[HTML::Template::COND::VARIABLE_TYPE] == HTML::Template::COND::VARIABLE_TYPE_VAR) {
            if (defined ${$line->[HTML::Template::COND::VARIABLE]}) {
              if (ref(${$line->[HTML::Template::COND::VARIABLE]}) eq 'CODE') {
                $x = $line->[HTML::Template::COND::JUMP_ADDRESS] unless ${$line->[HTML::Template::COND::VARIABLE]}->($self);
              } else {
                $x = $line->[HTML::Template::COND::JUMP_ADDRESS] unless ${$line->[HTML::Template::COND::VARIABLE]};
              }
            } else {
              $x = $line->[HTML::Template::COND::JUMP_ADDRESS];
            }
          } else {
            $x = $line->[HTML::Template::COND::JUMP_ADDRESS] if
              (not defined $line->[HTML::Template::COND::VARIABLE][HTML::Template::LOOP::PARAM_SET] or
               not scalar @{$line->[HTML::Template::COND::VARIABLE][HTML::Template::LOOP::PARAM_SET]});
          }
        }
      }      	
    } elsif ($type eq 'HTML::Template::NOOP') {
      next;
    } elsif ($type eq 'HTML::Template::DEFAULT') {
      $_ = $x;  # remember default place in stack

      # find next VAR, there might be an ESCAPE in the way
      *line = \$parse_stack[++$x];
      *line = \$parse_stack[++$x] if ref $line eq 'HTML::Template::ESCAPE';

      # either output the default or go back
      if (defined $$line) {
        $x = $_;
      } else {
        $result .= ${$parse_stack[$_]};
      }
      next;      
    } elsif ($type eq 'HTML::Template::ESCAPE') {
      *line = \$parse_stack[++$x];
      if (defined($$line)) {
        if (ref($$line) eq 'CODE') {
            $_ = $$line->($self);
        } else {
            $_ = $$line;
        }
        
        # straight from the CGI.pm bible.
        s/&/&amp;/g;
        s/\"/&quot;/g; #"
        s/>/&gt;/g;
        s/</&lt;/g;
        s/'/&#39;/g; #'
        
        $result .= $_;
      }
      next;
    } elsif ($type eq 'HTML::Template::JSESCAPE') {
      $x++;
      *line = \$parse_stack[$x];
      if (defined($$line)) {
        if (ref($$line) eq 'CODE') {
            $_ = $$line->($self);
        } else {
            $_ = $$line;
        }
        s/\\/\\\\/g;
        s/'/\\'/g;
        s/"/\\"/g;
        s/\n/\\n/g;
        s/\r/\\r/g;
        $result .= $_;
      }
    } elsif ($type eq 'HTML::Template::URLESCAPE') {
      $x++;
      *line = \$parse_stack[$x];
      if (defined($$line)) {
        if (ref($$line) eq 'CODE') {
            $_ = $$line->($self);
        } else {
            $_ = $$line;
        }
        # Build a char->hex map if one isn't already available
        unless (exists($URLESCAPE_MAP{chr(1)})) {
          for (0..255) { $URLESCAPE_MAP{chr($_)} = sprintf('%%%02X', $_); }
        }
        # do the translation (RFC 2396 ^uric)
        s!([^a-zA-Z0-9_.\-])!$URLESCAPE_MAP{$1}!g;
        $result .= $_;
      }
    } else {
      confess("HTML::Template::output() : Unknown item in parse_stack : " . $type);
    }
  }

  # undo the globalization circular refs
  $self->_unglobalize_vars() if ($options->{global_vars});

  print STDERR "### HTML::Template Memory Debug ### END OUTPUT ", $self->{proc_mem}->size(), "\n"
    if $options->{memory_debug};
    
  return undef if defined $args{print_to};
  return $result;
}

=pod

=head2 query()

This method allow you to get information about the template structure.
It can be called in a number of ways.  The simplest usage of query is
simply to check whether a parameter name exists in the template, using
the C<name> option:

  if ($template->query(name => 'foo')) {
    # do something if a varaible of any type 
    # named FOO is in the template
  }

This same usage returns the type of the parameter.  The type is the
same as the tag minus the leading 'TMPL_'.  So, for example, a
TMPL_VAR parameter returns 'VAR' from query().

  if ($template->query(name => 'foo') eq 'VAR') {
    # do something if FOO exists and is a TMPL_VAR
  }

Note that the variables associated with TMPL_IFs and TMPL_UNLESSs will
be identified as 'VAR' unless they are also used in a TMPL_LOOP, in
which case they will return 'LOOP'.

C<query()> also allows you to get a list of parameters inside a loop
(and inside loops inside loops).  Example loop:

   <TMPL_LOOP NAME="EXAMPLE_LOOP">
     <TMPL_VAR NAME="BEE">
     <TMPL_VAR NAME="BOP">
     <TMPL_LOOP NAME="EXAMPLE_INNER_LOOP">
       <TMPL_VAR NAME="INNER_BEE">
       <TMPL_VAR NAME="INNER_BOP">
     </TMPL_LOOP>
   </TMPL_LOOP>

And some query calls:
  
  # returns 'LOOP'
  $type = $template->query(name => 'EXAMPLE_LOOP');
    
  # returns ('bop', 'bee', 'example_inner_loop')
  @param_names = $template->query(loop => 'EXAMPLE_LOOP');

  # both return 'VAR'
  $type = $template->query(name => ['EXAMPLE_LOOP', 'BEE']);
  $type = $template->query(name => ['EXAMPLE_LOOP', 'BOP']);

  # and this one returns 'LOOP'
  $type = $template->query(name => ['EXAMPLE_LOOP', 
                                    'EXAMPLE_INNER_LOOP']);
  
  # and finally, this returns ('inner_bee', 'inner_bop')
  @inner_param_names = $template->query(loop => ['EXAMPLE_LOOP',
                                                 'EXAMPLE_INNER_LOOP']);

  # for non existent parameter names you get undef
  # this returns undef.
  $type = $template->query(name => 'DWEAZLE_ZAPPA');

  # calling loop on a non-loop parameter name will cause an error.
  # this dies:
  $type = $template->query(loop => 'DWEAZLE_ZAPPA');

As you can see above the C<loop> option returns a list of parameter
names and both C<name> and C<loop> take array refs in order to refer
to parameters inside loops.  It is an error to use C<loop> with a
parameter that is not a loop.

Note that all the names are returned in lowercase and the types are
uppercase.

Just like C<param()>, C<query()> with no arguements returns all the
parameter names in the template at the top level.

=cut

sub query {
  my $self = shift;
  $self->{options}{debug} and print STDERR "### HTML::Template Debug ### query(", join(', ', @_), ")\n";

  # the no-parameter case - return $self->param()
  return $self->param() unless scalar(@_);
  
  croak("HTML::Template::query() : Odd number of parameters passed to query!")
    if (scalar(@_) % 2);
  croak("HTML::Template::query() : Wrong number of parameters passed to query - should be 2.")
    if (scalar(@_) != 2);

  my ($opt, $path) = (lc shift, shift);
  croak("HTML::Template::query() : invalid parameter ($opt)")
    unless ($opt eq 'name' or $opt eq 'loop');

  # make path an array unless it already is
  $path = [$path] unless (ref $path);

  # find the param in question.
  my @objs = $self->_find_param(@$path);
  return undef unless scalar(@objs);
  my ($obj, $type);

  # do what the user asked with the object
  if ($opt eq 'name') {
    # we only look at the first one.  new() should make sure they're
    # all the same.
    ($obj, $type) = (shift(@objs), shift(@objs));
    return undef unless defined $obj;
    return 'VAR' if $type eq 'HTML::Template::VAR';
    return 'LOOP' if $type eq 'HTML::Template::LOOP';
    croak("HTML::Template::query() : unknown object ($type) in param_map!");

  } elsif ($opt eq 'loop') {
    my %results;
    while(@objs) {
      ($obj, $type) = (shift(@objs), shift(@objs));
      croak("HTML::Template::query() : Search path [", join(', ', @$path), "] doesn't end in a TMPL_LOOP - it is an error to use the 'loop' option on a non-loop parameter.  To avoid this problem you can use the 'name' option to query() to check the type first.") 
        unless ((defined $obj) and ($type eq 'HTML::Template::LOOP'));
      
      # SHAZAM!  This bit extracts all the parameter names from all the
      # loop objects for this name.
      map {$results{$_} = 1} map { keys(%{$_->{'param_map'}}) }
        values(%{$obj->[HTML::Template::LOOP::TEMPLATE_HASH]});
    }
    # this is our loop list, return it.
    return keys(%results);   
  }
}

# a function that returns the object(s) corresponding to a given path and
# its (their) ref()(s).  Used by query() in the obvious way.
sub _find_param {
  my $self = shift;
  my $spot = $self->{options}{case_sensitive} ? shift : lc shift;

  # get the obj and type for this spot
  my $obj = $self->{'param_map'}{$spot};
  return unless defined $obj;
  my $type = ref $obj;

  # return if we're here or if we're not but this isn't a loop
  return ($obj, $type) unless @_;
  return unless ($type eq 'HTML::Template::LOOP');

  # recurse.  this is a depth first seach on the template tree, for
  # the algorithm geeks in the audience.
  return map { $_->_find_param(@_) }
    values(%{$obj->[HTML::Template::LOOP::TEMPLATE_HASH]});
}

# HTML::Template::VAR, LOOP, etc are *light* objects - their internal
# spec is used above.  No encapsulation or information hiding is to be
# assumed.

package HTML::Template::VAR;

sub new {
    my $value;
    return bless(\$value, $_[0]);
}

package HTML::Template::DEFAULT;

sub new {
    my $value = $_[1];
    return bless(\$value, $_[0]);
}

package HTML::Template::LOOP;

sub new {
    return bless([], $_[0]);
}

sub output {
  my $self = shift;
  my $index = shift;
  my $loop_context_vars = shift;
  my $template = $self->[TEMPLATE_HASH]{$index};
  my $value_sets_array = $self->[PARAM_SET];
  return unless defined($value_sets_array);  
  
  my $result = '';
  my $count = 0;
  my $odd = 0;
  foreach my $value_set (@$value_sets_array) {
    if ($loop_context_vars) {
      if ($count == 0) {
        @{$value_set}{qw(__first__ __inner__ __last__)} = (1,0,$#{$value_sets_array} == 0);
      } elsif ($count == $#{$value_sets_array}) {
        @{$value_set}{qw(__first__ __inner__ __last__)} = (0,0,1);
      } else {
        @{$value_set}{qw(__first__ __inner__ __last__)} = (0,1,0);
      }
      $odd = $value_set->{__odd__} = not $odd;
      $value_set->{__counter__} = $count + 1;
    }
    $template->param($value_set);    
    $result .= $template->output;
    $template->clear_params;
    @{$value_set}{qw(__first__ __last__ __inner__ __odd__ __counter__)} = 
      (0,0,0,0)
        if ($loop_context_vars);
    $count++;
  }

  return $result;
}

package HTML::Template::COND;

sub new {
  my $pkg = shift;
  my $var = shift;
  my $self = [];
  $self->[VARIABLE] = $var;

  bless($self, $pkg);  
  return $self;
}

package HTML::Template::NOOP;
sub new {
  my $unused;
  my $self = \$unused;
  bless($self, $_[0]);
  return $self;
}

package HTML::Template::ESCAPE;
sub new {
  my $unused;
  my $self = \$unused;
  bless($self, $_[0]);
  return $self;
}

package HTML::Template::JSESCAPE;
sub new {
  my $unused;
  my $self = \$unused;
  bless($self, $_[0]);
  return $self;
}

package HTML::Template::URLESCAPE;
sub new {
  my $unused;
  my $self = \$unused;
  bless($self, $_[0]);
  return $self;
}

# scalar-tying package for output(print_to => *HANDLE) implementation
package HTML::Template::PRINTSCALAR;
use strict;

sub TIESCALAR { bless \$_[1], $_[0]; }
sub FETCH { }
sub STORE {
  my $self = shift;
  local *FH = $$self;
  print FH @_;
}
1;
__END__

=head1 FREQUENTLY ASKED QUESTIONS

In the interest of greater understanding I've started a FAQ section of
the perldocs.  Please look in here before you send me email.

=over 4

=item 1

Q: Is there a place to go to discuss HTML::Template and/or get help?

A: There's a mailing-list for discussing HTML::Template at
html-template-users@lists.sourceforge.net.  To join:

   http://lists.sourceforge.net/lists/listinfo/html-template-users

If you just want to get email when new releases are available you can
join the announcements mailing-list here:

   http://lists.sourceforge.net/lists/listinfo/html-template-announce
    
=item 2

Q: Is there a searchable archive for the mailing-list?

A: Yes, you can find an archive of the SourceForge list here:

  http://www.geocrawler.com/lists/3/SourceForge/23294/0/

For an archive of the old vm.com list, setup by Sean P. Scanlon, see:

   http://bluedot.net/mail/archive/

=item 3

Q: I want support for <TMPL_XXX>!  How about it?

A: Maybe.  I definitely encourage people to discuss their ideas for
HTML::Template on the mailing list.  Please be ready to explain to me
how the new tag fits in with HTML::Template's mission to provide a
fast, lightweight system for using HTML templates.

NOTE: Offering to program said addition and provide it in the form of
a patch to the most recent version of HTML::Template will definitely
have a softening effect on potential opponents!

=item 4

Q: I found a bug, can you fix it?

A: That depends.  Did you send me the VERSION of HTML::Template, a test
script and a test template?  If so, then almost certainly.

If you're feeling really adventurous, HTML::Template has a publically
available CVS server.  See below for more information in the PUBLIC
CVS SERVER section.

=item 5

Q: <TMPL_VAR>s from the main template aren't working inside a
<TMPL_LOOP>!  Why?

A: This is the intended behavior.  <TMPL_LOOP> introduces a separate
scope for <TMPL_VAR>s much like a subroutine call in Perl introduces a
separate scope for "my" variables.

If you want your <TMPL_VAR>s to be global you can set the
'global_vars' option when you call new().  See above for documentation
of the 'global_vars' new() option.

=item 6

Q: Why do you use /[Tt]/ instead of /t/i?  It's so ugly!

A: Simple - the case-insensitive match switch is very inefficient.
According to _Mastering_Regular_Expressions_ from O'Reilly Press,
/[Tt]/ is faster and more space efficient than /t/i - by as much as
double against long strings.  //i essentially does a lc() on the
string and keeps a temporary copy in memory.

When this changes, and it is in the 5.6 development series, I will
gladly use //i.  Believe me, I realize [Tt] is hideously ugly.

=item 7

Q: How can I pre-load my templates using cache-mode and mod_perl?

A: Add something like this to your startup.pl:

   use HTML::Template;
   use File::Find;

   print STDERR "Pre-loading HTML Templates...\n";
   find(
        sub {
          return unless /\.tmpl$/;
          HTML::Template->new(
                              filename => "$File::Find::dir/$_",
                              cache => 1,
                             );
        },
        '/path/to/templates',
        '/another/path/to/templates/'
      );

Note that you'll need to modify the "return unless" line to specify
the extension you use for your template files - I use .tmpl, as you
can see.  You'll also need to specify the path to your template files.

One potential problem: the "/path/to/templates/" must be EXACTLY the
same path you use when you call HTML::Template->new().  Otherwise the
cache won't know they're the same file and will load a new copy -
instead getting a speed increase, you'll double your memory usage.  To
find out if this is happening set cache_debug => 1 in your application
code and look for "CACHE MISS" messages in the logs.

=item 8

Q: What characters are allowed in TMPL_* NAMEs?

A: Numbers, letters, '.', '/', '+', '-' and '_'.

=item 9

Q: How can I execute a program from inside my template?  

A: Short answer: you can't.  Longer answer: you shouldn't since this
violates the fundamental concept behind HTML::Template - that design
and code should be seperate.

But, inevitably some people still want to do it.  If that describes
you then you should take a look at
L<HTML::Template::Expr|HTML::Template::Expr>.  Using
HTML::Template::Expr it should be easy to write a run_program()
function.  Then you can do awful stuff like:

  <tmpl_var expr="run_program('foo.pl')">

Just, please, don't tell me about it.  I'm feeling guilty enough just
for writing HTML::Template::Expr in the first place.

=item 10

Q: Can I get a copy of these docs in Japanese?

A: Yes you can.  See Kawai Takanori's translation at:

   http://member.nifty.ne.jp/hippo2000/perltips/html/template.htm

=item 11

Q: What's the best way to create a <select> form element using
HTML::Template?

A: There is much disagreement on this issue.  My personal preference
is to use CGI.pm's excellent popup_menu() and scrolling_list()
functions to fill in a single <tmpl_var select_foo> variable.  

To some people this smacks of mixing HTML and code in a way that they
hoped HTML::Template would help them avoid.  To them I'd say that HTML
is a violation of the principle of separating design from programming.
There's no clear separation between the programmatic elements of the
<form> tags and the layout of the <form> tags.  You'll have to draw
the line somewhere - clearly the designer can't be entirely in charge
of form creation.

It's a balancing act and you have to weigh the pros and cons on each side.
It is certainly possible to produce a <select> element entirely inside the
template.  What you end up with is a rat's nest of loops and conditionals.
Alternately you can give up a certain amount of flexibility in return for
vastly simplifying your templates.  I generally choose the latter.

Another option is to investigate HTML::FillInForm which some have
reported success using to solve this problem.

=back

=head1 BUGS

I am aware of no bugs - if you find one, join the mailing list and
tell us about it.  You can join the HTML::Template mailing-list by
visiting:

  http://lists.sourceforge.net/lists/listinfo/html-template-users

Of course, you can still email me directly (sam@tregar.com) with bugs,
but I reserve the right to forward bug reports to the mailing list.

When submitting bug reports, be sure to include full details,
including the VERSION of the module, a test script and a test template
demonstrating the problem!

If you're feeling really adventurous, HTML::Template has a publically
available CVS server.  See below for more information in the PUBLIC
CVS SERVER section.

=head1 CREDITS

This module was the brain child of my boss, Jesse Erlbaum
( jesse@vm.com ) at Vanguard Media ( http://vm.com ) .  The most original
idea in this module - the <TMPL_LOOP> - was entirely his.

Fixes, Bug Reports, Optimizations and Ideas have been generously
provided by:

   Richard Chen
   Mike Blazer
   Adriano Nagelschmidt Rodrigues
   Andrej Mikus
   Ilya Obshadko
   Kevin Puetz
   Steve Reppucci
   Richard Dice
   Tom Hukins
   Eric Zylberstejn
   David Glasser
   Peter Marelas
   James William Carlson
   Frank D. Cringle
   Winfried Koenig
   Matthew Wickline
   Doug Steinwand
   Drew Taylor
   Tobias Brox
   Michael Lloyd
   Simran Gambhir
   Chris Houser <chouser@bluweb.com>
   Larry Moore
   Todd Larason
   Jody Biggs
   T.J. Mather
   Martin Schroth
   Dave Wolfe
   uchum
   Kawai Takanori
   Peter Guelich
   Chris Nokleberg
   Ralph Corderoy
   William Ward
   Ade Olonoh
   Mark Stosberg
   Lance Thomas
   Roland Giersig
   Jere Julian
   Peter Leonard
   Kenny Smith
   Sean P. Scanlon
   Martin Pfeffer
   David Ferrance
   Gyepi Sam  
   Darren Chamberlain
   Paul Baker
   Gabor Szabo
   Craig Manley

Thanks!

=head1 WEBSITE

You can find information about HTML::Template and other related modules at:

   http://html-template.sourceforge.net

=head1 PUBLIC CVS SERVER

HTML::Template now has a publicly accessible CVS server provided by
SourceForge (www.sourceforge.net).  You can access it by going to
http://sourceforge.net/cvs/?group_id=1075.  Give it a try!

=head1 AUTHOR

Sam Tregar, sam@tregar.com

=head1 LICENSE

  HTML::Template : A module for using HTML Templates with Perl
  Copyright (C) 2000-2002 Sam Tregar (sam@tregar.com)

  This module is free software; you can redistribute it and/or modify it
  under the terms of either:

  a) the GNU General Public License as published by the Free Software
  Foundation; either version 1, or (at your option) any later version,
  
  or

  b) the "Artistic License" which comes with this module.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either
  the GNU General Public License or the Artistic License for more details.

  You should have received a copy of the Artistic License with this
  module, in the file ARTISTIC.  If not, I'll be glad to provide one.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  USA

=cut
