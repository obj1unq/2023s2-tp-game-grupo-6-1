import gameClasses.*
import wollok.game.*

object loading inherits Visual {

	override method image() {
		return "loading.png"
	}

}

object gameOver inherits Visual {

	override method image() {
		return "gameover.png"
	}

}

object win inherits Visual {

	override method image() {
		return "win.png"
	}
}

class BurnMark inherits Visual{
	override method image(){
		return "burn_mark.png"
	}
	
	override method sufrirImpacto(municion) {
	}
}

class VidaUI inherits Visual{
	var property state = "6"
}

object health inherits VidaUI(position = game.at(0, game.height()-1)){	

	override method image() {
		return "life_" + self.state() + ".png"
	}
}

object shield inherits VidaUI(position = game.at(3, game.height()-1)){

	override method image() {
		return "shield_" + self.state() + ".png"
	}
}


