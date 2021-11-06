import { Context } from '@nuxt/types'

/**
 * This middleware verifies that the user is logged in before he can access the app.
 *
 * If the user is not logged in, the user is redirected to the about page where he can login.
 *
 * @param context {Context} the Nuxt Application Context
 */
export default function (context: Context) {
    if (!context.$auth.loggedIn) {
        context.redirect('/about')
    }
}
