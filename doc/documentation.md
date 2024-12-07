# Documento de Especificación para MVP de App Tipo Kanban con Asistente de IA

## Índice

1. [Introducción](#introducción)
2. [Descripción General de la Idea](#descripción-general-de-la-idea)
3. [Arquitectura Funcional](#arquitectura-funcional)
4. [Casos de Uso](#casos-de-uso)
5. [Características Detalladas](#características-detalladas)
   - [Tablero Kanban](#tablero-kanban)
   - [Tareas](#tareas)
   - [Columnas](#columnas)
   - [Asistente de IA](#asistente-de-ia)
   - [Interacción por Voz](#interacción-por-voz)
   - [Integración con Supabase](#integración-con-supabase)
   - [Estado Global con Riverpod](#estado-global-con-riverpod)
6. [Pantallas de la Aplicación](#pantallas-de-la-aplicación)
   - [Pantalla de Inicio (Splash)](#pantalla-de-inicio-splash)
   - [Pantalla de Autenticación](#pantalla-de-autenticación)
   - [Pantalla Principal del Tablero](#pantalla-principal-del-tablero)
   - [Pantalla de Detalle de Tarea](#pantalla-de-detalle-de-tarea)
   - [Pantalla/Modal de Creación/Edición de Tarea](#pantallamodal-de-creaciónedición-de-tarea)
   - [Pantalla de Chat con la IA](#pantalla-de-chat-con-la-ia)
   - [Pantalla de Configuración](#pantalla-de-configuración)
7. [Flujos de Navegación](#flujos-de-navegación)
8. [Funciones que la IA Puede Desencadenar](#funciones-que-la-ia-puede-desencadenar)
9. [Especificación de Atributos de Datos](#especificación-de-atributos-de-datos)
10. [Ejemplos de Interacción con la IA](#ejemplos-de-interacción-con-la-ia)
11. [Consideraciones Técnicas](#consideraciones-técnicas)
12. [Futuras Extensiones](#futuras-extensiones)

---

## Introducción

Este documento describe detalladamente la idea, las funcionalidades y la apariencia de un MVP para una aplicación basada en Flutter, con estado gestionado mediante Riverpod y backend sobre Supabase. La aplicación se inspira en herramientas como Trello, ofreciendo un tablero Kanban para gestionar tareas y proyectos. Como punto diferenciador clave, integra un asistente de IA (usando la API de OpenAI/Chat GPT) con el que el usuario puede interactuar tanto por texto como por voz y que, además, puede desencadenar acciones dentro de la app (por ejemplo, crear una tarea, mover una tarea entre columnas, etc.).

El objetivo es ofrecer una descripción exhaustiva para que un sistema de IA pueda comprender el alcance y los detalles del producto a desarrollar, facilitando la generación de código o asistencia en la implementación.

---

## Descripción General de la Idea

La aplicación es un tablero Kanban personalizable:

- Permite crear, editar y mover tareas entre columnas (similares a "To Do", "Doing", "Done").
- Cada tarea tiene atributos básicos (título, descripción, fecha límite, etiquetas, etc.).
- Incluye un asistente de IA integrado: el usuario puede chatear con la IA (por texto o voz) para:
  - Obtener ayuda contextual (por ejemplo, "¿Cómo puedo priorizar mis tareas?").
  - Pedir acciones directas (por ejemplo, "Mueve la tarea 'Diseñar el logo' a la columna 'Hecho'").
- El asistente de IA puede desencadenar funciones específicas expuestas por la aplicación, lo que hace que no solo se limite a responder consultas, sino también a actuar dentro del tablero.

---

## Arquitectura Funcional

- **Frontend:** Flutter.
- **Estado:** Riverpod para el manejo global del estado.
- **Backend:** Supabase (PostgreSQL, Auth y Storage).
- **IA:** Integración con API de OpenAI (Chat GPT).
- **Control de voz:** Uso de plugins de reconocimiento de voz (como `speech_to_text` u otros).

---

## Casos de Uso

1. **Crear una columna:** El usuario añade una nueva columna para organizar las tareas.
2. **Crear una tarea:** El usuario crea una nueva tarea con título, descripción y fecha límite.
3. **Mover tarea:** El usuario arrastra una tarea de una columna a otra para reflejar el progreso.
4. **Editar tarea:** Actualizar los detalles de una tarea existente.
5. **Eliminar tarea:** Eliminar una tarea que ya no es necesaria.
6. **Interacción con IA (texto):** El usuario le pide a la IA consejos o preguntas sobre las tareas.
7. **Interacción con IA (voz):** El usuario habla con la IA y le pide que realice acciones concretas (por ejemplo, “Crea una tarea llamada ‘Preparar informe semanal’ en la columna ‘To Do’”).
8. **Asistente de IA actuando:** La IA analiza el pedido del usuario y, mediante funciones definidas, realiza la acción sin intervención manual (por ejemplo, crear la tarea internamente).

---

## Características Detalladas

### Tablero Kanban

- **Vista en columnas:** Varias columnas apiladas horizontalmente.
- **Cada columna contiene una lista de tareas apiladas verticalmente.**
- **Funcionalidad drag & drop:** Poder arrastrar tareas para moverlas de una columna a otra.

### Tareas

- **Atributos mínimos:**
  - ID único
  - Título (string)
  - Descripción (string, opcional)
  - Fecha límite (datetime, opcional)
  - Etiquetas (lista de strings, opcional)
  - Estado/Columna (relación con la columna en la que está)
- **Acciones sobre una tarea:**
  - Crear
  - Editar (modificar título, descripción, fecha, etiquetas)
  - Mover (cambiar de columna)
  - Eliminar

### Columnas

- **Atributos:**
  - ID único
  - Título (ej: "To Do", "Doing", "Done")
  - Orden (para saber en qué posición se muestra la columna)
- **Acciones sobre columnas:**
  - Crear
  - Editar título
  - Cambiar orden (reordenar columnas)
  - Eliminar (opcionalmente, con confirmación)

### Asistente de IA

- **Chat con IA:** El usuario envía un mensaje y recibe respuesta.
- **Integración por voz:** Permite dictar mensajes a la IA.
- **Llamada a funciones:** Desde la respuesta de la IA, esta puede indicar ejecutar una función expuesta por la app (ej: `createTask`, `moveTask`).
- **Contextualidad:** La IA puede recordar el historial de chat del usuario y el estado del tablero, si es suministrado.

### Interacción por Voz

- **Icono de micrófono:** El usuario pulsa el icono para iniciar el reconocimiento de voz.
- **Transcripción en tiempo real:** El usuario ve lo que se va transcribiendo.
- **Envía el texto resultante a la IA:** Al finalizar la grabación, se envía el texto al asistente.
- **Respuesta hablada opcional:** La IA responde por texto y se puede opcionalmente leer la respuesta en voz alta (opcional MVP).

### Integración con Supabase

- **Persistencia de tareas y columnas:** Guardar, leer y actualizar el estado del tablero en Supabase.
- **Autenticación:** Opcional en MVP, pero se puede contemplar un login simple para tener un tablero personal.
- **Sincronización en tiempo real:** Supabase ofrece suscripciones para actualizar las tareas en tiempo real si se trabaja en varios dispositivos.

### Estado Global con Riverpod

- **Providers:**
  - `tasksProvider` para la lista global de tareas.
  - `columnsProvider` para las columnas.
  - `selectedTaskProvider` para la tarea seleccionada en el detalle.
  - `chatProvider` para el estado del chat con la IA.
- **Actualizaciones reactivas:** Cuando se crea/edita/borra una tarea, se actualizan los Providers y se redibuja la UI.

---

## Pantallas de la Aplicación

### Pantalla de Inicio (Splash)

- **Elementos:**
  - Logo de la aplicación.
  - Animación de carga (un spinner o animación simple).
- **Funcionalidad:**
  - Cargar datos iniciales (si es necesario).
  - Redirigir a la pantalla principal o de autenticación tras la carga.

### Pantalla de Autenticación

- **Elementos:**
  - Campo de email y contraseña.
  - Botón de "Iniciar sesión".
  - Botón de "Registrarse" (opcional en MVP).
- **Funcionalidad:**
  - Autenticar al usuario con Supabase.
  - En caso de éxito, redirigir a la pantalla principal del tablero.

### Pantalla Principal del Tablero

- **Elementos:**
  - Barra superior:
    - Título de la App ("Mi Kanban" por ejemplo).
    - Icono o botón para acceder a la pantalla de Chat con la IA.
    - Menú hamburguesa (opcional) para configuración.
  - Zona principal scroll horizontal con las columnas:
    - Cada columna en un contenedor con:
      - Título de la columna.
      - Botón para añadir nueva tarea.
      - Lista vertical de tareas (cards).
  - Botón flotante opcional para crear nueva columna.
- **Funcionalidades:**
  - Drag & drop de tareas entre columnas.
  - Clic en tarea para ver detalles.
  - Clic en botón "Añadir tarea" para abrir modal de creación.
  - Clic en botón "Añadir columna" para abrir modal de creación de columna.

### Pantalla de Detalle de Tarea

- **Elementos:**
  - Barra superior con botón de volver.
  - Título de la tarea (editable).
  - Descripción (editable).
  - Campo de fecha límite.
  - Lista de etiquetas (añadir o eliminar).
  - Botones:
    - Guardar cambios
    - Eliminar tarea
- **Funcionalidades:**
  - Editar los atributos de la tarea.
  - Guardar en Supabase.
  - Eliminar tarea y retornar al tablero.

### Pantalla/Modal de Creación/Edición de Tarea

- **Elementos:**
  - Campo título (obligatorio).
  - Campo descripción (opcional).
  - Selección de columna destino.
  - Campo fecha límite (opcional).
  - Botón "Guardar".
- **Funcionalidad:**
  - Crear o actualizar tarea.
  - Actualización del estado global.

### Pantalla de Chat con la IA

- **Elementos:**
  - Lista de mensajes (tipo chat):
    - Mensajes del usuario (en un lado).
    - Mensajes de la IA (en el lado opuesto).
  - Campo de texto para ingresar consulta.
  - Botón para enviar mensaje.
  - Icono de micrófono para activar voz.
- **Funcionalidad:**
  - Enviar mensajes a la IA.
  - Recibir respuesta y mostrarla en el chat.
  - Si la IA sugiere una función, ejecutarla automáticamente en segundo plano y mostrar mensaje de confirmación.

### Pantalla de Configuración

- **Elementos:**
  - Opción de cambiar idioma (opcional).
  - Opción de desconectarse.
  - Ajustes de notificaciones (opcional).
- **Funcionalidad:**
  - Ajustar parámetros globales.

---

## Flujos de Navegación

1. **Iniciar la app → Splash → si no autenticado → Autenticación → si autenticado → Pantalla Principal.**
2. **Pantalla Principal → Clic en tarea → Pantalla Detalle de Tarea.**
3. **Pantalla Principal → Clic en "Añadir tarea" → Modal de creación de tarea.**
4. **Pantalla Principal → Clic en "Chat IA" → Pantalla de Chat con IA.**
5. **Pantalla Principal → Menú hamburguesa → Pantalla de Configuración.**

---

## Funciones que la IA Puede Desencadenar

Ejemplo de funciones (el front o backend deben exponer una interfaz que la IA pueda "llamar"):

- `createTask(title: String, columnId: String, description?: String, dueDate?: Date)`: Crea una tarea.
- `moveTask(taskId: String, targetColumnId: String)`: Mueve una tarea a otra columna.
- `deleteTask(taskId: String)`: Elimina una tarea.
- `createColumn(title: String)`: Crea una nueva columna.
- `renameColumn(columnId: String, newTitle: String)`: Cambia el título de una columna.

Estas funciones serán llamadas por la IA cuando detecte en el mensaje del usuario una intención. Por ejemplo, si el usuario dice: "Crea una tarea llamada 'Hacer informe' en la columna 'To Do'", la IA identificará:

- Acción: `createTask`
- Parámetros: `title="Hacer informe"`, `columnId=(columna con nombre "To Do")`

---

## Especificación de Atributos de Datos

### Tareas

- `id`: UUID (Generado por Supabase)
- `title`: String (no vacío)
- `description`: String (opcional)
- `due_date`: Timestamp (opcional)
- `labels`: Lista de strings (opcional)
- `column_id`: UUID (relación con columnas)

### Columnas

- `id`: UUID
- `title`: String
- `order`: int (para ordenamiento)

### Usuario (opcional en MVP)

- `id`: UUID
- `email`: String
- `password_hash`: String (manejado por Supabase)

### Mensajes de Chat (en caso de persistir historial)

- `id`: UUID
- `user_id`: UUID
- `role`: Enum('user', 'assistant')
- `content`: String
- `timestamp`: Timestamp

---

## Ejemplos de Interacción con la IA

1. **Texto:**
   - Usuario: "¿Cómo puedo organizar mejor mis tareas?"
   - IA: "Podrías agruparlas por prioridad. Por cierto, puedo crear una nueva columna 'Prioridad Alta' si deseas."
   - Usuario: "Sí, crea la columna 'Prioridad Alta'."
   - IA: _Llama a la función_ `createColumn(title: 'Prioridad Alta')`
2. **Voz:**

   - Usuario (hablando): "Crea una tarea llamada 'Comprar materiales' en la columna 'To Do'."
   - Aplicación transcribe a texto: "Crea una tarea llamada 'Comprar materiales' en la columna 'To Do'."
   - IA interpreta y llama a: `createTask(title: 'Comprar materiales', columnId: 'id_de_To_Do')`
   - Muestra mensaje: "Tarea creada exitosamente."

3. **Moviendo tarea:**
   - Usuario: "Mueve la tarea 'Comprar materiales' a la columna 'Hecho'."
   - IA: _Llama a la función_ `moveTask(taskId: 'id_tarea_comprar_materiales', targetColumnId: 'id_de_done')`
   - Muestra mensaje: "Tarea movida a la columna 'Hecho'."

---

## Consideraciones Técnicas

- **Integración con IA:**
  - El backend puede recibir la cadena del usuario y enviarla a la API de OpenAI.
  - La respuesta de la IA debe analizarse para detectar si la IA sugiere una función a ejecutar.
  - Es posible usar el mecanismo de "function calling" de OpenAI, donde la IA devuelve un JSON con el nombre de la función y argumentos.
- **Autorización de acciones por parte del usuario:**
  - En un MVP, se puede ejecutar automáticamente la función. En un futuro, se podría requerir confirmación del usuario.
- **Rendimiento:**
  - Las actualizaciones locales (Riverpod) deben ser instantáneas.
  - Las operaciones en Supabase se hacen en segundo plano, actualizando el estado cuando finalizan.
- **Gestión de errores:**
  - Si una función falla (por ejemplo, no se encuentra la columna), la IA debe comunicar el error.

---

## Futuras Extensiones

- **Múltiples tableros por usuario.**
- **Colaboración en tiempo real con otros usuarios.**
- **Notificaciones push cuando la IA crea o modifica tareas.**
- **Soporte offline.**
- **Prioridades y vistas filtradas de tareas.**

---

**Con este documento, se busca tener una especificación detallada que pueda ser utilizada como guía para una IA generadora de código o para el equipo de desarrollo, permitiendo entender claramente las funcionalidades, flujos y elementos de la aplicación.**
