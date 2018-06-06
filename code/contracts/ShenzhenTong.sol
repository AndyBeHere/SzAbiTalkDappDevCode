pragma solidity ^0.4.23;

contract ShenzhenTong {
	uint public feePerStation; // 每站费用

	// 每个卡的账户余额
	mapping (address => uint) public card_balances;

	string[] public stations;

	// 每个人的开始地铁站 (如果不在深圳通=零下一)
	mapping (address => int) public start_station;

	constructor(uint costPerStation) public {
		feePerStation = costPerStation;
		stations.push("罗湖");
		stations.push("世界之窗");
		stations.push("机场东");
	}

	function getNumberOfStations() public constant returns (uint) {
        return stations.length;
    }

	// 检查卡的余额
	function getBalance() public returns (uint balance) {
		return uint(card_balances[msg.sender]);
	}

	// 加钱
	function addMoney() payable public {
		card_balances[msg.sender] += msg.value;
	}

	// 扫卡入
	function swipeIn(string station) public returns (int a) {
		int startStationId = getStationId(station);
		require(startStationId >= 0);
		start_station[msg.sender] = startStationId;
		return startStationId;
	}

	// 扫卡出
	function swipeOut(string station) public {
		int startStationId = start_station[msg.sender];
		int endStationId = getStationId(station);
		require(startStationId >= 0 && endStationId >= 0);

		int distance = endStationId - startStationId;
		if (distance < 0) {
			distance = distance * -1;
		}

		// 成本
		uint cost = uint(distance) * feePerStation;
		require(int(card_balances[msg.sender]) - int(cost) >= 0);
		card_balances[msg.sender] -= cost; // 行，可以从余额中减成本
	}

	// StationId 是地铁站ID = 名字在array + 1
	// 无效的地铁名 = 0
	function getStationId(string stationName) returns (int stationId) {
		for (uint i = 0; i < stations.length; i++) {
			if (keccak256(stations[i]) == keccak256(stationName)) {
				return int(i);
			}
		}

		return -1;
	}
}