// SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 < 0.9.0;

contract erc20{

    uint256 totalSupply;
    string  tokenName;
    string  tokenSymbol;
    uint decimal;
    mapping(address => uint256)balanceOf;

    constructor(uint256 _totalSupply, string memory _tokenName, string memory _tokenSymbol, uint _decimal) {
        totalSupply = _totalSupply;
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        decimal = _decimal;
        balanceOf[msg.sender]=_totalSupply;
    }

    function TotalSupply() public view returns(uint256){
        return totalSupply;
    }

    function TokenName() public view returns(string memory){
        return tokenName;
    }

    function TokenSymbol() public view returns(string memory){
        return tokenSymbol;
    }
    
    function TotalDecimal() public view returns(uint){
        return decimal;
    }

    function totalBalance(address _address) public view returns(uint256){
        return balanceOf[_address];
    }

}