import { render, fireEvent } from "@testing-library/svelte";
import { describe, it, expect, beforeEach, afterEach, vi } from "vitest";
import { tick } from "svelte";
import SearchButtonTestWrapper from "./SearchButtonTestWrapper.svelte";
import {
  createMockContentType,
  createMockSearchTabs,
  cleanupPortals,
} from "../../../tests/helpers/createAdmin2025TestProps.svelte";
import {
  setupAjaxMock as setupAjaxMockBase,
  setupAjaxMockWithPending,
} from "../../../tests/helpers/jquery";

const setupAjaxMock = (
  contentTypes: ReturnType<typeof createMockContentType>[] = [],
): ReturnType<typeof setupAjaxMockBase> => {
  return setupAjaxMockBase({
    result: {
      success: 1,
      content_types: contentTypes,
    },
  });
};

describe("SearchButton Component", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  afterEach(() => {
    cleanupPortals();
    document.body.innerHTML = "";
  });

  describe("Initial Rendering", () => {
    it("should render the component", async () => {
      setupAjaxMock();
      const { container } = render(SearchButtonTestWrapper);
      await tick();
      expect(container).toBeTruthy();
    });

    it("should not render modal when open is false", async () => {
      setupAjaxMock();
      render(SearchButtonTestWrapper, {
        props: { open: false },
      });
      await tick();

      const modal = document.body.querySelector(".search-button-modal");
      expect(modal).not.toBeInTheDocument();
    });

    it("should render modal when open is true", async () => {
      setupAjaxMock();
      render(SearchButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const modal = document.body.querySelector(".search-button-modal");
      expect(modal).toBeInTheDocument();
    });

    it("should render close button in modal header", async () => {
      setupAjaxMock();
      render(SearchButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const closeButton = document.body.querySelector(
        ".search-button-modal .close",
      );
      expect(closeButton).toBeInTheDocument();
    });

    it("should render overlay when modal is open", async () => {
      setupAjaxMock();
      render(SearchButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const overlay = document.body.querySelector(
        ".search-button-modal-overlay",
      );
      expect(overlay).toBeInTheDocument();
    });
  });

  describe("Content Types Fetching", () => {
    it("should fetch content types when modal opens", async () => {
      const mockAjax = setupAjaxMock();

      render(SearchButtonTestWrapper, {
        props: { open: true, blogId: "123", magicToken: "test-token" },
      });
      await tick();
      await tick();

      expect(mockAjax).toHaveBeenCalledWith(
        expect.any(String),
        expect.objectContaining({
          data: expect.objectContaining({
            blog_id: "123",
            magic_token: "test-token",
          }),
        }),
      );
    });

    it("should filter content types by can_search", async () => {
      const contentTypes = [
        createMockContentType({ id: "1", name: "Searchable", can_search: 1 }),
        createMockContentType({
          id: "2",
          name: "Not Searchable",
          can_search: 0,
        }),
        createMockContentType({
          id: "3",
          name: "Also Searchable",
          can_search: 1,
        }),
      ];
      setupAjaxMock(contentTypes);

      render(SearchButtonTestWrapper, {
        props: { open: true, objectType: "content_data" },
      });
      await tick();
      await tick();

      const modal = document.body.querySelector(".search-button-modal");
      const select = modal?.querySelector("select");
      const options = select?.querySelectorAll("option");

      expect(options?.length).toBe(2);
    });

    it("should not fetch content types if already fetched", async () => {
      const mockAjax = setupAjaxMock();

      const { rerender } = render(SearchButtonTestWrapper, {
        props: { open: true },
      });
      await tick();
      await tick();

      await rerender({ open: false });
      await tick();
      await rerender({ open: true });
      await tick();

      expect(mockAjax).toHaveBeenCalledTimes(1);
    });
  });

  describe("SearchForm Integration", () => {
    it("should render SearchForm component inside modal", async () => {
      setupAjaxMock();

      render(SearchButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const modal = document.body.querySelector(".search-button-modal");
      const searchForm = modal?.querySelector(".mt-search-form");
      expect(searchForm).toBeInTheDocument();
    });

    it("should pass contentTypes to SearchForm", async () => {
      const contentTypes = [
        createMockContentType({ id: "1", name: "Type 1", can_search: 1 }),
        createMockContentType({ id: "2", name: "Type 2", can_search: 1 }),
      ];
      setupAjaxMock(contentTypes);

      render(SearchButtonTestWrapper, {
        props: { open: true, objectType: "content_data" },
      });
      await tick();
      await tick();

      const modal = document.body.querySelector(".search-button-modal");
      const select = modal?.querySelector("select");
      const options = select?.querySelectorAll("option");

      expect(options?.length).toBe(2);
      expect(options?.[0].textContent).toBe("Type 1");
      expect(options?.[1].textContent).toBe("Type 2");
    });

    it("should pass searchTabs to SearchForm", async () => {
      setupAjaxMock();
      const searchTabs = createMockSearchTabs();

      render(SearchButtonTestWrapper, {
        props: { open: true, searchTabs },
      });
      await tick();

      const modal = document.body.querySelector(".search-button-modal");
      const radios = modal?.querySelectorAll('input[type="radio"]');

      expect(radios?.length).toBe(searchTabs.length);
    });

    it("should pass objectType to SearchForm", async () => {
      setupAjaxMock();

      render(SearchButtonTestWrapper, {
        props: { open: true, objectType: "page" },
      });
      await tick();

      const modal = document.body.querySelector(".search-button-modal");
      const pageRadio = modal?.querySelector(
        'input[type="radio"][value="page"]',
      ) as HTMLInputElement;

      expect(pageRadio?.checked).toBe(true);
    });
  });

  describe("ObjectType Initialization", () => {
    it("should set objectType to first searchTab if not provided", async () => {
      setupAjaxMock();
      const searchTabs = [
        { key: "custom1", label: "Custom 1" },
        { key: "custom2", label: "Custom 2" },
      ];

      render(SearchButtonTestWrapper, {
        props: { open: true, searchTabs, objectType: "" },
      });
      await tick();

      const modal = document.body.querySelector(".search-button-modal");
      const firstRadio = modal?.querySelector(
        'input[type="radio"][value="custom1"]',
      ) as HTMLInputElement;

      expect(firstRadio?.checked).toBe(true);
    });

    it("should keep objectType if exists in searchTabs", async () => {
      setupAjaxMock();
      const searchTabs = createMockSearchTabs();

      render(SearchButtonTestWrapper, {
        props: { open: true, searchTabs, objectType: "page" },
      });
      await tick();

      const modal = document.body.querySelector(".search-button-modal");
      const pageRadio = modal?.querySelector(
        'input[type="radio"][value="page"]',
      ) as HTMLInputElement;

      expect(pageRadio?.checked).toBe(true);
    });

    it("should select first searchTab if objectType does not exist in searchTabs", async () => {
      setupAjaxMock();
      const searchTabs = [
        { key: "custom1", label: "Custom 1" },
        { key: "custom2", label: "Custom 2" },
      ];

      render(SearchButtonTestWrapper, {
        props: { open: true, searchTabs, objectType: "nonexistent" },
      });
      await tick();

      const modal = document.body.querySelector(".search-button-modal");
      const firstRadio = modal?.querySelector(
        'input[type="radio"][value="custom1"]',
      ) as HTMLInputElement;

      expect(firstRadio?.checked).toBe(true);
    });
  });

  describe("Modal Operations", () => {
    it("should close modal when close button clicked", async () => {
      setupAjaxMock();

      render(SearchButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const closeButton = document.body.querySelector(
        ".search-button-modal .close",
      ) as HTMLButtonElement;
      await fireEvent.click(closeButton);
      await tick();

      const modal = document.body.querySelector(".search-button-modal");
      expect(modal).not.toBeInTheDocument();
    });

    it("should close modal when overlay clicked", async () => {
      setupAjaxMock();

      render(SearchButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const overlay = document.body.querySelector(
        ".search-button-modal-overlay",
      ) as HTMLElement;
      await fireEvent.click(overlay);
      await tick();

      const modal = document.body.querySelector(".search-button-modal");
      expect(modal).not.toBeInTheDocument();
    });

    it("should add open class to anchorRef when open", async () => {
      setupAjaxMock();

      const { container } = render(SearchButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const button = container.querySelector("button");
      expect(button).toHaveClass("open");
    });

    it("should not have open class when modal is closed", async () => {
      setupAjaxMock();

      const { container } = render(SearchButtonTestWrapper, {
        props: { open: false },
      });
      await tick();

      const button = container.querySelector("button");
      expect(button).not.toHaveClass("open");
    });
  });

  describe("Loading State", () => {
    it("should display loading state while fetching content types", async () => {
      const { resolve } = setupAjaxMockWithPending<{
        result: { success: number; content_types: never[] };
      }>();

      render(SearchButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const modal = document.body.querySelector(".search-button-modal");
      expect(modal?.textContent).toContain("Loading...");

      resolve({ result: { success: 1, content_types: [] } });
      await tick();
    });
  });
});
