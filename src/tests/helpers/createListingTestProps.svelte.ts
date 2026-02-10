import { writable, type Writable } from "svelte/store";
import { vi } from "vitest";
import type * as Listing from "../../@types/listing";
import type {
  ReactiveStoreData,
  ListStoreContext,
} from "../../listing/listStoreContext";

interface MockStoreConfig {
  count?: number;
  limit?: number;
  page?: number;
  pageMax?: number;
  columns?: Array<Listing.ListColumn>;
  showColumns?: Array<Listing.ListColumn>;
  objects?: Array<Listing.ListObject>;
  filters?: Array<Listing.Filter>;
  currentFilter?: Listing.Filter;
  allpassFilter?: Listing.Filter;
  isLoading?: boolean;
  sortBy?: string;
  sortOrder?: string;
  checkedAllRows?: boolean;
  checkedAllRowsOnPage?: boolean;
  editableCount?: number | null;
  disableUserDispOption?: boolean;
  objectType?: string;
  DefaultPage?: number;
}

export function createMockListStore(
  config: MockStoreConfig = {},
): Listing.ListStore {
  const defaultFilter: Listing.Filter = { items: [], label: "" };

  return {
    DefaultPage: config.DefaultPage ?? 1,
    allpassFilter: config.allpassFilter ?? defaultFilter,
    checkedAllRows: config.checkedAllRows ?? false,
    checkedAllRowsOnPage: config.checkedAllRowsOnPage ?? false,
    columns: config.columns ?? [],
    count: config.count ?? 0,
    currentFilter: config.currentFilter ?? defaultFilter,
    disableUserDispOption: config.disableUserDispOption ?? false,
    editableCount: config.editableCount ?? null,
    filters: config.filters ?? [],
    isLoading: config.isLoading ?? false,
    limit: config.limit ?? 25,
    objectType: config.objectType ?? "entry",
    objects: config.objects ?? [],
    page: config.page ?? 1,
    pageMax: config.pageMax ?? 1,
    showColumns: config.showColumns ?? [],
    sortBy: config.sortBy ?? "",
    sortOrder: config.sortOrder ?? "",

    addFilterItem: vi.fn(),
    addFilterItemContent: vi.fn(),
    checkAllRows: vi.fn(),
    clickRow: vi.fn(),
    createNewFilter: vi.fn(),
    getCheckedRowCount: vi.fn().mockReturnValue(0),
    getColumn: vi.fn(),
    getCheckedColumnIds: vi.fn().mockReturnValue([]),
    getCheckedRowIds: vi.fn().mockReturnValue([]),
    getFilter: vi.fn(),
    getListEnd: vi.fn().mockReturnValue(0),
    getListStart: vi.fn().mockReturnValue(0),
    getMobileColumnIndex: vi.fn().mockReturnValue(0),
    getNewFilterLabel: vi.fn().mockReturnValue("New Filter"),
    getSubField: vi.fn(),
    hasMobileColumn: vi.fn().mockReturnValue(false),
    hasSystemFilter: vi.fn().mockReturnValue(false),
    isCheckedAllRowsOnPage: vi.fn().mockReturnValue(false),
    isFilterItemSelected: vi.fn().mockReturnValue(false),
    movePage: vi.fn().mockReturnValue(true),
    removeFilterItemByIndex: vi.fn(),
    removeFilterItemContent: vi.fn(),
    resetAllClickedRows: vi.fn(),
    setFilter: vi.fn().mockReturnValue(true),
    setFilterById: vi.fn(),
    setDeleteFilterResult: vi.fn(),
    setResult: vi.fn(),
    setSaveFilterResult: vi.fn(),
    toggleAllRowsOnPage: vi.fn(),
    toggleColumn: vi.fn(),
    toggleRow: vi.fn(),
    toggleSortColumn: vi.fn(),
    toggleSubField: vi.fn(),
    resetColumns: vi.fn(),
    updateAllRowsOnPage: vi.fn(),
    updateIsLoading: vi.fn(),
    updateLimit: vi.fn(),

    listClient: createMockListClient(),
    deleteFilter: vi.fn(),
    initializeTrigger: vi.fn(),
    loadList: vi.fn(),
    renameFilter: vi.fn(),
    saveFilter: vi.fn(),
    saveListPrefs: vi.fn(),

    on: vi.fn(),
    off: vi.fn(),
    one: vi.fn(),
    trigger: vi.fn(),
  } as unknown as Listing.ListStore;
}

export function createMockListClient(): Listing.ListClient {
  return {
    datasource: "test",
    magicToken: "test-token",
    objectType: "entry",
    returnArgs: "",
    siteId: 1,
    url: "/test",

    deleteFilter: vi.fn(),
    filteredList: vi.fn(),
    renameFilter: vi.fn(),
    saveFilter: vi.fn(),
    saveListPrefs: vi.fn(),
    sendRequest: vi.fn(),
  };
}

export function createMockListActionClient(): Listing.ListActionClient {
  return {
    datasource: "test",
    magicToken: "test-token",
    objectType: "entry",
    returnArgs: "",
    siteId: 1,
    subType: "",
    url: "/test",

    createPostForm: vi.fn(),
    generateRequestData: vi.fn(),
    post: vi.fn(),
    removeFilterKeyFromReturnArgs: vi.fn().mockReturnValue(""),
    removeFilterItemFromReturnArgs: vi.fn().mockReturnValue(""),
  };
}

