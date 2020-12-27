<template>
    <div>
        <Sidebar></Sidebar>
        <div>
            <h1>Olá {{rentee.renteename}}</h1>
        </div>
        <div class = "rent">
            <button v-on:click="rentRobots"> Rent Robots</button>
        </div>
        <div class="bottom">
            <button v-on:click="logOut">Log Out</button>
        </div>
    </div>
</template>

<script>
    import Sidebar from '../components/sidebar.vue'
    import jwt from 'jsonwebtoken'

    export default {

        components: {
            Sidebar
        },

        data() {
            return {
                token: localStorage.getItem('access_token') || null,
                rentee: {}
            }
        },

        methods: {
            loggedIn() {
                try {
                    var decoded = jwt.verify(this.token, process.env.VUE_APP_ACCESS_TOKEN_SECRET);
                    return decoded.id != null
                } catch(err){
                    return false
                }
            },

            logOut() {
                localStorage.removeItem('access_token');
                this.$router.push({ name: "Home" });
            },

            rentRobots(){
                var decoded = jwt.verify(this.token, process.env.VUE_APP_ACCESS_TOKEN_SECRET);
                var userId = decoded.id;
                


                this.$router.push({ name: "Rent", params: { renteeid : userId}});

            },

            async getName() {
                var decoded = jwt.verify(this.token, process.env.VUE_APP_ACCESS_TOKEN_SECRET);
                var userId = decoded.id;
                const response = await fetch(process.env.VUE_APP_API + `/rentee?renteeid=eq.${userId}`);
                if (response.ok) {
                    const responseJson = await response.json();
                    responseJson.forEach(d => {
                        this.rentee = d;
                    });

                }
            }
        },

        mounted() {
            if (!this.loggedIn()) {
                this.$router.push({ name: 'Login' });
            }
            this.getName()
            
        }
    }


</script>

<style>
    h1 {
        color: #2140AD;
    }

    .bottom {
        padding: 0px 30px 30px 30px;
        position: relative;
        text-align: right;
        float: right;
        margin-left: 90%;
        position: absolute;
        bottom: 0px;
    }

    .bottom button {
        -moz-box-shadow: inset 0px 1px 0px 0px #2140AD;
        -webkit-box-shadow: inset 0px 1px 0px 0px #2140AD;
        box-shadow: inset 0px 1px 0px 0px #2140AD;
        background-color: #2140AD;
        border: 1px solid #2140AD;
        display: inline-block;
        cursor: pointer;
        color: #FFFFFF;
        font-family: 'Open Sans Condensed', sans-serif;
        font-size: 14px;
        padding: 8px 18px;
        text-decoration: none;
        text-transform: uppercase;
    }

    .bottom button:hover {
        background: linear-gradient(to bottom, #254ddfc7 5%, #254ddf 100%);
        background-color: #254ddfc7;
    }
</style>