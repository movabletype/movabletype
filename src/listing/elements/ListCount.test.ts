import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import ListCountTestWrapper from "./ListCountTestWrapper.svelte";
import { createMockListStoreContext } from "../../tests/helpers/createListingTestProps.svelte";

describe("ListCount Component", () => {
  it("should render the component", () => {
    const context = createMockListStoreContext({
      count: 100,
      limit: 25,
      page: 1,
    });

    const { container } = render(ListCountTestWrapper, {
      props: { context },
    });

    expect(container).toBeTruthy();
  });

  it("should display correct count range for first page", () => {
    const context = createMockListStoreContext({
      count: 100,
      limit: 25,
      page: 1,
    });

    const { container } = render(ListCountTestWrapper, {
      props: { context },
    });

    expect(container.textContent).toContain("1 - 25 / 100");
  });

  it("should display correct count range for second page", () => {
    const context = createMockListStoreContext({
      count: 100,
      limit: 25,
      page: 2,
    });

    const { container } = render(ListCountTestWrapper, {
      props: { context },
    });

    expect(container.textContent).toContain("26 - 50 / 100");
  });

  it("should display correct count range for last page", () => {
    const context = createMockListStoreContext({
      count: 100,
      limit: 25,
      page: 4,
    });

    const { container } = render(ListCountTestWrapper, {
      props: { context },
    });

    expect(container.textContent).toContain("76 - 100 / 100");
  });

  it("should display correct count range when last page is partial", () => {
    const context = createMockListStoreContext({
      count: 90,
      limit: 25,
      page: 4,
    });

    const { container } = render(ListCountTestWrapper, {
      props: { context },
    });

    expect(container.textContent).toContain("76 - 90 / 90");
  });

  it("should display 0 - 0 / 0 when count is 0", () => {
    const context = createMockListStoreContext({
      count: 0,
      limit: 25,
      page: 1,
    });

    const { container } = render(ListCountTestWrapper, {
      props: { context },
    });

    expect(container.textContent).toContain("0 - 0 / 0");
  });

  it("should handle single item", () => {
    const context = createMockListStoreContext({
      count: 1,
      limit: 25,
      page: 1,
    });

    const { container } = render(ListCountTestWrapper, {
      props: { context },
    });

    expect(container.textContent).toContain("1 - 1 / 1");
  });
});
