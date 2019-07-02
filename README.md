# README

## Dokumentation der Testschnittstellen

#### function saveResults(result, data)

##### result - Ergebnisse des Tests für Darstellung im Graph aufbereitet
	* Hash mit genau einem Eintrag pro definierter "View" des Tests (vgl. test.json - configuration/views).
	* Key des entsprechenden Eintrags muss mit dem Wert für "label" des Views übereinstimmen.
	* Die Daten die unter diesem Key gespeichert werden, werden unverändert für die Anzeige im Graph verwendet.
	* Zusätzlich ein Eintrag mit dem Key 'support' für Fördervorschläge. Dieser Eintrag verweist auf einen Hash mit den folgenden Keys:
		* total: 1 / 0 / -1 für "Verbesserung", "Keine Änderung" und "Verschlechterung", aus Sicht des Tests.
		* items: Array mit Shorthand der Items für die diese Testung einen Förderbedarf nahelegt.
	
##### data - Weitere Daten der Testung
	* Array mit genau einem Eintrag pro Item der Testung in der Reihenfolge der Testung
	* Eintrag im Array ist ein Hash mit den folgenden Keys und Werten:
		* item: Shorthand des Items 
		* result: Item-Rohwert (wird in diesem Format exportiert)
		* (optional) time: Bearbeitungszeit des Items in ms
