import wollok.game.*
import municiones.*
import gameClasses.*
import personaje.*

//Templeate clases
class ArmaPersonaje inherits Visual {

	const tiempoRecarga
	const municionMaxCargador
	var municionDisponible
	var municionCargador

	method danio()

	method tipoMunicion(_causante)

	method agarrable() {
		return true
	}

	method agarrado(personaje) {
		personaje.equipar(self)
	}

	method municionCargador() {
		return municionCargador
	}

	method municionDisponible() {
		return municionDisponible
	}
	
	method recargaParcial(){
		municionDisponible = municionDisponible - (municionMaxCargador - municionCargador)
		municionCargador = municionMaxCargador.min(municionDisponible)
	}
	
	method recargar(){
		municionCargador = municionMaxCargador.min(municionDisponible)
		municionDisponible = 0.max(municionDisponible - municionMaxCargador)
	}

	method necesitaRecarga() {
		return municionCargador == 0
	}

	method validarSuficienteMunicion() {
		if (municionDisponible == 0) {
			self.error("No hay mas municion")
		}
	}

	method validarRecarga() {
		if (self.necesitaRecarga()) {
			self.error("Recargando")
		}
	}

	method usar(personaje, direccionPJ) {
		self.validarSuficienteMunicion()
		if (!self.necesitaRecarga()) {
			self.dispararBala(personaje, direccionPJ)
		}else{
			game.schedule(tiempoRecarga, {self.recargar()})
			self.validarRecarga()
		}
	}
	
	method dispararBala(causante, direccionBala){
			const municion = self.tipoMunicion(causante)
			game.addVisual(municion)
			municion.position(causante.position())
			municion.viajarImpactando(direccionBala)
			municionCargador -= 1
	}
	
	override method sufrirImpacto(municion){
		municion.causante().equipar(self)
		if(municion.causante().equals(doomGuy)){
			super(municion)
		}
	}

}

class ArmaEnemigo inherits Visual {

	method danio()

	method tipoMunicion(_causante)

	method agarrable() {
		return false
	}

	method usar(personaje, direccionPJ) {
		const municion = self.tipoMunicion(personaje)
		game.addVisual(municion)
		municion.position(personaje.position())
		municion.viajarImpactando(direccionPJ)
	}

	
}

//Armas personajePrincipal
class Pistola inherits ArmaPersonaje(tiempoRecarga = 1000, municionDisponible = 30, municionCargador = 7, municionMaxCargador = 7) {

	override method tipoMunicion(_causante) {
		return new Bala(causante = _causante, ataque = self.danio())
	}

	override method danio() {
		return 50
	}

	override method image() {
		return "assets/armas/pistola_default.png"
	}

}

class LanzaMisiles inherits ArmaPersonaje(tiempoRecarga = 2000, municionDisponible = 9, municionCargador = 1, municionMaxCargador = 3) {

	override method tipoMunicion(_causante) {
		return new Misil(causante = _causante, ataque = self.danio())
	}

	override method danio() {
		return 500
	}

	override method image() {
		return "assets/armas/lanzamisiles_default.png"
	}

}

class BFG inherits ArmaPersonaje(tiempoRecarga = 3000, municionDisponible = 6, municionCargador = 1, municionMaxCargador = 3){
	override method tipoMunicion(_causante){
		return new Argent(causante = _causante, ataque = self.danio())
	}

	override method danio() {
		return 2000
	}

	override method image() {
		return "assets/armas/bfg_default.png"
	}

}

class Minigun inherits Pistola(tiempoRecarga = 2500, municionDisponible = 140, municionCargador = 70, municionMaxCargador = 70){
	
	override method usar(personaje, direccionPJ){
		self.validarSuficienteMunicion()
		if (self.hayMunicionSuficienteCargador(3)) {
			self.dispararBalas(3, personaje, direccionPJ)
		} else {
			// SI QUEDAN BALAS EN EL CARGADOR, SE PIERDEN POR FUNCIONAMIENTO DE UNA MINIGUN
			game.schedule(tiempoRecarga, { self.recargar()})
			self.validarRecarga()
		}
	}

	method hayMunicionSuficienteCargador(cantidad) {
		return municionCargador >= cantidad
	}
	
	method dispararBalas(cantidad, personaje, direccionPJ){
		if (cantidad > 0){
			self.dispararBala(personaje, direccionPJ)
			game.schedule(300, {self.dispararBalas(cantidad - 1, personaje, direccionPJ)})
		}
	}

	override method validarRecarga() {
		if (!self.hayMunicionSuficienteCargador(3)) {
			self.error("Recargando")
		}
	}

	override method image() {
		return "assets/armas/minigun_default.png"
	}

}

//Armas enemigos
class Francotirador inherits ArmaEnemigo {

	override method tipoMunicion(_causante) {
		return new BalaFrancotirador(causante = _causante, ataque = self.danio())
	}

	override method danio() {
		return 75
	}

	override method image() {
	}

}

class LanzaBolasFuego inherits ArmaEnemigo {

	override method tipoMunicion(_causante) {
		return new BolaDeFuego(causante = _causante, ataque = self.danio())
	}

	override method danio() {
		return 50
	}

	override method image() {
	// NO TIENE IMAGEN PARA QUE NO ES UN ARMA COMO TAL SINO LA HABILIDAD DEL ENEMIGO PARA DANIAR
	}

}

class LanzaBolasPlasma inherits ArmaEnemigo {

	override method tipoMunicion(_causante) {
		return new BolaDePlasma(causante = _causante, ataque = self.danio())
	}

	override method danio() {
		return 60
	}

	override method image() {
	// NO TIENE IMAGEN PARA QUE NO ES UN ARMA COMO TAL SINO LA HABILIDAD DEL ENEMIGO PARA DANIAR
	}
}
class LanzaMisilesBoss inherits ArmaEnemigo{
	override method tipoMunicion(_causante){
		return new MisilBoss(causante = _causante, ataque = self.danio())
	}
	
	override method danio(){
		return 100
	}
	
	override method image(){
	}
}
