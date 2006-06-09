package LWP::UserAgent::Local;

use LWP::UserAgent;
use base 'LWP::UserAgent';
use IPC::Open2 'open2';

=pod

The ScriptAlias parameter to LWP::UserAgent::Local::new is used to
find what part of a URI's path corresponds to the script name

The ScriptAlias is matched against the path; the single path component
that follows is the script name.

Ultimately, it should take multiple ScriptAliases and should map them
to file-system paths.

=cut

sub new {
    $class = shift;
    my %super_args = %{$_[0]};
    delete $super_args{ScriptAlias};
    delete $super_args{AddHandler};
    $this = $class->SUPER::new(%super_args);
    %$this = %{$_[0]};
    $this;
}

sub request { &simple_request }

sub simple_request {
    my $this = shift;
    my $request = shift;
    my ($options) = @_;

    Carp::croak "LWP::UserAgent::Local::request requires an HTTP::Request argument"
	unless ref $request && $request->isa('HTTP::Request');

    my $request_method = $request->method();
    $request_method = "GET" unless $request_method;

    my $script_alias = $this->{ScriptAlias};
    if ($this->{AddHandler}) {
        my ($handler, $ext) = split / +/, $this->{AddHandler};
        return unless $request->uri->path() =~ /$ext$/;
    }
    my($script_name, $path) = ($request->uri->path() =~ m|^(?:\w+://[^/]*/?)?$script_alias([^/]*)(/?.*)|);
    $script_name or
        die "Couldn't determine script name from " . $request->uri()->path();
    $ENV{REQUEST_URI} = $script_alias;

    $this->{cookie_jar}->add_cookie_header($request) if $this->{cookie_jar};

    shift;
    ###delete $ENV{$_} foreach (grep {/^HTTP_/} (keys %ENV));
    $request->headers()->scan(sub {
        $header_name = $_[0];
        $header_name =~ tr/a-z-/A-Z_/;
        $ENV{"HTTP_" . $header_name} = $_[1];
    });

    $ENV{REQUEST_METHOD} = $request_method;
    foreach $header (@headers) {
        my ($header_name, $header_val) = $header =~ /(.*?):(.*)/;
        $header_name =~ tr/a-z-/A-Z_/;
        $ENV{"HTTP_" . $header_name} = $header_val;
    }
    $ENV{SCRIPT_NAME} = $script_name;
    $ENV{PATH_INFO} = $path;
    $ENV{QUERY_STRING} = $request->uri->query || '';
    $ENV{HTTP_USER_AGENT} = "Ezra's Local User Agent 0.1";
    print $ENV{REQUEST_METHOD}." => " . $ENV{SCRIPT_NAME}.$ENV{PATH_INFO}."\n"
        if $options->{verbose};

    if ($request->content()) {
        $ENV{CONTENT_LENGTH} = length $request->content();
        my $pid = open2(\*RESPONSE, \*REQUEST, "./$script_name")
            or die "Couldn't spawn ./$script_name";
        print REQUEST $request->content();
        close REQUEST;
    } else {
        open RESPONSE, "./$script_name|" or die "Couldn't spawn $script_name";
        print STDERR "$script_name exit status: $?\n" if $?;
    }

    my $response = new HTTP::Response();
    $response->request($request);
    my $status_line;
    while (($line = <RESPONSE>) !~ /^\s*$/) {
        if ($line =~ /^Status:/i) {
            $status_line = $line;
        } else {
            my ($hdr_name, $hdr_val) = ($line =~ /(.*?):(.*)/);
            $response->header($hdr_name => $hdr_val);
        }
#	print "S: ", $line;
    }

    $this->{cookie_jar}->extract_cookies($response) if $this->{cookie_jar};
    $status_line =~ s/Status: //i;
    my ($response_code,$response_desc)= $status_line =~ /^(\d\d\d)(\s.*)?$/;
    $response->code($response_code);
    $response->message($response_desc);
    
    local $/ = undef;
    $body = <RESPONSE>;
    $response->content($body);

    close RESPONSE;
    $response;
}

1;

