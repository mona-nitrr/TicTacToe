import 'package:flutter/material.dart';
import 'dart:math';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));

  bool isPlayer1Turn = true; // true for Player 1, false for Player 2
  bool gameEnded = false;
  String winner = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            gameEnded
                ? (winner.isNotEmpty
                ? 'Winner: $winner'
                : 'It\'s a draw!')
                : (isPlayer1Turn ? 'Player 1\'s turn' : 'Player 2\'s turn'),
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              int row = index ~/ 3;
              int col = index % 3;
              return GestureDetector(
                onTap: () => _onTileTap(row, col),
                child: Container(
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      board[row][col],
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetGame,
            child: Text('Restart Game'),
          ),
        ],
      ),
    );
  }

  void _onTileTap(int row, int col) {
    if (board[row][col].isEmpty && !gameEnded) {
      // Player's move
      setState(() {
        board[row][col] = 'X';
        _checkWinner();
      });

      // Check if the game is still ongoing
      if (!gameEnded) {
        // Computer's move
        _makeComputerMove();
      }
    }
  }


  void _checkWinner() {
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0].isNotEmpty) {
        _endGame(board[i][0]);
        return;
      }

      if (board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[0][i].isNotEmpty) {
        _endGame(board[0][i]);
        return;
      }
    }

    if (board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0].isNotEmpty) {
      _endGame(board[0][0]);
      return;
    }

    if (board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2].isNotEmpty) {
      _endGame(board[0][2]);
      return;
    }

    // Check for a draw
    bool draw = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j].isEmpty) {
          draw = false;
          break;
        }
      }
      if (!draw) {
        break;
      }
    }

    if (draw) {
      _endGame('');
    }
  }

  void _endGame(String winner) {
    setState(() {
      gameEnded = true;
      this.winner = winner;
    });
  }
  void _makeComputerMove() {
    // Find empty tiles
    List<int> emptyTiles = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j].isEmpty) {
          emptyTiles.add(i * 3 + j);
        }
      }
    }

    // Choose a random empty tile
    if (emptyTiles.isNotEmpty) {
      int randomIndex = Random().nextInt(emptyTiles.length);
      int randomMove = emptyTiles[randomIndex];
      int row = randomMove ~/ 3;
      int col = randomMove % 3;

      // Apply computer's move
      setState(() {
        board[row][col] = 'O';
        _checkWinner();
      });
    }
  }


  void _resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ''));
      isPlayer1Turn = true;
      gameEnded = false;
      winner = '';
    });
  }
}
