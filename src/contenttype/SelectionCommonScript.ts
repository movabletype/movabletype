// copied some functions from selection_common_script.tmpl

import type * as ContentType from "../@types/contenttype";

export const addRow = (
  values: Array<ContentType.SelectionValue>,
): Array<ContentType.SelectionValue> => {
  values.push({ checked: "", label: "", value: "" });
  return values;
};

export const deleteRow = (
  values: Array<ContentType.SelectionValue>,
  index: number,
): Array<ContentType.SelectionValue> => {
  values.splice(index, 1);
  if (values.length === 0) {
    values = [
      {
        checked: "checked",
        label: "",
        value: "",
      },
    ];
  } else {
    let found = false;
    values.forEach(function (v: ContentType.SelectionValue) {
      if (v.checked === "checked") {
        found = true;
      }
    });
    if (!found) {
      values[0].checked = "checked";
    }
  }
  return values;
};

export const validateTable = (table: HTMLTableElement): void => {
  const jqTable = jQuery(table);
  const tableIsValidated = jqTable.data("mtValidator") ? true : false;
  if (tableIsValidated) {
    const jqNotValidatedLabelsValues = jqTable.find(
      "input[type=text]:not(.is-invalid)",
    );
    if (jqNotValidatedLabelsValues.length > 0) {
      /* @ts-expect-error : mtValidate is not defined */
      jqNotValidatedLabelsValues.mtValidate("simple");
    } else {
      /* @ts-expect-error : mtValid is not defined */
      jqTable.mtValid({ focus: false });
    }
  }
};
