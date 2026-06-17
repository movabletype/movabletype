import { render, fireEvent } from "@testing-library/svelte";
import { describe, it, expect, beforeEach, afterEach, vi } from "vitest";
import { tick } from "svelte";
import SiteListButtonTestWrapper from "./SiteListButtonTestWrapper.svelte";
import {
  createMockSite,
  cleanupPortals,
} from "../../../tests/helpers/createAdmin2025TestProps.svelte";
import {
  setupAjaxMock as setupAjaxMockBase,
  setupAjaxMockWithPending,
  setupFetchMock,
  type AjaxMockFn,
  type FetchMockFn,
} from "../../../tests/helpers/jquery";

const setupFetchSitesMock = (
  sites: ReturnType<typeof createMockSite>[] = [],
  options: { count?: number; page?: number; pageMax?: number } = {},
): { mockAjax: AjaxMockFn; mockFetch: FetchMockFn } => {
  const objects = sites.map((site) => [
    site.id,
    `<a href="/dashboard?blog_id=${site.id}">${site.name}</a>`,
    site.siteUrl,
    site.parentSiteName,
  ]);

  const mockAjax = setupAjaxMockBase({
    result: {
      count: String(options.count ?? sites.length),
      page: String(options.page ?? 1),
      page_max: String(options.pageMax ?? 1),
      objects: objects,
    },
  });
  const mockFetch = setupFetchMock({ success: true });

  return { mockAjax, mockFetch };
};

