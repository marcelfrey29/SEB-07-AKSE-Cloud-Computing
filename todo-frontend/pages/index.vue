<template>
    <div>
        <div class="mt-2">
            <b-card-title>Hello {{ $auth.user.name }}!</b-card-title>
            <br />
            <b-card-sub-title>Select a list to get started.</b-card-sub-title>
        </div>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'

@Component({})
export default class Index extends Vue {}
</script>
