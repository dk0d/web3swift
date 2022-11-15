//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import BigInt
import Core
import Foundation

// Token Standard
protocol IERC20: ContractApproval, ContractTransfer, ContractBalance, ContractSupply, ContractAllowance {}

// This namespace contains functions to work with ERC20 tokens.

// variables are lazyly evaluated or global token information (name, ticker, total supply)
// can be imperatively read and saved
// FIXME: Rewrite this to CodableTransaction
public class ERC20: IERC20 {

    public var address: EthereumAddress
    public var properties: [ContractReadProperties] = [
        .name(nil),
        .symbol(nil),
        .decimals(nil)
    ]
    public var abi: Web3ABI { .erc20ABI }
    public var hasReadProperties: Bool = false

    public init(address: EthereumAddress, transaction: CodableTransaction = .emptyTransaction) {
        self.address = address
        self.transaction = transaction
    }
}




