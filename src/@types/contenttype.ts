import type { Writable } from "svelte/store";

export interface ConfigSettings {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  [key: string]: any;
}

// order is same as in edit_content_type.tmpl
export interface ContentFieldsOpts {
  blog_id: string;
  magic_token: string;
  return_args: string;
  id: string;
  unique_id: string;
  name: string;
  description: string;
  user_disp_option: string;
  fields: Fields;
  types: Array<Type>;
  invalid_types: { [fieldType: string]: boolean };
  observer: ObservableInstanceAny;
  labelField: string;
}

// used in Custom.svelte
export type CustomContentFieldMountFunction = (
  props: {
    config: ConfigSettings;
    fieldIndex: number;
    fieldsStore: FieldsStore;
    optionsHtmlParams: OptionsHtmlParams;
  },
  target: Element,
) => CustomContentFieldObject;

// used in Custom.svelte
export interface CustomContentFieldObject {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  component: any;
  destroy: () => void;
  gather?: () => object;
}

// used in ContentFieldOpts
export interface Field {
  type: string;
  typeLabel: string;
  canDataLabel: number;

  id?: string;
  isNew?: boolean;
  isShow?: string;
  label?: string;
  options?: Options;
  order?: number;
  realId?: string;
  unique_id?: string;
}

export type Fields = Array<Field>;

export type FieldsStore = Writable<Fields>;

export type ObservableInstanceAny =
  import("@riotjs/observable").ObservableInstance<any>; // eslint-disable-line @typescript-eslint/no-explicit-any

// used in Field
export interface Options {
  [key: string]: any; // eslint-disable-line @typescript-eslint/no-explicit-any
}

export interface OptionsHtmlParams {
  [key: string]: any; // eslint-disable-line @typescript-eslint/no-explicit-any
}

// used in Checkboxes, RadioButton and SelctBox
export interface SelectionValue {
  checked: string;
  label: string;
  value: string;
}

export interface SubmitFieldOption {
  [key: string]: any; // eslint-disable-line @typescript-eslint/no-explicit-any
}

// used in ContentFieldsOpts
export interface Type {
  data_label: number;
  icon: string;
  label: string;
  order: number;
  type: string;

  warning?: string;
}
