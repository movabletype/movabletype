import { render, fireEvent } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import { tick } from "svelte";
import Checkboxes from "./Checkboxes.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "checkboxes",
  typeLabel: "Checkboxes",
  options: {
    values: [
      { checked: "", label: "Option 1", value: "option1" },
      { checked: "", label: "Option 2", value: "option2" },
    ],
  },
};

describe("Checkboxes Component", () => {
  it("should render the values table", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Checkboxes, { props });

    const table = container.querySelector("table.values-option-table");
    expect(table).toBeInTheDocument();
  });

  it("should render table headers", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Checkboxes, { props });

    const headers = container.querySelectorAll("thead th");
    expect(headers).toHaveLength(4);
    expect(headers[0]).toHaveTextContent("Selected");
    expect(headers[1]).toHaveTextContent("Label");
    expect(headers[2]).toHaveTextContent("Value");
  });

  it("should render checkboxes for each value option", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Checkboxes, { props });

    const checkboxes = container.querySelectorAll(
      'tbody input[type="checkbox"]',
    );
    expect(checkboxes).toHaveLength(2);
  });

  it("should render label and value input fields for each row", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Checkboxes, { props });

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

    render(Checkboxes, { props });
    await tick();

    expect(props.options.values).toBeDefined();
    expect(props.options.values).toHaveLength(1);
    expect(props.options.values[0]).toEqual({
      checked: "",
      label: "",
      value: "",
    });
  });

  it("should allow multiple checkboxes to be selected", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        values: [
          { checked: "", label: "A", value: "a" },
          { checked: "", label: "B", value: "b" },
        ],
      },
    });

    const { container } = render(Checkboxes, { props });
    const checkboxes = container.querySelectorAll(
      'tbody input[type="checkbox"]',
    );

    await fireEvent.click(checkboxes[0]);
    await fireEvent.click(checkboxes[1]);
    await tick();

    expect(props.options.values[0].checked).toBe("checked");
    expect(props.options.values[1].checked).toBe("checked");
  });

  it("should add a new row when add button is clicked", async () => {
    const props = createTestProps(presetProps);
    const { container } = render(Checkboxes, { props });

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

    const { container } = render(Checkboxes, { props });
    const deleteButtons = container.querySelectorAll(
      "tbody button.btn-default",
    );

    await fireEvent.click(deleteButtons[0]);
    await tick();

    expect(props.options.values).toHaveLength(1);
    expect(props.options.values[0].label).toBe("B");
  });

  it("should render min and max selection inputs", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Checkboxes, { props });

    const minInput = container.querySelector('input[name="min"]');
    const maxInput = container.querySelector('input[name="max"]');

    expect(minInput).toBeInTheDocument();
    expect(maxInput).toBeInTheDocument();
  });

  it("should update label value when input changes", async () => {
    const props = createTestProps(presetProps);
    const { container } = render(Checkboxes, { props });

    const labelInputs = container.querySelectorAll('tbody input[name="label"]');
    await fireEvent.input(labelInputs[0], { target: { value: "New Label" } });
    await tick();

    const input = labelInputs[0] as HTMLInputElement;
    expect(input.value).toBe("New Label");
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

    const { container } = render(Checkboxes, { props });

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
