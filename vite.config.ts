import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'

import vue from '@vitejs/plugin-vue'
import FullReload from 'vite-plugin-full-reload'

import { resolve } from 'path'

import { nodePolyfills } from 'vite-plugin-node-polyfills'

import Components from 'unplugin-vue-components/vite'
import { BootstrapVueNextResolver } from 'unplugin-vue-components/resolvers'

//import commonjsExternals from 'vite-plugin-commonjs-externals'
//import { builtinModules } from 'module'

//export default defineConfig({
//  optimizeDeps: {
//    exclude: builtinModules,
//  },
//  plugins: [
//    RubyPlugin(),
//    vue(),
//    FullReload(['config/routes.rb', 'app/views/**/*'], { delay: 200 }),
//    commonjsExternals({
//      externals: builtinModules,
//    }),
//  ],
//  server: {
//    host: '0.0.0.0',
//    port: 3036,
//    hmr: {
//      host: '0.0.0.0',
//    },
//  },
//  resolve: {
//    alias: {
//      '~bootstrap': 'bootstrap',
//      vue: 'vue/dist/vue.esm.js',
//      src: resolve(__dirname, 'app/frontend'),
//    },
//  },
//})
export default defineConfig({
  define: {
    __VUE_PROD_HYDRATION_MISMATCH_DETAILS__: 'true',
    __VUE_OPTIONS_API__: 'true',
    __VUE_PROD_DEVTOOLS__: 'true',
  },
  resolve: {
    alias: {
      '~bootstrap': 'bootstrap',
      //vue: 'vue/dist/vue.esm-bundler.js',

      vue: '@vue/compat',
      src: resolve(__dirname, 'app/frontend'),
    },
  },
  plugins: [
    RubyPlugin(),
    nodePolyfills(),

    vue({
      template: {
        compilerOptions: {
          compatConfig: {
            MODE: 2,
          },
        },
      },
    }),
    Components({
      dirs: ['app/frontend'],
      resolvers: [BootstrapVueNextResolver()],
    }),
  ],

  server: {
    host: '0.0.0.0',
    port: 3036,
    hmr: {
      host: '0.0.0.0',
    },
  },
})
