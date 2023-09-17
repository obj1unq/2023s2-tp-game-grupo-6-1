import armas.*
import wollok.game.*

object doomGuy {
	var arma = pistola
	var bombas = []
	var salud = 100
	
	method image() {
		return "assets/personaje.png"
	}
	
	method agarrar(){
		const obj = game.uniqueCollider(self)
		
		if(armaManager.esArma(obj)){
			self.agarrarArma(obj)
		}
	}
	
	method agarrarArma(_arma){
		
		if(_arma.equals(bomba)){
			bombas.add(bomba)
		}else{
			arma = _arma
		}
		game.removeVisual(_arma)
	}
	
	method estadisticas(){
		return game.say(self, arma.toString())
	}
}
