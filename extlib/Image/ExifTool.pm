#------------------------------------------------------------------------------
# File:         ExifTool.pm
#
# Description:  Read and write meta information
#
# URL:          http://owl.phy.queensu.ca/~phil/exiftool/
#
# Revisions:    Nov. 12/2003 - P. Harvey Created
#               (See html/history.html for revision history)
#
# Legal:        Copyright (c) 2003-2010, Phil Harvey (phil at owl.phy.queensu.ca)
#               This library is free software; you can redistribute it and/or
#               modify it under the same terms as Perl itself.
#------------------------------------------------------------------------------

package Image::ExifTool;

use strict;
require 5.004;  # require 5.004 for UNIVERSAL::isa (otherwise 5.002 would do)
require Exporter;
use File::RandomAccess;

use vars qw($VERSION $RELEASE @ISA %EXPORT_TAGS $AUTOLOAD @fileTypes %allTables
            @tableOrder $exifAPP1hdr $xmpAPP1hdr $xmpExtAPP1hdr $psAPP13hdr
            $psAPP13old @loadAllTables %UserDefined $evalWarning %noWriteFile
            %magicNumber @langs $defaultLang %langName %charsetName %mimeType
            $swapBytes $swapWords $currentByteOrder %unpackStd);

$VERSION = '8.50';
$RELEASE = '';
@ISA = qw(Exporter);
%EXPORT_TAGS = (
    # all public non-object-oriented functions:
    Public => [qw(
        ImageInfo GetTagName GetShortcuts GetAllTags GetWritableTags
        GetAllGroups GetDeleteGroups GetFileType CanWrite CanCreate
    )],
    # exports not part of the public API, but used by ExifTool modules:
    DataAccess => [qw(
        ReadValue GetByteOrder SetByteOrder ToggleByteOrder Get8u Get8s Get16u
        Get16s Get32u Get32s Get64u GetFloat GetDouble GetFixed32s Write
        WriteValue Tell Set8u Set8s Set16u Set32u
    )],
    Utils => [qw(GetTagTable TagTableKeys GetTagInfoList)],
    Vars  => [qw(%allTables @tableOrder @fileTypes)],
);
# set all of our EXPORT_TAGS in EXPORT_OK
Exporter::export_ok_tags(keys %EXPORT_TAGS);

# test for problems that can arise if encoding.pm is used
{ my $t = "\xff"; die "Incompatible encoding!\n" if ord($t) != 0xff; }

# The following functions defined in Image::ExifTool::Writer are declared
# here so their prototypes will be available.  These Writer routines will be
# autoloaded when any of them is called.
sub SetNewValue($;$$%);
sub SetNewValuesFromFile($$;@);
sub GetNewValues($;$$);
sub CountNewValues($);
sub SaveNewValues($);
sub RestoreNewValues($);
sub WriteInfo($$;$$);
sub SetFileModifyDate($$;$);
sub SetFileName($$;$);
sub GetAllTags(;$);
sub GetWritableTags(;$);
sub GetAllGroups($);
sub GetNewGroups($);
sub GetDeleteGroups();
# non-public routines below
sub InsertTagValues($$$;$);
sub IsWritable($);
sub GetNewFileName($$);
sub NextTagKey($$);
sub LoadAllTables();
sub GetNewTagInfoList($;$);
sub GetNewTagInfoHash($@);
sub GetLangInfo($$);
sub Get64s($$);
sub Get64u($$);
sub GetExtended($$);
sub DecodeBits($$;$);
sub EncodeBits($$;$$);
sub HexDump($;$%);
sub DumpTrailer($$);
sub DumpUnknownTrailer($$);
sub VerboseInfo($$$%);
sub VerboseDir($$;$$);
sub VerboseValue($$$;$);
sub VPrint($$@);
sub Rationalize($;$);
sub Write($@);
sub WriteTrailerBuffer($$$);
sub AddNewTrailers($;@);
sub Tell($);
sub WriteValue($$;$$$$);
sub WriteDirectory($$$;$);
sub WriteBinaryData($$$);
sub CheckBinaryData($$$);
sub WriteTIFF($$$);
sub PackUTF8(@);
sub UnpackUTF8($);
sub SetPreferredByteOrder($);
sub CopyBlock($$$);
sub CopyFileAttrs($$);

# other subroutine definitions
sub DoEscape($$);
sub ConvertFileSize($);
sub ParseArguments($;@); #(defined in attempt to avoid mod_perl problem)

# list of main tag tables to load in LoadAllTables() (sub-tables are recursed
# automatically).  Note: They will appear in this order in the documentation
# unless tweaked in BuildTagLookup::GetTableOrder().
@loadAllTables = qw(
    PhotoMechanic Exif GeoTiff CanonRaw KyoceraRaw MinoltaRaw PanasonicRaw
    SigmaRaw JPEG GIMP Jpeg2000 GIF BMP BMP::OS2 PICT PNG MNG DjVu PGF MIFF PSP
    PDF PostScript Photoshop::Header FujiFilm::RAF Sony::SRF2 Sony::SR2SubIFD
    Sony::PMP ITC ID3 Vorbis FLAC APE APE::NewHeader APE::OldHeader MPC
    MPEG::Audio MPEG::Video MPEG::Xing M2TS QuickTime QuickTime::ImageFile
    Matroska MXF DV Flash Flash::FLV Real::Media Real::Audio Real::Metafile RIFF
    AIFF ASF DICOM MIE HTML XMP::SVG EXE EXE::PEVersion EXE::PEString EXE::MachO
    EXE::PEF EXE::ELF LNK Font RSRC Rawzor ZIP ZIP::GZIP ZIP::RAR RTF OOXML
    iWork
);

# alphabetical list of current Lang modules
@langs = qw(cs de en en_ca en_gb es fr it ja ko nl pl ru sv tr zh_cn zh_tw);

$defaultLang = 'en';    # default language

# language names
%langName = (
    cs => 'Czech (Čeština)',
    de => 'German (Deutsch)',
    en => 'English',
    en_ca => 'Canadian English',
    en_gb => 'British English',
    es => 'Spanish (Español)',
    fr => 'French (Français)',
    it => 'Italian (Italiano)',
    ja => 'Japanese (日本語)',
    ko => 'Korean (한국어)',
    nl => 'Dutch (Nederlands)',
    pl => 'Polish (Polski)',
    ru => 'Russian (Русский)',
    sv => 'Swedish (Svenska)',
   'tr'=> 'Turkish (Türkçe)',
    zh_cn => 'Simplified Chinese (简体中文)',
    zh_tw => 'Traditional Chinese (繁體中文)',
);

# recognized file types, in the order we test unknown files
# Notes: 1) There is no need to test for like types separately here
# 2) Put types with weak file signatures at end of list to avoid false matches
@fileTypes = qw(JPEG CRW TIFF GIF MRW RAF X3F JP2 PNG MIE MIFF PS PDF PSD XMP
                BMP PPM RIFF AIFF ASF MOV MPEG Real SWF PSP FLV OGG FLAC APE MPC
                MKV MXF DV PMP IND PGF ICC ITC HTML VRD RTF XCF QTIF FPX PICT
                ZIP GZIP RAR RWZ EXE LNK RAW Font RSRC M2TS MP3 DICM);

# file types that we can write (edit)
my @writeTypes = qw(JPEG TIFF GIF CRW MRW ORF RAF RAW PNG MIE PSD XMP PPM
                    EPS X3F PS PDF ICC VRD JP2 EXIF AI AIT IND);

# file extensions that we can't write for various base types
%noWriteFile = (
    TIFF => [ qw(3FR DCR K25 KDC SRF) ],
    XMP  => [ 'SVG' ],
);

# file types that we can create from scratch
# - must update CanCreate() documentation if this list is changed!
my %createTypes = (XMP=>1, ICC=>1, MIE=>1, VRD=>1, EXIF=>1);

# file type lookup for all recognized file extensions
my %fileTypeLookup = (
   '3FR' => ['TIFF', 'Hasselblad RAW format'],
   '3G2' => ['MOV',  '3rd Gen. Partnership Project 2 audio/video'],
   '3GP' => ['MOV',  '3rd Gen. Partnership Project audio/video'],
    ACR  => ['DICM', 'American College of Radiology ACR-NEMA'],
    ACFM => ['Font', 'Adobe Composite Font Metrics'],
    AFM  => ['Font', 'Adobe Font Metrics'],
    AMFM => ['Font', 'Adobe Multiple Master Font Metrics'],
    AI   => [['PDF','PS'], 'Adobe Illustrator'],
    AIF  =>  'AIFF',
    AIFC => ['AIFF', 'Audio Interchange File Format Compressed'],
    AIFF => ['AIFF', 'Audio Interchange File Format'],
    AIT  =>  'AI',
    APE  => ['APE',  "Monkey's Audio format"],
    ARW  => ['TIFF', 'Sony Alpha RAW format'],
    ASF  => ['ASF',  'Microsoft Advanced Systems Format'],
    AVI  => ['RIFF', 'Audio Video Interleaved'],
    BMP  => ['BMP',  'Windows Bitmap'],
    BTF  => ['BTF',  'Big Tagged Image File Format'], #(unofficial)
    CIFF => ['CRW',  'Camera Image File Format'],
    COS  => ['COS',  'Capture One Settings'],
    CR2  => ['TIFF', 'Canon RAW 2 format'],
    CRW  => ['CRW',  'Canon RAW format'],
    CS1  => ['PSD',  'Sinar CaptureShop 1-Shot RAW'],
    DC3  =>  'DICM',
    DCM  =>  'DICM',
    DCP  => ['TIFF', 'DNG Camera Profile'],
    DCR  => ['TIFF', 'Kodak Digital Camera RAW'],
    DFONT=> ['Font', 'Macintosh Data fork Font'],
    DIB  => ['BMP',  'Device Independent Bitmap'],
    DIC  =>  'DICM',
    DICM => ['DICM', 'Digital Imaging and Communications in Medicine'],
    DIVX => ['ASF',  'DivX media format'],
    DJV  =>  'DJVU',
    DJVU => ['AIFF', 'DjVu image'],
    DLL  => ['EXE',  'Windows Dynamic Link Library'],
    DNG  => ['TIFF', 'Digital Negative'],
    DOC  => ['FPX',  'Microsoft Word Document'],
    DOCM => [['ZIP','FPX'], 'Office Open XML Document Macro-enabled'],
    # Note: I have seen a password-protected DOCX file which was FPX-like, so I assume
    # that any other MS Office file could be like this too.  The only difference is
    # that the ZIP and FPX formats are checked first, so if this is wrong, no biggie.
    DOCX => [['ZIP','FPX'], 'Office Open XML Document'],
    DOT  => ['FPX',  'Microsoft Word Template'],
    DOTM => [['ZIP','FPX'], 'Office Open XML Document Template Macro-enabled'],
    DOTX => [['ZIP','FPX'], 'Office Open XML Document Template'],
    DV   => ['DV',   'Digital Video'],
    DVB  => ['MOV',  'Digital Video Broadcasting'],
    DYLIB=> ['EXE',  'Mach-O Dynamic Link Library'],
    EIP  => ['ZIP',  'Capture One Enhanced Image Package'],
    EPS  => ['EPS',  'Encapsulated PostScript Format'],
    EPSF =>  'EPS',
    ERF  => ['TIFF', 'Epson Raw Format'],
    EXE  => ['EXE',  'Windows executable file'],
    EXIF => ['EXIF', 'Exchangable Image File Metadata'],
    F4A  => ['MOV',  'Adobe Flash Player 9+ Audio'],
    F4B  => ['MOV',  'Adobe Flash Player 9+ audio Book'],
    F4P  => ['MOV',  'Adobe Flash Player 9+ Protected'],
    F4V  => ['MOV',  'Adobe Flash Player 9+ Video'],
    FLAC => ['FLAC', 'Free Lossless Audio Codec'],
    FLA  => ['FPX',  'Macromedia/Adobe Flash project'],
    FLV  => ['FLV',  'Flash Video'],
    FPX  => ['FPX',  'FlashPix'],
    GIF  => ['GIF',  'Compuserve Graphics Interchange Format'],
    GZ   =>  'GZIP',
    GZIP => ['GZIP', 'GNU ZIP compressed archive'],
    HDP  => ['TIFF', 'Windows HD Photo'],
    HTM  =>  'HTML',
    HTML => ['HTML', 'HyperText Markup Language'],
    ICC  => ['ICC',  'International Color Consortium'],
    ICM  =>  'ICC',
    IIQ  => ['TIFF', 'Phase One Intelligent Image Quality RAW'],
    IND  => ['IND',  'Adobe InDesign'],
    INDD => ['IND',  'Adobe InDesign Document'],
    INDT => ['IND',  'Adobe InDesign Template'],
    ITC  => ['ITC',  'iTunes Cover Flow'],
    JNG  => ['PNG',  'JPG Network Graphics'],
    JP2  => ['JP2',  'JPEG 2000 file'],
    # JP4? - looks like a JPEG but the image data is different
    JPEG =>  'JPG',
    JPG  => ['JPEG', 'Joint Photographic Experts Group'],
    JPM  => ['JP2',  'JPEG 2000 compound image'],
    JPX  => ['JP2',  'JPEG 2000 with extensions'],
    K25  => ['TIFF', 'Kodak DC25 RAW'],
    KDC  => ['TIFF', 'Kodak Digital Camera RAW'],
    KEY  => ['ZIP',  'Apple Keynote presentation'],
    KTH  => ['ZIP',  'Apple Keynote Theme'],
    LNK  => ['LNK',  'Windows shortcut'],
    M2T  =>  'M2TS',
    M2TS => ['M2TS', 'MPEG-2 Transport Stream'],
    M2V  => ['MPEG', 'MPEG-2 Video'],
    M4A  => ['MOV',  'MPEG-4 Audio'],
    M4B  => ['MOV',  'MPEG-4 audio Book'],
    M4P  => ['MOV',  'MPEG-4 Protected'],
    M4V  => ['MOV',  'MPEG-4 Video'],
    MEF  => ['TIFF', 'Mamiya (RAW) Electronic Format'],
    MIE  => ['MIE',  'Meta Information Encapsulation format'],
    MIF  =>  'MIFF',
    MIFF => ['MIFF', 'Magick Image File Format'],
    MKA  => ['MKV',  'Matroska Audio'],
    MKS  => ['MKV',  'Matroska Subtitle'],
    MKV  => ['MKV',  'Matroska Video'],
    MNG  => ['PNG',  'Multiple-image Network Graphics'],
  # MODD => ['PLIST','Sony Picture Motion Metadata'],
    MOS  => ['TIFF', 'Creo Leaf Mosaic'],
    MOV  => ['MOV',  'Apple QuickTime movie'],
    MP3  => ['MP3',  'MPEG-1 Layer 3 audio'],
    MP4  => ['MOV',  'MPEG-4 video'],
    MPC  => ['MPC',  'Musepack Audio'],
    MPEG => ['MPEG', 'MPEG-1 or MPEG-2 audio/video'],
    MPG  =>  'MPEG',
    MPO  => ['JPEG', 'Extended Multi-Picture format'],
    MQV  => ['MOV',  'Sony Mobile Quicktime Video'],
    MRW  => ['MRW',  'Minolta RAW format'],
    MTS  => ['M2TS', 'MPEG-2 Transport Stream'],
    MXF  => ['MXF',  'Material Exchange Format'],
  # NDPI => ['TIFF', 'Hamamatsu NanoZoomer Digital Pathology Image'],
    NEF  => ['TIFF', 'Nikon (RAW) Electronic Format'],
    NMBTEMPLATE => ['ZIP','Apple Numbers Template'],
    NRW  => ['TIFF', 'Nikon RAW (2)'],
    NUMBERS => ['ZIP','Apple Numbers spreadsheet'],
    ODP  => ['ZIP',  'Open Document Presentation'],
    ODS  => ['ZIP',  'Open Document Spreadsheet'],
    ODT  => ['ZIP',  'Open Document Text file'],
    OGG  => ['OGG',  'Ogg Vorbis audio file'],
    ORF  => ['ORF',  'Olympus RAW format'],
    OTF  => ['Font', 'Open Type Font'],
    PAGES => ['ZIP', 'Apple Pages document'],
    PBM  => ['PPM',  'Portable BitMap'],
    PCT  =>  'PICT',
    PDF  => ['PDF',  'Adobe Portable Document Format'],
    PEF  => ['TIFF', 'Pentax (RAW) Electronic Format'],
    PFA  => ['Font', 'PostScript Font ASCII'],
    PFB  => ['Font', 'PostScript Font Binary'],
    PFM  => ['Font', 'Printer Font Metrics'],
    PGF  => ['PGF',  'Progressive Graphics File'],
    PGM  => ['PPM',  'Portable Gray Map'],
    PICT => ['PICT', 'Apple PICTure'],
  # PLIST=> ['PLIST','Apple Property List'],
    PMP  => ['PMP',  'Sony DSC-F1 Cyber-Shot PMP'], # should stand for Proprietery Metadata Package ;)
    PNG  => ['PNG',  'Portable Network Graphics'],
    POT  => ['FPX',  'Microsoft PowerPoint Template'],
    POTM => [['ZIP','FPX'], 'Office Open XML Presentation Template Macro-enabled'],
    POTX => [['ZIP','FPX'], 'Office Open XML Presentation Template'],
    PPM  => ['PPM',  'Portable Pixel Map'],
    PPS  => ['FPX',  'Microsoft PowerPoint Slideshow'],
    PPSM => [['ZIP','FPX'], 'Office Open XML Presentation Slideshow Macro-enabled'],
    PPSX => [['ZIP','FPX'], 'Office Open XML Presentation Slideshow'],
    PPT  => ['FPX',  'Microsoft PowerPoint Presentation'],
    PPTM => [['ZIP','FPX'], 'Office Open XML Presentation Macro-enabled'],
    PPTX => [['ZIP','FPX'], 'Office Open XML Presentation'],
    PS   => ['PS',   'PostScript'],
    PSB  => ['PSD',  'Photoshop Large Document'],
    PSD  => ['PSD',  'Photoshop Drawing'],
    PSP  => ['PSP',  'Paint Shop Pro'],
    PSPFRAME => 'PSP',
    PSPIMAGE => 'PSP',
    PSPSHAPE => 'PSP',
    PSPTUBE  => 'PSP',
    QIF  =>  'QTIF',
    QT   => ['MOV',  'QuickTime movie'],
    QTI  =>  'QTIF',
    QTIF => ['QTIF', 'QuickTime Image File'],
    RA   => ['Real', 'Real Audio'],
    RAF  => ['RAF',  'FujiFilm RAW Format'],
    RAM  => ['Real', 'Real Audio Metafile'],
    RAR  => ['RAR',  'RAR Archive'],
    RAW  => [['RAW','TIFF'], 'Kyocera Contax N Digital RAW or Panasonic RAW'],
    RIF  =>  'RIFF',
    RIFF => ['RIFF', 'Resource Interchange File Format'],
    RM   => ['Real', 'Real Media'],
    RMVB => ['Real', 'Real Media Variable Bitrate'],
    RPM  => ['Real', 'Real Media Plug-in Metafile'],
    RSRC => ['RSRC', 'Mac OS Resource'],
    RTF  => ['RTF',  'Rich Text Format'],
    RV   => ['Real', 'Real Video'],
    RW2  => ['TIFF', 'Panasonic RAW 2'],
    RWL  => ['TIFF', 'Leica RAW'],
    RWZ  => ['RWZ',  'Rawzor compressed image'],
    SO   => ['EXE',  'Shared Object file'],
    SR2  => ['TIFF', 'Sony RAW Format 2'],
    SRF  => ['TIFF', 'Sony RAW Format'],
    SRW  => ['TIFF', 'Samsung RAW format'],
    SVG  => ['XMP',  'Scalable Vector Graphics'],
    SWF  => ['SWF',  'Shockwave Flash'],
    THM  => ['JPEG', 'Canon Thumbnail'],
    THMX => [['ZIP','FPX'], 'Office Open XML Theme'],
    TIF  =>  'TIFF',
    TIFF => ['TIFF', 'Tagged Image File Format'],
    TTC  => ['Font', 'True Type Font Collection'],
    TTF  => ['Font', 'True Type Font'],
    TUB  => 'PSP',
    VOB  => ['MPEG', 'Video Object'],
    VRD  => ['VRD',  'Canon VRD Recipe Data'],
    WAV  => ['RIFF', 'WAVeform (Windows digital audio)'],
    WDP  => ['TIFF', 'Windows Media Photo'],
    WEBM => ['MKV',  'Google Web Movie'],
    WEBP => ['RIFF', 'Google Web Picture'],
    WMA  => ['ASF',  'Windows Media Audio'],
    WMV  => ['ASF',  'Windows Media Video'],
    X3F  => ['X3F',  'Sigma RAW format'],
    XCF  => ['XCF',  'GIMP native image format'],
    XHTML=> ['HTML', 'Extensible HyperText Markup Language'],
    XLA  => ['FPX',  'Microsoft Excel Add-in'],
    XLAM => [['ZIP','FPX'], 'Office Open XML Spreadsheet Add-in Macro-enabled'],
    XLS  => ['FPX',  'Microsoft Excel Spreadsheet'],
    XLSB => [['ZIP','FPX'], 'Office Open XML Spreadsheet Binary'],
    XLSM => [['ZIP','FPX'], 'Office Open XML Spreadsheet Macro-enabled'],
    XLSX => [['ZIP','FPX'], 'Office Open XML Spreadsheet'],
    XLT  => ['FPX',  'Microsoft Excel Template'],
    XLTM => [['ZIP','FPX'], 'Office Open XML Spreadsheet Template Macro-enabled'],
    XLTX => [['ZIP','FPX'], 'Office Open XML Spreadsheet Template'],
    XMP  => ['XMP',  'Extensible Metadata Platform'],
    ZIP  => ['ZIP',  'ZIP archive'],
);

# descriptions for file types not found in above file extension lookup
my %fileDescription = (
    DICOM => 'Digital Imaging and Communications in Medicine',
    PLIST => 'Property List',
    XML   => 'Extensible Markup Language',
    'DJVU (multi-page)' => 'DjVu multi-page image',
    'Win32 EXE' => 'Windows 32-bit Executable',
    'Win32 DLL' => 'Windows 32-bit Dynamic Link Library',
);

# MIME types for applicable file types above
# (missing entries default to 'application/unknown', but note that
#  other mime types may be specified by some modules, ie. QuickTime.pm)
%mimeType = (
   '3FR' => 'image/x-hasselblad-3fr',
    AI   => 'application/vnd.adobe.illustrator',
    AIFF => 'audio/x-aiff',
    APE  => 'audio/x-monkeys-audio',
    ASF  => 'video/x-ms-asf',
    ARW  => 'image/x-sony-arw',
    AVI  => 'video/x-msvideo',
    BMP  => 'image/bmp',
    BTF  => 'image/x-tiff-big', #(NC) (ref http://www.asmail.be/msg0055371937.html)
   'Canon 1D RAW' => 'image/x-raw', # (uses .TIF file extension)
    CR2  => 'image/x-canon-cr2',
    CRW  => 'image/x-canon-crw',
    DCR  => 'image/x-kodak-dcr',
    DFONT=> 'application/x-dfont',
    DICM => 'application/dicom',
    DIVX => 'video/divx',
    DJVU => 'image/vnd.djvu',
    DNG  => 'image/x-adobe-dng',
    DOC  => 'application/msword',
    DOCM => 'application/vnd.ms-word.document.macroEnabled',
    DOCX => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    DOT  => 'application/msword',
    DOTM => 'application/vnd.ms-word.template.macroEnabledTemplate',
    DOTX => 'application/vnd.openxmlformats-officedocument.wordprocessingml.template',
    DV   => 'video/x-dv',
    EIP  => 'application/x-captureone', #(NC)
    EPS  => 'application/postscript',
    ERF  => 'image/x-epson-erf',
    EXE  => 'application/octet-stream',
    FLA  => 'application/vnd.adobe.fla',
    FLAC => 'audio/flac',
    FLV  => 'video/x-flv',
    Font => 'application/x-font-type1', # covers PFA, PFB and PFM (not sure about PFM)
    FPX  => 'image/vnd.fpx',
    GIF  => 'image/gif',
    GZIP => 'application/x-gzip',
    HDP  => 'image/vnd.ms-photo',
    HTML => 'text/html',
    ICC  => 'application/vnd.iccprofile',
    IIQ  => 'image/x-raw',
    IND  => 'application/x-indesign',
    ITC  => 'application/itunes',
    JNG  => 'image/jng',
    JP2  => 'image/jp2',
    JPEG => 'image/jpeg',
    JPM  => 'image/jpm',
    JPX  => 'image/jpx',
    K25  => 'image/x-kodak-k25',
    KDC  => 'image/x-kodak-kdc',
    LNK  => 'application/octet-stream',
    M2T  => 'video/mpeg',
    M2TS => 'video/m2ts',
    MEF  => 'image/x-mamiya-mef',
    MIE  => 'application/x-mie',
    MIFF => 'application/x-magick-image',
    MKA  => 'audio/x-matroska',
    MKS  => 'application/x-matroska',
    MKV  => 'video/x-matroska',
    MNG  => 'video/mng',
    MOS  => 'image/x-raw',
    MOV  => 'video/quicktime',
    MP3  => 'audio/mpeg',
    MP4  => 'video/mp4',
    MPC  => 'audio/x-musepack',
    MPEG => 'video/mpeg',
    MRW  => 'image/x-minolta-mrw',
    MXF  => 'application/mxf',
    NEF  => 'image/x-nikon-nef',
    NRW  => 'image/x-nikon-nrw',
    ODP  => 'application/vnd.oasis.opendocument.presentation',
    ODS  => 'application/vnd.oasis.opendocument.spreadsheet',
    ODT  => 'application/vnd.oasis.opendocument.text',
    OGG  => 'audio/x-ogg',
    ORF  => 'image/x-olympus-orf',
    OTF  => 'application/x-font-otf',
    PBM  => 'image/x-portable-bitmap',
    PDF  => 'application/pdf',
    PEF  => 'image/x-pentax-pef',
    PGF  => 'image/pgf',
    PGM  => 'image/x-portable-graymap',
    PICT => 'image/pict',
    PLIST=> 'application/xml',
    PNG  => 'image/png',
    POT  => 'application/vnd.ms-powerpoint',
    POTM => 'application/vnd.ms-powerpoint.template.macroEnabled',
    POTX => 'application/vnd.openxmlformats-officedocument.presentationml.template',
    PPM  => 'image/x-portable-pixmap',
    PPS  => 'application/vnd.ms-powerpoint',
    PPSM => 'application/vnd.ms-powerpoint.slideshow.macroEnabled',
    PPSX => 'application/vnd.openxmlformats-officedocument.presentationml.slideshow',
    PPT  => 'application/vnd.ms-powerpoint',
    PPTM => 'application/vnd.ms-powerpoint.presentation.macroEnabled',
    PPTX => 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    PS   => 'application/postscript',
    PSD  => 'application/vnd.adobe.photoshop',
    PSP  => 'image/x-paintshoppro', #(NC)
    QTIF => 'image/x-quicktime',
    RA   => 'audio/x-pn-realaudio',
    RAF  => 'image/x-fujifilm-raf',
    RAM  => 'audio/x-pn-realaudio',
    RAR  => 'application/x-rar-compressed',
    RAW  => 'image/x-raw',
    RM   => 'application/vnd.rn-realmedia',
    RMVB => 'application/vnd.rn-realmedia-vbr',
    RPM  => 'audio/x-pn-realaudio-plugin',
    RSRC => 'application/ResEdit',
    RTF  => 'text/rtf',
    RV   => 'video/vnd.rn-realvideo',
    RW2  => 'image/x-panasonic-rw2',
    RWL  => 'image/x-leica-rwl',
    RWZ  => 'image/x-rawzor', #(duplicated in Rawzor.pm)
    SR2  => 'image/x-sony-sr2',
    SRF  => 'image/x-sony-srf',
    SRW  => 'image/x-samsung-srw',
    SVG  => 'image/svg+xml',
    SWF  => 'application/x-shockwave-flash',
    THMX => 'application/vnd.ms-officetheme',
    TIFF => 'image/tiff',
    TTC  => 'application/x-font-ttf',
    TTF  => 'application/x-font-ttf',
    WAV  => 'audio/x-wav',
    WDP  => 'image/vnd.ms-photo',
    WEBM => 'video/webm',
    WEBP => 'image/webp',
    WMA  => 'audio/x-ms-wma',
    WMV  => 'video/x-ms-wmv',
    X3F  => 'image/x-sigma-x3f',
    XCF  => 'image/x-xcf',
    XLA  => 'application/vnd.ms-excel',
    XLAM => 'application/vnd.ms-excel.addin.macroEnabled',
    XLS  => 'application/vnd.ms-excel',
    XLSB => 'application/vnd.ms-excel.sheet.binary.macroEnabled',
    XLSM => 'application/vnd.ms-excel.sheet.macroEnabled',
    XLSX => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    XLT  => 'application/vnd.ms-excel',
    XLTM => 'application/vnd.ms-excel.template.macroEnabled',
    XLTX => 'application/vnd.openxmlformats-officedocument.spreadsheetml.template',
    XML  => 'application/xml',
    XMP  => 'application/rdf+xml',
    ZIP  => 'application/zip',
);

# module names for processing routines of each file type
# (missing entries have same module name as file type)
my %moduleName = (
    BTF  => 'BigTIFF',
    CRW  => 'CanonRaw',
    DICM => 'DICOM',
    COS  => 'CaptureOne',
    DOCX => 'OOXML',
    EPS  => 'PostScript',
    EXIF => '',     # (Image::ExifTool)
    ICC  => 'ICC_Profile',
    IND  => 'InDesign',
    FLV  => 'Flash',
    FPX  => 'FlashPix',
    GZIP => 'ZIP',
    JP2  => 'Jpeg2000',
    JPEG => '',     # (Image::ExifTool)
  # MODD => 'XML',
    MOV  => 'QuickTime',
    MKV  => 'Matroska',
    MP3  => 'ID3',
    MRW  => 'MinoltaRaw',
    OGG  => 'Vorbis',
    ORF  => 'Olympus',
  # PLIST=> 'XML',
    PMP  => 'Sony',
    PS   => 'PostScript',
    PSD  => 'Photoshop',
    QTIF => 'QuickTime',
    RAF  => 'FujiFilm',
    RAR  => 'ZIP',
    RAW  => 'KyoceraRaw',
    RWZ  => 'Rawzor',
    SWF  => 'Flash',
    TIFF => '',     # (Image::ExifTool)
    VRD  => 'CanonVRD',
    X3F  => 'SigmaRaw',
    XCF  => 'GIMP',
);

