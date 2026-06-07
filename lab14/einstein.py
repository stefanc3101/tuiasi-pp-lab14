"""
einstein.py — Wrapper Python pentru rezolvarea problemei Einstein.

Folosește biblioteca pyswip pentru a apela motorul SWI-Prolog
și a obține soluția problemei Zebra Puzzle.
"""

from pyswip import Prolog
from pathlib import Path

# Calea absolută către fișierul Prolog
PROLOG_FILE = Path(__file__).parent.parent / "prolog" / "einstein.pl"


class EinsteinSolver:
    """Interfață Python pentru rezolvarea problemei lui Einstein via Prolog."""

    def __init__(self):
        self._prolog = Prolog()
        self._prolog.consult(str(PROLOG_FILE))

    def solve(self) -> str:
        """Returnează naționalitatea proprietarului peștelui."""
        rezultate = list(self._prolog.query("einstein(Owner)"))

        if rezultate:
            # Extragem primul rezultat
            owner = rezultate[0]["Owner"]
            # Convertim din bytes în string, necesar în anumite versiuni de PySwip
            return owner.decode("utf-8") if isinstance(owner, bytes) else str(owner)

        return "Nu s-a găsit o soluție."

    def get_solution(self) -> list[dict]:
        """Returnează lista celor 5 case cu toate atributele lor."""
        rezultate = list(self._prolog.query("solution(Houses)"))
        houses_list = []

        if rezultate:
            # Lista de case din primul rezultat
            houses = rezultate[0]["Houses"]

            for h in houses:
                # Extragem argumentele functorului `house(Culoare, Nat, Bautura, Animal, Tigari)`
                args = h.args if hasattr(h, 'args') else h

                # Funcție utilitară internă pentru curățarea string-urilor
                def to_str(val):
                    return val.decode("utf-8") if isinstance(val, bytes) else str(val)

                house_dict = {
                    "culoare": to_str(args[0]),
                    "nationalitate": to_str(args[1]),
                    "bautura": to_str(args[2]),
                    "animal": to_str(args[3]),
                    "tigari": to_str(args[4])
                }
                houses_list.append(house_dict)

        return houses_list