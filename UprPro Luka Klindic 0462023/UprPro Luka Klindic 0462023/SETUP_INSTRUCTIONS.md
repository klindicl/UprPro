# UprPro 2.1 - lokalna baza

Ova verzija više ne koristi SQL Server/ADO. Baza je SQLite i kreira se automatski pri prvom pokretanju.

## Pokretanje
1. Otvorite `UpravljanjeProizvodnjom.dpr` u Delphi-ju.
2. Izaberite Win32 platformu.
3. Build/Compile projekat.
4. Pokrenite `.exe`.
5. Pri prvom pokretanju aplikacija sama kreira bazu i tabele.

## Podaci za prvi login
- Korisničko ime: `admin`
- Lozinka: `1234`

## Gde je baza?
`%LOCALAPPDATA%\UprPro\UprPro.db`

Nema potrebe za SQL Server Express, SSMS, OLE DB providerom ili ručnim izvršavanjem SQL skripte.
