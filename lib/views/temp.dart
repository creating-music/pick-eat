import 'package:flutter/material.dart';
import 'package:pick_eat/game/lotto_machine_widget.dart';

class TempScreen extends StatelessWidget {
  const TempScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("추천 메뉴 뽑기"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.red,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("추천 메뉴 뽑기", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("오늘 추천해드릴 메뉴를 뽑아보세요.", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Expanded( // ✅ LottoMachineWidget에게 명확한 높이를 줌
            child: LottoMachineWidget(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("뽑기"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(onPressed: () {}, child: const Text("선호 선택")),
              const SizedBox(width: 10),
              OutlinedButton(onPressed: () {}, child: const Text("불호 선택")),
            ],
          ),
          const SizedBox(height: 20),
        ],
      )
    );
  }
}