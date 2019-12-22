require("../assets/css/style.css")
require("../assets/css/custom.css")
require("../assets/css/resume.css")
require("../assets/resume.json")
const Elm = require("./elm").Elm
import Vue from "vue/dist/vue.min.js"

const app = Elm.Main.init({ node: document.querySelector("#elm-resume") })
app.ports.getResume.subscribe((resume) => {
    console.log(resume)
    const vueApp = new Vue({
        el: "#vueapp",
        data: {
            selected: null,
            resume,
        },
        mounted() {
            this.$refs.info.classList.toggle("hidden")
        },
        methods: {
            select(subtitle) {
                if (this.selected == subtitle) {
                    this.selected = null
                } else {
                    this.selected = subtitle
                }
            },
        },
    })
})
