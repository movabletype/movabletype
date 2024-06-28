tinymce.PluginManager.add('mt_protect', function (ed) {
  ed.on('PreInit', function () {
    ed.parser.addNodeFilter('noscript', function (nodes) {
      nodes.forEach(function (node) {
        node.remove();
      });
    });
  })
});
