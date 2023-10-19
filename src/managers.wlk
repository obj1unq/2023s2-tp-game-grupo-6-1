import wollok.game.*
import factories.*

class Manager {

	var generados = #{}
	const limite
	const factories

	method seleccionarFactory() {
		return factories.anyOne()
	}

	method generar() {
		if (generados.size() < limite) {
			self.agregarObjeto()
		}
	}

	method quitar(item) {
		generados.remove(item)
		game.removeVisual(item)
	}

	method agregarObjeto()

}

object enemigoManager inherits Manager(limite = 1, factories = #{ lostSoulFactory }) {

	override method agregarObjeto() {
		const enemigo = self.seleccionarFactory().nuevo()
		game.addVisual(enemigo)
		generados.add(enemigo)
	}

	method moverEnemigos() {
		generados.forEach({ enemigo => enemigo.perseguirAdoomGuy()})
	}

}

