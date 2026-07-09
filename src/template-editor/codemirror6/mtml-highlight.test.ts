import { EditorState } from "@codemirror/state";
import { syntaxTree } from "@codemirror/language";
import { mtmlLanguage } from "./mtml-highlight";

type Token = { name: string; text: string };

function tokenize(lang: string, code: string): Token[] {
  const state = EditorState.create({
    doc: code,
    extensions: mtmlLanguage(lang),
  });
  const tree = syntaxTree(state);
  const tokens: Token[] = [];
  tree.iterate({
    enter: (node) => {
      if (node.name === "Document") return;
      tokens.push({ name: node.name, text: code.slice(node.from, node.to) });
    },
  });
  return tokens;
}

describe("mtmlLanguage (HTML)", () => {
  it("tags <MT:Foo></MT:Foo> as mt-tag", () => {
    const tokens = tokenize("html", "<p><MT:Foo></MT:Foo></p>");
    const mt = tokens.filter((t) => t.name === "mt-tag");
    expect(mt.length).toBeGreaterThan(0);
    expect(mt.some((t) => t.text.includes("MT:Foo"))).toBe(true);
  });

  it("tags the <$mt:bar$> short form as mt-tag", () => {
    const tokens = tokenize("html", "<p><$mt:bar$></p>");
    expect(
      tokens.some((t) => t.name === "mt-tag" && t.text.includes("mt:bar")),
    ).toBe(true);
  });

  it("tags self-closing <MT:Foo /> as mt-tag", () => {
    const tokens = tokenize("html", "<p><MT:Foo /></p>");
    expect(tokens.some((t) => t.name === "mt-tag")).toBe(true);
  });

  it("keeps an attribute string with MTML inside intact", () => {
    const tokens = tokenize("html", '<input value="<MT:Foo>">');
    const str = tokens.find((t) => t.name === "string");
    expect(str?.text).toBe('"<MT:Foo>"');
  });

  it("keeps the attribute string intact when MTML contains a quote", () => {
    const tokens = tokenize("html", '<input value="<MT:If foo="bar">">');
    const str = tokens.find((t) => t.name === "string");
    expect(str?.text).toBe('"<MT:If foo="bar">"');
  });

  it("highlights JavaScript inside an inline <script> block", () => {
    const tokens = tokenize("html", "<script>var x = 1;</script>");
    expect(tokens.some((t) => t.name === "keyword" && t.text === "var")).toBe(
      true,
    );
    expect(tokens.some((t) => t.name === "number" && t.text === "1")).toBe(
      true,
    );
  });

  it("highlights CSS inside an inline <style> block", () => {
    const tokens = tokenize("html", "<style>a { color: red; }</style>");
    expect(
      tokens.some((t) => t.name === "propertyName" && t.text === "color"),
    ).toBe(true);
    expect(tokens.some((t) => t.name === "keyword" && t.text === "red")).toBe(
      true,
    );
  });

  it("still tags MTML inside an inline <script> block as mt-tag", () => {
    const tokens = tokenize("html", "<script>var x = <$mt:val$>;</script>");
    expect(
      tokens.some((t) => t.name === "mt-tag" && t.text.includes("mt:val")),
    ).toBe(true);
  });

  it("highlights JS for an explicit JavaScript script type", () => {
    const tokens = tokenize(
      "html",
      '<script type="text/javascript">const a = 1;</script>',
    );
    expect(tokens.some((t) => t.name === "keyword" && t.text === "const")).toBe(
      true,
    );
  });

  it("does NOT highlight non-JS script types (e.g. inline templates) as code", () => {
    const tokens = tokenize(
      "html",
      '<script type="text/template">const a = 1;</script>',
    );
    expect(tokens.some((t) => t.name === "keyword")).toBe(false);
  });
});

describe("mtmlLanguage (CSS)", () => {
  it("keeps a string with MTML inside intact", () => {
    const tokens = tokenize("css", 'body { content: "<$mt:msg$>"; }');
    const str = tokens.find((t) => t.name === "string");
    expect(str?.text).toBe('"<$mt:msg$>"');
  });

  it("keeps a string intact when MTML contains a quote", () => {
    const tokens = tokenize("css", 'body { content: "<MT:Var foo="bar">"; }');
    const str = tokens.find((t) => t.name === "string");
    expect(str?.text).toBe('"<MT:Var foo="bar">"');
  });
});

describe("mtmlLanguage (JavaScript)", () => {
  it("keeps a string with MTML inside intact", () => {
    const tokens = tokenize("javascript", 'var s = "<$mt:val$>";');
    const str = tokens.find((t) => t.name === "string");
    expect(str?.text).toBe('"<$mt:val$>"');
  });

  it("keeps a string intact when MTML contains a quote", () => {
    const tokens = tokenize("javascript", 'var s = "<MT:Var foo="bar">";');
    const str = tokens.find((t) => t.name === "string");
    expect(str?.text).toBe('"<MT:Var foo="bar">"');
  });
});
