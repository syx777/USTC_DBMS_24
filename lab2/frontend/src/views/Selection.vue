<template>
    <div class="CourseSelection">
        <table>
            <thead>
                <tr>
                    <th>学生ID</th>
                    <th>学生姓名</th>
                    <th>课程ID</th>
                    <th>授课教师</th>
                    <th>授课地点</th>
                    <th>学分</th>
                    <th>成绩</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="selection in selections" :key="selection.student_id + selection.course_id">
                    <td>{{ selection.student_id }}</td>
                    <td>{{ selection.student_name }}</td>
                    <td>{{ selection.course_id }}</td>
                    <td>{{ selection.teacher_name }}</td>
                    <td>{{ selection.course_place }}</td>
                    <td>{{ selection.credits }}</td>
                    <td>{{ selection.grade }}</td>
                    <td>
                        <button @click="deleteSelection(selection.student_id, selection.course_id)">退课</button>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="add-selection">
            <input type="text" v-model="newSelection.student_id" placeholder="学生ID" />
            <input type="text" v-model="newSelection.course_id" placeholder="课程ID" />
            <button @click="addSelection">选课</button>
        </div>
        <div class="search-bar">
            <input type="text" v-model="searchCriteria.student_id" placeholder="学生ID" />
            <input type="text" v-model="searchCriteria.student_name" placeholder="学生姓名" />
            <input type="text" v-model="searchCriteria.course_id" placeholder="课程ID" />
            <input type="text" v-model="searchCriteria.teacher_name" placeholder="授课教师" />
            <input type="text" v-model="searchCriteria.course_place" placeholder="授课地点" />
            <input type="text" v-model="searchCriteria.credits" placeholder="学分" />
            <input type="text" v-model="searchCriteria.grade" placeholder="成绩" />
            <button @click="searchSelections">查询</button>
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    name: 'CourseSelection',
    data() {
        return {
            selections: [],
            newSelection: {
                student_id: '',
                course_id: ''
            },
            searchCriteria: {
                student_id: '',
                student_name: '',
                course_id: '',
                teacher_name: '',
                course_place: '',
                credits: '',
                grade: ''
            }
        };
    },
    created() {
        this.fetchSelections();
    },
    methods: {
        fetchSelections() {
            axios.get('http://localhost:3001/api/selections')
                .then(response => {
                    this.selections = response.data;
                })
                .catch(error => {
                    console.error(error);
                });
        },
        addSelection() {
            axios.post('http://localhost:3001/api/selections', this.newSelection)
                .then(() => {
                    this.fetchSelections();
                })
                .catch(error => {
                    console.error(error);
                });
        },
        deleteSelection(student_id, course_id) {
            axios.delete(`http://localhost:3001/api/selections/${student_id}/${course_id}`)
                .then(() => {
                    this.fetchSelections();
                })
                .catch(error => {
                    console.error(error);
                });
        },
        searchSelections() {
            axios.get('http://localhost:3001/api/selections/search', { params: this.searchCriteria })
                .then(response => {
                    this.selections = response.data;
                })
                .catch(error => {
                    console.error(error);
                });
        }
    }
};
</script>

<style scoped>
.CourseSelection {
    padding: 20px;
}

.search-bar {
    margin-bottom: 20px;
    margin-left: 250px;
}

.search-bar input {
    margin-right: 10px;
}

.add-selection {
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
