import wollok.game.*
import gameClasses.*

class Municion {

	var property position = game.at(0, 0)
	var property estado
	var agarrable = false
	var ataque
	var rango

	method image()

	method mover(direccion) {
		self.position(direccion.mover(self.position()))
		game.onCollideDo(self, { objeto => objeto.sufrirImpacto(self)})
	}

	method terminarMovimiento() {
		if (game.hasVisual(self)) {
			game.removeTickEvent("disparo_" + self.identity())
			game.removeVisual(self)
		}
	}

	method generar(_position, direccion) {
		self.estado(direccion.devolverDireccion())
		self.posicionar(_position, direccion)
		game.addVisual(self)
		self.viajar(direccion)
	}

	method sufrirImpacto(causante) {
	}

	method posicionar(_position, direccion) {
		const siguiente = direccion.mover(_position)
		self.position(siguiente)
	}

	method moverSiPresenteEnTablero(direccion) {
		if (game.hasVisual(self)) {
			self.mover(direccion)
		}
	}

	method efectoPostImpacto()

	method danio() {
		return ataque
	}

	method viajar(direccion)

}

class Bala inherits Municion {

	override method image() {
		//return "bala/bala_" + self.estado() + ".png"
		return "bala.png"
	}

	override method efectoPostImpacto() {
		self.terminarMovimiento()
	}

	override method viajar(direccion) {
		game.onTick(200, "disparo_" + self.identity(), {=> self.mover(direccion)})
		game.schedule(200 * rango, {=> self.terminarMovimiento()})
	}

}

class Misil inherits Municion {

	override method image() {
		return "misil/misil_" + self.estado() + ".png"
	}

	override method efectoPostImpacto() {
		self.activarAnimacionExplosion()
	}

	override method viajar(direccion) {
		game.onTick(200, "disparo_" + self.identity(), {=> self.mover(direccion)})
		game.schedule(200 * rango, {=> self.terminarMovimiento()})
	}

	method activarAnimacionExplosion() {
		const animacionMuerte = new AnimacionMuerte()
		animacionMuerte.animacion((1 .. 3), 100, self)
	}

	method accionPostMuerte() {
		self.terminarMovimiento()
	}

	method accionDuranteMuerte(fases) {
		self.estado("explosion_" + fases.first())
		fases.remove(fases.first())
	}

}

class Argent inherits Municion { //Municion de la BFG

	override method image() {
		return "argent/argent_" + self.estado() + ".png"
	}

	override method efectoPostImpacto() {
		self.activarAnimacionExplosion()
	}

	override method viajar(direccion) {
		game.onTick(200, "disparo_" + self.identity(), {=> self.mover(direccion)})
		game.schedule(200 * rango, {=> self.terminarMovimiento()})
	}

	method activarAnimacionExplosion() {
		const animacionMuerte = new AnimacionMuerte()
		animacionMuerte.animacion((1 .. 6), 100, self)
	}

	method accionPostMuerte() {
		self.terminarMovimiento()
	}

	method accionDuranteMuerte(fases) {
		self.estado("explosion_" + fases.first())
		fases.remove(fases.first())
	}

	override method mover(direccion) {
		self.position(direccion.mover(self.position()))
		game.onCollideDo(self, { objeto => self.matarATodos()})
	}

	method matarATodos() {
		const objects = game.allVisuals()
		objects.forEach({ _object => _object.sufrirImpacto(self)})
	}

}

