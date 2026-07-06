import { render } from "@testing-library/svelte";
import { userEvent } from "@testing-library/user-event";
import { describe, it, expect } from "vitest";
import { tick } from "svelte";
import Categories from "./Categories.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "categories",
  typeLabel: "Categories",
  options: {
    multiple: false,
    can_add: false,
    min: "",
    max: "",
    category_set: "1",
  },
  optionsHtmlParams: {
    categories: {
      category_sets: [
        { id: "1", name: "Default Categories" },
        { id: "2", name: "Product Categories" },
      ],
    },
  },
};

describe("Categories Component", () => {
  it("should render the component", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Categories, { props });

    expect(container).toBeTruthy();
  });

  it("should render multiple checkbox", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Categories, { props });

    const checkbox = container.querySelector('input[name="multiple"]');
    expect(checkbox).toBeInTheDocument();
    expect(checkbox).toHaveAttribute("type", "checkbox");
  });

  it("should render can_add checkbox", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Categories, { props });

    const checkbox = container.querySelector('input[name="can_add"]');
    expect(checkbox).toBeInTheDocument();
    expect(checkbox).toHaveAttribute("type", "checkbox");
  });

  it("should render min and max inputs", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Categories, { props });

    const minInput = container.querySelector('input[name="min"]');
    const maxInput = container.querySelector('input[name="max"]');

    expect(minInput).toBeInTheDocument();
    expect(maxInput).toBeInTheDocument();
  });

  it("should render category_set select with category sets", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Categories, { props });

    const select = container.querySelector('select[name="category_set"]');
    expect(select).toBeInTheDocument();

    const options = container.querySelectorAll(
      'select[name="category_set"] option',
    );
    expect(options).toHaveLength(2);
    expect(options[0]).toHaveTextContent("Default Categories");
    expect(options[1]).toHaveTextContent("Product Categories");
  });

  it("should show warning when no category sets available", () => {
    const props = createTestProps({
      ...presetProps,
      optionsHtmlParams: {
        categories: {
          category_sets: [],
        },
      },
    });

    const { container } = render(Categories, { props });

    const warning = container.querySelector(".alert-warning");
    expect(warning).toBeInTheDocument();
    expect(warning).toHaveTextContent(
      "There is no category set that can be selected. Please create a category set if you use the Categories field type.",
    );

    const select = container.querySelector('select[name="category_set"]');
    expect(select).not.toBeInTheDocument();
  });

  it("should set default values when undefined", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {},
    });

    const { container } = render(Categories, { props });
    await tick();

    const minInput = container.querySelector(
      'input[name="min"]',
    ) as HTMLInputElement;
    const maxInput = container.querySelector(
      'input[name="max"]',
    ) as HTMLInputElement;

    expect(minInput.value).toBe("");
    expect(maxInput.value).toBe("");
  });

  it("should render labels for options", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Categories, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(
      labelTexts.some((text) => text?.includes("select multiple categories")),
    ).toBe(true);
    expect(
      labelTexts.some((text) => text?.includes("create new categories")),
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
        category_set: "1",
      },
    });
    const { container } = render(Categories, { props });

    const minField = container.querySelector("#categories-min-field");
    const maxField = container.querySelector("#categories-max-field");

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
