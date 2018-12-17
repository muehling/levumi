/* eslint no-console: 0 */
import Vue from 'vue/dist/vue.esm'
import GroupCard from './backend/group-card.vue'
import GroupDisplay from './backend/group-display.vue'
import GroupForm from './backend/group-form.vue'

import BootstrapVue from 'bootstrap-vue'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

import Rails from 'rails-ujs'
Rails.start()

Vue.use(BootstrapVue);

document.addEventListener('DOMContentLoaded', () => {
    const element = document.getElementById('levumi');
    const data = JSON.parse(element.getAttribute('data'));
    if (element != null) {
        const backend = new Vue({
            el: '#levumi',
            data: data,
            components: {
                GroupCard, GroupDisplay, GroupForm
            }
        });
    }
});
