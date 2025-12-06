import 'package:critter_app/views/filter_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/critter_viewmodel.dart';
import 'glossary_page.dart';
import 'widgets/critter_tile.dart';
import 'widgets/info_tile.dart';
import '../services/audio_controller.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final AudioController _audioController = AudioController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audioController.playBackground();
  }

  @override
  void dispose() {
    _audioController.stop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // stop music when app is backgrounded
      _audioController.stop();
    } else if (state == AppLifecycleState.resumed) {
      // resume music when app comes back
      _audioController.playBackground();
    }
  }

  void _toggleMusic() {
    setState(() {
      _audioController.toggle();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CritterViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Critters Now"),
        backgroundColor: const Color.fromARGB(255, 112, 198, 154).withOpacity(0.5),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: vm.loading
            ? const Center(child: CircularProgressIndicator(
                color: Color(0xFF75e0a9),
              )
            )
            : vm.error != null
                ? Center(child: Text(vm.error!))
                : RefreshIndicator(
                  onRefresh: () async {
                    await vm.fetchAll();
                  },
                  color: const Color(0xFF75e0a9),
                  child: ListView.builder(
                    itemCount: vm.critters.length + 1,
                    itemBuilder: (_, index) {
                      if (index == 0) {
                        return InfoTile(
                          time: DateFormat.jm().format(
                              DateTime(2025, 1, 1, vm.hour, vm.minute)),
                          month: DateFormat.MMMM().format(vm.current),
                          hemisphere: vm.hemisphere[0].toUpperCase() +
                              vm.hemisphere.substring(1),
                        );
                      }
                      return CritterTile(critter: vm.critters[index - 1]);
                    },
                  ),
                  ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 112, 198, 154).withOpacity(0.5),
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Filter button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CustomFilterPage()),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.search, color: Colors.white, size: 30),
                    SizedBox(height: 4),
                    Text("Filter", style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),

              // Glossary button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GlossaryPage()),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.book, color: Colors.white, size: 30),
                    SizedBox(height: 4),
                    Text("Glossary", style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),

              // Sound button
              GestureDetector(
                onTap: _toggleMusic,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _audioController.isPlaying ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(height: 4),
                    const Text("Sound", style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

