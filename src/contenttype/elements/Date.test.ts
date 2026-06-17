import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import { tick } from "svelte";
import Date from "./Date.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "date-only",
  typeLabel: "Date",
  options: {
    initial_value: "",
  },
};

describe("Date Component", () => {
  it("should render the component", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Date, { props });

    expect(container).toBeTruthy();
  });

  it("should render initial_value input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Date, { props });

    const input = container.querySelector('input[name="initial_value"]');
    expect(input).toBeInTheDocument();
    expect(input).toHaveAttribute("type", "text");
  });

  it("should have date field class", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Date, { props });

    const input = container.querySelector('input[name="initial_value"]');
    expect(input).toHaveClass("date-field");
  });

  it("should have YYYY-MM-DD placeholder", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Date, { props });

    const input = container.querySelector('input[name="initial_value"]');
    expect(input).toHaveAttribute("placeholder", "YYYY-MM-DD");
  });

  it("should display existing initial_value", () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        initial_value: "2024-01-15",
      },
    });

    const { container } = render(Date, { props });

    const input = container.querySelector(
      'input[name="initial_value"]',
    ) as HTMLInputElement;
    expect(input.value).toBe("2024-01-15");
  });

  it("should set default initial_value when undefined", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {},
    });

    const { container } = render(Date, { props });
    await tick();

    const input = container.querySelector(
      'input[name="initial_value"]',
    ) as HTMLInputElement;
    expect(input.value).toBe("");
  });

  it("should render Initial Value label", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Date, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(labelTexts).toContain("Initial Value");
  });
});
