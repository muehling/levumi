<template>
    <div>
        <b-alert :show="tests.size == 0"  variant='secondary'>
            Aktuell sind keine Tests verfügbar!
        </b-alert>
        <b-card-group deck>
            <b-card class='mt-3'
                    v-for="(area, index) in areas"
                    :key="index"
                    :title="area"
            >
                <b-list-group flush>
                    <b-list-group-item
                            v-for="test in tests_for_area(area)"
                            :key="test.id"
                            :href="'/students/' + student + '/results/new?test_id='+ test.test_info.id + '&student=1'"
                            :disabled="!test.open"
                            :variant="test.open ? 'success' : ''"
                    >
                    {{test.test_info.competence}} - {{test.test_info.family}} - {{test.test_info.level}}
                    </b-list-group-item>
                </b-list-group>
            </b-card>
        </b-card-group>

    </div>
</template>

<script>
    export default {
        data: function () {
            return {
                tests: this.$root.tests,
                student: this.$root.student
            }
        },
        computed: {
            areas() {
                let res = []
                for (let i = 0; i < this.tests.length; ++i)
                    res.push(this.tests[i].test_info.area)
                res = res.filter((v, i, a) => a.indexOf(v) === i)
                return res
            },
        },
        methods: {
            tests_for_area(area) {
                let res = []
                for (let i = 0; i < this.tests.length; ++i)
                    if (this.tests[i].test_info.area == area && !this.tests[i].test_info.student_test)
                        res.push(this.tests[i])
                return res
            }
        },
        name: 'student-view'
    }
</script>

<style scoped>
</style>