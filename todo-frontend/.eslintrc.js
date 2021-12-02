module.exports = {
    root: true,
    env: {
        browser: true,
        node: true,
    },
    extends: [
        '@nuxtjs/eslint-config-typescript',
        'plugin:nuxt/recommended',
        'prettier',
    ],
    ignorePatterns: ['.eslintrc.js', '.gitignore'],
    plugins: [],
    // add your custom rules here
    rules: {},
}
