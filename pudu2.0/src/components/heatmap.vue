<template>
    <div>
        <div class="heatmapContainerWrapper" id="heatmapContainerWrapper">
            <div class="heatmapContainer" id="heatmapContainer">
            </div>
        </div>
    </div>
</template>

<script>
    import * as d3 from 'd3';
    import * as h337 from 'heatmap.js';

    export default {

        props: {
            groupid: Number
        },

        methods: {
            async getData() {
                var posData = []
                const data = {
                    "groupi": this.groupid
                };
                const response = await fetch(process.env.VUE_APP_API + '/rpc/grouprobotpositions',
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
                        posData.push({ x: (d.y+3)*70, y: (-d.x +3)*35, value: d.total });
                    });
                }

                return posData;
            },

            $ready(fn) {
                if (process.env.NODE_ENV === 'production') {
                    return this.$nextTick(fn);
                }

                setTimeout(() => {
                    this.$nextTick(fn);
                    console.log("Next Tick")
                }, 1000);
            },

            drawHeat: function () {

                d3.select("#heatmapContainerWrapper")
                    .append("svg")           // append an SVG element to the div
                    .attr("width", 700)
                    .attr("height", 350);
            },
        },

        async mounted() {

            var mydata = await this.getData();
            console.log(mydata);
            var themax = mydata[0].value;
            this.drawHeat();

            this.$ready(() => {
                console.log('doing stuff');
                var heatmap = h337.create({
                    container: document.getElementById('heatmapContainerWrapper') 
                });

                heatmap.setData({
                    max: themax + 1,
                    data: mydata
                });
                
                console.log(heatmap);
            });
        }
    }
</script>

<style>
    .heatmapContainerWrapper {
        margin: 2%;
        background-color: #fff;
    }
</style>