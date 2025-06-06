<template>
  <BModal
    :model-value="store.generalModals.isPrivacyOpen"
    scrollable
    ok-only
    size="xl"
    @hidden="close">
    <h3>Datenschutzerklärung</h3>
    <p class="text-justify">
      Levumi ist Teil einer langfristigen Forschungskooperation der beteiligten Arbeitsgruppen.
      <br />
      Wir nehmen den Datenschutz sehr ernst und möchten Ihnen hier erklären, wie und warum die Daten
      verarbeitet werden.
      <br />
      <br />
      Als Webseite wird Levumi auf einem Server an der CAU Kiel betrieben. Jedesmal wenn Sie oder
      ein Kind in einem Test die Seite aufrufen, speichert der Server einige Informationen: die
      IP-Adresse des Rechners der die Seite angefordert hat, einige Informationen über das System
      von dem die Anfrage kommt und auch den Zeitpunkt zu dem die Anfrage stattfand. Diese Daten
      werden als Teil der sogenanten "Logdateien" für einige Zeit aufbewahrt, wir werten diese Daten
      allerdings nicht aus sondern verwenden Sie nur z.B. zur Fehlersuche.
      <br />
      <br />
      Wenn Sie oder ein Kind sich anmelden, speichert die Webseite einen Cookie auf ihrem Rechner.
      Diese kleine Textdatei enthält eine zufällige Information, die dazu verwendet wird, Aufrufe
      die nach der Anmeldung von ihrem Rechner kommen auch ihrem Benutzer zuzuordnen. Wenn Sie sich
      abmelden oder Ihren Browser schließen, verliert der Cookie seine Gültigkeit - deswegen müssen
      Sie sich dann zunächst wieder anmelden wenn Sie das nächste Mal Levumi besuchen.
    </p>

    <h3>Welche Daten werden von mir als Nutzer*in gespeichert und warum?</h3>
    <p class="text-justify">
      Neben den gerade genannten, für den Betrieb von Levumi nötigen, Daten erheben wir bei der
      Registrierung ihre E-Mail Adresse sowie einige Informationen die wir für die statistische
      Auswertung der Nutzung verwenden. So können wir beispielsweise die Verbreitung in den
      Bundesländern oder auch die durchschnittliche Anzahl an Zugängen pro Schule ermitteln.
      <br />
      <br />
      Wir sind nicht daran interessiert, ihr Benutzerkonto mit ihrer Person in Verbindung zu
      bringen. Wenn Sie eine anonyme E-Mail Adresse verwenden, werden wir Sie im Allgemeinen nicht
      identifizieren können. Auch wenn Sie keine anonyme E-Mail Adresse verwenden, werden wir diese
      ausschließlich für den Zweck verwenden, Sie bei wichtigen Ereignissen zu kontaktieren.
      <strong>Wir werden keine regelmäßigen E-Mails an Sie schicken!</strong>
      <br />
      <br />
      Alle weiteren Daten sind solche, die Sie im Rahmen einer Testung erheben.
    </p>

    <h3>Wie werden die Daten der Kinder gespeichert und ausgewertet?</h3>
    <p class="text-justify">
      <strong>Die Daten der Kinder sind für uns vollständig anonym gespeichert!</strong>
      Die Namen, die Sie für die Kinder vergeben, werden noch innerhalb ihres Browsers
      verschlüsselt. Dazu wird das Passwort verwendet, mit dem Sie sich angemeldet haben. Es werden
      nur die verschlüsselten Daten an Levumi geschickt und dort gespeichert.
      <br />
      <br />
      Wir speichern ihr Passwort nicht als Klartext (sondern als sog. "Hash") und wir können ihr
      Passwort nicht aus den bei uns gespeicherten Daten rekonstruieren. Daher können wir auch die
      verschlüsselten Namen nicht entschlüsseln. Wenn Sie ihr Passwort vergessen, so können wir
      Ihnen ein neues Passwort zuweisen, dann sind allerdings auch die Namen der Kinder für Sie
      nicht mehr lesbar!
      <br />
      <br />
      Die Daten, die wir neben dem Namen erheben, sind nicht verschlüsselt und werden dafür
      verwendet die statistische Qualität der Tests auszuwerten und diese ggf. zu verbessern. Wir
      exportieren diese Daten regelmäßig für die wissenschaftliche Begleitforschung. In diesen
      Exporten finden sich keine persönlichen Daten von Ihnen!
    </p>

    <h3>Wie kann ich meine Daten löschen?</h3>
    <p class="text-justify">
      Sie können Ihren Zugang jederzeit löschen in dem Sie sich bei uns melden. In diesem Fall
      werden Ihre sämtlichen persönlichen Daten sofort gelöscht.
      <br />
      Sie können diese Aktion nicht rückgängig machen! Die Daten verbleiben noch einige Zeit in den
      Sicherungskopien, die wir regelmäßig von unserem Datenbestand anfertigen. Diese werden
      regelmäßig gelöscht bzw. ersetzt.
      <br />
      <br />
      Falls Sie Fragen zum Datenschutz in Levumi haben, wenden Sie sich bitte an Andreas Mühling
      (andreas.muehling@informatik.uni-kiel.de)!
    </p>

    <h2>Datenschutzerklärung gemäß DSGVO</h2>

    <h3>Name und Anschrift der Verantwortlichen</h3>
    Die Verantwortlichen im Sinne der Datenschutz-Grundverordnung und anderer nationaler
    Datenschutzgesetze der Mitgliedsstaaten sowie sonstiger datenschutzrechtlicher Bestimmungen
    sind:
    <br />
    <br />
    <table>
      <tbody>
        <tr>
          <td>Prof. Dr. Andreas Mühling</td>
          <td>und</td>
          <td>Prof. Dr. Markus Gebhardt</td>
        </tr>
        <tr>
          <td>
            <address>
              Christian-Albrechts-Universität zu Kiel
              <br />
              Christian-Albrechts-Platz 4
              <br />
              24118 Kiel
              <br />
              Deutschland
              <br />
              Tel.: +49 431-880-7508
              <br />
              E-Mail: andreas.muehling@informatik.uni-kiel.de
            </address>
          </td>
          <td style="padding: 3em"></td>
          <td>
            <address>
              Ludwig-Maximilians-Universität München
              <br />
              Leopoldstraße 13
              <br />
              80802 München
              <br />
              Deutschland
              <br />
              E-Mail: markus.gebhardt@lmu.de
            </address>
          </td>
        </tr>
      </tbody>
    </table>

    <h3>Name und Anschrift des Datenschutzbeauftragten der Verantwortlichen</h3>

    <address>
      Dr. Tim N. Höffler
      <br />
      Leibniz-Institut für die Pädagogik der
      <br />
      Naturwissenschaften und Mathematik (IPN)
      <br />
      Olshausenstraße 62
      <br />
      24118 Kiel
      <br />
      Deutschland
      <br />
      Tel.: +49 431-880-4834
      <br />
      E-Mail: datenschutz@leibniz-ipn.de
    </address>

    <h3>Allgemeines zur Datenverarbeitung</h3>

    <h4>Umfang der Verarbeitung personenbezogener Daten</h4>
    <p class="text-justify">
      Wir verarbeiten personenbezogene Daten unserer Nutzer grundsätzlich nur, soweit dies zur
      Bereitstellung einer funktionsfähigen Website sowie unserer Inhalte und Leistungen
      erforderlich ist. Die Verarbeitung personenbezogener Daten unserer Nutzer erfolgt regelmäßig
      nur nach Einwilligung des Nutzers. Eine Ausnahme gilt in solchen Fällen, in denen eine
      vorherige Einholung einer Einwilligung aus tatsächlichen Gründen nicht möglich ist und die
      Verarbeitung der Daten durch gesetzliche Vorschriften gestattet ist.
    </p>

    <h4>Rechtsgrundlage für die Verarbeitung personenbezogener Daten</h4>
    <p class="text-justify">
      Soweit wir für Verarbeitungsvorgänge personenbezogener Daten eine Einwilligung der betroffenen
      Person einholen, dient Art. 6 Abs. 1 lit. a EU-Datenschutzgrundverordnung (DSGVO) als
      Rechtsgrundlage. Bei der Verarbeitung von personenbezogenen Daten, die zur Erfüllung eines
      Vertrages, dessen Vertragspartei die betroffene Person ist, erforderlich ist, dient Art. 6
      Abs. 1 lit. b DSGVO als Rechtsgrundlage. Dies gilt auch für Verarbeitungsvorgänge, die zur
      Durchführung vorvertraglicher Maßnahmen erforderlich sind. Soweit eine Verarbeitung
      personenbezogener Daten zur Erfüllung einer rechtlichen Verpflichtung erforderlich ist, der
      unser Unternehmen unterliegt, dient Art. 6 Abs. 1 lit. c DSGVO als Rechtsgrundlage. Für den
      Fall, dass lebenswichtige Interessen der betroffenen Person oder einer anderen natürlichen
      Person eine Verarbeitung personenbezogener Daten erforderlich machen, dient Art. 6 Abs. 1 lit.
      d DSGVO als Rechtsgrundlage. Ist die Verarbeitung zur Wahrung eines berechtigten Interesses
      unseres Unternehmens oder eines Dritten erforderlich und überwiegen die Interessen,
      Grundrechte und Grundfreiheiten des Betroffenen das erstgenannte Interesse nicht, so dient
      Art. 6 Abs. 1 lit. f DSGVO als Rechtsgrundlage für die Verarbeitung.
    </p>

    <h4>Datenlöschung und Speicherdauer</h4>
    <p class="text-justify">
      Die personenbezogenen Daten der betroffenen Person werden gelöscht oder gesperrt, sobald der
      Zweck der Speicherung entfällt. Eine Speicherung kann darüber hinaus erfolgen, wenn dies durch
      den europäischen oder nationalen Gesetzgeber in unionsrechtlichen Verordnungen, Gesetzen oder
      sonstigen Vorschriften, denen der Verantwortliche unterliegt, vorgesehen wurde. Eine Sperrung
      oder Löschung der Daten erfolgt auch dann, wenn eine durch die genannten Normen
      vorgeschriebene Speicherfrist abläuft, es sei denn, dass eine Erforderlichkeit zur weiteren
      Speicherung der Daten für einen Vertragsabschluss oder eine Vertragserfüllung besteht.
    </p>

    <h3>Bereitstellung der Website und Erstellung von Logfiles</h3>

    <h4>Beschreibung und Umfang der Datenverarbeitung</h4>
    <p class="text-justify">
      Bei jedem Aufruf unserer Internetseite erfasst unser System automatisiert Daten und
      Informationen vom Computersystem des aufrufenden Rechners. Folgende Daten werden hierbei
      erhoben:
    </p>
    <ol>
      <li>Informationen über den Browsertyp und die verwendete Version</li>
      <li>Das Betriebssystem des Nutzers</li>
      <li>Die IP-Adresse des Nutzers</li>
      <li>Datum und Uhrzeit des Zugriffs</li>
    </ol>
    <p class="text-justify">
      Die Daten werden ebenfalls in den Logfiles unseres Systems gespeichert. Eine Speicherung
      dieser Daten zusammen mit anderen personenbezogenen Daten des Nutzers findet nicht statt.
    </p>

    <h4>Rechtsgrundlage für die Datenverarbeitung</h4>
    <p class="text-justify">
      Rechtsgrundlage für die vorübergehende Speicherung der Daten und der Logfiles ist Art. 6 Abs.
      1 lit. f DSGVO.
    </p>

    <h4>Zweck der Datenverarbeitung</h4>
    <p class="text-justify">
      Die vorübergehende Speicherung der IP-Adresse durch das System ist notwendig, um eine
      Auslieferung der Website an den Rechner des Nutzers zu ermöglichen. Hierfür muss die
      IP-Adresse des Nutzers für die Dauer der Sitzung gespeichert bleiben. Die Speicherung in
      Logfiles erfolgt, um die Funktionsfähigkeit der Website sicherzustellen. Zudem dienen uns die
      Daten zur Optimierung der Website und zur Sicherstellung der Sicherheit unserer
      informationstechnischen Systeme. Eine Auswertung der Daten zu Marketingzwecken findet in
      diesem Zusammenhang nicht statt. In diesen Zwecken liegt auch unser berechtigtes Interesse an
      der Datenverarbeitung nach Art. 6 Abs. 1 lit. f DSGVO.
    </p>

    <h4>Dauer der Speicherung</h4>
    <p class="text-justify">
      Die Daten werden gelöscht, sobald sie für die Erreichung des Zweckes ihrer Erhebung nicht mehr
      erforderlich sind. Im Falle der Erfassung der Daten zur Bereitstellung der Website ist dies
      der Fall, wenn die jeweilige Sitzung beendet ist. Im Falle der Speicherung der Daten in
      Logfiles ist dies nach spätestens sieben Tagen der Fall. Eine darüberhinausgehende Speicherung
      ist möglich. In diesem Fall werden die IP-Adressen der Nutzer gelöscht oder verfremdet, sodass
      eine Zuordnung des aufrufenden Clients nicht mehr möglich ist.
    </p>

    <h4>Widerspruchs- und Beseitigungsmöglichkeit</h4>
    <p class="text-justify">
      Die Erfassung der Daten zur Bereitstellung der Website und die Speicherung der Daten in
      Logfiles ist für den Betrieb der Internetseite zwingend erforderlich. Es besteht folglich
      seitens des Nutzers keine Widerspruchsmöglichkeit.
    </p>

    <h3>Verwendung von Cookies</h3>

    <h4>Beschreibung und Umfang der Datenverarbeitung</h4>
    <p class="text-justify">
      Unsere Webseite verwendet Cookies. Bei Cookies handelt es sich um Textdateien, die im
      Internetbrowser bzw. vom Internetbrowser auf dem Computersystem des Nutzers gespeichert
      werden. Ruft ein Nutzer eine Website auf, so kann ein Cookie auf dem Betriebssystem des
      Nutzers gespeichert werden. Dieser Cookie enthält eine charakteristische Zeichenfolge, die
      eine eindeutige Identifizierung des Browsers beim erneuten Aufrufen der Website ermöglicht.
      Wir setzen Cookies ein, um unsere Website nutzerfreundlicher zu gestalten. Einige Elemente
      unserer Internetseite erfordern es, dass der aufrufende Browser auch nach einem Seitenwechsel
      identifiziert werden kann. In den Cookies werden dabei folgende Daten gespeichert und
      übermittelt:
    </p>
    <ol>
      <li>Log-In-Informationen</li>
    </ol>

    <h4>Rechtsgrundlage für die Datenverarbeitung</h4>
    <p class="text-justify">
      Die Rechtsgrundlage für die Verarbeitung personenbezogener Daten unter Verwendung von Cookies
      ist Art. 6 Abs. 1 lit. f DSGVO.
    </p>

    <h4>Zweck der Datenverarbeitung</h4>
    <p class="text-justify">
      Der Zweck der Verwendung technisch notwendiger Cookies ist, die Nutzung von Websites für die
      Nutzer zu vereinfachen. Einige Funktionen unserer Internetseite können ohne den Einsatz von
      Cookies nicht angeboten werden. Für diese ist es erforderlich, dass der Browser auch nach
      einem Seitenwechsel wiedererkannt wird. Für folgende Anwendungen benötigen wir Cookies:
    </p>
    <ol>
      <li>Anmeldung im System überprüfen, um Zugang zu persönlichem Bereich zu ermöglichen</li>
    </ol>
    <p class="text-justify">
      Die durch technisch notwendige Cookies erhobenen Nutzerdaten werden nicht zur Erstellung von
      Nutzerprofilen verwendet. In diesen Zwecken liegt auch unser berechtigtes Interesse in der
      Verarbeitung der personenbezogenen Daten nach Art. 6 Abs. 1 lit. f DSGVO.
    </p>

    <h4>Dauer der Speicherung</h4>
    <p class="text-justify">
      Cookies werden auf dem Rechner des Nutzers gespeichert und von diesem an unserer Seite
      übermittelt. Daher haben Sie als Nutzer auch die volle Kontrolle über die Verwendung von
      Cookies. Durch eine Änderung der Einstellungen in Ihrem Internetbrowser können Sie die
      Übertragung von Cookies deaktivieren oder einschränken. Bereits gespeicherte Cookies können
      jederzeit gelöscht werden. Dies kann auch automatisiert erfolgen. Werden Cookies für unsere
      Website deaktiviert, können nicht mehr alle Funktionen der Website vollumfänglich genutzt
      werden.
    </p>

    <h4>Widerspruchs- und Beseitigungsmöglichkeit</h4>
    <p class="text-justify">
      Die Erfassung der Daten zur Bereitstellung der Website und die Speicherung der Daten in
      Logfiles ist für den Betrieb der Internetseite zwingend erforderlich. Es besteht folglich
      seitens des Nutzers keine Widerspruchsmöglichkeit.
    </p>

    <h3>Registrierung</h3>

    <h4>Beschreibung und Umfang der Datenverarbeitung</h4>
    <p class="text-justify">
      Auf unserer Internetseite bieten wir Nutzern die Möglichkeit, sich unter Angabe
      personenbezogener Daten zu registrieren. Die Daten werden dabei in eine Eingabemaske
      eingegeben und an uns übermittelt und gespeichert. Eine Weitergabe der Daten an Dritte findet
      nicht statt. Folgende Daten werden im Rahmen des Registrierungsprozesses erhoben:
    </p>
    <ol>
      <li>E-Mail Adresse</li>
      <li>Passwort</li>
      <li>Gewünschte Art des Zugangs (Lehrkraft, Wissenschaftler_in, Elternteil)</li>
      <li>Bundesland</li>
      <li>Schule oder Institution (außer für Zugang als Elternteil)</li>
      <li>Tätigkeitsschwerpunkt (nur für Zugang als Lehrkraft)</li>
    </ol>
    <p class="text-justify">
      Zum Zeitpunkt der Registrierung werden zudem folgende Daten gespeichert:
    </p>
    <ol>
      <li>Die IP-Adresse des Nutzers</li>
      <li>Datum und Uhrzeit der Registrierung</li>
    </ol>
    <p class="text-justify">
      Im Rahmen des Registrierungsprozesses wird eine Einwilligung des Nutzers zur Verarbeitung
      dieser Daten eingeholt.
    </p>

    <h4>Rechtsgrundlage für die Datenverarbeitung</h4>
    <p class="text-justify">
      Rechtsgrundlage für die Verarbeitung der Daten ist bei Vorliegen einer Einwilligung des
      Nutzers Art. 6 Abs. 1 lit. a DSGVO.
    </p>

    <h4>Zweck der Datenverarbeitung</h4>
    <p class="text-justify">
      Eine Registrierung des Nutzers ist für das Bereithalten bestimmter Inhalte und Leistungen auf
      unserer Website erforderlich. Das Anlegen eines Zugangs ermöglicht das Durchführen eigener
      längsschnittlicher Tests sowie die Speicherung der Testergebnisse auf der Seite. Die
      zusätzlich erhobenen Daten dienen der wissenschaftlichen Auswertung des Nutzungsverhaltens der
      Plattform.
    </p>

    <h4>Dauer der Speicherung</h4>
    <p class="text-justify">
      Die Daten werden gelöscht, sobald sie für die Erreichung des Zweckes ihrer Erhebung nicht mehr
      erforderlich sind. Dies ist für die während des Registrierungsvorgangs erhobenen Daten der
      Fall, wenn die Registrierung auf unserer Internetseite aufgehoben oder abgeändert wird.
    </p>

    <h4>Widerspruchs- und Beseitigungsmöglichkeit</h4>
    <p class="text-justify">
      Als Nutzer haben sie jederzeit die Möglichkeit, die Registrierung aufzulösen. Die über Sie
      gespeicherten Daten können Sie jederzeit abändern lassen.
    </p>

    <h3>Senden von Fehlerberichten</h3>
    <p class="text-justify">
      Wenn eine Anfrage von unserem Server aufgrund eines Fehlers nicht bearbeitet werden kann,
      besteht für den Nutzer die Möglichkeit, einen Fehlerbericht zu senden. Dieser enthält
      Informationen über die Art des Fehlers und die Anfrage, die den Fehler ausgelöst hat. Unter
      Umständen lässt sich aus diesen Daten ein Rückschluss auf den Account des sendenden Benutzers
      ziehen. Wir verwenden diese Daten jedoch ausschließlich zur Reproduktion und Behebung des
      Fehlers. Nach der Behebung des Fehlers werden diese Daten unmittelbar gelöscht.
    </p>

    <p></p>

    <h3>Rechte der betroffenen Person</h3>

    Werden personenbezogene Daten von Ihnen verarbeitet, sind Sie Betroffener i.S.d. DSGVO und es
    stehen Ihnen folgende Rechte gegenüber dem Verantwortlichen zu:

    <h4>Auskunftsrecht</h4>
    <p class="text-justify">
      Sie können von dem Verantwortlichen eine Bestätigung darüber verlangen, ob personenbezogene
      Daten, die Sie betreffen, von uns verarbeitet werden. Liegt eine solche Verarbeitung vor,
      können Sie von dem Verantwortlichen über folgende Informationen Auskunft verlangen:
    </p>
    <ol>
      <li>die Zwecke, zu denen die personenbezogenen Daten verarbeitet werden;</li>
      <li>die Kategorien von personenbezogenen Daten, welche verarbeitet werden;</li>
      <li>
        die Empfänger bzw. die Kategorien von Empfängern, gegenüber denen die Sie betreffenden
        personenbezogenen Daten offengelegt wurden oder noch offengelegt werden;
      </li>
      <li>
        die geplante Dauer der Speicherung der Sie betreffenden personenbezogenen Daten oder, falls
        konkrete Angaben hierzu nicht möglich sind, Kriterien für die Festlegung der Speicherdauer;
      </li>
      <li>
        das Bestehen eines Rechts auf Berichtigung oder Löschung der Sie betreffenden
        personenbezogenen Daten, eines Rechts auf Einschränkung der Verarbeitung durch den
        Verantwortlichen oder eines Widerspruchsrechts gegen diese Verarbeitung;
      </li>
      <li>das Bestehen eines Beschwerderechts bei einer Aufsichtsbehörde;</li>
      <li>
        alle verfügbaren Informationen über die Herkunft der Daten, wenn die personenbezogenen Daten
        nicht bei der betroffenen Person erhoben werden;
      </li>
      <li>
        das Bestehen einer automatisierten Entscheidungsfindung einschließlich Profiling gemäß Art.
        22 Abs. 1 und 4 DSGVO und – zumindest in diesen Fällen – aussagekräftige Informationen über
        die involvierte Logik sowie die Tragweite und die angestrebten Auswirkungen einer derartigen
        Verarbeitung für die betroffene Person.
      </li>
    </ol>
    <p class="text-justify">
      Ihnen steht das Recht zu, Auskunft darüber zu verlangen, ob die Sie betreffenden
      personenbezogenen Daten in ein Drittland oder an eine internationale Organisation übermittelt
      werden. In diesem Zusammenhang können Sie verlangen, über die geeigneten Garantien gem. Art.
      46 DSGVO im Zusammenhang mit der Übermittlung unterrichtet zu werden. Dieses Auskunftsrecht
      kann insoweit beschränkt werden, als es voraussichtlich die Verwirklichung der Forschungs-
      oder Statistikzwecke unmöglich macht oder ernsthaft beeinträchtigt und die Beschränkung für
      die Erfüllung der Forschungs- oder Statistikzwecke notwendig ist.
    </p>

    <h4>Recht auf Einschränkung der Verarbeitung</h4>
    <p class="text-justify">
      Unter den folgenden Voraussetzungen können Sie die Einschränkung der Verarbeitung der Sie
      betreffenden personenbezogenen Daten verlangen:
    </p>
    <ol>
      <li>
        wenn Sie die Richtigkeit der Sie betreffenden personenbezogenen für eine Dauer bestreiten,
        die es dem Verantwortlichen ermöglicht, die Richtigkeit der personenbezogenen Daten zu
        überprüfen;
      </li>
      <li>die Kategorien von personenbezogenen Daten, welche verarbeitet werden;</li>
      <li>
        die Verarbeitung unrechtmäßig ist und Sie die Löschung der personenbezogenen Daten ablehnen
        und stattdessen die Einschränkung der Nutzung der personenbezogenen Daten verlangen;
      </li>
      <li>
        der Verantwortliche die personenbezogenen Daten für die Zwecke der Verarbeitung nicht länger
        benötigt, Sie diese jedoch zur Geltendmachung, Ausübung oder Verteidigung von
        Rechtsansprüchen benötigen, oder
      </li>
      <li>
        wenn Sie Widerspruch gegen die Verarbeitung gemäß Art. 21 Abs. 1 DSGVO eingelegt haben und
        noch nicht feststeht, ob die berechtigten Gründe des Verantwortlichen gegenüber Ihren
        Gründen überwiegen.
      </li>
    </ol>
    <p class="text-justify">
      Wurde die Verarbeitung der Sie betreffenden personenbezogenen Daten eingeschränkt, dürfen
      diese Daten – von ihrer Speicherung abgesehen – nur mit Ihrer Einwilligung oder zur
      Geltendmachung, Ausübung oder Verteidigung von Rechtsansprüchen oder zum Schutz der Rechte
      einer anderen natürlichen oder juristischen Person oder aus Gründen eines wichtigen
      öffentlichen Interesses der Union oder eines Mitgliedstaats verarbeitet werden. Wurde die
      Einschränkung der Verarbeitung nach den o.g. Voraussetzungen eingeschränkt, werden Sie von dem
      Verantwortlichen unterrichtet bevor die Einschränkung aufgehoben wird. Ihr Recht auf
      Einschränkung der Verarbeitung kann insoweit beschränkt werden, als es voraussichtlich die
      Verwirklichung der Forschungs- oder Statistikzwecke unmöglich macht oder ernsthaft
      beeinträchtigt und die Beschränkung für die Erfüllung der Forschungs- oder Statistikzwecke
      notwendig ist.
    </p>

    <h4>Recht auf Löschung</h4>

    <strong>Löschungspflicht</strong>
    <p class="text-justify">
      Sie können von dem Verantwortlichen verlangen, dass die Sie betreffenden personenbezogenen
      Daten unverzüglich gelöscht werden, und der Verantwortliche ist verpflichtet, diese Daten
      unverzüglich zu löschen, sofern einer der folgenden Gründe zutrifft:
    </p>
    <ol>
      <li>
        Die Sie betreffenden personenbezogenen Daten sind für die Zwecke, für die sie erhoben oder
        auf sonstige Weise verarbeitet wurden, nicht mehr notwendig.
      </li>
      <li>
        Sie widerrufen Ihre Einwilligung, auf die sich die Verarbeitung gem. Art. 6 Abs. 1 lit. a
        oder Art. 9 Abs. 2 lit. a DSGVO stützte, und es fehlt an einer anderweitigen Rechtsgrundlage
        für die Verarbeitung.
      </li>
      <li>
        Sie legen gem. Art. 21 Abs. 1 DSGVO Widerspruch gegen die Verarbeitung ein und es liegen
        keine vorrangigen berechtigten Gründe für die Verarbeitung vor, oder Sie legen gem. Art. 21
        Abs. 2 DSGVO Widerspruch gegen die Verarbeitung ein.
      </li>
      <li>Die Sie betreffenden personenbezogenen Daten wurden unrechtmäßig verarbeitet.</li>
      <li>
        Die Löschung der Sie betreffenden personenbezogenen Daten ist zur Erfüllung einer
        rechtlichen Verpflichtung nach dem Unionsrecht oder dem Recht der Mitgliedstaaten
        erforderlich, dem der Verantwortliche unterliegt.
      </li>
      <li>
        Die Sie betreffenden personenbezogenen Daten wurden in Bezug auf angebotene Dienste der
        Informationsgesellschaft gemäß Art. 8 Abs. 1 DSGVO erhoben.
      </li>
    </ol>

    <strong>Information an Dritte</strong>
    <p class="text-justify">
      Hat der Verantwortliche die Sie betreffenden personenbezogenen Daten öffentlich gemacht und
      ist er gem. Art. 17 Abs. 1 DSGVO zu deren Löschung verpflichtet, so trifft er unter
      Berücksichtigung der verfügbaren Technologie und der Implementierungskosten angemessene
      Maßnahmen, auch technischer Art, um für die Datenverarbeitung Verantwortliche, die die
      personenbezogenen Daten verarbeiten, darüber zu informieren, dass Sie als betroffene Person
      von ihnen die Löschung aller Links zu diesen personenbezogenen Daten oder von Kopien oder
      Replikationen dieser personenbezogenen Daten verlangt haben.
    </p>

    <strong>Ausnahmen</strong>
    <p class="text-justify">
      Das Recht auf Löschung besteht nicht, soweit die Verarbeitung erforderlich ist
    </p>
    <ol>
      <li>zur Ausübung des Rechts auf freie Meinungsäußerung und Information;</li>
      <li>
        zur Erfüllung einer rechtlichen Verpflichtung, die die Verarbeitung nach dem Recht der Union
        oder der Mitgliedstaaten, dem der Verantwortliche unterliegt, erfordert, oder zur
        Wahrnehmung einer Aufgabe, die im öffentlichen Interesse liegt oder in Ausübung öffentlicher
        Gewalt erfolgt, die dem Verantwortlichen übertragen wurde;
      </li>
      <li>
        aus Gründen des öffentlichen Interesses im Bereich der öffentlichen Gesundheit gemäß Art. 9
        Abs. 2 lit. h und i sowie Art. 9 Abs. 3 DSGVO;
      </li>
      <li>
        für im öffentlichen Interesse liegende Archivzwecke, wissenschaftliche oder historische
        Forschungszwecke oder für statistische Zwecke gem. Art. 89 Abs. 1 DSGVO, soweit das unter
        Abschnitt a) genannte Recht voraussichtlich die Verwirklichung der Ziele dieser Verarbeitung
        unmöglich macht oder ernsthaft beeinträchtigt, oder
      </li>
      <li>zur Geltendmachung, Ausübung oder Verteidigung von Rechtsansprüchen.</li>
    </ol>

    <h4>Recht auf Unterrichtung</h4>
    <p class="text-justify">
      Haben Sie das Recht auf Berichtigung, Löschung oder Einschränkung der Verarbeitung gegenüber
      dem Verantwortlichen geltend gemacht, ist dieser verpflichtet, allen Empfängern, denen die Sie
      betreffenden personenbezogenen Daten offengelegt wurden, diese Berichtigung oder Löschung der
      Daten oder Einschränkung der Verarbeitung mitzuteilen, es sei denn, dies erweist sich als
      unmöglich oder ist mit einem unverhältnismäßigen Aufwand verbunden. Ihnen steht gegenüber dem
      Verantwortlichen das Recht zu, über diese Empfänger unterrichtet zu werden.
    </p>

    <h4>Recht auf Datenübertragbarkeit</h4>
    <p class="text-justify">
      Sie haben das Recht, die Sie betreffenden personenbezogenen Daten, die Sie dem
      Verantwortlichen bereitgestellt haben, in einem strukturierten, gängigen und maschinenlesbaren
      Format zu erhalten. Außerdem haben Sie das Recht diese Daten einem anderen Verantwortlichen
      ohne Behinderung durch den Verantwortlichen, dem die personenbezogenen Daten bereitgestellt
      wurden, zu übermitteln, sofern
    </p>
    <ol>
      <li>
        die Verarbeitung auf einer Einwilligung gem. Art. 6 Abs. 1 lit. a DSGVO oder Art. 9 Abs. 2
        lit. a DSGVO oder auf einem Vertrag gem. Art. 6 Abs. 1 lit. b DSGVO beruht und
      </li>
      <li>die Verarbeitung mithilfe automatisierter Verfahren erfolgt.</li>
    </ol>
    <p class="text-justify">
      In Ausübung dieses Rechts haben Sie ferner das Recht, zu erwirken, dass die Sie betreffenden
      personenbezogenen Daten direkt von einem Verantwortlichen einem anderen Verantwortlichen
      übermittelt werden, soweit dies technisch machbar ist. Freiheiten und Rechte anderer Personen
      dürfen hierdurch nicht beeinträchtigt werden. Das Recht auf Datenübertragbarkeit gilt nicht
      für eine Verarbeitung personenbezogener Daten, die für die Wahrnehmung einer Aufgabe
      erforderlich ist, die im öffentlichen Interesse liegt oder in Ausübung öffentlicher Gewalt
      erfolgt, die dem Verantwortlichen übertragen wurde.
    </p>

    <h4>Widerspruchsrecht</h4>
    <p class="text-justify">
      Sie haben das Recht, aus Gründen, die sich aus ihrer besonderen Situation ergeben, jederzeit
      gegen die Verarbeitung der Sie betreffenden personenbezogenen Daten, die aufgrund von Art. 6
      Abs. 1 lit. e oder f DSGVO erfolgt, Widerspruch einzulegen; dies gilt auch für ein auf diese
      Bestimmungen gestütztes Profiling. Der Verantwortliche verarbeitet die Sie betreffenden
      personenbezogenen Daten nicht mehr, es sei denn, er kann zwingende schutzwürdige Gründe für
      die Verarbeitung nachweisen, die Ihre Interessen, Rechte und Freiheiten überwiegen, oder die
      Verarbeitung dient der Geltendmachung, Ausübung oder Verteidigung von Rechtsansprüchen. Werden
      die Sie betreffenden personenbezogenen Daten verarbeitet, um Direktwerbung zu betreiben, haben
      Sie das Recht, jederzeit Widerspruch gegen die Verarbeitung der Sie betreffenden
      personenbezogenen Daten zum Zwecke derartiger Werbung einzulegen; dies gilt auch für das
      Profiling, soweit es mit solcher Direktwerbung in Verbindung steht. Widersprechen Sie der
      Verarbeitung für Zwecke der Direktwerbung, so werden die Sie betreffenden personenbezogenen
      Daten nicht mehr für diese Zwecke verarbeitet.
      <br />
      <br />
      Sie haben die Möglichkeit, im Zusammenhang mit der Nutzung von Diensten der
      Informationsgesellschaft – ungeachtet der Richtlinie 2002/58/EG – Ihr Widerspruchsrecht
      mittels automatisierter Verfahren auszuüben, bei denen technische Spezifikationen verwendet
      werden. Sie haben auch das Recht, aus Gründen, die sich aus Ihrer besonderen Situation
      ergeben, bei der Verarbeitung Sie betreffender personenbezogener Daten, die zu
      wissenschaftlichen oder historischen Forschungszwecken oder zu statistischen Zwecken gem. Art.
      89 Abs. 1 DSGVO erfolgt, dieser zu widersprechen. Ihr Widerspruchsrecht kann insoweit
      beschränkt werden, als es voraussichtlich die Verwirklichung der Forschungs- oder
      Statistikzwecke unmöglich macht oder ernsthaft beeinträchtigt und die Beschränkung für die
      Erfüllung der Forschungs- oder Statistikzwecke notwendig ist.
    </p>

    <h4>Recht auf Widerruf der datenschutzrechtlichen Einwilligungserklärung</h4>
    <p class="text-justify">
      Sie haben das Recht, Ihre datenschutzrechtliche Einwilligungserklärung jederzeit zu
      widerrufen. Durch den Widerruf der Einwilligung wird die Rechtmäßigkeit der aufgrund der
      Einwilligung bis zum Widerruf erfolgten Verarbeitung nicht berührt.
    </p>

    <h4>Recht auf Beschwerde bei einer Aufsichtsbehörde</h4>
    <p class="text-justify">
      Unbeschadet eines anderweitigen verwaltungsrechtlichen oder gerichtlichen Rechtsbehelfs steht
      Ihnen das Recht auf Beschwerde bei einer Aufsichtsbehörde, insbesondere in dem Mitgliedstaat
      ihres Aufenthaltsorts, ihres Arbeitsplatzes oder des Orts des mutmaßlichen Verstoßes, zu, wenn
      Sie der Ansicht sind, dass die Verarbeitung der Sie betreffenden personenbezogenen Daten gegen
      die DSGVO verstößt. Die Aufsichtsbehörde, bei der die Beschwerde eingereicht wurde,
      unterrichtet den Beschwerdeführer über den Stand und die Ergebnisse der Beschwerde
      einschließlich der Möglichkeit eines gerichtlichen Rechtsbehelfs nach Art. 78 DSGVO.
    </p>
  </BModal>
</template>
<script>
  import { useGlobalStore } from 'src/store/store'

  export default {
    name: 'ImprintModal',
    setup() {
      const store = useGlobalStore()
      return { store }
    },

    methods: {
      close() {
        this.store.generalModals.isPrivacyOpen = false
      },
    },
  }
</script>
