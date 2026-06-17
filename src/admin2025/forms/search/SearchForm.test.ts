import { render, fireEvent } from "@testing-library/svelte";
import { describe, it, expect, beforeEach, afterEach, vi } from "vitest";
import { tick } from "svelte";
import SearchForm from "./SearchForm.svelte";
import {
  createSearchFormProps,
  createMockContentType,
  createMockSearchTabs,
} from "../../../tests/helpers/createAdmin2025TestProps.svelte";

describe("SearchForm Component", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  afterEach(() => {
    document.body.innerHTML = "";
  });

  describe("Initial Rendering", () => {
    it("should render the component", async () => {
      const props = createSearchFormProps();
      const { container } = render(SearchForm, { props });
      await tick();
      expect(container).toBeTruthy();
      expect(container.querySelector(".mt-search-form")).toBeInTheDocument();
    });

    it("should render search type radio buttons", async () => {
      const props = createSearchFormProps();
      const { container } = render(SearchForm, { props });
      await tick();

      const radios = container.querySelectorAll('input[type="radio"]');
      expect(radios.length).toBe(props.searchTabs.length);
    });

    it("should render content type dropdown", async () => {
      const props = createSearchFormProps();
      const { container } = render(SearchForm, { props });
      await tick();

      const select = container.querySelector("select");
      expect(select).toBeInTheDocument();
    });

    it("should render search text input", async () => {
      const props = createSearchFormProps();
      const { container } = render(SearchForm, { props });
      await tick();

      const input = container.querySelector('input[type="text"]');
      expect(input).toBeInTheDocument();
    });

    it("should render submit button", async () => {
      const props = createSearchFormProps();
      const { container } = render(SearchForm, { props });
      await tick();

      const button = container.querySelector("button.btn-primary");
      expect(button).toBeInTheDocument();
    });

    it("should focus search text input on mount", async () => {
      const props = createSearchFormProps();
      const { container } = render(SearchForm, { props });
      await tick();
      await tick();

      const input = container.querySelector('input[type="text"]');
      expect(document.activeElement).toBe(input);
    });
  });

  describe("Search Type Selection", () => {
    it("should render all search tabs as radio buttons", async () => {
      const searchTabs = createMockSearchTabs();
      const props = createSearchFormProps({ searchTabs });
      const { container } = render(SearchForm, { props });
      await tick();

      const radios = container.querySelectorAll('input[type="radio"]');
      expect(radios.length).toBe(searchTabs.length);

      searchTabs.forEach((tab, index) => {
        expect(radios[index]).toHaveAttribute("value", tab.key);
      });
    });

    it("should check the correct radio button for objectType", async () => {
      const props = createSearchFormProps({ objectType: "page" });
      const { container } = render(SearchForm, { props });
      await tick();

      const pageRadio = container.querySelector(
        'input[type="radio"][value="page"]',
      ) as HTMLInputElement;
      expect(pageRadio.checked).toBe(true);
    });

    it("should update objectType when radio button selected", async () => {
      const props = createSearchFormProps({ objectType: "entry" });
      const { container } = render(SearchForm, { props });
      await tick();

      const pageRadio = container.querySelector(
        'input[type="radio"][value="page"]',
      ) as HTMLInputElement;
      await fireEvent.click(pageRadio);
      await tick();

      expect(pageRadio.checked).toBe(true);
    });
  });

  describe("Content Type Dropdown", () => {
    it("should display loading message while isLoading", async () => {
      const props = createSearchFormProps({ isLoading: true });
      const { container } = render(SearchForm, { props });
      await tick();

      expect(container.textContent).toContain("Loading...");
    });

    it("should disable dropdown when objectType is not content_data", async () => {
      const contentTypes = [createMockContentType()];
      const props = createSearchFormProps({
        contentTypes,
        objectType: "entry",
      });
      const { container } = render(SearchForm, { props });
      await tick();

      const select = container.querySelector("select") as HTMLSelectElement;
      expect(select.disabled).toBe(true);
    });

    it("should enable dropdown when objectType is content_data", async () => {
      const contentTypes = [createMockContentType()];
      const props = createSearchFormProps({
        contentTypes,
        objectType: "content_data",
      });
      const { container } = render(SearchForm, { props });
      await tick();

      const select = container.querySelector("select") as HTMLSelectElement;
      expect(select.disabled).toBe(false);
    });

    it("should display No Content Type message when empty", async () => {
      const props = createSearchFormProps({
        contentTypes: [],
        objectType: "content_data",
      });
      const { container } = render(SearchForm, { props });
      await tick();

      const select = container.querySelector("select") as HTMLSelectElement;
      expect(select.textContent).toContain("No Content Type could be found.");
      expect(select.disabled).toBe(true);
    });

    it("should display content type options", async () => {
      const contentTypes = [
        createMockContentType({ id: "1", name: "Type 1" }),
        createMockContentType({ id: "2", name: "Type 2" }),
      ];
      const props = createSearchFormProps({
        contentTypes,
        objectType: "content_data",
      });
      const { container } = render(SearchForm, { props });
      await tick();

      const options = container.querySelectorAll("select option");
      expect(options.length).toBe(2);
      expect(options[0].textContent).toBe("Type 1");
      expect(options[1].textContent).toBe("Type 2");
    });

    it("should set first content type as default selection", async () => {
      const contentTypes = [
        createMockContentType({ id: "1", name: "Type 1" }),
        createMockContentType({ id: "2", name: "Type 2" }),
      ];
      const props = createSearchFormProps({
        contentTypes,
        objectType: "content_data",
      });
      const { container } = render(SearchForm, { props });
      await tick();
      await tick();

      const select = container.querySelector("select") as HTMLSelectElement;
      expect(select.value).toBe("1");
    });
  });

  describe("Form Submission", () => {
    it("should call submit when submit button clicked", async () => {
      const props = createSearchFormProps();
      const { container } = render(SearchForm, { props });
      await tick();

      const submitSpy = vi.spyOn(HTMLFormElement.prototype, "submit");
      submitSpy.mockImplementation(() => {});

      const button = container.querySelector(
        "button.btn-primary",
      ) as HTMLButtonElement;
      await fireEvent.click(button);
      await tick();

      expect(submitSpy).toHaveBeenCalled();
      submitSpy.mockRestore();
    });

    it("should call submit when Enter key pressed", async () => {
      const props = createSearchFormProps();
      const { container } = render(SearchForm, { props });
      await tick();

      const submitSpy = vi.spyOn(HTMLFormElement.prototype, "submit");
      submitSpy.mockImplementation(() => {});

      const input = container.querySelector(
        'input[type="text"]',
      ) as HTMLInputElement;
      await fireEvent.keyDown(input, { key: "Enter", isComposing: false });
      await tick();

      expect(submitSpy).toHaveBeenCalled();
      submitSpy.mockRestore();
    });

    it("should not submit on Enter during IME composition", async () => {
      const props = createSearchFormProps();
      const { container } = render(SearchForm, { props });
      await tick();

      const submitSpy = vi.spyOn(HTMLFormElement.prototype, "submit");
      submitSpy.mockImplementation(() => {});

      const input = container.querySelector(
        'input[type="text"]',
      ) as HTMLInputElement;
      await fireEvent.keyDown(input, { key: "Enter", isComposing: true });
      await tick();

      expect(submitSpy).not.toHaveBeenCalled();
      submitSpy.mockRestore();
    });

    it("should create form with correct hidden inputs", async () => {
      const props = createSearchFormProps({
        blogId: "123",
        magicToken: "test-token",
        objectType: "entry",
      });
      const { container } = render(SearchForm, { props });
      await tick();

      const submitSpy = vi.spyOn(HTMLFormElement.prototype, "submit");
      submitSpy.mockImplementation(() => {});

      const button = container.querySelector(
        "button.btn-primary",
      ) as HTMLButtonElement;
      await fireEvent.click(button);
      await tick();

      const form = document.body.querySelector("form");
      expect(form).toBeInTheDocument();
      expect(form?.method.toUpperCase()).toBe("POST");
      expect(form?.action).toContain("/cgi-bin/mt.cgi");

      const modeInput = form?.querySelector(
        'input[name="__mode"]',
      ) as HTMLInputElement;
      expect(modeInput?.value).toBe("search_replace");

      const blogIdInput = form?.querySelector(
        'input[name="blog_id"]',
      ) as HTMLInputElement;
      expect(blogIdInput?.value).toBe("123");

      const magicTokenInput = form?.querySelector(
        'input[name="magic_token"]',
      ) as HTMLInputElement;
      expect(magicTokenInput?.value).toBe("test-token");

      submitSpy.mockRestore();
    });

    it("should include search text in form submission", async () => {
      const props = createSearchFormProps();
      const { container } = render(SearchForm, { props });
      await tick();

      const submitSpy = vi.spyOn(HTMLFormElement.prototype, "submit");
      submitSpy.mockImplementation(() => {});

      const input = container.querySelector(
        'input[type="text"]',
      ) as HTMLInputElement;
      await fireEvent.input(input, { target: { value: "test search" } });
      await tick();

      const button = container.querySelector(
        "button.btn-primary",
      ) as HTMLButtonElement;
      await fireEvent.click(button);
      await tick();

      const form = document.body.querySelector("form");
      const searchInput = form?.querySelector(
        'input[name="search"]',
      ) as HTMLInputElement;
      expect(searchInput?.value).toBe("test search");

      submitSpy.mockRestore();
    });
  });

  describe("Search Text Input", () => {
    it("should have placeholder text", async () => {
      const props = createSearchFormProps();
      const { container } = render(SearchForm, { props });
      await tick();

      const input = container.querySelector(
        'input[type="text"]',
      ) as HTMLInputElement;
      expect(input.placeholder).toContain("Select target and search text...");
    });
  });
});
