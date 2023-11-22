class Direcciones {

	method mover(position)

	method devolverDireccion()

}

class Arriba inherits Direcciones {

	override method mover(position) {
		return position.up(1)
	}

	override method devolverDireccion() {
		return "arriba"
	}

}

class Abajo inherits Direcciones {

	override method mover(position) {
		return position.down(1)
	}

	override method devolverDireccion() {
		return "abajo"
	}

}

class Izquierda inherits Direcciones {

	override method mover(position) {
		return position.left(1)
	}

	override method devolverDireccion() {
		return "izquierda"
	}

}

class Derecha inherits Direcciones {

	override method mover(position) {
		return position.right(1)
	}

	override method devolverDireccion() {
		return "derecha"
	}

}

