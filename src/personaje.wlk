import armas.*
import wollok.game.*
import gameClasses.*

class Personaje {

	var arma
	var property estado
	var salud
	var property position
	var agarrable = false

	method image()

	method atacar() {
		arma.usar()
	}

	method sufreDanio(danio)

	method morir()

	method mover(direccion)

	method sufrirImpacto(causante)

	method efectoPostImpacto()

	method validarMover(direccion)

	method muereSiNoHaySalud(danio)

	method activarAnimacionMuerte()

	method personajeHaDeMorir(danio)

	method agarrable() {
		return agarrable
	}

	method accionPostMuerte()

	method accionDuranteMuerte(fases)

	method accionPostAtaque()

	method accionDuranteAtaque(fases)

	method accionPostMovimiento()

	method accionDuranteMovimiento(fases)

}

object doomGuy inherits Personaje(arma = new Pistola(), estado = 'vivo_abajo_disparando', salud = 100, position = game.origin()) {

	var escudo = 100
	var bombas = []
	var ultimaDireccion = new Abajo()
	var puedeMoverse = true
	var enMovimiento = false

	method image() {
		return "doomguy/doomguy_" + self.estado() + ".png"
	}

	method agarrar() {
		const objetosEncontrados = self.devolverObjetosEnPosicion()
		self.validarSiHayObjetos(objetosEncontrados)
		self.validarSiEsObjetoAgarrable(objetosEncontrados.first())
		objetosEncontrados.first().agarrado(self)
	}

	method devolverObjetosEnPosicion() {
		return game.colliders(self)
	}

	method validarSiHayObjetos(objetos) {
		if (objetos.isEmpty()) {
			self.error("Here's nothing")
		}
	}

	method validarSiEsObjetoAgarrable(objeto) {
		if (!objeto.agarrable()) {
			self.error("I can't grab this")
		}
	}

	method estadisticas() {
		return game.say(self, "escudo: " + escudo.toString() + " salud: " + salud.toString() + " arma:" + arma.toString())
	}

	override method sufrirImpacto(causante) {
		self.sufreDanio(causante.danio())
		causante.efectoPostImpacto()
	}

	override method sufreDanio(_danio) {
		self.sufrirDanioSiHayEscudo(_danio)
		self.sufrirDanioSiNoHayEscudoYHaySalud(_danio)
		self.muereSiNoHaySalud(_danio)
	}

	method sufrirDanioSiHayEscudo(_danio) {
		if (self.haDeSufrirElEscudo(_danio)) {
			escudo -= _danio
		}
	}

	method haDeSufrirElEscudo(_danio) {
		return escudo - _danio >= 0 && salud > 0
	}

	method sufrirDanioSiNoHayEscudoYHaySalud(_danio) {
		if (self.haDeSufrirLaSalud(_danio)) {
			escudo = 0
			salud -= _danio
		}
	}

	method haDeSufrirLaSalud(_danio) {
		return escudo - _danio < 0 && salud - _danio >= 0
	}

	override method muereSiNoHaySalud(_danio) {
		if (self.personajeHaDeMorir(_danio)) {
			self.morir()
		}
	}

	override method personajeHaDeMorir(_danio) {
		return escudo == 0 && salud > 0 && salud - _danio < 0
	}

	override method morir() {
		salud = 0
		puedeMoverse = false
		self.activarAnimacionMuerte()
	}

	override method activarAnimacionMuerte() {
		const animacionMuerte = new AnimacionMuerte()
		animacionMuerte.animacion((1 .. 7), 100, self)
	}

	override method accionDuranteMuerte(fases){
		self.estado("muerto_" + fases.first())
			fases.remove(fases.first())
	}
	

	override method mover(direccion) {
		const siguiente = direccion.mover(self.position())
		self.validarMover(siguiente)
		self.establecerValoresDeCambioDePosicion(direccion)
		self.moverConAnimacion(siguiente, direccion)
		self.activarSecuenciaCambioPosicion(direccion, [ 1 ])
	}

	override method validarMover(posicion) {
		if (!self.personajePuedeMoverseA(posicion)) {
			self.error("I can't go there")
		}
	}

	method personajePuedeMoverseA(posicion) {
		return not enMovimiento && salud > 0 && tablero.pertenece(posicion)
	}

	method establecerValoresDeCambioDePosicion(direccion) {
		enMovimiento = true
		ultimaDireccion = direccion
	}

	method moverConAnimacion(posicionAMover, direccionAMover) {
		game.schedule(210, { enMovimiento = false})
		game.schedule(100, {=> self.position(posicionAMover)})
		game.schedule(150, {=> self.activarSecuenciaCambioPosicion(direccionAMover, [ 2, "normal", "disparando" ])})
	}

	method activarSecuenciaCambioPosicion(direccion, fases) {
		const animacionMovimiento = new AnimacionMovimiento()
		animacionMovimiento.animacion(fases, 50, self)
	}

	override method accionDuranteMovimiento(fases) {
		if (fases.size() > 0) {
			self.estado("vivo_" + ultimaDireccion.devolverDireccion() + "_" + fases.first())
			fases.remove(fases.first())
		}
	}

	method usarBomba() {
		self.verificarSiHayBombas()
		self.activarBomba(bombas.first())
	}

	method verificarSiHayBombas() {
		if (bombas.isEmpty()) {
			self.error("I have no more bombs")
		}
	}

	method activarBomba(_bomba) {
		_bomba.explotar(self)
		bombas.remove(bombas.first())
	}

}

