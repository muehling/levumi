class TestDictation < Test

  def draw_items(first)
    if first
      return super
    end
    itemset = Array.new
    firstthirty = content_items.take(30)
    count = 0
    len.times do
      if(count<30)
        remaining = firstthirty - itemset
        itemset = itemset + [remaining.sample]
        count = count + 1
      else
        remaining = content_items - itemset
        itemset = itemset + [remaining.sample]
      end
    end
    return [intro_items.map{|i| i.id}, itemset.map{|i| i.id}, outro_items.map{|i| i.id}]
  end

  def check_result(result)
    if result.extra_data.has_key?("answers")
      answers = result.extra_data["answers"]
      #watch out for big id-array. otherwise the runtime could be bad -> sort_by
      items = Item.where(id:result.items.first(answers.length)).sort_by{ |u| result.items.first(answers.length).index(u.id) }
      tested_item_texts =[]
      items.each do |i|
        tested_item_texts += [i.itemtext]
      end

      #Example: result.extra_data["principle"]={"psError" => 5,"psCount" => 35,"mpError" => 4,"mpCount" => 23,"wbError" => 4,"wbCount" =>5,"pbError" => 6,"pbCount" =>13}
      result.extra_data["principle"]= check_principles(tested_item_texts, answers)
    else
      result.extra_data["principle"] = {"psError" => 0,"psCount" => 0,"mpError" => 0,"mpCount" => 0,"wbError" => 0,"wbCount" =>0,"pbError" => 0,"pbCount" =>0}
    end
    #Alternativ:
    return result.extra_data
  end



  # @Author: Jan Ole Albert
  # @Version: 1.0



  #Diese Funktion nimmt die Daten zu einem Wort und eine geschriebene Version dieses Wortes entgegen und sucht darin nach Fehlern in Lupenstellen.
  #Falls Inserts stattfanden, die zwischen Lupenstellen liegen, werden von hier aus die Extraregeln aufgerufen.
  #Die Ausgabe ist ein Array. Der erste Eintrag dieses Arrays ist ein Array mit einer textuellen Auflistung aller gefundener Fehler.
  #Dabei hat jeder Fehler seinen eigenen Eintrag im Array.
  #Der zweite Eintrag ist ein Array von Arrays mit folgenden Informationen:
  #	[0][0]: "quantitative Korrektheit: ", 		[0][1]: ein boolscher Wert, der angibt, ob das Wort quantitaive korrekt geschrieben wurde
  #	[1][0]: "wortübergreifende Korrektheit: ", 	[1][1]: ein boolscher Wert, der angibt, ob die Groß-/Kleinschreibung korrekt ist
  #	[2][0]: "Pluralform: ", 					[2][1]: ein boolscher Wert, der angibt, ob keine der Pluralformen des Wortes geschrieben wurde (also true = keine Pluralform verwendet)
  #	[3][0]: "Komposition: ", 					[3][1]: ein boolscher Wert, der angibt, ob die Komposition stimmt, nil, falls es keine Kompositions-Lupenstelle gibt
  #	Es folgt eine Auflistung der Lupenstellen:
  #	[n][0]: "ps"/"m"/"wb"/"p" je nach Prinzip der Lupenstelle, [n][1]: Anfang der Lupenstelle, [n][2]: Ende der Lupenstelle, [n][3]: ein boolscher Wert, der angibt, ob die Lupenstelle korrekt oder falsch ist
  #	Die Reihenfolge der Lupenstellen richtet sich nach der Reihenfolge im Wort.
  #Wichtig: Sowohl alle Strings im Wortlisteneintrag, als auch das zu testende Wort müssen in UTF-8 Kodierung übergeben werden!
  def primarySearch(wordListEntry, wordToTest)

    # Initialisierung des Ausgabe-Arrays.
    textualOutput = Array.new

    # Initialisierung des Ausgabe-Arrays für computerisierte Weiterverarbeitung der Auswertungsdaten.
    boolshOutput = Array.new
    boolshOutput = fill(boolshOutput, wordListEntry)

    # Es wird eine lokale Kopie des korrekten Wortes erstellt, um Array-Zugriffe zu sparen.
    correctWord = wordListEntry[WORD]

    # Die quantitative Korrektheit gibt an, ob ein Wort ganz richtig geschrieben wurde, oder ob Fehler (irgendeiner Art) vorkommen.
    quantCorr = true
    # Die wortübergreifende Korrektheit gibt an, ob ein Wort z.B. korrekt groß bzw. klein geschrieben wurde.
    capCorr = true

    # Hier wird überprüft, ob die Komposition stimmt, falls vorhanden/benötigt
    if(wordListEntry[COMPOSITION]) then
      # Wenn ein nicht-Buchstabe (also Leerzeichen oder Bindestrich) enthalten ist, dann wird das Wort durch split in ein Array mit mindestens zwei Einträgen aufgetrennt.
      if(wordToTest.strip.split(/[^a-zA-ZäöüßÄÖÜ]/).length > 1) then
        boolshOutput[3][1] = false # Komposition wird als falsch markiert
        quantCorr = false

        # Alle nicht-Buchstaben werden aus dem Wort entfernt.
        wordToTest = wordToTest.gsub(/[^a-zA-ZäöüßÄÖÜ]/,"")
      else
        boolshOutput[3][1] = true
      end
    else
      boolshOutput[3][1] = nil
    end

    # Hier wird die Levenshtein-Distanz des korrekten und des vom Lernenden geschriebenen Wortes gebildet.
    levenshtein = berechneIterativDistanzVon(correctWord, downcase(wordToTest.strip))


    # Die Anzahl der Einfüge-Operationen muss mitgezählt werden, um die Lupenstellen richtig zuornen zu können.
    numOfInsert = 0

    # Wenn ein insert nach einer Lupenstelle stattgefunden hat, kann diese mit den Extraregeln trotzdem als falsch gewertet werden.
    # Die Extraregeln werden nach der primären Suche angewendet und bearbeiten alle diese inserts, sofern es mindestens eines gab.
    everyInsertInsideLupenstelle = true

    # Im Array sind alle Wörter klein geschrieben, ein Boolean gibt an, ob sie normalerweise groß geschrieben werden.
    # Wenn das der Fall ist, dann wird die lokale Kopie des Wortes dementsprechend korrigiert.
    if(wordListEntry[CAPITAL]) then correctWord = capitalize(correctWord) end

    if(levenshtein[0] > correctWord.length) then textualOutput.push("Zu viele Fehler!")
    elsif (levenshtein[0] == 0) then
      if(wordToTest[0].eql?(capitalize(wordToTest[0])) ^ wordListEntry[CAPITAL]) then
        textualOutput.push("Es wurde lediglich die Groß-/Kleinschreibung verletzt")
        capCorr = false
      else
        textualOutput.push("Es wurden keine Fehler gemacht!")
      end
    else textualOutput.push("Fehler wurden folgendermaßen Kategorisiert:")

    # Erster Test, ob die Groß-/Kleinschreibung korrekt ist.
    if(wordToTest[0].eql?(capitalize(wordToTest[0])) ^ wordListEntry[CAPITAL]) then
      textualOutput.push("Groß-/Kleinschreibung verletzt")
      capCorr = false
    end

    levenshtein[1].each_index{
        |index|
      # ein replace oder ein delete ist immer in einer Lupenstelle zu finden
      if(levenshtein[1][index].eql?("r") || levenshtein[1][index].eql?("d")) then

        # Sobald ein Replace oder Delete stattfand, ist die quantitative Korrektheit nicht mehr gewährleistet.
        quantCorr = false

        # Lupenstellen des Phonologisch-Silbischen Prinzip durchgehen
        wordListEntry[PS_PRINZIP].each{
            |lupenstelle|
          if((lupenstelle[0] <= (index - numOfInsert)) &
              ((index - numOfInsert) <= lupenstelle[1])) then
            selectiveOutput(textualOutput, "Phonologisch-Silbisches Prinzip verletzt. Lupenstelle: " + correctWord[lupenstelle[0]..lupenstelle[1]])
            selectiveOutput(boolshOutput, [lupenstelle[0], lupenstelle[1], false])

            # Wenn der letzte Buchstabe einer Lupenstelle ersetzt wurde, kann es sein, dass damit der folgende Buchstabe verdoppelt wurde.
            # In dem Fall ist die folgende Lupenstelle falsch!
            if(((index - numOfInsert) == lupenstelle[1]) & levenshtein[1][index].eql?("r")) then
              wrongDoubleLetterByReplacing(levenshtein[1], index, correctWord, wordToTest, boolshOutput, lupenstelle).each{
                  |mistake|
                selectiveOutput(textualOutput, mistake)
              }
            end
          end
        }

        # Lupenstellen des Morphologischen Prinzip durchgehen
        wordListEntry[M_PRINZIP].each{
            |lupenstelle|
          if((lupenstelle[0] <= (index - numOfInsert)) &
              ((index - numOfInsert) <= lupenstelle[1])) then
            selectiveOutput(textualOutput, "Morphologisches Prinzip verletzt. Lupenstelle: " + correctWord[lupenstelle[0]..lupenstelle[1]])
            selectiveOutput(boolshOutput, [lupenstelle[0], lupenstelle[1], false])

            # Wenn der letzte Buchstabe einer Lupenstelle ersetzt wurde, kann es sein, dass damit der folgende Buchstabe verdoppelt wurde.
            # In dem Fall ist die folgende Lupenstelle falsch!
            if(((index - numOfInsert) == lupenstelle[1]) & levenshtein[1][index].eql?("r")) then
              wrongDoubleLetterByReplacing(levenshtein[1], index, correctWord, wordToTest, boolshOutput, lupenstelle).each{
                  |mistake|
                selectiveOutput(textualOutput, mistake)
              }
            end
          end
        }

        # Lupenstellen des Wortbildungsprinzip durchgehen
        wordListEntry[WB_PRINZIP].each{
            |lupenstelle|
          if((lupenstelle[0] <= (index - numOfInsert)) &
              ((index - numOfInsert) <= lupenstelle[1])) then
            selectiveOutput(textualOutput, "Wortbildungsprinzip verletzt. Lupenstelle: " + correctWord[lupenstelle[0]..lupenstelle[1]])
            selectiveOutput(boolshOutput, [lupenstelle[0], lupenstelle[1], false])

            # Wenn der letzte Buchstabe einer Lupenstelle ersetzt wurde, kann es sein, dass damit der folgende Buchstabe verdoppelt wurde.
            # In dem Fall ist die folgende Lupenstelle falsch!
            if(((index - numOfInsert) == lupenstelle[1]) & levenshtein[1][index].eql?("r")) then
              wrongDoubleLetterByReplacing(levenshtein[1], index, correctWord, wordToTest, boolshOutput, lupenstelle).each{
                  |mistake|
                selectiveOutput(textualOutput, mistake)
              }
            end
          end
        }

        # Lupenstellen des Peripheriebereich durchgehen
        wordListEntry[P_BEREICH].each{
            |lupenstelle|
          if((lupenstelle[0] <= (index - numOfInsert)) &
              ((index - numOfInsert) <= lupenstelle[1])) then
            selectiveOutput(textualOutput, "Peripheriebereich verletzt. Lupenstelle: " + correctWord[lupenstelle[0]..lupenstelle[1]])
            selectiveOutput(boolshOutput, [lupenstelle[0], lupenstelle[1], false])

            # Wenn der letzte Buchstabe einer Lupenstelle ersetzt wurde, kann es sein, dass damit der folgende Buchstabe verdoppelt wurde.
            # In dem Fall ist die folgende Lupenstelle falsch!
            if(((index - numOfInsert) == lupenstelle[1]) & levenshtein[1][index].eql?("r")) then
              wrongDoubleLetterByReplacing(levenshtein[1], index, correctWord, wordToTest, boolshOutput, lupenstelle).each{
                  |mistake|
                selectiveOutput(textualOutput, mistake)
              }
            end
          end
        }

        # Ein insert kann in einer Lupenstelle sein oder zwischen zwei sollcher liegen. In dem Fall muss die zusätzliche Liste mit Regeln durchgegangen werden.
        # Insbesonders muss bei einer Lupenstelle auf der linken Seite mit einer harten Grenzen gearbeitet werden.
      elsif(levenshtein[1][index].eql?("i")) then


        # Wenn ein Insert stattgefunden hat, dann kann es zwischen Lupenstellen liegen, oder innerhalb
        insideLupenstelle = false

        # Sobald ein Insert stattfand, ist die quantitative Korrektheit nicht mehr gewährleistet.
        quantCorr = false

        # Lupenstellen des Phonologisch-Silbisches Prinzip durchgehen
        wordListEntry[PS_PRINZIP].each{
            |lupenstelle|
          if(((index - numOfInsert) > lupenstelle[0]) & ((index - numOfInsert) <= lupenstelle[1])) then
            selectiveOutput(textualOutput, "Phonologisch-Silbisches Prinzip verletzt. Lupenstelle: " + correctWord[lupenstelle[0]..lupenstelle[1]])
            selectiveOutput(boolshOutput, [lupenstelle[0], lupenstelle[1], false])
            insideLupenstelle = true
          end

        }

        # Lupenstellen des Morphologisches Prinzip durchgehen
        wordListEntry[M_PRINZIP].each{
            |lupenstelle|
          if(((index - numOfInsert) > lupenstelle[0]) & ((index - numOfInsert) <= lupenstelle[1])) then
            selectiveOutput(textualOutput, "Morphologisches Prinzip verletzt. Lupenstelle: " + correctWord[lupenstelle[0]..lupenstelle[1]])
            selectiveOutput(boolshOutput, [lupenstelle[0], lupenstelle[1], false])
            insideLupenstelle = true
          end
        }

        # Lupenstellen des Wortbildungsprinzip durchgehen
        wordListEntry[WB_PRINZIP].each{
            |lupenstelle|
          if(((index - numOfInsert) > lupenstelle[0]) & ((index - numOfInsert) <= lupenstelle[1])) then
            selectiveOutput(textualOutput, "Wortbildungsprinzip verletzt. Lupenstelle: " + correctWord[lupenstelle[0]..lupenstelle[1]])
            selectiveOutput(boolshOutput, [lupenstelle[0], lupenstelle[1], false])
            insideLupenstelle = true
          end
        }

        # Lupenstellen des Peripheriebereich durchgehen
        wordListEntry[P_BEREICH].each{
            |lupenstelle|
          if(((index - numOfInsert) > lupenstelle[0]) & ((index - numOfInsert) <= lupenstelle[1])) then
            selectiveOutput(textualOutput, "Peripheriebereich verletzt. Lupenstelle: " + correctWord[lupenstelle[0]..lupenstelle[1]])
            selectiveOutput(boolshOutput, [lupenstelle[0], lupenstelle[1], false])
            insideLupenstelle = true
          end
        }

        # Wenn ein insert stattgefunden hat, dann ist das falsch geschriebene Wort länger als das richtig geschriebene.
        # Damit weiter hinten stehende Lupenstellen richtig zugeordnet werden muss also der Modifikator verringert werden.
        numOfInsert += 1

        # Wenn nur ein insert außerhalb jeder Lupenstelle liegt, wird everyInsertInsideLupenstelle auf false gesetzt.
        everyInsertInsideLupenstelle = everyInsertInsideLupenstelle & insideLupenstelle
      end
    }

    # Wenn (mindestens) ein Insert zwischen zwei Lupenstellen stattfand, dann müssen die Extraregeln durchlaufen werden.
    # Diese trennen sich in die ersten 4, welche alle morphologische Lupenstellen betreffen, und die letzten 3 Regeln,
    # welche alle wortbildungs-Lupenstellen betreffen.
    if(!everyInsertInsideLupenstelle) then
      wrongAnyway1(levenshtein[1], wordListEntry, wordToTest, correctWord, boolshOutput).each{
          |mistake|
        selectiveOutput(textualOutput, mistake)
      }

    end
    wrongAnyway2(levenshtein[1], correctWord, wordToTest, boolshOutput).each{
        |mistake|
      selectiveOutput(textualOutput, mistake)
    }

    wrongVocalOrEnding(levenshtein[1], wordListEntry, wordToTest, correctWord, boolshOutput).each{
        |mistake|
      selectiveOutput(textualOutput, mistake)
    }

    end

    if(boolshOutput[3][1]) then
      textualOutput.push("Komposition nicht korrekt.")
    end

    # Wenn nur die quantitative Korrektheit als falsch erkannt wurde, wird dem textuellen Ausgabe-Array eine entsprechende Meldung hinzugefügt.
    if ((textualOutput.length == 1) & textualOutput[0].end_with?(":")) then
      textualOutput[0] = "Es wurden nicht-kategorisierbare Fehler gemacht!"
    end

    # Übertrage die boolschen Werte für quantitaive und wortübergreifende Korrektheit, sowie ob eine Pluralform vorliegt ins zweite Ausgabe-Array.
    boolshOutput[0][1] = quantCorr
    boolshOutput[1][1] = capCorr
    if(boolshOutput[2][1]) then boolshOutput[2][1] = true end

    return [textualOutput, boolshOutput]

  end

  def wrongAnyway1(levenshteinSpur, wordListEntry, wordToTest, correctWord, boolshOutput)

    textualOutput = Array.new

    # Pluralform?
    wordListEntry[PLURAL].each{
        |plural|
      if(wordListEntry[CAPITAL]) then
        if(capitalize(plural).eql?(wordToTest)) then
          boolshOutput[2][1] = false
          return ["Wort falsch durch Pluralbildung!"]
        end
      else
        if(plural.eql?(wordToTest)) then
          boolshOutput[2][1] = false
          return ["Wort falsch durch Pluralbildung!"]
        end
      end
    }

    # Für jeden Wortstamm wird getestet, ob er ganz korrekt ist. Wortstämme sind immer eine Morphologische Lupenstelle.
    wordListEntry[M_PRINZIP].each{
        |lupenstelle|

      #Zählt die Anzahl der Einfüge- und Lösch-Operationen zur Navigation zwischen den Lupenstellen.
      numOfInsert = 0
      numOfDelete = 0
      i = 0 # Laufindex
      while(i <= lupenstelle[0] + numOfInsert)
        if(levenshteinSpur[i].eql?("i")) then
          numOfInsert += 1
        end
        if(levenshteinSpur[i].eql?("d")) then
          numOfDelete += 1
        end
        i += 1

      end

      # Wortstamm -> Flag gesetzt?
      if(lupenstelle[2]) then

        # Wortstamm korrekt geschrieben?
        lupenstelleCorrect = true
        (lupenstelle[0]+numOfInsert).upto(lupenstelle[1]+numOfInsert){
            |x|
          if(!levenshteinSpur[x].eql?("e")) then lupenstelleCorrect = false end
        }
        if(lupenstelleCorrect) then

          # Gibt es einen Buchstaben nach der Lupenstelle und wurde dieser eingefügt?
          if(((levenshteinSpur.length - 1) - (lupenstelle[1] + numOfInsert) >= 1) & (levenshteinSpur[lupenstelle[1] + numOfInsert + 1].eql?("i"))) then
            textualOutput.push("Nach Wortstamm " + correctWord[lupenstelle[0]..lupenstelle[1]] + "wird kein Buchstabe eingefügt!")
            selectiveOutput(boolshOutput, [lupenstelle[0], lupenstelle[1], false])

            # Gibt es zwei identische Buchstaben nach der Lupenstelle und wurde einer davon eingefügt? (möglich wegen Entstehungsreihenfolge der Spur)
            # gibt es zwei Buchstaben?
          elsif(((levenshteinSpur.length - 1) - (lupenstelle[1] + numOfInsert) >= 2) &
              # wurde einer davon eingefügt?
              (levenshteinSpur[lupenstelle[1] + numOfInsert + 1].eql?("i") || levenshteinSpur[lupenstelle[1] + numOfInsert + 2].eql?("i"))) then
            # sind diese identisch?
            if(wordToTest[lupenstelle[1] + numOfInsert + 1].eql?(wordToTest[lupenstelle[1] + numOfInsert + 2])) then

              textualOutput.push("Nach Wortstamm " + correctWord[lupenstelle[0]..lupenstelle[1]] + "wird kein Buchstabe eingefügt!")
              selectiveOutput(boolshOutput, [lupenstelle[0], lupenstelle[1], false])
            end
          end
        end

      end

    }

    # Für jede Lupenstelle des Wortbildungsprinzips wird getestet, ob sie ganz korrekt ist. Wenn danach die Regeln 5, 6 oder 7 greifen wird sie dennoch als falsch gewertet.
    wordListEntry[WB_PRINZIP].each{
        |lupenstelle|

      #Zählt die Anzahl der Einfüge- und Lösch-Operationen zur Navigation zwischen den Lupenstellen.
      numOfInsert = 0
      numOfDelete = 0
      i = 0 # Laufindex
      while(i <= lupenstelle[0] + numOfInsert)
        if(levenshteinSpur[i].eql?("i")) then
          numOfInsert += 1
        end
        if(levenshteinSpur[i].eql?("d")) then
          numOfDelete += 1
        end
        i += 1

      end

      # Test, ob die Spur in der Lupenstelle nur e's aufweist, also ob der/die Lernende diese Lupenstelle richtig geschrieben hat.
      lupenstelleCorrect = true
      (lupenstelle[0]+numOfInsert).upto(lupenstelle[1]+numOfInsert){
          |x|
        if(!levenshteinSpur[x].eql?("e")) then lupenstelleCorrect = false end
      }

      # Wenn das der Fall ist, dann muss die Stelle ggf trotzdem als falsch betrachtet werden.
      if(lupenstelleCorrect) then

        # Vor einem Suffix, der mit einem Vokal beginnt, darf kein Doppelkonsonant stehen.
        # Ist die Lupenstelle die letzte im Wort?
        if((lupenstelle[1] == (correctWord.length - 1)) &
            # Endet sie auf einen Suffix, der mit einem Vokal anfängt?
            (correctWord.end_with?("ab","abel","aceae","affin","age","al","ales","an","ant","anz","arisch","arium","ase","at","ation","au",
                                   "e","eck","eder","egk","ei","el","ell","en","end","ens","ent","enz","er","erei","erl","erweise","esk","ette",
                                   "ibel","id","idae","ie","iell","ien","ier","ig","igk","ik","in","inae","ing","innen","ion","isch","isier","isk","ismus","ist","it","ition","ität","iv",
                                   "oat","oid","ol","on","or","ose","ow",
                                   "uell","ung")) &
            # Wurde davor ein Buchstabe eingefügt?
            (levenshteinSpur[numOfInsert + lupenstelle[0] - 1].eql?("i"))) then
          # Ist dieser Buchstabe der selbe, wie der davor?
          if((wordToTest[numOfInsert + lupenstelle[0] - 1 - numOfDelete].eql?(wordToTest[numOfInsert + lupenstelle[0] - 2 - numOfDelete])) &
              # Ist dieser Buchstabe ein Konsonant?
              (!wordToTest[numOfInsert + lupenstelle[0] - 1 - numOfDelete].end_with?("a","e","i","o","u","ä","ö","ü"))) then

            textualOutput.push("Vor Suffixen mit Vokalendung darf kein Doppelkonsonant stehen!")
            selectiveOutput(boolshOutput, [lupenstelle[0], lupenstelle[1], false])
          end
        end

        # Nach Präfixen mit Vokalendung darf keine Dehnung durch "h" erfolgen.
        # Ist die Lupenstelle als Präfix markiert?
        if(lupenstelle[2] &
            # Endet der Präfix auf einen Vokal?
            (correctWord[lupenstelle[1]].end_with?("a","e","i","o","u","ä","ö","ü")) &
            # Wurde nach dem Vokal ein Buchstabe eingefügt?
            (levenshteinSpur[lupenstelle[1] + numOfInsert + 1].eql?("i"))) then
          # Ist dieser Buchstabe ein "h" oder der vorherige Vokal wiederholt?
          if(wordToTest[lupenstelle[1] + 1 + numOfInsert - numOfDelete].eql?("h") || wordToTest[lupenstelle[1] + 1 + numOfInsert - numOfDelete].eql?(wordToTest[lupenstelle[1] + numOfInsert - numOfDelete])) then

            textualOutput.push("Nach Präfixen mit Vokalendung darf kein Dehnungs-h oder eine Dopplung des Vokals stehen! Betroffener Präfix: " + correctWord[lupenstelle[0]..lupenstelle[1]])
            selectiveOutput(boolshOutput, [lupenstelle[0], lupenstelle[1], false])
          end
        end

        # Nach Präfixen mit Konsonantenendung darf dieser Konsonant nicht erneut eingefügt sein.
        # Ist die Lupenstelle als Präfix markiert?
        if(lupenstelle[2] &
            # Endet der Präfix auf einen Konsonanten?
            (!correctWord[lupenstelle[1]].end_with?("a","e","i","o","u","ä","ö","ü")) &
            # Wurde nach dem Konsonanten ein Buchstabe eingefügt?
            (levenshteinSpur[lupenstelle[1] + numOfInsert + 1].eql?("i"))) then
          # Ist dieser Buchstabe der selbe, wie der letzte des Präfix?
          if(wordToTest[lupenstelle[1] + 1 + numOfInsert - numOfDelete].eql?(wordToTest[lupenstelle[1] + numOfInsert - numOfDelete])) then

            textualOutput.push("Nach Präfixen mit Konsonantenendung darf dieser Konsonant nicht erneut eingefügt sein! Betroffener Präfix: " + correctWord[lupenstelle[0]..lupenstelle[1]])

            selectiveOutput(boolshOutput, [lupenstelle[0], lupenstelle[1], false])
          end
        end
      end
    }

    return textualOutput
  end

  # Diese Regeln decken Fälle ab, die nicht bei Frahm erwähnt werden.
  def wrongAnyway2(levenshteinSpur, correctWord, wordToTest, boolshOutput)

    textualOutput = Array.new
    # Wenn der erste/letzte Buchstabe im falschen Wort eingefügt wurde, dann werte die erste/letzte Lupenstelle als falsch.
    if(levenshteinSpur[-1].eql?("i") & boolshOutput[-1][3]) then
      boolshOutput[-1][3] = false

      if(boolshOutput[-1][0].eql?("ps")) then
        textualOutput.push("Phonologisch-Silbisches Prinzip verletzt. Lupenstelle: " + correctWord[boolshOutput[-1][1]..boolshOutput[-1][2]])

      elsif(boolshOutput[-1][0].eql?("m")) then
        textualOutput.push("Morphologisches Prinzip verletzt. Lupenstelle: " + correctWord[boolshOutput[-1][1]..boolshOutput[-1][2]])

      elsif(boolshOutput[-1][0].eql?("wb")) then
        textualOutput.push("Wortbildungsprinzip verletzt. Lupenstelle: " + correctWord[boolshOutput[-1][1]..boolshOutput[-1][2]])

      else
        textualOutput.push("Peripheriebereich verletzt. Lupenstelle: " + correctWord[boolshOutput[-1][1]..boolshOutput[-1][2]])
      end
    end

    if(levenshteinSpur[0].eql?("i") & boolshOutput[4][3]) then
      boolshOutput[4][3] = false

      if(boolshOutput[4][0].eql?("ps")) then
        textualOutput.push("Phonologisch-Silbisches Prinzip verletzt. Lupenstelle: " + correctWord[boolshOutput[-1][1]..boolshOutput[-1][2]])

      elsif(boolshOutput[4][0].eql?("m")) then
        textualOutput.push("Morphologisches Prinzip verletzt. Lupenstelle: " + correctWord[boolshOutput[-1][1]..boolshOutput[-1][2]])

      elsif(boolshOutput[4][0].eql?("wb")) then
        textualOutput.push("Wortbildungsprinzip verletzt. Lupenstelle: " + correctWord[boolshOutput[-1][1]..boolshOutput[-1][2]])

      else
        textualOutput.push("Peripheriebereich verletzt. Lupenstelle: " + correctWord[boolshOutput[-1][1]..boolshOutput[-1][2]])
      end
    end

    # Wenn der letzte Buchstabe in einer Lupenstelle verdoppelt wurde, dann ist diese Lupenstelle falsch!
    numOfInsert = 0
    numOfDelete = 0
    i = 0 # Laufindex
    # Es muss nur bis zur vorletzten Lupenstelle kontrolliert werden, wenn der letzte Buchstabe des Wortes verdoppelt wurde, wird die letzte Lupenstelle sowieso als falsch markiert.
    4.upto(boolshOutput.length - 2){
        |noOfLS|

      while(i <= boolshOutput[noOfLS][2] + numOfInsert)
        if(levenshteinSpur[i].eql?("i")) then
          numOfInsert += 1
        end
        if(levenshteinSpur[i].eql?("d")) then
          numOfDelete += 1
        end
        i += 1
      end

      # Ist die betroffene Lupenstelle nicht bereits als falsch markiert?
      if(boolshOutput[noOfLS][3]) then
        # Wurde nach einer Lupenstelle ein Buchstabe eingefügt oder ersetzt?
        if(levenshteinSpur[boolshOutput[noOfLS][2] + numOfInsert + 1].eql?("i") || levenshteinSpur[boolshOutput[noOfLS][2] + numOfInsert + 1].eql?("r")) then
          # Wurde der letzte Buchstabe der Lupenstelle verdoppelt, oder
          if((wordToTest[boolshOutput[noOfLS][2] + numOfInsert - numOfDelete].eql?(wordToTest[boolshOutput[noOfLS][2] + numOfInsert - numOfDelete + 1])) ||
              # wurde nach einem "i" ein "e" eingefügt, oder
              (wordToTest[boolshOutput[noOfLS][2] + numOfInsert - numOfDelete].eql?("i") & wordToTest[boolshOutput[noOfLS][2] + numOfInsert - numOfDelete + 1].eql?("e")) ||
              # wurde nach einem Vokal ein "h" eingefügt?
              (wordToTest[boolshOutput[noOfLS][2] + numOfInsert - numOfDelete].end_with?("a","e","i","o","u","ä","ö","ü") & wordToTest[boolshOutput[noOfLS][2] + numOfInsert - numOfDelete + 1].eql?("h"))) then

            boolshOutput[noOfLS][3] = false
            if(boolshOutput[noOfLS][0].eql?("ps")) then
              selectiveOutput(textualOutput, "Phonologisch-Silbisches Prinzip verletzt. Lupenstelle: " + correctWord[boolshOutput[noOfLS][1]..boolshOutput[noOfLS][2]])

            elsif(boolshOutput[noOfLS][0].eql?("m")) then
              selectiveOutput(textualOutput, "Morphologisches Prinzip verletzt. Lupenstelle: " + correctWord[boolshOutput[noOfLS][1]..boolshOutput[noOfLS][2]])

            elsif(boolshOutput[noOfLS][0].eql?("wb")) then
              selectiveOutput(textualOutput, "Wortbildungsprinzip verletzt. Lupenstelle: " + correctWord[boolshOutput[noOfLS][1]..boolshOutput[noOfLS][2]])

            else
              selectiveOutput(textualOutput, "Peripheriebereich verletzt. Lupenstelle: " + correctWord[boolshOutput[noOfLS][1]..boolshOutput[noOfLS][2]])
            end
          end
        end
      end
    }

    # Wenn ein s eingefügt wird, prüfe, ob die nachfolgenden Buchstaben im korrekten Wort 'ch' sind. Wenn ja werte die Lupenstelle, zu der das 'ch' gehört, als falsch.
    numOfInsert = 0
    numOfDelete = 0
    i = 0 # Laufindex
    4.upto(boolshOutput.length - 1){
        |noOfLS|

      while(i <= boolshOutput[noOfLS][1] + numOfInsert)
        if(levenshteinSpur[i].eql?("i")) then
          numOfInsert += 1
        end
        if(levenshteinSpur[i].eql?("d")) then
          numOfDelete += 1
        end
        i += 1
      end

      # Wenn die aktuelle Lupenstellenoch nicht falsch ist und mindestens 2 Zeichen enthält,
      if(boolshOutput[noOfLS][3] & ((boolshOutput[noOfLS][2] - boolshOutput[noOfLS][1]) >= 1)) then
        # davor ein Buchstabe eingefügt oder ersetzt wurde,
        if((levenshteinSpur[boolshOutput[noOfLS][1] - 1 + numOfInsert].eql?("i") || levenshteinSpur[boolshOutput[noOfLS][2] + numOfInsert + 1].eql?("r")) &
            # dieser Buchstabe ein 's' ist
            wordToTest[boolshOutput[noOfLS][1] - 1 + numOfInsert - numOfDelete].end_with?("s", "S") &
            # und darauf ein 'ch' folgt, dann ist die Lupenstelle mit dem 'ch' falsch.
            correctWord[boolshOutput[noOfLS][1]..(boolshOutput[noOfLS][1] + 1)].end_with?("ch", "Ch")) then

          boolshOutput[noOfLS][3] = false
          if(boolshOutput[noOfLS][0].eql?("ps")) then
            selectiveOutput(textualOutput, "Phonologisch-Silbisches Prinzip verletzt. Lupenstelle: " + correctWord[boolshOutput[noOfLS][1]..boolshOutput[noOfLS][2]])

          elsif(boolshOutput[noOfLS][0].eql?("m")) then
            selectiveOutput(textualOutput, "Morphologisches Prinzip verletzt. Lupenstelle: " + correctWord[boolshOutput[noOfLS][1]..boolshOutput[noOfLS][2]])

          elsif(boolshOutput[noOfLS][0].eql?("wb")) then
            selectiveOutput(textualOutput, "Wortbildungsprinzip verletzt. Lupenstelle: " + correctWord[boolshOutput[noOfLS][1]..boolshOutput[noOfLS][2]])

          else
            selectiveOutput(textualOutput, "Peripheriebereich verletzt. Lupenstelle: " + correctWord[boolshOutput[noOfLS][1]..boolshOutput[noOfLS][2]])
          end
        end
      end

      # Wenn ein s der letzte Buchstabe einer Lupenstelle ist, dann führt ein eingefügtes ch dazu, dass die Lupenstelle falsch ist.
      # Lupenstelle noch nicht falsch und nicht die letzte im Wort
      if(boolshOutput[noOfLS][3] & ((noOfLS + 1) < boolshOutput.length)) then
        # Die nächste Lupenstelle hat mindestens noch zwei Buchstaben
        if(((boolshOutput[noOfLS + 1][2] - boolshOutput[noOfLS + 1][1]) >= 1) &
            # Im Wort soll an letzter Stelle der Lupenstelle ein s stehen
            correctWord[boolshOutput[noOfLS][2]].end_with?("s", "S") &
            # Im falschen Wort steht an letzter Stelle der Lupenstelle ein s
            wordToTest[boolshOutput[noOfLS][2] + numOfInsert - numOfDelete].end_with?("s","S")) then
          # nach der Lupenstelle folgt ein ch
          if(wordToTest[(boolshOutput[noOfLS][2] + numOfInsert - numOfDelete + 1)..(boolshOutput[noOfLS][2] + numOfInsert - numOfDelete + 2)].eql?("ch") &
              # und dieses ist nicht ordnungsgemäß da (wobei es reicht zu prüfen, ob das c eingefügt/ersetzt wurde)
              (!levenshteinSpur[boolshOutput[noOfLS][2] + numOfInsert + 1].eql?("e"))) then
            boolshOutput[noOfLS][3] = false
            if(boolshOutput[noOfLS][0].eql?("ps")) then
              selectiveOutput(textualOutput, "Phonologisch-Silbisches Prinzip verletzt. Lupenstelle: " + correctWord[boolshOutput[noOfLS][1]..boolshOutput[noOfLS][2]])

            elsif(boolshOutput[noOfLS][0].eql?("m")) then
              selectiveOutput(textualOutput, "Morphologisches Prinzip verletzt. Lupenstelle: " + correctWord[boolshOutput[noOfLS][1]..boolshOutput[noOfLS][2]])

            elsif(boolshOutput[noOfLS][0].eql?("wb")) then
              selectiveOutput(textualOutput, "Wortbildungsprinzip verletzt. Lupenstelle: " + correctWord[boolshOutput[noOfLS][1]..boolshOutput[noOfLS][2]])

            else
              selectiveOutput(textualOutput, "Peripheriebereich verletzt. Lupenstelle: " + correctWord[boolshOutput[noOfLS][1]..boolshOutput[noOfLS][2]])
            end
          end
        end
      end
    }

    return textualOutput
  end

  # Diese Funktion prüft, ob durch das ersetzten eines Buchstaben der Buchstabe, mit dem ersetzt wurde, doppelt auftritt, und markiert die entsprechende Lupenstelle als falsch.
  def wrongDoubleLetterByReplacing(levenshteinSpur, levenshteinIndex, correctWord, wordToTest, boolshOutput, currLS)

    textualOutput = Array.new

    numOfInsert = 0
    numOfDelete = 0
    i = 0
    while(i <= currLS[0] + numOfInsert)
      if(levenshteinSpur[i].eql?("i")) then
        numOfInsert += 1
      end
      if(levenshteinSpur[i].eql?("d")) then
        numOfDelete += 1
      end
      i += 1
    end

    # Es ist nicht die letzte Lupenstelle im Wort
    if(!(currLS[1] == boolshOutput[-1][2])) then
      # Der nächste Buchstabe ist der richtige.
      if(levenshteinSpur[levenshteinIndex + 1].eql?("e")) then
        # Wenn der Buchstabe, mit dem ersetzt wurde, gleich dem nächsten Buchstaben ist, dann ist die folgende Lupenstelle falsch.
        if(wordToTest[currLS[1] + numOfInsert - numOfDelete].eql?(wordToTest[currLS[1] + numOfInsert - numOfDelete + 1])) then

          nextLSIndex = boolshOutput.find_index{ |ls| ls[2] == currLS[1]} + 1
          boolshOutput[nextLSIndex][3] = false
          if(boolshOutput[nextLSIndex][0].eql?("ps")) then
            textualOutput.push("Phonologisch-Silbisches Prinzip verletzt. Lupenstelle: " + correctWord[boolshOutput[nextLSIndex][1]..boolshOutput[nextLSIndex][2]])

          elsif(boolshOutput[nextLSIndex][0].eql?("m")) then
            textualOutput.push("Morphologisches Prinzip verletzt. Lupenstelle: " + correctWord[boolshOutput[nextLSIndex][1]..boolshOutput[nextLSIndex][2]])

          elsif(boolshOutput[nextLSIndex][0].eql?("wb")) then
            textualOutput.push("Wortbildungsprinzip verletzt. Lupenstelle: " + correctWord[boolshOutput[nextLSIndex][1]..boolshOutput[nextLSIndex][2]])

          else
            textualOutput.push("Peripheriebereich verletzt. Lupenstelle: " + correctWord[boolshOutput[nextLSIndex][1]..boolshOutput[nextLSIndex][2]])
          end
        end
      end
    end

    return textualOutput
  end

  # Diese Regel testet, ob nach einer Lupenstelle, die nur aus Vokal oder Diphtong besteht, ein h steht, der Vokal verdoppelt wurde oder nach einem i ein e steht.
  # Diese Buchstaben müssen entweder eingefügt worden sein, oder den eigentlichen Buchstaben an dieser Stelle ersetzten.
  def wrongVocalOrEnding(levenshteinSpur, wordListEntry, wordToTest, correctWord, boolshOutput)

    textualOutput = Array.new

    # Für jede Lupenstelle des Morphologischen Prinzips wird getestet, ob sie ganz korrekt ist. Wenn danach die Regeln 1, 3 oder 4 greifen wird sie dennoch als falsch gewertet.
    wordListEntry[M_PRINZIP].each{
        |lupenstelle|

      #Zählt die Anzahl der Einfüge- und Lösch-Operationen zur Navigation zwischen den Lupenstellen.
      numOfInsert = 0
      numOfDelete = 0
      i = 0 # Laufindex
      while(i <= lupenstelle[0] + numOfInsert)
        if(levenshteinSpur[i].eql?("i")) then
          numOfInsert += 1
        end
        if(levenshteinSpur[i].eql?("d")) then
          numOfDelete += 1
        end
        i += 1

      end

      # Handelt es sich bei einer Lupenstelle um einen Vokal oder Diphtong, dann führt Dehnung durch Dopplung oder "h" dazu,
      # dass die Lupenstelle als falsch gewertet wird. i kann auch durch e gedehnt werden.
      # max. ein Zeichen, welches ein Vokal ist?
      if((((lupenstelle[1] - lupenstelle[0] < 1) & correctWord[lupenstelle[0]..lupenstelle[1]].end_with?("a","e","i","o","u","ä","ö","ü")) ||
          # max. zwei Zeichen, welches Vokale sind?
          ((lupenstelle[1] - lupenstelle[0] < 2) & correctWord[lupenstelle[0]..lupenstelle[1]].end_with?("au","ai","ei","äu","eu","oi","ui"))) &
          # Wurde nach der Lupenstelle ein Buchstabe eingefügt oder ersetzt?
          (levenshteinSpur[lupenstelle[1] + numOfInsert + 1].eql?("i") || levenshteinSpur[lupenstelle[1] + numOfInsert + 1].eql?("r"))) then
        # Ist der nächste Buchstabe ein "h" oder der (letzte) Vokal nochmal?
        if((wordToTest[lupenstelle[1] + numOfInsert - numOfDelete + 1].end_with?("h", wordToTest[lupenstelle[1] + numOfInsert - numOfDelete])) ||
            # Handelt es sich um "ie" statt "i"?
            (wordToTest[lupenstelle[1] + numOfInsert - numOfDelete].eql?("i") & wordToTest[lupenstelle[1] + numOfInsert - numOfDelete + 1].eql?("e"))) then

          textualOutput.push("Nach der Lupenstelle " + correctWord[lupenstelle[0]..lupenstelle[1]] + " darf nicht durch \"" + wordToTest[lupenstelle[1] + numOfInsert - numOfDelete + 1] + "\" gedehnt werden!")
          selectiveOutput(boolshOutput, [lupenstelle[0], lupenstelle[1], false])
        end

      end

      # Flexionsendung t oder d -> Ende des Wortes & letzter Buchstabe d oder t & Buchstabe davor eingefügt? merke: lupenstelle[0] == lupenstelle[1]
      # Flextionsendung ist einzelstehend am Ende des Wortes markiert
      if((lupenstelle[0] == (correctWord.length - 1)) &
          # Sicherheitshalber prüfen, ob das Wort auf d oder t endet
          (correctWord.end_with?("d","t")) &
          (wordToTest.end_with?("dt","td")) &
          # Wurde vor oder hinter dem d oder t, das regulär am Ende des Wortes steht, der jeweils andere Buchstabe eingefügt?
          (levenshteinSpur[-2].eql?("i") ^ levenshteinSpur[-1].eql?("i"))) then

        textualOutput.push("Flexionsendung falsch mit <dt> oder <td>!")
        selectiveOutput(boolshOutput, [lupenstelle[0], lupenstelle[1], false])

      end
    }

    return textualOutput
  end

  # Diese Funktion fügt dem an erster Stelle übergebenen Array den an zweiter Stelle übergebenen String genau dann hinzu,
  # wenn dieser noch nicht im Array vorkommt.
  # Zurückgegeben wird das textualOutput-Array.
  def selectiveOutput(textualOutput, msgToPush)
    notInArray = true
    if(msgToPush.is_a?(String)) then
      textualOutput.each{
          |msg|
        if(msg.eql?(msgToPush)) then
          notInArray = false
        end
      }

      if(notInArray) then
        textualOutput.push(msgToPush)
      end
    else
      textualOutput.map{
          |lupenstelle|
        if((lupenstelle[1] == msgToPush[0]) & (lupenstelle[2] == msgToPush[1])) then
          lupenstelle[3] = false
        end
      }
    end
    return textualOutput
  end

  # Diese Funktion füllt das an erster Stelle übergebene Array mit der Art, dem Anfang und dem Ende jeder Lupenstelle des übergeben Wortlisteneintrag, fügt ein true an jede Lupenstelle an, um zu zeigen, dass diese (noch) korrekt ist und sortiert das ganze nach Lupenstellenposition.
  def fill(boolshOutput, wordListEntry)
    boolshOutput.push(["quantitative Korrektheit: ", -4])
    boolshOutput.push(["wortübergreifende Korrektheit: ", -3])
    boolshOutput.push(["Pluralform: ", -2])
    boolshOutput.push(["Komposition: ", -1])
    wordListEntry[PS_PRINZIP].each{
        |lupenstelle|
      boolshOutput.push(["ps", lupenstelle[0], lupenstelle[1], true])
    }

    wordListEntry[M_PRINZIP].each{
        |lupenstelle|
      boolshOutput.push(["m", lupenstelle[0], lupenstelle[1], true])
    }

    wordListEntry[WB_PRINZIP].each{
        |lupenstelle|
      boolshOutput.push(["wb", lupenstelle[0], lupenstelle[1], true])
    }

    wordListEntry[P_BEREICH].each{
        |lupenstelle|
      boolshOutput.push(["p", lupenstelle[0], lupenstelle[1], true])
    }

    boolshOutput.sort!{|x,y| x[1] <=> y[1]}

    return boolshOutput
  end


  #Diese Funktion nimmt ein korrekt geschriebenes Wort (Großschreibung beachten) und ein falsch
  #geschriebenes Wort, sucht den Wortlisteneintrag zum korrekten Wort heraus und ruft die
  #primarySearch damit auf.
  def primarySearchByWord(correctWord, wordToTest)
    wordList = getList
    cap = correctWord[0].eql?(upcase(correctWord[0]))
    index = wordList.find_index{
        |entry|
      downcase(entry[WORD]).eql?(downcase(correctWord)) & (entry[CAPITAL] == cap)
    }
    test= primarySearch(wordList[index], wordToTest)

    psError = 0
    psCount = wordList[index][PS_PRINZIP].size

    mpError = 0
    mpCount = wordList[index][M_PRINZIP].size

    wbError = 0
    wbCount = wordList[index][WB_PRINZIP].size

    pbError = 0
    pbCount = wordList[index][P_BEREICH].size

    for i in 4...test[1].size
      case test[1][i][0]
        when "ps"
          if(!test[1][i][3])
            psError +=1
          end
        when "m"
          if(!test[1][i][3])
            mpError +=1
          end
        when "wb"
          if(!test[1][i][3])
            wbError +=1
          end
        when "p"
          if(!test[1][i][3])
            pbError +=1
          end
        else
      end


    end
    errors_in_word = {"psError" => psError,"psCount" => psCount,"mpError" => mpError,"mpCount" => mpCount,"wbError" => wbError,"wbCount" => wbCount,"pbError" => pbError,"pbCount" => pbCount}
    return errors_in_word
  end


  #Diese Funktion nimmt das boolshOutput-Array und liefert einen String zurück, der aus 0en und 1en besteht, und zwar in folgender Reihenfolge:
  #Die erste Ziffer gibt die quantitative Korrektheit an.
  #Die nächsten Ziffern stellen die Korrektheit der Lupenstellen in Erscheinungsreihenfolge im Wort dar (also als erstes die erste LS usw.).
  #Wenn es eine Kompositions-Lupenstelle gibt, ist dies die vorletzte Ziffer.
  #Die letzte Ziffer gibt die wortübergreifende Korrektheit an.
  #Eine 1 bedeutet immer, dass die Korrektheit gegeben ist.
  def minimalStringOutput(boolshOutput)
    out = ""
    i = 4
    while i < boolshOutput.length
      if(boolshOutput[i][3]) then out = out + "1 " else out = out + "0 " end
      i += 1
    end

    if(boolshOutput[0][1]) then out = "1 " + out else out = "0 " + out end

    if(!boolshOutput[3][1].is_a?(NilClass)) then
      if(boolshOutput[3][1]) then out = out + "1 " else out = out + "0 " end
    end

    if(boolshOutput[1][1]) then out = out + "1" else out = out + "0" end

    return out
  end

  #Parts aus Jans CSVParser.rb:
  #Ein Eintrag in der Liste in Ruby hat folgende Form:
  #	- dem Wort als downcase String
  #	- ein Boolscher Wert, der angibt, ob das Wort groß geschrieben wird
  #	- ein Boolscher Wert, der angibt, ob das Wort eine Komposition enthält
  #	- eine Liste von 2-dimensionalen Arrays mit Anfang und Ende der Lupenstellen des Phonologisch-Silbisches Prinzip
  #	- eine Liste von 3-dimensionalen Arrays mit Anfang und Ende der Lupenstellen des Morphologischen Prinzips, sowie ein zugehöriger Boolscher Wert, der angibt, ob es sich bei der Lupenstelle um einen Wortstamm handelt
  #	- eine Liste von 3-dimensionalen Arrays mit Anfang und Ende der Lupenstellen des Wortbildungsprinzips, sowie ein zugehöriger Boolscher Wert, der angibt, ob es sich bei der Lupenstelle um einen Präfix handelt
  #	- eine Liste von 2-dimensionalen Arrays mit Anfang und Ende der Lupenstellen des Peripheriebereichs
  #	- eine Liste von downcase Strings mit den Pluralformen des Worts
  #
  #Beispiele:
  #Versteck,3-4,|,5-7,false,|,0-2,true,|,|,Verstecke -> [versteck, true, false, [[3,4]], [[5,7,false]], [[0,2,true]], [], [verstecke]]
  #Drehbrücke,4-9,|,0-3,true,|,|,|,Drehbrücken -> [drehbrücke, true, true, [[4,9]], [[0,3,true]], [], [], [drehbrücken]]
  #zuverlässig,5-10,|,|,0-1,true,2-4,true,|,| -> [zuverlässig, false, false, [[5,10]], [], [[0,1,true], [2,4,true]], []]

  # Macht aus einem String ein Boolean
  # wenn der übergebene Parameter "false" oder nil ist, wird false zurückgegeben, sonst true
  def to_b(objAsString)
    if(objAsString == nil) then return false
    elsif(downcase(objAsString).eql?("true")) then return true
    elsif(downcase(objAsString).eql?("false")) then return false
    else return true
    end
  end

  #Die folgenden Konstanten liefern die Positon der entsprechenden Werte in einem Wort-Eintrag.
  WORD = 0
  CAPITAL = 1
  COMPOSITION = 2
  PS_PRINZIP = 3
  M_PRINZIP = 4
  WB_PRINZIP = 5
  P_BEREICH = 6
  PLURAL = 7

  @@wordlist = [
      ["blume", false, false, [[0, 4]], [], [], [], ["blumen"]],
      ["baum", true, false, [], [[0, 3, false]], [], [], ["bäume"]],
      ["leine", true, false, [[0, 4]], [], [], [], ["leinen"]],
      ["teller", true, false, [[0, 5]], [], [], [], []],
      ["spülen", false, false, [[0, 1], [3, 5]], [[2, 2, false]], [], [], []],
      ["flug", true, false, [], [[0, 3, false]], [], [], ["flüge"]],
      ["zecke", true, false, [[0, 4]], [], [], [], []],
      ["truhe", true, false, [[0, 4]], [], [], [], []],
      ["stärken", false, false, [[0, 1], [3, 6]], [[2, 2, false]], [], [], []],
      ["backt", false, false, [], [[0, 4, false]], [], [], []],
      ["fliegen", false, false, [[0, 6]], [], [], [], []],
      ["versteck", true, false, [[3, 4]], [[5, 7, false]], [[0, 2, true]], [], ["verstecke"]],
      ["fließen", false, false, [[0, 6]], [], [], [], []],
      ["satz", true, false, [], [[0, 3, false]], [], [], []],
      ["über", false, false, [[0, 3]], [], [], [], []],
      ["tee", true, false, [], [], [], [[0, 2]], []],
      ["einer", false, false, [[0, 4]], [], [], [], []],
      ["geld", true, false, [], [[0, 3, false]], [], [], []],
      ["läuse", true, false, [[0, 0], [3, 4]], [[1, 2, false]], [], [], []],
      ["bissig", false, false, [[0, 3]], [], [[4, 5, false]], [], []],
      ["packt", false, false, [], [[0, 4, false]], [], [], []],
      ["geht", false, false, [], [[0, 3, false]], [], [], []],
      ["spüren", false, false, [[0, 1], [3, 5]], [[2, 2, false]], [], [], []],
      ["adventskranz", true, true, [[0, 5]], [[7, 11, false]], [[6, 6, false]], [], ["adventskränze"]],
      ["kilo", true, false, [[0, 3]], [], [], [], []],
      ["seht", false, false, [], [[0, 3, false]], [], [], []],
      ["fahne", true, false, [[0, 0], [3, 4]], [], [], [[1, 2]], ["fahnen"]],
      ["see", true, false, [], [], [], [[0, 2]], ["seen"]],
      ["platz", true, false, [], [[0, 4, false]], [], [], []],
      ["kino", true, false, [[0, 3]], [], [], [], ["kinos"]],
      ["moor", true, false, [], [], [], [[0, 3]], ["moore"]],
      ["sahne", true, false, [[0, 0], [4, 4]], [], [], [[1, 3]], []],
      ["kommt", false, false, [], [[0, 4, false]], [], [], []],
      ["keller", true, false, [[0, 5]], [], [], [], []],
      ["decke", true, false, [[0, 4]], [], [], [], []],
      ["stärke", true, false, [[0, 1], [3, 5]], [[2, 2, false]], [], [], []],
      ["strahl", true, false, [[0, 1]], [], [], [[2, 5]], []],
      ["sonnt", false, false, [], [[0, 4, false]], [], [], []],
      ["kräne", true, false, [[0, 1], [3, 4]], [[2, 2, false]], [], [], []],
      ["beine", true, false, [[0, 4]], [], [], [], []],
      ["mäuse", true, false, [[0, 0], [3, 4]], [[1, 2, false]], [], [], []],
      ["sieb", true, false, [], [[0, 3, false]], [], [], ["siebe"]],
      ["winzig", false, false, [[0, 3]], [], [[4, 5, false]], [], []],
      ["korb", true, false, [], [[0, 3, false]], [], [], ["körbe"]],
      ["weihnachtsbaum", true, true, [], [[4, 8, false], [10, 13, false]], [[9, 9, false]], [[0, 3]], []],
      ["video", true, false, [], [], [], [[0, 4]], []],
      ["nationalmannschaft", true, true, [[8, 17]], [], [], [[0, 7]], ["nationalmannschaften"]],
      ["meer", true, false, [], [], [], [[0, 3]], ["meere"]],
      ["bäche", true, false, [[0, 0], [2, 4]], [[1, 1, false]], [], [], []],
      ["strähne", true, false, [[0, 2], [5, 6]], [], [], [[3, 4]], []],
      ["dort", false, false, [], [], [], [[0, 3]], []],
      ["feld", true, false, [], [[0, 3, false]], [], [], []],
      ["verdeck", true, false, [], [[3, 6, false]], [[0, 2, true]], [], ["verdecke"]],
      ["sind", false, false, [], [], [], [[0, 3]], []],
      ["zug", true, false, [], [[0, 2, false]], [], [], []]
  ]

  def getList
    return @@wordlist
  end

  # Diese Funktion gibt den übergebenen String als downcase-Variante zurück.
  # Es werden auch Umlaute berücksichtigt!
  def downcase(aString)
    out = ""
    out = aString.downcase
    out.gsub!("Ä", "ä")
    out.gsub!("Ö", "ö")
    out.gsub!("Ü", "ü")
    return out
  end

  # Diese Funktion gibt den übergebenen String als upcase-Variante zurück.
  # Es werden auch Umlaute berücksichtigt!
  def upcase(aString)
    out = ""
    out = aString.upcase
    out.gsub!("ä", "Ä")
    out.gsub!("ö", "Ö")
    out.gsub!("ü", "Ü")
    return out
  end

  # Diese Funktion gibt den übergebenen String mit großem Anfangsbuchstaben und sonst kleinen Buchstaben zurück.
  # Es werden auch Umlaute berücksichtigt!
  def capitalize(aString)
    if(!aString.nil?)
      i = aString.length - 1
      return upcase(aString[0]) + downcase(aString[1..i])
    else
      return ""
    end
  end

  #Parts aus Jans Levenshtein_Distanz.rb:
  def berechneIterativDistanzVon(korrektesWort, falschesWort)
    # Wortlänge für die Matrix bestimmen
    m = korrektesWort.length # Anzahl Zeilen der Matrix
    n = falschesWort.length # Anzahl Spalten der Matrix

    korrektesWort = " " + korrektesWort
    falschesWort = " " + falschesWort

    # Matrix initialisieren
    @distanceMatrix = Array.new(n+1){ Array.new(m+1)}
    m.downto(0){|x| @distanceMatrix[0][x] = x}
    0.upto(n){|x| @distanceMatrix[x][0] = x}

    1.upto(n){
        |i| # Zeile
      1.upto(m){
          |j| # Spalte
        cost = 1
        if(korrektesWort[j] == falschesWort[i]) then cost = 0 end

        @distanceMatrix[i][j] = [@distanceMatrix[i-1][j-1] + cost, @distanceMatrix[i-1][j] + 1, @distanceMatrix[i][j-1] + 1].min
      }
    }
    lSpur = spur(n,m).lines(" ").map!{|x| x.delete " "}.delete_if{|x| x.empty?}

    return [@distanceMatrix[n][m], lSpur]

  end

  # Diese Funktion gibt die Schritte an, mit denen das erste Wort in das zweite umgewandelt wird.
  def spur(i, j)
    if ((i > 0) & (@distanceMatrix[i-1][j] + 1 == @distanceMatrix[i][j])) then
      return spur(i-1, j) + " i "
    elsif ((j > 0) & (@distanceMatrix[i][j-1] + 1 == @distanceMatrix[i][j])) then
      return spur(i, j-1) + " d "
    elsif ((i > 0) & (j > 0) & (@distanceMatrix[i-1][j-1] + 1 == @distanceMatrix[i][j])) then
      return spur(i-1, j-1) + " r "
    elsif ((i > 0) & (j > 0) & (@distanceMatrix[i-1][j-1] == @distanceMatrix[i][j])) then
      return spur(i-1, j-1) + " e "
    end
    return ""
  end


  def check_principles(correct_words, answers)
    result = {"psError" => 0,"psCount" => 0,"mpError" => 0,"mpCount" => 0,"wbError" => 0,"wbCount" =>0,"pbError" => 0,"pbCount" =>0}
    index = 0
    answers.each do |a|
      result_of_single_test = primarySearchByWord(correct_words[index],a)
      result["psError"] += result_of_single_test["psError"]
      result["psCount"] += result_of_single_test["psCount"]

      result["mpError"]  += result_of_single_test["mpError"]
      result["mpCount"]  += result_of_single_test["mpCount"]

      result["wbError"] += result_of_single_test["wbError"]
      result["wbCount"] += result_of_single_test["wbCount"]

      result["pbError"]  += result_of_single_test["pbError"]
      result["pbCount"]  += result_of_single_test["pbCount"]
      index += 1
    end
    return result
  end
end