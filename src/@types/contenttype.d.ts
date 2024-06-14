declare namespace MT.ContentType {
  interface ConfigOpts {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    [key: string]: any;
  }

  // edit_content_type.tmpl
  interface ContentFieldsOpts {
    blog_id: string;
    magic_token: string;
    return_args: string;
    id: string;
    unique_id: string;
    name: string;
    description: string;
    user_disp_option: string;
    fields: Array<Field>;
    types: Array<Type>;
    invalid_types: { [fieldType: string]: boolean };
    observer: Common.ObservableInstanceAny;
    labelField: string;
  }

  interface Field {
    type: string;
    typeLabel: string;
    canDataLabel: number;

    id?: string;
    isNew?: boolean;
    isShow?: string;
    label?: string;
    options?: Options;
    order?: number;
    realdId?: string;
    unique_id?: string;
  }

  interface FieldOption {
    [key: string]: any; // eslint-disable-line @typescript-eslint/no-explicit-any
  }

  type ObservableInstanceAny =
    import("@riotjs/observable").ObservableInstance<any>; // eslint-disable-line @typescript-eslint/no-explicit-any

  // Options can be expanded by options_pre_load_handler
  interface Options {
    [key: string]: any; // eslint-disable-line @typescript-eslint/no-explicit-any
  }

  interface SelectionValue {
    checked: string;
    label: string;
    value: string;
  }

  // edit_content_type.tmpl
  interface Type {
    data_label: number;
    icon: string;
    label: string;
    order: number;
    type: string;

    warning?: string;
  }
}
