<template>
  <div :class="`mb-4${className ? ` ${className}` : ''}`">
    <div class="mb-1">
      <b-row>
        <b-col md="4">
          <router-link class="info-link" to="/lehrkraefte">
            <b-card class="text-center" body-class="info-card primary rounded shadow">
              <h4 class="card-title font-weight-bold">Für Lehrkräfte</h4>
            </b-card>
          </router-link>
        </b-col>
        <b-col md="4">
          <router-link class="info-link" to="/forschung">
            <b-card class="text-center" body-class="info-card primary rounded shadow">
              <h4 class="card-title font-weight-bold">Für Forschende</h4>
            </b-card>
          </router-link>
        </b-col>
        <b-col md="4">
          <router-link class="info-link" to="/testinventar">
            <b-card class="text-center" body-class="info-card primary rounded shadow">
              <h4 class="card-title font-weight-bold">Testinventar</h4>
            </b-card>
          </router-link>
        </b-col>
      </b-row>
    </div>
  </div>
</template>
<script>
  export default {
    name: 'StartpageNav',
    props: { className: String },
  }
</script>
