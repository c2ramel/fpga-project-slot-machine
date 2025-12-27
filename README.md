# FPGA Virtual Reel Slot Machine 🎰

This project implements a fully functional digital slot machine on the **Terasic DE10-Lite (Altera MAX 10)** FPGA board. It features a "Virtual Reel" architecture that simulates modern casino gaming logic with instantaneous result calculation, adjustable betting, and a dot-matrix animation system.

## 📂 Repository Structure

This project is organized to keep source code separate from Quartus compilation artifacts:

* **`src/`**: Contains all human-written Verilog source code modules (`.v` files).
* **`quartus_project/`**: Contains the Quartus Prime project files (`.qpf`, `.qsf`). **Open the project from here.**
* **`docs/`**: Documentation, pin assignment lists, and the project report.

## ✨ Features

* **True Randomness:** Utilizes a 16-bit Linear Feedback Shift Register (LFSR) to ensure statistically independent, non-deterministic results.
* **Synchronous Architecture:** Built using robust Clock Enable logic (no ripple clocks), ensuring timing stability and glitch-free operation on the 50MHz master clock.
* **Visuals:** 8x16 LED Dot Matrix display with smooth "slide-to-stop" animation logic.
* **Virtual Reel Logic:** Results are calculated instantly upon pressing spin, decoupling the math from the animation.
* **Betting System:** Adjustable bets (1-8 credits) via binary switch input.
* **Cheat Mode:** A hidden switch (`SW[0]`) overrides the LFSR to force a winning combination for demonstrations.
* **Scoreboard:** 6-digit 7-Segment display tracking current Credits and Win Amounts.

## 🛠️ Hardware Requirements

* **FPGA Board:** Terasic DE10-Lite (MAX 10 10M50DAF484C7G).
* **Display:** 2x LED Dot Matrix (8x8) modules, daisy-chained or wired to form an 8x16 grid.
* **Connections:**
    * **DOT_ROW:** Connected to GPIO pins (Active Low).
    * **DOT_COL_0 (Right):** Connected to GPIO pins (Active High).
    * **DOT_COL_1 (Left):** Connected to GPIO pins (Active High).

## 🚀 How to Run (Plug-and-Play)

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/c2ramel/fpga-project-slot-machine.git
    ```
2.  **Open in Quartus:**
    * Navigate to the `quartus_project/` folder.
    * Double-click `Final_Project_Slot_Machine.qpf` to open the project in Quartus Prime.
    * *Note: The project is configured to use relative paths, so it will automatically find the source code in `../src/`.*
3.  **Compile:**
    * Click **Start Compilation** in Quartus.
    * *Note: This will generate the necessary `db` and `output_files` folders locally on your machine.*
4.  **Upload:**
    * Connect your DE10-Lite board via USB.
    * Open the **Programmer** tool.
    * Select the generated `.sof` file (usually in `output_files/`) and click **Start**.

## 🎮 Controls

| Component | Input | Function |
| :--- | :--- | :--- |
| **KEY[0]** | Button | **Spin / Stop:** Press to bet & spin; press again to stop reels. |
| **KEY[1]** | Button | **Reset:** Resets game credits to 100. |
| **SW[3:1]** | Switches | **Bet Amount:** Binary 0-7 (Result is Bet + 1). |
| **SW[0]** | Switch | **Cheat Mode:** `0` = Fair Game, `1` = Guaranteed Win. |

## 📜 Pin Assignments

If you need to verify or change pin mappings, the full list is available in `docs/pin_assignment_updated.txt`. The project is pre-configured for the standard DE10-Lite GPIO header layout used in `Lab 10`.

---
*Created for the Digital Integrated Circuit Design Final Project by Google's Gemini AI.*





