<template>
    <div>
        <div>
            <h3> Total Distance: {{robotTotalDistance}}</h3>
        </div>
        <div class="info">
            <div>
                <button v-on:click='groupByTime("hour")'>DAY</button>
                <button v-on:click='groupByTime("day")'>WEEK</button>
                <button v-on:click='groupByTime("week")'>MONTH</button>
                <button v-on:click='groupByTime("month")'>YEAR</button>
            </div>
            <div class="row mt-5" v-if="robotDistanceArray.length > 0">
                <div class="col">
                    <h2 class="text-center">Distance</h2>
                    <line-chart :chartData="robotDistanceArray" :chartDataLabels='chartLabels' :options="chartOptions"
                        :chartColors="distanceChartColors" label="Distance"></line-chart>
                </div>
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
                chartLabels: [],
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
                    scales: {
                        yAxes: [{
                            ticks: {
                                suggestedMin: 0
                            }
                        }]
                    }
                }
            }
        },

        methods: {
            groupByTime: async function (time) {
                this.robotDistanceArray = [];
                var week = 0
                var date = new Date();
                var diff = 0;
                if (time == "day") {

                    var day = date.getDay();
                    console.log(day)
                    diff = date.getDate() - day;
                    date = new Date(date.setDate(diff));

                } else if (time == "week") {
                    time = "day"
                    week = 1;
                    diff = 1
                    date = new Date(date.setDate(diff));
                    console.log(date)
                } else if (time == "month") {
                    console.log(date.getFullYear())
                    date = new Date(new Date().getFullYear(), 0, 1);
                    console.log(date)
                }
                const data = {
                    "timedis": time,
                    "robot": this.robotid,
                    "begining": date.toDateString(),
                    "enddate": moment().format("YYYY-MM-DD HH:mm:ss")
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
                    this.generateGraph(responseJson, time, week);
                }
            },

            generateGraph(responseJson, time, week) {
                if (time == "hour") {
                    this.chartLabels = Array.from(Array(24).keys())
                } else if (time == "day") {
                    if (week == 1) {
                        this.chartLabels = Array.from(Array(31).keys())
                    } else {
                        this.chartLabels = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

                    }
                } else if (time == "week") {
                    this.chartLabels = Array.from(Array(4).keys())

                } else if (time == "month") {
                    this.chartLabels = [
                        'January',
                        'February',
                        'March',
                        'April',
                        'May',
                        'June',
                        'July',
                        'August',
                        'September',
                        'October',
                        'November',
                        'December'
                    ];
                }
                this.robotDistanceArray = new Array(this.chartLabels.length).fill(0);
                responseJson.forEach(d => {
                    var date1;
                    if (time == "hour") {
                        date1 = moment(d.ts).format("HH");
                    } else if (time == "day") {
                        if (week == 1) {
                            date1 = moment(d.ts).format("DD");
                        } else {
                            date1 = moment(d.ts).format("dddd");
                        }
                    } else if (time == "week") {
                        date1 = moment(d.ts).format("Q");
                    } else if (time == "month") {
                        date1 = moment(d.ts).format("M") - 1;
                    }
                    this.robotDistanceArray[date1] = d.distance;
                });
            },

            async totalDistance() {
                const response = await fetch(process.env.VUE_APP_API + `/robotposition?robotid=eq.${this.robotid}`);
                if (response.ok) {
                    const responseJson = await response.json();
                    responseJson.forEach(d => {
                        this.robotTotalDistance += d.distance;
                    });
                }
                this.robotTotalDistance = Math.round(this.robotTotalDistance);

            }
        },

        mounted() {
            this.groupByTime("hour");
            this.totalDistance();

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
        background-color: #264edfc7;
    }
</style>