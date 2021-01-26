<template>
    <div>
        <Sidebar></Sidebar>
        <div class="container2">
            <h1> Group: {{groupid}}</h1>
            <div class="listrobots" v-for="r in robots" :key="r.robot">
                <div>
                    <h4> {{r.robot}} : {{r.distance}} meters and {{r.delivery}} deliveries </h4>
                </div>
            </div>
        </div>
        <div id="terminate" class="bottom1">
            <button v-if="notTerminated()" v-on:click="terminateRent">Terminate Rent</button>
        </div>
        <Graphs :groupid= "parseInt(groupid)"></Graphs>
        <div class="goBack">
            <button v-on:click="goBack">Go Back</button>
        </div>
    </div>
</template>

<script>
    import Sidebar from '../components/sidebar.vue'
    import Graphs from '../components/groupinfo.vue'

    import jwt from 'jsonwebtoken'
    import moment from 'moment'

    export default {

        components: {
            Sidebar,
            Graphs
        },

        data() {
            return {
                groupid: this.$route.params.groupid,
                token: localStorage.getItem('access_token') || null,
                rent: {},
                robots: [],
                totalDistance: 0,
                totalDelivery: 0
            }
        },

        methods: {
            async isOwner() {
                if (this.token == null) {
                    this.$router.push({ name: "Account" });
                }
                const decoded = jwt.verify(this.token, process.env.VUE_APP_ACCESS_TOKEN_SECRET);
                if (decoded.level) {
                    const responseadmin = await fetch(process.env.VUE_APP_API + `/rents?groupid=eq.${this.groupid}`);
                    if (responseadmin.ok) {
                        const responseJsonadmin = await responseadmin.json();

                        responseJsonadmin.forEach(element => {
                            this.rent = element
                        });
                    }
                } else {

                    const userid = decoded.id;
                    const response = await fetch(process.env.VUE_APP_API + `/rents?renteeid=eq.${userid}&groupid=eq.${this.groupid}`);
                    if (response.ok) {
                        const responseJson = await response.json();
                        if (responseJson.length == 0) {
                            this.$router.push({ name: "Account" });
                        } else {
                            responseJson.forEach(element => {
                                this.rent = element
                            });
                        }
                    }
                }
            },

            async getRobots() {
                const response = await fetch(process.env.VUE_APP_API + `/grouprobots?groupid=eq.${this.groupid}`);
                if (response.ok) {
                    const responseJson = await response.json();
                    responseJson.forEach(element => {
                        this.robots.push({ robot: element.robotid, distance: 0, positions: [], delivery: 0 });
                    });
                }
            },

            async asyncForEach(array, callback) {
                for (let index = 0; index < array.length; index++) {
                    await callback(array[index], index, array);
                }
            },

            async getTotalDistance() {
                console.log(this.rent.rentstart)
                var date = moment(this.rent.rentstart).format('YYYYMMDD HH:mm:ss');
                console.log(date)

                if (this.rent.rentend == null) {
                    for await (var e of this.robots) {
                        console.log(e)
                        const response = await fetch(process.env.VUE_APP_API + `/robotposition?robotid=eq.${e.robot}&ts=gte.${date})`);
                        if (response.ok) {
                            const responseJson = await response.json();
                            responseJson.forEach(v => {
                                e.distance += v.distance;
                            });
                        }
                        e.distance = Math.floor(e.distance);
                        this.totalDistance += e.distance;
                    }
                } else {
                    var dateend = moment(this.rent.rentend).format('YYYY-MM-DD HH:mm:ss')
                    console.log(dateend)
                    for (var e2 of this.robots) {
                        const response = await fetch(process.env.VUE_APP_API + `/robotposition?robotid=eq.${e2.robot}&and=(ts.gte.${date},ts.lte.${dateend})`);
                        if (response.ok) {
                            const responseJson = await response.json();
                            responseJson.forEach(v => {
                                e2.distance += v.distance;
                            });
                        }
                        e2.distance = Math.floor(e2.distance);
                        this.totalDistance += e2.distance;
                    }
                }

            },

            async getDeliveries() {
                var date = moment(this.rent.rentstart).format('YYYYMMDD HH:mm:ss');
                if (this.rent.rentend == null) {
                    for await (var e of this.robots) {
                        console.log(e)
                        const response = await fetch(process.env.VUE_APP_API + `/delivery?robotid=eq.${e.robot}&deliverysent=gte.${date})`);
                        if (response.ok) {
                            const responseJson = await response.json();
                            responseJson.forEach(() => {
                                e.delivery++;
                            });
                        }
                        this.totalDelivery += e.delivery;
                    }
                } else {
                    var dateend = moment(this.rent.rentend).format('YYYY-MM-DD HH:mm:ss')
                    for await (var e2 of this.robots) {
                        const response = await fetch(process.env.VUE_APP_API + `/delivery?robotid=eq.${e2.robot}&and=(deliverysent.gte.${date},deliverysent.lte.${dateend})`);
                        if (response.ok) {
                            const responseJson = await response.json();
                            responseJson.forEach(() => {
                                e2.delivery++;
                            });
                        }
                        this.totalDelivery += e2.delivery;
                    }
                }
            },

            async terminateRent() {
                const data = {
                    terminategroup: this.groupid
                }
                const response = await fetch(process.env.VUE_APP_API + '/rpc/terminaterent',
                    {
                        headers: {
                            "content-type": "application/json"
                        },
                        body: JSON.stringify(data),
                        method: "POST"
                    });

                if (response.ok) {
                    const responseJson = await response.json();
                    this.rent.rentend = responseJson;
                }

                document.getElementById("terminate").style.display = 'none';

            },

            notTerminated() {
                return this.rent.rentend == null;
            },

            goBack() {
                this.$router.push({ name: 'Account' });
            }
        },

        async mounted() {
            await this.isOwner();
            await this.getRobots();
            await this.getTotalDistance();
            await this.getDeliveries();
        }
    }
</script>

<style>
    .listrobots {
        padding: 10px 30px 10px 30px;
        text-align: justify;
        margin-left: 20%;
        position: relative;
        display: block;
        align-content: center;
    }


    .bottom1 {
        padding: 0px 30px 30px 30px;
        text-align: right;
        float: right;
        margin-left: 85%;
        position: absolute;
        bottom: 0px;

    }

    .bottom1 button {
        -moz-box-shadow: inset 0px 1px 0px 0px #8b0000;
        -webkit-box-shadow: inset 0px 1px 0px 0px #8b0000;
        box-shadow: inset 0px 1px 0px 0px #8b0000;
        background-color: #8b0000;
        border: 1px solid #8b0000;
        display: inline-block;
        cursor: pointer;
        color: #FFFFFF;
        font-family: 'Open Sans Condensed', sans-serif;
        font-size: 14px;
        padding: 8px 18px;
        text-decoration: none;
        text-transform: uppercase;
    }

    .bottom1 button:hover {
        background: linear-gradient(to bottom, #700000 5%, #700000 100%);
        background-color: #700000;
    }

    .goBack {
        padding: 0px 30px 30px 30px;
        text-align: right;
        float: right;
        margin-left: 90%;
        position: relative;
        bottom: 0px;
    }
</style>