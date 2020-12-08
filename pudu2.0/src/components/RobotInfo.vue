<template>
    <div class="RobotInfo">
        <h1>Robots</h1>
        <div class="displayRobots" v-for="r in robot" :key="r.robotid">
            <strong>
                <div v-if="isAdmin" class="static" v-bind:class="{available: checkAvaialbility(r), inUse: !checkAvaialbility(r)}">
                    <router-link :to="{ name: 'Robot', params: { robotid: r.robotid }}">
                        {{r.robotid}}
                    </router-link>                        
                </div>
                <div v-else class="static" v-bind:class="{available: checkAvaialbility(r), inUse: !checkAvaialbility(r)}">                  
                        {{r.robotid}}                     
                </div>
            </strong>
        </div>
    </div>
</template>

<script>
    export default {
        data() {
            return {
                robot: {},
            }
        },

        methods: {
            getRobots: async function () {
                const response = await fetch(process.env.VUE_APP_API + '/robot');
                if (response.ok) {
                    const responseJson = await response.json();
                    this.robot = responseJson;
                }
            },

            checkAvaialbility: (robot) => {
                return robot.available;
            }
        },

        computed: {
            isAdmin: function() {
                return localStorage.getItem('level') === "true";
            }
        },

        mounted() {
            this.getRobots();
        }
    }
</script>

<style>
    h1 {
        color: #2140AD;
    }

    .RobotInfo {
        height: 60vh;
        padding: 10px;
    }

    .displayRobots {
        padding: 10px;
        align-content: center;
    }

    a {
        text-decoration: none;

    }

    .available a {
        color: green;
    }

    .inUse a {
        color: red;
    }

    .available {
        color: green;
    }

    .inUse {
        color: red;
    }
</style>