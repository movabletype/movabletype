package IPC::Cmd;

use Params::Check               qw[check];
use Module::Load::Conditional   qw[can_load];
use Locale::Maketext::Simple    Style => 'gettext';

use ExtUtils::MakeMaker();
use File::Spec ();
use Config;

use strict;

require Carp;
$Carp::CarpLevel = 1;

BEGIN {
    use Exporter    ();
    use vars        qw[ @ISA $VERSION @EXPORT_OK $VERBOSE
                        $USE_IPC_RUN $USE_IPC_OPEN3
                    ];

    $VERSION        = '0.24';
    $VERBOSE        = 0;
    $USE_IPC_RUN    = 1;
    $USE_IPC_OPEN3  = 1;

    @ISA            = qw[Exporter];
    @EXPORT_OK      = qw[can_run run];
}

### check if we can run some command ###
sub can_run {
    my $command = shift;

    if( File::Spec->file_name_is_absolute($command) ) {
        return MM->maybe_command($command);
    
    } else {    
        for my $dir (split /$Config{path_sep}/, $ENV{PATH}) {
            my $abs = File::Spec->catfile($dir, $command);
            return $abs if $abs = MM->maybe_command($abs);
        }
    }
}


### Execute a command: $cmd may be a scalar or an arrayref of cmd and args
### $bufout is a scalar ref to store outputs, $verbose can override conf
sub run {
    my %hash = @_;

    my $x = '';
    my $tmpl = {
        verbose => { default    => $VERBOSE },
        command => { required   => 1,
                     allow      => sub {my $cmd = pop();
                                        !(ref $cmd) or ref $cmd eq 'ARRAY' }
                   },
        buffer  => { default => \$x },             
    };

    my $args = check( $tmpl, \%hash, $VERBOSE )
                or ( warn(loc(q[Could not validate input!])), return );

    ### Kludge! This enables autoflushing for each perl process we launched.
    ### XXX probably not really needed, and seems to throw quite a few
    ### 'make test' etc off to have PERL5OPT set
    #local $ENV{PERL5OPT} = ($ENV{PERL5OPT} || '') . 
    #                            ' -MIPC::Cmd::System=autoflush=1';

    my $verbose     = $args->{verbose};
    my $is_win98    = ($^O eq 'MSWin32' and !Win32::IsWinNT());

    my $err;                # error flag
    my $have_buffer;        # to indicate we executed via IPC::Run 
                            # or IPC::Open3 only then it makes sence 
                            # to return the buffers

    my (@buffer,@buferr,@bufout);

    ### STDOUT message handler
    my $_out_handler = sub {
    #sub _out_handler {
        my $buf = shift;
        return unless defined $buf;

        print STDOUT $buf if $verbose;
        push @buffer, $buf;
        push @bufout, $buf;
    };

    ### STDERR message handler
    my $_err_handler = sub {
    #sub _err_handler {
        my $buf = shift;
        return unless defined $buf;

        print STDERR $buf if $verbose;
        push @buffer, $buf;
        push @buferr, $buf;
    };

    my $cmd = $args->{command};
    my @cmd = ref ($cmd) ? grep(length, @{$cmd}) : $cmd;

    print loc(qq|Running [%1]...\n|,"@cmd") if $verbose;

    ### First, we prefer Barrie Slaymaker's wonderful IPC::Run module.
    if (!$is_win98 and $USE_IPC_RUN and 
        can_load(
            modules => { 'IPC::Run' => '0.55' },
            verbose => $verbose && ($^O eq 'MSWin32') ) 
    ) {
        STDOUT->autoflush(1); STDERR->autoflush(1);

        $have_buffer++;

        ### a command like:
        # [
        #     '/usr/bin/gzip',
        #     '-cdf',
        #     '/Users/kane/sources/p4/other/archive-extract/t/src/x.tgz',
        #     '|',
        #     '/usr/bin/tar',
        #     '-tf -'
        # ]
        ### needs to become:
        # [
        #     ['/usr/bin/gzip', '-cdf',
        #       '/Users/kane/sources/p4/other/archive-extract/t/src/x.tgz']
        #     '|',
        #     ['/usr/bin/tar', '-tf -']
        # ]

        my @command; my $special_chars;
        if( ref $cmd ) {
            my $aref = [];
            for my $item (@cmd) {
                if( $item =~ /[<>|&]/ ) {
                    push @command, $aref, $item;
                    $aref = [];                  
                    $special_chars++;
                } else {
                    push @$aref, $item;
                }
            }            
            push @command, $aref;
        } else {
            @command = map { if( /[<>|&]/ ) {
                                $special_chars++; $_;
                             } else {                            
                                [ split / +/ ]
                             }
                        } split( /\s*([<>|&])\s*/, $cmd );
        }
        
        ### due to the double '>' construct, stdout buffers are now ending
        ### up in the stderr buffer. this is a bug in IPC::Run.
        ### Mailed barries about this early june, no solution yet :(
        ### update (23-6-04): so this thing with the double > makes
        ### this command not even fill any buffer:
        ###     perl -lewarn$$
        ### so it looks like when there are no 'special' chars in the
        ### command, like '|' and friends, best not use the '>' construct.
        if( $special_chars ) {              
            IPC::Run::run(@command, \*STDIN, '>', $_out_handler, 
                                             '>', $_err_handler) or $err++;
        } else {
            IPC::Run::run(@command, \*STDIN, $_out_handler, 
                                         $_err_handler) or $err++;
        }
 
 
    ### Next, IPC::Open3 is know to fail on Win32, but works on Un*x.
    } elsif (   $^O !~ /^(?:MSWin32|cygwin)$/
                and $USE_IPC_OPEN3
                and can_load(
                    modules => { map{$_ => '0.0'} 
                                qw|IPC::Open3 IO::Select Symbol| },
                    verbose => $verbose
    ) ) {
        my $rv;
        ($rv,$err) = _open3_run(\@cmd, $_out_handler, $_err_handler);
        $have_buffer++;


    ### Abandon all hope; falls back to simple system() on verbose calls.
    } elsif ($verbose) {
        ### quote for if we have pipes or anything else in there
        system("@cmd");
        $err = $? ? $? : 0;

    ### Non-verbose system() needs to have STDOUT and STDERR muted.
    } else {
        local *SAVEOUT; local *SAVEERR;

        open(SAVEOUT, ">&STDOUT")
            or warn(loc("couldn't dup STDOUT: %1",$!)),      return;
        open(STDOUT, ">".File::Spec->devnull)
            or warn "couldn't reopen STDOUT: $!",   return;

        open(SAVEERR, ">&STDERR")
            or warn(loc("couldn't dup STDERR: %1",$!)),      return;
        open(STDERR, ">".File::Spec->devnull)
            or warn(loc("couldn't reopen STDERR: %1",$!)),   return;

        ### quote for if we have pipes or anything else in there
        system("@cmd");

        open(STDOUT, ">&SAVEOUT")
            or warn(loc("couldn't restore STDOUT: %1",$!)), return;
        open(STDERR, ">&SAVEERR")
            or warn(loc("couldn't restore STDERR: %1",$!)), return;
    }

    ### unless $err has been set from _open3_run, set it to $? ###
    $err ||= $?;

    if ( scalar @buffer ) {
        my $capture = $args->{buffer};
        $$capture = join '', @buffer;
    }
    
    return wantarray
                ? $have_buffer
                    ? (!$err, $?, \@buffer, \@bufout, \@buferr)
                    : (!$err, $? )
                : !$err
}


