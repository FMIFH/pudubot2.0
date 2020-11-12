<template>
    <div id ="registerRobot">
        <form class="registerRobot_newRegist" @submit="registerRobot">
            <label for="newRobot"><strong>Register New Robot</strong></label>
            <textarea id="newRobot" cols="20" rows="1" v-model="newRobotId"></textarea>
            <button>Submit</button>
        </form>
    </div>
</template>

<script>
export default {
    name: 'RegisterRobot',
    data(){
        return{
            newRobotId: '',
            api : 'http://microsegur.ddns.net:3006'
        }
    },

    methods : {
        registerRobot : async function() {
            if(this.newRobotId){
                const data = {
                    "robotid" : this.newRobotId
                };

                console.log(data);
                await fetch(this.api+'/robot',
                {
                    headers: {
                        "content-type":"application/json"
                    },
                    body: JSON.stringify(data),
                    method: "POST"
                }).then(data => {return data.json})
                .then(res => {console.log(res)})
                .catch(error => console.log(error));
            }
            
        }
    }
}
</script>

<style>
.registerRobot_newRegist{
    width: 50%;
    text-align: center;
}
form{
    display: flex;
    margin-left: auto;
    margin-right: auto;
    text-align: left;
    flex-direction: column;
}

</style>