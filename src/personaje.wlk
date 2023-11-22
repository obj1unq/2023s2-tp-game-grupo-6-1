import armas.*
import wollok.game.*
import gameClasses.*
import direcciones.*
import managers.*
import ui.*

class Personaje inherits Visual {

	var property arma
	var property estado
	var property salud

	method puedeDanar() {
		return false
	}

	method arma() {
		return arma
	}

	method salud() {
		return salud
	}

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
		return salud <= 0
	}

	method obtenerEscudo(valor)

	method obtenerSalud(valor)

	method equipar(_arma)

}

object doomGuy inherits Personaje(arma = new Pistola(), estado = 'default', salud = 100, position = game.at(0, game.center().y())) {

	var property escudo = 100

	override method image() {
		return "doomguy/doomguy_" + self.estado() + ".png"
	}

	override method puedeDanar() {
		return true
	}

	override method obtenerEscudo(valor) {
		escudo = 100.min(escudo + valor)
		self.actualizarEscudo()
	}

	override method obtenerSalud(valor) {
		salud = 100.min(salud + valor)
		self.actualizarSalud()
	}

	override method equipar(_arma) {
		arma = _arma
		armaManager.quitar(_arma)
	}

	override method sufreDanio(_danio) {
		escudo -= _danio
		self.sufreDanioSiNoHayEscudo(_danio)
		self.muereSiNoHaySalud(_danio)
	}

	method sufreDanioSiNoHayEscudo(_danio) {
		if (escudo < 0) {
			salud += escudo
			escudo = 0
			self.actualizarSalud()
		}
		self.actualizarEscudo()
	}

	method parsePorcentaje(amount) {
		return if (amount == 0) "0" else if (amount <= 30) "1" else if (amount <= 45) "2" else if (amount <= 60) "3" else if (amount <= 75) "4" else if (amount <= 90) "5" else "6"
	}

	method actualizarEscudo() {
		shield.state(self.parsePorcentaje(escudo))
	}

	method actualizarSalud() {
		health.state(self.parsePorcentaje(salud))
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

	method mostrarMunicion() {
		return game.say(self, arma.municionText())
	}

}

