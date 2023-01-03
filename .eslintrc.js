module.exports = {
  env: {
    node: true,
  },
  extends: [
    'eslint:recommended',
    'plugin:vue/recommended',
    'prettier'
  ],
  rules: {
    'vue/no-unused-vars': 'error',
    'vue/require-default-prop': 'off',
    'curly': 'error'
  }
}
