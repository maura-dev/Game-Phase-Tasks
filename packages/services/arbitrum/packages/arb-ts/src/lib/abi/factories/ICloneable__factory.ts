/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer } from 'ethers'
import { Provider } from '@ethersproject/providers'

import type { ICloneable } from '../ICloneable'

export class ICloneable__factory {
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): ICloneable {
    return new Contract(address, _abi, signerOrProvider) as ICloneable
  }
}

const _abi = [
  {
    inputs: [],
    name: 'isMaster',
    outputs: [
      {
        internalType: 'bool',
        name: '',
        type: 'bool',
      },
    ],
    stateMutability: 'view',
    type: 'function',
  },
]