### IPC::Run::run emulator, using IPC::Open3.
sub _open3_run {
    my ($cmdref, $_out_handler, $_err_handler, $verbose) = @_;
    
    ### in case there are pipes in there;
    ### IPC::Open3 will call exec and exec will do the right thing ###
    my $cmd = join " ", @$cmdref;

    ### Following code are adapted from Friar 'abstracts' in the
    ### Perl Monastery (http://www.perlmonks.org/index.pl?node_id=151886).

    my ($infh, $outfh, $errfh); # open3 handles

    my $pid = eval {
        IPC::Open3::open3(
            $infh   = Symbol::gensym(),
            $outfh  = Symbol::gensym(),
            $errfh  = Symbol::gensym(),
            $cmd,
        )
    };


    return (undef, $@) if $@;

    my $sel = IO::Select->new; # create a select object
    $sel->add($outfh, $errfh); # and add the fhs

    STDOUT->autoflush(1); STDERR->autoflush(1);
    $outfh->autoflush(1) if UNIVERSAL::can($outfh, 'autoflush');
    $errfh->autoflush(1) if UNIVERSAL::can($errfh, 'autoflush');

    while (my @ready = $sel->can_read) {
        foreach my $fh (@ready) { # loop through buffered handles
            # read up to 4096 bytes from this fh.
            my $len = sysread $fh, my($buf), 4096;

            if (not defined $len){
                # There was an error reading
                warn loc("Error from child: %1",$!);
                return(undef, $!);
            }
            elsif ($len == 0){
                $sel->remove($fh); # finished reading
                next;
            }
            elsif ($fh == $outfh) {
                $_out_handler->($buf);
            } elsif ($fh == $errfh) {
                $_err_handler->($buf);
            } else {
                warn loc("%1 error", 'IO::Select');
                return(undef, $!);
            }
        }
    }

    waitpid $pid, 0; # wait for it to die
    return 1;
}

