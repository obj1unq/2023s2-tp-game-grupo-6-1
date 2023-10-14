import wollok.game.*

class Animacion {

	method animacion(fases, tiempoEntreImagenes, causanteAnimacion) {
		game.schedule(fases.size() * tiempoEntreImagenes + tiempoEntreImagenes, {=>
			game.removeTickEvent(self.nombreEventoDeAnimacion() + causanteAnimacion.identity().toString())
			self.accionPostAnimacion(causanteAnimacion)
		})
		
		game.onTick(50, self.nombreEventoDeAnimacion() + causanteAnimacion.identity().toString(), { 
			self.accionDuranteAnimacion(causanteAnimacion, fases)
		})
	}
	
	method nombreEventoDeAnimacion()
	
	method accionPostAnimacion(causante)
	
	method accionDuranteAnimacion(causante, fases)

}

class AnimacionMovimiento inherits Animacion { 
	
	override method nombreEventoDeAnimacion(){
		return "secuenciaPosicion_"
	}
	
	override method accionPostAnimacion(causante){
		causante.accionPostMovimiento()
	}
	
	override method accionDuranteAnimacion(causante, fases){
		causante.accionDuranteMovimiento(fases)
	}
	
}

class AnimacionMuerte inherits Animacion {

	override method nombreEventoDeAnimacion(){
		return "secuenciaMuerte_"
	}
	
	override method accionPostAnimacion(causante){
		causante.accionPostMuerte()
	}
	
	override method accionDuranteAnimacion(causante, fases){
		causante.accionDuranteMuerte(fases)
	}

}