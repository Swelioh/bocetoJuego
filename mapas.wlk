import wollok.game.*
import protagonista.*
import enemigos.*
import hud.*
import controlacion.*
import menu.*
// 1. PRIMERO LAS CLASES (los "moldes")
class Nivel {
  const numero = 0
  var property position = game.at(20,15)
  method image() = "nivel" + numero + ".png"
}

class TipoMapa {
  const nivel = new Nivel(numero = 0)
  const fondo = FondoNivel
  const listaEnemigos = []
  const nombreMusica = null
  var musicaObjeto = null

  method reiniciar() {
      // Simplemente resetea el estado de CADA enemigo en la lista maestra
      listaEnemigos.forEach({ enemigo => 
          enemigo.reiniciar()
      })
      
  }

  method detenerMusica() {
    if (musicaObjeto != null) {
      musicaObjeto.stop()
      musicaObjeto = null // Limpiamos la referencia
    }
  }

  method iniciar() {

    game.addVisual(fondo)
    game.addVisual(nivel)

    /*self.agregarEnemigos()
    self.agregarEnemigos()
    self.agregarEnemigos()*/

    listaEnemigos.forEach({ enemigo => 
        game.addVisual(enemigo)
    })

    if (nombreMusica != null) {
      musicaObjeto = game.sound(nombreMusica) 
      musicaObjeto.shouldLoop(true)
      musicaObjeto.volume(0.15)
      musicaObjeto.play()
    }
    

    game.schedule(5000, { => game.removeVisual(nivel) })

    game.addVisual(barraDeVida)     
    game.addVisual(barraDeEnergia)

    game.addVisual(protagonista)
    protagonista.iniciar()
    controlacion.configuracionControles()
  }

  /*method agregarEnemigos(){
    if(listaEnemigos.size() > 0){
      const nuevoEnemigo = listaEnemigos.first()
      listaEnemigosEnPantalla.add(nuevoEnemigo)
      game.addVisual(nuevoEnemigo)
      listaEnemigos.remove(nuevoEnemigo)
    }
  }*/

  method listaEnemigos() = listaEnemigos
}
class FondoNivel{
  var property position = game.at(0,0)
  const imagen="bosque.png"
  method image()=imagen

}


// 2. LUEGO LAS CONSTANTES (los "objetos" creados a partir de los moldes)
const tutorial = new TipoMapa(nivel = new Nivel(numero = 1), fondo = new FondoNivel(imagen="Summer1.png"), listaEnemigos = [maniqui,hongo], nombreMusica = "theShire.wav")
const bosque = new TipoMapa(nivel = new Nivel(numero = 2), fondo = new FondoNivel(imagen="bosques.png"), listaEnemigos = [hongo,murcielago],nombreMusica = "theDarkForest.wav")
const agua = new TipoMapa(nivel = new Nivel(numero = 3), fondo = new FondoNivel(imagen="aguas.png"), listaEnemigos = [hongo])
const nevado = new TipoMapa(nivel = new Nivel(numero = 4), fondo = new FondoNivel(imagen="nevada.png"), listaEnemigos = [hongo])
const mapaFinal = new TipoMapa(nivel = new Nivel(numero = 5), fondo = new FondoNivel(imagen="finalMap.png"), listaEnemigos = [hongo])



// 3. AL FINAL DE TODO, EL OBJETO PRINCIPAL QUE USA LO ANTERIOR
object mapa {
  const niveles=[tutorial,bosque,nevado,agua,mapaFinal]
  var indiceNivel=0
  var nuevoMapa = tutorial
  
  method reiniciar(){
    nuevoMapa.detenerMusica()

    indiceNivel=0
    nuevoMapa=niveles.get(indiceNivel)

    nuevoMapa.reiniciar()
    nuevoMapa.iniciar()
  }

  method siguienteMapa() {
    nuevoMapa.detenerMusica()
    if(indiceNivel<niveles.size()){
      nuevoMapa=niveles.get(indiceNivel)
      game.clear()
      controlacion.detenerTimers()
      nuevoMapa.iniciar()
      indiceNivel=indiceNivel+1
    }
  }

  method mapaActual()=nuevoMapa
}