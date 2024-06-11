<template>
    <div class="GradeManagement">
        <table>
            <thead>
                <tr>
                    <th>学生ID</th>
                    <th>学生姓名</th>
                    <th>课程ID</th>
                    <th>学分</th>
                    <th>成绩</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="grade in grades" :key="grade.student_id + grade.course_id">
                    <td>{{ grade.student_id }}</td>
                    <td>{{ grade.student_name }}</td>
                    <td>{{ grade.course_id }}</td>
                    <td>{{ grade.credits }}</td>
                    <td>{{ grade.grade }}</td>
                    <td>
                        <button @click="editGrade(grade)">修改成绩</button>
                        <button @click="clearGrade(grade.student_id, grade.course_id)">放弃成绩</button>
                    </td>
                </tr>
            </tbody>
        </table>
        <error-notification v-if="errorMessage" :message="errorMessage" @close="errorMessage = ''" />
        <div class="search-bar">
            <input type="text" v-model="searchCriteria.student_id" placeholder="学生ID" />
            <input type="text" v-model="searchCriteria.student_name" placeholder="学生姓名" />
            <input type="text" v-model="searchCriteria.course_id" placeholder="课程ID" />
            <input type="text" v-model="searchCriteria.credits" placeholder="学分" />
            <input type="text" v-model="searchCriteria.grade" placeholder="成绩" />
            <button @click="searchGrades">查询</button>
        </div>
        <div v-if="isEditing" class="edit-grade">
            <h3>修改成绩</h3>
            <input type="text" v-model="editForm.student_id" placeholder="学生ID" readonly />
            <input type="text" v-model="editForm.course_id" placeholder="课程ID" readonly />
            <input type="number" v-model="editForm.grade" placeholder="成绩" />
            <button @click="updateGrade">提交</button>
            <button @click="cancelEdit">取消</button>
        </div>
    </div>
</template>

<script>
import axios from 'axios';
import ErrorNotification from '../components/Error.vue';

export default {
    name: 'GradeManagement',
    components: {
        ErrorNotification
    },
    data() {
        return {
            grades: [],
            isEditing: false,
            editForm: {
                student_id: '',
                course_id: '',
                grade: ''
            },
            searchCriteria: {
                student_id: '',
                student_name: '',
                course_id: '',
                credits: '',
                grade: ''
            }
        };
    },
    created() {
        this.fetchGrades();
    },
    methods: {
        fetchGrades() {
            axios.get('http://localhost:3001/api/grades')
                .then(response => {
                    this.grades = response.data;
                })
                .catch(error => {
                    console.handleError(error);
                });
        },
        searchGrades() {
            axios.get('http://localhost:3001/api/grades/search', { params: this.searchCriteria })
                .then(response => {
                    this.grades = response.data;
                })
                .catch(error => {
                    console.handleError(error);
                });
        },
        editGrade(grade) {
            this.isEditing = true;
            this.editForm = { ...grade };
        },
        updateGrade() {
            axios.put('http://localhost:3001/api/grades', this.editForm)
                .then(() => {
                    this.fetchGrades();
                    this.isEditing = false;
                })
                .catch(error => {
                    console.handleError(error);
                });
        },
        clearGrade(student_id, course_id) {
            axios.put(`http://localhost:3001/api/grades/clear`, { student_id, course_id })
                .then(() => {
                    this.fetchGrades();
                })
                .catch(error => {
                    console.handleError(error);
                });
        },
        cancelEdit() {
            this.isEditing = false;
            this.editForm = { student_id: '', course_id: '', grade: '' };
        },
        handleError(error) {
            console.error(error);
            if (error.response && error.response.data) {
                this.errorMessage = error.response.data.error;
            } else {
                this.errorMessage = 'An error occurred';
            }
        }
    }
};
</script>

<style scoped>
.GradeManagement {
    padding: 20px;
}

.search-bar {
    margin-bottom: 20px;
    margin-left: 250px;
}

.search-bar input {
    margin-right: 10px;
}

.edit-grade {
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
