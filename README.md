# 📋 ToDo List w Haskellu

Projekt menedżera zadań (ToDo List) napisanego w języku Haskell.  
Pozwala dodawać zadania z tytułem, opisem, terminem wykonania i priorytetem.  
Zadania są przechowywane w pamięci jako lista.  

---

## 🚀 Jak uruchomić projekt

### 🔧 Wymagania
- GHC (kompilator Haskella)
- GHCi (interaktywny interpreter)
- Folder `src/` z modułami `Task.hs` i `Date.hs`
- Plik `app/Main.hs`

---

### 📁 Struktura katalogów

```bash
Haskell-ListaToDo/
├── Makefile        # proces kompilacji programu  
├── README.md  
├── app/  
│   └── Main.hs     # plik główny aplikacji  
├── build/          # katalog skompilowanych wersji aplikacji  
├── data/  
│   └── save.txt  
├── lab/            # pliki tymczasowe laboratoryjne  
│   └── Notify.hs  
├── resources/  
├── src/  
│   ├── Date.hs  
│   └── Task.hs  
└── tests/  
    ├── TestAddTask.hs  
    ├── TestDateParse.hs  
    ├── TestMain.hs  
    └── TestSort.hs  
```

---

### ✅ Uruchamianie w GHCi

Z katalogu głównego projektu uruchom GHCi:
```bash
ghci -i:src -i:tests
```

Wymagane moduły importuje się następująco:
```
:set -package time
:set -package HUnit
```

Główny program uruchamia się:
```
:l app/Main.hs
main
```

Testy uruchamia się:
```
:l test/TestMain.hs
mainTest
```

