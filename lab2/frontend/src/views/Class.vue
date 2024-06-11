<template>
    <div class="classes">
        <table>
            <thead>
                <tr>
                    <th>班级编号</th>
                    <th>学院</th>
                    <th>年级</th>
                    <th>人数</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="classk in classes" :key="classk.class_id">
                    <td>{{ classk.class_id }}</td>
                    <td>{{ classk.major }}</td>
                    <td>{{ classk.grade }}</td>
                    <td>{{ classk.class_size }}</td>
                    <td>
                        <button @click="navigateToEditClass(classk)">修改</button>
                        <button @click="deleteClass(classk.class_id)">删除</button>
                    </td>
                </tr>
            </tbody>
        </table>
        <button class="add-class-button" @click="navigateToAddClass">添加班级</button>
        <error-notification v-if="errorMessage" :message="errorMessage" @close="errorMessage = ''" />
    </div>
    <div class="search-bar">
        <input type="text" v-model="searchCriteria.class_id" placeholder="班级编号" />
        <input type="text" v-model="searchCriteria.major" placeholder="学院" />
        <input type="text" v-model="searchCriteria.grade" placeholder="年级" />
        <button @click="searchClasses">查询</button>
    </div>
</template>

<script>
import axios from 'axios';
import router from '../router';
import ErrorNotification from '../components/Error.vue';

export default {
    name: 'ClassList',
    components: {
        ErrorNotification
    },
    data() {
        return {
            classes: [],
            searchCriteria: {
                class_id: '',
                major: '',
                class_size: '',
                grade: ''
            }
        };
    },
    created() {
        this.fetchClasses();
    },
    methods: {
        fetchClasses() {
            axios.get('http://localhost:3001/api/classes')
                .then(response => {
                    this.classes = response.data;
                })
                .catch(error => {
                    console.handleError(error);
                });
        },
        searchClasses() {
            axios.get('http://localhost:3001/api/classes/search', { params: this.searchCriteria })
                .then(response => {
                    this.classes = response.data;
                })
                .catch(error => {
                    console.handleError(error);
                });
        },
        navigateToAddClass() {
            router.push({ name: 'ClassForm', params: { classk: null } });
        },
        navigateToEditClass(classk) {
            router.push({ name: 'ClassForm', params: { classk: JSON.stringify(classk) } });
        },
        deleteClass(id) {
            axios.delete(`http://localhost:3001/api/classes/${id}`)
                .then(() => {
                    this.fetchClasses();
                })
                .catch(error => {
                    console.handleError(error);
                });
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
.classes {
    padding: 20px;
}

.search-bar {
    margin-bottom: 20px;
    margin-left: 250px;
}

.search-bar input {
    margin-right: 10px;
}

.add-class-button {
    margin-top: 20px;
    margin-left: 250px;
}

table {
    margin-top: 150px;
    margin-left: 250px;
    width: 80%;
    border-collapse: collapse;
}

th,
td {
    border: 1px solid #ddd;
    padding: 8px;
}

th {
    background-color: #f2f2f2;
}

button {
    margin: 5px;
}
</style>