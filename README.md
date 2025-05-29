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
Haskell-ListaToDo  
├── app/
│ └── Main.hs # plik główny aplikacji  
├── lab/  
│ └── Notify.hs # pliki eksperymentalne  
├── src/  
│ ├── Date.hs # implementacja typu DueDate  
│ └── Task.hs # implementacja typu Task  
└── README.md  
```

---

### ✅ Uruchamianie w GHCi

Z katalogu głównego projektu uruchom GHCi:
```bash
ghci -i:src
:set -package time
:l app/Main.hs
```

W interpreterze wpisz:
```bash
main
```
