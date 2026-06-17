import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import { tick } from "svelte";
import Tables from "./Tables.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "table",
  typeLabel: "Table",
  options: {
    initial_rows: 1,
    initial_cols: 1,
    increase_decrease_rows: false,
    increase_decrease_cols: false,
  },
};

describe("Tables Component", () => {
  it("should render the component", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Tables, { props });

    expect(container).toBeTruthy();
  });

  it("should render initial_rows input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Tables, { props });

    const input = container.querySelector('input[name="initial_rows"]');
    expect(input).toBeInTheDocument();
    expect(input).toHaveAttribute("type", "number");
  });

  it("should render initial_cols input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Tables, { props });

    const input = container.querySelector('input[name="initial_cols"]');
    expect(input).toBeInTheDocument();
    expect(input).toHaveAttribute("type", "number");
  });

  it("should render increase_decrease_rows checkbox", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Tables, { props });

    const checkbox = container.querySelector(
      'input[name="increase_decrease_rows"]',
    );
    expect(checkbox).toBeInTheDocument();
    expect(checkbox).toHaveAttribute("type", "checkbox");
  });

  it("should render increase_decrease_cols checkbox", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Tables, { props });

    const checkbox = container.querySelector(
      'input[name="increase_decrease_cols"]',
    );
    expect(checkbox).toBeInTheDocument();
    expect(checkbox).toHaveAttribute("type", "checkbox");
  });

  it("should display existing values", () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        initial_rows: 3,
        initial_cols: 5,
        increase_decrease_rows: true,
        increase_decrease_cols: true,
      },
    });

    const { container } = render(Tables, { props });

    const rowsInput = container.querySelector(
      'input[name="initial_rows"]',
    ) as HTMLInputElement;
    const colsInput = container.querySelector(
      'input[name="initial_cols"]',
    ) as HTMLInputElement;

    expect(rowsInput.value).toBe("3");
    expect(colsInput.value).toBe("5");
  });

  it("should set default values when undefined", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {},
    });

    const { container } = render(Tables, { props });
    await tick();

    const rowsInput = container.querySelector(
      'input[name="initial_rows"]',
    ) as HTMLInputElement;
    const colsInput = container.querySelector(
      'input[name="initial_cols"]',
    ) as HTMLInputElement;

    expect(rowsInput.value).toBe("1");
    expect(colsInput.value).toBe("1");
  });

  it("should render labels for options", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Tables, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(labelTexts).toContain("Initial Rows");
    expect(labelTexts).toContain("Initial Cols");
  });

  it("should have min attribute of 1 on row and col inputs", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Tables, { props });

    const rowsInput = container.querySelector('input[name="initial_rows"]');
    const colsInput = container.querySelector('input[name="initial_cols"]');

    expect(rowsInput).toHaveAttribute("min", "1");
    expect(colsInput).toHaveAttribute("min", "1");
  });
});
