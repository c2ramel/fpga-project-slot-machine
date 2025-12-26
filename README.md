# FPGA Virtual Reel Slot Machine 🎰

This project implements a fully functional digital slot machine on the **Terasic DE10-Lite (Altera MAX 10)** FPGA board. It uses a "Virtual Reel" architecture to simulate a casino-style experience with instantaneous result calculation.

## Features
* **Virtual Reel Logic:** Results are calculated instantly upon spin press, simulating modern casino algorithms.
* **Visuals:** 8x16 LED Dot Matrix display with scrolling animation (using two 8x8 matrices).
* **Betting System:** Adjustable bets (1-8 credits) via switches.
* **Cheat Mode:** A hidden switch (`SW[0]`) forces a win for demonstrations.
* **Scoreboard:** 7-Segment displays track Credits and Win Amounts.

## Hardware Requirements
* **Board:** Terasic DE10-Lite (MAX 10 10M50DAF484C7G).
* **Display:** 2x LED Dot Matrix (8x8) chained together.
* **Inputs:** On-board Switches and Buttons.

## File Structure
* `src/`: Contains all Verilog source code modules.
* `docs/`: Contains the detailed Project Report and Pin Assignments.

## How to Run
1.  Open Quartus Prime and create a new project targeting the **MAX 10 10M50DAF484C7G**.
2.  Add all files from the `src/` folder to the project.
3.  Import the pin assignments from `docs/pin_assignment_updated.txt`.
4.  Compile and upload to the DE10-Lite board.
5.  **Controls:**
    * **KEY[1]:** Reset Game.
    * **SW[3:1]:** Set Bet Amount.
    * **KEY[0]:** Spin / Stop.