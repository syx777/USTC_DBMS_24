<template>
  <div class="students">
    <table>
      <thead>
        <tr>
          <th>学号</th>
          <th>姓名</th>
          <th>性别</th>
          <th>班级</th>
          <th>专业</th>
          <th>预计毕业时间</th>
          <th>电话</th>
          <th>照片</th>
          <th>学业情况</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="student in students" :key="student.student_id">
          <td>{{ student.student_id }}</td>
          <td>{{ student.name }}</td>
          <td>{{ student.gender }}</td>
          <td>{{ student.class }}</td>
          <td>{{ student.major }}</td>
          <td>{{ student.grade }}</td>
          <td>{{ student.phone }}</td>
          <td><button @click="showPhoto(student.photo)">查看</button></td>
          <td>{{ student.status }}</td>
          <td>
            <button @click="navigateToEditStudent(student)">修改</button>
            <button @click="deleteStudent(student.student_id)">删除</button>
          </td>
        </tr>
      </tbody>
    </table>
    <button class="add-student-button" @click="navigateToAddStudent">添加学生</button>

    <modal v-if="showPhotoModal" @close="showPhotoModal = false">
      <img :src="currentPhoto" alt="Student Photo" />
    </modal>

    <error-notification v-if="errorMessage" :message="errorMessage" @close="errorMessage = ''" />
  </div>
  <div class="search-bar">
    <input type="text" v-model="searchCriteria.student_id" placeholder="学号" />
    <input type="text" v-model="searchCriteria.name" placeholder="姓名" />
    <input type="text" v-model="searchCriteria.gender" placeholder="性别" />
    <input type="text" v-model="searchCriteria.class" placeholder="班级" />
    <input type="text" v-model="searchCriteria.major" placeholder="专业" />
    <input type="text" v-model="searchCriteria.grade" placeholder="预计毕业时间" />
    <input type="text" v-model="searchCriteria.status" placeholder="学业情况" />
    <button @click="searchStudents">查询</button>
  </div>
</template>

<script>
import axios from 'axios';
import Modal from '../components/Modal.vue';
import ErrorNotification from '../components/Error.vue';
import router from '../router';

export default {
  name: 'StudentList',
  components: {
    Modal,
    ErrorNotification,
  },
  data() {
    return {
      students: [],
      showPhotoModal: false,
      currentPhoto: null,
      searchCriteria: {
        student_id: '',
        name: '',
        gender: '',
        class: '',
        major: '',
        grade: '',
        status: '',
      },
      errorMessage: '',
    };
  },
  created() {
    this.fetchStudents();
  },
  methods: {
    fetchStudents() {
      axios.get('http://localhost:3001/api/students')
        .then(response => {
          this.students = response.data;
        })
        .catch(error => {
          this.handleError(error);
        });
    },
    searchStudents() {
      axios.get('http://localhost:3001/api/students/search', { params: this.searchCriteria })
        .then(response => {
          this.students = response.data;
        })
        .catch(error => {
          this.handleError(error);
        });
    },
    showPhoto(photo) {
      this.currentPhoto = photo;
      this.showPhotoModal = true;
    },
    navigateToAddStudent() {
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
          this.handleError(error);
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
  },
};
</script>

<style scoped>
.students {
  padding: 20px;
}

.search-bar {
  margin-bottom: 20px;
  margin-left: 250px;
}

.search-bar input {
  margin-right: 10px;
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

th, td {
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
