import wollok.game.*
import personaje.*
import enemigos.*
import armas.*
import managers.*
import ui.*
import gameClasses.*
import factories.*
import obstaculo.*
import direcciones.*

class Mapa inherits Visual{ 
	
	var musica = null
	
	method definirCeldas()
	
	method celdas(){
		return self.definirCeldas().reverse()
	}
	
	method generar() {
		const celdas = self.celdas()
		game.cellSize(80)
		game.addVisual(self)
		game.width(celdas.anyOne().size())
		game.height(celdas.size())
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
	
	method aplicarConfiguraciones(){
		doomGuy.arma().recargaParcial()
		self.iniciarMusica()
		
	}
	
	method iniciarMusica(){
		musica = game.sound(self.toString() + ".mp3")
		musica.shouldLoop(true)
		game.schedule(500, {musica.play()})
	}
	
	method pararMusica(){
		musica.stop()
	}
	
	override method sufrirImpacto(municion) {
	}
	
	override method image(){
		return "ui/" + self.toString() + ".png"
	 }
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
		return new Cacodemon(arma = new LanzaBolasFuego(), estado = "default", salud = 300)
	}	
}

object l inherits EnemigoEnCelda {//representa al lostsoul
	
	override method nuevoObjeto(){
		return new LostSoul(arma = new Pistola(), estado = "default", salud = 50)
	}	
}

object b inherits EnemigoEnCelda{//representa al baronhell
	override method nuevoObjeto(){
		return new BaronOfHell(arma = new LanzaBolasPlasma(), estado = "default", salud = 200)
	}
}

object z inherits EnemigoEnCelda{//representa al zombie
	override method nuevoObjeto(){
		return new Zombie(arma = new Francotirador(), estado = "default", salud = 150)
	}		
}

object bs inherits EnemigoEnCelda{
	override method nuevoObjeto(){
		return cyberDemon
	}
}

object m inherits ObjetoEnCelda{//representa al muro
	override method nuevoObjeto(){
		return new Muro(durabilidad = 5)
	}	
}

object e inherits ObjetoEnCelda{//representa al barrilExplosivo
	override method nuevoObjeto(){
		return new Barril()
	}		
}




object mapa1 inherits Mapa{
	
	override method definirCeldas(){
		//17x10
		//1360x800
		return [
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,z],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,z,e],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,z],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_]			
	]
	}
}


object mapa2 inherits Mapa{
	override method definirCeldas(){
		return [
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,m,_,z,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,m,_,z,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,m,_,z,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,e,_,_,c,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,e,_,_,c,_],		
		[_,_,_,_,_,_,_,_,_,_,m,_,z,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,m,_,z,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,m,_,z,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_]				
	]
	}
	
	override method generar(){
		super()
		uIController.quitarUI(loading)
		
	}
	
	override method aplicarConfiguraciones(){
		super()
		saludManager.agregarFactory(saludMedianaFactory)
		escudoManager.agregarFactory(escudoMedianoFactory)
		armaManager.agregarFactory(minigunFactory)
	}
}

object mapa3 inherits Mapa{
	override method definirCeldas(){
		return [
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_]				
	]
	}
	
	override method generar(){
		super()
		uIController.quitarUI(loading)
	}
}


object mapa4 inherits Mapa{
	override method definirCeldas(){
		return [
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_]					
	]
	}
	
	override method generar(){
		super()
		uIController.quitarUI(loading)
	}
	
	override method aplicarConfiguraciones(){
		super()
		saludManager.agregarFactory(saludGrandeFactory)
		escudoManager.agregarFactory(escudoGrandeFactory)
		armaManager.agregarFactory(lanzamisilesFactory)
	}
}


object mapa5 inherits Mapa{
	override method definirCeldas(){
		return [
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,l,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_]				
	]
	}
	
	override method generar(){
		super()
		uIController.quitarUI(loading)
	}
}

object mapaBoss inherits Mapa{
	var property estado = null
	
	override method definirCeldas(){
		return [
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,bs,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_]				
	]
	}
	
	method celdasVacias(){
		return [
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_]				
	]
	}


	
	override method generar() {
		const celdas = self.celdasVacias()
		game.cellSize(80)
		game.addVisual(self)
		game.width(celdas.anyOne().size())
		game.height(celdas.size())
		(0..game.width() -1).forEach({x =>
			(0..game.height() -1).forEach( {y =>
				self.generarCelda(x,y, celdas)
			})
		})
		uIController.quitarUI(loading)
		self.activarCinematica()
		game.schedule(41000, {
			(0..game.width() -1).forEach({x =>
			(0..game.height() -1).forEach( {y =>
				self.generarCelda(x,y, self.definirCeldas())
			})
		})
		self.estado("ui/" + self.toString())
		game.addVisual(doomGuy)
		})
		
	}
	
	method activarCinematica(){
		self.estado("first_age")
		game.schedule(20000, {self.estado("torment")})
		game.schedule(30000, {self.estado("no_peace")})
		game.schedule(35000, {self.estado("dark_lord")})
		game.schedule(40000, {self.estado("sword")})
	}
	
	method generarCelda(x,y, celdas) {
		const celda = celdas.reverse().get(y).get(x)
		celda.generar(game.at(x,y))
	}
	
	
	override method aplicarConfiguraciones(){
		super()
		armaManager.agregarFactory(BFGFactory)
		game.onTick(5000, "ESQUIVE", {cyberDemon.esquivar()})
	}
	
	override method image(){
		return self.estado() + ".png"
	 }
}


