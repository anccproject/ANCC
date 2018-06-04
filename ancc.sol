pragma solidity ^0.4.18;

// File: zeppelin-solidity/contracts/ownership/Ownable.sol

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

// File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

// File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol

contract DetailedERC20 is ERC20 {
  string public name;
  string public symbol;
  uint8 public decimals;

  function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
  }
}

// File: zeppelin-solidity/contracts/math/SafeMath.sol

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

// File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  uint256 totalSupply_;

  /**
  * @dev total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

}

// File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

// File: contracts/AdvanceToken.sol

/**
 * @title Advance ERC20 token
 *
 * @dev 增加多重签名的免手续费转账
 * @dev Based on StandardToken
 */
contract AdvanceToken is Ownable, DetailedERC20, StandardToken {

  // The nonce for avoid transfer replay attacks
  mapping(address => uint32) nonces;

  // init
  function AdvanceToken(
    uint256 initialSupply,
    string tokenName,
    string tokenSymbol,
    uint8 decimals
  ) DetailedERC20(tokenName, tokenSymbol, decimals) public
  {
    totalSupply_ = initialSupply;
    // 创建者获得所有代币
    balances[msg.sender] = initialSupply;
  }

  // 第三方付手续费转账 gas消耗:83143
  function transferProxy(
    address _from,
    address _to,
    uint256 _value,
    uint256 _fee,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) public returns (bool)
  {
    // basic
    require(_to != address(0));
//    require(_value <= balances[_from]);
//    require(_fee <= balances[_from]);
//    require(_value + _fee <= balances[_from]);

    // 签名内容
    uint32 _nonce = nonces[_from];
    bytes32 hashSign = keccak256(
      _from, _to, _value, _fee, _nonce
    );

    // 验证签名
    require(
      ecrecover(
        hashSign, v, r, s
      ) == _from);
    // nonces自增
    nonces[_from] = _nonce + 1;

    // 转账
    if (_fee > 0) {
      balances[_from] = balances[_from].sub(_value).sub(_fee);
      balances[msg.sender] = balances[msg.sender].add(_fee);
    } else {
      balances[_from] = balances[_from].sub(_value);
    }
    balances[_to] = balances[_to].add(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  // 读nonces
  function noncesOf(address _addr) public view returns (uint32) {
    return nonces[_addr];
  }

}

// File: contracts/Ancc.sol

/**
 * @title Ancc 防伪验证
 *
 * @dev 验证码数据格式
 */
contract Ancc {

  // 验证码
  struct Verification {
    // 摘要信息
    uint blockChain;            // 录入所在区块
    uint blockVerify;           // 验证所在区块
    address addressInput;       // 录入者
    address addressVerify;      // 验证者
    // 业务信息:基础信息
    bytes32 key;                // 密码, 激活用
    uint256 value;              // >0:验证码的代币价值
    bool isFill;                // false:产品信息未完善，可以修改 true:产品信息已完善，不能修改
    bool isPay;                 // true:码上价值已兑现
    // 业务信息:产品信息
    bytes32 business;           // 商家名称
    uint timeCreate;            // 生产日期
    bytes32 name;               // 产品名称
    bytes32 series;             // 产品系列
    bytes32 batch;              // 产品批次
    bytes32 desc;               // 产品描述
  }

  // 商家
  struct Business {
    // 摘要信息
    bytes32 symbol;             // 商家代号
    // 业务信息
    bytes32 name;               // 产品名称
    bytes32 desc;               // 商家简介
    address ceo;                // 商家地址
    address token;              // 商家币合约地址
  }

  // 代币合约
  AdvanceToken public tokenAdv;

  // CEO 执行，即所有者
  address public ceoAddress;
  modifier onlyCEO() {
    require(msg.sender == ceoAddress);
    _;
  }

  // CFO 财务，可以为二维码价值背书的人
  address public cfoAddress;
  modifier onlyCFO() {
    require(msg.sender == cfoAddress);
    _;
  }

  // COO 运营，可以录入二维码的人
  address public cooAddress;
  modifier onlyCOO() {
    require(msg.sender == cooAddress);
    _;
  }

  modifier onlyCLevel() {
    require(
      msg.sender == cooAddress || msg.sender == ceoAddress || msg.sender == cfoAddress
    );
    _;
  }

  // 文字翻译
  mapping(bytes32 => string) public translate;

  // 验证码
  mapping(bytes32 => Verification) public mapVerify;

  // 商家
  mapping(bytes32 => Business) public mapBusiness;

  // 验证码总数
  uint32 public totalInput;

  // 激活总数
  uint32 public totalActive;

  // 兑现总数
  uint32 public totalPay;

  // 总价值
  uint256 public totalValue;

  // 总兑现价值
  uint256 public totalPayValue;

  // init Functions should be in order: constructor, fallback, external, public, internal, private
  function Ancc(
    address tokenContract
  ) public
  {
    // 记录已存在的token合约实例
    tokenAdv = AdvanceToken(tokenContract);

    // CEO, CFO, COO
    ceoAddress = msg.sender;
    cfoAddress = msg.sender;
    cooAddress = msg.sender;
  }

  // 不接受直接转账
  function() external payable {
    revert();
  }

  // 修改代币合约地址
  function setTokenContract(address tokenContract) external onlyCEO {
    tokenAdv = AdvanceToken(tokenContract);
  }

  // 设置CEO
  function setCEO(address _newCEO) external onlyCEO {
    require(_newCEO != address(0));
    ceoAddress = _newCEO;
  }

  // 设置CFO
  function setCFO(address _newCFO) external onlyCEO {
    require(_newCFO != address(0));
    cfoAddress = _newCFO;
  }

  // 设置COO
  function setCOO(address _newCOO) external onlyCEO {
    require(_newCOO != address(0));
    cooAddress = _newCOO;
  }

  // 设置翻译
  function translateSet(string text) public returns (bytes32) {
    var textBytes = bytes(text);
    if (textBytes.length == 0) {
      // 空
      return 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
    }
    // 限制最大文本
    assert(textBytes.length < 1024);

    bytes32 hash = keccak256(text);
    if (bytes(translate[hash]).length == 0) {
      translate[hash] = text;
    }
    return hash;
  }

  // 添加/修改 商家
  function upsertBusiness(
    string symbol,
    string name,
    string desc,
    address ceo,
    address token
  ) public onlyCEO returns (bytes32)
  {
    bytes32 hash = translateSet(symbol);

    Business memory n;
    n.symbol = hash;
    n.name = translateSet(name);
    n.desc = translateSet(desc);
    n.ceo = ceo;
    n.token = token;
    mapBusiness[hash] = n;
    return hash;
  }

  // 添加验证码
  function addVerify(
    string uuid,         // 验证码唯一key
    string key,          // 激活密码, 无需则填空
    uint timeCreate,     // 生产日期
    string name,         // 产品名称
    string series,       // 产品系列
    string batch,        // 产品批次
    string desc,         // 产品描述
    string business,     // option: 商家名称
    uint value           // option: 验证码的代币价值
  ) public onlyCLevel returns (bytes32)
  {
    bytes32 hash = keccak256(uuid);
    // 要求未存在
    require(mapVerify[hash].blockChain == 0);

    // 统计
    if (value > 0) {
      totalValue += value;
    }

    Verification memory n;
    n.blockChain = block.number;
    n.blockVerify = 0;
    n.addressVerify = 0x0;
    n.value = value;
    n.addressInput = msg.sender;

    n.timeCreate = timeCreate;
    n.name = translateSet(name);
    n.series = translateSet(series);
    n.batch = translateSet(batch);
    n.desc = translateSet(desc);
    n.business = translateSet(business);
    n.key = keccak256(key);
    n.isFill = true;
    n.isPay = false;
    mapVerify[hash] = n;
    totalInput += 1;
    return (hash);
  }

  // 激活验证码
  function activeVerify(
    address active,
    string uuid,
    string key
  ) public returns (bytes32)
  {
    //
    require(active != 0x0);
    bytes32 hash = keccak256(uuid);
    Verification storage n = mapVerify[hash];
    // 要求已存在且未激活
    require(n.blockChain > 0 && n.addressVerify == 0x0 && n.isFill == true);
    // 要求密码匹配
    require(keccak256(key) == n.key);

    // 激活
    n.addressVerify = active;
    n.blockVerify = block.number;

    // 统计
    totalActive += 1;
    if (n.value == 0) {
      totalPay += 1;
    }
    return hash;
  }

  // 自己激活验证码
  function activeVerifySelf(string uuid, string key) public returns (bytes32) {
    return activeVerify(msg.sender, uuid, key);
  }

  // 第三方付手续费转账 gas消耗:70726
  function transferProxy(
    address _from,
    address _to,
    uint256 _value,
    uint256 _fee,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) public returns (bool)
  {
    return tokenAdv.transferProxy(
      _from, _to, _value, _fee, v, r, s
    );
  }

  // 第三方为激活码买单
  function payVerify(
    string uuid,
    address _from,
    address _to,
    uint256 _value,
    uint256 _fee,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) public returns (bool)
  {
    // 先转账
    tokenAdv.transferProxy(
      _from, _to, _value, _fee, v, r, s
    );

    // 买单
    bytes32 hash = keccak256(uuid);
    Verification storage n = mapVerify[hash];
    // 要求已激活且有价值且未兑现且价值匹配
    require(n.addressVerify == _to && n.value > 0 && n.isPay == false && n.value == _value);

    // 已兑现
    n.isPay = true;

    // 统计
    totalPay += 1;
    totalPayValue += _value;

    emit Payment(_from, _to, hash);
    return true;
  }

  // CFO标记已兑现. isValue:true 已足额兑现
  function payVerifyMark(string uuid, bool isValue) public onlyCFO returns (bool) {
    bytes32 hash = keccak256(uuid);
    Verification storage n = mapVerify[hash];
    // 要求已激活且有价值
    require(n.addressVerify != 0x0 && n.value > 0 && n.isPay == false);

    // 标记
    n.isPay = true;
    // 统计
    totalPay += 1;
    if (isValue == true) {
      totalPayValue += n.value;
    }

    emit Payment(msg.sender, n.addressVerify, hash);
    return true;
  }

  // 兑换事件
  event Payment(address indexed operator, address indexed active, bytes32 hash);
}
