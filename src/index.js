require("../assets/css/style.css")
require("../assets/css/custom.css")
require("../assets/css/resume.css")

// For webpack copying only
require("../assets/resume.json")
require("../assets/images/cap1.png")
require("../assets/images/cap2.png")
require("../assets/images/cap3.png")

const Elm = require("./Main.elm").Elm
import Vue from "vue/dist/vue.min.js"

const app = Elm.Main.init({ node: document.querySelector("#elm-resume") })
app.ports.getResume.subscribe((resume) => {
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
