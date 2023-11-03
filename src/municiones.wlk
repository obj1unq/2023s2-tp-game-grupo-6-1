import wollok.game.*
import gameClasses.*
import managers.*

class Municion inherits Visual {

	var ataque
	var causante
	var property estado = "derecha" //la inicio con valor para no tener conflictos pero siempre se actualiza cuando disparan

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
	
	method moverSiPerteneceAlTablero(direccion){
		if(tablero.pertenece(self.position())){
			self.mover(direccion)
		}else{
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
		game.onTick(self.velocidadMovimiento(), "disparo_" + self.identity(), {=> self.moverSiPerteneceAlTablero(direccion)
		self.impactar()})	
	}
	
	method velocidadMovimiento()
	
	method impactar(){
		game.colliders(self).forEach({objeto => objeto.sufrirImpacto(self)})
	}
	
	override method sufrirImpacto(municion) {
	}

}

class Bala inherits Municion {

	override method image() {
		return "assets/municiones/bala_" + self.estado() + "_default.png"
	}

	override method velocidadMovimiento(){
		return 200
	}
	
}

class BalaFrancotirador  inherits Bala {

	override method velocidadMovimiento(){
		return 100
	}
	
}

class BolaDeFuego inherits Bala {

	override method image() {
		return "assets/municion/bala_fuego_default.png"
	}
	
	//a futuro puede que genere un efecto de quemado
}

class BolaDePlasma inherits Bala {

	override method image() {
		return "assets/municiones/bola_plasma_default.png"
	}
	
	//a futuro puede que genere un efecto de reduccion bala o algo asi
}

class Misil inherits Municion {

	override method image() {
		return "assets/municiones/misil_" + self.estado() +  "_default.png"
	}
	
	override method velocidadMovimiento(){
		return 100
	}
	//a futuro puede que genere un efecto de dañar celdas lindantes

}

class Argent inherits Municion { //Municion de la BFG

	override method image() {
		return "assets/municiones/argent_default.png"
	}

	override method velocidadMovimiento(){
		return 500
	}
	
	override method impactar(){
	 	enemigoManager.generados().forEach({objeto => objeto.sufrirImpacto(self)})
	}

}

