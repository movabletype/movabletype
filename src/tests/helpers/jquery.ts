import { vi } from "vitest";

const createJQueryMock = (): Record<string, unknown> => {
  const mock: Record<string, unknown> = {
    data: vi.fn().mockReturnValue(false),
    find: vi.fn().mockReturnValue({
      length: 0,
      val: vi.fn().mockReturnValue(0),
      each: vi.fn(),
    }),
    attr: vi.fn(),
    parents: vi.fn().mockReturnValue({
      find: vi.fn().mockReturnValue({
        val: vi.fn().mockReturnValue(0),
        find: vi.fn().mockReturnValue({ length: 0 }),
      }),
    }),
    prop: vi.fn(),
    val: vi.fn().mockReturnValue(""),
    each: vi.fn(),
    trigger: vi.fn(),
    closest: vi.fn().mockReturnValue({
      attr: vi.fn(),
    }),
    sortable: vi.fn().mockReturnThis(),
    addClass: vi.fn().mockReturnThis(),
    removeClass: vi.fn().mockReturnThis(),
    css: vi.fn().mockReturnThis(),
    append: vi.fn().mockReturnThis(),
    remove: vi.fn().mockReturnThis(),
    html: vi.fn().mockReturnThis(),
    text: vi.fn().mockReturnThis(),
    show: vi.fn().mockReturnThis(),
    hide: vi.fn().mockReturnThis(),
    length: 0,
  };

  mock.on = vi.fn().mockReturnValue(mock);

  return mock;
};

export type AjaxMockFn = ReturnType<typeof vi.fn>;

const jQueryMock = Object.assign(
  vi.fn().mockImplementation(() => createJQueryMock()),
  {
    each: vi.fn(),
    extend: vi.fn((target, ...sources) => Object.assign(target, ...sources)),
    ajax: vi.fn().mockResolvedValue({ result: { success: 1 } }) as AjaxMockFn,
  },
);

export const setupAjaxMock = <T>(response?: T): AjaxMockFn => {
  const mockFn = vi
    .fn()
    .mockResolvedValue(response ?? { result: { success: 1 } });
  jQueryMock.ajax = mockFn;
  return mockFn;
};

export const setupAjaxMockWithPending = <T>(): {
  promise: Promise<T>;
  resolve: (value: T) => void;
  mockFn: AjaxMockFn;
} => {
  let resolve: (value: T) => void;
  const promise = new Promise<T>((r) => {
    resolve = r;
  });
  const mockFn = vi.fn().mockReturnValue(promise);
  jQueryMock.ajax = mockFn;
  return { promise, resolve: resolve!, mockFn };
};

export const setupAjaxMockRejected = (error: Error): AjaxMockFn => {
  const mockFn = vi.fn().mockRejectedValue(error);
  jQueryMock.ajax = mockFn;
  return mockFn;
};

export type FetchMockFn = ReturnType<typeof vi.fn>;

export const setupFetchMock = <T>(response?: T): FetchMockFn => {
  const mockFn = vi.fn().mockResolvedValue({
    json: () => Promise.resolve(response ?? { success: true }),
  });
  global.fetch = mockFn;
  return mockFn;
};

declare const global: typeof globalThis & {
  jQuery: typeof jQueryMock;
  fetch: FetchMockFn;
};
global.jQuery = jQueryMock;
