# 🎯 Project Bermuda: Logic-Driven Routing System

An intelligent, utility-based pathfinding agent that calculates mathematically optimal tactical routes across a simulated, dynamic environment (Bermuda Map). 

This project was developed as the Bring Your Own Project (BYOP) component for the **Fundamentals In Artificial Intelligence And Machine Learning** course. It bridges classical symbolic AI (Prolog) with modern scripting paradigms (Python) to demonstrate real-time reasoning, dynamic constraint satisfaction, and algorithmic search.

---

## 🧠 Core AI Concepts 

This system is architected to explicitly demonstrate the foundational theories of Artificial Intelligence:

* **Knowledge Representation:** The map's topology is not stored in traditional Python data structures. Instead, it is modeled strictly using **First-Order Predicate Logic** via SWI-Prolog. Locations and bidirectional paths are immutable `facts`, while adversarial elements are `dynamic rules`.
* **Intelligent Agents & Search Strategies:** The AI operates as a problem-solving agent. It executes an exhaustive Depth-First Search (DFS) algorithm, traversing the entire logical state space, calculating route weights, and utilizing an optimization wrapper to guarantee the absolute shortest path.

---

## ⚙️ System Architecture: How It Works

The project adheres to strict Separation of Concerns (SoC) for high code quality:

1. **The Brain (`map_kb.pl`):** The SWI-Prolog Knowledge Base. It contains the map's layout and the recursive search rules. It acts as an offline inference engine.
2. **The Interface (`tactical_route.py`):** The Python Command-Line Interface. It parses user commands and utilizes the `pyswip` library to query Prolog.
3. **Dynamic Constraint Injection:** When a user inputs an obstacle (e.g., an enemy presence), Python dynamically injects (`assertz`) that fact into Prolog's memory at runtime. The AI immediately updates its `valid_node` logic and recalculates the optimal route to avoid the threat.

---

## 💻 Setup & Installation

**Prerequisites:**
* **Python 3.8+**
* **SWI-Prolog:** Download from [SWI-Prolog Official](https://www.swi-prolog.org/download/stable). 
> ⚠️ **CRITICAL (Windows Users):** During the SWI-Prolog installation, you *must* check the box that says **"Add swipl to the system PATH"**. The Python bridge will fail to initialize without this.

**1. Clone the Environment**
```bash
git clone https://github.com/kaushalshivang-ai/Project-Bermuda
cd Project-Bermuda
```

**2. Install the Bridge Interface**
```bash
pip install -r requirements.txt
```

---

## 🚀 Execution & Tactical Scenarios

The system is strictly executed via the command line, requiring zero GUI. 

### Scenario 1: Unobstructed Routing
Calculates the fastest route from drop point to destination.
```bash
python tactical_route.py --start "Clock Tower" --end "Peak"
```

---

**Expected Terminal Output:**
```text
[>] Calculating optimal route from 'Clock Tower' to 'Peak'...

[+] ROUTE SECURED!
    Path:     Clock Tower -> Peak
    Distance: 150 units
```

### Scenario 2: Adversarial Avoidance (Dynamic Execution)
Forces the AI to abandon its preferred central route by blocking 'Clock Tower' and 'Factory' with dynamic constraints, triggering a massive detour calculation.
```bash
python tactical_route.py --start "Rim Nam Village" --end "Peak" --enemy "Clock Tower" --red_zone "Factory"
```

---

**Expected Terminal Output:**
```text
[!] RED ZONE ACTIVE: Routing around Factory
[!] ENEMY PRESENCE: Routing around Clock Tower

[>] Calculating optimal route from 'Rim Nam Village' to 'Peak'...

[+] ROUTE SECURED!
    Path:     Rim Nam Village -> Hangar -> Katulistiwa -> Bimasakti Strip -> Peak
    Distance: 825 units
```

---

## 📁 Repository Map

* `tactical_route.py` — Main execution script and bridge logic.
* `map_kb.pl` — Prolog inference engine and state-space definitions.
* `requirements.txt` — Python dependencies (`pyswip`).
* `.gitignore` — Engineering standard to exclude execution caches.
* `project_report.md` — Detailed system architecture, algorithmic analysis, and project documentation.
* `bermuda_map.png` — Visual nodal graph of the tactical state-space environment.

---

## 👨‍💻 Author

**Made by:** Shivang Kaushal  
