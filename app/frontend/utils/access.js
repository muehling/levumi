import { useGlobalStore } from 'src/store/store'
import { isSingleUser } from './user'

export const access = (groupShare = {}) => {
  const gs = useGlobalStore()

  if (gs.login.is_masquerading) {
    return { general: { decryptNames: false }, classbook: {}, diagnostics: {} }
  }

  let decryptNames = true

  let createGroup = !isSingleUser()
  let updateGroup = !groupShare.read_only
  let archiveGroup = groupShare.owner && !isSingleUser()
  let createQRCodes = !groupShare.is_anonymous && !groupShare.read_only
  let setGroupFontSettings = !groupShare.read_only

  let createStudents = !groupShare.read_only
  let updateStudents = !groupShare.read_only
  let deleteStudents = !groupShare.read_only
  let moveStudents = groupShare.owner && !isSingleUser()
  let createShare = groupShare.owner && !isSingleUser()
  let canAccessClassbook =
    createGroup ||
    updateGroup ||
    archiveGroup ||
    createQRCodes ||
    setGroupFontSettings ||
    createStudents ||
    updateStudents ||
    deleteStudents ||
    moveStudents ||
    createShare

  let createResults = !groupShare.read_only
  let deleteResults = !groupShare.read_only

  let createAssessments = !groupShare.read_only
  let updateAssessments = !groupShare.read_only
  let deleteAssessments = groupShare.owner
  let canAccessDiagnostics =
    createResults || deleteResults || createAssessments || updateAssessments || deleteAssessments

  return {
    general: { decryptNames },
    ...(canAccessClassbook && {
      classbook: {
        createGroup,
        updateGroup,
        archiveGroup,
        createQRCodes,
        setGroupFontSettings,
        createStudents,
        updateStudents,
        deleteStudents,
        moveStudents,
        createShare,
      },
    }),
    ...(canAccessDiagnostics && {
      diagnostics: {
        createResults,
        deleteResults,
        createAssessments,
        updateAssessments,
        deleteAssessments,
      },
    }),
  }
}
