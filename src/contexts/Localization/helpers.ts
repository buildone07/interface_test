import { ZHCN } from 'config/localization/languages'

const publicUrl = process.env.PUBLIC_URL

export const LS_KEY = 'swap_language'

export const fetchLocale = async (locale) => {
  const response = await fetch(`${publicUrl}/locales/${locale}.json`)
  const data = await response.json()
  return data
}

export const getLanguageCodeFromLS = () => {
  try {
    const codeFromStorage = localStorage.getItem(LS_KEY)

    return codeFromStorage || ZHCN.locale
  } catch {
    return ZHCN.locale
  }
}
