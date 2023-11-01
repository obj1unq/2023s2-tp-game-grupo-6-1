import armas.*
import wollok.game.*
import gameClasses.*
import direcciones.*

class Personaje inherits Visual {

	var property arma
	var property estado
	var property salud

	method dispararSiEstaVivo(direccionAAtacar) {
		if (salud > 0) {
			self.estado("ataque")
			arma.usar(self, direccionAAtacar)
			self.estado("default")
		}
	}

	method sufreDanio(danio)

	method morir() {
		self.estado("muerto")
	}

	method mover(direccion) {
		const siguiente = direccion.mover(self.position())
		self.position(siguiente)
	}

	override method sufrirImpacto(municion) {
		self.sufreDanio(municion.danio())
		super(municion)
	}

	method muereSiNoHaySalud(danio) {
		if (self.personajeHaDeMorir()) {
			self.morir()
		}
	}

	method personajeHaDeMorir() {
		return salud < 0
	}

	method obtenerEscudo(valor)

	method obtenerSalud(valor)

	method equipar(_arma)

}

object doomGuy inherits Personaje(arma = new Pistola(), estado = 'default', salud = 100, position = game.at(0, game.center().y())) {

	var escudo = 100

	override method image() {
		return "doomguy/doomguy_" + self.estado() + ".png"
	}

	override method obtenerEscudo(valor) {
		escudo += valor
	}

	override method obtenerSalud(valor) {
		salud += valor
	}

	override method equipar(_arma) {
		arma = _arma
	}

	override method sufreDanio(_danio) {
		self.sufrirDanioSiHayEscudo(_danio)
		self.sufrirDanioSiNoHayEscudoYHaySalud(_danio)
		self.muereSiNoHaySalud(_danio)
	}

	method sufrirDanioSiHayEscudo(_danio) {
		if (self.haDeSufrirElEscudo(_danio)) {
			escudo = (escudo - _danio)
		}
	}

	method haDeSufrirElEscudo(_danio) {
		return (escudo - _danio) >= 0 and salud > 0
	}

	method sufrirDanioSiNoHayEscudoYHaySalud(_danio) {
		if (self.haDeSufrirLaSalud(_danio)) {
			escudo = 0
			salud = (salud - _danio)
		}
	}

	method haDeSufrirLaSalud(_danio) {
		return (escudo - _danio) < 0 and (salud - _danio) >= 0
	}

	override method muereSiNoHaySalud(_danio) {
		if (self.personajeHaDeMorir()) {
			nivelController.gameOver()
		}
	}

	override method mover(direccion) {
		self.validarMover(direccion)
		if (salud > 0) {
			super(direccion)
		}
	}

	method validarMover(direccion) {
		const siguiente = direccion.mover(self.position())
		if (!tablero.esZonaDoomguy(siguiente)) {
			self.error("I can't go there")
		}
	}

}

