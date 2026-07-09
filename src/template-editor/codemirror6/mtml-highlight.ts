import {
  StreamLanguage,
  LanguageSupport,
  HighlightStyle,
  syntaxHighlighting,
} from "@codemirror/language";
import { EditorView } from "@codemirror/view";
import type { Extension } from "@codemirror/state";
import { Tag, tags } from "@lezer/highlight";

import { css as cssMode } from "./modes/css";
import { javascript as jsMode } from "./modes/javascript";
import htmlMixedMode from "./modes/htmlmixed";

const DEFAULT_INDENT_UNIT = 2;

const mtTagTag = Tag.define();
const mtTokenTable = { "mt-tag": mtTagTag };

const htmlMixed = StreamLanguage.define({
  ...htmlMixedMode({ indentUnit: DEFAULT_INDENT_UNIT }, {}),
  tokenTable: mtTokenTable,
});
const css = StreamLanguage.define(cssMode);
const javascript = StreamLanguage.define({
  ...jsMode,
  tokenTable: mtTokenTable,
});
const mtmlHighlightStyle = HighlightStyle.define([
  { tag: mtTagTag, color: "#A70" },
  { tag: tags.attributeName, color: "#00c" },
  { tag: tags.angleBracket, color: "#085" },
]);

const mtmlTheme = EditorView.theme({
  "&": {
    height: "550px",
    border: "1px solid #adadad",
    borderTopColor: "#a3a3a2",
  },
  ".cm-content, .cm-gutter": { minHeight: "550px" },
  ".cm-scroller": { overflow: "auto" },
  ".cm-content": { fontSize: "14px", lineHeight: "1.3" },
});

function mtmlExtensions(language: LanguageSupport): Extension[] {
  return [language, mtmlTheme, syntaxHighlighting(mtmlHighlightStyle)];
}

export function mtmlLanguage(lang: string): Extension[] {
  if (lang === "css") return mtmlExtensions(new LanguageSupport(css));
  if (lang === "javascript")
    return mtmlExtensions(new LanguageSupport(javascript));
  return mtmlExtensions(new LanguageSupport(htmlMixed));
}
