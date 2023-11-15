import gameClasses.*
import wollok.game.*

object loading inherits Visual(position = game.at(game.center().x(), game.center().y())) {

	override method image() {
		return "loading.png"
	}

}

object gameOver inherits Visual {

	override method image() {
		return "gameover.png"
	}

}

object win inherits Visual(position = game.at(game.width() / 2, game.height() / 2)) {

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

