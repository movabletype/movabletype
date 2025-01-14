import { fetchContentTypes } from "./utils/fetch-content-types";
import { svelteMountCreateButton } from "./buttons/create-button";
import { svelteMountSidebar } from "./sidebar/sidebar";
import { svelteMountSearchButton } from "./buttons/search-button";
import { svelteMountSiteListButton } from "./buttons/site-list-button";

const getTarget = (selector: string): Element | null => {
  const target = document.querySelector(selector);
  if (!target) {
    return null;
  }
  return target;
};

document.addEventListener("DOMContentLoaded", () => {
  // Sidebar toggle
  const sidebarTarget = document.querySelector(
    '[data-is="primary-navigation-toggle"]'
  );
  if (sidebarTarget !== null) {
    svelteMountSidebar(sidebarTarget);
  }

  const currentScript = document.querySelector(
    '[data-script="admin-header"]'
  ) as HTMLScriptElement;
  const blogId = currentScript.getAttribute("data-blog-id") ?? "";
  const magicToken = currentScript.getAttribute("data-magic-token") ?? "";

  if (magicToken === "") {
    console.error("data-magic-token is not set");
    return;
  }

  const limit = currentScript.getAttribute("data-blog-id") || "50";

  // Site list button
  const siteListButtonTarget = getTarget('[data-is="site-list-button"]');
  if (siteListButtonTarget !== null) {
    svelteMountSiteListButton(siteListButtonTarget, {
      magicToken: magicToken,
      limit: Number.parseInt(limit),
    });
  }

  const createButtonTarget = getTarget('[data-is="create-button"]');
  const searchButtonTarget = getTarget('[data-is="search-button"]');

  if (createButtonTarget !== null || searchButtonTarget !== null) {
    if (blogId === "") {
      console.error("data-blog-id is not set");
      return;
    }

    fetchContentTypes({
      blogId: blogId,
      magicToken: magicToken,
      page: 1,
      limit: Number.parseInt(limit),
    }).then((data) => {
      // Create button
      if (createButtonTarget !== null) {
        svelteMountCreateButton({
          target: createButtonTarget,
          props: { blog_id: blogId, contentTypes: data.contentTypes },
        });
      }
      // Search button
      if (searchButtonTarget !== null) {
        svelteMountSearchButton(searchButtonTarget, {
          blogId: blogId,
          magicToken: magicToken,
          contentTypes: data.contentTypes,
        });
      }
    });
  }
});
