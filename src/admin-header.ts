import { fetchContentTypes } from "./utils/fetch-content-types";
import { svelteMountCreateButton } from "./buttons/create-button";
import { svelteMountSidebar } from "./sidebar/sidebar";
import { svelteMountSearchButton } from "./buttons/search-button";
import { svelteMountSiteListButton } from "./buttons/site-list-button";

(() => {
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
      open: false,
      buttonRef: siteListButtonTarget,
      anchorRef: siteListButtonTarget,
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
            open: false,
            buttonRef: createButtonTarget,
            anchorRef: createButtonTarget,
          },
        });
      }
      // Search button
      if (searchButtonTarget !== null) {
        const searchButtonAnchor =
          searchButtonTarget.getElementsByTagName("a")[0];
        svelteMountSearchButton(searchButtonTarget, {
          blogId: blogId,
          magicToken: magicToken,
          contentTypes: data.contentTypes.filter(
            (contentType) => contentType.can_search === 1,
          ),
          open: false,
          buttonRef: searchButtonTarget,
          anchorRef: searchButtonAnchor,
        });
      }
    });
  }
})();
