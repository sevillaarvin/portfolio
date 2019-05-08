require("../assets/sass/main.scss")

const setUpNavigationHandlers = () => {
  const content = document.querySelector(".content")
  const subPages = document.querySelectorAll(".subpage")

  const navigationItems = document.querySelectorAll(".navigation__list")
  navigationItems.forEach((item) => {
    item.addEventListener("click", (e) => {
      const subPage = document.querySelector("." + e.target.dataset.link)
      const isHidden = subPage.classList.contains("hidden")

      hideAll([].concat.apply(Array(content), subPages))
      togglePage(content, subPage, isHidden)
    })
  })
}

const hideAll = (pages) => {
  pages.forEach((page) => {
    page.classList.add("hidden")
  })
}

const togglePage = (content, subPage, isHidden) => {
  if (isHidden) {
    subPage.classList.remove("hidden")
  } else {
    content.classList.remove("hidden")
    subPage.classList.add("hidden")
  }
}

const initialize = () => {
  setUpNavigationHandlers()
}

initialize()
