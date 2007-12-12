all: cgi file-spec file-temp html-template image-size libwww-perl soap-lite uri

.PHONY: cgi file-spec file-temp html-template image-size libwww-perl soap-lite uri

file-spec: File/Spec.pm

file-temp: File/Temp.pm

html-template: HTML/Template.pm

image-size: Image/Size.pm

libwww-perl: LWP.pm

cgi: CGI.pm

soap-lite: SOAP/Lite.pm

uri: URI.pm

CGI.pm: CGI.pm-2.78
	(cd $<; perl Makefile.PL prefix=$(PWD) installprivlib=$(PWD); make install)
	touch $@

File/Spec.pm: File-Spec-0.90
	(cd $<; perl Makefile.PL prefix=$(PWD) installprivlib=$(PWD); make install)
	touch $@

File/Temp.pm: File-Temp-0.12
	(cd $<; perl Makefile.PL prefix=$(PWD) installprivlib=$(PWD) installsitelib=$(PWD); make install)
	touch $@

HTML/Template.pm: HTML-Template-2.4
	(cd $<; perl Makefile.PL prefix=$(PWD) installprivlib=$(PWD) installsitelib=$(PWD); make install)
	touch $@

Image/Size.pm: Image-Size-2.96
	(cd $<; perl Makefile.PL prefix=$(PWD) installprivlib=$(PWD) installsitelib=$(PWD); make install)
	touch $@

LWP.pm: libwww-perl-5.64
	(cd $<; yes|perl Makefile.PL prefix=$(PWD) installprivlib=$(PWD) installsitelib=$(PWD); make install)
	touch $@

SOAP/Lite.pm: SOAP-Lite-0.55
	(cd $<; (echo yes; echo no) | perl Makefile.PL prefix=$(PWD) installprivlib=$(PWD) installsitelib=$(PWD); make install)
	touch $@

URI.pm: URI-1.35
	(cd $<; perl Makefile.PL prefix=$(PWD) installprivlib=$(PWD) installsitelib=$(PWD); make install)
	touch $@

File-Spec-0.90.tar.gz:
	cd pkg; wget http://search.cpan.org/CPAN/authors/id/K/KW/KWILLIAMS/File-Spec-0.90.tar.gz

File-Spec-0.82.tar.gz:
	wget http://search.cpan.org/CPAN/authors/id/K/KW/KWILLIAMS/File-Spec-0.82.tar.gz

CGI.pm-2.78.tar.gz:
	wget http://search.cpan.org/CPAN/authors/id/L/LD/LDS/CGI.pm-2.78.tar.gz

CGI.pm-3.10.tar.gz:
	wget http://cpan.uwinnipeg.ca/cpan/authors/id/L/LD/LDS/CGI.pm-3.10.tar.gz

File-Temp-0.12.tar.gz:
	wget http://search.cpan.org/CPAN/authors/id/T/TJ/TJENNESS/File-Temp-0.12.tar.gz

HTML-Template-2.4.tar.gz:
	wget http://search.cpan.org/CPAN/authors/id/S/SA/SAMTREGAR/HTML-Template-2.4.tar.gz

Image-Size-2.96.tar.gz:
	wget http://search.cpan.org/CPAN/authors/id/R/RJ/RJRAY/Image-Size-2.96.tar.gz

libwww-perl-5.64.tar.gz:
	wget http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/libwww-perl-5.64.tar.gz

SOAP-Lite-0.55.tar.gz:
	wget http://search.cpan.org/CPAN/authors/id/K/KU/KULCHENKO/SOAP-Lite-0.55.tar.gz

URI-1.35.tar.gz:
	wget http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/URI-1.35.tar.gz

clean:
	-mv *.tar.gz pkg/
	-mv SOAP-Lite-0.55 URI-1.35 libwww-perl-5.64 Image-Size-2.96 \
		File-Spec-0.90 File-Temp-0.12 HTML-Template-2.4 \
		CGI.pm-2.87 CGI.pm-3.10 pkg


%: %.tar.gz
	tar xzvf $<
