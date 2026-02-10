import { render } from "@testing-library/svelte";
import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { tick } from "svelte";
import ContentFieldOptionGroup from "./ContentFieldOptionGroup.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "test-type",
  typeLabel: "Test Type",
  options: {
    description: "Test description",
    required: false,
    display: "default",
  },
};

describe("ContentFieldOptionGroup Component", () => {
  beforeEach(() => {
    vi.spyOn(document, "querySelector").mockImplementation((selector) => {
      if (selector.startsWith("#field-options-")) {
        const mockElement = document.createElement("div");
        mockElement.querySelectorAll = vi.fn().mockReturnValue([]);
        return mockElement;
      }
      return null;
    });

    vi.spyOn(document, "getElementsByClassName").mockReturnValue(
      [] as unknown as HTMLCollectionOf<Element>,
    );
  });

  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("should render the component", () => {
    const props = createTestProps(presetProps);
    const { container } = render(ContentFieldOptionGroup, { props });

    expect(container).toBeTruthy();
  });

  it("should render hidden id input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(ContentFieldOptionGroup, { props });

    const idInput = container.querySelector('input[name="id"]');
    expect(idInput).toBeInTheDocument();
    expect(idInput).toHaveAttribute("type", "hidden");
  });

  it("should render label input with required attribute", () => {
    const props = createTestProps(presetProps);
    const { container } = render(ContentFieldOptionGroup, { props });

    const labelInput = container.querySelector('input[name="label"]');
    expect(labelInput).toBeInTheDocument();
    expect(labelInput).toHaveAttribute("type", "text");
    expect(labelInput).toHaveAttribute("required");
  });

  it("should render description input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(ContentFieldOptionGroup, { props });

    const descInput = container.querySelector('input[name="description"]');
    expect(descInput).toBeInTheDocument();
    expect(descInput).toHaveAttribute("type", "text");
  });

  it("should render required checkbox", () => {
    const props = createTestProps(presetProps);
    const { container } = render(ContentFieldOptionGroup, { props });

    const checkbox = container.querySelector('input[name="required"]');
    expect(checkbox).toBeInTheDocument();
    expect(checkbox).toHaveAttribute("type", "checkbox");
  });

  it("should render display select with options", () => {
    const props = createTestProps(presetProps);
    const { container } = render(ContentFieldOptionGroup, { props });

    const select = container.querySelector('select[name="display"]');
    expect(select).toBeInTheDocument();

    const options = container.querySelectorAll('select[name="display"] option');
    expect(options).toHaveLength(4);
    expect(options[0]).toHaveValue("force");
    expect(options[1]).toHaveValue("default");
    expect(options[2]).toHaveValue("optional");
    expect(options[3]).toHaveValue("none");
  });

  it("should render Close button", () => {
    const props = createTestProps(presetProps);
    const { container } = render(ContentFieldOptionGroup, { props });

    const button = container.querySelector("button.btn-default");
    expect(button).toBeInTheDocument();
    expect(button).toHaveTextContent("Close");
  });

  it("should set display value when options is empty", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {},
    });

    render(ContentFieldOptionGroup, { props });
    await tick();

    expect(props.options.display).toBeTruthy();
  });

  it("should use id:field.id format for new fields", () => {
    const props = createTestProps({
      ...presetProps,
      field: {
        isNew: true,
      },
    });
    const { container } = render(ContentFieldOptionGroup, { props });

    const idInput = container.querySelector(
      'input[name="id"]',
    ) as HTMLInputElement;
    expect(idInput.value).toMatch(/^id:/);
  });

  it("should render label for Label field", () => {
    const props = createTestProps(presetProps);
    const { container } = render(ContentFieldOptionGroup, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(labelTexts.some((text) => text?.includes("Label"))).toBe(true);
  });

  it("should render label for Description field", () => {
    const props = createTestProps(presetProps);
    const { container } = render(ContentFieldOptionGroup, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(labelTexts.some((text) => text?.includes("Description"))).toBe(true);
  });

  it("should render label for Display Options field", () => {
    const props = createTestProps(presetProps);
    const { container } = render(ContentFieldOptionGroup, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(labelTexts.some((text) => text?.includes("Display Options"))).toBe(
      true,
    );
  });

  it("should have hint for Description field", () => {
    const props = createTestProps(presetProps);
    const { container } = render(ContentFieldOptionGroup, { props });

    const hints = container.querySelectorAll(".form-text");
    expect(hints.length).toBeGreaterThan(0);
  });
});
