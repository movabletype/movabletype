use strict;
use warnings;
use Module::Build;

our $VERSION = '0.14';
our $MODULE = 'ckeditor_plugins_movabletype';

my $class = Module::Build->subclass(
	code => q{
		# Don't make blib
		# sub ACTION_code {};
		# Don't make blib
		sub ACTION_docs {};
		# Don't make META.yml
		sub ACTION_distmeta {
			# no warning on ACTION_distdir
			$_[0]->{metafile} = 'MANIFEST';
		};
		# Don't add MEATA.yml to MANIFEST
		sub ACTION_manifest {
			$_[0]->{metafile} = 'MANIFEST',
			$_[0]->SUPER::ACTION_manifest(@_);
		};
		sub dist_dir {
			'ckeditor';
		}
		sub ACTION_dist {
			my ($self) = @_;

			$_[0]->SUPER::ACTION_dist(@_);

			my $dist_dir = $self->dist_dir;
			rename(
				$dist_dir . '.tar.gz',
				$self->{properties}{dist_name} . '-' . $self->{properties}{dist_version} . '.tar.gz'
			);
		}

		sub ACTION_distdir {
			my ($self) = @_;

			$_[0]->SUPER::ACTION_distdir(@_);

			my $dist_dir = $self->dist_dir;

			use File::Path;
			mkpath('ckeditor_build/_source/plugins');

			rename(
				$dist_dir,
				'ckeditor_build/_source/plugins/movabletype'
			);
			rename('ckeditor_build', $dist_dir);
		}
	}
);

my $builder = $class->new(
	dist_name           => $MODULE,
    dist_author         => 'Taku Amano <taku@toi-planning.net>',
    dist_version        => $VERSION,
    module_name         => $MODULE,
    license             => 'mit',
    add_to_cleanup      => [ "$MODULE-*" ],
);

$builder->create_build_script();
