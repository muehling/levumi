/* eslint no-console: 0 */
import Vue from 'vue/dist/vue.esm'

import HomeApp from './home/home-app'
import ClassBookApp from './classbook/classbook-app'

import BootstrapVue from 'bootstrap-vue'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

import Rails from 'rails-ujs'
Rails.start();

Vue.use(BootstrapVue);

document.addEventListener('DOMContentLoaded', () => {
    const element = document.getElementById('levumi');
    const data = JSON.parse(element.getAttribute('data'));
    if (element != null) {
        const backend = new Vue({
            el: '#levumi',
            data: data,
            components: {
                ClassBookApp,
                HomeApp
            }
        });
    }
});
