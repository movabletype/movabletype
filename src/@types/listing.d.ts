export interface ButtonAction extends ListAction {
  js_message: string;
}

export interface ButtonActions {
  [key: string]: ButtonAction;
}

export interface Filter {}

interface FilterType {
  baseType: string;
  field: string;
  label: string;
  type: string;

  editable?: boolean;
  singleton?: boolean;
}

export interface ListAction {
  type: string;

  continue_prompt?: string;
  dialog?: number;
  input?: string;
  js?: string;
  label?: string;
  max?: string;
  min?: string;
  mobile?: boolean;
  mode?: string;
  no_prompt?: string;
  xhr?: boolean;
}

export interface ListActionClient {}

export interface ListActions {
  [key: string]: ListAction;
}

interface ListColumn {
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

interface ListData {
  DefaultPage: number;

  checkedAllRows: boolean;
  checkedAllRowsOnPage: boolean;
  columns: Array<ListColumn>;
  count: number | null;
  currentFilter: Filter;
  disableUserDispOption: boolean;
  isLoading: boolean;
  limit: number | null;
  page: number | null;
  pageMax: number;

  addFilterItem: () => void;
  addFilterItemContent: (itemIndex: string, contentIndex: number) => void;
  checkAllRows: () => void;
  clickRow: () => void;
  createNewFilter: (filterLabel: string) => void;
  getCheckedRowCount: () => number;
  getColumn: (columnId: number) => void;
  getCheckedColumnIds: () => Array<string>;
  getCheckedRowIds: () => Array<string>;
  getFilter: (filterId: string) => Filter | null;
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
  removeFilterItemContent: (itemIndex: string, contentIndex: string) => void;
  resetAllClickedRows: () => void;
  setFilter: (filter: Filter) => boolean;
  setFilterById: (filterId: string) => void | boolean;
  setDeleteFilterResult: (result: Result) => void;
  setResult: (result: Result) => void;
  setSaveFilterResult: (result: Result) => void;
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

export interface ListObject {}

export interface ListStore extends ListData {
  trigger: (event: string, ...args: string[]) => void;
}

export interface MoreListAction extends ListAction {}

export interface MoreListActions {
  [key: string]: MoreListAction;
}

interface Result {
  columns: Array<ListColumn>;
  count: number;
  editable_count: number;
  filters: Array<Filter>;
  objects: Array<ListObject>;
  page_max: number;
}

interface SubField {
  class: string;
  checked: number;
  display: number;
  id: string;
  is_default: number;
  label: string;
  parent_id: string;
}
