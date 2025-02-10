import BreadcrumbsButton from "./elements/BreadcrumbsButton.svelte";

export const svelteMountBreadcrumbsButton = ({
  target,
}: {
  target: HTMLElement;
}): void => {
  const {
    breadcrumbs,
    canAccessToSystemDashboard,
    currWebsiteCanLink,
    ...rest
  } = target.dataset;

  new BreadcrumbsButton({
    target: target,
    props: {
      breadcrumbs: JSON.parse(breadcrumbs ?? "[]"),
      canAccessToSystemDashboard: canAccessToSystemDashboard === "1",
      canCurrWebsiteLink: currWebsiteCanLink === "1",
      ...rest,
    },
  });
};
