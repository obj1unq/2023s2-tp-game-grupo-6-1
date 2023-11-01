import gameClasses.*
import wollok.game.*

object loading inherits Visual(position=game.at(game.center().x()-4, game.center().y()-2)) {
	
	override method image(){
		return "loading.png"
	}
}
