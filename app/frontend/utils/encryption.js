import * as sjcl from 'sjcl'
import { useGlobalStore } from '../store/store'

//Entschlüsselt einen String mit dem im sessionStorage gespeicherten "Masterkey" und dem Key der Gruppe
// Falls die Entschlüsselung fehlschlägt, wird der Wert von alt zurückgegeben.
export const decryptStudentName = (text, alt, group) => {
  let res = ''

  const store = useGlobalStore()
  try {
    let tempkey = sjcl.decrypt(sessionStorage.getItem('mk'), store.shareKeys[group])
    res = sjcl.decrypt(tempkey, text)
  } catch (e) {
    res = alt
  }
  return res
}

// returns an array with the decrypted student names of the passed group
export const decryptStudentNames = group => {
  const g = group.students?.map(student => {
    return {
      ...student,
      name: decryptStudentName(student.name, `Kind_${student.id}`, group.id),
    }
  })

  return g
}

//Verschlüsselt einen String mit dem im sessionStorage gespeicherten "Masterkey" und dem Key der Gruppe.
export const encryptWithMasterKeyAndGroup = (text, groupId) => {
  const store = useGlobalStore()
  let tempkey = sjcl.decrypt(sessionStorage.getItem('mk'), store.shareKeys[groupId])
  return sjcl.encrypt(tempkey, text)
}

export const encryptWithKey = (text, key) => {
  return sjcl.encrypt(key, text)
}

export const decryptWithKey = (text, key) => {
  try {
    return sjcl.decrypt(key, text)
  } catch (e) {
    return ''
  }
}

//Entschlüsselt einen String mit dem im sessionStorage gespeicherten "Masterkey"
export const decryptKey = text => {
  if (!text) {
    return ''
  }
  let res = ''
  try {
    res = sjcl.decrypt(sessionStorage.getItem('mk'), text)
  } catch (e) {
    res = ''
  }
  return res
}

//Verschlüsselt einen String mit dem im sessionStorage gespeicherten "Masterkey".
export const encryptKey = text => {
  if (!text) {
    return null
  }
  return sjcl.encrypt(sessionStorage.getItem('mk'), text)
}

export const recodeKeys = (newPassword, oldPassword, shareKeys) => {
  if (!newPassword) {
    return { error: 'new password cannot be empty!' }
  }

  const oldPw = oldPassword || sessionStorage.getItem('mk')

  const newKeys = Object.entries(shareKeys).reduce((acc, k) => {
    if (k[1]) {
      acc[k[0]] = decryptWithKey(k[1], oldPw)
    }
    return acc
  }, {})

  // recode with new password
  return Object.entries(newKeys).reduce((acc, k) => {
    acc[k[0]] = encryptWithKey(k[1], newPassword)
    return acc
  }, {})
}
