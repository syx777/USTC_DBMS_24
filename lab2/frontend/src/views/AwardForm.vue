<template>
    <div class="award-form">
        <form @submit.prevent="submitForm">
            <table>
                <tbody>
                    <tr>
                        <td><label for="record_id">记录编号</label></td>
                        <td><input v-model="form.record_id" id="record_id" type="text" required /></td>
                    </tr>
                    <tr>
                        <td><label for="student_id">学生编号</label></td>
                        <td><input v-model="form.student_id" id="student_id" type="text" required /></td>
                    </tr>
                    <tr>
                        <td><label for="type">类型</label></td>
                        <td><input v-model="form.type" id="type" type="text" required /></td>
                    </tr>
                    <tr>
                        <td><label for="description">描述</label></td>
                        <td><input v-model="form.description" id="description" type="text" required /></td>
                    </tr>
                </tbody>
            </table>
            <div class="button-container">
                <button type="submit">提交</button>
                <button @click="returnAwardList">返回</button>
            </div>
        </form>
        <error-notification v-if="errorMessage" :message="errorMessage" @close="errorMessage = ''" />
    </div>
</template>

<script>
import axios from 'axios';
import router from '../router';
import ErrorNotification from '../components/Error.vue';

export default {
    name: 'AwardForm',
    components: {
        ErrorNotification
    },
    data() {
        return {
            form: {
                record_id: '',
                student_id: '',
                type: '',
                description: ''
            },
        };
    },
    created() {
        if (this.$route.params.award) {
            try {
                this.award = JSON.parse(this.$route.params.award);
                this.form.record_id = this.award.record_id || '';
                this.form.student_id = this.award.student_id || '';
                this.form.type = this.award.type || '';
                this.form.description = this.award.description || '';
            } catch (error) {
                this.handleError('Error parsing award:', error);
            }
        } else {
            console.log('No award found');
            this.award = {};
        }
    },
    methods: {
        returnAwardList() {
            router.push({ name: 'Award' });
        },
        submitForm() {
            const awardId = this.form.record_id;
            console.log('Submitting form:', this.form, awardId)
            if (this.$route.params.award) {
                axios.put(`http://localhost:3001/api/awards/${awardId}`, this.form)
                    .then(() => {
                        router.push({ name: 'Award' });
                    })
                    .catch(error => {
                        this.handleError(error);
                    });
            } else {
                console.log('Adding award:', this.form)
                axios.post('http://localhost:3001/api/awards', this.form)
                    .then(() => {
                        console.log('Award added');
                        router.push({ name: 'Award' });
                    })
                    .catch(error => {
                        this.handleError(error);
                    });
            }
        },
        handleError(error) {
            console.error(error);
            if (error.response && error.response.data) {
                this.errorMessage = error.response.data.error;
            } else {
                this.errorMessage = 'An error occurred';
            }
        },
    }
};
</script>

<style scoped>
.award-form {
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