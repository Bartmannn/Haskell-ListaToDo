# 📋 ToDo List w Haskellu

Projekt menedżera zadań (ToDo List) napisanego w języku Haskell.  
Pozwala dodawać zadania z tytułem, opisem, terminem wykonania i priorytetem.  
Zadania są przechowywane w pamięci jako lista.  

---

## ⚙️ Technologie

- GHC 9.4.8
- System budowania: `cabal`
- Testy jednostkowe: `HUnit`
- Terminalowa aplikacja w katalogu `app/`
- Logika i modele w `src/`
- Dane zapisywane do pliku: `data/save.txt`

---

## 📁 Struktura katalogów

```bash
Haskell-ListaToDo/  
├── CHANGELOG.md            # Historia zmian i wersji projektu  
├── Haskell-ListaToDo.cabal # Konfiguracja projektu cabal (nazwa, zależności, build)  
├── LICENSE                 # Informacja o licencji (MIT)  
├── Makefile                # Skrypt budowania i czyszczenia projektu  
├── README.md               # Instrukcja użytkownika (ten plik)  
├── app
│   └── Main.hs
├── cabal.project.local     # Lokalne ustawienia (np. tests: True)  
├── data
│   └── save.txt
├── lab
│   └── Notify.hs           # Pliki tymczasowe  
├── src
│   ├── Date.hs
│   ├── Reader.hs
│   ├── Task.hs
│   └── Writer.hs
└── tests
    ├── TestAddTask.hs
    ├── TestDateParse.hs
    ├── TestMain.hs
    └── TestSort.hs
```

---

## 🚀 Jak uruchomić projekt

### 1. Zbuduj projekt:
```bash
cabal build
```

### 2. Uruchom program:
```bash
cabal run
```

### 3. (Opcjonalnie) Uruchom testy:
```bash
cabal test
```
