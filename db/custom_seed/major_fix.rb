#Problem für SEL2
r = Result.find(17)
r.views = {"V1":20,
           "V2":{
               "LG":"58.8",
               "RI":"20 von 60",
               "ADA":"\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e 9\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003ePause, Wand, Fibel, Ampel, Weg, Mofas, Auto, Brot, Film\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e 8\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eAbfall, Schule, Wasser, Kinder, Geschenk, Dose, Sofa, Reifen",
               "AVP":"\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e 11\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003etrinkt, hell, male, bade, hell, schnell, schlaue, lerne, kalt, lange, leben\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e 6\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003ekleinen, schwierigen, tollen, schwimmen, scharfe, laufen",
               "LGM":"7"
           },
           "V3":{
               "LG":"58.8",
               "RI":"20 von 60",
               "ADA":"\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e 9\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003ePause, Wand, Fibel, Ampel, Weg, Mofas, Auto, Brot, Film\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e 8\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eAbfall, Schule, Wasser, Kinder, Geschenk, Dose, Sofa, Reifen",
               "AVP":"\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e 11\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003etrinkt, hell, male, bade, hell, schnell, schlaue, lerne, kalt, lange, leben\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e 6\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003ekleinen, schwierigen, tollen, schwimmen, scharfe, laufen",
               "LGM":"7",
               "SUM":20
           }
}
r.report = {
    "trend":-1,
    "negative":["I44","I22","I27","I8","I55","I47","I36","I16","I41","I53","I56","I14","I57","I62"],
    "positive":["I30","I7","I48","I66","I35","I51","I26","I15","I2","I63","I45","I54","I6","I46","I39","I9","I32","I64","I4","I29"]
}
r.data = [
    {"item":"I30","time":1575190428107,"group":"1","answer":"Pause","result":1},
    {"item":"I44","time":7709,"group":"2","answer":"klei­nen","result":0},
    {"item":"I22","time":4680,"group":"2","answer":"schwie­ri­gen","result":0},
    {"item":"I27","time":10094,"group":"1","answer":"Ab­fall","result":0},
    {"item":"I7","time":6354,"group":"1","answer":"Wand","result":1},
    {"item":"I48","time":8342,"group":"2","answer":"trinkt","result":1},
    {"item":"I66","time":20042,"group":"1","answer":"Fibel","result":1},
    {"item":"I8","time":7484,"group":"2","answer":"tol­len","result":0},
    {"item":"I55","time":7050,"group":"2","answer":"schwim­men","result":0},
    {"item":"I47","time":6420,"group":"1","answer":"Schu­le","result":0},
    {"item":"I35","time":8166,"group":"2","answer":"hell","result":1},
    {"item":"I51","time":6342,"group":"1","answer":"Ampel","result":1},
    {"item":"I26","time":13608,"group":"1","answer":"Weg","result":1},
    {"item":"I15","time":6080,"group":"2","answer":"male","result":1},
    {"item":"I2","time":8852,"group":"2","answer":"bade","result":1},
    {"item":"I36","time":13738,"group":"1","answer":"Was­ser","result":0},
    {"item":"I63","time":13631,"group":"1","answer":"Mofas","result":1},
    {"item":"I45","time":6010,"group":"2","answer":"hell","result":1},
    {"item":"I54","time":5478,"group":"2","answer":"schnell","result":1},
    {"item":"I16","time":19384,"group":"1","answer":"Kin­der","result":0},
    {"item":"I6","time":11549,"group":"2","answer":"schlaue","result":1},
    {"item":"I46","time":7713,"group":"1","answer":"Auto","result":1},
    {"item":"I41","time":11575,"group":"1","answer":"Ge­schenk","result":0},
    {"item":"I39","time":7910,"group":"2","answer":"lerne","result":1},
    {"item":"I53","time":8006,"group":"1","answer":"Nadel","result":0},
    {"item":"I9","time":7606,"group":"2","answer":"kalt","result":1},
    {"item":"I32","time":9198,"group":"2","answer":"lange","result":1},
    {"item":"I56","time":10022,"group":"1","answer":"Was­ser","result":0},
    {"item":"I14","time":6862,"group":"2","answer":"schar­fe","result":0},
    {"item":"I64","time":5482,"group":"1","answer":"Brot","result":1},
    {"item":"I4","time":12338,"group":"1","answer":"Film","result":1},
    {"item":"I57","time":6438,"group":"2","answer":"lau­fen","result":0},
    {"item":"I29","time":4756,"group":"2","answer":"leben","result":1},
    {"item":"I62","time":5994,"group":"1","answer":"Rei­fen","result":0},
    {"item":"I37","time":"NA","group":"1","answer":"NA","result":"NA"},
    {"item":"I34","time":"NA","group":"2","answer":"NA","result":"NA"},
    {"item":"I11","time":"NA","group":"2","answer":"NA","result":"NA"},
    {"item":"I65","time":"NA","group":"1","answer":"NA","result":"NA"},
    {"item":"I58","time":"NA","group":"1","answer":"NA","result":"NA"},
    {"item":"I23","time":"NA","group":"2","answer":"NA","result":"NA"},
    {"item":"I28","time":"NA","group":"2","answer":"NA","result":"NA"},
    {"item":"I50","time":"NA","group":"1","answer":"NA","result":"NA"},
    {"item":"I60","time":"NA","group":"2","answer":"NA","result":"NA"},
    {"item":"I61","time":"NA","group":"1","answer":"NA","result":"NA"},
    {"item":"I52","time":"NA","group":"2","answer":"NA","result":"NA"},
    {"item":"I1","time":"NA","group":"1","answer":"NA","result":"NA"},
    {"item":"I49","time":"NA","group":"2","answer":"NA","result":"NA"},
    {"item":"I43","time":"NA","group":"1","answer":"NA","result":"NA"},
    {"item":"I42","time":"NA","group":"2","answer":"NA","result":"NA"},
    {"item":"I17","time":"NA","group":"1","answer":"NA","result":"NA"},
    {"item":"I33","time":"NA","group":"1","answer":"NA","result":"NA"},
    {"item":"I3","time":"NA","group":"2","answer":"NA","result":"NA"},
    {"item":"I59","time":"NA","group":"1","answer":"NA","result":"NA"},
    {"item":"I19","time":"NA","group":"2","answer":"NA","result":"NA"},
    {"item":"I13","time":"NA","group":"1","answer":"NA","result":"NA"},
    {"item":"I25","time":"NA","group":"2","answer":"NA","result":"NA"},
    {"item":"I20","time":"NA","group":"1","answer":"NA","result":"NA"},
    {"item":"I38","time":"NA","group":"2","answer":"NA","result":"NA"},
    {"item":"I18","time":"NA","group":"2","answer":"NA","result":"NA"},
    {"item":"I10","time":"NA","group":"1","answer":"NA","result":"NA"},
    {"item":"I12","time":"NA","group":"1","answer":"NA","result":"NA"},
    {"item":"I40","time":"NA","group":"1","answer":"NA","result":"NA"},
    {"item":"I5","time":"NA","group":"1","answer":"NA","result":"NA"},
    {"item":"I24","time":"NA","group":"1","answer":"NA","result":"NA"},
    {"item":"I31","time":"NA","group":"1","answer":"NA","result":"NA"},
    {"item":"I21","time":"NA","group":"1","answer":"NA","result":"NA"}
]
r.save

#Problem für SEL4
r = Result.find(22)
r.views = {
    "V1":15,
    "V2":{
        "LG":"60.0",
        "RI":"15 von 60",
        "ADA":"\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e 3\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eTür, Vogel, Baby\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e 4\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eSchere, Büro, Bilder, Blumen",
        "AVK":"\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e 5\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eweil, bevor, mit, für, weder\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e 4\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eWährend, Durch, Anstatt, aber",
        "AVP":"\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e 7\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003ebackt, spitz, böse, dicke, runde, kauft, scheint\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e 2\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003espricht, hungrig",
        "LGM":"5"
    },
    "V3":{
        "LG":"60.0",
        "RI":"15 von 60",
        "ADA":"\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e 3\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eTür, Vogel, Baby\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e 4\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eSchere, Büro, Bilder, Blumen",
        "AVK":"\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e 5\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eweil, bevor, mit, für, weder\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e 4\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eWährend, Durch, Anstatt, aber",
        "AVP":"\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e 7\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003ebackt, spitz, böse, dicke, runde, kauft, scheint\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e 2\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003espricht, hungrig",
        "LGM":"5",
        "SUM":15
    }
}
r.report = {
    "trend":0,
    "negative":["I2","I3","I4","I7","I13","I14","I15","I17","I23","I25"],
    "positive":["I1","I5","I6","I8","I9","I10","I11","I12","I16","I18","I19","I20","I21","I22","I24"]
}
r.data = [
    {"item":"I1","time":1575016694649,"group":"2","answer":"backt","result":1,"description":"backt"},
    {"item":"I2","time":776,"group":"1","answer":"...........","result":0,"description":"Schere"},
    {"item":"I3","time":10848,"group":"3","answer":"Wäh­rend","result":0,"description":"Während"},
    {"item":"I4","time":424,"group":"1","answer":"...........","result":0,"description":"Büro"},
    {"item":"I5","time":10240,"group":"2","answer":"spitz","result":1,"description":"spitz"},
    {"item":"I6","time":10464,"group":"3","answer":"weil","result":1,"description":"weil"},
    {"item":"I7","time":13775,"group":"1","answer":"Bil­der","result":0,"description":"Bilder"},
    {"item":"I8","time":8328,"group":"2","answer":"böse","result":1,"description":"böse"},
    {"item":"I9","time":11041,"group":"3","answer":"bevor","result":1,"description":"bevor"},
    {"item":"I10","time":18383,"group":"3","answer":"mit","result":1,"description":"mit"},
    {"item":"I11","time":8120,"group":"2","answer":"dicke","result":1,"description":"dicke"},
    {"item":"I12","time":14225,"group":"2","answer":"runde","result":1,"description":"runde"},
    {"item":"I13","time":9847,"group":"1","answer":"Blu­men","result":0,"description":"Blumen"},
    {"item":"I14","time":35008,"group":"2","answer":"packt","result":0,"description":"spricht"},
    {"item":"I15","time":14687,"group":"3","answer":"Über","result":0,"description":"Durch"},
    {"item":"I16","time":10936,"group":"1","answer":"Tür","result":1,"description":"Tür"},
    {"item":"I17","time":24049,"group":"3","answer":"Davon","result":0,"description":"Anstatt"},
    {"item":"I18","time":13279,"group":"2","answer":"kauft","result":1,"description":"kauft"},
    {"item":"I19","time":12024,"group":"1","answer":"Vogel","result":1,"description":"Vogel"},
    {"item":"I20","time":11592,"group":"2","answer":"scheint","result":1,"description":"scheint"},
    {"item":"I21","time":7304,"group":"3","answer":"für","result":1,"description":"für"},
    {"item":"I22","time":5927,"group":"1","answer":"Baby","result":1,"description":"Baby"},
    {"item":"I23","time":7841,"group":"2","answer":"hung­rig","result":0,"description":"hungrig"},
    {"item":"I24","time":20568,"group":"3","answer":"weder","result":1,"description":"weder"},
    {"item":"I25","time":72127,"group":"3","answer":"oder","result":0,"description":"aber"},
    {"item":"I26","time":"NA","group":"2","answer":"NA","result":"NA","description":"aber"},
    {"item":"I27","time":"NA","group":"1","answer":"NA","result":"NA","description":"aber"},
    {"item":"I28","time":"NA","group":"1","answer":"NA","result":"NA","description":"aber"},
    {"item":"I29","time":"NA","group":"3","answer":"NA","result":"NA","description":"aber"},
    {"item":"I30","time":"NA","group":"2","answer":"NA","result":"NA","description":"aber"},
    {"item":"I31","time":"NA","group":"2","answer":"NA","result":"NA","description":"aber"},
    {"item":"I32","time":"NA","group":"1","answer":"NA","result":"NA","description":"aber"},
    {"item":"I33","time":"NA","group":"3","answer":"NA","result":"NA","description":"aber"},
    {"item":"I34","time":"NA","group":"2","answer":"NA","result":"NA","description":"aber"},
    {"item":"I35","time":"NA","group":"1","answer":"NA","result":"NA","description":"aber"},
    {"item":"I36","time":"NA","group":"3","answer":"NA","result":"NA","description":"aber"},
    {"item":"I37","time":"NA","group":"2","answer":"NA","result":"NA","description":"aber"},
    {"item":"I38","time":"NA","group":"1","answer":"NA","result":"NA","description":"aber"},
    {"item":"I39","time":"NA","group":"3","answer":"NA","result":"NA","description":"aber"},
    {"item":"I40","time":"NA","group":"2","answer":"NA","result":"NA","description":"aber"},
    {"item":"I41","time":"NA","group":"3","answer":"NA","result":"NA","description":"aber"},
    {"item":"I42","time":"NA","group":"1","answer":"NA","result":"NA","description":"aber"},
    {"item":"I43","time":"NA","group":"1","answer":"NA","result":"NA","description":"aber"},
    {"item":"I44","time":"NA","group":"1","answer":"NA","result":"NA","description":"aber"},
    {"item":"I45","time":"NA","group":"2","answer":"NA","result":"NA","description":"aber"},
    {"item":"I46","time":"NA","group":"2","answer":"NA","result":"NA","description":"aber"},
    {"item":"I47","time":"NA","group":"3","answer":"NA","result":"NA","description":"aber"},
    {"item":"I48","time":"NA","group":"1","answer":"NA","result":"NA","description":"aber"},
    {"item":"I49","time":"NA","group":"1","answer":"NA","result":"NA","description":"aber"},
    {"item":"I50","time":"NA","group":"2","answer":"NA","result":"NA","description":"aber"},
    {"item":"I51","time":"NA","group":"3","answer":"NA","result":"NA","description":"aber"},
    {"item":"I52","time":"NA","group":"1","answer":"NA","result":"NA","description":"aber"},
    {"item":"I53","time":"NA","group":"2","answer":"NA","result":"NA","description":"aber"},
    {"item":"I54","time":"NA","group":"3","answer":"NA","result":"NA","description":"aber"},
    {"item":"I55","time":"NA","group":"2","answer":"NA","result":"NA","description":"aber"},
    {"item":"I56","time":"NA","group":"3","answer":"NA","result":"NA","description":"aber"},
    {"item":"I57","time":"NA","group":"1","answer":"NA","result":"NA","description":"aber"},
    {"item":"I58","time":"NA","group":"2","answer":"NA","result":"NA","description":"aber"},
    {"item":"I59","time":"NA","group":"1","answer":"NA","result":"NA","description":"aber"},
    {"item":"I60","time":"NA","group":"3","answer":"NA","result":"NA","description":"aber"}
]
r.save

