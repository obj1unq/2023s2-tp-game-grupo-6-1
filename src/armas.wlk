import wollok.game.*
import municiones.*
import gameClasses.*

//Templeate clases
class ArmaPersonaje inherits Visual{
	const tiempoRecarga
	const municionMaxCargador
	var municionDisponible
	var municionCargador

	method danio()
	method tipoMunicion(_causante)
	
	method agarrable(){
		return true
	}
	
	method agarrado(personaje){
		personaje.equipar(self)
	}
	
	method municionCargador(){
		return municionCargador
	}
	
	method municionDisponible(){
		return municionDisponible
	}
	
	method recargar(){
		municionCargador = municionMaxCargador.min(municionDisponible)
		municionDisponible = 0.max(municionDisponible - municionMaxCargador)
	}
	
	method necesitaRecarga(){
		return municionCargador == 0
	}
	
	method validarSuficienteMunicion(){
		if (municionDisponible == 0){
			self.error("No hay mas municion")
		}
	}
	
	method validarRecarga(){
		if (self.necesitaRecarga()){
			self.error("Recargando")
		}
	}
	
	method usar(personaje, direccionPJ){
		self.validarSuficienteMunicion()
		if (!self.necesitaRecarga()) {
			const municion = self.tipoMunicion(personaje)
			game.addVisual(municion)
			municion.position(personaje.position())
			municion.viajarImpactando(direccionPJ)
			municionCargador -= 1
		}else{
			game.schedule(tiempoRecarga, {self.recargar()})
			self.validarRecarga()
		}
	}
}

class ArmaEnemigo inherits Visual{
	method danio()
	method tipoMunicion(_causante)
	
	method agarrable(){
		return false
	}
	
	method usar(personaje, direccionPJ){
		const municion = self.tipoMunicion(personaje)
		municion.viajarImpactando(direccionPJ)
	}
}

//Armas personajePrincipal
class Pistola inherits ArmaPersonaje(tiempoRecarga = 1000, municionDisponible = 70, municionCargador = 7, municionMaxCargador = 7){
	override method tipoMunicion(_causante){
		return new Bala(causante = _causante, ataque = self.danio())
	}
	
	override method danio(){
		return 50
	}
	
	override method image(){
		return "assets/armas/pistola_default.png"
	}
}

class LanzaMisiles inherits ArmaPersonaje(tiempoRecarga = 5000, municionDisponible = 3, municionCargador = 1, municionMaxCargador = 1){
	override method tipoMunicion(_causante){
		return new Misil(causante = _causante, ataque = self.danio())
	}
	
	override method danio(){
		return 10000
	}
	
	override method image(){
		return "assets/armas/lanzamisiles_default.png"
	}
}

//LA BALANCEA MAXI
class BFG inherits ArmaPersonaje(tiempoRecarga = 5000, municionDisponible = 3, municionCargador = 1, municionMaxCargador = 1){
	override method tipoMunicion(_causante){
		return new Argent(causante = _causante, ataque = self.danio())
	}
	
	override method danio(){
		return 10000
	}
	
	override method image(){
		return "assets/armas/bfg_default.png"
	}
}

class Minigun inherits Pistola(tiempoRecarga = 3500, municionDisponible = 150, municionCargador = 75, municionMaxCargador = 75){
	
	override method usar(personaje, direccionPJ){
		self.validarSuficienteMunicion()
		if (self.hayMunicionSuficienteCargador(3)) {
			self.dispararBalas(3, personaje, direccionPJ)
		}else{
			//SI QUEDAN BALAS EN EL CARGADOR, SE PIERDEN POR FUNCIONAMIENTO DE UNA MINIGUN
			game.schedule(tiempoRecarga, {self.recargar()})
			self.validarRecarga()
		}
	}
	
	method hayMunicionSuficienteCargador(cantidad){
		return municionCargador >= cantidad
	}
	
	//es valido usar recursion? 
	method dispararBalas(cantidad, _personaje, _direccionPJ){
		if (cantidad > 0){
			const municion = self.tipoMunicion(_personaje)
			game.addVisual(municion)
			municion.position(_personaje.position())
			municion.viajarImpactando(_direccionPJ)
			municionCargador -= 1
			self.dispararBalas(cantidad - 1, _personaje, _direccionPJ)
		}
	}
	
	override method validarRecarga(){
		if(!self.hayMunicionSuficienteCargador(3)){
			self.error("Recargando")
		}
	}
	
	override method image(){
		return "assets/armas/minigun_default.png"
	}
}

//Armas enemigos
class Francotirador inherits ArmaEnemigo{
	override method tipoMunicion(_causante){
		return new BalaFrancotirador(causante = _causante, ataque = self.danio())
	}
	
	override method danio(){
		return 100
	}
	
	override method image(){
		//return "assets/pistola.png" IMAGEN FRANCOTIRADOR
	}
}

class LanzaBolasFuego inherits ArmaEnemigo{
	override method tipoMunicion(_causante){
		return new BolaDeFuego(causante = _causante, ataque = self.danio())
	}
	
	override method danio(){
		return 50
	}
	
	override method image(){
		//NO TIENE IMAGEN PARA QUE NO ES UN ARMA COMO TAL SINO LA HABILIDAD DEL ENEMIGO PARA DANIAR
	}
}

class LanzaBolasPlasma inherits ArmaEnemigo{
	override method tipoMunicion(_causante){
		return new BolaDePlasma(causante = _causante, ataque = self.danio())
	}
	
	override method danio(){
		return 75
	}
	
	override method image(){
		//NO TIENE IMAGEN PARA QUE NO ES UN ARMA COMO TAL SINO LA HABILIDAD DEL ENEMIGO PARA DANIAR
	}
}