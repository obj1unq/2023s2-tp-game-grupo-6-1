import personaje.*
import wollok.game.*
import gameClasses.*
import direcciones.*
import managers.*


class Enemigo inherits Personaje {

	override method sufreDanio(_danio) {
		salud -= _danio
		self.muereSiNoHaySalud(_danio)
	}

	override method morir() {
		super()
		game.schedule(300, { enemigoManager.quitar(self)})
	}

	method velocidad()

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
	
	override method dispararSiEstaVivo(direccionAAtacar){
		
	}

	override method velocidad(){
		return 1000
	}

}

class Cacodemon inherits Enemigo {

	override method image() {
		return "cacodemon/cacodemon_" + self.estado() + ".png"
	}
	
	override method velocidad(){
		return 5000
	}

}

class BaronOfHell inherits Enemigo {

	override method image() {
		return "baron/baron_" + self.estado() + ".png"
	}
	
	override method velocidad(){
		return 8000
	}

}


class Zombie inherits Enemigo {

	override method image() {
		return "zombie/zombie_" + self.estado() + ".png"
	}

	override method velocidad(){
		return 60 * 1000
	}

}

