import wollok.game.*
import ui.*
import managers.*
import mapas.*
import personaje.*
import direcciones.*

class Visual {

	var property position = game.at(0, 0)

	method sufrirImpacto(municion) {
		municion.terminarMovimientoSiPresenteEnTablero()
	}

	method image()

}

object tablero {

	method pertenece(position) {
		return position.x().between(0, game.width() - 2) && position.y().between(0, game.height() - 2)
	}

	method esZonaDoomguy(position) {
		return position.x() == 0 && position.y().between(0, game.height() - 2)
	}

}

object uIController {

	method ponerUI(ui) {
		game.addVisual(ui)
	}

	method quitarUI(ui) {
		game.removeVisual(ui)
	}

}

object setupController {

	method setupInitialize() {
		game.errorReporter(doomGuy)
		game.onTick(5000, "ENEMIGOS", { enemigoManager.activarAtaqueEnemigos()
			enemigoManager.moverEnemigos()
		})
		keyboard.up().onPressDo({ doomGuy.mover(new Arriba())})
		keyboard.down().onPressDo({ doomGuy.mover(new Abajo())})
		keyboard.s().onPressDo({ doomGuy.dispararSiEstaVivo(new Derecha())})
		keyboard.e().onPressDo({ doomGuy.mostrarMunicion()})
		saludManager.vaciarGenerados()
		escudoManager.vaciarGenerados()
		armaManager.vaciarGenerados()
		uIController.ponerUI(health)
		uIController.ponerUI(shield)
		game.onTick(5000, "SALUD", { saludManager.generar()})
		game.onTick(7000, "ESCUDO", { escudoManager.generar()})
		game.onTick(5000, "ARMA", { armaManager.generar()})
	}

	method initialize() {
		self.setupInitialize()
		game.start()
	}

}

object nivelController {

	const niveles = [ mapa1, mapa2, mapa3, mapa4, mapa5, mapaBoss ]
	var nivelActual = 0
	var mapaActual

	method ejecutarJuego() {
		self.aplicarConfiguracionesMapaActual()
		if (nivelActual == 0) {
			setupController.initialize()
		} else if (nivelActual == 5) {
			game.schedule(50000, { setupController.setupInitialize()})
		} else {
			setupController.setupInitialize()
		}
	}
	
	method aplicarConfiguracionesMapaActual(){
		mapaActual = niveles.get(nivelActual)
		mapaActual.aplicarConfiguraciones()
		mapaActual.generar()
	}

	method ejecutarGameOverSiEnZonaDoomguy(position) {
		if (tablero.esZonaDoomguy(position)) {
			self.gameOver()
		}
	}

	method gameOver() {
		mapaActual.pararMusica()
		doomGuy.morir()
		game.schedule(200, { mapaActual.pararMusica()
			game.clear()
			uIController.ponerUI(gameOver)
		})
	}

	method pasarDeNivelSiVencioATodos() {
		if (enemigoManager.estanTodosMuertos()) {
			game.schedule(1000, { game.clear()
				uIController.ponerUI(loading)
				game.schedule(3000, { mapaActual.pararMusica()
					self.subirNivel()
				})
			})
		}
	}

	method subirNivel() {
		if (nivelActual < 5) {
			nivelActual++
			self.ejecutarJuego()
		} else {
			self.ganarJuego()
		}
	}

	method ganarJuego() {
		game.clear()
		game.schedule(200, { uIController.ponerUI(win)})
	}

}

