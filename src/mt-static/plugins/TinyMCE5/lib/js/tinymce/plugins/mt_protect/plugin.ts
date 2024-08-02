/* eslint-disable no-var */

import type { Editor, AstNode } from "tinymce6"; // import type Editor from tinymce6 for compatibility

function isSameOrigin(iframe: AstNode): boolean {
  if (iframe.attr("srcdoc")) {
    return true;
  }
  var src = iframe.attr("src");
  if (!src) {
    return true;
  }
  var a = document.createElement("a");
  a.href = src;
  return (
    a.hostname === window.location.hostname &&
    a.protocol === window.location.protocol &&
    a.port === window.location.port
  );
}

tinymce.PluginManager.add("mt_protect", function (ed: Editor) {
  ed.on("PreInit", function () {
    ed.parser.addNodeFilter("noscript", function (nodes) {
      nodes.forEach(function (node) {
        node.remove();
      });
    });
    var parserIframeFilter = ed.parser.getNodeFilters().find(function (filter) {
      return filter.name === "iframe";
    });
    if (parserIframeFilter) {
      parserIframeFilter.callbacks.unshift(function (nodes) {
        nodes.forEach(function (node) {
          var origSandbox = node.attr("sandbox");
          var origReplace = node.replace;
          node.replace = function (newNode: AstNode) {
            var children = newNode.children();
            if (children[0] && children[0].name === "iframe") {
              var iframeNode = children[0];
              if (!isSameOrigin(iframeNode)) {
                iframeNode.attr("sandbox", origSandbox);
              } else {
                var newSandbox = "allow-scripts";
                if (origSandbox === undefined) {
                  iframeNode.attr("data-mt-protect-no-sandbox", "1");
                } else {
                  iframeNode.attr("data-mt-protect-sandbox", origSandbox);
                  newSandbox = origSandbox
                    .split(/\s+/)
                    .filter(function (value) {
                      return !/allow-same-origin/i.test(value);
                    })
                    .join(" ");
                }
                iframeNode.attr("sandbox", newSandbox);
              }
            }
            origReplace.apply(this, [newNode]);
            return this;
          };
        });
      });
    }
  });
});
