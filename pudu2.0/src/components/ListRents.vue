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
                    <v-btn v-on:click="goToGroup" outlined rounded text>
                        Button
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
                const response = await fetch(process.env.VUE_APP_API + `/rents?renteeid=eq.${renteeid}`);
                if (response.ok) {
                    const responseJson = await response.json();
                    responseJson.forEach(e => {
                        console.log( moment(e.rentStart).format("DD MMM YYYY"))
                        this.groups.push({
                            groupid : e.groupid,
                            renteeid : e.renteeid,
                            rentStart : moment(e.rentStart).format("DD MMM YYYY"),
                            rentEnd : moment(e.rentEnd).format("DD MMM YYYY")
                        })
                    });
                }
            },

            goToGroup(){
                //TODO
                alert("go to new group")
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
    position: absolute;
    top : 50%;
    left: 50%;
    transform: translate(-50%,-50%);
    text-align: left;
    
}


</style>