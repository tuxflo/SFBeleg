# SFBeleg
Belegaufgabe für das Fach Software Factories

Hier die manuelle Code Transpilierung (bereits mit Jamus scheme getestet)
```
(prolog (quote (((ist_nachbar_von schmidt meier))
((ist_nachbar_von meier mueller))
((ist_nachbar_von mueller krause))))
(quote ( (ist_nachbar_von schmidt N)(ist_nachbar_von N mueller) ) ))
 ]
```
die Antwort lautet:
```
N = meier
```
![Bilder der Lösung](prolog_v1.jpg)

Zum Erstellen der Update Seite: Projekt "de.htwdd. ... .feature" öffnen, feature.xml Doppelklicken, Unter "Exporting" den Export Wizzard starten.
**Wichtig** 
Für den Export werden die Eclipse Plugin Development Tools benötigt. Diese also vorher entsprechend installieren.
Zum testen des Deployments:
Eclipse in Docker Container laufen lassen: https://rgrunber.wordpress.com/2016/01/26/eclipse-inside-a-docker-container/
