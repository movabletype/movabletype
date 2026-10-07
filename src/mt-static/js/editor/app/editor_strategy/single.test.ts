import $ from "jquery";
import { loadLegacyScript } from "../../../../../tests/helpers/legacyScript";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const createMT = (): any => {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const MT: any = { App: {} };
  loadLegacyScript("js/editor/app/editor_strategy.js", $, MT);
  loadLegacyScript("js/editor/app/editor_strategy/single.js", $, MT);
  return MT;
};

describe("MT.App.EditorStrategy.Single#save", () => {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  let strategy: any;

  beforeEach(() => {
    const MT = createMT();
    strategy = new MT.App.EditorStrategy.Single();
  });

  test("saves app.editor when app is given", () => {
    const editor = { save: vi.fn() };
    const app = { editor };

    strategy.save(app);

    expect(editor.save).toHaveBeenCalledTimes(1);
  });

  test("falls back to window.app.editor when called with no argument", () => {
    const editor = { save: vi.fn() };
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const windowApp: any = { editor };

    try {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      (window as any).app = windowApp;

      strategy.save();

      expect(editor.save).toHaveBeenCalledTimes(1);
    } finally {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      delete (window as any).app;
    }
  });
});