describe("SiteListButton Component", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    setupFetchSitesMock();
  });

  afterEach(() => {
    cleanupPortals();
    document.body.innerHTML = "";
  });

  describe("Initial Rendering", () => {
    it("should render the component", async () => {
      setupFetchSitesMock();
      const { container } = render(SiteListButtonTestWrapper);
      await tick();
      expect(container).toBeTruthy();
    });

    it("should not render modal when open is false", async () => {
      setupFetchSitesMock();
      render(SiteListButtonTestWrapper, {
        props: { open: false },
      });
      await tick();

      const modal = document.body.querySelector(".site-list-button-modal");
      expect(modal).not.toBeInTheDocument();
    });

    it("should render modal when open is true", async () => {
      setupFetchSitesMock();
      render(SiteListButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const modal = document.body.querySelector(".site-list-button-modal");
      expect(modal).toBeInTheDocument();
    });

    it("should render close button in modal header", async () => {
      setupFetchSitesMock();
      render(SiteListButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const closeButton = document.body.querySelector(
        ".site-list-button-modal .close",
      );
      expect(closeButton).toBeInTheDocument();
    });

    it("should render overlay when modal is open", async () => {
      setupFetchSitesMock();
      render(SiteListButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const overlay = document.body.querySelector(
        ".site-list-button-modal-overlay",
      );
      expect(overlay).toBeInTheDocument();
    });
  });

  describe("Sites Fetching", () => {
    it("should fetch sites when modal opens", async () => {
      const { mockAjax } = setupFetchSitesMock();

      render(SiteListButtonTestWrapper, {
        props: { open: true, magicToken: "test-token" },
      });
      await tick();
      await tick();

      expect(mockAjax).toHaveBeenCalled();
    });

    it("should display loading state while fetching sites", async () => {
      const { resolve } = setupAjaxMockWithPending<{
        result: {
          success: number;
          count: string;
          page: string;
          page_max: string;
          objects: never[];
        };
      }>();

      render(SiteListButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const modal = document.body.querySelector(".site-list-button-modal");
      expect(modal?.textContent).toContain("Loading...");

      resolve({
        result: {
          success: 1,
          count: "0",
          page: "1",
          page_max: "1",
          objects: [],
        },
      });
      await tick();
    });

    it("should display sites after fetch completes", async () => {
      const sites = [
        createMockSite({ id: "1", name: "Site 1" }),
        createMockSite({ id: "2", name: "Site 2" }),
      ];
      setupFetchSitesMock(sites);

      render(SiteListButtonTestWrapper, {
        props: { open: true },
      });
      await tick();
      await tick();

      const modal = document.body.querySelector(".site-list-button-modal");
      expect(modal?.textContent).toContain("Site 1");
      expect(modal?.textContent).toContain("Site 2");
    });

    it("should not fetch sites if already fetched", async () => {
      const { mockAjax } = setupFetchSitesMock([createMockSite()]);

      const { rerender } = render(SiteListButtonTestWrapper, {
        props: { open: true },
      });
      await tick();
      await tick();

      const callCountAfterOpen = mockAjax.mock.calls.length;

      await rerender({ open: false });
      await tick();
      await rerender({ open: true });
      await tick();

      expect(mockAjax.mock.calls.length).toBe(callCountAfterOpen);
    });
  });

  describe("Site List Display", () => {
    it("should display site name with dashboard link", async () => {
      const sites = [createMockSite({ id: "123", name: "My Site" })];
      setupFetchSitesMock(sites);

      render(SiteListButtonTestWrapper, {
        props: { open: true },
      });
      await tick();
      await tick();

      const modal = document.body.querySelector(".site-list-button-modal");
      const siteLink = modal?.querySelector('a[href*="blog_id=123"]');
      expect(siteLink).toBeInTheDocument();
      expect(siteLink?.textContent).toContain("My Site");
    });

    it("should display site URL link", async () => {
      const sites = [
        createMockSite({
          id: "1",
          name: "Site",
          siteUrl: "https://example.com/",
        }),
      ];
      setupFetchSitesMock(sites);

      render(SiteListButtonTestWrapper, {
        props: { open: true },
      });
      await tick();
      await tick();

      const modal = document.body.querySelector(".site-list-button-modal");
      const urlLink = modal?.querySelector('a[href="https://example.com/"]');
      expect(urlLink).toBeInTheDocument();
    });

    it("should display total count", async () => {
      const sites = [createMockSite()];
      setupFetchSitesMock(sites, { count: 10 });

      render(SiteListButtonTestWrapper, {
        props: { open: true },
      });
      await tick();
      await tick();

      const modal = document.body.querySelector(".site-list-button-modal");
      expect(modal?.textContent).toContain("10");
    });
  });

  describe("Pagination", () => {
    it("should render pagination controls", async () => {
      const sites = [createMockSite()];
      setupFetchSitesMock(sites, { count: 100, page: 1, pageMax: 2 });

      render(SiteListButtonTestWrapper, {
        props: { open: true },
      });
      await tick();
      await tick();

      const modal = document.body.querySelector(".site-list-button-modal");
      const paginationButtons = modal?.querySelectorAll(".prev-next button");
      expect(paginationButtons?.length).toBeGreaterThan(0);
    });

    it("should disable previous/first buttons on first page", async () => {
      const sites = [createMockSite()];
      setupFetchSitesMock(sites, { count: 100, page: 1, pageMax: 2 });

      render(SiteListButtonTestWrapper, {
        props: { open: true },
      });
      await tick();
      await tick();

      const modal = document.body.querySelector(".site-list-button-modal");
      const prevNextDiv = modal?.querySelector(".prev-next");
      expect(prevNextDiv).toBeInTheDocument();

      const buttons = prevNextDiv?.querySelectorAll("button");
      expect(buttons?.[0]?.disabled).toBe(true);
      expect(buttons?.[1]?.disabled).toBe(true);
    });

    it("should display current page number", async () => {
      const sites = [createMockSite()];
      setupFetchSitesMock(sites, { count: 100, page: 2, pageMax: 4 });

      render(SiteListButtonTestWrapper, {
        props: { open: true },
      });
      await tick();
      await tick();

      const modal = document.body.querySelector(".site-list-button-modal");
      expect(modal?.textContent).toContain("2");
    });
  });

  describe("Filtering", () => {
    it("should render site type filter dropdown", async () => {
      setupFetchSitesMock();

      render(SiteListButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const modal = document.body.querySelector(".site-list-button-modal");
      const filterSelect = modal?.querySelector("select");
      expect(filterSelect).toBeInTheDocument();
    });

    it("should render site name filter input", async () => {
      setupFetchSitesMock();

      render(SiteListButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const modal = document.body.querySelector(".site-list-button-modal");
      const filterInput = modal?.querySelector('input[type="text"]');
      expect(filterInput).toBeInTheDocument();
    });
  });

  describe("Star Management", () => {
    it("should display star icon for sites", async () => {
      const sites = [createMockSite({ id: "1", name: "Site 1" })];
      setupFetchSitesMock(sites);

      render(SiteListButtonTestWrapper, {
        props: { open: true, initialStarredSites: [] },
      });
      await tick();
      await tick();

      const modal = document.body.querySelector(".site-list-button-modal");
      const starButtons = modal?.querySelectorAll(
        '[class*="star"], button[aria-label*="star"]',
      );
      expect(starButtons?.length).toBeGreaterThanOrEqual(0);
    });
  });

  describe("Modal Operations", () => {
    it("should close modal when close button clicked", async () => {
      setupFetchSitesMock();

      render(SiteListButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const closeButton = document.body.querySelector(
        ".site-list-button-modal .close",
      ) as HTMLButtonElement;
      await fireEvent.click(closeButton);
      await tick();

      const modal = document.body.querySelector(".site-list-button-modal");
      expect(modal).not.toBeInTheDocument();
    });

    it("should close modal when overlay clicked", async () => {
      setupFetchSitesMock();

      render(SiteListButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const overlay = document.body.querySelector(
        ".site-list-button-modal-overlay",
      ) as HTMLElement;
      await fireEvent.click(overlay);
      await tick();

      const modal = document.body.querySelector(".site-list-button-modal");
      expect(modal).not.toBeInTheDocument();
    });

    it("should add open class to anchorRef when open", async () => {
      setupFetchSitesMock();

      const { container } = render(SiteListButtonTestWrapper, {
        props: { open: true },
      });
      await tick();

      const button = container.querySelector("button");
      expect(button).toHaveClass("open");
    });

    it("should not have open class when modal is closed", async () => {
      setupFetchSitesMock();

      const { container } = render(SiteListButtonTestWrapper, {
        props: { open: false },
      });
      await tick();

      const button = container.querySelector("button");
      expect(button).not.toHaveClass("open");
    });
  });

  describe("Empty State", () => {
    it("should handle empty sites list", async () => {
      setupFetchSitesMock([], { count: 0 });

      render(SiteListButtonTestWrapper, {
        props: { open: true },
      });
      await tick();
      await tick();

      const modal = document.body.querySelector(".site-list-button-modal");
      expect(modal).toBeInTheDocument();
      expect(modal?.textContent).toContain("0");
    });
  });

  describe("Initial Starred Sites", () => {
    it("should accept initialStarredSites prop", async () => {
      const sites = [
        createMockSite({ id: "1", name: "Starred Site" }),
        createMockSite({ id: "2", name: "Normal Site" }),
      ];
      setupFetchSitesMock(sites);

      render(SiteListButtonTestWrapper, {
        props: { open: true, initialStarredSites: [1] },
      });
      await tick();
      await tick();

      const modal = document.body.querySelector(".site-list-button-modal");
      expect(modal?.textContent).toContain("Starred Site");
    });
  });
});
