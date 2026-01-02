# FPGA Slot Machine (Verilog / MAX10)

A fully functional, casino-style Slot Machine implemented on the **Terasic DE10-Lite (Altera MAX10)** FPGA. This project features animated 8x8 LED matrix reels, a realistic physics engine with staggered stopping times, a complete betting/wallet system, and user-configurable payout logic.

## 🚀 Quick Start (Instant Play)

**Want to play without compiling?** Use the pre-compiled bitstream:

1.  **Clone the Repo:**
    ```bash
    git clone https://github.com/c2ramel/fpga-project-slot-machine.git
    ```
2.  **Connect Board:** Plug in your DE10-Lite via USB.
3.  **Open Programmer:** Launch the **Quartus Prime Programmer** tool.
4.  **Load File:**
    * Click **Add File...** on the left.
    * Navigate to the `bin/` folder in this repository.
    * Select `slot_machine_v2.sof`.
5.  **Flash:** Check the **Program/Configure** box and click **Start**.
    * *The LEDs should light up immediately!*

---

## ⚡ Development Setup (Compile Yourself)

To modify the code or recompile:

1.  Open **Quartus Prime**.
2.  Go to **File -> Open Project** and select `slot_machine_v2.qpf` from the root directory.
    * *Note: The project automatically loads pin assignments from `slot_machine_v2.qsf`.*
3.  Modify any file in the `src/` folder.
4.  Click **Start Compilation** (Play Button).

---

## 🚀 Key Features & Controls

* **Dual Reel Display:** Two independent 8x8 LED Matrices driven by a custom MAX7219 SPI driver.
* **Realistic Physics:**
    * **Spin Duration:** 3.0 Seconds total.
    * **Staggered Stop:** Left reel locks at **2.0s**, Right reel locks at **3.0s**.
    * **Animation:** Smooth symbol cycling at ~0.1s intervals.
* **Economy System:**
    * **Wallet:** Starts with 50 credits (Customizable).
    * **Betting:** Adjustable bets (1-8 credits) via binary switches.
    * **Payouts:** Automated win detection with overflow protection.
* **Visual Feedback:**
    * **Idle/Loss:** LEDs OFF.
    * **Spinning:** "Marquee" LED chaser effect (Left-to-Right).
    * **Win:** 4x Synchronized Flashes.
* **Hardware RNG:** 16-bit Linear Feedback Shift Register (LFSR) ensures unpredictable outcomes.
* **Cheat Mode:** A hidden switch (`SW9`) forces a win for demonstration purposes.

| Control | Action |
| :--- | :--- |
| **KEY0** | **Spin Reels** |
| **KEY1** | **Reset Game** (Balance -> 50) |
| **SW0-SW2** | **Set Bet** (Binary 0-7 + 1) |
| **SW9** | **Cheat Mode** (Force Win) |

---

## 🧠 System Architecture

### 1. State Machine Controller (`slot_machine_controller.v`)
The core logic is a 3-state FSM driven by a 50MHz clock.

* **STATE_IDLE (2'b00):**
    * Waits for `KEY0` press.
    * Checks if `Balance >= Bet`.
    * Latches the random seed from the LFSR.
* **STATE_SPIN (2'b01):**
    * **Timer:** A 28-bit counter tracks the spin duration.
    * **Left Reel Stop:** Occurs at `100,000,000` cycles (**2.0 Seconds**).
    * **Right Reel Stop:** Occurs at `150,000,000` cycles (**3.0 Seconds**).
    * **Animation Speed:** Symbols advance every `5,000,000` cycles (0.1s).
* **STATE_WIN (2'b10):**
    * Triggered only if `Target_Left == Target_Right`.
    * Flashes LEDs 4 times (Cycle period: `12,500,000` cycles or 0.25s).
    * Adds calculated payout to the wallet.

### 2. Random Number Generator (`lfsr.v`)
Uses a 16-bit **Galois LFSR** with the polynomial $x^{16} + x^{14} + x^{13} + x^{11} + 1$.
* **Output:** 16-bit pseudo-random number.
* **Usage:** Bits `[1:0]` determine the Left Symbol. Bits `[3:2]` determine the Right Symbol.

### 3. Symbol ROM (`symbol_rom.v`)
Stores 4 custom 8x8 bitmaps. Row 7 is the visual "Top", Row 0 is the "Bottom".

| ID | Symbol | Payout Multiplier | Description |
| :--- | :--- | :--- | :--- |
| `00` | **SEVEN** | **x5** | Highest Payout |
| `01` | **CHERRY** | **x3** | Medium Payout |
| `02` | **BAR** | **x2** | Low Payout |
| `03` | **?** | **x1** | Money Back |

---

## ⚙️ Configuration & Customization

All game parameters are centralized in `slot_machine_controller.v`. You can edit the values at the top of the file to balance the game economy.

```verilog
// --- USER CONFIGURATION ---
localparam START_CREDITS = 12'd50;  // Starting Wallet Balance

// Payout Multipliers (Any Integer Value)
localparam MULT_SEVEN    = 100;     // Set to 100 for a Jackpot!
localparam MULT_CHERRY   = 10;
localparam MULT_BAR      = 5;
localparam MULT_QUEST    = 1;
```

**To Change Spin Duration:**
Modify the cycle counts in the `Timing Constants` section:
* `TIME_STOP_LEFT`: Defaults to `100,000,000` (2s).
* `TIME_STOP_RIGHT`: Defaults to `150,000,000` (3s).
* Formula: $Duration \times 50,000,000 \text{ Hz} = \text{Cycles}$

---

## ⚠️ Known Constraints
* **Max Balance:** The display is capped at **999**. The internal register holds up to 4095 (`12-bit`), but logic forces a clamp at 999 to prevent display overflow errors.
* **Max Bet:** 8 Credits (Binary `111` + 1).

---

## ❓ Troubleshooting

**"The pins are gone / compilation failed!"**
If you accidentally deleted the `.qsf` settings or created a new project file, you can restore the pin assignments manually:
1.  Open **Assignments -> Pin Planner**.
2.  Go to **File -> Import**.
3.  Select `docs/pin_assignments.csv`.
4.  Recompile the project.
