<template>
  <div v-if="group.demo && !onlySingleGroupAllowed" :model-value="true" variant="secondary">
    <div class="d-flex flex-row mb-2">
      <b-button v-b-toggle.collapse-1 size="sm" variant="outline-danger" class="me-2">
        Hinweise zur Beispielklasse
      </b-button>
      <demo-group-buttons :group="group" :source="source" />
    </div>
    <b-collapse id="collapse-1">
      <b-card class="mb-4">
        <div class="mt-4">
          <p v-for="(c, i) in content" :key="i" v-html="c"></p>
        </div>
      </b-card>
    </b-collapse>
  </div>
  <div v-else>
    <demo-group-buttons :group="group" :source="source" />
  </div>
</template>
<script setup>
  import DemoGroupButtons from './demo-group-buttons.vue'
  import { computed } from 'vue'

  import { isSingleUser } from 'src/utils/user'

  const { group, source } = defineProps({ group: Object, source: String })

  const content = computed(() => {
    return [
      'Die Beispielklasse dient zum Ausprobieren und Kennenlernen der Funktionen und Abläufe von Levumi. Hier können Sie z. B. Schüler*innen anlegen, ändern und löschen. Messdaten für die Beispiel-Schüler*innen können Sie auf dem Diagnostik-Tab einsehen und anlegen.',
      'Zusätzlich stehen die Funktionen "<b>Demo-Daten anlegen</b>" und "<b>Demo-Daten entfernen</b>" zur Verfügung. Diese erstellen/entfernen einige Schüler*innen im Klassenbuch, sowie einige beispielhafte Messungen in der Diagnostik. Manuell angelegte Schüler*innen und Testdaten werden dabei nicht entfernt.',
      'Die Beispielklasse ist nicht für den regelmäßigen Einsatz im Unterricht gedacht. Bitte legen Sie eine neue Klasse an, um eigene Messungen durchzuführen.',
      '<b>Daten aus Beispielklassen können nicht exportiert werden!</b>',
    ]
  })

  const onlySingleGroupAllowed = computed(() => isSingleUser())
</script>
