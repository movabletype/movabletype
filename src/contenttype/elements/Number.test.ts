import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import { tick } from "svelte";
import Number from "./Number.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "number",
  typeLabel: "Number",
  options: {
    min_value: -999999999,
    max_value: 999999999,
    decimal_places: 0,
    initial_value: "",
  },
  config: {
    NumberFieldMinValue: -999999999,
    NumberFieldMaxValue: 999999999,
    NumberFieldDecimalPlaces: 10,
  },
};

describe("Number Component", () => {
  it("should render the component", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Number, { props });

    expect(container).toBeTruthy();
  });

  it("should render min_value input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Number, { props });

    const minValueInput = container.querySelector('input[name="min_value"]');
    expect(minValueInput).toBeInTheDocument();
    expect(minValueInput).toHaveAttribute("type", "number");
  });

  it("should render max_value input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Number, { props });

    const maxValueInput = container.querySelector('input[name="max_value"]');
    expect(maxValueInput).toBeInTheDocument();
    expect(maxValueInput).toHaveAttribute("type", "number");
  });

  it("should render decimal_places input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Number, { props });

    const decimalPlacesInput = container.querySelector(
      'input[name="decimal_places"]',
    );
    expect(decimalPlacesInput).toBeInTheDocument();
    expect(decimalPlacesInput).toHaveAttribute("type", "number");
  });

  it("should render initial_value input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Number, { props });

    const initialValueInput = container.querySelector(
      'input[name="initial_value"]',
    );
    expect(initialValueInput).toBeInTheDocument();
    expect(initialValueInput).toHaveAttribute("type", "number");
  });

  it("should display existing option values", () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        min_value: 0,
        max_value: 100,
        decimal_places: 2,
        initial_value: "50",
      },
    });

    const { container } = render(Number, { props });

    const minValueInput = container.querySelector(
      'input[name="min_value"]',
    ) as HTMLInputElement;
    const maxValueInput = container.querySelector(
      'input[name="max_value"]',
    ) as HTMLInputElement;
    const decimalPlacesInput = container.querySelector(
      'input[name="decimal_places"]',
    ) as HTMLInputElement;
    const initialValueInput = container.querySelector(
      'input[name="initial_value"]',
    ) as HTMLInputElement;

    expect(minValueInput.value).toBe("0");
    expect(maxValueInput.value).toBe("100");
    expect(decimalPlacesInput.value).toBe("2");
    expect(initialValueInput.value).toBe("50");
  });

  it("should set default values when options are undefined", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {},
    });

    const { container } = render(Number, { props });
    await tick();

    const minValueInput = container.querySelector(
      'input[name="min_value"]',
    ) as HTMLInputElement;
    const maxValueInput = container.querySelector(
      'input[name="max_value"]',
    ) as HTMLInputElement;
    const decimalPlacesInput = container.querySelector(
      'input[name="decimal_places"]',
    ) as HTMLInputElement;
    const initialValueInput = container.querySelector(
      'input[name="initial_value"]',
    ) as HTMLInputElement;

    expect(minValueInput.value).toBe("-999999999");
    expect(maxValueInput.value).toBe("999999999");
    expect(decimalPlacesInput.value).toBe("0");
    expect(initialValueInput.value).toBe("");
  });

  it("should render labels for each option", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Number, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(labelTexts).toContain("Min Value");
    expect(labelTexts).toContain("Max Value");
    expect(labelTexts).toContain("Number of decimal places");
    expect(labelTexts).toContain("Initial Value");
  });

  it("should have correct min and max attributes from config", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Number, { props });

    const minValueInput = container.querySelector('input[name="min_value"]');
    const maxValueInput = container.querySelector('input[name="max_value"]');

    expect(minValueInput).toHaveAttribute("min", "-999999999");
    expect(minValueInput).toHaveAttribute("max", "999999999");
    expect(maxValueInput).toHaveAttribute("min", "-999999999");
    expect(maxValueInput).toHaveAttribute("max", "999999999");
  });

  it("should have correct max attribute on decimal_places input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Number, { props });

    const decimalPlacesInput = container.querySelector(
      'input[name="decimal_places"]',
    );
    expect(decimalPlacesInput).toHaveAttribute("min", "0");
    expect(decimalPlacesInput).toHaveAttribute("max", "10");
  });
});
