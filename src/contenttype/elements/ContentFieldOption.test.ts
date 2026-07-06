import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import ContentFieldOption from "./ContentFieldOption.svelte";

describe("ContentFieldOption Component", () => {
  it("should render the component with required props", () => {
    const { container } = render(ContentFieldOption, {
      props: {
        id: "test-field",
      },
    });

    expect(container).toBeTruthy();
    const formGroup = container.querySelector(".form-group");
    expect(formGroup).toBeInTheDocument();
    expect(formGroup).toHaveAttribute("id", "test-field-field");
  });

  it("should render label when provided", () => {
    const { container } = render(ContentFieldOption, {
      props: {
        id: "test-field",
        label: "Test Label",
        showLabel: 1,
      },
    });

    const label = container.querySelector("label");
    expect(label).toBeInTheDocument();
    expect(label).toHaveTextContent("Test Label");
    expect(label).toHaveAttribute("for", "test-field");
  });

  it("should not render label when showLabel is 0", () => {
    const { container } = render(ContentFieldOption, {
      props: {
        id: "test-field",
        label: "Test Label",
        showLabel: 0,
      },
    });

    const label = container.querySelector("label");
    expect(label).not.toBeInTheDocument();
  });

  it("should render required badge when required is 1", () => {
    const { container } = render(ContentFieldOption, {
      props: {
        id: "test-field",
        label: "Test Label",
        required: 1,
      },
    });

    const badge = container.querySelector(".badge-danger");
    expect(badge).toBeInTheDocument();
    expect(badge).toHaveTextContent("Required");
  });

  it("should not render required badge when required is 0", () => {
    const { container } = render(ContentFieldOption, {
      props: {
        id: "test-field",
        label: "Test Label",
        required: 0,
      },
    });

    const badge = container.querySelector(".badge-danger");
    expect(badge).not.toBeInTheDocument();
  });

  it("should add required class to form-group when required", () => {
    const { container } = render(ContentFieldOption, {
      props: {
        id: "test-field",
        required: 1,
      },
    });

    const formGroup = container.querySelector(".form-group");
    expect(formGroup).toHaveClass("required");
  });

  it("should render hint when provided and showHint is 1", () => {
    const { container } = render(ContentFieldOption, {
      props: {
        id: "test-field",
        hint: "This is a hint",
        showHint: 1,
      },
    });

    const hint = container.querySelector(".form-text");
    expect(hint).toBeInTheDocument();
    expect(hint).toHaveTextContent("This is a hint");
    expect(hint).toHaveAttribute("id", "test-field-field-help");
  });

  it("should not render hint when showHint is 0", () => {
    const { container } = render(ContentFieldOption, {
      props: {
        id: "test-field",
        hint: "This is a hint",
        showHint: 0,
      },
    });

    const hint = container.querySelector(".form-text");
    expect(hint).not.toBeInTheDocument();
  });

  it("should hide element when attrShow is false", async () => {
    const { container } = render(ContentFieldOption, {
      props: {
        id: "test-field",
        attrShow: false,
      },
    });

    const formGroup = container.querySelector(".form-group");
    expect(formGroup).toHaveAttribute("hidden", "");
    expect(formGroup).toHaveStyle("display: none");
  });

  it("should show element when attrShow is true", async () => {
    const { container } = render(ContentFieldOption, {
      props: {
        id: "test-field",
        attrShow: true,
      },
    });

    const formGroup = container.querySelector(".form-group");
    expect(formGroup).not.toHaveAttribute("hidden");
  });

  it("should set attr attribute when provided", () => {
    const { container } = render(ContentFieldOption, {
      props: {
        id: "test-field",
        attr: "custom-attr",
      },
    });

    const formGroup = container.querySelector(".form-group");
    expect(formGroup).toHaveAttribute("attr", "custom-attr");
  });
});
