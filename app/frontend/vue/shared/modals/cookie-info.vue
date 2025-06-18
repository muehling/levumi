<template>
  <BModal
    :model-value="store.generalModals.isCookieHintOpen"
    ok-only
    title="Cookie-Hinweis"
    @hidden="close">
    <h1 class="h1">Cookies</h1>
    <p>
      Levumi nutzt ein sog. Session-Cookie, das für den Betrieb der Plattform technisch notwendig
      ist. In diesem Cookie ist lediglich die Session-Id gespeichert. Diese wird benötigt, um den
      angemeldeten Benutzer zu identifizieren. Weitere Cookies werden nicht gesetzt.
    </p>
    <h1 class="h1">Session Storage</h1>

    Levumi legt für die Dauer der Nutzung einige Daten im Browser ab. Im einzelnen sind dies:
    <table class="cookie-table mt-4">
      <tbody>
        <tr>
          <td>ts</td>
          <td>
            <p>Zeitstempel des Website-Aufrufs. Dieser wird zur Abwehr von Spambots verwendet.</p>
          </td>
        </tr>
        <tr>
          <td>mk</td>
          <td>
            Willkürliche Zeichenfolge, die zum Ver-/Entschlüsseln der Schüler*innen-Namen verwendet
            wird. Datenbankseitig ist diese Zeichenfolge ebenfalls verschlüsselt; erst nach Eingabe
            des Nutzerpassworts wird diese entschlüsselt. Dadurch ist sichergestellt, dass außer dem
            angemeldeten Benutzer niemand Zugriff auf diese Daten hat.
          </td>
        </tr>
      </tbody>
    </table>
  </BModal>
</template>
<script>
  import { useGlobalStore } from 'src/store/store'
  import isEmpty from 'lodash/isEmpty'

  export default {
    name: 'ImprintModal',
    setup() {
      const store = useGlobalStore()
      return { store }
    },
    computed: {
      isLoggedIn() {
        return !isEmpty(this.store.login)
      },
    },

    methods: {
      close() {
        this.store.generalModals.isCookieHintOpen = false
      },
    },
  }
</script>
<style>
  h1.h1 {
    font-size: 1.3em;
  }
  tbody {
    vertical-align: top;
  }
  .cookie-table td {
    padding-right: 2em;
  }
</style>
