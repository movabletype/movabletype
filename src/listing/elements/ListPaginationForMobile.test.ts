import { render } from "@testing-library/svelte";
import { describe, it, expect, vi } from "vitest";
import ListPaginationForMobileTestWrapper from "./ListPaginationForMobileTestWrapper.svelte";
import { createMockListStoreContext } from "../../tests/helpers/createListingTestProps.svelte";

describe("ListPaginationForMobile Component", () => {
  it("should render the component", () => {
    const movePageMock = vi.fn();
    const context = createMockListStoreContext({ page: 1, pageMax: 10 });

    const { container } = render(ListPaginationForMobileTestWrapper, {
      props: {
        context,
        isTooNarrowWidth: false,
        movePage: movePageMock,
        nextDisabledProp: {},
        page: 1,
        previousDisabledProp: { disabled: "disabled" },
      },
    });

    expect(container).toBeTruthy();
  });

  it("should have d-md-none class for mobile display", () => {
    const movePageMock = vi.fn();
    const context = createMockListStoreContext({ page: 1, pageMax: 10 });

    const { container } = render(ListPaginationForMobileTestWrapper, {
      props: {
        context,
        isTooNarrowWidth: false,
        movePage: movePageMock,
        nextDisabledProp: {},
        page: 1,
        previousDisabledProp: { disabled: "disabled" },
      },
    });

    const pagination = container.querySelector(".pagination__mobile");
    expect(pagination).toBeInTheDocument();
    expect(pagination).toHaveClass("d-md-none");
  });

  it("should render Previous link with SVG icon", () => {
    const movePageMock = vi.fn();
    const context = createMockListStoreContext({ page: 2, pageMax: 10 });

    const { container } = render(ListPaginationForMobileTestWrapper, {
      props: {
        context,
        isTooNarrowWidth: false,
        movePage: movePageMock,
        nextDisabledProp: {},
        page: 2,
        previousDisabledProp: {},
      },
    });

    const svgs = container.querySelectorAll("svg");
    expect(svgs.length).toBeGreaterThanOrEqual(1);
  });

  it("should render Next link with SVG icon", () => {
    const movePageMock = vi.fn();
    const context = createMockListStoreContext({ page: 1, pageMax: 10 });

    const { container } = render(ListPaginationForMobileTestWrapper, {
      props: {
        context,
        isTooNarrowWidth: false,
        movePage: movePageMock,
        nextDisabledProp: {},
        page: 1,
        previousDisabledProp: { disabled: "disabled" },
      },
    });

    const svgs = container.querySelectorAll("svg");
    expect(svgs.length).toBeGreaterThanOrEqual(1);
  });

  it("should disable Previous link on first page", () => {
    const movePageMock = vi.fn();
    const context = createMockListStoreContext({ page: 1, pageMax: 10 });

    const { container } = render(ListPaginationForMobileTestWrapper, {
      props: {
        context,
        isTooNarrowWidth: false,
        movePage: movePageMock,
        nextDisabledProp: {},
        page: 1,
        previousDisabledProp: { disabled: "disabled" },
      },
    });

    const prevLink = container.querySelector(".page-link");
    expect(prevLink).toHaveAttribute("disabled", "disabled");
  });

  it("should disable Next link on last page", () => {
    const movePageMock = vi.fn();
    const context = createMockListStoreContext({ page: 10, pageMax: 10 });

    const { container } = render(ListPaginationForMobileTestWrapper, {
      props: {
        context,
        isTooNarrowWidth: false,
        movePage: movePageMock,
        nextDisabledProp: { disabled: "disabled" },
        page: 10,
        previousDisabledProp: {},
      },
    });

    const links = container.querySelectorAll(".page-link");
    const lastLink = links[links.length - 1];
    expect(lastLink).toHaveAttribute("disabled", "disabled");
  });

  it("should render current page as active", () => {
    const movePageMock = vi.fn();
    const context = createMockListStoreContext({ page: 5, pageMax: 10 });

    const { container } = render(ListPaginationForMobileTestWrapper, {
      props: {
        context,
        isTooNarrowWidth: false,
        movePage: movePageMock,
        nextDisabledProp: {},
        page: 5,
        previousDisabledProp: {},
      },
    });

    const activeItem = container.querySelector(".page-item.active");
    expect(activeItem).toBeInTheDocument();
    expect(activeItem).toHaveTextContent("5");
  });

  it("should render adjacent pages", () => {
    const movePageMock = vi.fn();
    const context = createMockListStoreContext({ page: 5, pageMax: 10 });

    const { container } = render(ListPaginationForMobileTestWrapper, {
      props: {
        context,
        isTooNarrowWidth: false,
        movePage: movePageMock,
        nextDisabledProp: {},
        page: 5,
        previousDisabledProp: {},
      },
    });

    const pageLinks = container.querySelectorAll(".page-link");
    const pageTexts = Array.from(pageLinks).map((l) => l.textContent?.trim());
    expect(pageTexts).toContain("3");
    expect(pageTexts).toContain("4");
    expect(pageTexts).toContain("6");
    expect(pageTexts).toContain("7");
  });

  it("should add me-auto class when isTooNarrowWidth is true", () => {
    const movePageMock = vi.fn();
    const context = createMockListStoreContext({ page: 5, pageMax: 10 });

    const { container } = render(ListPaginationForMobileTestWrapper, {
      props: {
        context,
        isTooNarrowWidth: true,
        movePage: movePageMock,
        nextDisabledProp: {},
        page: 5,
        previousDisabledProp: {},
      },
    });

    const itemsWithMeAuto = container.querySelectorAll(".page-item.me-auto");
    expect(itemsWithMeAuto.length).toBeGreaterThan(0);
  });

  it("should set correct data-page on Previous link", () => {
    const movePageMock = vi.fn();
    const context = createMockListStoreContext({ page: 5, pageMax: 10 });

    const { container } = render(ListPaginationForMobileTestWrapper, {
      props: {
        context,
        isTooNarrowWidth: false,
        movePage: movePageMock,
        nextDisabledProp: {},
        page: 5,
        previousDisabledProp: {},
      },
    });

    const prevLink = container.querySelector(".page-link");
    expect(prevLink).toHaveAttribute("data-page", "4");
  });

  it("should set correct data-page on Next link", () => {
    const movePageMock = vi.fn();
    const context = createMockListStoreContext({ page: 5, pageMax: 10 });

    const { container } = render(ListPaginationForMobileTestWrapper, {
      props: {
        context,
        isTooNarrowWidth: false,
        movePage: movePageMock,
        nextDisabledProp: {},
        page: 5,
        previousDisabledProp: {},
      },
    });

    const links = container.querySelectorAll(".page-link");
    const lastLink = links[links.length - 1];
    expect(lastLink).toHaveAttribute("data-page", "6");
  });
});
