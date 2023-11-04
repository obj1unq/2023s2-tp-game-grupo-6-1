import wollok.game.*
import personaje.*
import enemigos.*
import armas.*
import managers.*
import ui.*
import gameClasses.*
import factories.*
import obstaculo.*

class Mapa { 
	
	method celdas()
	
	method generar() {
		game.width(self.celdas().anyOne().size())
		game.height(self.celdas().size())
		(0..game.width() -1).forEach({x =>
			(0..game.height() -1).forEach( {y =>
				self.generarCelda(x,y)
			})
		})
		game.addVisual(doomGuy)
	}
	
	method generarCelda(x,y) {
		const celda = self.celdas().get(y).get(x)
		celda.generar(game.at(x,y))
	}
	
	method aplicarConfiguraciones()
	
}

class ObjetoEnCelda{
	var objeto = null
	
	method nuevoObjeto()
	
	method generar(position){
		objeto = self.nuevoObjeto()
		objeto.position(position)
		game.addVisual(objeto)
	}
}

object _ inherits ObjetoEnCelda{//representa la celda vacia
	
	override method generar(position) {
	}	
	
	override method nuevoObjeto(){
		
	}
}

class EnemigoEnCelda inherits ObjetoEnCelda{
	override method generar(position) {
		super(position)
		enemigoManager.agregarEnemigo(objeto)
	}	
}

object c inherits EnemigoEnCelda{//representa al cacodemon
	
	override method nuevoObjeto(){
		return new Cacodemon(arma = new LanzaBolasFuego(), estado = "default", salud = 5000)
	}	
}

object l inherits EnemigoEnCelda {//representa al lostsoul
	
	override method nuevoObjeto(){
		return new LostSoul(arma = new Pistola(), estado = "default", salud = 1000)
	}	
}

object b inherits EnemigoEnCelda{//representa al baronhell
	override method nuevoObjeto(){
		return new BaronOfHell(arma = new LanzaBolasPlasma(), estado = "default", salud = 10000)
	}
}

object z inherits EnemigoEnCelda{//representa al zombie
	override method nuevoObjeto(){
		return new Zombie(arma = new Francotirador(), estado = "default", salud = 1000)
	}		
}

object m inherits ObjetoEnCelda{//representa al muro
	override method nuevoObjeto(){
		return new Muro(durabilidad = 10)
	}	
}

object e inherits ObjetoEnCelda{//representa al barrilExplosivo
	override method nuevoObjeto(){
		return new Barril()
	}		
}


object mapa1 inherits Mapa{
	
	override method celdas(){
		return [
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,_,z],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,z],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,_,z],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,z],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,_,z],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,z],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,_,z],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,z],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,_,z],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,z]				
	].reverse()
	}
	
	override method aplicarConfiguraciones(){
		
	}
}


object mapa2 inherits Mapa{
	override method celdas(){
		return [
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,l,_,c,_,_,z],
		[_,_,_,_,_,_,_,_,_,_,m,_,_,e,_,l,l,_,c,_,z,_],
		[_,_,_,_,_,_,_,_,_,_,m,_,_,_,_,l,l,_,c,_,_,z],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,l,_,c,_,z,_],
		[_,_,_,_,_,_,_,_,m,_,_,_,_,e,_,l,_,_,c,_,_,z],		
		[_,_,_,_,_,_,_,_,m,_,_,_,_,_,_,l,_,_,c,_,z,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,l,_,c,_,_,z],
		[_,_,_,_,_,_,_,_,_,_,m,_,_,e,_,l,l,_,c,_,z,_],
		[_,_,_,_,_,_,_,_,_,_,m,_,_,_,_,l,l,_,c,_,_,z],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,l,_,c,_,z,_]				
	].reverse()
	}
	
	override method generar(){
		super()
		UIController.quitarUI(loading)
	}
	
	override method aplicarConfiguraciones(){
		saludManager.agregarFactory(saludMedianaFactory)
		escudoManager.agregarFactory(escudoMedianoFactory)
		armaManager.agregarFactory(minigunFactory)
	}
}

object mapa3 inherits Mapa{
	override method celdas(){
		return [
		[_,_,_,_,_,_,_,_,_,_,_,_,b,_,_,_,z,_,_,_,_,z],
		[_,_,_,_,_,_,_,_,_,e,_,_,_,c,_,_,_,z,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,e,_,_,b,_,_,_,_,_,_,_,_,z],
		[_,_,_,_,_,_,_,m,_,_,_,_,_,c,_,_,_,z,_,_,_,_],
		[_,_,_,_,_,_,_,m,_,_,_,_,b,_,_,_,_,_,_,z,_,_],		
		[_,_,_,_,_,_,_,m,_,_,_,_,_,c,_,_,_,z,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,b,_,_,_,_,_,_,_,_,z],
		[_,_,_,_,_,_,_,_,_,e,_,_,_,c,_,_,_,_,_,z,_,_],
		[_,_,_,_,_,_,_,_,_,e,_,_,b,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,c,_,z,_,_,_,_,_,z]				
	].reverse()
	}
	
	override method generar(){
		super()
		UIController.quitarUI(loading)
	}
	
	override method aplicarConfiguraciones(){
	}
}


object mapa4 inherits Mapa{
	override method celdas(){
		return [
		[_,_,_,_,_,_,_,_,l,_,m,_,_,b,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,m,_,_,b,_,_,l,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,l,_,m,_,_,c,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,e,_,b,_,_,l,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,l,_,_,e,_,b,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,e,_,c,_,_,l,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,l,_,_,e,_,b,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,m,_,_,b,_,_,l,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,l,_,m,_,_,c,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,m,_,_,b,_,_,l,_,_,_,_,_]				
	].reverse()
	}
	
	override method generar(){
		super()
		UIController.quitarUI(loading)
	}
	
	override method aplicarConfiguraciones(){
		saludManager.agregarFactory(saludGrandeFactory)
		escudoManager.agregarFactory(escudoGrandeFactory)
		armaManager.agregarFactory(lanzamisilesFactory)
	}
}


object mapa5 inherits Mapa{
	override method celdas(){
		return [
		[_,_,_,_,_,_,_,_,_,_,_,m,_,l,b,_,_,c,_,_,z,_],
		[_,_,_,_,_,_,_,_,e,_,_,m,_,l,b,_,_,c,_,_,_,z],
		[_,_,_,_,_,_,_,_,_,_,_,m,_,l,b,_,_,c,_,_,z,_],
		[_,_,_,_,_,_,_,_,e,_,_,m,_,l,b,_,_,c,_,_,_,z],
		[_,_,_,_,_,_,_,_,_,_,_,m,_,l,b,_,_,c,_,_,z,_],		
		[_,_,_,_,_,_,_,_,e,_,_,m,_,l,b,_,_,c,_,_,_,z],		
		[_,_,_,_,_,_,_,_,_,_,_,m,_,l,b,_,_,c,_,_,z,_],
		[_,_,_,_,_,_,_,_,e,_,_,m,_,l,b,_,_,c,_,_,_,z],
		[_,_,_,_,_,_,_,_,_,_,_,m,_,l,b,_,_,c,_,_,z,_],
		[_,_,_,_,_,_,_,_,e,_,_,m,_,l,b,_,_,c,_,_,_,z]				
	].reverse()
	}
	
	override method generar(){
		super()
		UIController.quitarUI(loading)
	}
	
	override method aplicarConfiguraciones(){
	}
}


