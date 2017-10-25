Welcome to Movable Type
=============

Thank you for choosing Movable Type, the premiere solution for your blogging and website management needs.
This file will explain how to get up and running; click on the highlighted sections for more information on that subject.

Before You Begin
--------

Movable Type requires the following applications:

* Perl 5.8.1 or greater;
* A web server like Apache or Windows IIS;
* Access to a database like MySQL;
* The following Perl modules:
 * [DBI](http://search.cpan.org/dist/DBI)
 * [Image::Size](http://search.cpan.org/dist/Image-Size)
 * [CGI::Cookie](http://search.cpan.org/search?query=cgi-cookie&mode=module)

Consult the CPAN documentation to learn how to [determine if a Perl module is already installed](http://www.cpan.org/misc/cpan-faq.html#How_installed_modules) and,
if they are not, [how to install them](http://www.cpan.org/misc/cpan-faq.html#How_install_Perl_modules).

Upgrading Movable Type
--------
If you are upgrading to Movable Type 6 from a previous version, we recommend that you first back up your old installation.
Database backup is especially important to restore your system in case of any trouble during the upgrade process.
Upload Movable Type 6's files over the same files from the previous version of Movable Type.
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

Some web servers and configurations do not allow static files such as JavaScript, CSS and image files to be located inside of a directory where CGI scripts are located. If you installed Movable Type into a cgi-bin directory, you may need to relocate the 'mt-static' directory to another web accessible location. Read our documentation on setting up your [mt-static directory](http://www.sixapart.com/movabletype/kb/installation/images_styles_a.html).

### Internal Server Errors

If you receive an "Internal Server Error" message, a configuration change may be required on your web server. Please consult our [installation guide](http://www.movabletype.org/documentation/installation/) or search our [knowledge base](http://www.sixapart.com/movabletype/kb/) to help resolve this issue.

### Finding more help

Need additional information or support? Check out the [Detailed Installation Guide](http://www.movabletype.org/documentation/installation/).
