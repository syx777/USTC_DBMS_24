import { createStore } from 'vuex';

const store = createStore({
  state: {
    loggedIn: localStorage.getItem('loggedIn') === 'true',
    loginPrompt: ''
  },
  mutations: {
    setLoggedIn(state, status) {
      state.loggedIn = status;
      localStorage.setItem('loggedIn', status);
    },
    setLoginPrompt(state, message) {
      state.loginPrompt = message;
    },
    clearLoginPrompt(state) {
      state.loginPrompt = '';
    }
  },
  actions: {
    login({ commit }) {
      commit('setLoggedIn', true);
      commit('clearLoginPrompt');
    },
    logout({ commit }) {
      commit('setLoggedIn', false);
      localStorage.removeItem('loggedIn');
    },
    promptLogin({ commit }, message) {
      commit('setLoginPrompt', message);
    }
  }
});

export default store;
