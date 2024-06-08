<template>
    <div class="awards">
        <table>
            <thead>
                <tr>
                    <th>记录编号</th>
                    <th>学生编号</th>
                    <th>学生姓名</th>
                    <th>类型</th>
                    <th>描述</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="award in awards" :key="award.record_id">
                    <td>{{ award.record_id }}</td>
                    <td>{{ award.student_id }}</td>
                    <td>{{ award.student_name }}</td>
                    <td>{{ award.type }}</td>
                    <td>{{ award.description }}</td>
                    <td>
                        <button @click="navigateToEditAward(award)">修改</button>
                        <button @click="deleteAward(award.record_id)">删除</button>
                    </td>
                </tr>
            </tbody>
        </table>
        <button class="add-award-button" @click="navigateToAddAward">添加记录</button>
    </div>
    <div class="search-bar">
        <input type="text" v-model="searchCriteria.record_id" placeholder="记录编号" />
        <input type="text" v-model="searchCriteria.student_id" placeholder="学生编号" />
        <input type="text" v-model="searchCriteria.student_name" placeholder="学生姓名" />
        <input type="text" v-model="searchCriteria.type" placeholder="类型" />
        <input type="text" v-model="searchCriteria.description" placeholder="描述" />
        <button @click="searchAwards">查询</button>
    </div>
</template>

<script>
import axios from 'axios';
import router from '../router';

export default {
    name: 'AwardList',
    data() {
        return {
            awards: [],
            searchCriteria: {
                record_id: '',
                student_id: '',
                student_name: '',
                type: '',
                description: ''
            }
        };
    },
    created() {
        this.fetchAwards();
    },
    methods: {
        fetchAwards() {
            axios.get('http://localhost:3001/api/awards')
                .then(response => {
                    console.log(response.data);
                    this.awards = response.data;
                })
                .catch(error => {
                    console.error(error);
                });
        },
        searchAwards() {
            axios.get('http://localhost:3001/api/awards/search', { params: this.searchCriteria })
                .then(response => {
                    this.awards = response.data;
                })
                .catch(error => {
                    console.error(error);
                });
        },
        navigateToAddAward() {
            router.push({ name: 'AwardForm', params: { award: null } });
        },
        navigateToEditAward(award) {
            router.push({ name: 'AwardForm', params: { award: JSON.stringify(award) } });
        },
        deleteAward(id) {
            axios.delete(`http://localhost:3001/api/awards/${id}`)
                .then(() => {
                    this.fetchAwards();
                })
                .catch(error => {
                    console.error(error);
                });
        }
    }
};
</script>

<style scoped>
.awards {
    padding: 20px;
}

.search-bar {
  margin-bottom: 20px;
  margin-left: 250px;
}

.search-bar input {
  margin-right: 10px;
}

.add-award-button {
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