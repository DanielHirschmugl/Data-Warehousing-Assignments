# DWH-Datenbank (PostgreSQL in Docker)

PostgreSQL-16-Datenbank für das Data-Warehousing-Projekt, betrieben als Docker-Container über Docker Compose.

## Voraussetzungen

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (inkl. Docker Compose)

## Verbindungsdaten

| Parameter  | Wert            |
|------------|-----------------|
| Container  | `dwh-container` |
| Host       | `localhost`     |
| Port       | `5434`          |
| Datenbank  | `dwh-database`  |
| User       | `dwh`           |
| Passwort   | `dwh`           |

Verbindungs-URL:

```
postgresql://dwh:dwh@localhost:5434/dwh-database
```

## Starten und Stoppen

Alle Befehle im Projektordner (wo die `docker-compose.yml` liegt) ausführen:

```powershell
docker compose up -d      # Container erstellen und starten
docker compose stop       # Container stoppen
docker compose start      # gestoppten Container wieder starten
docker compose down       # Container entfernen (Daten bleiben im Volume erhalten)
docker compose ps         # Status anzeigen
docker compose logs -f    # Logs anzeigen
```

## SQL-Konsole

```powershell
docker exec -it dwh-container psql -U dwh -d dwh-database
```

SQL-Datei ausführen:

```powershell
Get-Content .\script.sql | docker exec -i dwh-container psql -U dwh -d dwh-database
```

## Datenhaltung

Die Daten liegen im Docker-Volume `dwh-container-data` und bleiben auch nach `docker compose down` erhalten.

Datenbank komplett zurücksetzen (**löscht alle Daten!**):

```powershell
docker compose down -v
docker compose up -d
```

## Hinweise

- Der Datenbankname enthält einen Bindestrich. In SQL-Anweisungen muss er daher in Anführungszeichen stehen, z. B. `"dwh-database"`.
- Der Container ist auf Port `5434` erreichbar, weil die Ports `5432` und `5433` lokal durch native PostgreSQL-Installationen (Windows-Dienste `postgresql-x64-16` und `postgresql-x64-17`) belegt sind. Intern im Container läuft PostgreSQL weiterhin auf `5432`.
- Die Zugangsdaten sind nur für die lokale Entwicklung gedacht.
