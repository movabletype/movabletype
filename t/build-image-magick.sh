#!/bin/sh

# Install ImageMagick for installing Image::Magick on Travis CI.

# ImageMagick-6.9.1-6 causes segmentation fault when testing,
# so the latest version of ImageMagick is not used.

installed=[[ -f ${HOME}/image-magick/ImageMagick-6.9.0-10.tar.xz ]] && true || false

if [[ ! ${installed} ]]; then
  if [[ ! -d ${HOME}/image-magick ]]; then
    mkdir ${HOME}/image-magick
  fi
fi

pushd ${HOME}/image-magick

if [[ ! ${installed} ]]; then
  wget http://www.imagemagick.org/download/releases/ImageMagick-6.9.0-10.tar.xz
  tar Jxf ImageMagick-6.9.0-10.tar.xz
fi

cd ImageMagick-*

if [[ ! ${installed} ]]; then
  ./configure --prefix=${HOME}/image-magick --with-perl=${HOME}/perl5/perlbrew/perls/${TRAVIS_PERL_VERSION}/bin/perl
  make
fi

make install
popd
