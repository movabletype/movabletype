let icons_set = {
  'bold': 'ic_bold',
  'italic': 'ic_italic',
  'underline': 'ic_underline',
  'strike-through': 'ic_crossoff',
  'quote': 'ic_quotation',
  'unordered-list': 'ic_list',
  'ordered-list': 'ic_ol',
  'horizontal-rule': 'ic_hr',
  'link': 'ic_link',
  'unlink': 'ic_unlink',
  'addhtml': 'ic_addhtml',
  'new-document': 'ic_asset',
  'image': 'ic_image',
  'undo': 'ic_undo',
  'redo': 'ic_redo',
  'text-color': 'ic_textcolor',
  'highlight-bg-color': 'ic_backgroundcolor',
  'remove-formatting': 'ic_eraser',
  'align-left': 'ic_alignleft',
  'align-center': 'ic_aligncenter',
  'align-right': 'ic_alignright',
  'indent': 'ic_indent',
  'outdent': 'ic_unindent',
  'sourcecode': 'ic_code',
  'fullscreen': 'ic_fullscreen',
  'template': 'ic_template',
};
var icons = {};
Object.keys(icons_set).forEach(function (key) {
  icons[key] = '<svg width="24" height="24" role="' + key + '"><use xlink:href="' + StaticURI + 'images/sprite.svg#' + icons_set[key] + '"></use></svg>';
});

tinymce.IconManager.add('mt', {
  icons: icons
});