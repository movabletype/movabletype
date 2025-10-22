export const initWidgets = (): void => {
  document
    .querySelectorAll<HTMLFormElement>(".dashboard-widget-template form")
    .forEach((form) => {
      form.action = window.CMSScriptURI;
    });
};
