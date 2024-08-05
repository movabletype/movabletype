import type { JSDOM } from "jsdom";
import type { TinyMCE, Editor } from "tinymce5";
import "../../../../../../../../tests/helpers/tinymce5";
import "./plugin";

describe("mt_protect", () => {
  let editor: Editor;
  let root: HTMLElement;

  beforeEach(async () => {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const jsdom = (window as any).jsdom as JSDOM;
    const virtualConsole = jsdom.window._virtualConsole;
    const originalVirtualConsoleEmit = virtualConsole.emit;
    virtualConsole.emit = () => {}; // disable temporary

    const element = document.createElement("div");
    element.id = "editor";
    document.body.appendChild(element);
    editor = await new Promise<Editor>((resolve) => {
      const editor = (window.tinymce as unknown as TinyMCE).createEditor(
        "editor",
        {
          selector: "#editor",
          inline: true,
          plugins: ["media", "mt_protect"],
          convert_urls: false,
          verify_html: false,
          setup: (editor) => {
            editor.on("init", () => {
              if (process.env.MT_TEST_ENABLE_JSDOM_VIRTUAL_CONSOLE) {
                virtualConsole.emit = originalVirtualConsoleEmit;
              }
              resolve(editor);
            });
          },
        },
      );
      editor.render();
    });
    root = editor.getBody();
  });

  describe("noscript element", () => {
    it("should remove noscript element", () => {
      editor.setContent(
        '<p>pre</p><noscript><iframe src="/test.html"></iframe></noscript><p>post</p>',
      );
      expect(editor.getContent()).toBe("<p>pre</p>\n<p>post</p>");
    });
  });

  describe("iframe[sandbox]", () => {
    // prettier-ignore
    test.each`
      iframe                                                                                                                      | sandbox
      // external site
      ${`<iframe src="http://invalid/test.html"></iframe>`}                                                                       | ${null}
      ${`<iframe src="http://invalid/test.html" sandbox="allow-scripts"></iframe>`}                                               | ${"allow-scripts"}
      ${`<iframe src="http://invalid/test.html" sandbox="allow-scripts allow-same-origin"></iframe>`}                             | ${"allow-scripts allow-same-origin"}

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

      // same origin without src attribute
      ${`<iframe></iframe>`}                                                                                                      | ${"allow-scripts"}
      ${`<iframe sandbox="allow-scripts"></iframe>`}                                                                              | ${"allow-scripts"}
      ${`<iframe sandbox="allow-scripts allow-popups"></iframe>`}                                                                 | ${"allow-scripts allow-popups"}
      // should remove "allow-same-origin" for same origin
      ${`<iframe sandbox="allow-scripts allow-same-origin"></iframe>`}                                                            | ${"allow-scripts"}

      // same origin with srcdoc
      ${`<iframe srcdoc="&lt;p&gt;test&lt;/p&gt;"></iframe>`}                                                                     | ${"allow-scripts"}
      ${`<iframe srcdoc="&lt;p&gt;test&lt;/p&gt;" sandbox="allow-scripts"></iframe>`}                                             | ${"allow-scripts"}
      ${`<iframe srcdoc="&lt;p&gt;test&lt;/p&gt;" sandbox="allow-scripts allow-popups"></iframe>`}                                | ${"allow-scripts allow-popups"}
      // should remove "allow-same-origin" for same origin
      ${`<iframe srcdoc="&lt;p&gt;test&lt;/p&gt;" sandbox="allow-scripts allow-same-origin"></iframe>`}                           | ${"allow-scripts"}
  `("sandbox attributes of $iframe to $sandbox", ({ iframe, sandbox }) => {
    editor.setContent(iframe);
    expect(root.querySelector("iframe")?.getAttribute("sandbox")).toBe(sandbox);
    expect(editor.getContent()).toBe(`<p>${iframe}</p>`);
    });
  });
});
