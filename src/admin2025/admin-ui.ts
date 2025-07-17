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

if (createButtonTargets.length > 0 && magicToken !== "") {
  createButtonTargets.forEach((createButtonTarget) => {
    svelteMountCreateButton({
      target: createButtonTarget,
      props: {
        blog_id: blogId,
        magicToken: magicToken,
        open: false,
        anchorRef: createButtonTarget,
        containerRef: modalContainerTarget,
      },
    });
  });
}

if (searchButtonTarget !== null && magicToken !== "") {
  svelteMountSearchButton(searchButtonTarget, {
    blogId: blogId,
    magicToken: magicToken,
    open: false,
    anchorRef: searchButtonTarget,
  });
}

const searchFormTarget = document.querySelector<HTMLElement>(
  '[data-is="search-form"]',
);
if (searchFormTarget !== null && magicToken !== "") {
  svelteMountSearchForm(searchFormTarget, {
    blogId: blogId,
    magicToken: magicToken,
  });
}
