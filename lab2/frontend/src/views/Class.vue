<template>
    <div class="classes">
        <table>
            <thead>
                <tr>
                    <th>班级编号</th>
                    <th>学院</th>
                    <th>年级</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="classk in classes" :key="classk.class_id">
                    <td>{{ classk.class_id }}</td>
                    <td>{{ classk.major }}</td>
                    <td>{{ classk.grade }}</td>
                    <td>
                        <button @click="navigateToEditClass(classk)">修改</button>
                        <button @click="deleteClass(classk.class_id)">删除</button>
                    </td>
                </tr>
            </tbody>
        </table>
        <button class="add-class-button" @click="navigateToAddClass">添加班级</button>
    </div>
</template>

<script>
import axios from 'axios';
import router from '../router';

export default {
    name: 'ClassList',
    data() {
        return {
            classes: []
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
                    console.error(error);
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
                    console.error(error);
                });
        }
    }
};
</script>

<style scoped>
.classes {
    padding: 20px;
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