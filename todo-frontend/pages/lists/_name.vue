<template>
    <div>
        <b-container fluid>
            <b-row>
                <b-col class="p-0"> List {{ $route.params.name }} </b-col>
            </b-row>
        </b-container>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'

@Component({})
export default class List extends Vue {}
</script>
