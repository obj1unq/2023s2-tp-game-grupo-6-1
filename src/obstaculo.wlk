import gameClasses.*
import wollok.game.*
import personaje.*
import direcciones.*
import managers.*

class Muro inherits Visual {

	var durabilidad

	method durabilidad() {
		return durabilidad
	}

	override method image() {
		return "assets/muro/muro_default.png"
	}

	override method sufrirImpacto(municion) {
		if (municion.causante().puedeDanar()) {
			durabilidad -= 1
			super(municion)
			self.destruirseSiCorresponde()
		}
	}

	method destruirseSiCorresponde() {
		if (durabilidad <= 0) {
			game.removeVisual(self)
		}
	}

}

class Barril inherits Visual {

	var property estado = "default"

	method danio() {
		return 500
	}

	override method image() {
		return "assets/barril/barril_" + self.estado() + ".png"
	}

	override method sufrirImpacto(municion) {
		if (municion.causante().puedeDanar()) {
			super(municion)
			self.estado("muerto")
			game.schedule(500, { self.explotar()})
		}
	}

	method explotar() {
		self.danioExplosion()
		if(game.hasVisual(self)){
			game.removeVisual(self)
		}
	}

	method danioExplosion() {
		self.objetosEnRadioExplosion().forEach({ objeto => self.efectoExplosion(objeto)})
	}

	method efectoExplosion(objeto) {
		if (enemigoManager.generados().contains(objeto)) {
			objeto.sufreDanio(self.danio())
		}
	}

	method objetosEnRadioExplosion() {
		const direcciones = [ new Arriba(), new Abajo(), new Izquierda(), new Derecha() ]
		return self.ColectorObjetosEn(direcciones, (direcciones.size() - 1), [])
	}

	// es valido recursion?
	method ColectorObjetosEn(direcciones, indice, lista) {
		if (indice >= 0) {
			lista.addAll(game.getObjectsIn(direcciones.get(indice).mover(self.position())))
			self.ColectorObjetosEn(direcciones, (indice - 1), lista)
		}
		lista.addAll(game.getObjectsIn(self.position()))
		return lista
	}

}

