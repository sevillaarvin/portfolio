Vue.component('landing', {
	template: "#landing"
})

Vue.component('portfolio', {
	template: "#portfolio"
})

Vue.component('contact', {
	template: "#contact"
})

const app = new Vue({
	el: "#app",
	data: {
		selectedComponent: "landing"
	},
	template: `
		<transition name="slide" mode="out-in">
			<component :is='selectedComponent' class="d-none d-lg-flex flex-column justify-content-center flex-grow-1"></component>
		</transition>
	`
})

const nav = new Vue({
	data: {
		landingActive: false,
		portfolioActive: false,
		contactActive: false
	},
	el: "#nav",
	methods: {
		changeView(view) {
			app.selectedComponent = view
			this.landingActive = false
			this.portfolioActive = false
			this.contactActive = false
			switch (view) {
				case 'landing':
					this.landingActive = true
					break;
				case 'portfolio':
					this.portfolioActive = true
					break;
				case 'contact':
					this.contactActive = true
					break;
			}
		}
	}
})
