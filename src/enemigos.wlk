import personaje.*
import wollok.game.*
import gameClasses.*

//arma = puño, estado="vivo_derecha", position=game.at(0,0)
//ataque = 1, vision = 3
class Enemigo inherits Personaje {

	var vision

	override method sufreDanio(_danio) {
		salud -= _danio
		self.muereSiNoHaySalud(_danio)
	}

	override method muereSiNoHaySalud(_danio) {
		if (self.personajeHaDeMorir(_danio)) {
			self.morir()
		}
	}

	override method personajeHaDeMorir(_danio) {
		return salud > 0 && salud - _danio < 0
	}

	override method morir() {
		salud = 0
		self.activarAnimacionMuerte()
	}

	method perseguirAdoomGuy() {
		game.onTick(1000, self.toString() + "_acercarse_" + self.identity(), { self.acercarseParaAtacar(doomGuy.position())})
	}

	method acercarseParaAtacar(destino) {
		self.acercarse(destino)
		self.atacarSiHayCercania(destino)
	}

	method atacarSiHayCercania(destino) {
		if (self.hayCercania(destino)) {
			self.actualizarEstadoSegun(destino, "vivo_ataque_")
			self.activarSecuenciaAtaque(self.direccionesDeAtaque(destino))
		}
	}

	method hayCercania(destino) {
		return self.position().distance(destino).roundUp() < vision
	}

	override method sufrirImpacto(causante) {
		self.sufreDanio(causante.danio())
		causante.efectosPostImpacto()
	}

	method acercarse(destino) {
		position = game.at(position.x() + (destino.x() - position.x()) / vision, position.y() + (destino.y() - position.y()) / vision)
		self.actualizarEstadoSegun(destino, "vivo_")
	}

	override method accionPostMuerte() {
		enemigoManager.removerEnemigo(self)
	}

	method activarSecuenciaAtaque(direccion) {
		game.removeTickEvent(self.toString() + "_acercarse_" + self.identity())
		game.schedule(200, { game.removeTickEvent(self.toString() + "_ataque_" + self.identity())
			self.perseguirAdoomGuy()
		})
		game.onTick(50, self.toString() + "_ataque_" + self.identity(), { self.mover(direccion)
			self.atacar()
		})
	}

	method actualizarEstadoSegun(destino, _estado) {
		const direccion = self.direccionDeAtaqueEnX(destino)
		self.estado(_estado + direccion.devolverDireccion())
	}

	method direccionesDeAtaque(destino) {
		var direccionEnX = self.direccionDeAtaqueEnX(destino)
		var direccionEnY = self.direccionDeAtaqueEnY(destino)
		return self.elegirDireccionesDeAtaqueMasConveniente(direccionEnX, direccionEnY, destino)
	}

	method direccionDeAtaqueEnX(destino) {
		if (self.distanciaEnXA(destino) <= 0) {
			return new Izquierda()
		} else {
			return new Derecha()
		}
	}

	method direccionDeAtaqueEnY(destino) {
		return if (self.distanciaEnYA(destino) <= 0) {
			return new Abajo()
		} else {
			return new Arriba()
		}
	}

	method distanciaEnXA(destino) {
		return destino.x() - self.position().x()
	}

	method distanciaEnYA(destino) {
		return destino.y() - self.position().y()
	}

	method elegirDireccionesDeAtaqueMasConveniente(direccionEnX, direccionEnY, destino)
	
	method condicionDeAtaqueMasConveniente(posicionActual, posicionFinal)

}

class LostSoul inherits Enemigo {

	override method activarAnimacionMuerte() {
		const animacionMuerte = new AnimacionMuerte()
		animacionMuerte.animacion((1 .. 6), 100, self)
	}

	override method elegirDireccionesDeAtaqueMasConveniente(direccionEnX, direccionEnY, destino) {
		if (self.condicionDeAtaqueMasConveniente(self.position().x(), destino.x())) {
			return [ direccionEnY ]
		} else if (self.condicionDeAtaqueMasConveniente(self.position().y(), destino.y())) {
			return [ direccionEnX ]
		} else {
			return [ direccionEnX, direccionEnY ]
		}
	}

	override method condicionDeAtaqueMasConveniente(posicionActual, posicionFinal) {
		return (posicionActual - posicionFinal).abs() <= 1
	}

	override method mover(direcciones) {
		direcciones.forEach({ direccion => self.position(direccion.mover(self.position()))})
	}

}

class Pinky inherits Enemigo {

	override method activarAnimacionMuerte() {
		const animacionMuerte = new AnimacionMuerte()
		animacionMuerte.animacion((1 .. 6), 100, self)
	}

	override method elegirDireccionesDeAtaqueMasConveniente(direccionEnX, direccionEnY, destino) {
		if (self.condicionDeAtaqueMasConveniente(self.position().x(), destino.x())) {
			return [ direccionEnY ]
		} else {
			return [ direccionEnX ]
		}
	}

	override method condicionDeAtaqueMasConveniente(posicionActual, posicionFinal) {
		return (posicionActual - posicionFinal).abs() <= vision
	}

	override method mover(direcciones) {
		direcciones.forEach({ direccion => self.position(direccion.mover(self.position()))})
	}

	override method activarSecuenciaAtaque(direccion) {
		game.schedule(100, { super(direccion)})
	}

}

class Zombie inherits Enemigo {
	
	override method atacarSiHayCercania(destino) {
		if (self.hayCercania(destino)) {
			self.activarSecuenciaAtaque(self.direccionesDeAtaque(destino))
		}
	}

	override method activarAnimacionMuerte() {
		const animacionMuerte = new AnimacionMuerte()
		animacionMuerte.animacion((1 .. 5), 100, self)
	}

	override method elegirDireccionesDeAtaqueMasConveniente(direccionEnX, direccionEnY, destino) {
		if (self.condicionDeAtaqueMasConveniente(self.position().x(), destino.x())) {
			return [ direccionEnY ]
		} else {
			return [ direccionEnX ]
		}
	}

	override method condicionDeAtaqueMasConveniente(posicionActual, posicionFinal) {
		return (posicionActual - posicionFinal).abs() <= vision
	}

	override method mover(direcciones) {
		direcciones.forEach({ direccion => self.position(direccion.mover(self.position()))})
	}

	override method activarSecuenciaAtaque(direccion) {
		game.removeTickEvent(self.toString() + "_acercarse_" + self.identity())
		self.atacar()
		self.perseguirAdoomGuy()
	}

}


