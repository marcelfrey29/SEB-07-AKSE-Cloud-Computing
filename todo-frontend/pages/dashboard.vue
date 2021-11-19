<template>
    <div>
        <b-container fluid>
            <b-row>
                <b-col class="p-0">
                    Dashboard
                    <div>
                        <div>
                            Response: <b>{{ serviceResponse }}</b>
                        </div>
                        <b-button variant="primary" @click="getServiceResponse"
                            >Check Backend Connection</b-button
                        >
                    </div>
                </b-col>
            </b-row>
        </b-container>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'

@Component({})
export default class Dashboard extends Vue {
    private serviceResponse = ' '

    async getServiceResponse(): Promise<void> {
        let response = ''
        try {
            response = await this.$axios.$get('http://localhost:4000/lists')
        } catch (err) {
            response = 'ERROR: ' + err
        }
        this.serviceResponse = response
    }
}
</script>
