"""
family.py — Wrapper Python pentru baza de cunoștințe family.pl.

Folosește biblioteca pyswip pentru a interoga motorul SWI-Prolog
din cod Python.
"""

from pyswip import Prolog
from pathlib import Path

# Calea absolută către fișierul Prolog
PROLOG_FILE = Path(__file__).parent.parent / "prolog" / "family.pl"


class FamilyKnowledgeBase:
    """Interfață Python pentru baza de cunoștințe despre relații de familie."""

    def __init__(self):
        self._prolog = Prolog()
        self._prolog.consult(str(PROLOG_FILE))

    def _to_str(self, val) -> str:
        """Helper intern pentru a converti răspunsurile din Prolog (bytes) în string."""
        return val.decode("utf-8") if isinstance(val, bytes) else str(val)

    def query_matusa(self) -> list[tuple[str, str]]:
        """Returnează lista de perechi (copil, mătușă)."""
        rezultate = list(self._prolog.query("matusa(X,Y)"))
        return [(self._to_str(rez["X"]), self._to_str(rez["Y"])) for rez in rezultate]

    def query_bunic(self) -> list[tuple[str, str]]:
        """Returnează lista de perechi (nepot, bunic)."""
        rezultate = list(self._prolog.query("bunicul(X,Y)"))
        return [(self._to_str(rez["X"]), self._to_str(rez["Y"])) for rez in rezultate]

    def query_sora_lui(self, name: str) -> list[str]:
        """Returnează lista surorilor persoanei cu numele dat."""
        # Ne asigurăm că numele este un atom corect format (fără majuscule)
        name_atom = name.lower()

        # Interogăm sora(X, persoana_cautata)
        rezultate = list(self._prolog.query(f"sora(X, {name_atom})"))
        return [self._to_str(rez["X"]) for rez in rezultate]

    def query_var(self) -> list[tuple[str, str]]:
        """Returnează lista de perechi de veri."""
        rezultate = list(self._prolog.query("var(X,Y)"))
        return [(self._to_str(rez["X"]), self._to_str(rez["Y"])) for rez in rezultate]