import { render } from "@testing-library/svelte";
import { describe, it, expect, vi, afterEach } from "vitest";
import Custom from "./Custom.svelte";
import { createFieldsStore } from "../../tests/helpers/createTestProps.svelte";

vi.mock("../ContentFieldTypes", () => ({
  default: {
    getCustomType: vi.fn().mockReturnValue(null),
  },
}));

describe("Custom Component", () => {
  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("should render the component", () => {
    const fieldsStore = createFieldsStore({
      fields: [
        {
          id: "test-field-1",
          type: "custom-type",
          label: "Test Field",
          options: {},
        },
      ],
    });

    const { container } = render(Custom, {
      props: {
        config: {},
        fieldIndex: 0,
        fieldsStore: fieldsStore,
        gather: null,
        optionsHtmlParams: {},
      },
    });

    expect(container).toBeTruthy();
  });

  it("should render custom content field block div", () => {
    const fieldsStore = createFieldsStore({
      fields: [
        {
          id: "test-field-1",
          type: "custom-type",
          label: "Test Field",
          options: {},
        },
      ],
    });

    const { container } = render(Custom, {
      props: {
        config: {},
        fieldIndex: 0,
        fieldsStore: fieldsStore,
        gather: null,
        optionsHtmlParams: {},
      },
    });

    const block = container.querySelector(".mt-custom-contentfield");
    expect(block).toBeInTheDocument();
  });

  it("should have correct id on custom content field block", () => {
    const fieldsStore = createFieldsStore({
      fields: [
        {
          id: "test-field-1",
          type: "custom-type",
          label: "Test Field",
          options: {},
        },
      ],
    });

    const { container } = render(Custom, {
      props: {
        config: {},
        fieldIndex: 0,
        fieldsStore: fieldsStore,
        gather: null,
        optionsHtmlParams: {},
      },
    });

    const block = container.querySelector(
      "#custom-content-field-block-test-field-1",
    );
    expect(block).toBeInTheDocument();
  });
});
