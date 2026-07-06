import { render, fireEvent } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import { tick } from "svelte";
import SelectBox from "./SelectBox.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "select-box",
  typeLabel: "Select Box",
  options: {
    multiple: false,
    min: "",
    max: "",
    values: [
      { checked: "", label: "Option 1", value: "option1" },
      { checked: "", label: "Option 2", value: "option2" },
    ],
  },
};

describe("SelectBox Component", () => {
  it("should render the component", () => {
    const props = createTestProps(presetProps);
    const { container } = render(SelectBox, { props });

    expect(container).toBeTruthy();
  });

  it("should render the values table", () => {
    const props = createTestProps(presetProps);
    const { container } = render(SelectBox, { props });

    const table = container.querySelector("table.values-option-table");
    expect(table).toBeInTheDocument();
  });

  it("should render table headers", () => {
    const props = createTestProps(presetProps);
    const { container } = render(SelectBox, { props });

    const headers = container.querySelectorAll("thead th");
    expect(headers).toHaveLength(4);
    expect(headers[0]).toHaveTextContent("Selected");
    expect(headers[1]).toHaveTextContent("Label");
    expect(headers[2]).toHaveTextContent("Value");
  });

  it("should render checkboxes for each value option", () => {
    const props = createTestProps(presetProps);
    const { container } = render(SelectBox, { props });

    const checkboxes = container.querySelectorAll(
      'tbody input[type="checkbox"]',
    );
    expect(checkboxes).toHaveLength(2);
  });

  it("should render multiple selection checkbox", () => {
    const props = createTestProps(presetProps);
    const { container } = render(SelectBox, { props });

    const multipleCheckbox = container.querySelector('input[name="multiple"]');
    expect(multipleCheckbox).toBeInTheDocument();
  });

  it("should render min and max inputs", () => {
    const props = createTestProps(presetProps);
    const { container } = render(SelectBox, { props });

    const minInput = container.querySelector('input[name="min"]');
    const maxInput = container.querySelector('input[name="max"]');

    expect(minInput).toBeInTheDocument();
    expect(maxInput).toBeInTheDocument();
  });

  it("should set default values when options.values is undefined", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {},
    });

    render(SelectBox, { props });
    await tick();

    expect(props.options.values).toBeDefined();
    expect(props.options.values).toHaveLength(1);
    expect(props.options.values[0]).toEqual({
      checked: "",
      label: "",
      value: "",
    });
  });

  it("should add a new row when add button is clicked", async () => {
    const props = createTestProps(presetProps);
    const { container } = render(SelectBox, { props });

    const initialRowCount = props.options.values.length;
    const addButton = container.querySelector(
      "button.btn-default:not(tbody button)",
    );

    await fireEvent.click(addButton!);
    await tick();

    expect(props.options.values).toHaveLength(initialRowCount + 1);
  });

  it("should remove a row when delete button is clicked", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        ...presetProps.options,
        values: [
          { checked: "", label: "A", value: "a" },
          { checked: "", label: "B", value: "b" },
        ],
      },
    });

    const { container } = render(SelectBox, { props });
    const deleteButtons = container.querySelectorAll(
      "tbody button.btn-default",
    );

    await fireEvent.click(deleteButtons[0]);
    await tick();

    expect(props.options.values).toHaveLength(1);
    expect(props.options.values[0].label).toBe("B");
  });

  it("should display existing values in input fields", () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        ...presetProps.options,
        values: [
          { checked: "", label: "Existing Label", value: "existing-value" },
        ],
      },
    });

    const { container } = render(SelectBox, { props });

    const labelInput = container.querySelector(
      'tbody input[name="label"]',
    ) as HTMLInputElement;
    const valueInput = container.querySelector(
      'tbody input[name="value"]',
    ) as HTMLInputElement;

    expect(labelInput.value).toBe("Existing Label");
    expect(valueInput.value).toBe("existing-value");
  });

  it("should render labels for options", () => {
    const props = createTestProps(presetProps);
    const { container } = render(SelectBox, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(labelTexts).toContain("Allow users to select multiple values?");
    expect(labelTexts.some((text) => text?.includes("Values"))).toBe(true);
  });
});
