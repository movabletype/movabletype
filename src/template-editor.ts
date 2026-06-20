import { EditorView, keymap, lineNumbers } from "@codemirror/view";
import { EditorState } from "@codemirror/state";
import {
  defaultKeymap,
  history,
  historyKeymap,
  indentWithTab,
} from "@codemirror/commands";
import {
  syntaxHighlighting,
  defaultHighlightStyle,
} from "@codemirror/language";

import { mtmlLanguage } from "./template-editor/codemirror/mtml-highlight";

interface EditorShim {
  getValue(): string;
  setValue(value: string): void;
  getWrapperElement(): HTMLElement;
}

declare global {
  interface Window {
    saveTemplatePrefs?: (state: string) => void;
  }
}

function detectLanguage(textarea: HTMLTextAreaElement): string {
  const options = textarea.getAttribute("mt:editor-options") || "";
  if (options.match("lang:css")) return "css";
  if (options.match("lang:javascript")) return "javascript";
  return "html";
}

function createEditor(textarea: HTMLTextAreaElement): EditorShim {
  const lang = detectLanguage(textarea);

  const view = new EditorView({
    state: EditorState.create({
      doc: textarea.value,
      extensions: [
        lineNumbers(),
        history(),
        syntaxHighlighting(defaultHighlightStyle),
        keymap.of([indentWithTab, ...defaultKeymap, ...historyKeymap]),
        mtmlLanguage(lang),
      ],
    }),
  });

  const wrapper = document.createElement("div");
  wrapper.className = "mt-codemirror-wrapper";
  wrapper.appendChild(view.dom);

  textarea.parentNode?.insertBefore(wrapper, textarea);
  textarea.style.display = "none";

  return {
    getValue: () => view.state.doc.toString(),
    setValue: (value: string) => {
      view.dispatch({
        changes: { from: 0, to: view.state.doc.length, insert: value },
      });
    },
    getWrapperElement: () => wrapper,
  };
}

function initTemplateEditor(): void {
  const textarea = document.getElementById(
    "text",
  ) as HTMLTextAreaElement | null;
  if (!textarea) return;
  if (textarea.getAttribute("mt:editor") !== "codemirror") return;
  if (textarea.dataset.mtEditorInitialized) return;
  textarea.dataset.mtEditorInitialized = "1";

  const editor = createEditor(textarea);

  const syncEditor = (): void => {
    const wrapper = editor.getWrapperElement();
    if (wrapper.style.display === "none") {
      editor.setValue(textarea.value);
    } else {
      textarea.value = editor.getValue();
    }
  };

  const setSyntaxHighlight = (onOrOff: string): void => {
    syncEditor();
    const wrapper = editor.getWrapperElement();
    if (onOrOff === "off") {
      textarea.style.display = "";
      wrapper.style.display = "none";
    } else {
      textarea.style.display = "none";
      wrapper.style.display = "";
    }
  };

  const checkbox = document.getElementById(
    "code-highlight-switch",
  ) as HTMLInputElement | null;
  if (checkbox && !checkbox.checked) {
    setSyntaxHighlight("off");
  }

  checkbox?.addEventListener("change", () => {
    const state = checkbox.checked ? "on" : "off";
    setSyntaxHighlight(state);
    window.saveTemplatePrefs?.(state);
  });

  window.jQuery?.(window).on("pre_autosave", () => syncEditor());

  // eslint-disable-next-line no-control-regex
  const controlChars = /[\0-\x08\x0B\x0C\x0E-\x1F\x7F]/g;

  if (textarea.form && window.jQuery) {
    window.jQuery(textarea.form).on("submit", () => {
      syncEditor();
      const cleaned = editor.getValue().replace(controlChars, "");
      editor.setValue(cleaned);
      textarea.value = cleaned;
    });
  }
}

document.addEventListener("DOMContentLoaded", initTemplateEditor);
