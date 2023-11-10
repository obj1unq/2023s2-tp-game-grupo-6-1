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
		return position.x() == 0 && position.y().between(0, game.height() - 1)
	}

}

object UIController {

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
		keyboard.up().onPressDo({ doomGuy.mover(new Arriba())})
		keyboard.down().onPressDo({ doomGuy.mover(new Abajo())})
		keyboard.s().onPressDo({ doomGuy.dispararSiEstaVivo(new Derecha())})
		keyboard.e().onPressDo({ game.say(doomGuy, armaManager.factories().toString())})
		keyboard.r().onPressDo({ game.say(doomGuy, saludManager.factories().toString())})
		keyboard.t().onPressDo({ game.say(doomGuy, escudoManager.factories().toString())})
		game.onTick(1000, "ENEMIGOS", { enemigoManager.moverEnemigos()
			enemigoManager.activarAtaqueEnemigos()
		})
		saludManager.vaciarGenerados()
		escudoManager.vaciarGenerados()
		armaManager.vaciarGenerados()
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

	method ejecutarJuego() {
		const mapaActual = niveles.get(nivelActual)
		mapaActual.aplicarConfiguraciones()
		mapaActual.generar()
		if (nivelActual == 0) {
			setupController.initialize()
		} else {
			setupController.setupInitialize()
		}
	}

	method ejecutarGameOverSiEnZonaDoomguy(position) {
		if (tablero.esZonaDoomguy(position)) {
			self.gameOver()
		}
	}

	method gameOver() {
		doomGuy.morir()
		game.schedule(200, { game.clear()
			UIController.ponerUI(gameOver)
		})
	}

	method pasarDeNivelSiVencioATodos() {
		if (enemigoManager.estanTodosMuertos()) {
			game.schedule(1000, { game.clear()
				UIController.ponerUI(loading)
				game.schedule(5000, { self.subirNivel()})
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
		game.schedule(200, { UIController.ponerUI(win)})
	}

}

