import enemigos.*
import wollok.game.*
import pickups.*
import armas.*

class Factory{
	method nuevo(){
		const objeto = self.generarObjeto()
		objeto.position(randomizer.emptyPosition())
		return objeto
	}
	
	method generarObjeto()
}


object saludPequeniaFactory inherits Factory{
	override method generarObjeto(){
		return new SaludPequenia()
	}
}

object saludMedianaFactory inherits Factory{
	override method generarObjeto(){
		return new SaludMediana()
	}
}

object saludGrandeFactory inherits Factory{
	override method generarObjeto(){
		return new SaludGrande()
	}
}

object escudoPequenioFactory inherits Factory{
	override method generarObjeto(){
		return new EscudoPequenio()
	}
}

object escudoMedianoFactory inherits Factory{
	override method generarObjeto(){
		return new EscudoMediano()
	}
}

object escudoGrandeFactory inherits Factory{
	override method generarObjeto(){
		return new EscudoGrande()
	}
}

object pistolaFactory inherits Factory{
	override method generarObjeto(){
		return new Pistola()
	}
}

object BFGFactory inherits Factory{
	override method generarObjeto(){
		return new BFG()
	}
}

object lanzamisilesFactory inherits Factory{
	override method generarObjeto(){
		return new LanzaMisiles()
	}
}

object minigunFactory inherits Factory{
	override method generarObjeto(){
		return new Minigun()
	}
}


object randomizer {
		
	method position() {
		return 	game.at( 
					(1 .. game.width() - 1 ).anyOne(),
					(1..  game.height() - 2).anyOne()
		) 
	}
	
	method emptyPosition() {
		var position = self.position()
		if(game.getObjectsIn(position).isEmpty()) {
			return position	
		}
		else {
			return self.emptyPosition()
		}
	}
	
}