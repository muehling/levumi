/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

//Javascript

//Rails-UJS für Links etc.
import Rails from 'rails-ujs'
//Vue und Komponenten
import Vue from 'vue/dist/vue.esm'
import BootstrapVue from 'bootstrap-vue'
import VueApexCharts from 'vue-apexcharts'
//Eigene Vue Komponenten
import HomeApp from './home/home-app'
import ClassBookApp from './classbook/classbook-app'

//Stylesheets

//FontAwesome für Icons
import "@fortawesome/fontawesome-free/css/all.css"
//Bootstrap-Styles
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
//Selbst definierte Styles
import 'css/application.css'

//Vorbereitungscode

Rails.start();
Vue.use(BootstrapVue);
Vue.use(VueApexCharts);
Vue.component('apexchart', VueApexCharts)

//Setup für Vue-SPAs

document.addEventListener('DOMContentLoaded', () => {
    const element = document.getElementById('levumi');
    if (element != null) {
        const data = JSON.parse(element.getAttribute('data'));
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

