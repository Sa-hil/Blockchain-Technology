//  SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.5.0< 0.9.0;
contract crowdfunding{
    mapping(address=>uint) public contributors;
    address public manager;
    uint public minimumContribution;
    uint public deadline;
    uint public target;
    uint public raisedAmount;
    uint public noOfContributors;

    struct request{
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address=>bool) voters;
    }

    mapping(uint=>request) public requests;
    uint public numRequests;

    constructor (uint _target, uint _deadline){
        target=_target;
        deadline = block.timestamp+_deadline;
        minimumContribution = 100 wei;
        manager=msg.sender;
    }

    function  sendEth() public payable{
        require(block.timestamp< deadline, "Deadline has passed");
        require(msg.value >= minimumContribution, "Minimumm contribution has not met");

        if(contributors[msg.sender]==0){
            noOfContributors++;
        }

        contributors[msg.sender]+=msg.value;
        raisedAmount+= msg.value;
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }
    function refund() public{
        require(block.timestamp>deadline && raisedAmount<target, "you are not");
        require(contributors[msg.sender]>0);
        address payable user = payable(msg.sender);
        user.transfer(contributors[msg.sender]);
        contributors[msg.sender]=0;
    }

    modifier onlyManager(){
        require(msg.sender==manager,"only manager can access");
        _;
    }
    function createRequests(string memory _description, address payable _recipient, uint _value) public onlyManager{
        request storage newRequest = requests[numRequests];
        numRequests++;
        newRequest.description = _description;
        newRequest.recipient= _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters= 0;
    }
    function voteRequest(uint _requestno) public{
        require(contributors[msg.sender]>0,"you must be contributor");
        request storage thisRequest = requests[_requestno];
        require(thisRequest.voters[msg.sender]==false,"you have already voted");
        thisRequest.voters[msg.sender]=true;
        thisRequest.noOfVoters++;
    }

    function makePayment(uint _requestno) public onlyManager{
        require(raisedAmount>=target);
        request storage thisRequest= requests[_requestno];
        require(thisRequest.completed==false,"this request has been completed");
        require(thisRequest.noOfVoters> noOfContributors/2,"majority does not support");
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed=true;
    }

}