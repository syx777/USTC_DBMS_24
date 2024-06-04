<template>
    <div class="classes">
        <table>
            <thead>
                <tr>
                    <th>班级编号</th>
                    <th>学院</th>
                    <th>年级</th>
<!--                     <th>操作</th> -->
                </tr>
            </thead>
            <tbody>
                <tr v-for="classk in classes" :key="classk.class_id">
                    <td>{{ classk.class_id }}</td>
                    <td>{{ classk.major }}</td>
                    <td>{{ classk.grade }}</td>
                </tr>
            </tbody>
        </table>
<!--         <button class="add-student-button" @click="navigateToAddStudent">添加班级</button> -->
    </div>
</template>

<script>
import axios from 'axios';

export default {
    name: 'ClassList',
    components: {
    },
    data() {
        return {
            classes: []
        };
    },
    created() {
        this.fetchStudents();
    },
    methods: {
        fetchStudents() {
            axios.get('http://localhost:3001/api/classes')
                .then(response => {
                    this.classes = response.data;
                })
                .catch(error => {
                    console.error(error);
                });
        },
/*         navigateToAddStudent() {
            router.push({ name: 'StudentForm', params: { student: null } });
        },
        navigateToEditStudent(student) {
            console.log('Navigating to edit student:', student);
            router.push({ name: 'StudentForm', params: { student: JSON.stringify(student) } });
        },
        deleteStudent(id) {
            axios.delete(`http://localhost:3001/api/students/${id}`)
                .then(() => {
                    this.fetchStudents();
                })
                .catch(error => {
                    console.error(error);
                });
        } */
    }
};
</script>

<style scoped>
.classes {
    padding: 20px;
}

.add-student-button {
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

.modal img {
    max-width: 100%;
}
</style>