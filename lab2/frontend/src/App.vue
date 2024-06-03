<template>
  <div id="app">
    <AppMenu />
    <AppHeader/>
    <router-view />
  </div>
</template>

<script>
import AppMenu from './components/Menu.vue';
import AppHeader from './components/Header.vue';

export default {
  name: 'App',
  components: {
    AppMenu,
    AppHeader
  }
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;

}
</style>
