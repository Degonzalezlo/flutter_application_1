import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// Tema personalizado con 3 propiedades
final ThemeData myTheme = ThemeData(
  primaryColor: Colors.teal,
  scaffoldBackgroundColor: Colors.grey.shade200,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.teal, fontFamily: 'Arial'),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.teal, // Color de AppBar teal
    foregroundColor: Colors.white, // Título de AppBar blanco
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyecto Flutter',
      theme: myTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const FirstScreen(),
        '/second': (context) => const SecondScreen(),
        '/staticTasks': (context) => const StaticTasksScreen(),
        '/dynamicTasks': (context) => DynamicTasksScreen(),
      },
    );
  }
}

// Primera pantalla con botón, campo de texto y etiqueta
class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  // === TEXTEDITINGCONTROLLER ===
  // 1. Declaración: Crea la instancia del Controller.
  final TextEditingController _controller = TextEditingController(); 
  String displayedText = '';

  @override
  void dispose() {
    // 2. Liberación: ¡MUY IMPORTANTE! Libera los recursos de memoria del Controller.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Primera Pantalla')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller, // 3. Asignación: Conecta el Controller al TextField.
              decoration: const InputDecoration(labelText: 'Ingresa texto aquí'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // 4. Uso: Accede al valor del Controller para actualizar el estado.
                  displayedText = _controller.text; 
                });
              },
              child: const Text('Mostrar Texto'),
            ),
            const SizedBox(height: 20),
            Text('Texto ingresado: $displayedText'),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/second'),
              child: const Text('Ir a Segunda Pantalla (ScrollController)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/staticTasks'),
              child: const Text('Mostrar Tareas Estáticas (Stateless)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/dynamicTasks'),
              child: const Text('Mostrar Tareas Dinámicas (Nuevo Controller)'),
            ),
          ],
        ),
      ),
    );
  }
}

// Segunda pantalla con lista, menú desplegable y tarjeta
class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String dropdownValue = 'Opción 1';
  // Aumentamos los items para forzar la barra de desplazamiento
  final List<String> items = List.generate(20, (index) => 'Elemento Deslizable ${index + 1}'); 

  // === SCROLLCONTROLLER ===
  // 1. Declaración: Almacena la referencia del controlador de desplazamiento.
  late ScrollController _scrollController; 

  @override
  void initState() {
    super.initState();
    // 2. Inicialización: Crea la instancia del Controller.
    _scrollController = ScrollController(); 
  }

  @override
  void dispose() {
    // 3. Liberación: ¡MUY IMPORTANTE! Libera el Controller al salir de la pantalla.
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Segunda Pantalla')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: dropdownValue,
              onChanged: (String? newVal) {
                setState(() {
                  dropdownValue = newVal!;
                });
              },
              items: ['Opción 1', 'Opción 2', 'Opción 3']
                  .map<DropdownMenuItem<String>>((String val) {
                return DropdownMenuItem(value: val, child: Text(val));
              }).toList(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                controller: _scrollController, // 4. Asignación: Conecta el Controller a la lista.
                children: items.map((item) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(item),
                      subtitle: Text('Descripción para $item'),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      // 5. Uso: Botón que usa el Controller para forzar el scroll al inicio.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0, // Píxel 0 es el inicio de la lista.
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        },
        child: const Icon(Icons.arrow_upward),
        tooltip: 'Ir Arriba',
      ),
    );
  }
}

// Pantalla con lista fija (Stateless Widget)
class StaticTasksScreen extends StatelessWidget {
  const StaticTasksScreen({super.key});

  final List<String> tasks = const [
    "Comprar ingredientes",
    "Ir al gimnasio",
    "Leer un libro"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tareas Estáticas (Stateless Widget)")),
      body: ListView(
        children: tasks
            .map((task) => ListTile(
                  title: Text(task),
                  leading: const Icon(Icons.check_box_outline_blank),
                ))
            .toList(),
      ),
    );
  }
}

// Pantalla con lista interactiva (Stateful Widget)
class DynamicTasksScreen extends StatefulWidget {
  const DynamicTasksScreen({super.key});

  @override
  _DynamicTasksScreenState createState() => _DynamicTasksScreenState();
}

class _DynamicTasksScreenState extends State<DynamicTasksScreen> {
  // === TEXTEDITINGCONTROLLER PARA AÑADIR TAREAS ===
  final TextEditingController _newTaskController = TextEditingController(); 

  List<Map<String, dynamic>> tasks = [
    {"title": "Terminar el reporte", "done": false},
    {"title": "Enviar correo", "done": false},
    {"title": "Comprar regalo", "done": false},
  ];

  void toggleDone(int index) {
    setState(() {
      tasks[index]["done"] = !tasks[index]["done"];
    });
  }

  void addTask() {
    // 4. Uso (Leer): Obtiene el texto del Controller.
    final String title = _newTaskController.text.trim(); 
    
    if (title.isNotEmpty) {
      setState(() {
        tasks.add({"title": title, "done": false});
        // 5. Uso (Escribir): Llama al método del Controller para limpiar el campo.
        _newTaskController.clear(); 
      });
      // Opcional: Ocultar el teclado después de añadir
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    // 6. Liberación: Asegura la limpieza de memoria del nuevo Controller.
    _newTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tareas Dinámicas (Controller de Input)")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newTaskController, // 1. Asignación: Conecta el Controller.
                    decoration: const InputDecoration(
                      labelText: 'Nueva Tarea',
                    ),
                    onSubmitted: (_) => addTask(), // 2. Uso: Llama a la lógica al presionar Enter.
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.teal),
                  onPressed: addTask, // 3. Uso: Llama a la lógica con el botón.
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index]["title"]),
                  leading: Checkbox(
                    value: tasks[index]["done"],
                    onChanged: (bool? value) => toggleDone(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
