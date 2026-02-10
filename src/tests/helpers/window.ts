Object.defineProperty(window, "matchMedia", {
  writable: true,
  value: vi.fn().mockImplementation((query) => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: vi.fn(), // deprecated
    removeListener: vi.fn(), // deprecated
    addEventListener: vi.fn(),
    removeEventListener: vi.fn(),
    dispatchEvent: vi.fn(),
  })),
});

Object.defineProperty(window, "ScriptURI", {
  writable: true,
  value: "/cgi-bin/mt.cgi",
});

Object.defineProperty(window, "CMSScriptURI", {
  writable: true,
  value: "/cgi-bin/mt.cgi",
});

Object.defineProperty(window, "StaticURI", {
  writable: true,
  value: "/mt-static/",
});

Object.defineProperty(window, "trans", {
  writable: true,
  value: vi.fn((str: string, ...args: string[]) => {
    let result = str;
    args.forEach((arg, i) => {
      result = result.replace(`[_${i + 1}]`, arg);
    });
    return result;
  }),
});
