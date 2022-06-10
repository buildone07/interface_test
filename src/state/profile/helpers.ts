import Cookies from 'js-cookie'
import { Profile } from 'state/types'
import { GetUserProfileResponse } from 'utils/types'
import { getProfileContract } from 'utils/contractHelpers'
import { Nft } from 'config/constants/nfts/types'
import { getNftByTokenId } from 'utils/collectibles'
import { getTeam } from 'state/teams/helpers'

export interface GetProfileResponse {
  hasRegistered: boolean
  profile?: Profile
}

const transformProfileResponse = (profileResponse: GetUserProfileResponse): Partial<Profile> => {
  const { 0: userId, 1: numberPoints, 2: teamId, 3: nftAddress, 4: tokenId, 5: isActive } = profileResponse

  return {
    userId: userId.toNumber(),
    points: numberPoints.toNumber(),
    teamId: teamId.toNumber(),
    tokenId: tokenId.toNumber(),
    nftAddress,
    isActive,
  }
}

const profileApi = process.env.REACT_APP_API_PROFILE

export const getUsername = async (address: string): Promise<string> => {
  try {
    const response = await fetch(`${profileApi}/api/users/${address.toLowerCase()}`)

    if (!response.ok) {
      return ''
    }

    const { username = '' } = await response.json()

    return username
  } catch (error) {
    return ''
  }
}

/**
 * Intended to be used for getting a profile avatar
 */
export const getProfileAvatar = async (address: string) => {
  return null
}

export const getProfile = async (address: string): Promise<GetProfileResponse> => {
  return null
}
