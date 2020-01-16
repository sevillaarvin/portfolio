import "../assets/css/style.css"
import "../assets/css/custom.css"
import "../assets/css/resume.css"
import "../assets/css/info.css"

// For webpack copying only
import "../assets/resume.json"
import "../assets/images/cap1.png"
import "../assets/images/cap2.png"
import "../assets/images/cap3.png"

import { Elm } from "./Main.elm"
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

// import gsap from "gsap"
