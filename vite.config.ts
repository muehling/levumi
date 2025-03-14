import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'

import vue from '@vitejs/plugin-vue'
import FullReload from 'vite-plugin-full-reload'

import { resolve } from 'path'

import { nodePolyfills } from 'vite-plugin-node-polyfills'

import Components from 'unplugin-vue-components/vite'
import { BootstrapVueNextResolver } from 'bootstrap-vue-next'

export default defineConfig({
  resolve: {
    alias: {
      '~bootstrap': 'bootstrap',
      vue: 'vue/dist/vue.esm-bundler.js',

      src: resolve(__dirname, 'app/frontend'),
    },
  },
  plugins: [
    RubyPlugin(),
    nodePolyfills(),
    FullReload(['app/controllers/*', 'app/models/*', 'app/views/**/*'], { delay: 200 }),
    vue(),
    Components({
      dirs: ['app/frontend'],
      resolvers: [BootstrapVueNextResolver()],
    }),
  ],

  server: {
    host: '0.0.0.0',
    port: 3036,
    allowedHosts: ['vite'],
    hmr: {
      host: '0.0.0.0',
    },
  },
})
