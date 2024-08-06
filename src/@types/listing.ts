// list_common.tmpl
export type ButtonAction = ListAction;

// list_common.tmpl
export interface ButtonActions {
  [key: string]: ButtonAction;
}

// lib/MT/CMS/Filter.pm
export interface Filter {
  items: Array<Item>;
  label: string;

  can_delete?: number;
  can_edit?: number;
  can_save?: number;
  id?: string;
  legacy?: number;
  order?: number;
}

// list_common.tmpl
export interface FilterType {
  baseType: string;
  field: string;
  label: string;
  type: string;

  editable?: boolean;
  singleton?: boolean;
}

export interface Item {
  args: { items: Array<Item> };
  type: string;
}

// list_common.tmpl
export interface ListAction {
  type: string;

  continue_prompt?: string;
  dialog?: number;
  input?: string;
  js?: string;
  js_message?: string;
  label?: string;
  max?: string;
  min?: string;
  mobile?: boolean;
  mode?: string;
  no_prompt?: string;
  xhr?: boolean;
}

// list_action_client.js
export interface ListActionClient {
  datasource: string;
  magicToken: string;
  objectType: string;
  returnArgs: string;
  siteId: number;
  subType: string;
  url: string;

  createPostForm: (args: object) => JQuery<HTMLFormElement>;
  generateRequestData: (args: object) => object;
  post: (obj: object) => void;
  removeFilterKeyFromReturnArgs: () => string;
  removeFilterItemFromReturnArgs: () => string;
}

// list_client.js
export interface ListClient {
  datasource: string;
  magicToken: string;
  objectType: string;
  returnArgs: string;
  siteId: number;
  url: string;

  deleteFilter: (args: object) => void;
  filteredList: (args: object) => void;
  renameFilter: (args: object) => void;
  saveFilter: (args: object) => void;
  saveListPrefs: (args: object) => void;
  sendRequest: (args: object, data: object) => void;
}

// list_common.tmpl
export interface ListActions {
  [key: string]: ListAction;
}

// list_common.tmpl
export interface ListColumn {
  checked: number;
  col_class: string;
  default_sort_order: string;
  display: number;
  force_display: number;
  id: string;
  is_default: number;
  label: string;
  order: string;
  primary: number;
  sortable: number;
  sorted: number;
  sub_fields: Array<SubField>;
  type: string;
}

// list_data.js
export interface ListData {
  DefaultPage: number;
  allpassFilter: Filter;
  checkedAllRows: boolean;
  checkedAllRowsOnPage: boolean;
  columns: Array<ListColumn>;
  count: number | null;
  currentFilter: Filter;
  disableUserDispOption: boolean;
  editableCount: number | null;
  filters: Array<Filter>;
  isLoading: boolean;
  limit: number | null;
  objectType: string;
  objects: Array<ListObject> | null;
  page: number | null;
  pageMax: number;
  showColumns: Array<ListColumn>;
  sortBy: string;
  sortOrder: string;

  addFilterItem: (filterItem: string) => void;
  addFilterItemContent: (itemIndex: string, contentIndex: number) => void;
  checkAllRows: () => void;
  clickRow: () => void;
  createNewFilter: (filterLabel: string) => void;
  getCheckedRowCount: () => number;
  getColumn: (columnId: string) => void;
  getCheckedColumnIds: () => Array<string>;
  getCheckedRowIds: () => Array<string>;
  getFilter: (filterId: string) => Filter | null | undefined;
  getListEnd: () => number;
  getListStart: () => number;
  getMobileColumnIndex: () => number;
  getNewFilterLabel: (objectLabel: string) => string;
  getSubField: (subFieldId: string) => SubField;
  hasMobileColumn: () => boolean;
  hasSystemFilter: () => boolean;
  isCheckedAllRowsOnPage: () => boolean;
  isFilterItemSelected: (type: string) => boolean;
  movePage: (page: number) => boolean;
  removeFilterItemByIndex: (itemIndex: string) => void;
  removeFilterItemContent: (itemIndex: string, contentIndex: number) => void;
  resetAllClickedRows: () => void;
  setFilter: (filter: Filter) => boolean;
  setFilterById: (filterId: string) => boolean | void;
  setDeleteFilterResult: (result: object) => void;
  setResult: (result: Result) => void;
  setSaveFilterResult: (result: object) => void;
  toggleAllRowsOnPage: () => void;
  toggleColumn: (columnId: string) => void;
  toggleRow: (rowIndex: string) => void;
  toggleSortColumn: (columnId: string) => void;
  toggleSubField: (subFieldId: string) => void;
  resetColumns: () => void;
  updateAllRowsOnPage: (nextState: boolean) => void;
  updateIsLoading: (nextState: boolean) => void;
  updateLimit: (limit: number) => void;
}

// list_data.js
export interface ListObject {
  checked: boolean;
  object: Array<string | number>;

  clicked?: boolean;
}

// list_store.js
export interface ListStore extends ListData, ObservableInstanceAny {
  listClient: ListClient;

  deleteFilter: (filterId: string) => void;
  initializeTrigger: () => void;
  loadList: (args: object) => void;
  renameFilter: (filterId: string, filterLabel: string) => void;
  saveFilter: () => void;
  saveListPrefs: () => void;
}

// list_common.tmpl
export type MoreListAction = ListAction;

// list_common.tmpl
export interface MoreListActions {
  [key: string]: MoreListAction;
}

// list_store.js
export type ObservableInstanceAny =
  import("@riotjs/observable").ObservableInstance<any>; // eslint-disable-line @typescript-eslint/no-explicit-any

// list_data.js
export interface Result {
  columns: string;
  count: number;
  editable_count: number;
  filters: Array<Filter>;
  id: string;
  messages: Array<string>;
  objects: Array<ListObject>;
  page: string;
  page_max: number;

  debug?: string;
  label?: string;
}

// list_common.tmpl
export interface SubField {
  class: string;
  checked: number;
  display: number;
  force_display: number;
  id: string;
  is_default: number;
  label: string;
  parent_id: string;
}
