import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import { tick } from "svelte";
import Time from "./Time.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "time-only",
  typeLabel: "Time",
  options: {
    initial_value: "",
  },
};

describe("Time Component", () => {
  it("should render the component", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Time, { props });

    expect(container).toBeTruthy();
  });

  it("should render initial_value input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Time, { props });

    const input = container.querySelector('input[name="initial_value"]');
    expect(input).toBeInTheDocument();
    expect(input).toHaveAttribute("type", "text");
  });

  it("should have time field class", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Time, { props });

    const input = container.querySelector('input[name="initial_value"]');
    expect(input).toHaveClass("time-field");
  });

  it("should have HH:mm:ss placeholder", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Time, { props });

    const input = container.querySelector('input[name="initial_value"]');
    expect(input).toHaveAttribute("placeholder", "HH:mm:ss");
  });

  it("should display existing initial_value", () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        initial_value: "14:30:00",
      },
    });

    const { container } = render(Time, { props });

    const input = container.querySelector(
      'input[name="initial_value"]',
    ) as HTMLInputElement;
    expect(input.value).toBe("14:30:00");
  });

  it("should set default initial_value when undefined", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {},
    });

    const { container } = render(Time, { props });
    await tick();

    const input = container.querySelector(
      'input[name="initial_value"]',
    ) as HTMLInputElement;
    expect(input.value).toBe("");
  });

  it("should render Initial Value label", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Time, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(labelTexts).toContain("Initial Value");
  });
});
