-include .env

.PHONY: build test clean deploy

install: init

build:
	forge build

rebuild:
	clean build

init:
	nvm use 18
	git submodule update --init --recursive
	forge install
	npm install

deploy-lock-release-token-pool:
	forge script ./script/DeployLockReleaseTokenPool.s.sol --broadcast --slow --optimize --optimizer-runs 999999 --names --verify --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY} --chain ${CHAIN_ID} --etherscan-api-key ${ETHERSCAN_API_KEY}

deploy-burn-mint-token-pool:
	forge script ./script/DeployBurnMintTokenPool.s.sol --broadcast --slow --optimize --optimizer-runs 999999 --names --verify --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY} --chain ${CHAIN_ID} --etherscan-api-key ${ETHERSCAN_API_KEY}

deploy-custom-burn-mint-token-pool:
	forge script ./script/DeployCustomBurnMintTokenPool.s.sol --broadcast --slow --optimize --optimizer-runs 999999 --names --verify --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY} --chain ${CHAIN_ID} --etherscan-api-key ${ETHERSCAN_API_KEY}

claim-admin-role:
	forge script script/ClaimAdmin.s.sol --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY} --broadcast

accept-admin-role:
	forge script script/AcceptAdminRole.s.sol --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY} --broadcast

set-token-pool:
	forge script script/SetPool.s.sol --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY} --broadcast

configure-token-pool:
	forge script script/ApplyChainUpdates.s.sol --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY} --broadcast