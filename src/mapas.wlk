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
		game.cellSize(80)
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
		return new Cacodemon(arma = new LanzaBolasFuego(), estado = "default", salud = 200)
	}	
}

object l inherits EnemigoEnCelda {//representa al lostsoul
	
	override method nuevoObjeto(){
		return new LostSoul(arma = new Pistola(), estado = "default", salud = 100)
	}	
}

object b inherits EnemigoEnCelda{//representa al baronhell
	override method nuevoObjeto(){
		return new BaronOfHell(arma = new LanzaBolasPlasma(), estado = "default", salud = 200)
	}
}

object z inherits EnemigoEnCelda{//representa al zombie
	override method nuevoObjeto(){
		return new Zombie(arma = new Francotirador(), estado = "default", salud = 300)
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
		//17x10
		//1360x800
		return [
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_]			
	].reverse()
	}
	
	override method aplicarConfiguraciones(){
		
	}
}


object mapa2 inherits Mapa{
	override method celdas(){
		return [
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_]				
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
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_]				
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
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_]					
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
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_]				
	].reverse()
	}
	
	override method generar(){
		super()
		UIController.quitarUI(loading)
	}
	
	override method aplicarConfiguraciones(){
	}
}


