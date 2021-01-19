<template>
    <div>
        <Sidebar></Sidebar>
        <div class="adminButtons">
            <button v-on:click="listUsers">List Users</button>
            <button v-on:click="listRobots">List Robots</button>
        </div>
    </div>
</template>

<script>

    import jwt from 'jsonwebtoken'
    import Sidebar from '../components/sidebar.vue'

    export default {

        components: {
            Sidebar
        },

        data() {
            return {

                token: localStorage.getItem('access_token') || null
            }
        },

        methods: {
            isAdmin: function () {
                if (this.token == null) {
                    return false;
                }
                var decoded = jwt.verify(this.token, process.env.VUE_APP_ACCESS_TOKEN_SECRET);
                return decoded.level;
            },

            listRobots() {
                this.$router.push({ name: "Robots" });
            },

            listUsers() {
                this.$router.push({ name: "Users" });
            }
        },

        mounted() {
            if (!this.isAdmin()) {
                this.$router.push({ name: "Account" });
            }

        }

    }
</script>

<style>
    .adminButtons {
        margin: auto;
        width: 10%;
        padding: 10px;
        text-align: center;
    }

    .adminButtons button {
        -moz-box-shadow: inset 0px 1px 0px 0px #2140AD;
        -webkit-box-shadow: inset 0px 1px 0px 0px #2140AD;
        box-shadow: inset 0px 1px 0px 0px #2140AD;
        background-color: #2140AD;
        border: 1px solid #2140AD;
        display: block;
        cursor: pointer;
        color: #FFFFFF;
        font-family: 'Open Sans Condensed', sans-serif;
        font-size: 14px;
        padding: 8px 18px;
        text-decoration: none;
        text-transform: uppercase;
        width: 100%;
    }

    .adminButtons button:hover {
        background: linear-gradient(to bottom, #254ddfc7 5%, #254ddf 100%);
        background-color: #254ddfc7;
    }
</style>