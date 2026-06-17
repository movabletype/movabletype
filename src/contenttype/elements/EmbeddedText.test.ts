import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import { tick } from "svelte";
import EmbeddedText from "./EmbeddedText.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "embedded-text",
  typeLabel: "Embedded Text",
  options: {
    initial_value: "",
  },
};

describe("EmbeddedText Component", () => {
  it("should render the component", () => {
    const props = createTestProps(presetProps);
    const { container } = render(EmbeddedText, { props });

    expect(container).toBeTruthy();
  });

  it("should render initial_value textarea", () => {
    const props = createTestProps(presetProps);
    const { container } = render(EmbeddedText, { props });

    const textarea = container.querySelector('textarea[name="initial_value"]');
    expect(textarea).toBeInTheDocument();
  });

  it("should display existing initial_value", () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        initial_value: "<p>Hello World</p>",
      },
    });

    const { container } = render(EmbeddedText, { props });

    const textarea = container.querySelector(
      'textarea[name="initial_value"]',
    ) as HTMLTextAreaElement;
    expect(textarea.value).toBe("<p>Hello World</p>");
  });

  it("should set default initial_value when undefined", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {},
    });

    const { container } = render(EmbeddedText, { props });
    await tick();

    const textarea = container.querySelector(
      'textarea[name="initial_value"]',
    ) as HTMLTextAreaElement;
    expect(textarea.value).toBe("");
  });

  it("should render Initial Value label", () => {
    const props = createTestProps(presetProps);
    const { container } = render(EmbeddedText, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(labelTexts).toContain("Initial Value");
  });
});
