# Mapas App - Aplicación de Mapas Interactiva para iOS con CoreData

## Descripción del Proyecto
Mapa Linares es una aplicación de mapas para iOS desarrollada en Swift con Xcode, que te permite explorar lugares de interés en la ciudad de Linares. La novedad es que se ha implementado CoreData para garantizar la persistencia de los marcadores, permitiendo a los usuarios personalizar su experiencia.

## Funcionalidades

### 1. Mapa Principal
La aplicación presenta un mapa interactivo como pantalla principal, proporcionando una visión general de Linares.

### 2. "El Pósito"
Se ha integrado la ubicación de "El Pósito" en el mapa. Al iniciar la aplicación, el mapa se centrará en este punto de interés.

### 3. Indicaciones para Llegar a "El Pósito"
Al tocar el accesorio asociado a "El Pósito", la aplicación proporcionará indicaciones para llegar a este lugar caminando, utilizando la aplicación Mapas.

### 4. Ubicación de la Escuela
La aplicación muestra la ubicación de la escuela en el mapa. Al tocar el accesorio correspondiente, se abrirá el navegador web mostrando la página https://escuelaestech.es.

### 5. Marcador de la Catedral de Baeza
Además de los marcadores mencionados, se ha incluido un marcador para la Catedral de Baeza. Al iniciar la aplicación, los marcadores de "El Pósito", la escuela y la catedral aparecerán en la pantalla.

### 6. Marcadores Fuera de Linares
Los marcadores de lugares fuera de Linares se distinguen con un color amarillo. Proporcionan indicaciones para llegar en coche utilizando la aplicación Mapas. Gracias a CoreData, estos marcadores se conservan incluso después de cerrar la aplicación.

### 7. Switch para Ocultar/Mostrar Elementos Fuera de Linares
Se ha añadido un interruptor que permite al usuario ocultar o mostrar los marcadores fuera de Linares. Al activar o desactivar este interruptor, la vista se ajusta para mostrar todos los resultados. Los cambios se almacenan de forma persistente gracias a CoreData.

### 8. Funcionalidades Avanzadas (Opcionales)
- Los usuarios tienen la capacidad de agregar nuevos marcadores de lugares de interés. Esta información se almacena de forma persistente mediante CoreData, incluyendo el nombre, latitud, longitud y la indicación de si se encuentran en Linares o no.
- Además, la aplicación permite agregar nuevos marcadores con la ubicación actual del usuario, garantizando que la información se conserve incluso después de cerrar la aplicación.

## Requisitos
- iOS 17.12
- Xcode

## Instrucciones de Uso
1. Clona el repositorio.
2. Abre el proyecto en Xcode.
3. Configura el simulador o conecta un dispositivo iOS.
4. Ejecuta la aplicación y explora el mapa de Linares con la confianza de que tus marcadores se guardarán gracias a CoreData.
