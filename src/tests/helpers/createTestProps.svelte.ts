import { writable } from "svelte/store";
import type * as ContentType from "../../@types/contenttype";

type FieldOverrides = Partial<ContentType.Field>;
type OptionsOverrides = Partial<ContentType.Options>;
interface TestPropsConfig {
  type: string;
  typeLabel: string;
  field?: FieldOverrides;
  options?: OptionsOverrides;
  optionsHtmlParams?: Record<string, unknown>;
  config?: Record<string, unknown>;
}

interface FieldConfig {
  id?: string;
  type?: string;
  typeLabel?: string;
  label?: string;
  options?: Record<string, unknown>;
  isNew?: boolean;
}

interface FieldsStoreConfig {
  fields: Array<FieldConfig>;
}

export function createFieldsStore(
  config: FieldsStoreConfig,
): ContentType.FieldsStore {
  const fields: ContentType.Fields = config.fields.map((field, index) => ({
    id: field.id ?? `test-field-${index}`,
    type: field.type ?? "test-type",
    typeLabel: field.typeLabel ?? "Test Type",
    canDataLabel: 1,
    label: field.label ?? "Test Field",
    options: field.options ?? {},
    isNew: field.isNew ?? false,
  }));
  return writable(fields);
}

export function createTestProps(
  propsConfig: TestPropsConfig,
): ContentType.ContentFieldProps & { type: string } {
  const field = $state({
    type: propsConfig.type,
    typeLabel: propsConfig.typeLabel,
    canDataLabel: 1,
    id: `test-${propsConfig.type}-1`,
    label: "Test Field",
    ...propsConfig.field,
  });

  const options = $state({
    ...propsConfig.options,
  });

  return {
    config: propsConfig.config ?? {},
    field,
    gather: undefined,
    id: `test-${propsConfig.type}`,
    options,
    optionsHtmlParams: propsConfig.optionsHtmlParams ?? {},
    type: propsConfig.type,
  };
}
