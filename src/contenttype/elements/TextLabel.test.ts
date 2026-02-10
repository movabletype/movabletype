import { render } from "@testing-library/svelte";
import { describe, it, expect, vi } from "vitest";
import { tick } from "svelte";
import TextLabel from "./TextLabel.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "text-label",
  typeLabel: "Text Label",
  options: {
    text: "",
  },
};

describe("TextLabel Component", () => {
  beforeEach(() => {
    vi.spyOn(document, "getElementById").mockImplementation(() => {
      const mockElement = document.createElement("div");
      return mockElement;
    });
  });

  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("should render the component", () => {
    const props = createTestProps(presetProps);
    const { container } = render(TextLabel, { props });

    expect(container).toBeTruthy();
  });

  it("should render text textarea", () => {
    const props = createTestProps(presetProps);
    const { container } = render(TextLabel, { props });

    const textarea = container.querySelector('textarea[name="text"]');
    expect(textarea).toBeInTheDocument();
  });

  it("should display existing text value", () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        text: "This is a label text",
      },
    });

    const { container } = render(TextLabel, { props });

    const textarea = container.querySelector(
      'textarea[name="text"]',
    ) as HTMLTextAreaElement;
    expect(textarea.value).toBe("This is a label text");
  });

  it("should set default text value when undefined", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {},
    });

    const { container } = render(TextLabel, { props });
    await tick();

    const textarea = container.querySelector(
      'textarea[name="text"]',
    ) as HTMLTextAreaElement;
    expect(textarea.value).toBe("");
  });

  it("should render __TEXT_LABEL_TEXT label", () => {
    const props = createTestProps(presetProps);
    const { container } = render(TextLabel, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(labelTexts).toContain("__TEXT_LABEL_TEXT");
  });

  it("should render hint text", () => {
    const props = createTestProps(presetProps);
    const { container } = render(TextLabel, { props });

    const hint = container.querySelector(".form-text");
    expect(hint).toBeInTheDocument();
  });
});
