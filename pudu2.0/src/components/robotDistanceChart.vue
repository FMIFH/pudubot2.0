<template>
    <div class="info">
        <h3> Total Distance: {{robotTotalDistance}}</h3>
        <div>
            <button v-on:click='groupByTime("hour")'>DAY</button>
            <button v-on:click='groupByTime("day")'>WEEK</button>
            <button v-on:click='groupByTime("week")'>MONTH</button>
            <button v-on:click='groupByTime("month")'>YEAR</button>
        </div>
        <div class="row mt-5" v-if="robotDistanceArray.length > 0">
            <div class="col">
                <h2 class="text-center">Distance</h2>
                <line-chart :chartData="robotDistanceArray" :options="chartOptions" :chartColors="distanceChartColors"
                    label="Distance"></line-chart>
            </div>
        </div>

    </div>
</template>

<script>
    import LineChart from '../components/LineChart.vue';
    import moment from "moment";

    export default {
        components: {
            LineChart
        },

        props: {
            robotid: String
        },

        data() {
            return {
                robotTotalDistance: 0,
                robotDistanceArray: [],
                displayRobotDistanceArray: [],
                distanceChartColors: {
                    borderColor: "#9BA0B3",
                    pointBorderColor: "#0E1428",
                    pointBackgroundColor: "#AFD6AC",
                    backgroundColor: "#2B52E0",
                    type: "bar",
                    barThickness: 30
                },
                chartOptions: {
                    responsive: true,
                    maintainAspectRatio: false,
                }
            }
        },

        methods: {
            groupByTime: async function (time) {
                this.robotTotalDistance = 0;
                this.robotDistanceArray = [];
                var date = new Date();
                if (time == "day") {
                    date.setDate(date.getDate() - 7);
                } else if (time == "week") {
                    date.setDate(date.getDate() - 30)
                } else if (time == "month") {
                    date.setDate(date.getDate() - 365)
                }

                const data = {
                    "timedis": time,
                    "robot": this.robotid,
                    "begining": date.toDateString()
                };
                const response = await fetch(process.env.VUE_APP_API + '/rpc/distancepertime',
                    {
                        headers: {
                            "content-type": "application/json"
                        },
                        body: JSON.stringify(data),
                        method: "POST"
                    }
                );
                if (response.ok) {
                    const responseJson = await response.json();
                    responseJson.forEach(d => {
                        var date1;
                        if (time == "hour") {
                            date1 = moment(d.ts).format("HH");
                        } else if (time == "day") {
                            date1 = moment(d.ts).format("dddd");
                        } else if (time == "week") {
                            date1 = moment(d.ts).format("Q");
                        } else if (time == "month") {
                            date1 = moment(d.ts).format("MMMM");
                            console.log(date1)
                        }
                        console.log(d.ts);
                        this.robotDistanceArray.push({ date: date1, total: d.distance });
                        this.robotTotalDistance += d.distance;
                    });
                    this.robotTotalDistance = Math.round(this.robotTotalDistance);
                }
            }
        },

        mounted() {
            this.groupByTime("hour");
            var width = window.screen.width - 100;
            document.getElementsByClassName("info")[0].style = "width:" + width + "px !important";
        }

    }
</script>

<style>

    .info h3 {
        text-transform: uppercase;
        font-family: 'Open Sans Condensed', sans-serif;
        color: #929292;
        font-size: 18px;
        font-weight: 100;
        padding: 20px;
        margin: -30px -30px 30px -30px;
    }

    .info button {
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

    .info button:hover {
        background: linear-gradient(to bottom, #254ddfc7 5%, #254ddf 100%);
        background-color: #254ddfc7;
    }

    
</style>