import { render, fireEvent } from "@testing-library/svelte";
import { describe, it, expect, beforeEach, afterEach, vi } from "vitest";
import { tick } from "svelte";
import CreateButtonTestWrapper from "./CreateButtonTestWrapper.svelte";
import {
  createMockContentType,
  cleanupPortals,
} from "../../../tests/helpers/createAdmin2025TestProps.svelte";
import {
  setupAjaxMock as setupAjaxMockBase,
  setupAjaxMockWithPending,
  setupAjaxMockRejected,
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

describe("CreateButton Component", () => {
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
      const { container } = render(CreateButtonTestWrapper);
      await tick();
      expect(container).toBeTruthy();
    });

    it("should not render modal when open is false", async () => {
      setupAjaxMock();
      render(CreateButtonTestWrapper, {
        props: { open: false },
      });
      await tick();

      const modal = document.body.querySelector(".create-button-modal");
      expect(modal).not.toBeInTheDocument();
    });

    it("should render modal when open is true", async () => {
      setupAjaxMock();
      render(CreateButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const modal = document.body.querySelector(".create-button-modal");
      expect(modal).toBeInTheDocument();
    });

    it("should render close button in modal header", async () => {
      setupAjaxMock();
      render(CreateButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const closeButton = document.body.querySelector(
        ".create-button-modal .close",
      );
      expect(closeButton).toBeInTheDocument();
    });
  });

  describe("Content Types Fetching", () => {
    it("should fetch content types when modal opens", async () => {
      const mockAjax = setupAjaxMock();

      render(CreateButtonTestWrapper, {
        props: { open: true, blog_id: "123", magicToken: "test-token" },
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

    it("should display loading message while fetching", async () => {
      const { resolve } = setupAjaxMockWithPending<{
        result: { success: number; content_types: never[] };
      }>();

      render(CreateButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const modal = document.body.querySelector(".create-button-modal");
      expect(modal?.textContent).toContain("Loading...");

      resolve({ result: { success: 1, content_types: [] } });
      await tick();
    });

    it("should filter content types by can_create", async () => {
      const contentTypes = [
        createMockContentType({ id: "1", name: "Creatable", can_create: 1 }),
        createMockContentType({
          id: "2",
          name: "Not Creatable",
          can_create: 0,
        }),
        createMockContentType({
          id: "3",
          name: "Also Creatable",
          can_create: 1,
        }),
      ];
      setupAjaxMock(contentTypes);

      render(CreateButtonTestWrapper, {
        props: { open: true },
      });
      await tick();
      await tick();

      const modal = document.body.querySelector(".create-button-modal");

      const contentDataList = modal?.querySelector(
        ".create-button-list",
      ) as HTMLElement;
      const contentDataLinks = contentDataList?.querySelectorAll("a");
      expect(contentDataLinks?.length).toBe(2);
    });

    it("should display content type links after fetch", async () => {
      const contentTypes = [
        createMockContentType({
          id: "1",
          name: "Test Content Type",
          can_create: 1,
        }),
      ];
      setupAjaxMock(contentTypes);

      render(CreateButtonTestWrapper, {
        props: { open: true, blog_id: "123" },
      });
      await tick();
      await tick();

      const modal = document.body.querySelector(".create-button-modal");
      expect(modal?.textContent).toContain("Test Content Type");
    });

    it("should not fetch content types if already fetched", async () => {
      const mockAjax = setupAjaxMock();

      const { rerender } = render(CreateButtonTestWrapper, {
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

  describe("Creation Links", () => {
    it("should render Content Data section when content types exist", async () => {
      const contentTypes = [
        createMockContentType({ id: "1", name: "Test Type", can_create: 1 }),
      ];
      setupAjaxMock(contentTypes);

      render(CreateButtonTestWrapper, {
        props: { open: true },
      });
      await tick();
      await tick();

      const modal = document.body.querySelector(".create-button-modal");
      expect(modal?.textContent).toContain("Content Data");
    });

    it("should render Entry creation link", async () => {
      setupAjaxMock();

      render(CreateButtonTestWrapper, {
        props: { open: true, blog_id: "123" },
      });
      await tick();

      const modal = document.body.querySelector(".create-button-modal");
      const entryLink = modal?.querySelector('a[href*="_type=entry"]');
      expect(entryLink).toBeInTheDocument();
      expect(entryLink?.getAttribute("href")).toContain("blog_id=123");
    });

    it("should render Page creation link", async () => {
      setupAjaxMock();

      render(CreateButtonTestWrapper, {
        props: { open: true, blog_id: "456" },
      });
      await tick();

      const modal = document.body.querySelector(".create-button-modal");
      const pageLink = modal?.querySelector('a[href*="_type=page"]');
      expect(pageLink).toBeInTheDocument();
      expect(pageLink?.getAttribute("href")).toContain("blog_id=456");
    });

    it("should include correct URLs with blog_id", async () => {
      const contentTypes = [
        createMockContentType({ id: "99", name: "My Type", can_create: 1 }),
      ];
      setupAjaxMock(contentTypes);

      render(CreateButtonTestWrapper, {
        props: { open: true, blog_id: "789" },
      });
      await tick();
      await tick();

      const modal = document.body.querySelector(".create-button-modal");
      const contentDataLink = modal?.querySelector(
        'a[href*="content_type_id=99"]',
      );
      expect(contentDataLink).toBeInTheDocument();
      expect(contentDataLink?.getAttribute("href")).toContain("blog_id=789");
    });
  });

  describe("Modal Operations", () => {
    it("should close modal when close button clicked", async () => {
      setupAjaxMock();

      render(CreateButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const closeButton = document.body.querySelector(
        ".create-button-modal .close",
      ) as HTMLButtonElement;
      await fireEvent.click(closeButton);
      await tick();

      const modal = document.body.querySelector(".create-button-modal");
      expect(modal).not.toBeInTheDocument();
    });

    it("should add open class to anchorRef when open", async () => {
      setupAjaxMock();

      const { container } = render(CreateButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const button = container.querySelector("button");
      expect(button).toHaveClass("open");
    });

    it("should remove open class from anchorRef when closed", async () => {
      setupAjaxMock();

      const { container } = render(CreateButtonTestWrapper, {
        props: { open: false },
      });
      await tick();

      const button = container.querySelector("button");
      expect(button).not.toHaveClass("open");
    });
  });

  describe("Error Handling", () => {
    it("should handle fetch error gracefully", async () => {
      setupAjaxMockRejected(new Error("Network error"));

      const consoleSpy = vi
        .spyOn(console, "error")
        .mockImplementation(() => {});

      render(CreateButtonTestWrapper, {
        props: { open: true },
      });
      await tick();
      await tick();
      await tick();

      const modal = document.body.querySelector(".create-button-modal");
      expect(modal).toBeInTheDocument();
      consoleSpy.mockRestore();
    });
  });
});