#Problem für SEL6
r = Result.find(16)
r.views = {
    "V1":5,
    "V2": {
        "KO":"\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e 2\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eTagen, kaut\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e 8\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eWinter, Minuten, tanken, Anlegeplätze, Bürotür, fährt, rief, schließen",
        "LG":"16.1",
        "RI":"5 von 93",
        "INF":"\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e 1\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eihr\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e 10\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eeuch, Pflanzen, sie, Auto, Schwimmen, verstummen, Diese, ihr, Weg, Dame",
        "LGM":"6",
        "KOMS":"\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e 2\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eliebt, wenig\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e 8\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003esehr, gefährliche, gute, verbessert, verschwundenen, nie, besucht, hochwertig"
    },
    "V3":{
        "KO":"\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e 2\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eTagen, kaut\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e 8\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eWinter, Minuten, tanken, Anlegeplätze, Bürotür, fährt, rief, schließen",
        "LG":"16.1",
        "RI":"5 von 93",
        "INF":"\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e 1\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eihr\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e 10\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eeuch, Pflanzen, sie, Auto, Schwimmen, verstummen, Diese, ihr, Weg, Dame",
        "LGM":"6",
        "SUM":5,
        "KOMS":"\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e 2\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003eliebt, wenig\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e 8\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003esehr, gefährliche, gute, verbessert, verschwundenen, nie, besucht, hochwertig"
    }
}
r.report = {
    "trend":-1,
    "negative":["I92","I77","I82","I39","I4","I19","I41","I26","I45","I85","I21","I83","I2","I20","I91","I87","I31","I28","I37","I18","I34","I38","I60","I74","I42","I90"],
    "positive":["I62","I8","I51","I80","I32"]
}
r.data = [
    {"item":"I92","time":1575015891793,"group":"2","answer":"uns","result":0,"description":"euch"},
    {"item":"I77","time":10171,"group":"3","answer":"Win­ter","result":0,"description":"Winter"},
    {"item":"I62","time":35703,"group":"1","answer":"liebt","result":1,"description":"liebt"},
    {"item":"I82","time":20437,"group":"3","answer":"Mi­nu­ten","result":0,"description":"Minuten"},
    {"item":"I39","time":19171,"group":"1","answer":"neu­lich","result":0,"description":"sehr"},
    {"item":"I8","time":9781,"group":"2","answer":"ihr","result":1,"description":"ihr"},
    {"item":"I4","time":15546,"group":"1","answer":"ge­fähr­li­che","result":0,"description":"gefährliche"},
    {"item":"I19","time":21921,"group":"2","answer":"Pflan­zen","result":0,"description":"Pflanzen"},
    {"item":"I51","time":32533,"group":"3","answer":"Tagen","result":1,"description":"Tagen"},
    {"item":"I41","time":44807,"group":"2","answer":"wir","result":0,"description":"sie"},
    {"item":"I26","time":311,"group":"3","answer":"...........","result":0,"description":"tanken"},
    {"item":"I45","time":50,"group":"1","answer":"...........","result":0,"description":"gute"},
    {"item":"I85","time":319,"group":"2","answer":"...........","result":0,"description":"Auto"},
    {"item":"I21","time":42,"group":"3","answer":"...........","result":0,"description":"Anlegeplätze"},
    {"item":"I83","time":251,"group":"1","answer":"...........","result":0,"description":"verbessert"},
    {"item":"I2","time":21245,"group":"1","answer":"ge­fun­den","result":0,"description":"verschwundenen"},
    {"item":"I20","time":2859,"group":"3","answer":"Schnür­sen­kel","result":0,"description":"Bürotür"},
    {"item":"I91","time":7875,"group":"2","answer":"Schwim­men","result":0,"description":"Schwimmen"},
    {"item":"I87","time":3031,"group":"2","answer":"plap­pern","result":0,"description":"verstummen"},
    {"item":"I31","time":2485,"group":"3","answer":"rennt","result":0,"description":"fährt"},
    {"item":"I28","time":2749,"group":"1","answer":"lange","result":0,"description":"nie"},
    {"item":"I37","time":8062,"group":"2","answer":"Wir","result":0,"description":"Diese"},
    {"item":"I18","time":4016,"group":"1","answer":"be­sucht","result":0,"description":"besucht"},
    {"item":"I34","time":2234,"group":"3","answer":"hass­te","result":0,"description":"rief"},
    {"item":"I38","time":2406,"group":"1","answer":"bil­lig","result":0,"description":"hochwertig"},
    {"item":"I60","time":5453,"group":"2","answer":"uns","result":0,"description":"ihr"},
    {"item":"I80","time":2406,"group":"3","answer":"kaut","result":1,"description":"kaut"},
    {"item":"I74","time":2344,"group":"3","answer":"öff­nen","result":0,"description":"schließen"},
    {"item":"I42","time":2515,"group":"2","answer":"Knopf","result":0,"description":"Weg"},
    {"item":"I32","time":2579,"group":"1","answer":"wenig","result":1,"description":"wenig"},
    {"item":"I90","time":2309,"group":"2","answer":"Au­to­tür","result":0,"description":"Dame"},
    {"item":"I15","time":"NA","group":"3","answer":"NA","result":"NA","description":"Sekunden"},
    {"item":"I72","time":"NA","group":"1","answer":"NA","result":"NA","description":"verbogen"},
    {"item":"I48","time":"NA","group":"1","answer":"NA","result":"NA","description":"niemals"},
    {"item":"I49","time":"NA","group":"2","answer":"NA","result":"NA","description":"feiern"},
    {"item":"I44","time":"NA","group":"3","answer":"NA","result":"NA","description":"Schreibtisch"},
    {"item":"I54","time":"NA","group":"1","answer":"NA","result":"NA","description":"rutschen"},
    {"item":"I69","time":"NA","group":"3","answer":"NA","result":"NA","description":"Damals"},
    {"item":"I66","time":"NA","group":"2","answer":"NA","result":"NA","description":"Es"},
    {"item":"I7","time":"NA","group":"3","answer":"NA","result":"NA","description":"jubeln"},
    {"item":"I9","time":"NA","group":"1","answer":"NA","result":"NA","description":"nicht"},
    {"item":"I81","time":"NA","group":"2","answer":"NA","result":"NA","description":"Ordnungshüter"},
    {"item":"I36","time":"NA","group":"3","answer":"NA","result":"NA","description":"Spielplatz"},
    {"item":"I5","time":"NA","group":"2","answer":"NA","result":"NA","description":"Sie"},
    {"item":"I58","time":"NA","group":"1","answer":"NA","result":"NA","description":"reichlich"},
    {"item":"I27","time":"NA","group":"2","answer":"NA","result":"NA","description":"Geld"},
    {"item":"I17","time":"NA","group":"1","answer":"NA","result":"NA","description":"nichts"},
    {"item":"I68","time":"NA","group":"3","answer":"NA","result":"NA","description":"Ständen"},
    {"item":"I64","time":"NA","group":"1","answer":"NA","result":"NA","description":"Sonnenuntergänge"},
    {"item":"I52","time":"NA","group":"2","answer":"NA","result":"NA","description":"Es"},
    {"item":"I55","time":"NA","group":"3","answer":"NA","result":"NA","description":"heutzutage"},
    {"item":"I53","time":"NA","group":"1","answer":"NA","result":"NA","description":"berühmt"},
    {"item":"I89","time":"NA","group":"2","answer":"NA","result":"NA","description":"heften"},
    {"item":"I47","time":"NA","group":"3","answer":"NA","result":"NA","description":"Monate"},
    {"item":"I24","time":"NA","group":"1","answer":"NA","result":"NA","description":"läuft"},
    {"item":"I11","time":"NA","group":"3","answer":"NA","result":"NA","description":"Wiese"},
    {"item":"I30","time":"NA","group":"2","answer":"NA","result":"NA","description":"Wir"},
    {"item":"I46","time":"NA","group":"2","answer":"NA","result":"NA","description":"Arzt"},
    {"item":"I50","time":"NA","group":"3","answer":"NA","result":"NA","description":"bald"},
    {"item":"I70","time":"NA","group":"1","answer":"NA","result":"NA","description":"etwas"},
    {"item":"I65","time":"NA","group":"3","answer":"NA","result":"NA","description":"verpasse"},
    {"item":"I22","time":"NA","group":"2","answer":"NA","result":"NA","description":"du"},
    {"item":"I23","time":"NA","group":"1","answer":"NA","result":"NA","description":"viel"},
    {"item":"I6","time":"NA","group":"3","answer":"NA","result":"NA","description":"Klassenzimmer"},
    {"item":"I67","time":"NA","group":"1","answer":"NA","result":"NA","description":"nicht"},
    {"item":"I56","time":"NA","group":"2","answer":"NA","result":"NA","description":"sie"},
    {"item":"I1","time":"NA","group":"2","answer":"NA","result":"NA","description":"streiten"},
    {"item":"I13","time":"NA","group":"3","answer":"NA","result":"NA","description":"sauer"},
    {"item":"I79","time":"NA","group":"1","answer":"NA","result":"NA","description":"verdienen"},
    {"item":"I76","time":"NA","group":"1","answer":"NA","result":"NA","description":"ausleihe"},
    {"item":"I84","time":"NA","group":"2","answer":"NA","result":"NA","description":"ihnen"},
    {"item":"I40","time":"NA","group":"3","answer":"NA","result":"NA","description":"bezahlt"},
    {"item":"I33","time":"NA","group":"1","answer":"NA","result":"NA","description":"verpassen"},
    {"item":"I35","time":"NA","group":"2","answer":"NA","result":"NA","description":"Bild"},
    {"item":"I3","time":"NA","group":"3","answer":"NA","result":"NA","description":"Trick"},
    {"item":"I61","time":"NA","group":"3","answer":"NA","result":"NA","description":"draußen"},
    {"item":"I43","time":"NA","group":"1","answer":"NA","result":"NA","description":"spielen"},
    {"item":"I78","time":"NA","group":"2","answer":"NA","result":"NA","description":"Pflegerinnen"},
    {"item":"I12","time":"NA","group":"1","answer":"NA","result":"NA","description":"einladen"},
    {"item":"I59","time":"NA","group":"3","answer":"NA","result":"NA","description":"Jahr"},
    {"item":"I14","time":"NA","group":"2","answer":"NA","result":"NA","description":"Leinwand"},
    {"item":"I29","time":"NA","group":"3","answer":"NA","result":"NA","description":"Morgen"},
    {"item":"I16","time":"NA","group":"2","answer":"NA","result":"NA","description":"Gebäude"},
    {"item":"I86","time":"NA","group":"2","answer":"NA","result":"NA","description":"schließen"},
    {"item":"I93","time":"NA","group":"2","answer":"NA","result":"NA","description":"Dieser"},
    {"item":"I63","time":"NA","group":"2","answer":"NA","result":"NA","description":"dieser"},
    {"item":"I73","time":"NA","group":"2","answer":"NA","result":"NA","description":"klatschen"},
    {"item":"I75","time":"NA","group":"2","answer":"NA","result":"NA","description":"ihnen"},
    {"item":"I88","time":"NA","group":"2","answer":"NA","result":"NA","description":"Ozean"},
    {"item":"I57","time":"NA","group":"2","answer":"NA","result":"NA","description":"Uns"},
    {"item":"I25","time":"NA","group":"2","answer":"NA","result":"NA","description":"Lebensmittel"},
    {"item":"I71","time":"NA","group":"2","answer":"NA","result":"NA","description":"Bibliothek"},
    {"item":"I10","time":"NA","group":"2","answer":"NA","result":"NA","description":"Ihn"}
]
r.save

