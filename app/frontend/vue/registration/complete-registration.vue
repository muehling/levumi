<template>
  <div>
    <b-navbar toggleable="md" class="nav-pills main-navbar">
      <b-navbar-brand to="/">
        <img :src="'/images/shared/Levumi-normal_small.png'" alt="Levumi" height="48" />
        Levumi
      </b-navbar-brand>
    </b-navbar>
    <b-container>
      <div id="complete-registration" class="d-flex justify-content-center pt-4">
        <div class="col-lg-8 col-xl-6">
          <b-card title="Registrierung abschließen">
            <b-card title="Passwort festlegen" class="mt-4">
              <password-form
                :errors="errors"
                @change-password="pw => (password = pw)"
                @change-password-confirm="pw => (passwordConfirm = pw)"
                @change-security-answer="a => (securityAnswer = a)" />
            </b-card>
            <b-card
              v-if="accountType !== 2 && accountType !== 3"
              title="Helfen Sie uns bei der Forschung"
              class="mt-4">
              <extra-data-form
                :account-type="accountType"
                :focus-type="focusType || undefined"
                :school-type="schoolType || undefined"
                :institution="institution || undefined"
                @change-institution="inst => (institution = inst)"
                @change-town="t => (town = t)"
                @change-school-type="st => (schoolType = st)"
                @change-focus-type="ft => (focusType = ft)" />
            </b-card>
            <b-button
              class="mt-4"
              :disabled="!isSubmitEnabled"
              variant="outline-success"
              @click="submit">
              Fertig!
            </b-button>
          </b-card>
        </div>
      </div>
    </b-container>
  </div>
</template>

<script>
  import { ajax } from 'src/utils/ajax'
  import { encryptWithKey } from 'src/utils/encryption'
  import { useGlobalStore } from 'src/store/store'
  import apiRoutes from '../routes/api-routes'
  import ExtraDataForm from '../shared/forms/extra-data-form.vue'
  import PasswordForm from '../shared/forms/password-form.vue'
  export default {
    name: 'CompleteRegistration',
    components: { PasswordForm, ExtraDataForm },
    props: {
      accountType: Number,
    },
    setup() {
      const globalStore = useGlobalStore()
      return { globalStore }
    },
    data() {
      return {
        password: '',
        passwordConfirm: '',
        securityAnswer: '',
        errors: [],
        institution: '',
        town: '',
        schoolType: '',
        focusType: '',
      }
    },
    computed: {
      isSubmitEnabled() {
        return (
          this.password !== '' &&
          this.passwordConfirm !== '' &&
          this.password === this.passwordConfirm &&
          this.securityAnswer !== ''
        )
      },
    },

    methods: {
      async submit() {
        const key = Math.random()
          .toString(36)
          .replace(/[^a-z]+/g, '')
          .substring(0, 6)
        const masterkey = Math.random()
          .toString(36)
          .replace(/[^a-z]+/g, '')
          .substring(0, 6)

        const data = {
          user: {
            password: this.password,
            password_confirmation: this.passwordConfirm,
            security_digest: encryptWithKey(this.password, this.securityAnswer),
            masterkey: encryptWithKey(masterkey, this.password),
          },
          key: encryptWithKey(key, masterkey),
          auth_token: encryptWithKey(key, key),
        }
        switch (this.accountType) {
          case 0:
            data.user.town = this.town
            data.user.school_type = this.schoolType
            data.user.focus = this.focusType
            break
          case 1:
            data.user.institution = this.institution
            break
        }

        const res = await ajax({ url: apiRoutes.home.finishIntro, method: 'PATCH', data })
        // refetch global data, so the root app will know about the finished registration
        if (res.status === 200) {
          this.$emit('registration-complete')
          sessionStorage.setItem('mk', masterkey)
        }
      },
    },
  }
</script>
