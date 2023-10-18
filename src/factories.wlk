import enemigos.*
import wollok.game.*

class Punio{
	
}

object lostSoulFactory { 
 
    method nuevo(){ 
          const lostSoul = new LostSoul(vision = 3, arma = new Punio(), estado = 'vivo_derecha', salud = 50) 
          lostSoul.position(randomizer.emptyPosition())
          return lostSoul
    } 
}

object randomizer {
		
	method position() {
		return 	game.at( 
					(0 .. game.width() - 1 ).anyOne(),
					(0..  game.height() - 1).anyOne()
		) 
	}
	
	method emptyPosition() {
		const position = self.position()
		if(game.getObjectsIn(position).isEmpty()) {
			return position	
		}
		else {
			return self.emptyPosition()
		}
	}
	
}