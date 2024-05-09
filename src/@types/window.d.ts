interface Window {
  CMSScriptURI: string;
  StaticURI: string;
  trans: (str: string, ...args: string[]) => string;
}
