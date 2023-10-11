import armas.*
import wollok.game.*

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

	method sufrirImpacto(danio)

	method validarMover(direccion)

	method muereSiNoHaySalud(danio)

	method activarAnimacionMuerte()

	method personajeHaDeMorir(danio)

	method agarrable() {
		return agarrable
	}

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
		agarrableManager.asignarObjetoADoomguy(objetosEncontrados.first())
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

	override method sufrirImpacto(danio) {
		self.sufreDanio(danio)
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
	
	override method activarAnimacionMuerte(){
		var count = 0
		const fases = (1 .. 7)
		game.schedule(fases.size() * 100 + 100, {=>
			game.removeTickEvent("secuenciaMuerte_doomguy")
		})
		game.onTick(100, "secuenciaMuerte_doomguy", { self.estado("muerto_" + fases.get(count))
			count++
		})
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
		game.schedule(fases.size() * 50 + 50, {=> game.removeTickEvent("secuenciaPosicion_doomguy")})
		game.onTick(50, "secuenciaPosicion_doomguy", { self.cambiarSecuenciaPosicionSiCorresponde(direccion, fases)})
	}

	method cambiarSecuenciaPosicionSiCorresponde(direccion, fases) {
		if (fases.size() > 0) {
			self.estado("vivo_" + direccion.devolverDireccion() + "_" + fases.first())
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

