module.exports = {
  env: {
    browser: true,
    es6: true,
    jquery: true,
    node: true,
  },
  globals: {
    ButtonAction: true,
    ButtonActions: true,
    Filter: true,
    ListAction: true,
    ListActionClient: true,
    ListActions: true,
    ListObject: true,
    ListStore: true,
    MoreListAction: true,
    MoreListActions: true,
    MT: true,
  },
  parser: "@typescript-eslint/parser",
  parserOptions: {
    project: "tsconfig.json",
    extraFileExtensions: [".svelte"]
  },
  plugins: ["svelte", "@typescript-eslint"],
  overrides: [
    {
      files: ["*.svelte"],
      parser: "svelte-eslint-parser",
      parserOptions: {
        parser: "@typescript-eslint/parser",
      },
    },
    {
      extends: ['plugin:@typescript-eslint/disable-type-checked'],
      files: ['./**/*.js'],
    },
  ],
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/eslint-recommended",
    // "plugin:prettier/recommended", // Cannot be used with eslint-plugin-svelte3.
  ],
  rules: {
    "@typescript-eslint/explicit-function-return-type": [
      "warn",
      {
        allowExpressions: true,
        allowTypedFunctionExpressions: true,
      },
    ],
  },
  settings: {
    "svelte/typescript": true,
  },
};
