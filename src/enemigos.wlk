import personaje.*
import wollok.game.*
import gameClasses.*
import direcciones.*
import managers.*
import armas.*

class Enemigo inherits Personaje {

	override method sufreDanio(_danio) {
		salud -= _danio
		self.muereSiNoHaySalud(_danio)
		self.mostrarSaludSiCorresponde()
	}

	method mostrarSaludSiCorresponde() {
		if (salud > 0) {
			game.say(self, salud.toString())
		}
	}

	override method morir() {
		super()
		game.schedule(300, { enemigoManager.quitar(self)})
	}

	method velocidad()

	method velDisparo()

	override method mover(direccion) {
		super(direccion)
		nivelController.ejecutarGameOverSiEnZonaDoomguy(self.position())
	}

	override method sufrirImpacto(municion) {
		if (municion.causante().equals(doomGuy)) {
			super(municion)
		}
	}

	override method obtenerSalud(valor) {
	}

	override method obtenerEscudo(valor) {
	}

	override method equipar(_arma) {
	}

}

class LostSoul inherits Enemigo {

	override method image() {
		return "lostSoul/lostSoul_" + self.estado() + ".png"
	}

	override method dispararSiEstaVivo(direccionAAtacar) {
	}

	override method velocidad() {
		return 0
	}

	override method velDisparo() {
		return 0
	}

}

class Cacodemon inherits Enemigo {

	override method image() {
		return "cacodemon/cacodemon_" + self.estado() + ".png"
	}

	override method velocidad() {
		return 3000
	}

	override method velDisparo() {
		return 1000
	}

}

class BaronOfHell inherits Enemigo {

	override method image() {
		return "baron/baron_" + self.estado() + ".png"
	}

	override method velocidad() {
		return 3000
	}

	override method velDisparo() {
		return 3000
	}

}

class Zombie inherits Enemigo {

	override method image() {
		return "zombie/zombie_" + self.estado() + ".png"
	}

	override method velocidad() {
		return 60 * 1000
	}

	override method velDisparo() {
		return 3000
	}

}

object cyberDemon inherits Enemigo(arma = new LanzaMisilesBoss(), estado = "default", salud = 5000) {

	var muriendo = false

	;

	override method image() {
		return "cyberdemon/cyberdemon_" + self.estado() + ".png"
	}

	override method velocidad() {
		return 25000
	}

	override method velDisparo() {
		return 0
	}

	method esquivar() {
		self.position(self.posicionDeEsquive())
	}

	method posicionDeEsquive() {
		return game.at(self.position().x(), self.posicionRandomEnY())
	}

	method posicionRandomEnY() {
		return (0 .. (game.height() - 2)).anyOne()
	}

	override method morir() {
		if (!muriendo) {
			muriendo = true
			const fases = [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
			game.onTick(150, "MUERTE_BOSS", { self.estado("muerto_" + fases.first().toString())
				fases.remove(fases.first())
			})
			game.schedule(fases.size() * 150 + 150, { game.removeTickEvent("MUERTE_BOSS")
				enemigoManager.quitar(self)
			})
		}
	}

}

