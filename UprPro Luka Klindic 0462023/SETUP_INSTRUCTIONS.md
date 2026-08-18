# Uputstva za postavljanje UpravljanjeProizvodnjom

## 🚀 Početni koraci

### 1. SQL Server baza podataka

#### Opcija A: Korišćenje SQL Server Management Studio
1. Otvorite **SQL Server Management Studio**
2. Konekcujte se na vaš SQL Server
3. Otvorite datoteku `database_schema.sql`
4. Izvršite skriptu (F5)

#### Opcija B: Korišćenje Delphi aplikacije
Aplikacija će automatski izvršiti skriptu pri prvoj konekciji.

### 2. Konfiguracija baze podataka

Otvorite `LoginUnit.pas` i ažurirajte podatke za konekciju:

```pascal
// Primer konfiguracije
DatabaseManager.Connect(
  'localhost\SQLEXPRESS',    // Server
  'UpravljanjeProizvodnjom',  // Baza
  'sa',                        // Korisnik
  'password'                   // Lozinka
);
```

### 3. Instalacija komponenti

Potrebni su sledeći Delphi paketi:
- **Vcl.Graphics** - Grafika
- **Vcl.Grids** - Tabele (StringGrid)
- **Vcl.ComCtrls** - Tab kontrole
- **Data.Win.ADODB** - ADO konekcija sa bazom

### 4. Kompajliranje

1. Otvorite projekat `UpravljanjeProizvodnjom.dpr` u Delphi
2. Project → Compile
3. Ili koristite shortcut: Ctrl+F9

## 📋 Struktura baze podataka

### Users
- Tabela sa korisnicima
- Polja: Id, Username, Password, Email, Role, IsActive, CreatedDate, LastLogin

### Roles
- Tabela sa ulogama (ADMIN, MANAGER, OPERATOR, VIEWER)
- Dozvole mogu biti prilagođene po ulozi

### ActivityLog
- Log sve aktivnosti u sistemu
- Čuva informacije o korisnicima, akcijama, vremenu

### Products
- Proizvodi koje firme proizvode
- Polja: Id, ProductName, SKU, Price, Quantity

### Orders
- Narudžbine od kupaca
- Status: NEW, IN_PROGRESS, COMPLETED

### ProductionJobs
- Poslovi u proizvodnji
- Status: PLANNING, IN_PROGRESS, COMPLETED

### Resources
- Mašine, radnici, materijali

## 🔐 Prva prijava

**Korisničko ime:** admin  
**Lozinka:** 1234  

⚠️ **Napomena:** Promenite lozinku odmah nakon prve prijave!

## 🔧 Glavne funkcionalnosti

### 1. Login/Register sistem
- Prijava sa korisničkim imenom i lozinkom
- Registracija novih korisnika
- Reset lozinke

### 2. Admin panel
#### Korisnici
- Pregled svih korisnika
- Dodaj nove korisnike
- Ažuriranje korisnika
- Brisanje korisnika

#### Uloge
- Upravljanje ulogama i dozvolama

#### Log aktivnosti
- Pregled svih aktivnosti u sistemu
- Filtriranje po datumu

#### Postavke
- Verzija aplikacije
- Backup baze podataka

### 3. Upravljanje proizvodnjom
- Kreiraj narudžbine
- Dodelj resurse
- Prati napredak

## 📊 Moduli

| Modul | Datoteka | Opis |
|-------|----------|------|
| **Login** | LoginUnit.pas | Autentifikacija korisnika |
| **Register** | RegisterUnit.pas | Registracija novih korisnika |
| **Home** | HomeUnit.pas | Početna stranica |
| **Main** | MainUnit.pas | Upravljanje proizvodnjom |
| **Admin** | AdminUnit.pas | Admin panel |
| **Database** | DatabaseUnit.pas | Konekcija sa bazom |
| **ActivityLogger** | ActivityLoggerUnit.pas | Log aktivnosti |

## 🔄 Redosled učitavanja modula

1. **LoginUnit** - Prvo se prikazuje login
2. Ako je ADMIN → **AdminForm**
3. Ako je USER → **HomeForm**
4. Iz HomeForm → **MainForm** (proizvodnja)

## 🐛 Rešavanje problema

### Problem: "Nema konekcije sa bazom"
**Rešenje:**
- Proverite da li je SQL Server pokrenut
- Proverite connection string
- Proverite da li je baza kreirana

### Problem: "Login ne radi"
**Rešenje:**
- Izvršite database_schema.sql ponovo
- Proverite korisničko ime i lozinku u bazi
- Očistite aplikaciju (Clean Build)

### Problem: "Komponente ne rade"
**Rešenje:**
- Instalirajte sve potrebne VCL komponente
- Rebuildjujte pakete: Build → Install Packages

## 📱 Budući razvoj

Sledeće funkcionalnosti će biti dodate:
- [ ] Izveštaji (PDF/Excel)
- [ ] Notifikacije
- [ ] Mobilna verzija
- [ ] API za integraciju
- [ ] Napredne analize
- [ ] Email sistema

## 📞 Podrška

Za pitanja ili probleme, javite se razviteljima.

---

**Verzija:** 1.0.0  
**Datum:** 2025  
**Autor:** Luka Klindin
