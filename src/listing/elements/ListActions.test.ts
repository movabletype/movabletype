import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import ListActionsTestWrapper from "./ListActionsTestWrapper.svelte";
import {
  createMockAction,
  createListActionsProps,
} from "../../tests/helpers/createListingTestProps.svelte";
import type * as Listing from "../../@types/listing";

describe("ListActions Component", () => {
  it("should render the component", () => {
    const { container } = render(ListActionsTestWrapper, {
      props: createListActionsProps(),
    });

    expect(container).toBeTruthy();
  });

  it("should render PC version container", () => {
    const { container } = render(ListActionsTestWrapper, {
      props: createListActionsProps(),
    });

    const pcContainer = container.querySelector(
      '[data-is="list-actions-for-pc"]',
    );
    expect(pcContainer).toBeInTheDocument();
    expect(pcContainer).toHaveClass("d-none");
    expect(pcContainer).toHaveClass("d-md-block");
  });

  it("should render mobile version container", () => {
    const { container } = render(ListActionsTestWrapper, {
      props: createListActionsProps(),
    });

    const mobileContainer = container.querySelector(
      '[data-is="list-actions-for-mobile"]',
    );
    expect(mobileContainer).toBeInTheDocument();
    expect(mobileContainer).toHaveClass("d-md-none");
  });

  it("should render button actions in PC version", () => {
    const buttonActions: Listing.ButtonActions = {
      delete: createMockAction("Delete"),
    };

    const { container } = render(ListActionsTestWrapper, {
      props: createListActionsProps({ buttonActions }),
    });

    const pcContainer = container.querySelector(
      '[data-is="list-actions-for-pc"]',
    );
    const button = pcContainer?.querySelector("button.btn-default");
    expect(button).toBeInTheDocument();
    expect(button).toHaveTextContent("Delete");
  });

  it("should render dropdown in PC version when hasPulldownActions is true", () => {
    const listActions: Listing.ListActions = {
      edit: createMockAction("Edit"),
    };

    const { container } = render(ListActionsTestWrapper, {
      props: createListActionsProps({ hasPulldownActions: true, listActions }),
    });

    const pcContainer = container.querySelector(
      '[data-is="list-actions-for-pc"]',
    );
    const dropdown = pcContainer?.querySelector(".btn-group");
    expect(dropdown).toBeInTheDocument();
  });

  it("should render list actions in PC dropdown", () => {
    const listActions: Listing.ListActions = {
      edit: createMockAction("Edit"),
      view: createMockAction("View"),
    };

    const { container } = render(ListActionsTestWrapper, {
      props: createListActionsProps({ hasPulldownActions: true, listActions }),
    });

    const dropdownItems = container.querySelectorAll(
      '[data-is="list-actions-for-pc"] .dropdown-item',
    );
    expect(dropdownItems.length).toBe(2);
  });

  it("should pass singular and plural to component", () => {
    const { container } = render(ListActionsTestWrapper, {
      props: createListActionsProps({
        plural: "articles",
        singular: "article",
      }),
    });

    expect(container).toBeTruthy();
  });
});
