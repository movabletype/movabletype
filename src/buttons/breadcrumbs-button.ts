import { Breadcrumb } from "src/@types/breadcrumbs";
import BreadcrumbsButton from "./elements/BreadcrumbsButton.svelte";

type BreadcrumbsProps = {
  breadcrumbs: Breadcrumb[];
  scopeType: string;
  canAccessToSystemDashboard: boolean;
  canCurrentWebsiteLink: boolean;
  currentWebsiteID: string;
  currentWebsiteName: string;
  blogID: string;
  blogName: string;
};

export const svelteMountBreadcrumbsButton = ({
  target,
}: {
  target: Element;
}): void => {
  const dataBreadcrumbs = target.getAttribute("data-breadcrumbs");
  const dataScopeType = target.getAttribute("data-scope-type");
  const dataCanAccessToSystemDashboard = target.getAttribute(
    "data-can-access-to-system-dashboard",
  );
  const dataCanCurrentWebsiteLink = target.getAttribute(
    "data-curr-website-can-link",
  );
  const dataCurrentWebsiteID = target.getAttribute("data-curr-website-id");
  const dataCurrentWebsiteName = target.getAttribute("data-curr-website-name");
  const dataBlogID = target.getAttribute("data-blog-id");
  const dataBlogName = target.getAttribute("data-blog-name");
  const props: BreadcrumbsProps = {
    breadcrumbs: dataBreadcrumbs ? JSON.parse(dataBreadcrumbs) : [],
    scopeType: dataScopeType || "",
    canAccessToSystemDashboard: dataCanAccessToSystemDashboard === "1",
    canCurrentWebsiteLink: dataCanCurrentWebsiteLink === "1",
    currentWebsiteID: dataCurrentWebsiteID || "",
    currentWebsiteName: dataCurrentWebsiteName || "",
    blogID: dataBlogID || "",
    blogName: dataBlogName || "",
  };

  new BreadcrumbsButton({
    target: target,
    props: props,
  });
};
