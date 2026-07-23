import $ from "jquery";
import { loadLegacyScript } from "../../../../../tests/helpers/legacyScript";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const createMT = (): any => {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const MT: any = { App: {} };
  loadLegacyScript("js/editor/app/editor_strategy.js", $, MT);
  loadLegacyScript("js/editor/app/editor_strategy/multi.js", $, MT);
  return MT;
};

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const createEditorStub = (): any => ({
  show: vi.fn(),
  hide: vi.fn(),
  save: vi.fn(),
  setHeight: vi.fn(),
  getHeight: vi.fn().mockReturnValue(100),
  setFormat: vi.fn(),
});

describe("MT.App.EditorStrategy.Multi#save", () => {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  let strategy: any;

  beforeEach(() => {
    const MT = createMT();
    strategy = new MT.App.EditorStrategy.Multi();
  });

  test("saves every editor, not just the current one", () => {
    const contentEditor = createEditorStub();
    const extendedEditor = createEditorStub();
    const app = {
      editors: {
        "editor-input-content": contentEditor,
        "editor-input-extended": extendedEditor,
      },
      // app.editor points only to the currently visible editor.
      editor: extendedEditor,
    };

    strategy.save(app);

    expect(contentEditor.save).toHaveBeenCalledTimes(1);
    expect(extendedEditor.save).toHaveBeenCalledTimes(1);
  });

  test("falls back to app.editor when app.editors is not set", () => {
    const editor = createEditorStub();
    const app = { editor };

    strategy.save(app);

    expect(editor.save).toHaveBeenCalledTimes(1);
  });

  test("falls back to window.app and saves all its editors when called with no argument", () => {
    const contentEditor = createEditorStub();
    const extendedEditor = createEditorStub();
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const windowApp: any = {
      editors: {
        "editor-input-content": contentEditor,
        "editor-input-extended": extendedEditor,
      },
    };

    try {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      (window as any).app = windowApp;

      strategy.save();

      expect(contentEditor.save).toHaveBeenCalledTimes(1);
      expect(extendedEditor.save).toHaveBeenCalledTimes(1);
    } finally {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      delete (window as any).app;
    }
  });
});

describe("MT.App.EditorStrategy.Multi create/set/save integration", () => {
  test("saves both fields' managers after create() and set() switch the visible field", () => {
    document.body.innerHTML = `
      <textarea id="editor-input-content"></textarea>
      <textarea id="editor-input-extended"></textarea>
    `;

    const MT = createMT();
    const managers: Record<string, ReturnType<typeof createEditorStub>> = {};
    MT.EditorManager = vi.fn().mockImplementation((id: string) => {
      const manager = createEditorStub();
      managers[id] = manager;
      return manager;
    });

    const strategy = new MT.App.EditorStrategy.Multi();
    const ids = ["editor-input-content", "editor-input-extended"];
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const app: any = { editorIds: ids };

    strategy.create(app, ids, "richtext");
    strategy.set(app, ids[0]);
    strategy.save(app);

    expect(managers["editor-input-content"].save).toHaveBeenCalledTimes(1);
    expect(managers["editor-input-extended"].save).toHaveBeenCalledTimes(1);
    expect(managers["editor-input-content"].show).toHaveBeenCalledTimes(1);
    expect(managers["editor-input-extended"].hide).toHaveBeenCalledTimes(1);
  });
});
