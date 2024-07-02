<template>
  <b-container fluid class="tests-app">
    <div v-if="isLoading">
      <div class="spinner">
        <div class="bounce1"></div>
        <div class="bounce2"></div>
        <div class="bounce3"></div>
      </div>
    </div>
    <div v-else>
      <b-row v-cloak class="mt-3">
        <b-col md="12">
          <b-tabs pills lazy>
            <b-tab v-for="area in testData" :key="area.id" :title="area.name">
              <hr />
              <b-tabs pills lazy class="mt-3">
                <b-tab
                  v-for="competence in area.competences"
                  :key="competence.id"
                  :title="competence.name">
                  <b-alert
                    v-if="competence.description"
                    :model-value="true"
                    variant="secondary"
                    class="mt-2">
                    <span class="text-small">{{ competence.description }}</span>
                  </b-alert>
                  <hr />
                  <b-tabs pills lazy class="mt-3">
                    <b-tab
                      v-for="testFamily in competence.test_families"
                      :key="testFamily.id"
                      :title="testFamily.name">
                      <b-alert
                        v-if="testFamily.description"
                        :model-value="true"
                        variant="secondary"
                        class="mt-2">
                        <span class="text-small">{{ testFamily.description }}</span>
                      </b-alert>

                      <b-card no-body class="mt-3">
                        <b-tabs pills lazy card vertical>
                          <b-tab
                            v-for="test in testFamily.tests"
                            :key="test.id"
                            :title="test.level">
                            <div id="info_<%= t.id %>">
                              <div id="info_<%= t.id %>_inner">
                                <div class="container-fluid">
                                  <table
                                    class="table table-sm table-striped table-borderless text-small mt-1">
                                    <tr>
                                      <td>Anzahl an Items</td>
                                      <td>{{ test.items_count }}</td>
                                    </tr>
                                    <tr>
                                      <td>Durchführung</td>
                                      <td>
                                        <span>
                                          {{
                                            test.is_student_test
                                              ? 'Selbstständig durch die Schüler:innen'
                                              : 'Durch die Lehrkraft'
                                          }}
                                        </span>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td>Zeitbeschränkung</td>
                                      <td>{{ test.time_limit }}</td>
                                    </tr>
                                    <tr>
                                      <td>Durchführung</td>
                                      <td>
                                        <p>{{ test.usage }}</p>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td>Items</td>
                                      <td>
                                        <p>
                                          <span v-for="(item, key, i) in test.items" :key="key">
                                            {{
                                              `${item}${
                                                i < parseInt(test.items_count, 10) ? ', ' : ''
                                              }`
                                            }}
                                          </span>
                                        </p>
                                      </td>
                                    </tr>
                                  </table>
                                </div>

                                <div v-if="test.description" class="container-fluid mb-4">
                                  <p class="text-light bg-secondary ps-4">Beschreibung</p>
                                  <div
                                    class="full-description text-small"
                                    v-html="test.description"></div>
                                </div>
                                <div v-if="hasAttachments(test)" class="container-fluid">
                                  <p class="text-light bg-secondary ps-4">Anhänge</p>
                                  <img
                                    v-for="attachment in getAttachedImages(test)"
                                    :key="attachment.filename"
                                    class="attached-image"
                                    :src="attachment.filepath" />
                                </div>
                                <ul>
                                  <li v-for="file in getAttachedOther(test)" :key="file.filename">
                                    <a :href="file.filepath" target="_blank">{{ file.filename }}</a>
                                  </li>
                                </ul>
                              </div>
                            </div>
                          </b-tab>
                        </b-tabs>
                      </b-card>
                    </b-tab>
                  </b-tabs>
                </b-tab>
              </b-tabs>
            </b-tab>
          </b-tabs>
        </b-col>
      </b-row>
    </div>
  </b-container>
</template>

<script>
  import { useTestsStore } from '../../store/testsStore'
  export default {
    name: 'TestsApp',
    setup() {
      const testsStore = useTestsStore()
      return { testsStore }
    },

    computed: {
      testData() {
        console.log('miau', JSON.parse(JSON.stringify(this.testsStore.getTests)))
        return this.testsStore.tests
        //return this.testsStore.getTests
      },
      isLoading() {
        return this.testsStore.isLoading
      },
    },

    async created() {
      await this.testsStore.fetch()
    },
    methods: {
      getAttachedImages(test) {
        return test.info_attachments.filter(attachment =>
          attachment.content_type.startsWith('image')
        )
      },
      getAttachedOther(test) {
        return test.info_attachments.filter(
          attachment => !attachment.content_type.startsWith('image')
        )
      },
      hasAttachments(test) {
        return test.info_attachments.length
      },
    },
  }
</script>

<style>
  .tests-app .attached-image {
    max-width: 100%;
  }
</style>
