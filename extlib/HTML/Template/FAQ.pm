use strict;
use warnings;
package HTML::Template::FAQ;

# ABSTRACT: Frequently Asked Questions about HTML::Template
use Carp ();
Carp::confess "you're not meant to use the FAQ, just read it!";
1;

__END__

=pod 

=head1 NAME 

HTML::Template::FAQ - Frequently Asked Questions about HTML::Template

=head1 SYNOPSIS

In the interest of greater understanding I've started a FAQ section of
the perldocs. Please look in here before you send me email.

=head1 FREQUENTLY ASKED QUESTIONS

=head2 Is there a place to go to discuss HTML::Template and/or get help?

There's a mailing-list for discussing L<HTML::Template> at
html-template-users@lists.sourceforge.net. Join at:

   http://lists.sourceforge.net/lists/listinfo/html-template-users

If you just want to get email when new releases are available you can
join the announcements mailing-list here:

    http://lists.sourceforge.net/lists/listinfo/html-template-announce
    
=head2 Is there a searchable archive for the mailing-list?

Yes, you can find an archive of the SourceForge list here:

    http://dir.gmane.org/gmane.comp.lang.perl.modules.html-template

=head2 I want support for <TMPL_XXX>! How about it?

Maybe. I definitely encourage people to discuss their ideas for
L<HTML::Template> on the mailing list. Please be ready to explain to me
how the new tag fits in with HTML::Template's mission to provide a fast,
lightweight system for using HTML templates.

NOTE: Offering to program said addition and provide it in the form of
a patch to the most recent version of L<HTML::Template> will definitely
have a softening effect on potential opponents!

=head2 I found a bug, can you fix it?

That depends. Did you send me the VERSION of L<HTML::Template>, a test
script and a test template? If so, then almost certainly.

If you're feeling really adventurous, L<HTML::Template> is publicly
available on GitHub (https://github.com/mpeters/html-template). Please
feel free to fork it and send me a pull request with any changes you have.

=head2 <TMPL_VAR>s from the main template aren't working inside a <TMPL_LOOP>! Why?

This is the intended behavior. C<< <TMPL_LOOP> >> introduces a separate
scope for C<< <TMPL_VAR>s >> much like a subroutine call in Perl
introduces a separate scope for C<my> variables.

If you want your C<< <TMPL_VAR> >>s to be global you can set the
C<global_vars> option when you call C<new()>. See above for documentation
of the C<global_vars> C<new()> option.

=head2 How can I pre-load my templates using cache-mode and mod_perl?

Add something like this to your startup.pl:

    use HTML::Template;
    use File::Find;

    print STDERR "Pre-loading HTML Templates...\n";
    find(
        sub {
            return unless /\.tmpl$/;
            HTML::Template->new(
                filename => "$File::Find::dir/$_",
                cache    => 1,
            );
        },
        '/path/to/templates',
        '/another/path/to/templates/'
    );

Note that you'll need to modify the C<return unless> line to specify
the extension you use for your template files - I use F<.tmpl>, as you
can see. You'll also need to specify the path to your template files.

One potential problem: the F</path/to/templates/> must be B<EXACTLY> the
same path you use when you call C<< HTML::Template->new() >>. Otherwise
the cache won't know they're the same file and will load a new copy -
instead getting a speed increase, you'll double your memory usage.
To find out if this is happening set C<cache_debug => 1> in your
application code and look for "CACHE MISS" messages in the logs.

=head2 What characters are allowed in TMPL_* names?

Numbers, letters, '.', '/', '+', '-' and '_'.

=head2 How can I execute a program from inside my template?

Short answer: you can't. Longer answer: you shouldn't since this violates
the fundamental concept behind L<HTML::Template> - that design and code
should be separate.

But, inevitably some people still want to do it. If that describes
you then you should take a look at L<HTML::Template::Expr>. Using
L<HTML::Template::Expr> it should be easy to write a C<run_program()>
function. Then you can do awful stuff like:

    <tmpl_var expr="run_program('foo.pl')">

Just, please, don't tell me about it. I'm feeling guilty enough just
for writing L<HTML::Template::Expr> in the first place.

=head2 What's the best way to create a <select> form element using HTML::Template?

There is much disagreement on this issue. My personal preference is
to use L<CGI.pm>'s excellent C<popup_menu()> and C<scrolling_list()>
functions to fill in a single C<< <tmpl_var select_foo> >> variable.

To some people this smacks of mixing HTML and code in a way that
they hoped L<HTML::Template> would help them avoid. To them I'd say
that HTML is a violation of the principle of separating design from
programming. There's no clear separation between the programmatic
elements of the C<< <form> >> tags and the layout of the C<< <form>
>> tags.  You'll have to draw the line somewhere - clearly the designer
can't be entirely in charge of form creation.

It's a balancing act and you have to weigh the pros and cons on each
side. It is certainly possible to produce a C<< <select> >> element
entirely inside the template. What you end up with is a rat's nest of
loops and conditionals. Alternately you can give up a certain amount of
flexibility in return for vastly simplifying your templates. I generally
choose the latter.

Another option is to investigate L<HTML::FillInForm> which some have
reported success using to solve this problem.
