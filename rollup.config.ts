// rollup.config.js
import { glob } from "glob";
import resolve from "@rollup/plugin-node-resolve";
import commonjs from "@rollup/plugin-commonjs";
import esbuild from "rollup-plugin-esbuild";
import livereload from "rollup-plugin-livereload";
import sveltePreprocess from "svelte-preprocess";
import typescript from "@rollup/plugin-typescript";
import svelte from "rollup-plugin-svelte";
import css from "rollup-plugin-css-only";
import cleaner from "rollup-plugin-cleaner";

const production = !process.env.ROLLUP_WATCH;
const defaultOutputDir = "mt-static/js/build";

const mtStaticOutputDir = "mt-static";
const mtStaticInputFiles = [
  "src/mt-static/plugins/TinyMCE5/lib/js/tinymce/plugins/mt_protect/plugin.ts",
  "src/mt-static/plugins/TinyMCE6/lib/js/tinymce/plugins/mt_protect/plugin.ts",
];

const defaultConfig = {
  input: ["src/bootstrap.ts", "src/contenttype.ts", "src/listing.ts"].concat(
    glob.sync("src/api/*.ts")
  ),
  output: {
    dir: defaultOutputDir,
    format: "esm",
    sourcemap: !production,
  },
  plugins: [
    cleaner({ targets: [defaultOutputDir] }),
    resolve({
      browser: true,
      dedupe: ["svelte"],
    }),
    commonjs(),
    esbuild({
      sourceMap: true,
      minify: production,
    }),
    css({ output: "bundle.css" }),
    svelte({
      preprocess: sveltePreprocess({ sourceMap: !production }),
      compilerOptions: {
        // enable run-time checks when not in production
        dev: !production,
      },
    }),

    // Watch the `public` directory and refresh the
    // browser on changes when not in production
    !production && livereload(defaultOutputDir),
    typescript({ sourceMap: !production }),
  ],
};

const mtStaticConfig = {
  input: mtStaticInputFiles,
  output: {
    dir: mtStaticOutputDir,
    format: "esm",
    sourcemap: !production,
    entryFileNames: ({ facadeModuleId }) => {
      return facadeModuleId
        .replace(/.*\/src\/mt-static\//, "")
        .replace(/\.ts$/, ".js");
    },
  },
  plugins: [
    resolve({
      browser: true,
    }),
    commonjs(),
    esbuild({
      sourceMap: true,
      minify: production,
    }),

    // Watch the `public` directory and refresh the
    // browser on changes when not in production
    !production && livereload(mtStaticOutputDir),
    typescript({ sourceMap: !production }),
  ],
};

export default [defaultConfig, mtStaticConfig];