export function createReactiveStoreData(
  store: Listing.ListStore,
): ReactiveStoreData {
  return {
    objects: store.objects || [],
    count: store.count || 0,
    limit: store.limit || 0,
    page: store.page || 0,
    pageMax: store.pageMax || 0,
    columns: store.columns || [],
    showColumns: store.showColumns || [],
    isLoading: store.isLoading || false,
    sortBy: store.sortBy || "",
    sortOrder: store.sortOrder || "",
    filters: store.filters || [],
    currentFilter: store.currentFilter || { items: [], label: "" },
    allpassFilter: store.allpassFilter || { items: [], label: "" },
    checkedAllRows: store.checkedAllRows || false,
    checkedAllRowsOnPage: store.checkedAllRowsOnPage || false,
    editableCount: store.editableCount || null,
    disableUserDispOption: store.disableUserDispOption || false,
    objectType: store.objectType || "",
    DefaultPage: store.DefaultPage || 1,
  };
}

export function createMockListStoreContext(
  config: MockStoreConfig = {},
): ListStoreContext {
  const store = createMockListStore(config);
  const reactiveStore: Writable<ReactiveStoreData> = writable(
    createReactiveStoreData(store),
  );
  return { store, reactiveStore };
}

export function createMockColumn(
  overrides: Partial<Listing.ListColumn> = {},
): Listing.ListColumn {
  return {
    checked: 1,
    col_class: "col-test",
    default_sort_order: "ascend",
    display: 1,
    force_display: 0,
    id: "test-column",
    is_default: 1,
    label: "Test Column",
    order: "1",
    primary: 0,
    sortable: 1,
    sorted: 0,
    sub_fields: [],
    type: "string",
    ...overrides,
  };
}

export function createMockFilter(
  overrides: Partial<Listing.Filter> = {},
): Listing.Filter {
  return {
    items: [],
    label: "Test Filter",
    can_delete: 1,
    can_edit: 1,
    can_save: 1,
    id: "test-filter",
    ...overrides,
  };
}

export function createMockObject(
  overrides: Partial<Listing.ListObject> = {},
): Listing.ListObject {
  return {
    checked: false,
    clicked: false,
    object: [],
    ...overrides,
  };
}

export function createMockAction(
  label: string,
  overrides: Partial<Listing.ListAction> = {},
): Listing.ListAction {
  return {
    type: "action",
    label,
    ...overrides,
  };
}

export interface ListTableBodyPresetProps {
  context: ListStoreContext;
  hasListActions: boolean;
  hasMobilePulldownActions: boolean;
  zeroStateLabel: string;
}

export function createListTableBodyProps(
  overrides: Partial<ListTableBodyPresetProps> & {
    contextOverrides?: MockStoreConfig;
  } = {},
): ListTableBodyPresetProps {
  const { contextOverrides, ...rest } = overrides;
  return {
    context: createMockListStoreContext(contextOverrides),
    hasListActions: true,
    hasMobilePulldownActions: false,
    zeroStateLabel: "entries",
    ...rest,
  };
}

export interface ListActionsPresetProps {
  context: ListStoreContext;
  buttonActions: Listing.ButtonActions;
  hasPulldownActions: boolean;
  listActions: Listing.ListActions;
  listActionClient: Listing.ListActionClient;
  moreListActions: Listing.ListActions;
  plural: string;
  singular: string;
}

export function createListActionsProps(
  overrides: Partial<ListActionsPresetProps> & {
    contextOverrides?: MockStoreConfig;
  } = {},
): ListActionsPresetProps {
  const { contextOverrides, ...rest } = overrides;
  return {
    context: createMockListStoreContext(contextOverrides),
    buttonActions: {},
    hasPulldownActions: false,
    listActions: {},
    listActionClient: createMockListActionClient(),
    moreListActions: {},
    plural: "entries",
    singular: "entry",
    ...rest,
  };
}

export interface ListPaginationForPcPresetProps {
  context: ListStoreContext;
  movePage: ReturnType<typeof vi.fn>;
  nextDisabledProp: Record<string, string>;
  page: number;
  previousDisabledProp: Record<string, string>;
}

export function createListPaginationForPcProps(
  overrides: Partial<ListPaginationForPcPresetProps> & {
    contextOverrides?: MockStoreConfig;
  } = {},
): ListPaginationForPcPresetProps {
  const { contextOverrides, ...rest } = overrides;
  const page = rest.page ?? contextOverrides?.page ?? 1;
  const pageMax = contextOverrides?.pageMax ?? 10;
  return {
    context: createMockListStoreContext({ page, pageMax, ...contextOverrides }),
    movePage: vi.fn(),
    nextDisabledProp: page >= pageMax ? { disabled: "disabled" } : {},
    page,
    previousDisabledProp: page <= 1 ? { disabled: "disabled" } : {},
    ...rest,
  };
}

export interface DisplayOptionsLimitPresetProps {
  context: ListStoreContext;
  changeLimit: ReturnType<typeof vi.fn>;
}

export function createDisplayOptionsLimitProps(
  overrides: Partial<DisplayOptionsLimitPresetProps> & {
    contextOverrides?: MockStoreConfig;
  } = {},
): DisplayOptionsLimitPresetProps {
  const { contextOverrides, ...rest } = overrides;
  return {
    context: createMockListStoreContext({ limit: 25, ...contextOverrides }),
    changeLimit: vi.fn(),
    ...rest,
  };
}
