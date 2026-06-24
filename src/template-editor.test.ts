import $ from "jquery";
import "./template-editor";

window.jQuery = $ as unknown as typeof window.jQuery;

function initTemplateEditor(): void {
  document.dispatchEvent(new Event("DOMContentLoaded"));
}

type SetupOptions = {
  mtEditor?: string;
  mtEditorOptions?: string;
  value?: string;
  checkbox?: boolean | "absent";
};

type SetupResult = {
  form: HTMLFormElement;
  textarea: HTMLTextAreaElement;
  checkbox: HTMLInputElement | null;
};

function setup(opts: SetupOptions = {}): SetupResult {
  const form = document.createElement("form");
  const textarea = document.createElement("textarea");
  textarea.id = "text";
  if (opts.mtEditor !== undefined) {
    textarea.setAttribute("mt:editor", opts.mtEditor);
  }
  if (opts.mtEditorOptions !== undefined) {
    textarea.setAttribute("mt:editor-options", opts.mtEditorOptions);
  }
  textarea.value = opts.value ?? "";
  form.appendChild(textarea);

  let checkbox: HTMLInputElement | null = null;
  if (opts.checkbox !== "absent") {
    checkbox = document.createElement("input");
    checkbox.type = "checkbox";
    checkbox.id = "code-highlight-switch";
    checkbox.checked = opts.checkbox ?? true;
    form.appendChild(checkbox);
  }

  document.body.appendChild(form);
  return { form, textarea, checkbox };
}

describe("initTemplateEditor", () => {
  beforeEach(() => {
    document.body.innerHTML = "";
    delete window.saveTemplatePrefs;
  });

  it("does nothing when the textarea is absent", () => {
    initTemplateEditor();
    expect(document.querySelector(".mt-codemirror-wrapper")).toBeNull();
  });

  it("does nothing when mt:editor is not 'codemirror'", () => {
    setup({ mtEditor: "monaco" });
    initTemplateEditor();
    expect(document.querySelector(".mt-codemirror-wrapper")).toBeNull();
  });

  it("creates the editor wrapper and hides the textarea", () => {
    const { textarea } = setup({ mtEditor: "codemirror", value: "<p>hi</p>" });
    initTemplateEditor();
    expect(document.querySelector(".mt-codemirror-wrapper")).not.toBeNull();
    expect(textarea.style.display).toBe("none");
  });

  it("starts with the editor hidden when the checkbox is unchecked", () => {
    const { textarea } = setup({ mtEditor: "codemirror", checkbox: false });
    initTemplateEditor();
    const wrapper = document.querySelector(
      ".mt-codemirror-wrapper",
    ) as HTMLElement;
    expect(textarea.style.display).toBe("");
    expect(wrapper.style.display).toBe("none");
  });

  it("starts with the editor visible when the checkbox is checked", () => {
    const { textarea } = setup({ mtEditor: "codemirror", checkbox: true });
    initTemplateEditor();
    const wrapper = document.querySelector(
      ".mt-codemirror-wrapper",
    ) as HTMLElement;
    expect(textarea.style.display).toBe("none");
    expect(wrapper.style.display).toBe("");
  });

  it("toggles visibility and calls saveTemplatePrefs on checkbox change", () => {
    const saveTemplatePrefs = vi.fn();
    window.saveTemplatePrefs = saveTemplatePrefs;

    const { textarea, checkbox } = setup({
      mtEditor: "codemirror",
      checkbox: true,
    });
    initTemplateEditor();
    const wrapper = document.querySelector(
      ".mt-codemirror-wrapper",
    ) as HTMLElement;

    checkbox!.checked = false;
    checkbox!.dispatchEvent(new Event("change"));
    expect(textarea.style.display).toBe("");
    expect(wrapper.style.display).toBe("none");
    expect(saveTemplatePrefs).toHaveBeenLastCalledWith("off");

    checkbox!.checked = true;
    checkbox!.dispatchEvent(new Event("change"));
    expect(textarea.style.display).toBe("none");
    expect(wrapper.style.display).toBe("");
    expect(saveTemplatePrefs).toHaveBeenLastCalledWith("on");
  });

  it("strips control chars from the textarea on form submit", () => {
    const { form, textarea } = setup({
      mtEditor: "codemirror",
      value: "hello\x00world\x08!",
    });
    initTemplateEditor();

    form.addEventListener("submit", (e) => e.preventDefault());
    $(form).trigger("submit");

    expect(textarea.value).toBe("helloworld!");
  });

  it("preserves textarea edits made while highlighting is off on submit", () => {
    const { form, textarea } = setup({
      mtEditor: "codemirror",
      checkbox: false,
      value: "original",
    });
    initTemplateEditor();

    textarea.value = "edited while off";

    form.addEventListener("submit", (e) => e.preventDefault());
    $(form).trigger("submit");

    expect(textarea.value).toBe("edited while off");
  });
});
