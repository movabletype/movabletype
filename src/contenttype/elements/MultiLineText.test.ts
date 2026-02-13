import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import { tick } from "svelte";
import MultiLineText from "./MultiLineText.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "multi-line-text",
  typeLabel: "Multi Line Text",
  options: {
    initial_value: "",
    input_format: "richtext",
    full_rich_text: 1,
  },
  optionsHtmlParams: {
    multi_line_text: {
      text_filters: [
        { filter_key: "richtext", filter_label: "Rich Text" },
        { filter_key: "markdown", filter_label: "Markdown" },
        { filter_key: "none", filter_label: "None" },
      ],
    },
  },
};

describe("MultiLineText Component", () => {
  it("should render the component", () => {
    const props = createTestProps(presetProps);
    const { container } = render(MultiLineText, { props });

    expect(container).toBeTruthy();
  });

  it("should render initial_value textarea", () => {
    const props = createTestProps(presetProps);
    const { container } = render(MultiLineText, { props });

    const textarea = container.querySelector('textarea[name="initial_value"]');
    expect(textarea).toBeInTheDocument();
  });

  it("should render input_format select", () => {
    const props = createTestProps(presetProps);
    const { container } = render(MultiLineText, { props });

    const select = container.querySelector('select[name="input_format"]');
    expect(select).toBeInTheDocument();
  });

  it("should render text filter options", () => {
    const props = createTestProps(presetProps);
    const { container } = render(MultiLineText, { props });

    const options = container.querySelectorAll(
      'select[name="input_format"] option',
    );
    expect(options).toHaveLength(3);
    expect(options[0]).toHaveTextContent("Rich Text");
    expect(options[1]).toHaveTextContent("Markdown");
    expect(options[2]).toHaveTextContent("None");
  });

  it("should render full_rich_text checkbox", () => {
    const props = createTestProps(presetProps);
    const { container } = render(MultiLineText, { props });

    const checkbox = container.querySelector('input[name="full_rich_text"]');
    expect(checkbox).toBeInTheDocument();
    expect(checkbox).toHaveAttribute("type", "checkbox");
  });

  it("should display existing initial_value", () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        ...presetProps.options,
        initial_value: "Hello World",
      },
    });

    const { container } = render(MultiLineText, { props });

    const textarea = container.querySelector(
      'textarea[name="initial_value"]',
    ) as HTMLTextAreaElement;
    expect(textarea.value).toBe("Hello World");
  });

  it("should set default initial_value when undefined", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {},
    });

    const { container } = render(MultiLineText, { props });
    await tick();

    const textarea = container.querySelector(
      'textarea[name="initial_value"]',
    ) as HTMLTextAreaElement;
    expect(textarea.value).toBe("");
  });

  it("should render labels for each option", () => {
    const props = createTestProps(presetProps);
    const { container } = render(MultiLineText, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(labelTexts).toContain("Initial Value");
    expect(labelTexts).toContain("Input format");
  });
});
