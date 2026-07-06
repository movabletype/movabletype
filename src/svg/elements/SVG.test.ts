import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import SVG from "./SVG.svelte";

describe("SVG Component", () => {
  it("should render SVG element with class and role", () => {
    const { container } = render(SVG, {
      props: {
        class: "mt-icon mt-icon--sm",
        href: "/mt-static/images/admin2025/sprite.svg#ic_search",
        title: "Search",
      },
    });

    const svg = container.querySelector("svg");
    expect(svg).toBeVisible();
    expect(svg).toHaveAttribute("class", "mt-icon mt-icon--sm");
    expect(svg).toHaveAttribute("role", "img");
  });

  it("should render title element when title is set", () => {
    const { container } = render(SVG, {
      props: {
        class: "mt-icon",
        href: "/mt-static/images/admin2025/sprite.svg#ic_search",
        title: "Search",
      },
    });

    const title = container.querySelector("title");
    expect(title).toBeInTheDocument();
    expect(title?.textContent).toBe("Search");
  });

  it("should not render title element when title is empty", () => {
    const { container } = render(SVG, {
      props: {
        class: "mt-icon",
        href: "/mt-static/images/admin2025/sprite.svg#ic_search",
        title: "",
      },
    });

    const title = container.querySelector("title");
    expect(title).toBeNull();
  });

  it("should apply style attribute when style is set", () => {
    const { container } = render(SVG, {
      props: {
        class: "mt-icon",
        href: "/mt-static/images/admin2025/sprite.svg#ic_search",
        title: "Search",
        style: "width: 32px; height: 32px;",
      },
    });

    const svg = container.querySelector("svg");
    expect(svg).toHaveAttribute("style", "width: 32px; height: 32px;");
  });

  it("should render use element with xlink:href", () => {
    const { container } = render(SVG, {
      props: {
        class: "mt-icon",
        href: "/mt-static/images/admin2025/sprite.svg#ic_search",
        title: "Search",
      },
    });

    const use = container.querySelector("use");
    expect(use).toBeInTheDocument();
    expect(use?.getAttributeNS("http://www.w3.org/1999/xlink", "href")).toBe(
      "/mt-static/images/admin2025/sprite.svg#ic_search",
    );
  });

  it("should not apply style attribute when style is not set", () => {
    const { container } = render(SVG, {
      props: {
        class: "mt-icon",
        href: "/mt-static/images/admin2025/sprite.svg#ic_search",
        title: "Search",
      },
    });

    const svg = container.querySelector("svg");
    expect(svg).not.toHaveAttribute("style");
  });
});