# quick "magic number" file test used to avoid loading module unnecessarily:
# - regular expression evaluated on first 1024 bytes of file
# - must match beginning at first byte in file
# - this test must not be more stringent than module logic
%magicNumber = (
    AIFF => '(FORM....AIF[FC]|AT&TFORM)',
    APE  => '(MAC |APETAGEX|ID3)',
    ASF  => '\x30\x26\xb2\x75\x8e\x66\xcf\x11\xa6\xd9\x00\xaa\x00\x62\xce\x6c',
    BMP  => 'BM',
    BTF  => '(II\x2b\0|MM\0\x2b)',
    CRW  => '(II|MM).{4}HEAP(CCDR|JPGM)',
    DICM => '(.{128}DICM|\0[\x02\x04\x06\x08]\0[\0-\x20]|[\x02\x04\x06\x08]\0[\0-\x20]\0)',
    DOCX => 'PK\x03\x04',
    DV   => '\x1f\x07\0[\x3f\xbf]', # (not tested if extension recognized)
    EPS  => '(%!PS|%!Ad|\xc5\xd0\xd3\xc6)',
    EXE  => '(MZ|\xca\xfe\xba\xbe|\xfe\xed\xfa[\xce\xcf]|[\xce\xcf]\xfa\xed\xfe|Joy!peff|\x7fELF|#!\s*/\S*bin/|!<arch>\x0a)',
    EXIF => '(II\x2a\0|MM\0\x2a)',
    FLAC => '(fLaC|ID3)',
    FLV  => 'FLV\x01',
    Font => '((\0\x01\0\0|OTTO|true|typ1)[\0\x01]|ttcf\0[\x01\x02]\0\0|\0[\x01\x02]|' .
            '(.{6})?%!(PS-(AdobeFont-|Bitstream )|FontType1-)|Start(Comp|Master)?FontMetrics)',
    FPX  => '\xd0\xcf\x11\xe0\xa1\xb1\x1a\xe1',
    GIF  => 'GIF8[79]a',
    GZIP => '\x1f\x8b\x08',
    HTML => '(?i)<(!DOCTYPE\s+HTML|HTML|\?xml)', # (case insensitive)
    ICC  => '.{12}(scnr|mntr|prtr|link|spac|abst|nmcl|nkpf)(XYZ |Lab |Luv |YCbr|Yxy |RGB |GRAY|HSV |HLS |CMYK|CMY |[2-9A-F]CLR){2}',
    IND  => '\x06\x06\xed\xf5\xd8\x1d\x46\xe5\xbd\x31\xef\xe7\xfe\x74\xb7\x1d',
    ITC  => '.{4}itch',
    JP2  => '\0\0\0\x0cjP(  |\x1a\x1a)\x0d\x0a\x87\x0a',
    JPEG => '\xff\xd8\xff',
    LNK  => '.{4}\x01\x14\x02\0{5}\xc0\0{6}\x46',
    M2TS => '(....)?\x47',
    MIE  => '~[\x10\x18]\x04.0MIE',
    MIFF => 'id=ImageMagick',
    MKV  => '\x1a\x45\xdf\xa3',
    MOV  => '.{4}(free|skip|wide|ftyp|pnot|PICT|pict|moov|mdat|junk|uuid)',
  # MP3  =>  difficult to rule out
    MPC  => '(MP\+|ID3)',
    MPEG => '\0\0\x01[\xb0-\xbf]',
    MRW  => '\0MR[MI]',
    MXF  => '\x06\x0e\x2b\x34\x02\x05\x01\x01\x0d\x01\x02', # (not tested if extension recognized)
    OGG  => '(OggS|ID3)',
    ORF  => '(II|MM)',
    PDF  => '%PDF-\d+\.\d+',
    PGF  => 'PGF[0-9\0-\x09]',
    PICT => '(.{10}|.{522})(\x11\x01|\x00\x11)',
    PMP  => '.{8}\0{3}\x7c.{112}\xff\xd8\xff\xdb',
    PNG  => '(\x89P|\x8aM|\x8bJ)NG\r\n\x1a\n',
    PPM  => 'P[1-6]\s+',
    PS   => '(%!PS|%!Ad|\xc5\xd0\xd3\xc6)',
    PSD  => '8BPS\0[\x01\x02]',
    PSP  => 'Paint Shop Pro Image File\x0a\x1a\0{5}',
    QTIF => '.{4}(idsc|idat|iicc)',
    RAF  => 'FUJIFILM',
    RAR  => 'Rar!\x1a\x07\0',
    RAW  => '(.{25}ARECOYK|II|MM)',
    Real => '(\.RMF|\.ra\xfd|pnm://|rtsp://|http://)',
    RIFF => 'RIFF',
    RSRC => '(....)?\0\0\x01\0',
    RTF  => '[\n\r]*\\{[\n\r]*\\\\rtf',
    # (don't be too restrictive for RW2/RWL -- how does magic number change for big-endian?)
    RW2  => '(II|MM)', #(\x55\0\x18\0\0\0\x88\xe7\x74\xd8\xf8\x25\x1d\x4d\x94\x7a\x6e\x77\x82\x2b\x5d\x6a)
    RWL  => '(II|MM)', #(ditto)
    RWZ  => 'rawzor',
    SWF  => '[FC]WS[^\0]',
    TIFF => '(II|MM)', # don't test magic number (some raw formats are different)
    VRD  => 'CANON OPTIONAL DATA\0',
    X3F  => 'FOVb',
    XCF  => 'gimp xcf ',
    XMP  => '\0{0,3}(\xfe\xff|\xff\xfe|\xef\xbb\xbf)?\0{0,3}\s*<',
    ZIP  => 'PK\x03\x04',
);

# lookup for valid character set names (keys are all lower case)
%charsetName = (
    #   Charset setting                       alias(es)
    # -------------------------   --------------------------------------------
    utf8        => 'UTF8',        cp65001 => 'UTF8', 'utf-8' => 'UTF8',
    latin       => 'Latin',       cp1252  => 'Latin', latin1 => 'Latin',
    latin2      => 'Latin2',      cp1250  => 'Latin2',
    cyrillic    => 'Cyrillic',    cp1251  => 'Cyrillic', russian => 'Cyrillic',
    greek       => 'Greek',       cp1253  => 'Greek',
    turkish     => 'Turkish',     cp1254  => 'Turkish',
    hebrew      => 'Hebrew',      cp1255  => 'Hebrew',
    arabic      => 'Arabic',      cp1256  => 'Arabic',
    baltic      => 'Baltic',      cp1257  => 'Baltic',
    vietnam     => 'Vietnam',     cp1258  => 'Vietnam',
    thai        => 'Thai',        cp874   => 'Thai',
    macroman    => 'MacRoman',    cp10000 => 'MacRoman', mac => 'MacRoman', roman => 'MacRoman',
    maclatin2   => 'MacLatin2',   cp10029 => 'MacLatin2',
    maccyrillic => 'MacCyrillic', cp10007 => 'MacCyrillic',
    macgreek    => 'MacGreek',    cp10006 => 'MacGreek',
    macturkish  => 'MacTurkish',  cp10081 => 'MacTurkish',
    macromanian => 'MacRomanian', cp10010 => 'MacRomanian',
    maciceland  => 'MacIceland',  cp10079 => 'MacIceland',
    maccroatian => 'MacCroatian', cp10082 => 'MacCroatian',
);

# default group priority for writing
my @defaultWriteGroups = qw(EXIF IPTC XMP MakerNotes Photoshop ICC_Profile CanonVRD);

# group hash for ExifTool-generated tags
my %allGroupsExifTool = ( 0 => 'ExifTool', 1 => 'ExifTool', 2 => 'ExifTool' );

# special tag names (not used for tag info)
my %specialTags = (
    TABLE_NAME=>1, SHORT_NAME=>1, PROCESS_PROC=>1, WRITE_PROC=>1, CHECK_PROC=>1,
    GROUPS=>1, FORMAT=>1, FIRST_ENTRY=>1, TAG_PREFIX=>1, PRINT_CONV=>1,
    WRITABLE=>1, TABLE_DESC=>1, NOTES=>1, IS_OFFSET=>1, EXTRACT_UNKNOWN=>1,
    NAMESPACE=>1, PREFERRED=>1, SRC_TABLE=>1, PRIORITY=>1, WRITE_GROUP=>1,
    LANG_INFO=>1, VARS=>1, DATAMEMBER=>1, IS_SUBDIR=>1, SET_GROUP1=>1,
);

# headers for various segment types
$exifAPP1hdr = "Exif\0\0";
$xmpAPP1hdr = "http://ns.adobe.com/xap/1.0/\0";
$xmpExtAPP1hdr = "http://ns.adobe.com/xmp/extension/\0";
$psAPP13hdr = "Photoshop 3.0\0";
$psAPP13old = 'Adobe_Photoshop2.5:';

sub DummyWriteProc { return 1; }

# lookup for user lenses defined in @Image::ExifTool::UserDefined::Lenses
%Image::ExifTool::userLens = ( );

# queued plug-in tags to add to lookup
@Image::ExifTool::pluginTags = ( );
%Image::ExifTool::pluginTags = ( );

# tag information for preview image -- this should be used for all
# PreviewImage tags so they are handled properly when reading/writing
%Image::ExifTool::previewImageTagInfo = (
    Name => 'PreviewImage',
    Writable => 'undef',
    # a value of 'none' is ok...
    WriteCheck => '$val eq "none" ? undef : $self->CheckImage(\$val)',
    DataTag => 'PreviewImage',
    # accept either scalar or scalar reference
    RawConv => '$self->ValidateImage(ref $val ? $val : \$val, $tag)',
    # we allow preview image to be set to '', but we don't want a zero-length value
    # in the IFD, so set it temorarily to 'none'.  Note that the length is <= 4,
    # so this value will fit in the IFD so the preview fixup won't be generated.
    ValueConvInv => '$val eq "" and $val="none"; $val',
);

# extra tags that aren't truly EXIF tags, but are generated by the script
# Note: any tag in this list with a name corresponding to a Group0 name is
#       used to write the entire corresponding directory as a block.
%Image::ExifTool::Extra = (
    GROUPS => { 0 => 'File', 1 => 'File', 2 => 'Image' },
    VARS => { NO_ID => 1 }, # tag ID's aren't meaningful for these tags
    WRITE_PROC => \&DummyWriteProc,
    Error   => { Priority => 0, Groups => \%allGroupsExifTool },
    Warning => { Priority => 0, Groups => \%allGroupsExifTool },
    Comment => {
        Notes => 'comment embedded in JPEG, GIF89a or PPM/PGM/PBM image',
        Writable => 1,
        WriteGroup => 'Comment',
        Priority => 0,  # to preserve order of JPEG COM segments
    },
    Directory => {
        Groups => { 1 => 'System' },
        Writable => 1,
        Protected => 1,
        # translate backslashes in directory names and add trailing '/'
        ValueConvInv => '$_=$val; tr/\\\\/\//; m{[^/]$} and $_ .= "/"; $_',
    },
    FileName => {
        Groups => { 1 => 'System' },
        Writable => 1,
        Protected => 1,
        Notes => q{
            may be written with a full path name to set FileName and Directory in one
            operation.  See L<filename.html|../filename.html> for more information on
            writing the FileName and Directory tags
        },
        ValueConvInv => '$val=~tr/\\\\/\//; $val',
    },
    FileSize => {
        Groups => { 1 => 'System' },
        PrintConv => \&ConvertFileSize,
    },
    ResourceForkSize => {
        Groups => { 1 => 'System' },
        Notes => q{
            [Mac OS only] size of the file's resource fork if it contains data.  If this
            tag is generated the ExtractEmbedded option may be used to extract
            resource-fork information as a sub-document
        },
        PrintConv => \&ConvertFileSize,
    },
    FileType    => { },
    FileModifyDate => {
        Description => 'File Modification Date/Time',
        Notes => 'the filesystem modification time',
        Groups => { 1 => 'System', 2 => 'Time' },
        Writable => 1,
        # all pseudo-tags must be protected so -tagsfromfile fails with
        # unrecognized files unless a pseudo tag is specified explicitly
        Protected => 1,
        Shift => 'Time',
        ValueConv => 'ConvertUnixTime($val,1)',
        ValueConvInv => 'GetUnixTime($val,1)',
        PrintConv => '$self->ConvertDateTime($val)',
        PrintConvInv => '$self->InverseDateTime($val)',
    },
    FilePermissions => {
        Groups => { 1 => 'System' },
        Notes => q{
            r=read, w=write and x=execute permissions for the file owner, group and
            others.  The ValueConv value is an octal number so bit test operations on
            this value should be done in octal, ie. "oct($filePermissions) & 0200"
        },
        ValueConv => 'sprintf("%.3o", $val & 0777)',
        PrintConv => sub {
            my ($mask, $str, $val) = (0400, '', oct(shift));
            while ($mask) {
                foreach (qw(r w x)) {
                    $str .= $val & $mask ? $_ : '-';
                    $mask >>= 1;
                }
            }
            return $str;
        },
    },
    MIMEType    => { },
    ImageWidth  => { },
    ImageHeight => { },
    XResolution => { },
    YResolution => { },
    MaxVal      => { }, # max pixel value in PPM or PGM image
    EXIF => {
        Notes => 'the full EXIF data block from JPEG, PNG, JP2, MIE and MIFF images',
        Groups => { 0 => 'EXIF', 1 => 'EXIF' },
        Flags => ['Writable' ,'Protected', 'Binary'],
        WriteCheck => q{
            return undef if $val =~ /^(II\x2a\0|MM\0\x2a)/;
            return 'Invalid EXIF data';
        },
    },
    ICC_Profile => {
        Notes => 'the full ICC_Profile data block',
        Groups => { 0 => 'ICC_Profile', 1 => 'ICC_Profile' },
        Flags => ['Writable' ,'Protected', 'Binary'],
        WriteCheck => q{
            require Image::ExifTool::ICC_Profile;
            return Image::ExifTool::ICC_Profile::ValidateICC(\$val);
        },
    },
    XMP => {
        Notes => 'the full XMP data block',
        Groups => { 0 => 'XMP', 1 => 'XMP' },
        Flags => ['Writable', 'Protected', 'Binary'],
        Priority => 0,  # so main xmp (which usually comes first) takes priority
        WriteCheck => q{
            require Image::ExifTool::XMP;
            return Image::ExifTool::XMP::CheckXMP($self, $tagInfo, \$val);
        },
    },
    CanonVRD => {
        Notes => 'the full Canon DPP VRD trailer block',
        Groups => { 0 => 'CanonVRD', 1 => 'CanonVRD' },
        Flags => ['Writable' ,'Protected', 'Binary'],
        Permanent => 0, # (this is 1 by default for MakerNotes tags)
        WriteCheck => q{
            return undef if $val =~ /^CANON OPTIONAL DATA\0/;
            return 'Invalid CanonVRD data';
        },
    },
    CurrentIPTCDigest => {
        Notes => q{
            MD5 digest of existing IPTC data.  All zeros if IPTC exists but Digest::MD5
            is not installed.  Only calculated for IPTC in the standard location as
            specified by the L<MWG|http://www.metadataworkinggroup.org/>.  ExifTool
            automates the handling of this tag in the MWG module -- see the
            L<MWG Tag Name documentation|MWG.html> for details
        },
        ValueConv => 'unpack("H*", $val)',
    },
    PreviewImage => {
        Writable => 1,
        WriteCheck => '$self->CheckImage(\$val)',
        # can't delete, so set to empty string and return no error
        DelCheck => '$val = ""; return undef',
        # accept either scalar or scalar reference
        RawConv => '$self->ValidateImage(ref $val ? $val : \$val, $tag)',
    },
    PreviewPNG  => { Binary => 1 },
    ExifByteOrder => {
        Writable => 1,
        Notes => 'only writable for newly created EXIF segments',
        PrintConv => {
            II => 'Little-endian (Intel, II)',
            MM => 'Big-endian (Motorola, MM)',
        },
    },
    ExifUnicodeByteOrder => {
        Writable => 1,
        Notes => q{
            the EXIF specification is particularly vague about the byte ordering for
            Unicode text, and different applications use different conventions.  By
            default ExifTool writes Unicode text in EXIF byte order, but this write-only
            tag may be used to force a specific byte order
        },
        PrintConv => {
            II => 'Little-endian (Intel, II)',
            MM => 'Big-endian (Motorola, MM)',
        },
    },
    ExifToolVersion => {
        Description => 'ExifTool Version Number',
        Groups => \%allGroupsExifTool,
    },
    RAFVersion => { },
    JPEGDigest => {
        Notes => q{
            an MD5 digest of the JPEG quantization tables is combined with the component
            sub-sampling values to generate the value of this tag.  The result is
            compared to known values in an attempt to deduce the originating software
            based only on the JPEG image data.  For performance reasons, this tag is
            generated only if specifically requested
        },
    },
    Now => {
        Groups => { 0 => 'ExifTool', 1 => 'ExifTool', 2 => 'Time' },
        Notes => q{
            the current date/time.  Useful when setting the tag values, ie.
            C<"-modifydate<now">.  Not generated unless specifically requested
        },
        ValueConv => sub {
            my $time = shift;
            my @tm = localtime $time;
            my $tz = Image::ExifTool::TimeZoneString(\@tm, $time);
            sprintf("%4d:%.2d:%.2d %.2d:%.2d:%.2d%s", $tm[5]+1900, $tm[4]+1, $tm[3],
                    $tm[2], $tm[1], $tm[0], $tz);
        },
        PrintConv => '$self->ConvertDateTime($val)',
    },
    ID3Size     => { },
    Geotag => {
        Writable => 1,
        AllowGroup => '(exif|gps|xmp|xmp-exif)',
        Notes => q{
            this write-only tag is used to define the GPS track log data or track log
            file name.  Currently supported track log formats are GPX, NMEA RMC/GGA/GLL,
            KML, IGC, Garmin XML and TCX, and Magellan PMGNTRK.  See
            L<geotag.html|../geotag.html> for details
        },
        DelCheck => q{
            require Image::ExifTool::Geotag;
            # delete associated tags
            Image::ExifTool::Geotag::SetGeoValues($self, undef, $wantGroup);
        },
        ValueConvInv => q{
            require Image::ExifTool::Geotag;
            # always warn because this tag is never set (warning is "\n" on success)
            my $result = Image::ExifTool::Geotag::LoadTrackLog($self, $val);
            return '' if not defined $result;   # deleting geo tags
            return $result if ref $result;      # geotag data hash reference
            warn "$result\n";                   # error string
        },
    },
    Geotime => {
        Writable => 1,
        AllowGroup => '(exif|gps|xmp|xmp-exif)',
        Notes => q{
            this write-only tag is used to define a date/time for interpolating a
            position in the GPS track specified by the Geotag tag.  Writing this tag
            causes the following 8 tags to be written:  GPSLatitude, GPSLatitudeRef,
            GPSLongitude, GPSLongitudeRef, GPSAltitude, GPSAltitudeRef, GPSDateStamp and
            GPSTimeStamp.  The local system timezone is assumed if the date/time value
            does not contain a timezone.  May be deleted to delete associated GPS tags.
            A group name of 'EXIF' or 'XMP' may be specified to write or delete only
            EXIF or XMP GPS tags.  The value of Geotag must be assigned before this tag
        },
        DelCheck => q{
            require Image::ExifTool::Geotag;
            # delete associated tags
            Image::ExifTool::Geotag::SetGeoValues($self, undef, $wantGroup);
        },
        ValueConvInv => q{
            require Image::ExifTool::Geotag;
            warn Image::ExifTool::Geotag::SetGeoValues($self, $val, $wantGroup) . "\n";
            return undef;
        },
    },
    Geosync => {
        Writable => 1,
        AllowGroup => '(exif|gps|xmp|xmp-exif)',
        Shift => 'Time', # enables "+=" syntax as well as "=+"
        Notes => q{
            this write-only tag specifies a time difference to add to Geotime for
            synchronization with the GPS clock.  For example, set this to "-12" if the
            camera clock is 12 seconds faster than GPS time.  Input format is
            "[+-][[[DD ]HH:]MM:]SS[.ss]".  Must be set before Geotime to be effective.
            Additional features allow calculation of time differences and time drifts,
            and extraction of synchronization times from image files. See the
            L<geotagging documentation|../geotag.html> for details
        },
        ValueConvInv => q{
            require Image::ExifTool::Geotag;
            return Image::ExifTool::Geotag::ConvertGeosync($self, $val);
        },
    },
);

# YCbCrSubSampling values (used by JPEG SOF, EXIF and XMP)
%Image::ExifTool::JPEG::yCbCrSubSampling = (
    '1 1' => 'YCbCr4:4:4 (1 1)', #PH
    '2 1' => 'YCbCr4:2:2 (2 1)', #14 in Exif.pm
    '2 2' => 'YCbCr4:2:0 (2 2)', #14 in Exif.pm
    '4 1' => 'YCbCr4:1:1 (4 1)', #14 in Exif.pm
    '4 2' => 'YCbCr4:1:0 (4 2)', #PH
    '1 2' => 'YCbCr4:4:0 (1 2)', #PH
    '1 4' => 'YCbCr4:4:1 (1 4)', #JD
    '2 4' => 'YCbCr4:2:1 (2 4)', #JD
);

# define common JPEG segments here to avoid overhead of loading JPEG module

# JPEG SOF (start of frame) tags
# (ref http://www.w3.org/Graphics/JPEG/itu-t81.pdf)
%Image::ExifTool::JPEG::SOF = (
    GROUPS => { 0 => 'File', 1 => 'File', 2 => 'Image' },
    NOTES => 'This information is extracted from the JPEG Start Of Frame segment.',
    VARS => { NO_ID => 1 }, # tag ID's aren't meaningful for these tags
    EncodingProcess => {
        PrintHex => 1,
        PrintConv => {
            0x0 => 'Baseline DCT, Huffman coding',
            0x1 => 'Extended sequential DCT, Huffman coding',
            0x2 => 'Progressive DCT, Huffman coding',
            0x3 => 'Lossless, Huffman coding',
            0x5 => 'Sequential DCT, differential Huffman coding',
            0x6 => 'Progressive DCT, differential Huffman coding',
            0x7 => 'Lossless, Differential Huffman coding',
            0x9 => 'Extended sequential DCT, arithmetic coding',
            0xa => 'Progressive DCT, arithmetic coding',
            0xb => 'Lossless, arithmetic coding',
            0xd => 'Sequential DCT, differential arithmetic coding',
            0xe => 'Progressive DCT, differential arithmetic coding',
            0xf => 'Lossless, differential arithmetic coding',
        }
    },
    BitsPerSample    => { },
    ImageHeight      => { },
    ImageWidth       => { },
    ColorComponents  => { },
    YCbCrSubSampling => {
        Notes => 'calculated from components table',
        PrintConv => \%Image::ExifTool::JPEG::yCbCrSubSampling,
    },
);

# JPEG JFIF APP0 definitions
%Image::ExifTool::JFIF::Main = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    WRITE_PROC => \&Image::ExifTool::WriteBinaryData,
    CHECK_PROC => \&Image::ExifTool::CheckBinaryData,
    GROUPS => { 0 => 'JFIF', 1 => 'JFIF', 2 => 'Image' },
    DATAMEMBER => [ 2, 3, 5 ],
    0 => {
        Name => 'JFIFVersion',
        Format => 'int8u[2]',
        PrintConv => 'sprintf("%d.%.2d", split(" ",$val))',
    },
    2 => {
        Name => 'ResolutionUnit',
        Writable => 1,
        RawConv => '$$self{JFIFResolutionUnit} = $val',
        PrintConv => {
            0 => 'None',
            1 => 'inches',
            2 => 'cm',
        },
        Priority => -1,
    },
    3 => {
        Name => 'XResolution',
        Format => 'int16u',
        Writable => 1,
        Priority => -1,
        RawConv => '$$self{JFIFXResolution} = $val',
    },
    5 => {
        Name => 'YResolution',
        Format => 'int16u',
        Writable => 1,
        Priority => -1,
        RawConv => '$$self{JFIFYResolution} = $val',
    },
);
%Image::ExifTool::JFIF::Extension = (
    GROUPS => { 0 => 'JFIF', 1 => 'JFIF', 2 => 'Image' },
    0x10 => {
        Name => 'ThumbnailImage',
        RawConv => '$self->ValidateImage(\$val,$tag)',
    },
);

# Composite tags (accumulation of all Composite tag tables)
%Image::ExifTool::Composite = (
    GROUPS => { 0 => 'Composite', 1 => 'Composite' },
    TABLE_NAME => 'Image::ExifTool::Composite',
    SHORT_NAME => 'Composite',
    VARS => { NO_ID => 1 }, # want empty tagID's for Composite tags
    WRITE_PROC => \&DummyWriteProc,
);

# static private ExifTool variables

%allTables = ( );   # list of all tables loaded (except Composite tags)
@tableOrder = ( );  # order the tables were loaded

#------------------------------------------------------------------------------
# Warning handler routines (warning string stored in $evalWarning)
#
# Set warning message
# Inputs: 0) warning string (undef to reset warning)
sub SetWarning($) { $evalWarning = $_[0]; }

# Get warning message
sub GetWarning()  { return $evalWarning; }

# Clean unnecessary information (line number, LF) from warning
# Inputs: 0) warning string or undef to use current warning
# Returns: cleaned warning
sub CleanWarning(;$)
{
    my $str = shift;
    unless (defined $str) {
        return undef unless defined $evalWarning;
        $str = $evalWarning;
    }
    $str = $1 if $str =~ /(.*) at /s;
    $str =~ s/\s+$//s;
    return $str;
}

#==============================================================================
# New - create new ExifTool object
# Inputs: 0) reference to exiftool object or ExifTool class name
# Returns: blessed ExifTool object ref
sub new
{
    local $_;
    my $that = shift;
    my $class = ref($that) || $that || 'Image::ExifTool';
    my $self = bless {}, $class;

    # make sure our main Exif tag table has been loaded
    GetTagTable("Image::ExifTool::Exif::Main");

    $self->ClearOptions();      # create default options hash
    $self->{VALUE} = { };       # must initialize this for warning messages
    $self->{DEL_GROUP} = { };   # list of groups to delete when writing

    # initialize our new groups for writing
    $self->SetNewGroups(@defaultWriteGroups);

    return $self;
}

#------------------------------------------------------------------------------
# ImageInfo - return specified information from image file
# Inputs: 0) [optional] ExifTool object reference
#         1) filename, file reference, or scalar data reference
#         2-N) list of tag names to find (or tag list reference or options reference)
# Returns: reference to hash of tag/value pairs (with "Error" entry on error)
# Notes:
#   - if no tags names are specified, the values of all tags are returned
#   - tags may be specified with leading '-' to exclude, or trailing '#' for ValueConv
#   - can pass a reference to list of tags to find, in which case the list will
#     be updated with the tags found in the proper case and in the specified order.
#   - can pass reference to hash specifying options
#   - returned tag values may be scalar references indicating binary data
#   - see ClearOptions() below for a list of options and their default values
# Examples:
#   use Image::ExifTool 'ImageInfo';
#   my $info = ImageInfo($file, 'DateTimeOriginal', 'ImageSize');
#    - or -
#   my $exifTool = new Image::ExifTool;
#   my $info = $exifTool->ImageInfo($file, \@tagList, {Sort=>'Group0'} );
sub ImageInfo($;@)
{
    local $_;
    # get our ExifTool object ($self) or create one if necessary
    my $self;
    if (ref $_[0] and UNIVERSAL::isa($_[0],'Image::ExifTool')) {
        $self = shift;
    } else {
        $self = new Image::ExifTool;
    }
    my %saveOptions = %{$self->{OPTIONS}};  # save original options

    # initialize file information
    $self->{FILENAME} = $self->{RAF} = undef;

    $self->ParseArguments(@_);              # parse our function arguments
    $self->ExtractInfo(undef);              # extract meta information from image
    my $info = $self->GetInfo(undef);       # get requested information

    $self->{OPTIONS} = \%saveOptions;       # restore original options

    return $info;   # return requested information
}

#------------------------------------------------------------------------------
# Get/set ExifTool options
# Inputs: 0) ExifTool object reference,
#         1) Parameter name, 2) Value to set the option
#         3-N) More parameter/value pairs
# Returns: original value of last option specified
sub Options($$;@)
{
    local $_;
    my $self = shift;
    my $options = $$self{OPTIONS};
    my $oldVal;

    while (@_) {
        my $param = shift;
        $oldVal = $$options{$param};
        last unless @_;
        my $newVal = shift;
        if ($param eq 'Lang') {
            # allow this to be set to undef to select the default language
            $newVal = $defaultLang unless defined $newVal;
            if ($newVal eq $defaultLang) {
                $$options{$param} = $newVal;
                delete $$self{CUR_LANG};
            # make sure the language is available
            } elsif (eval "require Image::ExifTool::Lang::$newVal") {
                my $xlat = "Image::ExifTool::Lang::${newVal}::Translate";
                no strict 'refs';
                if (%$xlat) {
                    $$self{CUR_LANG} = \%$xlat;
                    $$options{$param} = $newVal;
                }
            } # else don't change Lang
        } elsif ($param eq 'Exclude' and defined $newVal) {
            # clone Exclude list and expand shortcuts
            my @exclude;
            if (ref $newVal eq 'ARRAY') {
                @exclude = @$newVal;
            } else {
                @exclude = ($newVal);
            }
            ExpandShortcuts(\@exclude, 1);  # (also remove '#' suffix)
            $$options{$param} = \@exclude;
        } elsif ($param =~ /^Charset/ or $param eq 'IPTCCharset') {
            # only allow valid character sets to be set
            if ($newVal) {
                my $charset = $charsetName{lc $newVal};
                if ($charset) {
                    $$options{$param} = $charset;
                    # maintain backward-compatibility with old IPTCCharset option
                    $$options{CharsetIPTC} = $charset if $param eq 'IPTCCharset';
                } else {
                    warn "Invalid Charset $newVal\n";
                }
            }
        } else {
            if ($param eq 'Escape') {
                # set ESCAPE_PROC
                if (defined $newVal and $newVal eq 'XML') {
                    require Image::ExifTool::XMP;
                    $$self{ESCAPE_PROC} = \&Image::ExifTool::XMP::EscapeXML;
                } elsif (defined $newVal and $newVal eq 'HTML') {
                    require Image::ExifTool::HTML;
                    $$self{ESCAPE_PROC} = \&Image::ExifTool::HTML::EscapeHTML;
                } else {
                    delete $$self{ESCAPE_PROC};
                }
                # must forget saved values since they depend on Escape method
                $self->{BOTH} = { };
            }
            $$options{$param} = $newVal;
        }
    }
    return $oldVal;
}

#------------------------------------------------------------------------------
# ClearOptions - set options to default values
# Inputs: 0) ExifTool object reference
sub ClearOptions($)
{
    local $_;
    my $self = shift;

    # create options hash with default values
    # (commented out options don't need initializing)
    # +-----------------------------------------------------+
    # ! DON'T FORGET!!  When adding any new option, must    !
    # ! decide how it is handled in SetNewValuesFromFile()  !
    # +-----------------------------------------------------+
    $self->{OPTIONS} = {
    #   Binary      => undef,   # flag to extract binary values even if tag not specified
    #   ByteOrder   => undef,   # default byte order when creating EXIF information
        Charset     => 'UTF8',  # character set for converting Unicode characters
        CharsetID3  => 'Latin', # internal ID3v1 character set
        CharsetIPTC => 'Latin', # fallback IPTC character set if no CodedCharacterSet
    #   Compact     => undef,   # compact XMP and IPTC data
        Composite   => 1,       # flag to calculate Composite tags
    #   Compress    => undef,   # flag to write new values as compressed if possible
    #   CoordFormat => undef,   # GPS lat/long coordinate format
    #   DateFormat  => undef,   # format for date/time
        Duplicates  => 1,       # flag to save duplicate tag values
    #   Escape      => undef,   # escape special characters
    #   Exclude     => undef,   # tags to exclude
    #   ExtractEmbedded =>undef,# flag to extract information from embedded documents
    #   FastScan    => undef,   # flag to avoid scanning for trailer
    #   FixBase     => undef,   # fix maker notes base offsets
    #   GeoMaxIntSecs => undef, # geotag maximum interpolation time (secs)
    #   GeoMaxExtSecs => undef, # geotag maximum extrapolation time (secs)
    #   GeoMaxHDOP  => undef,   # geotag maximum HDOP
    #   GeoMaxPDOP  => undef,   # geotag maximum PDOP
    #   GeoMinSats  => undef,   # geotag minimum satellites
    #   Group#      => undef,   # return tags for specified groups in family #
        HtmlDump    => 0,       # HTML dump (0-3, higher # = bigger limit)
    #   HtmlDumpBase => undef,  # base address for HTML dump
    #   IgnoreMinorErrors => undef, # ignore minor errors when reading/writing
        Lang        => $defaultLang,# localized language for descriptions etc
    #   LargeFileSupport => undef,  # flag indicating support of 64-bit file offsets
    #   List        => undef,   # extract lists of PrintConv values into arrays
        ListSep     => ', ',    # list item separator
    #   ListSplit   => undef,   # regex for splitting list-type tag values when writing
    #   MakerNotes  => undef,   # extract maker notes as a block
    #   MissingTagValue =>undef,# value for missing tags when expanded in expressions
    #   Password    => undef,   # password for password-protected PDF documents
        PrintConv   => 1,       # flag to enable print conversion
    #   SavePath    => undef,   # (undocumented) save family 5 location path
    #   ScanForXMP  => undef,   # flag to scan for XMP information in all files
        Sort        => 'Input', # order to sort found tags (Input, File, Alpha, Group#)
    #   StrictDate  => undef,   # flag to return undef for invalid date conversions
    #   Struct      => undef,   # return structures as hash references
        TextOut     => \*STDOUT,# file for Verbose/HtmlDump output
        Unknown     => 0,       # flag to get values of unknown tags (0-2)
        Verbose     => 0,       # print verbose messages (0-5, higher # = more verbose)
    };
    # keep necessary member variables in sync with options
    delete $$self{CUR_LANG};
    delete $$self{ESCAPE_PROC};

    # load user-defined default options
    if (%Image::ExifTool::UserDefined::Options) {
        foreach (keys %Image::ExifTool::UserDefined::Options) {
            $self->Options($_, $Image::ExifTool::UserDefined::Options{$_});
        }
    }
}

