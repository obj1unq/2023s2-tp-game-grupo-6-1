import gameClasses.*
import managers.*

class Pickup inherits Visual {
	method aporte()
}

class Salud inherits Pickup{
	override method sufrirImpacto(municion){
		municion.causante().obtenerSalud(self.aporte())
		saludManager.quitar(self)
		super(municion)
	}
}

class SaludPequenia inherits Salud{
	override method image(){
		return "salud/salud_pequenia_default.png"
	}
	
	
	override method aporte(){
		return 10
	}
}

class SaludMediana inherits Salud{
	override method image(){
		return "salud/salud_mediana_default.png"
	}
	
	
	override method aporte(){
		return 25
	}
}


class SaludGrande inherits Salud{
	override method image(){
		return "salud/salud_grande_default.png"
	}
	
	
	override method aporte(){
		return 100
	}
}

class Escudo inherits Pickup{
	override method sufrirImpacto(municion){
		municion.causante().obtenerEscudo(self.aporte())
		escudoManager.quitar(self)
		super(municion)
	}
}

class EscudoPequenio inherits Salud{
	override method image(){
		return "escudo/escudo_pequenio_default.png"
	}
	
	
	override method aporte(){
		return 10
	}
}

class EscudoMediano inherits Salud{
	override method image(){
		return "escudo/escudo_mediano_default.png"
	}
	
	
	override method aporte(){
		return 25
	}
}


class EscudoGrande inherits Salud{
	override method image(){
		return "escudo/escudo_grande_default.png"
	}
	
	
	override method aporte(){
		return 50
	}
}
