import axios from 'axios'
import { useGlobalStore } from '../store/store'

const axiosInstance = axios.create()

axiosInstance.interceptors.response.use(
  response => {
    return response
  },
  error => {
    // these can result from invalid credentials
    if (error.config.url === '/login' || error.config.url === '/renew_login') {
      return error.response
    }
    if (error.response.status === 403) {
      return error.response
    }

    // any error that returns a message is not unexpected and should be handled by the frontend
    if (error.response.data?.message) {
      return error.response
    }

    // display everything else with the possibility to send a report
    const store = useGlobalStore()
    store.serverError = {
      status: error.response.status,
      url: error.config.url,
      data: error.config.data,
      method: error.config.method,
      contentType: error.config.headers['Content-Type'],
    }
    return error.response
  }
)

export const ajax = async ({
  url,
  method = 'GET',
  data = {},
  contentType = 'application/json',
  accept = 'application/json',
}) => {
  const request = {
    url,
    headers: {
      'X-Requested-With': 'XMLHttpRequest',
      'X-CSRF-Token': getCSRFToken(),
      ...(contentType !== 'omit' && { 'Content-Type': contentType }),
      Accept: accept,
    },
    withCredentials: true,
    method: method,
  }
  if (data) {
    request.data = contentType === 'application/json' ? JSON.stringify(data) : data
  } else {
    request.data = {}
  }

  return await axiosInstance(request)
}

export const getCSRFToken = () => {
  return document.getElementsByName('csrf-token')[0].getAttribute('content')
}
