//
// Created by Dan Capecci CTR on 11/5/22.
//

import Foundation


public enum Web3ABI {
    case estimateGasTestABI
    case coldWalletABI
    case st20ABI
    case erc888ABI
    case erc1376ABI
    case erc20ABI
    case erc721ABI
    case erc721xABI
    case erc1155ABI
    case erc777ABI
    case erc1633ABI
    case ensRegistryABI
    case erc1400ABI
    case erc1410ABI
    case erc1594ABI
    case erc1644ABI
    case erc1643ABI
    case deedABI
    case registrarABI
    case ethRegistrarControllerABI
    case baseRegistrarABI
    case reverseRegistrarABI
    case legacyResolverABI
    case resolverABI


    var name: String {
        switch self {
        case .estimateGasTestABI:
            return "Estimate Gas ABI"
        case .coldWalletABI:
            return "Cold Wallet"
        case .st20ABI:
            return "ST20"
        case .erc888ABI:
            return "ERC888"
        case .erc1376ABI:
            return "ERC1376"
        case .erc20ABI:
            return "ERC20"
        case .erc721ABI:
            return "ERC721"
        case .erc721xABI:
            return "ERC721X"
        case .erc1155ABI:
            return "ERC1155"
        case .erc777ABI:
            return "ERC777"
        case .erc1633ABI:
            return "ERC1633"
        case .ensRegistryABI:
            return "ENS REGISTRY"
        case .erc1400ABI:
            return "ERC1400"
        case .erc1410ABI:
            return "ERC1410"
        case .erc1594ABI:
            return "ERC1594"
        case .erc1644ABI:
            return "ERC1644"
        case .erc1643ABI:
            return "ERC1643"
        case .deedABI:
            return "DEED"
        case .registrarABI:
            return "REGISTRAR"
        case .ethRegistrarControllerABI:
            return "ETH REGISTRAR CONTROLLER"
        case .baseRegistrarABI:
            return "BASE REGISTRAR"
        case .reverseRegistrarABI:
            return "REVERSE REGISTRAR"
        case .legacyResolverABI:
            return "LEGACY RESOLVER"
        case .resolverABI:
            return "RESOLVER"
        }
    }

    var abiString: String {
        switch self {
        case .estimateGasTestABI:
            return Web3Utils.estimateGasTestABI
        case .coldWalletABI:
            return Web3Utils.coldWalletABI
        case .st20ABI:
            return Web3Utils.st20ABI
        case .erc888ABI:
            return Web3Utils.erc888ABI
        case .erc1376ABI:
            return Web3Utils.erc1376ABI
        case .erc20ABI:
            return Web3Utils.erc20ABI
        case .erc721ABI:
            return Web3Utils.erc721ABI
        case .erc721xABI:
            return Web3Utils.erc721xABI
        case .erc1155ABI:
            return Web3Utils.erc1155ABI
        case .erc777ABI:
            return Web3Utils.erc777ABI
        case .erc1633ABI:
            return Web3Utils.erc1633ABI
        case .ensRegistryABI:
            return Web3Utils.ensRegistryABI
        case .erc1400ABI:
            return Web3Utils.erc1400ABI
        case .erc1410ABI:
            return Web3Utils.erc1410ABI
        case .erc1594ABI:
            return Web3Utils.erc1594ABI
        case .erc1644ABI:
            return Web3Utils.erc1644ABI
        case .erc1643ABI:
            return Web3Utils.erc1643ABI
        case .deedABI:
            return Web3Utils.deedABI
        case .registrarABI:
            return Web3Utils.registrarABI
        case .ethRegistrarControllerABI:
            return Web3Utils.ethRegistrarControllerABI
        case .baseRegistrarABI:
            return Web3Utils.baseRegistrarABI
        case .reverseRegistrarABI:
            return Web3Utils.reverseRegistrarABI
        case .legacyResolverABI:
            return Web3Utils.legacyResolverABI
        case .resolverABI:
            return Web3Utils.resolverABI
        }


    }

}