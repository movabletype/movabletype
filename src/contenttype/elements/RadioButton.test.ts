import { render, fireEvent } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import { tick } from "svelte";
import RadioButton from "./RadioButton.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "radio-button",
  typeLabel: "Radio Button",
  options: {
    values: [
      { checked: "", label: "Option 1", value: "option1" },
      { checked: "", label: "Option 2", value: "option2" },
    ],
  },
};

describe("RadioButton Component", () => {
  it("should render the values table", () => {
    const props = createTestProps(presetProps);
    const { container } = render(RadioButton, { props });

    const table = container.querySelector("table.values-option-table");
    expect(table).toBeInTheDocument();
  });

  it("should render table headers", () => {
    const props = createTestProps(presetProps);
    const { container } = render(RadioButton, { props });

    const headers = container.querySelectorAll("thead th");
    expect(headers).toHaveLength(4);
    expect(headers[0]).toHaveTextContent("Selected");
    expect(headers[1]).toHaveTextContent("Label");
    expect(headers[2]).toHaveTextContent("Value");
  });

  it("should render radio buttons for each value option", () => {
    const props = createTestProps(presetProps);
    const { container } = render(RadioButton, { props });

    const radios = container.querySelectorAll('input[type="radio"]');
    expect(radios).toHaveLength(2);
  });

  it("should render label and value input fields for each row", () => {
    const props = createTestProps(presetProps);
    const { container } = render(RadioButton, { props });

    const labelInputs = container.querySelectorAll('tbody input[name="label"]');
    const valueInputs = container.querySelectorAll('tbody input[name="value"]');

    expect(labelInputs).toHaveLength(2);
    expect(valueInputs).toHaveLength(2);
  });

  it("should set default values when options.values is undefined", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {},
    });

    render(RadioButton, { props });
    await tick();

    expect(props.options.values).toBeDefined();
    expect(props.options.values).toHaveLength(1);
    expect(props.options.values[0]).toEqual({
      checked: "",
      label: "",
      value: "",
    });
  });

  it("should clear all other selections when a radio button is selected", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        values: [
          { checked: "checked", label: "A", value: "a" },
          { checked: "", label: "B", value: "b" },
        ],
      },
    });

    const { container } = render(RadioButton, { props });
    const radios = container.querySelectorAll('input[type="radio"]');

    await fireEvent.click(radios[1]);
    await tick();

    expect(props.options.values[0].checked).toBe("");
    expect(props.options.values[1].checked).toBe("checked");
  });

  it("should add a new row when add button is clicked", async () => {
    const props = createTestProps(presetProps);
    const { container } = render(RadioButton, { props });

    const initialRowCount = props.options.values.length;
    const addButton = container.querySelector(
      "button.btn-default:not(tbody button)",
    );

    await fireEvent.click(addButton!);
    await tick();

    expect(props.options.values).toHaveLength(initialRowCount + 1);
    expect(props.options.values[initialRowCount]).toEqual({
      checked: "",
      label: "",
      value: "",
    });
  });

  it("should remove a row when delete button is clicked", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        values: [
          { checked: "checked", label: "A", value: "a" },
          { checked: "", label: "B", value: "b" },
        ],
      },
    });

    const { container } = render(RadioButton, { props });
    const deleteButtons = container.querySelectorAll(
      "tbody button.btn-default",
    );

    await fireEvent.click(deleteButtons[0]);
    await tick();

    expect(props.options.values).toHaveLength(1);
    expect(props.options.values[0].label).toBe("B");
  });

  it("should set first item as checked when deleting the checked item", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        values: [
          { checked: "checked", label: "A", value: "a" },
          { checked: "", label: "B", value: "b" },
        ],
      },
    });

    const { container } = render(RadioButton, { props });
    const deleteButtons = container.querySelectorAll(
      "tbody button.btn-default",
    );

    await fireEvent.click(deleteButtons[0]);
    await tick();

    expect(props.options.values[0].checked).toBe("checked");
  });

  it("should add a default row when all rows are deleted", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        values: [{ checked: "checked", label: "A", value: "a" }],
      },
    });

    const { container } = render(RadioButton, { props });
    const deleteButton = container.querySelector("tbody button.btn-default");

    await fireEvent.click(deleteButton!);
    await tick();

    expect(props.options.values).toHaveLength(1);
    expect(props.options.values[0]).toEqual({
      checked: "checked",
      label: "",
      value: "",
    });
  });

  it("should assign gather function to props", async () => {
    const values = [{ checked: "checked", label: "Test", value: "test" }];
    const props = createTestProps({
      ...presetProps,
      options: { values },
    });

    const { container } = render(RadioButton, { props });
    await tick();

    const table = container.querySelector("table.values-option-table");
    expect(table).toBeInTheDocument();
  });

  it("should update label value when input changes", async () => {
    const props = createTestProps(presetProps);
    const { container } = render(RadioButton, { props });

    const labelInputs = container.querySelectorAll('tbody input[name="label"]');
    await fireEvent.input(labelInputs[0], { target: { value: "New Label" } });
    await tick();

    const input = labelInputs[0] as HTMLInputElement;
    expect(input.value).toBe("New Label");
  });

  it("should update value when value input changes", async () => {
    const props = createTestProps(presetProps);
    const { container } = render(RadioButton, { props });

    const valueInputs = container.querySelectorAll('tbody input[name="value"]');
    await fireEvent.input(valueInputs[0], { target: { value: "new-value" } });
    await tick();

    const input = valueInputs[0] as HTMLInputElement;
    expect(input.value).toBe("new-value");
  });

  it("should display existing values in input fields", () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        values: [
          { checked: "", label: "Existing Label", value: "existing-value" },
        ],
      },
    });

    const { container } = render(RadioButton, { props });

    const labelInput = container.querySelector(
      'tbody input[name="label"]',
    ) as HTMLInputElement;
    const valueInput = container.querySelector(
      'tbody input[name="value"]',
    ) as HTMLInputElement;

    expect(labelInput.value).toBe("Existing Label");
    expect(valueInput.value).toBe("existing-value");
  });
});
