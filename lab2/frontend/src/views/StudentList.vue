<template>
  <div class="students">
    <h1>Students</h1>
    <form @submit.prevent="addStudent">
      <input v-model="newStudent.student_id" placeholder="Student-id" required />
      <input v-model="newStudent.name" placeholder="Name" required />
      <input v-model="newStudent.gender" placeholder="Gender" required />
      <input v-model="newStudent.class" placeholder="Class" required />
      <input v-model="newStudent.phone" placeholder="Phone" required />
      <input type="file" @change="onFileChange($event, 'newStudent')" />
      <button type="submit">Add Student</button>
    </form>
    <ul>
      <li v-for="student in students" :key="student.student_id">
        {{ student.name }} - <img :src="student.photo" alt="Student Photo" />
        <button @click="editStudent(student)">Edit</button>
        <button @click="deleteStudent(student.student_id)">Delete</button>
      </li>
    </ul>
    <div v-if="editingStudent">
      <h3>Edit Student</h3>
      <form @submit.prevent="updateStudent">
        <input v-model="editingStudent.student_id" placeholder="Student-id" required />
        <input v-model="editingStudent.name" placeholder="Name" required />
        <input v-model="editingStudent.gender" placeholder="Gender" required />
        <input v-model="editingStudent.class" placeholder="Class" required />
        <input v-model="editingStudent.phone" placeholder="Phone" required />
        <input type="file" @change="onFileChange($event, 'editingStudent')" />
        <button type="submit">Update Student</button>
        <button type="button" @click="cancelEdit">Cancel</button>
      </form>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'StudentList',
  data() {
    return {
      students: [],
      newStudent: {
        student_id:'',
        name: '',
        gender: '',
        class: '',
        phone: '',
        photo: null
      },
      editingStudent: null
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
          console.error(error);
        });
    },
    onFileChange(event, studentType) {
      const file = event.target.files[0];
      if (studentType === 'newStudent') {
        this.newStudent.photo = file;
      } else if (studentType === 'editingStudent') {
        this.editingStudent.photo = file;
      }
    },
    addStudent() {
      const formData = new FormData();
      formData.append('student_id', this.newStudent.student_id);
      formData.append('name', this.newStudent.name);
      formData.append('gender', this.newStudent.gender);
      formData.append('class', this.newStudent.class);
      formData.append('phone', this.newStudent.phone);
      if (this.newStudent.photo) {
        formData.append('photo', this.newStudent.photo);
      }

      axios.post('http://localhost:3001/api/students', formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      })
        .then(response => {
          console.log('Student added:', response.data); // 添加日志记录
          this.fetchStudents();
          this.newStudent = {
            student_id:'',
            name: '',
            gender: '',
            class: '',
            phone: '',
            photo: null
          };
        })
        .catch(error => {
          console.error('Error adding student:', error);
        });
    },
    editStudent(student) {
      this.editingStudent = { ...student, photo: null };
    },
    updateStudent() {
      const formData = new FormData();
      formData.append('student_id', this.editingStudent.student_id);
      formData.append('name', this.editingStudent.name);
      formData.append('gender', this.editingStudent.gender);
      formData.append('class', this.editingStudent.class);
      formData.append('phone', this.editingStudent.phone);
      if (this.editingStudent.photo) {
        formData.append('photo', this.editingStudent.photo);
      }

      axios.put(`http://localhost:3001/api/students/${this.editingStudent.student_id}`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      })
        .then(() => {
          this.fetchStudents();
          this.editingStudent = null;
        })
        .catch(error => {
          console.error(error);
        });
    },
    deleteStudent(id) {
      axios.delete(`http://localhost:3001/api/students/${id}`)
        .then(() => {
          this.fetchStudents();
        })
        .catch(error => {
          console.error(error);
        });
    },
    cancelEdit() {
      this.editingStudent = null;
    }
  }
};
</script>


<style scoped>
.students {
  padding: 20px;
}

form {
  margin-bottom: 20px;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  margin: 10px 0;
}

button {
  margin-left: 10px;
}
</style>
