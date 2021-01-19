<template>
    <div class="listparent">
        <div class="list" v-for="u in groups" :key="u.renteeid">
            <div>
            <v-card class="mx-auto" max-width="344" outlined>
                <v-list-item three-line>
                    <v-list-item-content>
                        <div class="overline mb-4">
                            Renteeid: {{u.renteeid}}
                        </div>
                        <v-list-item-title class="headline mb-1">
                            Name: {{u.renteename}}
                        </v-list-item-title>
                        <v-list-item-subtitle>
                            Phone: {{u.phone}}
                            <p></p>
                            Email: {{u.email}}
                        </v-list-item-subtitle>

                    </v-list-item-content>

                    <v-list-item-avatar tile size="80" color="grey"></v-list-item-avatar>
                </v-list-item>

                <v-card-actions>
                    <v-btn v-on:click=goToUser(u.renteeid) outlined rounded text>
                        View More
                    </v-btn>
                </v-card-actions>
            </v-card>
        </div>
        </div>
    </div>
</template>

<script>
    import Vue from 'vue'
    import Vuetify from 'vuetify'
    import 'vuetify/dist/vuetify.min.css'

    Vue.use(Vuetify)


    export default {
        data() {
            return {
                groups: [],
            }
        },

        methods: {
            getUsers: async function () {
                const response = await fetch(process.env.VUE_APP_API + `/rentee`);
                if (response.ok) {
                    const responseJson = await response.json();
                    responseJson.forEach(e => {
                        console.log(e);
                        this.groups.push({
                            renteeid : e.renteeid,
                            renteename : e.renteename,
                            phone : e.phone,
                            email : e.email
                        })
                    });
                }
            },

            goToUser(user){
                this.$router.push({name: "User", params: {userid : user}})
            }
        },

        mounted() {
            this.getUsers();
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