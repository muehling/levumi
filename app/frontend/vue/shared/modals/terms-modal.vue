<template>
  <BModal
    :model-value="store.generalModals.isTermsOpen"
    scrollable
    ok-only
    size="xl"
    @hidden="close">
    <h3>Nutzungsbedingungen</h3>
    <p class="text-justify">
      Vielen Dank, dass Sie Levumi nutzen möchten. Levumi wird in Kooperation zweier Arbeitsgruppen
      der CAU Kiel und der LMU München betrieben, der Dienst wird auf Servern der CAU Kiel
      bereitgestellt. Die Nutzung von Levumi setzt voraus, dass Sie unseren hier dargestellten
      Nutzungsbedingungen zustimmen. Bitte lesen Sie diese sorgfältig durch.
    </p>
    <h4>Registrierung und Verwendung Ihrer Daten</h4>
    <p class="text-justify">
      Wir bieten Levumi unentgeltlich für Schulen und Lehrkräfte, Forscher:innen und Privatpersonen
      an. Für jede dieser Nutzungsarten ist eine Registrierung erforderlich, für die Sie neben der
      gewünschten Nutzungsart eine gültige E-Mail Adresse, ein Passwort sowie ihr Bundesland angeben
      müssen. Weitere Angaben sind optional. Wir speichern Ihre Angaben und werten Sie im Rahmen von
      wissenschaftlichen Studien anonymisiert aus. Nach erfolgter Registrierung erhalten Sie ein
      Passwort zugeschickt, mit dem Sie sich in Levumi anmelden können. Sie können dieses Passwort
      jederzeit ändern, wir speichern Passwörter ausschließlich verschlüsselt ab und können, wenn
      Sie es verändert haben, nicht darauf zugreifen. Wir verwenden Ihre E-Mail Adresse außerdem um
      Sie - ausschließlich in dringenden Fällen - kontaktieren zu können, etwa bei technischen
      Problemen.
    </p>
    <h4>Anlegen von Testpersonen und Verwendung der Daten</h4>
    <p class="text-justify">
      Um Levumi verwenden zu können, müssen Sie nach der Registrierung Testpersonen (z.B. die
      Schüler:innen Ihrer Klasse) anlegen, mit denen Sie arbeiten. Für jede Testperson müssen Sie
      einen Namen vergeben. Alle weiteren Angaben sind optional, helfen uns aber bei der
      wissenschaftlichen Auswertung und darauf aufbauenden Verbesserung von Levumi. Der Name, den
      Sie für eine Testperson vergeben wird bereits verschlüsselt an Levumi gesendet und dort
      ausschließlich verschlüsselt gespeichert. Die Daten der Testpersonen sind für die
      Seitenbetreiber also anonymisiert und können keiner realen Person zugeordnet werden,
      unabhängig davon, ob Sie einen realen Namen oder ein Pseudonym eingeben. Sie sind dafür
      verantwortlich, das Einverständnis der von Ihnen angelegten Testpersonen bzw. deren
      gesetzlicher Vertreter*innen in geeigneter Form einzuholen. Wir stellen in Levumi eine
      Einverständniserklärung zur Verfügung, die Sie als Grundlage verwenden können.
    </p>
    <h4>Durchführen von Tests</h4>
    <p class="text-justify">
      Testdaten werden mit den in Levumi vorhandenen Tests durch Sie erhoben. Die Testungen
      innerhalb von Levumi sind immer an eine Testperson gekoppelt. Wir verwenden diese mit Levumi
      erhobenen Testdaten für die wissenschaftliche Begleitforschung und zur Verbesserung von
      Levumi. Wenn die Begleitforschung für einen bestimmten Datensatz abgeschlossen ist, wird
      dieser noch für einige Zeit in einem Archiv vorgehalten. Wenn Sie eine Registrierung als
      Lehrkraft vorgenommen haben, finden Sie eine Beispielklasse vor. Testpersonen in dieser Klasse
      werden nicht von uns ausgewertet und können von Ihnen zum Ausprobieren von Tests verwendet
      werden. Wir bitten Sie, diese Klasse nur für diesen Zweck zu verwenden und alle Daten von
      realen Testpersonen nur in von Ihnen selbst angelegten Klassen zu erheben.
    </p>
    <h4>Anmerkungen</h4>
    <p class="text-justify">
      Wenn Sie in Levumi in einer Klasse Anmerkungen anlegen, so können diese auch von den Personen
      gelesen werden, mit denen Sie diese Klasse geteilt haben. Wir werten die Anmerkungen im Rahmen
      der wissenschaftlichen Begleitforschung aus. Wenn Sie in einer Anmerkung den Namen eines
      Kindes oder ein Teil des Namens (z.B. 'Eva' anstelle 'Eva Müller') verwenden, so werden Diese
      vor dem Senden an Levumi verschlüsselt. Wir bitten Sie, in Anmerkungen keine Variationen der
      im Klassenbuch verwendeten Namen (z.B. 'Evi' anstell von 'Eva') zu verwenden, da diese nicht
      automatisch erkannt und verschlüsselt werden können.
    </p>
    <h4>Urheberrechte</h4>
    <p class="text-justify">
      Die in Levumi zur Verfügung gestellten Tests und Fördermaterialien sind alle unter einer
      "Creative Common" Lizenz veröffentlicht. Die Tests können Sie außerhalb von Levumi unter
      Nennung der Urheber weiterverwenden und abändern. Die entsprechende Quellenangabe finden Sie
      in Levumi als Teil der Testbeschreibung. Die Fördermaterialien können Sie ohne Einschränkung
      und ohne Angabe der Urheber weiterverwenden und abändern.
    </p>
    <h4>Datenlöschung</h4>
    <p class="text-justify">
      Sie können Ihren Zugang zu Levumi jederzeit löschen, dazu kontaktieren Sie uns bitte per
      E-Mail (info@levumi.de). Mit der Löschung entfernen wir Ihre persönlichen Daten aus unserer
      Datenbank. Die von Ihnen erhobenen Testdaten werden zu diesem Zeitpunkt durch Entfernung des
      Namens vollständig anonymisiert. Sie können auch jederzeit direkt in Levumi die von Ihnen
      angelegten Testpersonen, Klassen oder einzelne Testdaten löschen. Diese werden dann nach den
      gleichen Grundsätzen anonymisiert.
    </p>
    <h4>Änderung der Nutzungsbedingungen</h4>
    <p class="text-justify">
      Die Nutzungsbedingungen können sich in der Zukuft ändern, etwa um neuen rechtlichen
      Rahmenbedingungen gerecht werden zu können oder aufgrund von Änderungen an Levumi. In diesem
      Fall werden wir Sie bei Ihrer nächsten Anmeldung informieren und Ihnen die geänderten
      Nutzungsbedingungen erneut zur Zustimmung vorlegen.
    </p>
    <hr />
  </BModal>
</template>
<script>
  import { useGlobalStore } from 'src/store/store'

  export default {
    name: 'TermsModal',
    setup() {
      const store = useGlobalStore()
      return { store }
    },

    methods: {
      close() {
        this.store.generalModals.isTermsOpen = false
      },
    },
  }
</script>
