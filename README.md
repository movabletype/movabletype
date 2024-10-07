Welcome to Movable Type
=============

Thank you for choosing Movable Type, the premiere solution for your blogging and website management needs.
This file will explain how to get up and running; click on the highlighted sections for more information on that subject.

Before You Begin
--------

Movable Type requires the following applications:

* Perl 5.16.3 or greater, with its core modules;
* A web server like nginx, Apache or Windows IIS;
* Access to a database like MySQL;
* The following Perl modules:
 * [DBI](https://metacpan.org/pod/DBI)
 * [HTML::Entities](https://metacpan.org/pod/HTML::Entities), a part of [HTML-Parser](https://metacpan.org/dist/HTML-Parser) distribution

Consult the CPAN documentation to learn how to [determine if a Perl module is already installed](https://www.cpan.org/misc/cpan-faq.html#How_installed_modules) and,
if they are not, [how to install them](https://www.cpan.org/misc/cpan-faq.html#How_install_Perl_modules).

Upgrading Movable Type
--------
If you are upgrading Movable Type from a previous version, we recommend that you first back up your old installation.
Database backup is especially important to restore your system in case of any trouble during the upgrade process.
Upload Movable Type's files over the same files from the previous version of Movable Type.
Access Movable Type as you normally do, and you will be taken through the upgrade process.

Installing Movable Type
--------

Before you install Movable Type:

1. Upload all of Movable Type's files into a directory or folder accessible via your web browser. We recommend that you separate your published content from the Movable Type executable programs by placing each in a separate directory. Typically, the installation directory is called 'mt' and is located in the root directory of your website or within an existing directory that is already configured to allow CGI script execution.
2. Make sure that the 'mt' directory containing the uploaded Movable Type files has been <a href="http://httpd.apache.org/docs/2.0/howto/cgi.html#nonscriptalias">enabled to execute CGI scripts</a>.
3. Make sure that each .cgi file (e.g. mt.cgi, mt-search.cgi, etc.) found in the Movable Type directory has the <a href="http://www.elated.com/articles/understanding-permissions/">execute permission</a> enabled.
4. Open that folder in your web browser -- `i.e. http://www.mywebsite.com/mt/`.
5. You should see a Movable Type welcome screen that will take you through the installation process. If the welcome screen does not appear, please consult Troubleshooting Movable Type below.

Troubleshooting Movable Type
--------

### Setting up your static web path

Some web servers and configurations do not allow static files such as JavaScript, CSS and image files to be located inside of a directory where CGI scripts are located. If you installed Movable Type into a cgi-bin directory, you may need to relocate the 'mt-static' directory to another web accessible location. Read our documentation on setting up your [mt-static directory](https://movabletype.org/documentation/installation/file-system.html#static-directory).

### Internal Server Errors

If you receive an "Internal Server Error" message, a configuration change may be required on your web server. Please consult our [installation guide](https://www.movabletype.org/documentation/installation/).

### Finding more help

Need additional information or support? Check out the [Detailed Installation Guide](https://www.movabletype.org/documentation/installation/).

Get Involved
--------

### Testing

You can learn how to test Movabletype by reading 
[.github/workflows/movabletype.yml](https://github.com/movabletype/movabletype/blob/develop/.github/workflows/movabletype.yml).
The following are some small portions of it.

```sh
$ git clone git@github.com:movabletype/movabletype.git
$ cd movabletype
$ BUILD_RELEASE_NUMBER=1 make
$ docker run -it --rm -v $PWD:/mt -w /mt movabletype/test:centos8 prove -It/lib t/app
```

Some tests need to be run on the dedicated docker images.

```sh
$ docker run -it --rm -v $PWD:/mt -w /mt movabletype/test:chromiumdriver prove -It/lib t/selenium
```

PHP files can be tested by following command.

```sh
$ docker run -it --rm -v $PWD:/mt -w /mt movabletype/test:chromiumdriver phpunit
```

Some tests are skipped by default. These cases can be run by setting environment variables starting with `MT_TEST_`.

For example,

```sh
$ docker run -it --rm -v $PWD:/mt -w /mt movabletype/test:centos8 bash -c "MT_TEST_CRAWL=1 prove -It/lib t/selenium/crawl.t"
```

For details, please do `grep -r MT_TEST_ t/`.

mysql is used for tests by default. You can inspect the tables by following command.

```sh
$ docker run -it --rm -v $PWD:/mt -w /mt movabletype/test:centos8 /bin/bash
$ prove -It/lib path/to/test.t
$ mysql -u root --database mt_test
```

See also [t/README.md](https://github.com/movabletype/movabletype/blob/develop/t/README.md).
