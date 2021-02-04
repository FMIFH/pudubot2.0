<template>
    <div>
        <div class="heatmapContainerWrapper" id="heatmapContainerWrapper" v-on:click="changeHeatMap">

            <img src="" id="plant">
            <div class="heatmapContainer" id="heatmapContainer">
            </div>
        </div>
        <input type="file" @change="setplant">
        <p></p>
        <input type="checkbox" id="checkbox" v-model="checked">
        <label for="checkbox">Set Origin</label>
        <input type="checkbox" id="checkbox2" v-model="checkedScale">
        <label for="checkbox2">Change Scale</label>
        <p></p>
        <div class="transformations">
            <button v-on:click="rotate">Rotate 90º</button>
            <button v-on:click="reflect(0)">Reflect X</button>
            <button v-on:click="reflect(1)">Reflect Y</button>
            <p></p>
            <button v-on:click="reset">Reset</button>
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

        data() {
            return {
                files: [],
                posData: [],
                drawArray: [],
                heatmap: null,
                checked: false,
                checkedScale: false,
                origin: { x: 0, y: 0 },
                scale: 1,
                angle: 0,
                reflectionX: 1,
                reflectionY: 1
            }
        },

        methods: {
            async getData() {
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
                        this.posData.push({ x: d.x, y: d.y, value: d.total });
                    });
                }

            },

            $ready(fn) {
                if (process.env.NODE_ENV === 'production') {
                    return this.$nextTick(fn);
                }

                setTimeout(() => {
                    this.$nextTick(fn);
                }, 1000);
            },

            drawHeat: function () {

                d3.select("#heatmapContainerWrapper")
                    .append("svg")           // append an SVG element to the div
                    .attr("width", 700)
                    .attr("height", 500);
            },

            async setplant(event) {
                var background = document.getElementById("plant");
                var file = event.target.files[0];
                console.log(process.env.VUE_APP_BLUEPRINTAPI)
                await fetch(process.env.VUE_APP_BLUEPRINTAPI + `/blueprint/${this.groupid}`,
                    {
                        headers: {
                            "content-type": "image/png"
                        },
                        body: file,
                        method: "POST"
                    }
                );
                background.src = URL.createObjectURL(process.env.VUE_APP_BLUEPRINTAPI + `/blueprint/${this.groupid}`);
            },

            changePosition(e) {
                if (this.checked) {
                    var div = document.getElementById("heatmapContainerWrapper")

                    var desx = e.pageX - div.offsetLeft;
                    var desy = e.pageY - div.offsetTop;
                    this.origin = { x: desx, y: desy };
                    this.drawHeatMap();
                    this.checked = false;
                }
            },

            changeScale(e) {
                if (this.checkedScale) {
                    var div = document.getElementById("heatmapContainerWrapper")
                    var disx = e.pageX - div.offsetLeft;
                    var disy = e.pageY - div.offsetTop;
                    var xdif = disx - this.origin.x;
                    var ydif = disy - this.origin.y
                    this.scale = Math.sqrt(xdif * xdif + ydif * ydif).toFixed(0);
                    this.drawHeatMap();
                    this.checkedScale = false;
                }
            },

            rotate() {
                this.angle += Math.PI / 2;
                this.drawHeatMap();
            },

            reflect(dir) {
                if (dir == 0) {
                    this.reflectionX = this.reflectionX * -1;
                } else {
                    this.reflectionY = this.reflectionY * -1;
                }
                this.drawHeatMap();
            },

            reset() {
                this.origin = { x: 0, y: 0 };
                this.scale = 1;
                this.angle = 0;
                this.reflectionX = 1;
                this.reflectiony = 1;
                this.drawHeatMap();
            },

            drawHeatMap() {
                this.drawArray = [];
                var x1 = Math.cos(this.angle);
                var x2 = Math.sin(this.angle);
                this.posData.forEach(pos => {
                    var newX = (pos.x * x1 + pos.y * x2) * this.reflectionX * this.scale + this.origin.x;
                    var newY = (pos.x * x2 + pos.y * x1) * this.reflectionY * this.scale + this.origin.y;
                    this.drawArray.push({
                        x: newX,
                        y: newY,
                        value: pos.value
                    });

                });
                var themax = this.drawArray[0].value;
                this.heatmap.setData({
                    max: themax + 1,
                    data: this.drawArray
                });
            },

            changeHeatMap(e) {
                if (this.checked && this.checkedScale) {
                    alert("You may only set one at the time");
                    this.checked = false;
                    this.checkedScale = false;
                }
                this.changeScale(e);
                this.changePosition(e);
            },

            movecorner() {
                console.log("oi");
            },

        },

        async mounted() {
            await this.getData();

            this.drawHeat();


            this.heatmap = h337.create({
                container: document.getElementById('heatmapContainerWrapper'),
                radius: 10,
            });
            this.drawHeatMap();
        }
    }


</script>

<style>
    .heatmapContainerWrapper {
        margin: 2%;
        background-color: #fff;
    }

    .transformations button {
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

    .transformations button:hover {
        background: linear-gradient(to bottom, #254ddfc7 5%, #254ddf 100%);
        background-color: #254ddfc7;
    }


    .dot {
        height: 25px;
        width: 25px;
        background-color: rgb(0, 26, 255);
        border-radius: 50%;
        display: inline-block;
        z-index: 999;
    }
</style>