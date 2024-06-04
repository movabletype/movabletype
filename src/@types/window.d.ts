interface Window {
  CMSScriptURI: string;
  ScriptURI: string;
  StaticURI: string;
  setDirty: (boolean?) => void;
  trans: (str: string, ...args: string[]) => string;
}
