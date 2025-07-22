const sessionName = "collapsed";

export const getCollapsedState = (): boolean | null => {
  const value = sessionStorage.getItem(sessionName);
  return value === "true" ? true : value === "false" ? false : null;
};

export const setCollapsedState = (collapsed: boolean): void => {
  sessionStorage.setItem(sessionName, collapsed.toString());
};

export const setGlobalCollapsedDomAttribute = (collapsed: boolean): void => {
  if (collapsed) {
    document.documentElement.classList.add(
      "mt-has-primary-navigation-collapsed",
    );
  } else {
    document.documentElement.classList.remove(
      "mt-has-primary-navigation-collapsed",
    );
  }
};
