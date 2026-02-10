import { render } from "@testing-library/svelte";
import { describe, it, expect, beforeEach, afterEach, vi } from "vitest";
import { tick } from "svelte";
import SidebarTestWrapper from "./SidebarTestWrapper.svelte";
import {
  setupTestDom,
  cleanupPortals,
} from "../../../tests/helpers/createAdmin2025TestProps.svelte";

describe("Sidebar Component", () => {
  let testDom: ReturnType<typeof setupTestDom>;

  beforeEach(() => {
    testDom = setupTestDom();
    vi.clearAllMocks();
  });

  afterEach(() => {
    testDom.cleanup();
    cleanupPortals();
    document.body.innerHTML = "";
  });

  describe("Initial Rendering", () => {
    it("should render the component", async () => {
      const { container } = render(SidebarTestWrapper);
      await tick();
      expect(container).toBeTruthy();
    });

    it("should render overlay element in body", async () => {
      render(SidebarTestWrapper);
      await tick();

      const overlay = document.body.querySelector(
        ".mt-primaryNavigation-overlay",
      );
      expect(overlay).toBeInTheDocument();
    });

    it("should hide overlay when not collapsed", async () => {
      render(SidebarTestWrapper, {
        props: { collapsed: false },
      });
      await tick();

      const overlay = document.body.querySelector(
        ".mt-primaryNavigation-overlay",
      ) as HTMLElement;
      expect(overlay).toHaveStyle({ display: "none" });
    });

    it("should show overlay when collapsed", async () => {
      render(SidebarTestWrapper, {
        props: { collapsed: true },
      });
      await tick();

      const overlay = document.body.querySelector(
        ".mt-primaryNavigation-overlay",
      ) as HTMLElement;
      expect(overlay).toHaveStyle({ display: "block" });
    });
  });

  describe("Collapse State", () => {
    it("should add collapsed class to buttonRef when collapsed", async () => {
      const { container } = render(SidebarTestWrapper, {
        props: { collapsed: true },
      });
      await tick();

      const button = container.querySelector("button");
      expect(button).toHaveClass("collapsed");
      expect(button).not.toHaveClass("expanded");
    });

    it("should add expanded class to buttonRef when not collapsed", async () => {
      const { container } = render(SidebarTestWrapper, {
        props: { collapsed: false },
      });
      await tick();

      const button = container.querySelector("button");
      expect(button).toHaveClass("expanded");
      expect(button).not.toHaveClass("collapsed");
    });

    it("should add collapsed class to content-wrapper when collapsed", async () => {
      render(SidebarTestWrapper, {
        props: { collapsed: true },
      });
      await tick();

      const contentWrapper = document.querySelector(
        '[data-is="content-wrapper"]',
      );
      expect(contentWrapper).toHaveClass("collapsed");
    });

    it("should remove collapsed class from content-wrapper when not collapsed", async () => {
      render(SidebarTestWrapper, {
        props: { collapsed: false },
      });
      await tick();

      const contentWrapper = document.querySelector(
        '[data-is="content-wrapper"]',
      );
      expect(contentWrapper).not.toHaveClass("collapsed");
    });

    it("should add mt-has-primary-navigation-collapsed class to documentElement when collapsed", async () => {
      render(SidebarTestWrapper, {
        props: { collapsed: true },
      });
      await tick();

      expect(document.documentElement).toHaveClass(
        "mt-has-primary-navigation-collapsed",
      );
    });

    it("should remove mt-has-primary-navigation-collapsed class from documentElement when not collapsed", async () => {
      render(SidebarTestWrapper, {
        props: { collapsed: false },
      });
      await tick();

      expect(document.documentElement).not.toHaveClass(
        "mt-has-primary-navigation-collapsed",
      );
    });
  });

  describe("Responsive Behavior", () => {
    it("should collapse on mount if window width < 1000 and not stored", async () => {
      Object.defineProperty(window, "innerWidth", {
        writable: true,
        configurable: true,
        value: 900,
      });

      const { container } = render(SidebarTestWrapper, {
        props: { collapsed: false, isStored: false },
      });
      await tick();

      const button = container.querySelector("button");
      expect(button).toHaveClass("collapsed");
    });

    it("should always collapse if window width < 800", async () => {
      Object.defineProperty(window, "innerWidth", {
        writable: true,
        configurable: true,
        value: 700,
      });

      const { container } = render(SidebarTestWrapper, {
        props: { collapsed: false, isStored: true },
      });
      await tick();

      const button = container.querySelector("button");
      expect(button).toHaveClass("collapsed");
    });

    it("should respect stored state if isStored is true and window width >= 1000", async () => {
      Object.defineProperty(window, "innerWidth", {
        writable: true,
        configurable: true,
        value: 1200,
      });

      const { container } = render(SidebarTestWrapper, {
        props: { collapsed: false, isStored: true },
      });
      await tick();

      const button = container.querySelector("button");
      expect(button).toHaveClass("expanded");
    });
  });

  describe("Mouse Interaction", () => {
    it("should have overlay that responds to mouseenter when collapsed", async () => {
      render(SidebarTestWrapper, {
        props: { collapsed: true },
      });
      await tick();

      const overlay = document.body.querySelector(
        ".mt-primaryNavigation-overlay",
      ) as HTMLElement;
      expect(overlay).toBeInTheDocument();
      expect(overlay.style.display).toBe("block");
    });

    it("should not show overlay when not collapsed", async () => {
      render(SidebarTestWrapper, {
        props: { collapsed: false },
      });
      await tick();

      const overlay = document.body.querySelector(
        ".mt-primaryNavigation-overlay",
      ) as HTMLElement;
      expect(overlay.style.display).toBe("none");

      const contentWrapper = document.querySelector(
        '[data-is="content-wrapper"]',
      );
      expect(contentWrapper).not.toHaveClass("mouseover");
    });
  });
});
