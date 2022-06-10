import { Currency, ETHER, Token } from 'framework/sdk'
import { SYMBOL } from 'env-config'

export function currencyId(currency: Currency): string {
  if (currency === ETHER) return SYMBOL
  if (currency instanceof Token) return currency.address
  throw new Error('invalid currency')
}

export default currencyId
