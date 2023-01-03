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
          <b-tabs pills>
            <!--% Area.order(:name).all.each do |a| %-->
            <!-- Oberste Ebene Lernbereiche -->
            <b-tab v-for="area in testData" :key="area.id">
              <template slot="title">
                {{ area.name }}
              </template>
              <b-tabs pills class="mt-3">
                <!-- Hinweistext falls keine Tests vorhanden -->
                <div slot="empty">
                  <div class="text-center text-muted">Keine Kompetenzbereiche vorhanden.</div>
                </div>

                <!--% a.competences.order(:name).each do |c| %-->
                <!-- Zweite Ebene Kompetenzen -->
                <b-tab v-for="competence in area.competences" :key="competence.id">
                  <template slot="title">
                    {{ competence.name }}
                  </template>

                  <b-alert show variant="secondary" class="mt-2">
                    <span class="text-small">{{ competence.description }}</span>
                  </b-alert>

                  <b-tabs pills class="mt-3">
                    <!-- Hinweistext falls keine Tests vorhanden -->
                    <div slot="empty">
                      <div class="text-center text-muted">Keine Tests vorhanden.</div>
                    </div>

                    <!--% c.test_families.order(:name).each do |f| %-->
                    <!-- Dritte Ebene Tests -->
                    <b-tab v-for="testFamily in competence.test_families" :key="testFamily.id">
                      <template slot="title">
                        {{ testFamily.name }}
                      </template>

                      <b-alert show variant="secondary" class="mt-2">
                        <span class="text-small">{{ testFamily.description }}</span>
                      </b-alert>

                      <b-card no-body class="mt-3">
                        <b-tabs pills card vertical>
                          <!--% f.tests.where(archive: false).order(:level).all.each do |t|  %-->
                          <!-- Vierte Ebene Niveaustufen -->
                          <b-tab
                            v-for="test in testFamily.tests"
                            :key="test.id"
                            :title="test.level"
                          >
                            <!-- Testinfo rendern -->
                            <div id="info_<%= t.id %>">
                              <div id="info_<%= t.id %>_inner">
                                <div class="container-fluid">
                                  <table
                                    class="table table-sm table-striped table-borderless text-small mt-1"
                                  >
                                    <tr>
                                      <td>Anzahl an Items</td>
                                      <td>{{ test.items_count }}</td>
                                    </tr>
                                    <tr>
                                      <td>Durchführung</td>
                                      <td>
                                        <span>{{
                                          test.is_student_test
                                            ? 'Selbstständig durch die Schüler:innen'
                                            : 'Durch die Lehrkraft'
                                        }}</span>
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
                                          <span v-for="(item, key, i) in test.items" :key="key"
                                            >{{
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
                                  <p class="text-light bg-secondary pl-4">Beschreibung</p>
                                  <div
                                    class="full-description text-small"
                                    v-html="test.description"
                                  ></div>
                                </div>
                                <div v-if="hasAttachments(test)" class="container-fluid">
                                  <p class="text-light bg-secondary pl-4">Anhänge</p>
                                  <img
                                    v-for="attachment in getAttachedImages(test)"
                                    :key="attachment.filename"
                                    class="attached-image"
                                    :src="attachment.filepath"
                                  />
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
        return this.testsStore.tests
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
