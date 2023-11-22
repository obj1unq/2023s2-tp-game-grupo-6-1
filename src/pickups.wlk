import gameClasses.*
import managers.*
import personaje.*
import wollok.game.*

class Pickup inherits Visual {

	method aporte()

	override method sufrirImpacto(municion) {
		if (municion.causante().puedeDanar()) {
			self.efectoImpacto(municion)
			super(municion)
		}
	}

	method efectoImpacto(municion)

}

class Salud inherits Pickup {

	override method efectoImpacto(municion) {
		municion.causante().obtenerSalud(self.aporte())
		saludManager.quitar(self)
	}

}

class SaludPequenia inherits Salud {

	override method image() {
		return "salud/salud_pequenia_default.png"
	}

	override method aporte() {
		return 10
	}

}

class SaludMediana inherits Salud {

	override method image() {
		return "salud/salud_mediana_default.png"
	}

	override method aporte() {
		return 25
	}

}

class SaludGrande inherits Salud {

	override method image() {
		return "salud/salud_grande_default.png"
	}

	override method aporte() {
		return 100
	}

}

class Escudo inherits Pickup {

	override method efectoImpacto(municion) {
		municion.causante().obtenerEscudo(self.aporte())
		escudoManager.quitar(self)
	}

}

class EscudoPequenio inherits Escudo {

	override method image() {
		return "escudo/escudo_pequenio_default.png"
	}

	override method aporte() {
		return 10
	}

}

class EscudoMediano inherits Escudo {

	override method image() {
		return "escudo/escudo_mediano_default.png"
	}

	override method aporte() {
		return 25
	}

}

class EscudoGrande inherits Escudo {

	override method image() {
		return "escudo/escudo_grande_default.png"
	}

	override method aporte() {
		return 50
	}

}

