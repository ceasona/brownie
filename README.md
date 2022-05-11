# Brownie

- ## 安装

  ```
  pip install eth-brownie
  ```

  or

  ```
  git clone https://github.com/eth-brownie/brownie.git
  cd brownie
  python3 setup.py install
  ```

  Dependencies:

  1. python3.6+
  2. [ganache](https://github.com/trufflesuite/ganache)

- ## 运行

  1. #### 创建项目

     - 创建空项目：

       ```
       brownie init
       ```

     - 创建Template：

       ```
       brownie bake token
       ```

  2. #### 编译合约

     ```
     brownie compile
     ```

  3. #### 终端交互

     ```
     >>> accounts[0]
     <Account object '0x73449641e44C4186bE766B8AE6c70BA1781a6C7a'>
     
     >>> accounts[1].balance()
     100000000000000000000
     
     >>> accounts[0].transfer(accounts[1], "10 ether")
     
     Transaction sent: 0x99dc73419b79b2439db037b7ec357cfeeace26916be74167277fa864fe8466e6
       Gas price: 0.0 gwei   Gas limit: 6721975   Nonce: 8
       Transaction confirmed   Block: 9   Gas used: 21000 (0.31%)
     <Transaction '0x99dc73419b79b2439db037b7ec357cfeeace26916be74167277fa864fe8466e6'>
     
     >>> accounts[1].balance()
     110000000000000000000
     ```

     ```
     >>> Token
     []
     
     >>> Token.deploy
     <ContractConstructor 'Token.constructor(string _name, string _symbol, uint256 _decimals, uint256 _totalSupply)'>
     
     >>> t = Token.deploy("Test Token", "TST", 18, 1e21, {'from': accounts[1]})
     
     Transaction sent: 0x31a4eebc5934c4e619e8d9bf246b5a83286aece7f113552affbf5c7f04ced48a
       Gas price: 0.0 gwei   Gas limit: 6721975   Nonce: 0
       Token.constructor confirmed   Block: 10   Gas used: 512493 (7.62%)
       Token deployed at: 0xf1859Df5d96a82249f40B0F8B9dDb1D56C8AA6e6
     
     >>> t
     <Token Contract '0xf1859Df5d96a82249f40B0F8B9dDb1D56C8AA6e6'>
     
     >>> t.balanceOf(accounts[1])
     1000000000000000000000
     
     >>> t.transfer
     <ContractTx object 'transfer(address _to, uint256 _value)'>
     
     >>> t.transfer(accounts[2], 1e20, {'from': accounts[1]})
     
     Transaction sent: 0xbea121a59e2d813245dd0fb4dfa98506d84d4f0b79dccf587c22808d6a2f87e3
       Gas price: 0.0 gwei   Gas limit: 6721975   Nonce: 1
       Token.transfer confirmed   Block: 11   Gas used: 51882 (0.77%)
     
     <Transaction '0xbea121a59e2d813245dd0fb4dfa98506d84d4f0b79dccf587c22808d6a2f87e3'>
     
     
     >>> t.balanceOf(accounts[1])
     900000000000000000000
     
     >>> t.balanceOf(accounts[2])
     100000000000000000000
     ```

  4. 脚本部署（scripts）

     ```
     brownie run scripts\token.py
     ```

  5. 测试（tests）

     ```
     brownie test
     ```

     

- ## 问题汇总

  - PermissionError: [WinError 5] 拒绝访问。: 'token-mix-master' -> 'token'

    无法重命名，经排查该文件夹被typora相关进程占用

    [Windows 查看文件被哪个进程占用](https://blog.csdn.net/ALone_cat/article/details/118448109)

    解决办法：关闭typora

  - Ganache与brownie连接时的network id与端口

    network id 默认1337，端口默认8545

  - solc网络问题无法下载

    solc可执行文件存放位置

    ```
    C:\Users\ASUS\.solcx\solc-v0.8.10 
    ```

  - qw

  

- ## 参考资料：

  1. [brownie官方地址](https://github.com/eth-brownie/brownie)
  2. [Python智能合约开发框架Brownie简明教程](https://zhuanlan.zhihu.com/p/352593330)