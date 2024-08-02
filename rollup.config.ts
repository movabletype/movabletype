// rollup.config.js
import resolve from "@rollup/plugin-node-resolve";
import commonjs from "@rollup/plugin-commonjs";
import esbuild from 'rollup-plugin-esbuild'
import livereload from "rollup-plugin-livereload";
import sveltePreprocess from "svelte-preprocess";
import typescript from '@rollup/plugin-typescript';
import svelte from "rollup-plugin-svelte";
import css from "rollup-plugin-css-only";
import cleaner from "rollup-plugin-cleaner";

const production = !process.env.ROLLUP_WATCH;
const outputDir = "mt-static/js/build";

export default {
  input: ["src/contenttype.ts", "src/listing.ts"],
  output: {
    dir: outputDir,
    format: "esm",
    sourcemap: !production
  },
  plugins: [
    cleaner({ targets: [outputDir] }),
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
    !production && livereload(outputDir),
    typescript({ sourceMap: !production })
  ],
};
