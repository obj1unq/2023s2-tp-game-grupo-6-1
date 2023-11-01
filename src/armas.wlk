import wollok.game.*
import municiones.*
import personaje.*
//Templeate clases
class Arma{
	const agarrable = true
	method danio()
	
	method image()
	method usar(personaje, direccionPJ)
	
	method agarrado(personaje){
		personaje.equipar(self)
	}
}

class Bomba inherits Arma{
	
}

class ArmaDistancia inherits Arma{
	method tipoMunicion()
	method municionDisponible()
	method municionEnCargador()
	method recargar()
	
	
	method recargando(){
		return self.municionEnCargador() == 0
	}
	
	method validarSuficienteMunicion(){
		if (self.municionDisponible() == 0){
			self.error("No hay mas municion")
		}
	}
	method validarRecarga(){
		if (self.recargando()){
			self.error("Recargando")
		}
	}
}

class ArmaMelee inherits Arma{
	method durabilidad()
	method efectoPostImpacto()
}

//Clases armas melee
class Motosierra inherits ArmaMelee{
	var durabilidad = 3
	
	override method danio(){
		//return valordanio
	}
	
	override method durabilidad(){
		return durabilidad
	}
	
	override method image(){
		//return imagen
	}
	
	override method usar(personaje, direccionPJ){
		self.validarDurabilidad()
		//self.daniar()
	}
	
	override method efectoPostImpacto(){
		durabilidad -= 1
	}
	
	method validarDurabilidad(){
		if (durabilidad == 0){
			self.error("Tu motosierra demoniaca no tiene mas usos!")
		}
	}
	
//	method daniar(){
//		animacionManager.animacion(self)
//		personaje.sufrirImpacto(self)
//		self.efectoPostImpacto()
//	}
}

//Clases armas distancia
class Pistola inherits ArmaDistancia{
	var municionDisponible = 70
	var municionCargador = 7
	
	override method tipoMunicion(){
		return new Bala(ataque = 10, causante = doomGuy)
	}
	
	override method municionDisponible(){
		return municionDisponible
	}
	
	override method municionEnCargador(){
		return municionCargador
	}
	
	override method danio(){
		self.tipoMunicion().danio()
	}
	
	override method usar(personaje, direccionPJ){
		self.validarSuficienteMunicion()
		if (!self.recargando()) {
			self.tipoMunicion().generar(personaje.position(), direccionPJ)
			municionCargador -= 1
		}else{
			game.schedule(1000, {self.recargar()})
			self.validarRecarga()
		}
	}
	
	override method recargar(){
		municionDisponible = 0.max(municionDisponible - 7)
		municionCargador = 7.min(municionDisponible)
	}
	
	override method image(){
		return "assets/pistola.png"
	}
}