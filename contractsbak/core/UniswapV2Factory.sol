pragma solidity =0.5.16;

import './interfaces/IUniswapV2Factory.sol';
import './UniswapV2Pair.sol';

contract UniswapV2Factory is IUniswapV2Factory {
    address public feeTo;
    address public feeToSetter;

    mapping(address => bool) public valuedToken;
    bool public closeValuedToken;
    address public controller;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    bytes32 public constant INIT_CODE_PAIR_HASH = keccak256(abi.encodePacked(type(UniswapV2Pair).creationCode));

    event PairCreated(address indexed token0, address indexed token1, address pair, uint256);

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
        controller = msg.sender;
    }

    function allPairsLength() external view returns (uint256) {
        return allPairs.length;
    }

    function manageValuedToken(address token, bool isExist) public {
        require(msg.sender == controller, 'UniswapV2: ONLY CONTROLLER IS AVAIABLE');
        if (isExist) {
            valuedToken[token] = true;
        } else {
            delete valuedToken[token];
        }
    }

    function updateCloseValuedToken(bool close) public {
        require(msg.sender == controller, 'UniswapV2: ONLY CONTROLLER IS AVAIABLE');
        closeValuedToken = close;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        if (!closeValuedToken) {
            require(valuedToken[tokenA] || valuedToken[tokenB], 'UniswapV2: ONE TOKEN MUST BE VALUED TOKEN');
        }
        require(tokenA != tokenB, 'UniswapV2: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'UniswapV2: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'UniswapV2: PAIR_EXISTS'); // single check is sufficient
        if (!valuedToken[token0]) {
            address _token = token0;
            token0 = token1;
            token1 = _token;
        }
        bytes memory bytecode = type(UniswapV2Pair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IUniswapV2Pair(pair).initialize(token0, token1, controller);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN');
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'UniswapV2: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }
}
