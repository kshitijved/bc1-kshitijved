pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import "@openzeppelin/contracts/utils/Counters.sol";
import '@openzeppelin/contracts/access/Ownable.sol';

contract OpenNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter public tokenId;

    string private baseUri;

    event NFTInitialised(uint _time, address _caller);

    event NftTokenCreated(address creator, uint tokenId, string tokenUri);
    
    mapping(uint => string) private tokenURIs;

    mapping(address => uint[]) private user_to_tokens;  //new

    mapping(string => uint8) private hash_to_isExiting;
    mapping(uint => address) private token_to_creator;
    mapping(uint => string) private token_to_caption;

    constructor (
        string memory _token_name,
        string memory _token_symbol
    ) 
    public 
    ERC721(token_name, token_symbol)
    {
        setBaseUrl('https://ipfs.infura.io/ipfs/');
        emit NFTInitialised(block.timestamp, msg.sender);
    }

    function createNFT(
        address _creator,
        string memory _token_name,
        string memory _token_symbol
    ) 
        public returns(uint _reward) {
        require(hash_to_isExiting[_tokenURI]!=1, "NFT already created");
        tokenId.increment();

        uint newTokenId = tokenId.current();

        tokenURIs[newTokenId] = _tokenURI;
        user_to_tokens[_creator].push(newTokenId);
        hash_to_isExiting[_tokenURI] = 1;
        token_to_creator[newTokenId] = _creator;
        token_to_name[newTokenId] = _token_name;
        token_to_symbol[newTokenId] = _token_symbol;
        token_to_course_name[newTokenId] = _token_course_name;
        token_to_issuing_date[newTokenId] = _token_issuing_date;
        token_to_receivers_name[newTokenId] = _token_receivers_name;
        token_to_certificate_type[newTokenId] = _token_certificate_type;

        _mint(_creator, newTokenId);
        
        return 1;
    }

    function register(string memory _name) public {
        
        require(users[msg.sender].adrs == address(0), "Token already exists");
        User memory user = User(_name, msg.value, msg.sender, 1);
        users[msg.sender] = user;
        
    }
    function getCreator(address _creator) public 
                                view returns(uint[] memory _tokens) {
        return user_to_tokens[_creator];
    }
    function getCourseName(string memory _token_course_name) public 
                                view returns(string memory token_course_name) {
        return token_course_name[_token_course_name];
    }

    function getIssuingDate(string memory _token_issuing_date) public 
                                view returns(string memory token_to_issuing_date){
        return token_to_issuing_date[_token_issuing_date];
    }

    function getReceiversName(string memory _token_receivers_name) public
                                view returns(string memory token_to_receivers_name){
        return token_to_receivers_name[_token_receivers_name];
    }
     function getCertificateType(string memory _token_certificate_type) public
                                view returns(string memory token_to_certificate_type){
        return token_to_certificate_type[_token_certificate_type];
    }
    
    fallback () external {
        revert();
    }
   
}