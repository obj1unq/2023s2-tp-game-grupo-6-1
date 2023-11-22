import wollok.game.*
import factories.*
import direcciones.*
import gameClasses.*
import personaje.*

class Manager {

	var generados = []
	var limite
	var factories

	method seleccionarFactory() {
		const randomNumber = (0 .. (factories.size() - 1)).anyOne()
		return factories.get(randomNumber)
	}

	method generar() {
		if (generados.size() < limite) {
			self.agregarObjeto()
		}
	}

	method quitar(item) {
		generados.remove(item)
		self.removerSiPresenteEnTablero(item)
	}

	method removerSiPresenteEnTablero(item) {
		if (game.hasVisual(item)) {
			game.removeVisual(item)
		}
	}

	method agregarObjeto() {
		const objeto = self.seleccionarFactory().nuevo()
		game.addVisual(objeto)
		generados.add(objeto)
	}

	method agregarFactory(factory) {
		factories.add(factory)
	}

	method limite(_limite) {
		limite = _limite
	}

	method generados() {
		return generados
	}

	method vaciarGenerados() {
		generados = []
	}

	method vaciarFactories() {
		factories = []
	}

	method factories() {
		return factories
	}

}

object armaManager inherits Manager(limite = 3, factories = [ pistolaFactory ]) {

}

object saludManager inherits Manager(limite = 2, factories = [ saludPequeniaFactory ]) {

}

object escudoManager inherits Manager(limite = 2, factories = [ escudoPequenioFactory ]) {

}

object enemigoManager inherits Manager(limite = 0, factories = []) {

	override method agregarObjeto() {
	}

	override method quitar(item) {
		super(item)
		nivelController.pasarDeNivelSiVencioATodos()
	}

	method agregarEnemigo(enemigo) {
		generados.add(enemigo)
	}

	method moverEnemigos() {
		generados.forEach({ enemigo => self.moverEnemigo(enemigo)})
	}

	method moverEnemigo(enemigo) {
		game.schedule(enemigo.velocidad(), { enemigo.mover(new Izquierda())})
	}

	method activarAtaqueEnemigos() {
		generados.forEach({ enemigo => self.activarAtaqueEnemigo(enemigo)})
	}

	method matarATodos() {
		generados.forEach({ enemigo => enemigo.morir()})
	}

	method activarAtaqueEnemigo(_enemigo) {
		game.schedule(_enemigo.velDisparo(), { _enemigo.dispararSiEstaVivo(new Izquierda())})
	}

	method estanTodosMuertos() {
		return generados.isEmpty()
	}

}

