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
		return "assets/barril/barril_default.png"
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
	var property estado = "default"
	
	method danio(){
		return 500
	}
	
	override method image(){
		return "assets/barril/barril_" + self.estado() + ".png"
	}
	
	override method sufrirImpacto(municion){
		if (municion.causante().equals(doomGuy)) {
			super(municion)
			self.estado("muerto")
			self.explotar() //PUESTO PARA PROBAR TEST
			//game.schedule(500, {self.explotar()}) //ACTIVAR CUANDO ANDE EL JUEGO 
			//hace que se vea la imagen del barril por explotar medio segundo y luego hace la explosion
		}
	}
	
	method explotar(){
		game.removeVisual(self)
		self.danioExplosion()
	}
	
	method danioExplosion(){
		self.objetosEnRadioExplosion().forEach({objeto => objeto.sufreDanio(self.danio())})
	}
	
	method objetosEnRadioExplosion(){
		const direcciones = [new Arriba(), new Abajo(), new Izquierda(), new Derecha()]
		return self.ColectorObjetosEn(direcciones, (direcciones.size() - 1), [])
	}
	
	//es valido recursion?
	method ColectorObjetosEn(direcciones, indice, lista){
		if(indice >= 0){
			lista.addAll(game.getObjectsIn(direcciones.get(indice).mover(self.position())))
			self.ColectorObjetosEn(direcciones, (indice - 1), lista)
		}
		lista.addAll(game.getObjectsIn(self.position()))
		return lista
	}
}
