import { render } from "@testing-library/svelte";
import { userEvent } from "@testing-library/user-event";
import { describe, it, expect } from "vitest";
import { tick } from "svelte";
import Tags from "./Tags.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "tags",
  typeLabel: "Tags",
  options: {
    multiple: false,
    can_add: false,
    min: "",
    max: "",
    initial_value: "",
  },
};

describe("Tags Component", () => {
  it("should render the component", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Tags, { props });

    expect(container).toBeTruthy();
  });

  it("should render multiple checkbox", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Tags, { props });

    const checkbox = container.querySelector('input[name="multiple"]');
    expect(checkbox).toBeInTheDocument();
    expect(checkbox).toHaveAttribute("type", "checkbox");
  });

  it("should render can_add checkbox", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Tags, { props });

    const checkbox = container.querySelector('input[name="can_add"]');
    expect(checkbox).toBeInTheDocument();
    expect(checkbox).toHaveAttribute("type", "checkbox");
  });

  it("should render min and max inputs", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Tags, { props });

    const minInput = container.querySelector('input[name="min"]');
    const maxInput = container.querySelector('input[name="max"]');

    expect(minInput).toBeInTheDocument();
    expect(maxInput).toBeInTheDocument();
  });

  it("should render initial_value input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Tags, { props });

    const input = container.querySelector('input[name="initial_value"]');
    expect(input).toBeInTheDocument();
    expect(input).toHaveAttribute("type", "text");
  });

  it("should display existing values", () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        multiple: true,
        can_add: true,
        min: "1",
        max: "10",
        initial_value: "tag1, tag2",
      },
    });

    const { container } = render(Tags, { props });

    const initialValueInput = container.querySelector(
      'input[name="initial_value"]',
    ) as HTMLInputElement;
    expect(initialValueInput.value).toBe("tag1, tag2");
  });

  it("should set default values when undefined", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {},
    });

    const { container } = render(Tags, { props });
    await tick();

    const minInput = container.querySelector(
      'input[name="min"]',
    ) as HTMLInputElement;
    const maxInput = container.querySelector(
      'input[name="max"]',
    ) as HTMLInputElement;
    const initialValueInput = container.querySelector(
      'input[name="initial_value"]',
    ) as HTMLInputElement;

    expect(minInput.value).toBe("");
    expect(maxInput.value).toBe("");
    expect(initialValueInput.value).toBe("");
  });

  it("should render labels for options", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Tags, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(
      labelTexts.some((text) =>
        text?.includes("Allow users to input multiple"),
      ),
    ).toBe(true);
    expect(
      labelTexts.some((text) =>
        text?.includes("Allow users to create new tags"),
      ),
    ).toBe(true);
  });

  it("should show min/max fields when multiple checkbox is checked", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        multiple: false,
        can_add: false,
        min: "",
        max: "",
        initial_value: "",
      },
    });
    const { container } = render(Tags, { props });

    const minField = container.querySelector("#tags-min-field");
    const maxField = container.querySelector("#tags-max-field");

    expect(minField).toHaveAttribute("hidden");
    expect(maxField).toHaveAttribute("hidden");

    const checkbox = container.querySelector(
      'input[name="multiple"]',
    ) as HTMLInputElement;
    const user = userEvent.setup();
    await user.click(checkbox);
    await tick();

    expect(minField).not.toHaveAttribute("hidden");
    expect(maxField).not.toHaveAttribute("hidden");
  });
});
