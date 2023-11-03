import gameClasses.*
import wollok.game.*
import personaje.*
import direcciones.*

class Muro inherits Visual {
	var durabilidad
	
	method durabilidad(){
		return durabilidad
	}
	
	override method image(){
		//return IMAGEN
	}
	
	override method sufrirImpacto(municion){
		if (municion.causante().equals(doomGuy)) {
			durabilidad -= 1
			super(municion)
			self.destruirseSiCorresponde()
		}
	}
	
	method destruirseSiCorresponde(){
		if (durabilidad <= 0){
			game.removeVisual(self)
		} 
	}
}

class Barril inherits Visual{
	
	method danio(){
		return 500
	}
	
	override method image(){
		//return IMAGEN
	}
	
	override method sufrirImpacto(municion){
		if (municion.causante().equals(doomGuy)) {
			super(municion)
			self.explotar()
		}
	}
	
	method explotar(){
		self.danioExplosion()
		game.removeVisual(self)
		//hacer imagen explosion
	}
	
	method danioExplosion(){
		self.objetosEnRadioExplosion().forEach({objeto => objeto.sufrirImpacto(self)})
	}
	
	method objetosEnRadioExplosion(){
		const direcciones = [new Arriba(), new Abajo(), new Izquierda(), new Derecha()]
		return self.ObjetosEn(direcciones, direcciones.size())
	}
	
	//es valido recursion?
	//PROBAR EN JUEGO SI FUNCIONA
	method ObjetosEn(direcciones, indice){
		const objetosHastaAhora = []
		if(indice >= 0){
			objetosHastaAhora.addAll(game.getObjectsIn(direcciones.get(indice).mover(self.position())))
			self.ObjetosEn(direcciones, (indice - 1))
		}
		objetosHastaAhora.addAll(game.getObjectsIn(self.position()))
		return objetosHastaAhora
	}
}
