import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import ListPaginationForPcTestWrapper from "./ListPaginationForPcTestWrapper.svelte";
import { createListPaginationForPcProps } from "../../tests/helpers/createListingTestProps.svelte";

describe("ListPaginationForPc Component", () => {
  it("should render the component", () => {
    const { container } = render(ListPaginationForPcTestWrapper, {
      props: createListPaginationForPcProps({ page: 1 }),
    });

    expect(container).toBeTruthy();
  });

  it("should render Previous link", () => {
    const { container } = render(ListPaginationForPcTestWrapper, {
      props: createListPaginationForPcProps({ page: 2 }),
    });

    const links = container.querySelectorAll(".page-link");
    expect(links[0]).toHaveTextContent("Previous");
  });

  it("should render Next link", () => {
    const { container } = render(ListPaginationForPcTestWrapper, {
      props: createListPaginationForPcProps({ page: 1 }),
    });

    const links = container.querySelectorAll(".page-link");
    const lastLink = links[links.length - 1];
    expect(lastLink).toHaveTextContent("Next");
  });

  it("should disable Previous link on first page", () => {
    const { container } = render(ListPaginationForPcTestWrapper, {
      props: createListPaginationForPcProps({ page: 1 }),
    });

    const prevLink = container.querySelector(".page-link");
    expect(prevLink).toHaveAttribute("disabled", "disabled");
  });

  it("should disable Next link on last page", () => {
    const { container } = render(ListPaginationForPcTestWrapper, {
      props: createListPaginationForPcProps({
        page: 10,
        contextOverrides: { pageMax: 10 },
      }),
    });

    const links = container.querySelectorAll(".page-link");
    const lastLink = links[links.length - 1];
    expect(lastLink).toHaveAttribute("disabled", "disabled");
  });

  it("should render current page as active", () => {
    const { container } = render(ListPaginationForPcTestWrapper, {
      props: createListPaginationForPcProps({ page: 5 }),
    });

    const activeItem = container.querySelector(".page-item.active");
    expect(activeItem).toBeInTheDocument();
    expect(activeItem).toHaveTextContent("5");
  });

  it("should render first page link when page > 2", () => {
    const { container } = render(ListPaginationForPcTestWrapper, {
      props: createListPaginationForPcProps({ page: 5 }),
    });

    const firstLastItems = container.querySelectorAll(".first-last");
    expect(firstLastItems.length).toBeGreaterThanOrEqual(1);
  });

  it("should render ellipsis when page > 3", () => {
    const { container } = render(ListPaginationForPcTestWrapper, {
      props: createListPaginationForPcProps({ page: 5 }),
    });

    const ellipsis = container.querySelector('[aria-hidden="true"]');
    expect(ellipsis).toBeInTheDocument();
    expect(ellipsis).toHaveTextContent("...");
  });

  it("should have d-none d-md-flex classes for desktop display", () => {
    const { container } = render(ListPaginationForPcTestWrapper, {
      props: createListPaginationForPcProps({ page: 1 }),
    });

    const pagination = container.querySelector(".pagination");
    expect(pagination).toHaveClass("d-none");
    expect(pagination).toHaveClass("d-md-flex");
  });

  it("should set correct data-page on Previous link", () => {
    const { container } = render(ListPaginationForPcTestWrapper, {
      props: createListPaginationForPcProps({ page: 5 }),
    });

    const prevLink = container.querySelector(".page-link");
    expect(prevLink).toHaveAttribute("data-page", "4");
  });

  it("should set correct data-page on Next link", () => {
    const { container } = render(ListPaginationForPcTestWrapper, {
      props: createListPaginationForPcProps({ page: 5 }),
    });

    const links = container.querySelectorAll(".page-link");
    const lastLink = links[links.length - 1];
    expect(lastLink).toHaveAttribute("data-page", "6");
  });
});
