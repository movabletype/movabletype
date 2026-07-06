import { render } from "@testing-library/svelte";
import { describe, it, expect, vi, afterEach } from "vitest";
import { tick } from "svelte";
import Custom from "./Custom.svelte";
import ContentFieldTypes from "../ContentFieldTypes.svelte";
import { createFieldsStore } from "../../tests/helpers/createTestProps.svelte";

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

  it("should mount custom field when type is registered after render", async () => {
    const fieldsStore = createFieldsStore({
      fields: [
        {
          id: "test-field-1",
          type: "late-register-type",
          label: "Test Field",
          options: {},
        },
      ],
    });

    const mountFn = vi.fn(() => ({
      component: {},
      destroy: vi.fn(),
      gather: () => ({}),
    }));

    render(Custom, {
      props: {
        config: {},
        fieldIndex: 0,
        fieldsStore: fieldsStore,
        gather: null,
        optionsHtmlParams: {},
      },
    });

    expect(mountFn).not.toHaveBeenCalled();

    ContentFieldTypes.registerCustomType("late-register-type", mountFn);
    await tick();

    expect(mountFn).toHaveBeenCalledTimes(1);
  });
});
