<template>
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
                    <v-btn v-on:click= goToGroup(g.groupid) outlined rounded text>
                        View More
                    </v-btn>
                </v-card-actions>
            </v-card>
        </div>
        </div>
    </div>
</template>

<script>
    import jwt from 'jsonwebtoken'
    import Vue from 'vue'
    import Vuetify from 'vuetify'
    import 'vuetify/dist/vuetify.min.css'
    import moment from "moment";

    Vue.use(Vuetify)


    export default {
        data() {
            return {
                groups: [],
                token: localStorage.getItem('access_token') || null,
                renteeid: ''
            }
        },

        methods: {
            getRents: async function () {
                var decoded = await jwt.verify(this.token, process.env.VUE_APP_ACCESS_TOKEN_SECRET);
                const renteeid = decoded.id;
                const response = await fetch(process.env.VUE_APP_API + `/rents?renteeid=eq.${renteeid}&order=groupid.desc`);
                if (response.ok) {
                    const responseJson = await response.json();
                    responseJson.forEach(e => {
                        this.groups.push({
                            groupid : e.groupid,
                            renteeid : e.renteeid,
                            rentStart : moment(e.rentStart).format("DD MMM YYYY"),
                            rentEnd : moment(e.rentEnd).format("DD MMM YYYY")
                        })
                    });
                }
            },

            goToGroup(groupid){
                this.$router.push({name: "Group", params: {groupid : groupid}})
            }
        },

        mounted() {
            this.getRents();
        }
    }

</script>

<style>
body{
    background-repeat: repeat;
}

.listparent{
    position: relative;
    left: calc(-171px + 50%);    
    text-align: left;
}


</style>