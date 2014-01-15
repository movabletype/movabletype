package Net::FTP::Find::Mixin;

use strict;
use warnings;

our $VERSION = '0.041';

use Carp;
use File::Spec;
use File::Basename;
use Time::Local qw(timegm);
use Net::Cmd;
use File::Listing;

my @month_name_list = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);

sub import {
	my $class = shift;
	my $pkg = shift || 'Net::FTP';

	no strict 'refs';
	*{$pkg . '::find'} = \&find;
	*{$pkg . '::finddepth'} = \&finddepth;
}

sub finddepth {
	my $self = shift;
	my ($opts, @directories) = @_;

	my %options = (
		bydepth => 1,
	);

	if (ref $opts eq 'CODE') {
		$options{'wanted'} = $opts;
	}
	elsif (ref $opts eq 'HASH') {
		while (my ($k, $v) = each(%$opts)) {
			$options{$k} = $v;
		}
	}

	&find($self, \%options, @directories);
}

sub find {
	my $self = shift;
	my ($opts, @directories) = @_;

	my %options = (
		use_mlsd => 1,
	);

	if (ref $opts eq 'CODE') {
		$options{'wanted'} = $opts;
	}
	elsif (ref $opts eq 'HASH') {
		while (my ($k, $v) = each(%$opts)) {
			$options{$k} = $v;
		}
	}

	if (! $options{'wanted'}) {
		croak('no &wanted subroutine given');
	}

	if ( !$options{'fstype'} ) {
		$options{'fstype'} = 'unix';
		my $res = _command( $self, 'SYST' );
		if ( $res->[0] == CMD_OK ) {
			if ( $res->[1] =~ m/windows/i ) {
				$options{'fstype'} = 'dosftp';
			}
		}
	}

	defined(my $cwd = $self->pwd)
		or return;
	$cwd =~ s{/*\z}{/} if $cwd;

	foreach my $d (@directories) {
		&recursive( $self, $d =~ m!\A/! ? '' : $cwd, \%options, $d, 0 )
			or return;
	}

	1;
}

sub recursive {
	my $self = shift;
	my ($cwd, $opts, $directory, $depth) = @_;

	our (
		$name, $dir,
		$is_directory, $is_symlink, $mode,
		$permissions, $link, $user, $group, $size, $month, $mday, $year_or_time,
		$type, $ballpark_mtime,
		$unix_like_system_size, $unix_like_system_name,
		$mlsd_facts, $mtime,
	);

	return 1
		if (defined($opts->{'max_depth'}) && $depth > $opts->{'max_depth'});

	local $dir;
	my $orig_cwd = undef;
	my $entries;
	if ($opts->{'no_chdir'}) {
		$entries
			= _dir_entries( $self, $opts, $directory, undef, undef, undef,
			$depth == 0 )
			or return;
		return 1 unless @$entries;

		if ($depth == 0) {
			if (! grep {$_->{data}[0] eq '.'} @$entries) {
				build_start_dir( $self, $opts, $entries, $directory,
					dirname($directory) )
					or return;
			}
		}

		$dir = $directory;
	}
	else {
		defined($orig_cwd = $self->pwd)
			or return;
		if ($orig_cwd) {
			$orig_cwd =~ s{^/*}{/};
		}

		$self->cwd($directory)
			or return;
		$entries
			= _dir_entries( $self, $opts, '.', undef, undef, undef,
			$depth == 0 )
			or return;

		defined($dir = $self->pwd)
			or return;
		if ($dir) {
			$dir =~ s{^/*}{/};
		}
		elsif (defined($dir)) {
			$dir = $directory;
		}

		if ($depth == 0) {
			if (! grep {$_->{data}[0] eq '.'} @$entries) {
				$self->cwd('..')
					or return;
				build_start_dir($self, $opts, $entries, $directory, '.')
					or return;
			}

			$self->cwd($orig_cwd)
				or return;
		}

		if ( !@$entries ) {
			$self->cwd($orig_cwd)
				or return;
			return 1;
		}
	}

	my @dirs = ();
	foreach my $e (@$entries) {
		local (
			$permissions, $link, $user, $group, $unix_like_system_size, $month, $mday, $year_or_time, $unix_like_system_name
		) = split(/\s+/, $e->{line}, 9);
		local (
			$_, $type, $size, $ballpark_mtime, $mode
		) = @{ $e->{data} };
		local $mlsd_facts = $e->{mlsd_facts} || undef;

		next if $_ eq '..';
		next if $_ eq '.' && $depth != 0;

		if ($depth == 0) {
			next if $_ ne '.';
			$_ = $directory;
		}

		local $name = $depth == 0 ? $_ : File::Spec->catfile($dir, $_);
		$_ = $name if $opts->{'no_chdir'} && $depth != 0;
		my $next = $_;

		$name =~ s/$cwd// if $cwd;
		$dir  =~ s/$cwd// if $cwd;

		local $is_directory = $type eq 'd';
		local $is_symlink   = substr($type, 0, 1) eq 'l';

		local $mtime;
		if ($mlsd_facts) {
			$mtime = $ballpark_mtime;
		}
		elsif ($type eq 'f' && $opts->{fetch_mtime}) {
			$mtime = _mdtm_gmt($self, $_);
		}

		if ($is_directory && $opts->{'bydepth'}) {
			&recursive($self, $cwd, $opts, $next, $depth+1)
				or return;
		}

		if (
			(! defined($opts->{'min_depth'}))
			|| ($depth > $opts->{'min_depth'})
		) {
			local $_ = '.' if (! $opts->{'no_chdir'}) && $depth == 0;

			no strict 'refs';
			foreach my $k (qw(
				name dir is_directory is_symlink mode
				permissions link user group size month mday year_or_time
				type ballpark_mtime mtime mlsd_facts
			)) {
				${'Net::FTP::Find::'.$k} = $$k;
			}

			$opts->{'wanted'}($self);
		}

		if ($is_directory && ! $opts->{'bydepth'}) {
			&recursive($self, $cwd, $opts, $next, $depth+1)
				or return;
		}
	}

	if ($orig_cwd) {
		$self->cwd($orig_cwd)
			or return;
	}

	1;
}

sub build_start_dir {
	my ($self, $opts, $entries, $current, $parent) = @_;

	my $detected = 0;
	if ($current ne '/') {
		my $parent_entries = _dir_entries( $self, $opts, $parent )
			or return;
		my $basename = basename($current);

		for my $e (@$parent_entries) {
			next if $e->{data}[0] ne $basename;

			$detected = 1;
			$e->{line} =~ s/$basename$/./g;
			$e->{data}[0] = '.';
			splice @$entries, 0, scalar(@$entries), $e;
		}
	}

	if (! $detected) {
		my ($year, $month, $mday, $hour, $min) = (localtime)[5,4,3,2,1];
		my $line;
		if ($opts->{'fstype'} eq 'dosftp') {
			$line = join(
				' ',
				sprintf( '%02d-%02d-%d',
					$month + 1, $mday, substr( $year + 1900, 2 ) ),
				(   $hour < 12
					? sprintf( '%02d:%02dAM', $hour,	  $min )
					: sprintf( '%02d:%02dPM', $hour - 12, $min )
				),
				'<DIR>', '.'
			);
		}
		else {
			$line = join(' ',
				'drwxr-xr-x',
				scalar(@$entries)+2,
				'-',
				'-',
				0,
				$month_name_list[$month],
				sprintf('%02d', $mday),
				sprintf('%02d:%02d', $hour, $min),
				'.'
			);
		}
		my ($e) = parse_entries([$line], undef, undef, undef, 1);
		splice @$entries, 0, scalar(@$entries), $e;
	}

	1;
}

sub _list {
	my $self = shift;

	if ( $self->isa('Net::FTPSSL') ) {
		my @entries = $self->list(@_);
		if ( $self->last_status_code != CMD_OK ) {
			return;
		}
		else {
			[@entries];
		}
	}
	else {
		$self->dir(@_);
	}
}

sub _command {
	my $self = shift;

	if ( $self->isa('Net::FTPSSL') ) {
		my $status = $self->command(@_)->response;
		return [$status, $self->last_message];
	}
	else {
		my $status = $self->cmd(@_);
		return [$status, $self->message];
	}
}

sub _data_command {
	my $self = shift;

	my $res = '';
	if ( $self->isa('Net::FTPSSL') ) {
		unless ( $self->prep_data_channel ) {
			return;
		}

		if ( $self->command(@_)->response != CMD_INFO ) {
			$self->_croak_or_return;
			return;
		}

		my ( $tmp, $io, $size );

		$size = ${*$self}{buf_size};

		$io = $self->_get_data_channel;
		unless ( defined $io ) {
			return;
		}

		while ( my $len = sysread $io, $tmp, $size ) {
			unless ( defined $len ) {
				next if $! == Net::FTPSSL::EINTR();
				$self->_croak_or_return;
				$io->close;
				return;
			}
			$res .= $tmp;
		}

		$io->close;

		if ( $self->response() != CMD_OK ) {
			$self->_croak_or_return;
			return;
		}
	}
	else {
		my $data = $self->_data_cmd(@_)
			or return;
		my $buf;
		my $size = ${*$self}{'net_ftp_blksize'};
		while ( $data->read( $buf, $size ) ) {
			$res .= $buf;
		}
		$data->close
			or return;
	}

	$res;
}

sub _mdtm_gmt {
	my $self = shift;

	if ( $self->isa('Net::FTPSSL') ) {
		$self->_mdtm(@_);
	}
	else {
		$self->mdtm(@_);
	}
}

sub _dir_entries {
	my $self = shift;
	my ($opts, $directory, $tz, $fstype, $error, $preserve_current) = @_;

	if ($directory ne '.' && $directory ne '..') {
		$directory =~ s{/*\z}{/};
	}

	if ( $opts->{use_mlsd}
		&& defined( my $res = _data_command( $self, 'MLSD', $directory ) ) )
	{
		my @entries = map {
			(my $line = $_) =~ s/(\r\n|\r|\n)\z//;

			my %data;
			my ( $facts, $name ) = split ' ', $line, 2;
			for my $i ( split ';', $facts ) {
				my ( $k, $v ) = split '=', $i, 2;
				$data{lc $k} = $v;
			}

			$data{modify}
				=~ /((\d\d)(\d\d\d?))(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)/;
			my $modify = timegm( $8, $7, $6, $5, $4 - 1,
				$2 eq '19' ? $3 : ( $1 - 1900 ) );

			+{  line => '',
				data => [
					$name,
					(	 $data{type} =~ m/dir\z/ ? 'd'
						: $data{type} =~ m/link/ ? 'l'
						: 'f'
					),
					$data{size} || 0,
					$modify,
					$data{'UNIX.mode'}
				],
				mlsd_facts => \%data,
			};
		} split( /\n/, $res );

		return wantarray ? @entries : \@entries;
	}
	else {
		$opts->{use_mlsd} = 0;
	}

	my $list = _list($self, $directory)
		or return;
	parse_entries( $list, $tz, $fstype, $error, $preserve_current );
}

sub parse_entries {
	my($dir, $tz, $fstype, $error, $preserve_current) = @_;

	return unless $dir;

	if ($preserve_current) {
		$dir = [ map {
			my $e = $_;
			$e =~ s/(\s\S*)d(?=\S*\z)/$1dd/g;
			$e =~ s/(?<=\s)\.\z/d./g;
			$e;
		} @$dir ];
	}

	my @parsed = map {
		my ($data) = File::Listing::parse_dir($_, $tz, $fstype, $error);
		$data ? +{ line => $_, data => $data } : ()
	} @$dir;

	if (@$dir && ! @parsed) {
		# Fallback
		@parsed = map {
			my $l = $_;
			$l =~ s/
				(\s\d+\s+)
				(\d+)\S*
				(?=\s+\d+\s+(\d{2}:\d{2}|\d{4}))
			/$1 . $month_name_list[$2-1]/ex;
			my ($data) = File::Listing::parse_dir($l, $tz, $fstype, $error);
			$data ? +{ line => $_, data => $data } : ()
		} @$dir;
	}

	if ($preserve_current) {
		for (@parsed) {
			$_->{data}[0] =~ s/dd/d/;
			$_->{data}[0] =~ s/d\././g;
		}
	}

	wantarray ? @parsed : \@parsed;
}

1;
__END__

=head1 NAME

Net::FTP::Find::Mixin - Inject the function of Net::FTP::Find

=head1 SYNOPSIS

  use Net::FTP;
  use Net::FTP::Find::Mixin;

  my $ftp = Net::FTP->new('localhost');
  $ftp->login('user', 'pass');
  $ftp->find(sub { ... }, '/');

or

  use Net::FTP::Subclass;
  use Net::FTP::Find::Mixin qw( Net::FTP::Subclass );

  my $sub = Net::FTP::Subclass->new('localhost');
  $sub->login('user', 'pass');
  $sub->find(sub { ... }, '/');

or

  use Net::FTPSSL;
  use Net::FTP::Find::Mixin qw( Net::FTPSSL );

  my $ftp = Net::FTPSSL->new('localhost');
  $ftp->login('user', 'pass');
  $ftp->find(sub { ... }, '/');

=head1 AUTHOR

Taku Amano E<lt>taku@toi-planning.netE<gt>

=head1 SEE ALSO

L<Net::FTP::Find>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
