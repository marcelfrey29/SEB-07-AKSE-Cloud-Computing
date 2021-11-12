export default {
    // Disable server-side rendering: https://go.nuxtjs.dev/ssr-mode
    ssr: false,

    // Target: https://go.nuxtjs.dev/config-target
    target: 'static',

    // Global page headers: https://go.nuxtjs.dev/config-head
    head: {
        title: 'Todo App',
        htmlAttrs: {
            lang: 'en',
        },
        meta: [
            { charset: 'utf-8' },
            {
                name: 'viewport',
                content: 'width=device-width, initial-scale=1',
            },
            { hid: 'description', name: 'description', content: '' },
            { name: 'format-detection', content: 'telephone=no' },
        ],
        link: [{ rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }],
    },

    // Global CSS: https://go.nuxtjs.dev/config-css
    css: [],

    // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
    plugins: [],

    // Auto import components: https://go.nuxtjs.dev/config-components
    components: true,

    // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
    buildModules: [
        // https://go.nuxtjs.dev/typescript
        '@nuxt/typescript-build',
    ],

    // Modules: https://go.nuxtjs.dev/config-modules
    modules: [
        // https://go.nuxtjs.dev/bootstrap
        'bootstrap-vue/nuxt',
        // https://go.nuxtjs.dev/axios
        '@nuxtjs/axios',
        // Auth
        '@nuxtjs/auth-next',
    ],

    // Axios module configuration: https://go.nuxtjs.dev/config-axios
    axios: {},

    // Build Configuration: https://go.nuxtjs.dev/config-build
    build: {},

    auth: {
        strategies: {
            local: false,
            keycloak: {
                scheme: 'oauth2',
                endpoints: {
                    authorization:
                        process.env.NUXT_ENV_KEYCLOAK_HOST +
                        `/auth/realms/` +
                        process.env.NUXT_ENV_KEYCLOAK_REALM +
                        `/protocol/openid-connect/auth`,
                    userInfo:
                        process.env.NUXT_ENV_KEYCLOAK_HOST +
                        `/auth/realms/` +
                        process.env.NUXT_ENV_KEYCLOAK_REALM +
                        `/protocol/openid-connect/userinfo`,
                    token:
                        process.env.NUXT_ENV_KEYCLOAK_HOST +
                        `/auth/realms/` +
                        process.env.NUXT_ENV_KEYCLOAK_REALM +
                        `/protocol/openid-connect/token`,
                    logout:
                        process.env.NUXT_ENV_KEYCLOAK_HOST +
                        `/auth/realms/` +
                        process.env.NUXT_ENV_KEYCLOAK_REALM +
                        `/protocol/openid-connect/logout?redirect_uri=` +
                        encodeURIComponent(
                            process.env.NUXT_ENV_KEYCLOAK_REDIRECT_URI
                        ),
                },
                token: {
                    property: 'access_token',
                    type: 'Bearer',
                    name: 'Authorization',
                    maxAge: 1800,
                },
                refreshToken: {
                    property: 'refresh_token',
                    maxAge: 60 * 60 * 24 * 30,
                },
                responseType: 'code',
                grantType: 'authorization_code',
                clientId: process.env.NUXT_ENV_KEYCLOAK_CLIENT_ID,
                scope: ['openid', 'profile', 'email'],
                codeChallengeMethod: 'S256',
            },
        },
        redirect: {
            login: '/about',
            logout: '/about',
            home: false,
        },
    },
}
