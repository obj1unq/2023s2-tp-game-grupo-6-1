import wollok.game.*
import factories.*
import direcciones.*
import gameClasses.*

class Manager {

	var generados = []
	var limite
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

	method agregarObjeto() {
		const objeto = self.seleccionarFactory().nuevo()
		game.addVisual(objeto)
		generados.add(objeto)
	}

	method agregarFactory(factory) {
		factories.add(factory)
	}
	
	method limite(_limite){
		limite = _limite
	}
	
	method generados(){
		return generados
	}

}


object armaManager inherits Manager(limite = 5, factories = #{pistolaFactory }){
}

object saludManager inherits Manager(limite = 5, factories = #{saludPequeniaFactory }){
}

object escudoManager inherits Manager(limite = 5, factories = #{escudoPequenioFactory }){
}

object enemigoManager inherits Manager(limite = 0, factories = #{ }) {

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
		generados.forEach({ enemigo => enemigo.dispararSiEstaVivo(new Izquierda())})
	}

	method estanTodosMuertos() {
		return generados.isEmpty()
	}

}