#Problem Tastaturschulung
r = Result.find(31)
r.views = {"Übersicht":1}
r.save

#Problem ARTH
r = Result.find(33)
r.data = [{"item":"I2","time":1575365501096,"group":2,"answer":"72","result":1,"description":"78 - 6 = 72"},{"item":"I1","time":1575365504670,"group":1,"answer":"50","result":1,"description":"30 + 20 = 50"},{"item":"I3","time":1575365508069,"group":3,"answer":"11","result":1,"description":"7 + 4 = 11"},{"item":"I4","time":1575365525629,"group":4,"answer":"86","result":1,"description":"93 - 7 = 86"},{"item":"I5","time":1575365532805,"group":1,"answer":"59","result":1,"description":"56 + 3 = 59"},{"item":"I6","time":1575365537406,"group":2,"answer":"40","result":1,"description":"47 - 7 = 40"},{"item":"I7","time":1575365544603,"group":3,"answer":"52","result":1,"description":"43 + 9 = 52"},{"item":"I8","time":1575365557356,"group":4,"answer":"26","result":0,"description":"32 - 17 = 15"},{"item":"I9","time":1575365563438,"group":1,"answer":"30","result":1,"description":"24 + 6 = 30"},{"item":"I11","time":1575365580888,"group":3,"answer":"73","result":1,"description":"47 + 26 = 73"},{"item":"I10","time":1575365589976,"group":4,"answer":"1890","result":0,"description":"76 - 23 = 53"},{"item":"I12","time":1575365597052,"group":2,"answer":"40","result":1,"description":"70 - 30 = 40"},{"item":"I13","time":1575365607963,"group":3,"answer":"66","result":1,"description":"42 + 24 = 66"},{"item":"I15","time":1575365620031,"group":1,"answer":"80","result":1,"description":"37 + 43 = 80"},{"item":"I16","time":1575365627107,"group":4,"answer":"8","result":0,"description":"13 - 6 = 7"},{"item":"I14","time":1575365638480,"group":2,"answer":"60","result":1,"description":"83 - 23 = 60"},{"item":"I19","time":1575365644649,"group":3,"answer":"6","result":0,"description":"8 + 4 = 12"},{"item":"I18","time":1575365650891,"group":2,"answer":"63","result":1,"description":"67 - 4 = 63"},{"item":"I17","time":1575365655141,"group":1,"answer":"50","result":1,"description":"40 + 10 = 50"},{"item":"I20","time":1575365659609,"group":4,"answer":"18","result":0,"description":"23 - 6 = 17"},{"item":"I21","time":1575365664169,"group":1,"answer":"29","result":1,"description":"24 + 5 = 29"},{"item":"I26","time":1575365676370,"group":4,"answer":"24","result":0,"description":"48 - 26 = 22"},{"item":"I22","time":1575365680511,"group":2,"answer":"90","result":1,"description":"97 - 7 = 90"},{"item":"I24","time":1575365686309,"group":4,"answer":"98","result":0,"description":"78 - 49 = 29"},{"item":"I25","time":1575365691424,"group":1,"answer":"80","result":1,"description":"78 + 2 = 80"},{"item":"I23","time":1575365700394,"group":3,"answer":"7","result":0,"description":"73 + 8 = 81"},{"item":"I27","time":1575365708879,"group":3,"answer":"855","result":0,"description":"43 + 38 = 81"},{"item":"I28","time":1575365714157,"group":2,"answer":"10","result":1,"description":"80 - 70 = 10"},{"item":"I29","time":1575365727877,"group":3,"answer":"51","result":0,"description":"32 + 17 = 49"},{"item":"I30","time":1575365737914,"group":2,"answer":"20","result":1,"description":"67 - 47 = 20"},{"item":"I31","time":1575365744985,"group":1,"answer":"80","result":1,"description":"49 + 31 = 80"},{"item":"I32","time":1575365751605,"group":4,"answer":"9","result":1,"description":"16 - 7 = 9"},{"item":"I35","time":1575365763883,"group":3,"answer":"17","result":1,"description":"9 + 8 = 17"},{"item":"I33","time":1575365767517,"group":1,"answer":"90","result":1,"description":"70 + 20 = 90"},{"item":"I34","time":1575365773227,"group":2,"answer":"36","result":1,"description":"38 - 2 = 36"},{"item":"I36","time":1575365780620,"group":4,"answer":"68","result":1,"description":"76 - 8 = 68"},{"item":"I40","time":1575365792177,"group":4,"answer":"4","result":0,"description":"48 - 29 = 19"},{"item":"I38","time":"NA","group":2,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I37","time":"NA","group":1,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I39","time":"NA","group":3,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I44","time":"NA","group":2,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I41","time":"NA","group":1,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I42","time":"NA","group":4,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I43","time":"NA","group":3,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I47","time":"NA","group":1,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I46","time":"NA","group":2,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I45","time":"NA","group":3,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I48","time":"NA","group":4,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I50","time":"NA","group":2,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I49","time":"NA","group":1,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I54","time":"NA","group":2,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I52","time":"NA","group":4,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I53","time":"NA","group":1,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I51","time":"NA","group":3,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I59","time":"NA","group":3,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I55","time":"NA","group":3,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I57","time":"NA","group":1,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I58","time":"NA","group":4,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I56","time":"NA","group":4,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I60","time":"NA","group":2,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I65","time":"NA","group":1,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I62","time":"NA","group":2,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I63","time":"NA","group":1,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I64","time":"NA","group":4,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I68","time":"NA","group":4,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I66","time":"NA","group":2,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I67","time":"NA","group":3,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I61","time":"NA","group":3,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I69","time":"NA","group":1,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I70","time":"NA","group":2,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I75","time":"NA","group":3,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I72","time":"NA","group":4,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I73","time":"NA","group":1,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I74","time":"NA","group":4,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I71","time":"NA","group":3,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I77","time":"NA","group":3,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I76","time":"NA","group":2,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I80","time":"NA","group":4,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I79","time":"NA","group":1,"answer":"NA","result":"NA","description":"48 - 29 = 19"},{"item":"I78","time":"NA","group":2,"answer":"NA","result":"NA","description":"48 - 29 = 19"}]
r.test_date = '2019-12-03'
r.save

#Problem Rater2
r = Result.find(30)
r.views = {
    "V1":14,
    "V2":{
        "PW":"\u003ctable class=\"table table-bordered\" style=\"margin-bottom: 0\"\u003e\u003cthead\u003e\u003ctr style=\"background-color: rgba(0,0,0,0)\"\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eSpezifität\u003c/th\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eSensitivität\u003c/th\u003e\u003c/tr\u003e\u003c/thead\u003e\u003ctbody\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003e100.00%\u003c/td\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003e84.62%\u003c/td\u003e\u003c/tbody\u003e\u003c/table\u003e",
        "FBC":"\u003ctable class=\"table table-bordered\" style=\"margin-bottom: 0\"\u003e\u003cthead\u003e\u003ctr style=\"background-color: rgba(0,0,0,0)\"\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems mit Lesefehler\u003c/th\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems ohne Lesefehler\u003c/th\u003e\u003c/tr\u003e\u003c/thead\u003e\u003ctbody\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003e\u003c/td\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003esteime\u003c/td\u003e\u003c/tbody\u003e\u003c/table\u003e",
        "RBC":"\u003ctable class=\"table table-bordered\" style=\"margin-bottom: 0\"\u003e\u003cthead\u003e\u003ctr style=\"background-color: rgba(0,0,0,0)\"\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems mit Lesefehler\u003c/th\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems ohne Lesefehler\u003c/th\u003e\u003c/tr\u003e\u003c/thead\u003e\u003ctbody\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003eneufu, scheuli, zisa\u003c/td\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003evofa, zifu, vume, steiru, hexun, spema, vore, zanu, euni, stame, pyno, jemo\u003c/td\u003e\u003c/tbody\u003e\u003c/table\u003e"
    },
    "V3":{
        "PW":"\u003ctable class=\"table table-bordered\" style=\"margin-bottom: 0\"\u003e\u003cthead\u003e\u003ctr style=\"background-color: rgba(0,0,0,0)\"\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eSpezifität\u003c/th\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eSensitivität\u003c/th\u003e\u003c/tr\u003e\u003c/thead\u003e\u003ctbody\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003e100.00%\u003c/td\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003e84.62%\u003c/td\u003e\u003c/tbody\u003e\u003c/table\u003e",
        "RB":14,
        "FBC":"\u003ctable class=\"table table-bordered\" style=\"margin-bottom: 0\"\u003e\u003cthead\u003e\u003ctr style=\"background-color: rgba(0,0,0,0)\"\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems mit Lesefehler\u003c/th\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems ohne Lesefehler\u003c/th\u003e\u003c/tr\u003e\u003c/thead\u003e\u003ctbody\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003e\u003c/td\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003esteime\u003c/td\u003e\u003c/tbody\u003e\u003c/table\u003e",
        "FBL":0,
        "RBC":"\u003ctable class=\"table table-bordered\" style=\"margin-bottom: 0\"\u003e\u003cthead\u003e\u003ctr style=\"background-color: rgba(0,0,0,0)\"\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems mit Lesefehler\u003c/th\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems ohne Lesefehler\u003c/th\u003e\u003c/tr\u003e\u003c/thead\u003e\u003ctbody\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003eneufu, scheuli, zisa\u003c/td\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003evofa, zifu, vume, steiru, hexun, spema, vore, zanu, euni, stame, pyno, jemo\u003c/td\u003e\u003c/tbody\u003e\u003c/table\u003e",
        "FBOL":2
    }
}
r.data = [
    {"item":"I106","time":4118,"group":1,"result":1,"description":"vofa"},
    {"item":"I123","time":3632,"group":1,"result":1,"description":"zifu"},
    {"item":"I91","time":4430,"group":1,"result":0,"description":"steime"},
    {"item":"I110","time":3890,"group":1,"result":1,"description":"vume"},
    {"item":"I21","time":5587,"group":0,"result":1,"description":"neufu"},
    {"item":"I92","time":4290,"group":1,"result":1,"description":"steiru"},
    {"item":"I65","time":2107,"group":1,"result":1,"description":"hexun"},
    {"item":"I86","time":8218,"group":1,"result":0,"description":"spema"},
    {"item":"I28","time":2664,"group":0,"result":1,"description":"scheuli"},
    {"item":"I109","time":2466,"group":1,"result":1,"description":"vore"},
    {"item":"I117","time":3145,"group":1,"result":1,"description":"zanu"},
    {"item":"I58","time":2741,"group":1,"result":1,"description":"euni"},
    {"item":"I54","time":2329,"group":0,"result":1,"description":"zisa"},
    {"item":"I89","time":4453,"group":1,"result":1,"description":"stame"},
    {"item":"I74","time":5239,"group":1,"result":1,"description":"pyno"},
    {"item":"I68","time":4107,"group":1,"result":1,"description":"jemo"},
    {"item":"I2","time":"NA","result":"NA"},
    {"item":"I83","time":"NA","result":"NA"},
    {"item":"I125","time":"NA","result":"NA"},
    {"item":"I116","time":"NA","result":"NA"},
    {"item":"I118","time":"NA","result":"NA"},
    {"item":"I76","time":"NA","result":"NA"},
    {"item":"I57","time":"NA","result":"NA"},
    {"item":"I13","time":"NA","result":"NA"},
    {"item":"I82","time":"NA","result":"NA"},
    {"item":"I100","time":"NA","result":"NA"},
    {"item":"I73","time":"NA","result":"NA"},
    {"item":"I72","time":"NA","result":"NA"},
    {"item":"I55","time":"NA","result":"NA"},
    {"item":"I47","time":"NA","result":"NA"},
    {"item":"I56","time":"NA","result":"NA"},
    {"item":"I111","time":"NA","result":"NA"},
    {"item":"I98","time":"NA","result":"NA"},
    {"item":"I79","time":"NA","result":"NA"},
    {"item":"I8","time":"NA","result":"NA"},
    {"item":"I121","time":"NA","result":"NA"},
    {"item":"I42","time":"NA","result":"NA"},
    {"item":"I96","time":"NA","result":"NA"},
    {"item":"I78","time":"NA","result":"NA"},
    {"item":"I84","time":"NA","result":"NA"},
    {"item":"I114","time":"NA","result":"NA"},
    {"item":"I99","time":"NA","result":"NA"},
    {"item":"I64","time":"NA","result":"NA"},
    {"item":"I51","time":"NA","result":"NA"},
    {"item":"I126","time":"NA","result":"NA"},
    {"item":"I70","time":"NA","result":"NA"},
    {"item":"I129","time":"NA","result":"NA"},
    {"item":"I113","time":"NA","result":"NA"},
    {"item":"I17","time":"NA","result":"NA"},
    {"item":"I107","time":"NA","result":"NA"},
    {"item":"I85","time":"NA","result":"NA"},
    {"item":"I127","time":"NA","result":"NA"},
    {"item":"I66","time":"NA","result":"NA"},
    {"item":"I48","time":"NA","result":"NA"},
    {"item":"I128","time":"NA","result":"NA"},
    {"item":"I69","time":"NA","result":"NA"},
    {"item":"I93","time":"NA","result":"NA"},
    {"item":"I122","time":"NA","result":"NA"},
    {"item":"I5","time":"NA","result":"NA"},
    {"item":"I108","time":"NA","result":"NA"},
    {"item":"I130","time":"NA","result":"NA"},
    {"item":"I75","time":"NA","result":"NA"},
    {"item":"I102","time":"NA","result":"NA"},
    {"item":"I97","time":"NA","result":"NA"},
    {"item":"I35","time":"NA","result":"NA"},
    {"item":"I23","time":"NA","result":"NA"},
    {"item":"I112","time":"NA","result":"NA"},
    {"item":"I95","time":"NA","result":"NA"},
    {"item":"I120","time":"NA","result":"NA"},
    {"item":"I67","time":"NA","result":"NA"},
    {"item":"I88","time":"NA","result":"NA"},
    {"item":"I50","time":"NA","result":"NA"},
    {"item":"I61","time":"NA","result":"NA"},
    {"item":"I71","time":"NA","result":"NA"},
    {"item":"I104","time":"NA","result":"NA"},
    {"item":"I80","time":"NA","result":"NA"},
    {"item":"I101","time":"NA","result":"NA"},
    {"item":"I12","time":"NA","result":"NA"},
    {"item":"I94","time":"NA","result":"NA"},
    {"item":"I81","time":"NA","result":"NA"},
    {"item":"I90","time":"NA","result":"NA"},
    {"item":"I59","time":"NA","result":"NA"},
    {"item":"I105","time":"NA","result":"NA"},
    {"item":"I115","time":"NA","result":"NA"},
    {"item":"I40","time":"NA","result":"NA"},
    {"item":"I62","time":"NA","result":"NA"},
    {"item":"I63","time":"NA","result":"NA"},
    {"item":"I60","time":"NA","result":"NA"},
    {"item":"I87","time":"NA","result":"NA"},
    {"item":"I1","time":"NA","result":"NA"},
    {"item":"I77","time":"NA","result":"NA"},
    {"item":"I49","time":"NA","result":"NA"},
    {"item":"I119","time":"NA","result":"NA"},
    {"item":"I124","time":"NA","result":"NA"},
    {"item":"I103","time":"NA","result":"NA"},
    {"item":"I27","time":"NA","result":"NA"},
    {"item":"I45","time":"NA","result":"NA"},
    {"item":"I53","time":"NA","result":"NA"},
    {"item":"I44","time":"NA","result":"NA"},
    {"item":"I31","time":"NA","result":"NA"},
    {"item":"I14","time":"NA","result":"NA"},
    {"item":"I3","time":"NA","result":"NA"},
    {"item":"I37","time":"NA","result":"NA"},
    {"item":"I30","time":"NA","result":"NA"},
    {"item":"I20","time":"NA","result":"NA"},
    {"item":"I16","time":"NA","result":"NA"},
    {"item":"I18","time":"NA","result":"NA"},
    {"item":"I43","time":"NA","result":"NA"},
    {"item":"I39","time":"NA","result":"NA"},
    {"item":"I4","time":"NA","result":"NA"},
    {"item":"I24","time":"NA","result":"NA"},
    {"item":"I38","time":"NA","result":"NA"},
    {"item":"I32","time":"NA","result":"NA"},
    {"item":"I25","time":"NA","result":"NA"},
    {"item":"I7","time":"NA","result":"NA"},
    {"item":"I52","time":"NA","result":"NA"},
    {"item":"I36","time":"NA","result":"NA"},
    {"item":"I19","time":"NA","result":"NA"},
    {"item":"I46","time":"NA","result":"NA"},
    {"item":"I34","time":"NA","result":"NA"},
    {"item":"I29","time":"NA","result":"NA"},
    {"item":"I22","time":"NA","result":"NA"},
    {"item":"I6","time":"NA","result":"NA"},
    {"item":"I26","time":"NA","result":"NA"},
    {"item":"I10","time":"NA","result":"NA"},
    {"item":"I11","time":"NA","result":"NA"},
    {"item":"I9","time":"NA","result":"NA"},
    {"item":"I41","time":"NA","result":"NA"},
    {"item":"I33","time":"NA","result":"NA"},
    {"item":"I15","time":"NA","result":"NA"}
]
r.save

#Problem Rater3
r = Result.find(26)
r.views = {
    "V1":22,"V2":{"PW":"\u003ctable class=\"table table-bordered\" style=\"margin-bottom: 0\"\u003e\u003cthead\u003e\u003ctr style=\"background-color: rgba(0,0,0,0)\"\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eSpezifität\u003c/th\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eSensitivität\u003c/th\u003e\u003c/tr\u003e\u003c/thead\u003e\u003ctbody\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003e83.33%\u003c/td\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003e77.27%\u003c/td\u003e\u003c/tbody\u003e\u003c/table\u003e","FBC":"\u003ctable class=\"table table-bordered\" style=\"margin-bottom: 0\"\u003e\u003cthead\u003e\u003ctr style=\"background-color: rgba(0,0,0,0)\"\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems mit Lesefehler\u003c/th\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems ohne Lesefehler\u003c/th\u003e\u003c/tr\u003e\u003c/thead\u003e\u003ctbody\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003ezasi\u003c/td\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003escheuno\u003c/td\u003e\u003c/tbody\u003e\u003c/table\u003e","RBC":"\u003ctable class=\"table table-bordered\" style=\"margin-bottom: 0\"\u003e\u003cthead\u003e\u003ctr style=\"background-color: rgba(0,0,0,0)\"\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems mit Lesefehler\u003c/th\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems ohne Lesefehler\u003c/th\u003e\u003c/tr\u003e\u003c/thead\u003e\u003ctbody\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003espeino, vimi, vifo, vano, schöme\u003c/td\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003ebeulu, jafi, geusi, xisu, vala, stasu, hexol, scheufu, neune, speira, hexun, viru, feune, quara, tyne, zisa, vane, eure, zili, hexaf, quase\u003c/td\u003e\u003c/tbody\u003e\u003c/table\u003e"},"V3":{"PW":"\u003ctable class=\"table table-bordered\" style=\"margin-bottom: 0\"\u003e\u003cthead\u003e\u003ctr style=\"background-color: rgba(0,0,0,0)\"\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eSpezifität\u003c/th\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eSensitivität\u003c/th\u003e\u003c/tr\u003e\u003c/thead\u003e\u003ctbody\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003e83.33%\u003c/td\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003e77.27%\u003c/td\u003e\u003c/tbody\u003e\u003c/table\u003e","RB":22,"FBC":"\u003ctable class=\"table table-bordered\" style=\"margin-bottom: 0\"\u003e\u003cthead\u003e\u003ctr style=\"background-color: rgba(0,0,0,0)\"\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems mit Lesefehler\u003c/th\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems ohne Lesefehler\u003c/th\u003e\u003c/tr\u003e\u003c/thead\u003e\u003ctbody\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003ezasi\u003c/td\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003escheuno\u003c/td\u003e\u003c/tbody\u003e\u003c/table\u003e","FBL":1,"RBC":"\u003ctable class=\"table table-bordered\" style=\"margin-bottom: 0\"\u003e\u003cthead\u003e\u003ctr style=\"background-color: rgba(0,0,0,0)\"\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems mit Lesefehler\u003c/th\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems ohne Lesefehler\u003c/th\u003e\u003c/tr\u003e\u003c/thead\u003e\u003ctbody\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003espeino, vimi, vifo, vano, schöme\u003c/td\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003ebeulu, jafi, geusi, xisu, vala, stasu, hexol, scheufu, neune, speira, hexun, viru, feune, quara, tyne, zisa, vane, eure, zili, hexaf, quase\u003c/td\u003e\u003c/tbody\u003e\u003c/table\u003e","FBOL":5}
}
r.data = [
    {"item":"I17","time":3378,"group":1,"result":1,"description":"beulu"},{"item":"I14","time":1820,"group":0,"result":0,"description":"zasi"},{"item":"I39","time":2128,"group":1,"result":1,"description":"jafi"},{"item":"I63","time":2402,"group":1,"result":0,"description":"scheuno"},{"item":"I32","time":2026,"group":1,"result":0,"description":"geusi"},{"item":"I114","time":1707,"group":1,"result":1,"description":"xisu"},{"item":"I9","time":2666,"group":0,"result":1,"description":"speino"},{"item":"I94","time":3127,"group":1,"result":0,"description":"vala"},{"item":"I83","time":2066,"group":1,"result":1,"description":"stasu"},{"item":"I37","time":2527,"group":1,"result":1,"description":"hexol"},{"item":"I12","time":2172,"group":0,"result":1,"description":"vimi"},{"item":"I62","time":1984,"group":1,"result":0,"description":"scheufu"},{"item":"I51","time":1664,"group":1,"result":1,"description":"neune"},{"item":"I73","time":2099,"group":1,"result":1,"description":"speira"},{"item":"I38","time":1973,"group":1,"result":1,"description":"hexun"},{"item":"I99","time":2739,"group":1,"result":1,"description":"viru"},{"item":"I28","time":1857,"group":1,"result":0,"description":"feune"},{"item":"I60","time":1770,"group":1,"result":1,"description":"quara"},{"item":"I91","time":1787,"group":1,"result":1,"description":"tyne"},{"item":"I11","time":1708,"group":0,"result":1,"description":"vifo"},{"item":"I127","time":1841,"group":1,"result":1,"description":"zisa"},{"item":"I95","time":3453,"group":1,"result":1,"description":"vane"},{"item":"I10","time":1597,"group":0,"result":1,"description":"vano"},{"item":"I23","time":2323,"group":1,"result":1,"description":"eure"},{"item":"I125","time":1734,"group":1,"result":1,"description":"zili"},{"item":"I34","time":2678,"group":1,"result":1,"description":"hexaf"},{"item":"I61","time":1825,"group":1,"result":1,"description":"quase"},{"item":"I7","time":5081,"group":0,"result":1,"description":"schöme"},{"item":"I90","time":"NA","result":"NA"},{"item":"I112","time":"NA","result":"NA"},{"item":"I48","time":"NA","result":"NA"},{"item":"I66","time":"NA","result":"NA"},{"item":"I64","time":"NA","result":"NA"},{"item":"I8","time":"NA","result":"NA"},{"item":"I40","time":"NA","result":"NA"},{"item":"I3","time":"NA","result":"NA"},{"item":"I105","time":"NA","result":"NA"},{"item":"I18","time":"NA","result":"NA"},{"item":"I113","time":"NA","result":"NA"},{"item":"I44","time":"NA","result":"NA"},{"item":"I72","time":"NA","result":"NA"},{"item":"I123","time":"NA","result":"NA"},{"item":"I2","time":"NA","result":"NA"},{"item":"I126","time":"NA","result":"NA"},{"item":"I50","time":"NA","result":"NA"},{"item":"I115","time":"NA","result":"NA"},{"item":"I96","time":"NA","result":"NA"},{"item":"I1","time":"NA","result":"NA"},{"item":"I65","time":"NA","result":"NA"},{"item":"I81","time":"NA","result":"NA"},{"item":"I86","time":"NA","result":"NA"},{"item":"I87","time":"NA","result":"NA"},{"item":"I26","time":"NA","result":"NA"},{"item":"I13","time":"NA","result":"NA"},{"item":"I35","time":"NA","result":"NA"},{"item":"I75","time":"NA","result":"NA"},{"item":"I106","time":"NA","result":"NA"},{"item":"I5","time":"NA","result":"NA"},{"item":"I110","time":"NA","result":"NA"},{"item":"I71","time":"NA","result":"NA"},{"item":"I93","time":"NA","result":"NA"},{"item":"I92","time":"NA","result":"NA"},{"item":"I67","time":"NA","result":"NA"},{"item":"I53","time":"NA","result":"NA"},{"item":"I15","time":"NA","result":"NA"},{"item":"I16","time":"NA","result":"NA"},{"item":"I69","time":"NA","result":"NA"},{"item":"I57","time":"NA","result":"NA"},{"item":"I108","time":"NA","result":"NA"},{"item":"I124","time":"NA","result":"NA"},{"item":"I25","time":"NA","result":"NA"},{"item":"I117","time":"NA","result":"NA"},{"item":"I6","time":"NA","result":"NA"},{"item":"I85","time":"NA","result":"NA"},{"item":"I104","time":"NA","result":"NA"},{"item":"I29","time":"NA","result":"NA"},{"item":"I42","time":"NA","result":"NA"},{"item":"I79","time":"NA","result":"NA"},{"item":"I46","time":"NA","result":"NA"},{"item":"I4","time":"NA","result":"NA"},{"item":"I84","time":"NA","result":"NA"},{"item":"I129","time":"NA","result":"NA"},{"item":"I70","time":"NA","result":"NA"},{"item":"I131","time":"NA","result":"NA"},{"item":"I88","time":"NA","result":"NA"},{"item":"I22","time":"NA","result":"NA"},{"item":"I119","time":"NA","result":"NA"},{"item":"I68","time":"NA","result":"NA"},{"item":"I77","time":"NA","result":"NA"},{"item":"I33","time":"NA","result":"NA"},{"item":"I30","time":"NA","result":"NA"},{"item":"I97","time":"NA","result":"NA"},{"item":"I56","time":"NA","result":"NA"},{"item":"I58","time":"NA","result":"NA"},{"item":"I55","time":"NA","result":"NA"},{"item":"I47","time":"NA","result":"NA"},{"item":"I107","time":"NA","result":"NA"},{"item":"I118","time":"NA","result":"NA"},{"item":"I76","time":"NA","result":"NA"},{"item":"I52","time":"NA","result":"NA"},{"item":"I101","time":"NA","result":"NA"},{"item":"I19","time":"NA","result":"NA"},{"item":"I45","time":"NA","result":"NA"},{"item":"I111","time":"NA","result":"NA"},{"item":"I121","time":"NA","result":"NA"},{"item":"I100","time":"NA","result":"NA"},{"item":"I82","time":"NA","result":"NA"},{"item":"I80","time":"NA","result":"NA"},{"item":"I27","time":"NA","result":"NA"},{"item":"I89","time":"NA","result":"NA"},{"item":"I20","time":"NA","result":"NA"},{"item":"I21","time":"NA","result":"NA"},{"item":"I122","time":"NA","result":"NA"},{"item":"I128","time":"NA","result":"NA"},{"item":"I41","time":"NA","result":"NA"},{"item":"I43","time":"NA","result":"NA"},{"item":"I54","time":"NA","result":"NA"},{"item":"I120","time":"NA","result":"NA"},{"item":"I78","time":"NA","result":"NA"},{"item":"I130","time":"NA","result":"NA"},{"item":"I109","time":"NA","result":"NA"},{"item":"I102","time":"NA","result":"NA"},{"item":"I49","time":"NA","result":"NA"},{"item":"I59","time":"NA","result":"NA"},{"item":"I74","time":"NA","result":"NA"},{"item":"I116","time":"NA","result":"NA"},{"item":"I36","time":"NA","result":"NA"},{"item":"I31","time":"NA","result":"NA"},{"item":"I98","time":"NA","result":"NA"},{"item":"I24","time":"NA","result":"NA"},{"item":"I103","time":"NA","result":"NA"}
]
r.save


#Lösung für SEL2
t = Test.find_by shorthand: "SEL2"
assessments = Assessment.where(test_id: t.id)
results = Result.where(assessment_id: assessments.ids).order(:test_date)
items_sel2 = {"I1"=> { "group"=> "1", "correct_answer"=> "Taschen"},
              "I2"=> { "group"=> "2", "correct_answer"=> "bade"},
              "I3"=> { "group"=> "2", "correct_answer"=> "wartet"},
              "I4"=> { "group"=> "1", "correct_answer"=> "Film"},
              "I5"=> { "group"=> "1", "correct_answer"=> "Fahrrad"},
              "I6"=> { "group"=> "2", "correct_answer"=> "schlaue"},
              "I7"=> { "group"=> "1", "correct_answer"=> "Wand"},
              "I8"=> { "group"=> "2", "correct_answer"=> "tollen"},
              "I9"=> { "group"=> "2", "correct_answer"=> "kalt"},
              "I10"=> { "group"=> "1", "correct_answer"=> "Traktor"},
              "I11"=> { "group"=> "2", "correct_answer"=> "besucht"},
              "I12"=> { "group"=> "1", "correct_answer"=> "Milch"},
              "I13"=> { "group"=> "1", "correct_answer"=> "Bruder"},
              "I14"=> { "group"=> "2", "correct_answer"=> "scharfe"},
              "I15"=> { "group"=> "2", "correct_answer"=> "male"},
              "I16"=> { "group"=> "1", "correct_answer"=> "Kinder"},
              "I17"=> { "group"=> "1", "correct_answer"=> "Buch"},
              "I18"=> { "group"=> "2", "correct_answer"=> "faul"},
              "I19"=> { "group"=> "2", "correct_answer"=> "ruft"},
              "I20"=> { "group"=> "1", "correct_answer"=> "Kuchen"},
              "I21"=> { "group"=> "1", "correct_answer"=> "Ausflug"},
              "I22"=> { "group"=> "2", "correct_answer"=> "schwierigen"},
              "I23"=> { "group"=> "2", "correct_answer"=> "blau"},
              "I24"=> { "group"=> "1", "correct_answer"=> "Berg"},
              "I25"=> { "group"=> "2", "correct_answer"=> "sieht"},
              "I26"=> { "group"=> "1", "correct_answer"=> "Weg"},
              "I27"=> { "group"=> "1", "correct_answer"=> "Abfall"},
              "I28"=> { "group"=> "2", "correct_answer"=> "reiten"},
              "I29"=> { "group"=> "2", "correct_answer"=> "leben"},
              "I30"=> { "group"=> "1", "correct_answer"=> "Pause"},
              "I31"=> { "group"=> "1", "correct_answer"=> "Seife"},
              "I32"=> { "group"=> "2", "correct_answer"=> "lange"},
              "I33"=> { "group"=> "1", "correct_answer"=> "Eier"},
              "I34"=> { "group"=> "2", "correct_answer"=> "baden"},
              "I35"=> { "group"=> "2", "correct_answer"=> "hell"},
              "I36"=> { "group"=> "1", "correct_answer"=> "Wasser"},
              "I37"=> { "group"=> "1", "correct_answer"=> "Opa"},
              "I38"=> { "group"=> "2", "correct_answer"=> "heimlich"},
              "I39"=> { "group"=> "2", "correct_answer"=> "lerne"},
              "I40"=> { "group"=> "1", "correct_answer"=> "Lieder"},
              "I41"=> { "group"=> "1", "correct_answer"=> "Geschenk"},
              "I42"=> { "group"=> "2", "correct_answer"=> "leere"},
              "I43"=> { "group"=> "1", "correct_answer"=> "Abend"},
              "I44"=> { "group"=> "2", "correct_answer"=> "kleinen"},
              "I45"=> { "group"=> "2", "correct_answer"=> "hell"},
              "I46"=> { "group"=> "1", "correct_answer"=> "Auto"},
              "I47"=> { "group"=> "1", "correct_answer"=> "Schule"},
              "I48"=> { "group"=> "2", "correct_answer"=> "trinkt"},
              "I49"=> { "group"=> "2", "correct_answer"=> "tief"},
              "I50"=> { "group"=> "1", "correct_answer"=> "Keks"},
              "I51"=> { "group"=> "1", "correct_answer"=> "Ampel"},
              "I52"=> { "group"=> "2", "correct_answer"=> "hebt"},
              "I53"=> { "group"=> "1", "correct_answer"=> "Dose"},
              "I54"=> { "group"=> "2", "correct_answer"=> "schnell"},
              "I55"=> { "group"=> "2", "correct_answer"=> "schwimmen"},
              "I56"=> { "group"=> "1", "correct_answer"=> "Sofa"},
              "I57"=> { "group"=> "2", "correct_answer"=> "laufen"},
              "I58"=> { "group"=> "1", "correct_answer"=> "Kater"},
              "I59"=> { "group"=> "1", "correct_answer"=> "Ende"},
              "I60"=> { "group"=> "2", "correct_answer"=> "allein"},
              "I61"=> { "group"=> "1", "correct_answer"=> "Schweine"},
              "I62"=> { "group"=> "1", "correct_answer"=> "Reifen"},
              "I63"=> { "group"=> "1", "correct_answer"=> "Mofas"},
              "I64"=> { "group"=> "1", "correct_answer"=> "Brot"},
              "I65"=> { "group"=> "1", "correct_answer"=> "Boden"},
              "I66"=> { "group"=> "1", "correct_answer"=> "Fibel"}
}
results.each do |r|
  trend = 0 #check
  negative = [] #check
  positive = [] #check
  data = []
  p_sum = 0 #check
  n_sum = 0 #check
  ada_correct_items = "" #check
  ada_false_items = "" #check
  ada_positve = 0 #check
  ada_negative = 0 #check

  avp_correct_items = "" #check
  avp_false_items = "" #check
  avp_positve = 0 #check
  avp_negative = 0 #check

  r.data.each do |d|
    result = 0
    item = items_sel2[d["item"]]
    if item["group"] == "1"
      if d["answer"].gsub(/\u00AD/, '') == item["correct_answer"]
        p_sum += 1
        result = 1
        positive += [d["item"]]
        ada_positve += 1
        if ada_correct_items == ""
          ada_correct_items += item["correct_answer"]
        else
          ada_correct_items += ", " +item["correct_answer"]
        end
      elsif d["answer"].gsub(/\u00AD/, '') != "NA"
        n_sum += 1
        ada_negative += 1
        negative += [d["item"]]
        if ada_false_items == ""
          ada_false_items += item["correct_answer"]
        else
          ada_false_items += ", " + item["correct_answer"]
        end
      else
        result = "NA"
      end
    elsif d["answer"].gsub(/\u00AD/, '') != "NA"
      if d["answer"].gsub(/\u00AD/, '') == item["correct_answer"]
        p_sum += 1
        avp_positve += 1
        result = 1
        positive += [d["item"]]
        if avp_correct_items == ""
          avp_correct_items += item["correct_answer"]
        else
          avp_correct_items += ", " +item["correct_answer"]
        end
      else
        avp_negative += 1
        n_sum += 1
        negative += [d["item"]]
        if avp_false_items == ""
          avp_false_items += item["correct_answer"]
        else
          avp_false_items += ", " + item["correct_answer"]
        end
      end
    else
      result = "NA"
    end
    data += [{"item": d["item"], "result": result, "group": item["group"], "decription": item["correct_answer"], "answer": d["answer"].gsub(/\u00AD/, ''), "time": d["time"] }]
  end
  last_result = Result.where(assessment_id: r.assessment_id, student_id: r.student_id).where.not(id: r.id).where("test_date < ? ", r.test_date).order(:test_week).last
  trend = last_result.nil? ? 0: (last_result.views['V1'] <= p_sum ? 1: -1)

  lg = ((p_sum.to_f/ (p_sum.to_f+n_sum.to_f))* 100).round(2).to_s
  ri = p_sum.to_s + " von 66"
  ada = "\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e " + ada_positve.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + ada_correct_items + "\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e " + ada_negative.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e"+ ada_false_items
  avp = "\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e " + avp_positve.to_s+ "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + avp_correct_items+ "\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e " +avp_negative.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + avp_false_items

  r.report = {
      "trend":trend,
      "negative":negative,
      "positive": positive
  }
  r.data = data
  v1  = p_sum
  v2 = {
      "LG": lg,
      "RI": ri,
      "ADA": ada,
      "AVP": avp,
      "LGM": r.views["V2"]["LGM"]

  }
  v3 = {
      "LG": lg,
      "RI": ri,
      "ADA": ada,
      "AVP": avp,
      "LGM": r.views["V2"]["LGM"],
      "SUM": p_sum
  }
  views = {
      "V1": v1,
      "V2": v2,
      "V3": v3
  }
  r.views = views
  r.save
end

#Lösung für SEL4
t = Test.find_by shorthand: "SEL4"
assessments = Assessment.where(test_id: t.id)
results = Result.where(assessment_id: assessments.ids).order(:test_date)
items_sel4 = {"I1"=> { "group"=> "2", "correct_answer"=> "backt"},
              "I2"=> { "group"=> "1", "correct_answer"=> "Schere"},
              "I3"=> { "group"=> "3", "correct_answer"=> "Während"},
              "I4"=> { "group"=> "1", "correct_answer"=> "Büro"},
              "I5"=> { "group"=> "2", "correct_answer"=> "spitz"},
              "I6"=> { "group"=> "3", "correct_answer"=> "weil"},
              "I7"=> { "group"=> "1", "correct_answer"=> "Bilder"},
              "I8"=> { "group"=> "2", "correct_answer"=> "böse"},
              "I9"=> { "group"=> "3", "correct_answer"=> "bevor"},
              "I10"=> { "group"=> "3", "correct_answer"=> "mit"},
              "I11"=> { "group"=> "2", "correct_answer"=> "dicke"},
              "I12"=> { "group"=> "2", "correct_answer"=> "runde"},
              "I13"=> { "group"=> "1", "correct_answer"=> "Blumen"},
              "I14"=> { "group"=> "2", "correct_answer"=> "spricht"},
              "I15"=> { "group"=> "3", "correct_answer"=> "Durch"},
              "I16"=> { "group"=> "1", "correct_answer"=> "Tür"},
              "I17"=> { "group"=> "3", "correct_answer"=> "Anstatt"},
              "I18"=> { "group"=> "2", "correct_answer"=> "kauft"},
              "I19"=> { "group"=> "1", "correct_answer"=> "Vogel"},
              "I20"=> { "group"=> "2", "correct_answer"=> "scheint"},
              "I21"=> { "group"=> "3", "correct_answer"=> "für"},
              "I22"=> { "group"=> "1", "correct_answer"=> "Baby"},
              "I23"=> { "group"=> "2", "correct_answer"=> "hungrig"},
              "I24"=> { "group"=> "3", "correct_answer"=> "weder"},
              "I25"=> { "group"=> "3", "correct_answer"=> "aber"},
              "I26"=> { "group"=> "2", "correct_answer"=> "schmeckt"},
              "I27"=> { "group"=> "1", "correct_answer"=> "Augen"},
              "I28"=> { "group"=> "1", "correct_answer"=> "Wasser"},
              "I29"=> { "group"=> "3", "correct_answer"=> "Nachdem"},
              "I30"=> { "group"=> "2", "correct_answer"=> "lustigen"},
              "I31"=> { "group"=> "2", "correct_answer"=> "schnelle"},
              "I32"=> { "group"=> "1", "correct_answer"=> "Schuhe"},
              "I33"=> { "group"=> "3", "correct_answer"=> "Auf"},
              "I34"=> { "group"=> "2", "correct_answer"=> "neues"},
              "I35"=> { "group"=> "1", "correct_answer"=> "Bett"},
              "I36"=> { "group"=> "3", "correct_answer"=> "außer"},
              "I37"=> { "group"=> "2", "correct_answer"=> "wohne"},
              "I38"=> { "group"=> "1", "correct_answer"=> "Haus"},
              "I39"=> { "group"=> "3", "correct_answer"=> "von"},
              "I40"=> { "group"=> "2", "correct_answer"=> "isst"},
              "I41"=> { "group"=> "3", "correct_answer"=> "über"},
              "I42"=> { "group"=> "1", "correct_answer"=> "Beine"},
              "I43"=> { "group"=> "1", "correct_answer"=> "Freunde"},
              "I44"=> { "group"=> "1", "correct_answer"=> "Biene"},
              "I45"=> { "group"=> "2", "correct_answer"=> "schläft"},
              "I46"=> { "group"=> "2", "correct_answer"=> "süß"},
              "I47"=> { "group"=> "3", "correct_answer"=> "wegen"},
              "I48"=> { "group"=> "1", "correct_answer"=> "Sonne"},
              "I49"=> { "group"=> "1", "correct_answer"=> "Hase"},
              "I50"=> { "group"=> "2", "correct_answer"=> "gut"},
              "I51"=> { "group"=> "3", "correct_answer"=> "Zwischen"},
              "I52"=> { "group"=> "1", "correct_answer"=> "Frösche"},
              "I53"=> { "group"=> "2", "correct_answer"=> "wartest"},
              "I54"=> { "group"=> "3", "correct_answer"=> "Wenn"},
              "I55"=> { "group"=> "2", "correct_answer"=> "sammeln"},
              "I56"=> { "group"=> "3", "correct_answer"=> "Sobald"},
              "I57"=> { "group"=> "1", "correct_answer"=> "Enten"},
              "I58"=> { "group"=> "2", "correct_answer"=> "fleißig"},
              "I59"=> { "group"=> "1", "correct_answer"=> "Schwester"},
              "I60"=> { "group"=> "3", "correct_answer"=> "unter"},
}
results.each do |r|
  trend = 0 #check
  negative = []
  positive = []
  data = []
  p_sum = 0
  n_sum = 0
  ada_correct_items = ""
  ada_false_items = ""
  ada_positve = 0
  ada_negative = 0

  avp_correct_items = ""
  avp_false_items = ""
  avp_positve = 0
  avp_negative = 0

  avk_correct_items = ""
  avk_false_items = ""
  avk_positve = 0
  avk_negative = 0

  r.data.each do |d|
    result = 0
    item = items_sel4[d["item"]]
    if item["group"] == "1"
      if d["answer"].gsub(/\u00AD/, '') == item["correct_answer"]
        p_sum += 1
        result = 1
        positive += [d["item"]]
        ada_positve += 1
        if ada_correct_items == ""
          ada_correct_items += item["correct_answer"]
        else
          ada_correct_items += ", " +item["correct_answer"]
        end
      elsif d["answer"].gsub(/\u00AD/, '') != "NA"
        n_sum += 1
        ada_negative += 1
        negative += [d["item"]]
        if ada_false_items == ""
          ada_false_items += item["correct_answer"]
        else
          ada_false_items += ", " + item["correct_answer"]
        end
      else
        result = "NA"
      end
    elsif item["group"] == "2"
      if d["answer"].gsub(/\u00AD/, '') == item["correct_answer"]
        p_sum += 1
        avp_positve += 1
        result = 1
        positive += [d["item"]]
        if avp_correct_items == ""
          avp_correct_items += item["correct_answer"]
        else
          avp_correct_items += ", " +item["correct_answer"]
        end
      elsif d["answer"].gsub(/\u00AD/, '') != "NA"
        avp_negative += 1
        n_sum += 1
        negative += [d["item"]]
        if avp_false_items == ""
          avp_false_items += item["correct_answer"]
        else
          avp_false_items += ", " + item["correct_answer"]
        end
      else
        result = "NA"
      end
    elsif d["answer"].gsub(/\u00AD/, '') != "NA"
      if d["answer"].gsub(/\u00AD/, '') == item["correct_answer"]
        p_sum += 1
        avk_positve += 1
        result = 1
        positive += [d["item"]]
        if avk_correct_items == ""
          avk_correct_items += item["correct_answer"]
        else
          avk_correct_items += ", " +item["correct_answer"]
        end
      elsif d["answer"].gsub(/\u00AD/, '') != "NA"
        avk_negative += 1
        n_sum += 1
        negative += [d["item"]]
        if avk_false_items == ""
          avk_false_items += item["correct_answer"]
        else
          avk_false_items += ", " + item["correct_answer"]
        end
      else
        result = "NA"
      end
    else
      result = "NA"
    end
    data += [{"item": d["item"], "result": result, "group": item["group"], "decription": item["correct_answer"], "answer": d["answer"].gsub(/\u00AD/, ''), "time": d["time"] }]
  end
  last_result = Result.where(assessment_id: r.assessment_id, student_id: r.student_id).where.not(id: r.id).where("test_date < ? ", r.test_date).order(:test_week).last
  trend = last_result.nil? ? 0: (last_result.views['V1'] <= p_sum ? 1: -1)

  lg = ((p_sum.to_f/ (p_sum.to_f+n_sum.to_f))* 100).round(2).to_s
  ri = p_sum.to_s + " von 66"
  ada = "\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e " + ada_positve.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + ada_correct_items + "\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e " + ada_negative.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e"+ ada_false_items
  avp = "\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e " + avp_positve.to_s+ "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + avp_correct_items+ "\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e " +avp_negative.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + avp_false_items
  avk = "\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e " + avk_positve.to_s+ "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + avk_correct_items+ "\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e " +avk_negative.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + avk_false_items

  r.report = {
      "trend":trend,
      "negative":negative,
      "positive": positive
  }
  r.data = data
  v1  = p_sum
  v2 = {
      "LG": lg,
      "RI": ri,
      "ADA": ada,
      "AVP": avp,
      "AVK": avk,
      "LGM": r.views["V2"]["LGM"]

  }
  v3 = {
      "LG": lg,
      "RI": ri,
      "ADA": ada,
      "AVP": avp,
      "AVK": avk,
      "LGM": r.views["V2"]["LGM"],
      "SUM": p_sum
  }
  views = {
      "V1": v1,
      "V2": v2,
      "V3": v3
  }
  r.views = views
  r.save
end

#Lösung für SEL6
t = Test.find_by shorthand: "SEL6"
assessments = Assessment.where(test_id: t.id)
results = Result.where(assessment_id: assessments.ids).order(:test_date)
items_sel6 = {"I1"=> { "group"=> "2", "correct_answer"=> "streiten"},
              "I2"=> { "group"=> "1", "correct_answer"=> "verschwundenen"},
              "I3"=> { "group"=> "3", "correct_answer"=> "Trick"},
              "I4"=> { "group"=> "1", "correct_answer"=> "gefährliche"},
              "I5"=> { "group"=> "2", "correct_answer"=> "Sie"},
              "I6"=> { "group"=> "3", "correct_answer"=> "Klassenzimmer"},
              "I7"=> { "group"=> "3", "correct_answer"=> "jubeln"},
              "I8"=> { "group"=> "2", "correct_answer"=> "ihr"},
              "I9"=> { "group"=> "1", "correct_answer"=> "nicht"},
              "I10"=> { "group"=> "2", "correct_answer"=> "Ihn"},
              "I11"=> { "group"=> "3", "correct_answer"=> "Wiese"},
              "I12"=> { "group"=> "1", "correct_answer"=> "einladen"},
              "I13"=> { "group"=> "3", "correct_answer"=> "sauer"},
              "I14"=> { "group"=> "2", "correct_answer"=> "Leinwand"},
              "I15"=> { "group"=> "3", "correct_answer"=> "Sekunden"},
              "I16"=> { "group"=> "2", "correct_answer"=> "Gebäude"},
              "I17"=> { "group"=> "1", "correct_answer"=> "nichts"},
              "I18"=> { "group"=> "1", "correct_answer"=> "besucht"},
              "I19"=> { "group"=> "2", "correct_answer"=> "Pflanzen"},
              "I20"=> { "group"=> "3", "correct_answer"=> "Bürotür"},
              "I21"=> { "group"=> "3", "correct_answer"=> "Anlegeplätze"},
              "I22"=> { "group"=> "2", "correct_answer"=> "du"},
              "I23"=> { "group"=> "1", "correct_answer"=> "viel"},
              "I24"=> { "group"=> "1", "correct_answer"=> "läuft"},
              "I25"=> { "group"=> "2", "correct_answer"=> "Lebensmittel"},
              "I26"=> { "group"=> "3", "correct_answer"=> "tanken"},
              "I27"=> { "group"=> "2", "correct_answer"=> "Geld"},
              "I28"=> { "group"=> "1", "correct_answer"=> "nie"},
              "I29"=> { "group"=> "3", "correct_answer"=> "Morgen"},
              "I30"=> { "group"=> "2", "correct_answer"=> "Wir"},
              "I31"=> { "group"=> "3", "correct_answer"=> "fährt"},
              "I32"=> { "group"=> "1", "correct_answer"=> "wenig"},
              "I33"=> { "group"=> "1", "correct_answer"=> "verpassen"},
              "I34"=> { "group"=> "3", "correct_answer"=> "rief"},
              "I35"=> { "group"=> "2", "correct_answer"=> "Bild"},
              "I36"=> { "group"=> "3", "correct_answer"=> "Spielplatz"},
              "I37"=> { "group"=> "2", "correct_answer"=> "Diese"},
              "I38"=> { "group"=> "1", "correct_answer"=> "hochwertig"},
              "I39"=> { "group"=> "1", "correct_answer"=> "sehr"},
              "I40"=> { "group"=> "3", "correct_answer"=> "bezahlt"},
              "I41"=> { "group"=> "2", "correct_answer"=> "sie"},
              "I42"=> { "group"=> "2", "correct_answer"=> "Weg"},
              "I43"=> { "group"=> "1", "correct_answer"=> "spielen"},
              "I44"=> { "group"=> "3", "correct_answer"=> "Schreibtisch"},
              "I45"=> { "group"=> "1", "correct_answer"=> "gute"},
              "I46"=> { "group"=> "2", "correct_answer"=> "Arzt"},
              "I47"=> { "group"=> "3", "correct_answer"=> "Monate"},
              "I48"=> { "group"=> "1", "correct_answer"=> "niemals"},
              "I49"=> { "group"=> "2", "correct_answer"=> "feiern"},
              "I50"=> { "group"=> "3", "correct_answer"=> "bald"},
              "I51"=> { "group"=> "3", "correct_answer"=> "Tagen"},
              "I52"=> { "group"=> "2", "correct_answer"=> "Es"},
              "I53"=> { "group"=> "1", "correct_answer"=> "berühmt"},
              "I54"=> { "group"=> "1", "correct_answer"=> "rutschen"},
              "I55"=> { "group"=> "3", "correct_answer"=> "heutzutage"},
              "I56"=> { "group"=> "2", "correct_answer"=> "sie"},
              "I57"=> { "group"=> "2", "correct_answer"=> "Uns"},
              "I58"=> { "group"=> "1", "correct_answer"=> "reichlich"},
              "I59"=> { "group"=> "3", "correct_answer"=> "Jahr"},
              "I60"=> { "group"=> "2", "correct_answer"=> "ihr"},
              "I61"=> { "group"=> "3", "correct_answer"=> "draußen"},
              "I62"=> { "group"=> "1", "correct_answer"=> "liebt"},
              "I63"=> { "group"=> "2", "correct_answer"=> "dieser"},
              "I64"=> { "group"=> "1", "correct_answer"=> "Sonnenuntergänge"},
              "I65"=> { "group"=> "3", "correct_answer"=> "verpasse"},
              "I66"=> { "group"=> "2", "correct_answer"=> "Es"},
              "I67"=> { "group"=> "1", "correct_answer"=> "nicht"},
              "I68"=> { "group"=> "3", "correct_answer"=> "Ständen"},
              "I69"=> { "group"=> "3", "correct_answer"=> "Damals"},
              "I70"=> { "group"=> "1", "correct_answer"=> "etwas"},
              "I71"=> { "group"=> "2", "correct_answer"=> "Bibliothek"},
              "I72"=> { "group"=> "1", "correct_answer"=> "verbogen"},
              "I73"=> { "group"=> "2", "correct_answer"=> "klatschen"},
              "I74"=> { "group"=> "3", "correct_answer"=> "schließen"},
              "I75"=> { "group"=> "2", "correct_answer"=> "ihnen"},
              "I76"=> { "group"=> "1", "correct_answer"=> "ausleihe"},
              "I77"=> { "group"=> "3", "correct_answer"=> "Winter"},
              "I78"=> { "group"=> "2", "correct_answer"=> "Pflegerinnen"},
              "I79"=> { "group"=> "1", "correct_answer"=> "verdienen"},
              "I80"=> { "group"=> "3", "correct_answer"=> "kaut"},
              "I81"=> { "group"=> "2", "correct_answer"=> "Ordnungshüter"},
              "I82"=> { "group"=> "3", "correct_answer"=> "Minuten"},
              "I83"=> { "group"=> "1", "correct_answer"=> "verbessert"},
              "I84"=> { "group"=> "2", "correct_answer"=> "ihnen"},
              "I85"=> { "group"=> "2", "correct_answer"=> "Auto"},
              "I86"=> { "group"=> "2", "correct_answer"=> "schließen"},
              "I87"=> { "group"=> "2", "correct_answer"=> "verstummen"},
              "I88"=> { "group"=> "2", "correct_answer"=> "Ozean"},
              "I89"=> { "group"=> "2", "correct_answer"=> "heften"},
              "I90"=> { "group"=> "2", "correct_answer"=> "Dame"},
              "I91"=> { "group"=> "2", "correct_answer"=> "Schwimmen"},
              "I92"=> { "group"=> "2", "correct_answer"=> "euch"},
              "I93"=> { "group"=> "2", "correct_answer"=> "Dieser"},
}
results.each do |r|
  trend = 0 #check
  negative = []
  positive = []
  data = []
  p_sum = 0
  n_sum = 0
  comp_correct_items = ""
  comp_false_items = ""
  comp_positve = 0
  comp_negative = 0

  inf_correct_items = ""
  inf_false_items = ""
  inf_positve = 0
  inf_negative = 0

  koh_correct_items = ""
  koh_false_items = ""
  koh_positve = 0
  koh_negative = 0

  r.data.each do |d|
    result = 0
    item = items_sel6[d["item"]]
    if item["group"] == "1"
      if d["answer"].gsub(/\u00AD/, '') == item["correct_answer"]
        p_sum += 1
        result = 1
        positive += [d["item"]]
        comp_positve += 1
        if comp_correct_items == ""
          comp_correct_items += item["correct_answer"]
        else
          comp_correct_items += ", " +item["correct_answer"]
        end
      elsif d["answer"].gsub(/\u00AD/, '') != "NA"
        n_sum += 1
        comp_negative += 1
        negative += [d["item"]]
        if comp_false_items == ""
          comp_false_items += item["correct_answer"]
        else
          comp_false_items += ", " + item["correct_answer"]
        end
      else
        result = "NA"
      end
    elsif item["group"] == "2"
      if d["answer"].gsub(/\u00AD/, '') == item["correct_answer"]
        p_sum += 1
        inf_positve += 1
        result = 1
        positive += [d["item"]]
        if inf_correct_items == ""
          inf_correct_items += item["correct_answer"]
        else
          inf_correct_items += ", " +item["correct_answer"]
        end
      elsif d["answer"].gsub(/\u00AD/, '') != "NA"
        inf_negative += 1
        n_sum += 1
        negative += [d["item"]]
        if inf_false_items == ""
          inf_false_items += item["correct_answer"]
        else
          inf_false_items += ", " + item["correct_answer"]
        end
      else
        result = "NA"
      end
    elsif d["answer"].gsub(/\u00AD/, '') != "NA"
      if d["answer"].gsub(/\u00AD/, '') == item["correct_answer"]
        p_sum += 1
        koh_positve += 1
        result = 1
        positive += [d["item"]]
        if koh_correct_items == ""
          koh_correct_items += item["correct_answer"]
        else
          koh_correct_items += ", " +item["correct_answer"]
        end
      elsif d["answer"].gsub(/\u00AD/, '') != "NA"
        koh_negative += 1
        n_sum += 1
        negative += [d["item"]]
        if koh_false_items == ""
          koh_false_items += item["correct_answer"]
        else
          koh_false_items += ", " + item["correct_answer"]
        end
      else
        result = "NA"
      end
    else
      result = "NA"
    end
    data += [{"item": d["item"], "result": result, "group": item["group"], "decription": item["correct_answer"], "answer": d["answer"].gsub(/\u00AD/, ''), "time": d["time"] }]
  end
  last_result = Result.where(assessment_id: r.assessment_id, student_id: r.student_id).where.not(id: r.id).where("test_date < ? ", r.test_date).order(:test_week).last
  trend = last_result.nil? ? 0: (last_result.views['V1'] <= p_sum ? 1: -1)

  lg = ((p_sum.to_f/ (p_sum.to_f+n_sum.to_f))* 100).round(2).to_s
  ri = p_sum.to_s + " von 93"
  comp = "\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e " + comp_positve.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + comp_correct_items + "\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e " + comp_negative.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e"+ comp_false_items
  inf = "\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e " + inf_positve.to_s+ "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + inf_correct_items+ "\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e " + inf_negative.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + inf_false_items
  koh = "\u003cstrong\u003eAnzahl richtig gelöster Items:\u003c/strong\u003e " + koh_positve.to_s+ "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + koh_correct_items+ "\u003cbr/\u003e\u003cbr/\u003e\u003cstrong\u003eAnzahl falsch gelöster Items:\u003c/strong\u003e " + koh_negative.to_s + "\u003chr style=\"margin-top:0; margin-bottom:0\"/\u003e" + koh_false_items

  r.report = {
      "trend":trend,
      "negative":negative,
      "positive": positive
  }
  r.data = data
  v1  = p_sum
  v2 = {
      "LG": lg,
      "RI": ri,
      "KOMS": comp,
      "INF": inf,
      "KO": koh,
      "LGM": r.views["V2"]["LGM"]

  }
  v3 = {
      "LG": lg,
      "RI": ri,
      "KOMS": comp,
      "INF": inf,
      "KO": koh,
      "LGM": r.views["V2"]["LGM"],
      "SUM": p_sum
  }
  views = {
      "V1": v1,
      "V2": v2,
      "V3": v3
  }
  r.views = views
  r.save
end

#Lösung falsch abgegebene Results, Key TS0, Zeit ARTH
results_removed = 0
results_to_remove = []
Result.where('test_date > 2019-09-25').each do |r|
  begin
    if r.views["V1"].include?("NA")
      if r.data.size > Test.find(Assessment.find(r.assessment_id).test_id).items.size
        #r.destroy
        results_to_remove += [r.id]
        results_removed += 1
      end
    end
  rescue
  end
  if r.assessment.test.shorthand == "TS0" && r.views.has_key?("Übersicht")
    r.views = {'V1': r.views['Übersicht']}
    r.save
  end
  if r.assessment.test.shorthand == "ARTH" && r.test_date < Date.parse('2019-12-05')
    newDate = []
    r.data.each_with_index do |d, i|
      if i == 0
        newDate += [d]
      elsif d['time']!= 'NA' && d['time'] > 300000
        newDate += [{"item": d["item"], "time": (d["time"] - r.data[i-1]["time"]), "group": d["group"], "answer": d["answer"], "result": d["result"], "description": d["description"]}]
      else
        newDate += [d]
      end
    end
    r.data = newDate
    r.save
  end
end
p "Anzahl defekter Results " + results_removed
p "IDs der defekten Results " + results_to_remove

#Lösung für Lehrerübung
t = Test.where("shorthand= 'BPL3a2' OR shorthand= 'BPL3a1' OR shorthand= 'BPL3b1' OR shorthand= 'BPL3b2'")
assessments = Assessment.where(test_id: t.ids)
results = Result.where(assessment_id: assessments.ids).where('test_date < "2019-11-28"').order(:test_date)
results.each do |r|
  rbc_ml = ""
  rbc_ol = ""
  fbc_ml = ""
  fbc_ol = ""
  r.data.each do |d|
    if d["group"] == 1
      if d["result"] == 1
        if rbc_ol == ""
          rbc_ol = d["description"]
        else
          rbc_ol += ", " + d["description"]
        end
      else
        if fbc_ol == ""
          fbc_ol = d["description"]
        else
          fbc_ol += ", " + d["description"]
        end
      end
    elsif d["group"] == 0
      if d["result"] == 1
        if rbc_ml == ""
          rbc_ml = d["description"]
        else
          rbc_ml += ", " + d["description"]
        end
      else
        if fbc_ml == ""
          fbc_ml = d["description"]
        else
          fbc_ml += ", " + d["description"]
        end
      end
    end
  end

  fbc = "\u003ctable class=\"table table-bordered\" style=\"margin-bottom: 0\"\u003e\u003cthead\u003e\u003ctr style=\"background-color: rgba(0,0,0,0)\"\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems mit Lesefehler\u003c/th\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems ohne Lesefehler\u003c/th\u003e\u003c/tr\u003e\u003c/thead\u003e\u003ctbody\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003e" + fbc_ml + "\u003c/td\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003e" + fbc_ol + "\u003c/td\u003e\u003c/tbody\u003e\u003c/table\u003e"
  rbc = "\u003ctable class=\"table table-bordered\" style=\"margin-bottom: 0\"\u003e\u003cthead\u003e\u003ctr style=\"background-color: rgba(0,0,0,0)\"\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems mit Lesefehler\u003c/th\u003e\u003cth scope=\"col\" style=\"border: 1px solid #dee2e6;text-align: center\"\u003eItems ohne Lesefehler\u003c/th\u003e\u003c/tr\u003e\u003c/thead\u003e\u003ctbody\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003e" + rbc_ml + "\u003c/td\u003e\u003ctd style=\"border: 1px solid #dee2e6;text-align: center\"\u003e" + rbc_ol + "\u003c/td\u003e\u003c/tbody\u003e\u003c/table\u003e"

  v1  = r.views['V1']
  v2 = {
      "PW": r.views['V2']['PW'],
      "FBC": fbc,
      "RBC": rbc

  }
  v3 = {
      "PW": r.views['V3']['PW'],
      "RB": r.views['V3']['RB'],
      "FBC": fbc,
      "FBL": r.views['V3']['FBL'],
      "RBC": rbc,
      "FBOL": r.views['V3']['FBOL']
  }
  views = {
      "V1": v1,
      "V2": v2,
      "V3": v3
  }
  r.views = views
  r.save
end





