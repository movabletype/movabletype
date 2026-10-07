import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import { tick } from "svelte";
import DateTime from "./DateTime.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "date-and-time",
  typeLabel: "Date and Time",
  options: {
    initial_date: "",
    initial_time: "",
  },
};

describe("DateTime Component", () => {
  it("should render the component", () => {
    const props = createTestProps(presetProps);
    const { container } = render(DateTime, { props });

    expect(container).toBeTruthy();
  });

  it("should render initial_date input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(DateTime, { props });

    const input = container.querySelector('input[name="initial_date"]');
    expect(input).toBeInTheDocument();
    expect(input).toHaveAttribute("type", "text");
  });

  it("should render initial_time input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(DateTime, { props });

    const input = container.querySelector('input[name="initial_time"]');
    expect(input).toBeInTheDocument();
    expect(input).toHaveAttribute("type", "text");
  });

  it("should have date field class on date input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(DateTime, { props });

    const input = container.querySelector('input[name="initial_date"]');
    expect(input).toHaveClass("date-field");
  });

  it("should have time field class on time input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(DateTime, { props });

    const input = container.querySelector('input[name="initial_time"]');
    expect(input).toHaveClass("time-field");
  });

  it("should have correct placeholders", () => {
    const props = createTestProps(presetProps);
    const { container } = render(DateTime, { props });

    const dateInput = container.querySelector('input[name="initial_date"]');
    const timeInput = container.querySelector('input[name="initial_time"]');

    expect(dateInput).toHaveAttribute("placeholder", "YYYY-MM-DD");
    expect(timeInput).toHaveAttribute("placeholder", "HH:mm:ss");
  });

  it("should display existing values", () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        initial_date: "2024-01-15",
        initial_time: "14:30:00",
      },
    });

    const { container } = render(DateTime, { props });

    const dateInput = container.querySelector(
      'input[name="initial_date"]',
    ) as HTMLInputElement;
    const timeInput = container.querySelector(
      'input[name="initial_time"]',
    ) as HTMLInputElement;

    expect(dateInput.value).toBe("2024-01-15");
    expect(timeInput.value).toBe("14:30:00");
  });

  it("should set default values when undefined", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {},
    });

    const { container } = render(DateTime, { props });
    await tick();

    const dateInput = container.querySelector(
      'input[name="initial_date"]',
    ) as HTMLInputElement;
    const timeInput = container.querySelector(
      'input[name="initial_time"]',
    ) as HTMLInputElement;

    expect(dateInput.value).toBe("");
    expect(timeInput.value).toBe("");
  });

  it("should render labels for both date and time", () => {
    const props = createTestProps(presetProps);
    const { container } = render(DateTime, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(labelTexts).toContain("Initial Value (Date)");
    expect(labelTexts).toContain("Initial Value (Time)");
  });
});
