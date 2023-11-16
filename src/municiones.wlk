import wollok.game.*
import gameClasses.*
import managers.*
import personaje.*
import ui.*

class Municion inherits Visual {

	var ataque
	var causante
	var property estado = "derecha" // la inicio con valor para no tener conflictos pero siempre se actualiza cuando disparan

	method danio() {
		return ataque
	}

	method causante() {
		return causante
	}

	method mover(direccion) {
		const siguiente = direccion.mover(self.position())
		self.position(siguiente)
	}

	method moverSiPerteneceAlTablero(direccion) {
		if (tablero.pertenece(self.position())) {
			self.mover(direccion)
		} else {
			self.terminarMovimientoSiPresenteEnTablero()
		}
	}

	method terminarMovimientoSiPresenteEnTablero() {
		if (game.hasVisual(self)) {
			game.removeTickEvent("disparo_" + self.identity())
			game.removeVisual(self)
		}
	}

	method viajarImpactando(direccion) {
		self.estado(direccion.devolverDireccion())
		self.mover(direccion)
		game.onTick(self.velocidadMovimiento(), "disparo_" + self.identity(), {=>
			self.impactar()
			self.moverSiPerteneceAlTablero(direccion)
		})
	}

	method velocidadMovimiento()

	method impactar() {
		if (game.colliders(self).any({ objeto => self.esDePrioridad(objeto) })) {
			self.impactarALosDeMayorPrioridad()
		} else {
			game.colliders(self).forEach({ objeto => objeto.sufrirImpacto(self)})
		}
	}

	method esDePrioridad(objeto) {
		return enemigoManager.generados().contains(objeto)
	}

	method impactarALosDeMayorPrioridad() {
		game.colliders(self).filter({ objeto => self.esDePrioridad(objeto)}).forEach({ objeto => objeto.sufrirImpacto(self)})
	}

	override method sufrirImpacto(municion) {
	}

}

class Bala inherits Municion {

	override method image() {
		return "assets/municion/bala_" + self.estado() + "_default.png"
	}

	override method velocidadMovimiento() {
		return 200
	}

}

class BalaFrancotirador inherits Bala {

	override method velocidadMovimiento() {
		return 100
	}

}

class BolaDeFuego inherits Bala {

	override method image() {
		return "assets/municion/bala_fuego_default.png"
	}

// a futuro puede que genere un efecto de quemado
}

class BolaDePlasma inherits Bala {

	override method image() {
		return "assets/municion/bola_plasma_default.png"
	}

// a futuro puede que genere un efecto de reduccion bala o algo asi
}

class Misil inherits Municion {

	override method image() {
		return "assets/municion/misil_" + self.estado() + "_default.png"
	}

	override method velocidadMovimiento() {
		return 100
	}

	override method impactar() {
		if (!game.colliders(self).isEmpty()) {
			(0 .. game.height() - 2).forEach({ posicionY => game.getObjectsIn(game.at(self.position().x(), posicionY)).forEach({ objeto =>
				objeto.sufrirImpacto(self)
				self.agregarMarcaQuemado(game.at(self.position().x(), posicionY))
			})})
		}
	}

	method agregarMarcaQuemado(posicion) {
		const burnMark = new BurnMark(position = posicion)
		game.addVisual(burnMark)
		game.schedule(1500, { game.removeVisual(burnMark)})
	}

}

class MisilBoss inherits Municion {

	override method image() {
		return "assets/municion/misil_" + self.estado() + "_default.png"
	}

	override method velocidadMovimiento() {
		return 100
	}

}

class Argent inherits Municion { //Municion de la BFG

	override method image() {
		return "assets/municion/argent_default.png"
	}

	override method velocidadMovimiento() {
		return 500
	}

	override method impactar() {
		if (!game.colliders(self).isEmpty() && game.colliders(self).any({ obj => enemigoManager.generados().contains(obj) })) {
			enemigoManager.generados().forEach({ objeto => objeto.sufreDanio(self.danio())})
			self.terminarMovimientoSiPresenteEnTablero()
		} 
	}

}

