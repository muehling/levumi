export const ajax = async ({
  url,
  method = 'get',
  data,
  contentType = 'application/json',
  accept = 'application/json',
}) => {
  return await fetch(url, {
    headers: {
      'X-Requested-With': 'XMLHttpRequest',
      'X-CSRF-Token': getCSRFToken(),
      ...(contentType !== 'omit' && { 'Content-Type': contentType }),
      Accept: accept,
    },
    credentials: 'include',
    method: method,
    body: contentType === 'application/json' ? JSON.stringify(data) : data,
  })
}

export const getCSRFToken = () => {
  return document.getElementsByName('csrf-token')[0].getAttribute('content')
}