#------------------------------------------------------------------------------
# Extract meta information from image
# Inputs: 0) ExifTool object reference
#         1-N) Same as ImageInfo()
# Returns: 1 if this was a valid image, 0 otherwise
# Notes: pass an undefined value to avoid parsing arguments
# Internal 'ReEntry' option allows this routine to be called recursively
sub ExtractInfo($;@)
{
    local $_;
    my $self = shift;
    my $options = $self->{OPTIONS};     # pointer to current options
    my (%saveOptions, $reEntry, $rsize);

    # check for internal ReEntry option to allow recursive calls to ExtractInfo
    if (ref $_[1] eq 'HASH' and $_[1]{ReEntry} and
       (ref $_[0] eq 'SCALAR' or ref $_[0] eq 'GLOB'))
    {
        # save necessary members for restoring later
        $reEntry = {
            RAF       => $$self{RAF},
            PROCESSED => $$self{PROCESSED},
            EXIF_DATA => $$self{EXIF_DATA},
            EXIF_POS  => $$self{EXIF_POS},
            FILE_TYPE => $$self{FILE_TYPE},
        };
        $self->{RAF} = new File::RandomAccess($_[0]);
        $$self{PROCESSED} = { };
        delete $$self{EXIF_DATA};
        delete $$self{EXIF_POS};
    } else {
        if (defined $_[0] or $options->{HtmlDump}) {
            %saveOptions = %$options;       # save original options
    
            # require duplicates for html dump
            $self->Options(Duplicates => 1) if $options->{HtmlDump};
    
            if (defined $_[0]) {
                # only initialize filename if called with arguments
                $self->{FILENAME} = undef;  # name of file (or '' if we didn't open it)
                $self->{RAF} = undef;       # RandomAccess object reference
    
                $self->ParseArguments(@_);  # initialize from our arguments
            }
        }
        # initialize ExifTool object members
        $self->Init();

        delete $self->{MAKER_NOTE_FIXUP};   # fixup information for extracted maker notes
        delete $self->{MAKER_NOTE_BYTE_ORDER};

        # return our version number
        $self->FoundTag('ExifToolVersion', "$VERSION$RELEASE");
        $self->FoundTag('Now', time()) if $self->{REQ_TAG_LOOKUP}{now} or $self->{TAGS_FROM_FILE};
    }
    my $filename = $self->{FILENAME};   # image file name ('' if already open)
    my $raf = $self->{RAF};             # RandomAccess object

    local *EXIFTOOL_FILE;   # avoid clashes with global namespace

    my $realname = $filename;
    unless ($raf) {
        # save file name
        if (defined $filename and $filename ne '') {
            unless ($filename eq '-') {
                # extract file name from pipe if necessary
                $realname =~ /\|$/ and $realname =~ s/.*?"(.*?)".*/$1/;
                my ($dir, $name);
                if (eval 'require File::Basename') {
                    $dir = File::Basename::dirname($realname);
                    $name = File::Basename::basename($realname);
                } else {
                    ($name = $realname) =~ tr/\\/\//;
                    # remove path
                    $dir = length($1) ? $1 : '/' if $name =~ s/(.*)\///;
                }
                $self->FoundTag('FileName', $name);
                $self->FoundTag('Directory', $dir) if defined $dir and length $dir;
                # get size of resource fork on Mac OS
                $rsize = -s "$filename/rsrc" if $^O eq 'darwin' and not $$self{IN_RESOURCE};
            }
            # open the file
            if (open(EXIFTOOL_FILE, $filename)) {
                my $filePt = \*EXIFTOOL_FILE;
                # create random access file object
                $raf = new File::RandomAccess($filePt);
                # patch to force pipe to be buffered because seek returns success
                # in Windows cmd shell pipe even though it really failed
                $raf->{TESTED} = -1 if $filename eq '-' or $filename =~ /\|$/;
                $self->{RAF} = $raf;
            } else {
                $self->Error('Error opening file');
            }
        } else {
            $self->Error('No file specified');
        }
    }

    if ($raf) {
        if ($reEntry) {
            # we already set these tags
        } elsif (not $raf->{FILE_PT}) {
            # get file size from image in memory
            $self->FoundTag('FileSize', length ${$raf->{BUFF_PT}});
        } elsif (-f $raf->{FILE_PT}) {
            # get file size and last modified time if this is a plain file
            my $fileSize = -s _;
            my $fileTime = -M _;
            my @stat = stat _;
            $self->FoundTag('FileSize', $fileSize) if defined $fileSize;
            $self->FoundTag('ResourceForkSize', $rsize) if $rsize;
            $self->FoundTag('FileModifyDate', $^T - $fileTime*(24*3600)) if defined $fileTime;
            $self->FoundTag('FilePermissions', $stat[2]) if defined $stat[2];
        }

        # get list of file types to check
        my ($tiffType, %noMagic);
        $self->{FILE_EXT} = GetFileExtension($realname);
        my @fileTypeList = GetFileType($realname);
        if (@fileTypeList) {
            # add remaining types to end of list so we test them all
            my $pat = join '|', @fileTypeList;
            push @fileTypeList, grep(!/^($pat)$/, @fileTypes);
            $tiffType = $self->{FILE_EXT};
            $noMagic{MXF} = 1;  # don't do magic number test on MXF or DV files
            $noMagic{DV} = 1;
        } else {
            # scan through all recognized file types
            @fileTypeList = @fileTypes;
            $tiffType = 'TIFF';
        }
        push @fileTypeList, ''; # end of list marker
        # initialize the input file for seeking in binary data
        $raf->BinMode();    # set binary mode before we start reading
        my $pos = $raf->Tell(); # get file position so we can rewind
        my %dirInfo = ( RAF => $raf, Base => $pos );
        # loop through list of file types to test
        my ($type, $buff, $seekErr);
        # read first 1024 bytes of file for testing
        $raf->Read($buff, 1024) or $buff = '';
        $raf->Seek($pos, 0) or $seekErr = 1;
        until ($seekErr) {
            $type = shift @fileTypeList;
            if ($type) {
                # do quick test for this file type to avoid loading module unnecessarily
                next if $magicNumber{$type} and $buff !~ /^$magicNumber{$type}/s and
                        not $noMagic{$type};
            } else {
                last unless defined $type;
                # last ditch effort to scan past unknown header for JPEG/TIFF
                next unless $buff =~ /(\xff\xd8\xff|MM\0\x2a|II\x2a\0)/g;
                $type = ($1 eq "\xff\xd8\xff") ? 'JPEG' : 'TIFF';
                my $skip = pos($buff) - length($1);
                $dirInfo{Base} = $pos + $skip;
                $raf->Seek($pos + $skip, 0) or $seekErr = 1, last;
                $self->Warn("Skipped unknown $skip byte header");
            }
            # save file type in member variable
            $self->{FILE_TYPE} = $self->{PATH}[0] = $type;
            $dirInfo{Parent} = ($type eq 'TIFF') ? $tiffType : $type;
            my $module = $moduleName{$type};
            $module = $type unless defined $module;
            my $func = "Process$type";

            # load module if necessary
            if ($module) {
                require "Image/ExifTool/$module.pm";
                $func = "Image::ExifTool::${module}::$func";
            }
            # process the file
            no strict 'refs';
            &$func($self, \%dirInfo) and last;
            use strict 'refs';

            # seek back to try again from the same position in the file
            $raf->Seek($pos, 0) or $seekErr = 1, last;
        }
        if ($seekErr) {
            $self->Error('Error seeking in file');
        } elsif ($self->Options('ScanForXMP') and (not defined $type or
            (not $self->Options('FastScan') and not $$self{FoundXMP})))
        {
            # scan for XMP
            $raf->Seek($pos, 0);
            require Image::ExifTool::XMP;
            Image::ExifTool::XMP::ScanForXMP($self, $raf) and $type = '';
        }
        unless (defined $type) {
            # if we were given a single image with a known type there
            # must be a format error since we couldn't read it, otherwise
            # it is likely we don't support images of this type
            my $fileType = GetFileType($realname);
            my $err;
            if (not $fileType) {
                $err = 'Unknown file type';
            } elsif ($fileType eq 'RAW') {
                $err = 'Unsupported RAW file type';
            } else {
                $err = 'File format error';
            }
            $self->Error($err);
        }
        # extract binary EXIF data block only if requested
        if (defined $self->{EXIF_DATA} and length $$self{EXIF_DATA} > 16 and
            ($self->{REQ_TAG_LOOKUP}{exif} or $self->{OPTIONS}{Binary}))
        {
            $self->FoundTag('EXIF', $self->{EXIF_DATA});
        }
        unless ($reEntry) {
            $self->{PATH} = [ ];    # reset PATH
            # calculate Composite tags
            $self->BuildCompositeTags() if $options->{Composite};
            # do our HTML dump if requested
            if ($self->{HTML_DUMP}) {
                $raf->Seek(0, 2);   # seek to end of file
                $self->{HTML_DUMP}->FinishTiffDump($self, $raf->Tell());
                my $pos = $options->{HtmlDumpBase};
                $pos = ($self->{FIRST_EXIF_POS} || 0) unless defined $pos;
                my $dataPt = defined $self->{EXIF_DATA} ? \$self->{EXIF_DATA} : undef;
                undef $dataPt if defined $self->{EXIF_POS} and $pos != $self->{EXIF_POS};
                my $success = $self->{HTML_DUMP}->Print($raf, $dataPt, $pos,
                    $options->{TextOut}, $options->{HtmlDump},
                    $self->{FILENAME} ? "HTML Dump ($self->{FILENAME})" : 'HTML Dump');
                $self->Warn("Error reading $self->{HTML_DUMP}{ERROR}") if $success < 0;
            }
        }
        if ($filename) {
            $raf->Close();  # close the file if we opened it
            # process the resource fork as an embedded file on Mac filesystems
            if ($rsize and $options->{ExtractEmbedded}) {
                local *RESOURCE_FILE;
                if (open(RESOURCE_FILE, "$filename/rsrc")) {
                    $$self{DOC_NUM} = $$self{DOC_COUNT} + 1;
                    $$self{IN_RESOURCE} = 1;
                    $self->ExtractInfo(\*RESOURCE_FILE, { ReEntry => 1 });
                    close RESOURCE_FILE;
                    delete $$self{IN_RESOURCE};
                } else {
                    $self->Warn('Error opening resource fork');
                }
            }
        }
    }

    # restore original options
    %saveOptions and $self->{OPTIONS} = \%saveOptions;

    if ($reEntry) {
        # restore necessary members when exiting re-entrant code
        $$self{$_} = $$reEntry{$_} foreach keys %$reEntry;
    }

    return exists $self->{VALUE}{Error} ? 0 : 1;
}

#------------------------------------------------------------------------------
# Get hash of extracted meta information
# Inputs: 0) ExifTool object reference
#         1-N) options hash reference, tag list reference or tag names
# Returns: Reference to information hash
# Notes: - pass an undefined value to avoid parsing arguments
#        - If groups are specified, first groups take precedence if duplicate
#          tags found but Duplicates option not set.
#        - tag names may end in '#' to extract ValueConv value
sub GetInfo($;@)
{
    local $_;
    my $self = shift;
    my %saveOptions;

    unless (@_ and not defined $_[0]) {
        %saveOptions = %{$self->{OPTIONS}}; # save original options
        # must set FILENAME so it isn't parsed from the arguments
        $self->{FILENAME} = '' unless defined $self->{FILENAME};
        $self->ParseArguments(@_);
    }

    # get reference to list of tags for which we will return info
    my ($rtnTags, $byValue) = $self->SetFoundTags();

    # build hash of tag information
    my (%info, %ignored);
    my $conv = $self->{OPTIONS}{PrintConv} ? 'PrintConv' : 'ValueConv';
    foreach (@$rtnTags) {
        my $val = $self->GetValue($_, $conv);
        defined $val or $ignored{$_} = 1, next;
        $info{$_} = $val;
    }

    # override specified tags with ValueConv value if necessary
    if (@$byValue and $conv ne 'ValueConv') {
        # first determine the number of times each non-ValueConv value is used
        my %nonVal;
        $nonVal{$_} = ($nonVal{$_} || 0) + 1 foreach @$rtnTags;
        --$nonVal{$$rtnTags[$_]} foreach @$byValue;
        # then loop through ValueConv tags, updating return values as necessary
        foreach (@$byValue) {
            my $tag = $$rtnTags[$_];
            my $val = $self->GetValue($tag, 'ValueConv');
            next unless defined $val;
            # must generate new tag key if the non-ValueConv value is also used
            # (otherwise we just override the returned value for the existing key)
            if ($nonVal{$tag}) {
                my $vtag = $tag;
                # generate a new tag key like "Tag #" or "Tag #(1)"
                $vtag =~ s/( |$)/ #/;
                unless (defined $self->{VALUE}->{$vtag}) {
                    $self->{VALUE}{$vtag} = $self->{VALUE}{$tag};
                    $self->{TAG_INFO}{$vtag} = $self->{TAG_INFO}{$tag};
                    $self->{TAG_EXTRA}{$vtag} = $self->{TAG_EXTRA}{$tag};
                    $self->{FILE_ORDER}{$vtag} = $self->{FILE_ORDER}{$tag};
                }
                # store ValueConv value with new tag key
                $$rtnTags[$_] = $tag = $vtag;
            }
            $info{$tag} = $val;     # return ValueConv value
        }
    }

    # remove ignored tags from the list
    my $reqTags = $self->{REQUESTED_TAGS} || [ ];
    if (%ignored and not @$reqTags) {
        my @goodTags;
        foreach (@$rtnTags) {
            push @goodTags, $_ unless $ignored{$_};
        }
        $rtnTags = $self->{FOUND_TAGS} = \@goodTags;
    }

    # return sorted tag list if provided with a list reference
    if ($self->{IO_TAG_LIST}) {
        # use file order by default if no tags specified
        # (no such thing as 'Input' order in this case)
        my $sortOrder = $self->{OPTIONS}{Sort};
        unless (@$reqTags or ($sortOrder and $sortOrder ne 'Input')) {
            $sortOrder = 'File';
        }
        # return tags in specified sort order
        @{$self->{IO_TAG_LIST}} = $self->GetTagList($rtnTags, $sortOrder);
    }

    # restore original options
    %saveOptions and $self->{OPTIONS} = \%saveOptions;

    return \%info;
}

#------------------------------------------------------------------------------
# Combine information from a list of info hashes
# Unless Duplicates is enabled, first entry found takes priority
# Inputs: 0) ExifTool object reference, 1-N) list of info hash references
# Returns: Combined information hash reference
sub CombineInfo($;@)
{
    local $_;
    my $self = shift;
    my (%combinedInfo, $info, $tag, %haveInfo);

    if ($self->{OPTIONS}{Duplicates}) {
        while ($info = shift) {
            foreach $tag (keys %$info) {
                $combinedInfo{$tag} = $$info{$tag};
            }
        }
    } else {
        while ($info = shift) {
            foreach $tag (keys %$info) {
                my $tagName = GetTagName($tag);
                next if $haveInfo{$tagName};
                $haveInfo{$tagName} = 1;
                $combinedInfo{$tag} = $$info{$tag};
            }
        }
    }
    return \%combinedInfo;
}

#------------------------------------------------------------------------------
# Inputs: 0) ExifTool object reference
#         1) [optional] reference to info hash or tag list ref (default is found tags)
#         2) [optional] sort order ('File', 'Input', ...)
# Returns: List of tags in specified order
sub GetTagList($;$$)
{
    local $_;
    my ($self, $info, $sortOrder) = @_;

    my $foundTags;
    if (ref $info eq 'HASH') {
        my @tags = keys %$info;
        $foundTags = \@tags;
    } elsif (ref $info eq 'ARRAY') {
        $foundTags = $info;
    }
    my $fileOrder = $self->{FILE_ORDER};

    if ($foundTags) {
        # make sure a FILE_ORDER entry exists for all tags
        # (note: already generated bogus entries for FOUND_TAGS case below)
        foreach (@$foundTags) {
            next if defined $$fileOrder{$_};
            $$fileOrder{$_} = 999;
        }
    } else {
        $sortOrder = $info if $info and not $sortOrder;
        $foundTags = $self->{FOUND_TAGS} || $self->SetFoundTags() or return undef;
    }
    $sortOrder or $sortOrder = $self->{OPTIONS}{Sort};

    # return original list if no sort order specified
    return @$foundTags unless $sortOrder and $sortOrder ne 'Input';

    if ($sortOrder eq 'Alpha') {
        return sort @$foundTags;
    } elsif ($sortOrder =~ /^Group(\d*(:\d+)*)/) {
        my $family = $1 || 0;
        # want to maintain a basic file order with the groups
        # ordered in the way they appear in the file
        my (%groupCount, %groupOrder);
        my $numGroups = 0;
        my $tag;
        foreach $tag (sort { $$fileOrder{$a} <=> $$fileOrder{$b} } @$foundTags) {
            my $group = $self->GetGroup($tag, $family);
            my $num = $groupCount{$group};
            $num or $num = $groupCount{$group} = ++$numGroups;
            $groupOrder{$tag} = $num;
        }
        return sort { $groupOrder{$a} <=> $groupOrder{$b} or
                      $$fileOrder{$a} <=> $$fileOrder{$b} } @$foundTags;
    } else {
        return sort { $$fileOrder{$a} <=> $$fileOrder{$b} } @$foundTags;
    }
}

#------------------------------------------------------------------------------
# Get list of found tags in specified sort order
# Inputs: 0) ExifTool object reference, 1) sort order ('File', 'Input', ...)
# Returns: List of tag keys in specified order
# Notes: If not specified, sort order is taken from OPTIONS
sub GetFoundTags($;$)
{
    local $_;
    my ($self, $sortOrder) = @_;
    my $foundTags = $self->{FOUND_TAGS} || $self->SetFoundTags() or return undef;
    return $self->GetTagList($foundTags, $sortOrder);
}

#------------------------------------------------------------------------------
# Get list of requested tags
# Inputs: 0) ExifTool object reference
# Returns: List of requested tag keys
sub GetRequestedTags($)
{
    local $_;
    return @{$_[0]{REQUESTED_TAGS}};
}

#------------------------------------------------------------------------------
# Get tag value
# Inputs: 0) ExifTool object reference
#         1) tag key (or flattened tagInfo for getting field values, not part of public API)
#         2) [optional] Value type: PrintConv, ValueConv, Both or Raw, the default
#            is PrintConv or ValueConv, depending on the PrintConv option setting
#         3) raw field value (not part of public API)
# Returns: Scalar context: tag value or undefined
#          List context: list of values or empty list
sub GetValue($$;$)
{
    local $_;
    my ($self, $tag, $type) = @_; # plus: ($fieldValue)
    my (@convTypes, $tagInfo, $valueConv, $both);

    # figure out what conversions to do
    $type or $type = $self->{OPTIONS}{PrintConv} ? 'PrintConv' : 'ValueConv';

    # start with the raw value
    my $value = $self->{VALUE}{$tag};
    if (not defined $value) {
        return wantarray ? () : undef unless ref $tag;
        # get the value of a structure field
        $tagInfo = $tag;
        $tag = $$tagInfo{Name};
        $value = $_[3];
        # (note: type "Both" is not allowed for structure fields)
        if ($type ne 'Raw') {
            push @convTypes, 'ValueConv';
            push @convTypes, 'PrintConv' unless $type eq 'ValueConv';
        }
    } else {
        $tagInfo = $self->{TAG_INFO}{$tag};
        if ($$tagInfo{Struct} and ref $value) {
            # must load XMPStruct.pl just in case (should already be loaded if
            # a structure was extracted, but we could also arrive here if a simple
            # list of values was stored incorrectly in a Struct tag)
            require 'Image/ExifTool/XMPStruct.pl';
            # convert strucure field values
            unless ($type eq 'Both') {
                # (note: ConvertStruct handles the escape too if necessary)
                return Image::ExifTool::XMP::ConvertStruct($self,$tagInfo,$value,$type);
            }
            $valueConv = Image::ExifTool::XMP::ConvertStruct($self,$tagInfo,$value,'ValueConv');
            $value = Image::ExifTool::XMP::ConvertStruct($self,$tagInfo,$value,'PrintConv');
            # (must not save these in $$self{BOTH} because the values may have been escaped)
            return ($valueConv, $value);
        }
        if ($type ne 'Raw') {
            # use values we calculated already if we stored them
            $both = $self->{BOTH}{$tag};
            if ($both) {
                if ($type eq 'PrintConv') {
                    $value = $$both[1];
                } elsif ($type eq 'ValueConv') {
                    $value = $$both[0];
                    $value = $$both[1] unless defined $value;
                } else {
                    ($valueConv, $value) = @$both;
                }
            } else {
                push @convTypes, 'ValueConv';
                push @convTypes, 'PrintConv' unless $type eq 'ValueConv';
            }
        }
    }

    # do the conversions
    my (@val, @prt, @raw, $convType);
    foreach $convType (@convTypes) {
        # don't convert a scalar reference or structure
        last if ref $value eq 'SCALAR';
        my $conv = $$tagInfo{$convType};
        unless (defined $conv) {
            if ($convType eq 'ValueConv') {
                next unless $$tagInfo{Binary};
                $conv = '\$val';  # return scalar reference for binary values
            } else {
                # use PRINT_CONV from tag table if PrintConv doesn't exist
                next unless defined($conv = $tagInfo->{Table}{PRINT_CONV});
                next if exists $$tagInfo{$convType};
            }
        }
        # save old ValueConv value if we want Both
        $valueConv = $value if $type eq 'Both' and $convType eq 'PrintConv';
        my ($i, $val, $vals, @values, $convList);
        # split into list if conversion is an array
        if (ref $conv eq 'ARRAY') {
            $convList = $conv;
            $conv = $$convList[0];
            my @valList = split ' ', $value;
            # reorganize list if specified (Note: The writer currently doesn't
            # relist values, so they may be grouped but the order must not change)
            my $relist = $$tagInfo{Relist};
            if ($relist) {
                my (@newList, $oldIndex);
                foreach $oldIndex (@$relist) {
                    my ($newVal, @join);
                    if (ref $oldIndex) {
                        foreach (@$oldIndex) {
                            push @join, $valList[$_] if defined $valList[$_];
                        }
                        $newVal = join(' ', @join) if @join;
                    } else {
                        $newVal = $valList[$oldIndex];
                    }
                    push @newList, $newVal if defined $newVal;
                }
                $value = \@newList;
            } else {
                $value = \@valList;
            }
        }
        # initialize array so we can iterate over values in list
        if (ref $value eq 'ARRAY') {
            $i = 0;
            $vals = $value;
            $val = $$vals[0];
        } else {
            $val = $value;
        }
        # loop through all values in list
        for (;;) {
            if (defined $conv) {
                # get values of required tags if this is a Composite tag
                if (ref $val eq 'HASH' and not @val) {
                    # disable escape of source values so we don't double escape them
                    my $oldEscape = $$self{ESCAPE_PROC};
                    delete $$self{ESCAPE_PROC};
                    foreach (keys %$val) {
                        $raw[$_] = $self->{VALUE}{$$val{$_}};
                        ($val[$_], $prt[$_]) = $self->GetValue($$val{$_}, 'Both');
                        next if defined $val[$_] or not $tagInfo->{Require}{$_};
                        $$self{ESCAPE_PROC} = $oldEscape;
                        return wantarray ? () : undef;
                    }
                    $$self{ESCAPE_PROC} = $oldEscape;
                    # set $val to $val[0], or \@val for a CODE ref conversion
                    $val = ref $conv eq 'CODE' ? \@val : $val[0];
                }
                if (ref $conv eq 'HASH') {
                    # look up converted value in hash
                    my $lc;
                    if (defined($value = $$conv{$val})) {
                        # override with our localized language PrintConv if available
                        if ($$self{CUR_LANG} and $convType eq 'PrintConv' and
                            # (no need to check for lang-alt tag names -- they won't have a PrintConv)
                            ref($lc = $self->{CUR_LANG}{$$tagInfo{Name}}) eq 'HASH' and
                            ($lc = $$lc{PrintConv}) and ($lc = $$lc{$value}))
                        {
                            $value = $self->Decode($lc, 'UTF8');
                        }
                    } else {
                        if ($$conv{BITMASK}) {
                            $value = DecodeBits($val, $$conv{BITMASK});
                            # override with localized language strings
                            if (defined $value and $$self{CUR_LANG} and $convType eq 'PrintConv' and
                                ref($lc = $self->{CUR_LANG}{$$tagInfo{Name}}) eq 'HASH' and
                                ($lc = $$lc{PrintConv}))
                            {
                                my @vals = split ', ', $value;
                                foreach (@vals) {
                                    $_ = $$lc{$_} if defined $$lc{$_};
                                }
                                $value = join ', ', @vals;
                            }
                        } elsif (not $$conv{OTHER} or
                                 # use alternate conversion routine if available
                                 not defined($value = &{$$conv{OTHER}}($val, undef, $conv)))
                        {
                            if (($$tagInfo{PrintHex} or
                                ($$tagInfo{Mask} and not defined $$tagInfo{PrintHex}))
                                and $val and IsInt($val) and $convType eq 'PrintConv')
                            {
                                $val = sprintf('0x%x',$val);
                            }
                            $value = "Unknown ($val)";
                        }
                    }
                } else {
                    # call subroutine or do eval to convert value
                    local $SIG{'__WARN__'} = \&SetWarning;
                    undef $evalWarning;
                    if (ref $conv eq 'CODE') {
                        $value = &$conv($val, $self);
                    } else {
                        #### eval ValueConv/PrintConv ($val, $self, @val, @prt, @raw)
                        $value = eval $conv;
                        $@ and $evalWarning = $@;
                    }
                    $self->Warn("$convType $tag: " . CleanWarning()) if $evalWarning;
                }
            } else {
                $value = $val;
            }
            last unless $vals;
            # save this converted value and step to next value in list
            push @values, $value if defined $value;
            if (++$i >= scalar(@$vals)) {
                $value = \@values if @values;
                last;
            }
            $val = $$vals[$i];
            $conv = $$convList[$i] if $convList;
        }
        # return undefined now if no value
        return wantarray ? () : undef unless defined $value;
        # join back into single value if split for conversion list
        if ($convList and ref $value eq 'ARRAY') {
            $value = join($convType eq 'PrintConv' ? '; ' : ' ', @$value);
        }
    }
    if ($type eq 'Both') {
        # save both (unescaped) values because we often need them again
        # (Composite tags need "Both" and often Require one tag for various Composite tags)
        $self->{BOTH}{$tag} = [ $valueConv, $value ] unless $both;
        # escape values if necessary
        if ($$self{ESCAPE_PROC}) {
            DoEscape($value, $$self{ESCAPE_PROC});
            if (defined $valueConv) {
                DoEscape($valueConv, $$self{ESCAPE_PROC});
            } else {
                $valueConv = $value;
            }
        } elsif (not defined $valueConv) {
            # $valueConv is undefined if there was no print conversion done
            $valueConv = $value;
        }
        # return Both values as a list (ValueConv, PrintConv)
        return ($valueConv, $value);
    }
    # escape value if necessary
    DoEscape($value, $$self{ESCAPE_PROC}) if $$self{ESCAPE_PROC};

    if (ref $value eq 'ARRAY') {
        # return array if requested
        return @$value if wantarray;
        # return list reference for Raw, ValueConv or if List or not a list of scalars
        return $value if $type ne 'PrintConv' or $self->{OPTIONS}{List} or ref $$value[0];
        # otherwise join in comma-separated string
        $value = join $self->{OPTIONS}{ListSep}, @$value;
    }
    return $value;
}

#------------------------------------------------------------------------------
# Get tag identification number
# Inputs: 0) ExifTool object reference, 1) tag key
# Returns: Scalar context: Tag ID if available, otherwise ''
#          List context: 0) Tag ID (or ''), 1) language code (or undef)
sub GetTagID($$)
{
    my ($self, $tag) = @_;
    my $tagInfo = $self->{TAG_INFO}{$tag};
    return '' unless $tagInfo and defined $$tagInfo{TagID};
    return ($$tagInfo{TagID}, $$tagInfo{LangCode}) if wantarray;
    return $$tagInfo{TagID};
}

#------------------------------------------------------------------------------
# Get tag table name
# Inputs: 0) ExifTool object reference, 1) tag key
# Returns: Table name if available, otherwise ''
sub GetTableName($$)
{
    my ($self, $tag) = @_;
    my $tagInfo = $self->{TAG_INFO}{$tag} or return '';
    return $tagInfo->{Table}{SHORT_NAME};
}

#------------------------------------------------------------------------------
# Get tag index number
# Inputs: 0) ExifTool object reference, 1) tag key
# Returns: Table index number, or undefined if this tag isn't indexed
sub GetTagIndex($$)
{
    my ($self, $tag) = @_;
    my $tagInfo = $self->{TAG_INFO}{$tag} or return undef;
    return $$tagInfo{Index};
}

#------------------------------------------------------------------------------
# Get description for specified tag
# Inputs: 0) ExifTool object reference, 1) tag key
# Returns: Tag description
# Notes: Will always return a defined value, even if description isn't available
sub GetDescription($$)
{
    local $_;
    my ($self, $tag) = @_;
    my ($desc, $name);
    my $tagInfo = $self->{TAG_INFO}{$tag};
    # ($tagInfo won't be defined for missing tags extracted with -f)
    if ($tagInfo) {
        # use alternate language description if available
        while ($$self{CUR_LANG}) {
            $desc = $self->{CUR_LANG}{$$tagInfo{Name}};
            if ($desc) {
                # must look up Description if this tag also has a PrintConv
                $desc = $$desc{Description} or last if ref $desc;
            } else {
                # look up default language of lang-alt tag
                last unless $$tagInfo{LangCode} and
                    ($name = $$tagInfo{Name}) =~ s/-$$tagInfo{LangCode}$// and
                    $desc = $self->{CUR_LANG}{$name};
                $desc = $$desc{Description} or last if ref $desc;
                $desc .= " ($$tagInfo{LangCode})";
            }
            # escape description if necessary
            DoEscape($desc, $$self{ESCAPE_PROC}) if $$self{ESCAPE_PROC};
            # return description in proper Charset
            return $self->Decode($desc, 'UTF8');
        }
        $desc = $$tagInfo{Description};
    }
    # just make the tag more readable if description doesn't exist
    unless ($desc) {
        $desc = MakeDescription(GetTagName($tag));
        # save description in tag information
        $$tagInfo{Description} = $desc if $tagInfo;
    }
    return $desc;
}

#------------------------------------------------------------------------------
# Get group name for specified tag
# Inputs: 0) ExifTool object reference
#         1) tag key (or reference to tagInfo hash, not part of the public API)
#         2) [optional] group family (-1 to get extended group list)
# Returns: Scalar context: Group name (for family 0 if not otherwise specified)
#          Array context: Group name if family specified, otherwise list of
#          group names for each family.  Returns '' for undefined tag.
# Notes: Mutiple families may be specified with ':' in family argument (ie. '1:2')
sub GetGroup($$;$)
{
    local $_;
    my ($self, $tag, $family) = @_;
    my ($tagInfo, @groups, @families, $simplify);
    if (ref $tag eq 'HASH') {
        $tagInfo = $tag;
        $tag = $tagInfo->{Name};
    } else {
        $tagInfo = $self->{TAG_INFO}{$tag} or return '';
    }
    my $groups = $$tagInfo{Groups};
    # fill in default groups unless already done
    # (after this, Groups 0-2 in tagInfo are guaranteed to be defined)
    unless ($$tagInfo{GotGroups}) {
        my $tagTablePtr = $$tagInfo{Table};
        if ($tagTablePtr) {
            # construct our group list
            $groups or $groups = $$tagInfo{Groups} = { };
            # fill in default groups
            foreach (keys %{$$tagTablePtr{GROUPS}}) {
                $$groups{$_} or $$groups{$_} = $tagTablePtr->{GROUPS}{$_};
            }
        }
        # set flag indicating group list was built
        $$tagInfo{GotGroups} = 1;
    }
    if (defined $family and $family ne '-1') {
        if ($family =~ /[^\d]/) {
            @families = ($family =~ /\d+/g);
            return $$groups{0} unless @families;
            $simplify = 1 unless $family =~ /^:/;
            undef $family;
            foreach (0..2) { $groups[$_] = $$groups{$_}; }
        } else {
            return $$groups{$family} if $family == 0 or $family == 2;
            $groups[1] = $$groups{1};
        }
    } else {
        return $$groups{0} unless wantarray;
        foreach (0..2) { $groups[$_] = $$groups{$_}; }
    }
    $groups[3] = 'Main';
    $groups[4] = ($tag =~ /\((\d+)\)$/) ? "Copy$1" : '';
    # handle dynamic group names if necessary
    my $ex = $self->{TAG_EXTRA}{$tag};
    if ($ex) {
        $groups[0] = $$ex{G0} if $$ex{G0};
        $groups[1] = $$ex{G1} =~ /^\+(.*)/ ? "$groups[1]$1" : $$ex{G1} if $$ex{G1};
        $groups[3] = 'Doc' . $$ex{G3} if $$ex{G3};
        $groups[5] = $$ex{G5} || $groups[1] if defined $$ex{G5};
    }
    if ($family) {
        return $groups[$family] || '' if $family > 0;
        # add additional matching group names to list
        # ie) for MIE-Doc, also add MIE1, MIE1-Doc, MIE-Doc1 and MIE1-Doc1
        # and for MIE2-Doc3, also add MIE2, MIE-Doc3, MIE2-Doc and MIE-Doc
        if ($groups[1] =~ /^MIE(\d*)-(.+?)(\d*)$/) {
            push @groups, 'MIE' . ($1 || '1');
            push @groups, 'MIE' . ($1 ? '' : '1') . "-$2$3";
            push @groups, "MIE$1-$2" . ($3 ? '' : '1');
            push @groups, 'MIE' . ($1 ? '' : '1') . "-$2" . ($3 ? '' : '1');
        }
    }
    if (@families) {
        my @grps;
        # create list of group names (without identical adjacent groups if simplifying)
        foreach (@families) {
            my $grp = $groups[$_] or next;
            push @grps, $grp unless $simplify and @grps and $grp eq $grps[-1];
        }
        # remove leading "Main:" if simplifying
        shift @grps if $simplify and @grps > 1 and $grps[0] eq 'Main';
        # return colon-separated string of group names
        return join ':', @grps;
    }
    return @groups;
}

