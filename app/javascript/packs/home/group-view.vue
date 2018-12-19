<template>
    <b-card class="mt-3">

        <template slot="header">

            <b-nav pills>

                <b-nav-item v-for="area in group_info.areas"
                            v-if="area.used"
                            :key="area.info.id"
                            :active="area.info.id == area_selected"
                            @click="area_selected = area.info.id"
                >
                    {{area.info.name}}
                </b-nav-item>

                <b-nav-item-dropdown
                        v-if="areasLeft()"
                        text="<em>Neuer Lernbereich</em>"
                        right
                        @click="area_selected = -1"
                >

                    <b-dropdown-item
                            v-for="area in group_info.areas"
                            v-if="!area.used"
                            :key="area.info.id"
                            @click="area.used = true"
                    >
                        {{area.info.name}}
                    </b-dropdown-item>

                </b-nav-item-dropdown>

            </b-nav>

        </template>

        <b-nav pills>

            <b-nav-item v-for="test in group_info.tests"
                        :key="test.info.id"
                        v-if="test.used && test.info.area_id == area_selected"
            >
                {{test.info.name}} - {{test.info.level}}
            </b-nav-item>

            <b-nav-item  v-if="testsLeft(area_selected)">
                <em>Neuen Test verwenden</em>
            </b-nav-item>

        </b-nav>

        Assessment Info
    </b-card>

</template>

<script>
    export default {
        props: {
            group: Object,
            group_info: Object
        },
        data: function () {
            return {
                area_selected: 0,
                assessments: [{id: 1, test: 'Test 1', area: 1}, {id: 2, test: 'Test 2', area: 1}, {id:3, test: 'Test 3', area: 2}] //Dummy Data
            }
        },
        methods: {
            areasLeft() {
                for (let i = 0; i < this.group_info.areas.length; ++i)
                    if (!this.group_info.areas[i].used)
                        return true;
                return false;
            },
            testsLeft(area) {
                for (let i = 0; i < this.group_info.tests.length; ++i)
                    if (!this.group_info.tests[i].used && this.group_info.tests[i].info.area_id == area)
                        return true;
                return false;
            }
        },
        name: "group-view"
    }
</script>
