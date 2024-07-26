import type { Editor } from "tinymce6";
import "../../../../../../../../tests/helpers/tinymce6";
import "./plugin";

describe("mt_protect", () => {
  let editor: Editor;
  let root: HTMLElement;

  beforeEach(async () => {
    const element = document.createElement("div");
    element.id = "editor";
    document.body.appendChild(element);
    editor = await new Promise<Editor>((resolve) => {
      const editor = window.tinymce.createEditor("editor", {
        selector: "#editor",
        inline: true,
        plugins: ["media", "mt_protect"],
        convert_urls: false,
        setup: (editor) => {
          editor.on("init", () => {
            resolve(editor);
          });
        },
      });
      editor.render();
    });
    root = editor.getBody();
  });

  describe("iframe[sandbox]", () => {
    // prettier-ignore
    test.each`
      iframe                                                                                                                      | sandbox
      // external site
      ${`<iframe src="http://example.com/test.html"></iframe>`}                                                                   | ${null}
      ${`<iframe src="http://example.com/test.html" sandbox="allow-scripts"></iframe>`}                                           | ${"allow-scripts"}
      ${`<iframe src="http://example.com/test.html" sandbox="allow-scripts allow-same-origin"></iframe>`}                         | ${"allow-scripts allow-same-origin"}

      // same host, but different port
      ${`<iframe src="${location.protocol}//${location.hostname}/test.html"></iframe>`}                                           | ${null}
      ${`<iframe src="${location.protocol}//${location.hostname}/test.html" sandbox="allow-scripts"></iframe>`}                   | ${"allow-scripts"}
      ${`<iframe src="${location.protocol}//${location.hostname}/test.html" sandbox="allow-scripts allow-same-origin"></iframe>`} | ${"allow-scripts allow-same-origin"}

      // same origin
      ${`<iframe src="${location.origin}/test.html"></iframe>`}                                                                   | ${"allow-scripts"}
      ${`<iframe src="${location.origin}/test.html" sandbox="allow-scripts"></iframe>`}                                           | ${"allow-scripts"}
      ${`<iframe src="${location.origin}/test.html" sandbox="allow-scripts allow-popups"></iframe>`}                              | ${"allow-scripts allow-popups"}
      // should remove "allow-same-origin" for same origin
      ${`<iframe src="${location.origin}/test.html" sandbox="allow-scripts allow-same-origin"></iframe>`}                         | ${"allow-scripts"}

      // same origin with relative path
      ${`<iframe src="/test.html"></iframe>`}                                                                                     | ${"allow-scripts"}
      ${`<iframe src="/test.html" sandbox="allow-scripts"></iframe>`}                                                             | ${"allow-scripts"}
      ${`<iframe src="/test.html" sandbox="allow-scripts allow-popups"></iframe>`}                                                | ${"allow-scripts allow-popups"}
      // should remove "allow-same-origin" for same origin
      ${`<iframe src="/test.html" sandbox="allow-scripts allow-same-origin"></iframe>`}                                           | ${"allow-scripts"}

      // same origin with protocol relative
      ${`<iframe src="//${location.hostname}:${location.port}/test.html"></iframe>`}                                              | ${"allow-scripts"}
      ${`<iframe src="//${location.hostname}:${location.port}/test.html" sandbox="allow-scripts"></iframe>`}                      | ${"allow-scripts"}
      ${`<iframe src="//${location.hostname}:${location.port}/test.html" sandbox="allow-scripts allow-popups"></iframe>`}         | ${"allow-scripts allow-popups"}
      // should remove "allow-same-origin" for same origin
      ${`<iframe src="//${location.hostname}:${location.port}/test.html" sandbox="allow-scripts allow-same-origin"></iframe>`}    | ${"allow-scripts"}
  `("sandbox attributes of $iframe to $sandbox", ({ iframe, sandbox }) => {
    editor.setContent(iframe);
    expect(root.querySelector("iframe")?.getAttribute("sandbox")).toBe(sandbox);
    expect(editor.getContent()).toBe(`<p>${iframe}</p>`);
    });
  });
});
