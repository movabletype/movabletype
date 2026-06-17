import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import { tick } from "svelte";
import SingleLineText from "./SingleLineText.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "single-line-text",
  typeLabel: "Single Line Text",
  options: {
    min_length: 0,
    max_length: 255,
    initial_value: "",
  },
};

describe("SingleLineText Component", () => {
  it("should render the component", () => {
    const props = createTestProps(presetProps);
    const { container } = render(SingleLineText, { props });

    expect(container).toBeTruthy();
  });

  it("should render min_length input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(SingleLineText, { props });

    const minLengthInput = container.querySelector('input[name="min_length"]');
    expect(minLengthInput).toBeInTheDocument();
    expect(minLengthInput).toHaveAttribute("type", "number");
  });

  it("should render max_length input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(SingleLineText, { props });

    const maxLengthInput = container.querySelector('input[name="max_length"]');
    expect(maxLengthInput).toBeInTheDocument();
    expect(maxLengthInput).toHaveAttribute("type", "number");
  });

  it("should render initial_value input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(SingleLineText, { props });

    const initialValueInput = container.querySelector(
      'input[name="initial_value"]',
    );
    expect(initialValueInput).toBeInTheDocument();
    expect(initialValueInput).toHaveAttribute("type", "text");
  });

  it("should display existing option values", () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        min_length: 5,
        max_length: 100,
        initial_value: "Hello",
      },
    });

    const { container } = render(SingleLineText, { props });

    const minLengthInput = container.querySelector(
      'input[name="min_length"]',
    ) as HTMLInputElement;
    const maxLengthInput = container.querySelector(
      'input[name="max_length"]',
    ) as HTMLInputElement;
    const initialValueInput = container.querySelector(
      'input[name="initial_value"]',
    ) as HTMLInputElement;

    expect(minLengthInput.value).toBe("5");
    expect(maxLengthInput.value).toBe("100");
    expect(initialValueInput.value).toBe("Hello");
  });

  it("should display default values when options are undefined", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {},
    });

    const { container } = render(SingleLineText, { props });
    await tick();

    const minLengthInput = container.querySelector(
      'input[name="min_length"]',
    ) as HTMLInputElement;
    const maxLengthInput = container.querySelector(
      'input[name="max_length"]',
    ) as HTMLInputElement;
    const initialValueInput = container.querySelector(
      'input[name="initial_value"]',
    ) as HTMLInputElement;

    expect(minLengthInput.value).toBe("0");
    expect(maxLengthInput.value).toBe("255");
    expect(initialValueInput.value).toBe("");
  });

  it("should render labels for each option", () => {
    const props = createTestProps(presetProps);
    const { container } = render(SingleLineText, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(labelTexts).toContain("Min Length");
    expect(labelTexts).toContain("Max Length");
    expect(labelTexts).toContain("Initial Value");
  });

  it("should have correct min attribute on min_length input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(SingleLineText, { props });

    const minLengthInput = container.querySelector('input[name="min_length"]');
    expect(minLengthInput).toHaveAttribute("min", "0");
  });

  it("should have correct min attribute on max_length input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(SingleLineText, { props });

    const maxLengthInput = container.querySelector('input[name="max_length"]');
    expect(maxLengthInput).toHaveAttribute("min", "1");
  });
});
