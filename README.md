# Covsax

Buchungshilfe für Corona Impftermin in Sachsen

## Vorausetzungen
- erfolgreiche Anmeldung auf https://sachsen.impfterminvergabe.de
- für die Terminfindung wird der Link aus der Email nach erfolgreicher Registrierung sowie das zugehörige Passwort benötigt.
- lokale Installation des Browsers Google Chrome
- lokale Installation der Java Runtime

## Anwendung
- Download der Applikation: https://git.osp-dd.de/pramm/covsax/-/blob/master/covsax.war
- Start der Applikation in Terminal: > java -jar covsax.war
- Nach 10 .. 20 Sekunden ist Applikation gestartet (Ausgabe: INFO:oejs.Server:main: Started @14177ms)
- Webseite der Applikation im Browser öffnen: http://localhost:8080
- Eingabe von:
  - Link-URL und Passwort aus Anmeldung bei https://sachsen.impfterminvergabe.de
  - Anpassung der Suchdauer und der Zeit zwischen den Versuchen
  - Auswahl der max. 10 in Frage kommenden Impfzentren (diese werden in der angegebenen Reihenfolge durchgeprüft)
- Button "Termin suchen" drücken 
- Der Request des Browsers bleibt aktiv bis entweder ein Termin gefunden wurde oder die max. Suchzeit abgelaufen ist

Die Aktivitäten auf der Webseite der Impfterminvergabe werden in einem separaten Fenster des Chrome-Browser ausgeführt und können visuell verfolgt werden.

Wenn ein auswählbarer Termin gefunden wurde, bleibt das Chrome-Fenster offen, es ertönt ein Beep und die Buchung des Termins kann dann manuell abgeschlossen werden.