1;

__END__

=pod

=head1 NAME

IPC::Cmd - finding and running system commands made easy

=head1 SYNOPSIS

    use IPC::Cmd qw[can_run run];

    my $full_path = can_run('wget') or warn 'wget is not installed!';


    ### commands can be arrayrefs or strings ###
    my $cmd = "$full_path -b theregister.co.uk";
    my $cmd = [$full_path, '-b', 'theregister.co.uk'];

    ### in scalar context ###
    my $buffer;
    if( scalar run( command => $cmd, 
                    verbose => 0,
                    buffer  => \$buffer ) 
    ) {
        print "fetched webpage successfully\n";
    }


    ### in list context ###
    my( $success, $error_code, $full_buf, $stdout_buf, $stderr_buf ) =
            run( command => $cmd, verbose => 0 );

    if( $success ) {
        print "this is what the command printed:\n";
        print join "", @$full_buf;
    }


    ### don't have IPC::Cmd be verbose, ie don't print to stdout or
    ### stderr when running commands -- default is '0'
    $IPC::Cmd::VERBOSE = 0;

=head1 DESCRIPTION

IPC::Cmd allows you to run commands, interactively if desired,
platform independent but have them still work.

The C<can_run> function can tell you if a certain binary is installed
and if so where, whereas the C<run> function can actually execute any
of the commands you give it and give you a clear return value, as well
as adhere to your verbosity settings.

=head1 FUNCTIONS

=head2 can_run

C<can_run> takes but a single argument: the name of a binary you wish
to locate. C<can_run> works much like the unix binary C<which> or the bash
command C<type>, which scans through your path, looking for the requested
binary .

Unlike C<which> and C<type>, this function is platform independent and
will also work on, for example, Win32.

It will return the full path to the binary you asked for if it was
found, or C<undef> if it was not.

=head2 run

C<run> takes 3 arguments:

=over 4

=item command

This is the command to execute. It may be either a string or an array
reference. 
This is a required argument.

See L<CAVEATS> for remarks on how commands are parsed and their 
limitations.

=item verbose

This controls whether all output of a command should also be printed
to STDOUT/STDERR or should only be trapped in buffers (NOTE: buffers
require C<IPC::Run> to be installed or your system able to work with
C<IPC::Open3>).

It will default to the global setting of C<$IPC::Cmd::VERBOSE>,
which by default is 0.

=item buffer

This will hold all the output of a command. It needs to be a reference
to a scalar.
Note that this will hold both the STDOUT and STDERR messages, and you
have no way of telling which is which.
If you require this distinction, run the C<run> command in list context
and inspect the individual buffers.

Of course, this requires that the underlying call supports buffers. See
the note on buffers right above.

=back

C<run> will return a simple C<true> or C<false> when called in scalar
context.
In list context, you will be returned a list of the following items:

=over 4

=item success

A simple boolean indicating if the command executed without errors or
not.

=item errorcode

If the first element of the return value (success) was 0, then some
error occurred. This second element is the error code the command
you requested exited with, if available.

=item full_buffer

This is an arrayreference containing all the output the command
generated.
Note that buffers are only available if you have C<IPC::Run> installed,
or if your system is able to work with C<IPC::Open3> -- See below).
This element will be C<undef> if this is not the case.

