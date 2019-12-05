require("../assets/css/style.css")
require("../assets/css/custom.css")
require("../assets/resume.json")
const Elm = require("./elm").Elm

const app = Elm.Main.init({ node: document.querySelector("#elm-resume") })
