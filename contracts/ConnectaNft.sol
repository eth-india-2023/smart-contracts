/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

interface IACCESSMASTER {
    /// @dev checks if the address {User} is Admin or not.
    function isAdmin(address user) external view returns (bool);

    /// @dev checks if the address {User} is Operator or not.
    function isOperator(address user) external view returns (bool);

    /// @dev checks if the address {User} is creator or not.
    function isCreator(address user) external view returns (bool);

    /**
     * @notice Retrieves the payout address defined by the admin.
     * @return The payout address for receiving funds.
     */
    function getPayoutAddress() external view  returns (address);

}

contract ConnectaNft is Context, ERC721Enumerable {
    
    uint256 public nftPrice;
    uint256 private Counter;
    uint8 public version = 1;

    address public accessMasterAddress;
    
    string public baseURI;


    IACCESSMASTER flowRoles;

    /// @dev mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    modifier onlyOperator() {
        require(
            flowRoles.isOperator(_msgSender()),
            "ConnectaNft: User is not authorized "
        );
        _;
    }


    event AssetIssued(
        uint256 indexed tokenID,
        address indexed creator,
        string metaDataURI
    );
    event AssetDestroyed(uint indexed tokenId, address ownerOrApproved);

    event FundTransferred(address sender,address reciepient , uint256 tokenId,uint256 amount);
    
    using Strings for uint256;

    constructor(
        string memory name,
        string memory symbol,
        string memory _intialURI,
        address flowContract
    ) ERC721(name, symbol) {
        baseURI = _intialURI;
        flowRoles = IACCESSMASTER(flowContract);
        accessMasterAddress = flowContract;
    }
    
    /// @dev only operator can assign issue for an user
    function delegateIssue(
        address creator,
        string memory metadataURI
    ) public onlyOperator returns (uint256) {
        Counter++;
        uint256 currentTokenID = Counter;
        _safeMint(creator, currentTokenID);
        _setTokenURI(currentTokenID, metadataURI);

        emit AssetIssued(currentTokenID, creator, metadataURI);
        return currentTokenID;
    }
   
    /**
     * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _setTokenURI(
        uint256 tokenId,
        string memory _tokenURI
    ) internal virtual {
        require(_exists(tokenId), "ConnectaNft: Non-Existent Asset");
        _tokenURIs[tokenId] = _tokenURI;
    }

    /** Getter Functions **/
    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ConnectaNft: Non-Existent Asset");
        if (bytes(_tokenURIs[tokenId]).length == 0) {
            string memory _tokenUri = _baseURI(); //ERC721
            return _tokenUri;
        } else {
            return _tokenURIs[tokenId];
        }
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    /// @dev only minting and burning can happen
    /// token transfer are restricted
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal virtual override(ERC721Enumerable) {
        require(
            from == address(0),
            "ConnectaNft : Asset cannot be transferred"
        );
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}