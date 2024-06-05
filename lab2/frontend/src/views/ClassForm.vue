<template>
    <div class="class-form">
        <form @submit.prevent="submitForm">
            <table>
                <tbody>
                    <tr>
                        <td><label for="class_id">班级编号</label></td>
                        <td><input v-model="form.class_id" id="class_id" type="text" required /></td>
                    </tr>
                    <tr>
                        <td><label for="major">学院</label></td>
                        <td><input v-model="form.major" id="major" type="text" required /></td>
                    </tr>
                    <tr>
                        <td><label for="grade">年级</label></td>
                        <td><input v-model="form.grade" id="grade" type="text" required /></td>
                    </tr>
                </tbody>
            </table>
            <div class="button-container">
                <button type="submit">提交</button>
                <button @click="returnClassList">返回</button>
            </div>
        </form>
    </div>
</template>

<script>
import axios from 'axios';
import router from '../router';

export default {
    name: 'ClassForm',
    data() {
        return {
            form: {
                class_id: '',
                major: '',
                grade: ''
            },
        };
    },
    created() {
        if (this.$route.params.classk) {
            try {
                this.classk = JSON.parse(this.$route.params.classk);
                this.form.class_id = this.classk.class_id || '';
                this.form.major = this.classk.major || '';
                this.form.grade = this.classk.grade || '';
            } catch (error) {
                console.error('Error parsing classk:', error);
            }
        } else {
            console.log('No classk found');
            this.classk = {};
        }
    },
    methods: {
        returnClassList() {
            router.push({ name: 'Class' });
        },
        submitForm() {
            const classkId = this.form.class_id;
            console.log('Submitting form:', this.form, classkId)
            if (this.$route.params.classk) {
                axios.put(`http://localhost:3001/api/classes/${classkId}`, this.form)
                    .then(() => {
                        router.push({ name: 'Class' });
                    })
                    .catch(error => {
                        console.error(error);
                    });
            } else {
                axios.post('http://localhost:3001/api/classes', this.form)
                    .then(() => {
                        router.push({ name: 'Class' });
                    })
                    .catch(error => {
                        console.error(error);
                    });
            }
        }
    }
};
</script>

<style scoped>
.class-form {
    margin-left: 250px;
    margin-top: 150px;
    width: 50%;
    padding: 20px;
}

.button-container {
    display: flex;
    justify-content: space-between;
}

table {
    width: 100%;
    border-collapse: collapse;
}

td {
    padding: 10px;
    border: 1px solid #ddd;
}

td:first-child {
    width: 30%;
    text-align: right;
    padding-right: 20px;
}

input,
button {
    margin: 5px 0;
    width: 100%;
    padding: 8px;
    box-sizing: border-box;
}
</style>