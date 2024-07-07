// rollup.config.js
import { glob } from "glob";
import resolve from "@rollup/plugin-node-resolve";
import commonjs from "@rollup/plugin-commonjs";
import esbuild from 'rollup-plugin-esbuild'
import livereload from "rollup-plugin-livereload";
import sveltePreprocess from "svelte-preprocess";
import typescript from '@rollup/plugin-typescript';
import svelte from "rollup-plugin-svelte";
import css from "rollup-plugin-css-only";

const production = !process.env.ROLLUP_WATCH;

export default {
  input: ["src/bootstrap.ts", "src/listing.ts"].concat(glob.sync("src/api/*.ts")),
  output: {
    dir: "mt-static/js/build",
    format: "esm",
    sourcemap: !production
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
    !production && livereload("mt-static/js/build"),
    typescript({ sourceMap: !production })
  ],
};
