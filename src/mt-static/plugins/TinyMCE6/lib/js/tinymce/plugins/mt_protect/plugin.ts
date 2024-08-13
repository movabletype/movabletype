import type { Editor, AstNode } from "tinymce6";

function isSameOrigin(iframe: AstNode): boolean {
  if (iframe.attr("srcdoc")) {
    return true;
  }
  const src = iframe.attr("src");
  if (!src) {
    return true;
  }
  const a = document.createElement("a");
  a.href = src;
  return (
    a.hostname === window.location.hostname &&
    a.protocol === window.location.protocol &&
    a.port === window.location.port
  );
}

tinymce.PluginManager.add("mt_protect", function (ed: Editor) {
  ed.on("PreInit", function () {
    const parserIframeFilter = ed.parser
      .getNodeFilters()
      .find(function (filter) {
        return filter.name === "iframe";
      });
    if (parserIframeFilter) {
      parserIframeFilter.callbacks.unshift(function (nodes) {
        nodes.forEach(function (node) {
          if (!isSameOrigin(node)) {
            return;
          }

          const origSandbox = node.attr("sandbox");
          let newSandbox = "allow-scripts";
          if (origSandbox === undefined) {
            node.attr("data-mt-protect-no-sandbox", "1");
          } else {
            node.attr("data-mt-protect-sandbox", origSandbox);
            newSandbox = origSandbox
              .split(/\s+/)
              .filter(function (value) {
                return !/allow-same-origin/i.test(value);
              })
              .join(" ");
          }
          node.attr("sandbox", newSandbox);
        });
      });
    }

    const serializerObjectFilter = ed.serializer
      .getAttributeFilters()
      .find(function (filter) {
        return filter.name === "data-mce-object";
      });
    if (serializerObjectFilter) {
      serializerObjectFilter.callbacks.unshift(function (nodes) {
        nodes.forEach(function (node) {
          const origSandbox = node.attr("data-mce-p-data-mt-protect-sandbox");
          if (origSandbox !== undefined) {
            node.attr("data-mce-p-sandbox", origSandbox);
          } else if (node.attr("data-mce-p-data-mt-protect-no-sandbox")) {
            node.attr("data-mce-p-sandbox", null);
          }
          node.attr("data-mce-p-data-mt-protect-sandbox", null);
          node.attr("data-mce-p-data-mt-protect-no-sandbox", null);
        });
      });
    }
  });
});
