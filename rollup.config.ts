// rollup.config.js
import resolve from "@rollup/plugin-node-resolve";
import commonjs from "@rollup/plugin-commonjs";
import esbuild from "rollup-plugin-esbuild";
import livereload from "rollup-plugin-livereload";
import sveltePreprocess from "svelte-preprocess";
import typescript from "@rollup/plugin-typescript";
import svelte from "rollup-plugin-svelte";
import css from "rollup-plugin-css-only";

const production = !process.env.ROLLUP_WATCH;
const defaultOutputDir = "mt-static/js/build";

const mtStaticOutputDir = "mt-static";
const mtStaticInputFiles = [
  "src/mt-static/plugins/TinyMCE6/lib/js/tinymce/plugins/mt_protect/plugin.ts",
];

const srcConfig = (inputFile) => {
  return {
    input: [inputFile],
    output: {
      dir: defaultOutputDir,
      format: "esm",
      sourcemap: !production,
    },
    plugins: [
      resolve({
        browser: true,
        dedupe: ["svelte"],
      }),
      commonjs(),
      esbuild({
        sourceMap: true,
        minify: production,
      }),
      css({ output: inputFile.replace(/^src\//, "").replace(/ts$/, "css") }),
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
};

const mtStaticConfig = (inputfile) => {
  return {
    input: inputfile,
    output: {
      file: inputfile.replace(/^src\//, "").replace(/ts$/, "js"),
      format: "iife",
      sourcemap: !production,
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
};

export default [
  srcConfig("src/contenttype.ts"),
  srcConfig("src/listing.ts"),
  srcConfig("src/admin-header.ts"),
  srcConfig("src/edit-author.ts"),
  ...mtStaticInputFiles.map(mtStaticConfig),
];
