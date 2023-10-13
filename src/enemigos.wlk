import personaje.*
import wollok.game.*
import gameClasses.*

//arma = puño, estado="vivo_derecha", position=game.at(0,0)
//ataque = 1
class Enemigo inherits Personaje {

	var vision

	override method sufreDanio(_danio) {
		salud -= _danio
		self.muereSiNoHaySalud(_danio)
	}

	override method muereSiNoHaySalud(_danio) {
		if (self.personajeHaDeMorir(_danio)) {
			self.morir()
		}
	}

	override method personajeHaDeMorir(_danio) {
		return salud > 0 && salud - _danio < 0
	}

	override method morir() {
		salud = 0
		self.activarAnimacionMuerte()
	}

	method perseguirAdoomGuy() {
		game.onTick(1000, self.toString() + "_acercarse_" + self.identity(), { self.acercarseParaAtacar(doomGuy.position())})
	}

	method acercarseParaAtacar(destino) {
		self.acercarse(destino)
		self.atacarSiHayCercania(destino)
	}

	method atacarSiHayCercania(destino) {
		if (self.hayCercania(destino)) {
			self.actualizarEstadoSegun(destino, "vivo_ataque_")
			self.activarSecuenciaAtaque(self.direccionesDeAtaque(destino))
		}
	}

	method hayCercania(destino) {
		return self.position().distance(destino).roundUp() < vision
	}

	method actualizarEstadoSegun(destino, _estado)

	method activarSecuenciaAtaque(direccion)

	override method sufrirImpacto(causante) {
		self.sufreDanio(causante.danio())
		causante.efectosPostImpacto()
	}

	method acercarse(destino) {
		position = game.at(position.x() + (destino.x() - position.x()) / vision, position.y() + (destino.y() - position.y()) / vision)
		self.actualizarEstadoSegun(destino, "vivo_")
	}

	method direccionesDeAtaque(destino)

}

