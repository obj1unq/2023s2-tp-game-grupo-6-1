import wollok.game.* 
import enemigos.*
import randomizer.* 
import armas.*
   
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
 
object enemigoManager inherits Manager(limite=5, factories =#{lostSoulFactory, pinkyFactory, zombieFactory}) {   
	
}   
 
object armaManager inherits Manager(limite=2, factories=#{pistolaFactory, miniGunFactory}){ 

      override method seleccionarFactory() { 
          const x = 0.randomUpto(1) 
          return if (x < 0.10) pistolaFactory else miniGunFactory 
      } 

}
 
object saludManager inherits Manager(limite=3, factories=#{botiquinFactory, vendajeFactory, pildoraSaludFactory}){
  
}
 
object escudoManager inherits Manager(limite=3, factories=#{escudoDe20Factory, escudoDe40Factory, escudDe100Factory}) {
 
} 
  
 
object lostSoulFactory { 
 
    method nuevo(){ 
          return new LostSoul(position=randomizer.emptyPosition()) 
    } 
}
  
object pinkyFactory { 
 
    method nuevo(){ 
          return new Pinky(position=randomizer.emptyPosition())
     }  
}  
 
object zombieFactory { 
    method nuevo(){ 
        return new Zombie(position=randomizer.emptyPosition())     
     } 
} 
