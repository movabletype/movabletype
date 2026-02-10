import { vi } from "vitest";
import type { Site, Sites } from "../../@types/site";
import type { ContentType, ContentTypes } from "../../@types/contenttype";
import type { SearchTab } from "../../admin2025/buttons/search-button";

export function createMockSite(overrides: Partial<Site> = {}): Site {
  return {
    id: "1",
    name: "Test Site",
    siteUrl: "https://example.com/",
    parentSiteName: "",
    ...overrides,
  };
}

export function createMockSites(
  count: number = 3,
  overrides: Partial<Sites> = {},
): Sites {
  const sites = Array.from({ length: count }, (_, i) =>
    createMockSite({
      id: String(i + 1),
      name: `Test Site ${i + 1}`,
    }),
  );

  return {
    count: sites.length,
    page: 1,
    pageMax: 1,
    sites,
    ...overrides,
  };
}

export function createMockContentType(
  overrides: Partial<ContentType> = {},
): ContentType {
  return {
    id: "1",
    name: "Test Content Type",
    can_create: 1,
    can_search: 1,
    ...overrides,
  };
}

export function createMockContentTypes(count: number = 3): ContentTypes {
  const contentTypes = Array.from({ length: count }, (_, i) =>
    createMockContentType({
      id: String(i + 1),
      name: `Content Type ${i + 1}`,
    }),
  );

  return {
    contentTypes,
  };
}

export function createMockSearchTab(
  overrides: Partial<SearchTab> = {},
): SearchTab {
  return {
    key: "entry",
    label: "Entry",
    ...overrides,
  };
}

export function createMockSearchTabs(): SearchTab[] {
  return [
    { key: "entry", label: "Entry" },
    { key: "page", label: "Page" },
    { key: "content_data", label: "Content Data" },
  ];
}

export interface SidebarProps {
  buttonRef: HTMLButtonElement;
  collapsed?: boolean;
  isStored?: boolean;
}

export function createSidebarProps(
  overrides: Partial<SidebarProps> = {},
): SidebarProps {
  const buttonRef = overrides.buttonRef ?? document.createElement("button");
  return {
    buttonRef,
    collapsed: false,
    isStored: false,
    ...overrides,
  };
}

export interface SearchFormProps {
  blogId: string;
  magicToken: string;
  contentTypes: ContentType[];
  searchTabs: SearchTab[];
  objectType: string;
  isLoading: boolean;
}

export function createSearchFormProps(
  overrides: Partial<SearchFormProps> = {},
): SearchFormProps {
  return {
    blogId: "1",
    magicToken: "test-magic-token",
    contentTypes: [],
    searchTabs: createMockSearchTabs(),
    objectType: "entry",
    isLoading: false,
    ...overrides,
  };
}

export interface CreateButtonProps {
  blog_id: string;
  magicToken: string;
  open: boolean;
  anchorRef: HTMLElement;
  containerRef: HTMLElement;
}

export function createCreateButtonProps(
  overrides: Partial<CreateButtonProps> = {},
): CreateButtonProps {
  const anchorRef = overrides.anchorRef ?? document.createElement("button");
  const containerRef = overrides.containerRef ?? document.createElement("div");
  return {
    blog_id: "1",
    magicToken: "test-magic-token",
    open: false,
    anchorRef,
    containerRef,
    ...overrides,
  };
}

export interface SearchButtonProps {
  blogId: string;
  magicToken: string;
  open: boolean;
  anchorRef: HTMLElement;
  searchTabs: SearchTab[];
  objectType: string;
}

export function createSearchButtonProps(
  overrides: Partial<SearchButtonProps> = {},
): SearchButtonProps {
  const anchorRef = overrides.anchorRef ?? document.createElement("button");
  return {
    blogId: "1",
    magicToken: "test-magic-token",
    open: false,
    anchorRef,
    searchTabs: createMockSearchTabs(),
    objectType: "entry",
    ...overrides,
  };
}

export interface SiteListButtonProps {
  magicToken: string;
  limit?: number;
  open?: boolean;
  anchorRef: HTMLElement;
  initialStarredSites: number[];
}

export function createSiteListButtonProps(
  overrides: Partial<SiteListButtonProps> = {},
): SiteListButtonProps {
  const anchorRef = overrides.anchorRef ?? document.createElement("button");
  return {
    magicToken: "test-magic-token",
    limit: 50,
    open: false,
    anchorRef,
    initialStarredSites: [],
    ...overrides,
  };
}

export const mockFetchSites = vi.fn();
export const mockFetchContentTypes = vi.fn();

export function setupTestDom(): {
  contentWrapper: HTMLDivElement;
  primaryNavigation: HTMLElement;
  cleanup: () => void;
} {
  const contentWrapper = document.createElement("div");
  contentWrapper.setAttribute("data-is", "content-wrapper");
  document.body.appendChild(contentWrapper);

  const primaryNavigation = document.createElement("nav");
  primaryNavigation.setAttribute("data-is", "primary-navigation");
  document.body.appendChild(primaryNavigation);

  const cleanup = (): void => {
    contentWrapper.remove();
    primaryNavigation.remove();
  };

  return { contentWrapper, primaryNavigation, cleanup };
}

export function cleanupPortals(): void {
  document
    .querySelectorAll(
      ".site-list-button-modal, .search-button-modal, .create-button-modal, .mt-primaryNavigation-overlay, .search-button-modal-overlay",
    )
    .forEach((el) => el.remove());
}
