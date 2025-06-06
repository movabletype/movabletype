import { fetchContentTypes } from "src/utils/fetch-content-types";
import { svelteMountCreateButton } from "./buttons/create-button";
import { svelteMountSidebar } from "./sidebar/sidebar";
import { svelteMountSearchButton } from "./buttons/search-button";
import { svelteMountSiteListButton } from "./buttons/site-list-button";
import { svelteMountSearchForm } from "./forms/search/search-form";

// Sidebar toggle
const sidebarTarget = document.querySelector<HTMLButtonElement>(
  '[data-is="primary-navigation-toggle"]',
);
if (sidebarTarget !== null) {
  const sessionName = "collapsed";
  const sessionCollapsed = sessionStorage.getItem(sessionName);

  svelteMountSidebar(sidebarTarget, {
    collapsed: sessionCollapsed === "true",
    buttonRef: sidebarTarget.getElementsByTagName("button")[0],
    sessionName: sessionName,
    isStored: sessionCollapsed !== null,
  });
}

const currentScript = document.querySelector<HTMLScriptElement>(
  '[data-script="admin-ui"]',
);
if (currentScript === null) {
  console.error("data-script='admin-ui' is not set");
}
const blogId = currentScript?.getAttribute("data-blog-id") ?? "";
const magicToken = currentScript?.getAttribute("data-magic-token") ?? "";

if (magicToken === "") {
  console.error("data-magic-token is not set");
}

const limit = "50";

// Site list button
const siteListButtonTargets = document.querySelectorAll<HTMLElement>(
  '[data-is="site-list-button"]',
);
if (siteListButtonTargets.length > 0 && magicToken !== "") {
  siteListButtonTargets.forEach((siteListButtonTarget) => {
    svelteMountSiteListButton(siteListButtonTarget, {
      magicToken: magicToken,
      limit: Number.parseInt(limit),
      open: false,
      anchorRef: siteListButtonTarget,
      initialStarredSites:
        siteListButtonTarget.dataset.starredSites
          ?.split(",")
          .map(Number)
          .filter(Number.isInteger) || [],
    });
  });
}

const createButtonTargets = document.querySelectorAll<HTMLElement>(
  '[data-is="create-button"]',
);
const searchButtonTarget = document.querySelector<HTMLElement>(
  '[data-is="search-button"]',
);
const modalContainerTarget =
  document.querySelector<HTMLElement>("div.mt-modal");

if (
  (createButtonTargets.length > 0 || searchButtonTarget !== null) &&
  magicToken !== ""
) {
  fetchContentTypes({
    blogId: blogId,
    magicToken: magicToken,
  }).then((data) => {
    // Create button
    if (createButtonTargets.length > 0) {
      createButtonTargets.forEach((createButtonTarget) => {
        svelteMountCreateButton({
          target: createButtonTarget,
          props: {
            blog_id: blogId,
            contentTypes: data.contentTypes.filter(
              (contentType) => contentType.can_create === 1,
            ),
            open: false,
            anchorRef: createButtonTarget,
            containerRef: modalContainerTarget,
          },
        });
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
        open: false,
        anchorRef: searchButtonTarget,
      });
    }
    // Search Form
    const searchFormTarget = document.querySelector<HTMLElement>(
      '[data-is="search-form"]',
    );
    if (searchFormTarget !== null) {
      svelteMountSearchForm(searchFormTarget, {
        blogId: blogId,
        magicToken: magicToken,
        contentTypes: data.contentTypes.filter(
          (contentType) => contentType.can_search === 1,
        ),
      });
    }
  });
}
