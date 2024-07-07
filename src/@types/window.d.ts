interface Window {
  CMSScriptURI: string;
  ScriptURI: string;
  StaticURI: string;
  trans: (str: string, ...args: string[]) => string;
}
