import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import { createVuePlugin } from 'vite-plugin-vue2'
import FullReload from 'vite-plugin-full-reload'


export default defineConfig({
  plugins: [
    RubyPlugin(),
    createVuePlugin(),
    FullReload(['config/routes.rb', 'app/views/**/*'], { delay: 200 })
  ],
  server: {
    host: '0.0.0.0',
    port: 3036,
    hmr: {
      host: '0.0.0.0',
    }
  },
  resolve: {
    alias: {
      '~bootstrap': 'bootstrap',
      'vue': 'vue/dist/vue.esm.js',
    }
  }
})