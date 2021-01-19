<template>
    <div>
        <Sidebar></Sidebar>
        <div class="head">
            <h1>User {{userId}}</h1>
        </div>
        <div class="listparent">
            <div class="list" v-for="g in groups" :key="g.groupid">
                <div>
                    <v-card class="mx-auto" max-width="344" outlined>
                        <v-list-item three-line>
                            <v-list-item-content>
                                <div class="overline mb-4">
                                    Group: {{g.groupid}}
                                </div>
                                <v-list-item-title class="headline mb-1">
                                    Started: {{g.rentStart}}
                                </v-list-item-title>
                            </v-list-item-content>

                            <v-list-item-avatar tile size="80" color="grey"></v-list-item-avatar>
                        </v-list-item>

                        <v-card-actions>
                            <v-btn v-on:click=goToGroup(g.groupid) outlined rounded text>
                                View More
                            </v-btn>
                        </v-card-actions>
                    </v-card>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import Sidebar from '../components/sidebar.vue'
    import moment from "moment";

    export default {

        components: {
            Sidebar,
        },

        data() {
            return {
                userId: this.$route.params.userid,
                rentee: {},
                groups: []

            }
        },

        methods: {

            async getName() {

                const response = await fetch(process.env.VUE_APP_API + `/rentee?renteeid=eq.${this.userId}`);
                if (response.ok) {
                    const responseJson = await response.json();
                    responseJson.forEach(d => {
                        this.rentee = d;
                    });

                }
            },

            getRents: async function () {
                const response = await fetch(process.env.VUE_APP_API + `/rents?renteeid=eq.${this.userId}&order=groupid.desc`);
                if (response.ok) {
                    const responseJson = await response.json();
                    responseJson.forEach(e => {
                        this.groups.push({
                            groupid: e.groupid,
                            renteeid: e.renteeid,
                            rentStart: moment(e.rentStart).format("DD MMM YYYY"),
                            rentEnd: moment(e.rentEnd).format("DD MMM YYYY")
                        });
                    });
                }
            },


            goToGroup(groupid) {
                this.$router.push({ name: "Group", params: { groupid: groupid } })
            }
        },


        async mounted() {
            await this.getRents();
        }
    }


</script>

<style>
    h1 {
        color: #2140AD;
    }

    body {
        background-repeat: repeat;
    }

    .listparent {
        position: relative;
        left: calc(-171px + 50%);
        text-align: left;
    }
</style>