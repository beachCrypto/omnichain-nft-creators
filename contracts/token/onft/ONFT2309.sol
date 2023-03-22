// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ONFT721.sol";

/**
 * @dev ERC-2309: ERC-721 Consecutive Transfer Extension.
 *
 * _Available since v4.8._
 */
interface IERC2309 {
    /**
     * @dev Emitted when the tokens from `fromTokenId` to `toTokenId` are transferred from `fromAddress` to `toAddress`.
     */
    event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed fromAddress, address indexed toAddress);
}

contract ONFT2309 is ONFT721, IERC2309 {
    string public baseURI;
    uint256 public start; //  = 0;
    uint256 public end; // = 5500;
    // string public baseURI = "ipfs://QmZPSjZKMjDUcqGuy6xS2EDQsJVFLyGHj3LUM2DkmCEfHo/";

    constructor(
      string memory _name,
      string memory _symbol,
      uint256 _minGasToTransfer,
      address _lzEndpoint,
      string memory _deployedBaseURI,
      uint _startMintId,
      uint _endMintId) ONFT721(
        _name,
        _symbol,
        _minGasToTransfer,
        _lzEndpoint) {
          baseURI = _deployedBaseURI;
          start = _startMintId;
          end = _endMintId;

          uint256 _batchSize = end - start + 1;
          super._beforeTokenTransfer(address(0), owner(), 0, _batchSize);

          uint256 last = end;
          uint256 first = start;
          while (first < last) {
            if (last - first > 5000) {
              emit ConsecutiveTransfer(first, first + 4999, address(0), owner());
              first = first + 5000;
            } else {
              emit ConsecutiveTransfer(first, last, address(0), owner());
              first = first + 5000;
            }
          }
    }

    function _ownerOf(uint256 tokenId) internal view virtual override returns (address) {
      address _owner = super._ownerOf(tokenId);
      if (_owner == address(0) && ((start <= tokenId) && (tokenId <= end))) {
        return owner();
      }
      return _owner;
    }

    function _baseURI() internal view override returns (string memory) {
      return baseURI;
    }
}