#------------------------------------------------------------------------------
# Get group names for specified tags
# Inputs: 0) ExifTool object reference
#         1) [optional] information hash reference (default all extracted info)
#         2) [optional] group family (default 0)
# Returns: List of group names in alphabetical order
sub GetGroups($;$$)
{
    local $_;
    my $self = shift;
    my $info = shift;
    my $family;

    # figure out our arguments
    if (ref $info ne 'HASH') {
        $family = $info;
        $info = $self->{VALUE};
    } else {
        $family = shift;
    }
    $family = 0 unless defined $family;

    # get a list of all groups in specified information
    my ($tag, %groups);
    foreach $tag (keys %$info) {
        $groups{ $self->GetGroup($tag, $family) } = 1;
    }
    return sort keys %groups;
}

#------------------------------------------------------------------------------
# Set priority for group where new values are written
# Inputs: 0) ExifTool object reference,
#         1-N) group names (reset to default if no groups specified)
sub SetNewGroups($;@)
{
    local $_;
    my ($self, @groups) = @_;
    @groups or @groups = @defaultWriteGroups;
    my $count = @groups;
    my %priority;
    foreach (@groups) {
        $priority{lc($_)} = $count--;
    }
    $priority{file} = 10;       # 'File' group is always written (Comment)
    $priority{composite} = 10;  # 'Composite' group is always written
    # set write priority (higher # is higher priority)
    $self->{WRITE_PRIORITY} = \%priority;
    $self->{WRITE_GROUPS} = \@groups;
}

#------------------------------------------------------------------------------
# Build Composite tags from Require'd/Desire'd tags
# Inputs: 0) ExifTool object reference
# Note: Tag values are calculated in alphabetical order unless a tag Require's
#       or Desire's another Composite tag, in which case the calculation is
#       deferred until after the other tag is calculated.
sub BuildCompositeTags($)
{
    local $_;
    my $self = shift;

    $$self{BuildingComposite} = 1;
    # first, add user-defined Composite tags if necessary
    if (%UserDefined and $UserDefined{'Image::ExifTool::Composite'}) {
        AddCompositeTags($UserDefined{'Image::ExifTool::Composite'}, 1);
        delete $UserDefined{'Image::ExifTool::Composite'};
    }
    my @tagList = sort keys %Image::ExifTool::Composite;
    my %tagsUsed;

    my $rawValue = $self->{VALUE};
    for (;;) {
        my %notBuilt;
        $notBuilt{$_} = 1 foreach @tagList;
        my @deferredTags;
        my $tag;
COMPOSITE_TAG:
        foreach $tag (@tagList) {
            next if $specialTags{$tag};
            my $tagInfo = $self->GetTagInfo(\%Image::ExifTool::Composite, $tag);
            next unless $tagInfo;
            # put required tags into array and make sure they all exist
            my $subDoc = ($$tagInfo{SubDoc} and $$self{DOC_COUNT});
            my $require = $$tagInfo{Require} || { };
            my $desire = $$tagInfo{Desire} || { };
            # loop through sub-documents if necessary
            my $doc;
            for (;;) {
                my (%tagKey, $found, $index);
                # save Require'd and Desire'd tag values in list
                for ($index=0; ; ++$index) {
                    my $reqTag = $$require{$index} || $$desire{$index} or last;
                    # add family 3 group if generating Composite tags for sub-documents
                    # (unless tag already begins with family 3 group name)
                    if ($subDoc and $reqTag !~ /^(Main|Doc\d+):/) {
                        $reqTag = ($doc ? "Doc$doc:" : 'Main:') . $reqTag;
                    }
                    # allow tag group to be specified
                    if ($reqTag =~ /(.+):(.+)/) {
                        my ($reqGroup, $name) = ($1, $2);
                        if ($reqGroup eq 'Composite' and $notBuilt{$name}) {
                            push @deferredTags, $tag;
                            next COMPOSITE_TAG;
                        }
                        my ($i, $key, @keys);
                        for ($i=0; ; ++$i) {
                            $key = $name;
                            $key .= " ($i)" if $i;
                            last unless defined $$rawValue{$key};
                            push @keys, $key;
                        }
                        # find first matching tag
                        $key = $self->GroupMatches($reqGroup, \@keys);
                        $reqTag = $key if $key;
                    } elsif ($notBuilt{$reqTag}) {
                        # calculate this tag later if it relies on another
                        # Composite tag which hasn't been calculated yet
                        push @deferredTags, $tag;
                        next COMPOSITE_TAG;
                    }
                    if (defined $$rawValue{$reqTag}) {
                        $found = 1;
                    } elsif ($$require{$index}) {
                        $found = 0;
                        last;   # don't continue since we require this tag
                    }
                    $tagKey{$index} = $reqTag;
                }
                if ($doc) {
                    if ($found) {
                        $self->{DOC_NUM} = $doc;
                        $self->FoundTag($tagInfo, \%tagKey);
                        delete $self->{DOC_NUM};
                    }
                    next if ++$doc <= $self->{DOC_COUNT};
                    last;
                } elsif ($found) {
                    delete $notBuilt{$tag}; # this tag is OK to build now
                    # keep track of all Require'd tag keys
                    foreach (keys %tagKey) {
                        # only tag keys with same name as a Composite tag
                        # can be replaced (also eliminates keys with
                        # instance numbers which can't be replaced either)
                        next unless $Image::ExifTool::Composite{$tagKey{$_}};
                        my $keyRef = \$tagKey{$_};
                        $tagsUsed{$$keyRef} or $tagsUsed{$$keyRef} = [ ];
                        push @{$tagsUsed{$$keyRef}}, $keyRef;
                    }
                    # save reference to tag key lookup as value for Composite tag
                    my $key = $self->FoundTag($tagInfo, \%tagKey);
                    # check to see if we just replaced one of the tag keys we Require'd
                    if (defined $key and $tagsUsed{$key}) {
                        foreach (@{$tagsUsed{$key}}) {
                            $$_ = $self->{MOVED_KEY};   # replace with new tag key
                        }
                        delete $tagsUsed{$key};         # can't be replaced again
                    }
                } elsif (not defined $found) {
                    delete $notBuilt{$tag}; # tag can't be built anyway
                }
                last unless $subDoc;
                $doc = 1;   # continue to process the 1st sub-document
            }
        }
        last unless @deferredTags;
        if (@deferredTags == @tagList) {
            # everything was deferred in the last pass,
            # must be a circular dependency
            warn "Circular dependency in Composite tags\n";
            last;
        }
        @tagList = @deferredTags; # calculate deferred tags now
    }
    delete $$self{BuildingComposite};
}

#------------------------------------------------------------------------------
# Get tag name (removes copy index)
# Inputs: 0) Tag key
# Returns: Tag name
sub GetTagName($)
{
    local $_;
    $_[0] =~ /^(\S+)/;
    return $1;
}

#------------------------------------------------------------------------------
# Get list of shortcuts
# Returns: Shortcut list (sorted alphabetically)
sub GetShortcuts()
{
    local $_;
    require Image::ExifTool::Shortcuts;
    return sort keys %Image::ExifTool::Shortcuts::Main;
}

#------------------------------------------------------------------------------
# Get file type for specified extension
# Inputs: 0) file name or extension (case is not significant),
#            or FileType value if a description is requested
#         1) flag to return long description instead of type
# Returns: File type (or desc) or undef if extension not supported or if
#          description is the same as the input FileType.  In array
#          context, may return more than one file type if the file may be
#          different formats.  Returns list of all recognized extensions if no
#          file specified
sub GetFileType(;$$)
{
    local $_;
    my ($file, $desc) = @_;
    return sort keys %fileTypeLookup unless defined $file;
    my $fileType;
    my $fileExt = GetFileExtension($file);
    $fileExt = uc($file) unless $fileExt;
    $fileExt and $fileType = $fileTypeLookup{$fileExt}; # look up the file type
    $fileType = $fileTypeLookup{$fileType} unless ref $fileType or not $fileType;
    # return description if specified
    # (allow input $file to be a FileType for this purpose)
    $desc and return $fileType ? $$fileType[1] : $fileDescription{$file};
    $fileType or return wantarray ? () : undef;
    $fileType = $$fileType[0];      # get file type (or list of types)
    if (wantarray) {
        return @$fileType if ref $fileType eq 'ARRAY';
    } elsif ($fileType) {
        $fileType = $fileExt if ref $fileType eq 'ARRAY';
    }
    return $fileType;
}

#------------------------------------------------------------------------------
# Return true if we can write the specified file type
# Inputs: 0) file name or ext
# Returns: true if writable, 0 if not writable, undef if unrecognized
sub CanWrite($)
{
    local $_;
    my $file = shift or return undef;
    my $type = GetFileType($file) or return undef;
    if ($noWriteFile{$type}) {
        # can't write TIFF files with certain extensions (various RAW formats)
        my $ext = GetFileExtension($file) || uc($file);
        return grep(/^$ext$/, @{$noWriteFile{$type}}) ? 0 : 1 if $ext;
    }
    return scalar(grep /^$type$/, @writeTypes);
}

#------------------------------------------------------------------------------
# Return true if we can create the specified file type
# Inputs: 0) file name or ext
# Returns: true if creatable, 0 if not writable, undef if unrecognized
sub CanCreate($)
{
    local $_;
    my $file = shift or return undef;
    my $ext = GetFileExtension($file) || uc($file);
    my $type = GetFileType($file) or return undef;
    return 1 if $createTypes{$ext} or $createTypes{$type};
    return 0;
}

#==============================================================================
# Functions below this are not part of the public API

# Initialize member variables
# Inputs: 0) ExifTool object reference
sub Init($)
{
    local $_;
    my $self = shift;
    # delete all DataMember variables (lower-case names)
    foreach (keys %$self) {
        /[a-z]/ and delete $self->{$_};
    }
    delete $self->{FOUND_TAGS};     # list of found tags
    delete $self->{EXIF_DATA};      # the EXIF data block
    delete $self->{EXIF_POS};       # EXIF position in file
    delete $self->{FIRST_EXIF_POS}; # position of first EXIF in file
    delete $self->{HTML_DUMP};      # html dump information
    delete $self->{SET_GROUP1};     # group1 name override
    delete $self->{DOC_NUM};        # current embedded document number
    $self->{DOC_COUNT}  = 0;        # count of embedded documents processed
    $self->{BASE}       = 0;        # base for offsets from start of file
    $self->{FILE_ORDER} = { };      # hash of tag order in file
    $self->{VALUE}      = { };      # hash of raw tag values
    $self->{BOTH}       = { };      # hash for Value/PrintConv values of Require'd tags
    $self->{TAG_INFO}   = { };      # hash of tag information
    $self->{TAG_EXTRA}  = { };      # hash of extra tag information (dynamic group names)
    $self->{PRIORITY}   = { };      # priority of current tags
    $self->{LIST_TAGS}  = { };      # hash of tagInfo refs for active List-type tags
    $self->{PROCESSED}  = { };      # hash of processed directory start positions
    $self->{DIR_COUNT}  = { };      # count various types of directories
    $self->{DUPL_TAG}   = { };      # last-used index for duplicate-tag keys
    $self->{WARNED_ONCE}= { };      # WarnOnce() warnings already issued
    $self->{PATH}       = [ ];      # current subdirectory path in file when reading
    $self->{NUM_FOUND}  = 0;        # total number of tags found (incl. duplicates)
    $self->{CHANGED}    = 0;        # number of tags changed (writer only)
    $self->{INDENT}     = '  ';     # initial indent for verbose messages
    $self->{PRIORITY_DIR} = '';     # the priority directory name
    $self->{LOW_PRIORITY_DIR} = { PreviewIFD => 1 }; # names of priority 0 directories
    $self->{TIFF_TYPE}  = '';       # type of TIFF data (APP1, TIFF, NEF, etc...)
    $self->{Make}       = '';       # camera make
    $self->{Model}      = '';       # camera model
    $self->{CameraType} = '';       # Olympus camera type
    if ($self->Options('HtmlDump')) {
        require Image::ExifTool::HtmlDump;
        $self->{HTML_DUMP} = new Image::ExifTool::HtmlDump;
    }
    # make sure our TextOut is a file reference
    $self->{OPTIONS}{TextOut} = \*STDOUT unless ref $self->{OPTIONS}{TextOut};
}

#------------------------------------------------------------------------------
# Parse function arguments and set member variables accordingly
# Inputs: Same as ImageInfo()
# - sets REQUESTED_TAGS, REQ_TAG_LOOKUP, IO_TAG_LIST, FILENAME, RAF, OPTIONS
sub ParseArguments($;@)
{
    my $self = shift;
    my $options = $self->{OPTIONS};
    my @exclude;
    my @oldGroupOpts = grep /^Group/, keys %{$self->{OPTIONS}};
    my $wasExcludeOpt;

    $self->{REQUESTED_TAGS} = [ ];
    $self->{REQ_TAG_LOOKUP} = { };
    $self->{IO_TAG_LIST} = undef;

    # handle our input arguments
    while (@_) {
        my $arg = shift;
        if (ref $arg) {
            if (ref $arg eq 'ARRAY') {
                $self->{IO_TAG_LIST} = $arg;
                foreach (@$arg) {
                    if (/^-(.*)/) {
                        push @exclude, $1;
                    } else {
                        push @{$self->{REQUESTED_TAGS}}, $_;
                    }
                }
            } elsif (ref $arg eq 'HASH') {
                my $opt;
                foreach $opt (keys %$arg) {
                    # a single new group option overrides all old group options
                    if (@oldGroupOpts and $opt =~ /^Group/) {
                        foreach (@oldGroupOpts) {
                            delete $options->{$_};
                        }
                        undef @oldGroupOpts;
                    }
                    $self->Options($opt, $$arg{$opt});
                    $opt eq 'Exclude' and $wasExcludeOpt = 1;
                }
            } elsif (ref $arg eq 'SCALAR' or UNIVERSAL::isa($arg,'GLOB')) {
                next if defined $self->{RAF};
                # convert image data from UTF-8 to character stream if necessary
                # (patches RHEL 3 UTF8 LANG problem)
                if (ref $arg eq 'SCALAR' and $] >= 5.006 and
                    (eval 'require Encode; Encode::is_utf8($$arg)' or $@))
                {
                    # repack by hand if Encode isn't available
                    my $buff = $@ ? pack('C*',unpack('U0C*',$$arg)) : Encode::encode('utf8',$$arg);
                    $arg = \$buff;
                }
                $self->{RAF} = new File::RandomAccess($arg);
                # set filename to empty string to indicate that
                # we have a file but we didn't open it
                $self->{FILENAME} = '';
            } elsif (UNIVERSAL::isa($arg, 'File::RandomAccess')) {
                $self->{RAF} = $arg;
                $self->{FILENAME} = '';
            } else {
                warn "Don't understand ImageInfo argument $arg\n";
            }
        } elsif (defined $self->{FILENAME}) {
            if ($arg =~ /^-(.*)/) {
                push @exclude, $1;
            } else {
                push @{$self->{REQUESTED_TAGS}}, $arg;
            }
        } else {
            $self->{FILENAME} = $arg;
        }
    }
    # expand shortcuts in tag arguments if provided
    if (@{$self->{REQUESTED_TAGS}}) {
        ExpandShortcuts($self->{REQUESTED_TAGS});
        # initialize lookup for requested tags
        foreach (@{$self->{REQUESTED_TAGS}}) {
            $self->{REQ_TAG_LOOKUP}{lc(/.+:(.+)/ ? $1 : $_)} = 1;
        }
    }

    if (@exclude or $wasExcludeOpt) {
        # must add existing excluded tags
        if ($options->{Exclude}) {
            if (ref $options->{Exclude} eq 'ARRAY') {
                push @exclude, @{$options->{Exclude}};
            } else {
                push @exclude, $options->{Exclude};
            }
        }
        $options->{Exclude} = \@exclude;
        # expand shortcuts in new exclude list
        ExpandShortcuts($options->{Exclude}, 1); # (also remove '#' suffix)
    }
}

