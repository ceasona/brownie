#!/usr/bin/python3

from brownie import Wufeng, accounts


def main():
    return Wufeng.deploy({'from': accounts[1]})
