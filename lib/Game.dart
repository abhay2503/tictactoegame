import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Game extends StatefulWidget {
   Game({required this.player1,required this.player2});

  final String player1;
  final String player2;


  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {

  final String player1val="X";
  final String player2val="O";

  String? currentPlayer;
  String? currentPlayerval;
  bool? gameOver;
  List<String>? board;


  LinearGradient linear=LinearGradient(
      colors: [Color(0xFF5A0DF3),Color(0xFF261765)],
      stops: [0.0,1.0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter
  );

  @override
   void initState() {
    // TODO: implement initState
    super.initState();
    intializeGame();
  }

  void changeturn(){
    if(currentPlayerval==player1val){
      currentPlayerval=player2val;
      currentPlayer='${widget.player2}(O)';
    }
    else{
      currentPlayerval=player1val;
      currentPlayer='${widget.player1}(X)';
    }
  }
  void winningcheck(){
    List<List<int>> winningpattern=[
      [0,1,2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for( var winningpatternposition in winningpattern)
    {
      String winningpatternposition0=board![winningpatternposition[0]];
      String winningpatternposition1=board![winningpatternposition[1]];
      String winningpatternposition2=board![winningpatternposition[2]];


      if(winningpatternposition1.isNotEmpty){
        if(winningpatternposition0==winningpatternposition1 &&
            winningpatternposition1==winningpatternposition2){
          //  all equals
          if(winningpatternposition1=="X") {
            GameOverMessage("${widget.player1} Wins");
            gameOver = true;
            return;
          }
          else{
            GameOverMessage("${widget.player2} Wins");
            gameOver = true;
            return;
          }
        }
      }
    }
  }

  void checkfordraw(){
    if(gameOver!){
      return;
    }

    bool check=true;
    for(var boardfilled in board!)
    {
      if(boardfilled.isEmpty){
        check=false;
      }
    }

    if(check){
      GameOverMessage("Draw");
      gameOver=true;
    }
  }

  GameOverMessage(String message) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              backgroundColor: Color(0xFF5A0DF3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Set border radius here
              ),

              actions: [
                Center(
                  child: Text("Game Over",style: TextStyle(
                      fontSize: 40,
                      color: Color(0xFFE6C621),
                      fontWeight: FontWeight.w900
                  ),),
                ),
                SizedBox(height: 30,),
                Center(
                  child: Text("$message", style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.white
                  ),),
                ),
                SizedBox(height: 40,),
                Center(
                  child: Container(
                    width: 200.0,
                    height: 55.0,
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.restart_alt,
                            size: 40.0,
                            color: Colors.white,),
                          Text('Restart', style: TextStyle(
                              fontSize: 27.0, fontWeight: FontWeight.bold,color: Colors.white),),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: Color(0xFFE6C621),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          )
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {

                          intializeGame();
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 40,)
              ],
            ),
          );
        }
    );
  }



  void intializeGame(){
    currentPlayer='${widget.player1}(X)';
    currentPlayerval=player1val;
    gameOver=false;
    board=["","","","","","","","",""];
  }



  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: linear
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              SizedBox(height: 95,),
              Column(
                  children:[
                    Text(
                        'Turn:',
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: Color(0xFFE6C621),
                            fontWeight: FontWeight.w900,
                            fontSize: 60,

                          ),
                        )
                    ),
                    Text(
                        currentPlayer!,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: Color(0xFFE6C621),
                            fontWeight: FontWeight.w900,
                            fontSize: 45,

                          ),
                        )
                    ),

                  ]
              ),
                SizedBox(height: 30,),
              Container(
                  width: MediaQuery.of(context).size.height / 2,
                  height: MediaQuery.of(context).size.height / 2,
                  margin:EdgeInsets.all(10),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3
                  ),
                  itemCount: board!.length,
                  itemBuilder: (context,index){
                   return GestureDetector(
                      onTap: (){
                        if (gameOver! || board![index].isNotEmpty){
                          return;
                        }

                        setState(() {
                          board![index]=currentPlayerval!;
                          changeturn();
                          winningcheck();
                          checkfordraw();
                        });
                      },
                      child: Container(

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Color(0xFF221355),
                        ),
                        margin: EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                              board![index],
                              style:GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    color: Color(0xFFE6C621),
                                    fontSize: 65,
                                    fontWeight: FontWeight.bold,
                                  )
                              )
                          ),
                        ),
                      ),
                    );
                  },

                ),
              ),
         ]
            )
            ),
          ),
        ),


    );
  }}