=item out_buffer

This is an arrayreference containing all the output sent to STDOUT the
command generated.
Note that buffers are only available if you have C<IPC::Run> installed,
or if your system is able to work with C<IPC::Open3> -- See below).
This element will be C<undef> if this is not the case.

=item error_buffer

This is an arrayreference containing all the output sent to STDERR the
command generated.
Note that buffers are only available if you have C<IPC::Run> installed,
or if your system is able to work with C<IPC::Open3> -- See below).
This element will be C<undef> if this is not the case.

=back

C<run> will try to execute your command using the following logic:

=over 4

=item *

If you are not on windows 98 and have C<IPC::Run> installed, use that
to execute the command. You will have the full output available in
buffers, interactive commands are sure to work  and you are guaranteed
to have your verbosity settings honored cleanly.

=item *

Otherwise, if you are not on MSWin32 or Cygwin, try to execute the
command by using C<IPC::Open3>. Buffers will be available, interactive
commands will still execute cleanly, and also your  verbosity settings
will be adhered to nicely;

=item *

Otherwise, if you have the verbose argument set to true, we fall back
to a simple system() call. We cannot capture any buffers, but
interactive commands will still work.

=item *

Otherwise we will try and temporarily redirect STDERR and STDOUT, do a
system() call with your command and then re-open STDERR and STDOUT.
This is the method of last resort and will still allow you to execute
your commands cleanly. However, no buffers will be available.

=head1 Global Variables

The behaviour of IPC::Cmd can be altered by changing the following
global variables:

=head2 $IPC::Cmd::VERBOSE

This controls whether IPC::Cmd will print any output from the
commands to the screen or not. The default is 0;

=head2 $IPC::Cmd::USE_IPC_RUN

This variable controls whether IPC::Cmd will try to use L<IPC::Run> 
when available and suitable. Defaults to true.

=head2 $IPC::Cmd::USE_IPC_OPEN3

This variable controls whether IPC::Cmd will try to use L<IPC::Open3>
when available and suitable. Defaults to true.

=head2 Caveats

=over 4

=item Whitespace

When you provide a string as this argument, the string will be
split on whitespace to determine the individual elements of your 
command. Although this will usually just Do What You Mean, it may
break if you have files or commands with whitespace in them. 

If you do not wish this to happen, you should provide an array 
reference, where all parts of your command are already separated out.
Note however, if there's extra or spurious whitespace in these parts,
the parser or underlying code may not interpret it correctly, and
cause an error.

Example:
The following code
    
    gzip -cdf foo.tar.gz | tar -xf -
    
should either be passed as

    "gzip -cdf foo.tar.gz | tar -xf -"

or as

    ['gzip', '-cdf', 'foo.tar.gz', '|', 'tar', '-xf', '-']
    
But take care not to pass it as, for example
    
    ['gzip -cdf foo.tar.gz', '|', 'tar -xf -']            

Since this will lead to issues as described above.

=item IO Redirect

Currently it is too complicated to parse your command for IO 
Redirections. For capturing STDOUT or STDERR there is a work around
however, since you can just inspect your buffers for the contents.

=item IPC::Run buffer capture bug

Due to a bug in C<IPC::Run> versions upto and including the latest one
at the time of writing (0.78), C<run()> calls executed via C<IPC::Run>
will not be able to differentiate between C<STDOUT> and C<STDERR> 
output when C<special characters> are present in the command (like 
<,>,| and &); All output will be caught in the C<STDERR> buffer.

Note that this is only a problem if you use the long output of C<run()>
and not if you provide the C<buffer> option to the command.

If this limitation is not acceptable to you, consider setting the 
global variable C<$IPC::Cmd::USE_IPC_RUN> to false.


=back

=head1 See Also

C<IPC::Run>, C<IPC::Open3>

=head1 AUTHOR

This module by
Jos Boumans E<lt>kane@cpan.orgE<gt>.

=head1 COPYRIGHT

This module is
copyright (c) 2002,2003,2004 Jos Boumans E<lt>kane@cpan.orgE<gt>.
All rights reserved.

This library is free software;
you may redistribute and/or modify it under the same
terms as Perl itself.
