import BigNumber from 'bignumber.js'
import { getCakeVaultContract } from 'utils/contractHelpers'

const fetchVaultUser = async (account: string) => {
  return {
    isLoading: true,
    userShares: null,
    lastDepositedTime: null,
    lastUserActionTime: null,
    cakeAtLastUserAction: null,
  }
}

export default fetchVaultUser
