<template>
  <div class="student-form">
    <form @submit.prevent="submitForm">
      <table>
        <tbody>
          <tr>
            <td><label for="student_id">学号</label></td>
            <td><input v-model="form.student_id" id="student_id" type="text" required /></td>
          </tr>
          <tr>
            <td><label for="name">姓名</label></td>
            <td><input v-model="form.name" id="name" type="text" required /></td>
          </tr>
          <tr>
            <td><label for="gender">性别</label></td>
            <td><input v-model="form.gender" id="gender" type="text" required /></td>
          </tr>
          <tr>
            <td><label for="class">班级</label></td>
            <td><input v-model="form.class" id="class" type="text" required /></td>
          </tr>
          <tr>
            <td><label for="phone">电话</label></td>
            <td><input v-model="form.phone" id="phone" type="text" /></td>
          </tr>
          <tr>
            <td><label for="photo">照片</label></td>
            <td>
              <input type="file" @change="onFileChange" />
              <button v-if="form.photoUrl" @click="viewPhoto" type="button">查看</button>
            </td>
          </tr>
        </tbody>
      </table>
      <div class="button-container">
        <button type="submit">提交</button>
        <button @click="returnStudentList">返回</button>
      </div>
    </form>

    <div v-if="showPhotoModal" class="modal" @click="closePhotoModal">
      <img :src="form.photoUrl" alt="Student Photo" />
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import router from '../router';

export default {
  name: 'StudentForm',
  data() {
    return {
      form: {
        student_id: '',
        name: '',
        gender: '',
        class: '',
        phone: '',
        photo: null,
        photoUrl: null
      },
      showPhotoModal: false
    };
  },
  created() {
    console.log('created() started');
    if (this.$route.params.student) {
      try {
        this.student = JSON.parse(this.$route.params.student);
        console.log('Editing student:', this.student.photo);
        this.form.student_id = this.student.student_id || '';
        this.form.name = this.student.name || '';
        this.form.gender = this.student.gender || '';
        this.form.class = this.student.class || '';
        this.form.phone = this.student.phone || '';
        if (this.student.photo) {
          this.form.photoUrl = this.student.photo;
        }
      } catch (error) {
        console.error('Error parsing student:', error);
      }
    } else {
      this.student = {};
    }
  },
  methods: {
    onFileChange(event) {
      const file = event.target.files[0];
      this.form.photo = file;
      this.form.photoUrl = URL.createObjectURL(file);
    },
    viewPhoto() {
      this.showPhotoModal = true;
    },
    closePhotoModal() {
      this.showPhotoModal = false;
    },
    returnStudentList() {
      router.push({ name: 'StudentList' });
    },
    submitForm() {
      const formData = new FormData();
      formData.append('student_id', this.form.student_id);
      formData.append('name', this.form.name);
      formData.append('gender', this.form.gender);
      formData.append('class', this.form.class);
      formData.append('phone', this.form.phone);
      if (this.form.photo) {
        formData.append('photo', this.form.photo);
      } else if (this.form.photoUrl) {
        formData.append('photoUrl', this.form.photoUrl);
      }

      const studentId = this.form.student_id;
      if (this.$route.params.student) {
        // 编辑学生
        axios.put(`http://localhost:3001/api/students/${studentId}`, formData, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })
          .then(() => {
            router.push({ name: 'StudentList' });
          })
          .catch(error => {
            console.error(error);
          });
      } else {
        // 添加学生
        axios.post('http://localhost:3001/api/students', formData, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })
          .then(() => {
            router.push({ name: 'StudentList' });
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
.student-form {
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

.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.8);
  display: flex;
  justify-content: center;
  align-items: center;
}

.modal img {
  max-width: 90%;
  max-height: 90%;
}
</style>
