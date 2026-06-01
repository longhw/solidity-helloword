// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

contract MyToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    bool public paused;

    // 状态变量
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // 所有者
    address public owner;

    // 事件
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    // 修饰符
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    modifier notPaused() {
        require(!paused, "contract is paused");
        _;
    }

    // 构造函数
    constructor (string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * 10**_decimals;
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    // 转账函数
    function transfer(address _to, uint256 amount) public notPaused returns (bool success) {
        // 检查零地址
        require(_to != address(0), "can not transfer to zero address");
        // 检查余额是否充足
        require(balanceOf[msg.sender] >= amount, "balance not enough");

        // 先更新状态
        balanceOf[msg.sender] -= amount;
        balanceOf[_to] += amount;

        // 记录事件
        emit Transfer(msg.sender, _to, amount);

        // 返回成功
        return true;
    }

    // 批量转账
    function batchTransfer(address[] memory toAddresses, uint[] memory amounts) public notPaused returns (bool success) {
        require(toAddresses.length == amounts.length, "length mismatch");
        // 限制批量大小
        require(toAddresses.length <= 50, "more than batch size");

        // 检查余额是否充足
        uint totalAmount;
        for (uint i = 0; i < amounts.length; i++) {
            totalAmount += amounts[i];
        }
        require(balanceOf[msg.sender] >= totalAmount, "balance not enough");

        // 执行转账
        for (uint i = 0; i < toAddresses.length; i++) {
            balanceOf[msg.sender] -= amounts[i];
            balanceOf[toAddresses[i]] += amounts[i];
            emit Transfer(msg.sender, toAddresses[i], amounts[i]);
        }

        // 返回成功
        return true;
    }

    // 授权函数
    function approve(address spender, uint256 amount) public notPaused returns (bool success) {
        // 检查零地址
        require(spender != address(0), "can not approve to a zero adddress");

        // 设置授权额度
        allowance[msg.sender][spender] = amount;

        // 记录事件
        emit Approval(msg.sender, spender, amount);

        // 返回成功
        return true;
    }

    // 授权转账函数
    function transferFrom(address from, address to, uint amount) public notPaused returns (bool success) {
        // 检查地址有效性
        require(from != address(0), "from can not be a zero address");
        require(to != address(0), "to can not be a zero address");

        // 检查余额是否充足
        require(balanceOf[from] >= amount, "transfer amount is greater than from balance");
        
        // 检查授权额度是否充足
        require(allowance[from][msg.sender] >= amount, "transfer amount is greater than allowance");

        // 更新余额
        balanceOf[from] -= amount;
        balanceOf[to] += amount;

        // 扣除授权额度
        allowance[from][msg.sender] -= amount;

        // 记录事件
        emit Transfer(from, to, amount);

        // 返回成功
        return true;
    }

    // 暂停转账
    function transferPaused() public onlyOwner {
        paused = true;
    }

    // 恢复转账
    function transferRecover() public onlyOwner {
        paused = false;
    }

    // 铸币
    function mint(address to, uint amount) public onlyOwner {
        // 参数有效性检查
        require(to != address(0), "to can not be a zero address");
        require(amount > 0, "amount must be greater than zero");

        // 增加总供应量
        totalSupply += amount;

        // 增加接受者余额
        balanceOf[to] += amount;

        // 记录事件(from为零地址，因为币是新创造的)
        emit Transfer(address(0), to, amount);
    }

    // 销毁代码
    function burn(uint amount) public {
        // 检查余额是否充足
        require(balanceOf[msg.sender] >= amount, "balance is not enough");

        // 减少总供应量
        totalSupply -= amount;

        // 减少调用者余额
        balanceOf[msg.sender] -= amount;

        // 记录事件
        emit Transfer(msg.sender, address(0), amount);
    }
    
}