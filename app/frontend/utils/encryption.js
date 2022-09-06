import * as sjcl from 'sjcl'

//Entschlüsselt einen String mit dem im sessionStorage gespeicherten "Masterkey" und dem Key der Gruppe
// Falls die Entschlüsselung fehlschlägt, wird der Wert von alt zurückgegeben.
export const decryptStudentName = (text, alt, group, keys) => {
  let res = ''
  try {
    let tempkey = sjcl.decrypt(sessionStorage.getItem('login'), keys[group])
    res = sjcl.decrypt(tempkey, text)
  } catch (e) {
    console.error(e.toString())
    console.log('Entschlüsselung fehlgeschlagen') //Log-Output (evtl. nicht in Production?)
    res = alt
  }
  return res
}

//Verschlüsselt einen String mit dem im sessionStorage gespeicherten "Masterkey" und dem Key der Gruppe.
export const encryptWithMasterKeyAndGroup = (text, group, keys) => {
  let tempkey = sjcl.decrypt(sessionStorage.getItem('login'), keys[group])
  return sjcl.encrypt(tempkey, text)
}

export const encryptWithKey = (text, key) => {
  return sjcl.encrypt(key, text)
}

export const decryptWithKey = (text, key) => {
  try {
    return sjcl.decrypt(key, text)
  } catch (e) {
    console.error('decryptWithKey::', e)
  }
}

//Entschlüsselt einen String mit dem im sessionStorage gespeicherten "Masterkey"
export const decryptKey = text => {
  if (!text) {
    return ''
  }
  let res = ''
  try {
    res = sjcl.decrypt(sessionStorage.getItem('login'), text)
  } catch (e) {
    console.error(e.toString())
    console.log('Entschlüsselung fehlgeschlagen') //Log-Output (evtl. nicht in Production?)
    res = ''
  }
  return res
}

//Verschlüsselt einen String mit dem im sessionStorage gespeicherten "Masterkey".
export const encryptKey = text => {
  if (!text) {
    return null
  }
  return sjcl.encrypt(text, sessionStorage.getItem('login'))
}

export const recodeKeys = (new_password, keys) => {
  // decrypt keys with current password
  const newKeys = Object.entries(keys).map(k => ({ id: k[0], key: decryptKey(k[1]) }))

  // update login data
  sessionStorage['old_login'] = sessionStorage['login']
  sessionStorage['login'] = new_password

  // recode with new password, update in global namespace
  keys = Object.entries(newKeys).map(k => ({ id: k[0], key: encryptKey(k[1]) }))
}
