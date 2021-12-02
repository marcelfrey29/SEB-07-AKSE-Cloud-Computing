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
    ignorePatterns: [
        '.eslintrc.js',
        '.gitignore',
        '.nuxt',
        'dist',
        'node_modules',
    ],
    plugins: [],
    // add your custom rules here
    rules: {},
}
