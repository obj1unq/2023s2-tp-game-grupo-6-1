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
		return position.x().between(0, game.width() - 1) && position.y().between(0, game.height() - 1)
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

	method initialize() {
		game.cellSize(80)
		game.errorReporter(doomGuy)
		keyboard.up().onPressDo({ doomGuy.mover(new Arriba())})
		keyboard.down().onPressDo({ doomGuy.mover(new Abajo())})
		keyboard.left().onPressDo({ doomGuy.mover(new Izquierda())})
		keyboard.right().onPressDo({ doomGuy.mover(new Derecha())})
		keyboard.s().onPressDo({doomGuy.dispararSiEstaVivo(new Derecha())})
		game.onTick(1000, "ENEMIGOS", { enemigoManager.moverEnemigos()
			enemigoManager.activarAtaqueEnemigos()
		})
		game.onTick(5000, "SALUD", { saludManager.generar()})
		game.onTick(7000, "ESCUDO", { escudoManager.generar()})
		game.onTick(5000, "ARMA", { armaManager.generar()})
		game.start()
	}

}

object nivelController {

	var niveles = [ mapa1, mapa2, mapa3, mapa4, mapa5] //mapaBoss ]
	var nivelActual = 0

	method ejecutarJuego() {
		const mapaActual = niveles.get(nivelActual)
		mapaActual.aplicarConfiguraciones()
		mapaActual.generar()
		setupController.initialize()
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
			self.subirNivel()
		}
	}

	method subirNivel() {
		if (nivelActual <= 5) {
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

