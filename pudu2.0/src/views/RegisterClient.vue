<template>
    <div>
        <label for="newUser"><strong>Register New User</strong></label>
        <form class="registerUser_newRegist" @submit="registerUser">
            <label for="newUser_name">Name</label>
            <textarea id="newUser" cols="20" rows="1" v-model="newUserName"></textarea>
            <label for="newUser_phone">Phone</label>
            <textarea id="newUser" cols="20" rows="1" v-model="newUserPhone"></textarea>
            <label for="newUser_email">Email</label>
            <textarea id="newUser" cols="20" rows="1" v-model="newUserEmail"></textarea>
            <label for="newUser_password">Password</label>
            <textarea id="newUser" cols="20" rows="1" v-model="newUserPassword"></textarea>
            <button>Submit</button>
        </form>
    </div>
</template>

<script>
    import bcrypt from 'bcryptjs'

    export default {
        name: 'Home',
        components: {
        },

        data() {
            return {
                newUserName: '',
                newUserPhone: '',
                newUserEmail: '',
                newUserPassword: '',
                api: 'http://microsegur.ddns.net:3006'
            }
        },

        methods: {
            registerUser: async function () {
                var hashed = bcrypt.hashSync(this.newUserPassword, 10);
                const data = {
                    "renteename": this.newUserName,
                    "phone": this.newUserPhone,
                    "email": this.newUserEmail,
                    "password": hashed
                };
                await fetch(this.api+'/rentee',
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
</script>

<style>

</style>