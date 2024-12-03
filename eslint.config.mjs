import svelte from "eslint-plugin-svelte";
import typescriptEslint from "@typescript-eslint/eslint-plugin";
import globals from "globals";
import tsParser from "@typescript-eslint/parser";
import parser from "svelte-eslint-parser";
import path from "node:path";
import { fileURLToPath } from "node:url";
import js from "@eslint/js";
import { FlatCompat } from "@eslint/eslintrc";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const compat = new FlatCompat({
    baseDirectory: __dirname,
    recommendedConfig: js.configs.recommended,
    allConfig: js.configs.all
});

export default [...compat.extends(
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/eslint-recommended",
), {
    plugins: {
        svelte,
        "@typescript-eslint": typescriptEslint,
    },

    languageOptions: {
        globals: {
            ...globals.browser,
            ...globals.jquery,
            ...globals.node,
            JQuery: true,
            MT: true,
            bootstrap: true,
        },

        parser: tsParser,
        ecmaVersion: 5,
        sourceType: "commonjs",

        parserOptions: {
            project: "tsconfig.json",
            extraFileExtensions: [".svelte"],
        },
    },

    settings: {
        "svelte/typescript": true,
    },

    rules: {
        "@typescript-eslint/explicit-function-return-type": ["warn", {
            allowExpressions: true,
            allowTypedFunctionExpressions: true,
        }],

        eqeqeq: "error",
    },
}, {
    files: ["**/*.svelte"],

    languageOptions: {
        parser: parser,
        ecmaVersion: 5,
        sourceType: "script",

        parserOptions: {
            parser: "@typescript-eslint/parser",
        },
    },
}, ...compat.extends("plugin:@typescript-eslint/disable-type-checked").map(config => ({
    ...config,
    files: ["./**/*.js"],
}))];