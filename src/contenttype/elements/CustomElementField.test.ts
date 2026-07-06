import { render } from "@testing-library/svelte";
import {
  describe,
  it,
  expect,
  vi,
  beforeAll,
  beforeEach,
  afterEach,
} from "vitest";
import CustomElementField from "./CustomElementField.svelte";
import { createFieldsStore } from "../../tests/helpers/createTestProps.svelte";

class TestCustomElement extends HTMLElement {
  options: Record<string, unknown> = {};

  constructor() {
    super();
  }

  connectedCallback(): void {
    const dataOptions = this.getAttribute("data-options");
    if (dataOptions) {
      this.options = JSON.parse(dataOptions);
    }
  }
}

describe("CustomElementField Component", () => {
  beforeAll(() => {
    if (!customElements.get("test-custom-element")) {
      customElements.define("test-custom-element", TestCustomElement);
    }
  });

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
    const fieldsStore = createFieldsStore({
      fields: [
        {
          id: "test-field-1",
          type: "custom-element",
          label: "Test Field",
          options: {
            description: "Test description",
            required: false,
            display: "default",
          },
        },
      ],
    });

    const { container } = render(CustomElementField, {
      props: {
        fieldIndex: 0,
        fieldsStore: fieldsStore,
        type: "custom-element",
        customElement: "test-custom-element",
      },
    });

    expect(container).toBeTruthy();
  });

  it("should render ContentFieldOptionGroup common fields", () => {
    const fieldsStore = createFieldsStore({
      fields: [
        {
          id: "test-field-1",
          type: "custom-element",
          label: "Test Field",
          options: {
            description: "Test description",
            required: false,
            display: "default",
          },
        },
      ],
    });

    const { container } = render(CustomElementField, {
      props: {
        fieldIndex: 0,
        fieldsStore: fieldsStore,
        type: "custom-element",
        customElement: "test-custom-element",
      },
    });

    const labelInput = container.querySelector('input[name="label"]');
    expect(labelInput).toBeInTheDocument();

    const descInput = container.querySelector('input[name="description"]');
    expect(descInput).toBeInTheDocument();

    const requiredCheckbox = container.querySelector('input[name="required"]');
    expect(requiredCheckbox).toBeInTheDocument();

    const displaySelect = container.querySelector('select[name="display"]');
    expect(displaySelect).toBeInTheDocument();
  });

  it("should render custom element with data-options attribute", () => {
    const fieldsStore = createFieldsStore({
      fields: [
        {
          id: "test-field-1",
          type: "custom-element",
          label: "Test Field",
          options: {
            description: "Test description",
            required: false,
            display: "default",
          },
        },
      ],
    });

    const { container } = render(CustomElementField, {
      props: {
        fieldIndex: 0,
        fieldsStore: fieldsStore,
        type: "custom-element",
        customElement: "test-custom-element",
      },
    });

    const customElement = container.querySelector("[data-options]");
    expect(customElement).toBeInTheDocument();

    const dataOptions = customElement?.getAttribute("data-options");
    expect(dataOptions).toBeTruthy();

    const parsedOptions = JSON.parse(dataOptions!);
    expect(parsedOptions).toHaveProperty("description", "Test description");
    expect(parsedOptions).toHaveProperty("display", "default");
  });

  it("should render close button", () => {
    const fieldsStore = createFieldsStore({
      fields: [
        {
          id: "test-field-1",
          type: "custom-element",
          label: "Test Field",
          options: {
            description: "Test description",
            required: false,
            display: "default",
          },
        },
      ],
    });

    const { container } = render(CustomElementField, {
      props: {
        fieldIndex: 0,
        fieldsStore: fieldsStore,
        type: "custom-element",
        customElement: "test-custom-element",
      },
    });

    const closeButton = container.querySelector("button.btn-default");
    expect(closeButton).toBeInTheDocument();
    expect(closeButton).toHaveTextContent("Close");
  });

  it("should render hidden id input", () => {
    const fieldsStore = createFieldsStore({
      fields: [
        {
          id: "test-field-1",
          type: "custom-element",
          label: "Test Field",
          options: {
            description: "Test description",
            required: false,
            display: "default",
          },
        },
      ],
    });

    const { container } = render(CustomElementField, {
      props: {
        fieldIndex: 0,
        fieldsStore: fieldsStore,
        type: "custom-element",
        customElement: "test-custom-element",
      },
    });

    const idInput = container.querySelector('input[name="id"]');
    expect(idInput).toBeInTheDocument();
    expect(idInput).toHaveAttribute("type", "hidden");
  });

  it("should pass plugin options through data-options on initial render", () => {
    const fieldsStore = createFieldsStore({
      fields: [
        {
          id: "test-field-1",
          type: "custom-element",
          label: "Test Field",
          options: {
            description: "Test description",
            required: false,
            display: "default",
            min_length: "1",
            max_length: "50",
            initial_value: "test@example.com",
          },
        },
      ],
    });

    const { container } = render(CustomElementField, {
      props: {
        fieldIndex: 0,
        fieldsStore: fieldsStore,
        type: "custom-element",
        customElement: "test-custom-element",
      },
    });

    const customElement = container.querySelector("[data-options]");
    const dataOptions = customElement?.getAttribute("data-options");
    const parsedOptions = JSON.parse(dataOptions!);

    expect(parsedOptions).toHaveProperty("min_length", "1");
    expect(parsedOptions).toHaveProperty("max_length", "50");
    expect(parsedOptions).toHaveProperty("initial_value", "test@example.com");
  });

  it("should render display options select with all options", () => {
    const fieldsStore = createFieldsStore({
      fields: [
        {
          id: "test-field-1",
          type: "custom-element",
          label: "Test Field",
          options: {
            description: "Test description",
            required: false,
            display: "default",
          },
        },
      ],
    });

    const { container } = render(CustomElementField, {
      props: {
        fieldIndex: 0,
        fieldsStore: fieldsStore,
        type: "custom-element",
        customElement: "test-custom-element",
      },
    });

    const options = container.querySelectorAll('select[name="display"] option');
    expect(options).toHaveLength(4);
    expect(options[0]).toHaveValue("force");
    expect(options[1]).toHaveValue("default");
    expect(options[2]).toHaveValue("optional");
    expect(options[3]).toHaveValue("none");
  });
});
