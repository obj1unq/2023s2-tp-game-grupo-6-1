import wollok.game.*

object armaManager{
	const armas = #{pistola, miniGun, bomba}
	
	method esArma(obj){
		return armas.contains(obj)
	}
}

object pistola {
	const property position = game.at(7,7)
	
	method image(){
		return "assets/pistola.png"
	}
	
}

object miniGun {
	const property position = game.at(10,2)
	
	method image(){
		return "assets/miniGun.png"
	}
}

object bomba {
	const property position = game.at(8,8)
	method image(){
		return "assets/bomba.png"
	}
}