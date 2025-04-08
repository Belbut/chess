# Ruby Chess

A command-line Chess game written in Ruby, built as part of [The Odin Project's](https://www.theodinproject.com/) curriculum.

🔗 **Live preview**: [Not yet available]

---

## Demo

![Chess Game at Play](https://github.com/Belbut/chess/blob/main/demo/complete_game_demo.gif)  

---

## Technologies

- **Ruby**
- **Stockfish** (Chess engine)
- **RSpec** (Testing)
- **Procs & Lambdas** (Game rule architecture)
- **Commitlint** (Commit message linter)

---

## Tools

- Visual Studio Code
- Git & GitHub
- Linux CLI
- Interactive Ruby Shell (IRB)
- Pry (for advanced debugging)

---

## What I Learned

This project became much more than an exercise — it was a deep dive into software design and thoughtful engineering. I deliberately overengineered the structure, not out of necessity, but to sharpen my skills, experiment with ideas, and learn how to balance elegance with maintainability.

- Crafted a **modular OOP architecture** to manage complex, interdependent Chess rules and board states.
- Leveraged **Procs and Lambdas** to create flexible, reusable logic blocks for key rule validations (like movement restrictions, checks, and pins).
- Integrated **Stockfish**, allowing players to face off against a grandmaster-level AI, and managed external engine communication.
- Practiced **Test-Driven Development (TDD)** using **RSpec**, focusing test coverage on critical gameplay logic and input validation.
- Set up **custom Git hooks**:
  - Spellcheck enforcement before commits
  - Commit message standardization using **Commitlint**
- Refined debugging workflows using **IRB**, **Pry**, and **VS Code Debugger**, especially helpful in inspecting complex game state transitions.
- Gained insight into the importance of keeping code readable and modular, especially in large logic-heavy projects like Chess.

There are still parts of the code I’d like to refactor or improve — things I know I could make cleaner or simply implement in a more elegant way. And honestly, I’d probably enjoy doing it. But at this point, I realized the time and effort it would take wouldn’t really move the needle in terms of what I’d learn from it. So I’ve decided to leave the project as it is — and truthfully, I’m pretty happy with how it turned out.

---

## Running the Project Locally

### Prerequisites

- Ruby
- Git
- [Stockfish](https://stockfishchess.org/download/) chess engine

---
### Steps (for Linux)
1. **Install engine**
   ```bash
    sudo apt update
    sudo apt install stockfish
    which stockfish #should return /usr/games/stockfish
    ```
2. **Clone the repository:**
   ```bash
   git clone https://github.com/Belbut/chess
   ```

3. **Install dependency's**
   ```bash
   cd chess
   bundle install
   ```

4. **Play Game**
    ```bash
    ruby main.rb
    ```
    
## Author

**Belbut**
* GitHub: [Belbut](https://github.com/belbut)