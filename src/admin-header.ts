import { fetchContentTypes } from "./utils/fetch-content-types";
import { svelteMountCreateButton } from "./buttons/create-button";
import { svelteMountSidebar } from "./sidebar/sidebar";
import { svelteMountSearchButton } from "./buttons/search-button";
import { svelteMountSiteListButton } from "./buttons/site-list-button";
import { svelteMountBreadcrumbsButton } from "./buttons/breadcrumbs-button";

document.addEventListener("DOMContentLoaded", () => {
  // Sidebar toggle
  const sidebarTarget = document.querySelector<HTMLElement>(
    '[data-is="primary-navigation-toggle"]',
  );
  if (sidebarTarget !== null) {
    svelteMountSidebar(sidebarTarget);
  }

  // Breadcrumbs
  const breadcrumbsTarget = document.querySelector<HTMLElement>(
    '[data-is="breadcrumbs"]',
  );
  if (breadcrumbsTarget !== null) {
    svelteMountBreadcrumbsButton({
      target: breadcrumbsTarget,
    });
  }

  const currentScript = document.querySelector<HTMLScriptElement>(
    '[data-script="admin-header"]',
  );
  if (currentScript === null) {
    console.error("data-script='admin-header' is not set");
    return;
  }
  const blogId = currentScript.getAttribute("data-blog-id") ?? "";
  const magicToken = currentScript.getAttribute("data-magic-token") ?? "";

  if (magicToken === "") {
    console.error("data-magic-token is not set");
    return;
  }

  const limit = "50";

  // Site list button
  const siteListButtonTarget = document.querySelector<HTMLElement>(
    '[data-is="site-list-button"]',
  );
  if (siteListButtonTarget !== null) {
    svelteMountSiteListButton(siteListButtonTarget, {
      magicToken: magicToken,
      limit: Number.parseInt(limit),
    });
  }

  const createButtonTarget = document.querySelector<HTMLElement>(
    '[data-is="create-button"]',
  );
  const searchButtonTarget = document.querySelector<HTMLElement>(
    '[data-is="search-button"]',
  );

  if (createButtonTarget !== null || searchButtonTarget !== null) {
    fetchContentTypes({
      blogId: blogId,
      magicToken: magicToken,
    }).then((data) => {
      // Create button
      if (createButtonTarget !== null) {
        svelteMountCreateButton({
          target: createButtonTarget,
          props: {
            blog_id: blogId,
            contentTypes: data.contentTypes.filter(
              (contentType) => contentType.can_create === 1,
            ),
          },
        });
      }
      // Search button
      if (searchButtonTarget !== null) {
        svelteMountSearchButton(searchButtonTarget, {
          blogId: blogId,
          magicToken: magicToken,
          contentTypes: data.contentTypes.filter(
            (contentType) => contentType.can_search === 1,
          ),
        });
      }
    });
  }
});
