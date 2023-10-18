import wollok.game.*
import factories.*

class Manager { 
     var generados = #{} 
     const limite 
     const factories  
     
     method seleccionarFactory() { 
          return factories.anyOne() 
     }
      
  method generar() {
         if (generados.size() < limite) {
            const item = self.seleccionarFactory().nuevo()
            game.addVisual(item)
            generados.add(item)
        }
    }

     method quitar(item) { 
        generados.remove(item)
        game.removeVisual(item)
    }
}
 
object enemigoManager inherits Manager(limite=5, factories =#{lostSoulFactory}) {   
	
}