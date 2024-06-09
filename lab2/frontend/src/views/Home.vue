<!-- src/views/Home.vue -->
<template>
  <div class="home">
    <form @submit.prevent="handleLogin">
      <div class="form-group">
        <label for="username">账号：</label>
        <input type="text" v-model="username" id="username" required />
      </div>
      <div class="form-group">
        <label for="password">密码：</label>
        <div class="password-input">
          <input :type="passwordFieldType" v-model="password" id="password" required />
        </div>
      </div>
      <button type="submit">登录</button>
    </form>
    <div v-if="errorMessage" class="error-message">
      {{ errorMessage }}
    </div>
    <div v-if="loginPrompt" class="login-prompt">
      {{ loginPrompt }}
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';

export default {
  name: 'HomeList',
  data() {
    return {
      username: '',
      password: '',
      errorMessage: '',
      passwordFieldType: 'password',
      defaultUsername: 'admin',
      defaultPassword: '123456'
    };
  },
  computed: {
    ...mapState(['loginPrompt'])
  },
  methods: {
    handleLogin() {
      if (this.username === this.defaultUsername && this.password === this.defaultPassword) {
        this.$store.dispatch('login');
        this.$router.push('/students');
      } else {
        this.errorMessage = '账号或密码错误';
      }
    },
    togglePasswordVisibility() {
      this.passwordFieldType = this.passwordFieldType === 'password' ? 'text' : 'password';
    }
  },
  watch: {
    loginPrompt() {
      if (this.loginPrompt) {
        setTimeout(() => {
          this.$store.commit('clearLoginPrompt');
        }, 3000);
      }
    }
  }
};
</script>

<style scoped>
.home {
  max-width: 300px;
  margin-top: 15rem;
  margin-left: 38rem;
  padding: 2rem;
  border: 1px solid #ccc;
  border-radius: 5px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

h1 {
  text-align: center;
}

.form-group {
  margin-bottom: 1rem;
}

label {
  display: block;
  margin-bottom: 0.5rem;
}

input[type="text"],
input[type="password"] {
  width: 100%;
  padding: 0.5rem;
  box-sizing: border-box;
}

.password-input {
  display: flex;
  align-items: center;
}

.password-input button {
  margin-left: 0.5rem;
  padding: 0.5rem;
  background: none;
  border: none;
  cursor: pointer;
}

button[type="submit"] {
  width: 100%;
  padding: 0.75rem;
  background-color: #544ACA;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

button[type="submit"]:hover {
  background-color: #0056b3;
}

.error-message {
  margin-top: 1rem;
  color: red;
  text-align: center;
}

.login-prompt {
  margin-top: 1rem;
  color: red;
  text-align: center;
}
</style>