#------------------------------------------------------------------------------
# Get list of tags in specified group
# Inputs: 0) ExifTool ref, 1) group spec, 2) tag key or reference to list of tag keys
# Returns: list of matching tags in list context, or first match in scalar context
# Notes: Group spec may contain multiple groups separated by colons, each
#        possibly with a leading family number
sub GroupMatches($$$)
{
    my ($self, $group, $tagList) = @_;
    $tagList = [ $tagList ] unless ref $tagList;
    my ($tag, @matches);
    if ($group =~ /:/) {
        # check each group name individually (ie. "Author:1IPTC")
        my @grps = split ':', lc $group;
        my (@fmys, $g);
        for ($g=0; $g<@grps; ++$g) {
            $fmys[$g] = $1 if $grps[$g] =~ s/^(\d+)//;
        }
        foreach $tag (@$tagList) {
            my @groups = $self->GetGroup($tag, -1);
            for ($g=0; $g<@grps; ++$g) {
                my $grp = $grps[$g];
                next if $grp eq '*' or $grp eq 'all';
                if (defined $fmys[$g]) {
                    my $f = $fmys[$g];
                    last unless $groups[$f] and $grps[$g] eq lc $groups[$f];
                } else {
                    last unless grep /^$grps[$g]$/i, @groups;
                }
            }
            push @matches, $tag if $g == @grps;
        }
    } else {
        my $family = ($group =~ s/^(\d+)//) ? $1 : -1;
        foreach $tag (@$tagList) {
            my @groups = $self->GetGroup($tag, $family);
            push @matches, $tag if grep(/^$group$/i, @groups);
        }
    }
    return wantarray ? @matches : $matches[0];
}

#------------------------------------------------------------------------------
# Set list of found tags from previously requested tags
# Inputs: 0) ExifTool object reference
# Returns: 0) Reference to list of found tag keys (in order of requested tags)
#          1) Reference to list of indices for tags requested by value
sub SetFoundTags($)
{
    my $self = shift;
    my $options = $self->{OPTIONS};
    my $reqTags = $self->{REQUESTED_TAGS} || [ ];
    my $duplicates = $options->{Duplicates};
    my $exclude = $options->{Exclude};
    my $fileOrder = $self->{FILE_ORDER};
    my @groupOptions = sort grep /^Group/, keys %$options;
    my $doDups = $duplicates || $exclude || @groupOptions;
    my ($tag, $rtnTags, @byValue);

    # only return requested tags if specified
    if (@$reqTags) {
        $rtnTags or $rtnTags = [ ];
        # scan through the requested tags and generate a list of tags we found
        my $tagHash = $self->{VALUE};
        my $reqTag;
        foreach $reqTag (@$reqTags) {
            my (@matches, $group, $allGrp, $allTag, $byValue);
            if ($reqTag =~ /^(.+):(.+)/) {
                ($group, $tag) = ($1, $2);
                if ($group =~ /^(\*|all)$/i) {
                    $allGrp = 1;
                } elsif ($group !~ /^[-\w:]+$/) {
                    $self->Warn("Invalid group name '$group'");
                    $group = 'invalid';
                }
            } else {
                $tag = $reqTag;
            }
            $byValue = 1 if $tag =~ s/#$//;
            if (defined $tagHash->{$reqTag} and not $doDups) {
                $matches[0] = $tag;
            } elsif ($tag =~ /^(\*|all)$/i) {
                # tag name of '*' or 'all' matches all tags
                if ($doDups or $allGrp) {
                    @matches = keys %$tagHash;
                } else {
                    @matches = grep(!/ /, keys %$tagHash);
                }
                next unless @matches;   # don't want entry in list for '*' tag
                $allTag = 1;
            } elsif ($tag =~ /[*?]/) {
                # allow wildcards in tag names
                $tag =~ s/\*/[-\\w]*/g;
                $tag =~ s/\?/[-\\w]/g;
                $tag .= '( .*)?' if $doDups or $allGrp;
                @matches = grep(/^$tag$/i, keys %$tagHash);
                next unless @matches;   # don't want entry in list for wildcard tags
                $allTag = 1;
            } elsif ($doDups or defined $group) {
                # must also look for tags like "Tag (1)"
                @matches = grep(/^$tag( |$)/i, keys %$tagHash);
            } elsif ($tag =~ /^[-\w]+$/) {
                # find first matching value
                # (use in list context to return value instead of count)
                ($matches[0]) = grep /^$tag$/i, keys %$tagHash;
                defined $matches[0] or undef @matches;
            } else {
                $self->Warn("Invalid tag name '$tag'");
            }
            if (defined $group and not $allGrp) {
                # keep only specified group
                @matches = $self->GroupMatches($group, \@matches);
                next unless @matches or not $allTag;
            }
            if (@matches > 1) {
                # maintain original file order for multiple tags
                @matches = sort { $$fileOrder{$a} <=> $$fileOrder{$b} } @matches;
                # return only the highest priority tag unless duplicates wanted
                unless ($doDups or $allTag or $allGrp) {
                    $tag = shift @matches;
                    my $oldPriority = $self->{PRIORITY}{$tag} || 1;
                    foreach (@matches) {
                        my $priority = $self->{PRIORITY}{$_};
                        $priority = 1 unless defined $priority;
                        next unless $priority >= $oldPriority;
                        $tag = $_;
                        $oldPriority = $priority || 1;
                    }
                    @matches = ( $tag );
                }
            } elsif (not @matches) {
                # put entry in return list even without value (value is undef)
                $matches[0] = "$tag (0)";
                # bogus file order entry to avoid warning if sorting in file order
                $self->{FILE_ORDER}{$matches[0]} = 999;
            }
            # save indices of tags extracted by value
            push @byValue, scalar(@$rtnTags) .. (scalar(@$rtnTags)+scalar(@matches)-1) if $byValue;
            push @$rtnTags, @matches;
        }
    } else {
        # no requested tags, so we want all tags
        my @allTags;
        if ($doDups) {
            @allTags = keys %{$self->{VALUE}};
        } else {
            foreach (keys %{$self->{VALUE}}) {
                # only include tag if it doesn't end in a copy number
                push @allTags, $_ unless / /;
            }
        }
        $rtnTags = \@allTags;
    }

    # filter excluded tags and group options
    while (($exclude or @groupOptions) and @$rtnTags) {
        if ($exclude) {
            my ($pat, %exclude);
            foreach $pat (@$exclude) {
                my $group;
                if ($pat =~ /^(.+):(.+)/) {
                    ($group, $tag) = ($1, $2);
                    if ($group =~ /^(\*|all)$/i) {
                        undef $group;
                    } elsif ($group !~ /^[-\w:]+$/) {
                        $self->Warn("Invalid group name '$group'");
                        $group = 'invalid';
                    }
                } else {
                    $tag = $pat;
                }
                my @matches;
                if ($tag =~ /^(\*|all)$/i) {
                    @matches = @$rtnTags;
                } else {
                    # allow wildcards in tag names
                    $tag =~ s/\*/[-\\w]*/g;
                    $tag =~ s/\?/[-\\w]/g;
                    @matches = grep(/^$tag( |$)/i, @$rtnTags);
                }
                @matches = $self->GroupMatches($group, \@matches) if $group and @matches;
                $exclude{$_} = 1 foreach @matches;
            }
            if (%exclude) {
                my @filteredTags;
                $exclude{$_} or push @filteredTags, $_ foreach @$rtnTags;
                $rtnTags = \@filteredTags;      # use new filtered tag list
                last unless @filteredTags;      # all done if nothing left
            }
            last if $duplicates and not @groupOptions;
        }
        # filter groups if requested, or to remove duplicates
        my (%keepTags, %wantGroup, $family, $groupOpt);
        my $allGroups = 1;
        # build hash of requested/excluded group names for each group family
        my $wantOrder = 0;
        foreach $groupOpt (@groupOptions) {
            $groupOpt =~ /^Group(\d*(:\d+)*)/ or next;
            $family = $1 || 0;
            $wantGroup{$family} or $wantGroup{$family} = { };
            my $groupList;
            if (ref $options->{$groupOpt} eq 'ARRAY') {
                $groupList = $options->{$groupOpt};
            } else {
                $groupList = [ $options->{$groupOpt} ];
            }
            foreach (@$groupList) {
                # groups have priority in order they were specified
                ++$wantOrder;
                my ($groupName, $want);
                if (/^-(.*)/) {
                    # excluded group begins with '-'
                    $groupName = $1;
                    $want = 0;          # we don't want tags in this group
                } else {
                    $groupName = $_;
                    $want = $wantOrder; # we want tags in this group
                    $allGroups = 0;     # don't want all groups if we requested one
                }
                $wantGroup{$family}{$groupName} = $want;
            }
        }
        # loop through all tags and decide which ones we want
        my (@tags, %bestTag);
GR_TAG: foreach $tag (@$rtnTags) {
            my $wantTag = $allGroups;   # want tag by default if want all groups
            foreach $family (keys %wantGroup) {
                my $group = $self->GetGroup($tag, $family);
                my $wanted = $wantGroup{$family}{$group};
                next unless defined $wanted;
                next GR_TAG unless $wanted;     # skip tag if group excluded
                # take lowest non-zero want flag
                next if $wantTag and $wantTag < $wanted;
                $wantTag = $wanted;
            }
            next unless $wantTag;
            if ($duplicates) {
                push @tags, $tag;
            } else {
                my $tagName = GetTagName($tag);
                my $bestTag = $bestTag{$tagName};
                if (defined $bestTag) {
                    next if $wantTag > $keepTags{$bestTag};
                    if ($wantTag == $keepTags{$bestTag}) {
                        # want two tags with the same name -- keep the latest one
                        if ($tag =~ / \((\d+)\)$/) {
                            my $tagNum = $1;
                            next if $bestTag !~ / \((\d+)\)$/ or $1 > $tagNum;
                        }
                    }
                    # this tag is better, so delete old best tag
                    delete $keepTags{$bestTag};
                }
                $keepTags{$tag} = $wantTag;    # keep this tag (for now...)
                $bestTag{$tagName} = $tag;      # this is our current best tag
            }
        }
        unless ($duplicates) {
            # construct new tag list with no duplicates, preserving order
            foreach $tag (@$rtnTags) {
                push @tags, $tag if $keepTags{$tag};
            }
        }
        $rtnTags = \@tags;
        last;
    }
    $self->{FOUND_TAGS} = $rtnTags;     # save found tags 

    # return reference to found tag keys (and list of indices of tags to extract by value)
    return wantarray ? ($rtnTags, \@byValue) : $rtnTags;
}

#------------------------------------------------------------------------------
# Utility to load our write routines if required (called via AUTOLOAD)
# Inputs: 0) autoload function, 1-N) function arguments
# Returns: result of function or dies if function not available
# To Do: Generalize this routine so it works on systems that don't use '/'
#        as a path name separator.
sub DoAutoLoad(@)
{
    my $autoload = shift;
    my @callInfo = split(/::/, $autoload);
    my $file = 'Image/ExifTool/Write';

    return if $callInfo[$#callInfo] eq 'DESTROY';
    if (@callInfo == 4) {
        # load Image/ExifTool/WriteMODULE.pl
        $file .= "$callInfo[2].pl";
    } else {
        # load Image/ExifTool/Writer.pl
        $file .= 'r.pl';
    }
    # attempt to load the package
    eval "require '$file'" or die "Error while attempting to call $autoload\n$@\n";
    unless (defined &$autoload) {
        my @caller = caller(0);
        # reproduce Perl's standard 'undefined subroutine' message:
        die "Undefined subroutine $autoload called at $caller[1] line $caller[2]\n";
    }
    no strict 'refs';
    return &$autoload(@_);     # call the function
}

#------------------------------------------------------------------------------
# AutoLoad our writer routines when necessary
#
sub AUTOLOAD
{
    return DoAutoLoad($AUTOLOAD, @_);
}

#------------------------------------------------------------------------------
# Add warning tag
# Inputs: 0) ExifTool object reference, 1) warning message, 2) true if minor
# Returns: true if warning tag was added
sub Warn($$;$)
{
    my ($self, $str, $ignorable) = @_;
    if ($ignorable) {
        return 0 if $self->{OPTIONS}{IgnoreMinorErrors};
        $str = "[minor] $str";
    }
    $self->FoundTag('Warning', $str);
    return 1;
}

#------------------------------------------------------------------------------
# Add warning tag only once per processed file
# Inputs: 0) ExifTool object reference, 1) warning message, 2) true if minor
# Returns: true if warning tag was added
sub WarnOnce($$;$)
{
    my ($self, $str, $ignorable) = @_;
    return 0 if $ignorable and $self->{OPTIONS}{IgnoreMinorErrors};
    unless ($$self{WARNED_ONCE}{$str}) {
        $self->Warn($str, $ignorable);
        $$self{WARNED_ONCE}{$str} = 1;
    }
    return 1;
}

#------------------------------------------------------------------------------
# Add error tag
# Inputs: 0) ExifTool object reference, 1) error message, 2) true if minor
# Returns: true if error tag was added, otherwise warning was added
sub Error($$;$)
{
    my ($self, $str, $ignorable) = @_;
    if ($ignorable) {
        if ($self->{OPTIONS}{IgnoreMinorErrors}) {
            $self->Warn($str);
            return 0;
        }
        $str = "[minor] $str";
    }
    $self->FoundTag('Error', $str);
    return 1;
}

#------------------------------------------------------------------------------
# Expand shortcuts
# Inputs: 0) reference to list of tags, 1) set to remove trailing '#'
# Notes: Handles leading '-' for excluded tags, trailing '#' for ValueConv,
#        multiple group names, and redirected tags
sub ExpandShortcuts($;$)
{
    my ($tagList, $removeSuffix) = @_;
    return unless $tagList and @$tagList;

    require Image::ExifTool::Shortcuts;

    # expand shortcuts
    my $suffix = $removeSuffix ? '' : '#';
    my @expandedTags;
    my ($entry, $tag, $excl);
    foreach $entry (@$tagList) {
        # skip things like options hash references in list
        if (ref $entry) {
            push @expandedTags, $entry;
            next;
        }
        # remove leading '-'
        ($excl, $tag) = $entry =~ /^(-?)(.*)/s;
        my ($post, @post, $pre, $v);
        # handle redirection
        if (not $excl and $tag =~ /(.+?)([-+]?[<>].+)/s) {
            ($tag, $post) = ($1, $2);
            if ($post =~ /^[-+]?>/ or $post !~ /\$/) {
                # expand shortcuts in postfix (rhs of redirection)
                my ($op, $p2, $t2) = ($post =~ /([-+]?[<>])(.+:)?(.+)/);
                $p2 = '' unless defined $p2;
                $v = ($t2 =~ s/#$//) ? $suffix : ''; # ValueConv suffix
                my ($match) = grep /^\Q$t2\E$/i, keys %Image::ExifTool::Shortcuts::Main;
                if ($match) {
                    foreach (@{$Image::ExifTool::Shortcuts::Main{$match}}) {
                        /^-/ and next;  # ignore excluded tags
                        if ($p2 and /(.+:)(.+)/) {
                            push @post, "$op$_$v";
                        } else {
                            push @post, "$op$p2$_$v";
                        }
                    }
                    next unless @post;
                    $post = shift @post;
                }
            }
        } else {
            $post = '';
        }
        # handle group names
        if ($tag =~ /(.+:)(.+)/) {
            ($pre, $tag) = ($1, $2);
        } else {
            $pre = '';
        }
        $v = ($tag =~ s/#$//) ? $suffix : '';   # ValueConv suffix
        # loop over all postfixes
        for (;;) {
            # expand the tag name
            my ($match) = grep /^\Q$tag\E$/i, keys %Image::ExifTool::Shortcuts::Main;
            if ($match) {
                if ($excl) {
                    # entry starts with '-', so exclude all tags in this shortcut
                    foreach (@{$Image::ExifTool::Shortcuts::Main{$match}}) {
                        /^-/ and next;  # ignore excluded exclude tags
                        # group of expanded tag takes precedence
                        if ($pre and /(.+:)(.+)/) {
                            push @expandedTags, "$excl$_";
                        } else {
                            push @expandedTags, "$excl$pre$_";
                        }
                    }
                } elsif (length $pre or length $post or $v) {
                    foreach (@{$Image::ExifTool::Shortcuts::Main{$match}}) {
                        /(-?)(.+:)?(.+)/;
                        if ($2) {
                            # group from expanded tag takes precedence
                            push @expandedTags, "$_$v$post";
                        } else {
                            push @expandedTags, "$1$pre$3$v$post";
                        }
                    }
                } else {
                    push @expandedTags, @{$Image::ExifTool::Shortcuts::Main{$match}};
                }
            } else {
                push @expandedTags, "$excl$pre$tag$v$post";
            }
            last unless @post;
            $post = shift @post;
        }
    }
    @$tagList = @expandedTags;
}

#------------------------------------------------------------------------------
# Add hash of Composite tags to our composites
# Inputs: 0) hash reference to table of Composite tags to add or module name,
#         1) overwrite existing tag
sub AddCompositeTags($;$)
{
    local $_;
    my ($add, $overwrite) = @_;
    my $module;
    unless (ref $add) {
        $module = $add;
        $add .= '::Composite';
        no strict 'refs';
        $add = \%$add;
    }
    my $defaultGroups = $$add{GROUPS};

    # make sure default groups are defined in families 0 and 1
    if ($defaultGroups) {
        $defaultGroups->{0} or $defaultGroups->{0} = 'Composite';
        $defaultGroups->{1} or $defaultGroups->{1} = 'Composite';
        $defaultGroups->{2} or $defaultGroups->{2} = 'Other';
    } else {
        $defaultGroups = $$add{GROUPS} = { 0 => 'Composite', 1 => 'Composite', 2 => 'Other' };
    }
    SetupTagTable($add);    # generate tag Name, etc
    my $tagID;
    foreach $tagID (sort keys %$add) {
        next if $specialTags{$tagID};   # must skip special tags
        my $tagInfo = $$add{$tagID};
        # tagID's MUST be the exact tag name for logic in BuildCompositeTags()
        my $tag = $$tagInfo{Name};
        $$tagInfo{Module} = $module if $$tagInfo{Writable};
        # allow Composite tags with the same name
        my ($t, $n, $type);
        while ($Image::ExifTool::Composite{$tag} and not $overwrite) {
            $n ? $n += 1 : ($n = 2, $t = $tag);
            $tag = "${t}_$n";
            $$tagInfo{NewTagID} = $tag; # save new ID so we can use it in TagLookup
        }
        # convert scalar Require/Desire entries
        foreach $type ('Require','Desire') {
            my $req = $$tagInfo{$type} or next;
            $$tagInfo{$type} = { 0 => $req } if ref($req) ne 'HASH';
        }
        # add this Composite tag to our main Composite table
        $$tagInfo{Table} = \%Image::ExifTool::Composite;
        # (use the original TagID, even if we changed it)
        # $$tagInfo{TagID} = $tag;
        # save new tag ID so we can find entry in Composite table
        $Image::ExifTool::Composite{$tag} = $tagInfo;
        # set all default groups in tag
        my $groups = $$tagInfo{Groups};
        $groups or $groups = $$tagInfo{Groups} = { };
        # fill in default groups
        foreach (keys %$defaultGroups) {
            $$groups{$_} or $$groups{$_} = $$defaultGroups{$_};
        }
        # set flag indicating group list was built
        $$tagInfo{GotGroups} = 1;
    }
}

#------------------------------------------------------------------------------
# Add tags to TagLookup (used for writing)
# Inputs: 0) source hash of tag definitions, 1) name of destination tag table
sub AddTagsToLookup($$)
{
    my ($tagHash, $table) = @_;
    if (defined &Image::ExifTool::TagLookup::AddTags) {
        Image::ExifTool::TagLookup::AddTags($tagHash, $table);
    } elsif (not $Image::ExifTool::pluginTags{$tagHash}) {
        # queue these tags until TagLookup is loaded
        push @Image::ExifTool::pluginTags, [ $tagHash, $table ];
        # set flag so we don't load same tags twice
        $Image::ExifTool::pluginTags{$tagHash} = 1;
    }
}

#------------------------------------------------------------------------------
# Expand tagInfo Flags
# Inputs: 0) tagInfo hash ref
# Notes: $$tagInfo{Flags} must be defined to call this routine
sub ExpandFlags($)
{
    my $tagInfo = shift;
    my $flags = $$tagInfo{Flags};
    if (ref $flags eq 'ARRAY') {
        foreach (@$flags) {
            $$tagInfo{$_} = 1;
        }
    } elsif (ref $flags eq 'HASH') {
        my $key;
        foreach $key (keys %$flags) {
            $$tagInfo{$key} = $$flags{$key};
        }
    } else {
        $$tagInfo{$flags} = 1;
    }
}

#------------------------------------------------------------------------------
# Set up tag table (must be done once for each tag table used)
# Inputs: 0) Reference to tag table
# Notes: - generates 'Name' field from key if it doesn't exist
#        - stores 'Table' pointer and 'TagID' value
#        - expands 'Flags' for quick lookup
sub SetupTagTable($)
{
    my $tagTablePtr = shift;
    my ($tagID, $tagInfo);
    foreach $tagID (TagTableKeys($tagTablePtr)) {
        my @infoArray = GetTagInfoList($tagTablePtr,$tagID);
        # process conditional tagInfo arrays
        foreach $tagInfo (@infoArray) {
            $$tagInfo{Table} = $tagTablePtr;
            $$tagInfo{TagID} = $tagID;
            my $tag = $$tagInfo{Name};
            unless (defined $tag) {
                # generate name equal to tag ID if 'Name' doesn't exist
                $tag = $tagID;
                $$tagInfo{Name} = ucfirst($tag); # make first char uppercase
            }
            $$tagInfo{Flags} and ExpandFlags($tagInfo);
        }
        next unless @infoArray > 1;
        # add an "Index" member to each tagInfo in a list
        my $index = 0;
        foreach $tagInfo (@infoArray) {
            $$tagInfo{Index} = $index++;
        }
    }
}

#------------------------------------------------------------------------------
# Utilities to check for numerical types
# Inputs: 0) value;  Returns: true if value is a numerical type
# Notes: May change commas to decimals in floats for use in other locales
sub IsFloat($) {
    return 1 if $_[0] =~ /^[+-]?(?=\d|\.\d)\d*(\.\d*)?([Ee]([+-]?\d+))?$/;
    # allow comma separators (for other locales)
    return 0 unless $_[0] =~ /^[+-]?(?=\d|,\d)\d*(,\d*)?([Ee]([+-]?\d+))?$/;
    $_[0] =~ tr/,/./;   # but translate ',' to '.'
    return 1;
}
sub IsInt($)      { return scalar($_[0] =~ /^[+-]?\d+$/); }
sub IsHex($)      { return scalar($_[0] =~ /^(0x)?[0-9a-f]{1,8}$/i); }
sub IsRational($) { return scalar($_[0] =~ m{^[-+]?\d+/\d+$}); }

# round floating point value to specified number of significant digits
# Inputs: 0) value, 1) number of sig digits;  Returns: rounded number
sub RoundFloat($$)
{
    my ($val, $sig) = @_;
    $val == 0 and return 0;
    my $sign = $val < 0 ? ($val=-$val, -1) : 1;
    my $log = log($val) / log(10);
    my $exp = int($log) - $sig + ($log > 0 ? 1 : 0);
    return $sign * int(10 ** ($log - $exp) + 0.5) * 10 ** $exp;
}

# Convert strings to floating point numbers (or undef)
# Inputs: 0-N) list of strings (may be undef)
# Returns: last value converted
sub ToFloat(@)
{
    local $_;
    foreach (@_) {
        next unless defined $_;
        # (add 0 to convert "0.0" to "0" for tests)
        $_ = /((?:[+-]?)(?=\d|\.\d)\d*(?:\.\d*)?(?:[Ee](?:[+-]?\d+))?)/ ? $1 + 0 : undef;
    }
    return $_[-1];
}

#------------------------------------------------------------------------------
# Utility routines to for reading binary data values from file

my %unpackMotorola = ( S => 'n', L => 'N', C => 'C', c => 'c' );
my %unpackIntel    = ( S => 'v', L => 'V', C => 'C', c => 'c' );
my %unpackRev = ( N => 'V', V => 'N', C => 'C', n => 'v', v => 'n', c => 'c' );

# the following 4 variables are defined in 'use vars' instead of using 'my'
# because mod_perl 5.6.1 apparently has a problem with setting file-scope 'my'
# variables from within subroutines (ref communication with Pavel Merdin):
# $swapBytes - set if EXIF header is not native byte ordering
# $swapWords - swap 32-bit words in doubles (ARM quirk)
$currentByteOrder = 'MM'; # current byte ordering ('II' or 'MM')
%unpackStd = %unpackMotorola;

# Swap bytes in data if necessary
# Inputs: 0) data, 1) number of bytes
# Returns: swapped data
sub SwapBytes($$)
{
    return $_[0] unless $swapBytes;
    my ($val, $bytes) = @_;
    my $newVal = '';
    $newVal .= substr($val, $bytes, 1) while $bytes--;
    return $newVal;
}
# Swap words.  Inputs: 8 bytes of data, Returns: swapped data
sub SwapWords($)
{
    return $_[0] unless $swapWords and length($_[0]) == 8;
    return substr($_[0],4,4) . substr($_[0],0,4)
}

# Unpack value, letting unpack() handle byte swapping
# Inputs: 0) unpack template, 1) data reference, 2) offset
# Returns: unpacked number
# - uses value of %unpackStd to determine the unpack template
# - can only be called for 'S' or 'L' templates since these are the only
#   templates for which you can specify the byte ordering.
sub DoUnpackStd(@)
{
    $_[2] and return unpack("x$_[2] $unpackStd{$_[0]}", ${$_[1]});
    return unpack($unpackStd{$_[0]}, ${$_[1]});
}
# same, but with reversed byte order
sub DoUnpackRev(@)
{
    my $fmt = $unpackRev{$unpackStd{$_[0]}};
    $_[2] and return unpack("x$_[2] $fmt", ${$_[1]});
    return unpack($fmt, ${$_[1]});
}
# Pack value
# Inputs: 0) template, 1) value, 2) data ref (or undef), 3) offset (if data ref)
# Returns: packed value
sub DoPackStd(@)
{
    my $val = pack($unpackStd{$_[0]}, $_[1]);
    $_[2] and substr(${$_[2]}, $_[3], length($val)) = $val;
    return $val;
}
# same, but with reversed byte order
sub DoPackRev(@)
{
    my $val = pack($unpackRev{$unpackStd{$_[0]}}, $_[1]);
    $_[2] and substr(${$_[2]}, $_[3], length($val)) = $val;
    return $val;
}

# Unpack value, handling the byte swapping manually
# Inputs: 0) # bytes, 1) unpack template, 2) data reference, 3) offset
# Returns: unpacked number
# - uses value of $swapBytes to determine byte ordering
sub DoUnpack(@)
{
    my ($bytes, $template, $dataPt, $pos) = @_;
    my $val;
    if ($swapBytes) {
        $val = '';
        $val .= substr($$dataPt,$pos+$bytes,1) while $bytes--;
    } else {
        $val = substr($$dataPt,$pos,$bytes);
    }
    defined($val) or return undef;
    return unpack($template,$val);
}

# Unpack double value
# Inputs: 0) unpack template, 1) data reference, 2) offset
# Returns: unpacked number
sub DoUnpackDbl(@)
{
    my ($template, $dataPt, $pos) = @_;
    my $val = substr($$dataPt,$pos,8);
    defined($val) or return undef;
    # swap bytes and 32-bit words (ARM quirk) if necessary, then unpack value
    return unpack($template, SwapWords(SwapBytes($val, 8)));
}

# Inputs: 0) data reference, 1) offset into data
sub Get8s($$)     { return DoUnpackStd('c', @_); }
sub Get8u($$)     { return DoUnpackStd('C', @_); }
sub Get16s($$)    { return DoUnpack(2, 's', @_); }
sub Get16u($$)    { return DoUnpackStd('S', @_); }
sub Get32s($$)    { return DoUnpack(4, 'l', @_); }
sub Get32u($$)    { return DoUnpackStd('L', @_); }
sub GetFloat($$)  { return DoUnpack(4, 'f', @_); }
sub GetDouble($$) { return DoUnpackDbl('d', @_); }
sub Get16uRev($$) { return DoUnpackRev('S', @_); }

# rationals may be a floating point number, 'inf' or 'undef'
sub GetRational32s($$)
{
    my ($dataPt, $pos) = @_;
    my $numer = Get16s($dataPt,$pos);
    my $denom = Get16s($dataPt, $pos + 2) or return $numer ? 'inf' : 'undef';
    # round off to a reasonable number of significant figures
    return RoundFloat($numer / $denom, 7);
}
sub GetRational32u($$)
{
    my ($dataPt, $pos) = @_;
    my $numer = Get16u($dataPt,$pos);
    my $denom = Get16u($dataPt, $pos + 2) or return $numer ? 'inf' : 'undef';
    return RoundFloat($numer / $denom, 7);
}
sub GetRational64s($$)
{
    my ($dataPt, $pos) = @_;
    my $numer = Get32s($dataPt,$pos);
    my $denom = Get32s($dataPt, $pos + 4) or return $numer ? 'inf' : 'undef';
    return RoundFloat($numer / $denom, 10);
}
sub GetRational64u($$)
{
    my ($dataPt, $pos) = @_;
    my $numer = Get32u($dataPt,$pos);
    my $denom = Get32u($dataPt, $pos + 4) or return $numer ? 'inf' : 'undef';
    return RoundFloat($numer / $denom, 10);
}
sub GetFixed16s($$)
{
    my ($dataPt, $pos) = @_;
    my $val = Get16s($dataPt, $pos) / 0x100;
    return int($val * 1000 + ($val<0 ? -0.5 : 0.5)) / 1000;
}
sub GetFixed16u($$)
{
    my ($dataPt, $pos) = @_;
    return int((Get16u($dataPt, $pos) / 0x100) * 1000 + 0.5) / 1000;
}
sub GetFixed32s($$)
{
    my ($dataPt, $pos) = @_;
    my $val = Get32s($dataPt, $pos) / 0x10000;
    # remove insignificant digits
    return int($val * 1e5 + ($val>0 ? 0.5 : -0.5)) / 1e5;
}
sub GetFixed32u($$)
{
    my ($dataPt, $pos) = @_;
    # remove insignificant digits
    return int((Get32u($dataPt, $pos) / 0x10000) * 1e5 + 0.5) / 1e5;
}
# Inputs: 0) value, 1) data ref, 2) offset
sub Set8s(@)  { return DoPackStd('c', @_); }
sub Set8u(@)  { return DoPackStd('C', @_); }
sub Set16u(@) { return DoPackStd('S', @_); }
sub Set32u(@) { return DoPackStd('L', @_); }
sub Set16uRev(@) { return DoPackRev('S', @_); }

#------------------------------------------------------------------------------
# Get current byte order ('II' or 'MM')
sub GetByteOrder() { return $currentByteOrder; }

#------------------------------------------------------------------------------
# Set byte ordering
# Inputs: 0) 'MM'=motorola, 'II'=intel (will translate 'BigEndian', 'LittleEndian')
# Returns: 1 on success
sub SetByteOrder($)
{
    my $order = shift;

    if ($order eq 'MM') {       # big endian (Motorola)
        %unpackStd = %unpackMotorola;
    } elsif ($order eq 'II') {  # little endian (Intel)
        %unpackStd = %unpackIntel;
    } elsif ($order =~ /^Big/i) {
        $order = 'MM';
        %unpackStd = %unpackMotorola;
    } elsif ($order =~ /^Little/i) {
        $order = 'II';
        %unpackStd = %unpackIntel;
    } else {
        return 0;
    }
    my $val = unpack('S','A ');
    my $nativeOrder;
    if ($val == 0x4120) {       # big endian
        $nativeOrder = 'MM';
    } elsif ($val == 0x2041) {  # little endian
        $nativeOrder = 'II';
    } else {
        warn sprintf("Unknown native byte order! (pattern %x)\n",$val);
        return 0;
    }
    $currentByteOrder = $order;  # save current byte order

    # swap bytes if our native CPU byte ordering is not the same as the EXIF
    $swapBytes = ($order ne $nativeOrder);

    # little-endian ARM has big-endian words for doubles (thanks Riku Voipio)
    # (Note: Riku's patch checked for '0ff3', but I think it should be 'f03f' since
    # 1 is '000000000000f03f' on an x86 -- so check for both, but which is correct?)
    my $pack1d = pack('d', 1);
    $swapWords = ($pack1d eq "\0\0\x0f\xf3\0\0\0\0" or
                  $pack1d eq "\0\0\xf0\x3f\0\0\0\0");
    return 1;
}

#------------------------------------------------------------------------------
# Change byte order
sub ToggleByteOrder()
{
    SetByteOrder(GetByteOrder() eq 'II' ? 'MM' : 'II');
}

#------------------------------------------------------------------------------
# hash lookups for reading values from data
my %formatSize = (
    int8s => 1,
    int8u => 1,
    int16s => 2,
    int16u => 2,
    int16uRev => 2,
    int32s => 4,
    int32u => 4,
    int64s => 8,
    int64u => 8,
    rational32s => 4,
    rational32u => 4,
    rational64s => 8,
    rational64u => 8,
    fixed16s => 2,
    fixed16u => 2,
    fixed32s => 4,
    fixed32u => 4,
    float => 4,
    double => 8,
    extended => 10,
    unicode => 2,
    complex => 8,
    string => 1,
    binary => 1,
   'undef' => 1,
    ifd => 4,
    ifd64 => 8,
);
my %readValueProc = (
    int8s => \&Get8s,
    int8u => \&Get8u,
    int16s => \&Get16s,
    int16u => \&Get16u,
    int16uRev => \&Get16uRev,
    int32s => \&Get32s,
    int32u => \&Get32u,
    int64s => \&Get64s,
    int64u => \&Get64u,
    rational32s => \&GetRational32s,
    rational32u => \&GetRational32u,
    rational64s => \&GetRational64s,
    rational64u => \&GetRational64u,
    fixed16s => \&GetFixed16s,
    fixed16u => \&GetFixed16u,
    fixed32s => \&GetFixed32s,
    fixed32u => \&GetFixed32u,
    float => \&GetFloat,
    double => \&GetDouble,
    extended => \&GetExtended,
    ifd => \&Get32u,
    ifd64 => \&Get64u,
);
sub FormatSize($) { return $formatSize{$_[0]}; }

#------------------------------------------------------------------------------
# Read value from binary data (with current byte ordering)
# Inputs: 0) data reference, 1) value offset, 2) format string,
#         3) number of values (or undef to use all data)
#         4) valid data length relative to offset
# Returns: converted value, or undefined if data isn't there
#          or list of values in list context
sub ReadValue($$$$$)
{
    my ($dataPt, $offset, $format, $count, $size) = @_;

    my $len = $formatSize{$format};
    unless ($len) {
        warn "Unknown format $format";
        $len = 1;
    }
    unless ($count) {
        return '' if defined $count or $size < $len;
        $count = int($size / $len);
    }
    # make sure entry is inside data
    if ($len * $count > $size) {
        $count = int($size / $len);     # shorten count if necessary
        $count < 1 and return undef;    # return undefined if no data
    }
    my @vals;
    my $proc = $readValueProc{$format};
    if ($proc) {
        for (;;) {
            push @vals, &$proc($dataPt, $offset);
            last if --$count <= 0;
            $offset += $len;
        }
    } else {
        # handle undef/binary/string (also unsupported unicode/complex)
        $vals[0] = substr($$dataPt, $offset, $count * $len);
        # truncate string at null terminator if necessary
        $vals[0] =~ s/\0.*//s if $format eq 'string';
    }
    return @vals if wantarray;
    return join(' ', @vals) if @vals > 1;
    return $vals[0];
}

#------------------------------------------------------------------------------
# Decode string with specified encoding
# Inputs: 0) ExifTool object ref, 1) string to decode
#         2) source character set name (undef for current Charset)
#         3) optional source byte order (2-byte and 4-byte fixed-width sets only)
#         4) optional destination character set (defaults to Charset setting)
#         5) optional destination byte order (2-byte and 4-byte fixed-width only)
# Returns: string in destination encoding
# Note: ExifTool ref may be undef if character both character sets are provided
#       (but in this case no warnings will be issued)
sub Decode($$$;$$$)
{
    my ($self, $val, $from, $fromOrder, $to, $toOrder) = @_;
    $from or $from = $$self{OPTIONS}{Charset};
    $to or $to = $$self{OPTIONS}{Charset};
    if ($from ne $to and length $val) {
        require Image::ExifTool::Charset;
        my $cs1 = $Image::ExifTool::Charset::csType{$from};
        my $cs2 = $Image::ExifTool::Charset::csType{$to};
        if ($cs1 and $cs2 and not $cs2 & 0x002) {
            # treat as straight ASCII if no character will need remapping
            if (($cs1 | $cs2) & 0x680 or $val =~ /[\x80-\xff]/) {
                my $uni = Image::ExifTool::Charset::Decompose($self, $val, $from, $fromOrder);
                $val = Image::ExifTool::Charset::Recompose($self, $uni, $to, $toOrder);
            }
        } elsif ($self) {
            my $set = $cs1 ? $to : $from;
            unless ($$self{"DecodeWarn$set"}) {
                $self->Warn("Unsupported character set ($set)");
                $$self{"DecodeWarn$set"} = 1;
            }
        }
    }
    return $val;
}

#------------------------------------------------------------------------------
# Encode string with specified encoding
# Inputs: 0) ExifTool object ref, 1) string, 2) destination character set name,
#         3) optional destination byte order (2-byte and 4-byte fixed-width sets only)
# Returns: string in specified encoding
sub Encode($$$;$)
{
    my ($self, $val, $to, $toOrder) = @_;
    return $self->Decode($val, undef, undef, $to, $toOrder);
}

#------------------------------------------------------------------------------
# Decode bit mask
# Inputs: 0) value to decode, 1) Reference to hash for decoding (or undef)
#         2) optional bits per word (defaults to 32)
sub DecodeBits($$;$)
{
    my ($vals, $lookup, $bits) = @_;
    $bits or $bits = 32;
    my ($val, $i, @bitList);
    my $num = 0;
    foreach $val (split ' ', $vals) {
        for ($i=0; $i<$bits; ++$i) {
            next unless $val & (1 << $i);
            my $n = $i + $num;
            if (not $lookup) {
                push @bitList, $n;
            } elsif ($$lookup{$n}) {
                push @bitList, $$lookup{$n};
            } else {
                push @bitList, "[$n]";
            }
        }
        $num += $bits;
    }
    return '(none)' unless @bitList;
    return join($lookup ? ', ' : ',', @bitList);
}

#------------------------------------------------------------------------------
# Validate an extracted image and repair if necessary
# Inputs: 0) ExifTool object reference, 1) image reference, 2) tag name or key
# Returns: image reference or undef if it wasn't valid
# Note: should be called from RawConv, not ValueConv
sub ValidateImage($$$)
{
    my ($self, $imagePt, $tag) = @_;
    return undef if $$imagePt eq 'none';
    unless ($$imagePt =~ /^(Binary data|\xff\xd8\xff)/ or
            # the first byte of the preview of some Minolta cameras is wrong,
            # so check for this and set it back to 0xff if necessary
            $$imagePt =~ s/^.(\xd8\xff\xdb)/\xff$1/s or
            $self->Options('IgnoreMinorErrors'))
    {
        # issue warning only if the tag was specifically requested
        if ($self->{REQ_TAG_LOOKUP}{lc GetTagName($tag)}) {
            $self->Warn("$tag is not a valid JPEG image",1);
            return undef;
        }
    }
    return $imagePt;
}

#------------------------------------------------------------------------------
# Make description from a tag name
# Inputs: 0) tag name 1) optional tagID to add at end of description
# Returns: description
sub MakeDescription($;$)
{
    my ($tag, $tagID) = @_;
    # start with the tag name and force first letter to be upper case
    my $desc = ucfirst($tag);
    $desc =~ tr/_/ /;       # translate underlines to spaces
    # put a space between lower/UPPER case and lower/number combinations
    $desc =~ s/([a-z])([A-Z\d])/$1 $2/g;
    # put a space between acronyms and words
    $desc =~ s/([A-Z])([A-Z][a-z])/$1 $2/g;
    # put spaces after numbers (if more than one character following number)
    $desc =~ s/(\d)([A-Z]\S)/$1 $2/g;
    # remove space in hex number
    $desc =~ s/ 0x ([\dA-Fa-f])/ 0x$1/g;
    $desc .= ' ' . $tagID if defined $tagID;
    return $desc;
}

#------------------------------------------------------------------------------
# Return printable value
# Inputs: 0) ExifTool object reference
#         1) value to print, 2) line length limit (undef defaults to 60, 0=unlimited)
sub Printable($;$)
{
    my ($self, $outStr, $maxLen) = @_;
    return '(undef)' unless defined $outStr;
    $outStr =~ tr/\x01-\x1f\x7f-\xff/./;
    $outStr =~ s/\x00//g;
    if (defined $maxLen) {
        # minimum length is 20 (0 is unlimited)
        $maxLen = 20 if $maxLen and $maxLen < 20;
    } else {
        $maxLen = 60;                   # default length is 60
    }
    # limit length only if verbose < 4
    if ($maxLen and length($outStr) > $maxLen and $self->{OPTIONS}{Verbose} < 4) {
        $outStr = substr($outStr,0,$maxLen-6) . '[snip]';
    }
    return $outStr;
}

#------------------------------------------------------------------------------
# Convert date/time from Exif format
# Inputs: 0) ExifTool object reference, 1) Date/time in EXIF format
# Returns: Formatted date/time string
sub ConvertDateTime($$)
{
    my ($self, $date) = @_;
    my $dateFormat = $self->{OPTIONS}{DateFormat};
    # only convert date if a format was specified and the date is recognizable
    if ($dateFormat) {
        # a few cameras use incorrect date/time formatting:
        # - slashes instead of colons in date (RolleiD330, ImpressCam)
        # - date/time values separated by colon instead of space (Polariod, Sanyo, Sharp, Vivitar)
        # - single-digit seconds with leading space (HP scanners)
        $date =~ s/[-+]\d{2}:\d{2}$//;  # remove timezone if it exists
        my @a = ($date =~ /\d+/g);      # be very flexible about date/time format
        if (@a and $a[0] > 1900 and $a[0] < 3000 and eval 'require POSIX') {
            $date = POSIX::strftime($dateFormat, $a[5]||0, $a[4]||0, $a[3]||0,
                                                 $a[2]||1, ($a[1]||1)-1, $a[0]-1900);
        } elsif ($self->{OPTIONS}{StrictDate}) {
            undef $date;
        }
    }
    return $date;
}

#------------------------------------------------------------------------------
# Print conversion for time span value
# Inputs: 0) time ticks, 1) number of seconds per tick (default 1)
# Returns: readable time
sub ConvertTimeSpan($;$)
{
    my ($val, $mult) = @_;
    if (Image::ExifTool::IsFloat($val) and $val != 0) {
        $val *= $mult if $mult;
        if ($val < 60) {
            $val = "$val seconds";
        } elsif ($val < 3600) {
            my $fmt = ($mult and $mult >= 60) ? '%d' : '%.1f';
            my $s = ($val == 60 and $mult) ? '' : 's';
            $val = sprintf("$fmt minute$s", $val / 60);
        } elsif ($val < 24 * 3600) {
            $val = sprintf("%.1f hours", $val / 3600);
        } else {
            $val = sprintf("%.1f days", $val / (24 * 3600));
        }
    }
    return $val;
}

#------------------------------------------------------------------------------
# Patched timelocal() that fixes ActivePerl timezone bug
# Inputs/Returns: same as timelocal()
# Notes: must 'require Time::Local' before calling this routine
sub TimeLocal(@)
{
    my $tm = Time::Local::timelocal(@_);
    if ($^O eq 'MSWin32') {
        # patch for ActivePerl timezone bug
        my @t2 = localtime($tm);
        my $t2 = Time::Local::timelocal(@t2);
        # adjust timelocal() return value to be consistent with localtime()
        $tm += $tm - $t2;
    }
    return $tm;
}

#------------------------------------------------------------------------------
# Get time zone in minutes
# Inputs: 0) localtime array ref, 1) gmtime array ref
# Returns: time zone offset in minutes
sub GetTimeZone(;$$)
{
    my ($tm, $gm) = @_;
    # compute the number of minutes between localtime and gmtime
    my $min = $$tm[2] * 60 + $$tm[1] - ($$gm[2] * 60 + $$gm[1]);
    if ($$tm[3] != $$gm[3]) {
        # account for case where one date wraps to the first of the next month
        $$gm[3] = $$tm[3] - ($$tm[3]==1 ? 1 : -1) if abs($$tm[3]-$$gm[3]) != 1;
        # adjust for the +/- one day difference
        $min += ($$tm[3] - $$gm[3]) * 24 * 60;
    }
    return $min;
}

#------------------------------------------------------------------------------
# Get time zone string
# Inputs: 0) time zone offset in minutes
#     or  0) localtime array ref, 1) corresponding time value
# Returns: time zone string ("+/-HH:MM")
sub TimeZoneString($;$)
{
    my $min = shift;
    if (ref $min) {
        my @gm = gmtime(shift);
        $min = GetTimeZone($min, \@gm);
    }
    my $sign = '+';
    $min < 0 and $sign = '-', $min = -$min;
    my $h = int($min / 60);
    return sprintf('%s%.2d:%.2d', $sign, $h, $min - $h * 60);
}

#------------------------------------------------------------------------------
# Convert Unix time to EXIF date/time string
# Inputs: 0) Unix time value, 1) non-zero to convert to local time
# Returns: EXIF date/time string (with timezone for local times)
# Notes: fractional seconds are ignored
sub ConvertUnixTime($;$)
{
    my ($time, $toLocal) = @_;
    return '0000:00:00 00:00:00' if $time == 0;
    my (@tm, $tz);
    if ($toLocal) {
        @tm = localtime($time);
        $tz = TimeZoneString(\@tm, $time);
    } else {
        @tm = gmtime($time);
        $tz = '';
    }
    my $str = sprintf("%4d:%.2d:%.2d %.2d:%.2d:%.2d%s",
                      $tm[5]+1900, $tm[4]+1, $tm[3], $tm[2], $tm[1], $tm[0], $tz);
    return $str;
}

#------------------------------------------------------------------------------
# Get Unix time from EXIF-formatted date/time string with optional timezone
# Inputs: 0) EXIF date/time string, 1) non-zero if time is local
# Returns: Unix time (seconds since 0:00 GMT Jan 1, 1970) or undefined on error
sub GetUnixTime($;$)
{
    my ($timeStr, $isLocal) = @_;
    return 0 if $timeStr eq '0000:00:00 00:00:00';
    my @tm = ($timeStr =~ /^(\d+):(\d+):(\d+)\s+(\d+):(\d+):(\d+)/);
    return undef unless @tm == 6 and eval 'require Time::Local';
    my $tzsec = 0;
    # use specified timezone offset (if given) instead of local system time
    # if we are converting a local time value
    if ($isLocal and $timeStr =~ /(?:Z|([-+])(\d+):(\d+))$/i) {
        # use specified timezone if one exists
        $tzsec = ($2 * 60 + $3) * ($1 eq '-' ? -60 : 60) if $1;
        undef $isLocal; # convert using GMT corrected for specified timezone
    }
    $tm[0] -= 1900;     # convert year
    $tm[1] -= 1;        # convert month
    @tm = reverse @tm;  # change to order required by timelocal()
    return $isLocal ? TimeLocal(@tm) : Time::Local::timegm(@tm) - $tzsec;
}

#------------------------------------------------------------------------------
# Print conversion for file size
# Inputs: 0) file size in bytes
# Returns: converted file size
sub ConvertFileSize($)
{
    my $val = shift;
    $val < 2048 and return "$val bytes";
    $val < 10240 and return sprintf('%.1f kB', $val / 1024);
    $val < 2097152 and return sprintf('%.0f kB', $val / 1024);
    $val < 10485760 and return sprintf('%.1f MB', $val / 1048576);
    return sprintf('%.0f MB', $val / 1048576);
}

#------------------------------------------------------------------------------
# Convert seconds to duration string (handles negative durations)
# Inputs: 0) floating point seconds
# Returns: duration string in form "S.SS s", "MM:SS" or "H:MM:SS"
sub ConvertDuration($)
{
    my $time = shift;
    return $time unless IsFloat($time);
    return '0 s' if $time == 0;
    my $sign = ($time > 0 ? '' : (($time = -$time), '-'));
    return sprintf("$sign%.2f s", $time) if $time < 30;
    my $h = int($time / 3600);
    $time -= $h * 3600;
    my $m = int($time / 60);
    $time -= $m * 60;
    return sprintf("$sign%d:%.2d:%.2d", $h, $m, int($time));
}

#------------------------------------------------------------------------------
# Print conversion for bitrate values
# Inputs: 0) bitrate in bits per second
# Returns: human-readable bitrate string
# Notes: returns input value without formatting if it isn't numerical
sub ConvertBitrate($)
{
    my $bitrate = shift;
    IsFloat($bitrate) or return $bitrate;
    my @units = ('bps', 'kbps', 'Mbps', 'Gbps');
    for (;;) {
        my $units = shift @units;
        $bitrate >= 1000 and @units and $bitrate /= 1000, next;
        my $fmt = $bitrate < 100 ? '%.3g' : '%.0f';
        return sprintf("$fmt $units", $bitrate);
    }
}

#------------------------------------------------------------------------------
# Save information for HTML dump
# Inputs: 0) ExifTool hash ref, 1) start offset, 2) data size
#         3) comment string, 4) tool tip (or SAME), 5) flags
sub HDump($$$$;$$)
{
    my $self = shift;
    my $pos = shift;
    $pos += $$self{BASE} if $$self{BASE};
    $$self{HTML_DUMP} and $self->{HTML_DUMP}->Add($pos, @_);
}

#------------------------------------------------------------------------------
# JPEG constants
my %jpegMarker = (
    0x01 => 'TEM',
    0xc0 => 'SOF0', # to SOF15, with a few exceptions below
    0xc4 => 'DHT',
    0xc8 => 'JPGA',
    0xcc => 'DAC',
    0xd0 => 'RST0',
    0xd8 => 'SOI',
    0xd9 => 'EOI',
    0xda => 'SOS',
    0xdb => 'DQT',
    0xdc => 'DNL',
    0xdd => 'DRI',
    0xde => 'DHP',
    0xdf => 'EXP',
    0xe0 => 'APP0', # to APP15
    0xf0 => 'JPG0',
    0xfe => 'COM',
);

#------------------------------------------------------------------------------
# Get JPEG marker name
# Inputs: 0) Jpeg number
# Returns: marker name
sub JpegMarkerName($)
{
    my $marker = shift;
    my $markerName = $jpegMarker{$marker};
    unless ($markerName) {
        $markerName = $jpegMarker{$marker & 0xf0};
        if ($markerName and $markerName =~ /^([A-Z]+)\d+$/) {
            $markerName = $1 . ($marker & 0x0f);
        } else {
            $markerName = sprintf("marker 0x%.2x", $marker);
        }
    }
    return $markerName;
}

#------------------------------------------------------------------------------
# Identify trailer ending at specified offset from end of file
# Inputs: 0) RAF reference, 1) offset from end of file (0 by default)
# Returns: Trailer info hash (with RAF and DirName set),
#          or undef if no recognized trailer was found
# Notes: leaves file position unchanged
sub IdentifyTrailer($;$)
{
    my $raf = shift;
    my $offset = shift || 0;
    my $pos = $raf->Tell();
    my ($buff, $type, $len);
    while ($raf->Seek(-$offset, 2) and ($len = $raf->Tell()) > 0) {
        # read up to 64 bytes before specified offset from end of file
        $len = 64 if $len > 64;
        $raf->Seek(-$len, 1) and $raf->Read($buff, $len) == $len or last;
        if ($buff =~ /AXS(!|\*).{8}$/s) {
            $type = 'AFCP';
        } elsif ($buff =~ /\xa1\xb2\xc3\xd4$/) {
            $type = 'FotoStation';
        } elsif ($buff =~ /cbipcbbl$/) {
            $type = 'PhotoMechanic';
        } elsif ($buff =~ /^CANON OPTIONAL DATA\0/) {
            $type = 'CanonVRD';
        } elsif ($buff =~ /~\0\x04\0zmie~\0\0\x06.{4}[\x10\x18]\x04$/s or
                 $buff =~ /~\0\x04\0zmie~\0\0\x0a.{8}[\x10\x18]\x08$/s)
        {
            $type = 'MIE';
        }
        last;
    }
    $raf->Seek($pos, 0);    # restore original file position
    return $type ? { RAF => $raf, DirName => $type } : undef;
}

#------------------------------------------------------------------------------
# Read/rewrite trailer information (including multiple trailers)
# Inputs: 0) ExifTool object ref, 1) DirInfo ref:
# - requires RAF and DirName
# - OutFile is a scalar reference for writing
# - scans from current file position if ScanForAFCP is set
# Returns: 1 if trailer was processed or couldn't be processed (or written OK)
#          0 if trailer was recognized but offsets need fixing (or write error)
# - DirName, DirLen, DataPos, Offset, Fixup and OutFile are updated
# - preserves current file position and byte order
sub ProcessTrailers($$)
{
    my ($self, $dirInfo) = @_;
    my $dirName = $$dirInfo{DirName};
    my $outfile = $$dirInfo{OutFile};
    my $offset = $$dirInfo{Offset} || 0;
    my $fixup = $$dirInfo{Fixup};
    my $raf = $$dirInfo{RAF};
    my $pos = $raf->Tell();
    my $byteOrder = GetByteOrder();
    my $success = 1;
    my $path = $$self{PATH};

    for (;;) { # loop through all trailers
        require "Image/ExifTool/$dirName.pm";
        my $proc = "Image::ExifTool::${dirName}::Process$dirName";
        my $outBuff;
        if ($outfile) {
            # write to local buffer so we can add trailer in proper order later
            $$outfile and $$dirInfo{OutFile} = \$outBuff, $outBuff = '';
            # must generate new fixup if necessary so we can shift
            # the old fixup separately after we prepend this trailer
            delete $$dirInfo{Fixup};
        }
        delete $$dirInfo{DirLen};       # reset trailer length
        $$dirInfo{Offset} = $offset;    # set offset from end of file
        $$dirInfo{Trailer} = 1;         # set Trailer flag in case proc cares
        # add trailer and DirName to SubDirectory PATH
        push @$path, 'Trailer', $dirName;

        # read or write this trailer
        # (proc takes Offset as offset from end of trailer to end of file,
        #  and returns DataPos and DirLen, and Fixup if applicable)
        no strict 'refs';
        my $result = &$proc($self, $dirInfo);
        use strict 'refs';

        # restore PATH
        pop @$path;
        pop @$path;
        # check result
        if ($outfile) {
            if ($result > 0) {
                if ($outBuff) {
                    # write trailers to OutFile in original order
                    $$outfile = $outBuff . $$outfile;
                    # must adjust old fixup start if it exists
                    $$fixup{Start} += length($outBuff) if $fixup;
                    $outBuff = '';      # free memory
                }
                if ($fixup) {
                    # add new fixup information if any
                    $fixup->AddFixup($$dirInfo{Fixup}) if $$dirInfo{Fixup};
                } else {
                    $fixup = $$dirInfo{Fixup};  # save fixup
                }
            } else {
                $success = 0 if $self->Error("Error rewriting $dirName trailer", 1);
                last;
            }
        } elsif ($result < 0) {
            # can't continue if we must scan for this trailer
            $success = 0;
            last;
        }
        last unless $result > 0 and $$dirInfo{DirLen};
        # look for next trailer
        $offset += $$dirInfo{DirLen};
        my $nextTrail = IdentifyTrailer($raf, $offset) or last;
        $dirName = $$dirInfo{DirName} = $$nextTrail{DirName};
        $raf->Seek($pos, 0);
    }
    SetByteOrder($byteOrder);       # restore original byte order
    $raf->Seek($pos, 0);            # restore original file position
    $$dirInfo{OutFile} = $outfile;  # restore original outfile
    $$dirInfo{Offset} = $offset;    # return offset from EOF to start of first trailer
    $$dirInfo{Fixup} = $fixup;      # return fixup information
    return $success;
}

#------------------------------------------------------------------------------
# Extract EXIF information from a jpg image
# Inputs: 0) ExifTool object reference, 1) dirInfo ref with RAF set
# Returns: 1 on success, 0 if this wasn't a valid JPEG file
sub ProcessJPEG($$)
{
    local $_;
    my ($self, $dirInfo) = @_;
    my ($ch, $s, $length);
    my $verbose = $self->{OPTIONS}{Verbose};
    my $out = $self->{OPTIONS}{TextOut};
    my $fast = $self->{OPTIONS}{FastScan};
    my $raf = $$dirInfo{RAF};
    my $htmlDump = $self->{HTML_DUMP};
    my %dumpParms = ( Out => $out );
    my ($success, $icc_profile, $wantTrailer, $trailInfo, %extendedXMP);
    my ($preview, $scalado, @dqt, $subSampling, $dumpEnd);

    # check to be sure this is a valid JPG file
    return 0 unless $raf->Read($s, 2) == 2 and $s eq "\xff\xd8";
    $dumpParms{MaxLen} = 128 if $verbose < 4;
    unless ($self->{VALUE}{FileType}) {
        $self->SetFileType();               # set FileType tag
        $$self{LOW_PRIORITY_DIR}{IFD1} = 1; # lower priority of IFD1 tags
    }
    if ($htmlDump) {
        $dumpEnd = $raf->Tell();
        my $pos = $dumpEnd - 2;
        $self->HDump(0, $pos, '[unknown header]') if $pos;
        $self->HDump($pos, 2, 'JPEG header', 'SOI Marker');
    }
    my $path = $$self{PATH};
    my $pn = scalar @$path;

    # set input record separator to 0xff (the JPEG marker) to make reading quicker
    local $/ = "\xff";

    my ($nextMarker, $nextSegDataPt, $nextSegPos, $combinedSegData);

    # read file until we reach an end of image (EOI) or start of scan (SOS)
    Marker: for (;;) {
        # set marker and data pointer for current segment
        my $marker = $nextMarker;
        my $segDataPt = $nextSegDataPt;
        my $segPos = $nextSegPos;
        undef $nextMarker;
        undef $nextSegDataPt;
#
# read ahead to the next segment unless we have reached EOI or SOS
#
        unless ($marker and ($marker==0xd9 or ($marker==0xda and not $wantTrailer))) {
            # read up to next marker (JPEG markers begin with 0xff)
            my $buff;
            $raf->ReadLine($buff) or last;
            # JPEG markers can be padded with unlimited 0xff's
            for (;;) {
                $raf->Read($ch, 1) or last Marker;
                $nextMarker = ord($ch);
                last unless $nextMarker == 0xff;
            }
            # read data for all markers except 0xd9 (EOI) and stand-alone
            # markers 0x00, 0x01 and 0xd0-0xd7 (NULL, TEM, RST0-RST7)
            if ($nextMarker!=0xd9 and $nextMarker!=0x00 and $nextMarker!=0x01 and
                ($nextMarker<0xd0 or $nextMarker>0xd7))
            {
                # read record length word
                last unless $raf->Read($s, 2) == 2;
                my $len = unpack('n',$s);   # get data length
                last unless defined($len) and $len >= 2;
                $nextSegPos = $raf->Tell();
                $len -= 2;  # subtract size of length word
                last unless $raf->Read($buff, $len) == $len;
                $nextSegDataPt = \$buff;    # set pointer to our next data
            }
            # read second segment too if this was the first
            next unless defined $marker;
        }
        # set some useful variables for the current segment
        my $markerName = JpegMarkerName($marker);
        $$path[$pn] = $markerName;
#
# parse the current segment
#
        # handle SOF markers: SOF0-SOF15, except DHT(0xc4), JPGA(0xc8) and DAC(0xcc)
        if (($marker & 0xf0) == 0xc0 and ($marker == 0xc0 or $marker & 0x03)) {
            $length = length $$segDataPt;
            if ($verbose) {
                print $out "JPEG $markerName ($length bytes):\n";
                HexDump($segDataPt, undef, %dumpParms, Addr=>$segPos) if $verbose>2;
            }
            next unless $length >= 6;
            # extract some useful information
            my ($p, $h, $w, $n) = unpack('Cn2C', $$segDataPt);
            my $sof = GetTagTable('Image::ExifTool::JPEG::SOF');
            $self->FoundTag($$sof{ImageWidth}, $w);
            $self->FoundTag($$sof{ImageHeight}, $h);
            $self->FoundTag($$sof{EncodingProcess}, $marker - 0xc0);
            $self->FoundTag($$sof{BitsPerSample}, $p);
            $self->FoundTag($$sof{ColorComponents}, $n);
            next unless $n == 3 and $length >= 15;
            my ($i, $hmin, $hmax, $vmin, $vmax);
            # loop through all components to determine sampling frequency
            $subSampling = '';
            for ($i=0; $i<$n; ++$i) {
                my $sf = Get8u($segDataPt, 7 + 3 * $i);
                $subSampling .= sprintf('%.2x', $sf);
                # isolate horizontal and vertical components
                my ($hf, $vf) = ($sf >> 4, $sf & 0x0f);
                unless ($i) {
                    $hmin = $hmax = $hf;
                    $vmin = $vmax = $vf;
                    next;
                }
                # determine min/max frequencies
                $hmin = $hf if $hf < $hmin;
                $hmax = $hf if $hf > $hmax;
                $vmin = $vf if $vf < $vmin;
                $vmax = $vf if $vf > $vmax;
            }
            if ($hmin and $vmin) {
                my ($hs, $vs) = ($hmax / $hmin, $vmax / $vmin);
                $self->FoundTag($$sof{YCbCrSubSampling}, "$hs $vs");
            }
            next;
        } elsif ($marker == 0xd9) {         # EOI
            pop @$path;
            $verbose and print $out "JPEG EOI\n";
            my $pos = $raf->Tell();
            if ($htmlDump and $dumpEnd) {
                $self->HDump($dumpEnd, $pos-2-$dumpEnd, '[JPEG Image Data]', undef, 0x08);
                $self->HDump($pos-2, 2, 'JPEG EOI', undef);
                $dumpEnd = 0;
            }
            $success = 1;
            # we are here because we are looking for trailer information
            if ($wantTrailer) {
                my $start = $$self{PreviewImageStart};
                if ($start) {
                    my $buff;
                    # most previews start right after the JPEG EOI, but the Olympus E-20
                    # preview is 508 bytes into the trailer, the K-M Maxxum 7D preview is
                    # 979 bytes in, and Sony previews can start up to 32 kB into the trailer.
                    # (and Minolta and Sony previews can have a random first byte...)
                    my $scanLen = $$self{Make} =~ /Sony/i ? 65536 : 1024;
                    if ($raf->Read($buff, $scanLen) and ($buff =~ /\xff\xd8\xff./g or
                        ($self->{Make} =~ /(Minolta|Sony)/i and $buff =~ /.\xd8\xff\xdb/g)))
                    {
                        # adjust PreviewImageStart to this location
                        my $actual = $pos + pos($buff) - 4;
                        if ($start ne $actual and $verbose > 1) {
                            print $out "(Fixed PreviewImage location: $start -> $actual)\n";
                        }
                        # update preview image offsets
                        $self->{VALUE}{PreviewImageStart} = $actual if $self->{VALUE}{PreviewImageStart};
                        $$self{PreviewImageStart} = $actual;
                        # load preview now if we tried and failed earlier
                        if ($$self{PreviewError} and $$self{PreviewImageLength}) {
                            if ($raf->Seek($actual, 0) and $raf->Read($buff, $$self{PreviewImageLength})) {
                                $self->FoundTag('PreviewImage', $buff);
                                delete $$self{PreviewError};
                            }
                        }
                    }
                    $raf->Seek($pos, 0);
                }
            }
            # process trailer now or finish processing trailers
            # and scan for AFCP if necessary
            my $fromEnd = 0;
            if ($trailInfo) {
                $$trailInfo{ScanForAFCP} = 1;   # scan now if necessary
                $self->ProcessTrailers($trailInfo);
                # save offset from end of file to start of first trailer
                $fromEnd = $$trailInfo{Offset};
                undef $trailInfo;
            }
            if ($$self{LeicaTrailer}) {
                $raf->Seek(0, 2);
                $$self{LeicaTrailer}{TrailPos} = $pos;
                $$self{LeicaTrailer}{TrailLen} = $raf->Tell() - $pos - $fromEnd;
                Image::ExifTool::Panasonic::ProcessLeicaTrailer($self);
            }
            # finally, dump remaining information in JPEG trailer
            if ($verbose or $htmlDump) {
                my $endPos = $$self{LeicaTrailerPos};
                unless ($endPos) {
                    $raf->Seek(0, 2);
                    $endPos = $raf->Tell() - $fromEnd;
                }
                $self->DumpUnknownTrailer({
                    RAF => $raf,
                    DataPos => $pos,
                    DirLen => $endPos - $pos
                }) if $endPos > $pos;
            }
            last;       # all done parsing file
        } elsif ($marker == 0xda) {         # SOS
            pop @$path;
            # all done with meta information unless we have a trailer
            $verbose and print $out "JPEG SOS\n";
            unless ($fast) {
                $trailInfo = IdentifyTrailer($raf);
                # process trailer now unless we are doing verbose dump
                if ($trailInfo and $verbose < 3 and not $htmlDump) {
                    # process trailers (keep trailInfo to finish processing later
                    # only if we can't finish without scanning from end of file)
                    $self->ProcessTrailers($trailInfo) and undef $trailInfo;
                }
                if ($wantTrailer) {
                    # seek ahead and validate preview image
                    my $buff;
                    my $curPos = $raf->Tell();
                    if ($raf->Seek($$self{PreviewImageStart}, 0) and
                        $raf->Read($buff, 4) == 4 and
                        $buff =~ /^.\xd8\xff[\xc4\xdb\xe0-\xef]/)
                    {
                        undef $wantTrailer;
                    }
                    $raf->Seek($curPos, 0) or last;
                }
                # seek ahead and process Leica trailer
                if ($$self{LeicaTrailer}) {
                    require Image::ExifTool::Panasonic;
                    Image::ExifTool::Panasonic::ProcessLeicaTrailer($self);
                    $wantTrailer = 1 if $$self{LeicaTrailer};
                }
                next if $trailInfo or $wantTrailer or $verbose > 2 or $htmlDump;
            }
            # nothing interesting to parse after start of scan (SOS)
            $success = 1;
            last;   # all done parsing file
        } elsif ($marker==0x00 or $marker==0x01 or ($marker>=0xd0 and $marker<=0xd7)) {
            # handle stand-alone markers 0x00, 0x01 and 0xd0-0xd7 (NULL, TEM, RST0-RST7)
            $verbose and $marker and print $out "JPEG $markerName:\n";
            next;
        } elsif ($marker == 0xdb and length($$segDataPt) and    # DQT
            # save the DQT data only if JPEGDigest has been requested
            $self->{REQ_TAG_LOOKUP}->{jpegdigest})
        {
            my $num = unpack('C',$$segDataPt) & 0x0f;   # get table index
            $dqt[$num] = $$segDataPt if $num < 4;       # save for MD5 calculation
        }
        # handle all other markers
        my $dumpType = '';
        $length = length $$segDataPt;
        if ($verbose) {
            print $out "JPEG $markerName ($length bytes):\n";
            if ($verbose > 2) {
                my %extraParms = ( Addr => $segPos );
                $extraParms{MaxLen} = 128 if $verbose == 4;
                HexDump($segDataPt, undef, %dumpParms, %extraParms);
            }
        }
        if ($marker == 0xe0) {              # APP0 (JFIF, CIFF, AVI1)
            if ($$segDataPt =~ /^JFIF\0/) {
                $dumpType = 'JFIF';
                my %dirInfo = (
                    DataPt => $segDataPt,
                    DataPos  => $segPos,
                    DirStart => 5,
                    DirLen => $length - 5,
                );
                SetByteOrder('MM');
                my $tagTablePtr = GetTagTable('Image::ExifTool::JFIF::Main');
                $self->ProcessDirectory(\%dirInfo, $tagTablePtr);
            } elsif ($$segDataPt =~ /^JFXX\0\x10/) {
                $dumpType = 'JFXX';
                my $tagTablePtr = GetTagTable('Image::ExifTool::JFIF::Extension');
                my $tagInfo = $self->GetTagInfo($tagTablePtr, 0x10);
                $self->FoundTag($tagInfo, substr($$segDataPt, 6));
            } elsif ($$segDataPt =~ /^(II|MM).{4}HEAPJPGM/s) {
                next if $fast and $fast > 1;    # skip processing for very fast
                $dumpType = 'CIFF';
                my %dirInfo = (
                    RAF => new File::RandomAccess($segDataPt),
                );
                $self->{SET_GROUP1} = 'CIFF';
                require Image::ExifTool::CanonRaw;
                Image::ExifTool::CanonRaw::ProcessCRW($self, \%dirInfo);
                delete $self->{SET_GROUP1};
            } elsif ($$segDataPt =~ /^AVI1/) {
                $dumpType = 'AVI1';
                SetByteOrder('MM');
                my $tagTablePtr = GetTagTable('Image::ExifTool::JPEG::AVI1');
                my %dirInfo = (
                    DataPt   => $segDataPt,
                    DataPos  => $segPos,
                    DirStart => 4,
                    DirLen   => $length - 4,
                );
                $self->ProcessDirectory(\%dirInfo, $tagTablePtr);
            }
        } elsif ($marker == 0xe1) {         # APP1 (EXIF, XMP, QVCI)
            if ($$segDataPt =~ /^Exif\0/) { # (some Kodak cameras don't put a second \0)
                undef $dumpType;    # (will be dumped here)
                # this is EXIF data --
                # get the data block (into a common variable)
                my $hdrLen = length($exifAPP1hdr);
                my %dirInfo = (
                    Parent => $markerName,
                    DataPt => $segDataPt,
                    DataPos => $segPos,
                    DirStart => $hdrLen,
                    Base => $segPos + $hdrLen,
                );
                if ($htmlDump) {
                    $self->HDump($segPos-4, 4, 'APP1 header', "Data size: $length bytes");
                    $self->HDump($segPos, $hdrLen, 'Exif header', 'APP1 data type: Exif');
                    $dumpEnd = $segPos + $length;
                }
                # extract the EXIF information (it is in standard TIFF format)
                $self->ProcessTIFF(\%dirInfo);
                # avoid looking for preview unless necessary because it really slows
                # us down -- only look for it if we found pointer, and preview is
                # outside EXIF, and PreviewImage is specifically requested
                my $start = $self->GetValue('PreviewImageStart');
                my $length = $self->GetValue('PreviewImageLength');
                if (not $start or not $length and $$self{PreviewError}) {
                    $start = $$self{PreviewImageStart};
                    $length = $$self{PreviewImageLength};
                }
                if ($start and $length and
                    $start + $length > $self->{EXIF_POS} + length($self->{EXIF_DATA}) and
                    $self->{REQ_TAG_LOOKUP}{previewimage})
                {
                    $$self{PreviewImageStart} = $start;
                    $$self{PreviewImageLength} = $length;
                    $wantTrailer = 1;
                }
            } elsif ($$segDataPt =~ /^$xmpExtAPP1hdr/) {
                # off len -- extended XMP header (75 bytes total):
                #   0  35 bytes - signature
                #  35  32 bytes - GUID (MD5 hash of full extended XMP data in ASCII)
                #  67   4 bytes - total size of extended XMP data
                #  71   4 bytes - offset for this XMP data portion
                $dumpType = 'Extended XMP';
                if (length $$segDataPt > 75) {
                    my ($size, $off) = unpack('x67N2', $$segDataPt);
                    my $guid = substr($$segDataPt, 35, 32);
                    my $extXMP = $extendedXMP{$guid};
                    $extXMP or $extXMP = $extendedXMP{$guid} = { };
                    $$extXMP{Size} = $size;
                    $$extXMP{$off} = substr($$segDataPt, 75);
                    # process extended XMP if complete
                    my @offsets;
                    for ($off=0; $off<$size; ) {
                        last unless defined $$extXMP{$off};
                        push @offsets, $off;
                        $off += length $$extXMP{$off};
                    }
                    if ($off == $size) {
                        my $buff = '';
                        # assemble XMP all together
                        $buff .= $$extXMP{$_} foreach @offsets;
                        $dumpType = 'Extended XMP';
                        my $tagTablePtr = GetTagTable('Image::ExifTool::XMP::Main');
                        my %dirInfo = (
                            DataPt   => \$buff,
                            Parent   => $markerName,
                        );
                        $self->ProcessDirectory(\%dirInfo, $tagTablePtr);
                        delete $extendedXMP{$guid};
                    }
                } else {
                    $self->Warn('Invalid extended XMP segment');
                }
            } elsif ($$segDataPt =~ /^QVCI\0/) {
                $dumpType = 'QVCI';
                my $tagTablePtr = GetTagTable('Image::ExifTool::Casio::QVCI');
                my %dirInfo = (
                    Base     => 0,
                    DataPt   => $segDataPt,
                    DataPos  => $segPos,
                    DataLen  => $length,
                    DirStart => 0,
                    DirLen   => $length,
                    Parent   => $markerName,
                );
                $self->ProcessDirectory(\%dirInfo, $tagTablePtr);
            } else {
                # Hmmm.  Could be XMP, let's see
                my $processed;
                if ($$segDataPt =~ /^http/ or $$segDataPt =~ /<exif:/) {
                    $dumpType = 'XMP';
                    # also try to parse XMP with a non-standard header
                    # (note: this non-standard XMP is ignored when writing)
                    my $start = ($$segDataPt =~ /^$xmpAPP1hdr/) ? length($xmpAPP1hdr) : 0;
                    my $tagTablePtr = GetTagTable('Image::ExifTool::XMP::Main');
                    my %dirInfo = (
                        Base     => 0,
                        DataPt   => $segDataPt,
                        DataPos  => $segPos,
                        DataLen  => $length,
                        DirStart => $start,
                        DirLen   => $length - $start,
                        Parent   => $markerName,
                    );
                    $processed = $self->ProcessDirectory(\%dirInfo, $tagTablePtr);
                    if ($processed and not $start) {
                        $self->Warn('Non-standard header for APP1 XMP segment');
                    }
                }
                if ($verbose and not $processed) {
                    $self->Warn("Ignored EXIF block length $length (bad header)");
                }
            }
        } elsif ($marker == 0xe2) {         # APP2 (ICC Profile, FPXR, MPF, PreviewImage)
            if ($$segDataPt =~ /^ICC_PROFILE\0/) {
                $dumpType = 'ICC_Profile';
                # must concatenate blocks of profile
                my $block_num = Get8u($segDataPt, 12);
                my $blocks_tot = Get8u($segDataPt, 13);
                $icc_profile = '' if $block_num == 1;
                if (defined $icc_profile) {
                    $icc_profile .= substr($$segDataPt, 14);
                    if ($block_num == $blocks_tot) {
                        my $tagTablePtr = GetTagTable('Image::ExifTool::ICC_Profile::Main');
                        my %dirInfo = (
                            DataPt   => \$icc_profile,
                            DataPos  => $segPos + 14,
                            DataLen  => length($icc_profile),
                            DirStart => 0,
                            DirLen   => length($icc_profile),
                            Parent   => $markerName,
                        );
                        $self->ProcessDirectory(\%dirInfo, $tagTablePtr);
                        undef $icc_profile;
                    }
                }
            } elsif ($$segDataPt =~ /^FPXR\0/) {
                next if $fast and $fast > 1;    # skip processing for very fast
                $dumpType = 'FPXR';
                my $tagTablePtr = GetTagTable('Image::ExifTool::FlashPix::Main');
                my %dirInfo = (
                    DataPt   => $segDataPt,
                    DataPos  => $segPos,
                    DataLen  => $length,
                    DirStart => 0,
                    DirLen   => $length,
                    Parent   => $markerName,
                    # set flag if this is the last FPXR segment
                    LastFPXR => not ($nextMarker==$marker and $$nextSegDataPt=~/^FPXR\0/),
                );
                $self->ProcessDirectory(\%dirInfo, $tagTablePtr);
            } elsif ($$segDataPt =~ /^MPF\0/) {
                undef $dumpType;    # (will be dumped here)
                my %dirInfo = (
                    Parent => $markerName,
                    DataPt => $segDataPt,
                    DataPos => $segPos,
                    DirStart => 4,
                    Base => $segPos + 4,
                    Multi => 1, # the MP Attribute IFD will be MPF1
                );
                if ($htmlDump) {
                    $self->HDump($segPos-4, 4, 'APP2 header', "Data size: $length bytes");
                    $self->HDump($segPos, 4, 'MPF header', 'APP2 data type: MPF');
                    $dumpEnd = $segPos + $length;
                }
                # extract the MPF information (it is in standard TIFF format)
                my $tagTablePtr = GetTagTable('Image::ExifTool::MPF::Main');
                $self->ProcessTIFF(\%dirInfo, $tagTablePtr);
            } elsif ($$segDataPt =~ /^\xff\xd8\xff\xdb/) {
                $preview = $$segDataPt;
                $dumpType = 'Samsung Preview';
            } elsif ($preview) {
                $preview .= $$segDataPt;
                $dumpType = 'Samsung Preview';
            }
            if ($preview and $nextMarker ne $marker) {
                $self->FoundTag('PreviewImage', $preview);
                undef $preview;
            }
        } elsif ($marker == 0xe3) {         # APP3 (Kodak "Meta", Stim)
            if ($$segDataPt =~ /^(Meta|META|Exif)\0\0/) {
                undef $dumpType;    # (will be dumped here)
                my %dirInfo = (
                    Parent => $markerName,
                    DataPt => $segDataPt,
                    DataPos => $segPos,
                    DirStart => 6,
                    Base => $segPos + 6,
                );
                if ($htmlDump) {
                    $self->HDump($segPos-4, 10, 'APP3 Meta header');
                    $dumpEnd = $segPos + $length;
                }
                my $tagTablePtr = GetTagTable('Image::ExifTool::Kodak::Meta');
                $self->ProcessTIFF(\%dirInfo, $tagTablePtr);
            } elsif ($$segDataPt =~ /^Stim\0/) {
                undef $dumpType;    # (will be dumped here)
                my %dirInfo = (
                    Parent => $markerName,
                    DataPt => $segDataPt,
                    DataPos => $segPos,
                    DirStart => 6,
                    Base => $segPos + 6,
                );
                if ($htmlDump) {
                    $self->HDump($segPos-4, 4, 'APP3 header', "Data size: $length bytes");
                    $self->HDump($segPos, 5, 'Stim header', 'APP3 data type: Stim');
                    $dumpEnd = $segPos + $length;
                }
                # extract the Stim information (it is in standard TIFF format)
                my $tagTablePtr = GetTagTable('Image::ExifTool::Stim::Main');
                $self->ProcessTIFF(\%dirInfo, $tagTablePtr);
            } elsif ($$segDataPt =~ /^\xff\xd8\xff\xdb/) {
                $preview = $$segDataPt;
                $dumpType = 'Samsung/HP Preview';
            }
            # Samsung continues the preview in APP4
            if ($preview and $nextMarker ne 0xe4) {
                $self->FoundTag('PreviewImage', $preview);
                undef $preview;
            }
        } elsif ($marker == 0xe4) {         # APP4 ("SCALADO", FPXR, PreviewImage)
            if ($$segDataPt =~ /^SCALADO\0/ and $length >= 16) {
                $dumpType = 'SCALADO';
                my ($num, $idx, $len) = unpack('x8n2N', $$segDataPt);
                # assume that the segments are in order and just concatinate them
                $scalado = '' unless defined $scalado;
                $scalado .= substr($$segDataPt, 16);
                if ($idx == $num - 1) {
                    if ($len != length $scalado) {
                        $self->Warn('Possibly corrupted APP4 SCALADO data', 1);
                    }
                    my %dirInfo = (
                        Parent => $markerName,
                        DataPt => \$scalado,
                    );
                    my $tagTablePtr = GetTagTable('Image::ExifTool::JPEG::Scalado');
                    $self->ProcessDirectory(\%dirInfo, $tagTablePtr);
                    undef $scalado;
                }
            } elsif ($$segDataPt =~ /^FPXR\0/) {
                next if $fast and $fast > 1;    # skip processing for very fast
                $dumpType = 'FPXR';
                my $tagTablePtr = GetTagTable('Image::ExifTool::FlashPix::Main');
                my %dirInfo = (
                    DataPt   => $segDataPt,
                    DataPos  => $segPos,
                    DataLen  => $length,
                    DirStart => 0,
                    DirLen   => $length,
                    Parent   => $markerName,
                    # set flag if this is the last FPXR segment
                    LastFPXR => not ($nextMarker==$marker and $$nextSegDataPt=~/^FPXR\0/),
                );
                $self->ProcessDirectory(\%dirInfo, $tagTablePtr);
            } elsif ($preview) {
                # continued Samsung S1060 preview from APP3
                $preview .= $$segDataPt;
                # (not sure if next part would be APP5 or APP4 again, but assume APP4)
                if ($nextMarker ne $marker) {
                    $self->FoundTag('PreviewImage', $preview);
                    undef $preview;
                }
            }
        } elsif ($marker == 0xe5) {         # APP5 (Ricoh "RMETA")
            if ($$segDataPt =~ /^RMETA\0/) {
                $dumpType = 'Ricoh RMETA';
                my %dirInfo = (
                    Parent => $markerName,
                    DataPt => $segDataPt,
                    DataPos => $segPos,
                    DirStart => 6,
                    Base => $segPos + 6,
                );
                my $tagTablePtr = GetTagTable('Image::ExifTool::Ricoh::RMETA');
                $self->ProcessDirectory(\%dirInfo, $tagTablePtr);
            }
        } elsif ($marker == 0xe6) {         # APP6 (Toshiba EPPIM, NITF, HP_TDHD)
            if ($$segDataPt =~ /^EPPIM\0/) {
                undef $dumpType;    # (will be dumped here)
                my %dirInfo = (
                    Parent => $markerName,
                    DataPt => $segDataPt,
                    DataPos => $segPos,
                    DirStart => 6,
                    Base => $segPos + 6,
                );
                if ($htmlDump) {
                    $self->HDump($segPos-4, 10, 'APP6 EPPIM header');
                    $dumpEnd = $segPos + $length;
                }
                my $tagTablePtr = GetTagTable('Image::ExifTool::JPEG::EPPIM');
                $self->ProcessTIFF(\%dirInfo, $tagTablePtr);
            } elsif ($$segDataPt =~ /^NITF\0/) {
                $dumpType = 'NITF';
                SetByteOrder('MM');
                my $tagTablePtr = GetTagTable('Image::ExifTool::JPEG::NITF');
                my %dirInfo = (
                    DataPt   => $segDataPt,
                    DataPos  => $segPos,
                    DirStart => 5,
                    DirLen   => $length - 5,
                );
                $self->ProcessDirectory(\%dirInfo, $tagTablePtr);
            } elsif ($$segDataPt =~ /^TDHD\x01\0\0\0/ and $length > 12) {
                # HP Photosmart R837 APP6 "TDHD" segment
                $dumpType = 'TDHD';
                my $tagTablePtr = GetTagTable('Image::ExifTool::HP::TDHD');
                my %dirInfo = (
                    DataPt   => $segDataPt,
                    DataPos  => $segPos,
                    DirStart => 12, # (ignore first TDHD element because size includes 12-byte tag header)
                    DirLen   => $length - 12,
                );
                $self->ProcessDirectory(\%dirInfo, $tagTablePtr);
            }
        } elsif ($marker == 0xe8) {         # APP8 (SPIFF)
            # my sample SPIFF has 32 bytes of data, but spec states 30
            if ($$segDataPt =~ /^SPIFF\0/ and $length == 32) {
                $dumpType = 'SPIFF';
                my %dirInfo = (
                    DataPt => $segDataPt,
                    DataPos  => $segPos,
                    DirStart => 6,
                    DirLen => $length - 6,
                );
                my $tagTablePtr = GetTagTable('Image::ExifTool::JPEG::SPIFF');
                $self->ProcessDirectory(\%dirInfo, $tagTablePtr);
            }
        } elsif ($marker == 0xea) {         # APP10 (PhotoStudio Unicode comments)
            if ($$segDataPt =~ /^UNICODE\0/) {
                $dumpType = 'PhotoStudio';
                my $comment = $self->Decode(substr($$segDataPt,8), 'UCS2', 'MM');
                $self->FoundTag('Comment', $comment);
            }
        } elsif ($marker == 0xec) {         # APP12 (Ducky, Picture Info)
            if ($$segDataPt =~ /^Ducky/) {
                $dumpType = 'Ducky';
                my %dirInfo = (
                    DataPt => $segDataPt,
                    DataPos => $segPos,
                    DirStart => 5,
                    DirLen => $length - 5,
                );
                my $tagTablePtr = GetTagTable('Image::ExifTool::APP12::Ducky');
                $self->ProcessDirectory(\%dirInfo, $tagTablePtr);
            } else {
                my %dirInfo = ( DataPt => $segDataPt );
                my $tagTablePtr = GetTagTable('Image::ExifTool::APP12::PictureInfo');
                $self->ProcessDirectory(\%dirInfo, $tagTablePtr) and $dumpType = 'Picture Info';
            }
        } elsif ($marker == 0xed) {         # APP13 (Photoshop, Adobe_CM)
            my $isOld;
            if ($$segDataPt =~ /^$psAPP13hdr/ or ($$segDataPt =~ /^$psAPP13old/ and $isOld=1)) {
                $dumpType = 'Photoshop';
                # add this data to the combined data if it exists
                my $dataPt = $segDataPt;
                if (defined $combinedSegData) {
                    $combinedSegData .= substr($$segDataPt,length($psAPP13hdr));
                    $dataPt = \$combinedSegData;
                }
                # peek ahead to see if the next segment is photoshop data too
                if ($nextMarker == $marker and $$nextSegDataPt =~ /^$psAPP13hdr/) {
                    # initialize combined data if necessary
                    $combinedSegData = $$segDataPt unless defined $combinedSegData;
                    # (will handle the Photoshop data the next time around)
                } else {
                    my $hdrlen = $isOld ? 27 : 14;
                    # process APP13 Photoshop record
                    my $tagTablePtr = GetTagTable('Image::ExifTool::Photoshop::Main');
                    my %dirInfo = (
                        DataPt   => $dataPt,
                        DataPos  => $segPos,
                        DataLen  => length $$dataPt,
                        DirStart => $hdrlen,    # directory starts after identifier
                        DirLen   => length($$dataPt) - $hdrlen,
                        Parent   => $markerName,
                    );
                    $self->ProcessDirectory(\%dirInfo, $tagTablePtr);
                    undef $combinedSegData;
                }
            } elsif ($$segDataPt =~ /^Adobe_CM/) {
                $dumpType = 'Adobe_CM';
                SetByteOrder('MM');
                my $tagTablePtr = GetTagTable('Image::ExifTool::JPEG::AdobeCM');
                my %dirInfo = (
                    DataPt   => $segDataPt,
                    DataPos  => $segPos,
                    DirStart => 8,
                    DirLen   => $length - 8,
                );
                $self->ProcessDirectory(\%dirInfo, $tagTablePtr);
            }
        } elsif ($marker == 0xee) {         # APP14 (Adobe)
            if ($$segDataPt =~ /^Adobe/) {
                $dumpType = 'Adobe';
                SetByteOrder('MM');
                my $tagTablePtr = GetTagTable('Image::ExifTool::JPEG::Adobe');
                my %dirInfo = (
                    DataPt   => $segDataPt,
                    DataPos  => $segPos,
                    DirStart => 5,
                    DirLen   => $length - 5,
                );
                $self->ProcessDirectory(\%dirInfo, $tagTablePtr);
            }
        } elsif ($marker == 0xef) {         # APP15 (GraphicConverter)
            if ($$segDataPt =~ /^Q\s*(\d+)/ and $length == 4) {
                $dumpType = 'GraphicConverter';
                my $tagTablePtr = GetTagTable('Image::ExifTool::JPEG::GraphConv');
                $self->HandleTag($tagTablePtr, 'Q', $1);
            }
        } elsif ($marker == 0xfe) {         # COM (JPEG comment)
            $dumpType = 'Comment';
            $$segDataPt =~ s/\0+$//;    # some dumb softwares add null terminators
            $self->FoundTag('Comment', $$segDataPt);
        } elsif (($marker & 0xf0) != 0xe0) {
            undef $dumpType;    # only dump unknown APP segments
        }
        if (defined $dumpType) {
            if (not $dumpType and $self->{OPTIONS}{Unknown}) {
                $self->Warn("Unknown $markerName segment", 1);
            }
            if ($htmlDump) {
                my $desc = $markerName . ($dumpType ? " $dumpType" : '') . ' segment';
                $self->HDump($segPos-4, $length+4, $desc, undef, 0x08);
                $dumpEnd = $segPos + $length;
            }
        }
        undef $$segDataPt;
    }
    # calculate JPEGDigest if requested
    if (@dqt and $subSampling) {
        require Image::ExifTool::JPEGDigest;
        Image::ExifTool::JPEGDigest::Calculate($self, \@dqt, $subSampling);
    }
    $self->Warn('Error reading PreviewImage', 1) if $$self{PreviewError};
    $self->Warn('Invalid extended XMP') if %extendedXMP;
    $success or $self->Warn('JPEG format error');
    pop @$path if @$path > $pn;
    return 1;
}

#------------------------------------------------------------------------------
# Process EXIF file
# Inputs/Returns: same as ProcessTIFF
sub ProcessEXIF($$;$)
{
    my ($self, $dirInfo, $tagTablePtr) = @_;
    return $self->ProcessTIFF($dirInfo, $tagTablePtr);
}

#------------------------------------------------------------------------------
# Process TIFF data (wrapper for DoProcessTIFF to allow re-entry)
# Inputs: 0) ExifTool object ref, 1) dirInfo ref, 2) optional tag table ref
# Returns: 1 if this looked like a valid EXIF block, 0 otherwise, or -1 on write error
sub ProcessTIFF($$;$)
{
    my ($self, $dirInfo, $tagTablePtr) = @_;
    my $exifData = $$self{EXIF_DATA};
    my $exifPos = $$self{EXIF_POS};
    my $rtnVal = $self->DoProcessTIFF($dirInfo, $tagTablePtr);
    # restore original EXIF information (in case ProcessTIFF is nested)
    if (defined $exifData) {
        $$self{EXIF_DATA} = $exifData;
        $$self{EXIF_POS} = $exifPos;
    }
    return $rtnVal;
}

#------------------------------------------------------------------------------
# Process TIFF data
# Inputs: 0) ExifTool object ref, 1) dirInfo ref, 2) optional tag table ref
# Returns: 1 if this looked like a valid EXIF block, 0 otherwise, or -1 on write error
sub DoProcessTIFF($$;$)
{
    my ($self, $dirInfo, $tagTablePtr) = @_;
    my $dataPt = $$dirInfo{DataPt};
    my $fileType = $$dirInfo{Parent} || '';
    my $raf = $$dirInfo{RAF};
    my $base = $$dirInfo{Base} || 0;
    my $outfile = $$dirInfo{OutFile};
    my ($err, $canonSig, $otherSig);

    # attempt to read TIFF header
    $self->{EXIF_DATA} = '';
    if ($raf) {
        if ($outfile) {
            $raf->Seek(0, 0) or return 0;
            if ($base) {
                $raf->Read($$dataPt, $base) == $base or return 0;
                Write($outfile, $$dataPt) or $err = 1;
            }
        } else {
            $raf->Seek($base, 0) or return 0;
        }
        # extract full EXIF block (for block copy) from EXIF file
        my $amount = $fileType eq 'EXIF' ? 65536 * 8 : 8;
        my $n = $raf->Read($self->{EXIF_DATA}, $amount);
        if ($n < 8) {
            return 0 if $n or not $outfile or $fileType ne 'EXIF';
            # create EXIF file from scratch
            delete $self->{EXIF_DATA};
            undef $raf;
        }
        if ($n > 8) {
            $raf->Seek(8, 0);
            if ($n == $amount) {
                $self->{EXIF_DATA} = substr($self->{EXIF_DATA}, 0, 8);
                $self->Warn('EXIF too large to extract as a block'); #(shouldn't happen)
            }
        }
    } elsif ($dataPt and length $$dataPt) {
        # save a copy of the EXIF data
        my $dirStart = $$dirInfo{DirStart} || 0;
        my $dirLen = $$dirInfo{DirLen} || (length($$dataPt) - $dirStart);
        $self->{EXIF_DATA} = substr($$dataPt, $dirStart, $dirLen);
        $self->VerboseDir('TIFF') if $self->{OPTIONS}{Verbose} and length($$self{INDENT}) > 2;
    } elsif ($outfile) {
        delete $self->{EXIF_DATA};  # create from scratch
    } else {
        $self->{EXIF_DATA} = '';
    }
    unless (defined $self->{EXIF_DATA}) {
        # create TIFF information from scratch
        if ($self->SetPreferredByteOrder() eq 'MM') {
            $self->{EXIF_DATA} = "MM\0\x2a\0\0\0\x08";
        } else {
            $self->{EXIF_DATA} = "II\x2a\0\x08\0\0\0";
        }
    }
    $$self{FIRST_EXIF_POS} = $base + $$self{BASE} unless defined $$self{FIRST_EXIF_POS};
    $$self{EXIF_POS} = $base + $$self{BASE};
    $dataPt = \$self->{EXIF_DATA};

    # set byte ordering
    my $byteOrder = substr($$dataPt,0,2);
    SetByteOrder($byteOrder) or return 0;

    # verify the byte ordering
    my $identifier = Get16u($dataPt, 2);
    # identifier is 0x2a for TIFF (but 0x4f52, 0x5352 or ?? for ORF)
  # no longer do this because various files use different values
  # (TIFF=0x2a, RW2/RWL=0x55, HDP=0xbc, BTF=0x2b, ORF=0x4f52/0x5352/0x????)
  #  return 0 unless $identifier == 0x2a;

    # get offset to IFD0
    my $offset = Get32u($dataPt, 4);
    $offset >= 8 or return 0;

    if ($raf) {
        # Canon CR2 images usually have an offset of 16, but it may be
        # greater if edited by PhotoMechanic, so check the 4-byte signature
        if ($identifier == 0x2a and $offset >= 16) {
            $raf->Read($canonSig, 8) == 8 or return 0;
            $$dataPt .= $canonSig;
            if ($canonSig =~ /^(CR\x02\0|\xba\xb0\xac\xbb)/) {
                $fileType = $canonSig =~ /^CR/ ? 'CR2' : 'Canon 1D RAW';
                $self->HDump($base+8, 8, "[$fileType header]") if $self->{HTML_DUMP};
            } else {
                undef $canonSig;
            }
        } elsif ($identifier == 0x55 and $fileType =~ /^(RAW|RW2|RWL|TIFF)$/) {
            # panasonic RAW, RW2 or RWL file
            my $magic;
            # test for RW2/RWL magic number
            if ($offset >= 0x18 and $raf->Read($magic, 16) and
                $magic eq "\x88\xe7\x74\xd8\xf8\x25\x1d\x4d\x94\x7a\x6e\x77\x82\x2b\x5d\x6a")
            {
                $fileType = 'RW2' unless $fileType eq 'RWL';
                $self->HDump($base + 8, 16, '[RW2/RWL header]') if $$self{HTML_DUMP};
                $otherSig = $magic; # save signature for writing
            } else {
                $fileType = 'RAW';
            }
            $tagTablePtr = GetTagTable('Image::ExifTool::PanasonicRaw::Main');
        } elsif ($identifier == 0x2b and $fileType eq 'TIFF') {
            # this looks like a BigTIFF image
            $raf->Seek(0);
            require Image::ExifTool::BigTIFF;
            return 1 if Image::ExifTool::BigTIFF::ProcessBTF($self, $dirInfo);
        } elsif (Get8u($dataPt, 2) == 0xbc and $byteOrder eq 'II' and $fileType eq 'TIFF') {
            $fileType = 'HDP';  # Windows HD Photo file
            # check version number
            my $ver = Get8u($dataPt, 3);
            if ($ver > 1) {
                $self->Error("Windows HD Photo version $ver files not yet supported");
                return 1;
            }
        } elsif ($identifier == 0x4352 and $fileType eq 'TIFF') {
            $fileType = 'DCP';
        }
        # we have a valid TIFF (or whatever) file
        if ($fileType and not $self->{VALUE}{FileType}) {
            my $lookup = $fileTypeLookup{$fileType};
            $lookup = $fileTypeLookup{$lookup} unless ref $lookup or not $lookup;
            # use file extension to pre-determine type if extension is TIFF-based or type is RAW
            my $t = (($lookup and $$lookup[0] eq 'TIFF') or $fileType =~ /RAW/) ? $fileType : undef;
            $self->SetFileType($t);
        }
    }
    my $ifdName = 'IFD0';
    if (not $tagTablePtr or $$tagTablePtr{GROUPS}{0} eq 'EXIF') {
        $self->FoundTag('ExifByteOrder', $byteOrder);
    } else {
        $ifdName = $$tagTablePtr{GROUPS}{1};
    }
    if ($self->{HTML_DUMP}) {
        my $tip = sprintf("Byte order: %s endian\nIdentifier: 0x%.4x\n$ifdName offset: 0x%.4x",
                          ($byteOrder eq 'II') ? 'Little' : 'Big', $identifier, $offset);
        $self->HDump($base, 8, 'TIFF header', $tip, 0);
    }
    # remember where we found the TIFF data (APP1, APP3, TIFF, NEF, etc...)
    $self->{TIFF_TYPE} = $fileType;

    # get reference to the main EXIF table
    $tagTablePtr or $tagTablePtr = GetTagTable('Image::ExifTool::Exif::Main');

    # build directory information hash
    my %dirInfo = (
        Base     => $base,
        DataPt   => $dataPt,
        DataLen  => length $$dataPt,
        DataPos  => 0,
        DirStart => $offset,
        DirLen   => length($$dataPt) - $offset,
        RAF      => $raf,
        DirName  => $ifdName,
        Parent   => $fileType,
        ImageData=> 'Main', # set flag to get information to copy main image data later
        Multi    => $$dirInfo{Multi},
    );

    # extract information from the image
    unless ($outfile) {
        # process the directory
        $self->ProcessDirectory(\%dirInfo, $tagTablePtr);
        # process GeoTiff information if available
        if ($self->{VALUE}{GeoTiffDirectory}) {
            require Image::ExifTool::GeoTiff;
            Image::ExifTool::GeoTiff::ProcessGeoTiff($self);
        }
        # process information in recognized trailers
        if ($raf) {
            my $trailInfo = IdentifyTrailer($raf);
            if ($trailInfo) {
                $$trailInfo{ScanForAFCP} = 1;   # scan to find AFCP if necessary
                $self->ProcessTrailers($trailInfo);
            }
            # dump any other known trailer (ie. A100 RAW Data)
            if ($$self{HTML_DUMP} and $$self{KnownTrailer}) {
                my $known = $$self{KnownTrailer};
                $raf->Seek(0, 2);
                my $len = $raf->Tell() - $$known{Start};
                $len -= $$trailInfo{Offset} if $trailInfo;  # account for other trailers
                $self->HDump($$known{Start}, $len, "[$$known{Name}]") if $len > 0;
           }
        }
        # update FileType if necessary now that we know more about the file
        if ($$self{DNGVersion} and $self->{VALUE}{FileType} ne 'DNG') {
            # override whatever FileType we set since we now know it is DNG
            $self->OverrideFileType('DNG');
        }
        return 1;
    }
#
# rewrite the image
#
    if ($$dirInfo{NoTiffEnd}) {
        delete $self->{TIFF_END};
    } else {
        # initialize TIFF_END so it will be updated by WriteExif()
        $self->{TIFF_END} = 0;
    }
    if ($canonSig) {
        # write Canon CR2 specially because it has a header we want to preserve,
        # and possibly trailers added by the Canon utilities and/or PhotoMechanic
        $dirInfo{OutFile} = $outfile;
        require Image::ExifTool::CanonRaw;
        Image::ExifTool::CanonRaw::WriteCR2($self, \%dirInfo, $tagTablePtr) or $err = 1;
    } else {
        # write TIFF header (8 bytes [plus optional signature] followed by IFD)
        $otherSig = '' unless defined $otherSig;
        my $offset = 8 + length($otherSig);
        # construct tiff header
        my $header = substr($$dataPt, 0, 4) . Set32u($offset) . $otherSig;
        $dirInfo{NewDataPos} = $offset;
        $dirInfo{HeaderPtr} = \$header;
        # preserve padding between image data blocks in ORF images
        # (otherwise dcraw has problems because it assumes fixed block spacing)
        $dirInfo{PreserveImagePadding} = 1 if $fileType eq 'ORF' or $identifier != 0x2a;
        my $newData = $self->WriteDirectory(\%dirInfo, $tagTablePtr);
        if (not defined $newData) {
            $err = 1;
        } elsif (length($newData)) {
            # update header length in case more was added
            my $hdrLen = length $header;
            if ($hdrLen != 8) {
                Set32u($hdrLen, \$header, 4);
                # also update preview fixup if necessary
                my $pi = $$self{PREVIEW_INFO};
                $$pi{Fixup}{Start} += $hdrLen - 8 if $pi and $$pi{Fixup};
            }
            if ($$self{TIFF_TYPE} eq 'ARW' and not $err) {
                # write any required ARW trailer and patch other ARW quirks
                require Image::ExifTool::Sony;
                my $errStr = Image::ExifTool::Sony::FinishARW($self, $dirInfo, \$newData, 
                                                              $dirInfo{ImageData});
                $errStr and $self->Error($errStr);
                delete $dirInfo{ImageData}; # (was copied by FinishARW)
            } else {
                Write($outfile, $header, $newData) or $err = 1;
            }
            undef $newData; # free memory
        }
        # copy over image data now if necessary
        if (ref $dirInfo{ImageData} and not $err) {
            $self->CopyImageData($dirInfo{ImageData}, $outfile) or $err = 1;
            delete $dirInfo{ImageData};
        }
    }
    # make local copy of TIFF_END now (it may be reset when processing trailers)
    my $tiffEnd = $self->{TIFF_END};
    delete $self->{TIFF_END};

    # rewrite trailers if they exist
    if ($raf and $tiffEnd and not $err) {
        my ($buf, $trailInfo);
        $raf->Seek(0, 2) or $err = 1;
        my $extra = $raf->Tell() - $tiffEnd;
        # check for trailer and process if possible
        for (;;) {
            last unless $extra > 12;
            $raf->Seek($tiffEnd);  # seek back to end of image
            $trailInfo = IdentifyTrailer($raf);
            last unless $trailInfo;
            my $tbuf = '';
            $$trailInfo{OutFile} = \$tbuf;  # rewrite trailer(s)
            $$trailInfo{ScanForAFCP} = 1;   # scan for AFCP if necessary
            # rewrite all trailers to buffer
            unless ($self->ProcessTrailers($trailInfo)) {
                undef $trailInfo;
                $err = 1;
                last;
            }
            # calculate unused bytes before trailer
            $extra = $$trailInfo{DataPos} - $tiffEnd;
            last; # yes, the 'for' loop was just a cheap 'goto'
        }
        # ignore a single zero byte if used for padding
        if ($extra > 0 and $tiffEnd & 0x01) {
            $raf->Seek($tiffEnd, 0) or $err = 1;
            $raf->Read($buf, 1) or $err = 1;
            defined $buf and $buf eq "\0" and --$extra, ++$tiffEnd;
        }
        if ($extra > 0) {
            my $known = $$self{KnownTrailer};
            if ($self->{DEL_GROUP}{Trailer} and not $known) {
                $self->VPrint(0, "  Deleting unknown trailer ($extra bytes)\n");
                ++$self->{CHANGED};
            } elsif ($known) {
                $self->VPrint(0, "  Copying $$known{Name} ($extra bytes)\n");
                $raf->Seek($tiffEnd, 0) or $err = 1;
                CopyBlock($raf, $outfile, $extra) or $err = 1;
            } else {
                $raf->Seek($tiffEnd, 0) or $err = 1;
                # preserve unknown trailer only if it contains non-null data
                # (Photoshop CS adds a trailer with 2 null bytes)
                my $size = $extra;
                for (;;) {
                    my $n = $size > 65536 ? 65536 : $size;
                    $raf->Read($buf, $n) == $n or $err = 1, last;
                    if ($buf =~ /[^\0]/) {
                        $self->VPrint(0, "  Preserving unknown trailer ($extra bytes)\n");
                        # copy the trailer since it contains non-null data
                        Write($outfile, "\0"x($extra-$size)) or $err = 1, last if $size != $extra;
                        Write($outfile, $buf) or $err = 1, last;
                        CopyBlock($raf, $outfile, $size-$n) or $err = 1 if $size > $n;
                        last;
                    }
                    $size -= $n;
                    next if $size > 0;
                    $self->VPrint(0, "  Deleting blank trailer ($extra bytes)\n");
                    last;
                }
            }
        }
        # write trailer buffer if necessary
        $self->WriteTrailerBuffer($trailInfo, $outfile) or $err = 1 if $trailInfo;
        # add any new trailers we are creating
        my $trailPt = $self->AddNewTrailers();
        Write($outfile, $$trailPt) or $err = 1 if $trailPt;
    }
    # check DNG version
    if ($$self{DNGVersion}) {
        my $ver = $$self{DNGVersion};
        # currently support up to DNG version 1.2
        unless ($ver =~ /^(\d+) (\d+)/ and "$1.$2" <= 1.3) {
            $ver =~ tr/ /./;
            $self->Error("DNG Version $ver not yet supported", 1);
        }
    }
    return $err ? -1 : 1;
}

#------------------------------------------------------------------------------
# Return list of tag table keys (ignoring special keys)
# Inputs: 0) reference to tag table
# Returns: List of table keys (unsorted)
sub TagTableKeys($)
{
    local $_;
    my $tagTablePtr = shift;
    my @keyList;
    foreach (keys %$tagTablePtr) {
        push(@keyList, $_) unless $specialTags{$_};
    }
    return @keyList;
}

#------------------------------------------------------------------------------
# GetTagTable
# Inputs: 0) table name
# Returns: tag table reference, or undefined if not found
# Notes: Always use this function instead of requiring module and using table
# directly since this function also does the following the first time the table
# is loaded:
# - requires new module if necessary
# - generates default GROUPS hash and Group 0 name from module name
# - registers Composite tags if Composite table found
# - saves descriptions for tags in specified table
# - generates default TAG_PREFIX to be used for unknown tags
sub GetTagTable($)
{
    my $tableName = shift or return undef;
    my $table = $allTables{$tableName};

    unless ($table) {
        no strict 'refs';
        unless (%$tableName) {
            # try to load module for this table
            if ($tableName =~ /(.*)::/) {
                my $module = $1;
                if (eval "require $module") {
                    # load additional XMP modules if required
                    if (not %$tableName and $module eq 'Image::ExifTool::XMP') {
                        require 'Image/ExifTool/XMP2.pl';
                    }
                } else {
                    $@ and warn $@;
                }
            }
            unless (%$tableName) {
                warn "Can't find table $tableName\n";
                return undef;
            }
        }
        no strict 'refs';
        $table = \%$tableName;
        use strict 'refs';
        $$table{TABLE_NAME} = $tableName;   # set table name
        ($$table{SHORT_NAME} = $tableName) =~ s/^Image::ExifTool:://;
        # set default group 0 and 1 from module name unless already specified
        my $defaultGroups = $$table{GROUPS};
        $defaultGroups or $defaultGroups = $$table{GROUPS} = { };
        unless ($$defaultGroups{0} and $$defaultGroups{1}) {
            if ($tableName =~ /Image::.*?::([^:]*)/) {
                $$defaultGroups{0} = $1 unless $$defaultGroups{0};
                $$defaultGroups{1} = $1 unless $$defaultGroups{1};
            } else {
                $$defaultGroups{0} = $tableName unless $$defaultGroups{0};
                $$defaultGroups{1} = $tableName unless $$defaultGroups{1};
            }
        }
        $$defaultGroups{2} = 'Other' unless $$defaultGroups{2};
        if ($$defaultGroups{0} eq 'XMP' or $$table{NAMESPACE}) {
            # initialize some XMP table defaults
            require Image::ExifTool::XMP;
            Image::ExifTool::XMP::RegisterNamespace($table); # register all table namespaces
            # set default write/check procs
            $$table{WRITE_PROC} = \&Image::ExifTool::XMP::WriteXMP unless $$table{WRITE_PROC};
            $$table{CHECK_PROC} = \&Image::ExifTool::XMP::CheckXMP unless $$table{CHECK_PROC};
            $$table{LANG_INFO} = \&Image::ExifTool::XMP::GetLangInfo unless $$table{LANG_INFO};
        }
        # generate a tag prefix for unknown tags if necessary
        unless ($$table{TAG_PREFIX}) {
            my $tagPrefix;
            if ($tableName =~ /Image::.*?::(.*)::Main/ || $tableName =~ /Image::.*?::(.*)/) {
                ($tagPrefix = $1) =~ s/::/_/g;
            } else {
                $tagPrefix = $tableName;
            }
            $$table{TAG_PREFIX} = $tagPrefix;
        }
        # set up the new table
        SetupTagTable($table);
        # add any user-defined tags
        if (%UserDefined and $UserDefined{$tableName}) {
            my $tagID;
            foreach $tagID (TagTableKeys($UserDefined{$tableName})) {
                my $tagInfo = $UserDefined{$tableName}{$tagID};
                if (ref $tagInfo eq 'HASH') {
                    $$tagInfo{Name} or $$tagInfo{Name} = ucfirst($tagID);
                } else {
                    $tagInfo = { Name => $tagInfo };
                }
                if ($$table{WRITABLE} and not defined $$tagInfo{Writable} and
                    not $$tagInfo{SubDirectory})
                {
                    $$tagInfo{Writable} = $$table{WRITABLE};
                }
                delete $$table{$tagID}; # replace any existing entry
                AddTagToTable($table, $tagID, $tagInfo);
            }
        }
        # remember order we loaded the tables in
        push @tableOrder, $tableName;
        # insert newly loaded table into list
        $allTables{$tableName} = $table;
    }
    return $table;
}

#------------------------------------------------------------------------------
# Process an image directory
# Inputs: 0) ExifTool object reference, 1) directory information reference
#         2) tag table reference, 3) optional reference to processing procedure
# Returns: Result from processing (1=success)
sub ProcessDirectory($$$;$)
{
    my ($self, $dirInfo, $tagTablePtr, $proc) = @_;

    return 0 unless $tagTablePtr and $dirInfo;
    # use default proc from tag table or EXIF proc as fallback if no proc specified
    $proc or $proc = $$tagTablePtr{PROCESS_PROC} || \&Image::ExifTool::Exif::ProcessExif;
    # set directory name from default group0 name if not done already
    $$dirInfo{DirName} or $$dirInfo{DirName} = $tagTablePtr->{GROUPS}{0};
    # guard against cyclical recursion into the same directory
    if (defined $$dirInfo{DirStart} and defined $$dirInfo{DataPos}) {
        my $addr = $$dirInfo{DirStart} + $$dirInfo{DataPos} + ($$dirInfo{Base}||0);
        if ($self->{PROCESSED}{$addr}) {
            $self->Warn("$$dirInfo{DirName} pointer references previous $self->{PROCESSED}{$addr} directory");
            return 0;
        }
        $self->{PROCESSED}{$addr} = $$dirInfo{DirName};
    }
    my $oldOrder = GetByteOrder();
    my $oldIndent = $self->{INDENT};
    my $oldDir = $self->{DIR_NAME};
    $self->{LIST_TAGS} = { };  # don't build lists across different directories
    $self->{INDENT} .= '| ';
    $self->{DIR_NAME} = $$dirInfo{DirName};
    push @{$self->{PATH}}, $$dirInfo{DirName};

    # process the directory
    my $rtnVal = &$proc($self, $dirInfo, $tagTablePtr);

    pop @{$self->{PATH}};
    $self->{INDENT} = $oldIndent;
    $self->{DIR_NAME} = $oldDir;
    SetByteOrder($oldOrder);
    return $rtnVal;
}

#------------------------------------------------------------------------------
# Get Metadata path
# Inputs: 0) Exiftool object ref
# Return: Metadata path string
sub MetadataPath($)
{
    my $self = shift;
    return join '-', @{$$self{PATH}}
}

#------------------------------------------------------------------------------
# Get standardized file extension
# Inputs: 0) file name
# Returns: standardized extension (all uppercase), or undefined if no extension
sub GetFileExtension($)
{
    my $filename = shift;
    my $fileExt;
    if ($filename and $filename =~ /.*\.(.+)$/) {
        $fileExt = uc($1);   # change extension to upper case
        # convert TIF extension to TIFF because we use the
        # extension for the file type tag of TIFF images
        $fileExt eq 'TIF' and $fileExt = 'TIFF';
    }
    return $fileExt;
}

#------------------------------------------------------------------------------
# Get list of tag information hashes for given tag ID
# Inputs: 0) Tag table reference, 1) tag ID
# Returns: Array of tag information references
# Notes: Generates tagInfo hash if necessary
sub GetTagInfoList($$)
{
    my ($tagTablePtr, $tagID) = @_;
    my $tagInfo = $$tagTablePtr{$tagID};

    if (ref $tagInfo eq 'HASH') {
        return ($tagInfo);
    } elsif (ref $tagInfo eq 'ARRAY') {
        return @$tagInfo;
    } elsif ($tagInfo) {
        # create hash with name
        $tagInfo = $$tagTablePtr{$tagID} = { Name => $tagInfo };
        return ($tagInfo);
    }
    return ();
}

#------------------------------------------------------------------------------
# Find tag information, processing conditional tags
# Inputs: 0) ExifTool object reference, 1) tagTable pointer, 2) tag ID
#         3) optional value reference, 4) optional format type, 5) optional value count
# Returns: pointer to tagInfo hash, undefined if none found, or '' if $valPt needed
# Notes: You should always call this routine to find a tag in a table because
# this routine will evaluate conditional tags.
# Arguments 3-5 are only required if the information type allows $valPt, $format and/or
# $count in a Condition, and if not given when needed this routine returns ''.
sub GetTagInfo($$$;$$$)
{
    my ($self, $tagTablePtr, $tagID) = @_;
    my ($valPt, $format, $count);

    my @infoArray = GetTagInfoList($tagTablePtr, $tagID);
    # evaluate condition
    my $tagInfo;
    foreach $tagInfo (@infoArray) {
        my $condition = $$tagInfo{Condition};
        if ($condition) {
            ($valPt, $format, $count) = splice(@_, 3) if @_ > 3;
            return '' if $condition =~ /\$(valPt|format|count)\b/ and not defined $valPt;
            # set old value for use in condition if needed
            local $SIG{'__WARN__'} = \&SetWarning;
            undef $evalWarning;
            #### eval Condition ($self, [$valPt, $format, $count])
            unless (eval $condition) {
                $@ and $evalWarning = $@;
                $self->Warn("Condition $$tagInfo{Name}: " . CleanWarning()) if $evalWarning;
                next;
            }
        }
        if ($$tagInfo{Unknown} and not $$self{OPTIONS}{Unknown} and not $$self{OPTIONS}{Verbose}) {
            # don't return Unknown tags unless that option is set
            return undef;
        }
        # return the tag information we found
        return $tagInfo;
    }
    # generate information for unknown tags (numerical only) if required
    if (not $tagInfo and ($$self{OPTIONS}{Unknown} or $$self{OPTIONS}{Verbose}) and
        $tagID =~ /^\d+$/ and not $$self{NO_UNKNOWN})
    {
        my $printConv;
        if (defined $$tagTablePtr{PRINT_CONV}) {
            $printConv = $$tagTablePtr{PRINT_CONV};
        } else {
            # limit length of printout (can be very long)
            $printConv = 'length($val) > 60 ? substr($val,0,55) . "[...]" : $val';
        }
        my $hex = sprintf("0x%.4x", $tagID);
        my $prefix = $$tagTablePtr{TAG_PREFIX};
        $tagInfo = {
            Name => "${prefix}_$hex",
            Description => MakeDescription($prefix, $hex),
            Unknown => 1,
            Writable => 0,  # can't write unknown tags
            PrintConv => $printConv,
        };
        # add tag information to table
        AddTagToTable($tagTablePtr, $tagID, $tagInfo);
    } else {
        undef $tagInfo;
    }
    return $tagInfo;
}

#------------------------------------------------------------------------------
# Add new tag to table (must use this routine to add new tags to a table)
# Inputs: 0) reference to tag table, 1) tag ID
#         2) [optional] reference to tag information hash
# Notes: - will not overwrite existing entry in table
# - info need contain no entries when this routine is called
sub AddTagToTable($$;$)
{
    my ($tagTablePtr, $tagID, $tagInfo) = @_;
    $tagInfo or $tagInfo = { };

    # define necessary entries in information hash
    if ($$tagInfo{Groups}) {
        # fill in default groups from table GROUPS
        foreach (keys %{$$tagTablePtr{GROUPS}}) {
            next if $tagInfo->{Groups}{$_};
            $tagInfo->{Groups}{$_} = $tagTablePtr->{GROUPS}{$_};
        }
    } else {
        $$tagInfo{Groups} = { %{$$tagTablePtr{GROUPS}} };
    }
    $$tagInfo{Flags} and ExpandFlags($tagInfo);
    $$tagInfo{GotGroups} = 1,
    $$tagInfo{Table} = $tagTablePtr;
    $$tagInfo{TagID} = $tagID;

    my $name = $$tagInfo{Name};
    if (defined $name) {
        $name =~ tr/-_a-zA-Z0-9//dc;    # remove illegal characters
    } else {
        # construct a name from the tag ID
        $name = $tagID;
        $name =~ tr/-_a-zA-Z0-9//dc;    # remove illegal characters
        $name = ucfirst $name;          # start with uppercase
        # make sure name is a reasonable length
        my $prefix = $$tagTablePtr{TAG_PREFIX};
        if ($prefix) {
            # make description to prevent tagID from getting mangled by MakeDescription()
            $$tagInfo{Description} = MakeDescription($prefix, $name);
            $name = "${prefix}_$name";
        }
    }
    # tag names must be at least 2 characters long and begin with a letter
    $name = "Tag$name" if length($name) <= 1 or $name !~ /^[A-Z]/i;
    $$tagInfo{Name} = $name;
    # add tag to table, but never overwrite existing entries (could potentially happen
    # if someone thinks there isn't any tagInfo because a condition wasn't satisfied)
    $$tagTablePtr{$tagID} = $tagInfo unless defined $$tagTablePtr{$tagID};
}

#------------------------------------------------------------------------------
# Handle simple extraction of new tag information
# Inputs: 0) ExifTool object ref, 1) tag table reference, 2) tagID, 3) value,
#         4-N) parameters hash: Index, DataPt, DataPos, Start, Size, Parent,
#              TagInfo, ProcessProc, RAF
# Returns: tag key or undef if tag not found
# Notes: if value is not defined, it is extracted from DataPt using TagInfo
#        Format and Count if provided
sub HandleTag($$$$;%)
{
    my ($self, $tagTablePtr, $tag, $val, %parms) = @_;
    my $verbose = $self->{OPTIONS}{Verbose};
    my $tagInfo = $parms{TagInfo} || $self->GetTagInfo($tagTablePtr, $tag, \$val);
    my $dataPt = $parms{DataPt};
    my ($subdir, $format, $count, $size, $noTagInfo);

    if ($tagInfo) {
        $subdir = $$tagInfo{SubDirectory}
    } else {
        return undef unless $verbose;
        $tagInfo = { Name => "tag $tag" };  # create temporary tagInfo hash
        $noTagInfo = 1;
    }
    # read value if not done already (not necessary for subdir)
    unless (defined $val or ($subdir and not $$tagInfo{Writable})) {
        my $start = $parms{Start} || 0;
        my $size = $parms{Size} || 0;
        # read from data in memory if possible
        if ($dataPt and $start >= 0 and $start + $size <= length($$dataPt)) {
            $format = $$tagInfo{Format} || $$tagTablePtr{FORMAT};
            if ($format) {
                $val = ReadValue($dataPt, $start, $format, $$tagInfo{Count}, $size);
            } else {
                $val = substr($$dataPt, $start, $size);
            }
        } else {
            $self->Warn("Error extracting value for $$tagInfo{Name}");
            return undef;
        }
    }
    # do verbose print if necessary
    if ($verbose) {
        undef $tagInfo if $noTagInfo;
        $parms{Value} = $val;
        $parms{Table} = $tagTablePtr;
        if ($format) {
            $count or $count = int(($parms{Size} || 0) / ($formatSize{$format} || 1));
            $parms{Format} = $format . "[$count]";
        }
        $self->VerboseInfo($tag, $tagInfo, %parms);
    }
    if ($tagInfo) {
        if ($subdir) {
            my $subdirStart = $parms{Start};
            my $subdirLen = $parms{Size};
            if ($$subdir{Start}) {
                my $valuePtr = 0;
                #### eval Start ($valuePtr)
                my $off = eval $$subdir{Start};                
                $subdirStart += $off;
                $subdirLen -= $off;
            }
            $dataPt or $dataPt = \$val;
            # process subdirectory information
            my %dirInfo = (
                DirName  => $$subdir{DirName} || $$tagInfo{Name},
                DataPt   => $dataPt,
                DataLen  => length $$dataPt,
                DataPos  => $parms{DataPos},
                DirStart => $subdirStart,
                DirLen   => $subdirLen,
                Parent   => $parms{Parent},
                Base     => $parms{Base},
                Multi    => $$subdir{Multi},
                TagInfo  => $tagInfo,
                RAF      => $parms{RAF},
            );
            my $oldOrder = GetByteOrder();
            SetByteOrder($$subdir{ByteOrder}) if $$subdir{ByteOrder};
            my $subTablePtr = GetTagTable($$subdir{TagTable}) || $tagTablePtr;
            $self->ProcessDirectory(\%dirInfo, $subTablePtr, $$subdir{ProcessProc} || $parms{ProcessProc});
            SetByteOrder($oldOrder);
            # return now unless directory is writable as a block
            return undef unless $$tagInfo{Writable};
        }
        return $self->FoundTag($tagInfo, $val);
    }
    return undef;
}

#------------------------------------------------------------------------------
# Add tag to hash of extracted information
# Inputs: 0) ExifTool object reference
#         1) reference to tagInfo hash or tag name
#         2) data value (or reference to require hash if Composite)
# Returns: tag key or undef if no value
sub FoundTag($$$)
{
    local $_;
    my ($self, $tagInfo, $value) = @_;
    my $tag;

    if (ref $tagInfo eq 'HASH') {
        $tag = $$tagInfo{Name} or warn("No tag name\n"), return undef;
    } else {
        $tag = $tagInfo;
        # look for tag in Extra
        $tagInfo = $self->GetTagInfo(GetTagTable('Image::ExifTool::Extra'), $tag);
        # make temporary hash if tag doesn't exist in Extra
        # (not advised to do this since the tag won't show in list)
        $tagInfo or $tagInfo = { Name => $tag, Groups => \%allGroupsExifTool };
        $self->{OPTIONS}{Verbose} and $self->VerboseInfo(undef, $tagInfo, Value => $value);
    }
    my $rawValueHash = $self->{VALUE};
    if ($$tagInfo{RawConv}) {
        # initialize @val for use in Composite RawConv expressions
        my @val;
        if (ref $value eq 'HASH') {
            foreach (keys %$value) { $val[$_] = $$rawValueHash{$$value{$_}}; }
        }
        my $conv = $$tagInfo{RawConv};
        local $SIG{'__WARN__'} = \&SetWarning;
        undef $evalWarning;
        if (ref $conv eq 'CODE') {
            $value = &$conv($value, $self);
        } else {
            my $val = $value;   # must do this in case eval references $val
            # NOTE: RawConv is also evaluated in Writer.pl
            #### eval RawConv ($self, $val, $tag)
            $value = eval $conv;
            $@ and $evalWarning = $@;
        }
        $self->Warn("RawConv $tag: " . CleanWarning()) if $evalWarning;
        return undef unless defined $value;
    }
    # get tag priority
    my $priority = $$tagInfo{Priority};
    defined $priority or $priority = $tagInfo->{Table}{PRIORITY};
    # handle duplicate tag names
    if (defined $$rawValueHash{$tag}) {
        # add to list if there is an active list for this tag
        if ($self->{LIST_TAGS}{$tagInfo}) {
            $tag = $self->{LIST_TAGS}{$tagInfo};  # use key from previous list tag
            if (ref $$rawValueHash{$tag} ne 'ARRAY') {
                $$rawValueHash{$tag} = [ $$rawValueHash{$tag} ];
            }
            push @{$$rawValueHash{$tag}}, $value;
            return $tag;    # return without creating a new entry
        }
        # get next available tag key
        my $nextInd = $self->{DUPL_TAG}{$tag} = ($self->{DUPL_TAG}{$tag} || 0) + 1;
        my $nextTag = "$tag ($nextInd)";
#
# take tag with highest priority
#
        # promote existing 0-priority tag so it takes precedence over a new 0-tag
        # (unless old tag was a sub-document and new tag isn't)
        my $oldPriority = $self->{PRIORITY}{$tag};
        unless ($oldPriority) {
            if ($self->{DOC_NUM} or not $self->{TAG_EXTRA}{$tag} or
                                    not $self->{TAG_EXTRA}{$tag}{G3})
            {
                $oldPriority = 1;
            } else {
                $oldPriority = 0; # don't promote sub-document tag over main document
            }
        }
        # set priority for this tag
        if (defined $priority) {
            # increase 0-priority tags if this is the priority directory
            $priority = 1 if not $priority and $$self{DIR_NAME} and
                             $$self{DIR_NAME} eq $$self{PRIORITY_DIR};
        } elsif ($$self{DIR_NAME} and $$self{LOW_PRIORITY_DIR}{$$self{DIR_NAME}}) {
            $priority = 0;  # default is 0 for a LOW_PRIORITY_DIR
        } else {
            $priority = 1;  # the normal default
        }
        if ($priority >= $oldPriority and not $self->{DOC_NUM}) {
            # move existing tag out of the way since this tag is higher priority
            $self->{MOVED_KEY} = $nextTag;  # used in BuildCompositeTags()
            $self->{PRIORITY}{$nextTag} = $self->{PRIORITY}{$tag};
            $$rawValueHash{$nextTag} = $$rawValueHash{$tag};
            $self->{FILE_ORDER}{$nextTag} = $self->{FILE_ORDER}{$tag};
            my $oldInfo = $self->{TAG_INFO}{$nextTag} = $self->{TAG_INFO}{$tag};
            if ($self->{TAG_EXTRA}{$tag}) {
                $self->{TAG_EXTRA}{$nextTag} = $self->{TAG_EXTRA}{$tag};
                delete $self->{TAG_EXTRA}{$tag};
            }
            # update tag key for list if necessary
            $self->{LIST_TAGS}{$oldInfo} = $nextTag if $self->{LIST_TAGS}{$oldInfo};
        } else {
            $tag = $nextTag;        # don't override the existing tag
        }
        $self->{PRIORITY}{$tag} = $priority;
    } elsif ($priority) {
        # set tag priority (only if exists and non-zero)
        $self->{PRIORITY}{$tag} = $priority;
    }

    # save the raw value, file order, tagInfo ref, group1 name,
    # and tag key for lists if necessary
    $$rawValueHash{$tag} = $value;
    $self->{FILE_ORDER}{$tag} = ++$self->{NUM_FOUND};
    $self->{TAG_INFO}{$tag} = $tagInfo;
    # set dynamic groups 1 and 3 if necessary
    $self->{TAG_EXTRA}{$tag}{G1} = $self->{SET_GROUP1} if $self->{SET_GROUP1};
    if ($self->{DOC_NUM}) {
        $self->{TAG_EXTRA}{$tag}{G3} = $self->{DOC_NUM};
        if ($self->{DOC_NUM} =~ /^(\d+)/) {
            # keep track of maximum 1st-level sub-document number
            $self->{DOC_COUNT} = $1 unless $self->{DOC_COUNT} >= $1;
        }
    }
    # save path if requested
    $self->{TAG_EXTRA}{$tag}{G5} = $self->MetadataPath() if $self->{OPTIONS}{SavePath};

    # remember this tagInfo if we will be accumulating values in a list
    $self->{LIST_TAGS}{$tagInfo} = $tag if $$tagInfo{List} and not $$self{NO_LIST};

    return $tag;
}

#------------------------------------------------------------------------------
# Make current directory the priority directory if not set already
# Inputs: 0) ExifTool object reference
sub SetPriorityDir($)
{
    my $self = shift;
    $self->{PRIORITY_DIR} = $self->{DIR_NAME} unless $self->{PRIORITY_DIR};
}

#------------------------------------------------------------------------------
# Set family 0 or 1 group name specific to this tag instance
# Inputs: 0) ExifTool ref, 1) tag key, 2) group name, 3) family (default 1)
sub SetGroup($$$;$)
{
    my ($self, $tagKey, $extra, $fam) = @_;
    $self->{TAG_EXTRA}{$tagKey}{defined $fam ? "G$fam" : 'G1'} = $extra;
}

#------------------------------------------------------------------------------
# Delete specified tag
# Inputs: 0) ExifTool object ref, 1) tag key
sub DeleteTag($$)
{
    my ($self, $tag) = @_;
    delete $self->{VALUE}{$tag};
    delete $self->{FILE_ORDER}{$tag};
    delete $self->{TAG_INFO}{$tag};
    delete $self->{TAG_EXTRA}{$tag};
}

#------------------------------------------------------------------------------
# Escape all elements of a value
# Inputs: 0) value, 1) escape proc
sub DoEscape($$)
{
    my ($val, $key);
    if (not ref $_[0]) {
        $_[0] = &{$_[1]}($_[0]);
    } elsif (ref $_[0] eq 'ARRAY') {
        foreach $val (@{$_[0]}) {
            DoEscape($val, $_[1]);
        }
    } elsif (ref $_[0] eq 'HASH') {
        foreach $key (keys %{$_[0]}) {
            DoEscape($_[0]{$key}, $_[1]);
        }
    }
}

#------------------------------------------------------------------------------
# Set the FileType and MIMEType tags
# Inputs: 0) ExifTool object reference
#         1) Optional file type (uses FILE_TYPE if not specified)
#         2) Optional MIME type (uses our lookup if not specified)
# Notes:  Will NOT set file type twice (subsequent calls ignored)
sub SetFileType($;$$)
{
    my ($self, $fileType, $mimeType) = @_;
    unless ($self->{VALUE}{FileType}) {
        my $baseType = $self->{FILE_TYPE};
        $fileType or $fileType = $baseType;
        $mimeType or $mimeType = $mimeType{$fileType};
        # use base file type if necessary (except if 'TIFF', which is a special case)
        $mimeType = $mimeType{$baseType} unless $mimeType or $baseType eq 'TIFF';
        $self->FoundTag('FileType', $fileType);
        $self->FoundTag('MIMEType', $mimeType || 'application/unknown');
    }
}

#------------------------------------------------------------------------------
# Override the FileType and MIMEType tags
# Inputs: 0) ExifTool object ref, 1) file type
# Notes:  does nothing if FileType was not previously defined (ie. when writing)
sub OverrideFileType($$)
{
    my ($self, $fileType) = @_;
    if (defined $$self{VALUE}{FileType} and $fileType ne $$self{VALUE}{FileType}) {
        $$self{VALUE}{FileType} = $fileType;
        $$self{VALUE}{MIMEType} = $mimeType{$fileType} || 'application/unknown';
        if ($$self{OPTIONS}{Verbose}) {
            $self->VPrint(0,"$$self{INDENT}FileType [override] = $fileType\n");
            $self->VPrint(0,"$$self{INDENT}MIMEType [override] = $$self{VALUE}{MIMEType}\n");
        }
    }
}

#------------------------------------------------------------------------------
# Modify the value of the MIMEType tag
# Inputs: 0) ExifTool object reference, 1) file or MIME type
# Notes: combines existing type with new type: ie) a/b + c/d => c/b-d
sub ModifyMimeType($;$)
{
    my ($self, $mime) = @_;
    $mime =~ m{/} or $mime = $mimeType{$mime} or return;
    my $old = $self->{VALUE}{MIMEType};
    if (defined $old) {
        my ($a, $b) = split '/', $old;
        my ($c, $d) = split '/', $mime;
        $d =~ s/^x-//;
        $self->{VALUE}{MIMEType} = "$c/$b-$d";
        $self->VPrint(0, "  Modified MIMEType = $c/$b-$d\n");
    } else {
        $self->FoundTag('MIMEType', $mime);
    }
}

#------------------------------------------------------------------------------
# Print verbose output
# Inputs: 0) ExifTool ref, 1) verbose level (prints if level > this), 2-N) print args
sub VPrint($$@)
{
    my $self = shift;
    my $level = shift;
    if ($self->{OPTIONS}{Verbose} and $self->{OPTIONS}{Verbose} > $level) {
        my $out = $self->{OPTIONS}{TextOut};
        print $out @_;
    }
}

#------------------------------------------------------------------------------
# Verbose dump
# Inputs: 0) ExifTool ref, 1) data ref, 2-N) HexDump options
sub VerboseDump($$;%)
{
    my $self = shift;
    my $dataPt = shift;
    if ($self->{OPTIONS}{Verbose} and $self->{OPTIONS}{Verbose} > 2) {
        my %parms = (
            Prefix => $self->{INDENT},
            Out    => $self->{OPTIONS}{TextOut},
            MaxLen => $self->{OPTIONS}{Verbose} < 4 ? 96 : undef,
        );
        HexDump($dataPt, undef, %parms, @_);
    }
}

#------------------------------------------------------------------------------
# Extract binary data from file
# 0) ExifTool object reference, 1) offset, 2) length, 3) tag name if conditional
# Returns: binary data, or undef on error
# Notes: Returns "Binary data #### bytes" instead of data unless tag is
#        specifically requested or the Binary option is set
sub ExtractBinary($$$;$)
{
    my ($self, $offset, $length, $tag) = @_;
    my ($isPreview, $buff);

    if ($tag and $tag eq 'PreviewImage') {
        # save PreviewImage start/length in case we want to dump trailer
        $$self{PreviewImageStart} = $offset;
        $$self{PreviewImageLength} = $length;
        $isPreview = 1;
    }
    if ($tag and not $self->{OPTIONS}{Binary} and not $self->{OPTIONS}{Verbose} and
        not $self->{REQ_TAG_LOOKUP}{lc($tag)})
    {
        return "Binary data $length bytes";
    }
    unless ($self->{RAF}->Seek($offset,0)
        and $self->{RAF}->Read($buff, $length) == $length)
    {
        $tag or $tag = 'binary data';
        if ($isPreview and not $$self{BuildingComposite}) {
            $$self{PreviewError} = 1;
        } else {
            $self->Warn("Error reading $tag from file", $isPreview);
        }
        return undef;
    }
    return $buff;
}

#------------------------------------------------------------------------------
# Process binary data
# Inputs: 0) ExifTool object ref, 1) directory information ref, 2) tag table ref
# Returns: 1 on success
# Notes: dirInfo may contain VarFormatData (reference to empty list) to return
#        details about any variable-length-format tags in the table (used when writing)
sub ProcessBinaryData($$$)
{
    my ($self, $dirInfo, $tagTablePtr) = @_;
    my $dataPt = $$dirInfo{DataPt};
    my $offset = $$dirInfo{DirStart} || 0;
    my $size = $$dirInfo{DirLen} || (length($$dataPt) - $offset);
    my $base = $$dirInfo{Base} || 0;
    my $verbose = $self->{OPTIONS}{Verbose};
    my $unknown = $self->{OPTIONS}{Unknown};
    my $dataPos = $$dirInfo{DataPos} || 0;

    # get default format ('int8u' unless specified)
    my $defaultFormat = $$tagTablePtr{FORMAT} || 'int8u';
    my $increment = $formatSize{$defaultFormat};
    unless ($increment) {
        warn "Unknown format $defaultFormat\n";
        $defaultFormat = 'int8u';
        $increment = $formatSize{$defaultFormat};
    }
    # prepare list of tag numbers to extract
    my @tags;
    if ($unknown > 1 and defined $$tagTablePtr{FIRST_ENTRY}) {
        # scan through entire binary table
        @tags = ($$tagTablePtr{FIRST_ENTRY}..(int($size/$increment) - 1));
        # add in floating point tag ID's if they exist
        my @ftags = grep /\./, TagTableKeys($tagTablePtr);
        @tags = sort { $a <=> $b } @tags, @ftags if @ftags;
    } elsif ($$dirInfo{DataMember}) {
        @tags = @{$$dirInfo{DataMember}};
        $verbose = 0;   # no verbose output of extracted values when writing
    } else {
        # extract known tags in numerical order
        @tags = sort { $a <=> $b } TagTableKeys($tagTablePtr);
    }
    $self->VerboseDir('BinaryData', undef, $size) if $verbose;
    # avoid creating unknown tags for tags that fail condition if Unknown is 1
    $$self{NO_UNKNOWN} = 1 if $unknown < 2;
    my ($index, %val);
    my $nextIndex = 0;
    my $varSize = 0;
    foreach $index (@tags) {
        my ($tagInfo, $val, $saveNextIndex, $len, $mask, $wasVar);
        if ($$tagTablePtr{$index}) {
            $tagInfo = $self->GetTagInfo($tagTablePtr, $index);
            unless ($tagInfo) {
                next unless defined $tagInfo;
                my $entry = int($index) * $increment + $varSize;
                next if $entry >= $size;
                my $more = $size - $entry;
                $more = 128 if $more > 128;
                my $v = substr($$dataPt, $entry+$offset, $more);
                $tagInfo = $self->GetTagInfo($tagTablePtr, $index, \$v);
                next unless $tagInfo;
            }
            next if $$tagInfo{Unknown} and
                   ($$tagInfo{Unknown} > $unknown or $index < $nextIndex);
        } else {
            # don't generate unknown tags in binary tables unless Unknown > 1
            next unless $unknown > 1;
            next if $index < $nextIndex;    # skip if data already used
            $tagInfo = $self->GetTagInfo($tagTablePtr, $index) or next;
            $$tagInfo{Unknown} = 2;    # set unknown to 2 for binary unknowns
        }
        # get relative offset of this entry
        my $entry = int($index) * $increment + $varSize;
        my $more = $size - $entry;
        last if $more <= 0;     # all done if we have reached the end of data
        my $count = 1;
        my $format = $$tagInfo{Format};
        if (not $format) {
            $format = $defaultFormat;
        } elsif ($format eq 'string') {
            # string with no specified count runs to end of block
            $count = $more;
        } elsif ($format eq 'pstring') {
            $format = 'string';
            $count = Get8u($dataPt, ($entry++)+$offset);
            --$more;
        } elsif (not $formatSize{$format}) {
            if ($format =~ /(.*)\[(.*)\]/) {
                # handle format count field
                $format = $1;
                $count = $2;
                # evaluate count to allow count to be based on previous values
                #### eval Format size (%val, $size, $self)
                $count = eval $count;
                $@ and warn("Format $$tagInfo{Name}: $@"), next;
                next if $count < 0;
                # allow a variable-length of any format type (with base $count = 1)
                if ($format =~ s/^var_//) {
                    $varSize += ($count - 1) * ($formatSize{$format} || 1);
                    # save variable size data if required for writing
                    if ($$dirInfo{VarFormatData}) {
                        push @{$$dirInfo{VarFormatData}}, $index, $varSize;
                    }
                }
            } elsif ($format =~ /^var_/) {
                # handle variable-length string formats
                $format = substr($format, 4);
                pos($$dataPt) = $entry + $offset;
                undef $count;
                if ($format eq 'ustring') {
                    $count = pos($$dataPt) - ($entry+$offset) if $$dataPt =~ /\G(..)*?\0\0/sg;
                    $varSize -= 2;  # ($count includes base size of 2 bytes)
                } elsif ($format eq 'pstring') {
                    $count = Get8u($dataPt, ($entry++)+$offset);
                    --$more;
                } elsif ($format eq 'pstr32') {
                    last if $more < 4;
                    $count = Get32u($dataPt, $entry + $offset);
                    $entry += 4;
                    $more -= 4;
                } elsif ($format eq 'int16u') {
                    # int16u size of binary data to follow
                    last if $more < 2;
                    $count = Get16u($dataPt, $entry + $offset) + 2;
                    $varSize -= 2;  # ($count includes size word)
                    $format = 'undef';
                } elsif ($$dataPt =~ /\0/g) {
                    $count = pos($$dataPt) - ($entry+$offset);
                    --$varSize;     # ($count includes base size of 1 byte)
                }
                $count = $more if not defined $count or $count > $more;
                $varSize += $count; # shift subsequent indices
                $val = substr($$dataPt, $entry+$offset, $count);
                $val = $self->Decode($val, 'UCS2') if $format eq 'ustring';
                $val =~ s/\0.*//s unless $format eq 'undef';  # truncate at null
                $wasVar = 1;
                # save variable size data if required for writing
                if ($$dirInfo{VarFormatData}) {
                    push @{$$dirInfo{VarFormatData}}, $index, $varSize;
                }
            }
        }
        # hook to allow format, etc to be set dynamically
        if (defined $$tagInfo{Hook}) {
            #### eval Hook ($format, $varSize)
            eval $$tagInfo{Hook};
            # save variable size data if required for writing (in case changed by Hook)
            if ($$dirInfo{VarFormatData}) {
                $#{$$dirInfo{VarFormatData}} -= 2 if $wasVar; # remove previous entries for this tag
                push @{$$dirInfo{VarFormatData}}, $index, $varSize;
            }
        }
        if ($unknown > 1) {
            # calculate next valid index for unknown tag
            my $ni = int $index;
            $ni += (($formatSize{$format} || 1) * $count) / $increment unless $wasVar;
            $saveNextIndex = $nextIndex;
            $nextIndex = $ni unless $nextIndex > $ni;
        }
        # read value now if necessary
        unless (defined $val and not $$tagInfo{SubDirectory}) {
            $val = ReadValue($dataPt, $entry+$offset, $format, $count, $more);
            $mask = $$tagInfo{Mask};
            $val &= $mask if $mask;
        }
        if ($verbose and not $$tagInfo{Hidden}) {
            if (not $$tagInfo{SubDirectory} or $$tagInfo{Format}) {
                $len = $count * ($formatSize{$format} || 1);
                $len = $more if $len > $more;
            } else {
                $len = $more;
            }
            $self->VerboseInfo($index, $tagInfo,
                Table  => $tagTablePtr,
                Value  => $val,
                DataPt => $dataPt,
                Size   => $len,
                Start  => $entry+$offset,
                Addr   => $entry+$offset+$base+$dataPos,
                Format => $format,
                Count  => $count,
                Extra  => $mask ? sprintf(', mask 0x%.2x',$mask) : undef,
            );
        }
        # parse nested BinaryData directories
        if ($$tagInfo{SubDirectory}) {
            my $subTablePtr = GetTagTable($tagInfo->{SubDirectory}{TagTable});
            # use specified subdirectory length if given
            if ($$tagInfo{Format} and $formatSize{$format}) {
                $len = $count * $formatSize{$format};
                $len = $more if $len > $more;
            } else {
                $len = $more;
                if ($$subTablePtr{PROCESS_PROC} and
                    $$subTablePtr{PROCESS_PROC} eq \&ProcessBinaryData)
                {
                    # the rest of the data will be printed in the subdirectory
                    $nextIndex = $size / $increment;
                }
            }
            my %subdirInfo = (
                DataPt   => $dataPt,
                DataPos  => $dataPos,
                DirStart => $entry + $offset,
                DirLen   => $len,
                Base     => $base,
            );
            $self->ProcessDirectory(\%subdirInfo, $subTablePtr);
            next;
        }
        if ($$tagInfo{IsOffset} and $$tagInfo{IsOffset} ne '3') {
            my $exifTool = $self;
            #### eval IsOffset ($val, $exifTool)
            $val += $base + $$self{BASE} if eval $$tagInfo{IsOffset};
        }
        $val{$index} = $val;
        unless ($self->FoundTag($tagInfo,$val)) {
            # don't increment nextIndex if we didn't extract a tag
            $nextIndex = $saveNextIndex if defined $saveNextIndex;
        }
    }
    delete $$self{NO_UNKNOWN};
    return 1;
}

#..............................................................................
# Load .ExifTool_config file from user's home directory
# (use of noConfig is now deprecated, use configFile = '' instead)
until ($Image::ExifTool::noConfig) {
    my $file = $Image::ExifTool::configFile;
    if (not defined $file) {
        my $config = '.ExifTool_config';
        # get our home directory (HOMEDRIVE and HOMEPATH are used in Windows cmd shell)
        my $home = $ENV{EXIFTOOL_HOME} || $ENV{HOME} ||
                   ($ENV{HOMEDRIVE} || '') . ($ENV{HOMEPATH} || '') || '.';
        # look for the config file in 1) the home directory, 2) the program dir
        $file = "$home/$config";
        -r $file or $file = ($0 =~ /(.*[\\\/])/ ? $1 : './') . $config;
        -r $file or last;
    } else {
        length $file or last;   # filename of "" disables configuration
        -r $file or warn("Config file not found\n"), last;
    }
    eval "require '$file'"; # load the config file
    # print warning (minus "Compilation failed" part)
    $@ and $_=$@, s/Compilation failed.*//s, warn $_;
    if (@Image::ExifTool::UserDefined::Lenses) {
        foreach (@Image::ExifTool::UserDefined::Lenses) {
            $Image::ExifTool::userLens{$_} = 1;
        }
    }
    last;
}

#------------------------------------------------------------------------------
1;  # end
