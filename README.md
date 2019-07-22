# README

## Dokumentation der Testschnittstellen

#### function saveResults(result, data)

##### result - Ergebnisse des Tests für Darstellung im Graph aufbereitet
	* Hash mit genau einem Eintrag pro definierter "View" des Tests (vgl. test.json - configuration/views).
	* Key des entsprechenden Eintrags muss mit dem Wert für "label" des Views übereinstimmen.
	* Die Daten die unter diesem Key gespeichert werden, werden unverändert für die Anzeige im Graph verwendet.

##### report - Qualitative Aufbereitung
    Hash mit drei Einträgen:
		* total: 1 / 0 / -1 für "Verbesserung", "Keine Änderung" und "Verschlechterung", aus Sicht des Tests.
		* positive: Array mit Shorthand der Items, die in dieser Testung "gut" waren.
		* negative: Array mit Shorthand der Items, die in dieser Testung "schlecht" waren.
	
##### extra_data - Weitere Daten der Testung
	* Array mit genau einem Eintrag pro Item der Testung in der Reihenfolge der Testung
	* Eintrag im Array ist ein Hash mit den folgenden Keys und Werten:
		* item: Shorthand des Items 
		* result: Item-Rohwert (wird in diesem Format exportiert)
		* (optional) time: Bearbeitungszeit des Items in ms
		
#### function exit()
    * Beendet den Testablauf 

#### function startTimer()
    * Speichert den aktuellen Zeitstempel, kann zusammen mit stopTimer() zur Zeitmessung verwendet werden.

#### function stopTimer()
    * Gibt die Differenz zwischen dem vorher gespeicherten Zeitstempel und der aktuellen Zeit zurück.

#### function shuffleArray(array)
    * Ordnet die Elemente des übergebenen Arrays zufällig neu an. Mutiert das übergebene Array!
 
#### function showFeedback(result, timedout)
    * Zeigt eine generische Ergebnisseite, die durch die Werte von result und timedout gestaltet wird.
        * result: -1, falls das aktuelle Ergebnis eine Verschlechterung darstellt, 0 falls keine Änderung erfolgt ist und 1, falls eine Verbesserung zur letzten Messung vorliegt.
        * timedout: true, falls das Ende des Tests durch ein Ablaufen der Zeit eingetreten ist, false falls alle Items bearbeitet wurden.
