<template>
    <div>
        <b-alert :show="tests.size == 0"  variant='secondary'>
            Aktuell sind keine Tests verfügbar!
        </b-alert>
        <b-card-group deck>
            <b-card class='mt-3'
                    v-for="test in tests"
                    v-if="!test.test_info.student_test"
                    :key="test.id"
                    :title="test.test_info.family"
                    :sub-title="test.test_info.level"
            >
                <template slot='header'>
                    <h4>{{test.test_info.competence}}</h4>
                    <h6>{{test.test_info.area}}</h6>
                </template>
                <b-button block variant='primary'
                          :href="'/students/' + student + '/results?test_id='+ test.test_info.id + '&student=1'"
                          data-method='post'
                          :disabled="!test.open"
                          :variant="test.open ? 'outline-success' : 'success'"
                >
                    {{test.open ? 'Test starten' : 'Diese Woche bereits gestestet'}}
                </b-button>
            </b-card>
        </b-card-group>

    </div>
</template>

<script>
    export default {
        name: "student-view",
        data: function () {
            return {
                tests: this.$root.tests,
                student: this.$root.student
            }
        },
    }
</script>

<style scoped>
</style>