<template>
    <div v-if="isAdmin" id="registerRobot">
        <form class="registerRobot_newRegist" @submit.prevent="registerRobot">
            <div>
                <label for="newRobot"><h2><strong>Register New Robot</strong></h2></label>
                <textarea id="newRobot" cols="20" rows="1" v-model="newRobotId"></textarea>
            </div>
            
            <button>Submit</button>
        </form>
    </div>
</template>

<script>
    import jwt from 'jsonwebtoken'


    export default {
        name: 'RegisterRobot',
        data() {
            return {
                newRobotId: '',
                token : localStorage.getItem('access_token') || null
            }
        },

        methods: {
            registerRobot: async function () {
                if (this.newRobotId) {
                    const data = {
                        "robotid": this.newRobotId
                    };

                    console.log(data);
                    await fetch(process.env.VUE_APP_API + '/robot',
                        {
                            headers: {
                                "content-type": "application/json"
                            },
                            body: JSON.stringify(data),
                            method: "POST"
                        }).then(data => { return data.json })
                        .then(res => { console.log(res) })
                        .catch(error => console.log(error));
                }
                location.reload();
            }
        },

        computed: {
            isAdmin() {
                if(this.token == null){
                    return false;
                }
                var decoded = jwt.verify(this.token, process.env.VUE_APP_ACCESS_TOKEN_SECRET);
                return decoded.level == true;            }
        }
    }
</script>


<style>
    .registerRobot_newRegist {
        font-family: 'Open Sans Condensed', arial, sans;
        width: 500px;
        padding: 30px;
        background: #FFFFFF;
        margin: 50px auto;
        box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.22);
        -moz-box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.22);
        -webkit-box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.22);

    }

    .registerRobot_newRegist h2 {
        background: #2140AD;
        text-transform: uppercase;
        font-family: 'Open Sans Condensed', sans-serif;
        color: #929292;
        font-size: 18px;
        font-weight: 100;
        padding: 20px;
        margin: -30px -30px 30px -30px;
    }

    .registerRobot_newRegist textarea,
    .registerRobot_newRegist select {
        box-sizing: border-box;
        -webkit-box-sizing: border-box;
        -moz-box-sizing: border-box;
        outline: none;
        display: block;
        width: 100%;
        padding: 7px;
        border: none;
        border-bottom: 1px solid #ddd;
        background: transparent;
        margin-bottom: 10px;
        font: 16px Arial, Helvetica, sans-serif;
        height: 45px;
    }

    .registerRobot_newRegist textarea {
        resize: none;
        overflow: hidden;
    }

    .registerRobot_newRegist button {
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

    .registerRobot_newRegist button:hover {
        background: linear-gradient(to bottom, #254ddfc7 5%, #254ddf 100%);
        background-color: #254ddfc7;
    }
</style>