
# KC_Marvel_JCRC

**KC_Marvel_JCRC** es una aplicación desarrollada en Swift que permite explorar el vasto universo de personajes y series de Marvel. Este proyecto aprovecha SwiftUI para crear una interfaz de usuario dinámica y atractiva, además de incorporar patrones de arquitectura modernos para garantizar una alta mantenibilidad y escalabilidad.

---

## **Índice**

- [Características](#características)
- [Arquitectura](#arquitectura)
- [Dependencias](#dependencias)
- [Requisitos del sistema](#requisitos-del-sistema)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Flujo de la Aplicación](#flujo-de-la-aplicación)
- [Instalación](#instalación)
- [Capturas de Pantalla](#capturas-de-pantalla)
- [Contribución](#contribución)
- [Licencia](#licencia)

---

## **Características**

1. **Exploración de Personajes de Marvel:**
   - Visualiza una lista de personajes del universo Marvel, incluyendo su imagen y nombre.
   - Selecciona un personaje para ver sus detalles completos y las series asociadas.

2. **Detalles de las Series:**
   - Accede a información detallada sobre cada serie, como su título, descripción e imagen.

3. **Navegación Intuitiva:**
   - Implementación de navegación mediante `NavigationStack` y `NavigationPath` para garantizar una experiencia fluida.

4. **Estado Global:**
   - Uso de un modelo de estado centralizado (`RootViewModel`) que gestiona el flujo completo de la aplicación.

5. **Persistencia de Datos:**
   - Gestión de datos locales mediante un `DataStorageManager` que interactúa con una base de datos local para optimizar el rendimiento y permitir el acceso sin conexión.

6. **Gestión de Errores:**
   - Pantallas dedicadas para mostrar mensajes de error cuando ocurren problemas en la carga de datos.

7. **Interfaz Dinámica y Animada:**
   - Animaciones en la pantalla de inicio para una mejor experiencia del usuario.
   - Vista de carga con logos dinámicos y textos personalizados según la acción.

---

## **Arquitectura**

El proyecto sigue un enfoque basado en **MVVM** (Model-View-ViewModel) para una separación clara de responsabilidades:

- **Modelo:** Define las estructuras de datos (`Character`, `SerieModel`) y sus relaciones.
- **Vista:** Implementada con SwiftUI, ofrece una interfaz dinámica y altamente reactiva.
- **ViewModel:** Controla la lógica de negocio, gestionando la interacción entre la vista y los modelos.

Adicionalmente, el proyecto implementa un patrón de **State Management** centralizado con `RootViewModel` para manejar el estado global de la aplicación.

---

## **Dependencias**

- **Combine:** Framework nativo de Apple utilizado para gestionar la asincronía y el enlace de datos reactivo entre las vistas y los modelos de vista.
- **AsyncImage:** Utilizado para cargar imágenes de forma asíncrona desde URLs remotas.

---

## **Requisitos del Sistema**

- **Sistema Operativo:** iOS 15.0 o superior.
- **IDE:** Xcode 14.0 o superior.
- **Lenguaje:** Swift 5.5 o superior.

---

## **Estructura del Proyecto**

```
KC_Marvel_JCRC
├── Models
│   ├── Character.swift
│   ├── CharacterThumbnail.swift
│   ├── SerieModel.swift
│   └── SerieThumbnail.swift
├── ViewModels
│   ├── RootViewModel.swift
│   ├── CharactersViewModel.swift
│   ├── CharacterSeriesViewModel.swift
│   └── SerieDetailViewModel.swift
├── Views
│   ├── RootView.swift
│   ├── StartView.swift
│   ├── LoadView.swift
│   ├── ErrorView.swift
│   ├── CharactersView.swift
│   ├── CharacterDetailView.swift
│   └── SerieDetailView.swift
├── Utilities
│   ├── APIClient.swift
│   ├── APIClientUseCase.swift
│   ├── DataStorageManager.swift
│   ├── KeyChainKC.swift
│   └── Extensions.swift
└── Resources
    ├── Assets.xcassets
    └── Localizable.strings
```

---

## **Flujo de la Aplicación**

1. **Pantalla de Inicio (StartView):**
   - Animación con los logos de Marvel y KeepCoding.
   - Inicia la carga de los personajes.

2. **Vista de Personajes (CharactersView):**
   - Muestra un grid con los personajes disponibles.
   - Permite seleccionar un personaje para ver sus detalles.

3. **Detalles del Personaje (CharacterDetailView):**
   - Muestra el nombre, descripción e imagen del personaje seleccionado.
   - Lista las series asociadas con opción de navegar a su vista de detalle.

4. **Vista de Detalles de la Serie (SerieDetailView):**
   - Presenta el título, imagen y descripción de la serie seleccionada.

5. **Gestión de Estados:**
   - `RootViewModel` maneja el estado global, gestionando transiciones entre vistas y errores.

---

## **Instalación**

1. Clona este repositorio en tu máquina local:
   ```bash
   git clone https://github.com/tu-usuario/KC_Marvel_JCRC.git
   ```
2. Abre el archivo del proyecto `KC_Marvel_JCRC.xcodeproj` con Xcode.
3. Configura tu cuenta de desarrollador en Xcode.
4. Selecciona un simulador o dispositivo físico y ejecuta la aplicación.

---

## **Capturas de Pantalla**

### Pantalla de Inicio
![StartView](https://via.placeholder.com/300x600)

### Vista de Personajes
![CharactersView](https://via.placeholder.com/300x600)

### Detalles del Personaje
![CharacterDetailView](https://via.placeholder.com/300x600)

### Detalles de la Serie
![SerieDetailView](https://via.placeholder.com/300x600)

---

## **Contribución**

Las contribuciones son bienvenidas. Por favor, sigue estos pasos para contribuir:

1. Haz un fork del repositorio.
2. Crea una rama nueva (`git checkout -b feature/nueva-funcionalidad`).
3. Realiza tus cambios y haz commit (`git commit -m 'Añadida nueva funcionalidad'`).
4. Envía tus cambios al repositorio remoto (`git push origin feature/nueva-funcionalidad`).
5. Abre un Pull Request para revisión.

---

## **Licencia**

Este proyecto está licenciado bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.

---

Si tienes preguntas o problemas, no dudes en abrir un issue en este repositorio. ¡Gracias por tu interés en **KC_Marvel_JCRC**! 🎉

Contacto: jcrubio@equinsa.es 
