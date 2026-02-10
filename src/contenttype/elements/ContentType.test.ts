import { render } from "@testing-library/svelte";
import { userEvent } from "@testing-library/user-event";
import { describe, it, expect } from "vitest";
import { tick } from "svelte";
import ContentType from "./ContentType.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "content-type",
  typeLabel: "Content Type",
  options: {
    multiple: false,
    can_add: false,
    min: "",
    max: "",
    source: "1",
  },
  optionsHtmlParams: {
    content_type: {
      content_types: [
        { id: "1", name: "Blog Post" },
        { id: "2", name: "News Article" },
      ],
    },
  },
};

describe("ContentType Component", () => {
  it("should render the component", () => {
    const props = createTestProps(presetProps);
    const { container } = render(ContentType, { props });

    expect(container).toBeTruthy();
  });

  it("should render multiple checkbox", () => {
    const props = createTestProps(presetProps);
    const { container } = render(ContentType, { props });

    const checkbox = container.querySelector('input[name="multiple"]');
    expect(checkbox).toBeInTheDocument();
    expect(checkbox).toHaveAttribute("type", "checkbox");
  });

  it("should render min and max inputs", () => {
    const props = createTestProps(presetProps);
    const { container } = render(ContentType, { props });

    const minInput = container.querySelector('input[name="min"]');
    const maxInput = container.querySelector('input[name="max"]');

    expect(minInput).toBeInTheDocument();
    expect(maxInput).toBeInTheDocument();
  });

  it("should render source select with content types", () => {
    const props = createTestProps(presetProps);
    const { container } = render(ContentType, { props });

    const select = container.querySelector('select[name="source"]');
    expect(select).toBeInTheDocument();

    const options = container.querySelectorAll('select[name="source"] option');
    expect(options).toHaveLength(2);
    expect(options[0]).toHaveTextContent("Blog Post");
    expect(options[1]).toHaveTextContent("News Article");
  });

  it("should show warning when no content types available", () => {
    const props = createTestProps({
      ...presetProps,
      optionsHtmlParams: {
        content_type: {
          content_types: [],
        },
      },
    });

    const { container } = render(ContentType, { props });

    const warning = container.querySelector(".alert-warning");
    expect(warning).toBeInTheDocument();
    expect(warning).toHaveTextContent(
      "There is no content type that can be selected. Please create a content type if you use the Content Type field type.",
    );

    const select = container.querySelector('select[name="source"]');
    expect(select).not.toBeInTheDocument();
  });

  it("should set default values when undefined", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {},
    });

    const { container } = render(ContentType, { props });
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
    const { container } = render(ContentType, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(
      labelTexts.some((text) => text?.includes("select multiple values")),
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
        source: "1",
      },
    });
    const { container } = render(ContentType, { props });

    const minField = container.querySelector("#content_type-min-field");
    const maxField = container.querySelector("#content_type-max-field");

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
