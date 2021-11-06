<template>
    <div>
        <p>Logged in? {{ $auth.loggedIn }}</p>
        <hr />
        <div v-if="$auth.loggedIn">
            <p>User {{ $auth.user }}</p>
        </div>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'

@Component({})
export default class Index extends Vue {}
</script>
