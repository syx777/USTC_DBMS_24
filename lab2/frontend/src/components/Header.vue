<template>
  <header class="app-header">
    <nav>
      <ul class="nav-list">
        <li class="header-title">学籍管理系统</li>
        <li class="header-welcome">欢迎您,系统管理员！</li>
        <li><button @click="logout">登出</button></li>
      </ul>
    </nav>
  </header>
</template>

<script>
export default {
  name: 'AppHeader',
  methods: {
    logout() {
      this.$store.dispatch('logout');  // 调用 Vuex 中的 logout action
      this.$router.push('/');          // 跳转到登录页面
    }
  }
};
</script>

<style scoped>
.app-header {
  background-color: #544ACA;
  padding: 2rem;
  color: white;
  margin: 0;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  box-sizing: border-box;
}

.nav-list {
  list-style: none;
  padding: 0;
  display: flex;
  text-align: left;
  align-items: center;
  margin: 0;
}

.header-title {
  font-weight: bold;
  font-size: 2rem;
  margin: 0;
  flex-grow: 1;
}

.header-welcome {
  font-family: "STXingkai";
  font-size: 1.5rem;
  position: absolute;
  right: 30rem;
  top: 50%;
  transform: translateY(-50%);
}

nav a {
  color: white;
  text-decoration: none;
}

nav a:hover {
  text-decoration: underline;
}

button {
  background: none;
  border: none;
  color: white;
  cursor: pointer;
}
</style>
