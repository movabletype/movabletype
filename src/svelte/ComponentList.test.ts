import { render, cleanup, waitFor } from "@testing-library/svelte";
import { describe, it, expect, vi, afterEach } from "vitest";
import { tick } from "svelte";
import ComponentListTestWrapper from "./ComponentListTestWrapper.svelte";

const setupMTMock = (
  components: HTMLElement[] = [],
): ReturnType<typeof vi.fn> => {
  const getAll = vi.fn().mockResolvedValue(components);
  (window as unknown as { MT: unknown }).MT = {
    UI: {
      Component: {
        getAll,
      },
    },
  };
  return getAll;
};

describe("ComponentList", () => {
  afterEach(() => {
    cleanup();
    delete (window as unknown as { MT?: unknown }).MT;
  });

  describe("Rendering", () => {
    it("should render container with flex classes", async () => {
      setupMTMock([]);

      const { container } = render(ComponentListTestWrapper, {
        props: { namespace: "test" },
      });
      await tick();

      const flexContainer = container.querySelector(".d-flex.flex-column");
      expect(flexContainer).toBeInTheDocument();
    });

    it("should render prepend snippet", async () => {
      setupMTMock([]);

      const { container } = render(ComponentListTestWrapper, {
        props: {
          namespace: "test",
          hasPrepend: true,
          prependText: "Before",
        },
      });
      await tick();

      const prepend = container.querySelector(".prepend-content");
      expect(prepend).toBeInTheDocument();
      expect(prepend?.textContent).toBe("Before");
    });

    it("should render append snippet", async () => {
      setupMTMock([]);

      const { container } = render(ComponentListTestWrapper, {
        props: {
          namespace: "test",
          hasAppend: true,
          appendText: "After",
        },
      });
      await tick();

      const append = container.querySelector(".append-content");
      expect(append).toBeInTheDocument();
      expect(append?.textContent).toBe("After");
    });

    it("should render both prepend and append", async () => {
      setupMTMock([]);

      const { container } = render(ComponentListTestWrapper, {
        props: {
          namespace: "test",
          hasPrepend: true,
          hasAppend: true,
          prependText: "Start",
          appendText: "End",
        },
      });
      await tick();

      expect(container.querySelector(".prepend-content")).toBeInTheDocument();
      expect(container.querySelector(".append-content")).toBeInTheDocument();
    });
  });

  describe("Component Loading", () => {
    it("should call getAll with namespace", async () => {
      const getAll = setupMTMock([]);

      render(ComponentListTestWrapper, {
        props: { namespace: "my-namespace" },
      });
      await tick();

      expect(getAll).toHaveBeenCalledWith("my-namespace");
    });

    it("should render loaded components", async () => {
      const component1 = document.createElement("div");
      component1.className = "component-1";
      const component2 = document.createElement("div");
      component2.className = "component-2";

      setupMTMock([component1, component2]);

      const { container } = render(ComponentListTestWrapper, {
        props: { namespace: "test" },
      });

      await waitFor(() => {
        expect(container.querySelector(".component-1")).toBeInTheDocument();
        expect(container.querySelector(".component-2")).toBeInTheDocument();
      });
    });
  });

  describe("Order Assignment", () => {
    it("should assign order style to elements after all ready", async () => {
      const component1 = document.createElement("div");
      component1.className = "order-test-1";
      const component2 = document.createElement("div");
      component2.className = "order-test-2";

      setupMTMock([component1, component2]);

      const { container } = render(ComponentListTestWrapper, {
        props: { namespace: "test" },
      });

      await waitFor(
        () => {
          const flexContainer = container.querySelector(".d-flex.flex-column");
          const children = flexContainer?.querySelectorAll(":scope > div");
          if (children && children.length >= 2) {
            const wrapper1 = children[1] as HTMLElement;
            const wrapper2 = children[2] as HTMLElement;
            expect(wrapper1.style.order || wrapper2.style.order).toBeTruthy();
          }
        },
        { timeout: 1000 },
      );
    });
  });

  describe("Event Handling", () => {
    it("should dispatch message event with detail to components", async () => {
      const component = document.createElement("div");
      let receivedDetail: unknown;
      component.addEventListener("message", (e) => {
        receivedDetail = (e as CustomEvent).detail;
      });

      setupMTMock([component]);

      render(ComponentListTestWrapper, {
        props: {
          namespace: "test",
          detail: { key: "value" },
        },
      });

      await waitFor(
        () => {
          expect(receivedDetail).toEqual({ key: "value" });
        },
        { timeout: 1000 },
      );
    });
  });
});
