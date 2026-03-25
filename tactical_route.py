import argparse
import sys
from pyswip import Prolog

def find_route(start, end, red_zones, enemy_areas):
    # Initialize the Prolog engine
    prolog = Prolog()
    
    # === THE CONNECTION POINT ===
    # Updated to look for the file in the exact same folder
    try:
        prolog.consult("map_kb.pl") 
    except Exception as e:
        print(f"[ERROR] Could not find the Prolog file. Ensure 'map_kb.pl' is in the same folder.\nDetails: {e}")
        sys.exit(1)
    # ============================
        
    print("\n" + "="*50)
    print("       TACTICAL PATHFINDER INITIALIZED")
    print("="*50)
    
    # Clean up old dynamic facts
    list(prolog.query("retractall(red_zone(_))"))
    list(prolog.query("retractall(enemy_area(_))"))
    
    # Inject dynamic constraints into Prolog
    if red_zones:
        for rz in red_zones:
            prolog.assertz(f"red_zone('{rz}')")
            print(f"[!] RED ZONE ACTIVE: Routing around {rz}")
            
    if enemy_areas:
        for ea in enemy_areas:
            prolog.assertz(f"enemy_area('{ea}')")
            print(f"[!] ENEMY PRESENCE: Routing around {ea}")
            
    print(f"\n[>] Calculating optimal route from '{start}' to '{end}'...")
    
    # Query the engine
    query_str = f"shortest_path('{start}', '{end}', Path, Distance)"
    try:
        results = list(prolog.query(query_str))
        if not results:
            print("\n[X] MISSION FAILED: No valid route exists.")
        else:
            best_route = results[0]
            clean_path = [node.decode('utf-8') if isinstance(node, bytes) else str(node) for node in best_route["Path"]]
            print("\n[+] ROUTE SECURED!")
            print(f"    Path:     {' -> '.join(clean_path)}")
            print(f"    Distance: {best_route['Distance']} units")
    except Exception as e:
        print(f"\n[ERROR] Calculation failed: {e}")

    print("="*50 + "\n")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Tactical Map Pathfinder")
    parser.add_argument("--start", required=True)
    parser.add_argument("--end", required=True)
    parser.add_argument("--red_zone", nargs='+', default=[])
    parser.add_argument("--enemy", nargs='+', default=[])
    
    args = parser.parse_args()
    find_route(args.start, args.end, args.red_zone, args.enemy)