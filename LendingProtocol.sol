// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LendingProtocol {
    
    address payable public lender;
    uint public loanAmount;
    uint public interestRate;
    uint public repaymentDate;
    bool public loanClosed;
    
    constructor(uint _loanAmount, uint _interestRate, uint _repaymentDate) payable {
        lender = payable(msg.sender);
        loanAmount = _loanAmount;
        interestRate = _interestRate;
        repaymentDate = _repaymentDate;
        require(msg.value == loanAmount, "You must send the full loan amount.");
    }
    
    function repayLoan() public payable {
        require(msg.sender == lender, "Only the lender can repay the loan.");
        require(msg.value == loanAmount + calculateInterest(), "You must repay the full loan amount plus interest.");
        require(block.timestamp >= repaymentDate, "The loan has not yet come due.");
        loanClosed = true;
        (bool success,) = msg.sender.call{value: address(this).balance}("");
        require(success, "Failed to send Ether.");
    }
    
    function calculateInterest() public view returns(uint) {
        uint timeDiff = block.timestamp - repaymentDate;
        uint interest = loanAmount * interestRate * timeDiff / (100 * 365 days);
        return interest;
    }
    
    function withdrawFunds() public {
        require(msg.sender == lender, "Only the lender can withdraw funds.");
        require(loanClosed, "The loan has not yet been repaid.");
        (bool success,) = msg.sender.call{value: address(this).balance}("");
        require(success, "Failed to send Ether.");
    }
    
}
//trying to write a simple protocol 
//now I am working on P2P lending protocol
